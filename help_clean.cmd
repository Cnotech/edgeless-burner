cd /d "%~dp0"
echo %time% 启动盘制作工具-main_exit-被调用 >>.\Log.txt
@del /f /q "%~dp0Upath.txt"
@del /f /q "%~dp0isolist.txt"
@del /f /q "%~dp0burn_check.txt"
@del /f /q "%~dp0burn_target.txt"
@del /f /q "%~dp0update_way.txt"
@del /f /q "%~dp0core\burnername.txt"
@del /f /q "%~dp0core\md5_iso.txt"
@del /f /q "%~dp0core\md5_ol.txt"
@del /f /q "%~dp0core\UseIDM.txt"
@del /f /q "%~dp0GetSpace.txt"
@del /f /q "%~dp0Usee0.txt"
@del /f /q "%~dp0Usee.txt"
@del /f /q "%~dp0FI_Part.txt"
@del /f /q "%~dp0UDiskInfo.txt"
@del /f /q "%~dp0Wimpath.txt"
@del /f /q "%~dp0verify.txt"
@del /f /q "%~dp0burn_way.txt"

rd .\MoreThanOnce

for %%1 in (Z Y X W V T S R Q P O N M L K J I H G F E D C U) do rd %%1

TASKKILL /F /IM MiniThunderPlatform.exe
TASKKILL /F /IM EasyDown.exe
taskkill /f /im IDM* >NUL 2>NUL
taskkill /f /im IEMon* >NUL 2>NUL

if "%~n0"=="help_clean" goto skipUnHide

attrib -s -a -h -r dash_checkiso.cmd
attrib -s -a -h -r dash_checkrelease.cmd
attrib -s -a -h -r dash_checkusb.cmd
attrib -s -a -h -r dash_createstuffiso.cmd
attrib -s -a -h -r help_uie.cmd
attrib -s -a -h -r main_askway.cmd
attrib -s -a -h -r main_burn.cmd
attrib -s -a -h -r main_delpart.cmd
attrib -s -a -h -r main_exit.cmd
attrib -s -a -h -r main_hide.cmd
attrib -s -a -h -r main_home.cmd
attrib -s -a -h -r main_update.cmd
attrib -s -a -h -r main_writeproc.cmd
attrib -s -a -h -r net_checknet.cmd
attrib -s -a -h -r net_downloadiso.cmd
attrib -s -a -h -r net_getversion.cmd


:skipUnHide






if exist X:\ type .\Log.txt >>X:\Users\Log.txt

echo %time% 启动盘制作工具-main_exit-程序退出 >>.\Log.txt
exit