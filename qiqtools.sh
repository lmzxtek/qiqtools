#!/bin/bash

#========================================================
#   System Required: CentOS 7+ / Debian 8+ / Ubuntu 16+ / Alpine 3+ /
#   Description: QiQ一键安装脚本
#   Gitlab: https://gitlab.com/lmzxtek/qiqtools
#   
#   一键安装命令如下：
#   $> curl -sS -O https://sub.lmzxtek.top/qiqtools.sh && chmod +x qiqtools.sh && ./qiqtools.sh
#   $> curl -sS -O https://gitlab.com/lmzxtek/qiqtools/-/raw/main/qiqtools.sh && chmod +x qiqtools.sh && ./qiqtools.sh
#========================================================

# 设置脚本的快捷命令为 `qiq`
ln -sf ~/qiqtools.sh /usr/local/bin/qiq

 black='\033[0;30m'
   red='\033[0;31m'
 green='\033[0;32m'
yellow='\033[0;33m'
 blue2='\033[0;34m'
  pink='\033[0;35m'
  cyan='\033[0;36m'
 white='\033[0;37m'
  blue='\033[96m'
  bold='\033[01m'
 plain='\033[0m'

# 自定义字体彩色，read 函数
warning() { echo -e "${red}$*${plain}"; }                  # 红色
error()   { echo -e "${red}${bold}$*${plain}" && exit 1; } # 红色粗体
info()    { echo -e "${green}${bold}$*${plain}"; }         # 绿色粗体
hint()    { echo -e "${yellow}${bold}$*${plain}"; }        # 黄色粗体

reading() { read -rp "$(info "$1")" "$2"; }
text() { grep -q '\$' <<< "${E[$*]}" && eval echo "\$(eval echo "\${${L}[$*]}")" || eval echo "\${${L}[$*]}"; }

break_end() {
      echo -e "${green} 操作完成 ${plain}\n 按任意键继续..."
      read -n 1 -s -r -p ""
      echo ""
      clear
}

# run qiq and exit 
qiqtools() {
    qiq
    exit
}

# 安装应用程序
install() {
    if [ $# -eq 0 ]; then
        echo "未提供软件包参数!"
        return 1
    fi

    for package in "$@"; do
        if ! command -v "$package" &>/dev/null; then
            if command -v apt &>/dev/null; then
                apt update -y && apt install -y "$package"
            elif command -v yum &>/dev/null; then
                yum -y update && yum -y install "$package"
            elif command -v apk &>/dev/null; then
                apk update && apk add "$package"
            else
                echo "未知的包管理器!"
                return 1
            fi
        fi
    done

    return 0
}

install_dependency() { 
  clear && install curl wget socat unzip tar 
}


remove() {
    if [ $# -eq 0 ]; then
        echo "未提供软件包参数!"
        return 1
    fi

    for package in "$@"; do
        if command -v apt &>/dev/null; then
            apt purge -y "$package"
        elif command -v yum &>/dev/null; then
            yum remove -y "$package"
        elif command -v apk &>/dev/null; then
            apk del "$package"
        else
            echo "未知的包管理器!"
            return 1
        fi
    done

    return 0
}


# export PATH=$PATH:/usr/local/bin

cur_dir=$(pwd)

ip_address() {
ipv4_address=$(curl -s ipv4.ip.sb)
ipv6_address=$(curl -s --max-time 1 ipv6.ip.sb)
}

check_root() {
    # check root
    [[ $EUID -ne 0 ]] && echo -e "${red}错误：${plain} 必须使用root用户运行此脚本！\n" && exit 1
}

check_os() {
    # check os
    if [[ -f /etc/redhat-release ]]; then
        release="centos"
    elif cat /etc/issue | grep -Eqi "debian"; then
        release="debian"
    elif cat /etc/issue | grep -Eqi "ubuntu"; then
        release="ubuntu"
    elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
        release="centos"
    elif cat /proc/version | grep -Eqi "debian"; then
        release="debian"
    elif cat /proc/version | grep -Eqi "ubuntu"; then
        release="ubuntu"
    elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
        release="centos"
    else
        echo -e "${red}未检测到系统版本，请联系脚本作者！${plain}\n" && exit 1
    fi
}

get_arch(){
    arch=$(arch)

    if [[ $arch == "x86_64" || $arch == "x64" || $arch == "amd64" ]]; then
        arch="64"
    elif [[ $arch == "aarch64" || $arch == "arm64" ]]; then
        arch="arm64-v8a"
    elif [[ $arch == "s390x" ]]; then
        arch="s390x"
    else
        arch="64"
        echo -e "${red}检测架构失败，使用默认架构: ${arch}${plain}"
    fi

    # echo "架构: ${arch}"

    # if [ "$(getconf WORD_BIT)" != '32' ] && [ "$(getconf LONG_BIT)" != '64' ] ; then
    #     echo "本软件不支持 32 位系统(x86)，请使用 64 位系统(x86_64)，如果检测有误，请联系作者"
    #     exit 2
    # fi
}

get_os_version() {
    os_version=""

    # os version
    if [[ -f /etc/os-release ]]; then
        os_version=$(awk -F'[= ."]' '/VERSION_ID/{print $3}' /etc/os-release)
    fi
    if [[ -z "$os_version" && -f /etc/lsb-release ]]; then
        os_version=$(awk -F'[= ."]+' '/DISTRIB_RELEASE/{print $2}' /etc/lsb-release)
    fi

    if [[ x"${release}" == x"centos" ]]; then
        if [[ ${os_version} -le 6 ]]; then
            echo -e "${red}请使用 CentOS 7 或更高版本的系统！${plain}\n" && exit 1
        fi
    elif [[ x"${release}" == x"ubuntu" ]]; then
        if [[ ${os_version} -lt 16 ]]; then
            echo -e "${red}请使用 Ubuntu 16 或更高版本的系统！${plain}\n" && exit 1
        fi
    elif [[ x"${release}" == x"debian" ]]; then
        if [[ ${os_version} -lt 8 ]]; then
            echo -e "${red}请使用 Debian 8 或更高版本的系统！${plain}\n" && exit 1
        fi
    fi
}

# 获取系统信息
get_sysinfo(){
    # 函数: 获取IPv4和IPv6地址
    ip_address

    if [ "$(uname -m)" == "x86_64" ]; then
      cpu_info=$(cat /proc/cpuinfo | grep 'model name' | uniq | sed -e 's/model name[[:space:]]*: //')
    else
      cpu_info=$(lscpu | grep 'BIOS Model name' | awk -F': ' '{print $2}' | sed 's/^[ \t]*//')
    fi

    cpu_usage=$(top -bn1 | grep 'Cpu(s)' | awk '{print $2 + $4}')
    cpu_usage_percent=$(printf "%.2f" "$cpu_usage")%

    cpu_cores=$(nproc)

    mem_info=$(free -b | awk 'NR==2{printf "%.2f/%.2f MB (%.2f%%)", $3/1024/1024, $2/1024/1024, $3*100/$2}')

    disk_info=$(df -h | awk '$NF=="/"{printf "%s/%s (%s)", $3, $2, $5}')

    country=$(curl -s ipinfo.io/country)
    city=$(curl -s ipinfo.io/city)

    isp_info=$(curl -s ipinfo.io/org)

    cpu_arch=$(uname -m)

    hostname=$(hostname)

    kernel_version=$(uname -r)

    congestion_algorithm=$(sysctl -n net.ipv4.tcp_congestion_control)
    queue_algorithm=$(sysctl -n net.core.default_qdisc)

    # 尝试使用 lsb_release 获取系统信息
    os_info=$(lsb_release -ds 2>/dev/null)

    # 如果 lsb_release 命令失败，则尝试其他方法
    if [ -z "$os_info" ]; then
      # 检查常见的发行文件
      if [ -f "/etc/os-release" ]; then
        os_info=$(source /etc/os-release && echo "$PRETTY_NAME")
      elif [ -f "/etc/debian_version" ]; then
        os_info="Debian $(cat /etc/debian_version)"
      elif [ -f "/etc/redhat-release" ]; then
        os_info=$(cat /etc/redhat-release)
      else
        os_info="Unknown"
      fi
    fi

    output=$(awk 'BEGIN { rx_total = 0; tx_total = 0 }
        NR > 2 { rx_total += $2; tx_total += $10 }
        END {
            rx_units = "Bytes";
            tx_units = "Bytes";
            if (rx_total > 1024) { rx_total /= 1024; rx_units = "KB"; }
            if (rx_total > 1024) { rx_total /= 1024; rx_units = "MB"; }
            if (rx_total > 1024) { rx_total /= 1024; rx_units = "GB"; }

            if (tx_total > 1024) { tx_total /= 1024; tx_units = "KB"; }
            if (tx_total > 1024) { tx_total /= 1024; tx_units = "MB"; }
            if (tx_total > 1024) { tx_total /= 1024; tx_units = "GB"; }

            printf("总接收: %.2f %s\n总发送: %.2f %s\n", rx_total, rx_units, tx_total, tx_units);
        }' /proc/net/dev)


    current_time=$(date "+%Y-%m-%d %I:%M %p")


    swap_used=$(free -m | awk 'NR==3{print $3}')
    swap_total=$(free -m | awk 'NR==3{print $2}')

    if [ "$swap_total" -eq 0 ]; then
        swap_percentage=0
    else
        swap_percentage=$((swap_used * 100 / swap_total))
    fi

    swap_info="${swap_used}MB/${swap_total}MB (${swap_percentage}%)"

    runtime=$(cat /proc/uptime | awk -F. '{run_days=int($1 / 86400);run_hours=int(($1 % 86400) / 3600);run_minutes=int(($1 % 3600) / 60); if (run_days > 0) printf("%d天 ", run_days); if (run_hours > 0) printf("%d时 ", run_hours); printf("%d分\n", run_minutes)}')

}

# 显示系统信息
show_info() {
    echo -e "${plain}
系统信息查询
------------------------
   主机名: $hostname
   运营商: $isp_info
------------------------
 系统版本: $os_info
Linux版本: $kernel_version
------------------------
  CPU架构: $cpu_arch
  CPU型号: $cpu_info
CPU核心数: $cpu_cores
------------------------
  CPU占用: $cpu_usage_percent
 物理内存: $mem_info
 虚拟内存: $swap_info
 硬盘占用: $disk_info
------------------------
$output
------------------------
网络拥堵算法: $congestion_algorithm $queue_algorithm
------------------------
公网IPv4地址: $ipv4_address
公网IPv6地址: $ipv6_address
------------------------
    地理位置: $country $city
    系统时间: $current_time
------------------------
系统运行时长: $runtime
"
}

# 更新系统
update_and_upgrade() {
    
    # Update system on Debian-based systems
    if [ -f "/etc/debian_version" ]; then
        apt update -y && DEBIAN_FRONTEND=noninteractive apt full-upgrade -y
    fi

    # Update system on Red Hat-based systems
    if [ -f "/etc/redhat-release" ]; then
        yum -y update
    fi

    # Update system on Alpine Linux
    if [ -f "/etc/alpine-release" ]; then
        apk update && apk upgrade
    fi
}


clean_debian() {
    apt autoremove --purge -y
    apt clean -y
    apt autoclean -y
    apt remove --purge $(dpkg -l | awk '/^rc/ {print $2}') -y
    journalctl --rotate
    journalctl --vacuum-time=1s
    journalctl --vacuum-size=50M
    apt remove --purge $(dpkg -l | awk '/^ii linux-(image|headers)-[^ ]+/{print $2}' | grep -v $(uname -r | sed 's/-.*//') | xargs) -y
}

clean_redhat() {
    yum autoremove -y
    yum clean all
    journalctl --rotate
    journalctl --vacuum-time=1s
    journalctl --vacuum-size=50M
    yum remove $(rpm -q kernel | grep -v $(uname -r)) -y
}

clean_alpine() {
    apk del --purge $(apk info --installed | awk '{print $1}' | grep -v $(apk info --available | awk '{print $1}'))
    apk autoremove
    apk cache clean
    rm -rf /var/log/*
    rm -rf /var/cache/apk/*

}

# 清理系统
clean_sys() {
    # Main script
    if [ -f "/etc/debian_version" ]; then
        # Debian-based systems
        clean_debian
    elif [ -f "/etc/redhat-release" ]; then
        # Red Hat-based systems
        clean_redhat
    elif [ -f "/etc/alpine-release" ]; then
        # Alpine Linux
        clean_alpine
    fi
}


# 定义安装 Docker 的函数
install_docker() {
    if ! command -v docker &>/dev/null; then
        curl -fsSL https://get.docker.com | sh && ln -s /usr/libexec/docker/cli-plugins/docker-compose /usr/local/bin
        systemctl start docker
        systemctl enable docker
    else
        echo "Docker 已经安装"
    fi
}

# 设置docker-compose快捷命令，默认为dcc
set_docker_cmd(){
    chmod a+x /usr/local/bin/docker-compose && rm -rf `which dcc` && ln -s /usr/local/bin/docker-compose /usr/bin/dcc
}

# 显示主菜单
main_menu() {
echo -e "${blue}
 __   _  __   ___ ____ ____ _   __
|  |  | |  |   |  |  | |  | |  |__
|__|_ | |__|_  |  |__| |__| |__ __|
                        
QiQTools 一键脚本工具 v0.0.1
(支持Ubuntu/Debian/CentOS/Alpine系统)
-- 输入 ${yellow}qiq ${blue}可快速启动此脚本 --
-------------------------------
${green} 1.${plain} 系统信息查询
${green} 2.${plain} 系统更新
${green} 3.${plain} 系统清理
${green} 4.${plain} 常用工具 ▶
${green} 5.${plain} BBR管理 ▶
${green} 6.${plain} Docker管理 ▶
${green} 7.${plain} WARP管理 ▶ 解锁ChatGPT Netflix
${green} 8.${plain} 测试脚本合集 ▶
${green} 9.${plain} 甲骨文云脚本合集 ▶
${green}10.${blue} LDNMP建站 ▶${plain}
${green}11.${plain} 面板工具 ▶
${green}12.${plain} 我的工作区 ▶
${green}13.${plain} 系统工具 ▶
${green}14.${plain} VPS集群控制 ▶ ${blue}Beta${plain}
-------------------------------
${green}00.${plain} 脚本更新
-------------------------------
${green} 0.${plain} 退出脚本
-------------------------------
"
}


# 安装常用工具
common_apps_menu() {
echo -e "
▶ 安装常用工具
-------------------------------
${green} 1.${plain} curl   下载工具
${green} 2.${plain} wget   下载工具
${green} 3.${plain} sudo   超级管理权限工具
${green} 4.${plain} socat  通信连接工具 （申请域名证书必备）
${green} 5.${plain} htop   系统监控工具
${green} 6.${plain} iftop  网络流量监控工具
${green} 7.${plain} unzip  ZIP压缩解压工具
${green} 8.${plain} tar    GZ压缩解压工具
${green} 9.${plain} tmux   多路后台运行工具
${green}10.${plain} ffmpeg 视频编码直播推流工具
${green}11.${plain} btop   现代化监控工具
${green}12.${plain} ranger 文件管理工具
${green}13.${plain} gdu    磁盘占用查看工具
${green}14.${plain} fzf    全局搜索工具
-------------------------------
${green}31.${plain} 全部安装
${green}32.${plain} 全部卸载
-------------------------------
${green}41.${plain} 安装指定工具
${green}42.${plain} 卸载指定工具
-------------------------------
${green} 0.${plain} 返回主菜单
-------------------------------
"
}


common_apps_run() {
  while true; do 
    clear
    common_apps_menu
    read -p "请输入你的选择: " sub_choice

    case $sub_choice in
      1)
        clear && install curl
        clear && echo "工具已安装，使用方法如下：" && curl --help
        ;;
      0)
        qiqtools
        ;;
      *)
        echo "无效的输入!"
        ;;
    esac
    break_end
  done
}


# Main Loops for the scripts
while true; do 
  clear && main_menu

  # read -p "请输入你的选择: " choice
  reading "请输入你的选择: " choice
  # echo && read -ep "请输入选择: " choice

  case $choice in
    1)
      clear
      get_sysinfo
      show_info
      # break_end
      ;;
    2)
      clear
      update_and_upgrade
      # break_end
      ;;
    3)
      clear
      clean_sys
      # break_end
      ;;
    4)
      common_apps_run
      ;;
    00)
      cd ~
      # curl -sS -O https://raw.githubusercontent.com/kejilion/sh/main/update_log.sh && chmod +x update_log.sh && ./update_log.sh
      # rm update_log.sh
      echo ""
      curl -sS -O https://gitlab.com/lmzxtek/qiqtools/-/raw/main/qiqtools.sh && chmod +x kejilion.sh
      echo "脚本已更新到最新版本！"
      # break_end
      # qiqtools
      # exit 
      ;;

    0)
      # clear
      exit
      ;;

    *)
      echo "无效的输入!"
      ;;
  esac  
  break_end
done