@ECHO OFF

REM Made by Wengier and Roy. China DOS Union.
REM All rights reserved. 2002-2003.
REM Modified for MultiPatcher

SET DIRCMD=/OGN /4
SET PROMPT=$P$G

LH SHSUCDX /D:ELTORITO
FINDCD
if not exist %CDROM%\MPCCD goto NOCD

:: CDRom is found.
SET DOSPATH=%CDROM%\RES\DOSINS
SET DOSINS=%DOSPATH%
SET PATH=%PATH%;%CDROM%;%DOSINS%

TM /R=30 /D=250
LH KILLER
AUXSTACK
SET LFN=
LH DOSKEY
LH CTMOUSE
::Note: The following line is for compatibility on some systems.
LH CTMOUSE>NUL
LH SHARE
LH ZENO /Q
cls
WBAT BOX "Enable Long File Names(LFN) support?",Yes,No #1,60
IF ERRORLEVEL 1 IF NOT ERRORLEVEL 2 SET LFN=1
IF %LFN%#==1# LH DOSLFN /Z:%CDROM%\DOSINS\CP437UNI.TBL
WBAT BOX "Launch Windows 3.11 right now?",Yes,No #1,60
IF ERRORLEVEL 2 IF NOT ERRORLEVEL 3 GOTO NOWIN
LH ESCAPE
CALL %DOSPATH%\WIN.BAT
GOTO END

:NOCD
CLS
ECHO Mini-Windows 3.11 by China DOS Union
ECHO Made by Wengier and Roy. All rights reserved.
ECHO Modified for use with MultiPatcher.
ECHO.
ECHO The rest of this CD image could not located.
ECHO El-Torito may not be loaded, or image is not MultiPatcher.
ECHO Type "mwin" to start Mini-Windows!
ECHO.
goto END

:NOWIN
CLS
ECHO Mini-Windows 3.11 by China DOS Union
ECHO Made by Wengier and Roy. All rights reserved.
WRITEXT 0+ 1 "Any comments, please come to the forum at: " -f15 http://dosbbs.2ya.com/ -f7
ECHO.
ECHO Modified for use with MultiPatcher.
ECHO.
ECHO Type "WIN" to start Windows 3.1!
ECHO Type "mwin" to start Mini-Windows!
ECHO Type "patcher" to start MultiPatcher!
ECHO Or just do nothing to stay on MS-DOS!
ECHO.

:END
