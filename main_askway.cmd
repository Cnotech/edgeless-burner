@echo off
cd /d "%~dp0"
echo %time% ��������������-main_askway-������ >>.\Log.txt
:askwayhome
if exist .\core\ZIPOnce.txt del /f /q .\core\ZIPOnce.txt >nul
cls
title ׼��д��
echo ��ѡ��һ��д�뷽ʽ��Ĭ��ѡ1����
echo ѡ��֮����Բ鿴���飬��ȷ���Ƿ���ѡ
echo.
echo 1.exFAT+FAT16  ���Ƽ���
echo 2.FAT32        �����ȣ�
ver | find "10." > NUL && echo 3.FAT32+exFAT  ����Win10��
echo ==========================
echo 0.������ģʽ
echo.
set /p cho=������Ų��س���
cls

if %cho%==0 (
    echo %time% ��������������-main_askway-�û�ѡ�����ϻ�����ģʽ >>.\Log.txt
    cd core
    echo ZIPOnce >ZIPOnce.txt
    cd ..
    goto way2
)
if %cho%==1 goto way1
if %cho%==2 goto way2
ver | find "10." > NUL && if %cho%==3 goto way3

goto askwayhome


:way1
echo %time% ��������������-main_askway-�û��鿴�˷���1 >>.\Log.txt
echo.
echo �˷�����һ��exFAT����ǰ����Ϊ�ļ�������ʹ�ú��õ�FAT16������ΪEFI����
echo ȱ���ǿ��ܻ�����ʧ�ܣ������Բ�ǿ���ϻ����޷��������������������������Ƽ��ķ���
echo.
echo ע���ϻ���ָԼ2013��֮ǰ�����ĵ��ԣ���ʱ����ʹ�÷���2�����������װ����ʹ�ü�������
echo.
echo ========================================
echo �������γ�����USB�洢�豸����������У�
echo ========================================
echo.
CHOICE /C yn /M "��Yȷ�ϻ�N����ѡ��"
if %errorlevel%==2 goto askwayhome
echo %time% ��������������-main_askway-�û�ȷ��ʹ�÷���1 >>.\Log.txt
echo 1 >burn_way.txt
if not exist burn_way.txt echo %time% ��������������-main_askway-burn_way.txt����ʧ�� >>.\Log.txt

echo %time% ��������������-main_askway-�������ISO >>.\Log.txt
call dash_createstuffiso.cmd
echo %time% ��������������-main_askway-��ʼ���U�̷��� >>.\Log.txt
call main_delpart.cmd
echo %time% ��������������-main_askway-��ʼд�� >>.\Log.txt
echo "%~dp0core\Edgeless_stuff.iso" >burn_target.txt
echo 1 >burn_check.txt
call main_burn.cmd
call main_exit.cmd
exit


:way2
echo %time% ��������������-main_askway-�û��鿴�˷���2 >>.\Log.txt
echo.
echo �˷�����ʹ��һ��FAT32�����������Ժã������ɹ��ʸ�
if exist .\core\ZIPOnce.txt echo ��ʹ��USB-ZIPģʽ��ǿ���ϵ��Ե�֧��
echo ȱ���ǲ��ܷ���4GB�����ļ�����Win10ԭ�澵��
echo.
CHOICE /C yn /M "��Yȷ�ϻ�N����ѡ��"
if %errorlevel%==2 goto askwayhome
echo %time% ��������������-main_askway-�û�ȷ��ʹ�÷���2 >>.\Log.txt
echo %time% ��������������-main_askway-��ʼ���U�̷��� >>.\Log.txt
if not exist .\core\ZIPOnce.txt call main_delpart.cmd
echo 2 >burn_way.txt
if not exist burn_way.txt echo %time% ��������������-main_askway-burn_way.txt����ʧ�� >>.\Log.txt

echo %time% ��������������-main_askway-��ʼд�� >>.\Log.txt
echo "%~dp0core\Edgeless.iso" >burn_target.txt
echo 1 >burn_check.txt
call main_burn.cmd
call main_exit.cmd
exit


:way3
echo %time% ��������������-main_askway-�û��鿴�˷���3 >>.\Log.txt
echo.
echo �˷���ʹ��һ��FAT32������Ϊǰ�÷�����exFAT��Ϊ�����ļ������������Ժ�
echo ȱ����ֻ����Win10ϵͳ/PE�б�����ʶ�𣬱��ϵͳ�����ֻ�ܿ���ǰ�˵�EFI����
echo.
echo ========================================
echo �������γ�����USB�洢�豸����������У�
echo ========================================
echo.
CHOICE /C yn /M "��Yȷ�ϻ�N����ѡ��"
if %errorlevel%==2 goto askwayhome
echo %time% ��������������-main_askway-�û�ȷ��ʹ�÷���3 >>.\Log.txt
echo %time% ��������������-main_askway-��ʼ���U�̷��� >>.\Log.txt
call main_delpart.cmd
echo 3 >burn_way.txt
if not exist burn_way.txt echo %time% ��������������-main_askway-burn_way.txt����ʧ�� >>.\Log.txt

echo %time% ��������������-main_askway-��ʼд�� >>.\Log.txt
echo "%~dp0core\Edgeless.iso" >burn_target.txt
echo 1 >burn_check.txt

call main_burn.cmd
call main_exit.cmd
exit