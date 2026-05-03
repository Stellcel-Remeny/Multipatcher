
# Adding Utilities

You can add new utilities, patches, and related files to your local instance of MultiPatcher, either at compile time or after compilation.

For an already compiled instance, follow [Adding Utilities at Compile-Time](#adding-utilities-at-compile-time) steps 1–4, but use the `RES` directory in the compiled output instead of `source/BASE/RES`.

You can also add a custom `.C` file (for the MultiPatcher MS-DOS application), which can take advantage of `MPCLIB.C`. See [Adding Custom DOS Applet](#adding-custom-dos-applet)

## Adding Utilities at Compile-Time

1. In `source/BASE/RES` directory, create a directory with a name no longer than **8 characters**.
2. Inside that directory, create either:
    - `LFN.INI` if the directory will serve as a menu (holds more menus/entries)
    - `INFO.INI` if the directory will serve as an entry (holds the actual utility/patch/etc.)

3. Populate the `.INI` file. View [INI file structures](ini_structures.md)
4. Add the required files, such as executables. File names must follow the **8.3 filename format**.
5. [Compile MultiPatcher](building.md#instructions)

## Adding Custom DOS Applet

You can add a custom `.C` file to be compiled by Turbo C++ 3 compiler in DOSBox, and then automatically be added into your local MultiPatcher instance. This is called a **DOS Applet**.

By doing this, you can also choose to include the `MININI.C` and `MPCLIB.C` files in your C file alongside any other libraries found in `source/DOS/INCLUDE`, which are automatically made available to the custom `.C` file.

Steps to add a custom DOS Applet:

1. In the directory `source/DOS/APPS`, create a new directory with a name **no longer than 8 characters**.
2. Inside that directory, add a file named `meson.build`.
3. Copy the template given in [DOS Applet Template](dos_applet_template.md), and follow its instructions.
4. Add your `.C` file with the `<src_c_file>` name you have set in your `meson.build` file.
5. Delete any existing build directory you may have currently, and then [compile MultiPatcher](building.md#instructions).
