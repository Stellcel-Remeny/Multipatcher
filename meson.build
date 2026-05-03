# MultiPatcher Meson Build File
# 2023 - 2026 NTSP3:
## Patchress, MultiPatcher MPC, MultibootSystemEssentials MSE, NTPatcher, RealBoot
#
# 2026, 2025 Remeny
# Novem 5 2025
# GNU GPL v3
#

project('MultiPatcher',
    version : '0.6',
    default_options : ['warning_level=3'])

add_project_arguments('-x', 'c', language: 'c')

# ----------------------------------------------------------------------
# Options (paths relative to project source root)
# ----------------------------------------------------------------------
src_dir   = get_option('SRC_DIR)
src_about = get_option('SRC_ABOUT')
src_base  = get_option('SRC_BASE')
src_mwin  = get_option('SRC_MWIN')
src_dos   = get_option('SRC_DOS')
bin_dir   = get_option('BIN_DIR')

# Staging directory inside the build tree - everything needed for the ISO
staging_dir = meson.current_build_dir() / bin_dir

#
# Print the variables to tty
#
message('Source directory: ' + src_dir)
message('About directory: ' + src_about)
message('Base directory: ' + src_base)
message('Mini Windows directory: ' + src_mwin)
message('DOS Source directory: ' + src_dos)

message('Staging directory: ' + staging_dir)

# ----------------------------------------------------------------------
# 1. Generate BOOT.IMG
# ----------------------------------------------------------------------
subdir(src_mwin)

# ----------------------------------------------------------------------
# 2. Generate info.ini
# ----------------------------------------------------------------------
conf = configuration_data()
conf.set('PROJECT_VERSION', meson.project_version())
info_ini = configure_file(
    input:  src_about / 'info.ini.in',
    output: 'info.ini',
    configuration: conf
)

# ----------------------------------------------------------------------
# 3. Copy the BASE directory into staging_dir
#    We use a custom_target with a Python script for portability.
# ----------------------------------------------------------------------
python = import('python').find_installation()
copy_base = custom_target('copy-base',
    output: 'base_copied.stamp',
    command: [
        python, '-c',
        'import shutil, sys; shutil.copytree(sys.argv[1], sys.argv[2], dirs_exist_ok=True)',
        meson.current_source_dir() / src_base,
        staging_dir
    ],
    build_by_default: true,
)

# ----------------------------------------------------------------------
# 4. Build DOS applications
# ----------------------------------------------------------------------
subdir(src_dos)

# ----------------------------------------------------------------------
# 5. Copy BOOT.IMG and info.ini into staging directory
# ----------------------------------------------------------------------
copy_boot_img = custom_target('copy-boot-img',
    input: boot_target,
    output: 'boot_img_copied.stamp',
    command: [
        python, '-c',
        'import shutil, sys, os; os.makedirs(os.path.dirname(sys.argv[2]), exist_ok=True); shutil.copy2(sys.argv[1], sys.argv[2])',
        '@INPUT@',
        staging_dir / 'BOOT' / 'BOOT.IMG' # Install to BOOT directory
    ],
    build_by_default: true,
)

copy_info_ini = custom_target('copy-info-ini',
    input: info_ini,
    output: 'info_ini_copied.stamp',
    command: [
        python, '-c',
        'import shutil, sys, os; os.makedirs(os.path.dirname(sys.argv[2]), exist_ok=True); shutil.copy2(sys.argv[1], sys.argv[2])',
        '@INPUT@',
        staging_dir / 'info.ini'
    ],
    build_by_default: true,
)

# ----------------------------------------------------------------------
# 6. Generate the ISO image
# ----------------------------------------------------------------------
# New directory options for scripts and utilities
src_scripts = get_option('SRC_SCRIPTS')
src_utils   = get_option('SRC_UTILS')

# Per‑platform script name
iso_script = ''
xorriso_path = ''   # will be passed to script as optional argument
if host_machine.system() == 'windows'
    iso_script = meson.current_source_dir() / src_scripts / 'isogen.bat'
    # On Windows we expect xorriso.exe in SRC_UTILS
    xorriso_exe = meson.current_source_dir() / src_utils / 'xorriso.exe'
    xorriso_path = xorriso_exe
elif host_machine.system() == 'linux'
    iso_script = meson.current_source_dir() / src_scripts / 'isogen.sh'
    # On Linux we rely on system xorriso; leave empty so script uses 'xorriso' from PATH
    xorriso_path = ''
else
    error('Unsupported OS for ISO generation: ' + host_machine.system())
endif

# Dependencies: all pieces that must be in staging_dir before we run the ISO tool.
# We need:
#   copy_base         (BASE directory)
#   copy_boot_img     (BOOT.IMG)
#   copy_info_ini     (info.ini)
#   copy_mpc_dos      (main PATCHX16.EXE – defined in source/DOS/meson.build)
#   copy_target       (all DOS apps – defined in source/DOS/APPS/meson.build)
#
# Those targets are visible here because subdir() returned control after defining them.
# Note: copy_target is the target 'copy_dos_apps' in APPS/meson.build.
iso_deps = [copy_base, copy_boot_img, copy_info_ini, copy_mpc_dos, copy_target]

# Build the command list: script + staging_dir + output_iso [+ xorriso_path]
iso_cmd = [iso_script, staging_dir, meson.current_build_dir() / 'MultiPatcher.iso']
if xorriso_path != ''
    iso_cmd += [xorriso_path]
endif

iso_target = custom_target('generate-iso',
    output: 'MultiPatcher.iso',
    command: iso_cmd,
    depends: iso_deps,
    build_by_default: true,
)