@echo off
cd /d "%~dp0"
echo %time% ��������������-main_writeproc-������ >>.\Log.txt
color 3f
title ���ڴ���д����ɺ��������

:homeProc

::����uid
echo %time% ��������������-main_writeproc-��ʼ����uid������ΪPA�������� >>.\Log.txt
echo ���ڲ����豸
if exist .\Usee0.txt del /f /q .\Usee0.txt >nul
set uid=
echo ���������������֣������ĵȴ�...
.\core\PartAssist\partassist.exe /list /usb /out:.\Usee0.txt
type Usee0.txt >>.\Log.txt
for %%j in (1 2 3 4 5 6 7 8 9 10 11 12) DO (find  /i "%%j	|" .\Usee0.txt>nul&&SET uid=%%j)
echo %time% ��������������-main_writeproc-uid��%uid% >>.\Log.txt
if exist .\Usee0.txt del /f /q .\Usee0.txt >nul
if not defined uid (
    echo %time% ��������������-main_writeproc-uidδ���壬�����˳� >>.\Log.txt
    cls
    echo ��������ֵĴ��󣡷���ʱ���ύLog.txt
    echo PartAssist���ҵķ�����uidδ����
    echo �����ⲻ������U�̣��볢�����°β��ͼ���ʽ��
    pause
    call main_exit.cmd
    exit
)

::����uid���ҷ���
:ctnwriteproc
echo %time% ��������������-main_writeproc-��ʼ����uid���ҷ���������ΪPA�������� >>.\Log.txt
echo ����У�����������%uid%�ķ���״̬
if exist .\Usee.txt del /f /q .\Usee.txt >nul
set PA_Part=
echo ���������������֣������ĵȴ�...
.\core\PartAssist\partassist.exe /list:%uid% /out:.\Usee.txt
type Usee.txt >>.\Log.txt
for %%i in (Z Y X W V U T S R Q P O N M L K J I H G F E D C) DO (find  /i "0	| %%i:" .\Usee.txt>nul&&SET PA_Part=%%i)
echo %time% ��������������-main_writeproc-PA_Part��%PA_Part% >>.\Log.txt
if exist .\Usee.txt del /f /q .\Usee.txt >nul
if not defined PA_Part (
    if not defined failtime goto reGivePart
    cls
    title ��ȫֹͣ
    echo �����޷�Ϊ��һ���������̷����˴�Ϊ��ȫֹͣ������U��δ�ܵ������
    echo ��ʹ��DiskGeniusΪU�̵ĵ�һ����ָ���µ��̷�Ȼ�����������
    pause
    goto ctnwriteproc
)
if not exist %PA_Part%:\ (
    if not defined failtime goto reGivePart
    cls
    title ��ȫֹͣ
    echo �����޷�Ϊ��һ���������̷����˴�Ϊ��ȫֹͣ������U��δ�ܵ������
    echo ��ʹ��DiskGeniusΪU�̵ĵ�һ����ָ���µ��̷�Ȼ�����������
    pause
    goto ctnwriteproc
)
echo ����������%uid%�ϵķ�����ѯ���Ϊ%PA_Part%

::ȷ���ǵ�һ��������EFI
if exist %PA_Part%:\Edgeless\version.txt (
    echo %time% ��������������-main_writeproc-PA_Part��ʵ��EFI�����������쳣�˳� >>.\Log.txt
    cls
    title ��ȫֹͣ
    echo �����ļ�������EFI�����ص����˴�Ϊ��ȫֹͣ������U��δ�ܵ������
    echo Ŀǰ�����������ѻ���������ֻ��һЩ�ƺ���û�ܱ��Զ���ɣ������ڲ�ȺѰ������
    pause
    call main_exit.cmd
    exit
)

::ͨ�����飬ȷ��û�������
echo %time% ��������������-main_writeproc-%PA_Part%�̷�ͨ��Edgeless������һ����У�� >>.\Log.txt
echo %PA_Part%�̷�ͨ��Edgeless������һ����У��

::���EFI�����Ƿ��Ѿ�ֱ�ӱ�¶
if exist EFIpath.txt del /f /q EFIpath.txt >nul
for %%1 in (Z Y X W V T S R Q P O N M L K J I H G F E D C U) do if exist %%1:\sources\boot.wim echo %%1>EFIpath.txt
set /p EFI_Part=<EFIpath.txt
echo %time% ��������������-main_writeproc-���EFI�����Ƿ��Ѿ�ֱ�ӱ�¶��EFI_Part��%EFI_Part% >>.\Log.txt
if exist EFIpath.txt del /f /q EFIpath.txt >nul

::ɾ��stuff.zip��Edgeless�ļ���
echo %time% ��������������-main_writeproc-��ʼɾ��stuff.zip��Edgeless�ļ��� >>.\Log.txt
if defined EFI_Part (
    del /f /q %EFI_Part%:\stuff.zip
    if exist %EFI_Part%:\stuff.zip echo %time% ��������������-main_writeproc-stuff.zipɾ��ʧ�� >>.\Log.txt
    del /f /s /q %EFI_Part%:\Edgeless
    rd /s /q %EFI_Part%:\Edgeless
    if exist %EFI_Part%:\Edgeless echo %time% ��������������-main_writeproc-Edgeless�ļ���ɾ��ʧ�� >>.\Log.txt
)
if not defined EFI_Part goto delHideFile
:ctnHideFile
echo %time% ��������������-main_writeproc-ɾ��stuff.zip��Edgeless�ļ������ >>.\Log.txt

::�ļ�������ʽ��ΪexFAT
echo %time% ��������������-main_writeproc-��ʼ�ļ�������ʽ��ΪexFAT >>.\Log.txt
echo ��ʼ�ļ�������ʽ��ΪexFAT
format %PA_Part%: /FS:exFAT /V:�ļ��� /Q /Y
echo %time% ��������������-main_writeproc-��ʽ��ΪexFAT��� >>.\Log.txt

::����Edgeless�ļ���
echo %time% ��������������-main_writeproc-��ʼ��ѹISO >>.\Log.txt
call dash_checkrelease.cmd
title ���ڴ���д����ɺ��������
echo %time% ��������������-main_writeproc-��ʼ����Edgeless�ļ��� >>.\Log.txt
md %PA_Part%:\Edgeless
xcopy /s /r /y core\Release\Edgeless %PA_Part%:\Edgeless\
echo %time% ��������������-main_writeproc-����Edgeless�ļ������ >>.\Log.txt
goto endWriteProc


:reGivePart
set failtime=1
echo %time% ��������������-main_writeproc-U�̵ĵ�һ����δ�����̷���׼������DiskPart����������DiskPart�ű� >>.\Log.txt
echo select disk %uid% >DPS.txt
echo select partition 1 >>DPS.txt
if exist emptypart.txt del /f /q emptypart.txt >nul
for %%k in (Z Y X W V U T S R Q P O N M L K J I H G F E D C) do (
   if not exist %%k:\ (
        echo %%k >emptypart.txt
        )
)
set /p ep=<emptypart.txt
if exist emptypart.txt del /f /q emptypart.txt >nul
echo %time% ��������������-main_writeproc-׼��������%ep% >>.\Log.txt
if not defined ep (
    echo %time% ��������������-main_writeproc-emptypartδ���壬�����˳� >>.\Log.txt
    cls
    echo ��������ֵĴ��󣡷���ʱ���ύLog.txt
    echo emptypartδ����
    echo ���ĵ�����û��ʣ��Ŀɷ�����̷��ˣ�
    pause
    call main_exit.cmd
    exit
)
echo assign letter=%ep% >>DPS.txt
echo exit >>DPS.txt

echo %time% ��������������-main_writeproc-DiskPart�ű�������ϣ�����Ϊ�� >>.\Log.txt
type DPS.txt >>.\Log.txt
echo %time% ��������������-main_writeproc-ִ��DiskPart�ű� >>.\Log.txt
diskpart /s DPS.txt
if exist DPS.txt del /f /q DPS.txt >nul
echo %time% ��������������-main_writeproc-DiskPart�ű�ִ����� >>.\Log.txt
goto ctnwriteproc

:delHideFile
cd "%~dp0core\PartAssist_old"
partassist.exe /hd:%uid% /whide:1 /delfiles /dest:stuff.zip
partassist.exe /hd:%uid% /whide:1 /delfiles /dest:Edgeless
cd /d "%~dp0"
goto ctnHideFile


:endWriteProc
echo %time% ��������������-main_writeproc-������ɣ�У��Edgeless�ļ����Ƿ���� >>.\Log.txt
::Edgeless�ļ��п�����У��
if exist Upath.txt del /f /q Upath.txt >nul
for %%1 in (Z Y X W V T S R Q P O N M L K J I H G F E D C U) do if exist %%1:\Edgeless\version.txt echo %%1>Upath.txt
set /p u=<Upath.txt
echo %time% ��������������-main_writeproc-ʹ��%u%��ΪEdgeless�̷� >>.\Log.txt
if exist Upath.txt del /f /q Upath.txt >nul

if defined u (
echo %time% ��������������-main_writeproc-д��ɹ� >>.\Log.txt
explorer %u%:\Edgeless\Resource
attrib +s +a +h +r %u%:\boot
attrib +s +a +h +r %u%:\efi
attrib +s +a +h +r %u%:\bootmgr
attrib +s +a +h +r %u%:\bootmgr.efi
ping 127.0.0.1 -n 2 >nul 2>&1
call .\core\dynamic_msgbox.cmd Edgeless�������������� Edgeless�����������ɹ��������صõ��Ĳ�����ƶ�����Ŀ¼������ɰ�װ
call "%~dp0main_exit.cmd"
exit
)
else 
(
echo %time% ��������������-main_writeproc-д��ʧ�� >>.\Log.txt
title ���ܳ�����һЩ����
color 4f
cls
echo.
echo.
echo ���棺û�з���д����ɵ������̣� ���������������г����˹��ϣ�
echo �������U�����Ѿ������������ļ�������Դ���Ϣ
echo ��������ʱ�뽫��Ŀ¼�µ�Log.txtһ���ύ
pause >nul
color 3f
cls
call main_home.cmd
)