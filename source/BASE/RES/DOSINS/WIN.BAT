@echo off

rem Made by Wengier and Roy, China DOS Union.
rem All rights reserved. 2002-2003.
rem (LIVE WIN3.1 modified for mpc)

if %1.==_next_. goto nextstep
if %1.==_quit_. goto quit
xmsdsk 32768 /y > nul
findramd>nul
if %ramdrive%#==# echo Error: Can't create RAM disk!
if %ramdrive%#==# goto shut
if not exist %ramdrive%\temp\nul md %ramdrive%\temp
set temp=%ramdrive%\temp
set tmp=%ramdrive%\temp
echo y|lock %ramdrive%>nul
SET DOSPATH=%CDROM%\RES\DOSINS

:start
cls
echo.
echo Starting Windows 3.11...
echo Now extracting Windows and applications...
echo.
copy %DOSPATH%\win.bat %ramdrive%\ > nul
if not exist %ramdrive%\win.bat goto copyerr
%ramdrive%\win.bat _next_
goto nextstep

:SHUT
WBAT BOX "Please enter your choice:",Stay on DOS,Shutdown the computer,Restart the computer #1,60
IF NOT ERRORLEVEL 4 GOTO ANS
WBAT BOX (RED ON YELLOW) "Note: Please make a choice!",OK
GOTO SHUT
:ANS
IF NOT ERRORLEVEL 2 GOTO END
IF ERRORLEVEL 3 GOTO RES
ECHO Now trying to shutdown the computer..
ECHO.
SHUTDOWN S
ECHO.
ECHO Shutdown failed. Your computer may not have an ATX power.
:RES
ECHO Now restarting the computer...
ECHO.
SHUTDOWN R
GOTO END

:nextstep
pkunzjr -o %CDROM%\DATA\WIN31.ZIP %RAMDRIVE%\
copy a:\command.com %ramdrive%\ > nul
if not exist %ramdrive%\win.com goto copyerr
echo.
echo Windows 3.11 has been extracted successfully.
set comspec=%ramdrive%\command.com
set path=%ramdrive%\;%PATH%

if %lfn%#==1# inifile %ramdrive%\system.ini [boot] network.drv=fmlfn.drv
if not %lfn%#==1# inifile %ramdrive%\system.ini [boot] network.drv=;
%ramdrive%
VBESVGA
win.com

%DOSINS%\win.bat _quit_

:copyerr
cls
echo Error!!!
echo.
wbat box "Failed to extract Windows 3.11 properly",Quit #1,30
if errorlevel 2 a:\win.bat _quit_

:quit
cls
echo.
echo Removing Windows 3.11 from memory... please wait...
set comspec=a:\command.com
set path=a:\;%DOSPATH%;%CDROM%:\
xmsdsk /u /y > nul
echo Now Mini-Windows has been successfully removed from the memory.
echo Made by Wengier and Roy, China DOS Union.
goto shut

:end
cls
echo Thanks for using Windows 3.11!
echo Mini-Windows script by Wengier and Roy, China DOS Union. All rights reserved.
echo.
echo Type "WIN" to start Windows 3.1 again if you want!
echo Type "MWIN" to start Mini-Windows!
echo Type "patcher" to start MultiPatcher!
echo.
A: