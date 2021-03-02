@echo off
cd /d "%~dp0core"
echo %time% 启动盘制作工具-net_api-被调用 >>.\Log.txt
:: 1.token 2.文件名 3.引擎：a,e,i
if "%3"=="a" goto Aria
if "%3"=="e" goto EasyDown
if "%3"=="i" goto IDM

:Aria
echo 正在调用Aria执行连接任务
if "%2"=="Edgeless.iso" (
    echo 连接线程数：16
)
aria2c.exe -x16 -c -o %2 http://s.edgeless.top/?token=%1
goto endAPI

:EasyDown
if not exist EasyDown\EasyDown.exe goto Aria
echo 正在调用EasyDown执行连接任务
EasyDown\EasyDown.exe -Down("http://s.edgeless.top/?token=%1","%2","%~dp0core")
goto endAPI

:IDM
echo 正在调用IDM执行连接任务
if not defined IDMPath goto Aria
if not exist "%IDMPath%" goto Aria
start /d "%IDMPath:~0,-10%" /wait IDMan.exe /d http://s.edgeless.top/?token=%1 /p %~dp0core /f %2 /q /n
goto endAPI


:endAPI
cd /d "%~dp0"
echo %time% 启动盘制作工具-net_api-结束任务 >>.\Log.txt