#!/bin/bash

#========================================================
#   System Required: CentOS 7+ | Debian 8+ | Ubuntu 16+ | Alpine 3+ |
#   Description: QiQ一键安装脚本
#   GitHub : https://github.com/lmzxtek/qiqtools
#   GitCode: https://gitcode.com/lmzxtek/qiqtools
#
#   一键安装命令如下：
#   $> wget -qO qiqtools.sh https://sub.zwdk.org/qiq && chmod +x qiqtools.sh && ./qiqtools.sh
#   $> curl -sSL -o qiqtools.sh https://sub.zwdk.org/qiq && chmod +x qiqtools.sh && ./qiqtools.sh

#   $> wget -qN https://raw.gitcode.com/lmzxtek/qiqtools/raw/main/qiqtools.sh && chmod +x qiqtools.sh && ./qiqtools.sh
#   $> curl -sS -O https://raw.gitcode.com/lmzxtek/qiqtools/raw/main/qiqtools.sh && chmod +x qiqtools.sh && ./qiqtools.sh
#========================================================


#==== 脚本版本号 ===========
SRC_VER=v0.7.1
#==========================


URL_REDIRECT='https://sub.zwdk.org/qiq'
URL_SCRIPT='https://raw.githubusercontent.com/lmzxtek/qiqtools/refs/heads/main/qiqtools.sh'
URL_UPDATE='https://raw.githubusercontent.com/lmzxtek/qiqtools/refs/heads/main/update_log.sh'
URL_PROXY='https://proxy.zwdk.org/proxy/'

# 设置脚本的快捷命令为 `qiq`
function set_qiq_alias() {
  echo -e "\n >>> 设置 qiq 快捷命令 ... "
  if ! command -v qiq &>/dev/null; then
    echo -e "\n >>> qiq 快捷命令未设置 ... "
    ln -sf ~/qiqtools.sh /usr/local/bin/qiq
  fi
}


# 颜色定义
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
CYAN='\e[36m'
PURPLE='\033[35m'
PLAIN='\033[0m'
AZURE='\033[36m'
RESET='\033[0m'
BOLD='\033[1m'
MAGENTA='\e[35m'

SUCCESS="\033[1;32m✅${PLAIN}"
COMPLETE="\033[1;32m✔${PLAIN}"
WARN="\033[1;36m⚠️${PLAIN}"
ERROR="\033[1;31m✘${PLAIN}"
FAIL="\033[1;31m✘${PLAIN}"
TIP="\033[1;36m💡${PLAIN}"
WORKING="\033[1;36m✨️ ${PLAIN}"

# Emoji: 💡🧹🎉⚙️🔧🎯💧📡

## 报错退出
function output_error() {
    [ "$1" ] && echo -e "\n$ERROR $1\n"
    exit 1
}

## 权限判定
function permission_judgment() {
    if [ $UID -ne 0 ]; then
        output_error "权限不足，请使用 Root 用户运行本脚本"
    fi
}

# 定义颜色渐变函数，返回带颜色的字符串
function gradient_text() {
  local text=$1
  local gradient=("${!2}") # 获取颜色渐变数组
  local length=${#text}
  local result=""

  for ((i = 0; i < length; i++)); do
    char=${text:i:1}
    color_code=${gradient[$((i % ${#gradient[@]}))]}
    result+=$(echo -en "\e[38;5;${color_code}m${char}\e[0m")
  done

  echo "$result"
}


## 定义系统判定变量
SYSTEM_DEBIAN="Debian"
SYSTEM_UBUNTU="Ubuntu"
SYSTEM_KALI="Kali"
SYSTEM_DEEPIN="Deepin"
SYSTEM_LINUX_MINT="Linuxmint"
SYSTEM_ZORIN="Zorin"
SYSTEM_REDHAT="RedHat"
SYSTEM_RHEL="Red Hat Enterprise Linux"
SYSTEM_CENTOS="CentOS"
SYSTEM_CENTOS_STREAM="CentOS Stream"
SYSTEM_ROCKY="Rocky"
SYSTEM_ALMALINUX="AlmaLinux"
SYSTEM_FEDORA="Fedora"
SYSTEM_OPENCLOUDOS="OpenCloudOS"
SYSTEM_OPENCLOUDOS_STREAM="OpenCloudOS Stream"
SYSTEM_OPENEULER="openEuler"
SYSTEM_ANOLISOS="Anolis"
SYSTEM_OPENKYLIN="openKylin"
SYSTEM_OPENSUSE="openSUSE"
SYSTEM_ARCH="Arch"
SYSTEM_ALPINE="Alpine"
SYSTEM_GENTOO="Gentoo"
SYSTEM_NIXOS="NixOS"

## 定义系统版本文件
File_LinuxRelease=/etc/os-release
File_RedHatRelease=/etc/redhat-release
File_DebianVersion=/etc/debian_version
File_ArmbianRelease=/etc/armbian-release
File_openEulerRelease=/etc/openEuler-release
File_OpenCloudOSRelease=/etc/opencloudos-release
File_AnolisOSRelease=/etc/anolis-release
File_OracleLinuxRelease=/etc/oracle-release
File_ArchLinuxRelease=/etc/arch-release
File_AlpineRelease=/etc/alpine-release
File_GentooRelease=/etc/gentoo-release
File_openKylinVersion=/etc/kylin-version/kylin-system-version.conf
File_ProxmoxVersion=/etc/pve/.version

## 定义软件源相关文件或目录
File_DebianSourceList=/etc/apt/sources.list
File_DebianSourceListBackup=/etc/apt/sources.list.bak
File_DebianSources=/etc/apt/sources.list.d/debian.sources
File_DebianSourcesBackup=/etc/apt/sources.list.d/debian.sources.bak
File_UbuntuSources=/etc/apt/sources.list.d/ubuntu.sources
File_UbuntuSourcesBackup=/etc/apt/sources.list.d/ubuntu.sources.bak
File_ArmbianSourceList=/etc/apt/sources.list.d/armbian.list
File_ArmbianSourceListBackup=/etc/apt/sources.list.d/armbian.list.bak
File_ProxmoxSourceList=/etc/apt/sources.list.d/pve-no-subscription.list
File_ProxmoxSourceListBackup=/etc/apt/sources.list.d/pve-no-subscription.list.bak
File_LinuxMintSourceList=/etc/apt/sources.list.d/official-package-repositories.list
File_LinuxMintSourceListBackup=/etc/apt/sources.list.d/official-package-repositories.list.bak
File_ArchLinuxMirrorList=/etc/pacman.d/mirrorlist
File_ArchLinuxMirrorListBackup=/etc/pacman.d/mirrorlist.bak
File_AlpineRepositories=/etc/apk/repositories
File_AlpineRepositoriesBackup=/etc/apk/repositories.bak
File_GentooMakeConf=/etc/portage/make.conf
File_GentooMakeConfBackup=/etc/portage/make.conf.bak
File_GentooReposConf=/etc/portage/repos.conf/gentoo.conf
File_GentooReposConfBackup=/etc/portage/repos.conf/gentoo.conf.bak
File_NixConf=/etc/nix/nix.conf
File_NixConfBackup=/etc/nix/nix.conf.bak
Dir_GentooReposConf=/etc/portage/repos.conf
Dir_DebianExtendSource=/etc/apt/sources.list.d
Dir_DebianExtendSourceBackup=/etc/apt/sources.list.d.bak
Dir_YumRepos=/etc/yum.repos.d
Dir_YumReposBackup=/etc/yum.repos.d.bak
Dir_ZYppRepos=/etc/zypp/repos.d
Dir_ZYppReposBackup=/etc/zypp/repos.d.bak
Dir_NixConfig=/etc/nix


function init_global_vars(){
    
    blue_green_gradient=("118" "154" "82" "34" "36" "46" ) # 蓝色到绿色的渐变颜色代码
    CONSTSTR='QiQ Tools'
    CONSTSTR=$(gradient_text "${CONSTSTR}" blue_green_gradient[@])

    NUM_SPLIT=${NUM_SPLIT:-4}           # 左右栏的宽度间隔
    NUM_WIDTH=${NUM_WIDTH:-3}           # 序号最大宽度
    MAX_COL_NUM=${MAX_COL_NUM:-25}      # 单栏字符串最大宽度，默认为30
    ITEM_CAT_CHAR=${ITEM_CAT_CHAR:-'.'} # 序号与字符连接字符，默认为 '.'

    MAX_SPLIT_CHAR_NUM=${MAX_SPLIT_CHAR_NUM:-42} # 最大分割字符数量，默认为42
}


## 收集系统信息
function collect_system_info() {
    ## 定义系统名称
    SYSTEM_NAME="$(cat $File_LinuxRelease | grep -E "^NAME=" | awk -F '=' '{print$2}' | sed "s/[\'\"]//g")"
    grep -q "PRETTY_NAME=" $File_LinuxRelease && SYSTEM_PRETTY_NAME="$(cat $File_LinuxRelease | grep -E "^PRETTY_NAME=" | awk -F '=' '{print$2}' | sed "s/[\'\"]//g")"
    ## 定义系统版本号
    SYSTEM_VERSION_NUMBER="$(cat $File_LinuxRelease | grep -E "^VERSION_ID=" | awk -F '=' '{print$2}' | sed "s/[\'\"]//g")"
    SYSTEM_VERSION_NUMBER_MAJOR="${SYSTEM_VERSION_NUMBER%.*}"
    SYSTEM_VERSION_NUMBER_MINOR="${SYSTEM_VERSION_NUMBER#*.}"
    ## 定义系统ID
    SYSTEM_ID="$(cat $File_LinuxRelease | grep -E "^ID=" | awk -F '=' '{print$2}' | sed "s/[\'\"]//g")"
    ## 判定当前系统派系
    if [ -s $File_DebianVersion ]; then
        SYSTEM_FACTIONS="${SYSTEM_DEBIAN}"
    elif [ -s $File_OracleLinuxRelease ]; then
        # output_error "当前操作系统不在本脚本的支持范围内，请前往官网查看支持列表！"
        echo -e "$ERROR 当前操作系统不在本脚本的支持范围内，请前往官网查看支持列表！"
    elif [ -s $File_RedHatRelease ]; then
        SYSTEM_FACTIONS="${SYSTEM_REDHAT}"
    elif [ -s $File_openEulerRelease ]; then
        SYSTEM_FACTIONS="${SYSTEM_OPENEULER}"
    elif [ -s $File_OpenCloudOSRelease ]; then
        SYSTEM_FACTIONS="${SYSTEM_OPENCLOUDOS}" # 自 9.0 版本起不再基于红帽
    elif [ -s $File_AnolisOSRelease ]; then
        SYSTEM_FACTIONS="${SYSTEM_ANOLISOS}" # 自 8.8 版本起不再基于红帽
    elif [ -s $File_openKylinVersion ]; then
        SYSTEM_FACTIONS="${SYSTEM_OPENKYLIN}"
    elif [ -f $File_ArchLinuxRelease ]; then
        SYSTEM_FACTIONS="${SYSTEM_ARCH}"
    elif [ -f $File_AlpineRelease ]; then
        SYSTEM_FACTIONS="${SYSTEM_ALPINE}"
    elif [ -f $File_GentooRelease ]; then
        SYSTEM_FACTIONS="${SYSTEM_GENTOO}"
    elif [[ "${SYSTEM_NAME}" == *"openSUSE"* ]]; then
        SYSTEM_FACTIONS="${SYSTEM_OPENSUSE}"
    elif [[ "${SYSTEM_NAME}" == *"NixOS"* ]]; then
        SYSTEM_FACTIONS="${SYSTEM_NIXOS}"
    else
        # output_error "当前操作系统不在本脚本的支持范围内，请前往官网查看支持列表！"
        echo -e "$ERROR 当前操作系统不在本脚本的支持范围内，请前往官网查看支持列表！"
    fi
    ## 判定系统类型、版本、版本号
    case "${SYSTEM_FACTIONS}" in
    "${SYSTEM_DEBIAN}" | "${SYSTEM_OPENKYLIN}")
        local os_info=$(lsb_release -ds 2>/dev/null)
            
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
            SYSTEM_JUDGMENT="${os_info}"
            SYSTEM_VERSION_CODENAME="${os_info}"
        else
            SYSTEM_JUDGMENT="$(lsb_release -is)"
            SYSTEM_VERSION_CODENAME="${DEBIAN_CODENAME:-"$(lsb_release -cs)"}"
        fi
        # if [ ! -x /usr/bin/lsb_release ]; then
        #     apt-get install -y lsb-release
        #     if [ $? -ne 0 ]; then
        #         # output_error "lsb-release 软件包安装失败\n\n本脚本依赖 lsb_release 指令判断系统具体类型和版本，当前系统可能为精简安装，请自行安装后重新执行脚本！"
        #         echo -e "$ERROR lsb-release 软件包安装失败\n\n本脚本依赖 lsb_release 指令判断系统具体类型和版本，当前系统可能为精简安装，请自行安装后重新执行脚本！"
        #     fi
        # fi
        ;;
    "${SYSTEM_REDHAT}")
        SYSTEM_JUDGMENT="$(awk '{printf $1}' $File_RedHatRelease)"
        ## 特殊系统判断
        # Red Hat Enterprise Linux
        grep -q "${SYSTEM_RHEL}" $File_RedHatRelease && SYSTEM_JUDGMENT="${SYSTEM_RHEL}"
        # CentOS Stream
        grep -q "${SYSTEM_CENTOS_STREAM}" $File_RedHatRelease && SYSTEM_JUDGMENT="${SYSTEM_CENTOS_STREAM}"
        ;;
    *)
        SYSTEM_JUDGMENT="${SYSTEM_FACTIONS}"
        ;;
    esac
    ## 判断系统及版本是否适配
    local is_supported="true"
    case "${SYSTEM_JUDGMENT}" in
    "${SYSTEM_DEBIAN}")
        if [[ "${SYSTEM_VERSION_NUMBER_MAJOR}" -lt 8 || "${SYSTEM_VERSION_NUMBER_MAJOR}" -gt 13 ]]; then
            is_supported="false"
        fi
        ;;
    "${SYSTEM_UBUNTU}")
        if [[ "${SYSTEM_VERSION_NUMBER_MAJOR}" -lt 14 || "${SYSTEM_VERSION_NUMBER_MAJOR}" -gt 24 ]]; then
            is_supported="false"
        fi
        ;;
    "${SYSTEM_LINUX_MINT}")
        if [[ "${SYSTEM_VERSION_NUMBER_MAJOR}" != 19 && "${SYSTEM_VERSION_NUMBER_MAJOR}" != 2[0-2] && "${SYSTEM_VERSION_NUMBER_MAJOR}" != 6 ]]; then
            is_supported="false"
        fi
        ;;
    "${SYSTEM_RHEL}")
        if [[ "${SYSTEM_VERSION_NUMBER_MAJOR}" != [7-9] ]]; then
            is_supported="false"
        fi
        ;;
    "${SYSTEM_CENTOS}")
        if [[ "${SYSTEM_VERSION_NUMBER_MAJOR}" != [7-8] ]]; then
            is_supported="false"
        fi
        ;;
    "${SYSTEM_CENTOS_STREAM}" | "${SYSTEM_ROCKY}" | "${SYSTEM_ALMALINUX}")
        if [[ "${SYSTEM_VERSION_NUMBER_MAJOR}" != [8-9] ]]; then
            is_supported="false"
        fi
        ;;
    "${SYSTEM_FEDORA}")
        if [[ "${SYSTEM_VERSION_NUMBER}" != [3-4][0-9] ]]; then
            is_supported="false"
        fi
        ;;
    "${SYSTEM_OPENEULER}")
        if [[ "${SYSTEM_VERSION_NUMBER_MAJOR}" != 2[1-4] ]]; then
            is_supported="false"
        fi
        ;;
    "${SYSTEM_OPENCLOUDOS}")
        if [[ "${SYSTEM_VERSION_NUMBER_MAJOR}" != [8-9] && "${SYSTEM_VERSION_NUMBER_MAJOR}" != 23 ]] || [[ "${SYSTEM_VERSION_NUMBER_MAJOR}" == 8 && "$SYSTEM_VERSION_NUMBER_MINOR" -lt 6 ]]; then
            is_supported="false"
        fi
        ;;
    "${SYSTEM_ANOLISOS}")
        if [[ "${SYSTEM_VERSION_NUMBER_MAJOR}" != 8 && "${SYSTEM_VERSION_NUMBER_MAJOR}" != 23 ]]; then
            is_supported="false"
        fi
        ;;
    "${SYSTEM_OPENSUSE}")
        case "${SYSTEM_ID}" in
        "opensuse-leap")
            if [[ "${SYSTEM_VERSION_NUMBER_MAJOR}" != 15 ]]; then
                is_supported="false"
            fi
            ;;
        "opensuse-tumbleweed") ;;
        *)
            is_supported="false"
            ;;
        esac
        ;;
    "${SYSTEM_KALI}" | "${SYSTEM_DEEPIN}" | "${SYSTEM_ZORIN}" | "${SYSTEM_ARCH}" | "${SYSTEM_ALPINE}" | "${SYSTEM_GENTOO}" | "${SYSTEM_OPENKYLIN}" | "${SYSTEM_NIXOS}")
        # 理论全部支持或不作判断
        ;;
    *)
        # output_error "当前操作系统不在本脚本的支持范围内，请前往官网查看支持列表！"
        echo -e "$ERROR 当前操作系统不在本脚本的支持范围内，请前往官网查看支持列表！"
        ;;
    esac
    if [[ "${is_supported}" == "false" ]]; then
        # output_error "当前系统版本不在本脚本的支持范围内，请前往官网查看支持列表！"
        echo -e "$ERROR 当前操作系统不在本脚本的支持范围内，请前往官网查看支持列表！"
    fi
    ## 判定系统处理器架构
    case "$(uname -m)" in
    x86_64)
        DEVICE_ARCH="x86_64"
        ;;
    aarch64)
        DEVICE_ARCH="ARM64"
        ;;
    armv7l)
        DEVICE_ARCH="ARMv7"
        ;;
    armv6l)
        DEVICE_ARCH="ARMv6"
        ;;
    i686)
        DEVICE_ARCH="x86_32"
        ;;
    *)
        DEVICE_ARCH="$(uname -m)"
        ;;
    esac
    ## 定义软件源仓库名称
    if [[ -z "${SOURCE_BRANCH}" ]]; then
        ## 默认为系统名称小写，替换空格
        SOURCE_BRANCH="${SYSTEM_JUDGMENT,,}"
        SOURCE_BRANCH="${SOURCE_BRANCH// /-}"
        ## 处理特殊的仓库名称
        case "${SYSTEM_JUDGMENT}" in
        "${SYSTEM_DEBIAN}")
            case "${SYSTEM_VERSION_NUMBER_MAJOR}" in
            8 | 9 | 10)
                SOURCE_BRANCH="debian-archive" # EOF
                ;;
            *)
                SOURCE_BRANCH="debian"
                ;;
            esac
            ;;
        "${SYSTEM_UBUNTU}" | "${SYSTEM_ZORIN}")
            if [[ "${DEVICE_ARCH}" == "x86_64" || "${DEVICE_ARCH}" == *i?86* ]]; then
                SOURCE_BRANCH="ubuntu"
            else
                SOURCE_BRANCH="ubuntu-ports"
            fi
            ;;
        "${SYSTEM_RHEL}")
            case "${SYSTEM_VERSION_NUMBER_MAJOR}" in
            9)
                SOURCE_BRANCH="centos-stream" # 使用 CentOS Stream 仓库
                ;;
            *)
                SOURCE_BRANCH="centos-vault" # EOF
                ;;
            esac
            ;;
        "${SYSTEM_CENTOS}")
            if [[ "${DEVICE_ARCH}" == "x86_64" ]]; then
                SOURCE_BRANCH="centos-vault" # EOF
            else
                SOURCE_BRANCH="centos-altarch"
            fi
            ;;
        "${SYSTEM_CENTOS_STREAM}")
            # 自 CentOS Stream 9 开始使用 centos-stream 仓库，旧版本使用 centos 仓库
            case "${SYSTEM_VERSION_NUMBER_MAJOR}" in
            8)
                if [[ "${DEVICE_ARCH}" == "x86_64" ]]; then
                    SOURCE_BRANCH="centos-vault" # EOF
                else
                    SOURCE_BRANCH="centos-altarch"
                fi
                ;;
            *)
                SOURCE_BRANCH="centos-stream"
                ;;
            esac
            ;;
        "${SYSTEM_FEDORA}")
            if [[ "${SYSTEM_VERSION_NUMBER}" -lt 39 ]]; then
                SOURCE_BRANCH="fedora-archive"
            fi
            ;;
        "${SYSTEM_ARCH}")
            if [[ "${DEVICE_ARCH}" == "x86_64" || "${DEVICE_ARCH}" == *i?86* ]]; then
                SOURCE_BRANCH="archlinux"
            else
                SOURCE_BRANCH="archlinuxarm"
            fi
            ;;
        "${SYSTEM_OPENCLOUDOS}")
            # OpenCloudOS Stream
            grep -q "${SYSTEM_OPENCLOUDOS_STREAM}" $File_OpenCloudOSRelease
            if [ $? -eq 0 ]; then
                SOURCE_BRANCH="${SYSTEM_OPENCLOUDOS_STREAM,,}"
                SOURCE_BRANCH="${SOURCE_BRANCH// /-}"
            fi
            ;;
        "${SYSTEM_NIXOS}")
            SOURCE_BRANCH="nix-channels"
            ;;
        esac
    fi
    ## 定义软件源更新文字
    case "${SYSTEM_FACTIONS}" in
    "${SYSTEM_DEBIAN}" | "${SYSTEM_ALPINE}" | "${SYSTEM_OPENKYLIN}")
        SYNC_MIRROR_TEXT="更新软件源"
        ;;
    "${SYSTEM_REDHAT}" | "${SYSTEM_OPENEULER}" | "${SYSTEM_OPENCLOUDOS}" | "${SYSTEM_ANOLISOS}")
        SYNC_MIRROR_TEXT="生成软件源缓存"
        ;;
    "${SYSTEM_OPENSUSE}")
        SYNC_MIRROR_TEXT="刷新软件源"
        ;;
    "${SYSTEM_ARCH}" | "${SYSTEM_GENTOO}")
        SYNC_MIRROR_TEXT="同步软件源"
        ;;
    "${SYSTEM_NIXOS}")
        SYNC_MIRROR_TEXT="更新二进制缓存与频道源"
        ;;
    esac
    ## 判断是否可以使用高级交互式选择器
    CAN_USE_ADVANCED_INTERACTIVE_SELECTION="false"
    if [ ! -z "$(command -v tput)" ]; then
        CAN_USE_ADVANCED_INTERACTIVE_SELECTION="true"
    fi
}



## 计算输入字符串字符数量，检测中文字符和Emoji字符
function str_width_awk() {
    echo -n "$1" | awk '{
        len=0
        for (i=1; i<=length($0); i++) {
            c=substr($0, i, 1)
            if (c ~ /[一-龥]/) { len+=2 }  # 处理中文全角字符
            else if (c ~ /[\x{1F600}-\x{1F64F}]/) { len+=2 }  # 处理Emoji
            else { len+=1 }
        }
        print len
    }'
}


function get_split_list() {
    local items=("${@}")
    local result=()
    
    for i in "${!items[@]}"; do
        if [[ ! "${items[i]}" =~ ^[0-9] ]]; then  # 只要不是数字开头的项，就作为分割线
            result+=("$i")  # 记录分隔符的位置索引
        fi
    done
    
    echo "${result[@]}"  # 输出所有分割线的位置索引
}

# 生成重复字符的分割行，并应用颜色
function generate_separator() {
    local separator_info="$1"
    local count="$2"
    
    # 解析分割符和颜色
    IFS='|' read -r separator color <<< "$separator_info"
    
    # 颜色默认值（如果未提供颜色）
    color=${color:-$RESET}
    
    local first_char="${separator:0:1}"  # 取分割符的第一个字符
    
    # 颜色化输出分割线
    echo -e "${color}$(printf "%0.s$first_char" $(seq 1 "$count"))${RESET}"
}

## 菜单项按2栏显示
function print_sub_menu_items() {
    local items=("${@}")
    local total_items=${#items[@]}
    local half=$(( (total_items + 1) / 2 ))  # 计算左右分栏

    for ((i=0; i<half; i++)); do
        local left_item=${items[i]}
        local right_index=$((i + half))
        local right_item=${items[right_index]:-}  # 可能为空

        # 解析左栏
        IFS='|' read -r l_num l_text l_color <<< "$left_item"
        l_color=${l_color:-$RESET}  # 默认颜色
        local l_formatted="${l_color}${ITEM_CAT_CHAR}$l_text$RESET"
        # 计算中文字符数量
        chinese_left=$(echo -n "$l_formatted" | grep -oP '[\p{Han}]' | wc -l)
        # 计算Emoji数量
        emoji_count=$(echo -n "$l_formatted" | grep -oP "[\x{1F600}-\x{1F64F}\x{1F300}-\x{1F5FF}]" | wc -l)
        adj_left_width=$((MAX_COL_NUM + chinese_left + emoji_count + chinese_left + emoji_count))

        adj_split_num=$((NUM_SPLIT - chinese_left - emoji_count ))

        # 解析右栏（如果有的话）
        if [ -n "$right_item" ]; then
            IFS='|' read -r r_num r_text r_color <<< "$right_item"
            r_color=${r_color:-$RESET}  # 默认颜色
            local r_formatted="${r_color}${ITEM_CAT_CHAR}$r_text$RESET"
            printf "%${NUM_WIDTH}d%-${adj_left_width}b%${adj_split_num}s%${NUM_WIDTH}d%-${MAX_COL_NUM}b\n" \
                    $l_num "$l_formatted" "" $r_num "$r_formatted"
        else
            local r_formatted=""
            printf "%${NUM_WIDTH}d%-${adj_left_width}b\n" $l_num "$l_formatted"
        fi
    done
}

# 根据分割位置拆分数组，并用 n 个分割符号替换原始分割线
function split_menu_items() {
    local items=("${!1}")  # 传入数组
    local n=${2:-40}    # 传入分割符重复次数, 默认40
    
    local split_indices=($(get_split_list "${items[@]}"))

    local sub_list=()
    local start=0

    for split in "${split_indices[@]}"; do
        # 取出当前子列表
        sub_list=("${items[@]:start:split-start}")
        
        # 调用 print_sub_menu_items 进行子列表显示
        print_sub_menu_items "${sub_list[@]}"
        
        # 生成新的分割行
        generate_separator "${items[split]}" "$n"
        
        start=$((split + 1))
    done

    # 处理最后一部分（如果还有剩余项）
    if [[ $start -lt ${#items[@]} ]]; then
        sub_list=("${items[@]:start}")
        print_sub_menu_items "${sub_list[@]}"
    fi
}


function check_ip_command() {
    if ! command -v ip &> /dev/null; then
        echo -e "$WARN 'ip' command not found. Attempting to install iproute2 package...\n"

        if command -v apt-get &> /dev/null; then
            # Debian/Ubuntu
            sudo apt-get update
            sudo apt-get install -y iproute2
        elif command -v yum &> /dev/null; then
            # CentOS/RHEL
            sudo yum install -y iproute
        elif command -v dnf &> /dev/null; then
            # Fedora
            sudo dnf install -y iproute
        else
            echo -e "$ERROR Could not determine package manager. Please install iproute2 manually.\n"
            exit 1
        fi

        if ! command -v ip &> /dev/null; then
            echo -e "$ERROR Failed to install 'ip' command. Please install iproute2 manually.\n"
            exit 1
        else
            echo -e "$SUCCESS 'ip' command installed successfully.\n"
        fi
    fi
}

function check_ip_support() {
    # 检查IPv4支持
    if ip -4 addr show | grep -q "inet "; then
        export IPV4_SUPPORTED=1
    else
        export IPV4_SUPPORTED=0
    fi

    # 检查IPv6支持
    if ip -6 addr show | grep -q "inet6 "; then
        export IPV6_SUPPORTED=1
    else
        export IPV6_SUPPORTED=0
    fi
}

function check_warp_status() {
  local ip_version=$1

  if [[ "$ip_version" -ne 4 && "$ip_version" -ne 6 ]]; then
    echo -e "\n$WARN Invalid IP version. Please use 4 or 6!"
    return 1
  fi

  if [[ IPV${ip_version}_SUPPORTED -eq 0 ]]; then
    echo -e "$WARN IPv${ip_version} is not supported!"
    return 1
  fi 

  echo -e " $WORKING Check warp status for IPv${ip_version} ..."

  url="https://www.cloudflare.com/cdn-cgi/trace"
  response=$(curl -${ip_version} -sS --retry 2 --max-time 1 "$url")

  if [[ -z "$response" ]]; then
    echo -e "${WARN}  Failed to check warp for IPv${ip_version} from cloudflare.com \n"
    return 1
  fi

  local location_ip=$( echo -e "$response" | grep "loc="  | awk -F= '{print $2}')
  local warp_status=$( echo -e "$response"  | grep "warp=" | awk -F= '{print $2}')

  [[ -n "$location_ip" ]] && export WARP_LOC${ip_version}=${location_ip}

  # 设置全局变量
  if [[ "$warp_status" =~ ^on$ ]] ; then 
    # export WARP${ip_version}=$(echo -e "${location_ip}, ${RED}Warp${PLAIN}")
    export WARPSTATUS${ip_version}=1
  else 
    # export WARP${ip_version}=$(echo -e ${location_ip})
    export WARPSTATUS${ip_version}=0
  fi 
}

function print_warp_ip_info() {
  local ip_version=$1
  local result=""

  if [ "$ip_version" -eq 4 ]; then
      local result="${GREEN}IPv4${PLAIN}: $WAN4 ${PURPLE}$WARP_LOC4${PLAIN}"
  elif [ "$ip_version" -eq 6 ]; then
      local result="${GREEN}IPv6${PLAIN}: $WAN6 ${PURPLE}$WARP_LOC6${PLAIN}"
  else
      echo -e " $WARN Invalid ip version. Please enter 4 or 6."
      return 1
  fi

  result=$(echo -en "${result}")
  [[ WARPSTATUS${ip_version} -eq 1 ]] && result+=$(echo -en ", ${RED}warp${PLAIN}")
  echo "$result"
}


function get_ip_info() {
  local ip_version=$1

  if [[ "$ip_version" -ne 4 && "$ip_version" -ne 6 ]]; then
    echo -e "\n$WARN Invalid IP version. Please use 4 or 6!"
    return 1
  fi

  if [[ IPV${ip_version}_SUPPORTED -eq 0 ]]; then
    echo -e "$WARN IPv${ip_version} is not supported!"
    return 1
  fi 

  echo -e " $WORKING Check IPv${ip_version} information ..."

  local url
  local response
  local loc_ip
  local loc_country
  local loc_asn  local loc_asn_org
  local ip_info

  url="https://ifconfig.co/json"
  response=$(curl -${ip_version} -sS --retry 2 --max-time 1 "$url")

  if [[ -z "$response" ]]; then
    echo -e "${WARN}  Failed to fetch IPv${ip_version} information from ifconfig.co \n"
    return 1
  fi

  # loc_ip=$(echo "$response" | jq -r '.ip')
  # loc_country=$(echo "$response" | jq -r '.country')
  # loc_asn=$(echo "$response" | jq -r '.asn')
  # loc_asn_org=$(echo "$response" | jq -r '.asn_org')

  loc_ip=$(echo "$response" | grep -o '"ip": *"[^"]*"' | awk -F': ' '{print $2}' | tr -d '"')
  loc_asn=$(echo "$response" | grep -o '"asn": *"[^"]*"' | awk -F': ' '{print $2}' | tr -d '"')
  loc_asn_org=$(echo "$response" | grep -o '"asn_org": *"[^"]*"' | awk -F': ' '{print $2}' | tr -d '"')
  loc_country=$(echo "$response" | grep -o '"country": *"[^"]*"' | awk -F': ' '{print $2}' | tr -d '"')

  ip_info=$(echo -e "${loc_country}, ${loc_asn}, ${loc_asn_org}")

  # 设置全局变量
  [[ -n "$loc_ip" ]]      && export WAN${ip_version}=$(printf "%s" ${loc_ip})
  [[ -n "$loc_country" ]] && export COUNTRY${ip_version}=$loc_country
  [[ -n "$loc_asn_org" ]] && export ASNORG${ip_version}=$loc_asn_org
#   [[ -n "$ip_info" ]]     && export IP_INFO${ip_version}=$(printf "%s" ${ip_info})
  [[ -n "$ip_info" ]]     && export IP_INFO${ip_version}=$loc_asn

}


function check_ip_status() {

  # 检查 'ip' 命令是否可用
  check_ip_command

  # 检查IPv4和IPv6支持
  check_ip_support

  # 示例调用
  if [[ $IPV4_SUPPORTED -eq 1 ]]; then
      get_ip_info 4
      check_warp_status 4
  else
      echo -e "$WARN IPv4 is not supported on this system.\n"
  fi

  if [[ $IPV6_SUPPORTED -eq 1 ]]; then
      get_ip_info 6
      check_warp_status 6
  else
      echo -e "$WARN IPv6 is not supported on this system.\n"
  fi

}

function print_menu_head() {
    local n=${1:-35}    # 传入分割符重复次数, 默认35
    echo ""
    local head=$(echo -e "${GREEN}♧♧♧${PLAIN}  ${CONSTSTR} ${BLUE}${SRC_VER}${PLAIN}  ${GREEN}♧♧♧${PLAIN}")
    printf "%5s%s\n${RESET}" "" "$head"
    generate_separator "-|$AZURE" "$n" # 另一个分割线
    
    print_warp_ip_info 4
    print_warp_ip_info 6
    generate_separator "=|$YELLOW" "$n" # 另一个分割线
}

function print_sys_title() {
    local system_name="${SYSTEM_PRETTY_NAME:-"${SYSTEM_NAME} ${SYSTEM_VERSION_NUMBER}"}"
    local arch="${DEVICE_ARCH}"
    local date_time time_zone
    date_time="$(date "+%Y-%m-%d %H:%M")"
    time_zone="$(timedatectl status 2>/dev/null | grep "Time zone" | awk -F ':' '{print$2}' | awk -F ' ' '{print$1}')"

    echo -e "运行环境: ${BLUE}${system_name} ${arch}${PLAIN}"
    echo -e "系统时间: ${BLUE}${date_time} ${time_zone}${PLAIN}"
}


function print_sub_head() {
    local head="$1"
    local n=${2:-35}    # 传入分割符重复次数, 默认35
    local is_machine_info_show=${3:-0}
    local is_ip_info_show=${4:-1} 

    echo "" 
    printf "%1s%s\n${RESET}" "" "$head"
    generate_separator "=|$AZURE" "$n" # 另一个分割线
    
    if [[ $is_machine_info_show -eq 1 ]]; then
        collect_system_info
        print_sys_title
        generate_separator "~|$AZURE" "$n" # 另一个分割线
    fi

    if [[ $is_ip_info_show -eq 1 ]]; then
        print_warp_ip_info 4
        print_warp_ip_info 6
        generate_separator "=|$YELLOW" "$n" # 另一个分割线
    fi
}


## 输出菜单尾项 
function print_main_menu_tail() {
    local n=${1:-35}    # 传入分割符重复次数, 默认35

    generate_separator "=|$AZURE" "$n" # 另一个分割线
    emoji_count=1
    chinese_width=4
    adj_width=$((MAX_COL_NUM + chinese_width + emoji_count + chinese_width + emoji_count))

    s_update=${BLUE}'脚本更新'${PURPLE}"ღ"${RESET}
    s_restart=${BLUE}'重启系统'${RED}"☋"${RESET}
    printf "%${NUM_WIDTH}s.%-${adj_width}b%${NUM_SPLIT}s%${NUM_WIDTH}s.%-${MAX_COL_NUM}b\n${RESET}" \
            '0' $s_update "" 'xx' $s_restart

    generate_separator "…" "$n"
    emoji_count=1
    chinese_width=4
    adj_width=$((MAX_COL_NUM + chinese_width + emoji_count + chinese_width + emoji_count))

    s_exit=${BLUE}'退出脚本'${RED}"✘"${RESET}
    s_qiq=${BLUE}'✟✟'${ITEM_CAT_CHAR}${RESET}'快捷命令☽_'${YELLOW}"qiq"${BLUE}${RESET}"_☾"
    printf "%${NUM_WIDTH}s${ITEM_CAT_CHAR}%-${adj_width}b%${NUM_SPLIT}s%-${MAX_COL_NUM}b\n\n${RESET}" \
        'x' $s_exit "" $s_qiq
}

## 输出子菜单尾项 
function print_sub_menu_tail() {
    local n=${1:-35}    # 传入分割符重复次数, 默认35

    generate_separator "=|$AZURE" "$n" # 另一个分割线
    emoji_count=1
    chinese_width=4
    adj_width=$((MAX_COL_NUM + chinese_width + emoji_count + chinese_width + emoji_count))

    s_exit=${BLUE}'返回'${RED}"🔙"${RESET}
    s_restart=${BLUE}'重启系统'${RED}"☋"${RESET}
    printf "%${NUM_WIDTH}s.%-${adj_width}b%${NUM_SPLIT}s%${NUM_WIDTH}s.%-${MAX_COL_NUM}b\n\n${RESET}" \
            '0' $s_exit "" 'xx' $s_restart

}


## 显示系统基本信息 
function print_system_info() {    
    # collect_system_info 

    DEVICE_ARCH=$(uname -m)
    # 判断虚拟化
    if [ $(type -p systemd-detect-virt) ]; then
        VIRT=$(systemd-detect-virt)
    elif [ $(type -p hostnamectl) ]; then
        VIRT=$(hostnamectl | awk '/Virtualization/{print $NF}')
    elif [ $(type -p virt-what) ]; then
        VIRT=$(virt-what)
    fi
    VIRT=${VIRT^^} || VIRT="UNKNOWN"

    local hostname=$(hostname)
    local kernel_version=$(uname -r)

    local cpu_cores=$(nproc)
	local cpu_freq=$(cat /proc/cpuinfo | grep "MHz" | head -n 1 | awk '{printf "%.1f GHz\n", $4/1000}')
    if [ "$(uname -m)" == "x86_64" ]; then
      local cpu_info=$(cat /proc/cpuinfo | grep 'model name' | uniq | sed -e 's/model name[[:space:]]*: //')
    else
      local cpu_info=$(lscpu | grep 'BIOS Model name' | awk -F': ' '{print $2}' | sed 's/^[ \t]*//')
    fi
	local cpu_usage_percent=$(awk '{u=$2+$4; t=$2+$4+$5; if (NR==1){u1=u; t1=t;} else printf "%.0f\n", (($2+$4-u1) * 100 / (t-t1))}' \
		<(grep 'cpu ' /proc/stat) <(sleep 1; grep 'cpu ' /proc/stat))

    local os_info=$(lsb_release -ds 2>/dev/null)
    # 如果 lsb_release 命令失败，则尝试其他方法
    if [ -z "$os_info" ]; then
      # 检查常见的发行文件
      if [ -f "/etc/os-release" ]; then
        local os_info=$(source /etc/os-release && echo "$PRETTY_NAME")
      elif [ -f "/etc/debian_version" ]; then
        local os_info="Debian $(cat /etc/debian_version)"
      elif [ -f "/etc/redhat-release" ]; then
        local os_info=$(cat /etc/redhat-release)
      else
        local os_info="Unknown"
      fi
    fi
	local load=$(uptime | awk '{print $(NF-2), $(NF-1), $NF}')
    local mem_info=$(free -b | awk 'NR==2{printf "%.2f/%.2f MB (%.2f%%)", $3/1024/1024, $2/1024/1024, $3*100/$2}')
    local disk_info=$(df -h | awk '$NF=="/"{printf "%s/%s (%s)", $3, $2, $5}')
    
    local swap_used=$(free -m | awk 'NR==3{print $3}')
    local swap_total=$(free -m | awk 'NR==3{print $2}')    
    if [ "$swap_total" -eq 0 ]; then
        local swap_percentage=0
    else
        local swap_percentage=$((swap_used * 100 / swap_total))
    fi
    local swap_info="${swap_used}MB/${swap_total}MB (${swap_percentage}%)"

    clear 
	echo ""
	echo -e " 系统信息 "
    generate_separator "↓|$AZURE" 40 # 割线
	echo -e "${BLUE}主机名称:  ${BLUE}$hostname"
	echo -e "${BLUE}运营商家:  ${BLUE}$ASNORG4"
	echo -e "${BLUE}系统版本:  ${BLUE}$os_info"
	echo -e "${BLUE}内核版本:  ${BLUE}$kernel_version"
	echo -e "${BLUE}虚拟类型:  ${BLUE}$VIRT"
    generate_separator "…|$AZURE" 40 # 割线
	echo -e "${BLUE}CPU核数:   ${BLUE}$cpu_cores"
	echo -e "${BLUE}CPU架构:   ${BLUE}$DEVICE_ARCH"
	echo -e "${BLUE}CPU频率:   ${BLUE}$cpu_freq"
	echo -e "${BLUE}CPU型号:   ${BLUE}$cpu_info"
    generate_separator "…|$AZURE" 40 # 割线
	echo -e "${BLUE}CPU占用:   ${BLUE}$cpu_usage_percent%"
	echo -e "${BLUE}系统负载:  ${BLUE}$load"
	echo -e "${BLUE}物理内存:  ${BLUE}$mem_info"
	echo -e "${BLUE}虚拟内存:  ${BLUE}$swap_info"
	echo -e "${BLUE}硬盘占用:  ${BLUE}$disk_info"
    generate_separator "…|$AZURE" 40 # 割线

    if [[ $IPV4_SUPPORTED -eq 1 ]]; then
		echo -e "${BLUE}IPv4地址:  ${RED}$WAN4"
        [[ -n "$WAN4" ]] && echo -e "${BLUE}地理位置:  ${BLUE}$COUNTRY4,$IP_INFO4,$ASNORG4"
    else
		echo -e "${BLUE}IPv4地址:  ${RED} Not Supported "
	fi

    if [[ $IPV6_SUPPORTED -eq 1 ]]; then
		echo -e "${BLUE}IPv6地址:  ${RED}$WAN6"
        [[ -n "$WAN6" ]] && echo -e "${BLUE}地理位置:  ${BLUE}$COUNTRY6,$IP_INFO6,$ASNORG6"
    else
		echo -e "${BLUE}IPv6地址:  ${RED} Not Supported "
	fi

    generate_separator "~|$AZURE" 40 # 割线
	local dns_addresses=$(awk '/^nameserver/{printf "%s, ", $2} END {print ""}' /etc/resolv.conf)
	local congestion_algorithm=$(sysctl -n net.ipv4.tcp_congestion_control)
	local queue_algorithm=$(sysctl -n net.core.default_qdisc)
	echo -e "${BLUE}DNS地址:  ${BLUE}$dns_addresses"
	echo -e "${BLUE}网络算法:  ${BLUE}$congestion_algorithm $queue_algorithm"

    generate_separator "…|$AZURE" 40 # 割线
    local date_time="$(date "+%Y-%m-%d %H:%M")"
    local time_zone="$(timedatectl status 2>/dev/null | grep "Time zone" | awk -F ':' '{print$2}' | awk -F ' ' '{print$1}')"
    local runtime=$(cat /proc/uptime | awk -F. '{run_days=int($1 / 86400);run_hours=int(($1 % 86400) / 3600);run_minutes=int(($1 % 3600) / 60); if (run_days > 0) printf("%d天 ", run_days); if (run_hours > 0) printf("%d时 ", run_hours); printf("%d分\n", run_minutes)}')
	echo -e "${BLUE}系统时间:  ${BLUE}$time_zone $date_time"
	echo -e "${BLUE}运行时长:  ${BLUE}$runtime"
    generate_separator "↑|$AZURE" 40 # 割线

    _BREAK_INFO=" 系统信息获取完成"
    _IS_BREAK="true"
}



function interactive_select_mirror() {
    _SELECT_RESULT=""
    local options=("$@")
    local message="${options[${#options[@]} - 1]}"
    unset options[${#options[@]}-1]
    local selected=0
    local start=0
    local page_size=$(($(tput lines) - 3)) # 减去1行用于显示提示信息
    function clear_menu() {
        tput rc
        for ((i = 0; i < ${#options[@]} + 1; i++)); do
            echo -e "\r\033[K"
        done
        tput rc
    }
    function cleanup() {
        clear_menu
        tput rc
        tput cnorm
        tput rmcup
        exit
    }
    function draw_menu() {
        tput clear
        tput cup 0 0
        echo -e "${message}"
        local end=$((start + page_size - 1))
        if [ $end -ge ${#options[@]} ]; then
            end=${#options[@]}-1
        fi
        for ((i = start; i <= end; i++)); do
            if [ "$i" -eq "$selected" ]; then
                echo -e "\e[34;4m➤ ${options[$i]%@*}\e[0m"
            else
                echo -e "  ${options[$i]%@*}"
            fi
        done
    }
    function read_key() {
        IFS= read -rsn1 key
        if [[ $key == $'\x1b' ]]; then
            IFS= read -rsn2 key
            key="$key"
        fi
        echo "$key"
    }
    tput smcup              # 保存当前屏幕并切换到新屏幕
    tput sc                 # 保存光标位置
    tput civis              # 隐藏光标
    trap "cleanup" INT TERM # 捕捉脚本结束时恢复光标
    draw_menu               # 初始化菜单位置
    # 处理选择
    while true; do
        key=$(read_key)
        case "$key" in
        "[A" | "w" | "W")
            # 上箭头 / W
            if [ "$selected" -gt 0 ]; then
                selected=$((selected - 1))
                if [ "$selected" -lt "$start" ]; then
                    start=$((start - 1))
                fi
            fi
            ;;
        "[B" | "s" | "S")
            # 下箭头 / S
            if [ "$selected" -lt $((${#options[@]} - 1)) ]; then
                selected=$((selected + 1))
                if [ "$selected" -ge $((start + page_size)) ]; then
                    start=$((start + 1))
                fi
            fi
            ;;
        "")
            # Enter 键
            tput rmcup
            break
            ;;
        *) ;;
        esac
        draw_menu
    done
    # clear_menu # 清除菜单
    tput cnorm # 恢复光标
    tput rmcup # 恢复之前的屏幕
    # tput rc    # 恢复光标位置
    # 处理结果
    _SELECT_RESULT="${options[$selected]}"
}

function interactive_select_boolean() {
    _SELECT_RESULT=""
    local selected=0
    local message="$1"
    function clear_menu() {
        tput rc
        for ((i = 0; i < 2 + 2; i++)); do
            echo -e "\r\033[K"
        done
        tput rc
    }
    function cleanup() {
        clear_menu
        tput rc
        tput cnorm
        tput rmcup
        exit
    }
    function draw_menu() {
        tput rc
        echo -e "╭─ ${message}"
        echo -e "│"
        if [ "$selected" -eq 0 ]; then
            echo -e "╰─ \033[32m●\033[0m 是\033[2m / ○ 否\033[0m"
        else
            echo -e "╰─ \033[2m○ 是 / \033[0m\033[32m●\033[0m 否"
        fi
    }
    function draw_menu_confirmed() {
        tput rc
        echo -e "╭─ ${message}"
        echo -e "│"
        if [ "$selected" -eq 0 ]; then
            echo -e "╰─ \033[32m●\033[0m \033[1m是\033[0m\033[2m / ○ 否\033[0m"
        else
            echo -e "╰─ \033[2m○ 是 / \033[0m\033[32m●\033[0m \033[1m否\033[0m"
        fi
    }
    function read_key() {
        IFS= read -rsn1 key
        if [[ $key == $'\x1b' ]]; then
            IFS= read -rsn2 key
            key="$key"
        fi
        echo "$key"
    }
    tput sc                 # 保存光标位置
    tput civis              # 隐藏光标
    trap "cleanup" INT TERM # 捕捉脚本结束时恢复光标
    draw_menu               # 初始化菜单位置
    # 处理选择
    while true; do
        key=$(read_key)
        case "$key" in
        "[D" | "a" | "A")
            # 左箭头 / A
            if [ "$selected" -gt 0 ]; then
                selected=$((selected - 1))
            fi
            ;;
        "[C" | "d" | "D")
            # 右箭头 / D
            if [ "$selected" -lt 1 ]; then
                selected=$((selected + 1))
            fi
            ;;
        "")
            # Enter 键
            draw_menu_confirmed
            break
            ;;
        *) ;;
        esac
        draw_menu
    done
    # clear_menu # 清除菜单
    tput cnorm # 恢复光标
    # tput rc    # 恢复光标位置
    # 处理结果
    if [ "$selected" -eq 0 ]; then
        _SELECT_RESULT="true"
    else
        _SELECT_RESULT="false"
    fi
}


## 处理break，显示信息或直接跳过 
function break_tacle() {
    _IS_BREAK=${_IS_BREAK:-"false"}
    _BREAK_INFO=${_BREAK_INFO:-"操作完成"}

    if ${_IS_BREAK} == "true"; then
        echo -e "\n${TIP}${_BREAK_INFO}${RESET}"
        echo "└─ 按任意键继续 ..."
        read -n 1 -s -r -p ""
    fi
    _IS_BREAK="false"
    _BREAK_INFO="操作完成"
}

## 重启系统，需要用户确认
function sys_reboot() {

    local CHOICE=$(echo -e "\n${BOLD}└─ 是否要重启系统? [Y/n] ${PLAIN}")
    read -rp "${CHOICE}" INPUT
    [[ -z "${INPUT}" ]] && INPUT=Y
    case "${INPUT}" in
    [Yy] | [Yy][Ee][Ss])
        echo -e "\n$TIP 重启系统 ...\n"
        _BREAK_INFO=" 系统重启中 ..."
        reboot 
        ;;
    [Nn] | [Nn][Oo])
        echo -e "\n$TIP 取消重启系统！"
        ;;
    *)
        echo -e "\n$WARN 输入错误！"
        _BREAK_INFO=" 不重启系统！"
        _IS_BREAK="true"
        ;;
    esac
}


# 修复dpkg中断问题
function fix_dpkg() {
	pkill -9 -f 'apt|dpkg'
	rm -f /var/lib/dpkg/lock-frontend /var/lib/dpkg/lock
	DEBIAN_FRONTEND=noninteractive dpkg --configure -a
}

function sys_update() {
    _BREAK_INFO=" 系统更新完成！"
    _IS_BREAK="true"
    
	echo -e "\n${WORKING}${GREEN}正在系统更新...${RESET}"
	if command -v dnf &>/dev/null; then
		dnf -y update
	elif command -v yum &>/dev/null; then
		yum -y update
	elif command -v apt &>/dev/null; then
		fix_dpkg
		DEBIAN_FRONTEND=noninteractive apt update -y
		DEBIAN_FRONTEND=noninteractive apt full-upgrade -y
	elif command -v apk &>/dev/null; then
		apk update && apk upgrade
	elif command -v pacman &>/dev/null; then
		pacman -Syu --noconfirm
	elif command -v zypper &>/dev/null; then
		zypper refresh
		zypper update
	elif command -v opkg &>/dev/null; then
		opkg update
	else
		echo -e "$WARN 未知的包管理器!"
        _BREAK_INFO=" 系统更新失败！"
		return
	fi
}

function sys_clean() {
    _IS_BREAK="true"
    _BREAK_INFO=" 系统清理完成！"
	echo -e "\n${WORKING}${RED}正在系统清理...${RESET}"
	if command -v dnf &>/dev/null; then
		rpm --rebuilddb
		dnf autoremove -y
		dnf clean all
		dnf makecache
		journalctl --rotate
		journalctl --vacuum-time=1s
		journalctl --vacuum-size=500M

	elif command -v yum &>/dev/null; then
		rpm --rebuilddb
		yum autoremove -y
		yum clean all
		yum makecache
		journalctl --rotate
		journalctl --vacuum-time=1s
		journalctl --vacuum-size=500M

	elif command -v apt &>/dev/null; then
		fix_dpkg
		apt autoremove --purge -y
		apt clean -y
		apt autoclean -y
		journalctl --rotate
		journalctl --vacuum-time=1s
		journalctl --vacuum-size=500M

	elif command -v apk &>/dev/null; then
		echo "清理包管理器缓存..."
		apk cache clean
		echo "删除系统日志..."
		rm -rf /var/log/*
		echo "删除APK缓存..."
		rm -rf /var/cache/apk/*
		echo "删除临时文件..."
		rm -rf /tmp/*

	elif command -v pacman &>/dev/null; then
		pacman -Rns $(pacman -Qdtq) --noconfirm
		pacman -Scc --noconfirm
		journalctl --rotate
		journalctl --vacuum-time=1s
		journalctl --vacuum-size=500M

	elif command -v zypper &>/dev/null; then
		zypper clean --all
		zypper refresh
		journalctl --rotate
		journalctl --vacuum-time=1s
		journalctl --vacuum-size=500M

	elif command -v opkg &>/dev/null; then
		echo "删除系统日志..."
		rm -rf /var/log/*
		echo "删除临时文件..."
		rm -rf /tmp/*

	elif command -v pkg &>/dev/null; then
		echo "清理未使用的依赖..."
		pkg autoremove -y
		echo "清理包管理器缓存..."
		pkg clean -y
		echo "删除系统日志..."
		rm -rf /var/log/*
		echo "删除临时文件..."
		rm -rf /tmp/*

	else
		echo -e "$WARN 未知的包管理器!"
        _BREAK_INFO=" 系统清理失败！"
		return
	fi
	return
}



function system_test_menu(){
    function print_system_test_menu(){
        clear 
        # print_menu_head $MAX_SPLIT_CHAR_NUM
        print_sub_head "▼ 性能测试 " $MAX_SPLIT_CHAR_NUM 1 
        split_menu_items MENU_TEST_ITEMS[@] $MAX_SPLIT_CHAR_NUM
        # print_main_menu_tail $MAX_SPLIT_CHAR_NUM
        print_sub_menu_tail $MAX_SPLIT_CHAR_NUM
    }
    # collect_system_info


    while true; do
        print_system_test_menu
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入选项: ${PLAIN}")

        read -rp "${CHOICE}" INPUT
        case "${INPUT}" in
        3) 
            sys_update
            ;;
        4) 
            sys_clean
            ;;
        xx) 
            sys_reboot
            ;;
        0) 
            echo -e "\n$TIP 返回主菜单 ..."
            break 
            ;;
        *)
            _BREAK_INFO=" 请输入正确的数字序号以选择你想使用的功能！"
            _IS_BREAK="true"
            ;;
        esac
        break_tacle
    done

}


function system_tools_menu(){
    function print_system_tools_menu(){
        clear 
        # print_menu_head $MAX_SPLIT_CHAR_NUM
        print_sub_head "▼ 系统工具 " $MAX_SPLIT_CHAR_NUM 1 0 
        split_menu_items MENU_SYSTEM_TOOLS_ITEMS[@] $MAX_SPLIT_CHAR_NUM
        # print_main_menu_tail $MAX_SPLIT_CHAR_NUM
        print_sub_menu_tail $MAX_SPLIT_CHAR_NUM
    }

    while true; do
        print_system_tools_menu
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入选项: ${PLAIN}")

        read -rp "${CHOICE}" INPUT
        case "${INPUT}" in
        3) 
            sys_update
            ;;
        4) 
            sys_clean
            ;;
        xx) 
            sys_reboot
            ;;
        0) 
            echo -e "\n$TIP 返回主菜单 ..."
            break 
            ;;
        *)
            _BREAK_INFO=" 请输入正确的数字序号以选择你想使用的功能！"
            _IS_BREAK="true"
            ;;
        esac
        break_tacle
    done

}

function commonly_tools_menu(){
    function print_commonly_tools_menu(){
        clear 
        # print_menu_head $MAX_SPLIT_CHAR_NUM
        # local num_split=$MAX_SPLIT_CHAR_NUM
        local num_split=45
        print_sub_head "▼ 常用工具 " $num_split 1 0 
        split_menu_items MENU_COMMONLY_TOOLS_ITEMS[@] $num_split
        # print_main_menu_tail $num_split
        print_sub_menu_tail $num_split
    }

    while true; do
        print_commonly_tools_menu
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入选项: ${PLAIN}")

        read -rp "${CHOICE}" INPUT
        case "${INPUT}" in
        3) 
            sys_update
            ;;
        4) 
            sys_clean
            ;;
        xx) 
            sys_reboot
            ;;
        0) 
            echo -e "\n$TIP 返回主菜单 ..."
            break 
            ;;
        *)
            _BREAK_INFO=" 请输入正确的数字序号以选择你想使用的功能！"
            _IS_BREAK="true"
            ;;
        esac
        break_tacle
    done

}

function management_tools_menu(){
    function print_management_tools_menu(){
        clear 
        # print_menu_head $MAX_SPLIT_CHAR_NUM
        # local num_split=$MAX_SPLIT_CHAR_NUM
        local num_split=45
        print_sub_head "▼ 管理工具 " $num_split 1 0 
        split_menu_items MENU_MANAGEMENT_TOOLS_ITEMS[@] $num_split
        # print_main_menu_tail $num_split
        print_sub_menu_tail $num_split
    }

    while true; do
        print_management_tools_menu
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入选项: ${PLAIN}")

        read -rp "${CHOICE}" INPUT
        case "${INPUT}" in
        3) 
            sys_update
            ;;
        4) 
            sys_clean
            ;;
        xx) 
            sys_reboot
            ;;
        0) 
            echo -e "\n$TIP 返回主菜单 ..."
            break 
            ;;
        *)
            _BREAK_INFO=" 请输入正确的数字序号以选择你想使用的功能！"
            _IS_BREAK="true"
            ;;
        esac
        break_tacle
    done

}

function other_scripts_menu(){
    function print_other_scripts_menu(){
        clear 
        # print_menu_head $MAX_SPLIT_CHAR_NUM
        local num_split=$MAX_SPLIT_CHAR_NUM
        print_sub_head "▼ 其他脚本 " $num_split 1 0 
        split_menu_items MENU_OTHER_SCRIPTS_ITEMS[@] $num_split
        # print_main_menu_tail $num_split
        print_sub_menu_tail $num_split
    }

    while true; do
        print_other_scripts_menu
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入选项: ${PLAIN}")

        read -rp "${CHOICE}" INPUT
        case "${INPUT}" in
        3) 
            sys_update
            ;;
        4) 
            sys_clean
            ;;
        xx) 
            sys_reboot
            ;;
        0) 
            echo -e "\n$TIP 返回主菜单 ..."
            break 
            ;;
        *)
            _BREAK_INFO=" 请输入正确的数字序号以选择你想使用的功能！"
            _IS_BREAK="true"
            ;;
        esac
        break_tacle
    done

}
## ======================================================
function main_menu(){
    function print_main_menu(){
        clear 
        # 调用拆分函数
        print_menu_head $MAX_SPLIT_CHAR_NUM
        split_menu_items MENU_MAIN_ITEMS[@] $MAX_SPLIT_CHAR_NUM
        print_main_menu_tail $MAX_SPLIT_CHAR_NUM
    }

    while true; do
        print_main_menu
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入选项: ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        case "${INPUT}" in
        1)  print_system_info ;;
        2)  system_test_menu ;;
        3)  sys_update ;;
        4)  sys_clean ;;

        11) system_tools_menu ;;
        12) management_tools_menu ;;
        13) commonly_tools_menu ;;
        14) other_scripts_menu ;;

        xx) sys_reboot ;;
        x)  
            echo -e "\n$WARN 退出脚本！" 
            exit
            ;;
        *)
            # echo -e "\n$WARN 请输入数字序号以选择你想使用的功能！"
            _BREAK_INFO=" 请输入正确的数字序号以选择你想使用的功能！"
            _IS_BREAK="true"
            ;;
        esac
        break_tacle
    done
}


# 定义主菜单数组
MENU_MAIN_ITEMS=(
    "1|基本信息|$MAGENTA"
    "2|性能测试|$BLUE"
    "3|系统更新|$BLUE"
    "4|系统清理|$GREEN"
    "………………………|$BLUE" 
    "11|系统工具|$CYAN"
    "12|管理工具|$BLUE"
    "13|常用软件|$CYAN" 
    "14|其他脚本|$GREEN"
    "21|Caddy管理|$MAGENTA"
    "22|Docker管理|$BLUE"
    "23|Python管理|$BLUE"
)

# 定义性能测试数组
MENU_TEST_ITEMS=(
    "1|基本信息|$BLUE"
    "2|GB5测试|$MAGENTA"
    "3|NodeBench测试|$BLUE"
    "4|Bench测试|$BLUE"
    "5|融合怪测评|$GREEN"
    "6|ChatGPT解锁状态|$BLUE"
    "7|Region流媒体状态|$BLUE"
    "8|yeahwu流媒体状态|$BLUE"
    "………………………|$BLUE" 
    "11|三网测速(Superspeed)|$CYAN"
    "12|三网回程(bestrace)|$BLUE"
    "13|回程线路(mtr_trace)|$BLUE" 
    "21|单线程测速|$BLUE"
    "22|带宽性能(yabs)|$BLUE"
)

# 定义性能测试数组
MENU_SYSTEM_TOOLS_ITEMS=(
    "1|修改ROOT密码|$BLUE"
    "2|开启ROOT登录|$MAGENTA"
    "3|禁用ROOT用户|$BLUE"
    "4|开启SSH转发|$BLUE"
    "5|切换IPv4/IPv6|$BLUE"
    "6|端口管理|$BLUE"
    "7|DNS管理|$BLUE"
    "8|DD系统|$GREEN"
    "………………………|$BLUE" 
    "21|改主机名|$CYAN"
    "22|虚拟内存|$BLUE"
    "23|时区调整|$BLUE" 
    "24|系统源管理|$BLUE"
    "25|BBRv3加速|$BLUE"
    "26|用户管理|$BLUE"
    "27|定时任务|$BLUE"
)

# 定义性能测试数组
MENU_COMMONLY_TOOLS_ITEMS=(
    "1|curl|$BLUE"
    "2|wget|$BLUE"
    "3|gdu|$MAGENTA"
    "4|btop|$BLUE"
    "5|htop|$BLUE"
    "6|iftop|$BLUE"
    "7|tzip|$BLUE"
    "8|Fail2Ban|$YELLOW"
    "9|SuperVisor|$YELLOW"
    "………………………|$BLUE" 
    "21|安装指定|$BLUE" 
    "22|卸载指定|$BLUE"
    "23|安装常用|$CYAN"
    "24|全部安装|$CYAN"
    "25|全部卸载|$BLUE"
    "26|最新天气☀|$BLUE"
    "………………………|$BLUE" 
    "31|贪吃蛇|$BLUE"
    "32|俄罗期方块|$BLUE"
    "33|太空入侵者(sl)|$BLUE"
    "34|跑火车屏保(cmatrix)|$BLUE"
    "35|黑客帝国屏保|$BLUE"
)

# 常用面板和软件 
MENU_MANAGEMENT_TOOLS_ITEMS=(
    "1|1Panel|$BLUE"
    "2|aaPanel|$BLUE"
    "3|iyCMS|$MAGENTA"
    "4|frps|$BLUE"
    "5|frpc|$BLUE"
    "6|Lucky|$BLUE"
    "7|Nezha(v0)|$BLUE"
    "8|Nezha(v1)|$BLUE"
    "9|Akile Monitor|$BLUE"
    "10|Code-Server|$BLUE"
    "………………………|$BLUE" 
    "21|warp(@farsman)|$BLUE"
    "22|warp(@ygkkk)|$BLUE"
    "23|Singbox(@farsman)|$YELLOW"
    "24|Singbox(@ygkkk)|$YELLOW"
    "25|V2RayA|$YELLOW"
    "………………………|$BLUE" 
    "41|RustDesk|$YELLOW"
    "42|DeepLX|$YELLOW"
    "43|SubLinkX|$YELLOW"
    "44|Chrome|$YELLOW"
    "45|Gnome-Desktop|$YELLOW"
)

# 其他常用脚本 
MENU_OTHER_SCRIPTS_ITEMS=(
    "1|KijiLion|$BLUE"
    "2|KijiLion(CN)|$BLUE"
    "3|LinuxMirrors|$BLUE"
    "4|LinuxMirrors(abroad|$MAGENTA"
    "5|LinuxMirrors(edu)|$BLUE"
    "6|LinuxMirrors(docker)|$BLUE"
    "7|YiDian(docker)|$BLUE"
    "8|YiDian(Nginx)|$BLUE"
    "9|YiDian(Serv00)|$YELLOW"
    "………………………|$BLUE" 
    "21|Sky-Box|$BLUE" 
)

#=================
# 设置qiq快捷命令 
# set_qiq_alias
# 初始化全局变量
init_global_vars 
# 检测系统IP地址
check_ip_status

# 显示主菜单 
main_menu
