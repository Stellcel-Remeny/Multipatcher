# Patchress Meson Build File
# 2023 - 2025 NTSP3:
## Patchress, MultiPatcher MPC, MultibootSystemEssentials MSE, NTPatcher, RealBoot
#
# 2025 Remeny
# Novem 5 2025
# GNU GPL v3
#

project('MultiPatcher',
    version : '0.5.1',
    default_options : ['warning_level=3'])

# Get directories from options
src_dir = get_option('src_dir')
message('Source directory: ' + src_dir)
src_about = get_option('src_about')
message('About directory: ' + src_about)
src_base = get_option('src_base')
message('Base directory: ' + src_base)
src_mwin  = get_option('src_muwu')
message('Bootable Mini Windows Source directory: ' + src_mwin)
src_dos  = get_option('src_dos')
message('DOS Source directory: ' + src_dos)

# Check if BOOT.IMG exists
fs = import('fs')
if not fs.is_file(src_mwin + '\\BOOT.IMG')
    error('BOOT.IMG not found in ' + src_mwin + ', please view HOWTO.TXT in src_mwin dir.')
endif

# Generate text for 'About'
conf = configuration_data()
conf.set('PROJECT_VERSION', meson.project_version())

configure_file(
    input: src_about / 'info.ini.in',
    output: 'info.ini',
    configuration: conf
)

# Compile DOS App
subdir(src_dos)

# Install generated About information
install_data(
    meson.current_build_dir() / 'info.ini',
    install_dir: meson.project_source_root() / get_option('bin_dir') / 'RES' / 'ABOUT'
)

# Now is a good time to copy src_base
install_subdir(src_base,
               install_dir: meson.project_source_root() / get_option('bin_dir'),
               strip_directory: true)

# Now is a good time to install BOOT.IMG
install_data(src_mwin / 'BOOT.IMG',
             install_dir: meson.project_source_root() / get_option('bin_dir') / 'BOOT')
