title ����ִ�� �������/�����޸�
cd /d "%~dp0"
echo %time% ��������������-main_update-������ >>.\Log.txt
cls
echo.
echo ͬʱ������U�̻�USB�洢�豸���ܵ��²����쳣��
echo �뵯�� ��Edgeless������ �������������
echo.
pause
set /p way=<update_way.txt
set /p u=<Upath.txt
echo %time% ��������������-main_update-way��%way%��u��%u% >>.\Log.txt

for %%1 in (Z Y X W V U T S R Q P O N M L K J I H G F E D C) do if exist %%1:\sources\boot.wim echo %%1>Wimpath.txt
set /p wimpath=<Wimpath.txt
echo %time% ��������������-main_update-����boot.wim�����̷���%wimpath% >>.\Log.txt

if not defined wimpath goto unHide
:ctnUpdate

echo %time% ��������������-main_update-��ʼ��ѹISO >>.\Log.txt
call dash_checkrelease.cmd

::����ԭ�ļ�
if defined hide echo %time% ��������������-main_update-���������أ��������� >>.\Log.txt
if defined hide goto skipBackup
echo %time% ��������������-main_update-׼������ԭ�ļ� >>.\Log.txt
del /f /s /q .\backup
rd /s /q .\backup
if exist .\backup echo %time% ��������������-main_update-ɾ���ɱ���ʧ�� >>.\Log.txt
md backup
echo %time% ��������������-main_update-��ʼ����Nes_Inport.7z >>.\Log.txt
copy /y %u%:\Edgeless\Nes_Inport.7z .\backup\Nes_Inport.7z
if %way% neq 1 echo %time% ��������������-main_update-��ʼ����boot.wim >>.\Log.txt
if %way% neq 1 copy /y %wimpath%:\sources\boot.wim .\backup\boot.wim
copy /y %u%:\Edgeless\version.txt .\backup\version_backup.txt
echo %time% ��������������-main_update-������� >>.\Log.txt
:skipBackup

::ȡ��EFI�����ļ���ϵͳ������
if defined hide echo %time% ��������������-main_update-���������أ�����ȡ��EFI�����ļ���ϵͳ������ >>.\Log.txt
if defined hide goto skipSysUnHide
echo %time% ��������������-main_update-��ʼȡ��EFI�����ļ���ϵͳ������ >>.\Log.txt
attrib -s -a -h -r %wimpath%:\boot
attrib -s -a -h -r %wimpath%:\efi
attrib -s -a -h -r %wimpath%:\bootmgr
attrib -s -a -h -r %wimpath%:\bootmgr.efi
echo %time% ��������������-main_update-���ȡ��EFI�����ļ���ϵͳ������ >>.\Log.txt
:skipSysUnHide

::��ʼ�����ļ�
echo %time% ��������������-main_update-��ʼ�����ļ� >>.\Log.txt

if %way%==4 (
    echo %time% ��������������-main_update-ִ�з���4 >>.\Log.txt
    echo %time% ��������������-main_update-���Ǹ���Edgeless�ļ��� >>.\Log.txt
    md %u%:\Edgeless
    xcopy /s /r /y core\Release\Edgeless %u%:\Edgeless\
    echo %time% ��������������-main_update-���Ǹ���Edgeless�ļ������ >>.\Log.txt
    if defined hide goto writeWim
    echo %time% ��������������-main_update-���Ǹ���������� >>.\Log.txt
    xcopy /s /r /y core\Release\boot %wimpath%:\boot\
    xcopy /s /r /y core\Release\efi %wimpath%:\efi\
    xcopy /s /r /y core\Release\sources %wimpath%:\sources\
    xcopy /s /r /y core\Release\bootmgr %wimpath%:\
    xcopy /s /r /y core\Release\bootmgr.efi %wimpath%:\
    echo %time% ��������������-main_update-���Ǹ������������� >>.\Log.txt
    echo %time% ��������������-main_update-����4ִ����� >>.\Log.txt
)

if %way%==3 (
    echo %time% ��������������-main_update-ִ�з���3 >>.\Log.txt
    echo %time% ��������������-main_update-���Ǹ���Edgeless�ļ��� >>.\Log.txt
    md %u%:\Edgeless
    xcopy /s /r /y core\Release\Edgeless %u%:\Edgeless\
    echo %time% ��������������-main_update-���Ǹ���Edgeless�ļ������ >>.\Log.txt
    if defined hide goto writeWim
    :delCheck3
    del /f /q %wimpath%:\sources\boot.wim
    if exist %wimpath%:\sources\boot.wim (
        echo %time% ��������������-main_update-boot.wimɾ��ʧ�� >>.\Log.txt
        echo.
        echo ɾ��U��Ŀ¼�е�%wimpath%:\sources\boot.wimʧ�ܣ��뽫���ֶ�ɾ�������������
        echo �����Ƶ���յ��˾��棬�뿼���Ƿ��а�ȫ�����U�̽�����д�뱣���������ڳ��Զ�ֻ�����ص�ISO�����������
        echo.
        pause
        goto delCheck3
    )
    :copyCheck3Wim
    copy /y core\Release\sources\boot.wim %wimpath%:\sources\boot.wim
    if not exist %wimpath%:\sources\boot.wim (
        echo %time% ��������������-main_update-boot.wim����ʧ�� >>.\Log.txt
        echo.
        echo ����core\Release\sources\boot.wim��%wimpath%:\sources\boot.wimʧ�ܣ��밴���������
        echo �����Ƶ���յ��˾��棬�뿼���Ƿ��а�ȫ�����U�̽�����д�뱣���������ڳ��Զ�ֻ�����ص�ISO�����������
        echo.
        pause
        goto copyCheck3Wim
    )
    echo %time% ��������������-main_update-����3ִ����� >>.\Log.txt
)

if %way%==2 (
    echo %time% ��������������-main_update-ִ�з���2 >>.\Log.txt
    echo %time% ��������������-main_update-׼��ɾ��������Nes_Inport.7z >>.\Log.txt
    :delCheck2Nes
    del /f /q %u%:\Edgeless\Nes_Inport.7z
    if exist %u%:\Edgeless\Nes_Inport.7z (
        echo %time% ��������������-main_update-Nes_Inport.7zɾ��ʧ�� >>.\Log.txt
        echo.
        echo ɾ��U��Ŀ¼�е�%u%:\Edgeless\Nes_Inport.7zʧ�ܣ��뽫���ֶ�ɾ�������������
        echo �����Ƶ���յ��˾��棬�뿼���Ƿ��а�ȫ�����U�̽�����д�뱣���������ڳ��Զ�ֻ�����ص�ISO�����������
        echo.
        pause
        goto delCheck2Nes
    )
    :copyCheck2Nes
    copy /y core\Release\Edgeless\Nes_Inport.7z %u%:\Edgeless\Nes_Inport.7z
    if not exist %u%:\Edgeless\Nes_Inport.7z (
        echo %time% ��������������-main_update-Nes_Inport.7z����ʧ�� >>.\Log.txt
        echo.
        echo ����core\Release\sources\Nes_Inport.7z��%wimpath%:\sources\Nes_Inport.7zʧ�ܣ��밴���������
        echo �����Ƶ���յ��˾��棬�뿼���Ƿ��а�ȫ�����U�̽�����д�뱣���������ڳ��Զ�ֻ�����ص�ISO�����������
        echo.
        pause
        goto copyCheck2Nes
    )
    if defined hide goto writeWim
    :delCheck2Wim
    del /f /q %wimpath%:\sources\boot.wim
    if exist %wimpath%:\sources\boot.wim (
        echo %time% ��������������-main_update-boot.wimɾ��ʧ�� >>.\Log.txt
        echo.
        echo ɾ��U��Ŀ¼�е�%wimpath%:\sources\boot.wimʧ�ܣ��뽫���ֶ�ɾ�������������
        echo �����Ƶ���յ��˾��棬�뿼���Ƿ��а�ȫ�����U�̽�����д�뱣���������ڳ��Զ�ֻ�����ص�ISO�����������
        echo.
        pause
        goto delCheck2Wim
    )
    :copyCheck2Wim
    copy /y core\Release\sources\boot.wim %wimpath%:\sources\boot.wim
    if not exist %wimpath%:\sources\boot.wim (
        echo %time% ��������������-main_update-boot.wim����ʧ�� >>.\Log.txt
        echo.
        echo ����core\Release\sources\boot.wim��%wimpath%:\sources\boot.wimʧ�ܣ��밴���������
        echo �����Ƶ���յ��˾��棬�뿼���Ƿ��а�ȫ�����U�̽�����д�뱣���������ڳ��Զ�ֻ�����ص�ISO�����������
        echo.
        pause
        goto copyCheck2Wim
    )
    echo %time% ��������������-main_update-����2ִ����� >>.\Log.txt
)

if %way%==1 (
    echo %time% ��������������-main_update-ִ�з���1 >>.\Log.txt
    :delCheck1
    del /f /q %u%:\Edgeless\Nes_Inport.7z
    if exist %u%:\Edgeless\Nes_Inport.7z (
        echo %time% ��������������-main_update-Nes_Inport.7zɾ��ʧ�� >>.\Log.txt
        echo.
        echo ɾ��U��Ŀ¼�е�%u%:\Edgeless\Nes_Inport.7zʧ�ܣ��뽫���ֶ�ɾ�������������
        echo �����Ƶ���յ��˾��棬�뿼���Ƿ��а�ȫ�����U�̽�����д�뱣���������ڳ��Զ�ֻ�����ص�ISO�����������
        echo.
        pause
        goto delCheck1
    )
    :copyCheck1Nes
    copy /y core\Release\Edgeless\Nes_Inport.7z %u%:\Edgeless\Nes_Inport.7z
    if not exist %u%:\Edgeless\Nes_Inport.7z (
        echo %time% ��������������-main_update-Nes_Inport.7z����ʧ�� >>.\Log.txt
        echo.
        echo ����core\Release\sources\Nes_Inport.7z��%wimpath%:\sources\Nes_Inport.7zʧ�ܣ��밴���������
        echo �����Ƶ���յ��˾��棬�뿼���Ƿ��а�ȫ�����U�̽�����д�뱣���������ڳ��Զ�ֻ�����ص�ISO�����������
        echo.
        pause
        goto copyCheck1Nes
    )
    echo %time% ��������������-main_update-����1ִ����� >>.\Log.txt
)
:endCopyFile
if defined hide echo %time% ��������������-main_update-�����ط���д��boot.wim�ɹ� >>.\Log.txt
::���°汾��Ϣ�ļ�
:delCheck0
del /f /q %u%:\Edgeless\version.txt
if exist %u%:\Edgeless\version.txt (
    echo %time% ��������������-main_update-ɾ��U�̵�version.txtʧ�� >>.\Log.txt
    echo.
    echo ɾ��U��Ŀ¼�е�%u%:\Edgeless\version.txtʧ�ܣ��뽫���ֶ�ɾ�������������
    echo �����Ƶ���յ��˾��棬�뿼���Ƿ��а�ȫ�����U�̽�����д�뱣���������ڳ��Զ�ֻ�����ص�ISO�����������
    echo.
    pause
    goto delCheck0
)
:copyCheck0
copy /y core\version_ol.txt %u%:\Edgeless\version.txt
if not exist %u%:\Edgeless\version.txt (
    echo %time% ��������������-main_update-����version.txt��U��ʧ�� >>.\Log.txt
    echo.
    echo ���� core\version_ol.txt �� %u%:\Edgeless\version.txtʧ�ܣ��밴���������
    echo �����Ƶ���յ��˾��棬�뿼���Ƿ��а�ȫ�����U�̽�����д�뱣���������ڳ��Զ�ֻ�����ص�ISO�����������
    echo.
    pause
    goto copyCheck0
)
echo %time% ��������������-main_update-������� >>.\Log.txt
title ������/�����޸� ���
echo =======================================
echo        ������/�����޸� ������ɣ�
echo =======================================
echo.
if not defined hide echo �ɰ汾�ļ��ѱ�������Ŀ¼��backup�ļ�����
echo.
pause
echo %time% ��������������-main_update-�����˳� >>.\Log.txt
call main_exit.cmd
exit






:unHide
echo %time% ��������������-main_update-����boot.wimʧ�ܣ�׼����ȡuid��������д�� >>.\Log.txt
set hide=1
echo ����U�̿���ʹ���˷����Ż�������׼����ȡuid��������д��

::����uid
echo %time% ��������������-main_update-��ʼ����uid������ΪPA�������� >>.\Log.txt
echo ���ڲ����豸
if exist .\Usee0.txt del /f /q .\Usee0.txt >nul
echo ���������������֣������ĵȴ�...
.\core\PartAssist\partassist.exe /list /usb /out:.\Usee0.txt
type Usee0.txt >>.\Log.txt
for %%j in (1 2 3 4 5 6 7 8 9 10 11 12) DO (find  /i "%%j	|" .\Usee0.txt>nul&&SET uid=%%j)
echo %time% ��������������-main_update-uid��%uid% >>.\Log.txt
if exist .\Usee0.txt del /f /q .\Usee0.txt >nul
if not defined uid (
    echo %time% ��������������-main_update-uidδ���壬�����˳� >>.\Log.txt
    cls
    echo ��������ֵĴ���
    echo Edgeless�ļ������ڷ�����%u%
    echo PartAssist���ҵ������̣�uidδ����
    pause
    call main_exit.cmd
    exit
)
echo %time% ��������������-main_update-��ȡuid������� >>.\Log.txt
goto ctnUpdate


:writeWim
echo %time% ��������������-main_update-��ʼɾ���ɰ�boot.wim >>.\Log.txt
echo ����ɾ���ɰ�boot.wim
::ɾ��boot.wim
.\core\PartAssist_old\partassist.exe /hd:%uid% /whide:1 /delfiles /dest:sources\boot.wim
echo %time% ��������������-main_update-��ʼд��boot.wim >>.\Log.txt
echo ���������ط���д��boot.wim
::д��boot.wim
if exist %~d0\boot.wim del /f /q %~d0\boot.wim
:resmove
move /y .\core\Release\sources\boot.wim %~d0\
if not exist %~d0\boot.wim (
    echo %time% ��������������-main_update-�ƶ�boot.wim����Ŀ¼ʧ�� >>.\Log.txt
    echo ==================================================================================================
    echo �ƶ�boot.wim��%~d0�̸�Ŀ¼ʧ�ܣ����ֶ���core\Release\sources\boot.wim�ƶ���%~d0�̸�Ŀ¼��Ȼ�������
    echo ==================================================================================================
    echo.
    pause
    echo %time% ��������������-main_update-�û�ѡ������ >>.\Log.txt
    if not exist %~d0\boot.wim goto resmove
)
.\core\PartAssist_old\partassist.exe /hd:%uid% /whide:1 /src:%~d0\boot.wim /dest:sources





move /y %~d0\boot.wim .\core\Release\sources\
goto endCopyFile
::�˴���У�������ԭ���Ƿ������ֵ�У������ʧ��
echo %time% ��������������-main_update-��ʼУ��д�룬����ΪPA�������� >>.\Log.txt
echo ����У���ļ�д�����
::У���ļ�
.\core\PartAssist_old\partassist.exe /hd:%uid% /whide:1 /src:%~d0\boot.wim /dest:sources /verify /out:.\verify.txt
move /y %~d0\boot.wim .\core\Release\sources\
if not exist verify.txt (
    echo %time% ��������������-main_update-verify.txt����ʧ�ܣ�����У�� >>.\Log.txt
    goto endCopyFile
)
type .\verify.txt >>.\Log.txt
find /I "Success" .\verify.txt
if "%errorlevel%"=="0" goto endCopyFile
echo %time% ��������������-main_update-У��ʧ�� >>.\Log.txt
echo ===============================================================================
echo ����boot.wim�����ط���ʧ�ܣ��뾡���ܹر�����������˳���ȫ�����Ȼ�����������
echo ===============================================================================
echo.
pause
echo %time% ��������������-main_update-�û�ѡ������ >>.\Log.txt
goto writeWim