title ���ڼ�������������
cd /d "%~dp0"
echo %time% ��������������-net_checknet-������ >>.\Log.txt
ping cloud.tencent.com
if %errorlevel%==1 goto nonet
echo %time% ��������������-net_checknet-Edgeless����������Ӧ >>.\Log.txt
title Edgeless����������Ӧ
cls
echo.
echo.
echo.
echo                 ����ʧ�ܣ�Edgeless����������Ӧ
echo                   ����ϵ���߽����������Ժ�����
echo.
echo        ���ϣ��ʹ������ģʽ���������̣���ο��������ļ�.txt��
echo.
echo.
if not exist core\version_iso.txt (
    echo %time% ��������������-net_checknet-������version_iso.txt�������ٽ��˳� >>.\Log.txt
    pause
    call main_exit.cmd
    exit
)
goto offline


:nonet
title �޷�������������
echo %time% ��������������-net_checknet-�޷������������� >>.\Log.txt
cls
echo.
echo.
echo.
echo               ����ʧ�ܣ���ǰϵͳδ���뻥����
echo.
echo     ���ϣ��ʹ������ģʽ���������̣���ο��������ļ�.txt��
echo.
echo.
echo.
if not exist core\version_iso.txt (
    echo %time% ��������������-net_checknet-������version_iso.txt�������ٽ��˳� >>.\Log.txt
    pause
    call main_exit.cmd
    exit
)



:offline
echo %time% ��������������-net_checknet-����version_iso.txt����ʾʹ�� >>.\Log.txt
set /p version_iso=<core\version_iso.txt
if not defined version_iso (
    echo %time% ��������������-net_checknet-version_isoδ���壬�����ٽ��˳� >>.\Log.txt
    del /f /q .\core\Edgeless.iso >nul
    pause
    call main_exit.cmd
    exit
)
echo       ===============================
echo       ��⵽���߾����ļ����Ƿ�ʹ�ã�
echo       ����汾��%version_iso%
echo       ===============================
echo.
echo.
echo          ��1����         ��2����
set /p cho=��������Ų��س���
if %cho%==2 (
    echo %time% ��������������-net_checknet-�û�ȡ��ʹ�����߾��� >>.\Log.txt
    call main_exit.cmd
    exit
)
echo %time% ��������������-net_checknet-�û�ѡ��ʹ�����߾��� >>.\Log.txt
call main_askway.cmd
call main_exit.cmd
exit