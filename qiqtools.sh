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

#==== 脚本版本号 ===========
script_version=v0.3.0
#==========================

# Language
L=E
L=C

 black='\033[0;30m'
   red='\033[0;31m'
 green='\033[0;32m'
yellow='\033[0;33m'
  blue='\033[0;34m'
  pink='\033[0;35m'
  cyan='\033[0;36m'
 white='\033[0;37m'
 blue2='\033[96m'
  bold='\033[01m'
 plain='\033[0m'

# 自定义字体彩色，read 函数
warning() { echo -e "${red}$*${plain}"; }                  # 红色
error()   { echo -e "${red}${bold}$*${plain}" && exit 1; } # 红色粗体
info()    { echo -e "${green}${bold}$*${plain}"; }         # 绿色粗体
hint()    { echo -e "${yellow}${bold}$*${plain}"; }        # 黄色粗体

reading() { read -rp "$(info "$1")" "$2"; }
text() { grep -q '\$' <<< "${E[$*]}" && eval echo "\$(eval echo "\${${L}[$*]}")" || eval echo "\${${L}[$*]}"; }

qiqtools() { main_loop && exit; }
qiq_reload() { cd ~ && qiq && exit; }

break_end() {
      echo -e "${green} 操作完成 ${red}>> ${yellow} 按任意键继续${green}..."
      read -n 1 -s -r -p ""
      echo ""
      # clear
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

install_dependency() { clear && install curl wget socat unzip tar; }

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

ipv4_address=""
ipv6_address=""

# 获取当前服务器的IP地址
ip_address() {
  # if [ -z "$ipv4_address" ] && [ -z "$ipv6_address" ]; then
  #   # echo "s1 和 s2 均不为空"
  #   # ipv4_address=$(curl -s ipv4.ip.sb)
  #   # ipv6_address=$(curl -s --max-time 1 ipv6.ip.sb)
  #   check_system_ip
  # fi
  [ -z "$ipv4_address" ] && [ -z "$ipv6_address" ] && check_system_ip
}

ip_show(){
  info "\t IPv4: $WAN4 $WARPSTATUS4 $COUNTRY4  $ASNORG4 "
  info "\t IPv6: $WAN6 $WARPSTATUS6 $COUNTRY6  $ASNORG6 "
}


# 自定义谷歌翻译函数
translate() {
  [ -n "$@" ] && EN="$@"
  ZH=$(wget --no-check-certificate -qO- --tries=1 --timeout=2 "https://translate.google.com/translate_a/t?client=any_client_id_works&sl=en&tl=zh&q=${EN//[[:space:]]/}" 2>/dev/null)
  [[ "$ZH" =~ ^\[\".+\"\]$ ]] && cut -d \" -f2 <<< "$ZH"
}

# 检测 IPv4 IPv6 信息
check_system_ip() {
  IP4=$(wget -4 -qO- --no-check-certificate --user-agent=Mozilla --tries=2 --timeout=1 http://ip-api.com/json/) &&
  WAN4=$(expr "$IP4" : '.*query\":[ ]*\"\([^"]*\).*') &&
  COUNTRY4=$(expr "$IP4" : '.*country\":[ ]*\"\([^"]*\).*') &&
  ASNORG4=$(expr "$IP4" : '.*isp\":[ ]*\"\([^"]*\).*') &&
  ipv4_address=$WAN4 &&
  [[ "$L" = C && -n "$COUNTRY4" ]] && COUNTRY4=$(translate "$COUNTRY4")

  IP6=$(wget -6 -qO- --no-check-certificate --user-agent=Mozilla --tries=2 --timeout=1 https://api.ip.sb/geoip) &&
  WAN6=$(expr "$IP6" : '.*ip\":[ ]*\"\([^"]*\).*') &&
  COUNTRY6=$(expr "$IP6" : '.*country\":[ ]*\"\([^"]*\).*') &&
  ASNORG6=$(expr "$IP6" : '.*isp\":[ ]*\"\([^"]*\).*') &&
  ipv6_address=$WAN6 &&
  [[ "$L" = C && -n "$COUNTRY6" ]] && COUNTRY6=$(translate "$COUNTRY6")
}

check_root() {
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

check_virt(){
  # 判断虚拟化
  if [ $(type -p systemd-detect-virt) ]; then
    VIRT=$(systemd-detect-virt)
  elif [ $(type -p hostnamectl) ]; then
    VIRT=$(hostnamectl | awk '/Virtualization/{print $NF}')
  elif [ $(type -p virt-what) ]; then
    VIRT=$(virt-what)
  fi
}

# 获取系统信息
get_sysinfo(){
    # 函数: 获取IPv4和IPv6地址
    
    ipv4_address=""
    ipv6_address=""
    ip_address

    check_virt

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
========================
   主机名: $hostname
   运营商: $isp_info
 系统版本: $os_info
 内核版本: $kernel_version
------------------------
  CPU架构: $cpu_arch
  CPU型号: $cpu_info
   核心数: $cpu_cores
   虚拟化: ${yellow}$VIRT${plain}
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
   IPv4地址: $ipv4_address  $WARPSTATUS4 ($COUNTRY4 $CITY4 $ASNORG4)
   IPv6地址: $ipv6_address  $WARPSTATUS6 ($COUNTRY6 $CITY6 $ASNORG6)
------------------------
    系统时间: $current_time
    运行时长: $runtime
========================
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


install_add_docker() {
    if [ -f "/etc/alpine-release" ]; then
        apk update
        apk add docker docker-compose
        rc-update add docker default
        service docker start
    else
        curl -fsSL https://get.docker.com | sh && ln -s /usr/libexec/docker/cli-plugins/docker-compose /usr/local/bin
        systemctl start docker
        systemctl enable docker
    fi
}

# 定义安装 Docker 的函数
install_docker() {
    if ! command -v docker &>/dev/null; then
        install_add_docker
    else
        echo "Docker 已经安装"
    fi
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
${green} 5.${plain} unzip  ZIP压缩解压工具
${green} 6.${plain} tar    GZ压缩解压工具
${green} 7.${plain} tmux   多路后台运行工具
${green} 8.${plain} ffmpeg 视频编码直播推流工具
${green} 9.${plain} htop   系统监控工具
${green}10.${plain} btop   现代化监控工具
${green}11.${plain} iftop  网络流量监控工具
${green}12.${plain} ranger 文件管理工具
${green}13.${plain} gdu    磁盘占用查看工具
${green}14.${plain} fzf    全局搜索工具
-------------------------------
${green}21.${plain} cmatrix 黑客帝国屏保
${green}22.${plain} sl 跑火车屏保
-------------------------------
${green}26.${plain} 俄罗斯方块小游戏
${green}27.${plain} 贪吃蛇小游戏
${green}28.${plain} 太空入侵者小游戏
-------------------------------
${green}31.${plain} 全部安装    ${green}41.${plain} 安装指定工具
${green}32.${plain} 全部卸载    ${green}42.${plain} 卸载指定工具
-------------------------------
${green} 0.${plain} 返回主菜单
-------------------------------
"
}

common_apps_run() {
  while true; do 
    clear && common_apps_menu
    reading "请输入你的选择: " sub_choice

    case $sub_choice in
      1) clear && install curl   && clear && echo "工具已安装，使用方法如下：" && curl   --help ;;
      2) clear && install wget   && clear && echo "工具已安装，使用方法如下：" && wget   --help ;;
      3) clear && install sudo   && clear && echo "工具已安装，使用方法如下：" && sudo   --help ;;
      4) clear && install socat  && clear && echo "工具已安装，使用方法如下：" && socat  --h    ;;
      5) clear && install unzip  && clear && echo "工具已安装，使用方法如下：" && unzip  ;;
      6) clear && install tar    && clear && echo "工具已安装，使用方法如下：" && tar    --help ;;
      7) clear && install tmux   && clear && echo "工具已安装，使用方法如下：" && tmux   --help ;;
      8) clear && install ffmpeg && clear && echo "工具已安装，使用方法如下：" && ffmpeg --help ;;
      9) clear && install htop   && clear && htop  ;;
     10) clear && install btop   && clear && btop  ;;
     11) clear && install iftop  && clear && iftop ;;
     12) clear && install ranger && cd / && clear && ranger && cd ~ ;;
     13) clear && install gdu    && cd / && clear && gdu    && cd ~ ;;
     14) clear && install fzf    && cd / && clear && fzf    && cd ~ ;;
     
     21) clear && install cmatrix   && clear && cmatrix ;;
     22) clear && install sl        && clear && /usr/games/sl ;;
     
     26) clear && install bastet    && clear && /usr/games/bastet ;;
     27) clear && install nsnake    && clear && /usr/games/nsnake ;;
     28) clear && install ninvaders && clear && /usr/games/ninvaders ;;

     31) clear && install curl wget sudo socat htop iftop unzip tar tmux ffmpeg btop ranger gdu fzf cmatrix sl bastet nsnake ninvaders ;;
     32) clear && remove htop iftop unzip tmux ffmpeg btop ranger gdu fzf cmatrix sl bastet nsnake ninvaders ;;
 
     41) clear && reading "请输入安装的工具名(wget curl): " installname && install $installname ;;
     42) clear && reading "请输入卸载的工具名(htop ufw): "  removename  && remove  $removename  ;;

      0) qiqtools ;;
      *) echo "无效的输入!" ;;
    esac
    break_end
  done
}


# 安装最新版本的python
install_python() {
  # 系统检测
  OS=$(cat /etc/os-release | grep -o -E "Debian|Ubuntu|CentOS" | head -n 1)

  if [[ $OS == "Debian" || $OS == "Ubuntu" || $OS == "CentOS" ]]; then
      echo -e "检测到你的系统是 ${YELLOW}${OS}${NC}"
  else
      echo -e "${RED}很抱歉，你的系统不受支持！${NC}"
      exit 1
  fi

  # 检测安装Python3的版本
  VERSION=$(python3 -V 2>&1 | awk '{print $2}')

  # 获取最新Python3版本
  PY_VERSION=$(curl -s https://www.python.org/ | grep "downloads/release" | grep -o 'Python [0-9.]*' | grep -o '[0-9.]*')

  # 卸载Python3旧版本
  if [[ $VERSION == "3"* ]]; then
      echo -e "${YELLOW}你的Python3版本是${NC}${RED}${VERSION}${NC}，${YELLOW}最新版本是${NC}${RED}${PY_VERSION}${NC}"
      read -p "是否确认升级最新版Python3？默认不升级 [y/N]: " CONFIRM
      if [[ $CONFIRM == "y" ]]; then
          if [[ $OS == "CentOS" ]]; then
              echo ""
              rm-rf /usr/local/python3* >/dev/null 2>&1
          else
              apt --purge remove python3 python3-pip -y
              rm-rf /usr/local/python3*
          fi
      else
          echo -e "${YELLOW}已取消升级Python3${NC}"
          exit 1
      fi
  else
      echo -e "${RED}检测到没有安装Python3。${NC}"
      read -p "是否确认安装最新版Python3？默认安装 [Y/n]: " CONFIRM
      if [[ $CONFIRM != "n" ]]; then
          echo -e "${GREEN}开始安装最新版Python3...${NC}"
      else
          echo -e "${YELLOW}已取消安装Python3${NC}"
          exit 1
      fi
  fi

  # 安装相关依赖
  if [[ $OS == "CentOS" ]]; then
      yum update
      yum groupinstall -y "development tools"
      yum install wget openssl-devel bzip2-devel libffi-devel zlib-devel -y
  else
      apt update
      apt install wget build-essential libreadline-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev -y
  fi

  # 安装python3
  cd /root/
  wget https://www.python.org/ftp/python/${PY_VERSION}/Python-"$PY_VERSION".tgz
  tar -zxf Python-${PY_VERSION}.tgz
  cd Python-${PY_VERSION}
  ./configure --prefix=/usr/local/python3
  make -j $(nproc)
  make install
  if [ $? -eq 0 ];then
      rm -f /usr/local/bin/python3*
      rm -f /usr/local/bin/pip3*
      ln -sf /usr/local/python3/bin/python3 /usr/bin/python3
      ln -sf /usr/local/python3/bin/pip3 /usr/bin/pip3
      clear
      echo -e "${YELLOW}Python3安装${GREEN}成功，${NC}版本为: ${NC}${GREEN}${PY_VERSION}${NC}"
  else
      clear
      echo -e "${RED}Python3安装失败！${NC}"
      exit 1
  fi
  cd /root/ && rm -rf Python-${PY_VERSION}.tgz && rm -rf Python-${PY_VERSION}

}

iptables_open() {
    iptables -P INPUT ACCEPT
    iptables -P FORWARD ACCEPT
    iptables -P OUTPUT ACCEPT
    iptables -F

    ip6tables -P INPUT ACCEPT
    ip6tables -P FORWARD ACCEPT
    ip6tables -P OUTPUT ACCEPT
    ip6tables -F

}

# 修改系统SSH连接端口
change_ssh_port() {
  #!/bin/bash

  # 去掉 #Port 的注释
  sed -i 's/#Port/Port/' /etc/ssh/sshd_config

  # 读取当前的 SSH 端口号
  current_port=$(grep -E '^ *Port [0-9]+' /etc/ssh/sshd_config | awk '{print $2}')

  # 打印当前的 SSH 端口号
  echo "当前的 SSH 端口号是: $current_port"

  echo "------------------------"

  # 提示用户输入新的 SSH 端口号
  read -p "请输入新的 SSH 端口号: " new_port

  # 备份 SSH 配置文件
  cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

  # 替换 SSH 配置文件中的端口号
  sed -i "s/Port [0-9]\+/Port $new_port/g" /etc/ssh/sshd_config

  # 重启 SSH 服务
  service sshd restart

  echo "SSH 端口已修改为: $new_port"

  clear
  iptables_open
  remove iptables-persistent ufw firewalld iptables-services > /dev/null 2>&1

}

# 修改系统的DNS
change_dns() {
    echo "当前DNS地址"
    echo "------------------------"
    cat /etc/resolv.conf
    echo "------------------------"
    echo ""
    # 询问用户是否要优化DNS设置
    read -p "是否要设置为Cloudflare和Google的DNS地址？(y/n): " choice

    if [ "$choice" == "y" ]; then
        # 定义DNS地址
        cloudflare_ipv4="1.1.1.1"
            google_ipv4="8.8.8.8"
        cloudflare_ipv6="2606:4700:4700::1111"
            google_ipv6="2001:4860:4860::8888"

        # 检查机器是否有IPv6地址
        ipv6_available=0
        if [[ $(ip -6 addr | grep -c "inet6") -gt 0 ]]; then
            ipv6_available=1
        fi

        # 设置DNS地址为Cloudflare和Google（IPv4和IPv6）
        echo "设置DNS为Cloudflare和Google"

        # 设置IPv4地址
        echo "nameserver $cloudflare_ipv4" > /etc/resolv.conf
        echo "nameserver $google_ipv4" >> /etc/resolv.conf

        # 如果有IPv6地址，则设置IPv6地址
        if [[ $ipv6_available -eq 1 ]]; then
            echo "nameserver $cloudflare_ipv6" >> /etc/resolv.conf
            echo "nameserver $google_ipv6" >> /etc/resolv.conf
        fi

        echo "DNS地址已更新"
        echo "------------------------"
        cat /etc/resolv.conf
        echo "------------------------"
    else
        echo "DNS设置未更改"
    fi

}


# 重装系统
dd_xitong_1() {
  reading "请输入你重装后的密码: " vpspasswd
  install wget
  bash <(wget --no-check-certificate -qO- 'https://raw.githubusercontent.com/MoeClub/Note/master/InstallNET.sh') $xitong -v 64 -p $vpspasswd -port 22
}

dd_xitong_2() {
  install wget
  wget --no-check-certificate -qO InstallNET.sh 'https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/InstallNET.sh' && chmod a+x InstallNET.sh
}

dd_system_menu() {
echo -e "
▶ 可选系统菜单
-------------------------------
${green} 1.${plain} CentOS 9                 ${green} 3.${plain} CentOS 7
${green} 2.${plain} CentOS 8                 
-------------------------------
${green}11.${plain} Debian 12                ${green}21.${plain} Ubuntu 24.04 ${red}(Not Avaliable)
${green}12.${plain} Debian 11                ${green}22.${plain} Ubuntu 22.04
${green}13.${plain} Debian 10                ${green}23.${plain} Ubuntu 20.04
-------------------------------
${green}31.${plain} Alpine Edge              ${green}41.${plain} Kali Rolling
${green}32.${plain} Alpine 3.19              ${green}42.${plain} AlmaLinux
${green}33.${plain} Alpine 3.18              ${green}43.${plain} RockyLinux
${green}34.${plain} Alpine 3.17              ${green}44.${plain} Fedora 39
-------------------------------
${green}64.${plain} Windows 2019             ${green}61.${plain} Windows 11 ${pink}Beta${plain}
${green}65.${plain} Windows 2016             ${green}62.${plain} Windows 10 
${green}66.${plain} Windows 2012             ${green}63.${plain} Windows 2022
-------------------------------
${green} 0.${plain} 返回系统工具菜单
-------------------------------
${green}PS:${plain} Default password: 
${green}   ${blue}   Linux: ${yellow}LeitboGi0ro
${green}   ${blue} Windows: ${yellow}Teddysun.com ${plain}(minumum Disk is 15G)
-------------------------------
"
}

dd_system_run() {
  while true; do
    clear && dd_system_menu
    reading "请选择要重装的系统: " sys_choice

    dd_xitong_2 

    case "$sys_choice" in
      21) 
        # dd_xitong_2 
        bash InstallNET.sh -ubuntu 24.04
        reboot 
        exit ;;
        
      22) 
        # dd_xitong_2 
        # bash InstallNET.sh -ubuntu 
        bash InstallNET.sh -ubuntu 22.04
        reboot 
        exit ;;
      23) 
        bash InstallNET.sh -ubuntu 20.04
        # bash InstallNET.sh -ubuntu 18.04
        # bash InstallNET.sh -ubuntu 16.04
        reboot 
        exit ;;
        # xitong="-u 20.04" 
        # dd_xitong_1 
        # reboot 
        # exit ;;
      11) 
        # bash InstallNET.sh -debian
        bash InstallNET.sh -debian 12
        reboot 
        exit ;;
        # xitong="-d 12" 
        # dd_xitong_1 
        # exit 
        # reboot 
        # ;;
      12) 
        bash InstallNET.sh -debian 11
        reboot 
        exit ;;
        # xitong="-d 11" 
        # dd_xitong_1 
        # reboot 
        # exit ;;
      13) 
        bash InstallNET.sh -debian 10
        reboot 
        exit ;;
        # xitong="-d 10" 
        # dd_xitong_1 
        # reboot 
        # exit ;;
      #============================== 
      1) 
        bash InstallNET.sh -centos 9
        reboot 
        exit ;;
      2) 
        bash InstallNET.sh -centos 8
        reboot 
        exit ;;
      3) 
        bash InstallNET.sh -centos 7
        reboot 
        exit ;;
      #============================== 
      31) 
        # bash InstallNET.sh -alpine
        bash InstallNET.sh -alpine edge
        bash InstallNET.sh -alpine 3.19
        bash InstallNET.sh -alpine 3.18
        reboot 
        exit ;;
      32) 
        bash InstallNET.sh -alpine 3.19
        reboot 
        exit ;;
      33) 
        bash InstallNET.sh -alpine 3.18
        reboot 
        exit ;;
      34) 
        bash InstallNET.sh -alpine 3.17
        reboot 
        exit ;;
      #============================== 
      41) 
        bash InstallNET.sh -kali   
        # bash InstallNET.sh -kali rolling   
        # bash InstallNET.sh -kali dev   
        # bash InstallNET.sh -kali experimental   
        reboot 
        exit ;;
      42) 
        bash InstallNET.sh -almalinux 9
        # bash InstallNET.sh -almalinux 8   
        reboot 
        exit ;;
      43) 
        bash InstallNET.sh -rockylinux 9
        # bash InstallNET.sh -rockylinux 8   
        reboot 
        exit ;;
      44) 
        bash InstallNET.sh -fedro 39
        # bash InstallNET.sh -fedro 38   
        reboot 
        exit ;;
      #============================== 
      61) 
        bash InstallNET.sh -windows 11
        # bash InstallNET.sh -windows 11 -lang "en"
        # bash InstallNET.sh -windows 11 -lang "cn"
        # bash InstallNET.sh -windows 11 -lang "jp" -port "22[1~65535]" -pwd "PssWord" -hostname "win11"
        reboot 
        exit ;;
      62) 
        bash InstallNET.sh -windows 10
        reboot 
        exit ;;
      63) 
        bash InstallNET.sh -windows 2022
        reboot 
        exit ;;
      64) 
        bash InstallNET.sh -windows 2019
        reboot 
        exit ;;
      65) 
        bash InstallNET.sh -windows 2016
        reboot 
        exit ;;
      66) 
        bash InstallNET.sh -windows 2012
        reboot 
        exit ;;
      #============================== 
      0) system_tools_run && exit ;;
      *) echo "无效的选择，请重新输入。" && break_end ;;
    esac    
  done
}

banroot_with_new_user() {
  install sudo

  # 提示用户输入新用户名
  reading "请输入新用户名: " new_username

  # 创建新用户并设置密码
  sudo useradd -m -s /bin/bash "$new_username"
  sudo passwd "$new_username"

  # 赋予新用户sudo权限
  echo "$new_username ALL=(ALL:ALL) ALL" | sudo tee -a /etc/sudoers

  # 禁用ROOT用户登录
  sudo passwd -l root

  echo "操作已完成。"
  
}

alter_ipv4_ipv6() {
  ipv6_disabled=$(sysctl -n net.ipv6.conf.all.disable_ipv6)

  echo ""
  if [ "$ipv6_disabled" -eq 1 ]; then
      echo "当前网络优先级设置: IPv4 优先"
  else
      echo "当前网络优先级设置: IPv6 优先"
  fi
  echo "------------------------"

  echo ""
  echo "切换的网络优先级"
  echo "------------------------"
  echo "1. IPv4 优先          2. IPv6 优先"
  echo "------------------------"
  read -p "选择优先的网络: " choice

  case $choice in
      1)
          sysctl -w net.ipv6.conf.all.disable_ipv6=1 > /dev/null 2>&1
          echo "已切换为 IPv4 优先" ;;
      2)
          sysctl -w net.ipv6.conf.all.disable_ipv6=0 > /dev/null 2>&1
          echo "已切换为 IPv6 优先" ;;
      *) echo "无效的选择" ;;
  esac
}

# 设置系统虚拟内存
set_swap() {
  if [ "$EUID" -ne 0 ]; then
    echo "请以 root 权限运行此脚本。"
    exit 1
  fi

  clear
  # 获取当前交换空间信息
   swap_used=$(free -m | awk 'NR==3{print $3}')
  swap_total=$(free -m | awk 'NR==3{print $2}')

  if [ "$swap_total" -eq 0 ]; then
    swap_percentage=0
  else
    swap_percentage=$((swap_used * 100 / swap_total))
  fi

  swap_info="${swap_used}MB/${swap_total}MB (${swap_percentage}%)"

  echo "当前虚拟内存: $swap_info"

  read -p "是否调整大小?(Y/N): " choice

  case "$choice" in
    [Yy])
      # 输入新的虚拟内存大小
      read -p "请输入虚拟内存大小MB: " new_swap

      # 获取当前系统中所有的 swap 分区
      swap_partitions=$(grep -E '^/dev/' /proc/swaps | awk '{print $1}')

      # 遍历并删除所有的 swap 分区
      for partition in $swap_partitions; do
        swapoff "$partition"
        wipefs -a "$partition"  # 清除文件系统标识符
        mkswap -f "$partition"
        echo "已删除并重新创建 swap 分区: $partition"
      done

      # 确保 /swapfile 不再被使用
      swapoff /swapfile

      # 删除旧的 /swapfile
      rm -f /swapfile

      # 创建新的 swap 分区
      dd if=/dev/zero of=/swapfile bs=1M count=$new_swap
      chmod 600 /swapfile
      mkswap /swapfile
      swapon /swapfile

      if [ -f /etc/alpine-release ]; then
          echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
          echo "nohup swapon /swapfile" >> /etc/local.d/swap.start
          chmod +x /etc/local.d/swap.start
          rc-update add local
      else
          echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
      fi

      echo "虚拟内存大小已调整为${new_swap}MB"
      ;;
    [Nn])
      echo "已取消"
      ;;
    *)
      echo "无效的选择，请输入 Y 或 N。"
      ;;
  esac
  
}

# 修改系统名
change_sys_name(){
  current_hostname=$(hostname)

  # 询问用户是否要更改主机名
  echo "当前主机名: $current_hostname"
  read -p "是否要更改主机名？(y/n): " answer

  if [ "$answer" == "y" ]; then
      # 获取新的主机名
      read -p "请输入新的主机名: " new_hostname
      if [ -n "$new_hostname" ]; then
          if [ -f /etc/alpine-release ]; then
              # Alpine
              echo "$new_hostname" > /etc/hostname
              hostname "$new_hostname"
          else
              # 其他系统，如 Debian, Ubuntu, CentOS 等
              hostnamectl set-hostname "$new_hostname"
              sed -i "s/$current_hostname/$new_hostname/g" /etc/hostname
              systemctl restart systemd-hostnamed
          fi
          echo "主机名已更改为: $new_hostname"
      else
          echo "无效的主机名。未更改主机名。"
          exit 1
      fi
  else
      echo "未更改主机名。"
  fi
}

# 修改系统安装源
alter_sourcelist(){
  # 获取系统信息
  source /etc/os-release

  # 定义 Ubuntu 更新源
  aliyun_ubuntu_source="http://mirrors.aliyun.com/ubuntu/"
  official_ubuntu_source="http://archive.ubuntu.com/ubuntu/"
  initial_ubuntu_source=""

  # 定义 Debian 更新源
  aliyun_debian_source="http://mirrors.aliyun.com/debian/"
  official_debian_source="http://deb.debian.org/debian/"
  initial_debian_source=""

  # 定义 CentOS 更新源
  aliyun_centos_source="http://mirrors.aliyun.com/centos/"
  official_centos_source="http://mirror.centos.org/centos/"
  initial_centos_source=""

  # 获取当前更新源并设置初始源
  case "$ID" in
      ubuntu) initial_ubuntu_source=$(grep -E '^deb ' /etc/apt/sources.list | head -n 1 | awk '{print $2}') ;;
      debian) initial_debian_source=$(grep -E '^deb ' /etc/apt/sources.list | head -n 1 | awk '{print $2}') ;;
      centos) initial_centos_source=$(awk -F= '/^baseurl=/ {print $2}' /etc/yum.repos.d/CentOS-Base.repo | head -n 1 | tr -d ' ') ;;
           *) echo "未知系统，无法执行切换源脚本" && exit 1 ;;
  esac

  # 备份当前源
  backup_sources() {
      case "$ID" in
          ubuntu) cp /etc/apt/sources.list /etc/apt/sources.list.bak ;;
          debian) cp /etc/apt/sources.list /etc/apt/sources.list.bak ;;
          centos)
              if [ ! -f /etc/yum.repos.d/CentOS-Base.repo.bak ]; then
                  cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
              else
                  echo "备份已存在，无需重复备份"
              fi
              ;;
          *) echo "未知系统，无法执行备份操作" && exit 1 ;;
      esac
      echo "已备份当前更新源为 /etc/apt/sources.list.bak 或 /etc/yum.repos.d/CentOS-Base.repo.bak"
  }

  # 还原初始更新源
  restore_initial_source() {
      case "$ID" in
          ubuntu) cp /etc/apt/sources.list.bak /etc/apt/sources.list ;;
          debian) cp /etc/apt/sources.list.bak /etc/apt/sources.list ;;
          centos) cp /etc/yum.repos.d/CentOS-Base.repo.bak /etc/yum.repos.d/CentOS-Base.repo ;;
               *) echo "未知系统，无法执行还原操作" && exit 1 ;;
      esac
      echo "已还原初始更新源"
  }

  # 函数：切换更新源
  switch_source() {
      case "$ID" in
          ubuntu) sed -i 's|'"$initial_ubuntu_source"'|'"$1"'|g' /etc/apt/sources.list ;;
          debian) sed -i 's|'"$initial_debian_source"'|'"$1"'|g' /etc/apt/sources.list ;;
          centos) sed -i "s|^baseurl=.*$|baseurl=$1|g" /etc/yum.repos.d/CentOS-Base.repo ;;
               *) echo "未知系统，无法执行切换操作" && exit 1 ;;
      esac
  }

  # 主菜单
  while true; do
      clear
      case "$ID" in
          ubuntu) echo -e "Ubuntu 更新源切换脚本\n------------------------" ;;
          debian) echo -e "Debian 更新源切换脚本\n------------------------" ;;
          centos) echo -e "CentOS 更新源切换脚本\n------------------------" ;;
               *) echo "未知系统，无法执行脚本" && exit 1 ;;
      esac

      echo "1. 切换到阿里云源"
      echo "2. 切换到官方源"
      echo "------------------------"
      echo "3. 备份当前更新源"
      echo "4. 还原初始更新源"
      echo "------------------------"
      echo "0. 返回上一级"
      echo "------------------------"
      read -p "请选择操作: " choice

      case $choice in
          1)
              backup_sources
              case "$ID" in
                  ubuntu) switch_source $aliyun_ubuntu_source ;;
                  debian) switch_source $aliyun_debian_source ;;
                  centos) switch_source $aliyun_centos_source ;;
                       *) echo "未知系统，无法执行切换操作" && exit 1 ;;
              esac
              echo "已切换到阿里云源"
              ;;
          2)
              backup_sources
              case "$ID" in
                  ubuntu) switch_source $official_ubuntu_source ;;
                  debian) switch_source $official_debian_source ;;
                  centos) switch_source $official_centos_source ;;
                       *) echo "未知系统，无法执行切换操作" && exit 1 ;;
              esac
              echo "已切换到官方源"
              ;;
          3)
              backup_sources
              case "$ID" in
                  ubuntu) switch_source $initial_ubuntu_source ;;
                  debian) switch_source $initial_debian_source ;;
                  centos) switch_source $initial_centos_source ;;
                       *) echo "未知系统，无法执行切换操作" && exit 1 ;;
              esac
              echo "已切换到初始更新源"
              ;;
          4) restore_initial_source ;;
          0) break ;;
          *) echo "无效的选择，请重新输入" ;;
      esac
      break_end
  done
}

timezone_menu(){
echo -e "
▶ 时区切换
${plain}-->> 亚洲 <<-----------------------------
${green} 1.${plain} 中国上海时间              ${green} 2.${plain} 中国香港时间
${green} 3.${plain} 日本东京时间              ${green} 4.${plain} 韩国首尔时间
${green} 5.${plain} 新加坡时间                ${green} 6.${plain} 中国香港时间
${green} 7.${plain} 阿联酋迪拜时间            ${green} 8.${plain} 澳大利亚悉尼时间

${plain}-->> 欧洲 <<-----------------------------
${green}11.${plain} 英国伦敦时间              ${green}12.${plain} 法国巴黎时间
${green}13.${plain} 德国柏林时间              ${green}14.${plain} 俄罗斯莫斯科时间
${green}15.${plain} 荷兰尤特赖赫特时间        ${green}16.${plain} 西班牙马德里时间

${plain}-->> 美洲 <<-----------------------------
${green}21.${plain} 美国西部时间              ${green}22.${plain} 美国东部时间
${green}23.${plain} 加拿大时间               ${green}24.${plain} 墨西哥时间
${green}25.${plain} 巴西时间                 ${green}26.${plain} 阿根廷时间
${plain}-------------------------------
${green} 0.${plain} 返回上级菜单
${plain}-------------------------------
"
}

# 修改系统时区
alter_timezone(){
  while true; do
      echo "系统时间信息"

      # 获取当前系统时区
      current_timezone=$(timedatectl show --property=Timezone --value)

      # 获取当前系统时间
      current_time=$(date +"%Y-%m-%d %H:%M:%S")

      # 显示时区和时间
      echo "当前系统时区：$current_timezone"
      echo "当前系统时间：$current_time"

      timezone_menu
      read -p "请输入你的选择: " sub_choice

      case $sub_choice in
           1) timedatectl set-timezone Asia/Shanghai ;;
           2) timedatectl set-timezone Asia/Hong_Kong ;;
           3) timedatectl set-timezone Asia/Tokyo ;;
           4) timedatectl set-timezone Asia/Seoul ;;
           5) timedatectl set-timezone Asia/Singapore ;;
           6) timedatectl set-timezone Asia/Kolkata ;;
           7) timedatectl set-timezone Asia/Dubai ;;
           8) timedatectl set-timezone Australia/Sydney ;;
          11) timedatectl set-timezone Europe/London ;;
          12) timedatectl set-timezone Europe/Paris ;;
          13) timedatectl set-timezone Europe/Berlin ;;
          14) timedatectl set-timezone Europe/Moscow ;;
          15) timedatectl set-timezone Europe/Amsterdam ;;
          16) timedatectl set-timezone Europe/Madrid ;;
          21) timedatectl set-timezone America/Los_Angeles ;;
          22) timedatectl set-timezone America/New_York ;;
          23) timedatectl set-timezone America/Vancouver ;;
          24) timedatectl set-timezone America/Mexico_City ;;
          25) timedatectl set-timezone America/Sao_Paulo ;;
          26) timedatectl set-timezone America/Argentina/Buenos_Aires ;;
          0) break ;; # 跳出循环，退出菜单
          *) break ;; # 跳出循环，退出菜单
      esac
  done
}

# 管理BBRv3
bbrv3_install(){
  if dpkg -l | grep -q 'linux-xanmod'; then
    while true; do
          clear
          kernel_version=$(uname -r)
          echo "您已安装xanmod的BBRv3内核"
          echo "当前内核版本: $kernel_version"

          echo ""
          echo "内核管理"
          echo "------------------------"
          echo "1. 更新BBRv3内核              2. 卸载BBRv3内核"
          echo "------------------------"
          echo "0. 返回上一级选单"
          echo "------------------------"
          read -p "请输入你的选择: " sub_choice

          case $sub_choice in
              1)
                apt purge -y 'linux-*xanmod1*'
                update-grub

                # wget -qO - https://dl.xanmod.org/archive.key | gpg --dearmor -o /usr/share/keyrings/xanmod-archive-keyring.gpg --yes
                wget -qO - https://raw.githubusercontent.com/kejilion/sh/main/archive.key | gpg --dearmor -o /usr/share/keyrings/xanmod-archive-keyring.gpg --yes

                # 步骤3：添加存储库
                echo 'deb [signed-by=/usr/share/keyrings/xanmod-archive-keyring.gpg] http://deb.xanmod.org releases main' | tee /etc/apt/sources.list.d/xanmod-release.list

                # version=$(wget -q https://dl.xanmod.org/check_x86-64_psabi.sh && chmod +x check_x86-64_psabi.sh && ./check_x86-64_psabi.sh | grep -oP 'x86-64-v\K\d+|x86-64-v\d+')
                version=$(wget -q https://raw.githubusercontent.com/kejilion/sh/main/check_x86-64_psabi.sh && chmod +x check_x86-64_psabi.sh && ./check_x86-64_psabi.sh | grep -oP 'x86-64-v\K\d+|x86-64-v\d+')

                apt update -y
                apt install -y linux-xanmod-x64v$version

                echo "XanMod内核已更新。重启后生效"
                rm -f /etc/apt/sources.list.d/xanmod-release.list
                rm -f check_x86-64_psabi.sh*

                reboot

                  ;;
              2)
                apt purge -y 'linux-*xanmod1*'
                update-grub
                echo "XanMod内核已卸载。重启后生效"
                reboot
                  ;;
              0)
                  break  # 跳出循环，退出菜单
                  ;;

              *)
                  break  # 跳出循环，退出菜单
                  ;;

          esac
    done
else

  clear
  echo "请备份数据，将为你升级Linux内核开启BBR3"
  echo "官网介绍: https://xanmod.org/"
  echo "------------------------------------------------"
  echo "仅支持Debian/Ubuntu 仅支持x86_64架构"
  echo "VPS是512M内存的，请提前添加1G虚拟内存，防止因内存不足失联！"
  echo "------------------------------------------------"
  read -p "确定继续吗？(Y/N): " choice

  case "$choice" in
    [Yy])
    if [ -r /etc/os-release ]; then
        . /etc/os-release
        if [ "$ID" != "debian" ] && [ "$ID" != "ubuntu" ]; then
            echo "当前环境不支持，仅支持Debian和Ubuntu系统"
            break
        fi
    else
        echo "无法确定操作系统类型"
        break
    fi

    # 检查系统架构
    arch=$(dpkg --print-architecture)
    if [ "$arch" != "amd64" ]; then
      echo "当前环境不支持，仅支持x86_64架构"
      break
    fi

    install wget gnupg

    # wget -qO - https://dl.xanmod.org/archive.key | gpg --dearmor -o /usr/share/keyrings/xanmod-archive-keyring.gpg --yes
    wget -qO - https://raw.githubusercontent.com/kejilion/sh/main/archive.key | gpg --dearmor -o /usr/share/keyrings/xanmod-archive-keyring.gpg --yes

    # 步骤3：添加存储库
    echo 'deb [signed-by=/usr/share/keyrings/xanmod-archive-keyring.gpg] http://deb.xanmod.org releases main' | tee /etc/apt/sources.list.d/xanmod-release.list

    # version=$(wget -q https://dl.xanmod.org/check_x86-64_psabi.sh && chmod +x check_x86-64_psabi.sh && ./check_x86-64_psabi.sh | grep -oP 'x86-64-v\K\d+|x86-64-v\d+')
    version=$(wget -q https://raw.githubusercontent.com/kejilion/sh/main/check_x86-64_psabi.sh && chmod +x check_x86-64_psabi.sh && ./check_x86-64_psabi.sh | grep -oP 'x86-64-v\K\d+|x86-64-v\d+')

    apt update -y
    apt install -y linux-xanmod-x64v$version

    # 步骤5：启用BBR3
    cat > /etc/sysctl.conf << EOF
net.core.default_qdisc=fq_pie
net.ipv4.tcp_congestion_control=bbr
EOF
    sysctl -p

    echo "XanMod内核安装并BBR3启用成功。重启后生效"
    rm -f /etc/apt/sources.list.d/xanmod-release.list
    rm -f check_x86-64_psabi.sh*
    reboot

      ;;
    [Nn]) echo "已取消" ;;
    *) echo "无效的选择，请输入 Y 或 N。" ;;
  esac
fi

}

# 给Alpine系统添加BBRv3
bbrv3_conf(){
  cat > /etc/sysctl.conf << EOF
net.core.default_qdisc=fq_pie
net.ipv4.tcp_congestion_control=bbr
EOF

  sysctl -p
}

# 防火墙管理
firewall_manage(){
  if dpkg -l | grep -q iptables-persistent; then
    while true; do
          clear
          echo "防火墙已安装"
          echo "------------------------"
          iptables -L INPUT

          echo ""
          echo "防火墙管理"
          echo "------------------------"
          echo "1. 开放指定端口              2. 关闭指定端口"
          echo "3. 开放所有端口              4. 关闭所有端口"
          echo "------------------------"
          echo "5. IP白名单                  6. IP黑名单"
          echo "7. 清除指定IP"
          echo "------------------------"
          echo "9. 卸载防火墙"
          echo "------------------------"
          echo "0. 返回上一级选单"
          echo "------------------------"
          read -p "请输入你的选择: " sub_choice

          case $sub_choice in
              1)
              read -p "请输入开放的端口号: " o_port
              sed -i "/COMMIT/i -A INPUT -p tcp --dport $o_port -j ACCEPT" /etc/iptables/rules.v4
              sed -i "/COMMIT/i -A INPUT -p udp --dport $o_port -j ACCEPT" /etc/iptables/rules.v4
              iptables-restore < /etc/iptables/rules.v4

                  ;;
              2)
              read -p "请输入关闭的端口号: " c_port
              sed -i "/--dport $c_port/d" /etc/iptables/rules.v4
              iptables-restore < /etc/iptables/rules.v4
                ;;

              3)
              current_port=$(grep -E '^ *Port [0-9]+' /etc/ssh/sshd_config | awk '{print $2}')

              cat > /etc/iptables/rules.v4 << EOF
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A FORWARD -i lo -j ACCEPT
-A INPUT -p tcp --dport $current_port -j ACCEPT
COMMIT
EOF
              iptables-restore < /etc/iptables/rules.v4

                  ;;
              4)
              current_port=$(grep -E '^ *Port [0-9]+' /etc/ssh/sshd_config | awk '{print $2}')

              cat > /etc/iptables/rules.v4 << EOF
*filter
:INPUT DROP [0:0]
:FORWARD DROP [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A FORWARD -i lo -j ACCEPT
-A INPUT -p tcp --dport $current_port -j ACCEPT
COMMIT
EOF
              iptables-restore < /etc/iptables/rules.v4

                  ;;

              5)
              read -p "请输入放行的IP: " o_ip
              sed -i "/COMMIT/i -A INPUT -s $o_ip -j ACCEPT" /etc/iptables/rules.v4
              iptables-restore < /etc/iptables/rules.v4

                  ;;

              6)
              read -p "请输入封锁的IP: " c_ip
              sed -i "/COMMIT/i -A INPUT -s $c_ip -j DROP" /etc/iptables/rules.v4
              iptables-restore < /etc/iptables/rules.v4
                  ;;

              7)
              read -p "请输入清除的IP: " d_ip
              sed -i "/-A INPUT -s $d_ip/d" /etc/iptables/rules.v4
              iptables-restore < /etc/iptables/rules.v4
                  ;;

              9)
              remove iptables-persistent
              rm /etc/iptables/rules.v4
              break
              # echo "防火墙已卸载，重启生效"
              # reboot
                  ;;

              0) break ;; # 跳出循环，退出菜单
              *) break ;; # 跳出循环，退出菜单
          esac
    done
else

  clear
  echo "将为你安装防火墙，该防火墙仅支持Debian/Ubuntu"
  echo "------------------------------------------------"
  read -p "确定继续吗？(Y/N): " choice

  case "$choice" in
    [Yy])
    if [ -r /etc/os-release ]; then
        . /etc/os-release
        if [ "$ID" != "debian" ] && [ "$ID" != "ubuntu" ]; then
            echo "当前环境不支持，仅支持Debian和Ubuntu系统"
            break
        fi
    else
        echo "无法确定操作系统类型"
        break
    fi

  clear
  iptables_open
  remove iptables-persistent ufw
  rm /etc/iptables/rules.v4

  apt update -y && apt install -y iptables-persistent

  current_port=$(grep -E '^ *Port [0-9]+' /etc/ssh/sshd_config | awk '{print $2}')

  cat > /etc/iptables/rules.v4 << EOF
*filter
:INPUT DROP [0:0]
:FORWARD DROP [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A FORWARD -i lo -j ACCEPT
-A INPUT -p tcp --dport $current_port -j ACCEPT
COMMIT
EOF

  iptables-restore < /etc/iptables/rules.v4
  systemctl enable netfilter-persistent
  echo "防火墙安装完成"


      ;;
    [Nn]) echo "已取消" ;;
    *) echo "无效的选择，请输入 Y 或 N。" ;;
  esac
fi

}

# 用户管理
user_manage(){
  while true; do
    # clear && install sudo && clear 
    clear
    # 显示所有用户、用户权限、用户组和是否在sudoers中
    echo "用户列表"
    echo "----------------------------------------------------------------------------"
    printf "%-24s %-34s %-20s %-10s\n" "用户名" "用户权限" "用户组" "sudo权限"
    while IFS=: read -r username _ userid groupid _ _ homedir shell; do
        groups=$(groups "$username" | cut -d : -f 2)
        sudo_status=$(sudo -n -lU "$username" 2>/dev/null | grep -q '(ALL : ALL)' && echo "Yes" || echo "No")
        printf "%-20s %-30s %-20s %-10s\n" "$username" "$homedir" "$groups" "$sudo_status"
    done < /etc/passwd


      echo ""
      echo "账户操作"
      echo "------------------------"
      echo "1. 创建普通账户             2. 创建高级账户"
      echo "------------------------"
      echo "3. 赋予最高权限             4. 取消最高权限"
      echo "------------------------"
      echo "5. 删除账号"
      echo "------------------------"
      echo "0. 返回上一级菜单"
      echo "------------------------"
      read -p "请输入你的选择: " sub_choice

      case $sub_choice in
          1)
            # 提示用户输入新用户名
            read -p "请输入新用户名: " new_username

            # 创建新用户并设置密码
            sudo useradd -m -s /bin/bash "$new_username"
            sudo passwd "$new_username"

            echo "操作已完成。"
              ;;

          2)
            # 提示用户输入新用户名
            read -p "请输入新用户名: " new_username

            # 创建新用户并设置密码
            sudo useradd -m -s /bin/bash "$new_username"
            sudo passwd "$new_username"

            # 赋予新用户sudo权限
            echo "$new_username ALL=(ALL:ALL) ALL" | sudo tee -a /etc/sudoers

            echo "操作已完成。"

              ;;
          3)
            read -p "请输入用户名: " username
            # 赋予新用户sudo权限
            echo "$username ALL=(ALL:ALL) ALL" | sudo tee -a /etc/sudoers
              ;;
          4)
            read -p "请输入用户名: " username
            # 从sudoers文件中移除用户的sudo权限
            sudo sed -i "/^$username\sALL=(ALL:ALL)\sALL/d" /etc/sudoers

              ;;
          5)
            read -p "请输入要删除的用户名: " username
            # 删除用户及其主目录
            sudo userdel -r "$username"
              ;;

          0) break ;; # 跳出循环，退出菜单
          *) break ;; # 跳出循环，退出菜单
      esac
  done
}

# 用户名和密码管理
pss_generate(){
  echo "随机用户名"
  echo "------------------------"
  for i in {1..5}; do
      username="user$(< /dev/urandom tr -dc _a-z0-9 | head -c6)"
      echo "随机用户名 $i: $username"
  done

  echo ""
  echo "随机姓名"
  echo "------------------------"
  first_names=("John" "Jane" "Michael" "Emily" "David" "Sophia" "William" "Olivia" "James" "Emma" "Ava" "Liam" "Mia" "Noah" "Isabella")
  last_names=("Smith" "Johnson" "Brown" "Davis" "Wilson" "Miller" "Jones" "Garcia" "Martinez" "Williams" "Lee" "Gonzalez" "Rodriguez" "Hernandez")

  # 生成5个随机用户姓名
  for i in {1..5}; do
      first_name_index=$((RANDOM % ${#first_names[@]}))
      last_name_index=$((RANDOM % ${#last_names[@]}))
      user_name="${first_names[$first_name_index]} ${last_names[$last_name_index]}"
      echo "随机用户姓名 $i: $user_name"
  done

  echo ""
  echo "随机UUID"
  echo "------------------------"
  for i in {1..5}; do
      uuid=$(cat /proc/sys/kernel/random/uuid)
      echo "随机UUID $i: $uuid"
  done

  echo ""
  echo "16位随机密码"
  echo "------------------------"
  for i in {1..5}; do
      password=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c16)
      echo "随机密码 $i: $password"
  done

  echo ""
  echo "32位随机密码"
  echo "------------------------"
  for i in {1..5}; do
      password=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c32)
      echo "随机密码 $i: $password"
  done
  echo ""

}

# 定时任务管理
cron_manage(){
  while true; do
      clear
      echo "定时任务列表"
      crontab -l
      echo ""
      echo "操作"
      echo "------------------------"
      echo "1. 添加定时任务              2. 删除定时任务"
      echo "------------------------"
      echo "0. 返回上一级菜单"
      echo "------------------------"
      read -p "请输入你的选择: " sub_choice

      case $sub_choice in
          1)
              read -p "请输入新任务的执行命令: " newquest
              echo "------------------------"
              echo "1. 每周任务                 2. 每天任务"
              read -p "请输入你的选择: " dingshi

              case $dingshi in
                  1)
                      read -p "选择周几执行任务？ (0-6，0代表星期日): " weekday
                      (crontab -l ; echo "0 0 * * $weekday $newquest") | crontab - > /dev/null 2>&1
                      ;;
                  2)
                      read -p "选择每天几点执行任务？（小时，0-23）: " hour
                      (crontab -l ; echo "0 $hour * * * $newquest") | crontab - > /dev/null 2>&1
                      ;;
                  *)
                      break  # 跳出
                      ;;
              esac
              ;;
          2)
              read -p "请输入需要删除任务的关键字: " kquest
              crontab -l | grep -v "$kquest" | crontab -
              ;;
          0) break ;; # 跳出循环，退出菜单
          *) break ;; # 跳出循环，退出菜单
      esac
  done
}

# 系统常用工具
system_tools_menu() {
echo -e "
▶ 系统工具
-------------------------------
${green} 1.${plain} 设置脚本启动快捷键
-------------------------------
${green} 2.${plain} 修改ROOT密码                  ${green}11.${red} 修改虚拟内存大小
${green} 3.${plain} 开启ROOT密码登录模式          ${green}12.${plain} 修改主机名
${green} 4.${plain} 开放所有端口                  ${green}13.${plain} 切换系统更新源
${green} 5.${plain} 修改SSH连接端口               ${green}14.${blue} 系统时区调整
${green} 6.${red} 优化DNS地址                   ${green}15.${plain} 开启BBR3加速
${green} 7.${plain} 一键重装系统                  ${green}16.${plain} 防火墙高级管理器
${green} 8.${plain} 禁用ROOT账户创建新账户        ${green}17.${plain} 用户管理
${green} 9.${red} 切换优先ipv4/ipv6             ${green}18.${plain} 用户/密码生成器
${green}10.${plain} 查看端口占用状态              ${green}19.${plain} 定时任务管理
-------------------------------
${green}99.${plain} 重启服务器    
${green} 0.${plain} 返回主菜单
-------------------------------
"
}

system_tools_run() {
  while true; do 
    clear && system_tools_menu
    reading "请输入你的选择: " sub_choice

    case $sub_choice in
      1) clear && reading "请输入你的快捷按键: " kuaijiejian && echo "alias $kuaijiejian='~/kejilion.sh'" >> ~/.bashrc && source ~/.bashrc && echo "快捷键已设置" ;;
      2) clear && echo "设置你的ROOT密码" && passwd ;;
      3) 
        clear && echo "设置你的ROOT密码" && passwd

        sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config;
        sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config;
        service sshd restart
        echo "ROOT登录设置完毕！"

        reading "需要重启服务器吗？(Y/N): " choice
        case "$choice" in
          [Yy]) reboot ;;
          [Nn]) echo "已取消" ;;
             *) echo "无效的选择，请输入 Y 或 N。" ;;
        esac
        ;;
      # 4) clear && install_python ;;
      4) clear && iptables_open && remove iptables-persistent ufw firewalld iptables-services > /dev/null 2>&1 && echo "端口已全部开放" ;;
      5) clear && change_ssh_port ;;
      6) clear && change_dns ;;
      7) 
        clear && echo -e "请备份数据，将为你重装系统，预计花费15分钟。\n${white}感谢MollyLau和MoeClub的脚本支持！${plain}"
        reading "确定继续吗？(Y/N): " choice
        case "$choice" in
          [Yy]) dd_system_run ;;
          [Nn]) echo "已取消" ;;
             *) echo "无效的选择，请输入 Y 或 N。" ;;
        esac
        ;;
      8) clear && banroot_with_new_user ;;
      9) clear && alter_ipv4_ipv6 ;;
     10) clear && ss -tulnape ;;
     11) clear && set_swap ;;
     12) clear && change_sys_name  ;;
     13) clear && alter_sourcelist ;;
     14) clear && alter_timezone ;;
     15) clear && bbrv3_install ;;
     16) clear && firewall_manage ;;
     17) clear && user_manage ;;
     18) clear && pss_generate ;;
     19) clear && cron_manage ;;
    #  20) clear && echo "Todo: ..." ;;

     99) clear && echo "正在重启服务器，即将断开SSH连接" && reboot ;;
      0) qiqtools ;;
      *) echo "无效的输入!" ;;
    esac
    break_end
  done
}

install_baota_cn() {
  if [ -f "/etc/init.d/bt" ] && [ -d "/www/server/panel" ]; then
      clear
      echo "宝塔面板已安装，应用操作"
      echo ""
      echo "------------------------"
      echo "1. 管理宝塔面板           2. 卸载宝塔面板"
      echo "------------------------"
      echo "0. 返回上一级选单"
      echo "------------------------"
      read -p "请输入你的选择: " sub_choice

      case $sub_choice in
          1) clear && bt ;;
          2) clear && curl -o bt-uninstall.sh http://download.bt.cn/install/bt-uninstall.sh > /dev/null 2>&1 && chmod +x bt-uninstall.sh && ./bt-uninstall.sh ;;
          0) break  ;;
          *) break  ;;
      esac
  else
      clear
      echo "安装提示"
      echo "如果您已经安装了其他面板工具或者LDNMP建站环境，建议先卸载，再安装宝塔面板！"
      echo "会根据系统自动安装，支持Debian，Ubuntu，Centos"
      echo "官网介绍: https://www.bt.cn/new/index.html"
      echo ""

      # 获取当前系统类型
      get_system_type() {
          if [ -f /etc/os-release ]; then
              . /etc/os-release
              if [ "$ID" == "centos" ]; then
                  echo "centos"
              elif [ "$ID" == "ubuntu" ]; then
                  echo "ubuntu"
              elif [ "$ID" == "debian" ]; then
                  echo "debian"
              else
                  echo "unknown"
              fi
          else
              echo "unknown"
          fi
      }

      system_type=$(get_system_type)

      if [ "$system_type" == "unknown" ]; then
          echo "不支持的操作系统类型"
      else
          read -p "确定安装宝塔吗？(Y/N): " choice
          case "$choice" in
              [Yy])
                  iptables_open
                  install wget
                  if [ "$system_type" == "centos" ]; then
                      yum install -y wget && wget -O install.sh https://download.bt.cn/install/install_6.0.sh && sh install.sh ed8484bec
                  elif [ "$system_type" == "ubuntu" ]; then
                      wget -O install.sh https://download.bt.cn/install/install-ubuntu_6.0.sh && bash install.sh ed8484bec
                  elif [ "$system_type" == "debian" ]; then
                      wget -O install.sh https://download.bt.cn/install/install-ubuntu_6.0.sh && bash install.sh ed8484bec
                  fi
                  ;;
              [Nn]) ;;
                 *) ;;
          esac
      fi
  fi

}

install__baota_aa(){
  if [ -f "/etc/init.d/bt" ] && [ -d "/www/server/panel" ]; then
      clear
      echo "aaPanel已安装，应用操作"
      echo ""
      echo "------------------------"
      echo "1. 管理aaPanel           2. 卸载aaPanel"
      echo "------------------------"
      echo "0. 返回上一级选单"
      echo "------------------------"
      read -p "请输入你的选择: " sub_choice

      case $sub_choice in
          1) clear && bt ;;
          2) clear && curl -o bt-uninstall.sh http://download.bt.cn/install/bt-uninstall.sh > /dev/null 2>&1 && chmod +x bt-uninstall.sh && ./bt-uninstall.sh ;;
          0) break ;;
          *) break ;;
      esac
  else
      clear
      echo "安装提示"
      echo "如果您已经安装了其他面板工具或者LDNMP建站环境，建议先卸载，再安装aaPanel！"
      echo "会根据系统自动安装，支持Debian，Ubuntu，Centos"
      echo "官网介绍: https://www.aapanel.com/new/index.html"
      echo ""

      # 获取当前系统类型
      get_system_type() {
          if [ -f /etc/os-release ]; then
              . /etc/os-release
              if [ "$ID" == "centos" ]; then
                  echo "centos"
              elif [ "$ID" == "ubuntu" ]; then
                  echo "ubuntu"
              elif [ "$ID" == "debian" ]; then
                  echo "debian"
              else
                  echo "unknown"
              fi
          else
              echo "unknown"
          fi
      }

      system_type=$(get_system_type)

      if [ "$system_type" == "unknown" ]; then
          echo "不支持的操作系统类型"
      else
          read -p "确定安装aaPanel吗？(Y/N): " choice
          case "$choice" in
              [Yy])
                  iptables_open
                  install wget
                  if [ "$system_type" == "centos" ]; then
                      yum install -y wget && wget -O install.sh http://www.aapanel.com/script/install_6.0_en.sh && bash install.sh aapanel
                  elif [ "$system_type" == "ubuntu" ]; then
                      wget -O install.sh http://www.aapanel.com/script/install-ubuntu_6.0_en.sh && bash install.sh aapanel
                  elif [ "$system_type" == "debian" ]; then
                      wget -O install.sh http://www.aapanel.com/script/install-ubuntu_6.0_en.sh && bash install.sh aapanel
                  fi
                  ;;
              [Nn]) ;;
                 *) ;;
          esac
      fi
  fi

}

install_1panel() {
  if command -v 1pctl &> /dev/null; then
      clear
      echo "1Panel已安装，应用操作"
      echo ""
      echo "------------------------"
      echo "1. 查看1Panel信息           2. 卸载1Panel"
      echo "------------------------"
      echo "0. 返回上一级选单"
      echo "------------------------"
      read -p "请输入你的选择: " sub_choice

      case $sub_choice in
          1) clear && 1pctl user-info && 1pctl update password ;;
          2) clear && 1pctl uninstall ;;
          0) break ;;
          *) break ;;
      esac
  else
      clear
      echo "安装提示"
      echo "如果您已经安装了其他面板工具或者LDNMP建站环境，建议先卸载，再安装1Panel！"
      echo "会根据系统自动安装，支持Debian，Ubuntu，Centos"
      echo "官网介绍: https://1panel.cn/"
      echo ""
      # 获取当前系统类型
      get_system_type() {
        if [ -f /etc/os-release ]; then
          . /etc/os-release
          if [ "$ID" == "centos" ]; then
            echo "centos"
          elif [ "$ID" == "ubuntu" ]; then
            echo "ubuntu"
          elif [ "$ID" == "debian" ]; then
            echo "debian"
          else
            echo "unknown"
          fi
        else
          echo "unknown"
        fi
      }

      system_type=$(get_system_type)

      if [ "$system_type" == "unknown" ]; then
        echo "不支持的操作系统类型"
      else
        read -p "确定安装1Panel吗？(Y/N): " choice
        case "$choice" in
          [Yy])
            iptables_open
            install_docker
            if [ "$system_type" == "centos" ]; then
              curl -sSL https://resource.fit2cloud.com/1panel/package/quick_start.sh -o quick_start.sh && sh quick_start.sh
            elif [ "$system_type" == "ubuntu" ]; then
              curl -sSL https://resource.fit2cloud.com/1panel/package/quick_start.sh -o quick_start.sh && bash quick_start.sh
            elif [ "$system_type" == "debian" ]; then
              curl -sSL https://resource.fit2cloud.com/1panel/package/quick_start.sh -o quick_start.sh && bash quick_start.sh
            fi
            ;;
          [Nn]) ;;
             *) ;;
        esac
      fi
  fi
}

# 在Ubuntu22.04上安装可道云
# https://docs.kodcloud.com/setup/ubuntu/
install_kodbox(){
  # 安装信赖
  sudo apt update && sudo apt -y upgrade && \
  sudo apt install -y nginx mysql-server redis-server && \
  sudo apt install -y php php-fpm php-mysql php-gd php-redis php-mbstring php-curl php-xml php-zip php-json && \
  sudo systemctl disable apache2.service && \
  sudo systemctl enable nginx php8.1-fpm mysql redis-server

  sudo apt -y install imagemagick ffmpeg && \
  sudo sed -i '/PDF/s/none/read \| write/g' /etc/ImageMagick-6/policy.xml

  # touch /etc/nginx/sites-enabled/default
  cat > /etc/nginx/sites-enabled/default << EOF
listen 80;              ##访问端口
root /var/www/html;     #改成自己的站点目录
server_name _;          #访问域名 '_'代表任何域名都能访问

location ~ [^/]\.php(/|$) {
   try_files $uri =404;
   fastcgi_pass unix:/run/php/php8.1-fpm.sock;
   fastcgi_index index.php;
   set $path_info $fastcgi_path_info;
   set $real_script_name $fastcgi_script_name;  
   if ($fastcgi_script_name ~ "^(.+?\.php)(/.+)$") {
      set $real_script_name $1;
      set $path_info $2;
   }
   fastcgi_param SCRIPT_FILENAME $document_root$real_script_name;
   fastcgi_param SCRIPT_NAME $real_script_name;
   fastcgi_param PATH_INFO $path_info;
   include fastcgi_params;
}
EOF

  PHP_INI=/etc/php/8.1/fpm/php.ini
  PHP_FPM=/etc/php/8.1/fpm/pool.d/www.conf
  sed -i \
    -e "s/max_execution_time = 30/max_execution_time = 3600/g" \
    -e "s/max_input_time = 60/max_input_time = 3600/g" \
    -e "s/memory_limit = 128M/memory_limit = 512M/g" \
    -e "s/post_max_size = 8M/post_max_size = 512M/g" \
    -e "s/upload_max_filesize = 2M/upload_max_filesize = 512M/g" \
    ${PHP_INI}
  sed -i \
    -e "s/pm.max_children = 5/pm.max_children = 100/g" \
    -e "s/pm.start_servers = 2/pm.start_servers = 10/g" \
    -e "s/pm.min_spare_servers = 1/pm.min_spare_servers = 10/g" \
    -e "s/pm.max_spare_servers = 3/pm.max_spare_servers = 50/g" \
    -e "s/;pm.max_requests = 500/pm.max_requests = 500/g" \
    -e "s/;listen.mode = 0660/listen.mode = 0666/g" \
    ${PHP_FPM}
  sudo systemctl restart php8.1-fpm

  sudo mysql
  # mysql> ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password by 'xxxx';
  # mysql> quit

  # sudo mysql_secure_installation

  # mysql> CREATE USER 'username'@'localhost' IDENTIFIED BY 'password';
  # mysql> CREATE DATABASE IF NOT EXISTS kodbox CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
  # mysql> GRANT ALL PRIVILEGES ON kodbox.* TO 'username'@'localhost';
  # mysql> FLUSH PRIVILEGES;
  # mysql> quit

  # 安装KodBox
  sudo apt install -y unzip
  cd /var/www/html/
  sudo curl -L "https://api.kodcloud.com/?app/version&download=server.link" -o kodbox.zip
  sudo unzip kodbox.zip && sudo rm kodbox.zip
  sudo chown -R www-data:www-data /var/www/html
  sudo chmod -R 755 /var/www/html
  sudo systemctl restart nginx

  # 设置防火墙
  sudo ufw allow ssh
  sudo ufw allow http
  sudo ufw enable
}

# 安装苹果CMS网站
# https://github.com/magicblack/maccms_down
# https://github.com/magicblack/maccms10
# https://kejilion.blogspot.com/2023/06/3-cms.html
# https://www.youtube.com/watch?v=94u3wvJWKuA
# https://www.tweek.top/archives/1706060591396
# https://www.youtube.com/watch?v=AVorImTHH8Q
install_maccms(){
  
      # add_yuming
      # install_ssltls
      add_db

  wget -O /home/web/conf.d/$yuming.conf https://raw.githubusercontent.com/kejilion/nginx/main/maccms.com.conf
  sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf

  cd /home/web/html
  mkdir $yuming
  cd $yuming

  wget https://github.com/magicblack/maccms_down/raw/master/maccms10.zip && unzip maccms10.zip && rm maccms10.zip
  cd /home/web/html/$yuming/template/ && wget https://github.com/kejilion/Website_source_code/raw/main/DYXS2.zip && unzip DYXS2.zip && rm /home/web/html/$yuming/template/DYXS2.zip
  cp /home/web/html/$yuming/template/DYXS2/asset/admin/Dyxs2.php /home/web/html/$yuming/application/admin/controller
  cp /home/web/html/$yuming/template/DYXS2/asset/admin/dycms.html /home/web/html/$yuming/application/admin/view/system
  mv /home/web/html/$yuming/admin.php /home/web/html/$yuming/vip.php && wget -O /home/web/html/$yuming/application/extra/maccms.php https://raw.githubusercontent.com/kejilion/Website_source_code/main/maccms.php

  clear
  echo "您的苹果CMS搭建好了！"
  echo "https://$yuming"
  echo "------------------------"
  echo "安装信息如下: "
  echo "数据库地址: mysql"
  echo "数据库端口: 3306"
  echo "数据库名: $dbname"
  echo "用户名: $dbuse"
  echo "密码: $dbusepasswd"
  echo "数据库前缀: mac_"
  echo "------------------------"
  echo "安装成功后登录后台地址"
  echo "https://$yuming/vip.php"
  # nginx_status
}

# 站点工具菜单
website_tools_menu() {
echo -e "
▶ 面板工具
${plain}-------------------------------
${green} 1.${yellow}1Panel(新一代管理面板)
${green} 2.${plain}aaPanel(宝塔国际版)
${green} 3.${plain}宝塔面板(官方版)
${green} 4.${plain}NginxProxyManager(NPM)
${green} 5.${cyan}哪吒探针(VPS监控面板)
${plain}-------------------------------
${green}11.${plain}Ubuntu远程桌面网页版(Docker)
${green}12.${plain}AuroPanel极光面板(Docker)
${green}13.${plain}Portainer容器管理面板(Docker)
${green}14.${plain}Memos网页备忘录(Docker)
${green}15.${plain}QBittorrent-BT下载面板(Docker)
${green}16.${plain}RocketChat在线聊天系统(Docker)
${green}17.${plain}SearXNG聚合搜索站(Docker)
${green}18.${plain}StirlingPDF工具大全(Docker)
${green}19.${plain}IT-Tools常用工具(Docker)
${green}20.${plain}Next-Terminal资产管理(Docker)
${plain}-------------------------------
${green}61.${cyan}AList多存储文件列表程序
${green}62.${cyan}VScode-Server网页版
${green}63.${cyan}KodBox可道云在线桌面
${green}64.${cyan}ChatGPT-Next-Web
${green}65.${cyan}苹果CMS网站
${green}66.${cyan}苹果CMS网站(Docker)
${plain}-------------------------------
${green} 0.${plain} 返回主菜单
"
}

# 面板工具
website_tools_run(){
  while true; do
    clear && website_tools_menu
    read -p "请输入你的选择: " sub_choice

    case $sub_choice in
      1) clear && install_1panel  ;;
      2) clear && install__baota_aa ;;
      3) clear && install_baota_cn ;;
      4) 
        clear 
        docker_name="npm"
        docker_img="jc21/nginx-proxy-manager:latest"
        docker_port=81
        docker_rum="docker run -d \
                      --name=$docker_name \
                      -p 80:80 \
                      -p 81:$docker_port \
                      -p 443:443 \
                      -v /home/docker/npm/data:/data \
                      -v /home/docker/npm/letsencrypt:/etc/letsencrypt \
                      --restart=always \
                      $docker_img"
        docker_describe="如果您已经安装了其他面板工具或者LDNMP建站环境，建议先卸载，再安装npm！"
        docker_url="官网介绍: https://nginxproxymanager.com/"
        docker_use="echo \"初始用户名: admin@example.com\""
        docker_passwd="echo \"初始密码: changeme\""
        docker_app
        ;;

      5) clear && install curl && curl -L https://raw.githubusercontent.com/naiba/nezha/master/script/install.sh  -o nezha.sh && chmod +x nezha.sh && ./nezha.sh  ;;
     11) 
        clear 
        docker_name="ubuntu-novnc"
        docker_img="fredblgr/ubuntu-novnc:20.04"
        docker_port=6080
        rootpasswd=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c16)
        docker_rum="docker run -d \
                            --name ubuntu-novnc \
                            -p 6080:80 \
                            -v /home/docker/ubuntu-novnc:/workspace:rw \
                            -e HTTP_PASSWORD=$rootpasswd \
                            -e RESOLUTION=1280x720 \
                            --restart=always \
                            fredblgr/ubuntu-novnc:20.04"
        docker_describe="一个网页版Ubuntu远程桌面，挺好用的！"
        docker_url="官网介绍: https://hub.docker.com/r/fredblgr/ubuntu-novnc"
        docker_use="echo \"用户名: root\""
        docker_passwd="echo \"密码: $rootpasswd\""
        docker_app
        ;;

     12) clear && install curl && bash <(curl -fsSL https://raw.githubusercontent.com/Aurora-Admin-Panel/deploy/main/install.sh)  ;;

     13) 
        clear 
        docker_name="portainer"
        docker_img="portainer/portainer"
        docker_port=9050
        docker_rum="docker run -d \
                --name portainer \
                -p 9050:9000 \
                -v /var/run/docker.sock:/var/run/docker.sock \
                -v /home/docker/portainer:/data \
                --restart always \
                portainer/portainer"
        docker_describe="portainer是一个轻量级的docker容器管理面板"
        docker_url="官网介绍: https://www.portainer.io/"
        docker_use=""
        docker_passwd=""
        docker_app
        ;;

     14) 
      clear 
      docker_name="memos"
      docker_img="ghcr.io/usememos/memos:latest"
      docker_port=5230
      docker_rum="docker run -d --name memos -p 5230:5230 -v /home/docker/memos:/var/opt/memos --restart always ghcr.io/usememos/memos:latest"
      docker_describe="Memos是一款轻量级、自托管的备忘录中心"
      docker_url="官网介绍: https://github.com/usememos/memos"
      docker_use=""
      docker_passwd=""
      docker_app
      ;;

     15) 
        docker_name="qbittorrent"
        docker_img="lscr.io/linuxserver/qbittorrent:latest"
        docker_port=8081
        docker_rum="docker run -d \
                              --name=qbittorrent \
                              -e PUID=1000 \
                              -e PGID=1000 \
                              -e TZ=Etc/UTC \
                              -e WEBUI_PORT=8081 \
                              -p 8081:8081 \
                              -p 6881:6881 \
                              -p 6881:6881/udp \
                              -v /home/docker/qbittorrent/config:/config \
                              -v /home/docker/qbittorrent/downloads:/downloads \
                              --restart unless-stopped \
                              lscr.io/linuxserver/qbittorrent:latest"
        docker_describe="qbittorrent离线BT磁力下载服务"
        docker_url="官网介绍: https://hub.docker.com/r/linuxserver/qbittorrent"
        docker_use="sleep 3"
        docker_passwd="docker logs qbittorrent"

        docker_app
        ;;
     16) 
      clear 
      if docker inspect rocketchat &>/dev/null; then
              clear
              echo "rocket.chat已安装，访问地址: "
              ip_address
              echo "http:$ipv4_address:3897"
              echo ""

              echo "应用操作"
              echo "------------------------"
              echo "1. 更新应用             2. 卸载应用"
              echo "------------------------"
              echo "0. 返回上一级选单"
              echo "------------------------"
              read -p "请输入你的选择: " sub_choice

              case $sub_choice in
                  1)
                      clear
                      docker rm -f rocketchat
                      docker rmi -f rocket.chat:6.3


                      docker run --name rocketchat --restart=always -p 3897:3000 --link db --env ROOT_URL=http://localhost --env MONGO_OPLOG_URL=mongodb://db:27017/rs5 -d rocket.chat

                      clear
                      ip_address
                      echo "rocket.chat已经安装完成"
                      echo "------------------------"
                      echo "多等一会，您可以使用以下地址访问rocket.chat:"
                      echo "http:$ipv4_address:3897"
                      echo ""
                      ;;
                  2)
                      clear
                      docker rm -f rocketchat
                      docker rmi -f rocket.chat
                      docker rmi -f rocket.chat:6.3
                      docker rm -f db
                      docker rmi -f mongo:latest
                      # docker rmi -f mongo:6
                      rm -rf /home/docker/mongo
                      echo "应用已卸载"
                      ;;
                  0)
                      break  # 跳出循环，退出菜单
                      ;;
                  *)
                      break  # 跳出循环，退出菜单
                      ;;
              esac
      else
          clear
          echo "安装提示"
          echo "rocket.chat国外知名开源多人聊天系统"
          echo "官网介绍: https://www.rocket.chat"
          echo ""

          # 提示用户确认安装
          read -p "确定安装rocket.chat吗？(Y/N): " choice
          case "$choice" in
              [Yy])
              clear
              install_docker
              docker run --name db -d --restart=always \
                  -v /home/docker/mongo/dump:/dump \
                  mongo:latest --replSet rs5 --oplogSize 256
              sleep 1
              docker exec -it db mongosh --eval "printjson(rs.initiate())"
              sleep 5
              docker run --name rocketchat --restart=always -p 3897:3000 --link db --env ROOT_URL=http://localhost --env MONGO_OPLOG_URL=mongodb://db:27017/rs5 -d rocket.chat:6.3

              clear

              ip_address
              echo "rocket.chat已经安装完成"
              echo "------------------------"
              echo "多等一会，您可以使用以下地址访问rocket.chat:"
              echo "http:$ipv4_address:3897"
              echo ""

                  ;;
              [Nn])
                  ;;
              *)
                  ;;
          esac
      fi
      ;;

     17) 
      clear 
      docker_name="searxng"
      docker_img="alandoyle/searxng:latest"
      docker_port=8700
      docker_rum="docker run --name=searxng \
                      -d --init \
                      --restart=unless-stopped \
                      -v /home/docker/searxng/config:/etc/searxng \
                      -v /home/docker/searxng/templates:/usr/local/searxng/searx/templates/simple \
                      -v /home/docker/searxng/theme:/usr/local/searxng/searx/static/themes/simple \
                      -p 8700:8080/tcp \
                      alandoyle/searxng:latest"
      docker_describe="searxng是一个私有且隐私的搜索引擎站点"
      docker_url="官网介绍: https://hub.docker.com/r/alandoyle/searxng"
      docker_use=""
      docker_passwd=""
      docker_app
      ;;

     18) 
      clear
      docker_name="s-pdf"
      docker_img="frooodle/s-pdf:latest"
      docker_port=8020
      docker_rum="docker run -d \
                      --name s-pdf \
                      --restart=always \
                        -p 8020:8080 \
                        -v /home/docker/s-pdf/trainingData:/usr/share/tesseract-ocr/5/tessdata \
                        -v /home/docker/s-pdf/extraConfigs:/configs \
                        -v /home/docker/s-pdf/logs:/logs \
                        -e DOCKER_ENABLE_SECURITY=false \
                        frooodle/s-pdf:latest"
      docker_describe="这是一个强大的本地托管基于 Web 的 PDF 操作工具，使用 docker，允许您对 PDF 文件执行各种操作，例如拆分合并、转换、重新组织、添加图像、旋转、压缩等。"
      docker_url="官网介绍: https://github.com/Stirling-Tools/Stirling-PDF"
      docker_use=""
      docker_passwd=""
      docker_app
      ;;
      
     19) 
      clear 
      docker run -d --name it-tools --restart unless-stopped -p 8080:80 corentinth/it-tools:latest
      # docker run -d --name it-tools --restart unless-stopped -p 8080:80 ghcr.io/corentinth/it-tools:latest
      ;;

     20) 
      clear
      cd ~
      mkdir next-terminal-docker && cd next-terminal-docker
      curl -sSL https://f.typesafe.cn/next-terminal/docker-compose.yml > docker-compose.yml
      # curl -sSL https://f.typesafe.cn/next-terminal/aliyuns/docker-compose.yml > docker-compose.yml # 阿里镜像
      docker-compose up -d
      cd ~
      ;;

     61) clear && install curl && curl -fsSL "https://alist.nn.ci/v3.sh" | bash -s install  ;;
     62) clear && install curl && curl -fsSL https://code-server.dev/install.sh | sh  ;;
     63) clear && install_kodbox  ;;   
     64) clear && install curl && bash <(curl -s https://raw.githubusercontent.com/Yidadaa/ChatGPT-Next-Web/main/scripts/setup.sh) ;;
     65) clear && install_maccms ;;
     66) clear && install_maccms ;;

      0) qiqtools ;;
     99) echo -e "重新启动系统，SSH连接将断开..." && reboot && exit ;;
      *) echo "无效的输入!" ;;
    esac
    break_end
  done

}

other_tools_menu() {
echo -e "
▶ 其他工具
-------------------------------
${green} 1.${plain} Docker
${green} 2.${plain} Python
${green} 3.${plain} Conda
${green} 4.${plain} RustDesk Server
-------------------------------
${green} 0.${plain} 返回主菜单
-------------------------------
"
}

other_tools_run() {
  while true; do
    clear && other_tools_menu
    reading "请选择代码: " choice

    case $choice in
      1) clear && install curl && curl -fsSL https://get.docker.com | sh ;;
      2) clear && install_python ;;
      3) 
        clear 
        if [[ $(uname -m | grep 'arm') != "" ]]; then 
          wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh && bash Miniconda3-latest-Linux-aarch64.sh
        else
          wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && bash Miniconda3-latest-Linux-x86_64.sh 
        fi 
        ;;
      4) clear && install wget && wget https://raw.githubusercontent.com/dinger1986/rustdeskinstall/master/install.sh && chmod +x install.sh && ./install.sh ;;

      0) qiqtools ;;
      *) echo "无效的输入!" ;;
    esac  
    break_end
  done 
}

warp_tools_menu() {
echo -e "
▽ 节点管理 ${blue}✈✈✈${plain}
${plain}==============================================================
${yellow} 1.${plain} ${yellow}Warp(@fscarmen)                  ${green}11.${plain} XRay(@233boy)
${green} 2.${plain} Warp(@hamid-gh98)                ${green}12.${plain} V2Ray(@233boy)
${green} 3.${plain} Warp(@Misaka-blog)               ${green}13.${plain} V2Ray-Agent(@mack-a)
${green} 4.${plain} ArgoX(@fscarmen)                 ${green}14.${plain} Hysteria2(@Misaka)
${green} 5.${plain} ${cyan}SingBox四合一(@ygkkk)            ${green}15.${plain} TUIC5(@Misaka)
${yellow} 6.${plain} ${yellow}SingBox全家桶(@fscarmen)         ${green}16.${plain} mianyang()
${green} 7.${plain} ${plain}SingBox-Argox(@fscarmen)
${plain}--------------------------------------------------------------
${green}51.${plain} ${yellow}XRayR(@XrayR-project)            ${green}61.${plain} Set Github(For IPv6 VPS)
${green}52.${plain} XRayR(@wyx2685)                  ${green}62.${plain} Cloudflare Select IP
${green}53.${plain} XRayR-Docker(@XrayR-project)     ${green}63.${plain} Cloudflare Select CDN
${green}54.${plain} ${blue}Bodhi(Hysteria2 to V2board)      ${green}64.${plain} YACD(Yet another Clash Dashboard)
${yellow}55.${plain} ${yellow}V2bX(Vless&Trojan to V2board)    ${green}65.${plain} ClashDashBoard
${plain}--------------------------------------------------------------
${green}91.${plain} Show IP(ip.sb)                   ${green}95.${plain} Check-OpenAI(检测OpenAI解锁)
${green}92.${plain} Show IPv4(ip addr | grep...)     ${green}96.${plain} Check-Region(检测区域媒体解锁)
${green}93.${plain} Show IPv6(ip addr | grep...)     ${green}97.${plain} Cloudflare(IPv4)
${green}94.${plain} Set GitHUB(IPv6)                 ${green}98.${plain} Cloudflare(IPv6)    
${plain}==============================================================
${green} 0.${plain} 返回主菜单
"
}

warp_tools_run() {
  while true; do
    clear && warp_tools_menu
    reading "请选择代码: " choice
    
    case $choice in
      1) clear && install wget && wget -N https://gitlab.com/fscarmen/warp/-/raw/main/menu.sh && bash menu.sh [option] [lisence/url/token] ;;
      2) clear && bash <(curl -sSL https://raw.githubusercontent.com/hamid-gh98/x-ui-scripts/main/install_warp_proxy.sh) ;;
      3) clear && wget -N https://gitlab.com/Misaka-blog/warp-script/-/raw/main/warp.sh && bash warp.sh ;;
      4) clear && bash <(wget -qO- https://raw.githubusercontent.com/fscarmen/argox/main/argox.sh)  ;;
      5) clear && bash <(curl -Ls https://gitlab.com/rwkgyg/sing-box-yg/raw/main/sb.sh)  ;;
      6) clear && bash <(wget -qO- https://raw.githubusercontent.com/fscarmen/sing-box/main/sing-box.sh) ;;
      7) clear && bash <(wget -qO- https://raw.githubusercontent.com/fscarmen/sba/main/sba.sh) ;;
      # 8) clear && bash <(wget -qO- https://raw.githubusercontent.com/fscarmen/argox/main/argox.sh) ;;

     11) clear && bash <(wget -qO- -o- https://github.com/233boy/Xray/raw/main/install.sh) ;;
     12) clear && bash <(wget -qO- -o- https://git.io/v2ray.sh) ;;
     13) clear && wget -P /root -N --no-check-certificate "https://raw.githubusercontent.com/mack-a/v2ray-agent/master/install.sh" && chmod 700 /root/install.sh && /root/install.sh ;;
     14) clear && wget -N --no-check-certificate https://raw.githubusercontent.com/Misaka-blog/hysteria-install/main/hy2/hysteria.sh && bash hysteria.sh ;;
     15) clear && wget -N --no-check-certificate https://gitlab.com/Misaka-blog/tuic-script/-/raw/main/tuic.sh && bash tuic.sh ;;
     16) clear && bash <(curl -fsSL https://github.com/vveg26/sing-box-reality-hysteria2/raw/main/beta.sh) ;;

     51) clear && wget -N https://raw.githubusercontent.com/XrayR-project/XrayR-release/master/install.sh && bash install.sh && cd /etc/XrayR ;;
     52) clear && wget -N https://raw.githubusercontent.com/wyx2685/XrayR-release/master/install.sh && bash install.sh ;;
     53) clear && cd ~ && git clone https://github.com/XrayR-project/XrayR-release xrayr && cd xrayr ;;
     54) clear && cd ~ && git clone https://github.com/lotusnetwork/bodhi-docker.git && cd bodhi-docker ;;
     55) clear && wget -N https://raw.githubusercontent.com/wyx2685/V2bX-script/master/install.sh && bash install.sh ;;

     61) clear && echo -e "nameserver 2001:67c:2b0::4\nnameserver 2001:67c:2b0::6" > /etc/resolv.conf ;;
     62) clear && cd ~ && curl -sSL https://gitlab.com/rwkgyg/CFwarp/raw/main/point/cfip.sh -o cfip.sh && chmod +x cfip.sh && bash cfip.sh ;;
     63) clear && cd ~ && curl -sSL https://gitlab.com/rwkgyg/CFwarp/raw/main/point/CFcdnym.sh -o CFcdnym.sh && chmod +x CFcdnym.sh && bash CFcdnym.sh ;;
     64) clear && docker run -p 1234:80 -d --name yacd --rm ghcr.io/haishanh/yacd:master ;;
     65) clear && echo -e "\n Todo: ... \n" ;;

     91) echo -e "\nIP: $(curl -s ip.sb)\n"  ;;
     92) echo -e "\n$(ip addr | grep "inet ")\n"  ;;
     93) echo -e "\n$(ip addr | grep "inet6")\n"  ;;
     94) echo -e "nameserver 2001:67c:2b0::4\nnameserver 2001:67c:2b0::6" > /etc/resolv.conf ;;

     95) clear && bash <(curl -Ls https://cdn.jsdelivr.net/gh/missuo/OpenAI-Checker/openai.sh) ;;
     96) clear && bash <(curl -Ls check.unlock.media) ;;
     97) clear && curl -s4m5 https://www.cloudflare.com/cdn-cgi/trace ;;
     98) clear && curl -s6m5 https://www.cloudflare.com/cdn-cgi/trace ;;

      0) qiqtools ;;
      *) echo "无效的输入!" ;;
    esac  
    break_end
  done 

}

board_tools_menu() {
echo -e "
▶ 面板管理
${plain}-------------------------------
${green}21.${plain} ${blue}3X-UI(@mhsanaei)                   ${green}31.${plain} Hiddify
${green}22.${plain} ${yellow}X-UI(@alireza0)                    ${green}32.${plain} V2RayA
${green}23.${plain} X-UI(@FranzKafkaYu)                ${green}33.${plain} Daed
${green}24.${plain} X-UI(@rwkgyg)                      ${green}34.${plain} Daed-Docker
${green}25.${plain} S-UI(@alireza0)
${plain}-------------------------------
${green}41.${plain} XBoard                             ${green}44.${plain} LotusBoard
${green}42.${plain} V2Board                            ${green}45.${plain} SSPanel
${green}43.${plain} V2Board(wyx2685)                   ${green}46.${plain} Proxypanel
${plain}-------------------------------
${green} 0.${plain} 返回主菜单
${plain}-------------------------------
"
}

board_tools_run() {
  while true; do
    clear && board_tools_menu
    reading "请选择面板代码: " choice
    
    case $choice in
     21) clear && bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh) ;;
     22) clear && bash <(curl -Ls https://raw.githubusercontent.com/alireza0/x-ui/master/install.sh) ;;
     23) clear && bash <(curl -Ls https://raw.githubusercontent.com/FranzKafkaYu/x-ui/master/install.sh) ;;
     24) clear && bash <(curl -Ls https://gitlab.com/rwkgyg/x-ui-yg/raw/main/install.sh)  ;;
     25) clear && bash <(curl -Ls https://raw.githubusercontent.com/alireza0/s-ui/master/install.sh)  ;;

     31) clear && bash -c "$(curl -Lfo- https://raw.githubusercontent.com/hiddify/hiddify-config/main/common/download_install.sh)" ;;
     32) clear && echo -e "\n Todo: ... \n" ;;
     33) clear && sh -c "$(curl -sL https://github.com/daeuniverse/dae-installer/raw/main/installer.sh)" @ update-geoip update-geosite ;;
     34) clear && docker run -d --privileged --network=host --pid=host --restart=unless-stopped  -v /sys:/sys  -v /etc/daed:/etc/daed --name=daed ghcr.io/daeuniverse/daed:latest ;;

      0) qiqtools ;;
      *) echo "无效的输入!" ;;
    esac  
    break_end
  done 

}

docker_app() {
if docker inspect "$docker_name" &>/dev/null; then
    clear
    echo "$docker_name 已安装，访问地址: "
    ip_address
    echo "http://$ipv4_address:$docker_port"
    echo "http://[$ipv6_address]:$docker_port"
    echo ""
    echo "应用操作"
    echo "------------------------"
    echo "1. 更新应用             2. 卸载应用"
    echo "------------------------"
    echo "0. 返回上一级选单"
    echo "------------------------"
    read -p "请输入你的选择: " sub_choice

    case $sub_choice in
        1)
            clear
            docker rm -f "$docker_name"
            docker rmi -f "$docker_img"

            $docker_rum
            clear
            echo "$docker_name 已经安装完成"
            echo "------------------------"
            # 获取外部 IP 地址
            ip_address
            echo "您可以使用以下地址访问:"
            echo "http:$ipv4_address:$docker_port"
            $docker_use
            $docker_passwd
            ;;
        2)
            clear
            docker rm -f "$docker_name"
            docker rmi -f "$docker_img"
            rm -rf "/home/docker/$docker_name"
            echo "应用已卸载"
            ;;
        0)
            # 跳出循环，退出菜单
            ;;
        *)
            # 跳出循环，退出菜单
            ;;
    esac
else
    clear
    echo "安装提示"
    echo "$docker_describe"
    echo "$docker_url"
    echo ""

    # 提示用户确认安装
    read -p "确定安装吗？(Y/N): " choice
    case "$choice" in
        [Yy])
            clear
            # 安装 Docker（请确保有 install_docker 函数）
            install_docker
            $docker_rum
            clear
            echo "$docker_name 已经安装完成"
            echo "------------------------"
            # 获取外部 IP 地址
            ip_address
            echo "您可以使用以下地址访问:"
            echo "http://$ipv4_address:$docker_port"
            echo "http://[$ipv6_address]:$docker_port"
            echo "------------------------"
            $docker_use
            $docker_passwd
            ;;
        [Nn])
            # 用户选择不安装
            ;;
        *)
            # 无效输入
            ;;
    esac
fi

}

docker_menu() {
echo -e "
▶ 容器管理
-------------------------------
${green} 1.${plain} Docker环境安装
${green} 2.${plain} Docker环境卸载
${green} 3.${plain} Docker查看状态
${green} 4.${plain} Docker清理
-------------------------------        
${green} 5.${plain} Docker容器管理 ▶  
${green} 6.${plain} Docker镜像管理 ▶  
${green} 7.${plain} Docker网络管理 ▶  
${green} 8.${plain} Docker卷管理  ▶
-------------------------------
${green} 9.${plain} 设置docker-compose快捷键[默认为: ${yellow}dcc${plain}]
-------------------------------
${green} 0.${plain} 返回主菜单
-------------------------------
"
}

docker_run() {
  while true; do
    clear && docker_menu
    reading "请选择: " choice

    case $choice in
      1) clear && install_add_docker ;;
      2) 
        clear
        read -p "确定卸载docker环境吗？(Y/N): " choice
        case "$choice" in
          [Yy])
            docker rm $(docker ps -a -q) && docker rmi $(docker images -q) && docker network prune
            remove docker docker-ce docker-compose > /dev/null 2>&1
            ;;
          [Nn])
            ;;
          *)
            echo "无效的选择，请输入 Y 或 N。"
            ;;
        esac
        ;;
      3) 
        clear
        echo "Dcoker版本"
        docker --version
        docker-compose --version
        echo ""
        echo "Dcoker镜像列表"
        docker image ls
        echo ""
        echo "Dcoker容器列表"
        docker ps -a
        echo ""
        echo "Dcoker卷列表"
        docker volume ls
        echo ""
        echo "Dcoker网络列表"
        docker network ls
        echo ""
        ;;
      4)
        clear
        read -p "确定清理无用的镜像容器网络吗？(Y/N): " choice
        case "$choice" in
          [Yy]) docker system prune -af --volumes ;;
          [Nn]) ;;
          *) echo "无效的选择，请输入 Y 或 N。" ;;
        esac
        ;;
      9) clear && chmod a+x /usr/local/bin/docker-compose && rm -rf `which dcc` && ln -s /usr/local/bin/docker-compose /usr/bin/dcc ;;
      0) qiqtools ;;
      *) echo "无效的输入!" ;;
    esac  
    break_end    
  done 

}


check_port() {
    # 定义要检测的端口
    PORT=443

    # 检查端口占用情况
    result=$(ss -tulpn | grep ":$PORT")

    # 判断结果并输出相应信息
    if [ -n "$result" ]; then
        is_nginx_container=$(docker ps --format '{{.Names}}' | grep 'nginx')

        # 判断是否是Nginx容器占用端口
        if [ -n "$is_nginx_container" ]; then
            echo ""
        else
            clear
            echo -e "\e[1;31m端口 $PORT 已被占用，无法安装环境，卸载以下程序后重试！\e[0m"
            echo "$result"
            break_end
            qiqtools
        fi
    else
        echo ""
    fi
}

add_yuming() {
  # ip_address
  echo -e "先将域名解析到本机IP: ${red}$ipv4_address  $ipv6_address${plain}"
  read -p "请输入你解析的域名: " yuming
}

# 反代域名
reverse_proxy() {
      # ip_address
      wget -O /home/web/conf.d/$yuming.conf https://raw.githubusercontent.com/kejilion/nginx/main/reverse-proxy.conf
      sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf
      sed -i "s/0.0.0.0/$ipv4_address/g" /home/web/conf.d/$yuming.conf
      sed -i "s/0000/$duankou/g" /home/web/conf.d/$yuming.conf
      docker restart nginx
}

# 安装PHP8.3
install_php83(){
  apt insstall sudo && sudo apt update && sudo apt upgrade -y && sudo apt install -y ca-certificates apt-transport-https software-properties-common lsb-release && sudo add-apt-repository ppa:ondrej/php -y && sudo apt update && sudo apt install -y php8.3 php8.3-fpm php8.3-cli && sudo systemctl enable php8.3-fpm --now

  # 安装PHP8.3-extentions
  # sudo apt install -y php8.3-{cli,fpm,curl,mysql,gd,opcache,zip,intl,common,bcmath,imagick,xmlrpc,readline,memcached,redis,mbstring,apcu,xml,dom,memcache}

  # php --version
  # php -m
}

# 安装PHP7.4
install_php74(){
  sudo apt update && sudo -y apt install software-properties-common && sudo add-apt-repository ppa:ondrej/php && sudo apt -y install php7.4 php7.4-cli php7.4-fpm php7.4-mysql php7.4-curl php7.4-gd php7.4-zip php7.4-xsl php7.4-mbstring php7.4-xml php7.4-xmlrpc php7.4-opcache

  # sudo apt-get autoremove php*
  # sudo add-apt-repository ppa:apt-fast/stable && sudo -y apt install apt-fast && sudo add-apt-repository ppa:ondrej/php && sudo apt-get update && sudo apt-fast -y install php7.4 && sudo -y apt-fast install php7.4-dev && sudo -y apt-fast install php-pear && sudo -y apt-fast install php7.4-fpm php7.4-mysql php7.4-curl php7.4-json php7.4-mbstring php7.4-xml php7.4-intl

  # php --version
  # php -m
}

mariadb_install(){
  apt install apt-transport-https curl
  mkdir -p /etc/apt/keyrings
  curl -o /etc/apt/keyrings/mariadb-keyring.pgp 'https://mariadb.org/mariadb_release_signing_key.pgp'

  cat > /etc/apt/sources.list.d/mariadb.sources << EOF
X-Repolib-Name: MariaDB
Types: deb
# deb.mariadb.org is a dynamic mirror if your preferred mirror goes offline. See https://mariadb.org/mirrorbits/ for details.
URIs: https://deb.mariadb.org/11.2/ubuntu
Suites: jammy
Components: main main/debug
Signed-By: /etc/apt/keyrings/mariadb-keyring.pgp
EOF

  apt update
  apt install mariadb-server
  systemctl start mariadb
  systemctl enable mariadb
  mariadb-secure-installation

}

redis_install(){
  curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list

  apt update
  apt install redis
  systemctl start redis-server
  systemctl enable redis-server

}

nginx_docker(){
  docker rm -f nginx >/dev/null 2>&1
  docker rmi nginx nginx:alpine >/dev/null 2>&1
  docker run -d --name nginx --restart always -p 80:80 -p 443:443 -p 443:443/udp -v /home/web/nginx.conf:/etc/nginx/nginx.conf -v /home/web/conf.d:/etc/nginx/conf.d -v /home/web/certs:/etc/nginx/certs -v /home/web/html:/var/www/html -v /home/web/log/nginx:/var/log/nginx nginx:alpine
}

nginx_install(){
  # apt install curl gnupg2 ca-certificates lsb-release ubuntu-keyring
  # curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
  # echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx" | sudo tee /etc/apt/sources.list.d/nginx.list
  # echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" | sudo tee /etc/apt/preferences.d/99nginx

  # apt update
  # apt install nginx
  
  # systemctl start nginx
  # systemctl enable nginx
  
  apt install sudo && sudo apt install -y curl gnupg2 ca-certificates lsb-release ubuntu-keyring && curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null && echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx" | sudo tee /etc/apt/sources.list.d/nginx.list && echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" | sudo tee /etc/apt/preferences.d/99nginx && sudo apt update && sudo apt install -y nginx && systemctl start nginx && systemctl enable nginx

}

openresty_install(){ echo -e "OpenResty installation is not implemented...";}

caddy_install(){
  # 准备目录和主页文件
  mkdir -p /home/web/{caddy,html}
  # touch /home/web/caddy/Caddyfile
  # touch /home/web/html/index.html
  wget -O /home/web/html/index.html https://gitlab.com/lmzxtek/qiqtools/-/raw/main/src/caddy/index.html
  wget -O /home/web/caddy/default.conf https://gitlab.com/lmzxtek/qiqtools/-/raw/main/src/caddy/default.conf

  sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https curl && curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg && curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list && sudo apt update && sudo apt install -y caddy

  # 安装Caddy
  # sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https curl
  # curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
  # curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list

  # sudo apt update
  # sudo apt install caddy

}

caddy_uninstall(){ echo -e "\nUninstall Caddy is not implemented...\n";}

# 反代
caddy_reproxy(){
  local domain=$1
  local reproxip=$2
  local report=$3
  cat > /home/web/caddy/$domain.conf << EOF
$domain {
    reverse_proxy $reproxip:$report
    encode gzip
}
EOF
}

# 重定向
caddy_redirect(){
  local domain=$1
  local redirurl=$2
  cat > /home/web/caddy/$domain.conf << EOF
$domain {
    redir $redirurl{uri}
}
EOF
}


# 静态网站
caddy_staticweb(){
  local domain=$1
  local rootpath=$2
  cat > /home/web/caddy/$domain.conf << EOF
$domain {
    root * $rootpath
    encode gzip
    file_server
}
EOF
}

# 更新域名信息
caddy_newcaddyfile(){
  if [ -z "$(find /home/web/caddy -name "*.conf")" ]; then
    echo "No .conf files found in /home/web/caddy"

  else
    mv /etc/caddy/Caddyfile /etc/caddy/Caddyfile.bak
    find /home/web/caddy -name "*.conf" -exec cat {} + > /etc/caddy/Caddyfile
  fi
}

caddy_reload(){  
  caddy_newcaddyfile

  # sudo systemctl stop caddy
  # cd /etc/caddy
  caddy reload
  # cd -
}

caddy_start(){
  # sudo systemctl stop caddy
  # cd /etc/caddy
  caddy start
  # caddy run
  # cd -
}

caddy_stop(){
  # sudo systemctl stop caddy
  # cd /etc/caddy
  caddy stop
  # cd -
}

caddy_status(){
  sudo systemctl status caddy
}

# 站点列表（不包含default.conf)
caddy_web_list(){
  # ls -t /home/web/caddy | grep -v "default.conf" | sed 's/\.[^.]*$//'
  dm_list=$(ls -t /home/web/caddy | grep -v "default.conf" | sed 's/\.[^.]*$//')

  # clear
  echo -e "\n >> ${red}站点列表\n${plain}-------------------------------\n"
  for dm_file in $dm_list; do
      printf "%-30s\n" "$dm_file"
  done
  echo -e "\n${plain}-------------------------------\n"
}

# 修改域名
caddy_change_domain(){
  read -p "请输入旧域名: " dm_old
  read -p "请输入新域名: " dm_new

  mv /home/web/caddy/$dm_old.conf /home/web/caddy/$dm_new.conf
  sed -i "s/$dm_old/$dm_new/g" /home/web/caddy/$dm_new.conf

  caddy_reload
}

# 给现有域名添加新的域名
caddy_add_domain(){
  read -p "请输入旧域名: " dm_old
  read -p "请输入新域名: " dm_new

  cp /home/web/caddy/$dm_old.conf /home/web/caddy/$dm_new.conf
  sed -i "s/$dm_old/$dm_new/g" /home/web/caddy/$dm_new.conf

  caddy_reload  
}

# 删除现有域名
caddy_delete_domain(){
  read -p "请输入要删除的域名: " dm_old
  rm /home/web/caddy/$dm_old.conf
  
  caddy_reload  
}

# 清理站点缓存
caddy_clean_cache(){
  echo "Caddy会自动清除过期的缓存条目。"
  # caddy adapt
}

caddy_version(){
  caddy_version=$(caddy -v)
  caddy_version=$(echo "$caddy_version" | grep -oP "caddy/\K[0-9]+\.[0-9]+\.[0-9]+")
  echo -n "Caddy : v$caddy_version"
}

# 站点管理菜单
caddy_web_menu(){

clear
# echo "Web站点"
# echo "------------------------"
# caddy_version 

echo -e "
▶ 站点目录
${plain}-------------------------------
${green} ${plain} 数据： /home/web/html 
${green} ${plain} 配置： /home/web/caddy
${plain}-------------------------------    

▶ 站点管理
${plain}-------------------------------
${green} 1.${plain} 查看站点列表
${green} 2.${plain} 查看分析报告
${green} 3.${plain} 更换站点域名
${green} 4.${plain} 添加站点域名
${green} 5.${plain} 删除指定站点
${green} 6.${plain} 清理站点缓存
${plain}-------------------------------    
${green} 0.${plain} 返回上一级菜单
${plain}-------------------------------    
"
}

# Web站点管理器
caddy_web_manager(){
  while true; do
      # caddy_web_list
      caddy_web_menu
      read -p "请输入你的选择: " sub_choice

      case $sub_choice in
          1) clear && caddy_web_list ;;
          2) clear && install goaccess && goaccess --log-format=COMBINED /home/web/log/caddy/access.log ;;
          3) clear && caddy_web_list && caddy_change_domain ;;
          4) clear && caddy_web_list && caddy_add_domain ;;
          5) clear && caddy_web_list && caddy_delete_domain ;;
          6) caddy_clean_cache ;;

          # 0) break ;; # 跳出循环，退出菜单
          0) LDNMP_run ;; # 跳出循环，退出菜单
          *) echo "无效的输入!" ;; # 跳出循环，退出菜单
      esac
      break_end
  done
}

# 网站管理菜单
LDNMP_menu() {
echo -e "
▼ Web站点管理✈️
${yellow}IPv4: ${white}$ipv4_address${plain}
${yellow}IPv6: ${white}$ipv6_address${plain}
${plain}-------------------------------
${green} 1.${plain}安装LDNMP环境(Todo...)   ${green} 3.${plain}更新LDNMP环境(Todo...)
${green} 2.${plain}卸载LDNMP环境(Todo...)   ${green} 4.${plain}优化LDNMP环境(Todo...)
${plain}-------------------------------     
${red}11.${yellow}安装Caddy          ${green}21.${plain}安装PHP8.3
${green}12.${plain}安装Nginx          ${green}22.${plain}安装PHP7.4
${green}13.${plain}安装OpenLiteSpeed  ${green}23.${plain}安装MariaDB
${green}14.${plain}查看状态          ${green}24.${plain}安装Redis
${yellow}-------------------------------  
${green}31.${plain}站点列表          ${green}41.${plain}重启服务
${green}32.${plain}站点管理          ${green}42.${plain}停止服务
${green}33.${plain}站点重定向        ${green}43.${plain}更新服务 
${red}34.${yellow}站点反向代理   ${green}44.${plain}删除服务(Todo...)
${green}35.${plain}自定义静态站点 ${green}
${yellow}-------------------------------   
${green}88.${plain}站点防御程序 (Todo...)
${plain}-------------------------------   
${green} 0.${plain}返回主菜单
-------------------------------
"
}

LDNMP_run(){

  if [ -d /etc/caddy ]; then
    cd /etc/caddy
  fi

  ip_address

  while true; do
    clear && LDNMP_menu
    reading "请选择: " choice

    case $choice in
     11) clear && caddy_install ;;
     12) 
        #  安装Nginx

        # nginx_docker
        nginx_install

        clear
        # nginx_version=$(docker exec nginx nginx -v 2>&1)
        nginx_version=$(nginx -v)
        nginx_version=$(echo "$nginx_version" | grep -oP "nginx/\K[0-9]+\.[0-9]+\.[0-9]+")
        echo "nginx已安装完成"
        echo "当前版本: v$nginx_version"
        # echo "当前版本: $(nginx -v)"
        echo ""
        ;;

    #  13) clear && openresty_install ;;
     13) 
      clear
      wget https://raw.githubusercontent.com/litespeedtech/ols1clk/master/ols1clk.sh && bash ols1clk.sh
      # bash <( curl -k https://raw.githubusercontent.com/litespeedtech/ols1clk/master/ols1clk.sh )
      echo ""
      echo -e " >>> 安装OpenLiteSpeed成功..."
      echo -e " >>> 设置用户名和密码：/usr/local/lsws/admin/misc/admpass.sh"
      ;;

     14) caddy_status ;;

     21) clear && install_php83 ;;
     22) clear && install_php74 ;;
     23) clear && mariadb_install ;;
     24) clear && redis_install ;;

     41) caddy_reload ;;
     42) caddy_start ;;
     43) caddy_stop ;;
     44) caddy_uninstall ;;

     31) caddy_web_list ;;
     32) caddy_web_manager ;;
     33)
        # ip_address
        add_yuming
        read -p "请输入跳转域名: " reverseproxy

        caddy_redirect $yuming $reverseproxy
        
        # caddy_newcaddyfile
        caddy_reload
        
        echo -e "\n您的重定向网站做好了！"
        echo "https://$yuming"
        echo ""
        ;;

     34)
        # ip_address
        add_yuming
        read -p "请输入你的反代IP: " reverseproxy
        read -p "请输入你的反代端口: " port 

        caddy_reproxy $yuming $reverseproxy $port
        
        # caddy_newcaddyfile
        caddy_reload
        
        echo -e "\n您的反向代理网站做好了！"
        echo "https://$yuming"
        echo ""
        ;;

     35)
        # ip_address
        add_yuming
        read -p "请输入web概目录: " rootpath 

        caddy_staticweb $yuming $rootpath

        # caddy_newcaddyfile
        caddy_reload
        
        echo -e "\n您的静态网站搭建好了！"
        echo "https://$yuming"
        echo ""
        ;;

      0) qiqtools ;;
      *) echo "无效的输入!" ;;
    esac  
    break_end    
  done 
}

# 脚本更新
script_update(){
  cd ~
  echo ""
  curl -sS -O https://gitlab.com/lmzxtek/qiqtools/-/raw/main/qiqtools.sh && chmod +x qiqtools.sh
  echo -e "脚本已更新到最新版本！\n"
  break_end #&& exit && qiq
  qiq_reload
}

# 显示主菜单
main_menu() {
cd ~

# echo -e "
# ${red}${bold}╭─╮ ┬╭─╮  ${plain}${blue}─┬─╭─╮╭─╮┬ ${plain}╭─╮${plain} 
# ${red}${bold}│ │ ││ │  ${plain}${blue} │ │ ││ ││ ${plain}╰─╮${plain}
# ${red}${bold}╰─┴╯┴╰─┴╯ ${plain}${blue} │ ╰─╯╰─╯╰─${plain}╰─╯${plain}
# ${yellow}${bold}QiQTools ${white}一键脚本工具 $script_version
# ${cyan}(支持Ubuntu|Debian|CentOS|Alpine系统)${plain}
# ${plain}♤♤  输入>> ${yellow}qiq ${plain}<<可快速启动此脚本  ♤♤
# ${cyan}✟${plain} 一键脚本 ${blue}QiQTools${plain}
# "

echo -e "
 ${green}  ░███     ${cyan}░████  ${green}  ░███   ${plain}
 ${green} ░██ ░██   ${cyan} ░██   ${green} ░██ ░██ ${plain}
 ${green}░██   ░██  ${cyan} ░██   ${green}░██   ░██${plain}
 ${green} ░██ ░██   ${cyan} ░██   ${green} ░██ ░██ ${plain}
 ${green}   ░██ ██  ${cyan}░████  ${green}   ░██ ██${plain}

${blue}─┬─╭─╮╭─╮┬ ╭─╮${plain}  
${blue} │ │ ││ ││ ╰─╮${plain}  
${blue} │ ╰─╯╰─╯╰─╰─╯${plain}  ${cyan}✟${plain} 快捷命令 ${cyan}☞ ${yellow}qiq${cyan} ☜${plain}
${white}=====================================${plain}
${green} 1${white}.${yellow}系统信息${red}☄${plain}       ${green}11${white}.${plain}容器管理${blue}❂${plain}
${green} 2${white}.${plain}系统更新${blue}☣${plain}       ${green}12${white}.${yellow}站点管理${yellow}❈${plain}
${green} 3${blue}.${plain}系统清理${blue}☢${plain}       ${green}13${white}.${plain}站点部署${blue}ஐ${plain}
${white}-------------------------------------${plain}
${green}21${white}.${plain}常用工具${blue}❃${plain}       ${green}31${white}.${plain}面板工具${blue}◈${plain}
${yellow}22${white}.${yellow}系统工具${yellow}❁${plain}       ${green}32${white}.${plain}其他工具${blue}☃${plain}
${cyan}23${white}.${cyan}节点工具${yellow}✈ ${red}warp${plain}
${white}-------------------------------------${plain}
${green}99.${plain}重启系统${blue}❂${plain}       ${green}00.${plain}脚本更新${blue}♨${plain}
${white}=====================================${plain}
${green} 0.${plain}退出脚本${red}✖${plain}       ${green}♧♧ ${blue}QiQTools ${plain}$script_version${plain}
"
}

# ${plain}----------------
# ${green}12${white}.${plain} 我的工作区 ▶ (Todo...)
# ${green}13${white}.${plain} 测试脚本合集 ▶ (Todo...)
# ${green}14${white}.${plain} 甲骨文云脚本合集 ▶ (Todo...)

# Main Loops for the scripts
main_loop(){
while true; do 
  clear && main_menu 
  reading "请输入你的选择: " choice

  case $choice in
     1) clear && get_sysinfo && show_info ;;
     2) clear && update_and_upgrade ;;
     3) clear && clean_sys ;;

    11) docker_run ;;
    12) clear && LDNMP_run ;;
    13) website_tools_run  ;;

    21) common_apps_run  ;;
    22) system_tools_run ;;
    23) warp_tools_run   ;;

    31) board_tools_run  ;;
    32) other_tools_run  ;;

    00) script_update ;;
    99) echo "正在重启服务器，即将断开SSH连接" && reboot  ;;
     0) exit ;;
     *) echo "无效的输入!" ;;
  esac  
  break_end
done
}

main_loop