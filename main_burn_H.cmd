title ����ִ����¼����
cd /d "%~dp0"
echo %time% ��������������-main_burn_H-������ >>.\Log.txt
set /p target=<burn_target.txt
set /p way=<burn_way.txt
::����
set MBR_=USB-HDD+ v2
set HidePart_=��
if %way% == 1 set HidePart_=�߶�����
if exist .\core\ZIP.txt set MBR_=USB-ZIP+ v2
if exist .\core\ZIPOnce.txt set MBR_=USB-ZIP+ v2
if exist .\core\ZIPOnce.txt del /f /q .\core\ZIPOnce.txt

echo %time% ��������������-main_burn_H-way=%way%��HidePart_=%HidePart_%��MBR_=%MBR_%��target=%target% >>.\Log.txt

::����uid
echo %time% ��������������-main_burn_H-��ʼ����uid������ΪPA�������� >>.\Log.txt
echo ���ڲ����豸
if exist .\Usee0.txt del /f /q .\Usee0.txt >nul
set uid=
echo ���������������֣������ĵȴ�...
.\core\PartAssist\partassist.exe /list /usb /out:.\Usee0.txt
type Usee0.txt >>.\Log.txt
for %%j in (1 2 3 4 5 6 7 8 9 10 11 12) DO (find  /i "%%j	|" .\Usee0.txt>nul&&SET uid=%%j)
echo %time% ��������������-main_burn_H-uid��%uid% >>.\Log.txt
if exist .\Usee0.txt del /f /q .\Usee0.txt >nul
if not defined uid (
    echo %time% ��������������-main_burn_H-uidδ���壬�����˳� >>.\Log.txt
    cls
    echo ��������ֵĴ���
    echo PartAssist���ҵķ�����uidδ����
    echo ������Ϊ������û�в���U�̣��ƶ�Ӳ����ʹ��Rufusд�룩
    pause
    call main_exit.cmd
    exit
)

::�ƶ�ISO����Ŀ¼
if exist %~d0\Edgeless.iso del /f /q %~d0\Edgeless.iso
:resmove_HUI
move /y %target% %~d0\Edgeless.iso
if not exist %~d0\Edgeless.iso (
    echo %time% ��������������-main_burn_H-�ƶ�Edgeless.iso����Ŀ¼ʧ�� >>.\Log.txt
    echo ==================================================================================================
    echo �ƶ�Edgeless.iso��%~d0�̸�Ŀ¼ʧ�ܣ����ֶ���%target%�ƶ���%~d0�̸�Ŀ¼��Ȼ�������
    echo ==================================================================================================
    echo.
    pause
    echo %time% ��������������-main_burn_H-�û�ѡ������ >>.\Log.txt
    if not exist %~d0\Edgeless.iso goto resmove_HUI
)

::����д��
title ���ڵȴ�UltraISO���д��
"%~dp0\core\UltraISO\iso.exe" "iso:%~d0\Edgeless.iso" mode:-S disk:%uid% "MBR:%MBR_%" HidePart:%HidePart_% ShowProgress:-UI
move /y %~d0\Edgeless.iso %target%


echo %time% ��������������-main_burn_H-������� >>.\Log.txt