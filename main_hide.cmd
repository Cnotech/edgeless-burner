@echo off
cd /d "%~dp0"
echo %time% ��������������-main_hide-������ >>.\Log.txt
color 3f
title ׼�����з����Ż�
cls

:homeHide
for %%1 in (Z Y X W V T S R Q P O N M L K J I H G F E D C U) do if exist %%1:\Edgeless\version.txt echo %%1>"%~dp0Upath.txt"
set /p EL_Part=<"%~dp0Upath.txt"
echo %time% ��������������-main_hide-EL_Part��%EL_Part% >>.\Log.txt
if not defined EL_Part (
    echo %time% ��������������-main_hide-EL_Partδ���� >>.\Log.txt
    cls
    echo ����%EL_Part%����δ����
    pause
    call main_exit.cmd
    exit
)
if not exist %EL_Part%:\ (
    echo %time% ��������������-main_hide-%EL_Part%�̲����� >>.\Log.txt
    cls
    echo ����%EL_Part%����������
    pause
    call main_exit.cmd
    exit
)

::����uid
echo %time% ��������������-main_hide-��ʼ����uid������ΪPA�������� >>.\Log.txt
echo ���ڲ����豸
if exist .\Usee0.txt del /f /q .\Usee0.txt >nul
set uid=
echo ���������������֣������ĵȴ�...
.\core\PartAssist\partassist.exe /list /usb /out:.\Usee0.txt
type Usee0.txt >>.\Log.txt
for %%j in (1 2 3 4 5 6 7 8 9 10 11 12) DO (find  /i "%%j	|" .\Usee0.txt>nul&&SET uid=%%j)
echo %time% ��������������-main_hide-uid��%uid% >>.\Log.txt
if exist .\Usee0.txt del /f /q .\Usee0.txt >nul
if not defined uid (
    echo %time% ��������������-main_hide-uidδ���壬�����˳� >>.\Log.txt
    cls
    echo ��������ֵĴ���
    echo Edgeless�����̣�%EL_Part%
    echo PartAssist���ҵķ�����uidδ����
    pause
    call main_exit.cmd
    exit
)

::����uid���ҷ���
echo %time% ��������������-main_hide-��ʼ����uid���ҷ���������ΪPA�������� >>.\Log.txt
echo ����У�����������%uid%�ķ���״̬
if exist .\Usee.txt del /f /q .\Usee.txt >nul
set PA_Part=
echo ���������������֣������ĵȴ�...
.\core\PartAssist\partassist.exe /list:%uid% /out:.\Usee.txt
type Usee.txt >>.\Log.txt
for %%i in (Z Y X W U T S  R Q P O N M L K J I H G F E D C) DO (
		find  /i "%%i:" .\Usee.txt>nul&&SET PA_Part=%%i)
echo %time% ��������������-main_hide-PA_Part��%PA_Part% >>.\Log.txt
if exist .\Usee.txt del /f /q .\Usee.txt >nul
if not defined PA_Part (
    echo %time% ��������������-main_hide-PA_Partδ���壬�����˳� >>.\Log.txt
    cls
    echo ��������ֵĴ���
    echo Edgeless�����̣�%EL_Part%
    echo PartAssist���ҵķ����������̷�δ����
    pause
    call main_exit.cmd
    exit
)
echo ����������%uid%�ϵķ�����ѯ���Ϊ%PA_Part%

::�����Ƿ���ͬһ��U��
if %EL_Part%==%PA_Part% goto ctnHide
echo %time% ��������������-main_hide-��ȡ�ķ�����ͬ���϶�Ϊ���ڶ��USB�ƶ��洢�豸 >>.\Log.txt
title ���ڶ��USB�ƶ��洢�豸
cls 
echo.
echo ��⵽���ܴ��ڶ��U�̲��ҳ����ʶ������˻���
echo �뽫%PA_Part%�ϵ�U�̵����Ա�����������%EL_Part%�ϵ�Edgeless������
echo.
pause
goto homeHide

::ͨ�����飬ȷ��û�������
:ctnHide
echo %time% ��������������-main_hide-һ����У��ͨ�� >>.\Log.txt
echo %PA_Part%�̷�ͨ��Edgeless������һ����У��

::��СEFI����
echo ���ڲ�ѯ����������%uid%������
echo %time% ��������������-main_hide-��ѯU������������ΪPA�������� >>.\Log.txt
.\core\PartAssist_old\partassist.exe /list:%uid% /capacity /out:.\GetSpace.txt
type GetSpace.txt >>.\Log.txt
set /p AllSpace=<GetSpace.txt
set /a ReduceSpace = %AllSpace:~0,-2% - 800
echo %time% ��������������-main_hide-AllSpace��%AllSpace%��ReduceSpace��%ReduceSpace% >>.\Log.txt
if not defined AllSpace (
    echo %time% ��������������-main_hide-���밲ȫֹͣ����ΪAllSpaceδ���� >>.\Log.txt
    cls
    title ��ȫֹͣ
    echo.
    echo ������һЩ���⣬�����޷���ȡU�̵�ʣ������
    echo �˴�ֹͣΪ��ȫֹͣ��Ŀǰ�����������Ѿ���������������ֻ��û������4GB���ϵĴ��ļ�
    echo �ύbugʱ�뽫��Ŀ¼�µ�Log.txtһ���ύ
    echo.
    pause
    call main_exit.cmd
    exit
)
if not defined ReduceSpace (
    echo %time% ��������������-main_hide-���밲ȫֹͣ����ΪReduceSpaceδ���� >>.\Log.txt
    cls
    title ��ȫֹͣ
    echo.
    echo ������һЩ���⣬�����޷���ȡU�̵�ʣ������
    echo �˴�ֹͣΪ��ȫֹͣ��Ŀǰ�����������Ѿ���������������ֻ��û������4GB���ϵĴ��ļ�
    echo �ύbugʱ�뽫��Ŀ¼�µ�Log.txtһ���ύ
    echo.
    pause
    call main_exit.cmd
    exit
)
if %AllSpace:~0,-2%==0 (
    echo %time% ��������������-main_hide-���밲ȫֹͣ����ΪAllSpace==0 >>.\Log.txt
    cls
    title ��ȫֹͣ
    echo.
    echo ������һЩ���⣬�����޷���ȡU�̵�ʣ������
    echo �˴�ֹͣΪ��ȫֹͣ��Ŀǰ�����������Ѿ���������������ֻ��û������4GB���ϵĴ��ļ�
    echo �ύbugʱ�뽫��Ŀ¼�µ�Log.txtһ���ύ
    echo.
    pause
    call main_exit.cmd
    exit
)
if %ReduceSpace%==0 (
    echo %time% ��������������-main_hide-���밲ȫֹͣ����ΪReduceSpace==0 >>.\Log.txt
    cls
    title ��ȫֹͣ
    echo.
    echo ������һЩ���⣬�����޷���ȡU�̵�ʣ������
    echo �˴�ֹͣΪ��ȫֹͣ��Ŀǰ�����������Ѿ���������������ֻ��û������4GB���ϵĴ��ļ�
    echo �ύbugʱ�뽫��Ŀ¼�µ�Log.txtһ���ύ
    echo.
    pause
    call main_exit.cmd
    exit
)
::�Զ�����������֤
set /a Check = 800 + %ReduceSpace%
echo %time% ��������������-main_hide-Check��%Check% >>.\Log.txt
if %Check% neq %AllSpace:~0,-2% (
    echo %time% ��������������-main_hide-���밲ȫֹͣ����ΪCheck������AllSpace >>.\Log.txt
    cls
    title ��ȫֹͣ
    echo.
    echo ������һЩ���⣬�����޷���ȡU�̵�ʣ������
    echo �˴�ֹͣΪ��ȫֹͣ��Ŀǰ�����������Ѿ���������������ֻ��û������4GB���ϵĴ��ļ�
    echo �ύbugʱ�뽫��Ŀ¼�µ�Log.txtһ���ύ
    echo.
    pause
    call main_exit.cmd
    exit
)
echo �Զ�����У��ͨ������ʼ����%PA_Part%�̷������ϵ��γ�U�̿��ܵ��������𻵣�
echo %time% ��������������-main_hide-��ʼ��С���� >>.\Log.txt
.\core\PartAssist_old\partassist.exe /hd:%uid% /resize:0 /reduce-right:%ReduceSpace%
echo %time% ��������������-main_hide-������С���� >>.\Log.txt

::����Edgeless�ļ���
:checkEdgeless1
echo ��ʼ����Edgeless�ļ���
echo %time% ��������������-main_hide-��ʼ����Edgeless�ļ��� >>.\Log.txt

:delEdgeless1
del /f /s /q .\Edgeless
rd /s /q .\Edgeless
if exist .\Edgeless (
    echo %time% ��������������-main_hide-��Edgeless�ļ���ɾ��ʧ�� >>.\Log.txt
    cls
    echo ��Ŀ¼�ľɰ�Edgeless�ļ���ɾ��ʧ�ܣ���رհ�ȫ��������������
    echo ������ɳ��ִ���ʾ�����ֶ�����Ŀ¼�ڵ�Edgeless�ļ���ɾ��
    pause
    goto delEdgeless1
)
xcopy /s /r /y %EL_Part%:\Edgeless .\Edgeless\

if not exist .\Edgeless\version.txt (
    echo %time% ��������������-main_hide-Edgeless�ļ��б���ʧ�� >>.\Log.txt
    cls
    echo Edgeless�ļ��б���ʧ�ܣ���رհ�ȫ��������������
    echo ������ɳ��ִ���ʾ�����ֶ��� %EL_Part%:\Edgeless �ļ��и��Ƶ���Ŀ¼��
    pause
    goto checkEdgeless1
)
echo %time% ��������������-main_hide-Edgeless�ļ��б�����ɣ���ʼ���EFI�����е�Edgeless�ļ��� >>.\Log.txt
echo ���EFI�����е�Edgeless�ļ���
del /f /s /q %EL_Part%:\Edgeless
rd /s /q %EL_Part%:\Edgeless

::����EFI����Ϊ�����
echo %time% ��������������-main_hide-��ʼ����%EL_Part%����Ϊ����� >>.\Log.txt
echo ��ʼ����%EL_Part%����Ϊ�����
echo ���������������֣������ĵȴ�...
.\core\PartAssist\partassist.exe /setact:%EL_Part%

::�½��ļ���
:refreshLetter
echo %time% ��������������-main_hide-��ʼ�½��ļ��� >>.\Log.txt
for %%k in (Z Y X W V U T S R Q P O N M L K J I H G F E D C ) do (
   if not exist %%k:\ (
        if not exist .\%%k echo %%k>FI_Part.txt
        )
)
set /p FI_Part=<FI_Part.txt
echo %time% ��������������-main_hide-�����̷���FI_Part����%FI_Part% >>.\Log.txt
echo ��ʼ�����·���������%FI_Part%�̷�
echo ���������������֣������ĵȴ�...
.\core\PartAssist\partassist.exe /hd:%uid% /cre /size:auto /fs:fat32 /align /label:�ļ��� /letter:%FI_Part%
if not exist %FI_Part%:\ (
    echo %time% ��������������-main_hide-�Ҳ����������·���%FI_Part% >>.\Log.txt
    if exist .\MoreThanOnce echo %time% ��������������-main_hide-�ڶ��γ��ִ������ת����ȫ���� >>.\Log.txt
    if exist .\MoreThanOnce goto safeProtection
    echo %time% ��������������-main_hide-�����Զ��л��̷� >>.\Log.txt
    echo �ļ���������ʧ�ܣ�ԭ������ǿ��������������СEFI����δ���
    echo ���ڳ����Զ��л��̷�
    md MoreThanOnce
    md %FI_Part%
    if exist FI_Part.txt del /f /q FI_Part.txt >nul
    goto refreshLetter
)
echo %time% ��������������-main_hide-�·��������ɹ� >>.\Log.txt

::��ʽ���·���ΪexFAT
echo ���ٸ�ʽ��%FI_Part%����ΪexFAT�ļ�ϵͳ
echo %time% ��������������-main_hide-��ʽ���·���ΪexFAT >>.\Log.txt
format %FI_Part%: /FS:exFAT /V:�ļ��� /Q /Y

::��ԭEdgeless�ļ���
:checkEdgeless2
echo %time% ��������������-main_hide-��ʼ��ԭEdgeless�ļ��� >>.\Log.txt
echo ��ԭEdgeless�ļ��е�%FI_Part%������
xcopy /s /r /y .\Edgeless %FI_Part%:\Edgeless\

if not exist  %FI_Part%:\Edgeless\version.txt (
    echo %time% ��������������-main_hide-��ԭEdgeless�ļ���ʧ�� >>.\Log.txt
    cls
    echo Edgeless�ļ��л�ԭʧ�ܣ���رհ�ȫ��������������
    echo ������ɳ��ִ���ʾ�����ֶ�����Ŀ¼�ڵ� Edgeless �ļ��и��Ƶ� %FI_Part% �̸�Ŀ¼
    pause
    goto checkEdgeless2
)
echo %time% ��������������-main_hide-��ԭEdgeless�ļ��гɹ���������ر��ݻ��� >>.\Log.txt
echo �������Edgeless�ļ��б���
del /f /s /q .\Edgeless
rd /s /q .\Edgeless

::�������
title �����Ż����
echo %time% ��������������-main_hide-������� >>.\Log.txt
echo ==========================================================================
echo �����Ż�������ɣ������Ǳ����������Ϣ������ʱ���ύ����Ϣ�ʹ�Ŀ¼�ڵ�Log.txt
echo ELP��%EL_Part% PAP��%PA_Part% FIP��%FI_Part%
echo ==========================================================================
echo.
echo %time% ��������������-main_hide-�����˳� >>.\Log.txt
goto endHide


:safeProtection
title ��ȫ����
echo %time% ��������������-main_hide-���밲ȫ��������ʾU�̷������������ΪPA�������� >>.\Log.txt
.\core\PartAssist_old\partassist.exe /list:%uid% /out:.\UDiskInfo.txt
type .\UDiskInfo.txt >>.\UDiskInfo.txt
echo.
echo ==========================================================================
echo ��⵽���ܷ����˴��󣬳������Զ�ֹͣ���������밲ȫ����ģʽ
echo �����������������ԭ���µģ�
echo 1����һ����С����δ���
echo 2���˵����д������������ϵĿ�������
echo 3��������������
echo.
echo ����ֹͣ����Ϊ��ȫֹͣ�������ϲ�����U�̣����U�̳����쳣�볢�Եͼ���ʽ��
echo ==========================================================================
echo.
echo ����������Ի�ԭ����������ʼ״̬
pause

::��ԭEdgeless�ļ���
:checkEdgeless2
echo %time% ��������������-main_hide-��ʼ��ԭEdgeless�ļ��� >>.\Log.txt
echo ��ԭEdgeless�ļ��е�%PA_Part%������
xcopy /s /r /y .\Edgeless %PA_Part%:\Edgeless\

if not exist  %PA_Part%:\Edgeless\version.txt (
    echo %time% ��������������-main_hide-��ԭEdgeless�ļ���ʧ�� >>.\Log.txt
    cls
    echo Edgeless�ļ��л�ԭʧ�ܣ����ܳ������������⣬������еͼ���ʽ���Ա���U�̰�ȫ
    echo.
    echo.
    pause
)
echo �������Edgeless�ļ��б���
del /f /s /q .\Edgeless
rd /s /q .\Edgeless


echo %time% ��������������-main_hide-�ڰ�ȫ����״̬���˳� >>.\Log.txt
call main_exit.cmd
exit

:endHide