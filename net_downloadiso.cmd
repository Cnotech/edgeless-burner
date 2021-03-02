cd /d "%~dp0"
echo %time% 启动盘制作工具-net_downloadiso-被调用 >>.\Log.txt
::获取引擎切换云控信息
title 正在读取服务器端引擎配置
if exist core\UseIDM.txt del /f /q core\UseIDM.txt >nul
cls
echo %time% 启动盘制作工具-net_downloadiso-获取UseIDM参数 >>.\Log.txt
::core\EasyDown\EasyDown.exe -Down("http://s.edgeless.top/?token=engineSwitch","UseIDM.txt","%~dp0core")
call net_api engineSwitch UseIDM.txt a
if not exist core\UseIDM.txt call net_checknet.cmd
set /p UseIDM=<core\UseIDM.txt
echo %time% 启动盘制作工具-net_downloadiso-服务器端UseIDM：%UseIDM% >>.\Log.txt
if not defined UseIDM set UseIDM=0
if %UseIDM% neq 1 set UseIDM=0
if exist core\NomoreIDM.txt set UseIDM=0
if exist core\ForceIDM.txt set UseIDM=1
if exist X:\Users set UseIDM=0
echo %time% 启动盘制作工具-net_downloadiso-最终UseIDM：%UseIDM% >>.\Log.txt
set failTime=0

if %UseIDM%==0 goto skipEnsureIDM
if exist .\core\NoUserIDM.txt goto skipQueryIDM
echo %time% 启动盘制作工具-net_downloadiso-开始查询系统内是否有已安装的IDM >>.\Log.txt
for /f "tokens=1,2,* " %%i in ('REG QUERY HKEY_CURRENT_USER\Software\DownloadManager /v ExePath ^| find /i "ExePath"') do set "IDMPath=%%k"
echo %time% 启动盘制作工具-net_downloadiso-IDMPath：%IDMPath% >>.\Log.txt
if not defined IDMPath (
    echo %time% 启动盘制作工具-net_downloadiso-未找到已安装的IDM >>.\Log.txt
    goto skipQueryIDM
)
::过滤掉程序名不符合的IDM
if %IDMPath:~0,1%==C echo %time% 启动盘制作工具-net_downloadiso-IDM安装在了C盘，跳过 >>.\Log.txt
if %IDMPath:~0,1%==C set IDMPath=
if not defined IDMPath goto skipQueryIDM

if "%IDMPath:~-9,9%" neq "IDMan.exe" (
    echo %time% 启动盘制作工具-net_downloadiso-安装的IDM名称不符合规范，IDMPath：%IDMPath%，IDM程序名：%IDMPath:~-9,9% >>.\Log.txt
    goto skipQueryIDM
)
if "%IDMPath:~-9,9%" neq "IDMan.exe" set IDMPath=

:skipQueryIDM
::确认到底用哪个IDM
if defined IDMPath set UseUserIDM=1
::if not defined IDMPath set IDMPath=%~dp0core\IDM\IDMan.exe 就这个地方改了一下改变了IDM调用策略
if not defined IDMPath set UseIDM=0
echo %time% 启动盘制作工具-net_downloadiso-IDMPath：%IDMPath% >>.\Log.txt

:skipEnsureIDM
echo %time% 启动盘制作工具-net_downloadiso-IDM调用判断完成或无需判断 >>.\Log.txt


:head_diso
:autoRetryDownloadISO
cd /d "%~dp0"
echo %time% 启动盘制作工具-net_downloadiso-准备下载ISO >>.\Log.txt
title 正在下载Edgeless镜像
if exist .\core\Edgeless_backup.iso del /f /q .\core\Edgeless_backup.iso >nul
if exist .\core\Edgeless.iso ren .\core\Edgeless.iso Edgeless_backup.iso
if exist .\core\Edgeless.iso (
    echo %time% 启动盘制作工具-net_downloadiso-旧版ISO删除失败 >>.\Log.txt
    cls
    echo.
    echo core文件夹内的Edgeless.iso处于被占用状态，下载无法继续
    echo 请退出下载软件并将core\Edgeless.iso删除后按任意键继续下载
    echo.
    pause
    goto head_diso
)
cls
set token=iso
::token后门
if exist token.txt set /p token=<token.txt
echo %time% 启动盘制作工具-net_downloadiso-token：%token% >>.\Log.txt
echo %time% 启动盘制作工具-net_downloadiso-开始下载ISO >>.\Log.txt
::if %UseIDM%==0 .\core\EasyDown\EasyDown.exe -Down("http://s.edgeless.top/?token=%token%","Edgeless.iso","%~dp0core")
if %UseIDM%==0 call net_api %token% Edgeless.iso a
if %UseIDM%==1 (
    if not defined UseUserIDM goto installIDM
)
:ctnToDown
if %UseIDM%==1 (
    echo %time% 启动盘制作工具-net_downloadiso-调起IDM >>.\Log.txt
    cls
    echo.
    echo 正在等待IDM完成下载任务，请勿关闭本窗口...
    echo.
    echo 如果您手动关闭了IDM窗口，IDM会在后台继续运行
    ::start /d "%IDMPath:~0,-10%" /wait IDMan.exe /d http://s.edgeless.top/?token=%token% /p %~dp0core /f Edgeless.iso /q /n
    call net_api %token% Edgeless.iso i
    if not defined UseUserIDM taskkill /f /im IDM*
    if not defined UseUserIDM taskkill /f /im IEMon*
    echo %time% 启动盘制作工具-net_downloadiso-IDM退出 >>.\Log.txt
)
cd /d "%~dp0"

if not exist .\core\Edgeless.iso (
    echo %time% 启动盘制作工具-net_downloadiso-ISO不存在，failTime：%failTime% >>.\Log.txt
    cls
    if %failTime%==1 goto skipAutoRetryDownloadISO
    if %failTime%==0 set failTime=1
    echo %time% 启动盘制作工具-net_downloadiso-等待自动重试 >>.\Log.txt
    echo.
    echo Edgeless服务器可能正在解析下载地址，5s后程序将会自动重试
    echo.
    ping 127.0.0.1 -n 6 >nul 2>&1
    goto autoRetryDownloadISO
)
:skipAutoRetryDownloadISO

if not exist .\core\Edgeless.iso (
    echo %time% 启动盘制作工具-net_downloadiso-尝试使用备用地址和Aria下载 >>.\Log.txt
    title 正在尝试使用备用地址下载
)
::if not exist .\core\Edgeless.iso .\core\EasyDown\EasyDown.exe -Down("http://s.edgeless.top/?token=subiso","Edgeless.iso","%~dp0core")
if not exist .\core\Edgeless.iso call net_api subiso Edgeless.iso a
if not exist .\core\Edgeless.iso (
    echo %time% 启动盘制作工具-net_downloadiso-下载依旧失败 >>.\Log.txt
    call net_checknet.cmd
)
::校验MD5
cd /d "%~dp0"
echo %time% 启动盘制作工具-net_downloadiso-开始校验MD5 >>.\Log.txt
title 正在获取云端MD5校验信息
if exist .\core\md5_ol.txt del /f /q .\core\md5_ol.txt >nul
cls
echo %time% 启动盘制作工具-net_downloadiso-获取云端MD5信息 >>.\Log.txt
::.\core\EasyDown\EasyDown.exe -Down("http://s.edgeless.top/?token=md5","md5_ol.txt","%~dp0core")
call net_api md5 md5_ol.txt a
if not exist .\core\md5_ol.txt call net_checknet.cmd
echo %time% 启动盘制作工具-net_downloadiso-校验MD5信息，信息如下 >>.\Log.txt
title 正在校验MD5
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
echo %time% 启动盘制作工具-net_downloadiso-md5_iso：%md5_iso%，md5_iso截取：%md5_iso:~0,32%，md5_ol：%md5_ol% >>.\Log.txt
if not defined md5_iso goto ctnn
if not defined md5_ol goto ctnn
if /i "%md5_iso:~0,32%" neq "%md5_ol%" goto mdnc
goto ctnn
:mdnc
    echo %time% 启动盘制作工具-net_downloadiso-MD5校验失败 >>.\Log.txt
    cls
    title MD5校验失败
    echo.
    echo.
    echo.
    echo   ========================================================
    echo            警告！镜像MD5值与官方值不相符！
    echo.
    echo     官方MD5：%md5_ol%
    echo     本地MD5：%md5_iso:~0,32%
    echo   ========================================================
    echo 【1】重新下载      【2】继续制作
    echo.
    echo.
    set /p cho=请输入序号并回车：
    if %cho%==1 (
        echo %time% 启动盘制作工具-net_downloadiso-用户选择重新下载 >>.\Log.txt
        del /f /q core\Edgeless.iso >nul
        del /f /q core\version_iso.txt >nul
        goto head_diso
    )
echo %time% 启动盘制作工具-net_downloadiso-用户选择继续制作 >>.\Log.txt

:ctnn
echo %time% 启动盘制作工具-net_downloadiso-md5校验通过（未进行），继续 >>.\Log.txt
call net_getversion.cmd
:renCheck
if exist .\core\version_iso.txt del /f /q .\core\version_iso.txt >nul
ren .\core\version_ol.txt version_iso.txt
if not exist .\core\version_iso.txt (
    echo %time% 启动盘制作工具-net_downloadiso-version_iso.txt生成失败 >>.\Log.txt
    echo.
    echo iso镜像信息生成失败，请按任意键重试
    echo 如果重试后依旧失败，请手动将core文件夹内的version_ol.txt重命名为version_iso.txt
    echo.
    pause
    goto renCheck
)
goto endOfDown


:installIDM
echo %time% 启动盘制作工具-net_downloadiso-开始备份IDM注册表 >>.\Log.txt
if exist .\IDMBackup\*.reg del /f /q .\IDMBackup\*.reg >nul
if not exist IDMBackup md IDMBackup
cd IDMBackup
reg export "HKLM\SOFTWARE\Internet Download Manager" LM.reg
reg export "HKLM\SOFTWARE\Wow6432Node\Internet Download Manager" LM64.reg
reg export "HKCU\Software\DownloadManager" CU.reg
if not exist *.reg echo %time% 启动盘制作工具-net_downloadiso-备份IDM注册表失败 >>.\Log.txt

echo %time% 启动盘制作工具-net_downloadiso-备份IDM完成，开始安装IDM >>.\Log.txt
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
    echo %time% 启动盘制作工具-net_downloadiso-开始还原IDM备份 >>.\Log.txt
    cd IDMBackup
    regedit /s LM.reg
    regedit /s LM64.reg
    regedit /s CU.reg
    if exist *.reg del /f /q *.reg >nul
    cd ..
    rd IDMBackup
)
echo %time% 启动盘制作工具-net_downloadiso-正常退出 >>.\Log.txt