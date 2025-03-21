
echoT(){ FLAG=$1 && shift && echo -e "\033[39m$FLAG\033[39m$@";}
echoY(){ FLAG=$1 && shift && echo -e "\033[38;5;148m$FLAG\033[39m$@";}
echoG(){ FLAG=$1 && shift && echo -e "\033[38;5;71m$FLAG\033[39m$@"; }
echoB(){ FLAG=$1 && shift && echo -e "\033[38;1;34m$FLAG\033[39m$@" ;}
echoR(){ FLAG=$1 && shift && echo -e "\033[38;5;203m$FLAG\033[39m$@"; }

FCLS='\033[34m'        # 前景色：蓝色
FTCZ='\033[0m'         # 字体：重置所有
FTSS='\033[5m'         # 字体：闪烁

VLATEST="${FCLS}${FTSS}NEW${FTCZ}" # 蓝色闪烁字体
url_redir='https://sub.zwdk.org/qiq'
url_script='https://raw.githubusercontent.com/lmzxtek/qiqtools/refs/heads/main/src/qiq.sh'
url_update='https://raw.githubusercontent.com/lmzxtek/qiqtools/refs/heads/main/src/log.sh'

clear
echoR " >>> " $(echoY "脚本更新日志") $(echoR "<<<") 
echoB " - " $(echoT $url_update)
echoT "--------------------------------"
echoT " -=> 2025-03-21   v0.7.2" " "
echoT "   1.日志文件接之前的版本"
echoT "   2.测试DD脚本项"
echoT "   3.修正测试项链接"
echoT "   4.完善Docker部署"
echoT "--------------------------------"
echoR " -=> 2025-03-21   v0.7.3" " $VLATEST"
echoY "   1.美化单栏菜单显示效果：左侧增加自定义Emoji表情"
echoY "   2.美化系统信息显示效果"
echoT "--------------------------------"
echoR "" $(echoY "url") $(echoR ": $url_redir") 
echoR "" $(echoY "url") $(echoR ": $url_script") 

