title 正在执行 免格升级/尝试修复
cd /d "%~dp0"
echo %time% 启动盘制作工具-main_update-被调用 >>.\Log.txt
cls
echo.
echo 同时插入多个U盘或USB存储设备可能导致操作异常！
echo 请弹出 非Edgeless启动盘 并按任意键继续
echo.
pause
set /p way=<update_way.txt
set /p u=<Upath.txt
echo %time% 启动盘制作工具-main_update-way：%way%，u：%u% >>.\Log.txt

for %%1 in (Z Y X W V U T S R Q P O N M L K J I H G F E D C) do if exist %%1:\sources\boot.wim echo %%1>Wimpath.txt
set /p wimpath=<Wimpath.txt
echo %time% 启动盘制作工具-main_update-查找boot.wim所在盘符：%wimpath% >>.\Log.txt

if not defined wimpath goto unHide
:ctnUpdate

echo %time% 启动盘制作工具-main_update-开始解压ISO >>.\Log.txt
call dash_checkrelease.cmd

::备份原文件
if defined hide echo %time% 启动盘制作工具-main_update-分区被隐藏，跳过备份 >>.\Log.txt
if defined hide goto skipBackup
echo %time% 启动盘制作工具-main_update-准备备份原文件 >>.\Log.txt
del /f /s /q .\backup
rd /s /q .\backup
if exist .\backup echo %time% 启动盘制作工具-main_update-删除旧备份失败 >>.\Log.txt
md backup
echo %time% 启动盘制作工具-main_update-开始备份Nes_Inport.7z >>.\Log.txt
copy /y %u%:\Edgeless\Nes_Inport.7z .\backup\Nes_Inport.7z
if %way% neq 1 echo %time% 启动盘制作工具-main_update-开始备份boot.wim >>.\Log.txt
if %way% neq 1 copy /y %wimpath%:\sources\boot.wim .\backup\boot.wim
copy /y %u%:\Edgeless\version.txt .\backup\version_backup.txt
echo %time% 启动盘制作工具-main_update-备份完成 >>.\Log.txt
:skipBackup

::取消EFI分区文件的系统级隐藏
if defined hide echo %time% 启动盘制作工具-main_update-分区被隐藏，跳过取消EFI分区文件的系统级隐藏 >>.\Log.txt
if defined hide goto skipSysUnHide
echo %time% 启动盘制作工具-main_update-开始取消EFI分区文件的系统级隐藏 >>.\Log.txt
attrib -s -a -h -r %wimpath%:\boot
attrib -s -a -h -r %wimpath%:\efi
attrib -s -a -h -r %wimpath%:\bootmgr
attrib -s -a -h -r %wimpath%:\bootmgr.efi
echo %time% 启动盘制作工具-main_update-完成取消EFI分区文件的系统级隐藏 >>.\Log.txt
:skipSysUnHide

::开始复制文件
echo %time% 启动盘制作工具-main_update-开始复制文件 >>.\Log.txt

if %way%==4 (
    echo %time% 启动盘制作工具-main_update-执行方法4 >>.\Log.txt
    echo %time% 启动盘制作工具-main_update-覆盖复制Edgeless文件夹 >>.\Log.txt
    md %u%:\Edgeless
    xcopy /s /r /y core\Release\Edgeless %u%:\Edgeless\
    echo %time% 启动盘制作工具-main_update-覆盖复制Edgeless文件夹完成 >>.\Log.txt
    if defined hide goto writeWim
    echo %time% 启动盘制作工具-main_update-覆盖复制其他组件 >>.\Log.txt
    xcopy /s /r /y core\Release\boot %wimpath%:\boot\
    xcopy /s /r /y core\Release\efi %wimpath%:\efi\
    xcopy /s /r /y core\Release\sources %wimpath%:\sources\
    xcopy /s /r /y core\Release\bootmgr %wimpath%:\
    xcopy /s /r /y core\Release\bootmgr.efi %wimpath%:\
    echo %time% 启动盘制作工具-main_update-覆盖复制其他组件完成 >>.\Log.txt
    echo %time% 启动盘制作工具-main_update-方法4执行完成 >>.\Log.txt
)

if %way%==3 (
    echo %time% 启动盘制作工具-main_update-执行方法3 >>.\Log.txt
    echo %time% 启动盘制作工具-main_update-覆盖复制Edgeless文件夹 >>.\Log.txt
    md %u%:\Edgeless
    xcopy /s /r /y core\Release\Edgeless %u%:\Edgeless\
    echo %time% 启动盘制作工具-main_update-覆盖复制Edgeless文件夹完成 >>.\Log.txt
    if defined hide goto writeWim
    :delCheck3
    del /f /q %wimpath%:\sources\boot.wim
    if exist %wimpath%:\sources\boot.wim (
        echo %time% 启动盘制作工具-main_update-boot.wim删除失败 >>.\Log.txt
        echo.
        echo 删除U盘目录中的%wimpath%:\sources\boot.wim失败，请将其手动删除后按任意键重试
        echo 如果您频繁收到此警告，请考虑是否有安全软件对U盘进行了写入保护或是正在尝试对只读挂载的ISO镜像进行升级
        echo.
        pause
        goto delCheck3
    )
    :copyCheck3Wim
    copy /y core\Release\sources\boot.wim %wimpath%:\sources\boot.wim
    if not exist %wimpath%:\sources\boot.wim (
        echo %time% 启动盘制作工具-main_update-boot.wim拷贝失败 >>.\Log.txt
        echo.
        echo 拷贝core\Release\sources\boot.wim至%wimpath%:\sources\boot.wim失败，请按任意键重试
        echo 如果您频繁收到此警告，请考虑是否有安全软件对U盘进行了写入保护或是正在尝试对只读挂载的ISO镜像进行升级
        echo.
        pause
        goto copyCheck3Wim
    )
    echo %time% 启动盘制作工具-main_update-方法3执行完成 >>.\Log.txt
)

if %way%==2 (
    echo %time% 启动盘制作工具-main_update-执行方法2 >>.\Log.txt
    echo %time% 启动盘制作工具-main_update-准备删除并拷贝Nes_Inport.7z >>.\Log.txt
    :delCheck2Nes
    del /f /q %u%:\Edgeless\Nes_Inport.7z
    if exist %u%:\Edgeless\Nes_Inport.7z (
        echo %time% 启动盘制作工具-main_update-Nes_Inport.7z删除失败 >>.\Log.txt
        echo.
        echo 删除U盘目录中的%u%:\Edgeless\Nes_Inport.7z失败，请将其手动删除后按任意键重试
        echo 如果您频繁收到此警告，请考虑是否有安全软件对U盘进行了写入保护或是正在尝试对只读挂载的ISO镜像进行升级
        echo.
        pause
        goto delCheck2Nes
    )
    :copyCheck2Nes
    copy /y core\Release\Edgeless\Nes_Inport.7z %u%:\Edgeless\Nes_Inport.7z
    if not exist %u%:\Edgeless\Nes_Inport.7z (
        echo %time% 启动盘制作工具-main_update-Nes_Inport.7z拷贝失败 >>.\Log.txt
        echo.
        echo 拷贝core\Release\sources\Nes_Inport.7z至%wimpath%:\sources\Nes_Inport.7z失败，请按任意键重试
        echo 如果您频繁收到此警告，请考虑是否有安全软件对U盘进行了写入保护或是正在尝试对只读挂载的ISO镜像进行升级
        echo.
        pause
        goto copyCheck2Nes
    )
    if defined hide goto writeWim
    :delCheck2Wim
    del /f /q %wimpath%:\sources\boot.wim
    if exist %wimpath%:\sources\boot.wim (
        echo %time% 启动盘制作工具-main_update-boot.wim删除失败 >>.\Log.txt
        echo.
        echo 删除U盘目录中的%wimpath%:\sources\boot.wim失败，请将其手动删除后按任意键重试
        echo 如果您频繁收到此警告，请考虑是否有安全软件对U盘进行了写入保护或是正在尝试对只读挂载的ISO镜像进行升级
        echo.
        pause
        goto delCheck2Wim
    )
    :copyCheck2Wim
    copy /y core\Release\sources\boot.wim %wimpath%:\sources\boot.wim
    if not exist %wimpath%:\sources\boot.wim (
        echo %time% 启动盘制作工具-main_update-boot.wim拷贝失败 >>.\Log.txt
        echo.
        echo 拷贝core\Release\sources\boot.wim至%wimpath%:\sources\boot.wim失败，请按任意键重试
        echo 如果您频繁收到此警告，请考虑是否有安全软件对U盘进行了写入保护或是正在尝试对只读挂载的ISO镜像进行升级
        echo.
        pause
        goto copyCheck2Wim
    )
    echo %time% 启动盘制作工具-main_update-方法2执行完成 >>.\Log.txt
)

if %way%==1 (
    echo %time% 启动盘制作工具-main_update-执行方法1 >>.\Log.txt
    :delCheck1
    del /f /q %u%:\Edgeless\Nes_Inport.7z
    if exist %u%:\Edgeless\Nes_Inport.7z (
        echo %time% 启动盘制作工具-main_update-Nes_Inport.7z删除失败 >>.\Log.txt
        echo.
        echo 删除U盘目录中的%u%:\Edgeless\Nes_Inport.7z失败，请将其手动删除后按任意键重试
        echo 如果您频繁收到此警告，请考虑是否有安全软件对U盘进行了写入保护或是正在尝试对只读挂载的ISO镜像进行升级
        echo.
        pause
        goto delCheck1
    )
    :copyCheck1Nes
    copy /y core\Release\Edgeless\Nes_Inport.7z %u%:\Edgeless\Nes_Inport.7z
    if not exist %u%:\Edgeless\Nes_Inport.7z (
        echo %time% 启动盘制作工具-main_update-Nes_Inport.7z拷贝失败 >>.\Log.txt
        echo.
        echo 拷贝core\Release\sources\Nes_Inport.7z至%wimpath%:\sources\Nes_Inport.7z失败，请按任意键重试
        echo 如果您频繁收到此警告，请考虑是否有安全软件对U盘进行了写入保护或是正在尝试对只读挂载的ISO镜像进行升级
        echo.
        pause
        goto copyCheck1Nes
    )
    echo %time% 启动盘制作工具-main_update-方法1执行完成 >>.\Log.txt
)
:endCopyFile
if defined hide echo %time% 启动盘制作工具-main_update-向隐藏分区写入boot.wim成功 >>.\Log.txt
::更新版本信息文件
:delCheck0
del /f /q %u%:\Edgeless\version.txt
if exist %u%:\Edgeless\version.txt (
    echo %time% 启动盘制作工具-main_update-删除U盘的version.txt失败 >>.\Log.txt
    echo.
    echo 删除U盘目录中的%u%:\Edgeless\version.txt失败，请将其手动删除后按任意键重试
    echo 如果您频繁收到此警告，请考虑是否有安全软件对U盘进行了写入保护或是正在尝试对只读挂载的ISO镜像进行升级
    echo.
    pause
    goto delCheck0
)
:copyCheck0
copy /y core\version_ol.txt %u%:\Edgeless\version.txt
if not exist %u%:\Edgeless\version.txt (
    echo %time% 启动盘制作工具-main_update-拷贝version.txt至U盘失败 >>.\Log.txt
    echo.
    echo 复制 core\version_ol.txt 到 %u%:\Edgeless\version.txt失败，请按任意键重试
    echo 如果您频繁收到此警告，请考虑是否有安全软件对U盘进行了写入保护或是正在尝试对只读挂载的ISO镜像进行升级
    echo.
    pause
    goto copyCheck0
)
echo %time% 启动盘制作工具-main_update-操作完成 >>.\Log.txt
title 免格更新/尝试修复 完成
echo =======================================
echo        免格更新/尝试修复 操作完成！
echo =======================================
echo.
if not defined hide echo 旧版本文件已备份至此目录的backup文件夹中
echo.
pause
echo %time% 启动盘制作工具-main_update-正常退出 >>.\Log.txt
call main_exit.cmd
exit






:unHide
echo %time% 启动盘制作工具-main_update-查找boot.wim失败，准备读取uid进行隐藏写入 >>.\Log.txt
set hide=1
echo 您的U盘可能使用了分区优化方案，准备读取uid进行隐藏写入

::检索uid
echo %time% 启动盘制作工具-main_update-开始检索uid，下列为PA的输出结果 >>.\Log.txt
echo 正在查找设备
if exist .\Usee0.txt del /f /q .\Usee0.txt >nul
echo 正在启动分区助手，请耐心等待...
.\core\PartAssist\partassist.exe /list /usb /out:.\Usee0.txt
type Usee0.txt >>.\Log.txt
for %%j in (1 2 3 4 5 6 7 8 9 10 11 12) DO (find  /i "%%j	|" .\Usee0.txt>nul&&SET uid=%%j)
echo %time% 启动盘制作工具-main_update-uid：%uid% >>.\Log.txt
if exist .\Usee0.txt del /f /q .\Usee0.txt >nul
if not defined uid (
    echo %time% 启动盘制作工具-main_update-uid未定义，程序退出 >>.\Log.txt
    cls
    echo 出现了奇怪的错误！
    echo Edgeless文件夹所在分区：%u%
    echo PartAssist查找的启动盘：uid未定义
    pause
    call main_exit.cmd
    exit
)
echo %time% 启动盘制作工具-main_update-读取uid操作完成 >>.\Log.txt
goto ctnUpdate


:writeWim
echo %time% 启动盘制作工具-main_update-开始删除旧版boot.wim >>.\Log.txt
echo 正在删除旧版boot.wim
::删除boot.wim
.\core\PartAssist_old\partassist.exe /hd:%uid% /whide:1 /delfiles /dest:sources\boot.wim
echo %time% 启动盘制作工具-main_update-开始写入boot.wim >>.\Log.txt
echo 正在向隐藏分区写入boot.wim
::写入boot.wim
if exist %~d0\boot.wim del /f /q %~d0\boot.wim
:resmove
move /y .\core\Release\sources\boot.wim %~d0\
if not exist %~d0\boot.wim (
    echo %time% 启动盘制作工具-main_update-移动boot.wim至根目录失败 >>.\Log.txt
    echo ==================================================================================================
    echo 移动boot.wim到%~d0盘根目录失败，请手动将core\Release\sources\boot.wim移动到%~d0盘根目录，然后按任意键
    echo ==================================================================================================
    echo.
    pause
    echo %time% 启动盘制作工具-main_update-用户选择重试 >>.\Log.txt
    if not exist %~d0\boot.wim goto resmove
)
.\core\PartAssist_old\partassist.exe /hd:%uid% /whide:1 /src:%~d0\boot.wim /dest:sources





move /y %~d0\boot.wim .\core\Release\sources\
goto endCopyFile
::此处的校验废弃，原因是分区助手的校验总是失败
echo %time% 启动盘制作工具-main_update-开始校验写入，下列为PA的输出结果 >>.\Log.txt
echo 正在校验文件写入情况
::校验文件
.\core\PartAssist_old\partassist.exe /hd:%uid% /whide:1 /src:%~d0\boot.wim /dest:sources /verify /out:.\verify.txt
move /y %~d0\boot.wim .\core\Release\sources\
if not exist verify.txt (
    echo %time% 启动盘制作工具-main_update-verify.txt生成失败，跳过校验 >>.\Log.txt
    goto endCopyFile
)
type .\verify.txt >>.\Log.txt
find /I "Success" .\verify.txt
if "%errorlevel%"=="0" goto endCopyFile
echo %time% 启动盘制作工具-main_update-校验失败 >>.\Log.txt
echo ===============================================================================
echo 复制boot.wim到隐藏分区失败，请尽可能关闭其他软件并退出安全软件，然后按任意键重试
echo ===============================================================================
echo.
pause
echo %time% 启动盘制作工具-main_update-用户选择重试 >>.\Log.txt
goto writeWim