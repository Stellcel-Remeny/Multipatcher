
# INI File Structures

This document describes the structure of `LFN.INI` (menus) and `INFO.INI` (entries) used by MultiPatcher.

---

## Menus (`LFN.INI`)

A folder inside `RES/` is treated as a **menu** if it contains an `LFN.INI` file.

Menus:

- represent navigation nodes in the MultiPatcher interface
- contain other menus or entries

### LFN.INI structure

#### `[MAIN]`

- `name=`  
  Display name shown in the MultiPatcher interface

#### `[OS]`

Visibility flags per operating system:

- `msdos=<true|false>`
- `w31=<true|false>`
- `w95=<true|false>`
- `w98=<true|false>`
- `wme=<true|false>`
- `nt31=<true|false>`
- `nt35=<true|false>`
- `nt351=<true|false>`
- `nt4=<true|false>`
- `w2k=<true|false>`
- `wxp=<true|false>`

Set each flag to control where the menu appears.

---

## Entries (`INFO.INI`)

A folder inside `RES/` is treated as an **entry** if it contains an `INFO.INI` file.

Entries:

- represent executable utilities, patches, or tools
- appear inside menus
- can be executed by MultiPatcher

### INFO.INI structure

#### `[MAIN]`

- `name=`  
  Display name in the interface

- `description=`  
  Short description of the item

- `author=`  
  Creator of the item

- `version=`  
  Version string

- `executable=<true|false>`  
  Marks whether the entry can be executed

---

#### `[OS]`

Same visibility flags as menus:

- `msdos=<true|false>`
- `w31=<true|false>`
- `w95=<true|false>`
- `w98=<true|false>`
- `wme=<true|false>`
- `nt31=<true|false>`
- `nt35=<true|false>`
- `nt351=<true|false>`
- `nt4=<true|false>`
- `w2k=<true|false>`
- `wxp=<true|false>`

---

#### `[MSDOS]`

Used when running under DOS:

- `exec=`  
  Executable name

- `args=`  
  Default arguments

- `passArgs=<true|false>`  
  Forwards arguments from MultiPatcher and appends `/MPC`

- `batchMode=<true|false>`  
  Runs via `system()` (COMMAND.COM). Required for batch scripts

- `pauseOnQuit=<true|false>`  
  Waits for a keypress after execution finishes

---

#### `[<winver>]` sections

Any Windows version-specific override section (e.g. `[w95]`, `[wxp]`, etc.):

- `exec=` executable name
- `args=` default arguments

These override or supplement OS-specific execution settings.
