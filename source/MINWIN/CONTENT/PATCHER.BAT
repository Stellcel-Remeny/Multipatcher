@echo off
if not exist %CDROM%\MPCCD goto notfound
if not exist %CDROM%\PATCHER.BAT goto notfound

%CDROM%
PATCHER.BAT %1 %2 %3 %4 %5 %6 %7 %8 %9
A:

:notfound
echo.
echo CD Drivers could not be loaded, or disc is not MultiPatcher.
echo.
goto end

:end