
# MultiPatcher

![MultiPatcher Logo](media/mpc_banner.png)

MultiPatcher is a modular utility framework and collection of system tools and patches spanning operating systems from MS-DOS to Microsoft Windows 11.

---

## Features

MultiPatcher can package utilities, patches, visual system modifications, and drivers directly, or wrap them with additional functionality (for example, adding configuration layers when a patch does not natively support them).

Key features:

- Customizable interface
- Easy expandability
- Supports MS-DOS, Windows 3.1, Windows 9x, Windows NT, and modern Windows systems (including Windows 11)
- Includes bootable MS-DOS and Mini Windows 3.1 environments
- Unified interface for system utilities and patches

---

## Preview

![MultiPatcher running under MS-DOS](media/mpc_dos.gif)
![Mini Windows 3.1 interface](media/mpc_mwin.gif)
![Windows XP GUI](media/mpc_wxp.png)

---

## Architecture

MultiPatcher consists of three platform targets:

- **MS-DOS**: 16-bit terminal application compiled with Turbo C++ 3
- **Windows 3.1 / 95 / 98 / ME / NT 3.1–XP**: 16-bit Visual Basic 4.0 application
- **Windows Vista and above**: 32-bit Delphi application

### Launcher behavior

A compatibility launcher (`Patcher.bat`) detects the operating environment and launches the appropriate binary:

- MS-DOS → `patchx16.exe`
- Windows 95 / 98 / ME / NT 3.1–XP → `patchg16.exe`
- Windows Vista and above → `patchg32.exe`

---

## Layout

The `DATA/` directory contains data that affects the Interface itself.

The `RES/` directory contains data that consists of "menus" and "entries".

- Other directories inside `RES/` contain utilities, patches, and tools

### Content classification

- A directory containing `lfn.ini` is treated as a **menu**  
  See: [LFN.INI structure](docs/ini_structures.md#lfnini-structure)

- A directory containing `info.ini` is treated as an **entry**  
  See: [INFO.INI structure](docs/ini_structures.md#infoini-structure)

---

## Goals

MultiPatcher is designed to provide a lightweight and modular environment for launching system utilities and applying system-level patches.

It targets practical system tools rather than full application suites (such as disk partition managers). Lightweight configuration and repair utilities are the primary focus.

---

## Cloning

Ensure Git is installed.

```sh
git clone https://github.com/Stellcel-Remeny/Multipatcher.git --depth 1
````

The `--depth 1` option performs a shallow clone to reduce download size.

---

## Building

See [Building Instructions](docs/building.md)

---

## Credits

For a full list of included utilities and contributors, see [CREDITS](CREDITS.md).
