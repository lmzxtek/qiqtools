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

URL_PROXY='https://proxy.zwdk.org/proxy/'
URL_REDIRECT='https://sub.zwdk.org/qiq'
URL_SCRIPT='https://raw.githubusercontent.com/lmzxtek/qiqtools/refs/heads/main/qiqtools.sh'
URL_UPDATE='https://raw.githubusercontent.com/lmzxtek/qiqtools/refs/heads/main/update_log.sh'


# Emoji: 💡🧹🎉⚙️🔧🛠️💣🎯🧲🌍🌎🌏🌐🏡🏚️🏠🏯🗼🧭♨️💧📡👫
#        🐵🐒🐕🦍🫏🦒🐔🐤🐓🦅🪿🐦‍⬛🐋🐬🪼🪲🌹🥀🌿🌱☘️🍓🍉
# Emoji: 😀😀😝😔🫨💥💯💤💫💦🛑⚓🎁🎀🏅🎖️🥇🥈🥉
# Emoji: 💔💖💝🩷❤️💗⛳🕹️🎨♥️♠️♣️♦️♟️🃏🔒🔓🔐🔏🔑🗝️
#        👌👍✌️👋👉👈👆👇👎✊👊🤛🤝👐👀👁️🦶🩸💊🩹
#        ⚠️🚸⛔🚫🚳📵☣️☢️🔅🔆✖️➕➖➗🟰♾️⁉️❓❔💲♻️🔱⚜️📛⭕❌✔️☑️✅❎✳️❇️✴️

BOLD='\033[1m'
PLAIN='\033[0m'
RESET='\033[0m'

WORKING="\033[1;36m✨️${PLAIN}"
POINTING="\033[1;36m👉${PLAIN}"
SUCCESS="\033[1;32m✅${PLAIN}"
COMPLETE="\033[1;32m✔${PLAIN}"
WARN="\033[1;36m⚠️${PLAIN}"
ERROR="\033[1;31m✘${PLAIN}"
FAIL="\033[1;31m✘${PLAIN}"
TIP="\033[1;36m💡${PLAIN}"


# 颜色定义：\033比\e的兼容性更好 
BLACK='\033[31m'
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
PURPLE='\033[35m'
MAGENTA='\033[35m'
CYAN='\033[36m'
AZURE='\033[36m'
WHITE='\033[37m'
DEFAULT='\033[39m'

FCMR='\033[39m'        # 前景色：默认
FCBL='\033[30m'        # 前景色：黑色
FCRE='\033[31m'        # 前景色：红色
FCGR='\033[32m'        # 前景色：绿色
FCYE='\033[33m'        # 前景色：黄色
FCLS='\033[34m'        # 前景色：蓝色
FCZS='\033[35m'        # 前景色：紫色
FCTL='\033[36m'        # 前景色：天蓝
FCQH='\033[37m'        # 前景色：白色|浅灰

FCSH='\033[90m'        # 前景：深灰
FCHD='\033[91m'        # 前景：红灯
FCLG='\033[92m'        # 前景：浅绿
FCDH='\033[93m'        # 前景：淡黄
FCLB='\033[94m'        # 前景：浅蓝
FCYH='\033[95m'        # 前景：浅洋红
FCQQ='\033[96m'        # 前景：浅青色
FCBS='\033[97m'        # 前景：白色

BCMR='\033[49m'        # 背景色：默认
BCBL='\033[40m'        # 背景色：黑色
BCRE='\033[41m'        # 背景色：红色
BCGR='\033[42m'        # 背景色：绿色
BCYE='\033[43m'        # 背景色：黄色
BCLS='\033[44m'        # 背景色：蓝色
BCZS='\033[45m'        # 背景色：紫色
BCTL='\033[46m'        # 背景色：天蓝
BCQH='\033[47m'        # 背景色：白色|浅灰

BCSH='\033[100m'       # 背景：深灰
BCHD='\033[101m'       # 背景：红灯
BCLG='\033[102m'       # 背景：浅绿
BCDH='\033[103m'       # 背景：淡黄
BCLB='\033[104m'       # 背景：浅蓝
BCYH='\033[105m'       # 背景：浅洋红
BCQQ='\033[106m'       # 背景：浅青色
BCBS='\033[107m'       # 背景：白色

FTCZ='\033[0m'         # 字体：重置所有
FTCT='\033[1m'         # 字体：粗体
FTDH='\033[2m'         # 字体：淡化
FTXT='\033[3m'         # 字体：斜体
FTXH='\033[4m'         # 字体：下划线
FTSS='\033[5m'         # 字体：闪烁
FTFX='\033[7m'         # 字体：反显
FTYC='\033[8m'         # 字体：隐藏
FTHD='\033[9m'         # 字体：划掉

FDCT='\033[21m'        # 字体：取消粗体
FDDH='\033[22m'        # 字体：取消淡化
FDXT='\033[23m'        # 字体：取消斜体
FDXH='\033[24m'        # 字体：取消下划线
FDSS='\033[25m'        # 字体：取消闪烁
FDFX='\033[27m'        # 字体：取消反显
FDYC='\033[28m'        # 字体：取消隐藏
FDHD='\033[29m'        # 字体：取消划掉


## 报错退出
function output_error() {
    [ "$1" ] && echo -e "\n$ERROR $1\n"
    exit 1
}

## 权限判定
function permission_judgment() {
    if [ $UID -ne 0 ]; then
        output_error "权限不足，无法设置qiq快捷命令，请使用 Root 用户运行本脚本"
    fi
}

# 设置脚本的快捷命令为 `qiq`
function set_qiq_alias() {
    if [ $UID -ne 0 ]; then
        echo -e "$WARN 权限不足，请使用 Root 用户运行本脚本 "
    else
        echo -e "\n >>> 设置 qiq 快捷命令 ... "
        if ! command -v qiq &>/dev/null; then
            echo -e "\n >>> qiq 快捷命令未设置 ... "
            ln -sf ~/qiq.sh /usr/local/bin/qiq
        fi
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
    MAX_COL_NUM=${MAX_COL_NUM:-25}      # 单栏字符串最大宽度，默认为25
    ITEM_CAT_CHAR=${ITEM_CAT_CHAR:-'.'} # 序号与字符连接字符，默认为 '.'

    MAX_SPLIT_CHAR_NUM=${MAX_SPLIT_CHAR_NUM:-35} # 最大分割字符数量，默认为35
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
    local count=${2:-35}
    
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
        # adj_left_width=$((MAX_COL_NUM + chinese_left + emoji_count + chinese_left + emoji_count))
        adj_left_width=$((MAX_COL_NUM + chinese_left + emoji_count))

        # adj_split_num=$((NUM_SPLIT - chinese_left - emoji_count ))
        if [[ $adj_split_num -lt 0 ]]; then 
            adj_split_num=0
        fi 

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


## 输出数组列表
function print_items_list(){
    local items=("${!1}")  # 传入数组
    local head="$2"
    # clear 
    echo -e "\n${BOLD} ⚓ ${head}: \n${PLAIN}"
    for option in "${items[@]}"; do
        echo -e "$POINTING $option"
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

function check_ip_china() {
    local country=$(curl -s --connect-timeout 1 --max-time 3 ipinfo.io/country)
    if [ "$country" = "CN" ]; then
        _IS_CN=1
    else
        _IS_CN=0
    fi
}

## 判断IP所在地，给url设置代理 
function get_proxy_url() {
    local url="$1"
    check_ip_china
    [[ $_IS_CN -eq 1 ]] && url="${URL_PROXY}${url}"
    echo "$url"
}

## 下载脚本半修改可执行权限 
function fetch_script_from_url() { 
    local url="$1"
    local file="$2"
    local is_proxy=${3:-1}

    [[ $is_proxy -eq 1 ]] && url=$(get_proxy_url "$url")
    if command -v curl &>/dev/null; then 
        curl -L -o ${file} "${url}" && chmod +x ${file} && bash ${file}
    elif command -v wget &>/dev/null; then 
        wget -O ${file} ${url} && chmod +x ${file} && bash ${file}
    else
        _BREAK_INFO=" 请先安装curl或wget！"
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
    printf "%2s%s\n${RESET}" "" "$head"
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
    # adj_width=$((MAX_COL_NUM + chinese_width + emoji_count + chinese_width + emoji_count))
    adj_width=$((MAX_COL_NUM + chinese_width + emoji_count))

    s_exit=${BLUE}'退出脚本'${RED}"✘"${RESET}
    s_restart=${BLUE}'重启系统'${RED}"☋"${RESET}
    printf "%${NUM_WIDTH}s.%-${adj_width}b%${NUM_SPLIT}s%${NUM_WIDTH}s.%-${MAX_COL_NUM}b\n${RESET}" \
            '0' $s_exit "" 'xx' $s_restart

    generate_separator "…" "$n"
    emoji_count=1
    chinese_width=4
    # adj_width=$((MAX_COL_NUM + chinese_width + emoji_count + chinese_width + emoji_count))
    adj_width=$((MAX_COL_NUM + chinese_width + emoji_count ))

    s_update=${CYAN}'脚本更新'${PURPLE}"ღ"${RESET}
    s_qiq=${BLUE}'✟✟'${ITEM_CAT_CHAR}${RESET}'快捷命令☽_'${YELLOW}"qiq"${BLUE}${RESET}"_☾"
    printf "%${NUM_WIDTH}s${ITEM_CAT_CHAR}%-${adj_width}b%${NUM_SPLIT}s%-${MAX_COL_NUM}b\n\n${RESET}" \
        '00' $s_update "" $s_qiq
}

## 输出子菜单尾项 
function print_sub_menu_tail() {
    local n=${1:-35}    # 传入分割符重复次数, 默认35

    generate_separator "=|$AZURE" "$n" # 另一个分割线
    emoji_count=1
    chinese_width=4
    # adj_width=$((MAX_COL_NUM + chinese_width + emoji_count + chinese_width + emoji_count))
    adj_width=$((MAX_COL_NUM + chinese_width + emoji_count))

    s_exit=${BLUE}'返回'${RED}"🔙"${RESET}
    s_restart=${BLUE}'重启系统'${RED}"☋"${RESET}
    printf "%${NUM_WIDTH}s.%-${adj_width}b%${NUM_SPLIT}s%${NUM_WIDTH}s.%-${MAX_COL_NUM}b\n\n${RESET}" \
            '0' $s_exit "" 'xx' $s_restart

}

function check_sys_virt() {
    if [ $(type -p systemd-detect-virt) ]; then
        VIRT=$(systemd-detect-virt)
    elif [ $(type -p hostnamectl) ]; then
        VIRT=$(hostnamectl | awk '/Virtualization/{print $NF}')
    elif [ $(type -p virt-what) ]; then
        VIRT=$(virt-what)
    fi
    VIRT=${VIRT^^} || VIRT="UNKNOWN"
}


## 显示系统基本信息 
function print_system_info() {    
    # collect_system_info 

    DEVICE_ARCH=$(uname -m)
    # 判断虚拟化
    check_sys_virt

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

    echo -e "\n${TIP}${_BREAK_INFO}${RESET}"
    if ${_IS_BREAK} == "true"; then
        echo "└─ 按任意键继续 ..."
        read -n 1 -s -r -p ""
    fi
    _IS_BREAK="false"
    _BREAK_INFO="操作完成"
    # echo -e "${RESET}"
}

## 重启系统，需要用户确认
function sys_reboot() {

    local CHOICE=$(echo -e "\n${BOLD}└─ 是否要重启系统? [Y/n] ${PLAIN}")
    read -rp "${CHOICE}" INPUT
    [[ -z "${INPUT}" ]] && INPUT=Y # 回车默认为Y
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
        _BREAK_INFO=" 输入错误，不重启系统！"
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

# 安装应用程序
function app_install() {
    if [ $# -eq 0 ]; then
        echo "未提供软件包参数!"
        return 1
    fi

	for package in "$@"; do
		if ! command -v "$package" &>/dev/null; then
			echo -e "${gl_huang}正在安装 $package...${gl_bai}"
			if command -v dnf &>/dev/null; then
				dnf -y update
				dnf install -y epel-release
				dnf install -y "$package"
			elif command -v yum &>/dev/null; then
				yum -y update
				yum install -y epel-release
				yum install -y "$package"
			elif command -v apt &>/dev/null; then
				apt update -y
				apt install -y "$package"
			elif command -v apk &>/dev/null; then
				apk update
				apk add "$package"
			elif command -v pacman &>/dev/null; then
				pacman -Syu --noconfirm
				pacman -S --noconfirm "$package"
			elif command -v zypper &>/dev/null; then
				zypper refresh
				zypper install -y "$package"
			elif command -v opkg &>/dev/null; then
				opkg update
				opkg install "$package"
			elif command -v pkg &>/dev/null; then
				pkg update
				pkg install -y "$package"
			else
				echo "未知的包管理器!"
				return 1
			fi
		fi
	done
}

function app_remove() {
    if [ $# -eq 0 ]; then
        echo "未提供软件包参数!"
        return 1
    fi

	for package in "$@"; do
		echo -e "${gl_huang}正在卸载 $package...${gl_bai}"
		if command -v dnf &>/dev/null; then
			dnf remove -y "$package"
		elif command -v yum &>/dev/null; then
			yum remove -y "$package"
		elif command -v apt &>/dev/null; then
			apt purge -y "$package"
		elif command -v apk &>/dev/null; then
			apk del "$package"
		elif command -v pacman &>/dev/null; then
			pacman -Rns --noconfirm "$package"
		elif command -v zypper &>/dev/null; then
			zypper remove -y "$package"
		elif command -v opkg &>/dev/null; then
			opkg remove "$package"
		elif command -v pkg &>/dev/null; then
			pkg delete -y "$package"
		else
			echo "未知的包管理器!"
			return 1
		fi
	done
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

postgresql_usage(){
  
echo -e '\nPostgreSQL使用说明'
echo -e 'Start the database server using: pg_ctlcluster 11 main start'
echo -e '============================================================'
echo -e 'apt show postgresql         # 查看已经安装的postgresql版本 '
echo -e 'service postgresql status   # 检查PostgreSQL是否正在运行   '
echo -e 'su - postgresql             # 登录账户                    '
echo -e 'psql                        # 启动PostgreSQL Shell        '
echo -e '\q                          # 退出PosqgreSQL Shell        '
echo -e '\l                          # 查看所有表                   '
echo -e '\du                         # 查看PostSQL用户             '
echo -e '==========================================================='
echo -e "ALTER USER postgres WITH PASSWORD 'my_password';  # 更改任何用户的密码 "
echo -e "CREATE USER my_user WITH PASSWORD 'my_password';  # 创建一个用户 "
echo -e 'ALTER USER my_user WITH SUPERUSER;                # 给用户添加超级用户权限 '
echo -e 'DROP USER my_user;                                # 删除用户 '
echo -e 'CREATE DATABASE my_db OWNER my_user;              # 创建数据库，并指定所有者 '
echo -e 'DROP DATABASE my_db;                              # 删除数据库 '
echo -e '==========================================================='
echo -e 'select current_database();                        # 查看当前数据库 '
echo -e '\c - next_db;                                     # 切换数据库 '
echo -e 'psql -U my_user                                   # \q退出后，使用my_user登录 '
echo -e 'psql -U my_user -d my_db                          # 使用-d参数直接连接数据库 '
echo -e '==========================================================='
echo -e ' >>> 找到数据库bin目录./pg_ctl执行: 启停服务 '
echo -e 'systemctl stop postgresql.service                 # 停止 '
echo -e 'systemctl start postgresql.service                # 启动 '
}


# 定义性能测试数组
MENU_TEST_ITEMS=(
    "1|基本信息|$WHITE"
    "2|GB5测试|$MAGENTA"
    "3|NodeBench测试|$WHITE"
    "4|Bench测试|$WHITE"
    "5|融合怪测评|$GREEN"
    "6|ChatGPT解锁状态|$WHITE"
    "7|Region流媒体状态|$WHITE"
    "8|yeahwu流媒体状态|$WHITE"
    "………………………|$WHITE" 
    "11|三网测速(Superspeed)|$CYAN"
    "12|三网回程(bestrace)|$WHITE"
    "13|回程线路(mtr_trace)|$WHITE" 
    "21|单线程测速|$WHITE"
    "22|带宽性能(yabs)|$WHITE"
)
function system_test_menu(){
    function print_sub_item_menu_headinfo(){
        clear 
        # print_menu_head $MAX_SPLIT_CHAR_NUM
        print_sub_head "▼ 性能测试 " $MAX_SPLIT_CHAR_NUM 1 
        split_menu_items MENU_TEST_ITEMS[@] $MAX_SPLIT_CHAR_NUM
        # print_main_menu_tail $MAX_SPLIT_CHAR_NUM
        print_sub_menu_tail $MAX_SPLIT_CHAR_NUM
    }
    # collect_system_info


    while true; do
        print_sub_item_menu_headinfo
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入选项: ${PLAIN}")

        read -rp "${CHOICE}" INPUT
        case "${INPUT}" in
        3) 
            ;;
        4) 
            ;;
        xx) 
            sys_reboot
            ;;
        0) 
            echo -e "\n$TIP 返回主菜单 ..."
            return  0 
            ;;
        *)
            _BREAK_INFO=" 请输入正确的数字序号以选择你想使用的功能！"
            _IS_BREAK="true"
            ;;
        esac
        break_tacle
    done

}


function check_crontab_installed() {
	if ! command -v crontab >/dev/null 2>&1; then
		install_crontab
	fi
}


function install_crontab() {

	if [ -f /etc/os-release ]; then
		. /etc/os-release
		case "$ID" in
			ubuntu|debian|kali)
				apt update
				apt install -y cron
				systemctl enable cron
				systemctl start cron
				;;
			centos|rhel|almalinux|rocky|fedora)
				yum install -y cronie
				systemctl enable crond
				systemctl start crond
				;;
			alpine)
				apk add --no-cache cronie
				rc-update add crond
				rc-service crond start
				;;
			arch|manjaro)
				pacman -S --noconfirm cronie
				systemctl enable cronie
				systemctl start cronie
				;;
			opensuse|suse|opensuse-tumbleweed)
				zypper install -y cron
				systemctl enable cron
				systemctl start cron
				;;
			iStoreOS|openwrt|ImmortalWrt|lede)
				opkg update
				opkg install cron
				/etc/init.d/cron enable
				/etc/init.d/cron start
				;;
			FreeBSD)
				pkg install -y cronie
				sysrc cron_enable="YES"
				service cron start
				;;
			*)
				echo "不支持的发行版: $ID"
				return
				;;
		esac
	else
		echo "无法确定操作系统。"
		return
	fi

	echo -e "${gl_lv}crontab 已安装且 cron 服务正在运行。${gl_bai}"
}



function iptables_rules_save() {
	mkdir -p /etc/iptables
	touch /etc/iptables/rules.v4
	iptables-save > /etc/iptables/rules.v4
	check_crontab_installed
	crontab -l | grep -v 'iptables-restore' | crontab - > /dev/null 2>&1
	(crontab -l ; echo '@reboot iptables-restore < /etc/iptables/rules.v4') | crontab - > /dev/null 2>&1
}


function iptables_open() {
	app_install iptables
	iptables_rules_save
	iptables -P INPUT ACCEPT
	iptables -P FORWARD ACCEPT
	iptables -P OUTPUT ACCEPT
	iptables -F

	ip6tables -P INPUT ACCEPT
	ip6tables -P FORWARD ACCEPT
	ip6tables -P OUTPUT ACCEPT
	ip6tables -F

}


function add_swap() {
    local new_swap=$1  # 获取传入的参数

    # 获取当前系统中所有的 swap 分区
    local swap_partitions=$(grep -E '^/dev/' /proc/swaps | awk '{print $1}')

    # 遍历并删除所有的 swap 分区
    for partition in $swap_partitions; do
        swapoff "$partition"
        wipefs -a "$partition"
        mkswap -f "$partition"
    done

    # 确保 /swapfile 不再被使用
    swapoff /swapfile

    # 删除旧的 /swapfile
    rm -f /swapfile

    # 创建新的 swap 分区
    fallocate -l ${new_swap}M /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile

    sed -i '/\/swapfile/d' /etc/fstab
    echo "/swapfile swap swap defaults 0 0" >> /etc/fstab

    if [ -f /etc/alpine-release ]; then
        echo "nohup swapon /swapfile" > /etc/local.d/swap.start
        chmod +x /etc/local.d/swap.start
        rc-update add local
    fi

    echo -e "虚拟内存大小已调整为${gl_huang}${new_swap}${gl_bai}M"
}

function check_swap() {
    local swap_total=$(free -m | awk 'NR==3{print $2}')
    # 判断是否需要创建虚拟内存
    [ "$swap_total" -gt 0 ] || add_swap 1024 
}


function bbr_on() {
    cat > /etc/sysctl.conf << EOF
net.ipv4.tcp_congestion_control=bbr
EOF
    sysctl -p
}


function system_dd_usage(){
echo -e " "
echo -e "$POINTING DD脚本使用说明 "
echo -e "—————————————————————————————————————"
echo -e "       Linux : ${BLUE}root${red}@${yellow}LeitboGi0ro${PLAIN}"
echo -e "     Windows : ${BLUE}Administrator${red}@${yellow}Teddysun.com"
echo -e "  @bin456789 : ${BLUE}root|Administrator${red}@${yellow}123@@@"
echo -e "   ${white}(Windows need mininumn 15G Storage)${PLAIN}"
echo -e '   (当administrator无法登录时, 可尝试.\\administrator)\n'
echo -e "  bash InstallNET.sh -windows 10 -lang 'en'"
echo -e "  bash InstallNET.sh -windows 11 -lang 'cn'\n"
echo -e "  reinstall.sh alma 8|9"
echo -e "  reinstall.sh rocky 8|9"
echo -e "  reinstall.sh debian 9|10|11|12"
echo -e "  reinstall.sh ubuntu 24.04 [--minimal]"
echo -e "  reinstall.sh alpine 3.17|3.18|3.19|3.20\n"
echo -e "      reinstall.bat windows --image-name='windows server 2022 serverdatacenter' --lang=zh-cn "
echo -e "  bash reinstall.sh windows --image-name 'Windows 10 Enterprise LTSC 2021'--lang en-us "
echo -e "  bash reinstall.sh windows --image-name 'windows 11 pro' --lang zh-cn \n"
echo -e "  bash reinstall.sh windows --image-name 'windows 11 business 23h2'"
echo -e "                            --iso 'https://drive.massgrave.dev/zh-cn_windows_11_business_editions_version_23h2_updated_aug_2024_x64_dvd_6ca91c94.iso' \n"
echo -e "  bash reinstall.sh windows --image-name 'Windows 10 business 22h2'"
echo -e "                            --iso 'https://drive.massgrave.dev/zh-cn_windows_10_business_editions_version_22h2_updated_aug_2024_x86_dvd_8d7e500f.iso'\n"
echo -e "  bash reinstall.sh dd --img https://example.com/xx.xz"
echo -e "  bash reinstall.sh alpine --hold=1"
echo -e "  bash reinstall.sh netboot.xyz\n"
echo -e "  注意: Windows 10 LTSC 2021 zh-cn 的wsappx进程会长期占用CPU, 需要更新系统补丁。\n"
}

# 定义系统工具数组
MENU_SYSTEM_TOOLS_ITEMS=(
    "1|修改ROOT密码|$WHITE"
    "2|开启ROOT登录|$WHITE"
    "3|禁用ROOT用户|$WHITE"
    "4|改主机名|$WHITE"
    "5|时区调整|$WHITE" 
    "6|系统源管理|$MAGENTA"
    "7|用户管理|$WHITE"
    "8|端口管理|$WHITE"
    "9|DNS管理|$CYAN"
    "………………………|$WHITE" 
    "21|DD系统|$GREEN"
    "22|虚拟内存|$CYAN"
    "23|开启SSH转发|$WHITE"
    "24|切换IPv4/IPv6|$WHITE"
    "25|BBRv3加速|$WHITE"
    "26|定时任务|$WHITE"
    "27|命令行美化|$CYAN"
)
function system_tools_menu(){
    function print_sub_item_menu_headinfo(){
        clear 
        # print_menu_head $MAX_SPLIT_CHAR_NUM
        print_sub_head "▼ 系统工具 " $MAX_SPLIT_CHAR_NUM 1 0 
        split_menu_items MENU_SYSTEM_TOOLS_ITEMS[@] $MAX_SPLIT_CHAR_NUM
        # print_main_menu_tail $MAX_SPLIT_CHAR_NUM
        print_sub_menu_tail $MAX_SPLIT_CHAR_NUM
    }

    while true; do
        print_sub_item_menu_headinfo
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入选项: ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        case "${INPUT}" in
        1) 
            # local CHOICE=$(echo -e "\n${BOLD}└─ 请输入选项: ${PLAIN}")
            # read -rp "${CHOICE}" INPUT
            echo "设置ROOT密码" && passwd 
            ;;
        2) 
            sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config;
            sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config;
            service sshd restart

            _BREAK_INFO=" ROOT登录设置完毕"
            _IS_BREAK="true"
            ;;
        3) 
            app_install sudo 

            # 提示用户输入新用户名
            echo -e "$TIP 禁用Root用户，需要创建新的用户 ..."
            local CHOICE=$(echo -e "\n${BOLD}└─ 请输入新用户名: ${PLAIN}")
            read -rp "${CHOICE}" new_username

            # 创建新用户并设置密码
            echo -e "$TIP 设置新用户的密码 ..."
            sudo useradd -m -s /bin/bash "$new_username"
            sudo passwd "$new_username"

            # 赋予新用户sudo权限
            echo -e "$TIP 设置新用户sudo权限 ..."
            echo "$new_username ALL=(ALL:ALL) ALL" | sudo tee -a /etc/sudoers

            # 禁用ROOT用户登录
            echo -e "$TIP 禁用Root用户 ..."
            sudo passwd -l root
            
            _BREAK_INFO=" 禁用ROOT用户完毕"
            _IS_BREAK="true"
            ;;
        4) 
            local cur_hostname=$(hostname)

            # 询问用户是否要更改主机名
            echo "当前主机名: $cur_hostname"
            read -p "是否要更改主机名？(y/n): " answer

            if [ "$answer" == "y" ]; then
                # 获取新的主机名
                read -p "请输入新的主机名: " new_hostname
                if [ -n "$new_hostname" && [ "$new_hostname" != "0" ]]; then
                    if [ -f /etc/alpine-release ]; then
                        # Alpine
                        echo "$new_hostname" > /etc/hostname
                        hostname "$new_hostname"
                    else
                        # 其他系统，如 Debian, Ubuntu, CentOS 等
                        hostnamectl set-hostname "$new_hostname"
                        sed -i "s/$cur_hostname/$new_hostname/g" /etc/hostname
                        systemctl restart systemd-hostnamed
                    fi
                    
                    if grep -q "127.0.0.1" /etc/hosts; then
                        sed -i "s/127.0.0.1 .*/127.0.0.1       $new_hostname localhost localhost.localdomain/g" /etc/hosts
                    else
                        echo "127.0.0.1       $new_hostname localhost localhost.localdomain" >> /etc/hosts
                    fi

                    if grep -q "^::1" /etc/hosts; then
                        sed -i "s/^::1 .*/::1             $new_hostname localhost localhost.localdomain ipv6-localhost ipv6-loopback/g" /etc/hosts
                    else
                        echo "::1             $new_hostname localhost localhost.localdomain ipv6-localhost ipv6-loopback" >> /etc/hosts
                    fi

                    echo "主机名更改为: $new_hostname"
                else
                    echo "无效主机名。未更改主机名。"
                    continue 
                fi
            else
                echo "未更改主机名。"
            fi
            ;;
        5) 
            local timezone=$(current_timezone)
            local current_time=$(date +"%Y-%m-%d %H:%M:%S")
            local tz_items_regions=(
                "1|亚洲|$WHITE"
                "2|欧洲|$WHITE"
                "3|美洲|$WHITE"
                "4|UTC|$WHITE"
            )
            local tz_items_asian=(
                "1|中国上海|$WHITE"
                "2|中国香港|$WHITE"
                "3|日本东京|$WHITE"
                "4|韩国首尔|$WHITE"
                "5|新加坡|$WHITE"
                "6|印度加尔各答|$WHITE"
                "7|阿联酋迪拜|$WHITE"
                "8|澳大利亚悉尼|$WHITE"
                "9|泰国曼谷|$WHITE"
            )
            local tz_items_eu=(
                "1|英国伦敦|$WHITE"
                "2|法国巴黎|$WHITE"
                "3|德国柏林|$WHITE"
                "4|俄罗斯莫斯科|$WHITE"
                "5|荷兰尤特赖赫特|$WHITE"
                "6|西班牙马德里|$WHITE"
            )
            local tz_items_us=(
                "1|美国西部|$WHITE"
                "2|美国东部|$WHITE"
                "3|加拿大|$WHITE"
                "4|墨西哥|$WHITE"
                "5|巴西|$WHITE"
                "6|阿根廷|$WHITE"
            )

            ;;
        6) 
            local source_list_options=(
                "1.大陆地区"
                "2.教育网"
                "3.海外地区"
                "0.退出"
            )

            _IS_BREAK="true"
            _BREAK_INFO=" 已修改系统源！"
            print_items_list source_list_options[@] "系统源地区选择:"
            local CHOICE=$(echo -e "\n${BOLD}└─ 请选择: ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            case "${INPUT}" in
            1) 
                bash <(curl -sSL https://linuxmirrors.cn/main.sh)
                _BREAK_INFO=" 已修改系统源为大陆地区！"
                ;;
            2) 
                bash <(curl -sSL https://linuxmirrors.cn/main.sh) --edu
                _BREAK_INFO=" 已修改系统源为教育网！"
                ;;
            3) 
                bash <(curl -sSL https://linuxmirrors.cn/main.sh) --abroad
                _BREAK_INFO=" 已修改系统源为海外地区！"
                ;;
            0) 
                echo -e "\n$TIP 返回主菜单 ..."
                _IS_BREAK="false"
                ;;
            *)
                _BREAK_INFO=" 请输入正确选项！"
                ;;
            esac 
            ;;
        8) 
            local ports_management_options=(
                "1.查看端口状态"
                "2.开放所有端口"
                "3.关闭所有端口"
                "4.开放指定端口"
                "5.关闭指定端口"
                "0.退出"
            )

            _IS_BREAK="true"
            _BREAK_INFO=" 由端口管理子菜单返回！"
            print_items_list ports_management_options[@] "选择:"
            local CHOICE=$(echo -e "\n${BOLD}└─ 请选择: ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            case "${INPUT}" in
            1) 
                clear 
                ss -tulnape
                ;;
            2) 
                # permission_judgment 
                if [ "$EUID" -ne 0 ] ; then 
                    # echo -e "$WARN 该操作需要root权限！"
                    _BREAK_INFO=" 开放所有端口需要root权限"
                    break_tacle 
                    continue 
                fi 
                iptables_open 
                app_remove iptables-persistent ufw firewalld iptables-services > /dev/null 2>&1
                _BREAK_INFO=" 已开放全部端口"
                ;;
            3) 
            
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

                _BREAK_INFO=" 已关闭所有端口！"
                ;;
            4) 
            
                local CHOICE=$(echo -e "\n${BOLD}└─ 请输入要开放的端口号: ${PLAIN}")
                read -rp "${CHOICE}" INPUT

                sed -i "/COMMIT/i -A INPUT -p tcp --dport $INPUT -j ACCEPT" /etc/iptables/rules.v4
                sed -i "/COMMIT/i -A INPUT -p udp --dport $INPUT -j ACCEPT" /etc/iptables/rules.v4
                iptables-restore < /etc/iptables/rules.v4
                _BREAK_INFO=" 已开放端口: $INPUT！"

                ;;
            5) 
                local CHOICE=$(echo -e "\n${BOLD}└─ 请输入要关闭的端口号: ${PLAIN}")
                read -rp "${CHOICE}" INPUT

                sed -i "/--dport $INPUT/d" /etc/iptables/rules.v4
                iptables-restore < /etc/iptables/rules.v4
                _BREAK_INFO=" 已关闭端口: $INPUT！"

                ;;
            0) 
                echo -e "\n$TIP 返回主菜单 ..."
                _IS_BREAK="false"
                ;;
            *)
                _BREAK_INFO=" 请输入正确选项！"
                ;;
            esac 
            ;;
        9) 
            local dns_list_options=(
                "1.国外DNS"
                "2.国内DNS"
                "3.自定义DNS"
                "0.返回"
            )
            
            function set_dns() {
                local dns1_ipv4="$1"
                local dns2_ipv4="$2"
                local dns1_ipv6="$3"
                local dns2_ipv6="$4"

                cp /etc/resolv.conf /etc/resolv.conf.bak
                rm /etc/resolv.conf
                touch /etc/resolv.conf
                if [ $IPV6_SUPPORTED -eq 1 ]; then
                    echo "nameserver $dns1_ipv6" >> /etc/resolv.conf
                    echo "nameserver $dns2_ipv6" >> /etc/resolv.conf
                fi
                if [ $IPV4_SUPPORTED -eq 1 ]; then
                    echo "nameserver $dns1_ipv4" >> /etc/resolv.conf
                    echo "nameserver $dns2_ipv4" >> /etc/resolv.conf
                fi
            }

            _IS_BREAK="true"
            _BREAK_INFO=" 已修改DNS！"
            
            clear 
            echo -e "\n\n$TIP 当前DNS地址: \n"
            cat /etc/resolv.conf
            generate_separator "=|$WHITE" 

            print_items_list dns_list_options[@] "DNS切换:"
            local CHOICE=$(echo -e "\n${BOLD}└─ 请选择: ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            case "${INPUT}" in
            1) 
                local dns1_ipv4="1.1.1.1"
                local dns2_ipv4="8.8.8.8"
                local dns1_ipv6="2606:4700:4700::1111"
                local dns2_ipv6="2001:4860:4860::8888"
                set_dns ${dns1_ipv4} ${dns2_ipv4} ${dns1_ipv6} ${dns2_ipv6}
                _BREAK_INFO=" DNS 已切换为海外DNS！"
                ;;
            2) 
                local dns1_ipv4="223.5.5.5"
                local dns2_ipv4="183.60.83.19"
                local dns1_ipv6="2400:3200::1"
                local dns2_ipv6="2400:da00::6666"
                set_dns ${dns1_ipv4} ${dns2_ipv4} ${dns1_ipv6} ${dns2_ipv6}
                _BREAK_INFO=" DNS 已切换为国内DNS！"
                ;;
            3) 
                app_install nano
                nano /etc/resolv.conf
                _BREAK_INFO=" 已手动修改DNS！"
                ;;
            0) 
                echo -e "\n$TIP 返回主菜单 ..."
                _IS_BREAK="false"
                ;;
            *)
                _BREAK_INFO=" 请输入正确选项！"
                ;;
            esac 
            ;;
        21) 
            local sys_dd_options=(
                "1.Leitbogioro"
                "2.MoeClub"
                "3.0oVicero0"
                "4.mowwom"
                "5.bin456789"
                "0.返回"
            )         
            
            local sys_lang_options=(
                "1.中文(CN)"
                "2.英文(EN)"
            ) 
            function select_system_language(){
                local sys_lang='CN'
                print_items_list sys_lang_options[@] " 系统语言选择:"
                local CHOICE=$(echo -e "\n${BOLD}└─ 请选择语言(默认为中文)[CN/EN]: ${PLAIN}")
                read -rp "${CHOICE}" INPUT
                case "${INPUT}" in
                # 1) 
                #     sys_lang='CN'
                #     _BREAK_INFO=" 已选择中文！"
                #     ;;
                2) 
                    sys_lang='EN'
                    _BREAK_INFO=" 已选择英文！"
                esac 
                echo ${sys_lang}
            }

            local systems_list=(
                "1|Alpine Edge|$WHITE"
                "2|Alpine 3.20|$WHITE"
                "3|Alpine 3.19|$WHITE"
                "4|Alpine 3.18|$WHITE"
                "…………………………………|$WHITE" 
                "11|Debian 12|$YELLOW"
                "12|Debian 11|$WHITE"
                "13|Debian 10|$WHITE"
                "14|Ubuntu 24.04|$YELLOW"
                "15|Ubuntu 22.04|$WHITE"
                "16|Ubuntu 20.04|$WHITE"
                "…………………………………|$WHITE" 
                "21|AlmaLinux 9|$WHITE"
                "22|AlmaLinux 8|$WHITE"
                "23|RockyLinux 9|$WHITE"
                "24|RockyLinux 8|$WHITE"
                "…………………………………|$WHITE" 
                "31|Windows 2025|$YELLOW"
                "32|Windows 2022|$WHITE"
                "33|Windows 2019|$WHITE"
                "34|Windows 11|$WHITE"
                "35|Windows 10|$WHITE"
                "36|Windows 7|$WHITE"
                "…………………………………|$WHITE" 
                "88|41合一脚本|$WHITE"
                "99|脚本说明|$WHITE"
            )            

            _IS_BREAK="true"
            _BREAK_INFO=" DD系统！"

            check_sys_virt 
            if [[ "$VIRT" != *"KVM"* ]]; then
                # 如果系统虚拟化不是KVM，则使用OsMutation进行DD系统
                local fname='OsMutation.sh' 
                local url=$(get_proxy_url 'https://raw.githubusercontent.com/LloydAsp/OsMutation/main/OsMutation.sh')
                if command -v curl &>/dev/null; then 
                    curl -sL -o ${fname} "${url}" && chmod u+x ${fname} && bash ${fname}
                elif command -v wget &>/dev/null; then 
                    wget -qO ${fname} $url && chmod u+x ${fname} &&  bash ${fname}
                else
                    _BREAK_INFO=" 请先安装curl或wget！"
                fi
                continue  
            fi 
            
            function dd_sys_login_info(){
                local username='$1'
                local password='$2'
                local port='$3'

                echo -e "\n$TIP DD系统登录信息:"
                echo -e "======================="
                echo -e "$BOLD  用户: ${username}"
                echo -e "$BOLD  密码: ${password}"
                echo -e "$BOLD  端口: ${port}"
                echo -e "======================="

                _BREAK_INFO=" DD系统后登录信息:"
                _IS_BREAK="true"
                break_tacle 
            }
            function dd_sys_mollylau(){
                local fname='InstallNET.sh' 
                local url=$(get_proxy_url 'https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/InstallNET.sh')
                if command -v curl &>/dev/null; then 
                    curl -sL -o ${fname} "${url}" && chmod a+x ${fname} && bash ${fname}
                elif command -v wget &>/dev/null; then 
                    wget -qO ${fname} $url && chmod a+x ${fname} &&  bash ${fname}
                else
                    _BREAK_INFO=" 请先安装curl或wget！"
                    _IS_BREAK="true"
                    continue 
                fi 
            }
            
            
            clear 
            local num_split=40
            print_sub_head " DD系统 " $num_split 1 0 
            # print_items_list sys_dd_options[@] "DD系统脚本选择:"
            split_menu_items systems_list[@] $num_split
            print_sub_menu_tail $num_split
            local CHOICE=$(echo -e "\n${BOLD}└─ 请选择要DD的系统: ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            case "${INPUT}" in
            1) 
                ;;
            2) 
                ;;
            3) 
                _BREAK_INFO=" 已手动修改DNS！"
                ;;
            0) 
                echo -e "\n$TIP 返回主菜单 ..."
                _IS_BREAK="false"
                ;;
            88) 
                sys_update 

                _BREAK_INFO=" 从 41合一脚本DD系统 返回"
                local fname='NewReinstall.sh' 
                local url=$(get_proxy_url 'https://raw.githubusercontent.com/fcurrk/reinstall/master/NewReinstall.sh')
                if command -v curl &>/dev/null; then 
                    curl -sL -o ${fname} "${url}" && chmod a+x ${fname} && bash ${fname}
                elif command -v wget &>/dev/null; then 
                    wget -qO ${fname} $url && chmod a+x ${fname} &&  bash ${fname}
                else
                    _BREAK_INFO=" 请先安装curl或wget！"
                fi
                # wget --no-check-certificate -O NewReinstall.sh https://raw.githubusercontent.com/fcurrk/reinstall/master/NewReinstall.sh && chmod a+x NewReinstall.sh && bash NewReinstall.sh
                ;;
            99) 
                system_dd_usage 
                _BREAK_INFO=" DD系统说明 "
                ;; 
            0) 
                echo -e "\n$TIP 返回主菜单 ..."
                _IS_BREAK="false"
                ;;
            xx) 
                sys_reboot
                ;;
            *)
                _BREAK_INFO=" 请输入正确选项！"
                ;;
            esac 
            ;;
        22) 
            local swap_used=$(free -m | awk 'NR==3{print $3}')
            local swap_total=$(free -m | awk 'NR==3{print $2}')
            local swap_info=$(free -m | awk 'NR==3{used=$3; total=$2; if (total == 0) {percentage=0} else {percentage=used*100/total}; printf "%dM/%dM (%d%%)", used, total, percentage}')

            local swap_size_options=(
                "1. 1024M"
                "2. 2048M"
                "3. 4096M"
                "4. 8192M"
                "5. 自定义"
                "0. 返回"
            )           
            
            _IS_BREAK="true"
            print_items_list swap_size_options[@] "虚拟内存容量菜单:"
            local CHOICE=$(echo -e "\n${BOLD}└─ 请选择: ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            case "${INPUT}" in
            1) 
                add_swap 1024
                _BREAK_INFO=" 已设置1G虚拟内存！"
                ;;
            2) 
                add_swap 2048
                _BREAK_INFO=" 已设置2G虚拟内存！"
                ;;
            3) 
                add_swap 4096
                _BREAK_INFO=" 已设置4G虚拟内存！"
                ;;
            4) 
                add_swap 8192
                _BREAK_INFO=" 已设置8G虚拟内存！"
                ;;
            5) 
                local CHOICE=$(echo -e "\n${BOLD}└─ 请输入要设置的虚拟内存大小(M): ${PLAIN}")
                read -rp "${CHOICE}" INPUT
                if [[ $INPUT =~ ^[0-9]+$ ]]; then
                    add_swap $INPUT 
                    _BREAK_INFO=" 已设置${INPUT}M虚拟内存！"
                else
                    _BREAK_INFO=" 虚拟内存大小输入错误，格式有误，应为数字！"
                fi
                ;;
            *)
                _BREAK_INFO=" 请输入正确选项！"
                ;;
            esac 
            ;;
        23) 
            sed -i 's/^#\?AllowTcpForwarding.*/AllowTcpForwarding yes/g' /etc/ssh/sshd_config;
            sed -i 's/^#\?GatewayPorts.*/GatewayPorts yes/g' /etc/ssh/sshd_config;
            service sshd restart
            _BREAK_INFO=" 已开启SSH转发功能"
            _IS_BREAK="true"
            ;;
        24) 
            local ipv6_disabled=$(sysctl -n net.ipv6.conf.all.disable_ipv6)
            if [ "$ipv6_disabled" -eq 1 ]; then
                echo -e "\n${POINTING} 当前网络: IPv4 优先\n"
            else
                echo -e "\n${POINTING} 当前网络: IPv6 优先\n"
            fi
            local net_1st_options=(
                "1.IPv4优先"
                "2.IPv6优先"
                "3.IPv6修复"
                "0.返回"
            )
            
            _IS_BREAK="true"
            print_items_list net_1st_options[@] "功能菜单:"
            local CHOICE=$(echo -e "\n${BOLD}└─ 请选择: ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            case "${INPUT}" in
            1) 
                sysctl -w net.ipv6.conf.all.disable_ipv6=1 > /dev/null 2>&1
                echo "已切换为 IPv4 优先"
                _BREAK_INFO=" 已切换为 IPv4 优先！"
                ;;
            2) 
                sysctl -w net.ipv6.conf.all.disable_ipv6=0 > /dev/null 2>&1
                echo "已切换为 IPv6 优先"
                _BREAK_INFO=" 已切换为 IPv6 优先！"
                ;;
            3) 
                bash <(curl -L -s jhb.ovh/jb/v6.sh)
                # echo "该功能由jhb大神提供，感谢他！"
                _BREAK_INFO=" IPv6 修复成功！(jhb脚本)"
                ;;
            0) 
                echo -e "\n$TIP 返回主菜单 ..."
                _IS_BREAK="false"
                ;;
            *)
                _BREAK_INFO=" 请输入正确选项！"
                ;;
            esac 
            ;;
        25) 
        
            local cpu_arch=$(uname -m)
            if [ "$cpu_arch" = "aarch64" ]; then
                bash <(curl -sL jhb.ovh/jb/bbrv3arm.sh)
                _BREAK_INFO=" 系统为ARM架构,已使用jhb的bbrv3arm.sh安装BBRv3内核" 
                _IS_BREAK="true" 
                break_tacle 
                continue 
            fi

            if dpkg -l | grep -q 'linux-xanmod'; then
                local bbrv3_1st_options=(
                    "1.更新BBRv3"
                    "2.卸载BBRv3"
                    "0.返回"
                )
                
                _IS_BREAK="true"
                local kernel_version=$(uname -r)
                echo -e "\n$TIP 系统已安装xanmod的BBRv3内核"
                echo -e "\n$POINTING 当前内核版本: $kernel_version"
                print_items_list bbrv3_1st_options[@] "BBRv3功能选项:"
                local CHOICE=$(echo -e "\n${BOLD}└─ 请选择: ${PLAIN}")
                read -rp "${CHOICE}" INPUT
                case "${INPUT}" in
                1) 
                    apt purge -y 'linux-*xanmod1*'
                    update-grub

                    # wget -qO - https://dl.xanmod.org/archive.key | gpg --dearmor -o /usr/share/keyrings/xanmod-archive-keyring.gpg --yes
                    wget -qO - ${gh_proxy}raw.githubusercontent.com/kejilion/sh/main/archive.key | gpg --dearmor -o /usr/share/keyrings/xanmod-archive-keyring.gpg --yes

                    # 步骤3：添加存储库
                    echo 'deb [signed-by=/usr/share/keyrings/xanmod-archive-keyring.gpg] http://deb.xanmod.org releases main' | tee /etc/apt/sources.list.d/xanmod-release.list

                    # version=$(wget -q https://dl.xanmod.org/check_x86-64_psabi.sh && chmod +x check_x86-64_psabi.sh && ./check_x86-64_psabi.sh | grep -oP 'x86-64-v\K\d+|x86-64-v\d+')
                    local version=$(wget -q ${gh_proxy}raw.githubusercontent.com/kejilion/sh/main/check_x86-64_psabi.sh && chmod +x check_x86-64_psabi.sh && ./check_x86-64_psabi.sh | grep -oP 'x86-64-v\K\d+|x86-64-v\d+')

                    apt update -y
                    apt install -y linux-xanmod-x64v$version

                    echo "XanMod内核已更新。重启后生效"
                    rm -f /etc/apt/sources.list.d/xanmod-release.list
                    rm -f check_x86-64_psabi.sh*

                    _BREAK_INFO=" 已更新 linux-xammod1内核 ！"
                    _IS_BREAK="false"
                    break_tacle 
                    sys_reboot 
                    continue 
                    ;;
                2) 
                    apt purge -y 'linux-*xanmod1*'
                    update-grub 
                    echo "XanMod内核已卸载。重启后生效"
                    _BREAK_INFO=" XanMod内核已卸载。重启后生效"
                    _IS_BREAK="false"
                    break_tacle 
                    sys_reboot 
                    continue 
                    ;;
                0) 
                    echo -e "\n$TIP 返回主菜单 ..."
                    _IS_BREAK="false"
                    ;;
                *)
                    _BREAK_INFO=" 请输入正确选项！"
                    ;; 
                esac 
            else
                clear
                echo -e "$POINTING 设置BBR3加速 "
                echo -e "========================================================="
                echo -e " 仅支持[Debian|Ubuntu|Alpine]"
                echo -e " 请备份数据，将为你升级Linux内核开启BBR3"
                echo -e " 若系统内存为${RED}512M${RESET}，请提前添加1G虚拟内存，以防机器失联！"
                echo -e "========================================================="
                local CHOICE=$(echo -e "\n${BOLD}└─ 确定继续安装BBRv3? [Y/n] ${PLAIN}")
                read -rp "${CHOICE}" INPUT
                [[ -z "${INPUT}" ]] && INPUT=Y # 回车默认为Y
                case "$INPUT" in
                [Yy] | [Yy][Ee][Ss])
                    if [ -r /etc/os-release ]; then
                        . /etc/os-release
                        if [ "$ID" == "alpine" ]; then
                            bbr_on
                            _BREAK_INFO=" 当前为Alpine系统"
                            _IS_BREAK="false"
                            break_tacle
                            sys_reboot
                            continue
                        elif [ "$ID" != "debian" ] && [ "$ID" != "ubuntu" ]; then
                            _BREAK_INFO=" 当前环境不支持, 仅支持Alpine,Debian和Ubuntu系统"
                            _IS_BREAK="true"
                            break_tacle
                            continue
                        fi                        
                    else
                        echo "无法确定操作系统类型"
                        _BREAK_INFO=" 无法确定操作系统类型"
                        _IS_BREAK="true"
                        break_tacle
                        continue
                    fi

                    check_swap
                    app_install wget gnupg

                    local url=$(get_proxy_url "https://raw.githubusercontent.com/kejilion/sh/main/archive.key")
                    wget -qO - ${url} | gpg --dearmor -o /usr/share/keyrings/xanmod-archive-keyring.gpg --yes

                    # 步骤3：添加存储库
                    echo 'deb [signed-by=/usr/share/keyrings/xanmod-archive-keyring.gpg] http://deb.xanmod.org releases main' | tee /etc/apt/sources.list.d/xanmod-release.list

                    local url=$(get_proxy_url "https://raw.githubusercontent.com/kejilion/sh/main/check_x86-64_psabi.sh")
                    local version=$(wget -q ${url} && chmod +x check_x86-64_psabi.sh && ./check_x86-64_psabi.sh | grep -oP 'x86-64-v\K\d+|x86-64-v\d+')

                    apt update -y
                    apt install -y linux-xanmod-x64v$version

                    bbr_on

                    rm -f /etc/apt/sources.list.d/xanmod-release.list
                    rm -f check_x86-64_psabi.sh*
                    _BREAK_INFO=" XanMod内核安装并BBR3启用成功。重启后生效"
                    _IS_BREAK="false"
                    sys_reboot
                    continue
                    ;;
                [Nn] | [Nn][Oo])
                    _BREAK_INFO=" 已取消"
                    _IS_BREAK="false"
                    ;;
                *)
                    _BREAK_INFO=" 无效的选择。"
                    _IS_BREAK="true"
                    ;;
                esac
            fi             
            ;;
        27) 
            function print_better_cmd_style_options(){
                echo -e ""
                # echo -e "  1. \033[1;32mroot@\033[1;34mlocalhost \033[1;31m~ ${RESET}#"
                # echo -e "  2. \033[1;35mroot@\033[1;36mlocalhost \033[1;33m~ ${RESET}#"
                # echo -e "  3. \033[1;31mroot@\033[1;32mlocalhost \033[1;34m~ ${RESET}#"
                # echo -e "  4. \033[1;36mroot@\033[1;33mlocalhost \033[1;37m~ ${RESET}#"
                # echo -e "  5. \033[1;37mroot@\033[1;31mlocalhost \033[1;32m~ ${RESET}#"
                # echo -e "  6. \033[1;33mroot@\033[1;34mlocalhost \033[1;35m~ ${RESET}#"
                echo -e "  1. ${FCGR}root@${FCLS}localhost ${FCRE}~ ${RESET}#"  # 绿，  蓝， 红
                echo -e "  2. ${FCZS}root@${FCTL}localhost ${FCYE}~ ${RESET}#"  # 紫，天蓝， 黄 
                echo -e "  3. ${FCRE}root@${FCGR}localhost ${FCLS}~ ${RESET}#"  # 红，  绿， 蓝
                echo -e "  4. ${FCTL}root@${FCYE}localhost ${FCQH}~ ${RESET}#"  # 天蓝，黄，浅灰
                echo -e "  5. ${FCQH}root@${FCRE}localhost ${FCGR}~ ${RESET}#"  # 浅灰，红， 绿
                echo -e "  6. ${FCYE}root@${FCLS}localhost ${FCZS}~ ${RESET}#"  # 黄，  蓝， 紫
                echo -e "  7. root@localhost ~ #"
                echo -e "  0. 返回"
            }
            
            function shell_custom_style_profile() {
                local ss="$1"
                if command -v dnf &>/dev/null || command -v yum &>/dev/null; then
                    sed -i '/^PS1=/d' ~/.bashrc
                    echo "${ss}" >> ~/.bashrc
                    # source ~/.bashrc
                else
                    sed -i '/^PS1=/d' ~/.profile
                    echo "${ss}" >> ~/.profile
                    # source ~/.profile
                fi
                hash -r
            }

            _IS_BREAK="true"
            print_better_cmd_style_options
            local CHOICE=$(echo -e "\n${BOLD}└─ 选择命令行样式? ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            case "${INPUT}" in
            1) 
                local bianse="PS1='\[\033[1;32m\]\u\[\033[0m\]@\[\033[1;34m\]\h\[\033[0m\] \[\033[1;31m\]\w\[\033[0m\] # '"
                shell_custom_style_profile "${bianse}"
                _BREAK_INFO=" 已美化命令行样式(绿，  蓝， 红)，重启终端后生效"
                ;;
            2) 
                local bianse="PS1='\[\033[1;35m\]\u\[\033[0m\]@\[\033[1;36m\]\h\[\033[0m\] \[\033[1;33m\]\w\[\033[0m\] # '"
                shell_custom_style_profile "${bianse}"
                _BREAK_INFO=" 已美化命令行样式(紫，天蓝， 黄 )，重启终端后生效"
                ;;
            3) 
                local bianse="PS1='\[\033[1;31m\]\u\[\033[0m\]@\[\033[1;32m\]\h\[\033[0m\] \[\033[1;34m\]\w\[\033[0m\] # '"
                shell_custom_style_profile "${bianse}"
                _BREAK_INFO=" 已美化命令行样式(红，绿， 蓝)，重启终端后生效"
                ;;
            4) 
                local bianse="PS1='\[\033[1;36m\]\u\[\033[0m\]@\[\033[1;33m\]\h\[\033[0m\] \[\033[1;37m\]\w\[\033[0m\] # '"
                shell_custom_style_profile "${bianse}"
                _BREAK_INFO=" 已美化命令行样式(天蓝，黄，浅灰 )，重启终端后生效"
                ;;
            5) 
                local bianse="PS1='\[\033[1;37m\]\u\[\033[0m\]@\[\033[1;31m\]\h\[\033[0m\] \[\033[1;32m\]\w\[\033[0m\] # '"
                shell_custom_style_profile "${bianse}"
                _BREAK_INFO=" 已美化命令行样式(浅灰，红， 绿 )，重启终端后生效"
                ;;
            6) 
                local bianse="PS1='\[\033[1;33m\]\u\[\033[0m\]@\[\033[1;34m\]\h\[\033[0m\] \[\033[1;35m\]\w\[\033[0m\] # '"
                shell_custom_style_profile "${bianse}"
                _BREAK_INFO=" 已美化命令行样式(黄，  蓝， 紫 )，重启终端后生效"
                ;;
            7) 
                shell_custom_style_profile ''
                _BREAK_INFO=" 命令行无样式，重启终端后生效"
                ;;
            0) 
                echo -e "\n$TIP 返回主菜单 ..."
                _IS_BREAK="false"
                ;;
            *)
                _BREAK_INFO=" 请输入正确选项！"
                ;; 
            esac 
            
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


# 定义性能测试数组
MENU_COMMONLY_TOOLS_ITEMS=(
    "1|curl|$WHITE"
    "2|wget|$WHITE"
    "3|gdu|$MAGENTA"
    "4|btop|$WHITE"
    "5|htop|$WHITE"
    "6|iftop|$WHITE"
    "7|unzip|$WHITE"
    "8|Fail2Ban|$YELLOW"
    "9|SuperVisor|$YELLOW"
    "………………………|$WHITE" 
    "21|安装常用|$CYAN"
    "22|安装指定|$WHITE" 
    "23|卸载指定|$WHITE"
    "24|全部安装|$CYAN"
    "25|全部卸载|$WHITE"
    "………………………|$WHITE" 
    "31|贪吃蛇|$WHITE"
    "32|俄罗期方块|$WHITE"
    "33|太空入侵者|$WHITE"
    "34|跑火车屏保(sl)|$WHITE"
    "35|黑客帝国屏保(cmatrix)|$WHITE"
    "36|最新天气☀|$WHITE"
)

function commonly_tools_menu(){
    function print_sub_item_menu_headinfo(){
        clear 
        # print_menu_head $MAX_SPLIT_CHAR_NUM
        # local num_split=$MAX_SPLIT_CHAR_NUM
        local num_split=40
        print_sub_head "▼ 常用工具 " $num_split 1 0 
        split_menu_items MENU_COMMONLY_TOOLS_ITEMS[@] $num_split
        # print_main_menu_tail $num_split
        print_sub_menu_tail $num_split
    }

    while true; do
        print_sub_item_menu_headinfo
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入选项: ${PLAIN}")

        read -rp "${CHOICE}" INPUT
        case "${INPUT}" in
        1) 
            local app_name='curl'
            app_install ${app_name}
            echo -e "\n $POINTING ${app_name}已安装："
            _IS_BREAK='true'
            ;;
        2) 
            local app_name='wget'
            app_install ${app_name}
            echo -e "\n $POINTING ${app_name}已安装："
            app_install wget 
            _IS_BREAK='true'
            ;;
        3) 
            local app_name='gdu'
            app_install ${app_name}
            echo -e "\n $POINTING ${app_name}已安装："
            app_install gdu 
            _IS_BREAK='true'
            ;;
        4) 
            local app_name='btop'
            app_install ${app_name}
            echo -e "\n $POINTING ${app_name}已安装："
            app_install btop 
            _IS_BREAK='true'
            ;;
        5) 
            local app_name='htop'
            app_install ${app_name}
            echo -e "\n $POINTING ${app_name}已安装："
            app_install htop 
            _IS_BREAK='true'
            ;;
        6) 
            local app_name='iftop'
            app_install ${app_name}
            echo -e "\n $POINTING ${app_name}已安装："
            app_install iftop 
            _IS_BREAK='true'
            ;;
        7) 
            local app_name='unzip'
            app_install ${app_name}
            echo -e "\n $POINTING ${app_name}已安装："
            app_install unzip 
            _IS_BREAK='true'
            ;;
        8) 
            local app_name='fail2ban'
            if ! systemctl status ${app_name} > /dev/null 2>&1; then
                app_install ${app_name}
                app_install rsyslog 
                sudo systemctl start ${app_name}
                sudo systemctl enable ${app_name}
                sudo systemctl status ${app_name}
            fi
            echo -e "\n $POINTING ${app_name}已安装："
            _IS_BREAK='true'
            ;;
        9) 
            local app_name='supervisor'
            if ! systemctl status ${app_name} > /dev/null 2>&1; then
                app_install ${app_name}
            fi
            echo -e "\n $POINTING ${app_name}已安装："
            _IS_BREAK='true'
            ;;
        21) 
            local CHOICE=$(echo -e "\n${BOLD}└─ 是否要安装常用的工具(curl wget btop gdu supervisor fail2ban)? [Y/n]: ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            [[ -z $INPUT ]] && INPUT='Y'
            if [[ $INPUT == [Yy] || $INPUT == [Yy][Ee][Ss] ]]; then
                app_install curl 
                app_install wget 
                app_install btop 
                app_install gdu 
                
                app_install supervisor 
                app_install fail2ban 
                app_install rsyslog 
                sudo systemctl start fail2ban
                sudo systemctl enable fail2ban
                sudo systemctl status fail2ban
            fi

            echo -e "\n $POINTING 已安装常用工具：(curl wget btop gdu supervisor fail2ban)"
            _IS_BREAK='true'
            ;;
        24) 
            local CHOICE=$(echo -e "\n${BOLD}└─ 是否要安装常用的工具(wget btop gdu supervisor fail2ban)? [Y/n]: ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            [[ -z $INPUT ]] && INPUT='Y'
            if [[ $INPUT == [Yy] || $INPUT == [Yy][Ee][Ss] ]]; then
                # app_install curl 
                app_install wget 
                app_install btop 
                app_install gdu 
                
                app_install supervisor 
                app_install fail2ban 
                app_install rsyslog 
                sudo systemctl start fail2ban
                sudo systemctl enable fail2ban
                sudo systemctl status fail2ban
            fi

            echo -e "\n $POINTING 已安装常用工具：(wget btop gdu supervisor fail2ban)"
            _IS_BREAK='true'
            ;;
        25) 
            local CHOICE=$(echo -e "\n${BOLD}└─ 是否要卸载常用的工具(wget btop gdu supervisor fail2ban)? [Y/n]: ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            [[ -z $INPUT ]] && INPUT='Y'
            if [[ $INPUT == [Yy] || $INPUT == [Yy][Ee][Ss] ]]; then
                # app_remove curl 
                app_remove wget 
                app_remove btop 
                app_remove gdu 
                
                app_remove supervisor 
                sudo systemctl stop fail2ban
                app_remove fail2ban 
                app_remove rsyslog 

                sys_clean
            fi

            echo -e "\n $POINTING 已卸载常用工具：(wget btop gdu supervisor fail2ban)"
            _IS_BREAK='true'
            ;;
        22) 
            local CHOICE=$(echo -e "\n${BOLD}└─ 输入要安装的名称: ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            [[ -n $INPUT ]] && app_install $INPUT
            echo -e "\n $POINTING ${INPUT}已安装："
            _IS_BREAK='true'
            ;;
        23) 
            local CHOICE=$(echo -e "\n${BOLD}└─ 输入要卸载的名称: ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            [[ -n $INPUT ]] && app_remove $INPUT
            echo -e "\n $POINTING ${INPUT}已卸载："
            _IS_BREAK='true'
            ;;
        31) 
            app_install nsnake 
            clear 
            /usr/games/nsnake
            ;;
        32) 
            app_install bastet 
            clear 
            /usr/games/bastet
            ;;
        33) 
            app_install ninvaders 
            clear 
            /usr/games/ninvaders
            ;;
        34) 
            app_install sl 
            clear 
            /usr/games/sl
            ;;
        35) 
            app_install cmatrix 
            clear 
            cmatrix
            ;;
        36) 
            clear 
            curl wttr.in 
            _IS_BREAK="true"
            _BREAK_INFO=" > curl wttr.in "
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


# 常用面板和软件 
MENU_MANAGEMENT_TOOLS_ITEMS=(
    "1|1Panel|$YELLOW"
    "2|aaPanel|$WHITE"
    "3|iyCMS|$GREEN"
    "4|frps|$WHITE"
    "5|frpc|$WHITE"
    "6|Lucky|$WHITE"
    "7|Nezha|$WHITE"
    "8|Coder|$WHITE"
    "9|Code Server|$YELLOW"
    "10|Akile Monitor|$WHITE"
    "………………………|$WHITE" 
    "21|Redis|$CYAN"
    "22|MySQL|$WHITE"
    "23|MariaDB|$WHITE"
    "24|PostgreSQL|$WHITE"
    "………………………|$WHITE" 
    "31|RustDesk|$WHITE"
    "32|DeepLX|$WHITE"
    "33|SubLinkX|$WHITE"
    "34|Chrome|$WHITE"
    "………………………|$WHITE" 
    "41|Warp(@farsman)|$YELLOW"
    "42|Warp(@hamid)|$WHITE"
    "43|V2RayA|$WHITE"
    "44|Singbox(@farsman)|$YELLOW"
    "45|Singbox(@ygkkk)|$WHITE"
)

function management_tools_menu(){
    function print_sub_item_menu_headinfo(){
        clear 
        # print_menu_head $MAX_SPLIT_CHAR_NUM
        # local num_split=$MAX_SPLIT_CHAR_NUM
        local num_split=40
        print_sub_head "▼ 服务工具 " $num_split 1 0 
        split_menu_items MENU_MANAGEMENT_TOOLS_ITEMS[@] $num_split
        # print_main_menu_tail $num_split
        print_sub_menu_tail $num_split
    }
    
    # 获取当前系统类型
    function get_system_type() {
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

    while true; do
        print_sub_item_menu_headinfo

        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入选项: ${PLAIN}")
        read -rp "${CHOICE}" INPUT
        case "${INPUT}" in
        1) 
            _IS_BREAK="true"
            local app_name='1Panel'
            if command -v 1pctl &> /dev/null; then
                ## 系统已安装1Panel
                _BREAK_INFO=" 系统已安装${app_name}，无需重复安装!"
            else 
                ## 系统未安装1Panel
                local system_type=$(get_system_type)
                local CHOICE=$(echo -e "\n${BOLD}└─ 确定安装${app_name}吗? (Y/N): ${PLAIN}")
                read -rp "${CHOICE}" INPUT
                case "$INPUT" in
                [Yy] | [Yy][Ee][Ss])
                    # sys_update 
                    _BREAK_INFO=" 成功安装${app_name}!"
                    if [ "$system_type" == "centos" ]; then
                        curl -sSL https://resource.fit2cloud.com/1panel/package/quick_start.sh -o quick_start.sh && sh quick_start.sh
                    elif [ "$system_type" == "ubuntu" ]; then
                        curl -sSL https://resource.fit2cloud.com/1panel/package/quick_start.sh -o quick_start.sh && bash quick_start.sh
                    elif [ "$system_type" == "debian" ]; then
                        curl -sSL https://resource.fit2cloud.com/1panel/package/quick_start.sh -o quick_start.sh && bash quick_start.sh
                    else
                        bash <(curl -sSL https://linuxmirrors.cn/docker.sh) && curl -sSL https://resource.fit2cloud.com/1panel/package/quick_start.sh -o quick_start.sh && sh quick_start.sh
                    fi
                    ;;
                [Nn] | [Nn][Oo])
                    _BREAK_INFO=" 取消安装${app_name}!"
                    ;;
                *) 
                    _BREAK_INFO=" 输入错误，请重新输入!"
                    ;;
                esac
            fi        
            ;;
        2) 
            _IS_BREAK="true"
            local app_name='aaPanel'
            if [ -f "/etc/init.d/bt" ] && [ -d "/www/server/panel" ]; then
                _BREAK_INFO=" 系统已安装${aaPanel}，无需重复安装!"
            else 
                local system_type=$(get_system_type)
                local CHOICE=$(echo -e "\n${BOLD}└─ 确定安装${aaPanel}吗? (Y/N): ${PLAIN}")
                read -rp "${CHOICE}" INPUT
                case "$INPUT" in
                [Yy] | [Yy][Ee][Ss])
                    # sys_update 
                    app_install wget 
                    _BREAK_INFO=" 成功安装: ${aaPanel}!"
                    if [ "$system_type" == "centos" ]; then
                        yum install -y wget && wget -O install.sh http://www.aapanel.com/script/install_6.0_en.sh && bash install.sh aapanel
                    elif [ "$system_type" == "ubuntu" ]; then
                        wget -O install.sh http://www.aapanel.com/script/install-ubuntu_6.0_en.sh && bash install.sh aapanel
                    elif [ "$system_type" == "debian" ]; then
                        wget -O install.sh http://www.aapanel.com/script/install-ubuntu_6.0_en.sh && bash install.sh aapanel
                    else
                        _BREAK_INFO=" 不支持的系统类型(Debian|Ubuntu|CentOS), aaPanel安装取消!"
                    fi
                    ;;
                [Nn] | [Nn][Oo])
                    _BREAK_INFO=" 取消安装: ${aaPanel}!"
                    ;;
                *) 
                    _BREAK_INFO=" 输入错误，请重新输入!"
                    ;;
                esac
            fi        
            ;;
        3) 
            _IS_BREAK="true"
            local app_name='爱影CMS'
            local app_cmd='iycms'
            function print_app_usage(){
                echo -e "\n${BOLD} ${POINTING} ${app_name}使用说明: ${PLAIN}\n"
                echo -e " - WebURL: https://iycms.com/index.html"
                echo -e "" 
                echo -e " > systemctl status ${app_cmd}      # 查看${app_name}服务运行状态"
                echo -e " > systemctl start ${app_cmd}       # 查看${app_name}服务运行状态"
                echo -e " > systemctl stop ${app_cmd}        # 查看${app_name}服务运行状态"
                echo -e " > systemctl restart ${app_cmd}     # 查看${app_name}服务运行状态"
                echo ""
                [[ -n "$WAN4" ]] && echo -e " URL: http://$WAN4:21007 "
                [[ -n "$WAN6" ]] && echo -e " URL: http://[$WAN6]:21007 "
            }

            if systemctl status iycms > /dev/null 2>&1; then
                _BREAK_INFO=" 系统已安装${app_name}，无需重复安装!"
                print_app_usage
            else 
                local file="lucky.sh"
                local url="https://www.iycms.com/api/static/down/linux/ubuntu/install_x86_64.sh"
                echo -e "\n $TIP 开始下载${app_name}脚本...\n  url: ${url}\n $RESET"
                fetch_script_from_url $url $file 0
                
                print_app_usage
                _BREAK_INFO=" 成功安装: ${app_name}"
            fi 
            ;; 
        4) 
            _IS_BREAK="true"
            local app_name='frps'
            local app_cmd='frps'
            function print_app_usage(){
                echo -e "\n${BOLD} ${POINTING} ${app_name}使用说明: ${PLAIN}\n"
                echo -e " - GitHub: https://github.com/fatedier/frp/ "
                echo -e "" 
                echo -e " > systemctl status ${app_cmd}      # 查看${app_name}服务运行状态"
                echo -e " > systemctl start ${app_cmd}       # 查看${app_name}服务运行状态"
                echo -e " > systemctl stop ${app_cmd}        # 查看${app_name}服务运行状态"
                echo -e " > systemctl restart ${app_cmd}     # 查看${app_name}服务运行状态"
                echo ""
                [[ -n "$WAN4" ]] && echo -e " URL: http://$WAN4:7500 "
                [[ -n "$WAN6" ]] && echo -e " URL: http://[$WAN6]:7500 "
                echo ""
            }
            function download_frp(){
                local arch=$(uname -m)
                local url='https://api.github.com/repos/fatedier/frp/releases/latest'
                local frp_v=$(curl -s $(get_proxy_url $url) | grep -oP '"tag_name": "v\K.*?(?=")')

                if [[ "$arch" == "x86_64" ]]; then
                    url=$(get_proxy_url 'https://github.com/fatedier/frp/releases/download')
                    curl -L ${url}/v${frp_v}/frp_${frp_v}_linux_amd64.tar.gz -o frp_${frp_v}_linux_amd64.tar.gz
                elif [[ "$arch" == "armv7l" || "$arch" == "aarch64" ]]; then
                    curl -L ${url}/v${frp_v}/frp_${frp_v}_linux_arm.tar.gz -o frp_${frp_v}_linux_amd64.tar.gz
                else
                    echo " 不支持当前CPU架构: $arch"
                    _BREAK_INFO=" 不支持当前CPU架构: $arch!"
                    return 1 
                fi

                # 解压 .tar.gz 文件
                app_install tar
                tar -zxvf frp_*.tar.gz
                dir_name=$(tar -tzf frp_*.tar.gz | head -n 1 | cut -f 1 -d '/')
                mv "$dir_name" frp_0.61.0_linux_amd64
            }

            if systemctl status ${app_cmd} > /dev/null 2>&1; then
                _BREAK_INFO=" ${app_name}服务已安装，无需重复安装!"
                print_app_usage
            else 
                
                print_app_usage
                _BREAK_INFO=" 成功安装: ${app_name}!"
            fi 
            ;; 
        6) 
            _IS_BREAK="true"
            local app_name='Lucky'
            local app_cmd='lucky'
            function print_app_usage(){
                echo -e "\n${BOLD} ${POINTING} ${app_name}使用说明: ${PLAIN}\n"
                echo -e " > WebURL: https://lucky666.cn "
                echo -e " > GitHub: https://github.com/gdy666/lucky "
                echo -e "" 
                echo -e " > systemctl status ${app_cmd}      # 查看${app_name}服务运行状态"
                echo -e " > systemctl start ${app_cmd}       # 查看${app_name}服务运行状态"
                echo -e " > systemctl stop ${app_cmd}        # 查看${app_name}服务运行状态"
                echo -e " > systemctl restart ${app_cmd}     # 查看${app_name}服务运行状态"
                echo ""
                [[ -n "$WAN4" ]] && echo -e " URL: http://$WAN4:16601 "
                [[ -n "$WAN6" ]] && echo -e " URL: http://[$WAN6]:16601 "
                echo ""
                echo -e " > Login account: 666@666"
                echo ""
            }

            if command -v ${app_cmd} &> /dev/null; then
                _BREAK_INFO=" 系统已安装${app_name}，无需重复安装!"
                print_app_usage
            else 
                local file="lucky.sh"
                local url="https://release.ilucky.net:66"
                echo -e "\n $TIP 开始下载${app_name}脚本...\n  url: ${url}\n $RESET"
                fetch_script_from_url $url $file 0
                
                print_app_usage
                _BREAK_INFO=" 成功安装: ${app_name}!"
            fi 
            # URL="https://release.ilucky.net:66"; curl -o /tmp/install.sh "$URL/install.sh" && sh /tmp/install.sh "$URL"
            # URL="https://release.ilucky.net:66"; wget -O  /tmp/install.sh "$URL/install.sh" && sh /tmp/install.sh "$URL"
            # curl -o /tmp/install.sh https://6.666666.host:66/files/golucky.sh  && sh /tmp/install.sh https://6.666666.host:66/files 2.11.2
            ;; 
        7) 
            local app_name='NeZha Monitor'
            local app_cmd='nz'
            _IS_BREAK="true"
            
            local fname="nezha.sh"
            local url="https://raw.githubusercontent.com/nezhahq/scripts/refs/heads/main/install.sh"
            echo -e "\n $TIP 开始下载${app_name}脚本...\n  url: ${url}\n $RESET"
            fetch_script_from_url $url $fname 1
            _BREAK_INFO=" 从${app_name}返回！"
            echo -e "\n $TIP 后续可直接运行脚本: ./${fname}\n"
            # curl -L https://raw.githubusercontent.com/nezhahq/scripts/refs/heads/main/install.sh -o nezha.sh && chmod +x nezha.sh && sudo ./nezha.sh 
            ;; 
        8) 
            local app_name='Coder Server'
            local app_cmd='coder server'
            _IS_BREAK="true"
            function print_app_usage(){
                echo -e "\n${BOLD} ${POINTING} ${app_name}使用说明: ${PLAIN}\n"
                echo -e " > WebURL: https://coder.com/   "
                echo -e " > WebURL: https://github.com/coder/coder   "
                echo -e " > Docker: https://github.com/coder/coder/blob/main/docker-compose.yaml   "
                echo -e "\n > ${app_cmd}      # 临时启动${app_name}"
                echo -e "\n > sudo systemctl enable --now code-server@$USER # 以当前用户开启${app_name}服务"
                echo ""
                [[ -n "$WAN4" ]] && echo -e " URL: http://$WAN4:3000 "
                [[ -n "$WAN6" ]] && echo -e " URL: http://[$WAN6]:3000 "
            }
            
            if command -v ${app_cmd} &> /dev/null; then
                _BREAK_INFO=" 系统已安装${app_name}，无需重复安装!"
                print_app_usage
            else 
                _BREAK_INFO=" 成功安装${app_name}服务！"

                local file="coder.sh"
                local url="https://coder.com/install.sh"
                echo -e "\n $TIP 开始下载${app_name}脚本...\n  url: ${url}\n $RESET"
                fetch_script_from_url $url $file 0
                
                print_app_usage
            fi 
            # curl -L https://coder.com/install.sh | sh ;;
            ;; 
        9) 
            local app_name='Code Server'
            local app_cmd='code-server'
            _IS_BREAK="true"
            function print_app_usage(){
                echo -e "\n${BOLD} ${POINTING} ${app_name}使用说明: ${PLAIN}\n"
                echo -e " > WebURL: https://coder.com/   "
                echo -e " > WebURL: https://github.com/coder/coder   "
                echo -e " > GitHub: https://github.com/coder/code-server  "
                echo -e "\n > ${app_cmd}      # 临时启动${app_name}"
                echo -e "\n > sudo systemctl enable --now code-server@$USER # 以当前用户开启${app_name}服务"
                echo ""
                [[ -n "$WAN4" ]] && echo -e " URL: http://$WAN4:8080 "
                [[ -n "$WAN6" ]] && echo -e " URL: http://[$WAN6]:8080 "
            }
            
            if command -v ${app_cmd} &> /dev/null; then
                _BREAK_INFO=" 系统已安装${app_name}，无需重复安装!"
                print_app_usage
            else 
                _BREAK_INFO=" 成功安装${app_name}服务！"

                local file="code-server.sh"
                local url="https://code-server.dev/install.sh"
                echo -e "\n $TIP 开始下载${app_name}脚本...\n  url: ${url}\n $RESET"
                fetch_script_from_url $url $file 0
                
                print_app_usage
            fi 
            # curl -fsSL https://code-server.dev/install.sh | sh  ;;
            ;; 
        10) 
            local app_name='Akile Monitor'
            local app_cmd='akm'
            _IS_BREAK="true"
            _BREAK_INFO=" 由${app_name}返回！"
            local file="ak-setup.sh"
            local url="https://raw.githubusercontent.com/akile-network/akile_monitor/refs/heads/main/${file}"
            echo -e "\n $TIP 开始下载${app_name}脚本...\n  url: ${url}\n $RESET"
            fetch_script_from_url $url $file 1
            ;; 
        21) 
            local app_name='Redis'
            local app_cmd='redis'
            _IS_BREAK="true"
            _BREAK_INFO=" 由${app_name}返回！"
            function print_app_usage(){
                echo -e "\n${BOLD} ${POINTING} ${app_name}使用说明: ${PLAIN}\n"
                # echo -e " > WebURL: https://coder.com/   "
                echo ""
                [[ -n "$WAN4" ]] && echo -e " URL: http://$WAN4:6379 "
                [[ -n "$WAN6" ]] && echo -e " URL: http://[$WAN6]:6379 "
            }
            
            if command -v ${app_cmd} &> /dev/null; then
                _BREAK_INFO=" 系统已安装${app_name}数据库，无需重复安装!"
                # print_app_usage
            else 
                curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
                echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list
                apt update
                apt install redis
                systemctl start redis-server
                systemctl enable redis-server
                # print_app_usage
                _BREAK_INFO=" 成功安装${app_name}数据库！"
            fi 
            ;; 
        23) 
            local app_name='MariaDB'
            local app_cmd='mariadb'
            _IS_BREAK="true"
            _BREAK_INFO=" 由${app_name}返回！"
            
            if command -v ${app_cmd} &> /dev/null; then
                _BREAK_INFO=" 系统已安装${app_name}数据库，无需重复安装!"
            else                 
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

                _BREAK_INFO=" 成功安装${app_name}数据库！"
            fi 
            ;; 
        24) 
            local app_name='PostgreSQL'
            local app_cmd='postgresql'
            _IS_BREAK="true"
            _BREAK_INFO=" 由${app_name}返回！"
            
            if command -v ${app_cmd} &> /dev/null; then
                _BREAK_INFO=" 系统已安装${app_name}数据库，无需重复安装!"
                postgresql_usage
            else 
                install postgresql-client && apt update && install postgresql
                postgresql_usage
                _BREAK_INFO=" 成功安装${app_name}数据库！"
            fi 
            ;; 
        31) 
            _IS_BREAK="true"
            local app_name='RustDesk'
            local app_cmd='rustdesk'
             _BREAK_INFO=" 由${app_name}返回！"
            local fname="rustdesk.sh"
            local url="https://raw.githubusercontent.com/dinger1986/rustdeskinstall/master/install.sh"
            echo -e "\n $TIP 开始下载${app_name}脚本...\n  url: ${url}\n $RESET"
            fetch_script_from_url $url $fname 0 
            # wget https://raw.githubusercontent.com/dinger1986/rustdeskinstall/master/install.sh && chmod +x install.sh && ./install.sh ;;
            ;; 
        32) 
            _IS_BREAK="true"
            local app_name='DeepLX'
            local app_cmd='deeplx'
            function print_app_usage(){
                echo -e "\n${BOLD} ${POINTING} ${app_name}使用说明: ${PLAIN}\n"
                echo -e " - WebURL: https://deeplx.owo.network/"
                echo -e " - GitHub: https://github.com/OwO-Network/DeepLX"
                echo ""
                echo -e " > ${app_cmd}      # 查看${app_name}运行状态"
                echo ""
                if [[ -n "$WAN4" ]] ; then
                    echo ""
                    echo -e " URL: http://$WAN4:1188"
                    echo -e " URL: http://$WAN4:1188/translate"
                    echo -e " URL: http://$WAN4:1188/v1/translate"
                    echo -e " URL: http://$WAN4:1188/v2/translate"
                fi
                if [[ -n "$WAN6" ]] ; then
                    echo ""
                    echo -e " URL: http://[$WAN6]:1188"
                    echo -e " URL: http://[$WAN6]:1188/translate"
                    echo -e " URL: http://[$WAN6]:1188/v1/translate"
                    echo -e " URL: http://[$WAN6]:1188/v2/translate"
                fi
                # [[ -n "$WAN6" ]] && echo -e " URL: http://[$WAN6]:1188 "
            }

            if command -v deeplx &> /dev/null; then
                _BREAK_INFO=" 系统已安装${app_name}，无需重复安装!"
                print_app_usage
            else 
                _BREAK_INFO=" 成功安装${app_name}服务！"
                local fname="deeplx.sh"
                local url="https://raw.githubusercontent.com/OwO-Network/DeepLX/main/install.sh"
                echo -e "\n $TIP 开始下载${app_name}脚本...\n  url: ${url}\n $RESET"
                fetch_script_from_url $url $fname 1 
                
                print_app_usage
            fi 
            # bash <(curl -Ls https://ssa.sx/dx)
            # bash <(curl -Ls https://raw.githubusercontent.com/OwO-Network/DeepLX/main/install.sh)
            ;; 
        33) 
            _IS_BREAK="true"
            local app_name='SubLinkX'
            local app_cmd='sublink'
            function print_app_usage(){
                echo -e "\n${BOLD} ${POINTING} ${app_name}使用说明: ${PLAIN}"
                echo -e "\n - GitHub: https://github.com/gooaclok819/sublinkX"
                echo -e "\n - ${app_cmd}      # 查看${app_name}管理菜单"
                echo ""
                [[ -n "$WAN4" ]] && echo -e " URL: http://$WAN4:8000 "
                [[ -n "$WAN6" ]] && echo -e " URL: http://[$WAN6]:8000 "
            }

            if command -v ${app_cmd} &> /dev/null; then
                _BREAK_INFO=" 系统已安装${app_name}，无需重复安装!"
                print_app_usage
            else 
                _BREAK_INFO=" 成功安装${app_name}服务！"
                local fname="sublinkx.sh"
                local url="https://raw.githubusercontent.com/gooaclok819/sublinkX/main/install.sh"
                echo -e "\n $TIP 开始下载${app_name}脚本...\n  url: ${url}\n $RESET"
                fetch_script_from_url $url $fname 1 
                
                print_app_usage
            fi 
            # curl -s https://raw.githubusercontent.com/gooaclok819/sublinkX/main/install.sh | sudo bash
            ;; 
        34) 
            _IS_BREAK="true"
            local app_name='Chrome'
            local app_cmd='chrome'

            if command -v ${app_cmd} &> /dev/null; then
                _BREAK_INFO=" 系统已安装${app_name}，无需重复安装!"
            else 
                _BREAK_INFO=" 成功安装${app_name}！"
                local fname="google-chrome-stable_current_amd64.deb"
                local url="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
                sudo apt-get install -f -y && wget ${url} && sudo dpkg -i ${fname}
                # sudo apt-get install -f -y
                # wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb 
                # sudo dpkg -i google-chrome-stable_current_amd64.deb
            fi 

            ;; 
        41) 
            _IS_BREAK="true"
            local app_name='Warp'
            local app_cmd='warp'
             _BREAK_INFO=" 由${app_name}返回！"
            local fname="menu.sh"
            local url="https://gitlab.com/fscarmen/warp/-/raw/main/${fname}"
            echo -e "\n $TIP 开始下载${app_name}脚本...\n  url: ${url}\n $RESET"
            fetch_script_from_url $url $fname 0 
            ;; 
        42) 
            _IS_BREAK="true"
            local app_name='Warp(hamid)'
            local app_cmd='warp'
             _BREAK_INFO=" 由${app_name}返回！"
            local fname="warp_proxy.sh"
            local ghurl="https://github.com/hamid-gh98"
            local url="https://raw.githubusercontent.com/hamid-gh98/x-ui-scripts/main/install_warp_proxy.sh"
            echo -e "\n $TIP 开始下载${app_name}脚本...\n  url: ${url}\n $RESET"
            fetch_script_from_url $url $fname 1  
            ;; 
        43) 
            _IS_BREAK="true"
            local app_name='V2RayA'
            local app_cmd='v2raya'
             _BREAK_INFO=" 由${app_name}返回！"
            function print_app_usage(){
                echo -e "\n${BOLD} ${POINTING} ${app_name}使用说明: ${PLAIN}\n"
                echo -e " - WebURL: https://v2raya.org/"
                echo -e " - GitHub: https://github.com/v2rayA/v2rayA-installer"
                echo ""
                echo -e " > ${app_cmd}      # 查看${app_name}管理菜单"
                echo -e " > sudo systemctl start v2raya.service      # 启动${app_name}服务"
                echo -e " > sudo systemctl enable v2raya.service     # 设置${app_name}自启动"
                echo -e " > v2raya-reset-password                    # 重新设置${app_name}密码"
                echo -e " > /usr/local/etc/v2raya                    # 配置文件目录"
                echo ""
                [[ -n "$WAN4" ]] && echo -e " URL: http://$WAN4:2017 "
                [[ -n "$WAN6" ]] && echo -e " URL: http://[$WAN6]:2017 "
            }

            # wget -qO - https://apt.v2raya.org/key/public-key.asc | sudo tee /etc/apt/keyrings/v2raya.asc
            # echo "deb [signed-by=/etc/apt/keyrings/v2raya.asc] https://apt.v2raya.org/ v2raya main" | sudo tee /etc/apt/sources.list.d/v2raya.list
            # sudo apt update
            # sudo apt install v2raya v2ray ## 也可以使用 xray 包
            # sudo systemctl start v2raya.service
            # sudo systemctl enable v2raya.service
            function start_v2ray_service(){
                
                local CHOICE=$(echo -e "\n${BOLD}└─ 是否启动${app_name}服务? [Y/n] ${PLAIN}")
                read -rp "${CHOICE}" INPUT
                [[ -z "${INPUT}" ]] && INPUT=Y # 回车默认为Y
                case "${INPUT}" in
                [Yy] | [Yy][Ee][Ss])
                    echo -e "\n$TIP 启动服务 ...\n"
                    sudo systemctl start v2raya.service
                    _BREAK_INFO=" 服务启动中 ..."
                    ;;
                [Nn] | [Nn][Oo])
                    echo -e "\n$TIP 不启动服务！"
                    ;;
                *)
                    echo -e "\n$WARN 输入错误！"
                    _BREAK_INFO=" 输入错误，不重启系统！"
                    _IS_BREAK="true"
                    ;;
                esac

                local CHOICE=$(echo -e "\n${BOLD}└─ 是否设置${app_name}服务自启动? [Y/n] ${PLAIN}")
                read -rp "${CHOICE}" INPUT
                [[ -z "${INPUT}" ]] && INPUT=Y # 回车默认为Y
                case "${INPUT}" in
                [Yy] | [Yy][Ee][Ss])
                    echo -e "\n$TIP 设置自启动服务 ...\n"
                    sudo systemctl enable v2raya.service
                    _BREAK_INFO=" 设置服务自启动成功 ..."
                    ;;
                [Nn] | [Nn][Oo])
                    echo -e "\n$TIP 不启动服务！"
                    ;;
                *)
                    echo -e "\n$WARN 输入错误！"
                    _BREAK_INFO=" 输入错误，不重启系统！"
                    _IS_BREAK="true"
                    ;;
                esac
            }

            local v2raya_options_list=(
                "1. 安装 V2RayA(v2ray)"
                "2. 安装 V2RayA(xray)"
                "3. 卸载 V2RayA"
                "0. 退出"
            )

            local fname="v2raya-installer.sh"
            local url="https://github.com/v2rayA/v2rayA-installer/raw/main/installer.sh"
            url=$(get_proxy_url "$url")

            print_items_list v2raya_options_list[@] "${app_name}菜单"
            local CHOICE=$(echo -e "\n${BOLD}└─ 输入选项: ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            case "${INPUT}" in
            1) 
                _BREAK_INFO=" 成功安装${app_name}(v2ray内核)！"                
                sudo sh -c "$(wget -qO- ${url})" @ --with-v2ray
                print_app_usage
                start_v2ray_service
                ;;
            2) 
                _BREAK_INFO=" 成功安装${app_name}(xray内核)！"
                sudo sh -c "$(wget -qO- ${url})" @ --with-xray
                print_app_usage
                start_v2ray_service
                ;;
            3) 
                local fname="v2raya-uninstaller.sh"
                local url="https://github.com/v2rayA/v2rayA-installer/raw/main/uninstaller.sh"
                echo -e "\n $TIP 开始下载${app_name}脚本...\n  url: ${url}\n $RESET"
                fetch_script_from_url $url $fname 1 

                # sudo sh -c "$(wget -qO- ${url})"
                _BREAK_INFO=" 成功卸载${app_name}！"
                ;;
            0) 
                echo -e "\n$TIP 返回主菜单 ..."
                _IS_BREAK="false"
                ;;
            *)
                _BREAK_INFO=" 请输入正确选项！"
                ;;
            esac 
            ;; 
        44) 
            _IS_BREAK="true"
            local app_name='Singbox'
            local app_cmd='sb'
             _BREAK_INFO=" 由${app_name}返回！"
            local fname="sing-box.sh"
            local url="https://raw.githubusercontent.com/fscarmen/sing-box/main/${fname}"
            echo -e "\n $TIP 开始下载${app_name}脚本...\n  url: ${url}\n $RESET"
            fetch_script_from_url $url $fname 
            ;; 
        45) 
            _IS_BREAK="true"
            local app_name='Singbox(yg)'
            local app_cmd='sb'
             _BREAK_INFO=" 由${app_name}返回！"
            local fname="sb.sh"
            local url="https://gitlab.com/rwkgyg/sing-box-yg/raw/main/${fname}"
            echo -e "\n $TIP 开始下载${app_name}脚本...\n  url: ${url}\n $RESET"
            fetch_script_from_url $url $fname 0 
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


# 其他常用脚本 
MENU_OTHER_SCRIPTS_ITEMS=(
    "1|KijiLion|$YELLOW"
    "2|YiDian(docker)|$WHITE"
    "3|YiDian(Nginx)|$WHITE"
    "4|YiDian(Serv00)|$WHITE"
    "5|LinuxMirrors|$MAGENTA"
    "6|LinuxMirrors(edu)|$WHITE"
    "7|LinuxMirrors(abroad)|$WHITE"
    "8|LinuxMirrors(docker)|$WHITE"
    "………………………|$WHITE" 
    "21|Sky-Box|$WHITE" 
)


function other_scripts_menu(){
    function print_sub_item_menu_headinfo(){
        clear 
        # print_menu_head $MAX_SPLIT_CHAR_NUM
        local num_split=$MAX_SPLIT_CHAR_NUM
        print_sub_head "▼ 其他脚本 " $num_split 1 0 
        split_menu_items MENU_OTHER_SCRIPTS_ITEMS[@] $num_split
        # print_main_menu_tail $num_split
        print_sub_menu_tail $num_split
    }

    while true; do
        print_sub_item_menu_headinfo
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入选项: ${PLAIN}")

        read -rp "${CHOICE}" INPUT
        case "${INPUT}" in
        1) 
            bash <(curl -sL kejilion.sh)
            ;;
        2)
            local app_name='1keji_docker'
            local app_cmd='1keji_docker'
            _IS_BREAK="true"
             _BREAK_INFO=" 由${app_name}返回！"
            local fname="1keji_docker.sh"
            local url="https://pan.1keji.net/f/rRi2/${fname}"
            echo -e "\n $TIP 开始下载${app_name}脚本...\n  url: ${url}\n $RESET"
            fetch_script_from_url $url $fname 0 

            # echo -e " 1keji_docker.sh 脚本下载中...\n"
            # wget -qO 1keji_docker.sh "https://pan.1keji.net/f/rRi2/1keji_docker.sh" && chmod +x 1keji_docker.sh && ./1keji_docker.sh
            ;;
        3) 
            local app_name='1keji_docker'
            local app_cmd='1keji_docker'
            _IS_BREAK="true"
             _BREAK_INFO=" 由${app_name}返回！"
            local fname="1keji_nznginx.sh"
            local url="https://pan.1keji.net/f/YJTA/${fname}"
            echo -e "\n $TIP 开始下载${app_name}脚本...\n  url: ${url}\n $RESET"
            fetch_script_from_url $url $fname 0 
            # clear 
            # echo -e " 1keji_nznginx.sh 脚本下载中...\n"
            # wget -qO 1keji_nznginx.sh "https://pan.1keji.net/f/YJTA/1keji_nznginx.sh" && chmod +x 1keji_nznginx.sh && ./1keji_nznginx.sh
            ;;
        4) 
            local app_name='1keji_docker'
            local app_cmd='1keji_docker'
            _IS_BREAK="true"
             _BREAK_INFO=" 由${app_name}返回！"
            local fname="1kejiV01.sh"
            local url="https://pan.1keji.net/f/ERGcp/${fname}"
            echo -e "\n $TIP 开始下载${app_name}脚本...\n  url: ${url}\n $RESET"
            fetch_script_from_url $url $fname 0 
            # clear 
            # echo -e " 1kejiV01.sh 脚本下载中...\n"
            # wget -qO 1kejiV01.sh "https://pan.1keji.net/f/ERGcp/1kejiV01.sh" && chmod +x 1kejiV01.sh && ./1kejiV01.sh
            ;;
        5) 
            bash <(curl -sSL https://linuxmirrors.cn/main.sh)
            _BREAK_INFO=" 从 linuxmirrors 返回 ... "
            _IS_BREAK="true"
            ;;
        6) 
            bash <(curl -sSL https://linuxmirrors.cn/main.sh) --edu 
            _BREAK_INFO=" 从 linuxmirrors 返回 ... "
            _IS_BREAK="true"
            ;;
        7) 
            bash <(curl -sSL https://linuxmirrors.cn/main.sh) --abroad
            _BREAK_INFO=" 从 linuxmirrors 返回 ... "
            _IS_BREAK="true"
            ;;
        8) 
            bash <(curl -sSL https://linuxmirrors.cn/docker.sh)
            _BREAK_INFO=" 从 linuxmirrors(docker) 返回 ... "
            _IS_BREAK="true"
            ;;
        21) 
            # local country=$(curl -s --connect-timeout 1 --max-time 3 ipinfo.io/country)
            local url=$(get_proxy_url "https://raw.githubusercontent.com/BlueSkyXN/SKY-BOX/main/box.sh")
            # check_ip_china
            # [[ $_IS_CN -eq 1 ]] && url="${URL_PROXY}${url}"
            # app_install wget 
            if command -v wget &> /dev/null ; then 
                wget -O box.sh "${url}" && chmod +x box.sh && clear && ./box.sh
            elif command -v curl &> /dev/null ; then 
                curl -sSL -o box.sh "${url}" && chmod +x box.sh && clear && ./box.sh
            else 
                echo -e "\n${ERROR} 很抱歉，你的系统不支持 wget 或 curl 命令！${NC}"
            fi 
            _BREAK_INFO=" 从 SKY-BOX 工具箱返回 ... "
            _IS_BREAK="true"
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

# 安装最新版本的python
function python_update_to_latest() {
    # 系统检测
    local OS=$(cat /etc/os-release | grep -o -E "Debian|Ubuntu|CentOS" | head -n 1)

    if [[ $OS == "Debian" || $OS == "Ubuntu" || $OS == "CentOS" ]]; then
        echo -e "检测到你的系统是 ${YELLOW}${OS}${NC}"
    else
        echo -e "${RED}很抱歉，你的系统不受支持！${NC}"
        return 1 
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
            return 1
        fi
    else
        echo -e "${RED}检测到没有安装Python3。${NC}"
        read -p "是否确认安装最新版Python3？默认安装 [Y/n]: " CONFIRM
        if [[ $CONFIRM != "n" ]]; then
            echo -e "${GREEN}开始安装最新版Python3...${NC}"
        else
            echo -e "${YELLOW}已取消安装Python3${NC}"
            return 1 
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


# 安装指定版本的python
function python_install_version() {
    local python_version="$1"

    if ! grep -q 'export PYENV_ROOT="\$HOME/.pyenv"' ~/.bashrc; then
        if command -v yum &>/dev/null; then
            yum update -y && yum install git -y
            yum groupinstall "Development Tools" -y
            yum install openssl-devel bzip2-devel libffi-devel ncurses-devel zlib-devel readline-devel sqlite-devel xz-devel findutils -y

            curl -O https://www.openssl.org/source/openssl-1.1.1u.tar.gz
            tar -xzf openssl-1.1.1u.tar.gz
            cd openssl-1.1.1u
            ./config --prefix=/usr/local/openssl --openssldir=/usr/local/openssl shared zlib
            make
            make install
            echo "/usr/local/openssl/lib" > /etc/ld.so.conf.d/openssl-1.1.1u.conf
            ldconfig -v
            cd ..

            export LDFLAGS="-L/usr/local/openssl/lib"
            export CPPFLAGS="-I/usr/local/openssl/include"
            export PKG_CONFIG_PATH="/usr/local/openssl/lib/pkgconfig"

        elif command -v apt &>/dev/null; then
            apt update -y && apt install git -y
            apt install build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev libgdbm-dev libnss3-dev libedit-dev -y
        elif command -v apk &>/dev/null; then
            apk update && apk add git
            apk add --no-cache bash gcc musl-dev libffi-dev openssl-dev bzip2-dev zlib-dev readline-dev sqlite-dev libc6-compat linux-headers make xz-dev build-base  ncurses-dev
        else
            # echo "未知的包管理器!"
            _BREAK_INFO=" 未知的包管理器，无法安装Python${python_version}！"
            _IS_BREAK="true"
            return
        fi

        curl https://pyenv.run | bash
        cat << EOF >> ~/.bashrc

export PYENV_ROOT="\$HOME/.pyenv"
if [[ -d "\$PYENV_ROOT/bin" ]]; then
  export PATH="\$PYENV_ROOT/bin:\$PATH"
fi
eval "\$(pyenv init --path)"
eval "\$(pyenv init -)"
eval "\$(pyenv virtualenv-init -)"

EOF

    fi

    sleep 1
    source ~/.bashrc
    sleep 1
    pyenv install $python_version
    pyenv global $python_version

    rm -rf /tmp/python-build.*
    rm -rf $(pyenv root)/cache/*

    local VERSION=$(python -V 2>&1 | awk '{print $2}')
    _BREAK_INFO=" 成功安装Python${VERSION}！"
    _IS_BREAK="true"
}

# Python管理
MENU_PYTHON_ITEMS=(
    "1|安装Python|$WHITE" 
    "2|安装pipenv|$WHITE" 
    "3|安装miniForge|$YELLOW" 
    "4|安装miniConda|$WHITE"  
    "………………………|$WHITE" 
    "21|设置pip源|$WHITE" 
    "22|设置conda源|$WHITE" 
    "………………………|$WHITE"
    "31|安装dash|$WHITE"
    "32|安装julia|$WHITE"
    "33|安装gunicorn|$WHITE" 
    "34|安装hypercorn|$WHITE" 
)

function python_management_menu(){
    function print_sub_item_menu_headinfo(){
        clear 
        # print_menu_head $MAX_SPLIT_CHAR_NUM
        local num_split=$MAX_SPLIT_CHAR_NUM
        print_sub_head "▼ Python管理 " $num_split 0 0 
        local VERSION=$(python3 -V 2>&1 | awk '{print $2}')
        echo -e "\n $POINTING 当前Python: $VERSION\n"
        generate_separator "…|$AZURE" $num_split # 另一个分割线
        split_menu_items MENU_PYTHON_ITEMS[@] $num_split
        # print_main_menu_tail $num_split
        print_sub_menu_tail $num_split
    }
    local py_vesions_list=(
        "1.升级为最新版本"
        "2.Python3.12.7"
        "3.Python3.11"
        "4.Python3.10"
        "5.Python3.9"
        "9.指定版本"
        "0.退出"
    )
    local pip_sources_list=(
        "1.官方源"
        "2.阿里云"
        "3.腾讯云"
        "4.清华镜像"
        "5.中科大镜像"
        "9.自定义镜像"
        "0.退出"
    )
    local conda_sources_list=(
        "1.官方源"
        "2.阿里云"
        "3.清华镜像"
        "4.中科大镜像"
        "0.退出"
    )

    while true; do
        print_sub_item_menu_headinfo
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入选项: ${PLAIN}")

        read -rp "${CHOICE}" INPUT
        case "${INPUT}" in
        1) 
            _IS_BREAK="true"
            print_items_list py_vesions_list[@] "Python版本列表"
            local CHOICE=$(echo -e "\n${BOLD}└─ 输入你要安装选项: ${PLAIN}")
            read -rp "${CHOICE}" INPUT
            case "${INPUT}" in
            1) 
                python_update_to_latest
                ;;
            2) 
                python_install_version 3.12.7
                ;;
            3) 
                python_install_version 3.11
                ;;
            4) 
                python_install_version 3.10
                ;;
            5) 
                python_install_version 3.9
                ;;
            9) 
                local CHOICE=$(echo -e "\n${BOLD}└─ 选择Python版本: ${PLAIN}")
                read -rp "${CHOICE}" INPUT
                if [[ "$INPUT" == "0" ]]; then
                    _BREAK_INFO=" 取消安装Python ..."
                else
                    python_install_version $INPUT
                fi
                ;;
            0) 
                echo -e "\n$TIP 返回主菜单 ..."
                _IS_BREAK="false"
                ;;
            *)
                _BREAK_INFO=" 请输入正确选项！"
                ;;
            esac 
            ;;
        2) 
            _IS_BREAK="true"
            if command -v pipenv &>/dev/null; then
                _BREAK_INFO=" pipenv已安装，无需重新安装！"
            else
                sys_update && app_install pipenv 
                _BREAK_INFO=" pipenv安装成功！"
            fi
            ;;
        3) 
            _IS_BREAK="true"
            if command -v conda &>/dev/null; then
                _BREAK_INFO=" 系统已安装conda！"
            else
                local file="Miniforge3-$(uname)-$(uname -m).sh"
                local url="https://github.com/conda-forge/miniforge/releases/latest/download/$file"
                url=$(get_proxy_url $url)
                # check_ip_china
                # [[ $_IS_CN -eq 1 ]] && url="${URL_PROXY}${url}"

                _BREAK_INFO=" miniForge安装成功！"
                if command -v curl &>/dev/null; then
                    curl -L -O "${url}" && bash ${file}
                elif command -v wget &>/dev/null; then
                    wget "${url}" && bash ${file} 
                else
                    _BREAK_INFO=" 请先安装curl或wget！"
                fi
            fi
            ;;
        4) 
            _IS_BREAK="true"
            if command -v conda &>/dev/null; then
                _BREAK_INFO=" 系统已安装conda！"
            else
                local file="Miniconda3-latest-$(uname)-$(uname -m).sh"
                local url="https://repo.anaconda.com/miniconda/$file"
                url=$(get_proxy_url $url)
                # check_ip_china
                # [[ $_IS_CN -eq 1 ]] && url="${URL_PROXY}${url}"

                _BREAK_INFO=" miniConda安装成功！"
                if command -v curl &>/dev/null; then
                    curl -L -O "${url}" && bash ${file}
                elif command -v wget &>/dev/null; then
                    wget "${url}" && bash ${file} 
                else
                    _BREAK_INFO=" 请先安装curl或wget！"
                fi
            fi
            ;;
        21) 
            _IS_BREAK="true"
            if command -v pip &>/dev/null; then
                local is_to_set=1
                local url=""
                local host=""
                _BREAK_INFO=" 设置pip镜像源成功！"
                print_items_list pip_sources_list[@] "pip镜像列表"
                local CHOICE=$(echo -e "\n${BOLD}└─ 选择镜像源: ${PLAIN}")
                read -rp "${CHOICE}" INPUT
                case "${INPUT}" in
                1) 
                    url="https://pypi.org/simple"
                    host="pypi.org"
                    ;;
                2) 
                    url="https://mirrors.aliyun.com/simple"
                    host="mirrors.aliyun.com"
                    ;;
                3) 
                    url="https://mirrors.cloud.tencent.com/pypi/simple"
                    host="mirrors.cloud.tencent.com"
                    ;;
                4) 
                    url="https://pypi.tuna.tsinghua.edu.cn/simple"
                    host="pypi.tuna.tsinghua.edu.cn"
                    ;;
                5) 
                    url="https://pypi.mirrors.ustc.edu.cn/simple"
                    host="pypi.mirrors.ustc.edu.cn"
                    ;;
                9) 
                    local CHOICE=$(echo -e "\n${BOLD}└─ 请输入镜像源地址: \n ${PLAIN}")
                    read -rp "${CHOICE}" INPUT 
                    [[ -z "${INPUT}" ]] && url=$INPUT 
                    ;;
                0) 
                    echo -e "\n$TIP 返回主菜单 ..."
                    _IS_BREAK="false"
                    is_to_set=0
                    ;;
                *)
                    _BREAK_INFO=" 请输入正确选项！"
                    is_to_set=0
                    ;;
                esac 

                if [[ ${is_to_set} -eq 1 ]]; then
                    # if [[ -f "/etc/pip.conf" ]]; then
                    #     sed -i "s|index-url=.*|index-url=${url}|g" /etc/pip.conf
                    # else
                    #     echo "index-url=${url}" > /etc/pip.conf
                    # fi
                    [[ -n $url ]] && pip config set global.index-url  $url
                    [[ -n $host ]] && pip config set global.trusted-host $host
                    pip config set global.timeout 30
                    pip config set global.disable-pip-version-check true
                    _BREAK_INFO=" 设置pip镜像源成功: ${url}"
                fi
            else
                _BREAK_INFO=" pip尚未安装！"
            fi
            ;;
        22) 
            _IS_BREAK="true"
            if command -v conda &>/dev/null; then
                function conda_sources_backup(){
                    conda config --show-sources > conda_sources_backup.txt
                }
                function conda_sources_remove(){
                    conda config --remove-key channels
                }
                function conda_sources_default(){
                    conda config --remove-key channels
                    conda config --add channels defaults
                }

                local is_to_set=1
                local url=""
                local host=""
                _BREAK_INFO=" 设置conda镜像源成功！"

                print_items_list conda_sources_list[@] "conda镜像列表"
                local CHOICE=$(echo -e "\n${BOLD}└─ 选择镜像源: ${PLAIN}")
                read -rp "${CHOICE}" INPUT
                case "${INPUT}" in
                1) 
                    conda_sources_default
                    _BREAK_INFO=" 设置Conda源为默认源！"
                    ;;
                2) 
                    conda config --add channels http://mirrors.aliyun.com/anaconda/pkgs/main/
                    conda config --add channels http://mirrors.aliyun.com/anaconda/pkgs/r/
                    conda config --add channels http://mirrors.aliyun.com/anaconda/pkgs/msys2/
                    conda config --set show_channel_urls yes
                    conda clean -i 
                    _BREAK_INFO=" 设置Conda源成功: 阿里云镜像！"
                    ;;
                3) 
                    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
                    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
                    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/
                    conda config --set show_channel_urls yes
                    conda clean -i 
                    _BREAK_INFO=" 设置Conda源成功: 清华大学镜像！"
                    ;;
                4) 
                    conda config --add channels https://mirrors.ustc.edu.cn/anaconda/pkgs/main
                    conda config --add channels https://mirrors.ustc.edu.cn/anaconda/pkgs/r
                    conda config --add channels https://mirrors.ustc.edu.cn/anaconda/pkgs/msys2
                    conda config --set show_channel_urls yes
                    conda clean -i 
                    _BREAK_INFO=" 设置Conda源成功: 中科大镜像！"
                    ;;
                0) 
                    echo -e "\n$TIP 返回主菜单 ..."
                    _IS_BREAK="false"
                    is_to_set=0
                    ;;
                *)
                    _BREAK_INFO=" 请输入正确选项！"
                    is_to_set=0
                    ;;
                esac 

            else
                _BREAK_INFO=" conda尚未安装！"
            fi
            ;;
        31) 
            _IS_BREAK="true"
            _BREAK_INFO=" dash安装成功！"
            if command -v pip &>/dev/null; then
                pip install dash 
            elif command -v conda &>/dev/null; then
                conda install dash 
            else
                _BREAK_INFO=" conda或pip未安装！"
            fi
            ;;
        32) 
            _IS_BREAK="true"
            _BREAK_INFO=" Julia安装成功！"
            if  command -v julia &>/dev/null; then
                _BREAK_INFO=" julia已安装！"
            else
                if ! command -v jill &>/dev/null; then
                    # echo -e "\n$TIP 先安装jill ..."
                    if command -v pip &>/dev/null; then
                        pip install jill
                    else 
                        echo -e "$ERROR  jill未安装, 请先安装pip！"
                    fi
                fi 
                if command -v jill &>/dev/null; then
                    echo -e "\n$TIP 安装Julia ..."
                    jill install 
                else 
                    _BREAK_INFO=" jill未安装, Julia安装失败！"
                fi
            fi
            ;;
        33) 
            _IS_BREAK="true"
            _BREAK_INFO=" gunicorn安装成功！"
            if  command -v gunicorn &>/dev/null; then
                _BREAK_INFO=" gunicorn已安装！"
            else
                if command -v pip &>/dev/null; then
                    pip install gunicorn greenlet eventlet gevent
                elif command -v conda &>/dev/null; then
                    conda install gunicorn greenlet eventlet gevent
                else
                    _BREAK_INFO=" pip或conda未安装！"
                fi 
            fi
            ;;
        34) 
            _IS_BREAK="true"
            _BREAK_INFO=" hypercorn安装成功！"
            if  command -v hypercorn &>/dev/null; then
                _BREAK_INFO=" hypercorn已安装！"
            else
                if command -v pip &>/dev/null; then
                    pip install hypercorn 
                elif command -v conda &>/dev/null; then
                    conda install hypercorn 
                else
                    _BREAK_INFO=" pip或conda未安装！"
                fi 
            fi
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


# Caddy管理
MENU_CADDY_ITEMS=(
    "1|安装Caddy|$WHITE"
    "2|卸载Caddy|$WHITE"
    "3|Caddy状态|$WHITE"
    "4|重启Caddy|$WHITE"
    "5|更新Caddy|$WHITE"
    "…………………………|$WHITE" 
    "21|站点管理|$WHITE" 
    "22|添加反代|$YELLOW" 
    "23|添重定向|$WHITE" 
    "24|添静态站|$WHITE" 
)

function caddy_management_menu(){
    function print_sub_item_menu_headinfo(){
        clear 
        # print_menu_head $MAX_SPLIT_CHAR_NUM
        local num_split=$MAX_SPLIT_CHAR_NUM
        print_sub_head "▼ Caddy管理 " $num_split 0 0 
        split_menu_items MENU_CADDY_ITEMS[@] $num_split
        # print_main_menu_tail $num_split
        print_sub_menu_tail $num_split
    }

    while true; do
        print_sub_item_menu_headinfo
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入选项: ${PLAIN}")

        read -rp "${CHOICE}" INPUT
        case "${INPUT}" in
        1) 
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

# Docker管理
MENU_DOCKER_ITEMS=(
    "1|安装Docker|$WHITE"
    "2|卸载Docker|$WHITE"
    "3|Docker状态|$WHITE"
    "4|重启Docker|$WHITE"
    "5|更新Docker|$WHITE"
    "………………………|$WHITE" 
    "21|站点容器|$WHITE" 
    "21|删除容器|$YELLOW" 
    "21|添重定向|$WHITE" 
    "21|添静态站|$WHITE" 
)

function docker_management_menu(){
    function print_sub_item_menu_headinfo(){
        clear 
        # print_menu_head $MAX_SPLIT_CHAR_NUM
        local num_split=$MAX_SPLIT_CHAR_NUM
        print_sub_head "▼ Docker管理 " $num_split 0 0 
        split_menu_items MENU_DOCKER_ITEMS[@] $num_split
        # print_main_menu_tail $num_split
        print_sub_menu_tail $num_split
    }

    while true; do
        print_sub_item_menu_headinfo
        local CHOICE=$(echo -e "\n${BOLD}└─ 请输入选项: ${PLAIN}")

        read -rp "${CHOICE}" INPUT
        case "${INPUT}" in
        1) 
            bash <(curl -sL kejilion.sh)
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



# 定义主菜单数组
MENU_MAIN_ITEMS=(
    "1|基本信息|$MAGENTA"
    "2|性能测试|$WHITE"
    "3|系统更新|$WHITE"
    "4|系统清理|$GREEN"
    "………………………|$WHITE" 
    "11|系统工具|$GREEN"
    "12|服务工具|$WHITE"
    "13|常用软件|$WHITE" 
    "14|其他脚本|$BLUE"
    "21|Caddy管理|$WHITE"
    "22|Docker管理|$WHITE"
    "23|Python管理|$YELLOW"
)
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

        21) caddy_management_menu ;;
        22) docker_management_menu ;;
        23) python_management_menu ;;

        xx) sys_reboot ;;
        00) 
            ;;
        0)  
            echo -e "\n$WARN 退出脚本！${RESET}" 
            exit 1 
            ;;
        *)
            _BREAK_INFO=" 请输入正确的数字序号！"
            _IS_BREAK="true"
            ;;
        esac
        break_tacle
    done
}


#=================
# 设置qiq快捷命令 
# set_qiq_alias
# 初始化全局变量
init_global_vars 
# 检测系统IP地址
check_ip_status

# 显示主菜单 
main_menu
