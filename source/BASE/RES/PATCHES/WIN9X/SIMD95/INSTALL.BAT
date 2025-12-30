echo off
REM eny simple batch script for simd95
cls
type readme.txt | more
echo.
echo =========================================
echo.
echo Press any key to copy SIMD95 to C:\.
echo Press CTRL-C to quit.
echo.
pause > nul
copy SIMD95.COM C:\SIMD95.COM
echo Press any key to prepend to AUTOEXEC.BAT.
pause > nul
if exist C:\AUTOEXEC.BAK del C:\AUTOEXEC.BAK
if exist C:\AUTOEXEC.BAT copy C:\AUTOEXEC.BAT C:\AUTOEXEC.BAK
echo C:\SIMD95.COM > C:\AUTOEXEC.BAT
if exist C:\AUTOEXEC.BAK type C:\AUTOEXEC.BAK >> C:\AUTOEXEC.BAT
echo Done.