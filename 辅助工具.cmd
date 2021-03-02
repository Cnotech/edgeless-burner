fltmc >nul 2>&1 || (
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\GetAdmin.vbs"
    echo UAC.ShellExecute "辅助工具.cmd", "", "", "runas", 1 >> "%temp%\GetAdmin.vbs"
    cmd /u /c type "%temp%\GetAdmin.vbs">"%temp%\GetAdminUnicode.vbs"
    cscript //nologo "%temp%\GetAdminUnicode.vbs"
    del /f /q "%temp%\GetAdmin.vbs" >nul 2>&1
    del /f /q "%temp%\GetAdminUnicode.vbs" >nul 2>&1
    exit
)
@echo off

cd /d "%~dp0"
if exist help_clean.cmd start /min /wait help_clean.cmd


color 3f
title Edgeless启动盘制作工具辅助工具
:home
cd /d "%~dp0"
if not exist .\core\ZIP.txt set ZT=1
if exist .\core\ZIP.txt set ZT=0
cls
echo.
echo 1.清空下载缓存
echo 2.清空解压缓存
echo.
echo 3.卸载IDM引擎并禁用IDM引擎
echo 4.恢复IDM引擎云控状态
echo 5.强制启用IDM引擎
echo 6.禁止调用系统已安装的IDM
echo.
if not exist .\core\ZIP.txt echo 7.使用USB ZIP+ V2方案以适应部分U盘和机型启动（当前USB HDD+ V2）
if exist .\core\ZIP.txt echo 7.恢复到默认的USB HDD+ V2方案（当前USB ZIP+ V2）
echo 8.生成ISO到此目录
echo.
set /p a=输入序号并回车：
if %a%==1 goto deleteCash
if %a%==2 (
    cls
    echo.
    echo.
    echo.
    echo        =============================
    echo            您确定要清空解压缓存？
    echo        =============================
    echo.
    echo.
    pause
    cls
    del /f /s /q core\Release
    rd /s /q core\Release
    del /f /s /q .\stu
    rd /s /q .\stu
    echo.
    echo.
    echo        =======================
    echo            解压缓存清理完成
    echo        =======================
    echo.
    echo.
    pause
    goto home
)
if %a%==3 goto uninstallIDM
if %a%==4 (
    del /f /q core\NomoreIDM.txt
    del /f /q core\ForceIDM.txt
    cls
    echo.
    echo IDM引擎已恢复至云控状态，是否使用IDM引擎会受到云端控制
    echo.
    pause
)
if %a%==5 (
    del /f /q core\NomoreIDM.txt
    cd core
    echo ForceIDM>ForceIDM.txt
    cls 
    echo.
    echo IDM引擎将会被强制启用
    echo.
    pause
)
if %a%==6 (
    cd core
    echo NoUserIDM>NoUserIDM.txt
    cls 
    echo.
    echo 程序将不再调用已安装的IDM
    echo.
    pause
)
if %a%==7 (
    cd core
    cls 
    echo.
    if %ZT%==1 echo 已切换至USB ZIP+ V2模式
    if %ZT%==0 echo 已恢复至USB HDD+ V2模式
    if %ZT%==1 echo ZIP>ZIP.txt
    if %ZT%==0 del /f /q ZIP.txt
    echo.
    pause
)
if %a%==8 goto createISO
goto home



:deleteCash
cls
echo.
echo.
echo.
echo        =============================
echo            您确定要清空下载缓存？
echo        =============================
echo.
echo.
pause
cls
del /f /q Edgeless_stuff.iso
del /f /q core\*.iso
del /f /q core\*.txt
del /f /q core\*.td.cfg
del /f /q core\*.td
del /f /q core\*.dat
del /f /q core\stu\*.zip
rd stu
echo.
echo.
echo        =======================
echo            下载缓存清理完成
echo        =======================
echo.
echo.
pause
goto home



:uninstallIDM
cls
echo.
echo.
echo.
echo        =============================
echo            您确定要禁用IDM引擎？
echo        =============================
echo.
echo.
pause
del /f /q core\ForceIDM.txt
cd core
echo NomoreIDM>NomoreIDM.txt
cd IDM
cls
echo 正在运行IDM引擎卸载程序，请稍等...
call Uninstall.bat
cls
echo.
echo   我们已经永久禁用此文件夹内下载组件的IDM引擎的使用
echo    如果您愿意反馈原因，请在内测群艾特群主进行反馈
echo.
pause
goto home

:createISO
cls
if not exist .\core\Edgeless.iso (
    echo.
    echo 您尚未下载ISO，请先运行制作工具完成下载
    echo.
    pause
    goto home
)
if not exist .\core\version_iso.txt (
    echo.
    echo ISO版本校验信息缺失，请先运行制作工具重新下载
    echo.
    pause
    goto home
)
set /p version_iso=<.\core\version_iso.txt
if not defined version_iso (
    echo.
    echo ISO版本校验信息缺失，请先运行制作工具重新下载
    echo.
    pause
    goto home
)
md ISO
copy /y .\core\Edgeless.iso .\ISO\%version_iso:~0,14%%version_iso:~-7,-2%.iso
echo.
echo ===========================================================================
echo ISO已保存至本目录的ISO文件夹内，文件名为%version_iso:~0,14%%version_iso:~-7,-2%.iso
echo ===========================================================================
pause
goto home