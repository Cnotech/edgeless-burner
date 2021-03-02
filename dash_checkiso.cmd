title 正在校验镜像文件
echo %time% 启动盘制作工具-dash_checkiso-被调用，先下载version_ol.txt >>.\Log.txt
call net_getversion.cmd
if not exist core\version_iso.txt echo %time% 启动盘制作工具-dash_checkiso-不存在version_iso.txt，准备下载 >>.\Log.txt
if not exist core\version_iso.txt goto downit
if not exist core\Edgeless.iso echo %time% 启动盘制作工具-dash_checkiso-不存在Edgeless.iso，准备下载 >>.\Log.txt
if not exist core\Edgeless.iso goto downit
if exist core\version_iso.txt set /p version_iso=<core\version_iso.txt
if exist core\version_iso.txt echo %time% 启动盘制作工具-dash_checkiso-version_iso：%version_iso% >>.\Log.txt
set /p version_ol=<core\version_ol.txt
if not defined version_ol echo %time% 启动盘制作工具-dash_checkiso-version_ol获取失败 >>.\Log.txt
if not defined version_ol call net_checknet.cmd
echo %time% 启动盘制作工具-dash_checkiso-version_ol：%version_ol% >>.\Log.txt
if %version_iso%==%version_ol% echo %time% 启动盘制作工具-dash_checkiso-本地镜像已是最新版本（%version_iso%） >>.\Log.txt
if %version_iso%==%version_ol% goto exi

:downit
echo %time% 启动盘制作工具-dash_checkiso-即将开始下载Edgeless镜像（%version_ol%） >>.\Log.txt
title 即将开始下载Edgeless镜像
cls
echo.
echo.
echo         未检测到可用镜像文件或镜像校验信息缺失
echo.
echo     即将开始下载Edgeless镜像，如果不需要请关闭窗口
echo.
echo.
echo.
timeout 5
echo %time% 启动盘制作工具-dash_checkiso-5s等待确认结束，开始下载Edgeless镜像 >>.\Log.txt
call net_downloadiso.cmd

:exi
echo %time% 启动盘制作工具-dash_checkiso-退出 >>.\Log.txt