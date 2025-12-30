======================================================================
  Microsoft(R) Product Support Services Application Note (Text File)
                   PW1118: MICROSOFT WIN32S UPGRADE
======================================================================
                                                  Revision Date: 5/95
                                                       1 Disk Included

The following information applies to Microsoft Win32s, version 1.25A.

 ---------------------------------------------------------------------
| INFORMATION PROVIDED IN THIS DOCUMENT AND ANY SOFTWARE THAT MAY     |
| ACCOMPANY THIS DOCUMENT (collectively referred to as an Application |
| Note) IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER      |
| EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED      |
| WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR       |
| PURPOSE. The user assumes the entire risk as to the accuracy and    |
| the use of this Application Note. This Application Note may be      |
| copied and distributed subject to the following conditions: 1) All  |
| text must be copied without modification and all pages must be      |
| included;  2) If software is included, all files on the disk(s)     |
| must be copied without modification (the MS-DOS(R)  utility         |
| diskcopy is appropriate for this purpose);  3) All components of    |
| this Application Note must be distributed together;  and  4) This   |
| Application Note may not be distributed for profit.                 |
|                                                                     |
| Copyright (C) 1994-1995 Microsoft Corporation. All Rights Reserved. |
| Microsoft, MS-DOS, Win32, and Win32s are registered trademarks and  |
| Windows is a trademark of Microsoft Corporation.                    |
|  -------------------------------------------------------------------|

Microsoft Win32s version 1.25A is the latest version of the software
that allows you to run Win32-based applications on Windows(TM) 
or Windows for Workgroups versions 3.1 and later.

The "Microsoft Win32s Upgrade" Application Note disk contains the file
W32S125.EXE; the file LICENSE.TXT, which has legal information
regarding redistribution of Win32s files [please consult the Win32s
"Programmer's Reference," which is part of the Microsoft Win32
Software Development Kit (SDK), for further information]; and a
README.TXT file, which is the text of this Application Note.

The "Microsoft Win32s Upgrade" does not include OLE support. For OLE
support for Win32-based applications under Win32s, you need the Microsoft
Win32(R) SDK.

The Win32s upgrade is intended as an end-user upgrade and is not
intended for further redistribution.

The following are instructions for installing Win32s.

Decompressing the Setup Program Files
-------------------------------------

The Win32s files are provided in a compressed state in the W32S125.EXE
file. This executable file decompresses the setup files for Win32s:

1. Create a directory on your hard drive for the decompressed files.
   For example, you could create the directory "INSTALL" by entering
   the following at the command prompt:

      mkdir install

2. Copy W32S125.EXE to the new INSTALL directory, change directories to
   the INSTALL directory, and type the following at the command prompt:

      w32s125

This decompresses the Win32s files into an installation layout (setup
program) in the INSTALL directory.

Installing Win32s on Your System
--------------------------------

1. To install Win32s, run Windows and start the File Manager.

2. Open the INSTALL directory (the directory created in step 1 of the
   setup instructions above).

3. Double-click SETUP.EXE. The setup program installs Win32s and
   reboots the system to update system files.

   Win32s is now installed or upgraded on your system, and any
   obsolete Win32s files have been removed.

4. Delete the INSTALL directory and its contents.

Additional Information
----------------------

BUG: Win32s 1.25a Bug List                                    [win32sdk]
ID: Q130138    CREATED: 11-MAY-1995   MODIFIED: 11-MAY-1995
1.25a
WINDOWS
PUBLIC | kbprg kbbuglist

-----------------------------------------------------------------------
The information in this article applies to:

 - Microsoft Win32s, version 1.25a
-----------------------------------------------------------------------

The following is a list of the known bugs in Win32s version 1.25 at the
time of its release.

 - Incorrect context at EXIT_PROCESS_DEBUG_EVENT.

 - Progman gets restored when debugger app exits.

 - Using StartDoc() does not produce document from printer.

 - EM_GETWORDBREAKPROC return code is incorrect.

 - Int 3 cannot be trapped via Structured Exception Handling (SEH) on
   Win32s.

 - Win32s does not open all files in RAW mode, as Windows NT does.

 - Cannot do ReadProcessMemory (RPM) on memory that has a hardware
   breakpoint set on it.

 - C Run-Time functions getdcwd()/getcwd() do not work.

 - GetFullPathName() returns the root directory for any drive that is not
   the current drive.

 - PlayMetaFileRecord()/EnumMetaFile() contains incorrect lpHTable.

 - Size of memory mapped files is rounded to a whole number of pages,
   meaning that the size is a multiple of 4096 bytes.

 - Functions chdrive() and SetCurrentDirectory() fail on PCNFS network
   drives.

 - GetExitCodeProcess() does not return exit codes for 16-bit Windows-based
   applications.

 - Memory passed to Netbios() must be allocated with GlobalAlloc().

 - biSizeImage field of BITMAPINFOHEADER is zero.

 - CreateFile() on certain invalid long filesnames closes Windows.

 - Only the first CBT hook gets messages.

 - Most registry functions return the Windows 3.1 return codes, not the
   Windows NT return codes.

 - GlobalReAlloc(x,y,GMEM_MOVEABLE) returns wrong handle type.

 - GetVolumeInformation() fails for Universal Naming Convention (UNC)
   root path.

 - ResumeThread while debugging writes to debuggee stack.

 - GetShortPathName() doesn't fail with a bad path, as it does on
   Windows NT.

 - CreateDirectory()/RemoveDirectory() handle errors differently than on
   Windows NT.

 - SetCurrentDirctory() returns different error codes than on Windows NT.

 - FindText() leaks memory.

 - Win32s doesn't support language files other than default (l_intl.nls).

 - spawnl does not pass parameters to an MS-DOS-based application.

 - Win32s does not support forwarded exports.

 - GetDlgItemInt() only translates numbers <= 32767 (a 16-bit integer).

 - Changing system locale in Win32s will not have an effect until Win32s
   is loaded again, unlike on Windows NT.

 - Module Management APIs missing ANSI to OEM translation.

 - When WS_TABSTOP is passed to CreateWindow(), this forces a
   WS_MAXIMIZEBOX.

 - Stubbed API FindFirstFileW() does not return -1 to indicate failure.

 - SearchPath() and OpenFile() don't work properly with OEM chars in the
   filename.

 - GetSystemInfo() doesn't set correct ProcessorType for the Pentium.

 - FormatMessage() doesn't set last error.

 - FormatMessage() fails with LANG_NEUTRAL | SUBLANG_DEFAULT, but works
   with LANG_ENGLISH | SUBLANG_ENGLISH_US.

 - After calling CreateFile() on a write-protected floppy GetLastError()
   returns 2, instead of 19, as it should.

 - VirtualProtect() with anything other than PAGE_NOACCESS, PAGE_READ, OR
   PAGE_READWRITE yields unpredictable page protections.

 - COMPAREITEMSTRUCT, DELETEITEMSTRUCT, DRAWITEMSTRUCT, AND
   MEASUREITEMSTRUCT incorrectly sign-extend fields.

 - GetWindowTextLength() & GetWindowText() incorrectly sign-extend the
   return value.

 - MoveFile() fails on Windows for Workgroups when the source is remote and
   the destination is local.

Additional reference words: 1.25 1.25a
KBCategory: kbprg kbbuglist
KBSubcategory: W32s

FIX: Win32s 1.25a Fix List                                    [win32sdk]
ID: Q130139    CREATED: 11-MAY-1995   MODIFIED: 11-MAY-1995
1.25a
WINDOWS
PUBLIC | kbprg kbfixlist kbbuglist

-----------------------------------------------------------------------
The information in this article applies to:

 - Microsoft Win32s, version 1.25a
-----------------------------------------------------------------------

The following is a list of the known bugs in Win32s version 1.2 that
were fixed in Win32s version 1.25.

 - GlobalAlloc(GMEM_FIXED) from 32-bit .EXE locks memory pages. It is
   more efficient to use GlobalAlloc(GMEM_MOVEABLE) and call GlobalFix()
   if necessary.

 - WINMM16.DLL has no version information.

 - CreateFileMapping() with SEC_NOCOMMIT returns ERROR_INVALID_PARAMETER.

 - PolyPolygon() does not close the polygons.

 - OpenFile() only searches the current directory when only a filename is
   given, not the application directory, the system directory, the windows
   directory, or the directories listed on the path.

 - GetFileInformationByHandle() doesn't return the correct file attribute.

 - GlobalUnlock() sets an error of ERROR_INVALID_PARAMETER.

 - lstrcmp()/lstrcmpi() do not use the collate table correctly.

 - FreeLibrary() in DLL_PROCESS_DETACH crashes the system.

 - FindResource(), LoadResource(), GetProcAddress(), GetModuleFileName(),
   EnumResourceNames(), and other APIs, fail with a NULL hInstance.

 - sndPlaySound() with SND_ASYNC | SND_MEMORY may cause a crash or may work
   poorly.

 - Thread Local Storage (TLS) data is not initialized to 0 in TlsAlloc().

 - The pointer received in the lParam of WM_INITDIALOG in the common dialog
   hook function becomes invalid in the following messages if the pointer
   is "remembered" in a static variable.

 - Stubbed API GetFileAttributesW() does not return -1 on error.

 - Code page CP_MACCP not supported.

 - Invalid LCIDs are not recognized.

 - CreateFile() fails to open an existing file in share mode.

 - GetLocaleInfo() for locale returns system defaults from WIN.INI.\* #595

 - GetVolumeInformation() fails with ERROR_INVALID_NAME for volumes
   without a label.

 - VirtualProtect() may miss the last page in an address range.

 - GetLocaleInfo() returns incorrect information for most non-US locales.

 - ANSI/OEM conversions always use code page 437.

 - GetProcAddress() for printer driver APIs is case sensitive.

 - The LanMan APIs are unsupported, but they return 0, which indicates
   that the API was successful. They should return NERR_InvalidAPI (2142).

 - CreateFileW() returns 0 instead of -1 (HFILE_ERROR).

 - lstrcpyn() copies n bytes from source to destination, then appends a
   NULL terminator, instead of copying n-1 bytes and appending the NULL
   terminator.

 - GetDriveType() doesn't report detecting a CD-ROM or a RAM DISK.

 - CRTDLL calls TlsFree() upon each process detach, not just the last.

 - If a DllEntryPoint calls FreeLibrary() when using universal thunks,
   the system can crash.

 - Not all 32-bit DLLs have correct version numbers.

 - GetCurrentDirectory() returns the wrong directory after calling
   GetOpenFileName(). The workaround is to call SetCurrentDirectory(".")
   right after returning from the call to GetOpenFileName().

 - RegEnumValue() and other Registry functions return ERROR_SUCCESS even
   though they are not implemented. Win32s implements only the registry
   functions supported by Windows.

 - AreFileApisANSI()/SetFileApisToANSI()/SetFileApisToOEM() are not
   exported. AreFileApisANSI() should always return TRUE, SetFileApiToOEM()
   should always fail, and SetFileApiToANSI() should always succeed.

 - SetLocaleInfoW()/SetLocateInfoA() are not implemented.

 - GetScrollPos() sets the last error if the scroll position is 0.

 - SetScrollPos() sets the last error if the last scroll position is 0.

 - LoadString() leaks memory if the string is a null string.

 - GetFileVersionInfoSize() fails if the resource section is small and
   close to the end of the file.

 - MoveFile() doesn't call SetLastError() on failure or sets a different
   error than on Windows NT.

 - SetCurrentDirectory() does not work on a CD-ROM drive.

 - GetFileVersionInfoSize() fails if the 2nd parameter is NULL.

 - WSOCK32.DLL is missing exported stubs for unimplemented APIs.

 - Win32s fails to load 64x64 monochrome (black and white) icons.

 - CreateFile() fails when called with a filename with an international
   character.

 - GetCurrentDirectory() returns an OEM string.

 - PrintDlg() causes GP fault if hDevMode!=NULL and another printer is
   selected that uses a larger DevMode buffer.

 - Unicode resources are not properly converted to 8 bit characters.

 - CreateDC() returns an incorrect DEVMODE. This can cause a variety of
   symptoms, like the inability to do a Landscape Print Preview from an
   MFC application or the displayed paper width and height not changing,
   even when you change the paper size.

 - OpenFile() fails on filenames with OEM characters in the name.

 - GetDriveType() fails on a Stacker 3.1 drive.

 - SetCurrentDirectory() fails on Novell client machines.

 - GetProp() returns 0 in the second instance of an app in certain cases.

 - fopen(fn, "w") fails on second call.

 - TLS indices allocated by a module are released when that module is freed.


 - CreateWindow() handles STARTUPINFO incorrectly if the application starts
   minimized.

 - CreateFile() creates files with incorrect attributes.

 - Resource sections are now read/write to emulate the behavior of Windows
   NT and Windows 95.

 - Removed the 128K stack limitation.

 - CompareStringW() sometimes uses incorrect locale, primarily Swedish and
   other Scandinavian locales.

 - Added dummy _iob to CRTDLL for applications that reference standard
   handles.

 - Added support for OPENCHANNEL, CLOSECHANNEL, SEXGDIXFORM, and
   DOWNLOADHEADER escapes.

Additional reference words: 1.25 1.25a
KBCategory: kbprg kbfixlist kbbuglist
KBSubcategory: W32s
