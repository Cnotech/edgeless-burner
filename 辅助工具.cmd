fltmc >nul 2>&1 || (
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\GetAdmin.vbs"
    echo UAC.ShellExecute "��������.cmd", "", "", "runas", 1 >> "%temp%\GetAdmin.vbs"
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
title Edgeless�������������߸�������
:home
cd /d "%~dp0"
if not exist .\core\ZIP.txt set ZT=1
if exist .\core\ZIP.txt set ZT=0
cls
echo.
echo 1.������ػ���
echo 2.��ս�ѹ����
echo.
echo 3.ж��IDM���沢����IDM����
echo 4.�ָ�IDM�����ƿ�״̬
echo 5.ǿ������IDM����
echo 6.��ֹ����ϵͳ�Ѱ�װ��IDM
echo.
if not exist .\core\ZIP.txt echo 7.ʹ��USB ZIP+ V2��������Ӧ����U�̺ͻ�����������ǰUSB HDD+ V2��
if exist .\core\ZIP.txt echo 7.�ָ���Ĭ�ϵ�USB HDD+ V2��������ǰUSB ZIP+ V2��
echo 8.����ISO����Ŀ¼
echo.
set /p a=������Ų��س���
if %a%==1 goto deleteCash
if %a%==2 (
    cls
    echo.
    echo.
    echo.
    echo        =============================
    echo            ��ȷ��Ҫ��ս�ѹ���棿
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
    echo            ��ѹ�����������
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
    echo IDM�����ѻָ����ƿ�״̬���Ƿ�ʹ��IDM������ܵ��ƶ˿���
    echo.
    pause
)
if %a%==5 (
    del /f /q core\NomoreIDM.txt
    cd core
    echo ForceIDM>ForceIDM.txt
    cls 
    echo.
    echo IDM���潫�ᱻǿ������
    echo.
    pause
)
if %a%==6 (
    cd core
    echo NoUserIDM>NoUserIDM.txt
    cls 
    echo.
    echo ���򽫲��ٵ����Ѱ�װ��IDM
    echo.
    pause
)
if %a%==7 (
    cd core
    cls 
    echo.
    if %ZT%==1 echo ���л���USB ZIP+ V2ģʽ
    if %ZT%==0 echo �ѻָ���USB HDD+ V2ģʽ
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
echo            ��ȷ��Ҫ������ػ��棿
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
echo            ���ػ����������
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
echo            ��ȷ��Ҫ����IDM���棿
echo        =============================
echo.
echo.
pause
del /f /q core\ForceIDM.txt
cd core
echo NomoreIDM>NomoreIDM.txt
cd IDM
cls
echo ��������IDM����ж�س������Ե�...
call Uninstall.bat
cls
echo.
echo   �����Ѿ����ý��ô��ļ��������������IDM�����ʹ��
echo    �����Ը�ⷴ��ԭ�������ڲ�Ⱥ����Ⱥ�����з���
echo.
pause
goto home

:createISO
cls
if not exist .\core\Edgeless.iso (
    echo.
    echo ����δ����ISO�������������������������
    echo.
    pause
    goto home
)
if not exist .\core\version_iso.txt (
    echo.
    echo ISO�汾У����Ϣȱʧ��������������������������
    echo.
    pause
    goto home
)
set /p version_iso=<.\core\version_iso.txt
if not defined version_iso (
    echo.
    echo ISO�汾У����Ϣȱʧ��������������������������
    echo.
    pause
    goto home
)
md ISO
copy /y .\core\Edgeless.iso .\ISO\%version_iso:~0,14%%version_iso:~-7,-2%.iso
echo.
echo ===========================================================================
echo ISO�ѱ�������Ŀ¼��ISO�ļ����ڣ��ļ���Ϊ%version_iso:~0,14%%version_iso:~-7,-2%.iso
echo ===========================================================================
pause
goto home