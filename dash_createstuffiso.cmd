cd /d "%~dp0"
echo %time% 启动盘制作工具-dash_createstuffiso-被调用 >>.\Log.txt
::读取已有填充ISO的版本信息
if not exist .\core\version_stuff.txt goto skipReadVersion
set /p version_stuff=<.\core\version_stuff.txt
set /p version_iso=<.\core\version_iso.txt
echo %time% 启动盘制作工具-dash_createstuffiso-比较填充版本，version_stuff=%version_stuff%，version_iso=%version_iso% >>.\Log.txt
if not defined version_stuff goto skipReadVersion
if not defined version_iso (
    echo %time% 启动盘制作工具-dash_createstuffiso-严重的错误：version_iso未定义，程序提前退出 >>.\Log.txt
    echo ===============================================
    echo 错误：ISO版本信息缺失，请重新运行程序完成下载
    echo ===============================================
    pause
    call main_exit.cmd
    exit
)
if %version_stuff%==%version_iso% (
    echo %time% 启动盘制作工具-dash_createstuffiso-填充版本已是最新版本 >>.\Log.txt
    goto endStuff
)
:skipReadVersion
::创建填充文件
if exist .\stu\stuff.zip goto skipCreateStuff
echo %time% 启动盘制作工具-dash_createstuffiso-开始创建填充文件 >>.\Log.txt
fsutil file createnew stuff.zip 209715200
md stu
move /y stuff.zip stu
:skipCreateStuff
if not exist .\stu\stuff.zip (
    echo %time% 启动盘制作工具-dash_createstuffiso-填充文件生成失败，提前退出 >>.\Log.txt
    echo ===============================================
    echo 错误：stuff.zip生成失败，请尝试使用其他写入方式
    echo ===============================================
    pause
    call main_exit.cmd
    exit
)
echo %time% 启动盘制作工具-dash_createstuffiso-填充文件准备完成，开始添加到ISO中 >>.\Log.txt

if exist Edgeless_stuff.iso del /f /q Edgeless_stuff.iso >nul
.\core\ultraiso\ultraiso -input .\core\Edgeless.iso -directory stu -output .\core\Edgeless_stuff.iso
if exist .\core\Edgeless_stuff.iso (
    if exist .\core\version_stuff.txt del /f /q .\core\version_stuff.txt >nul
    copy /y .\core\version_iso.txt .\core\version_stuff.txt
    if not exist .\core\version_stuff.txt echo %time% 启动盘制作工具-dash_createstuffiso-version_stuff.txt创建失败 >>.\Log.txt
    echo %time% 启动盘制作工具-dash_createstuffiso-ISO生成完毕，正常退出 >>.\Log.txt
)
if not exist .\core\Edgeless_stuff.iso (
    echo %time% 启动盘制作工具-dash_createstuffiso-ISO生成失败，提前退出 >>.\Log.txt
    echo ======================================================
    echo 错误：Edgeless_stuff.iso生成失败，请尝试使用其他写入方式
    echo ======================================================
    pause
    call main_exit.cmd
    exit
)

:endStuff
echo %time% 启动盘制作工具-dash_createstuffiso-任务完成 >>.\Log.txt