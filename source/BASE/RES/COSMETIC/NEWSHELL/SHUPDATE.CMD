@echo off
rem
rem  This script installs the Shell Technology Preview
rem  on Windows NT 3.51
rem

SETLOCAL
set action=install

:ArgParse
if "%1" == "/u" set action=uninstall& shift& goto ArgParse
if "%1" == "/U" set action=uninstall& shift& goto ArgParse

set releasename=Shell Technology Preview

echo.
echo              Windows NT 3.51 %releasename% %action%
echo.
echo  This program will modify system-critical files in your current Windows NT
echo     installation and %action% the new %releasename% for
echo                          Windows NT 3.51.
echo.

if NOT "%1" == "" goto usage

rem
rem Set up our commands for non test mode

set shtools=shuttle inxtoreg mv rm imagecfg
set copycmd=copy
set rencmd=ren
set inxtoregcmd=inxtoreg
set delcmd=del
set rmdircmd=rmdir
set newdir=mkdir
set cdcmd=cd
set delboot=rm /x /d
set moveboot=mv /x /d
set rebootcmd=shuttle -x
set imagecfg40cmd=imagecfg -v 4.0
set imagecfg351cmd=imagecfg -v 3.51
set freespacecmd=shuttle -f
set freevschecksyscmd=shuttle -b
set freevscheckbincmd=shuttle -y
set adminprvcmd=shuttle -a
set ynccmd=shuttle -c
set rmassoccmd=shuttle -k
set restassoccmd=shuttle -z
set setshellcmd=shuttle -s
set setwelcomecmd=shuttle -w
set checkversioncmd=shuttle -l
set old_user=spbackup
rem
rem ************ Set up our lists of files.  These are the files that replace
rem ************ existing files so we should back them up first.
rem
set userexefiles=user control notepad
set userdllfiles=user32 kernel32 winsrv shell32 mpr ntlanman ntlanui comctl32 comdlg32

rem
rem ************  set these to the names of files that should be copied install
rem ************  directory to the %systemroot%\system32 directory
set system32exefiles=explorer grpconv rundll32 runonce syncapp
set system32dllfiles=linkinfo docprop shscrap synceng syncui ntshrui
set system32cplfiles=appwiz
set systemttffiles=marlett
set viewerexefiles=quikview
set viewerdllfiles=
set miscfiles=

rem
rem ************  set these to the name of files that should be
rem ************  version stamp revised only
rem
set stampinuseexefiles=winlogon printman winfile
set stampinusedllfiles=mprui netui0 netui1 netui2 acledit
set stampexefiles=ntoskrnl ntkrnlmp
set stampdllfiles=

rem
rem ************  set this to the names of files that should be inxtoreg'd.
set inxfiles=shell

rem
rem ************ Check to make sure the tools we need are in the current
rem ************ directory.

echo Checking for needed tools...
for %%i in (%shtools%) do (if NOT exist .\%%i.exe goto no_tools)
goto check_admin_priv

:no_tools
rem
echo.
echo Some files are missing.  One (or more) of the following files could not
echo be found in the current directory.  To install the new shell, make sure
echo you are running this script from the same directory where all the
echo distrubition files are located.
echo.
echo Could not find one of the following tools:
echo.
echo     %shtools%
echo.
goto end

:check_admin_priv
echo Checking for correct privileges...
%adminprvcmd%
if errorlevel 1 goto check_uninstall
echo.
echo  You do not have administrator privileges on this machine!  Administrator
echo  privileges are required to be able to install/uninstall the Shell Preview.
echo  Please log off and log back on with an user account that is a member of the
echo  administrator security group.
echo.
goto end


:check_uninstall
rem
rem check what function we are performing
rem
if %action% == uninstall goto uninstall


rem
rem ************ Check to make sure we are installing on an NT 3.51 system
echo Checking system version...
%checkversioncmd%
if errorlevel 1 goto wrong_version
goto check_disk_space
:wrong_version
echo.
echo  You are trying to install the %releasename%
echo  on a beta or pre 3.51 version of Windows NT.  The
echo  %releasename% can only be installed on the
echo  retail release of Windows NT version 3.51.
echo.
goto end


:check_disk_space
rem
rem ************ Check to make sure we have enough disk space
echo Checking free disk space...
%freespacecmd% 20000000 %systemroot%
if errorlevel 1 goto not_enough_space
goto check_free_vs_checked

:not_enough_space
echo.
echo  There is not enough disk space on the drive your
echo  system is installed on (%systemroot%).
echo  You need at least 20MB of free space.  Please free up
echo  some space on your system drive and run %0 again.
echo.
goto end

:check_free_vs_checked
echo Verifying system type...
rem
rem Check whether the Shell Preview binaries are retail
rem or debug binaries (so as to match the binaries with
rem the correct type of system).
rem
%freevscheckbincmd%
if errorlevel 1 goto need_checked_build

rem
rem we're trying to install free/retail binaries, make sure
rem the system is a free/retail one.
rem
%freevschecksyscmd%
if errorlevel 1 goto needed_free_build
goto check_files

:needed_free_build
echo.
echo  You are attempting the install the free/retail Shell Preview on a
echo  checked/debug system.  This is not supported!  For a checked/debug
echo  system, you need to install the checked/debug Shell Preview.
echo.
goto end

:need_checked_build
rem
rem we're trying to install debug binaries, make sure
rem the system is a debug one.
rem
%freevschecksyscmd%
if errorlevel 1 goto check_files

echo.
echo  You are attempting the install the checked/debug Shell Preview on a
echo  free/retail system.  This is not supported!  For a free/retail system,
echo  you need to install a free/retail Shell Preview.
echo.
goto end

:check_files



rem
rem Check to make sure all needed files exist in the current
rem directory.  This will ensure that we don't hose
rem any systems.
rem

echo Checking for %releasename% files...
for %%i in (%userexefiles%)     do (if NOT exist .\%%i.exe goto missing_files)
for %%i in (%userdllfiles%)     do (if NOT exist .\%%i.dll goto missing_files)
for %%i in (%system32exefiles%) do (if NOT exist .\%%i.exe goto missing_files)
for %%i in (%system32dllfiles%) do (if NOT exist .\%%i.dll goto missing_files)
for %%i in (%system32cplfiles%) do (if NOT exist .\%%i.cpl goto missing_files)
for %%i in (%systemttffiles%)   do (if NOT exist .\%%i.ttf goto missing_files)
for %%i in (%viewerexefiles%)   do (if NOT exist .\%%i.exe goto missing_files)
for %%i in (%inxfiles%)         do (if NOT exist .\%%i.inx goto missing_files)
goto check_already_installed


:missing_files
echo.
echo ***** Some file(s) are missing! *****
echo.
echo One (or more) of the following files could not  be found in the
echo current directory.  To install the new shell, make sure you are
echo running this script from the same directory where all the
echo distrubition files are located.
echo.
echo %0 could not find one of the following distribution files:
echo   .EXEs:
echo     %userexefiles%
echo     %system32exefiles%
echo     %viewerexefiles%
echo.
echo   .DLLs:
echo     %userdllfiles%
echo     %system32dllfiles%
echo     %viewerdllfiles%
echo.
echo   .CPLs:
echo     %system32cplfiles%
echo.
echo   .TTFs
echo     %systemttffiles%
echo.
goto end

:check_already_installed
for %%i in (%userexefiles%) do (if exist %SystemRoot%\System32\%old_user%\%%i.exe goto warn_user)
for %%i in (%userdllfiles%) do (if exist %SystemRoot%\System32\%old_user%\%%i.dll goto warn_user)
for %%i in (%stampinuseexefiles%) do (if exist %SystemRoot%\System32\%old_user%\%%i.exe goto warn_user)
for %%i in (%stampinusedllfiles%) do (if exist %SystemRoot%\System32\%old_user%\%%i.dll goto warn_user)
goto make_backup

:warn_user
echo.
echo  *** WARNING!  WARNING!  WARNING! ***
echo.
echo  The directory %SystemRoot%\system32\%old_user% already
echo  exists.  This is most likely because you have already installed
echo  or tried to install the Shell Preview.  If you try to install
echo  the Shell Preview again now, you might lose the ability to uninstall
echo  the Shell Preview and recover your NT 3.51 installation!!!!
echo.
echo.
%ynccmd% "yn" "Are you sure you want to try to install the Shell Preview?"
if errorlevel 1 goto end
echo.
%ynccmd% "yn" "Are you REALLY SURE you want to try to install the Shell Preview?"
if errorlevel 1 goto end

:make_backup
rem
rem Do a few more checks...
rem


rem
rem Verify that TEMP= and TMP= are valid

if not "%tmp%" == "" goto tempset
if not "%temp%" == "" set tmp=%temp%&&goto tempset

echo.
echo Neither the TMP or TEMP environment variable is set.  Please set one
echo of them and then re-run this script.
echo.
goto end

:tempset
if exist %tmp% goto tmpexists
echo.
echo Your TMP or TEMP environment variable is set to %tmp%
echo.
echo That directory does not exist.
echo.
%ynccmd% "yn" "Do you wish to create %tmp%?"
if errorlevel 1 goto end
%newdir% %tmp% 2>nul 1>nul
if not exist %tmp% goto end

:tmpexists
echo.
echo.
echo.
echo.
echo.
echo  *****************************************************************************
echo   Notes on using the %releasename% with Windows NT version 3.51
echo  *****************************************************************************
echo.
echo  This preview is intended to enable software developers and vendors
echo  to test their applications on both Windows 95 and Windows NT version 3.51
echo  platforms.  This user interface will be integrated into the base Windows NT
echo  product and made available in a future release of Windows NT.  The date of
echo  this release is to be determined.
echo.
echo  Reporting Problems
echo.
echo  The %releasename% has not been fully tested and should not be
echo  deployed in production environments.  There is currently no official
echo  Microsoft Product Support Services support available for using the
echo  %releasename% on Windows NT version 3.51.  If you wish to join
echo  other customers using and exchanging feedback on the %releasename%,
echo  the CompuServe location is MSDR forum, Section 15.
echo.
pause
echo.
echo  If you wish to report a problem, please do so through our CompuServe or
echo  Internet services as follows.  These are not support locations, but may
echo  be used to submit problems you encounter using PROBREP.TXT.
echo.
echo  CompuServe: upload PROBREP.TXT to the WINNT forum, Library 3.
echo.
echo  FTP: Connect to ftp.microsoft.com
echo.
echo        (ftp)cd e:
echo        (ftp)cd incoming/bussys/winnt/probrep
echo        (ftp)bin
echo        (ftp)put probrep.txt
echo.
echo  Internet mail: send to ntbug@microsoft.com
echo.
echo  If after installing the %releasename% you wish to remove it, run
echo  %0 /U.  This command will remove the %releasename%
echo  and reinstate Program Manager from the previous Windows NT 3.51
echo  configuration.
echo.
pause
echo.
echo  If you have read this statement, and still want to install the
echo  %releasename%, press 'y' now or press 'n' to escape.
echo.
%ynccmd% "yn" "Do you wish to continue?"
if errorlevel 1 goto end
echo.

%delcmd% %SystemRoot%\system32\~* 2>nul

if exist %SystemRoot%\system32\~* goto renamerr
if exist %SystemRoot%\mstools\~* goto renamerr

%newdir% %SystemRoot%\system32\%old_user% 2>nul 1>nul
if NOT "%userexefiles%" == "" for %%i in (%userexefiles%) do (if exist %SystemRoot%\system32\%%i.exe %copycmd% %SystemRoot%\system32\%%i.exe %SystemRoot%\system32\%old_user%)
if NOT "%userdllfiles%" == "" for %%i in (%userdllfiles%) do (if exist %SystemRoot%\system32\%%i.dll %copycmd% %SystemRoot%\system32\%%i.dll %SystemRoot%\system32\%old_user%)
if NOT "%stampinuseexefiles%" == "" for %%i in (%stampinuseexefiles%) do (if exist %SystemRoot%\system32\%%i.exe %copycmd% %SystemRoot%\system32\%%i.exe %SystemRoot%\system32\%old_user%)
if NOT "%stampinusedllfiles%" == "" for %%i in (%stampinusedllfiles%) do (if exist %SystemRoot%\system32\%%i.dll %copycmd% %SystemRoot%\system32\%%i.dll %SystemRoot%\system32\%old_user%)

echo.
echo            **********************************************************
echo              A backup of the original files has been made in
echo              %SystemRoot%\system32\%old_user% for uninstall purposes.
echo            **********************************************************
echo.

:backup_done
rem
rem ************ Copy files into the appropriate system locations
rem
echo.
echo Copying files...

for %%i in (%userexefiles%) do (%copycmd% .\%%i.exe %SystemRoot%\system32\~%%i.exe && %moveboot% %SystemRoot%\system32\~%%i.exe %SystemRoot%\system32\%%i.exe)
for %%i in (%userdllfiles%) do (%copycmd% .\%%i.dll %SystemRoot%\system32\~%%i.dll && %moveboot% %SystemRoot%\system32\~%%i.dll %SystemRoot%\system32\%%i.dll)
for %%i in (%stampinuseexefiles%) do (%copycmd% %SystemRoot%\system32\%%i.exe %SystemRoot%\system32\~%%i.exe && %moveboot% %SystemRoot%\system32\~%%i.exe %SystemRoot%\system32\%%i.exe)
for %%i in (%stampinusedllfiles%) do (%copycmd% %SystemRoot%\system32\%%i.dll %SystemRoot%\system32\~%%i.dll && %moveboot% %SystemRoot%\system32\~%%i.dll %SystemRoot%\system32\%%i.dll)

for %%i in (%system32exefiles%) do (%copycmd% .\%%i.exe %SystemRoot%\system32\~%%i.exe && %moveboot% %SystemRoot%\system32\~%%i.exe %SystemRoot%\system32\%%i.exe)
for %%i in (%system32dllfiles%) do (%copycmd% .\%%i.dll %SystemRoot%\system32\~%%i.dll && %moveboot% %SystemRoot%\system32\~%%i.dll %SystemRoot%\system32\%%i.dll)
for %%i in (%system32cplfiles%) do (%copycmd% .\%%i.cpl %SystemRoot%\system32\~%%i.cpl && %moveboot% %SystemRoot%\system32\~%%i.cpl %SystemRoot%\system32\%%i.cpl)
for %%i in (%systemttffiles%)   do (%copycmd% .\%%i.ttf %SystemRoot%\system\~%%i.ttf   && %moveboot% %SystemRoot%\system\~%%i.ttf   %SystemRoot%\system\%%i.ttf)

for %%i in (%miscfiles%) do (%copycmd% %%i %SystemRoot%\system32\~%%i && %moveboot% %SystemRoot%\system32\~%%i %SystemRoot%\system32\%%i)

%newdir% %SystemRoot%\system32\viewers 2>nul 1>nul

for %%i in (%viewerexefiles%) do (%copycmd% %%i.exe %SystemRoot%\system32\viewers\~%%i.exe && %moveboot% %SystemRoot%\system32\viewers\~%%i.exe %SystemRoot%\system32\viewers\%%i.exe)
for %%i in (%viewerdllfiles%) do (%copycmd% %%i.exe %SystemRoot%\system32\viewers\~%%i.dll && %moveboot% %SystemRoot%\system32\viewers\~%%i.dll %SystemRoot%\system32\viewers\%%i.dll)

rem
rem ************ Run inxtoreg as necessary
rem

if NOT "%inxfiles%" == "" for %%i in (%inxfiles%) do %inxtoregcmd% %%i.inx >nul

rem
rem ************ Set explorer as shell
rem

%setshellcmd% Explorer.exe

rem
rem ************ Set welcome executable
rem

%setwelcomecmd% grpconv.exe

rem
rem ************* Version stamp exes
rem

for %%i in (%stampinuseexefiles%) do %imagecfg40cmd% %SystemRoot%\system32\~%%i.exe >nul
for %%i in (%stampinusedllfiles%) do %imagecfg40cmd% %SystemRoot%\system32\~%%i.dll >nul
for %%i in (%stampexefiles%) do (if exist %SystemRoot%\system32\%%i.exe %imagecfg40cmd% %SystemRoot%\system32\%%i.exe >nul)
for %%i in (%stampdllfiles%) do %imagecfg40cmd% %SystemRoot%\system32\%%i.dll >nul

rem
rem ************ Tell the user to reboot
rem

echo.
echo After rebooting you may uninstall by running '%0 /u'.
echo.

:needreboot
%ynccmd% "yn" "The Shell Preview has been %action%ed.  Press 'y' to reboot."
if errorlevel 1 goto end

echo.
echo Rebooting system...
%rebootcmd%
goto end

:usage
echo.
echo %0 [/u] : Install or uninstall the Shell Preview files
echo.
echo    - /u : Perform an uninstall instead of an install
echo.
goto end

rem
rem ************ Perform an uninstall
rem

:uninstall

echo.
rem
rem Check to make sure the old file exist
if not exist %SystemRoot%\system32\%old_user% goto cantundo
for %%i in (%userexefiles%) do (if not exist %SystemRoot%\system32\%old_user%\%%i.exe goto cantundo)
for %%i in (%userdllfiles%) do (if not exist %SystemRoot%\system32\%old_user%\%%i.dll goto cantundo)
for %%i in (%stampinuseexefiles%) do (if not exist %SystemRoot%\system32\%old_user%\%%i.exe goto cantundo)
for %%i in (%stampinusedllfiles%) do (if not exist %SystemRoot%\system32\%old_user%\%%i.dll goto cantundo)
%ynccmd% "yn" "Press 'y' to %action% the Shell Preview for Windows NT 3.51"
if errorlevel 1 goto end
echo.

rem
rem ************* Unversion stamp exes
rem

for %%i in (%stampexefiles%) do (if exist %SystemRoot%\system32\%%i.exe %imagecfg351cmd% %SystemRoot%\system32\%%i.exe >nul)
for %%i in (%stampdllfiles%) do %imagecfg351cmd% %SystemRoot%\system32\%%i.dll >nul

rem Restore progman as the default shell.
%setshellcmd% progman.exe

rem Restore the original NT 3.51 files
for %%i in (%userexefiles%) do (%moveboot% %SystemRoot%\system32\%old_user%\%%i.exe %SystemRoot%\system32\%%i.exe)
for %%i in (%userdllfiles%) do (%moveboot% %SystemRoot%\system32\%old_user%\%%i.dll %SystemRoot%\system32\%%i.dll)
for %%i in (%stampinuseexefiles%) do (%moveboot% %SystemRoot%\system32\%old_user%\%%i.exe %SystemRoot%\system32\%%i.exe)
for %%i in (%stampinusedllfiles%) do (%moveboot% %SystemRoot%\system32\%old_user%\%%i.dll %SystemRoot%\system32\%%i.dll)
%delcmd% /q /s %SystemRoot%\system32\viewers\*.*
%rmdircmd% /q /s %SystemRoot%\system32\viewers

rem
rem ************* Remove newly added associations
rem
echo.
echo Restoring original NT 3.51 registry settings.  Depending on the speed of
echo your machine, this could take one or two minutes...
echo.
%rmassoccmd% "*"
%rmassoccmd% .386
%rmassoccmd% .ani
%rmassoccmd% .bat
%rmassoccmd% .bfc
%rmassoccmd% .bmp
%rmassoccmd% .cmd
%rmassoccmd% .com
%rmassoccmd% .cpl
%rmassoccmd% .cur
%rmassoccmd% .dll
%rmassoccmd% .drv
%rmassoccmd% .exe
%rmassoccmd% .fnd
%rmassoccmd% .fon
%rmassoccmd% .grp
%rmassoccmd% .hlp
%rmassoccmd% .ico
%rmassoccmd% .inf
%rmassoccmd% .ini
%rmassoccmd% .lnk
%rmassoccmd% .pif
%rmassoccmd% .reg
%rmassoccmd% .rtf
%rmassoccmd% .scr
%rmassoccmd% .shb
%rmassoccmd% .shs
%rmassoccmd% .sys
%rmassoccmd% .ttf
%rmassoccmd% .txt
%rmassoccmd% .vxd
%rmassoccmd% .wav
%rmassoccmd% anifile
%rmassoccmd% AudioCD
%rmassoccmd% batfile
%rmassoccmd% Briefcase
%rmassoccmd% cmdfile
%rmassoccmd% comfile
%rmassoccmd% cplfile
%rmassoccmd% curfile
%rmassoccmd% Directory
%rmassoccmd% dllfile
%rmassoccmd% DocShortcut
%rmassoccmd% Drive
%rmassoccmd% drvfile
%rmassoccmd% exefile
%rmassoccmd% fndfile
%rmassoccmd% Folder
%rmassoccmd% fonfile
%rmassoccmd% hlpfile
%rmassoccmd% icofile
%rmassoccmd% inffile
%rmassoccmd% inifile
%rmassoccmd% lnkfile
%rmassoccmd% MSProgramGroup
%rmassoccmd% Network
%rmassoccmd% piffile
%rmassoccmd% QuickView
%rmassoccmd% regfile
%rmassoccmd% ShellScrap
%rmassoccmd% scrfile
%rmassoccmd% sysfile
%rmassoccmd% ttffile
%rmassoccmd% txtfile
%rmassoccmd% vxdfile

rem Add back default associations
%restassoccmd%

echo.
goto needreboot

:cantundo
echo   The files required to perform an uninstall of the Shell Preview
echo   could not be found in (%systemroot%\system32\%old_user%).
echo   This may be because the Shell Preview has never been installed
echo   on this system, or because the Shell Preview has already been
echo   uninstalled, or because these files have deleted by some other
echo   means.
echo.
goto end

rem
rem ************ Error condition
rem
:renamerr
echo.
echo   Some files which had to be deleted could not be deleted.  This probably
echo   means that you have not rebooted since you last ran %0, and those
echo   files are still in use.  Reboot and try again.
echo.
goto end


:end
ENDLOCAL
echo.
