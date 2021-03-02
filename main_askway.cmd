@echo off
cd /d "%~dp0"
echo %time% 启动盘制作工具-main_askway-被调用 >>.\Log.txt
:askwayhome
if exist .\core\ZIPOnce.txt del /f /q .\core\ZIPOnce.txt >nul
cls
title 准备写入
echo 请选择一种写入方式，默认选1即可
echo 选中之后可以查看详情，再确认是否重选
echo.
echo 1.exFAT+FAT16  （推荐）
echo 2.FAT32        （最稳）
ver | find "10." > NUL && echo 3.FAT32+exFAT  （仅Win10）
echo ==========================
echo 0.最大兼容模式
echo.
set /p cho=输入序号并回车：
cls

if %cho%==0 (
    echo %time% 启动盘制作工具-main_askway-用户选择了老机兼容模式 >>.\Log.txt
    cd core
    echo ZIPOnce >ZIPOnce.txt
    cd ..
    goto way2
)
if %cho%==1 goto way1
if %cho%==2 goto way2
ver | find "10." > NUL && if %cho%==3 goto way3

goto askwayhome


:way1
echo %time% 启动盘制作工具-main_askway-用户查看了方案1 >>.\Log.txt
echo.
echo 此方案将一个exFAT分区前置作为文件分区，使用后置的FAT16分区作为EFI分区
echo 缺点是可能会制作失败，兼容性不强（老机型无法启动），但是这仍是我们最推荐的方案
echo.
echo 注：老机型指约2013年之前生产的电脑，此时建议使用方案2，如果您经常装机请使用寄生启动
echo.
echo ========================================
echo 请立即拔出其他USB存储设备避免程序误判！
echo ========================================
echo.
CHOICE /C yn /M "按Y确认或按N重新选择"
if %errorlevel%==2 goto askwayhome
echo %time% 启动盘制作工具-main_askway-用户确认使用方案1 >>.\Log.txt
echo 1 >burn_way.txt
if not exist burn_way.txt echo %time% 启动盘制作工具-main_askway-burn_way.txt创建失败 >>.\Log.txt

echo %time% 启动盘制作工具-main_askway-制作填充ISO >>.\Log.txt
call dash_createstuffiso.cmd
echo %time% 启动盘制作工具-main_askway-开始清空U盘分区 >>.\Log.txt
call main_delpart.cmd
echo %time% 启动盘制作工具-main_askway-开始写入 >>.\Log.txt
echo "%~dp0core\Edgeless_stuff.iso" >burn_target.txt
echo 1 >burn_check.txt
call main_burn.cmd
call main_exit.cmd
exit


:way2
echo %time% 启动盘制作工具-main_askway-用户查看了方案2 >>.\Log.txt
echo.
echo 此方案仅使用一个FAT32分区，兼容性好，制作成功率高
if exist .\core\ZIPOnce.txt echo 并使用USB-ZIP模式增强对老电脑的支持
echo 缺点是不能放置4GB以上文件，如Win10原版镜像
echo.
CHOICE /C yn /M "按Y确认或按N重新选择"
if %errorlevel%==2 goto askwayhome
echo %time% 启动盘制作工具-main_askway-用户确认使用方案2 >>.\Log.txt
echo %time% 启动盘制作工具-main_askway-开始清空U盘分区 >>.\Log.txt
if not exist .\core\ZIPOnce.txt call main_delpart.cmd
echo 2 >burn_way.txt
if not exist burn_way.txt echo %time% 启动盘制作工具-main_askway-burn_way.txt创建失败 >>.\Log.txt

echo %time% 启动盘制作工具-main_askway-开始写入 >>.\Log.txt
echo "%~dp0core\Edgeless.iso" >burn_target.txt
echo 1 >burn_check.txt
call main_burn.cmd
call main_exit.cmd
exit


:way3
echo %time% 启动盘制作工具-main_askway-用户查看了方案3 >>.\Log.txt
echo.
echo 此方案使用一个FAT32分区作为前置分区，exFAT作为后置文件分区，兼容性好
echo 缺点是只能在Win10系统/PE中被完整识别，别的系统大概率只能看到前端的EFI分区
echo.
echo ========================================
echo 请立即拔出其他USB存储设备避免程序误判！
echo ========================================
echo.
CHOICE /C yn /M "按Y确认或按N重新选择"
if %errorlevel%==2 goto askwayhome
echo %time% 启动盘制作工具-main_askway-用户确认使用方案3 >>.\Log.txt
echo %time% 启动盘制作工具-main_askway-开始清空U盘分区 >>.\Log.txt
call main_delpart.cmd
echo 3 >burn_way.txt
if not exist burn_way.txt echo %time% 启动盘制作工具-main_askway-burn_way.txt创建失败 >>.\Log.txt

echo %time% 启动盘制作工具-main_askway-开始写入 >>.\Log.txt
echo "%~dp0core\Edgeless.iso" >burn_target.txt
echo 1 >burn_check.txt

call main_burn.cmd
call main_exit.cmd
exit