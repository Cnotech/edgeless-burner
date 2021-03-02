fltmc >nul 2>&1 || (
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\GetAdmin.vbs"
    echo UAC.ShellExecute "ÇåÀícmd²ÐÁô.cmd", "", "", "runas", 1 >> "%temp%\GetAdmin.vbs"
    cmd /u /c type "%temp%\GetAdmin.vbs">"%temp%\GetAdminUnicode.vbs"
    cscript //nologo "%temp%\GetAdminUnicode.vbs"
    del /f /q "%temp%\GetAdmin.vbs" >nul 2>&1
    del /f /q "%temp%\GetAdminUnicode.vbs" >nul 2>&1
    exit
)
cd /d "%~dp0"
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

del /f /q dash_checkiso.cmd
del /f /q dash_checkrelease.cmd
del /f /q dash_checkusb.cmd
del /f /q dash_createstuffiso.cmd
del /f /q help_uie.cmd
del /f /q main_askway.cmd
del /f /q main_burn.cmd
del /f /q main_delpart.cmd
del /f /q main_exit.cmd
del /f /q main_hide.cmd
del /f /q main_home.cmd
del /f /q main_update.cmd
del /f /q main_writeproc.cmd
del /f /q net_checknet.cmd
del /f /q net_downloadiso.cmd
del /f /q net_getversion.cmd
exit