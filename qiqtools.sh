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
script_version=v0.4.3
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
 default='\033[0;39m'
 blue2='\033[96m'
  bold='\033[01m'
 plain='\033[0m'

# 自定义字体彩色，read 函数
#  txtn(){ echo -e "${plain}$*"; }                        # 常规字符
 txtn(){ echo -e "${plain}$*${plain}"; }                # 常规字符
 txtr(){ echo -e "${red}$*${plain}"; }                  # 红色字符
 txtb(){ echo -e "${blue}$*${plain}"; }                 # 蓝色字符
 txtc(){ echo -e "${cyan}$*${plain}"; }                 # 
 txtp(){ echo -e "${pink}$*${plain}"; }                 # 
 txtg(){ echo -e "${green}$*${plain}"; }                # 绿色字符
 txtw(){ echo -e "${white}$*${plain}"; }                # 
 txty(){ echo -e "${yellow}$*${plain}"; }               # 黄色字符

echoT(){ FLAG=$1 && shift && echo -e "\033[39m$FLAG\033[39m$@";}
echoY(){ FLAG=$1 && shift && echo -e "\033[38;5;148m$FLAG\033[39m$@";}
echoG(){ FLAG=$1 && shift && echo -e "\033[38;5;71m$FLAG\033[39m$@"; }
echoB(){ FLAG=$1 && shift && echo -e "\033[38;1;34m$FLAG\033[39m$@" ;}
echoR(){ FLAG=$1 && shift && echo -e "\033[38;5;203m$FLAG\033[39m$@"; }
echoW(){ FLAG=${1} && shift && echo -e "\033[1m${EPACE}${FLAG}\033[0m${@}"; }
echoNW(){ FLAG=${1} && shift && echo -e "\033[1m${FLAG}\033[0m${@}"; }
echoCYAN(){ FLAG=$1 && shift && echo -e "\033[1;36m$FLAG\033[0m$@"; }

 txbr(){ echo -e "${red}${bold}$*${plain}"; }           # 红色粗体
 txbb(){ echo -e "${blue}${bold}$*${plain}"; }          # 粗体
 txbc(){ echo -e "${cyan}${bold}$*${plain}"; }          # 粗体
 txbw(){ echo -e "${white}${bold}$*${plain}"; }         # 粗体
 txbn(){ echo -e "${plain}${bold}$*${plain}"; }         # 粗体
 txbg(){ echo -e "${green}${bold}$*${plain}"; }         # 粗体
 txby(){ echo -e "${yellow}${bold}$*${plain}"; }        # 粗体

  warning(){ echo -e "${red}$*${plain}"; }              # 红色
highlight(){ echo -e "${yellow}$*${plain}"; }           # 黄色

 note(){ echo -e "${pink}${bold}$*${plain}"; }          # 品色粗体
 info(){ echo -e "${green}${bold}$*${plain}"; }         # 绿色粗体
 hint(){ echo -e "${yellow}${bold}$*${plain}"; }        # 黄色粗体
error(){ echo -e "${red}${bold}$*${plain}" && exit 1; } # 红色粗体并退出

# 键值对输出
txtkvn() { local key="$1" && shift && local value=$(echo "$*" | tr -d '\n') && echo -e "${plain}$key${plain}$value${plain}"; }
txtkvr() { local key="$1" && shift && local value=$(echo "$*" | tr -d '\n') && echo -e "${plain}$key${red}$value${plain}";   }
txtkvb() { local key="$1" && shift && local value=$(echo "$*" | tr -d '\n') && echo -e "${plain}$key${blue}$value${plain}";  }
txtkvg() { local key="$1" && shift && local value=$(echo "$*" | tr -d '\n') && echo -e "${plain}$key${green}$value${plain}"; }
txtkvy() { local key="$1" && shift && local value=$(echo "$*" | tr -d '\n') && echo -e "${plain}$key${yellow}$value${plain}";}

reading() { read -rp "$(info "$1")" "$2"; }

# 显示标号对应的文字（中文或英文）
text() { grep -q '\$' <<< "${E[$*]}" && eval echo "\$(eval echo "\${${L}[$*]}")" || eval echo "\${${L}[$*]}"; }

  qiqtools() {   main_loop && exit; }
qiq_reload() { cd ~ && qiq && exit; }

# 操作完成，等待输入...
break_end() {
      echo -e "${green} 操作完成 ${red}>> ${yellow} 按任意键继续${green}..."
      read -n 1 -s -r -p ""
      echo ""
}


# 自定义谷歌翻译函数
translate() {
  [ -n "$@" ] && EN="$@"
  ZH=$(wget --no-check-certificate -qO- --tries=1 --timeout=2 "https://translate.google.com/translate_a/t?client=any_client_id_works&sl=en&tl=zh&q=${EN//[[:space:]]/}" 2>/dev/null)
  [[ "$ZH" =~ ^\[\".+\"\]$ ]] && cut -d \" -f2 <<< "$ZH"
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

install_dependency() { clear && install curl wget socat unzip tar; }

# export PATH=$PATH:/usr/local/bin

cur_dir=$(pwd)

# 设置纯IPv6访问GitHub出问题的处理办法
set_ipv6_github(){
  echo -e "nameserver 2001:67c:2b0::4\nnameserver 2001:67c:2b0::6" > /etc/resolv.conf
}

check_IPV4(){
	# echo -e "[IPv4]"
  [[ -n "$IP4_INFO" ]] && return 1; 

	local check4=`ping 1.1.1.1 -c 1 2>&1`;
	if [[ "$check4" != *"received"* ]] && [[ "$check4" != *"transmitted"* ]];then
    IP4_INFO="${red}Not Supported${plain}"
	else
    txtn " >>> Check IPv4 info ..."
		# local_ipv4=$(curl -4 -s --max-time 10 api64.ipify.org)
    local res_ipv4=$(curl -4 -sS --retry 2 --max-time 1 https://www.cloudflare.com/cdn-cgi/trace)
		local local_ipv4=$( echo -e "$res_ipv4" | grep "ip="   | awk -F= '{print $2}')
		local iso2_code4=$( echo -e "$res_ipv4" | grep "loc="  | awk -F= '{print $2}')
		local warp_ipv4=$( echo -e "$res_ipv4"  | grep "warp=" | awk -F= '{print $2}')
		local local_isp4=$(curl -s -4 --max-time 10  --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36" "https://api.ip.sb/geoip/${local_ipv4}" | grep organization | cut -f4 -d '"')
		# local iso2_code4=$(curl -4 -sS https://www.cloudflare.com/cdn-cgi/trace | grep "loc=" | awk -F= '{print $2}')
		# local warp_code4=$(curl -4 -sS https://www.cloudflare.com/cdn-cgi/trace | grep "warp=" | awk -F= '{print $2}')

    WAN4=$local_ipv4
    COUNTRY4=$iso2_code4
    ASNORG4=$local_isp4
    [[ "$warp_ipv4" =~ ^on$ ]] && WARPSTATUS4="${red}${bold}warp${plain}"
    [[ "$warp_ipv4" =~ ^off$ ]] && [[ -n "$local_isp4" ]] && isp_info=$local_isp4
    [[ -n "$WAN4" ]] && IP4_INFO="($WARPSTATUS4 $iso2_code4 -> $local_isp4)"
	fi
}

check_IPV6(){
	# echo -e "[IPv6]"
  [[ -n "$IP6_INFO" ]] && return 1;

	local check6=`ping6 240c::6666 -c 1 2>&1`;
	if [[ "$check6" != *"received"* ]] && [[ "$check4" != *"transmitted"* ]];then
    IP6_INFO="${red}Not Supported${plain}"
	else
    txtn " >>> Check IPv6 info ..."
		# local_ipv6=$(curl -6 -s --max-time 20 api64.ipify.org)
    local res_ipv6=$(curl -6 -sS --retry 2 --max-time 1 https://www.cloudflare.com/cdn-cgi/trace)
		local local_ipv6=$( echo -e "$res_ipv6" | grep "ip="   | awk -F= '{print $2}')
		local iso2_code6=$( echo -e "$res_ipv6" | grep "loc="  | awk -F= '{print $2}')
		local warp_ipv6=$( echo -e "$res_ipv6"  | grep "warp=" | awk -F= '{print $2}')
		local local_isp6=$(curl -s -6 --max-time 10 --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36" "https://api.ip.sb/geoip/${local_ipv6}" | grep organization | cut -f4 -d '"')
    
    WAN6=$local_ipv6
    COUNTRY6=$iso2_code6
    ASNORG6=$local_isp6
    [[ "$warp_ipv6" =~ ^on$ ]] && WARPSTATUS6="${red}${bold}warp${plain}"
    [[ "$warp_ipv6" =~ ^off$ ]] && [[ -n "$local_isp6" ]] && isp_info=$local_isp6
    [[ -n "$WAN6" ]] && IP6_INFO="($WARPSTATUS6 $iso2_code6 -> $local_isp6)"
	fi
}

# 获取当前服务器的IP地址
check_IP_address() {
  if [[ $(curl -sS --retry 2 --max-time 3 https://www.cloudflare.com/ -I | grep "text/plain") != "" ]]; then 
    echo "Your IP is BLOCKED!"
    txtn " >>> Check IP failed ..."
    return 1
  else  
    check_IPV4
    check_IPV6
  fi
}

# 重新检测服务器IP
recheck_ip_address(){
  IP4_INFO=""
  IP6_INFO=""
  check_IP_address
}



# 检测 IPv4 IPv6 信息
check_system_ip() {
  IP4=$(wget -4 -qO- --no-check-certificate --user-agent=Mozilla --tries=2 --timeout=1 http://ip-api.com/json/) &&
  WAN4=$(expr "$IP4" : '.*query\":[ ]*\"\([^"]*\).*') &&
  COUNTRY4=$(expr "$IP4" : '.*country\":[ ]*\"\([^"]*\).*') &&
  CITY4=$(expr "$IP4" : '.*city\":[ ]*\"\([^"]*\).*') &&
  ASNORG4=$(expr "$IP4" : '.*isp\":[ ]*\"\([^"]*\).*') &&
  WAN4=$WAN4 &&
  [[ "$L" = C && -n "$COUNTRY4" ]] && COUNTRY4=$(translate "$COUNTRY4") && 
  IP4_INFO="$WARPSTATUS4 $COUNTRY4 $CITY4 $ASNORG4"

  IP6=$(wget -6 -qO- --no-check-certificate --user-agent=Mozilla --tries=2 --timeout=1 https://api.ip.sb/geoip) &&
  WAN6=$(expr "$IP6" : '.*ip\":[ ]*\"\([^"]*\).*') &&
  COUNTRY6=$(expr "$IP6" : '.*country\":[ ]*\"\([^"]*\).*') &&
  CITY6=$(expr "$IP6" : '.*city\":[ ]*\"\([^"]*\).*') &&
  ASNORG6=$(expr "$IP6" : '.*isp\":[ ]*\"\([^"]*\).*') &&
  WAN6=$WAN6 &&
  [[ "$L" = C && -n "$COUNTRY6" ]] && COUNTRY6=$(translate "$COUNTRY6")&& 
  IP6_INFO="$WARPSTATUS6 $COUNTRY6 $CITY6 $ASNORG6"
}

# Output IP details to shell
WANIP_show(){
  txtn $(txty " IPv4:") $(txtr $WAN4)"\t"$(txtn $COUNTRY4) $(txtp $WARPSTATUS4)
  txtn $(txty " IPv6:") $(txtb $WAN6)"\t"$(txtn $COUNTRY6) $(txtp $WARPSTATUS6)
}

check_root() { [[ $EUID -ne 0 ]] && echo -e "${red}错误：${plain} 必须使用root用户运行此脚本！\n" && exit 1; }

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
  VIRT=${VIRT^^} || VIRT="UNKNOWN"
}

# 获取系统信息
get_sysinfo(){
    # 函数: 获取IPv4和IPv6地址
    
    clear
    txby "\n Welcome to QiQTools "
    txtp "\n >>> Start get system Info."

    txtn "\n >>> Check Hostname ..."
    hostname=$(hostname)

    txtn "\n >>> Check CPU arch ..."
    cpu_arch=$(uname -m)

    txtn " >>> Check system archtecture ..."
    if [ "$(uname -m)" == "x86_64" ]; then
      cpu_info=$(cat /proc/cpuinfo | grep 'model name' | uniq | sed -e 's/model name[[:space:]]*: //')
    else
      cpu_info=$(lscpu | grep 'BIOS Model name' | awk -F': ' '{print $2}' | sed 's/^[ \t]*//')
    fi

    txtn " >>> Check System kernel version ..."
    kernel_version=$(uname -r)

    txtn " >>> Check system virtualization ..."
    check_virt

    # 尝试使用 lsb_release 获取系统信息
    txtn " >>> Check System version ..."
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

    txtn "\n >>> Check CPU usage ..."
    cpu_usage=$(top -bn1 | grep 'Cpu(s)' | awk '{print $2 + $4}')
    cpu_usage_percent=$(printf "%.2f" "$cpu_usage")%

    txtn " >>> Check CPU cores ..."
    cpu_cores=$(nproc)

    txtn "\n >>> Check Memory usage ..."
    mem_info=$(free -b | awk 'NR==2{printf "%.2f/%.2f MB (%.2f%%)", $3/1024/1024, $2/1024/1024, $3*100/$2}')

    txtn " >>> Check Disk usage ..."
    disk_info=$(df -h | awk '$NF=="/"{printf "%s/%s (%s)", $3, $2, $5}')

    txtn " >>> Check Swap information ..."
    swap_used=$(free -m | awk 'NR==3{print $3}')
    swap_total=$(free -m | awk 'NR==3{print $2}')

    if [ "$swap_total" -eq 0 ]; then
        swap_percentage=0
    else
        swap_percentage=$((swap_used * 100 / swap_total))
    fi

    swap_info="${swap_used}MB/${swap_total}MB (${swap_percentage}%)"

    txtn "\n >>> Check Congestion Algorithm ..."
    congestion_algorithm=$(sysctl -n net.ipv4.tcp_congestion_control)
    queue_algorithm=$(sysctl -n net.core.default_qdisc)

    txtn " >>> Check Sever data transfer ..."
    txt_data_transfer=$(awk 'BEGIN { rx_total = 0; tx_total = 0 }
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

            printf("   总接收: %.2f %s\n   总发送: %.2f %s\n", rx_total, rx_units, tx_total, tx_units);
        }' /proc/net/dev)

    txtn "\n >>> Check Current time ..."
    current_time=$(date "+%Y-%m-%d %I:%M %p")
    txtn " >>> Check System running elapsed time ..."
    runtime=$(cat /proc/uptime | awk -F. '{run_days=int($1 / 86400);run_hours=int(($1 % 86400) / 3600);run_minutes=int(($1 % 3600) / 60); if (run_days > 0) printf("%d天 ", run_days); if (run_hours > 0) printf("%d时 ", run_hours); printf("%d分\n", run_minutes)}')

    txtn "\n >>> Check IP address ..."
    check_IP_address
    # country=$(curl -s ipinfo.io/country)
    # city=$(curl -s ipinfo.io/city)
    # isp_info=$(curl -s ipinfo.io/org)

    txtn ""
    txtn "\n >>> System information check Done ...\n"
    txtn ""
}

# 显示系统信息
system_info() {
  txtn " "
    info "系统信息查询"
  txtkvn "↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓"
  txtkvy "    ${blue}虚拟化: " "${yellow}${bold}$VIRT${plain}"
  txtkvn "    主机名: " "$hostname"
  txtkvn "    运营商: " "$isp_info"
  txtkvn "  系统版本: " "$os_info"
  txtkvy "  内核版本: " "$kernel_version"
  txtkvn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  txtkvn "  CPU占用: " "$cpu_usage_percent"
  txtkvn "  CPU架构: " "${yellow}$cpu_arch${plain}   核心数: ${yellow}$cpu_cores${plain}"
  txtkvn "  CPU型号: " "$cpu_info"
  txtkvn "——————————————————————————————————————"
  txtkvy " 物理内存: " "$mem_info"
  txtkvn " 虚拟内存: " "$swap_info"
  txtkvy " 硬盘占用: " "$disk_info"
  txtkvn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  txtkvn " 系统时间: " "$current_time"
  txtkvn " 运行时长: " "$runtime"
  txtkvn "——————————————————————————————————————"
  txtkvy " IPv4地址: " "$WAN4\t$IP4_INFO"
  txtkvy " IPv6地址: " "$WAN6\t$IP6_INFO"
  # WANIP_show
  txtkvn "——————————————————————————————————————"
  txtkvn " 拥堵算法: " "${yellow}$congestion_algorithm" "${plain}$queue_algorithm"
  txtkvn "$txt_data_transfer"
  txtkvn "↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑"
  # txtn " "
}


# format_size
# Purpose: Formats raw disk and memory sizes from kibibytes (KiB) to largest unit
# Parameters:
#          1. RAW - the raw memory size (RAM/Swap) in kibibytes
# Returns:
#          Formatted memory size in KiB, MiB, GiB, or TiB
function format_size {
	RAW=$1 # mem size in KiB
	RESULT=$RAW
	local DENOM=1
	local UNIT="KiB"

	# ensure the raw value is a number, otherwise return blank
	re='^[0-9]+$'
	if ! [[ $RAW =~ $re ]] ; then
		echo "" 
		return 0
	fi

	if [ "$RAW" -ge 1073741824 ]; then
		DENOM=1073741824
		UNIT="TiB"
	elif [ "$RAW" -ge 1048576 ]; then
		DENOM=1048576
		UNIT="GiB"
	elif [ "$RAW" -ge 1024 ]; then
		DENOM=1024
		UNIT="MiB"
	fi

	# divide the raw result to get the corresponding formatted result (based on determined unit)
	RESULT=$(awk -v a="$RESULT" -v b="$DENOM" 'BEGIN { print a / b }')
	# shorten the formatted result to two decimal places (i.e. x.x)
	RESULT=$(echo $RESULT | awk -F. '{ printf "%0.1f",$1"."substr($2,1,2) }')
	# concat formatted result value with units and return result
	RESULT="$RESULT $UNIT"
	echo $RESULT
}

command -v ping >/dev/null 2>&1 && LOCAL_PING=true || unset LOCAL_PING
command -v curl >/dev/null 2>&1 && LOCAL_CURL=true || unset LOCAL_CURL
[[ ! -z $LOCAL_CURL ]] && IP_CHECK_CMD="curl -s -m 4" || IP_CHECK_CMD="wget -qO- -T 4"
IPV4_CHECK=$( (ping -4 -c 1 -W 4 ipv4.google.com >/dev/null 2>&1 && echo true) || $IP_CHECK_CMD -4 icanhazip.com 2> /dev/null)
IPV6_CHECK=$( (ping -6 -c 1 -W 4 ipv6.google.com >/dev/null 2>&1 && echo true) || $IP_CHECK_CMD -6 icanhazip.com 2> /dev/null)

gather_sysinfo(){

  # gather basic system information (inc. CPU, AES-NI/virt status, RAM + swap + disk size)

  UPTIME=$(uptime | awk -F'( |,|:)+' '{d=h=m=0; if ($7=="min") m=$6; else {if ($7~/^day/) {d=$6;h=$8;m=$9} else {h=$6;m=$7}}} {print d+0,"days,",h+0,"hours,",m+0,"minutes"}')

  # check for local lscpu installs
  command -v lscpu >/dev/null 2>&1 && LOCAL_LSCPU=true || unset LOCAL_LSCPU
  if [[ $ARCH = *aarch64* || $ARCH = *arm* ]] && [[ ! -z $LOCAL_LSCPU ]]; then
    CPU_PROC=$(lscpu | grep "Model name" | sed 's/Model name: *//g')
  else
    CPU_PROC=$(awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//')
  fi

  if [[ $ARCH = *aarch64* || $ARCH = *arm* ]] && [[ ! -z $LOCAL_LSCPU ]]; then
    CPU_CORES=$(lscpu | grep "^[[:blank:]]*CPU(s):" | sed 's/CPU(s): *//g')
    CPU_FREQ=$(lscpu | grep "CPU max MHz" | sed 's/CPU max MHz: *//g')
    [[ -z "$CPU_FREQ" ]] && CPU_FREQ="???"
    CPU_FREQ="${CPU_FREQ} MHz"
  else
    CPU_CORES=$(awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo)
    CPU_FREQ=$(awk -F: ' /cpu MHz/ {freq=$2} END {print freq " MHz"}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//')
  fi

  CPU_AES=$(cat /proc/cpuinfo | grep aes)
  [[ -z "$CPU_AES" ]] && CPU_AES="\xE2\x9D\x8C Disabled" || CPU_AES="\xE2\x9C\x94 Enabled"
  CPU_VIRT=$(cat /proc/cpuinfo | grep 'vmx\|svm')
  [[ -z "$CPU_VIRT" ]] && CPU_VIRT="\xE2\x9D\x8C Disabled" || CPU_VIRT="\xE2\x9C\x94 Enabled"

  TOTAL_RAM_RAW=$(free | awk 'NR==2 {print $2}')
  TOTAL_RAM=$(format_size $TOTAL_RAM_RAW)
  TOTAL_SWAP_RAW=$(free | grep Swap | awk '{ print $2 }')
  TOTAL_SWAP=$(format_size $TOTAL_SWAP_RAW)

  # total disk size is calculated by adding all partitions of the types listed below (after the -t flags)
  TOTAL_DISK_RAW=$(df -t simfs -t ext2 -t ext3 -t ext4 -t btrfs -t xfs -t vfat -t ntfs -t swap --total 2>/dev/null | grep total | awk '{ print $2 }')
  TOTAL_DISK=$(format_size $TOTAL_DISK_RAW)
  DISTRO=$(grep 'PRETTY_NAME' /etc/os-release | cut -d '"' -f 2 )

  KERNEL=$(uname -r)
  VIRT=$(systemd-detect-virt 2>/dev/null)
  VIRT=${VIRT^^} || VIRT="UNKNOWN"

  [[ -z "$IPV4_CHECK" ]] && ONLINE="\xE2\x9D\x8C Offline | " || ONLINE="\xE2\x9C\x94 Online | "
  [[ -z "$IPV6_CHECK" ]] && ONLINE+="\xE2\x9D\x8C Offline" || ONLINE+="\xE2\x9C\x94 Online"
  # [[ -z "$IPV6_CHECK" ]] && ONLINE+="❌ Offline" || ONLINE+="✔ Online"

  echo -e 
  echo -e "${yellow}Basic System Information:${plain}"
  echo -e "---------------------------------"

  echo -e "Uptime     : $UPTIME"
  echo -e "Processor  : $CPU_PROC"
  echo -e "CPU cores  : $CPU_CORES @ $CPU_FREQ"
  echo -e "AES-NI     : $CPU_AES"
  echo -e "VM-x/AMD-V : $CPU_VIRT"
  echo -e "RAM        : $TOTAL_RAM"
  echo -e "Swap       : $TOTAL_SWAP"
  echo -e "Disk       : $TOTAL_DISK"
  echo -e "Distro     : $DISTRO"
  echo -e "Kernel     : $KERNEL"
  echo -e "VM Type    : ${red}$VIRT${plain}"
  echo -e "IPv4|IPv6  : $ONLINE"

  # echoT "VM Type    :" ${red}$VIRT${plain}
  # echoG "IPv4|IPv6  :" $ONLINE

}

# Function to get information from IP Address using ip-api.com free API
function ip_info() {

	# check for curl vs wget
	[[ ! -z $LOCAL_CURL ]] && DL_CMD="curl -s" || DL_CMD="wget -qO-"

	local ip6me_resp="$($DL_CMD http://ip6.me/api/)"
	local net_type="$(echo $ip6me_resp | cut -d, -f1)"
	local net_ip="$(echo $ip6me_resp | cut -d, -f2)"

	local response=$($DL_CMD http://ip-api.com/json/$net_ip)

	# if no response, skip output
	if [[ -z $response ]]; then
		return
	fi

	local country=$(echo "$response" | sed -e 's/[{}]/''/g' | awk -v RS=',"' -F: '/^country/ {print $2}' | head -1 | sed 's/^"\(.*\)"$/\1/')
	local region=$(echo "$response" | sed -e 's/[{}]/''/g' | awk -v RS=',"' -F: '/^regionName/ {print $2}' | sed 's/^"\(.*\)"$/\1/')
	local region_code=$(echo "$response" | sed -e 's/[{}]/''/g' | awk -v RS=',"' -F: '/^region/ {print $2}' | head -1 | sed 's/^"\(.*\)"$/\1/')
	local city=$(echo "$response" | sed -e 's/[{}]/''/g' | awk -v RS=',"' -F: '/^city/ {print $2}' | sed 's/^"\(.*\)"$/\1/')
	local isp=$(echo "$response" | sed -e 's/[{}]/''/g' | awk -v RS=',"' -F: '/^isp/ {print $2}' | sed 's/^"\(.*\)"$/\1/')
	local org=$(echo "$response" | sed -e 's/[{}]/''/g' | awk -v RS=',"' -F: '/^org/ {print $2}' | sed 's/^"\(.*\)"$/\1/')
	local as=$(echo "$response" | sed -e 's/[{}]/''/g' | awk -v RS=',"' -F: '/^as/ {print $2}' | sed 's/^"\(.*\)"$/\1/')
	
	echo -e ""
	echo -e "${yellow}$net_type Network Information:${plain}"
	echo -e "---------------------------------"

	if [[ -n "$isp" ]]; then
		echo "ISP        : $isp"
	else
		echo "ISP        : Unknown"
	fi
	if [[ -n "$as" ]]; then
		echo "ASN        : $as"
	else
		echo "ASN        : Unknown"
	fi
	if [[ -n "$org" ]]; then
		echo "Host       : $org"
	fi
	if [[ -n "$city" && -n "$region" ]]; then
		echo "Location   : $city, $region ($region_code)"
	fi
	if [[ -n "$country" ]]; then
		echo "Country    : $country"
	fi 
	echo

	# [[ ! -z $JSON ]] && JSON_RESULT+=',"ip_info":{"protocol":"'$net_type'","isp":"'$isp'","asn":"'$as'","org":"'$org'","city":"'$city'","region":"'$region'","region_code":"'$region_code'","country":"'$country'"}'
}

# if [ ! -z $JSON ]; then
# 	UPTIME_S=$(awk '{print $1}' /proc/uptime)
# 	IPV4=$([ ! -z $IPV4_CHECK ] && echo "true" || echo "false")
# 	IPV6=$([ ! -z $IPV6_CHECK ] && echo "true" || echo "false")
# 	AES=$([[ "$CPU_AES" = *Enabled* ]] && echo "true" || echo "false")
# 	CPU_VIRT_BOOL=$([[ "$CPU_VIRT" = *Enabled* ]] && echo "true" || echo "false")
# 	JSON_RESULT='{"version":"'$YABS_VERSION'","time":"'$TIME_START'","os":{"arch":"'$ARCH'","distro":"'$DISTRO'","kernel":"'$KERNEL'",'
# 	JSON_RESULT+='"uptime":'$UPTIME_S',"vm":"'$VIRT'"},"net":{"ipv4":'$IPV4',"ipv6":'$IPV6'},"cpu":{"model":"'$CPU_PROC'","cores":'$CPU_CORES','
# 	JSON_RESULT+='"freq":"'$CPU_FREQ'","aes":'$AES',"virt":'$CPU_VIRT_BOOL'},"mem":{"ram":'$TOTAL_RAM_RAW',"ram_units":"KiB","swap":'$TOTAL_SWAP_RAW',"swap_units":"KiB","disk":'$TOTAL_DISK_RAW',"disk_units":"KB"}'
# fi


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

# 设置docker-compose快捷命令
docker_set_1ckl(){

  tcmd="dcc"
  reading "\n 请输入要设置的快捷键[dcc]: " ccmd

  [[ -n $ccmd ]] && tcmd=$ccmd
  chmod a+x /usr/local/bin/docker-compose 
  rm -rf `which $tcmd` 
  ln -s /usr/local/bin/docker-compose /usr/bin/$tcmd
}

install_add_docker() {
  
  if [[ "$VIRT" =~ "LXC" ]]; then
    echo -e "\n >>> 检测到${red}LXC${plain}服务器，不建议安装Docker。\n"
    read -p " 安装docker环境吗？(输入Y[y]继续): " choice
    case "$choice" in
      [Yy]) clear ;;
      # [Nn]) return 1 ;;
         *) echo -e " 安装取消..." && return 1 ;;
    esac
  fi

  echo -e "\n >>> 开始安装Docker ...\n"
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

# Docker安装
docker_install() {
  if ! command -v docker &>/dev/null; then
      install_add_docker
      docker_set_1ckl
  else
    echo -e "\n >>> Docker已安装 ..."
    docker --version
    docker-compose --version
    echo -e ""
  fi
}

# Docker卸载
docker_uninstall() {
  clear
  read -p "确定卸载docker环境吗？(Y/N): " choice
  case "$choice" in
    [Yy])
      docker rm $(docker ps -a -q) && docker rmi $(docker images -q) && docker network prune
      remove docker docker-ce docker-compose > /dev/null 2>&1
      ;;
    [Nn]) ;;
       *) echo "无效的选择，请输入 Y 或 N。" ;;
  esac
}

# Docker清理不用的镜像和网络
docker_clean() {
  clear
  read -p "确定清理无用的容器镜像和容器网络吗？[Y|N]: " choice
  case "$choice" in
    [Yy]) docker system prune -af --volumes ;;
    [Nn]) echo "操作取消..." ;;
        *) echo "无效的选择，请输入 Y 或 N" ;;
  esac
}


# Docker列表：版本，镜像，网络和卷
docker_info_list() {
  clear
  echo -e "\n ☞☞☞ Dcoker版本"
  txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  docker --version
  docker-compose --version
  
  echo -e "\n ☞☞☞ Dcoker镜像列表"
  txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  docker image ls
  
  echo -e "\n ☞☞☞ Dcoker容器列表"
  txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  docker ps -a

  echo -e "\n ☞☞☞ Dcoker卷列表"
  txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  docker volume ls
  
  echo -e "\n ☞☞☞ Dcoker网络列表"
  txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  docker network ls

  echo ""
}



# 安装常用工具
common_apps_menu() {
echo -e "
▶ 安装常用工具 ❃❃❃
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
▶ 可选系统菜单\t系统虚拟化：${red}$VIRT
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
  
  clear
  txty "\n请备份数据，将为你重装系统，预计花费15分钟。\n"
  txtn "\t虚拟化类型：${red}$VIRT${plain} \n"
  read -p "确定继续吗？(Y/N): " choice
  
  case "$choice" in
    [Yy]) clear ;;
    [Nn]) echo "已取消" && return 1 ;;
       *) echo "无效的选择，请输入 Y 或 N，返回..." && return 1 ;;
  esac

  if [[ "$VIRT" != *"KVM"* ]]; then
    # 如果系统虚拟化不是KVM，则使用OsMutation进行DD系统
    wget -qO OsMutation.sh https://raw.githubusercontent.com/LloydAsp/OsMutation/main/OsMutation.sh && chmod u+x OsMutation.sh && ./OsMutation.sh
    return 1
  fi 

  # 机器基于KVM，则使用LeitboGi0ro的有脚本进行DD
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
      0) system_setting_run && exit ;;
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

  # 当机器为虚拟化为非KVM化，则不进行设置

  if [[ "$VIRT" != *"KVM"* ]]; then 
    WARPSTATUS6="${red}${bold}warp${plain}"
    txtn "\nThe server type is: $(txbr $VIRT)"
    txtn "(Only KVM server can set swap)\n"
    return 1
  fi

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

  echo "\n当前虚拟内存: $swap_info\n"

  read -p "是否调整大小?[Y|N]: " choice

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
    clear
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
    echo "仅支持Debian|Ubuntu 仅支持x86_64架构"
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

        bbrv3_debian_ub

        reboot

        ;;

      [Nn]) echo "已取消" ;;
      *) echo "无效的选择，请输入 Y 或 N。" ;;
    esac
  fi

}

# 为Debian或Ubuntu系统开启BBRv3
bbrv3_debian_ub(){
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
  bbrv3_conf

  echo "XanMod内核安装并BBR3启用成功。重启后生效"
  rm -f /etc/apt/sources.list.d/xanmod-release.list
  rm -f check_x86-64_psabi.sh*
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
  
txtn " "
txtn $(txbr "▼ 系统工具")$(txbg " ❁❁❁ ")
txtn "—————————————————————————————————————"
# WANIP_show
txtn "     主机名: "$(txtp "$hostname")
txtn "   系统版本: "$(txtp "$os_info")
txtn "====================================="
txtn $(txtn " 1.修改ROOT密码")$(txtg "✔")"           "$(txby "11.修改虚拟内存")$(txtn "✔")
txtn $(txtn " 2.开启ROOT密码登录")$(txtg "✔")"       "$(txtn "12.修改主机名")$(txtn "✔")
txtn $(txtn " 3.开放所有端口")$(txtg "✔")"           "$(txtn "13.切换系统更新源")$(txtn "✔")
txtn $(txtn " 4.修改SSH端口")$(txtg "✔")"            "$(txtb "14.系统时区调整")$(txty "✔")
txtn $(txty " 5.优化DNS")$(txtg "✔")"                "$(txtn "15.开启BBR3加速")$(txtn "✔")
txtn $(txty " 6.一键DD系统")$(txtr "✔")"             "$(txtn "16.防火墙管理器")$(txtn "✔")
txtn $(txtn " 7.禁用ROOT账户")$(txtg "✔")"           "$(txtn "17.用户管理")$(txtn "✔")
txtn $(txtp " 8.切换优先ipv4/ipv6")$(txtg "✔")"      "$(txtn "18.用户/密码生成器")$(txtn "✔")
txtn $(txtn " 9.查看端口占用状态")$(txtg "✔")"       "$(txtn "19.定时任务管理")$(txtn "✔")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn $(txtn "88.性能测试")$(txty "▷")"    "$(txtn "")$(txtn "")
# txtn $(txtn " 1.Docker")$(txtg "✔")"        "$(txtn "11.Test")$(txtb "✘")
txtn "—————————————————————————————————————"
txtn $(txtn " 0.返回主菜单")$(txtr "✖")"             "$(txtr "99")$(txtb ".重启服务器")$(txtc "☢")
txtn " "

}

system_setting_run() {
  while true; do 
    clear && system_tools_menu
    reading "请输入你的选择: " sub_choice

    case $sub_choice in
      # 1) clear && reading "请输入你的快捷按键: " kuaijiejian && echo "alias $kuaijiejian='~/kejilion.sh'" >> ~/.bashrc && source ~/.bashrc && echo "快捷键已设置" ;;
      1) clear && echo "设置你的ROOT密码" && passwd ;;
      2) 
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
      3) clear && iptables_open && remove iptables-persistent ufw firewalld iptables-services > /dev/null 2>&1 && echo "端口已全部开放" ;;
      4) clear && change_ssh_port ;;
      5) clear && change_dns ;;
      6) clear && dd_system_run ;;
        # clear && echo -e "请备份数据，将为你重装系统，预计花费15分钟。\n${white}感谢MollyLau和MoeClub的脚本支持！${plain}"
        # reading "确定继续吗？(Y/N): " choice
        # case "$choice" in
        #   [Yy]) dd_system_run ;;
        #   [Nn]) echo "已取消" ;;
        #      *) echo "无效的选择，请输入 Y 或 N。" ;;
        # esac
        # ;;
      7) clear && banroot_with_new_user ;;
      8) clear && alter_ipv4_ipv6 ;;
      9) clear && ss -tulnape ;;
     10) clear && bash <(curl -sL https://raw.githubusercontent.com/LloydAsp/NodeBench/main/NodeBench.sh) ;;

     11) clear && set_swap ;;
     12) clear && change_sys_name  ;;
     13) clear && alter_sourcelist ;;
     14) clear && alter_timezone ;;
     15) clear && bbrv3_install ;;
     16) clear && firewall_manage ;;
     17) clear && user_manage ;;
     18) clear && pss_generate ;;
     19) clear && cron_manage ;;

     88) clear && server_test_run ;;
     99) clear && echo -e "\n正在重启服务器，即将断开SSH连接..." && reboot ;;
      0) clear && qiqtools ;;
      *) echo "无效的输入!" ;;
    esac
    break_end
  done
}


function fetch(){
    download_url="$1"
    if [ -n "$(command -v wget)" ] ; then
        wget -qO- $download_url
    elif [ -n "$(command -v curl)" ] ; then
        curl -sLo- $download_url
    else
        install wget
        wget -qO- $download_url
    fi
}

# 性能测试工具
server_test_menu() {  
txtn " "
txtn $(txbr "▼ 性能测试")$(txbg " ☯☯☯ ")
txtn "—————————————————————————————————————"
txtn "     主机名: "$(txtp "$hostname")
txtn "   系统版本: "$(txtp "$os_info")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
WANIP_show 
txtn "====================================="
txtn $(txtn " 1.服务器基本信息")$(txtg "✔")"         "$(txtn "11.ChatGPT解锁状态检测")$(txtn "✔")
txtn $(txtn " 2.NodeBench性能测试")$(txtg "✔")"      "$(txtn "12.Region流媒体解锁测试")$(txtn "✔")
txtn $(txtn " 3.behch性能测试")$(txtg "✔")"          "$(txtn "13.yeahwu流媒体解锁测试")$(txtn "✔")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn $(txtn "21.带宽性能(yabs)")$(txtp "✔")"         "$(txtn "24.单线程测速")$(txtn "✔")
txtn $(txty "22.三网测速(Superspeed)")$(txtp "✔")"   "$(txtn "25.三网回程(bestrace)")$(txtn "✔")
txtn $(txtn "23.回程线路(mtr_trace)")$(txtg "✔")"    "$(txtn "")$(txtn "")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn $(txtn "41.融合怪测评(spiritysdx)")$(txtg "✔")" "$(txtn "")$(txtn "")
# txtn $(txtn " 1.Docker")$(txtg "✔")"        "$(txtn "11.Test")$(txtb "✘")
txtn "—————————————————————————————————————"
txtn $(txtn " 0.返回主菜单")$(txtr "✖")"             "$(txtr "99")$(txtb ".重启服务器")$(txtc "☢")
txtn " "
}

server_test_run() {
  while true; do 
    clear && server_test_menu
    reading "请输入你的选择: " sub_choice

    case $sub_choice in
      # 1) clear && reading "请输入你的快捷按键: " kuaijiejian && echo "alias $kuaijiejian='~/kejilion.sh'" >> ~/.bashrc && source ~/.bashrc && echo "快捷键已设置" ;;
      1) clear && gather_sysinfo && ip_info ;;

      2) clear && install curl && curl -Lso- bench.sh | bash ;;
      3) clear && fetch bench.sh | bash ;;
     
     11) clear && install curl && bash <(curl -Ls https://cdn.jsdelivr.net/gh/missuo/OpenAI-Checker/openai.sh) ;;
     12) clear && install curl && bash <(curl -L -s check.unlock.media) ;;
     13) clear && install wget && wget -qO- https://github.com/yeahwu/check/raw/main/check.sh | bash ;;

     21) clear && install curl && curl -sL yabs.sh | bash -s -- -i -5 ;;
     22) clear && install curl && bash <(curl -Lso- https://git.io/superspeed_uxh) ;;
     23) clear && install curl && curl https://raw.githubusercontent.com/zhucaidan/mtr_trace/main/mtr_trace.sh | bash ;;
     24) clear && bash <(fetch https://bench.im/hyperspeed) ;;
     25) clear && install wget && wget -qO- git.io/besttrace | bash ;;

     41) clear && install curl && curl -L https://gitlab.com/spiritysdx/za/-/raw/main/ecs.sh -o ecs.sh && chmod +x ecs.sh && bash ecs.sh ;;

     99) clear && echo -e "\n正在重启服务器，即将断开SSH连接..." && reboot ;;
      0) clear && qiqtools ;;
      *) echo "无效的输入!" ;;
    esac
    break_end
    clear
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

install_baota_aa(){
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
            docker_install
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

# 使用Docker安装苹果CMS内容管理系统
docker_deploy_maccms_tweek(){
  local BFLD="/home/dcc.d"
  local dc_name=macms10
  local dc_port=7878
  local dc_image=gs0245/maccms10

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/data"

  [[ -d $LPTH ]] || mkdir -p $LPTH
  cd $LFLD && touch docker-compose.yml

  cat > $LFLD/docker-compose.yml << EOF
version: '3'
services:
  maccms10:
    container_name: ${dc_name}
    image: $dc_image
    volumes:
        - $LPTH:/data
        - $LPTH/template:/opt/maccms10/template
    ports:
        - '$dc_port:7878'
      #network_mode: host (optional)
    restart: always
EOF

  docker-compose up -d
  
  # 下载影视主题到/root/npm/mnt/docker/maccms/template
  cd $LPTH/template && wget https://github.com/dockkkk/mxone/releases/download/mxone/mxone.zip && unzip mxone.zip && rm /root/npm/mnt/maccms/template/mxone.zip

  clear
  txtn ""
  txtn "MacCMS部署成功，以下为配置信息..."
  txtn ""
  txtn "IPv4链接: https://$WAN4:7878/admin123.php"
  txtn "IPv6链接: https://[$WAN6]:7878/admin123.php"
  txtn ""
  txtn "默认账户: admin@admin123"

  txtn ""
  txtn "解析接口: https://svip.ffzyplay.com/?url="
  txtn "后台主题: mxoneX主题,/admin123.php/admin/mxone/mxoneset"
  txtn "参考教程: https://www.tweek.top/archives/1706060591396"

  txtn ""
  txtn "非凡采集站: http://ffzy5.tv/"
  txtn "快看采集站: https://kuaikanzy.net/"
  txtn "暴风采集站: https://publish.bfzy.tv/"
  txtn "乐视采集站: https://www.leshizy1.com/"

  txtn ""
}

docker_deploy_ubunturdpweb(){

  local BFLD="/home/dcc.d"

  local dc_name=ubuntu_novnc
  local dc_port=6080
  local dc_image=fredblgr/ubuntu-novnc:20.04

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/data"

  [[ -d $LPTH ]] || mkdir -p $LPTH
  cd $LFLD && touch docker-compose.yml

  rootpasswd=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c16)
  resolution=1280x720

  cat > $LFLD/docker-compose.yml << EOF
version: '3'
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_image
    environment:
      - HTTP_PASSWORD=$rootpasswd
      - RESOLUTION=$resolution
    volumes:
        - $LPTH:/workspace:rw
    ports:
        - '$dc_port:80'
    restart: always
EOF

  docker-compose up -d

        # clear 
        # docker_name="ubuntu-novnc"
        # docker_img="fredblgr/ubuntu-novnc:20.04"
        # docker_port=6080
        # docker_rum="docker run -d \
        #                     --name ubuntu-novnc \
        #                     -p 6080:80 \
        #                     -v /home/docker/ubuntu-novnc:/workspace:rw \
        #                     -e HTTP_PASSWORD=$rootpasswd \
        #                     -e RESOLUTION=1280x720 \
        #                     --restart=always \
        #                     fredblgr/ubuntu-novnc:20.04"
        # docker_describe="一个网页版Ubuntu远程桌面，挺好用的！"
        # docker_url="官网介绍: https://hub.docker.com/r/fredblgr/ubuntu-novnc"
        # docker_use="echo \"用户名: root\""
        # docker_passwd="echo \"密码: $rootpasswd\""
        # docker_app
}

docker_deploy_portainer(){
  
  local BFLD="/home/dcc.d"

  local dc_name=portainer
  local dc_port=9050
  local dc_image=portainer/portainer

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/data"

  [[ -d $LPTH ]] || mkdir -p $LPTH
  cd $LFLD && touch docker-compose.yml

  cat > $LFLD/docker-compose.yml << EOF
version: '3'
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_image
    volumes:
        - $LPTH:/data
        - /var/run/docker.sock:/var/run/docker.sock
    ports:
        - '$dc_port:9000'
    restart: always
EOF

  docker-compose up -d

        # clear 
        # docker_name="portainer"
        # docker_img="portainer/portainer"
        # docker_port=9050
        # docker_rum="docker run -d \
        #         --name portainer \
        #         -p 9050:9000 \
        #         -v /var/run/docker.sock:/var/run/docker.sock \
        #         -v /home/docker/portainer:/data \
        #         --restart always \
        #         portainer/portainer"
        # docker_describe="portainer是一个轻量级的docker容器管理面板"
        # docker_url="官网介绍: https://www.portainer.io/"
        # docker_use=""
        # docker_passwd=""
        # docker_app
}

docker_deploy_memos(){
  
  local BFLD="/home/dcc.d"

  local dc_name=memos
  local dc_port=5230
  local dc_image=ghcr.io/usememos/memos:latest

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/data"

  [[ -d $LPTH ]] || mkdir -p $LPTH
  cd $LFLD && touch docker-compose.yml

  cat > $LFLD/docker-compose.yml << EOF
version: '3'
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_image
    volumes:
        - $LPTH:/var/opt/memos
    ports:
        - '$dc_port:5230'
    restart: always
EOF

  docker-compose up -d

      # clear 
      # docker_name="memos"
      # docker_img="ghcr.io/usememos/memos:latest"
      # docker_port=5230
      # docker_rum="docker run -d --name memos -p 5230:5230 -v /home/docker/memos:/var/opt/memos --restart always ghcr.io/usememos/memos:latest"
      # docker_describe="Memos是一款轻量级、自托管的备忘录中心"
      # docker_url="官网介绍: https://github.com/usememos/memos"
      # docker_use=""
      # docker_passwd=""
      # docker_app
}

docker_deploy_qbittorrent(){
  
  local BFLD="/home/dcc.d"

  local dc_port=8081
  local dc_name=qbittorrent
  local dc_image=lscr.io/linuxserver/qbittorrent:latest

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/downloads"

  [[ -d $LPTH ]] || mkdir -p $LPTH
  [[ -d $LFLD/config ]] || mkdir -p $LFLD/config
  cd $LFLD && touch docker-compose.yml

  cat > $LFLD/docker-compose.yml << EOF
version: '3'
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_image
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
      - WEBUI_PORT=$dc_port
    volumes:
        - $LFLD/config:/config
        - $LPTH:/downloads
    ports:
        - '$dc_port:8081'
        - '6881:6881'
        - '6881:6881/udp'
    restart: unless-stopped
EOF

  docker-compose up -d

        # docker_name="qbittorrent"
        # docker_img="lscr.io/linuxserver/qbittorrent:latest"
        # docker_port=8081
        # docker_rum="docker run -d \
        #                       --name=qbittorrent \
        #                       -e PUID=1000 \
        #                       -e PGID=1000 \
        #                       -e TZ=Etc/UTC \
        #                       -e WEBUI_PORT=8081 \
        #                       -p 8081:8081 \
        #                       -p 6881:6881 \
        #                       -p 6881:6881/udp \
        #                       -v /home/docker/qbittorrent/config:/config \
        #                       -v /home/docker/qbittorrent/downloads:/downloads \
        #                       --restart unless-stopped \
        #                       lscr.io/linuxserver/qbittorrent:latest"
        # docker_describe="qbittorrent离线BT磁力下载服务"
        # docker_url="官网介绍: https://hub.docker.com/r/linuxserver/qbittorrent"
        # docker_use="sleep 3"
        # docker_passwd="docker logs qbittorrent"

        # docker_app
}

docker_deploy_rocketchat(){
  
  echoR "Docker-compose.yml is not test. Todo..." &&  return 1 

  local BFLD="/home/dcc.d"

  local dc_port=3897
  local dc_name=rocketchat
  local dc_image=lscr.io/linuxserver/qbittorrent:latest

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/downloads"

  [[ -d $LPTH ]] || mkdir -p $LPTH
  [[ -d $LFLD/config ]] || mkdir -p $LFLD/config
  # cd $LFLD && touch docker-compose.yml
  cd $LFLD 
  curl -L https://raw.githubusercontent.com/RocketChat/Docker.Official.Image/master/compose.yml -O

  docker-compose up -d

      clear 
      if docker inspect rocketchat &>/dev/null; then
              clear
              echo "rocket.chat已安装，访问地址: "
              check_IP_address
              echo "http:$WAN4:3897"
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
                      check_IP_address
                      echo "rocket.chat已经安装完成"
                      echo "------------------------"
                      echo "多等一会，您可以使用以下地址访问rocket.chat:"
                      echo "http:$WAN4:3897"
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
              docker_install
              docker run --name db -d --restart=always \
                  -v /home/docker/mongo/dump:/dump \
                  mongo:latest --replSet rs5 --oplogSize 256
              sleep 1
              docker exec -it db mongosh --eval "printjson(rs.initiate())"
              sleep 5
              docker run --name rocketchat --restart=always -p 3897:3000 --link db --env ROOT_URL=http://localhost --env MONGO_OPLOG_URL=mongodb://db:27017/rs5 -d rocket.chat:6.3

              clear

              check_IP_address
              echo "rocket.chat已经安装完成"
              echo "------------------------"
              echo "多等一会，您可以使用以下地址访问rocket.chat:"
              echo "http:$WAN4:3897"
              echo ""

                  ;;
              [Nn])
                  ;;
              *)
                  ;;
          esac
      fi
}

docker_deploy_searxng(){
  
  local BFLD="/home/dcc.d"

  local dc_name=searxng
  local dc_port=8700
  local dc_image=alandoyle/searxng:latest

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/config"

  [[ -d $LPTH ]] || mkdir -p $LPTH
  cd $LFLD && touch docker-compose.yml

  cat > $LFLD/docker-compose.yml << EOF
version: '3'
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_image
    volumes:
        - $LPTH:/etc/searxng
        - $LFLD/templates:/usr/local/searxng/searx/templates/simple
        - $LFLD/theme:/usr/local/searxng/searx/static/themes/simple
    ports:
        - '$dc_port:8080/tcp'
    restart: unless-stopped
EOF

  docker-compose up -d

      # clear 
      # docker_name="searxng"
      # docker_img="alandoyle/searxng:latest"
      # docker_port=8700
      # docker_rum="docker run --name=searxng \
      #                 -d --init \
      #                 --restart=unless-stopped \
      #                 -v /home/docker/searxng/config:/etc/searxng \
      #                 -v /home/docker/searxng/templates:/usr/local/searxng/searx/templates/simple \
      #                 -v /home/docker/searxng/theme:/usr/local/searxng/searx/static/themes/simple \
      #                 -p 8700:8080/tcp \
      #                 alandoyle/searxng:latest"
      # docker_describe="searxng是一个私有且隐私的搜索引擎站点"
      # docker_url="官网介绍: https://hub.docker.com/r/alandoyle/searxng"
      # docker_use=""
      # docker_passwd=""
      # docker_app
}

docker_deploy_spdf(){
  
  local BFLD="/home/dcc.d"

  local dc_name=spdf
  local dc_port=8020
  local dc_image=frooodle/s-pdf:latest

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/trainingData"

  [[ -d $LPTH ]] || mkdir -p $LPTH
  cd $LFLD && touch docker-compose.yml

  cat > $LFLD/docker-compose.yml << EOF
version: '3'
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_image
    volumes:
        - $LPTH:/usr/share/tesseract-ocr/5/tessdata
        - $LFLD/extraConfigs:/configs
        - $LFLD/logs:/logs
    ports:
        - '$dc_port:8080'
    restart: always
EOF

  docker-compose up -d

      # clear
      # docker_name="s-pdf"
      # docker_img="frooodle/s-pdf:latest"
      # docker_port=8020
      # docker_rum="docker run -d \
      #                 --name s-pdf \
      #                 --restart=always \
      #                   -p 8020:8080 \
      #                   -v /home/docker/s-pdf/trainingData:/usr/share/tesseract-ocr/5/tessdata \
      #                   -v /home/docker/s-pdf/extraConfigs:/configs \
      #                   -v /home/docker/s-pdf/logs:/logs \
      #                   -e DOCKER_ENABLE_SECURITY=false \
      #                   frooodle/s-pdf:latest"
      # docker_describe="这是一个强大的本地托管基于 Web 的 PDF 操作工具，使用 docker，允许您对 PDF 文件执行各种操作，例如拆分合并、转换、重新组织、添加图像、旋转、压缩等。"
      # docker_url="官网介绍: https://github.com/Stirling-Tools/Stirling-PDF"
      # docker_use=""
      # docker_passwd=""
      # docker_app
}

docker_deploy_ittools(){
  
  local BFLD="/home/dcc.d"

  local dc_port=3380
  local dc_name=ittools
  local dc_imag=corentinth/it-tools:latest
  local dc_desc="IT-Tools常用工具箱"
  # local dc_imag=ghcr.io/corentinth/it-tools:latest

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name"
  local FYML="$FLD/docker-compose.yml"
  local FCONF="$FLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD
  [[ -f "$FYML"  ]] || touch $FYML

  echo -e "\n >>> 现在开始部署IT-Tools ... \n"
  read -p "请输入监听端口(默认为:${dc_port}): " ptmp
  # [[ (check_port ptmp ) ]] && dc_port=$ptmp
  
  cat > "$FYML" << EOF
version: '3'
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_imag
    ports:
        - '$dc_port:80'
    restart: always
EOF

  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc

  # 输出容器的额外信息
  # [[ -f "$CONF"]] || touch $FCONF
  # echo "New line of data" >> $FCONF

#   # 构建并启动容器
#   docker-compose up -d
  
#   # 是否绑定域名？
#   read -p "\n是否需要绑定域名？[Y|n] " choice
#   case "$choice" in
#     [Yy]) 
#       echo -e "\n先将域名解析到本机IP: ${red}$WAN4  ${blue}$WAN6${plain}"
#       echo -e "(注意: 初始时不开启CDN, 绑定成功之后再开启。)\n"
#       read -p "请输入解析的域名: " dc_domain
#       caddy_reproxy $dc_domain "127.0.0.1" $dc_port
#       caddy_reload
#       # echo -e "\n您的反向代理网站做好了！"      
#       ;;
#     # [Nn]) ;;
#        *)  echo "\n暂不绑定域名..." ;;
#   esac  

#   # 保存配置信息和访问链接
#   echo ""
#   read -p "是否保存配置文件？[N|n]($LFLD/${dc_name}.conf)" choice
#   case "$choice" in
#     [Nn]) echo "不保存配置文件..." ;;
#        *)  
#       # touch $LFLD/${dc_name}.conf
#       cat > "$LPTH_CONF" << EOF
#       service: ${dc_name}
#     container: ${dc_name}
#     URL(IPV4): http://$WAN4:$dc_port
#     URL(IPV6): http://[$WAN6]:$dc_port
#       Domain: $dc_domain
# EOF
#       ;;
#   esac  

#   # 显示配置文件信息
#   echoR "\n${dc_name}容器的配置信息和访问链接如下："
#   # cat $LFLD/${dc_name}.conf
#   echoR "    service: ${dc_name}              "     
#   echoR "  container: ${dc_name}              "     
#   [[ -n "$WAN4"      ]] && echoR "  URL(IPV4): http://$WAN4:$dc_port   "                
#   [[ -n "$WAN6"      ]] && echoR "  URL(IPV6): http://[$WAN6]:$dc_port "                  
#   [[ -n "$dc_domain" ]] && echoR "    Domain: $dc_domain               "    
#   echoT ""
}

docker_deploy_nextterminal(){
  
  local BFLD="/home/dcc.d"

  local dc_port=8081
  local dc_name=nextterminal
  # local dc_image=lscr.io/linuxserver/qbittorrent:latest

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/downloads"

  [[ -d $LPTH ]] || mkdir -p $LPTH
  [[ -d $LFLD/config ]] || mkdir -p $LFLD/config
  # cd $LFLD && touch docker-compose.yml
  curl -sSL https://f.typesafe.cn/next-terminal/docker-compose.yml > docker-compose.yml

  docker-compose up -d

      # clear
      # cd ~
      # mkdir next-terminal-docker && cd next-terminal-docker
      # curl -sSL https://f.typesafe.cn/next-terminal/docker-compose.yml > docker-compose.yml
      # # curl -sSL https://f.typesafe.cn/next-terminal/aliyuns/docker-compose.yml > docker-compose.yml # 阿里镜像
      # docker-compose up -d
      # cd ~
}

docker_deploy_yacd(){

  local BFLD="/home/dcc.d"

  local dc_port=1234
  local dc_name=yacd
  # local dc_image=haishanh/yacd
  local dc_image=ghcr.io/haishanh/yacd:master
  local dc_desc="YACD - Yet Another Clash Board"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name"
  local FYML="$FLD/docker-compose.yml"
  local FCONF="$FLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD
  [[ -d $LFLD/config ]] || mkdir -p $LFLD/config
  [[ -f "$FYML"  ]] || touch $FYML

  echo -e "\n >>> 现在开始部署YACD ... \n"
  read -p "请输入监听端口(默认为:${dc_port}): " ptmp
  # [[ (check_port ptmp ) ]] && dc_port=ptmp
  [[ -z "$ptmp" ]] || dc_port=$ptmp
  
  cat > "$FYML" << EOF
version: '3'
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_image
    volumes:
        - $LFLD/config:/config
    ports:
        - '$dc_port:80
    restart: unless-stopped
EOF

  # docker-compose up -d
  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc

  # docker run -p 1234:80 -d --name yacd --rm ghcr.io/haishanh/yacd:master 
}

docker_deploy_clashdashboard(){

  local BFLD="/home/dcc.d"

  local dc_port=7893
  local dc_name=clash_web
  local dc_image=haishanh/yacd
  # local dc_image=ghcr.io/haishanh/yacd

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name"

  [[ -d $LPTH ]] || mkdir -p $LPTH
  [[ -d $LFLD/config ]] || mkdir -p $LFLD/config
  cd $LFLD && touch docker-compose.yml

  cat > $LFLD/docker-compose.yml << EOF
version: '3'
services:
  clash:
    container_name: clash
    image: dreamacro/clash
    volumes:
        - $LFLD/.config:/root/.config/clash
    ports:
        - 8790:7890
        - 8791:7891
        - 8792:9090 
    restart: always

  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_image
    depends_on:
      # 依赖于clash服务，在clash启动后，web才启动
      - clash
    volumes:
        - $LFLD/config:/config
    ports:
        - '$dc_port:90'
    restart: always
EOF

  docker-compose up -d

}

docker_deploy_npm(){

  local BFLD="/home/dcc.d"

  local dc_port=81
  local dc_name=npm
  local dc_image=lscr.io/linuxserver/qbittorrent:latest

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/data"

  [[ -d $LPTH ]] || mkdir -p $LPTH
  [[ -d $LFLD/letsencrypt ]] || mkdir -p $LFLD/letsencrypt
  cd $LFLD && touch docker-compose.yml

  cat > $LFLD/docker-compose.yml << EOF
version: '3'
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_image
    volumes:
        - $LPTH:/data
        - $LFLD/letsencrypt:/etc/letsencrypt
    ports:
        - '$dc_port:81'
        - '80:80'
        - '443:443'
    restart: always
EOF

  docker-compose up -d


        # clear 
        # docker_name="npm"
        # docker_img="jc21/nginx-proxy-manager:latest"
        # docker_port=81
        # docker_rum="docker run -d \
        #               --name=$docker_name \
        #               -p 80:80 \
        #               -p 81:$docker_port \
        #               -p 443:443 \
        #               -v /home/docker/npm/data:/data \
        #               -v /home/docker/npm/letsencrypt:/etc/letsencrypt \
        #               --restart=always \
        #               $docker_img"
        # docker_describe="如果您已经安装了其他面板工具或者LDNMP建站环境，建议先卸载，再安装npm！"
        # docker_url="官网介绍: https://nginxproxymanager.com/"
        # docker_use="echo \"初始用户名: admin@example.com\""
        # docker_passwd="echo \"初始密码: changeme\""
        # docker_app
}

docker_deploy_gptacademic(){

  local BFLD="/home/dcc.d"

  local dc_port=50923
  local dc_name=gpt_academic
  local dc_image=ghcr.io/binary-husky/gpt_academic_nolocal:master
  local dc_desc="gpt_academic学术工具"

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/downloads"
  local FYML="$FLD/docker-compose.yml"
  local FCONF="$FLD/${dc_name}.conf"

  ([[ -d "$LPTH" ]] || mkdir -p $LPTH) && cd $LFLD
  [[ -f "$FYML"  ]] || touch $FYML

  # [[ -d $LPTH ]] || mkdir -p $LPTH
  # [[ -d $LFLD/config ]] || mkdir -p $LFLD/config
  # cd $LFLD && touch docker-compose.yml

  cat > "$FYML" << EOF
version: '3'
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_image
    environment:
      - WEB_PORT=$dc_port
      - API_KEY=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
      - GEMINI_API_KEY=AIzaSyDUfCAZB9snVfDaPoii1GRZfjJsLnIUjA7
      - DEFAULT_WORKER_NUM=30
      - AUTHENTICATION=[("usr1", "54321"), ("usr2", "adsfd")]  
      - AVAIL_LLM_MODELS=["gpt-3.5-turbo", "gpt-4","gemini-pro"]   
      - LLM_MODEL=gemini-pro
      - AUTO_CLEAR_TXT=False
      - ADD_WAIFU=True
    volumes:
        - $LFLD/config:/config
        - $LPTH:/downloads
    ports:
        - '$dc_port:$dc_port'  # 50923必须与WEB_PORT相互对应
    restart: unless-stopped
EOF

  docker_deploy_start $BFLD $dc_name $dc_port $dc_desc

  echo -e "\nNew line of data" >> $FCONF
}

docker_deploy_chunhuchat(){

  local BFLD="/home/dcc.d"

  local dc_port=7860
  local dc_name=changhuchat
  local dc_image=ghcr.io/gaizhenbiao/chuanhuchatgpt:latest

  local LFLD="$BFLD/$dc_name"
  local LPTH="$BFLD/$dc_name/history"

  [[ -d $LPTH ]] || mkdir -p $LPTH
  [[ -d $LFLD/config ]] || mkdir -p $LFLD/config
  cd $LFLD && touch docker-compose.yml

  # git clone https://github.com/GaiZhenbiao/ChuanhuChatGPT.git .
  # cp config_example.json config.json
  # curl -o config.json https://raw.githubusercontent.com/GaiZhenbiao/ChuanhuChatGPT/main/config_example.json

  cat > $LFLD/docker-compose.yml << EOF
version: '3'
services:
  ${dc_name}:
    container_name: ${dc_name}
    image: $dc_image
    # build:
    #   context: . 
    #   dockerfile: Dockerfile

    environment:
      - PUID=0
    volumes:
        - $LFLD/config.json:/app/config.json
        - $LPTH:/app/history
    ports:
        - '$dc_port:7860'
    restart: unless-stopped
EOF

  docker-compose up -d
}

# 部署Docker，使用yml配置文件
docker_deploy_start(){
  local BFLD=$1
  local NAME=$2
  local PORT=$3
  local DESC=$4

  local CONF="${BFLD}/${NAME}.conf"

  cd ${BFLD}/${NAME}
  docker_install
  docker-compose up -d

  # 是否绑定域名？
  read -p "\n是否需要绑定域名？[Y|n] " choice
  case "$choice" in
    [Yy]) 
          echo -e "\n先将域名解析到本机IP: ${red}$WAN4  ${blue}$WAN6${plain}"
          echo -e "(注意: 初始时不开启CDN, 绑定成功之后再开启。)\n"
          read -p "请输入解析的域名: " DOMAIN
          caddy_reproxy $DOMAIN "127.0.0.1" $PORT
          caddy_reload
          # echo -e "\n您的反向代理网站做好了！"
          ;;
       *)  echo "\n暂不绑定域名..." ;;
  esac  

  # 保存配置信息和访问链接
  echo ""
  read -p "是否保存配置文件？[Y|n](${CONF})" choice
  case "$choice" in
    [Nn]) 
        echo "不保存配置文件..." 
        ;;
       *) 
        [[ -f "$CONF"  ]] || touch $LPTH_YML
        cat > "${CONF}" << EOF
Service     : ${NAME}
Container   : ${NAME}
URL(IPV4)   : http://$WAN4:$PORT
URL(IPV6)   : http://[$WAN6]:$PORT
Domain      : $DOMAIN
Description : $DESC
EOF
      ;;
  esac  

  # 显示配置文件信息
  echoR "\n${NAME}容器的配置信息和访问链接如下："
  # cat $LFLD/${NAME}.conf
  echoR "    service:" "${NAME}"
  echoR "  container:" "${NAME}"
  [[ -n "$WAN4"      ]] && echoR " URL-IPV4:" "http://$WAN4:$PORT   "
  [[ -n "$WAN6"      ]] && echoR " URL-IPV6:" "http://[$WAN6]:$PORT "
  [[ -n "$DOMAIN"    ]] && echoY "   Domain:" "$DOMAIN              "
  echoT ""
}

# 站点工具菜单
website_deploy_menu() {

txtn " "
txtn $(txbr "▼ 站点部署")$(txtp " ♨♨♨ ")
txtn "—————————————————————————————————————"
WANIP_show
txtn "====================================="
txtn $(txty " 1.1Panel")$(txtc "〠")"                "$(txtn "11.AList")$(txtg "✔")
txtn $(txtn " 2.aaPanel")$(txtg "✔")"                "$(txtb "12.MacCMS")$(txtg "✔")
txtn $(txtn " 3.宝塔面板")$(txtg "✔")"               "$(txtn "13.KodBox")$(txtg "✔")
txtn $(txtn " 4.哪吒探针")$(txtg "✔")"               "$(txtn "14.Code-Server")$(txtg "✔")
txtn $(txtn " 5.OpenLiteSpeed")$(txtg "✔")"          "$(txtn "15.ChatGPT-Next-Web")$(txtg "✔")
# txtn $(txtn " 6.NginxProxyManager")$(txtb "✘")"      "$(txtn "")$(txtg "")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn $(txbr "▼ Docker")$(txbg " ❦❦❦ ")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn $(txtn "21.AuroPanel")$(txtg "✔")"              "$(txtn "41.Portainer")$(txtn "✔")
txtn $(txtn "22.Ubuntu-RDP-Web")$(txtg "✔")"         "$(txtn "42.Next-Terminal")$(txtn "✔")
txtn $(txtn "23.Memos")$(txtg "✔")"                  "$(txtn "43.YACD")$(txtn "✔")
txtn $(txtb "24.SearXNG")$(txtg "✔")"                "$(txtn "44.QBittorrent")$(txtn "✔")
txtn $(txtn "25.StirlingPDF")$(txtg "✔")"            "$(txtn "45.RocketChat")$(txtn "✔")
txtn $(txty "26.IT-Tools")$(txtg "✔")"               "$(txtn "46.ClashDashBoard")$(txtn "✔")
txtn $(txtn "27.MyIP(IPChecking)")$(txtg "✔")"       "$(txtn "47.MacCMS")$(txtn "✔")
txtn $(txtn "28.ChatGPT-Next-Web")$(txtg "✔")"       "$(txtn "48.NginxProxyManager")$(txtn "✔")
txtn $(txtn "29.GPT_Academic")$(txtg "✔")"           "$(txtn "49.ChunhuChat")$(txtn "✔")
# txtn $(txtn " 1.Docker")$(txtg "✔")"        "$(txtn "11.Test")$(txtb "✘")
txtn "—————————————————————————————————————"
txtn $(txtn " 0.返回主菜单")$(txtr "✖")"             "$(txtp "88.")$(txtb "容器管理")$(txty "☪")
txtn " "
}

# 面板工具
website_deploy_run(){
  while true; do
    clear && website_deploy_menu
    read -p "请输入你的选择: " sub_choice

    case $sub_choice in
      1) clear && install_1panel  ;;
      2) clear && install_baota_aa ;;
      3) clear && install_baota_cn ;;
      4) clear && install curl && curl -L https://raw.githubusercontent.com/naiba/nezha/master/script/install.sh  -o nezha.sh && chmod +x nezha.sh && ./nezha.sh  ;;
      5) clear && install wget && wget https://raw.githubusercontent.com/litespeedtech/ols1clk/master/ols1clk.sh && bash ols1clk.sh  ;;

     11) clear && install curl && curl -fsSL "https://alist.nn.ci/v3.sh" | bash -s install  ;;
     12) clear && install_maccms ;;
     13) clear && install_kodbox  ;;
     14) clear && install curl && curl -fsSL https://code-server.dev/install.sh | sh  ;;
     15) clear && install curl && bash <(curl -s https://raw.githubusercontent.com/Yidadaa/ChatGPT-Next-Web/main/scripts/setup.sh) ;;

     21) clear && install curl && bash <(curl -fsSL https://raw.githubusercontent.com/Aurora-Admin-Panel/deploy/main/install.sh)  ;;
     22) clear && docker_deploy_ubunturdpweb ;;
     23) clear && docker_deploy_memos ;;
     24) clear && docker_deploy_searxng ;;
     25) clear && docker_deploy_spdf ;;
     26) clear && docker_deploy_ittools ;;
     27) clear && docker_deploy_myip ;;
     28) clear && docker_deploy_chatgptnextweb ;;
     29) clear && docker_deploy_gptacademic ;;

     41) clear && docker_deploy_portainer ;;
     42) clear && docker_deploy_nextterminal ;;
     43) clear && docker_deploy_yacd ;;
     44) clear && docker_deploy_qbittorrent ;;
     45) clear && docker_deploy_rocketchat ;;
     46) clear && docker_deploy_clashdashboard;;
     47) clear && docker_deploy_maccms_tweek ;;
     48) clear && docker_deploy_npm ;;
     49) clear && docker_deploy_chunhuchat ;;

     88) clear && docker_run ;;
      0) clear && qiqtools ;;
      *) echo "无效的输入!" ;;
    esac
    break_end
  done

}

other_tools_menu() {
  
txtn " "
txtn $(txbr "▼ 其他工具")$(txbg " ののの ")
# txtn "-------------------------------------"
# WANIP_show
txtn "—————————————————————————————————————"
# txtn "====================================="
# txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn $(txtn " 1.Docker")$(txtg "✔")"          "$(txtn "")$(txtg "")
txtn $(txtn " 2.Python")$(txtg "✔")"          "$(txtn "")$(txtg "")
txtn $(txtn " 3.Conda")$(txtg "✔")"           "$(txtn "")$(txtg "")
txtn $(txtn " 4.RustDesk Server")$(txtg "✔")" "$(txtn "")$(txtg "")
# txtn $(txtn " 1.Docker")$(txtg "✔")"        "$(txtn "11.Test")$(txtb "✘")
txtn "—————————————————————————————————————"
txtn $(txtn " 0.返回主菜单")$(txtr "✖")
txtn " "
}

other_tools_run() {
  while true; do
    clear && other_tools_menu
    reading "请选择代码: " choice

    case $choice in
      1) clear && docker_install ;;
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

      0) clear && clear && clear && clear && clear && clear && qiqtools ;;
      *) echo "无效的输入!" ;;
    esac  
    break_end
  done 
}

warp_tools_menu() {

txtn " "
txtn $(txbr "▼ 节点管理")$(txbb " ✈✈✈ ")
txtn "—————————————————————————————————————"
WANIP_show
txtn "====================================="
txtn $(txtn "81.Show IP(ip.sb)")$(txtg "✔")"                "$(txtn "91.Set GitHUB(IPv6)")$(txtg "✔")
txtn $(txtn "82.Show IPv4(local)")$(txtg "✔")"              "$(txtb "92.Cloudflare Select IP")$(txtg "✔")
txtn $(txtn "83.Show IPv6(local)")$(txtg "✔")"              "$(txtn "93.Cloudflare Select CDN")$(txtg "✔")
txtn $(txtp "84.Cloudflare(IPv4)")$(txtg "✔")"              "$(txtr "85.Cloudflare(IPv6)")$(txtg "✔")
# txtn $(txtn "")$(txtg "")"              "$(txtn "")$(txtg "")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn $(txty " 1.Warp(@fscarmen)")$(txtr "✔")"               "$(txtn "11.XRay(@233boy)")$(txtg "✔")
txtn $(txtn " 2.Warp(@hamid-gh98)")$(txtg "✔")"             "$(txtn "12.V2Ray(@233boy)")$(txtg "✔")
txtn $(txtn " 3.Warp(@Misaka-blog)")$(txtg "✔")"            "$(txtn "13.V2Ray-Agent(@mack-a)")$(txtg "✔")
txtn $(txtn " 4.ArgoX")$(txtg "✔")"                         "$(txtn "14.Hysteria2(@Misaka)")$(txtg "✔")
txtn $(txtn " 5.SingBox四合一(yg)")$(txtg "✔")"             "$(txtn "15.TUIC5(@Misaka)")$(txtg "✔")
txtn $(txtn " 6.SingBox-Argox(@fscarmen)")$(txtg "✔")"      "$(txtn "16.mianyang()")$(txtg "✔")
txtn $(txby " 7.SingBox全家桶(@fscarmen)")$(txtr "✔")"      "$(txtn "")$(txtb "")
# txtn $(txtn " 1.Docker")$(txtg "✔")"        "$(txtn "11.Test")$(txtb "✘")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn $(txty "51.XRayR(@XrayR-project)")$(txtg "✔")"         "$(txtn "61.V2bX(Vless&Trojan to V2board)")$(txtg "")
txtn $(txtn "52.XRayR(@wyx2685)")$(txtg "✔")"               "$(txtn "62.Bodhi(Hysteria2 to V2board)")$(txtg "")
txtn $(txtc "53.XRayR(Alpine)")$(txtg "✔")"                 "$(txtn "63.XRayR-Docker(@XrayR-project)")$(txtg "✔")
txtn $(txtc "54.XRayR(AirGo)")$(txtg "✔")"                  "$(txtn "")$(txtg "")
# txtn $(txtc "")$(txtg "✔")"                 "$(txtn "")$(txtg "✔")
txtn "—————————————————————————————————————"
txtn $(txtn " 0.返回主菜单")$(txtr "✖")
txtn " "
}

warp_tools_run() {
  while true; do
    clear && warp_tools_menu
    reading "请选择代码: " choice
    
    case $choice in
      1) 
        clear && install wget && wget -N https://gitlab.com/fscarmen/warp/-/raw/main/menu.sh && bash menu.sh [option] [lisence/url/token] 
        recheck_ip_address
        ;;
      2) 
        clear && bash <(curl -sSL https://raw.githubusercontent.com/hamid-gh98/x-ui-scripts/main/install_warp_proxy.sh) 
        recheck_ip_address
        ;;
      3) 
        clear && wget -N https://gitlab.com/Misaka-blog/warp-script/-/raw/main/warp.sh && bash warp.sh 
        recheck_ip_address
        ;;
      4) clear && bash <(wget -qO- https://raw.githubusercontent.com/fscarmen/argox/main/argox.sh)  ;;
      5) clear && bash <(curl -Ls https://gitlab.com/rwkgyg/sing-box-yg/raw/main/sb.sh)  ;;
      6) clear && bash <(wget -qO- https://raw.githubusercontent.com/fscarmen/sba/main/sba.sh) ;;
      7) clear && bash <(wget -qO- https://raw.githubusercontent.com/fscarmen/sing-box/main/sing-box.sh) ;;
      # 8) clear && bash <(wget -qO- https://raw.githubusercontent.com/fscarmen/argox/main/argox.sh) ;;

     11) clear && bash <(wget -qO- -o- https://github.com/233boy/Xray/raw/main/install.sh) ;;
     12) clear && bash <(wget -qO- -o- https://git.io/v2ray.sh) ;;
     13) clear && wget -P /root -N --no-check-certificate "https://raw.githubusercontent.com/mack-a/v2ray-agent/master/install.sh" && chmod 700 /root/install.sh && /root/install.sh ;;
     14) clear && wget -N --no-check-certificate https://raw.githubusercontent.com/Misaka-blog/hysteria-install/main/hy2/hysteria.sh && bash hysteria.sh ;;
     15) clear && wget -N --no-check-certificate https://gitlab.com/Misaka-blog/tuic-script/-/raw/main/tuic.sh && bash tuic.sh ;;
     16) clear && bash <(curl -fsSL https://github.com/vveg26/sing-box-reality-hysteria2/raw/main/beta.sh) ;;

     51) clear && wget -N https://raw.githubusercontent.com/XrayR-project/XrayR-release/master/install.sh && bash install.sh && cd /etc/XrayR ;;
     52) clear && wget -N https://raw.githubusercontent.com/wyx2685/XrayR-release/master/install.sh && bash install.sh ;;
     53) clear && apk add wget sudo curl && wget -N https://github.com/Cd1s/alpineXrayR/releases/download/one-click/install-xrayr.sh && chmod +x install-xrayr.sh && bash install-xrayr.sh ;;
     54) clear && bash <(curl -Ls https://raw.githubusercontent.com/ppoonk/XrayR-for-AirGo/main/scripts/manage.sh) ;;

     61) clear && wget -N https://raw.githubusercontent.com/wyx2685/V2bX-script/master/install.sh && bash install.sh ;;
     62) clear && cd ~ && git clone https://github.com/lotusnetwork/bodhi-docker.git && cd bodhi-docker ;;
     63) clear && cd ~ && git clone https://github.com/XrayR-project/XrayR-release xrayr && cd xrayr ;;
    #  64) clear && docker run -p 1234:80 -d --name yacd --rm ghcr.io/haishanh/yacd:master ;;
    #  65) clear && echo -e "\n Todo: ... \n" ;;

     81) echo -e "\nIP: $(curl -s ip.sb)\n"  ;;
     82) echo -e "\n$(ip addr | grep "inet ")\n"  ;;
     83) echo -e "\n$(ip addr | grep "inet6")\n"  ;;
     84) clear && curl -s4m5 https://www.cloudflare.com/cdn-cgi/trace ;;
     85) clear && curl -s6m5 https://www.cloudflare.com/cdn-cgi/trace ;;

     91) set_ipv6_github ;;
     92) clear && cd ~ && mkdir -p cfip && cd cfip && curl -sSL https://gitlab.com/rwkgyg/CFwarp/raw/main/point/cfip.sh -o cfip.sh && chmod +x cfip.sh && bash cfip.sh ;;
     93) clear && cd ~ && mkdir -p cfip && cd cfip && curl -sSL https://gitlab.com/rwkgyg/CFwarp/raw/main/point/CFcdnym.sh -o CFcdnym.sh && chmod +x CFcdnym.sh && bash CFcdnym.sh ;;
    #  94) clear && bash <(curl -Ls https://cdn.jsdelivr.net/gh/missuo/OpenAI-Checker/openai.sh) ;;
    #  95) clear && bash <(curl -Ls check.unlock.media) ;;

      0) clear && clear && clear && clear && clear && qiqtools ;;
      *) echo "无效的输入!" ;;
    esac
    # recheck_ip_address
    break_end
  done 

}

board_panels_menu() {
txtn " "
txtn $(txbr "▼ 节点面板")$(txbg " ⊕⊕⊕ ")
txtn "—————————————————————————————————————"
WANIP_show
txtn "====================================="
txtn $(txtn " 1.3X-UI(@mhsanaei)")$(txtg "✔")"       "$(txtn "11.Hiddify")$(txtg "✔")
txtn $(txtb " 2.X-UI(@alireza0)")$(txtg "✔")"        "$(txty "12.V2RayA")$(txtg "✔")
txtn $(txtn " 3.X-UI(@FranzKafkaYu)")$(txtg "✔")"    "$(txtn "13.Daed")$(txtg "✔")
txtn $(txtn " 4.X-UI(@rwkgyg)")$(txtg "✔")"          "$(txtn "14.Daed-Docker")$(txtg "✔")
txtn $(txtc " 5.X-UI(alpine)")$(txtg "✔")"           "$(txtn "15.S-UI(@alireza0)")$(txtg "✔")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn $(txty "21.XBoard")$(txtb "✘")"                 "$(txtn "44.LotusBoard")$(txtb "✘")
txtn $(txtn "22.V2Board")$(txtb "✘")"                "$(txtn "45.SSPanel")$(txtb "✘")
txtn $(txtn "23.V2Board(wyx2685)")$(txtb "✘")"       "$(txtn "46.Proxypanel")$(txtb "✘")
txtn $(txtn "24.AirGo")$(txtg "✔")"                  "$(txtn "")$(txtb "")
# txtn $(txtn " 1.Docker")$(txtg "✔")"        "$(txtn "11.Test")$(txtb "✘")
txtn "—————————————————————————————————————"
txtn $(txtn " 0.返回主菜单")$(txtr "✖")
txtn " "
}

board_panels_run() {
  while true; do
    clear && board_panels_menu
    reading "请选择面板代码: " choice
    
    case $choice in
      1) clear && bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh) ;;
      2) clear && bash <(curl -Ls https://raw.githubusercontent.com/alireza0/x-ui/master/install.sh) ;;
      3) clear && bash <(curl -Ls https://raw.githubusercontent.com/FranzKafkaYu/x-ui/master/install.sh) ;;
      4) clear && bash <(curl -Ls https://gitlab.com/rwkgyg/x-ui-yg/raw/main/install.sh)  ;;
      5) clear && apk add curl && apk add bash && bash <(curl -Ls https://raw.githubusercontent.com/Lynn-Becky/Alpine-x-ui/main/alpine-xui.sh)  ;;

     11) clear && bash -c "$(curl -Lfo- https://raw.githubusercontent.com/hiddify/hiddify-config/main/common/download_install.sh)" ;;
     12) clear && echo -e "\n Todo: ... \n" ;;
     13) clear && sh -c "$(curl -sL https://github.com/daeuniverse/dae-installer/raw/main/installer.sh)" @ update-geoip update-geosite ;;
     14) clear && docker run -d --privileged --network=host --pid=host --restart=unless-stopped  -v /sys:/sys  -v /etc/daed:/etc/daed --name=daed ghcr.io/daeuniverse/daed:latest ;;
     15) clear && bash <(curl -Ls https://raw.githubusercontent.com/alireza0/s-ui/master/install.sh)  ;;

     24) clear && bash <(curl -Ls https://raw.githubusercontent.com/ppoonk/AirGo/main/server/scripts/install.sh)  ;;

      0) clear && clear && clear && clear && qiqtools ;;
      *) echo "无效的输入!" ;;
    esac  
    break_end
  done 

}

# 更新容器镜像
docker_container_update(){

  local dc_name=$1
  local dc_imag=$2
  local dc_port=$3
  local dc_user=$4
  local dc_pass=$5
  
  clear
  txtn " "
  txtn " >>> 删除容器$dc_name ..."
  docker rm -f "$dc_name"
  txtn " >>> 删除镜像$dc_imag ..."
  docker rmi -f "$dc_imag"

  txtn " >>> 重新构建容器$dc_name ..."
  $docker_rum

  clear
  txtn " "
  txtn " $dc_name 更新完成"
  txtn "↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓"

  if [ -n "$dc_port"]; then
    echo -e " 使用以下地址访问:"
    echo -e "http://$WAN4:$dc_port"
    echo -e "http://$[WAN6]:$dc_port"
  fi

  [[ -n "$dc_user" ]] && echo -e "     User: $dc_user"
  [[ -n "$dc_pass" ]] && echo -e " Password: $dc_pass"
  txtn "↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑"
  txtn " "
}

docker_app() {
  if docker inspect "$docker_name" &>/dev/null; then
      clear
      echo "$docker_name 已安装，访问地址: "
      # check_IP_address
      echo "http://$WAN4:$docker_port"
      echo "http://[$WAN6]:$docker_port"
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
              # check_IP_address
              echo "您可以使用以下地址访问:"
              echo "http://$WAN4:$docker_port"
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
          0) ;; # 跳出循环，退出菜单
          *) ;; # 跳出循环，退出菜单
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
              # 安装 Docker（请确保有 docker_install 函数）
              docker_install
              $docker_rum

              clear
              echo "$docker_name 已经安装完成"
              echo "------------------------"
              # 获取外部 IP 地址
              # check_IP_address
              echo "您可以使用以下地址访问:"
              echo "http://$WAN4:$docker_port"
              echo "http://[$WAN6]:$docker_port"
              echo "------------------------"
              $docker_use
              $docker_passwd

              ;;
          [Nn]) ;; # 用户选择不安装
            *) ;; # 无效输入
      esac
  fi
}

# 使用Docker compose部署ChatGPT-Next-Web
docker_deploy_chatgptnextweb(){

  local dc_name=chatgptnextweb
  local dcc_image=yidadaa/chatgpt-next-web

  local dcc_port=3001
  local dcc_code="543212345,7654321234567"

  reading "请输入OpenAI密钥：" OPENAI_API_KEY
  reading "请输入Gemini密钥：" GOOGLE_API_KEY

  # local OPENAI_API_KEY=$1
  # local GOOGLE_API_KEY=$2

  mkdir -p /home/dcc.d/${dc_name}
  cd /home/dcc.d/${dc_name}
  touch /home/dcc.d/${dc_name}/docker-compose.yml

  cat > /home/dcc.d/${dc_name}/docker-compose.yml << EOF
version: "3.9"
services:
  chatgpt-next-web-g:
    # profiles: [ "no-proxy" ]
    container_name: ${dc_name}
    image: $dcc_image
    restart: unless-stopped
    ports:
      - $dcc_port:3000
    environment:
      - OPENAI_API_KEY=$OPENAI_API_KEY
      - GOOGLE_API_KEY=$GOOGLE_API_KEY
      - CODE=$dcc_code
      - BASE_URL=$BASE_URL
      - OPENAI_ORG_ID=$OPENAI_ORG_ID
      - HIDE_USER_API_KEY=$HIDE_USER_API_KEY
      - DISABLE_GPT4=$DISABLE_GPT4
      - ENABLE_BALANCE_QUERY=$ENABLE_BALANCE_QUERY
      - DISABLE_FAST_LINK=$DISABLE_FAST_LINK
      - OPENAI_SB=$OPENAI_SB
      - CUSTOM_MODELS=-all,+gemini-pro
EOF

  # 启动容器
  docker-compose up -d

  # 是否绑定域名？
  echoR "是否需要绑定域名？[Y|N]"

  # 保存配置信息和访问链接
  touch /home/dcc.d/${dc_name}/${dc_name}.conf
  cat > /home/dcc.d/${dc_name}/${dc_name}.conf << EOF
    container_name = ${dc_name}
    URL(IPV4) = http://$WAN4:$dc_port
    URL(IPV6) = http://[$WAN6]:$dc_port
    OPENAI_API_KEY = $OPENAI_API_KEY
    GOOGLE_API_KEY = $GOOGLE_API_KEY
    CODE = $dcc_code
EOF
  echoG "是否保存配置文件？[Y|N](/home/dcc.d/${dc_name}/${dc_name}.conf)"

}

# 使用Docker compose部署MyIP
docker_deploy_myip(){

  local dc_name=myip
  local dcc_image=ghcr.io/jason5ng32/myip:latest

  local dcc_port=18966

  mkdir -p /home/dcc.d/${dc_name}
  cd /home/dcc.d/${dc_name}
  touch /home/dcc.d/${dc_name}/docker-compose.yml

  cat > /home/dcc.d/${dc_name}/docker-compose.yml << EOF
version: "3.9"
services:
  myip:
    container_name: ${dc_name}
    image: $dcc_image
    restart: unless-stopped
    ports:
      - $dcc_port:18966
EOF

  # 启动容器
  docker-compose up -d

  # 是否绑定域名？
  echoR "是否需要绑定域名？[Y|N]"

  # 保存配置信息和访问链接
  touch /home/dcc.d/${dc_name}/${dc_name}.conf
  cat > /home/dcc.d/${dc_name}/${dc_name}.conf << EOF
    container_name = ${dc_name}
    URL(IPV4) = http://$WAN4:$dc_port
    URL(IPV6) = http://[$WAN6]:$dc_port
    OPENAI_API_KEY = $OPENAI_API_KEY
    GOOGLE_API_KEY = $GOOGLE_API_KEY
    CODE = $dcc_code
EOF
  echoG "是否保存配置文件？[Y|N](/home/dcc.d/${dc_name}/${dc_name}.conf)"

}

docker_container_list_menu(){
txtn " "
txtn $(txbr "▼ Docker容器")$(txbg " ☪☪☪ ")
txtn "—————————————————————————————————————"
docker ps -a
txtn "====================================="
txtn $(txtn " 1.创建新的容器")$(txtg "✔")"       "$(txtn "11.启动所有容器")$(txtn "✔")
txtn $(txtn " 2.启动指定容器")$(txtg "✔")"       "$(txtn "12.暂停所有容器")$(txtn "✔")
txtn $(txtn " 3.停止指定容器")$(txtg "✔")"       "$(txtn "13.重启所有容器")$(txtn "✔")
txtn $(txty " 4.重启指定容器")$(txtc "✔")"       "$(txtn "14.删除所有容器")$(txtn "✔")
txtn $(txtn " 5.删除指定容器")$(txtg "✔")"       "$(txtp "15.进入指定容器")$(txtn "✔")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn $(txty "21.查看容器日志")$(txtp "✔")"       "$(txtn "31.查看容器网络")$(txtn "✔")
# txtn $(txtn " 1.Docker")$(txtg "✔")"      "$(txtn "11.Test")$(txtb "✘")
txtn "—————————————————————————————————————"
txtn $(txtn " 0.返回上级菜单")$(txtr "✖")"           "$(txtr "")$(txtb "")$(txtc "")
txtn " "  
}

docker_container_list_run() {
  while true; do
    clear && docker_container_list_menu
    reading "请选择: " choice

    case $choice in
      1) 
        read -p "请输入创建命令: " docker_cmd
        $docker_cmd
        ;;

      2) 
        read -p "请输入要启动的容器名: " dockername
        docker start $dockername
        ;;
      3) 
        read -p "请输入要停止的容器名: " dockername
        docker stop $dockername
        ;;
      4) 
        read -p "请输入要重启的容器名: " dockername
        docker restart $dockername
        ;;
      5) 
        clear 
        read -p "请输入要删除的容器名: " dockername
        docker rm $dockername
        ;;

     11) clear && docker start $(docker ps -a -q) ;;
     12) clear && docker stop $(docker ps -a -q) ;;
     13) clear && docker restart $(docker ps -a -q) ;;
     14) 
      read -p "确定删除所有容器吗？(Y/N): " choice
      case "$choice" in
        [Yy]) docker rm -f $(docker ps -a -q) ;;
        [Nn]) ;;
          *) echo "无效的选择，请输入 Y 或 N。" ;;
      esac
      ;;

     15) read -p "请输入容器名: " dockername && docker exec -it $dockername /bin/bash ;;

     21)  read -p "请输入容器名: " dockername && docker logs $dockername ;;
     31) 
      echo ""
      container_ids=$(docker ps -q)

      echo "------------------------------------------------------------"
      printf "%-25s %-25s %-25s\n" "容器名称" "网络名称" "IP地址"

      for container_id in $container_ids; do
          container_info=$(docker inspect --format '{{ .Name }}{{ range $network, $config := .NetworkSettings.Networks }} {{ $network }} {{ $config.IPAddress }}{{ end }}' "$container_id")

          container_name=$(echo "$container_info" | awk '{print $1}')
          network_info=$(echo "$container_info" | cut -d' ' -f2-)

          while IFS= read -r line; do
              network_name=$(echo "$line" | awk '{print $1}')
              ip_address=$(echo "$line" | awk '{print $2}')

              printf "%-20s %-20s %-15s\n" "$container_name" "$network_name" "$ip_address"
          done <<< "$network_info"
      done
      ;;
     
      0) clear && docker_run ;;
      *) echo "无效的输入!" ;;
    esac  
    break_end    
  done 
}

docker_images_list_menu(){
txtn " "
txtn $(txbr "▼ Docker镜像列表")$(txbg " ☪☪☪ ")
txtn "—————————————————————————————————————"
docker image ls
txtn "====================================="
txtn $(txtn " 1.获取指定镜像")$(txtg "✔")"       "$(txtn "")$(txtn "")
txtn $(txtn " 2.更新指定镜像")$(txtg "✔")"       "$(txtn "")$(txtn "")
txtn $(txtn " 3.删除指定镜像")$(txtg "✔")"       "$(txtn "")$(txtn "")
txtn $(txtn " 4.删除所有镜像")$(txtg "✔")"       "$(txtn "")$(txtn "")
# txtn $(txtn " 1.Docker")$(txtg "✔")"      "$(txtn "11.Test")$(txtb "✘")
txtn "—————————————————————————————————————"
txtn $(txtn " 0.返回上级菜单")$(txtr "✖")"           "$(txtr "")$(txtb "")$(txtc "")
txtn " "  
}

docker_images_list_run() {
  while true; do
    clear && docker_images_list_menu
    reading "请选择: " choice

    case $choice in
      1) read -p "请输入要获取的镜像名: " dockername && docker pull $dockername ;;
      2) read -p "请输入要更新的镜像名: " dockername && docker pull $dockername ;;
      3) read -p "请输入要删除的镜像名: " dockername && docker rmi -f $dockername ;;
      4) 
        read -p "确定删除所有镜像吗？(Y/N): " choice
        case "$choice" in
          [Yy]) docker rmi -f $(docker images -q) ;;
          [Nn]) ;;
             *)  echo "无效的选择，请输入 Y 或 N。" ;;
        esac
        ;;
     
      0) clear && docker_run ;;
      *) echo "无效的输入!" ;;
    esac  
    break_end    
  done 
}

docker_network_list_menu(){
txtn " "
txtn $(txbr "▼ Docker网络列表")$(txbg " ☪☪☪ ")
txtn "—————————————————————————————————————"
docker network ls
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
container_ids=$(docker ps -q)
printf "%-25s %-25s %-25s\n" "容器名称" "网络名称" "IP地址"

for container_id in $container_ids; do
    container_info=$(docker inspect --format '{{ .Name }}{{ range $network, $config := .NetworkSettings.Networks }} {{ $network }} {{ $config.IPAddress }}{{ end }}' "$container_id")

    container_name=$(echo "$container_info" | awk '{print $1}')
    network_info=$(echo "$container_info" | cut -d' ' -f2-)

    while IFS= read -r line; do
        network_name=$(echo "$line" | awk '{print $1}')
        ip_address=$(echo "$line" | awk '{print $2}')

        printf "%-20s %-20s %-15s\n" "$container_name" "$network_name" "$ip_address"
    done <<< "$network_info"
done

txtn " "
txtn "====================================="
txtn $(txtn " 1.创建网络")$(txtg "✔")"       "$(txtn "")$(txtn "")
txtn $(txtn " 2.加入网络")$(txtg "✔")"       "$(txtn "")$(txtn "")
txtn $(txtn " 3.退出网络")$(txtg "✔")"       "$(txtn "")$(txtn "")
txtn $(txtn " 4.删除网络")$(txtg "✔")"       "$(txtn "")$(txtn "")
# txtn $(txtn " 1.Docker")$(txtg "✔")"      "$(txtn "11.Test")$(txtb "✘")
txtn "—————————————————————————————————————"
txtn $(txtn " 0.返回上级菜单")$(txtr "✖")"           "$(txtr "")$(txtb "")$(txtc "")
txtn " "  
}

docker_network_list_run() {
  while true; do
    clear && docker_network_list_menu
    reading "请选择: " choice

    case $choice in
      1) read -p "设置新网络名: " dockernetwork && docker network create $dockernetwork ;;
      2) 
        read -p "加入网络名: " dockernetwork 
        read -p "那些容器加入该网络: " dockername 
        docker network connect $dockernetwork $dockername 
        ;;
      3) 
        read -p "退出网络名: " dockernetwork
        read -p "那些容器退出该网络: " dockername
        docker network disconnect $dockernetwork $dockername
        echo ""
        ;;
      4) 
        read -p "请输入要删除的网络名: " dockernetwork
        docker network rm $dockernetwork
        ;;
     
      0) clear && docker_run ;;
      *) echo "无效的输入!" ;;
    esac  
    break_end    
  done 
}

docker_volume_list_menu(){
txtn " "
txtn $(txbr "▼ Docker卷列表")$(txbg " ☪☪☪ ")
txtn "—————————————————————————————————————"
docker volume ls
txtn "====================================="
txtn $(txtn " 1.创建新卷")$(txtg "✔")"       "$(txtn "")$(txtn "")
txtn $(txtn " 2.删除卷")$(txtg "✔")"       "$(txtn "")$(txtn "")
# txtn $(txtn " 1.Docker")$(txtg "✔")"      "$(txtn "11.Test")$(txtb "✘")
txtn "—————————————————————————————————————"
txtn $(txtn " 0.返回上级菜单")$(txtr "✖")"           "$(txtr "")$(txtb "")$(txtc "")
txtn " "  
}

docker_volume_list_run() {
  while true; do
    clear && docker_volume_list_menu
    reading "请选择: " choice

    case $choice in
      1) 
        read -p "设置新卷名: " dockerjuan
        docker volume create $dockerjuan
        ;;
      
      2) 
        read -p "输入删除卷名: " dockerjuan
        docker volume rm $dockerjuan
        ;;
     
      0) clear && docker_run ;;
      *) echo "无效的输入!" ;;
    esac  
    break_end    
  done 
}
docker_menu() {
txtn " "
txtn $(txbr "▼ 容器管理")$(txbg " ☪☪☪ ")
txtn "—————————————————————————————————————"
WANIP_show 
txtn "====================================="
txtn $(txtn " 1.Docker环境安装")$(txtg "✔")"       "$(txtn "11.Docker查看状态")$(txtn "✔")
txtn $(txtn " 2.Docker环境卸载")$(txtg "✔")"       "$(txtn "12.Docker清理")$(txtn "✔")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn $(txtn "21.Docker容器管理")$(txtp "✔")"       "$(txtn "31.Docker网络管理")$(txtn "✔")
txtn $(txty "22.Docker镜像管理")$(txtp "✔")"       "$(txtn "32.Docker卷管理")$(txtn "✔")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn $(txtn "66.设置快捷键[dcc]")$(txtg "✔")"      "$(txtp "88.站点部署")$(txty "✔")
# txtn $(txtn " 1.Docker")$(txtg "✔")"      "$(txtn "11.Test")$(txtb "✘")
txtn "—————————————————————————————————————"
txtn $(txtn " 0.返回主菜单")$(txtr "✖")"           "$(txtr "")$(txtb "")$(txtc "")
txtn " "
}

docker_run() {
  while true; do
    clear && docker_menu
    reading "请选择: " choice

    case $choice in
      1) clear && docker_install ;;
      2) clear && docker_uninstall ;;

     11) clear && docker_info_list ;;
     12) clear && docker_clean ;;

     21) clear && docker_container_list_run ;;
     22) clear && docker_images_list_run ;;

     31) clear && docker_network_list_run ;;
     32) clear && docker_volume_list_run ;;

     66) clear && docker_set_1ckl "dcc" ;;
     88) clear && website_deploy_run ;;
      # 9) clear && chmod a+x /usr/local/bin/docker-compose && rm -rf `which dcc` && ln -s /usr/local/bin/docker-compose /usr/bin/dcc ;;
      
      0) clear && qiqtools ;;
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
            clear && clear && qiqtools
        fi
    else
        echo ""
    fi
}

add_yuming() {
  # check_IP_address
  unset yuming
  echo -e "先将域名解析到本机IP: ${red}$WAN4  ${blue}$WAN6${plain}"
  read -p "请输入你解析的域名: " yuming
  echo "$yuming"
}

# 反代域名
reverse_proxy() {
      # check_IP_address
      wget -O /home/web/conf.d/$yuming.conf https://raw.githubusercontent.com/kejilion/nginx/main/reverse-proxy.conf
      sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf
      sed -i "s/0.0.0.0/$WAN4/g" /home/web/conf.d/$yuming.conf
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

install_mariadb(){
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

install_redis(){
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
  wget -O /home/web/html/index.html https://gitlab.com/lmzxtek/clear && qiqtools/-/raw/main/src/caddy/index.html
  wget -O /home/web/caddy/default.conf https://gitlab.com/lmzxtek/clear && qiqtools/-/raw/main/src/caddy/default.conf

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

caddy_start(){ caddy start; }
caddy_stop(){  caddy stop;  }
caddy_status(){ sudo systemctl status caddy; }
caddy_reload(){ caddy_newcaddyfile; caddy reload; }

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
caddy_clean_cache(){ echo "Caddy会自动清除过期的缓存条目，无需额外操作。"; }

caddy_version(){
  caddy_version=$(caddy -v)
  caddy_version=$(echo "$caddy_version" | grep -oP "v/\K[0-9]+\.[0-9]+\.[0-9]+")
  echo -n "Caddy : v$caddy_version"
}

# 站点管理菜单
caddy_web_menu(){

clear

txtn "—————————————————————————————————————"
WANIP_show
txtn "====================================="
txtn $(txbr "▼ 站点目录")$(txbg " ✉✉✉ ")
txtb "-------------------------------------"
txtn $(txtn " 数据：")$(txtb " /home/web/html ")
txtn $(txtn " 配置：")$(txtb " /home/web/caddy")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn " "
txtn $(txbr "▼ 站点管理")$(txbg " 〠 ")
txtn "====================================="
txtn $(txtn " 1.查看站点列表")$(txtb "✔")"      "$(txtn "")$(txtb "")
txtn $(txtn " 2.查看分析报告")$(txtb "✔")"      "$(txtn "")$(txtb "")
txtn $(txtr " 3.更换站点域名")$(txtb "✔")"      "$(txtn "")$(txtb "")
txtn $(txtn " 4.添加站点域名")$(txtb "✔")"      "$(txtn "")$(txtb "")
txtn $(txtb " 5.删除指定站点")$(txtb "✔")"      "$(txtn "")$(txtb "")
txtn $(txtn " 6.清理站点缓存")$(txtb "✔")"      "$(txtn "")$(txtb "")
txtn "—————————————————————————————————————"
txtn $(txtn " 0.返回上级菜单")$(txtr "✖")
txtn " "
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
          0) WebSites_manager_run ;; # 跳出循环，退出菜单
          *) echo "无效的输入!" ;; # 跳出循环，退出菜单
      esac
      break_end
  done
}

# 网站管理菜单
WebSites_manager_menu() {

txtn " "
txtn $(txbr "▼ 站点管理")$(txbg " ❦ ")
txtn "—————————————————————————————————————"
WANIP_show
txtn "====================================="
txtn $(txtn " 1.安装LDNMP环境")$(txtb "✘")"      "$(txtn "11.更新LDNMP环境")$(txtb "✘")
txtn $(txtn " 2.卸载LDNMP环境")$(txtb "✘")"      "$(txtn "12.优化LDNMP环境")$(txtb "✘")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn $(txty "11.查看状态")$(txtg "✔")"           "$(txtn "21.安装PHP8.3")$(txtg "✔")
txtn $(txtn "12.安装Caddy")$(txtg "✔")"          "$(txtn "22.安装PHP8.2")$(txtg "✘")
txtn $(txtn "13.安装Nginx")$(txtg "✔")"          "$(txtn "23.安装PHP8.1")$(txtb "✘")
txtn $(txtn "14.安装OpenLiteSpeed")$(txtg "✔")"  "$(txtn "24.安装PHP7.4")$(txtb "✔")
# txtn $(txtn "15.安装Nginx")$(txtb "✘")"          "$(txtn "")$(txtb "")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn $(txtn "31.站点列表")$(txtg "✔")"           "$(txtn "41.重启服务")$(txtg "✔")
txtn $(txtn "32.站点管理")$(txtg "✔")"           "$(txtn "42.停止服务")$(txtg "✔")
txtn $(txtn "33.添加重定向")$(txtg "✔")"         "$(txtn "43.更新服务")$(txtg "✔")
txtn $(txty "34.添加反向代理")$(txtg "✔")"       "$(txtn "44.删除服务")$(txtb "✘")
txtn $(txtn "35.添加静态站点")$(txtg "✔")"       "$(txtn "") $(txtb "")
txtn "====================================="
txtn $(txtn "61.安装Redis")$(txtg "✔")"          "$(txtn "")$(txtb "")
txtn $(txtn "62.安装MySQL")$(txtb "✘")"          "$(txtn "")$(txtb "")
txtn $(txtn "63.安装MariaDB")$(txtb "✘")"        "$(txtn "")$(txtb "")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn $(txtn "88.站点防御程序")$(txtb "✘")
txtn "—————————————————————————————————————"
txtn $(txtn " 0.返回主菜单")$(txtr "✖")
txtn " "
}

WebSites_manager_run(){

  if [ -d /etc/caddy ]; then
    cd /etc/caddy
  fi

  check_IP_address

  while true; do
    clear && WebSites_manager_menu
    reading "请选择: " choice

    case $choice in
     11) caddy_status ;;
     12) clear && caddy_install ;;
     13) 
        #  安装Nginx

        # nginx_docker
        nginx_install
        # install nginx

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

     21) clear && install_php83 ;;
     22) clear && install_php74 ;;

     31) caddy_web_list ;;
     32) caddy_web_manager ;;
     33)
        # check_IP_address
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
        add_yuming
        read -p "请输入web概目录: " rootpath 

        caddy_staticweb $yuming $rootpath

        # caddy_newcaddyfile
        caddy_reload
        
        echo -e "\n您的静态网站搭建好了！"
        echo "https://$yuming"
        echo ""
        ;;

     41) caddy_reload ;;
     42) caddy_start ;;
     43) caddy_stop ;;
     44) caddy_uninstall ;;

     61) clear && install_redis ;;
     62) clear && mysql_install ;;
     63) clear && install_mariadb ;;

    #  61) clear && install redis-server ;;
    #  62) clear && install mysql-server ;;
    #  63) clear && install mariadb-server ;;

      0) clear && qiqtools ;;
      *) echo "无效的输入!" ;;
    esac  
    break_end    
  done 
}

# 脚本更新
script_update(){
  cd ~
  echo -e "\n脚本链接:\n>> ${blue}https://gitlab.com/lmzxtek/qiqtools/-/raw/main/qiqtools.sh${plain}"
  curl -sS -O https://gitlab.com/lmzxtek/qiqtools/-/raw/main/qiqtools.sh && chmod +x qiqtools.sh
  echo -e "\n脚本已更新至最新版本！\n按任意键重新加载脚本..."
  echo -e ""
  break_end #&& exit && qiq
  qiq_reload
}


show_header_qiq(){

# txtn " "$(txtg "  ░███   ") $(txtc "░████") $(txtg "  ░███   ")
# txtn " "$(txtg " ░██ ░██ ") $(txtc " ░██ ") $(txtg " ░██ ░██ ")
# txtn " "$(txtg "░██   ░██") $(txtc " ░██ ") $(txtg "░██   ░██")
# txtn " "$(txtg " ░██ ░██ ") $(txtc " ░██ ") $(txtg " ░██ ░██ ")
# txtn " "$(txtg "   ░██ ██") $(txtc "░████") $(txtg "   ░██ ██")
# txtn $(txtb "─┬─╭─╮╭─╮┬ ╭─╮")
# txtn $(txtb " │ │ ││ ││ ╰─╮")
# txtn $(txtb " │ ╰─╯╰─╯╰─╰─╯")$(txtc "  ✟  ")$(txtn "快捷命令")$(txtc "☞")$(txty " qiq ")$(txtc "☜")

# echo -e "
#  ${green}  ░███     ${cyan}░████  ${green}  ░███   ${plain}
#  ${green} ░██ ░██   ${cyan} ░██   ${green} ░██ ░██ ${plain}
#  ${green}░██   ░██  ${cyan} ░██   ${green}░██   ░██${plain}
#  ${green} ░██ ░██   ${cyan} ░██   ${green} ░██ ░██ ${plain}
#  ${green}   ░██ ██  ${cyan}░████  ${green}   ░██ ██${plain}

# ${blue}─┬─╭─╮╭─╮┬ ╭─╮${plain}  
# ${blue} │ │ ││ ││ ╰─╮${plain}  
# ${blue} │ ╰─╯╰─╯╰─╰─╯${plain}   ${cyan}✟${plain} 快捷命令 ${cyan}☞ ${yellow}qiq${cyan} ☜${plain}"

echo -e "
 ${green}  ░███     ${cyan}░████  ${green}  ░███   ${plain}
 ${green} ░██ ░██   ${cyan} ░██   ${green} ░██ ░██ ${plain}
 ${green}░██   ░██  ${cyan} ░██   ${green}░██   ░██${plain}
 ${green} ░██ ░██   ${cyan} ░██   ${green} ░██ ░██ ${plain}
 ${green}   ░██ ██  ${cyan}░████  ${green}   ░██ ██${plain}

${blue}─┬─╭─╮╭─╮┬ ╭─╮${plain}  
${blue} │ │ ││ ││ ╰─╮${plain}  
${blue} │ ╰─╯╰─╯╰─╰─╯${plain}   ${cyan}♧♧${plain} QiQTools ${blue}$script_version${plain}"

}

# 显示主菜单
main_menu() {
txtn "—————————————————————————————————————"
WANIP_show
txtn "====================================="
txtn $(txty " 1.系统信息")$(txty "☄")"       "$(txtn "11.容器管理")$(txtp "☪")
txtn $(txtn " 2.系统更新")$(txtb "☣")"       "$(txty "12.站点管理")$(txtr "◎")
txtn $(txtn " 3.系统清理")$(txtb "☒")"       "$(txtp "13.站点部署")$(txtb "❈")
txtn "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
txtn $(txty "21.系统工具")$(txtp "❁")"       "$(txtn "31.性能测试")$(txtb "☯")
txtn $(txtn "22.常用工具")$(txtn "❃")"       "$(txtp "32.节点搭建")$(txty "✈")
txtn $(txtn "23.其他工具")$(txtb "の")"      "$(txtc "33.节点面板")$(txty "⊕")
txtn "====================================="
txtn $(txtb "00.脚本更新")$(txtb "☋")"       "$(txty "99")$(txtc ".重启系统☢")
txtn "—————————————————————————————————————"
# txtn $(txtn " 1.Docker")$(txtg "✔")"        "$(txtn "11.Test")$(txtb "✘")
# txtn $(txtn " 0.退出脚本")$(txtr "✖")"       "$(txtb "♧♧ ")$(txtc "QiQTools") $(txtb "$script_version")
txtn $(txtn " 0.退出脚本")$(txtr "✖")"       "$(txtp "✟✟ ")$(txtc "快捷命令")$(txtb "☞") $(txty "qiq") $(txtb "☜")
txtn " "
}


# Main Loops for the scripts
main_loop(){
while true; do
  clear && cd ~ && show_header_qiq && main_menu 
  reading "请输入你的选择: " choice

  case $choice in
     1) clear && system_info ;;
     2) clear && update_and_upgrade ;;
     3) clear && clean_sys ;;

    11) clear && docker_run ;;
    12) clear && WebSites_manager_run ;;
    13) clear && website_deploy_run  ;;

    21) clear && system_setting_run ;;
    22) clear && common_apps_run  ;;
    23) clear && other_tools_run  ;;

    31) clear && server_test_run  ;;
    32) clear && warp_tools_run   ;;
    33) clear && board_panels_run  ;;

    00) script_update ;;
    99) echo "正在重启服务器，即将断开SSH连接" && reboot  ;;
     0) exit ;;
     *) echo "无效的输入!" ;;
  esac  
  break_end
done
}

# check_IP_address
clear
get_sysinfo
main_loop