title 正在获取版本信息
cd /d "%~dp0"
echo %time% 启动盘制作工具-net_getversion-被调用 >>.\Log.txt
::if not exist .\core\version_ol.txt core\EasyDown\EasyDown.exe -Down("http://s.edgeless.top/?token=version","version_ol.txt","%~dp0core")
if not exist .\core\version_ol.txt call net_api version version_ol.txt a
if not exist .\core\version_ol.txt call net_checknet.cmd
echo %time% 启动盘制作工具-net_getversion-下载成功，任务完成 >>.\Log.txt