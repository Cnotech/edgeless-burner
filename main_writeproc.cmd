@echo off
cd /d "%~dp0"
echo %time% 启动盘制作工具-main_writeproc-被调用 >>.\Log.txt
color 3f
title 正在处理写入完成后的启动盘

:homeProc

::检索uid
echo %time% 启动盘制作工具-main_writeproc-开始检索uid，下列为PA的输出结果 >>.\Log.txt
echo 正在查找设备
if exist .\Usee0.txt del /f /q .\Usee0.txt >nul
set uid=
echo 正在启动分区助手，请耐心等待...
.\core\PartAssist\partassist.exe /list /usb /out:.\Usee0.txt
type Usee0.txt >>.\Log.txt
for %%j in (1 2 3 4 5 6 7 8 9 10 11 12) DO (find  /i "%%j	|" .\Usee0.txt>nul&&SET uid=%%j)
echo %time% 启动盘制作工具-main_writeproc-uid：%uid% >>.\Log.txt
if exist .\Usee0.txt del /f /q .\Usee0.txt >nul
if not defined uid (
    echo %time% 启动盘制作工具-main_writeproc-uid未定义，程序退出 >>.\Log.txt
    cls
    echo 出现了奇怪的错误！反馈时请提交Log.txt
    echo PartAssist查找的分区：uid未定义
    echo 程序检测不到您的U盘，请尝试重新拔插或低级格式化
    pause
    call main_exit.cmd
    exit
)

::根据uid查找分区
:ctnwriteproc
echo %time% 启动盘制作工具-main_writeproc-开始根据uid查找分区，下列为PA的输出结果 >>.\Log.txt
echo 正在校验磁盘驱动器%uid%的分区状态
if exist .\Usee.txt del /f /q .\Usee.txt >nul
set PA_Part=
echo 正在启动分区助手，请耐心等待...
.\core\PartAssist\partassist.exe /list:%uid% /out:.\Usee.txt
type Usee.txt >>.\Log.txt
for %%i in (Z Y X W V U T S R Q P O N M L K J I H G F E D C) DO (find  /i "0	| %%i:" .\Usee.txt>nul&&SET PA_Part=%%i)
echo %time% 启动盘制作工具-main_writeproc-PA_Part：%PA_Part% >>.\Log.txt
if exist .\Usee.txt del /f /q .\Usee.txt >nul
if not defined PA_Part (
    if not defined failtime goto reGivePart
    cls
    title 安全停止
    echo 错误：无法为第一分区分配盘符，此次为安全停止，您的U盘未受到误操作
    echo 请使用DiskGenius为U盘的第一分区指派新的盘符然后按任意键继续
    pause
    goto ctnwriteproc
)
if not exist %PA_Part%:\ (
    if not defined failtime goto reGivePart
    cls
    title 安全停止
    echo 错误：无法为第一分区分配盘符，此次为安全停止，您的U盘未受到误操作
    echo 请使用DiskGenius为U盘的第一分区指派新的盘符然后按任意键继续
    pause
    goto ctnwriteproc
)
echo 磁盘驱动器%uid%上的分区查询结果为%PA_Part%

::确认是第一分区不是EFI
if exist %PA_Part%:\Edgeless\version.txt (
    echo %time% 启动盘制作工具-main_writeproc-PA_Part其实是EFI分区，程序异常退出 >>.\Log.txt
    cls
    title 安全停止
    echo 错误：文件分区与EFI分区重叠，此次为安全停止，您的U盘未受到误操作
    echo 目前您的启动盘已基本就绪，只差一些善后工作没能被自动完成，请在内测群寻求处理方法
    pause
    call main_exit.cmd
    exit
)

::通过检验，确认没有误操作
echo %time% 启动盘制作工具-main_writeproc-%PA_Part%盘符通过Edgeless启动盘一致性校验 >>.\Log.txt
echo %PA_Part%盘符通过Edgeless启动盘一致性校验

::检查EFI分区是否已经直接暴露
if exist EFIpath.txt del /f /q EFIpath.txt >nul
for %%1 in (Z Y X W V T S R Q P O N M L K J I H G F E D C U) do if exist %%1:\sources\boot.wim echo %%1>EFIpath.txt
set /p EFI_Part=<EFIpath.txt
echo %time% 启动盘制作工具-main_writeproc-检查EFI分区是否已经直接暴露，EFI_Part：%EFI_Part% >>.\Log.txt
if exist EFIpath.txt del /f /q EFIpath.txt >nul

::删除stuff.zip和Edgeless文件夹
echo %time% 启动盘制作工具-main_writeproc-开始删除stuff.zip和Edgeless文件夹 >>.\Log.txt
if defined EFI_Part (
    del /f /q %EFI_Part%:\stuff.zip
    if exist %EFI_Part%:\stuff.zip echo %time% 启动盘制作工具-main_writeproc-stuff.zip删除失败 >>.\Log.txt
    del /f /s /q %EFI_Part%:\Edgeless
    rd /s /q %EFI_Part%:\Edgeless
    if exist %EFI_Part%:\Edgeless echo %time% 启动盘制作工具-main_writeproc-Edgeless文件夹删除失败 >>.\Log.txt
)
if not defined EFI_Part goto delHideFile
:ctnHideFile
echo %time% 启动盘制作工具-main_writeproc-删除stuff.zip和Edgeless文件夹完成 >>.\Log.txt

::文件分区格式化为exFAT
echo %time% 启动盘制作工具-main_writeproc-开始文件分区格式化为exFAT >>.\Log.txt
echo 开始文件分区格式化为exFAT
format %PA_Part%: /FS:exFAT /V:文件盘 /Q /Y
echo %time% 启动盘制作工具-main_writeproc-格式化为exFAT完成 >>.\Log.txt

::复制Edgeless文件夹
echo %time% 启动盘制作工具-main_writeproc-开始解压ISO >>.\Log.txt
call dash_checkrelease.cmd
title 正在处理写入完成后的启动盘
echo %time% 启动盘制作工具-main_writeproc-开始复制Edgeless文件夹 >>.\Log.txt
md %PA_Part%:\Edgeless
xcopy /s /r /y core\Release\Edgeless %PA_Part%:\Edgeless\
echo %time% 启动盘制作工具-main_writeproc-复制Edgeless文件夹完成 >>.\Log.txt
goto endWriteProc


:reGivePart
set failtime=1
echo %time% 启动盘制作工具-main_writeproc-U盘的第一分区未分配盘符，准备调用DiskPart操作，生成DiskPart脚本 >>.\Log.txt
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
echo %time% 启动盘制作工具-main_writeproc-准备分配至%ep% >>.\Log.txt
if not defined ep (
    echo %time% 启动盘制作工具-main_writeproc-emptypart未定义，程序退出 >>.\Log.txt
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

echo %time% 启动盘制作工具-main_writeproc-DiskPart脚本生成完毕，内容为： >>.\Log.txt
type DPS.txt >>.\Log.txt
echo %time% 启动盘制作工具-main_writeproc-执行DiskPart脚本 >>.\Log.txt
diskpart /s DPS.txt
if exist DPS.txt del /f /q DPS.txt >nul
echo %time% 启动盘制作工具-main_writeproc-DiskPart脚本执行完毕 >>.\Log.txt
goto ctnwriteproc

:delHideFile
cd "%~dp0core\PartAssist_old"
partassist.exe /hd:%uid% /whide:1 /delfiles /dest:stuff.zip
partassist.exe /hd:%uid% /whide:1 /delfiles /dest:Edgeless
cd /d "%~dp0"
goto ctnHideFile


:endWriteProc
echo %time% 启动盘制作工具-main_writeproc-任务完成，校验Edgeless文件夹是否存在 >>.\Log.txt
::Edgeless文件夹可用性校验
if exist Upath.txt del /f /q Upath.txt >nul
for %%1 in (Z Y X W V T S R Q P O N M L K J I H G F E D C U) do if exist %%1:\Edgeless\version.txt echo %%1>Upath.txt
set /p u=<Upath.txt
echo %time% 启动盘制作工具-main_writeproc-使用%u%作为Edgeless盘符 >>.\Log.txt
if exist Upath.txt del /f /q Upath.txt >nul

if defined u (
echo %time% 启动盘制作工具-main_writeproc-写入成功 >>.\Log.txt
explorer %u%:\Edgeless\Resource
attrib +s +a +h +r %u%:\boot
attrib +s +a +h +r %u%:\efi
attrib +s +a +h +r %u%:\bootmgr
attrib +s +a +h +r %u%:\bootmgr.efi
ping 127.0.0.1 -n 2 >nul 2>&1
call .\core\dynamic_msgbox.cmd Edgeless启动盘制作工具 Edgeless启动盘制作成功！将下载得到的插件包移动到此目录即可完成安装
call "%~dp0main_exit.cmd"
exit
)
else 
(
echo %time% 启动盘制作工具-main_writeproc-写入失败 >>.\Log.txt
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