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
dd_system_menu() {
echo -e "
▶ 可选系统菜单
-------------------------------
${green} 1.${plain} Debian 12
${green} 2.${plain} Debian 11
${green} 3.${plain} Debian 10
${green} 4.${plain} Ubuntu 22.04
${green} 5.${plain} Ubuntu 20.04
${green} 6.${plain} CentOS 7.9
${green} 7.${plain} Alpine 3.19
${green} 8.${plain} Windows 11 ${pink}Beta${plain}
-------------------------------
"
}

dd_xitong_1() {
  reading "请输入你重装后的密码: " vpspasswd
  install wget
  bash <(wget --no-check-certificate -qO- 'https://raw.githubusercontent.com/MoeClub/Note/master/InstallNET.sh') $xitong -v 64 -p $vpspasswd -port 22
}

dd_xitong_2() {
  install wget
  wget --no-check-certificate -qO InstallNET.sh 'https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/InstallNET.sh' && chmod a+x InstallNET.sh
}

dd_system_run() {
  while true; do
    clear && dd_system_menu
    reading "请选择要重装的系统: " sys_choice

    case "$sys_choice" in
      1) 
        xitong="-d 12" 
        dd_xitong_1 
        exit 
        reboot 
        ;;
      2) 
        xitong="-d 11" 
        dd_xitong_1 
        reboot 
        exit ;;
      3) 
        xitong="-d 10" 
        dd_xitong_1 
        reboot 
        exit ;;
      4) 
        dd_xitong_2 
        bash InstallNET.sh -ubuntu 
        reboot 
        exit ;;
      5) 
        xitong="-u 20.04" 
        dd_xitong_1 
        reboot 
        exit ;;
      6) 
        dd_xitong_2 
        bash InstallNET.sh -centos 7 
        reboot 
        exit ;;
      7) 
        dd_xitong_2 
        bash InstallNET.sh -alpine   
        reboot 
        exit ;;
      8) 
        dd_xitong_2 
        bash InstallNET.sh -windows  
        reboot 
        exit ;;
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
          echo "已切换为 IPv4 优先"
          ;;
      2)
          sysctl -w net.ipv6.conf.all.disable_ipv6=0 > /dev/null 2>&1
          echo "已切换为 IPv6 优先"
          ;;
      *)
          echo "无效的选择"
          ;;

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

  echo "当前主机名: $current_hostname"

  # 询问用户是否要更改主机名
  read -p "是否要更改主机名？(y/n): " answer

  if [ "$answer" == "y" ]; then
      # 获取新的主机名
      read -p "请输入新的主机名: " new_hostname

      # 更改主机名
      if [ -n "$new_hostname" ]; then
          # 根据发行版选择相应的命令
          if [ -f /etc/debian_version ]; then
              # Debian 或 Ubuntu
              hostnamectl set-hostname "$new_hostname"
              sed -i "s/$current_hostname/$new_hostname/g" /etc/hostname
          elif [ -f /etc/redhat-release ]; then
              # CentOS
              hostnamectl set-hostname "$new_hostname"
              sed -i "s/$current_hostname/$new_hostname/g" /etc/hostname
          else
              echo "未知的发行版，无法更改主机名。"
              exit 1
          fi

          # 重启生效
          systemctl restart systemd-hostnamed
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

# 系统常用工具
system_tools_menu() {
echo -e "
▶ 系统工具
-------------------------------
${green} 1.${plain} 设置脚本启动快捷键
-------------------------------
${green} 2.${plain} 修改ROOT密码
${green} 3.${plain} 开启ROOT密码登录模式
${green} 4.${plain} 安装Python最新版
${green} 5.${plain} 开放所有端口
${green} 6.${plain} 修改SSH连接端口
${green} 7.${plain} 优化DNS地址
${green} 8.${plain} 一键重装系统
${green} 9.${plain} 禁用ROOT账户创建新账户
${green}10.${plain} 切换优先ipv4/ipv6
${green}11.${plain} 查看端口占用状态
${green}12.${plain} 修改虚拟内存大小
${green}13.${plain} 用户管理
${green}14.${plain} 用户/密码生成器
${green}15.${plain} 系统时区调整
${green}16.${plain} 开启BBR3加速
${green}17.${plain} 防火墙高级管理器
${green}18.${plain} 修改主机名
${green}19.${plain} 切换系统更新源
${green}20.${plain} 定时任务管理
-------------------------------
${green}99.${plain} 重启服务器
-------------------------------
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
      4) clear && install_python ;;
      5) clear && iptables_open && remove iptables-persistent ufw firewalld iptables-services > /dev/null 2>&1 && echo "端口已全部开放" ;;
      6) clear && change_ssh_port ;;
      7) clear && change_dns ;;
      8) 
        clear && echo -e "请备份数据，将为你重装系统，预计花费15分钟。\n${white}感谢MollyLau和MoeClub的脚本支持！${plain}"
        reading "确定继续吗？(Y/N): " choice
        case "$choice" in
          [Yy]) dd_system_run ;;
          [Nn]) echo "已取消" ;;
             *) echo "无效的选择，请输入 Y 或 N。" ;;
        esac
        ;;
      9) clear && banroot_with_new_user ;;
     10) clear && alter_ipv4_ipv6 ;;
     11) clear && ss -tulnape ;;
     12) clear && set_swap ;;
     13) clear && echo "Todo: ..." ;;
     14) clear && echo "Todo: ..." ;;
     15) clear && echo "Todo: ..." ;;
     16) clear && echo "Todo: ..." ;;
     17) clear && echo "Todo: ..." ;;
     18) clear && change_sys_name  ;;
     19) clear && alter_sourcelist ;;
     20) clear && echo "Todo: ..." ;;

     99) clear && echo "正在重启服务器，即将断开SSH连接" && reboot ;;
      0) qiqtools ;;
      *) echo "无效的输入!" ;;
    esac
    break_end
  done
}

# 面板工具菜单
panel_tools_menu() {
echo -e "
▶ 面板工具
-------------------------------
${green} 1.${plain} 宝塔面板(官方版)               ${green} 2.${plain} aaPanel(宝塔国际版)
${green} 3.${plain} 1Panel(新一代管理面板)         ${green} 4.${plain} NginxProxyManager(Nginx可视化面板)
${green} 5.${plain} AList(多存储文件列表程序       ${green} 6.${plain} Ubuntu远程桌面网页版
${green} 7.${plain} 哪吒探针(VPS监控面板)          ${green} 8.${plain} QB离线BT(磁力下载面板)
${green} 9.${plain} Poste.io(邮件服务器程序)       ${green}10.${plain} RocketChat(多人在线聊天系统)
${green}11.${plain} VScode网页版                  ${green}12.${plain} Memos网页备忘录
${green}13.${plain} AuroPanel(极光面板)           ${green}14.${plain} X-UI(@alireza0)
${green}15.${plain} X-UI(@FranzKafkaYu)          ${green}16.${plain} X-UI(@rwkgyg)
${green}17.${plain} 3X-UI(@mhsanaei)             ${green}18.${plain} XBoard
${green}19.${plain} XRayR                        ${green}20.${plain} SSPanel
${green}21.${plain} V2Board(wyz2685)             ${green}22.${plain} LotusBoard
${green}23.${plain} ProxyBoard                   ${green}24.${plain} v2rayA
${green}25.${plain} Daed                         ${green}26.${plain} YACD
${green}26.${plain} Hiddify                      ${green}28.${plain} ClashDashBoard
${green}29.${plain} IT-Tools                     ${green}30.${plain} Next Terminal
-------------------------------
${green}99.${plain} 重启服务器
-------------------------------
${green} 0.${plain} 返回主菜单
-------------------------------
"
}

# 面板工具
panel_tools_run(){
  while true; do
    clear && panel_tools_menu
    read -p "请输入你的选择: " sub_choice

    case $sub_choice in
      1) ;;
      0) qiqtools ;;
      *) echo "无效的输入!" ;;
    esac
    break_end
  done

}

# 显示主菜单
main_menu() {
echo -e "
${cyan} __   _  __   ___ ____ ____ _   __
${cyan}|  |  | |  |   |  |  | |  | |  |__
${cyan}|__|_ | |__|_  |  |__| |__| |__ __|

${plain}QiQTools 一键脚本工具 v0.0.1
${plain}(支持Ubuntu/Debian/CentOS/Alpine系统)
${plain}-- 输入${yellow}qiq ${plain}可快速启动此脚本 --
-------------------------------
${green} 1.${plain} 系统信息查询
${green} 2.${plain} 系统更新
${green} 3.${plain} 系统清理
${green} 4.${plain} 常用工具 ▶
${green} 5.${plain} 系统工具 ▶
${green} 6.${plain} 面板工具 ▶
${green} 7.${plain} 其他工具 ▶
${green} 8.${plain} Docker管理 ▶
${green} 9.${plain} WARP管理 ▶ 解锁ChatGPT Netflix
${green}10.${blue} LDNMP建站 ▶${plain}
${green}11.${plain} 测试脚本合集 ▶
${green}12.${plain} 甲骨文云脚本合集 ▶
${green}13.${plain} 我的工作区 ▶
${green}14.${plain} VPS集群控制 ▶ ${blue}Beta${plain}
-------------------------------
${green}00.${plain} 脚本更新
-------------------------------
${green} 0.${plain} 退出脚本
-------------------------------
"
}


# Main Loops for the scripts
while true; do 
  clear && main_menu 
  reading "请输入你的选择: " choice

  case $choice in
     1) clear && get_sysinfo && show_info ;;
     2) clear && update_and_upgrade ;;
     3) clear && clean_sys ;;
     4) common_apps_run  ;;
     5) system_tools_run ;;
     6) panel_tools_run  ;;
     7) clear && echo -e "Todo: ... " ;;
     8) clear && echo -e "Todo: ... " ;;
     9) clear && echo -e "Todo: ... " ;;
    10) clear && echo -e "Todo: ... " ;;
    11) clear && echo -e "Todo: ... " ;;
    12) clear && echo -e "Todo: ... " ;;
    13) clear && echo -e "Todo: ... " ;;
    14) clear && echo -e "Todo: ... " ;;

    00)
      cd ~
      # curl -sS -O https://raw.githubusercontent.com/kejilion/sh/main/update_log.sh && chmod +x update_log.sh && ./update_log.sh
      # rm update_log.sh
      echo ""
      curl -sS -O https://gitlab.com/lmzxtek/qiqtools/-/raw/main/qiqtools.sh && chmod +x kejilion.sh
      echo "脚本已更新到最新版本！"
      break_end
      qiqtools
      ;;
     0) exit ;;
     *) echo "无效的输入!" ;;
  esac  
  break_end
done