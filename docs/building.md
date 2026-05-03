
# Building MultiPatcher

This document explains how to build MultiPatcher using Meson, Ninja, DOSBox, and Turbo C++ 3.

## Prerequisites

Required:

1. Meson  
   `pip install meson`

2. Ninja  
   `pip install ninja`

3. DOSBox or DOSBox-X  
   [Download DOSBox](https://www.dosbox.com/)

4. Turbo C++ 3  
   [Download Turbo C++](https://turbo-c.net/)

Optional (recommended):

1. Mesonconfig  
   `pip install mesonconfig`

## Instructions

1. Run `mesonconfig` on the project directory.
2. Go to the "External Tools" menu.
3. Change "Path to DOSBox executable" to the path where the DOSBox executable is located, **including the executable filename**.
    The following is an example for Linux:
    `(/usr/bin/dosbox) Path to DOSBox executable`
4. Change "Turbo C++ directory" to the path where Turbo C++ is installed. (The path must contain BIN, INCLUDE, etc)
    The following is an example for Windows:
    `(C:\\TURBOC) Turbo C++ directory`
5. Run `meson setup <output_directory> --native-file local.conf`.
    The following is an example command:

    ```sh
    meson setup builddir --native-file local.conf
    ```

6. Run `meson compile -C <output_directory>` to build MultiPatcher.
    The following is an example command:

    ```sh
    meson compile -C builddir
    ```

   The ISO image will be generated as `<output_directory>/MultiPatcher.iso`

## Manual Configuration (Without mesonconfig)

1. In the root of the MultiPatcher directory, create a new file named `local.conf`.
2. Add the following configuration **(use double backslashes for Windows)**:

    ```ini
    [project options]
    dosbox = '<dosbox-file>'
    tcc = '<tcc-folder>'
    ```

    - `<dosbox-file>` must point to the path where the DOSBox executable is located, **including the executable filename**.
        The following is an example:
        `dosbox = 'C:\\DOSBox-X\\DOSBox-X.exe'`

    - `<tcc-folder>` must point to the path where Turbo C++ is installed. (The path must contain BIN, INCLUDE, etc)

Then continue from step 5 in [Instructions](#instructions).

## Building MPC for Windows VB4

You will need a copy of Microsoft Visual Basic 4.0 16-bit to compile this application. [Microsoft Visual Basic 4.0](https://winworldpc.com/product/microsoft-visual-bas/40)

1. Open Microsoft Visual Basic 4.0 16-bit
2. Open the project in `source/VB4`
3. Make necessary modifications and compile it using the File menu in VB4.
4. Copy the compiled .EXE file as `source/BASE/Patchg16.exe` along with the `DATA/` folder.
5. Recompile the whole project using meson.
