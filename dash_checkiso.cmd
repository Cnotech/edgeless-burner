title ����У�龵���ļ�
echo %time% ��������������-dash_checkiso-�����ã�������version_ol.txt >>.\Log.txt
call net_getversion.cmd
if not exist core\version_iso.txt echo %time% ��������������-dash_checkiso-������version_iso.txt��׼������ >>.\Log.txt
if not exist core\version_iso.txt goto downit
if not exist core\Edgeless.iso echo %time% ��������������-dash_checkiso-������Edgeless.iso��׼������ >>.\Log.txt
if not exist core\Edgeless.iso goto downit
if exist core\version_iso.txt set /p version_iso=<core\version_iso.txt
if exist core\version_iso.txt echo %time% ��������������-dash_checkiso-version_iso��%version_iso% >>.\Log.txt
set /p version_ol=<core\version_ol.txt
if not defined version_ol echo %time% ��������������-dash_checkiso-version_ol��ȡʧ�� >>.\Log.txt
if not defined version_ol call net_checknet.cmd
echo %time% ��������������-dash_checkiso-version_ol��%version_ol% >>.\Log.txt
if %version_iso%==%version_ol% echo %time% ��������������-dash_checkiso-���ؾ����������°汾��%version_iso%�� >>.\Log.txt
if %version_iso%==%version_ol% goto exi

:downit
echo %time% ��������������-dash_checkiso-������ʼ����Edgeless����%version_ol%�� >>.\Log.txt
title ������ʼ����Edgeless����
cls
echo.
echo.
echo         δ��⵽���þ����ļ�����У����Ϣȱʧ
echo.
echo     ������ʼ����Edgeless�����������Ҫ��رմ���
echo.
echo.
echo.
timeout 5
echo %time% ��������������-dash_checkiso-5s�ȴ�ȷ�Ͻ�������ʼ����Edgeless���� >>.\Log.txt
call net_downloadiso.cmd

:exi
echo %time% ��������������-dash_checkiso-�˳� >>.\Log.txt