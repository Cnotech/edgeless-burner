@echo off
cd /d "%~dp0core"
echo %time% ��������������-net_api-������ >>.\Log.txt
:: 1.token 2.�ļ��� 3.���棺a,e,i
if "%3"=="a" goto Aria
if "%3"=="e" goto EasyDown
if "%3"=="i" goto IDM

:Aria
echo ���ڵ���Ariaִ����������
if "%2"=="Edgeless.iso" (
    echo �����߳�����16
)
aria2c.exe -x16 -c -o %2 http://s.edgeless.top/?token=%1
goto endAPI

:EasyDown
if not exist EasyDown\EasyDown.exe goto Aria
echo ���ڵ���EasyDownִ����������
EasyDown\EasyDown.exe -Down("http://s.edgeless.top/?token=%1","%2","%~dp0core")
goto endAPI

:IDM
echo ���ڵ���IDMִ����������
if not defined IDMPath goto Aria
if not exist "%IDMPath%" goto Aria
start /d "%IDMPath:~0,-10%" /wait IDMan.exe /d http://s.edgeless.top/?token=%1 /p %~dp0core /f %2 /q /n
goto endAPI


:endAPI
cd /d "%~dp0"
echo %time% ��������������-net_api-�������� >>.\Log.txt