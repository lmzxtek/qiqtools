
echoT(){ FLAG=$1 && shift && echo -e "\033[39m$FLAG\033[39m$@";}
echoY(){ FLAG=$1 && shift && echo -e "\033[38;5;148m$FLAG\033[39m$@";}
echoG(){ FLAG=$1 && shift && echo -e "\033[38;5;71m$FLAG\033[39m$@"; }
echoB(){ FLAG=$1 && shift && echo -e "\033[38;1;34m$FLAG\033[39m$@" ;}
echoR(){ FLAG=$1 && shift && echo -e "\033[38;5;203m$FLAG\033[39m$@"; }

VLATEST=$(echoY "NEW")

clear
echoT " >>> 脚本更新日志 <<<"
echoT "--------------------------------"
echoT " >>> 2024-3-12   v0.4.4"
echoT " - 1.完成了站点部署菜单的各项功能。"
echoT " - 2.添加了脚本更新日志的显示."
echoT "--------------------------------"
echoR " >>> 2024-3-12   v0.4.5" " $VLATEST"
echoY " - 1.使用wget显示脚本日志。"
echoY " - 2.用不同颜色显示日志，突出最新版本。"
echoT "--------------------------------"