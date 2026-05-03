#
# Build file for 16-bit MultiPatcher MS-DOS Application
#

# Imports
python = import('python').find_installation()

# Get DOS utility paths from options
tcc     = get_option('TCC')
dosbox  = get_option('DOSBOX')

if tcc == ''
    error('TCC Path empty. Please load local.conf, or supply value in meson_options.txt')
endif

if dosbox == ''
    error('dosbox Path empty. Please load local.conf, or supply value in meson_options.txt')
endif

message('DOSbox File path: ' + dosbox)
message('TurboC Directory: ' + tcc)

# Add executable to end of DOSBox-X path
# dosbox = dosbox + '\\DOSBox-X.exe' <--- we assume user inputs full path, including exe name

# Check if Tcc exist
fs = import('fs')
tcc_exe = tcc / 'BIN' / 'TCC.EXE'
if not fs.is_file(tcc_exe)
    error('TCC.EXE not found at ' + tcc_exe)
endif

# Variables
source_file = 'PATCHX16.C'
output_file = 'PATCHX16.EXE'
custom_include_path = meson.current_source_dir() / 'INCLUDE'
custom_include_path_OBJ = meson.current_build_dir() # pre‑compiled .OBJ files

# List of all source files that the main EXE depends on
# (paths relative to this meson.build = source/DOS)
main_sources = files(
    'PATCHX16.C',
    'INCLUDE/MPCLIB.C',
    'INCLUDE/minIni.c',
    'INCLUDE/MPCLIB.H',
    'INCLUDE/minIni.h',
    'INCLUDE/minGlue.h',
)

# Arguments to pass into DOSBox
dosbox_args = [
    '-noconsole',
    '-c', 'cls',
    '-c', 'mount x "' + tcc + '"',
    '-c', 'mount y "' + meson.current_source_dir() + '"',
    '-c', 'mount r "' + meson.current_build_dir() + '"',
    '-c', 'mount i "' + custom_include_path + '"',
    '-c', 'PATH %path%;x:\\BIN',
    '-c', 'r:',
    '-c', 'tcc.exe /IX:\\include /LX:\\LIB /II:\\ -ms Y:\\PATCHX16.C I:\\MPCLIB.C I:\\MININI.C'
          + (get_option('TCC_OUTPUT_TO_FILE') ? ' > TCC_LOG.TXT' : ''),
]

# If debug run after compilation is enabled
if get_option('QUICK_RUN_16BIT')
    message('QUICK_RUN_16BIT IS ENABLED.')
    dosbox_args += ['-c', 'MPC.EXE' + get_option('MPC_DOS_ARGS')]
endif

if get_option('EXIT_ON_16BIT_COMPILATION')
    dosbox_args += ['-c', 'exit']
endif

# Build the main DOS executable (only when sources change)
mpc_dos = custom_target('16_bit_mpc_dos',
    input: main_sources,
    output: output_file,
    command: [dosbox] + dosbox_args,
    build_by_default: true,
)

# --------------------------------------------------------------------
# Build library OBJ files separately for use by other DOS apps
# --------------------------------------------------------------------
# MPCLIB.OBJ
lib_mpc_obj_target = custom_target('compile_mpclib_obj',
    input: files('INCLUDE/MPCLIB.C', 'INCLUDE/MPCLIB.H'),
    output: 'MPCLIB.OBJ',
    command: [
        dosbox,
        '-noconsole',
        '-c', 'mount x "' + tcc + '"',
        '-c', 'mount y "' + meson.current_source_dir() + '"',
        '-c', 'mount r "' + meson.current_build_dir() + '"',
        '-c', 'mount i "' + custom_include_path + '"',
        '-c', 'PATH %PATH%;x:\\BIN',
        '-c', 'r:',
        '-c', 'tcc.exe -c /IX:\\include /LX:\\LIB /II:\\ -ms Y:\\INCLUDE\\MPCLIB.C',
        '-c', 'exit'
    ],
    build_by_default: true,
)

# MININI.OBJ
lib_mini_obj_target = custom_target('compile_minini_obj',
    input: files('INCLUDE/minIni.c', 'INCLUDE/minIni.h'),
    output: 'MININI.OBJ',
    command: [
        dosbox,
        '-noconsole',
        '-c', 'mount x "' + tcc + '"',
        '-c', 'mount y "' + meson.current_source_dir() + '"',
        '-c', 'mount r "' + meson.current_build_dir() + '"',
        '-c', 'mount i "' + custom_include_path + '"',
        '-c', 'PATH %PATH%;x:\\BIN',
        '-c', 'r:',
        '-c', 'tcc.exe -c /IX:\\include /LX:\\LIB /II:\\ -ms Y:\\INCLUDE\\minIni.c',
        '-c', 'exit'
    ],
    build_by_default: true,
)

# Make library objects available to subdir (APPS)
lib_obj_mpc  = lib_mpc_obj_target
lib_obj_mini = lib_mini_obj_target

# Copy the resulting EXE into the staging directory (bin_dir)
# We need the staging directory path from the parent – use a variable set there.
# To keep it clean, we define a helper target that copies the file.
copy_mpc_dos = custom_target('copy-mpc-dos',
    input: mpc_dos,
    output: 'mpc_dos_copied.stamp',
    command: [
        python, '-c',
        'import shutil, sys, os; os.makedirs(os.path.dirname(sys.argv[2]), exist_ok=True); shutil.copy2(sys.argv[1], sys.argv[2])',
        '@INPUT@',
        join_paths(meson.project_build_root(), get_option('BIN_DIR'), output_file)
    ],
    build_by_default: true,
)

# Build other DOS apps (they need lib_obj_mpc and lib_obj_mini for dependency tracking)
subdir('APPS')