cd /d "%~dp0"
echo %time% ��������������-dash_createstuffiso-������ >>.\Log.txt
::��ȡ�������ISO�İ汾��Ϣ
if not exist .\core\version_stuff.txt goto skipReadVersion
set /p version_stuff=<.\core\version_stuff.txt
set /p version_iso=<.\core\version_iso.txt
echo %time% ��������������-dash_createstuffiso-�Ƚ����汾��version_stuff=%version_stuff%��version_iso=%version_iso% >>.\Log.txt
if not defined version_stuff goto skipReadVersion
if not defined version_iso (
    echo %time% ��������������-dash_createstuffiso-���صĴ���version_isoδ���壬������ǰ�˳� >>.\Log.txt
    echo ===============================================
    echo ����ISO�汾��Ϣȱʧ�����������г����������
    echo ===============================================
    pause
    call main_exit.cmd
    exit
)
if %version_stuff%==%version_iso% (
    echo %time% ��������������-dash_createstuffiso-���汾�������°汾 >>.\Log.txt
    goto endStuff
)
:skipReadVersion
::��������ļ�
if exist .\stu\stuff.zip goto skipCreateStuff
echo %time% ��������������-dash_createstuffiso-��ʼ��������ļ� >>.\Log.txt
fsutil file createnew stuff.zip 209715200
md stu
move /y stuff.zip stu
:skipCreateStuff
if not exist .\stu\stuff.zip (
    echo %time% ��������������-dash_createstuffiso-����ļ�����ʧ�ܣ���ǰ�˳� >>.\Log.txt
    echo ===============================================
    echo ����stuff.zip����ʧ�ܣ��볢��ʹ������д�뷽ʽ
    echo ===============================================
    pause
    call main_exit.cmd
    exit
)
echo %time% ��������������-dash_createstuffiso-����ļ�׼����ɣ���ʼ��ӵ�ISO�� >>.\Log.txt

if exist Edgeless_stuff.iso del /f /q Edgeless_stuff.iso >nul
.\core\ultraiso\ultraiso -input .\core\Edgeless.iso -directory stu -output .\core\Edgeless_stuff.iso
if exist .\core\Edgeless_stuff.iso (
    if exist .\core\version_stuff.txt del /f /q .\core\version_stuff.txt >nul
    copy /y .\core\version_iso.txt .\core\version_stuff.txt
    if not exist .\core\version_stuff.txt echo %time% ��������������-dash_createstuffiso-version_stuff.txt����ʧ�� >>.\Log.txt
    echo %time% ��������������-dash_createstuffiso-ISO������ϣ������˳� >>.\Log.txt
)
if not exist .\core\Edgeless_stuff.iso (
    echo %time% ��������������-dash_createstuffiso-ISO����ʧ�ܣ���ǰ�˳� >>.\Log.txt
    echo ======================================================
    echo ����Edgeless_stuff.iso����ʧ�ܣ��볢��ʹ������д�뷽ʽ
    echo ======================================================
    pause
    call main_exit.cmd
    exit
)

:endStuff
echo %time% ��������������-dash_createstuffiso-������� >>.\Log.txt