if not exist %CDROM%\MPCCD goto notfound
if not exist %CDROM%\DATA\WIN31.ZIP goto notfound
if not exist %CDROM%\RES\DOSINS\WIN.BAT goto notfound

SET DOSPATH=%CDROM%\RES\DOSINS
SET DOSINS=%DOSPATH%
SET PATH=A:\;%DOSINS%
%DOSINS%\WIN.BAT

:notfound
echo.
echo CD Drivers could not be loaded, or disc is not MultiPatcher.
echo.
goto end

:end