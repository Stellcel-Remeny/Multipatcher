@echo off
rem isogen.bat – Windows ISO generator using xorriso
rem Usage: isogen.bat <staging_dir> <output_iso> [xorriso_exe]
rem If xorriso_exe is omitted, looks for 'xorriso.exe' in the same directory as this script.

setlocal enabledelayedexpansion

if "%~2"=="" (
    echo ERROR: Usage: %~nx0 ^<staging_dir^> ^<output_iso^> [xorriso_exe] >&2
    exit /b 1
)

set "STAGING=%~1"
set "OUTPUT=%~2"

if not exist "%STAGING%\" (
    echo ERROR: Staging directory not found: "%STAGING%" >&2
    exit /b 1
)

rem --- find xorriso ---
if not "%~3"=="" (
    set "XORRISO=%~3"
) else (
    rem default: look in same folder as this script
    set "XORRISO=%~dp0xorriso.exe"
)

if not exist "%XORRISO%" (
    echo ERROR: xorriso.exe not found at "%XORRISO%" >&2
    echo        Download xorriso for Windows and place it in the UTILS directory. >&2
    exit /b 1
)

rem --- verify essential boot files ---
if not exist "%STAGING%\BOOT.IMG" (
    echo ERROR: Missing %STAGING%\BOOT.IMG >&2
    exit /b 1
)
if not exist "%STAGING%\BOOT\isolinux.bin" (
    echo ERROR: Missing %STAGING%\BOOT\isolinux.bin >&2
    exit /b 1
)
if not exist "%STAGING%\isohdpfx.bin" (
    echo ERROR: Missing %STAGING%\isohdpfx.bin >&2
    exit /b 1
)
if not exist "%STAGING%\BOOT\efi.img" (
    echo ERROR: Missing %STAGING%\BOOT\efi.img >&2
    exit /b 1
)

rem --- build ISO ---
"%XORRISO%" -as mkisofs ^
  -iso-level 3 ^
  -full-iso9660-filenames ^
  -volid MPC ^
  -eltorito-boot BOOT/isolinux.bin ^
  -eltorito-catalog boot.cat ^
  -no-emul-boot ^
  -boot-load-size 4 ^
  -boot-info-table ^
  -eltorito-alt-boot ^
  -e BOOT/efi.img ^
  -no-emul-boot ^
  -eltorito-platform efi ^
  -isohybrid-mbr "%STAGING%\isohdpfx.bin" ^
  -isohybrid-gpt-basdat ^
  -o "%OUTPUT%" ^
  "%STAGING%"

if errorlevel 1 (
    echo ERROR: xorriso failed >&2
    exit /b 1
)

echo ISO successfully created: %OUTPUT%
exit /b 0