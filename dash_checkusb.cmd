title 正在比对U盘信息
echo %time% 启动盘制作工具-dash_checkusb-被调用 >>.\Log.txt
:checkusb_home
set /p u=<"%~dp0Upath.txt"
set /p version_ol=<"%~dp0core\version_ol.txt"
set /p version_usb=<"%u%:\Edgeless\version.txt"
echo %time% 启动盘制作工具-dash_checkusb-读取信息，Upath：%u%，version_ol：%version_ol%，version_usb：%version_usb% >>.\Log.txt
if %version_ol%==%version_usb% goto newest
echo %time% 启动盘制作工具-dash_checkusb-U盘的Edgeless可更新 >>.\Log.txt
title 有可用的Edgeless更新
cls
echo.
echo      发现%u%盘可更新Edgeless
echo.
echo   当前版本：%version_usb%
echo   最新版本：%version_ol%
echo =========================================
echo.
echo.
echo   【1】免格更新（推荐）    【2】全新制作
echo.
echo.
echo.
set /p cho=请输入序号并回车：
if %cho%==2 (
    echo %time% 启动盘制作工具-dash_checkusb-用户选择全新制作 >>.\Log.txt
    call dash_checkiso.cmd
    call main_askway.cmd
    call main_exit.cmd
    exit
)
if %cho%==1 (
    echo %time% 启动盘制作工具-dash_checkusb-用户选择免格更新，更新方式：%version_ol:~-1,1% >>.\Log.txt
    call dash_checkiso.cmd
    echo %version_ol:~-1,1% >update_way.txt
    call main_update.cmd
    call main_exit.cmd
    exit
)
goto checkusb_home




:newest
echo %time% 启动盘制作工具-dash_checkusb-U盘的Edgeless已是最新版本 >>.\Log.txt
title 已是最新版本
cls
echo.
echo.
echo.
echo  恭喜，%u%盘的Edgeless已是最新版本！
echo =========================================
echo 版本信息：
echo 完整版本号：%version_ol%
echo 系统名称：%version_ol:~0,8%
echo 渠道类型：%version_ol:~9,4%
echo 发行版本：%version_ol:~14,5%
echo 版本编号：%version_ol:~20,5%
echo =========================================
echo.
echo.
echo.
echo    如果您的启动盘遇到了故障，请尝试修复
echo.
echo  【1】尝试修复（推荐）       【2】全新制作
echo.
echo.
set /p cho=请输入序号并回车：
if %cho%==2 (
    echo %time% 启动盘制作工具-dash_checkusb-用户选择全新制作 >>.\Log.txt
    call dash_checkiso.cmd
    call main_askway.cmd
    call main_exit.cmd
    exit
)
if %cho%==1 (
    echo %time% 启动盘制作工具-dash_checkusb-用户选择尝试修复 >>.\Log.txt
    call dash_checkiso.cmd
    echo 4 >update_way.txt
    call main_update.cmd
    call main_exit.cmd
    exit
)
goto newest