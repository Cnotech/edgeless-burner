cd /d "%~dp0"
echo %1 >mtitle.txt
echo %2 >mcontent.txt
echo %3 >mtime.txt
set /p title=<mtitle.txt
set /p content=<mcontent.txt
set /p time=<mtime.txt
if defined time ping 127.0.0.1 -n %time% >nul 2>&1
echo msgbox "%content%",64,"%title%">alert.vbs && start alert.vbs && ping -n 2 127.1>nul && del alert.vbs
del /f /q mtitle.txt
del /f /q mcontent.txt
del /f /q mtime.txt