title ����ִ����¼����
cd /d "%~dp0"
echo %time% ��������������-main_burn-������ >>.\Log.txt
set /p target=<burn_target.txt
set /p check=<burn_check.txt
set /p way=<burn_way.txt
if not defined check set check=0
if not defined way set way=0
echo %time% ��������������-main_burn-��ȡ��Ϣ��target��%target%��check��%check%��way��%way% >>.\Log.txt
if not defined target (
echo %time% ��������������-main_burn-����targetδ���� >>.\Log.txt
    cls
    echo ����targetδ����
    pause
    call main_exit.cmd
    exit
)
::����Ƿ���Ҫʹ�þ�Ĭд��
title ���ڲ�ѯ��Ĭд�뷽��
if exist core\NoHUI.txt goto skipAskHUI
if %check% == 0 goto skipAskHUI
del /f /q core\UseHUI.txt
call net_api HUI UseHUI.txt a
if not exist core\UseHUI.txt goto skipAskHUI
set /p HUI=<core\UseHUI.txt
del /f /q core\UseHUI.txt
if "%HUI%" neq "1" goto skipAskHUI
call main_burn_H
goto finishUltraIso

:skipAskHUI
echo %time% ��������������-main_burn-��ʼ��UltraISO����ʾд����ʾ >>.\Log.txt
if not exist $oset.reg reg export "HKCU\Software\EasyBoot Systems\UltraISO\5.0" $oset.reg
REG DELETE HKCU\Software\Microsoft\Software\EasyBoot Systems\UltraISO\5.0\ /f >NUL
reg add "HKCU\Software\EasyBoot Systems\UltraISO\5.0" /v "Language" /t REG_SZ /d "2052" /f
reg add "HKCU\Software\EasyBoot Systems\UltraISO\5.0" /v "SoundEffect" /t REG_SZ /d "0" /f
reg add "HKCU\Software\EasyBoot Systems\UltraISO\5.0" /v "USBBootPart" /t REG_SZ /d "0" /f
if %way%==1 reg add "HKCU\Software\EasyBoot Systems\UltraISO\5.0" /v "USBBootPart" /t REG_SZ /d "2" /f
reg add "HKCU\Software\EasyBoot Systems\UltraISO\5.0" /v "UPlusV2Level" /t REG_SZ /d "3" /f
reg add "HKCU\Software\EasyBoot Systems\UltraISO\5.0" /v "USBMode" /t REG_SZ /d "4" /f
if exist .\core\ZIP.txt reg add "HKCU\Software\EasyBoot Systems\UltraISO\5.0" /v "USBMode" /t REG_SZ /d "5" /f
if exist .\core\ZIPOnce.txt reg add "HKCU\Software\EasyBoot Systems\UltraISO\5.0" /v "USBMode" /t REG_SZ /d "5" /f
if exist .\core\ZIPOnce.txt del /f /q .\core\ZIPOnce.txt
reg add "HKCU\Software\EasyBoot Systems\UltraISO\5.0" /v "UseSkins" /t REG_SZ /d "1" /f
title �����ֶ��رձ�����
cls
echo.
echo. 
echo                       �뱣��Ĭ�����ò��䣬Ȼ������д�롱��ʼд��
echo                      д�����֮�����������ء��������ֶ��رձ����ڣ�
echo.
echo.
echo                  =================================================
echo                           ���и���Ĭ�����õ��µĺ���Ը���
echo                  =================================================
echo.
echo.
echo.
if %check% neq 0 echo %time% ��������������-main_burn-��ʾ�����Ĭ�����õ��� >>.\Log.txt
if %check% neq 0 call .\core\dynamic_msgbox.cmd Edgeless�������������� ֱ�ӵ��д�뼴�ɣ������޸�Ĭ�����ã�
cd /d "%~dp0"
start /min /wait .\help_uie.cmd

echo %time% ��������������-main_burn-UltraISO�˳� >>.\Log.txt
REG DELETE "HKCU\Software\EasyBoot Systems\UltraISO\5.0" /f >NUL
%windir%\system32\taskkill /im UltraISO.exe
regedit /s $oset.reg
.\core\UltraISO\drivers\ISOCMD.exe -EJECT 0:
if exist $oset.reg del $oset.reg /f /q >nul

:finishUltraIso
title ���ڴ���д����ɺ�������̣�����رմ��ڻ�γ�U��
::����uid
echo %time% ��������������-main_burn-��ʼ����uid������ΪPA�������� >>.\Log.txt
echo ���ڲ����豸
if exist .\Usee0.txt del /f /q .\Usee0.txt >nul
set uid=
echo ���������������֣������ĵȴ�...
.\core\PartAssist\partassist.exe /list /usb /out:.\Usee0.txt
type Usee0.txt >>.\Log.txt
for %%j in (1 2 3 4 5 6 7 8 9 10 11 12) DO (find  /i "%%j	|" .\Usee0.txt>nul&&SET uid=%%j)
echo %time% ��������������-main_burn-uid��%uid% >>.\Log.txt
if exist .\Usee0.txt del /f /q .\Usee0.txt >nul
if not defined uid (
    echo %time% ��������������-main_burn-uidδ���壬�����˳� >>.\Log.txt
    cls
    echo ��������ֵĴ��󣡷���ʱ���ύLog.txt
    echo PartAssist���ҵķ�����uidδ����
    echo �����ⲻ������U�̣��볢�����°β��ͼ���ʽ��
    pause
    call main_exit.cmd
    exit
)
::����һ�����Ƿ��Ѿ������̷�
echo %time% ��������������-main_burn-д�����������һ�����Ƿ��Ѿ������̷� >>.\Log.txt
:ctnburngp
echo %time% ��������������-main_burn-��ʼ����uid���ҷ���������ΪPA�������� >>.\Log.txt
echo ����У�����������%uid%�ķ���״̬
if exist .\Usee.txt del /f /q .\Usee.txt >nul
set PA_Part=
echo ���������������֣������ĵȴ�...
.\core\PartAssist\partassist.exe /list:%uid% /out:.\Usee.txt
type Usee.txt >>.\Log.txt
for %%i in (Z Y X W V U T S R Q P O N M L K J I H G F E D C) DO (find  /i "0	| %%i:" .\Usee.txt>nul&&SET PA_Part=%%i)
echo %time% ��������������-main_burn-PA_Part��%PA_Part% >>.\Log.txt
if exist .\Usee.txt del /f /q .\Usee.txt >nul
if not defined PA_Part (
    if not defined failtime goto reGivePart_burn
    if "%failtime%"=="1" goto reGivePart_burn_PA
    cls
    title ��ȫֹͣ
    echo �����޷�Ϊ��һ���������̷����˴�Ϊ��ȫֹͣ������U��δ�ܵ������
    echo ��ʹ��DiskGeniusΪU�̵ĵ�һ����ָ���µ��̷�Ȼ�����������
    pause
    goto ctnburngp
)
echo ����������%uid%�ϵķ�����ѯ���Ϊ%PA_Part%

::����������
if %way%==1 (
    echo %time% ��������������-main_burn-ʹ��д�뷽ʽ1���������� >>.\Log.txt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\GetAdmin.vbs"
    echo UAC.ShellExecute "main_writeproc.cmd", "", "", "runas", 1 >> "%temp%\GetAdmin.vbs"
    cmd /u /c type "%temp%\GetAdmin.vbs">"%temp%\GetAdminUnicode.vbs"
    cscript //nologo "%temp%\GetAdminUnicode.vbs"
    @del /f /q "%temp%\GetAdmin.vbs" >nul 2>&1
    @del /f /q "%temp%\GetAdminUnicode.vbs" >nul 2>&1
    exit
)
if %way%==3 (
    echo %time% ��������������-main_burn-ʹ��д�뷽ʽ3���������� >>.\Log.txt
    call main_hide.cmd
)


::Edgeless�ļ��п�����У��
if exist Upath.txt del /f /q Upath.txt >nul
for %%1 in (Z Y X W V T S R Q P O N M L K J I H G F E D C U) do if exist %%1:\Edgeless\version.txt echo %%1>Upath.txt
set /p u=<Upath.txt
echo %time% ��������������-main_burn-ʹ��%u%��ΪEdgeless�̷� >>.\Log.txt
if exist Upath.txt del /f /q Upath.txt >nul

if defined u (
echo %time% ��������������-main_burn-д��ɹ� >>.\Log.txt
explorer %u%:\Edgeless\Resource
attrib +s +a +h +r %u%:\boot
attrib +s +a +h +r %u%:\efi
attrib +s +a +h +r %u%:\bootmgr
attrib +s +a +h +r %u%:\bootmgr.efi
ping 127.0.0.1 -n 2 >nul 2>&1
call .\core\dynamic_msgbox.cmd Edgeless�������������� Edgeless�����������ɹ��������صõ��Ĳ�����ƶ�����Ŀ¼������ɰ�װ
call main_exit.cmd
exit
)
else 
(
if %check%==0 (
    echo %time% ��������������-main_burn-����У�� >>.\Log.txt
    call main_exit.cmd
    exit
)
echo %time% ��������������-main_burn-д��ʧ�� >>.\Log.txt
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


:reGivePart_burn
title ����ΪU�̷����̷�
set failtime=1
echo %time% ��������������-main_burn-U�̵ĵ�һ����δ�����̷���׼������DiskPart����������DiskPart�ű� >>.\Log.txt
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
echo %time% ��������������-main_burn-׼��������%ep% >>.\Log.txt
if not defined ep (
    echo %time% ��������������-main_burn-emptypartδ���壬�����˳� >>.\Log.txt
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

echo %time% ��������������-main_burn-DiskPart�ű�������ϣ�����Ϊ�� >>.\Log.txt
type DPS.txt >>.\Log.txt
echo %time% ��������������-main_burn-ִ��DiskPart�ű� >>.\Log.txt
diskpart /s DPS.txt
if exist DPS.txt del /f /q DPS.txt >nul
echo %time% ��������������-main_burn-DiskPart�ű�ִ����� >>.\Log.txt
goto ctnburngp


:reGivePart_burn_PA
title ����ΪU�̷����̷�
set failtime=2
echo %time% ��������������-main_burn-U�̵ĵ�һ������δ�����̷�������PA���� >>.\Log.txt
echo ���������������֣������ĵȴ�...
.\core\PartAssist\partassist.exe  /hd:%uid% /setletter:0 /letter:auto
.\core\PartAssist_old\partassist.exe  /hd:%uid% /setletter:0 /letter:auto
echo %time% ��������������-main_burn-PA�����̷����������ز鿴��� >>.\Log.txt
goto ctnburngp