title 正在执行烧录程序
cd /d "%~dp0"
echo %time% 启动盘制作工具-main_burn_H-被调用 >>.\Log.txt
set /p target=<burn_target.txt
set /p way=<burn_way.txt
::配置
set MBR_=USB-HDD+ v2
set HidePart_=无
if %way% == 1 set HidePart_=高端隐藏
if exist .\core\ZIP.txt set MBR_=USB-ZIP+ v2
if exist .\core\ZIPOnce.txt set MBR_=USB-ZIP+ v2
if exist .\core\ZIPOnce.txt del /f /q .\core\ZIPOnce.txt

echo %time% 启动盘制作工具-main_burn_H-way=%way%，HidePart_=%HidePart_%，MBR_=%MBR_%，target=%target% >>.\Log.txt

::检索uid
echo %time% 启动盘制作工具-main_burn_H-开始检索uid，下列为PA的输出结果 >>.\Log.txt
echo 正在查找设备
if exist .\Usee0.txt del /f /q .\Usee0.txt >nul
set uid=
echo 正在启动分区助手，请耐心等待...
.\core\PartAssist\partassist.exe /list /usb /out:.\Usee0.txt
type Usee0.txt >>.\Log.txt
for %%j in (1 2 3 4 5 6 7 8 9 10 11 12) DO (find  /i "%%j	|" .\Usee0.txt>nul&&SET uid=%%j)
echo %time% 启动盘制作工具-main_burn_H-uid：%uid% >>.\Log.txt
if exist .\Usee0.txt del /f /q .\Usee0.txt >nul
if not defined uid (
    echo %time% 启动盘制作工具-main_burn_H-uid未定义，程序退出 >>.\Log.txt
    cls
    echo 出现了奇怪的错误！
    echo PartAssist查找的分区：uid未定义
    echo 我们认为您可能没有插入U盘（移动硬盘请使用Rufus写入）
    pause
    call main_exit.cmd
    exit
)

::移动ISO到根目录
if exist %~d0\Edgeless.iso del /f /q %~d0\Edgeless.iso
:resmove_HUI
move /y %target% %~d0\Edgeless.iso
if not exist %~d0\Edgeless.iso (
    echo %time% 启动盘制作工具-main_burn_H-移动Edgeless.iso至根目录失败 >>.\Log.txt
    echo ==================================================================================================
    echo 移动Edgeless.iso到%~d0盘根目录失败，请手动将%target%移动到%~d0盘根目录，然后按任意键
    echo ==================================================================================================
    echo.
    pause
    echo %time% 启动盘制作工具-main_burn_H-用户选择重试 >>.\Log.txt
    if not exist %~d0\Edgeless.iso goto resmove_HUI
)

::隐藏写入
title 正在等待UltraISO完成写入
"%~dp0\core\UltraISO\iso.exe" "iso:%~d0\Edgeless.iso" mode:-S disk:%uid% "MBR:%MBR_%" HidePart:%HidePart_% ShowProgress:-UI
move /y %~d0\Edgeless.iso %target%


echo %time% 启动盘制作工具-main_burn_H-任务完成 >>.\Log.txt