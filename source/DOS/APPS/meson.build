#
# Build file for 16-bit MultiPatcher DOS Applications
#

# Imports
python = import('python').find_installation()
fs = import('fs')

# Variables for directories (these are full paths in the source tree)
bin_patches  = meson.project_source_root() / get_option('BIN_DIR') / 'RES' / 'PATCHES'
bin_utils    = meson.project_source_root() / get_option('BIN_DIR') / 'RES' / 'UTILS'
bin_cosmetic = meson.project_source_root() / get_option('BIN_DIR') / 'RES' / 'COSMETIC'
bin_drivers  = meson.project_source_root() / get_option('BIN_DIR') / 'RES' / 'DRIVERS'

# -------------------------------------------------------------------
# 1. List subdirectories in a portable way
# -------------------------------------------------------------------
list_cmd = [python, '-c',
    'import os; print("\\n".join(d for d in os.listdir(".") if os.path.isdir(d)))']
result = run_command(list_cmd, check: true)
subdir_names = result.stdout().strip().split('\n')

# -------------------------------------------------------------------
# 2. Gather information from each subdirectory that has a meson.build
# -------------------------------------------------------------------
apps = []   # each entry: [ subdir_name, source_file, output_file, dest_relative_path, actual_source_filename ]
foreach d : subdir_names
    d = d.strip()
    if d == ''
        continue
    endif
    # Does it contain a meson.build?
    if fs.is_dir(d) and fs.is_file(d / 'meson.build')
        # Enter the subdirectory. Afterwards, 'source_file' and 'install_bin_dir'
        # will be in scope
        subdir(d)

        # Make sure the required variables exist
        if not is_variable('source_file') or not is_variable('install_bin_dir')
            error('Meson.build in ' + d + ' must define "source_file" and "install_bin_dir"')
        endif

        # Resolve the actual case‑sensitive filename of the source file on disk
        resolve_cmd = [python, files('resolve_case.py'), meson.current_source_dir() / d, source_file]
        resolved = run_command(resolve_cmd, check: true)
        actual_source = resolved.stdout().strip()

        # Determine the output EXE name (strip the extension and add .EXE)
        out = actual_source.split('.')[0] + '.EXE'

        # ---- destination path calculation ----
        bin_dir = get_option('BIN_DIR')
        prefix = meson.project_source_root() / bin_dir
        # Remove the prefix and the leading '/'
        rel_dest = install_bin_dir.replace(prefix, '')
        if rel_dest.startswith('/')
            rel_dest = rel_dest.substring(1)
        endif
        if rel_dest == ''
            rel_dest = '.'
        endif
        # Finally the destination inside staging_dir will be:
        #   staging_dir / rel_dest / d / out
        dest_path = rel_dest / d / out
        # ----------------------------------------

        message('DOSAPP Target Input file: ' + d + '/' + actual_source)
        message('DOSAPP Target Output file: ' + out)
        message('DOSAPP Target dest: ' + dest_path)

        apps += [[d, actual_source, out, dest_path]]
    endif
endforeach

# Build a list of all source files (to use as inputs for the incremental script)
app_src_files = []
foreach a : apps
    # a[0]=subdir, a[1]=source C file
    app_src_files += files(a[0] / a[1])
endforeach

# The library objects are defined in the parent DOS meson.build and are visible here:
# lib_obj_mpc, lib_obj_mini
lib_objects = [lib_obj_mpc, lib_obj_mini]

# Also include the library source/header files for change detection
lib_src_files = files(
    '../INCLUDE/MPCLIB.C',
    '../INCLUDE/minIni.c',
    '../INCLUDE/MPCLIB.H',
    '../INCLUDE/minIni.h',
    '../INCLUDE/minGlue.h',
)

# All inputs: app sources, generated OBJ files, and library source files
gen_bat_inputs = app_src_files + lib_objects + lib_src_files

# -------------------------------------------------------------------
# 3. Generate CMPDAPPS.BAT (incremental)
# -------------------------------------------------------------------
# Use a single Python script that checks each app and writes only needed commands.
gen_bat_script = files('gen_cmpdapps_incremental.py')

gen_bat_inputs = app_src_files + lib_objects + lib_src_files

# Arguments for the script:
# --batch <output batch file>
# --builddir <meson.current_build_dir()>
# --tcc <tcc>
# --srcdir <source_directory>
# --objdir <custom_include_path_OBJ>
# --redirect-log (if needed)
# --exit (if needed)
# then per app: subdir source_file output_file
gen_bat_args = [
    '--batch', meson.current_build_dir() / 'CMPDAPPS.BAT',
    '--builddir', meson.current_build_dir(),
    '--srcdir', meson.current_source_dir(),
    '--tcc', tcc,
    '--objdir', custom_include_path_OBJ,
]
if get_option('TCC_OUTPUT_TO_FILE')
    gen_bat_args += ['--redirect-log']
endif
if get_option('EXIT_ON_16BIT_COMPILATION')
    gen_bat_args += ['--exit']
endif

foreach a : apps
    gen_bat_args += [a[0], a[1], a[2]]
endforeach

gen_bat = custom_target('gen_cmpdapps_bat',
    input: gen_bat_inputs,
    output: 'CMPDAPPS.BAT',
    command: [python, gen_bat_script] + gen_bat_args,
    build_by_default: true,
)

# -------------------------------------------------------------------
# 4. Run DOSBox (depends on the batch file and the main mpc_dos)
# -------------------------------------------------------------------
dosbox_cmd_list = [
    dosbox,
    '-noconsole',
    '-c', 'cls',
    '-c', 'mount x "' + tcc + '"',
    '-c', 'mount y "' + meson.current_source_dir() + '"',
    '-c', 'mount r "' + meson.current_build_dir() + '"',
    '-c', 'mount i "' + custom_include_path + '"',
    '-c', 'mount o "' + custom_include_path_OBJ + '"',
    '-c', 'PATH %PATH%;x:\\BIN',
    '-c', 'r:',
    '-c', 'del TCC_LOG.TXT',
    '-c', 'CMPDAPPS.BAT',
]
if get_option('EXIT_ON_16BIT_COMPILATION')
    dosbox_cmd_list += ['-c', 'exit']
endif

run_dosbox = custom_target('other_dos_apps',
    output: 'ALL_DOS_APPS_BUILT.TXT',
    command: dosbox_cmd_list,
    depends: [mpc_dos, gen_bat],
    build_by_default: true,
)

# -------------------------------------------------------------------
# 5. Copy the built EXE files into the staging directory
# -------------------------------------------------------------------
copy_args = []
copy_args += ['--builddir', meson.current_build_dir()]
copy_args += ['--staging', join_paths(meson.project_build_root(), get_option('BIN_DIR'))]

foreach a : apps
    # output_file, dest_path
    copy_args += [a[2], a[3]]
endforeach

copy_target = custom_target('copy_dos_apps',
    output: 'dos_apps_copied.stamp',
    command: [python, files('copy_dos_apps.py')] + copy_args,
    depends: run_dosbox,
    build_by_default: true,
)