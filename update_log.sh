
echoT(){ FLAG=$1 && shift && echo -e "\033[39m$FLAG\033[39m$@";}
echoY(){ FLAG=$1 && shift && echo -e "\033[38;5;148m$FLAG\033[39m$@";}
echoG(){ FLAG=$1 && shift && echo -e "\033[38;5;71m$FLAG\033[39m$@"; }
echoB(){ FLAG=$1 && shift && echo -e "\033[38;1;34m$FLAG\033[39m$@" ;}
echoR(){ FLAG=$1 && shift && echo -e "\033[38;5;203m$FLAG\033[39m$@"; }

FCLS='\033[34m'        # 前景色：蓝色
FTCZ='\033[0m'         # 字体：重置所有
FTSS='\033[5m'         # 字体：闪烁

VLATEST="${FCLS}${FTSS}NEW${FTCZ}" # 蓝色闪烁字体

clear
echoR " >>> " $(echoY "脚本更新日志") $(echoR "<<<") 
echoB " - " $(echoT "https://gitlab.com/lmzxtek/qiqtools/-/raw/main/qiqtools.sh")
echoT "--------------------------------"
echoT " >>> 2024-3-12   v0.4.4" ""
echoT "   1.完成了站点部署菜单的各项功能。"
echoT "   2.添加了脚本更新日志的显示."
echoT "   3.修正了域名绑定时，重新加载出错的问题."
echoT "--------------------------------"
echoT " >>> 2024-3-12   v0.4.5" " "
echoT "   1.使用wget显示脚本日志。"
echoT "   2.用不同颜色显示日志，突出最新版本。"
echoT "--------------------------------"
echoT " >>> 2024-3-12   v0.4.6" " "
echoT "   1.添加容器管理菜单。"
echoT "   2.容器管理菜单检测Docker是否安装。"
echoT "--------------------------------"
echoT " >>> 2024-3-13   v0.4.7" " "
echoT "   1.添加容器GeminiProChat。"
echoT "   2.添加容器AKTools金融数据接口。"
echoT "   3.把src目录下面的sh脚本文件移动到了子目录。"
echoT "--------------------------------"
echoT " >>> 2024-3-14   v0.4.8" " "
echoT "   1.添加颜色显示说明。"
echoT "   2.添加前景色、背景色、字体全局变量。"
echoT "   3.将更新日志中的NEW字体更改为蓝色闪烁。"
echoT "   4.DD系统选择时显示默认的登录密码。"
echoT "--------------------------------"
echoR " >>> 2024-3-17   v0.4.9" " $VLATEST"
echoY "   1.添加Dash.部署。"
echoY "   2.修改DD菜单实现方式。"
echoT "--------------------------------"