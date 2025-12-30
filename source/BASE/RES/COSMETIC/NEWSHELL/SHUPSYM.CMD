@echo off
rem
rem  This script installs/uninstalls symbols for the new shell
rem
rem  01-May-195      RickTu     Created
rem

SETLOCAL
set action=install
set moveboot=mv /x /d

:ArgParse
if "%1" == "/u" set action=uninstall& shift& goto ArgParse
if "%1" == "/U" set action=uninstall& shift& goto ArgParse

if "%1" == "" goto usage
if NOT exist mv.exe goto no_mv_exe

rem
rem ************ Set up our lists of files.  These are the files that replace
rem ************ existing files so we should back them up first.
rem
set userexefiles=user control
set userdllfiles=user32 kernel32 winsrv shell32 userexts mpr ntlanman comctl32

rem
rem ************  set these to the names of files that should be copied from the ui\system32
rem ************  directory to the %systemroot%\system32 directory
set system32exefiles=explorer grpconv rundll32 runonce syncapp
set system32dllfiles=linkinfo docprop shscrap synceng syncui ntshrui
set system32cplfiles=appwiz timedate
set debugdllfiles=userexts

if "%action%"=="uninstall" goto uninstall

echo.
echo  Installing symbols for new shell from %1
echo.



if NOT exist %SystemRoot%\symbols goto nobackupsymbols
mkdir %SystemRoot%\symbols\dll\old_user >nul
for %%i in (%userdllfiles%) do (if exist %SystemRoot%\symbols\dll\%%i.dbg copy %SystemRoot%\symbols\dll\%%i.dbg %SystemRoot%\symbols\dll\old_user)
mkdir %SystemRoot%\symbols\exe\old_user >nul
for %%i in (%userexefiles%) do (if exist %SystemRoot%\symbols\exe\%%i.dbg copy %SystemRoot%\symbols\exe\%%i.dbg %SystemRoot%\symbols\exe\old_user)
mkdir %SystemRoot%\symbols\cpl\old_user >nul
for %%i in (%system32cplfiles%) do (if exist %SystemRoot%\symbols\cpl\%%i.dbg copy %SystemRoot%\symbols\cpl\%%i.dbg %SystemRoot%\symbols\cpl\old_user)


:nobackupsymbols

if not exist %SystemRoot%\symbols goto nosymbols
for %%i in (%userexefiles%) do (if exist %1\symbols\exe\%%i.dbg copy %1\symbols\exe\%%i.dbg %SystemRoot%\symbols\exe\~%%i.dbg && %moveboot% %SystemRoot%\symbols\exe\~%%i.dbg %SystemRoot%\symbols\exe\%%i.dbg)
for %%i in (%userdllfiles%) do (if exist %1\symbols\dll\%%i.dbg copy %1\symbols\dll\%%i.dbg %SystemRoot%\symbols\dll\~%%i.dbg && %moveboot% %SystemRoot%\symbols\dll\~%%i.dbg %SystemRoot%\symbols\dll\%%i.dbg)
for %%i in (%system32exefiles%) do (if exist %1\symbols\exe\%%i.dbg copy %1\symbols\exe\%%i.dbg %SystemRoot%\symbols\exe\~%%i.dbg && %moveboot% %SystemRoot%\symbols\exe\~%%i.dbg %SystemRoot%\symbols\exe\%%i.dbg)
for %%i in (%system32dllfiles%) do (if exist %1\symbols\dll\%%i.dbg copy %1\symbols\dll\%%i.dbg %SystemRoot%\symbols\dll\~%%i.dbg && %moveboot% %SystemRoot%\symbols\dll\~%%i.dbg %SystemRoot%\symbols\dll\%%i.dbg)
for %%i in (%system32cplfiles%) do (if exist %1\symbols\cpl\%%i.dbg copy %1\symbols\cpl\%%i.dbg %SystemRoot%\symbols\cpl\~%%i.dbg && %moveboot% %SystemRoot%\symbols\cpl\~%%i.dbg %SystemRoot%\symbols\cpl\%%i.dbg)
for %%i in (%debugdllfiles%)    do (if exist %1\system32\%%i.dll    copy %1\system32\%%i.dll    %SystemRoot%\system32\~%%i.dll    && %moveboot% %SystemRoot%\system32\~%%i.dll    %SystemRoot%\system32\%%i.dll)
echo.
echo The symbols have been updated.  Please reboot your machine now!
echo.
goto end

:nosymbols
echo.
echo Couldn't find %systemroot%\symbols directory!  Symbols not updated.
echo.
goto end



:no_mv_exe
echo.
echo Can't find mv.exe on the path.  This tool is required to update the
echo symbols for the new shell.
echo.
goto end

:uninstall
echo.
echo Restoring old symbols...
echo.
if not exist %SystemRoot%\symbols\exe\old_user goto cantundo
copy %SystemRoot%\symbols\exe\old_user\*.* %SystemRoot%\symbols\exe
del /s /q %SystemRoot%\symbols\exe\old_user\*.*
rmdir /s /q %SystemRoot%\symbols\exe\old_user
copy %SystemRoot%\symbols\dll\old_user\*.* %SystemRoot%\symbols\dll
del /s /q %SystemRoot%\symbols\dll\old_user\*.*
rmdir /s /q %SystemRoot%\symbols\dll\old_user
copy %SystemRoot%\symbols\cpl\old_user\*.* %SystemRoot%\symbols\cpl
del /s /q %SystemRoot%\symbols\cpl\old_user\*.*
rmdir /s /q %SystemRoot%\symbols\cpl\old_user

echo.
echo  Old symbols restored!
echo.

:cantundo
echo.
echo Can't find %SystemRoot%\symbols\old_user directory so %0 can't restore
echo this system to the old symbols!
echo.
goto end

:usage
echo.
echo usage: %0 [pointer to nt\ui directory]

:end
ENDLOCAL
