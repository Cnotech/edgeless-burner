title ���ڽ�ѹISO
cd /d "%~dp0"
echo %time% ��������������-dash_checkrelease-������ >>.\Log.txt
::��ѹISO
echo %time% ��������������-dash_checkrelease-׼����ѹISO >>.\Log.txt
if exist .\core\version_release.txt set /p version_release=<.\core\version_release.txt
:reRead
set /p version_iso=<.\core\version_iso.txt
echo %time% ��������������-dash_checkrelease-version_release��%version_release%��version_iso��%version_iso% >>.\Log.txt
if not defined version_iso (
    echo %time% ��������������-dash_checkrelease-version_iso����Ϊ�գ��ȴ��û����� >>.\Log.txt
    cls
    echo.
    echo ������������ֵĴ��󣺾���У���ļ��ƺ�ȱʧ�ˣ����ǳ�����Լ�����ѱ�ͨ��
    echo �����ȷ��û�н���˽�Բ���������core�ļ��У���version_ol.txt������Ϊversion_iso.txt���������
    echo �����Ը�ⱨ������뽫Log.txt�ύ���ڲ�Ⱥ
    echo.
    pause
    goto reRead
    echo %time% ��������������-dash_checkrelease-�û����������� >>.\Log.txt
)
if defined version_release (
    if %version_iso%==%version_release% echo %time% ��������������-dash_checkrelease-�汾����ͬ��������ѹ >>.\Log.txt
    if %version_iso%==%version_release% goto skipRelease
    echo %time% ��������������-dash_checkrelease-�汾�Ų�ͬ��������ѹ >>.\Log.txt
)
echo %time% ��������������-dash_checkrelease-ɾ����ѹ���� >>.\Log.txt
del /f /s /q core\Release
rd /s /q core\Release
if exist .\core\Release echo %time% ��������������-dash_checkrelease-ɾ����ѹ����ʧ�� >>.\Log.txt
md .\core\Release
echo %time% ��������������-dash_checkrelease-��ʼ��ѹ >>.\Log.txt
::core\7-Zip\7z.exe x core\Edgeless.iso -ocore\Release -aoa
.\core\ultraiso\ultraiso -input .\core\Edgeless.iso -extract .\core\Release
echo %time% ��������������-dash_checkrelease-��ѹ��� >>.\Log.txt
if exist core\version_release.txt del /f /q core\version_release.txt
copy /y core\version_iso.txt core\version_release.txt
:skipRelease