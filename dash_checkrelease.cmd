title 正在解压ISO
cd /d "%~dp0"
echo %time% 启动盘制作工具-dash_checkrelease-被调用 >>.\Log.txt
::解压ISO
echo %time% 启动盘制作工具-dash_checkrelease-准备解压ISO >>.\Log.txt
if exist .\core\version_release.txt set /p version_release=<.\core\version_release.txt
:reRead
set /p version_iso=<.\core\version_iso.txt
echo %time% 启动盘制作工具-dash_checkrelease-version_release：%version_release%，version_iso：%version_iso% >>.\Log.txt
if not defined version_iso (
    echo %time% 启动盘制作工具-dash_checkrelease-version_iso参数为空，等待用户操作 >>.\Log.txt
    cls
    echo.
    echo 我们遇到了奇怪的错误：镜像校验文件似乎缺失了，但是程序的自检程序已被通过
    echo 如果您确定没有进行私自操作，请检查core文件夹，将version_ol.txt重命名为version_iso.txt并按任意键
    echo 如果您愿意报告错误，请将Log.txt提交至内测群
    echo.
    pause
    goto reRead
    echo %time% 启动盘制作工具-dash_checkrelease-用户尝试了重试 >>.\Log.txt
)
if defined version_release (
    if %version_iso%==%version_release% echo %time% 启动盘制作工具-dash_checkrelease-版本号相同，跳过解压 >>.\Log.txt
    if %version_iso%==%version_release% goto skipRelease
    echo %time% 启动盘制作工具-dash_checkrelease-版本号不同，继续解压 >>.\Log.txt
)
echo %time% 启动盘制作工具-dash_checkrelease-删除解压缓存 >>.\Log.txt
del /f /s /q core\Release
rd /s /q core\Release
if exist .\core\Release echo %time% 启动盘制作工具-dash_checkrelease-删除解压缓存失败 >>.\Log.txt
md .\core\Release
echo %time% 启动盘制作工具-dash_checkrelease-开始解压 >>.\Log.txt
::core\7-Zip\7z.exe x core\Edgeless.iso -ocore\Release -aoa
.\core\ultraiso\ultraiso -input .\core\Edgeless.iso -extract .\core\Release
echo %time% 启动盘制作工具-dash_checkrelease-解压完成 >>.\Log.txt
if exist core\version_release.txt del /f /q core\version_release.txt
copy /y core\version_iso.txt core\version_release.txt
:skipRelease