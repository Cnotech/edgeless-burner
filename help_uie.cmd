cd /d "%~dp0"
set /p target=<burn_target.txt
start /i /wait .\core\UltraISO\UltraISO.exe -input %target% -writeusb
exit