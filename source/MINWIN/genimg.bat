@echo off
rem genimg.bat – Windows equivalent of genimg.sh
rem Usage: genimg.bat <template> <content-dir> <output>
rem Generates a bootable floppy image by copying content into a template.
rem Requires ImDisk (imdisk.exe) – https://sourceforge.net/projects/imdisk-toolkit/

setlocal enabledelayedexpansion

rem ----- argument checks -----
if "%~3"=="" (
    echo ERROR: Usage: %~nx0 ^<template^> ^<content-dir^> ^<output^> >&2
    exit /b 1
)

set "TEMPLATE=%~1"
set "CONTENT=%~2"
set "OUTPUT=%~3"

if not exist "%TEMPLATE%" (
    echo ERROR: Template image not found: "%TEMPLATE%" >&2
    exit /b 1
)
if not exist "%CONTENT%\" (
    echo ERROR: Content directory not found: "%CONTENT%" >&2
    exit /b 1
)

rem ----- check for required tool -----
where imdisk >nul 2>nul
if %errorlevel% neq 0 (
    echo ERROR: imdisk is not installed or not in PATH. Please install ImDisk Toolkit. >&2
    exit /b 1
)

rem ----- work -----
echo Copying template to output...
copy /y "%TEMPLATE%" "%OUTPUT%" >nul
if %errorlevel% neq 0 (
    echo ERROR: Failed to copy template to "%OUTPUT%" >&2
    exit /b 1
)

echo Mounting image as floppy...
imdisk -a -f "%OUTPUT%" -m A: -o rem
if %errorlevel% neq 0 (
    echo ERROR: Failed to mount image. Ensure ImDisk is installed and you have necessary rights. >&2
    exit /b 1
)

echo Copying content to image...
xcopy "%CONTENT%\*" A:\ /E /H /K /Y >nul
set XCOPY_ERR=%errorlevel%
if %XCOPY_ERR% neq 0 (
    rem xcopy returns 0 even if files copied, 1 if no files, but we ignore 1.
    if %XCOPY_ERR% gtr 1 (
        echo ERROR: xcopy failed with errorlevel %XCOPY_ERR% >&2
        imdisk -D -m A: >nul 2>&1
        exit /b 1
    )
)

echo Unmounting image...
imdisk -D -m A:
if %errorlevel% neq 0 (
    echo WARNING: Unmounting may have failed, but the image is already written. >&2
)

echo BOOT.IMG successfully generated.
exit /b 0