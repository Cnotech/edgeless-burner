@echo off
cd /d "%~dp0"
echo %time% ��������������-main_delpart-������ >>.\Log.txt
color 3f
title ׼�����U�̷���

:homeProc

::����uid
echo %time% ��������������-main_delpart-��ʼ����uid������ΪPA�������� >>.\Log.txt
echo ���ڲ����豸
if exist .\Usee0.txt del /f /q .\Usee0.txt >nul
set uid=
echo ���������������֣������ĵȴ�...
.\core\PartAssist_old\partassist.exe /list /usb /out:.\Usee0.txt
type Usee0.txt >>.\Log.txt
for %%j in (1 2 3 4 5 6 7 8 9 10 11 12) DO (find  /i "%%j	|" .\Usee0.txt>nul&&SET uid=%%j)
echo %time% ��������������-main_delpart-uid��%uid% >>.\Log.txt
if exist .\Usee0.txt del /f /q .\Usee0.txt >nul
if not defined uid (
    echo %time% ��������������-main_delpart-uidδ���壬�����˳� >>.\Log.txt
    cls
    echo ��������ֵĴ���
    echo PartAssist���ҵķ�����uidδ����
    echo ������Ϊ������û�в���U�̣��ƶ�Ӳ����ʹ��Rufusд�룩
    pause
    call main_exit.cmd
    exit
)

::����uid���ҷ���
echo %time% ��������������-main_delpart-��ʼ����uid���ҷ���������ΪPA�������� >>.\Log.txt
echo ����У�����������%uid%�ķ���״̬
if exist .\Usee.txt del /f /q .\Usee.txt >nul
set PA_Part=
echo ���������������֣������ĵȴ�...
.\core\PartAssist_old\partassist.exe /list:%uid% /out:.\Usee.txt
type Usee.txt >>.\Log.txt
for %%i in (Z Y X W U T S  R Q P O N M L K J I H G F E D C) DO (
		find  /i "%%i:" .\Usee.txt>nul&&SET PA_Part=%%i)
echo %time% ��������������-main_delpart-PA_Part��%PA_Part% >>.\Log.txt
echo ����������%uid%�ϵķ�����ѯ���Ϊ%PA_Part%
if exist .\Usee.txt del /f /q .\Usee.txt >nul

::ȷ�����
cls
title ȷ��U����Ϣ
echo.
echo ȷ�����%PA_Part%�̣�����%uid%���ϵ����з�����
CHOICE /C yn /M "��Yȷ�ϻ�N����ѡ��"
if %errorlevel%==2 (
    call main_home.cmd
    call main_exit.cmd
    exit
)
echo %time% ��������������-main_delpart-�û�ȷ����� >>.\Log.txt
echo ���������������֣������ĵȴ�...
.\core\PartAssist_old\partassist.exe /hd:%uid% /del:all
echo %time% ��������������-main_delpart-���������� >>.\Log.txt

echo %time% ��������������-main_delpart-��ʼ���ķ�����ΪMBR >>.\Log.txt
echo ���������������֣������ĵȴ�...
.\core\PartAssist_old\partassist.exe /init:1
echo %time% ��������������-main_delpart-���ķ�����ΪMBR��� >>.\Log.txt

echo %time% ��������������-main_delpart-��ʼ�ؽ�MBR >>.\Log.txt
echo ���������������֣������ĵȴ�...
.\core\PartAssist_old\partassist.exe /rebuildmbr:%uid%
echo %time% ��������������-main_delpart-�ؽ�MBR��� >>.\Log.txt

echo %time% ��������������-main_delpart-��ʼ�½����� >>.\Log.txt
echo ���������������֣������ĵȴ�...
.\core\PartAssist_old\partassist.exe  /hd:%uid% /cre /pri /size:auto /fs:fat32 /align /letter:auto
echo %time% ��������������-main_delpart-�½�������� >>.\Log.txt
title �����ɣ�׼����ʼ����
echo.
echo ===========================================
echo U�������ɣ����û�д�����ʾ�밴���������
echo ===========================================
echo.
cls
::pause >nul