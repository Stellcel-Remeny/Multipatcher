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
src_base = get_option('src_base')
message('Base directory: ' + src_base)
src_mwin  = get_option('src_muwu')
message('Bootable Mini Windows Source directory: ' + src_mwin)
src_dos  = get_option('src_dos')
message('DOS Source directory: ' + src_dos)

# Compile DOS App
subdir(src_dos)

# Now is a good time to copy src_base
install_subdir(src_base,
               install_dir: meson.project_source_root() / get_option('bin_dir'),
               strip_directory: true)

# Now is a good time to install BOOT.IMG
install_data(src_mwin / 'BOOT.IMG',
             install_dir: meson.project_source_root() / get_option('bin_dir') / 'BOOT')
