title ���ڱȶ�U����Ϣ
echo %time% ��������������-dash_checkusb-������ >>.\Log.txt
:checkusb_home
set /p u=<"%~dp0Upath.txt"
set /p version_ol=<"%~dp0core\version_ol.txt"
set /p version_usb=<"%u%:\Edgeless\version.txt"
echo %time% ��������������-dash_checkusb-��ȡ��Ϣ��Upath��%u%��version_ol��%version_ol%��version_usb��%version_usb% >>.\Log.txt
if %version_ol%==%version_usb% goto newest
echo %time% ��������������-dash_checkusb-U�̵�Edgeless�ɸ��� >>.\Log.txt
title �п��õ�Edgeless����
cls
echo.
echo      ����%u%�̿ɸ���Edgeless
echo.
echo   ��ǰ�汾��%version_usb%
echo   ���°汾��%version_ol%
echo =========================================
echo.
echo.
echo   ��1�������£��Ƽ���    ��2��ȫ������
echo.
echo.
echo.
set /p cho=��������Ų��س���
if %cho%==2 (
    echo %time% ��������������-dash_checkusb-�û�ѡ��ȫ������ >>.\Log.txt
    call dash_checkiso.cmd
    call main_askway.cmd
    call main_exit.cmd
    exit
)
if %cho%==1 (
    echo %time% ��������������-dash_checkusb-�û�ѡ�������£����·�ʽ��%version_ol:~-1,1% >>.\Log.txt
    call dash_checkiso.cmd
    echo %version_ol:~-1,1% >update_way.txt
    call main_update.cmd
    call main_exit.cmd
    exit
)
goto checkusb_home




:newest
echo %time% ��������������-dash_checkusb-U�̵�Edgeless�������°汾 >>.\Log.txt
title �������°汾
cls
echo.
echo.
echo.
echo  ��ϲ��%u%�̵�Edgeless�������°汾��
echo =========================================
echo �汾��Ϣ��
echo �����汾�ţ�%version_ol%
echo ϵͳ���ƣ�%version_ol:~0,8%
echo �������ͣ�%version_ol:~9,4%
echo ���а汾��%version_ol:~14,5%
echo �汾��ţ�%version_ol:~20,5%
echo =========================================
echo.
echo.
echo.
echo    ������������������˹��ϣ��볢���޸�
echo.
echo  ��1�������޸����Ƽ���       ��2��ȫ������
echo.
echo.
set /p cho=��������Ų��س���
if %cho%==2 (
    echo %time% ��������������-dash_checkusb-�û�ѡ��ȫ������ >>.\Log.txt
    call dash_checkiso.cmd
    call main_askway.cmd
    call main_exit.cmd
    exit
)
if %cho%==1 (
    echo %time% ��������������-dash_checkusb-�û�ѡ�����޸� >>.\Log.txt
    call dash_checkiso.cmd
    echo 4 >update_way.txt
    call main_update.cmd
    call main_exit.cmd
    exit
)
goto newest