title 正在执行烧录程序
cd /d "%~dp0"
echo %time% 启动盘制作工具-main_burn-被调用 >>.\Log.txt
set /p target=<burn_target.txt
set /p check=<burn_check.txt
set /p way=<burn_way.txt
if not defined check set check=0
if not defined way set way=0
echo %time% 启动盘制作工具-main_burn-读取信息，target：%target%，check：%check%，way：%way% >>.\Log.txt
if not defined target (
echo %time% 启动盘制作工具-main_burn-错误：target未定义 >>.\Log.txt
    cls
    echo 错误：target未定义
    pause
    call main_exit.cmd
    exit
)
::检查是否需要使用静默写入
title 正在查询静默写入方案
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
echo %time% 启动盘制作工具-main_burn-初始化UltraISO并显示写入提示 >>.\Log.txt
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
title 请勿手动关闭本窗口
cls
echo.
echo. 
echo                       请保持默认设置不变，然后点击“写入”开始写入
echo                      写入完成之后请点击“返回”，请勿手动关闭本窗口！
echo.
echo.
echo                  =================================================
echo                           自行更改默认配置导致的后果自负！
echo                  =================================================
echo.
echo.
echo.
if %check% neq 0 echo %time% 启动盘制作工具-main_burn-显示勿更改默认配置弹框 >>.\Log.txt
if %check% neq 0 call .\core\dynamic_msgbox.cmd Edgeless启动盘制作工具 直接点击写入即可，切勿修改默认配置！
cd /d "%~dp0"
start /min /wait .\help_uie.cmd

echo %time% 启动盘制作工具-main_burn-UltraISO退出 >>.\Log.txt
REG DELETE "HKCU\Software\EasyBoot Systems\UltraISO\5.0" /f >NUL
%windir%\system32\taskkill /im UltraISO.exe
regedit /s $oset.reg
.\core\UltraISO\drivers\ISOCMD.exe -EJECT 0:
if exist $oset.reg del $oset.reg /f /q >nul

:finishUltraIso
title 正在处理写入完成后的启动盘，请勿关闭窗口或拔出U盘
::检索uid
echo %time% 启动盘制作工具-main_burn-开始检索uid，下列为PA的输出结果 >>.\Log.txt
echo 正在查找设备
if exist .\Usee0.txt del /f /q .\Usee0.txt >nul
set uid=
echo 正在启动分区助手，请耐心等待...
.\core\PartAssist\partassist.exe /list /usb /out:.\Usee0.txt
type Usee0.txt >>.\Log.txt
for %%j in (1 2 3 4 5 6 7 8 9 10 11 12) DO (find  /i "%%j	|" .\Usee0.txt>nul&&SET uid=%%j)
echo %time% 启动盘制作工具-main_burn-uid：%uid% >>.\Log.txt
if exist .\Usee0.txt del /f /q .\Usee0.txt >nul
if not defined uid (
    echo %time% 启动盘制作工具-main_burn-uid未定义，程序退出 >>.\Log.txt
    cls
    echo 出现了奇怪的错误！反馈时请提交Log.txt
    echo PartAssist查找的分区：uid未定义
    echo 程序检测不到您的U盘，请尝试重新拔插或低级格式化
    pause
    call main_exit.cmd
    exit
)
::检查第一分区是否已经分配盘符
echo %time% 启动盘制作工具-main_burn-写入结束，检查第一分区是否已经分配盘符 >>.\Log.txt
:ctnburngp
echo %time% 启动盘制作工具-main_burn-开始根据uid查找分区，下列为PA的输出结果 >>.\Log.txt
echo 正在校验磁盘驱动器%uid%的分区状态
if exist .\Usee.txt del /f /q .\Usee.txt >nul
set PA_Part=
echo 正在启动分区助手，请耐心等待...
.\core\PartAssist\partassist.exe /list:%uid% /out:.\Usee.txt
type Usee.txt >>.\Log.txt
for %%i in (Z Y X W V U T S R Q P O N M L K J I H G F E D C) DO (find  /i "0	| %%i:" .\Usee.txt>nul&&SET PA_Part=%%i)
echo %time% 启动盘制作工具-main_burn-PA_Part：%PA_Part% >>.\Log.txt
if exist .\Usee.txt del /f /q .\Usee.txt >nul
if not defined PA_Part (
    if not defined failtime goto reGivePart_burn
    if "%failtime%"=="1" goto reGivePart_burn_PA
    cls
    title 安全停止
    echo 错误：无法为第一分区分配盘符，此次为安全停止，您的U盘未受到误操作
    echo 请使用DiskGenius为U盘的第一分区指派新的盘符然后按任意键继续
    pause
    goto ctnburngp
)
echo 磁盘驱动器%uid%上的分区查询结果为%PA_Part%

::处理方法分流
if %way%==1 (
    echo %time% 启动盘制作工具-main_burn-使用写入方式1处理启动盘 >>.\Log.txt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\GetAdmin.vbs"
    echo UAC.ShellExecute "main_writeproc.cmd", "", "", "runas", 1 >> "%temp%\GetAdmin.vbs"
    cmd /u /c type "%temp%\GetAdmin.vbs">"%temp%\GetAdminUnicode.vbs"
    cscript //nologo "%temp%\GetAdminUnicode.vbs"
    @del /f /q "%temp%\GetAdmin.vbs" >nul 2>&1
    @del /f /q "%temp%\GetAdminUnicode.vbs" >nul 2>&1
    exit
)
if %way%==3 (
    echo %time% 启动盘制作工具-main_burn-使用写入方式3处理启动盘 >>.\Log.txt
    call main_hide.cmd
)


::Edgeless文件夹可用性校验
if exist Upath.txt del /f /q Upath.txt >nul
for %%1 in (Z Y X W V T S R Q P O N M L K J I H G F E D C U) do if exist %%1:\Edgeless\version.txt echo %%1>Upath.txt
set /p u=<Upath.txt
echo %time% 启动盘制作工具-main_burn-使用%u%作为Edgeless盘符 >>.\Log.txt
if exist Upath.txt del /f /q Upath.txt >nul

if defined u (
echo %time% 启动盘制作工具-main_burn-写入成功 >>.\Log.txt
explorer %u%:\Edgeless\Resource
attrib +s +a +h +r %u%:\boot
attrib +s +a +h +r %u%:\efi
attrib +s +a +h +r %u%:\bootmgr
attrib +s +a +h +r %u%:\bootmgr.efi
ping 127.0.0.1 -n 2 >nul 2>&1
call .\core\dynamic_msgbox.cmd Edgeless启动盘制作工具 Edgeless启动盘制作成功！将下载得到的插件包移动到此目录即可完成安装
call main_exit.cmd
exit
)
else 
(
if %check%==0 (
    echo %time% 启动盘制作工具-main_burn-无需校验 >>.\Log.txt
    call main_exit.cmd
    exit
)
echo %time% 启动盘制作工具-main_burn-写入失败 >>.\Log.txt
title 可能出现了一些错误
color 4f
cls
echo.
echo.
echo 警告：没有发现写入完成的启动盘！ 可能在制作过程中出现了故障！
echo 如果您的U盘内已经出现了启动文件，请忽略此消息
echo 描述问题时请将本目录下的Log.txt一并提交
pause >nul
color 3f
cls
call main_home.cmd
)


:reGivePart_burn
title 正在为U盘分配盘符
set failtime=1
echo %time% 启动盘制作工具-main_burn-U盘的第一分区未分配盘符，准备调用DiskPart操作，生成DiskPart脚本 >>.\Log.txt
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
echo %time% 启动盘制作工具-main_burn-准备分配至%ep% >>.\Log.txt
if not defined ep (
    echo %time% 启动盘制作工具-main_burn-emptypart未定义，程序退出 >>.\Log.txt
    cls
    echo 出现了奇怪的错误！反馈时请提交Log.txt
    echo emptypart未定义
    echo 您的电脑上没有剩余的可分配的盘符了？
    pause
    call main_exit.cmd
    exit
)
echo assign letter=%ep% >>DPS.txt
echo exit >>DPS.txt

echo %time% 启动盘制作工具-main_burn-DiskPart脚本生成完毕，内容为： >>.\Log.txt
type DPS.txt >>.\Log.txt
echo %time% 启动盘制作工具-main_burn-执行DiskPart脚本 >>.\Log.txt
diskpart /s DPS.txt
if exist DPS.txt del /f /q DPS.txt >nul
echo %time% 启动盘制作工具-main_burn-DiskPart脚本执行完毕 >>.\Log.txt
goto ctnburngp


:reGivePart_burn_PA
title 正在为U盘分配盘符
set failtime=2
echo %time% 启动盘制作工具-main_burn-U盘的第一分区仍未分配盘符，调用PA操作 >>.\Log.txt
echo 正在启动分区助手，请耐心等待...
.\core\PartAssist\partassist.exe  /hd:%uid% /setletter:0 /letter:auto
.\core\PartAssist_old\partassist.exe  /hd:%uid% /setletter:0 /letter:auto
echo %time% 启动盘制作工具-main_burn-PA分配盘符结束，返回查看结果 >>.\Log.txt
goto ctnburngp