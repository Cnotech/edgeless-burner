title ���ڻ�ȡ�汾��Ϣ
cd /d "%~dp0"
echo %time% ��������������-net_getversion-������ >>.\Log.txt
::if not exist .\core\version_ol.txt core\EasyDown\EasyDown.exe -Down("http://s.edgeless.top/?token=version","version_ol.txt","%~dp0core")
if not exist .\core\version_ol.txt call net_api version version_ol.txt a
if not exist .\core\version_ol.txt call net_checknet.cmd
echo %time% ��������������-net_getversion-���سɹ���������� >>.\Log.txt