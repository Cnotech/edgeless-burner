cd /d "%~dp0"
echo %time% ��������������-net_downloadiso-������ >>.\Log.txt
::��ȡ�����л��ƿ���Ϣ
title ���ڶ�ȡ����������������
if exist core\UseIDM.txt del /f /q core\UseIDM.txt >nul
cls
echo %time% ��������������-net_downloadiso-��ȡUseIDM���� >>.\Log.txt
::core\EasyDown\EasyDown.exe -Down("http://s.edgeless.top/?token=engineSwitch","UseIDM.txt","%~dp0core")
call net_api engineSwitch UseIDM.txt a
if not exist core\UseIDM.txt call net_checknet.cmd
set /p UseIDM=<core\UseIDM.txt
echo %time% ��������������-net_downloadiso-��������UseIDM��%UseIDM% >>.\Log.txt
if not defined UseIDM set UseIDM=0
if %UseIDM% neq 1 set UseIDM=0
if exist core\NomoreIDM.txt set UseIDM=0
if exist core\ForceIDM.txt set UseIDM=1
if exist X:\Users set UseIDM=0
echo %time% ��������������-net_downloadiso-����UseIDM��%UseIDM% >>.\Log.txt
set failTime=0

if %UseIDM%==0 goto skipEnsureIDM
if exist .\core\NoUserIDM.txt goto skipQueryIDM
echo %time% ��������������-net_downloadiso-��ʼ��ѯϵͳ���Ƿ����Ѱ�װ��IDM >>.\Log.txt
for /f "tokens=1,2,* " %%i in ('REG QUERY HKEY_CURRENT_USER\Software\DownloadManager /v ExePath ^| find /i "ExePath"') do set "IDMPath=%%k"
echo %time% ��������������-net_downloadiso-IDMPath��%IDMPath% >>.\Log.txt
if not defined IDMPath (
    echo %time% ��������������-net_downloadiso-δ�ҵ��Ѱ�װ��IDM >>.\Log.txt
    goto skipQueryIDM
)
::���˵������������ϵ�IDM
if %IDMPath:~0,1%==C echo %time% ��������������-net_downloadiso-IDM��װ����C�̣����� >>.\Log.txt
if %IDMPath:~0,1%==C set IDMPath=
if not defined IDMPath goto skipQueryIDM

if "%IDMPath:~-9,9%" neq "IDMan.exe" (
    echo %time% ��������������-net_downloadiso-��װ��IDM���Ʋ����Ϲ淶��IDMPath��%IDMPath%��IDM��������%IDMPath:~-9,9% >>.\Log.txt
    goto skipQueryIDM
)
if "%IDMPath:~-9,9%" neq "IDMan.exe" set IDMPath=

:skipQueryIDM
::ȷ�ϵ������ĸ�IDM
if defined IDMPath set UseUserIDM=1
::if not defined IDMPath set IDMPath=%~dp0core\IDM\IDMan.exe ������ط�����һ�¸ı���IDM���ò���
if not defined IDMPath set UseIDM=0
echo %time% ��������������-net_downloadiso-IDMPath��%IDMPath% >>.\Log.txt

:skipEnsureIDM
echo %time% ��������������-net_downloadiso-IDM�����ж���ɻ������ж� >>.\Log.txt


:head_diso
:autoRetryDownloadISO
cd /d "%~dp0"
echo %time% ��������������-net_downloadiso-׼������ISO >>.\Log.txt
title ��������Edgeless����
if exist .\core\Edgeless_backup.iso del /f /q .\core\Edgeless_backup.iso >nul
if exist .\core\Edgeless.iso ren .\core\Edgeless.iso Edgeless_backup.iso
if exist .\core\Edgeless.iso (
    echo %time% ��������������-net_downloadiso-�ɰ�ISOɾ��ʧ�� >>.\Log.txt
    cls
    echo.
    echo core�ļ����ڵ�Edgeless.iso���ڱ�ռ��״̬�������޷�����
    echo ���˳������������core\Edgeless.isoɾ�����������������
    echo.
    pause
    goto head_diso
)
cls
set token=iso
::token����
if exist token.txt set /p token=<token.txt
echo %time% ��������������-net_downloadiso-token��%token% >>.\Log.txt
echo %time% ��������������-net_downloadiso-��ʼ����ISO >>.\Log.txt
::if %UseIDM%==0 .\core\EasyDown\EasyDown.exe -Down("http://s.edgeless.top/?token=%token%","Edgeless.iso","%~dp0core")
if %UseIDM%==0 call net_api %token% Edgeless.iso a
if %UseIDM%==1 (
    if not defined UseUserIDM goto installIDM
)
:ctnToDown
if %UseIDM%==1 (
    echo %time% ��������������-net_downloadiso-����IDM >>.\Log.txt
    cls
    echo.
    echo ���ڵȴ�IDM���������������رձ�����...
    echo.
    echo ������ֶ��ر���IDM���ڣ�IDM���ں�̨��������
    ::start /d "%IDMPath:~0,-10%" /wait IDMan.exe /d http://s.edgeless.top/?token=%token% /p %~dp0core /f Edgeless.iso /q /n
    call net_api %token% Edgeless.iso i
    if not defined UseUserIDM taskkill /f /im IDM*
    if not defined UseUserIDM taskkill /f /im IEMon*
    echo %time% ��������������-net_downloadiso-IDM�˳� >>.\Log.txt
)
cd /d "%~dp0"

if not exist .\core\Edgeless.iso (
    echo %time% ��������������-net_downloadiso-ISO�����ڣ�failTime��%failTime% >>.\Log.txt
    cls
    if %failTime%==1 goto skipAutoRetryDownloadISO
    if %failTime%==0 set failTime=1
    echo %time% ��������������-net_downloadiso-�ȴ��Զ����� >>.\Log.txt
    echo.
    echo Edgeless�������������ڽ������ص�ַ��5s����򽫻��Զ�����
    echo.
    ping 127.0.0.1 -n 6 >nul 2>&1
    goto autoRetryDownloadISO
)
:skipAutoRetryDownloadISO

if not exist .\core\Edgeless.iso (
    echo %time% ��������������-net_downloadiso-����ʹ�ñ��õ�ַ��Aria���� >>.\Log.txt
    title ���ڳ���ʹ�ñ��õ�ַ����
)
::if not exist .\core\Edgeless.iso .\core\EasyDown\EasyDown.exe -Down("http://s.edgeless.top/?token=subiso","Edgeless.iso","%~dp0core")
if not exist .\core\Edgeless.iso call net_api subiso Edgeless.iso a
if not exist .\core\Edgeless.iso (
    echo %time% ��������������-net_downloadiso-��������ʧ�� >>.\Log.txt
    call net_checknet.cmd
)
::У��MD5
cd /d "%~dp0"
echo %time% ��������������-net_downloadiso-��ʼУ��MD5 >>.\Log.txt
title ���ڻ�ȡ�ƶ�MD5У����Ϣ
if exist .\core\md5_ol.txt del /f /q .\core\md5_ol.txt >nul
cls
echo %time% ��������������-net_downloadiso-��ȡ�ƶ�MD5��Ϣ >>.\Log.txt
::.\core\EasyDown\EasyDown.exe -Down("http://s.edgeless.top/?token=md5","md5_ol.txt","%~dp0core")
call net_api md5 md5_ol.txt a
if not exist .\core\md5_ol.txt call net_checknet.cmd
echo %time% ��������������-net_downloadiso-У��MD5��Ϣ����Ϣ���� >>.\Log.txt
title ����У��MD5
::.\core\EasyDown\EasyDown.exe -GetMD5("%~dp0core\Edgeless.iso") > "%~dp0core\md5_iso.txt"
cd core
md5sum Edgeless.iso>md5.txt
set /p md5_iso=<md5.txt
::certutil -hashfile Edgeless.iso MD5>md5.txt
::For /f "tokens=1* delims=:" %%i in ('Type md5.txt^|Findstr /n ".*"') do (
::If "%%i"=="2" Echo %%j >md5_iso.txt
::)
cd ..
type core\md5.txt >>Log.txt
if exist core\md5.txt del /f /q core\md5.txt >nul
set /p md5_iso=<.\core\md5_iso.txt
set /p md5_ol=<.\core\md5_ol.txt
echo %time% ��������������-net_downloadiso-md5_iso��%md5_iso%��md5_iso��ȡ��%md5_iso:~0,32%��md5_ol��%md5_ol% >>.\Log.txt
if not defined md5_iso goto ctnn
if not defined md5_ol goto ctnn
if /i "%md5_iso:~0,32%" neq "%md5_ol%" goto mdnc
goto ctnn
:mdnc
    echo %time% ��������������-net_downloadiso-MD5У��ʧ�� >>.\Log.txt
    cls
    title MD5У��ʧ��
    echo.
    echo.
    echo.
    echo   ========================================================
    echo            ���棡����MD5ֵ��ٷ�ֵ�������
    echo.
    echo     �ٷ�MD5��%md5_ol%
    echo     ����MD5��%md5_iso:~0,32%
    echo   ========================================================
    echo ��1����������      ��2����������
    echo.
    echo.
    set /p cho=��������Ų��س���
    if %cho%==1 (
        echo %time% ��������������-net_downloadiso-�û�ѡ���������� >>.\Log.txt
        del /f /q core\Edgeless.iso >nul
        del /f /q core\version_iso.txt >nul
        goto head_diso
    )
echo %time% ��������������-net_downloadiso-�û�ѡ��������� >>.\Log.txt

:ctnn
echo %time% ��������������-net_downloadiso-md5У��ͨ����δ���У������� >>.\Log.txt
call net_getversion.cmd
:renCheck
if exist .\core\version_iso.txt del /f /q .\core\version_iso.txt >nul
ren .\core\version_ol.txt version_iso.txt
if not exist .\core\version_iso.txt (
    echo %time% ��������������-net_downloadiso-version_iso.txt����ʧ�� >>.\Log.txt
    echo.
    echo iso������Ϣ����ʧ�ܣ��밴���������
    echo ������Ժ�����ʧ�ܣ����ֶ���core�ļ����ڵ�version_ol.txt������Ϊversion_iso.txt
    echo.
    pause
    goto renCheck
)
goto endOfDown


:installIDM
echo %time% ��������������-net_downloadiso-��ʼ����IDMע��� >>.\Log.txt
if exist .\IDMBackup\*.reg del /f /q .\IDMBackup\*.reg >nul
if not exist IDMBackup md IDMBackup
cd IDMBackup
reg export "HKLM\SOFTWARE\Internet Download Manager" LM.reg
reg export "HKLM\SOFTWARE\Wow6432Node\Internet Download Manager" LM64.reg
reg export "HKCU\Software\DownloadManager" CU.reg
if not exist *.reg echo %time% ��������������-net_downloadiso-����IDMע���ʧ�� >>.\Log.txt

echo %time% ��������������-net_downloadiso-����IDM��ɣ���ʼ��װIDM >>.\Log.txt
cd /d "%~dp0core"
cd IDM
taskkill /f /im IDM* >NUL 2>NUL
taskkill /f /im IEMon* >NUL 2>NUL
reg delete "HKLM\SOFTWARE\Internet Download Manager" /f>NUL 2>NUL
reg delete "HKLM\SOFTWARE\Wow6432Node\Internet Download Manager" /f>NUL 2>NUL
reg delete HKCU\Software\Classes\CLSID\{07999AC3-058B-40BF-984F-69EB1E554CA7} /f>NUL 2>NUL
reg delete HKCU\Software\Classes\CLSID\{6DDF00DB-1234-46EC-8356-27E7B2051192} /f>NUL 2>NUL
reg delete HKCU\Software\Classes\CLSID\{D5B91409-A8CA-4973-9A0B-59F713D25671} /f>NUL 2>NUL
reg delete HKCU\Software\Classes\CLSID\{7B8E9164-324D-4A2E-A46D-0165FB2000EC} /f>NUL 2>NUL
reg delete HKCU\Software\Classes\CLSID\{5ED60779-4DE2-4E07-B862-974CA4FF2E9C} /f>NUL 2>NUL
reg delete HKLM\Software\Classes\CLSID\{07999AC3-058B-40BF-984F-69EB1E554CA7} /f>NUL 2>NUL
reg delete HKLM\Software\Classes\CLSID\{6DDF00DB-1234-46EC-8356-27E7B2051192} /f>NUL 2>NUL
reg delete HKLM\Software\Classes\CLSID\{D5B91409-A8CA-4973-9A0B-59F713D25671} /f>NUL 2>NUL
reg delete HKLM\Software\Classes\CLSID\{7B8E9164-324D-4A2E-A46D-0165FB2000EC} /f>NUL 2>NUL
reg delete HKLM\Software\Classes\CLSID\{5ED60779-4DE2-4E07-B862-974CA4FF2E9C} /f>NUL 2>NUL
reg delete HKLM\SOFTWARE\Classes\CLSID\{D0FB58BB-2C07-492F-8BD0-A587E4874B4E} /f>NUL 2>NUL
reg delete HKLM\SOFTWARE\Classes\CLSID\{0055C089-8582-441B-A0BF-17B458C2A3A8} /f>NUL 2>NUL
reg delete HKLM\SOFTWARE\Classes\CLSID\{0F947660-8606-420A-BAC6-51B84DD22A47} /f>NUL 2>NUL
reg delete HKLM\SOFTWARE\Classes\CLSID\{436D67E1-2FB3-4A6C-B3CD-FF8A41B0664D} /f>NUL 2>NUL
reg delete HKLM\SOFTWARE\Classes\CLSID\{4764030F-2733-45B9-AE62-3D1F4F6F2861} /f>NUL 2>NUL
reg delete HKLM\SOFTWARE\Classes\CLSID\{52F6F7BD-DF73-44B3-AE13-89E1E1FB8F6A} /f>NUL 2>NUL
reg delete HKLM\SOFTWARE\Classes\CLSID\{5312C54E-A385-46B7-B200-ABAF81B03935} /f>NUL 2>NUL
reg delete HKLM\SOFTWARE\Classes\CLSID\{6B9EB066-DA1F-4C0A-AC62-01AC892EF175} /f>NUL 2>NUL
reg delete HKLM\SOFTWARE\Classes\CLSID\{7D11E719-FF90-479C-B0D7-96EB43EE55D7} /f>NUL 2>NUL
reg delete HKLM\SOFTWARE\Classes\CLSID\{AC746233-E9D3-49CD-862F-068F7B7CCCA4} /f>NUL 2>NUL
reg delete HKLM\SOFTWARE\Classes\CLSID\{CDD67718-A430-4AB9-A939-83D9074B0038} /f>NUL 2>NUL
reg delete HKLM\SOFTWARE\Classes\CLSID\{CDC95B92-E27C-4745-A8C5-64A52A78855D} /f>NUL 2>NUL
reg delete HKLM\SOFTWARE\Classes\CLSID\{CDD67718-A430-4AB9-A939-83D9074B0038} /f>NUL 2>NUL
reg delete HKLM\Software\Classes\Wow6432Node\CLSID\{07999AC3-058B-40BF-984F-69EB1E554CA7} /f>NUL 2>NUL
reg delete HKLM\Software\Classes\Wow6432Node\CLSID\{6DDF00DB-1234-46EC-8356-27E7B2051192} /f>NUL 2>NUL
reg delete HKLM\Software\Classes\Wow6432Node\CLSID\{D5B91409-A8CA-4973-9A0B-59F713D25671} /f>NUL 2>NUL
reg delete HKCU\Software\Classes\Wow6432Node\CLSID\{7B8E9164-324D-4A2E-A46D-0165FB2000EC} /f>NUL 2>NUL
reg delete HKCU\Software\Classes\Wow6432Node\CLSID\{5ED60779-4DE2-4E07-B862-974CA4FF2E9C} /f>NUL 2>NUL
reg delete HKLM\Software\Classes\Wow6432Node\CLSID\{7B8E9164-324D-4A2E-A46D-0165FB2000EC} /f>NUL 2>NUL
reg delete HKLM\Software\Classes\Wow6432Node\CLSID\{5ED60779-4DE2-4E07-B862-974CA4FF2E9C} /f>NUL 2>NUL
reg delete HKLM\SOFTWARE\Classes\Wow6432Node\CLSID\{0055C089-8582-441B-A0BF-17B458C2A3A8} /f>NUL 2>NUL
reg delete HKLM\SOFTWARE\Classes\Wow6432Node\CLSID\{0F947660-8606-420A-BAC6-51B84DD22A47} /f>NUL 2>NUL
reg delete HKLM\SOFTWARE\Classes\Wow6432Node\CLSID\{436D67E1-2FB3-4A6C-B3CD-FF8A41B0664D} /f>NUL 2>NUL
reg delete HKLM\SOFTWARE\Classes\Wow6432Node\CLSID\{4764030F-2733-45B9-AE62-3D1F4F6F2861} /f>NUL 2>NUL
reg delete HKLM\SOFTWARE\Classes\Wow6432Node\CLSID\{52F6F7BD-DF73-44B3-AE13-89E1E1FB8F6A} /f>NUL 2>NUL
reg delete HKLM\SOFTWARE\Classes\Wow6432Node\CLSID\{5312C54E-A385-46B7-B200-ABAF81B03935} /f>NUL 2>NUL
reg delete HKLM\SOFTWARE\Classes\Wow6432Node\CLSID\{6B9EB066-DA1F-4C0A-AC62-01AC892EF175} /f>NUL 2>NUL
reg delete HKLM\SOFTWARE\Classes\Wow6432Node\CLSID\{7D11E719-FF90-479C-B0D7-96EB43EE55D7} /f>NUL 2>NUL
reg delete HKLM\SOFTWARE\Classes\Wow6432Node\CLSID\{AC746233-E9D3-49CD-862F-068F7B7CCCA4} /f>NUL 2>NUL
reg delete HKLM\SOFTWARE\Classes\Wow6432Node\CLSID\{CDD67718-A430-4AB9-A939-83D9074B0038} /f>NUL 2>NUL
reg delete HKLM\SOFTWARE\Classes\Wow6432Node\CLSID\{D0FB58BB-2C07-492F-8BD0-A587E4874B4E} /f>NUL 2>NUL
reg delete HKLM\SOFTWARE\Wow6432Node\Classes\CLSID\{CDC95B92-E27C-4745-A8C5-64A52A78855D} /f>NUL 2>NUL
reg delete HKLM\SOFTWARE\Wow6432Node\Classes\CLSID\{CDD67718-A430-4AB9-A939-83D9074B0038} /f>NUL 2>NUL
reg delete HKCU\SOFTWARE\DownloadManager /v tvfrdt /f>NUL 2>NUL
reg add "HKCU\Software\DownloadManager" /f /v "LName" /d "Version" >NUL
reg add "HKCU\Software\DownloadManager" /f /v "FName" /d "All Users" >NUL
reg add "HKCU\Software\DownloadManager" /f /v "Email" /d "info@tonec.com" >NUL
reg add "HKCU\Software\DownloadManager" /f /v "Serial" /d "VM2HP-0L5CH-REJPM-7YSKI" >NUL
if "%PROCESSOR_ARCHITECTURE%"=="x86"  reg add "HKLM\Software\Internet Download Manager" /f /v LName /d "Version" >NUL
if "%PROCESSOR_ARCHITECTURE%"=="x86"  reg add "HKLM\Software\Internet Download Manager" /f /v FName /d "All Users" >NUL
if "%PROCESSOR_ARCHITECTURE%"=="x86"  reg add "HKLM\Software\Internet Download Manager" /f /v Email /d "info@tonec.com" >NUL
if "%PROCESSOR_ARCHITECTURE%"=="x86"  reg add "HKLM\Software\Internet Download Manager" /f /v Serial /d "VM2HP-0L5CH-REJPM-7YSKI" >NUL
if "%PROCESSOR_ARCHITECTURE%"=="AMD64"  reg add "HKLM\Software\WOW6432Node\Internet Download Manager" /f /v LName /d "Version" >NUL
if "%PROCESSOR_ARCHITECTURE%"=="AMD64"  reg add "HKLM\Software\WOW6432Node\Internet Download Manager" /f /v FName /d "All Users" >NUL
if "%PROCESSOR_ARCHITECTURE%"=="AMD64"  reg add "HKLM\Software\WOW6432Node\Internet Download Manager" /f /v Email /d "info@tonec.com" >NUL
if "%PROCESSOR_ARCHITECTURE%"=="AMD64"  reg add "HKLM\Software\WOW6432Node\Internet Download Manager" /f /v Serial /d "VM2HP-0L5CH-REJPM-7YSKI" >NUL
reg add HKCU\Software\DownloadManager /f /v ToolbarStyle /d "Faenza" >NUL
reg add HKCU\Software\DownloadManager /f /v LstCheck  /d "31/12/99" >NUL
reg add HKCU\Software\DownloadManager /f /v TipStartUp /t REG_DWORD /d 1 >NUL
reg add HKCU\Software\DownloadManager /f /v LaunchOnStart /t REG_DWORD /d 0 >NUL
reg add HKCU\Software\DownloadManager /f /v FSSettingsChecked /t REG_DWORD /d 1 >NUL
reg add HKCU\Software\DownloadManager /f /v LanguageID /t REG_DWORD /d "0x00000804" >NUL
reg add HKCU\Software\DownloadManager /f /v bShVistaAsAdmWarn /t REG_DWORD /d 1
reg add HKCU\Software\DownloadManager /f /v bComlDlgVMS /t REG_DWORD /d 1
reg add HKCU\Software\DownloadManager /f /v bShBTtFQCI /t REG_DWORD /d 1
reg add HKCU\Software\DownloadManager /f /v bShInstEdgeExtTip /t REG_DWORD /d 1
reg add HKCU\Software\DownloadManager /f /v bShTipDD /t REG_DWORD /d 1
goto ctnToDown



:endOfDown
if %UseIDM%==1 (
    echo %time% ��������������-net_downloadiso-��ʼ��ԭIDM���� >>.\Log.txt
    cd IDMBackup
    regedit /s LM.reg
    regedit /s LM64.reg
    regedit /s CU.reg
    if exist *.reg del /f /q *.reg >nul
    cd ..
    rd IDMBackup
)
echo %time% ��������������-net_downloadiso-�����˳� >>.\Log.txt