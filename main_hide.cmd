@echo off
cd /d "%~dp0"
echo %time% 启动盘制作工具-main_hide-被调用 >>.\Log.txt
color 3f
title 准备进行分区优化
cls

:homeHide
for %%1 in (Z Y X W V T S R Q P O N M L K J I H G F E D C U) do if exist %%1:\Edgeless\version.txt echo %%1>"%~dp0Upath.txt"
set /p EL_Part=<"%~dp0Upath.txt"
echo %time% 启动盘制作工具-main_hide-EL_Part：%EL_Part% >>.\Log.txt
if not defined EL_Part (
    echo %time% 启动盘制作工具-main_hide-EL_Part未定义 >>.\Log.txt
    cls
    echo 错误：%EL_Part%分区未定义
    pause
    call main_exit.cmd
    exit
)
if not exist %EL_Part%:\ (
    echo %time% 启动盘制作工具-main_hide-%EL_Part%盘不存在 >>.\Log.txt
    cls
    echo 错误：%EL_Part%分区不存在
    pause
    call main_exit.cmd
    exit
)

::检索uid
echo %time% 启动盘制作工具-main_hide-开始检索uid，下列为PA的输出结果 >>.\Log.txt
echo 正在查找设备
if exist .\Usee0.txt del /f /q .\Usee0.txt >nul
set uid=
echo 正在启动分区助手，请耐心等待...
.\core\PartAssist\partassist.exe /list /usb /out:.\Usee0.txt
type Usee0.txt >>.\Log.txt
for %%j in (1 2 3 4 5 6 7 8 9 10 11 12) DO (find  /i "%%j	|" .\Usee0.txt>nul&&SET uid=%%j)
echo %time% 启动盘制作工具-main_hide-uid：%uid% >>.\Log.txt
if exist .\Usee0.txt del /f /q .\Usee0.txt >nul
if not defined uid (
    echo %time% 启动盘制作工具-main_hide-uid未定义，程序退出 >>.\Log.txt
    cls
    echo 出现了奇怪的错误！
    echo Edgeless启动盘：%EL_Part%
    echo PartAssist查找的分区：uid未定义
    pause
    call main_exit.cmd
    exit
)

::根据uid查找分区
echo %time% 启动盘制作工具-main_hide-开始根据uid查找分区，下列为PA的输出结果 >>.\Log.txt
echo 正在校验磁盘驱动器%uid%的分区状态
if exist .\Usee.txt del /f /q .\Usee.txt >nul
set PA_Part=
echo 正在启动分区助手，请耐心等待...
.\core\PartAssist\partassist.exe /list:%uid% /out:.\Usee.txt
type Usee.txt >>.\Log.txt
for %%i in (Z Y X W U T S  R Q P O N M L K J I H G F E D C) DO (
		find  /i "%%i:" .\Usee.txt>nul&&SET PA_Part=%%i)
echo %time% 启动盘制作工具-main_hide-PA_Part：%PA_Part% >>.\Log.txt
if exist .\Usee.txt del /f /q .\Usee.txt >nul
if not defined PA_Part (
    echo %time% 启动盘制作工具-main_hide-PA_Part未定义，程序退出 >>.\Log.txt
    cls
    echo 出现了奇怪的错误！
    echo Edgeless启动盘：%EL_Part%
    echo PartAssist查找的分区：分区盘符未定义
    pause
    call main_exit.cmd
    exit
)
echo 磁盘驱动器%uid%上的分区查询结果为%PA_Part%

::检验是否是同一个U盘
if %EL_Part%==%PA_Part% goto ctnHide
echo %time% 启动盘制作工具-main_hide-获取的分区不同，认定为存在多个USB移动存储设备 >>.\Log.txt
title 存在多个USB移动存储设备
cls 
echo.
echo 检测到可能存在多个U盘并且程序的识别出现了混乱
echo 请将%PA_Part%上的U盘弹出以便程序继续操作%EL_Part%上的Edgeless启动盘
echo.
pause
goto homeHide

::通过检验，确认没有误操作
:ctnHide
echo %time% 启动盘制作工具-main_hide-一致性校验通过 >>.\Log.txt
echo %PA_Part%盘符通过Edgeless启动盘一致性校验

::缩小EFI分区
echo 正在查询磁盘驱动器%uid%的容量
echo %time% 启动盘制作工具-main_hide-查询U盘容量，下列为PA的输出结果 >>.\Log.txt
.\core\PartAssist_old\partassist.exe /list:%uid% /capacity /out:.\GetSpace.txt
type GetSpace.txt >>.\Log.txt
set /p AllSpace=<GetSpace.txt
set /a ReduceSpace = %AllSpace:~0,-2% - 800
echo %time% 启动盘制作工具-main_hide-AllSpace：%AllSpace%，ReduceSpace：%ReduceSpace% >>.\Log.txt
if not defined AllSpace (
    echo %time% 启动盘制作工具-main_hide-进入安全停止，因为AllSpace未定义 >>.\Log.txt
    cls
    title 安全停止
    echo.
    echo 出现了一些问题，我们无法获取U盘的剩余容量
    echo 此次停止为安全停止，目前您的启动盘已经可以正常启动，只是没法放置4GB以上的大文件
    echo 提交bug时请将本目录下的Log.txt一并提交
    echo.
    pause
    call main_exit.cmd
    exit
)
if not defined ReduceSpace (
    echo %time% 启动盘制作工具-main_hide-进入安全停止，因为ReduceSpace未定义 >>.\Log.txt
    cls
    title 安全停止
    echo.
    echo 出现了一些问题，我们无法获取U盘的剩余容量
    echo 此次停止为安全停止，目前您的启动盘已经可以正常启动，只是没法放置4GB以上的大文件
    echo 提交bug时请将本目录下的Log.txt一并提交
    echo.
    pause
    call main_exit.cmd
    exit
)
if %AllSpace:~0,-2%==0 (
    echo %time% 启动盘制作工具-main_hide-进入安全停止，因为AllSpace==0 >>.\Log.txt
    cls
    title 安全停止
    echo.
    echo 出现了一些问题，我们无法获取U盘的剩余容量
    echo 此次停止为安全停止，目前您的启动盘已经可以正常启动，只是没法放置4GB以上的大文件
    echo 提交bug时请将本目录下的Log.txt一并提交
    echo.
    pause
    call main_exit.cmd
    exit
)
if %ReduceSpace%==0 (
    echo %time% 启动盘制作工具-main_hide-进入安全停止，因为ReduceSpace==0 >>.\Log.txt
    cls
    title 安全停止
    echo.
    echo 出现了一些问题，我们无法获取U盘的剩余容量
    echo 此次停止为安全停止，目前您的启动盘已经可以正常启动，只是没法放置4GB以上的大文件
    echo 提交bug时请将本目录下的Log.txt一并提交
    echo.
    pause
    call main_exit.cmd
    exit
)
::自动进行算术验证
set /a Check = 800 + %ReduceSpace%
echo %time% 启动盘制作工具-main_hide-Check：%Check% >>.\Log.txt
if %Check% neq %AllSpace:~0,-2% (
    echo %time% 启动盘制作工具-main_hide-进入安全停止，因为Check不等于AllSpace >>.\Log.txt
    cls
    title 安全停止
    echo.
    echo 出现了一些问题，我们无法获取U盘的剩余容量
    echo 此次停止为安全停止，目前您的启动盘已经可以正常启动，只是没法放置4GB以上的大文件
    echo 提交bug时请将本目录下的Log.txt一并提交
    echo.
    pause
    call main_exit.cmd
    exit
)
echo 自动算术校验通过，开始缩减%PA_Part%盘分区，断电或拔出U盘可能导致物理损坏！
echo %time% 启动盘制作工具-main_hide-开始缩小分区 >>.\Log.txt
.\core\PartAssist_old\partassist.exe /hd:%uid% /resize:0 /reduce-right:%ReduceSpace%
echo %time% 启动盘制作工具-main_hide-结束缩小分区 >>.\Log.txt

::备份Edgeless文件夹
:checkEdgeless1
echo 开始备份Edgeless文件夹
echo %time% 启动盘制作工具-main_hide-开始备份Edgeless文件夹 >>.\Log.txt

:delEdgeless1
del /f /s /q .\Edgeless
rd /s /q .\Edgeless
if exist .\Edgeless (
    echo %time% 启动盘制作工具-main_hide-旧Edgeless文件夹删除失败 >>.\Log.txt
    cls
    echo 本目录的旧版Edgeless文件夹删除失败，请关闭安全软件后按任意键重试
    echo 如果依旧出现此提示，请手动将本目录内的Edgeless文件夹删除
    pause
    goto delEdgeless1
)
xcopy /s /r /y %EL_Part%:\Edgeless .\Edgeless\

if not exist .\Edgeless\version.txt (
    echo %time% 启动盘制作工具-main_hide-Edgeless文件夹备份失败 >>.\Log.txt
    cls
    echo Edgeless文件夹备份失败，请关闭安全软件后按任意键重试
    echo 如果依旧出现此提示，请手动将 %EL_Part%:\Edgeless 文件夹复制到此目录内
    pause
    goto checkEdgeless1
)
echo %time% 启动盘制作工具-main_hide-Edgeless文件夹备份完成，开始清除EFI分区中的Edgeless文件夹 >>.\Log.txt
echo 清除EFI分区中的Edgeless文件夹
del /f /s /q %EL_Part%:\Edgeless
rd /s /q %EL_Part%:\Edgeless

::设置EFI分区为活动分区
echo %time% 启动盘制作工具-main_hide-开始设置%EL_Part%分区为活动分区 >>.\Log.txt
echo 开始设置%EL_Part%分区为活动分区
echo 正在启动分区助手，请耐心等待...
.\core\PartAssist\partassist.exe /setact:%EL_Part%

::新建文件盘
:refreshLetter
echo %time% 启动盘制作工具-main_hide-开始新建文件盘 >>.\Log.txt
for %%k in (Z Y X W V U T S R Q P O N M L K J I H G F E D C ) do (
   if not exist %%k:\ (
        if not exist .\%%k echo %%k>FI_Part.txt
        )
)
set /p FI_Part=<FI_Part.txt
echo %time% 启动盘制作工具-main_hide-分配盘符（FI_Part）：%FI_Part% >>.\Log.txt
echo 开始建立新分区并分配%FI_Part%盘符
echo 正在启动分区助手，请耐心等待...
.\core\PartAssist\partassist.exe /hd:%uid% /cre /size:auto /fs:fat32 /align /label:文件盘 /letter:%FI_Part%
if not exist %FI_Part%:\ (
    echo %time% 启动盘制作工具-main_hide-找不到创建的新分区%FI_Part% >>.\Log.txt
    if exist .\MoreThanOnce echo %time% 启动盘制作工具-main_hide-第二次出现此情况，转至安全保护 >>.\Log.txt
    if exist .\MoreThanOnce goto safeProtection
    echo %time% 启动盘制作工具-main_hide-尝试自动切换盘符 >>.\Log.txt
    echo 文件分区创建失败，原因可能是空驱动器错误或缩小EFI分区未完成
    echo 正在尝试自动切换盘符
    md MoreThanOnce
    md %FI_Part%
    if exist FI_Part.txt del /f /q FI_Part.txt >nul
    goto refreshLetter
)
echo %time% 启动盘制作工具-main_hide-新分区创建成功 >>.\Log.txt

::格式化新分区为exFAT
echo 快速格式化%FI_Part%分区为exFAT文件系统
echo %time% 启动盘制作工具-main_hide-格式化新分区为exFAT >>.\Log.txt
format %FI_Part%: /FS:exFAT /V:文件盘 /Q /Y

::还原Edgeless文件夹
:checkEdgeless2
echo %time% 启动盘制作工具-main_hide-开始还原Edgeless文件夹 >>.\Log.txt
echo 还原Edgeless文件夹到%FI_Part%分区中
xcopy /s /r /y .\Edgeless %FI_Part%:\Edgeless\

if not exist  %FI_Part%:\Edgeless\version.txt (
    echo %time% 启动盘制作工具-main_hide-还原Edgeless文件夹失败 >>.\Log.txt
    cls
    echo Edgeless文件夹还原失败，请关闭安全软件后按任意键重试
    echo 如果依旧出现此提示，请手动将此目录内的 Edgeless 文件夹复制到 %FI_Part% 盘根目录
    pause
    goto checkEdgeless2
)
echo %time% 启动盘制作工具-main_hide-还原Edgeless文件夹成功，清除本地备份缓存 >>.\Log.txt
echo 清除本地Edgeless文件夹备份
del /f /s /q .\Edgeless
rd /s /q .\Edgeless

::完成任务
title 分区优化完成
echo %time% 启动盘制作工具-main_hide-完成任务 >>.\Log.txt
echo ==========================================================================
echo 分区优化任务完成，以下是本次任务的信息，报错时请提交此信息和此目录内的Log.txt
echo ELP：%EL_Part% PAP：%PA_Part% FIP：%FI_Part%
echo ==========================================================================
echo.
echo %time% 启动盘制作工具-main_hide-正常退出 >>.\Log.txt
goto endHide


:safeProtection
title 安全保护
echo %time% 启动盘制作工具-main_hide-进入安全保护，显示U盘分区情况，下列为PA的输出结果 >>.\Log.txt
.\core\PartAssist_old\partassist.exe /list:%uid% /out:.\UDiskInfo.txt
type .\UDiskInfo.txt >>.\UDiskInfo.txt
echo.
echo ==========================================================================
echo 检测到可能发生了错误，程序已自动停止操作并进入安全保护模式
echo 错误可能是由于以下原因导致的：
echo 1、第一步缩小分区未完成
echo 2、此电脑中存在两个及以上的空驱动器
echo 3、分区助手闪退
echo.
echo 本次停止操作为安全停止，理论上不会损坏U盘，如果U盘出现异常请尝试低级格式化
echo ==========================================================================
echo.
echo 按任意键尝试还原启动盘至初始状态
pause

::还原Edgeless文件夹
:checkEdgeless2
echo %time% 启动盘制作工具-main_hide-开始还原Edgeless文件夹 >>.\Log.txt
echo 还原Edgeless文件夹到%PA_Part%分区中
xcopy /s /r /y .\Edgeless %PA_Part%:\Edgeless\

if not exist  %PA_Part%:\Edgeless\version.txt (
    echo %time% 启动盘制作工具-main_hide-还原Edgeless文件夹失败 >>.\Log.txt
    cls
    echo Edgeless文件夹还原失败，可能出现了其他问题，建议进行低级格式化以保障U盘安全
    echo.
    echo.
    pause
)
echo 清除本地Edgeless文件夹备份
del /f /s /q .\Edgeless
rd /s /q .\Edgeless


echo %time% 启动盘制作工具-main_hide-在安全保护状态下退出 >>.\Log.txt
call main_exit.cmd
exit

:endHide