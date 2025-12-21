if not exist %CDROM%\MPCCD goto notfound
if not exist %CDROM%\PATCHER.BAT goto notfound

%CDROM%
PATCHER.BAT
A:

:notfound
echo.
echo CD Drivers could not be loaded, or disc is not MultiPatcher.
echo.
goto end

:end