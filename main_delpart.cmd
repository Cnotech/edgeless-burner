@echo off
cd /d "%~dp0"
echo %time% 启动盘制作工具-main_delpart-被调用 >>.\Log.txt
color 3f
title 准备清空U盘分区

:homeProc

::检索uid
echo %time% 启动盘制作工具-main_delpart-开始检索uid，下列为PA的输出结果 >>.\Log.txt
echo 正在查找设备
if exist .\Usee0.txt del /f /q .\Usee0.txt >nul
set uid=
echo 正在启动分区助手，请耐心等待...
.\core\PartAssist_old\partassist.exe /list /usb /out:.\Usee0.txt
type Usee0.txt >>.\Log.txt
for %%j in (1 2 3 4 5 6 7 8 9 10 11 12) DO (find  /i "%%j	|" .\Usee0.txt>nul&&SET uid=%%j)
echo %time% 启动盘制作工具-main_delpart-uid：%uid% >>.\Log.txt
if exist .\Usee0.txt del /f /q .\Usee0.txt >nul
if not defined uid (
    echo %time% 启动盘制作工具-main_delpart-uid未定义，程序退出 >>.\Log.txt
    cls
    echo 出现了奇怪的错误！
    echo PartAssist查找的分区：uid未定义
    echo 我们认为您可能没有插入U盘（移动硬盘请使用Rufus写入）
    pause
    call main_exit.cmd
    exit
)

::根据uid查找分区
echo %time% 启动盘制作工具-main_delpart-开始根据uid查找分区，下列为PA的输出结果 >>.\Log.txt
echo 正在校验磁盘驱动器%uid%的分区状态
if exist .\Usee.txt del /f /q .\Usee.txt >nul
set PA_Part=
echo 正在启动分区助手，请耐心等待...
.\core\PartAssist_old\partassist.exe /list:%uid% /out:.\Usee.txt
type Usee.txt >>.\Log.txt
for %%i in (Z Y X W U T S  R Q P O N M L K J I H G F E D C) DO (
		find  /i "%%i:" .\Usee.txt>nul&&SET PA_Part=%%i)
echo %time% 启动盘制作工具-main_delpart-PA_Part：%PA_Part% >>.\Log.txt
echo 磁盘驱动器%uid%上的分区查询结果为%PA_Part%
if exist .\Usee.txt del /f /q .\Usee.txt >nul

::确认清空
cls
title 确认U盘信息
echo.
echo 确认清空%PA_Part%盘（磁盘%uid%）上的所有分区吗
CHOICE /C yn /M "按Y确认或按N重新选择"
if %errorlevel%==2 (
    call main_home.cmd
    call main_exit.cmd
    exit
)
echo %time% 启动盘制作工具-main_delpart-用户确认清空 >>.\Log.txt
echo 正在启动分区助手，请耐心等待...
.\core\PartAssist_old\partassist.exe /hd:%uid% /del:all
echo %time% 启动盘制作工具-main_delpart-分区清空完成 >>.\Log.txt

echo %time% 启动盘制作工具-main_delpart-开始更改分区表为MBR >>.\Log.txt
echo 正在启动分区助手，请耐心等待...
.\core\PartAssist_old\partassist.exe /init:1
echo %time% 启动盘制作工具-main_delpart-更改分区表为MBR完成 >>.\Log.txt

echo %time% 启动盘制作工具-main_delpart-开始重建MBR >>.\Log.txt
echo 正在启动分区助手，请耐心等待...
.\core\PartAssist_old\partassist.exe /rebuildmbr:%uid%
echo %time% 启动盘制作工具-main_delpart-重建MBR完成 >>.\Log.txt

echo %time% 启动盘制作工具-main_delpart-开始新建分区 >>.\Log.txt
echo 正在启动分区助手，请耐心等待...
.\core\PartAssist_old\partassist.exe  /hd:%uid% /cre /pri /size:auto /fs:fat32 /align /letter:auto
echo %time% 启动盘制作工具-main_delpart-新建分区完成 >>.\Log.txt
title 清空完成，准备开始制作
echo.
echo ===========================================
echo U盘清空完成，如果没有错误提示请按任意键继续
echo ===========================================
echo.
cls
::pause >nul