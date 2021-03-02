title 正在检查网络连接情况
cd /d "%~dp0"
echo %time% 启动盘制作工具-net_checknet-被调用 >>.\Log.txt
ping cloud.tencent.com
if %errorlevel%==1 goto nonet
echo %time% 启动盘制作工具-net_checknet-Edgeless服务器无响应 >>.\Log.txt
title Edgeless服务器无响应
cls
echo.
echo.
echo.
echo                 下载失败，Edgeless服务器无响应
echo                   请联系作者解决此问题或稍后再试
echo.
echo        如果希望使用离线模式制作启动盘，请参考“帮助文件.txt”
echo.
echo.
if not exist core\version_iso.txt (
    echo %time% 启动盘制作工具-net_checknet-不存在version_iso.txt，程序临近退出 >>.\Log.txt
    pause
    call main_exit.cmd
    exit
)
goto offline


:nonet
title 无法连接至互联网
echo %time% 启动盘制作工具-net_checknet-无法连接至互联网 >>.\Log.txt
cls
echo.
echo.
echo.
echo               下载失败，当前系统未接入互联网
echo.
echo     如果希望使用离线模式制作启动盘，请参考“帮助文件.txt”
echo.
echo.
echo.
if not exist core\version_iso.txt (
    echo %time% 启动盘制作工具-net_checknet-不存在version_iso.txt，程序临近退出 >>.\Log.txt
    pause
    call main_exit.cmd
    exit
)



:offline
echo %time% 启动盘制作工具-net_checknet-存在version_iso.txt，提示使用 >>.\Log.txt
set /p version_iso=<core\version_iso.txt
if not defined version_iso (
    echo %time% 启动盘制作工具-net_checknet-version_iso未定义，程序临近退出 >>.\Log.txt
    del /f /q .\core\Edgeless.iso >nul
    pause
    call main_exit.cmd
    exit
)
echo       ===============================
echo       检测到离线镜像文件，是否使用？
echo       镜像版本：%version_iso%
echo       ===============================
echo.
echo.
echo          【1】是         【2】否
set /p cho=请输入序号并回车：
if %cho%==2 (
    echo %time% 启动盘制作工具-net_checknet-用户取消使用离线镜像 >>.\Log.txt
    call main_exit.cmd
    exit
)
echo %time% 启动盘制作工具-net_checknet-用户选择使用离线镜像 >>.\Log.txt
call main_askway.cmd
call main_exit.cmd
exit