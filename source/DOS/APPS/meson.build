# Imports
py = import('python').find_installation()

# Variables for directories
bin_patches = meson.project_source_root() / get_option('BIN_DIR') / 'RES' / 'PATCHES'
bin_utils = meson.project_source_root() / get_option('BIN_DIR') / 'RES' / 'UTILS'
bin_cosmetic = meson.project_source_root() / get_option('BIN_DIR') / 'RES' / 'COSMETIC'
bin_drivers = meson.project_source_root() / get_option('BIN_DIR') / 'RES' / 'DRIVERS'

# For every directory in this folder with meson.build, include them.
# Then, compile a list of arguments to pass into DOSBox.
# This way, we only have to call DOSBox once to compile all other DOS apps.
# (Or else it would be a jumpscare in a nightmare)

# Arguments to pass to DOSBOX-x
dosbox_args = [
  '-noconsole',
  '-c', 'cls',
  '-c', 'mount x "' + tcc + '"',
  '-c', 'mount y "' + meson.current_source_dir() + '"',
  '-c', 'mount r "' + meson.current_build_dir() + '"',
  '-c', 'mount i "' + custom_include_path + '"', # We now use this only to provide header files.
  '-c', 'mount o "' + custom_include_path_OBJ + '"', # We use the OBJ variable to not recompile libraries. (EXCPECTS MAIN MESON.BUILD TO HAVE ALREADY COMPILED THEM)
  '-c', 'PATH %PATH%;x:\\BIN',
  '-c', 'r:',
  '-c', 'del TCC_LOG.TXT', # Delete previous logfiles
  '-c', 'CMPDAPPS.BAT',
]

batch_cmds = []

dos_targets = []

# Ask Windows to list folders in this directory (bare names only)
rd = run_command('cmd', '/c', 'dir', '/b', '/ad')
subdirs = rd.stdout().strip().split('\n')

# For each directory, look for meson.build and include it.
foreach d : subdirs
  if fs.is_dir(d) and fs.exists(d / 'meson.build')
    # Wipe variables
    src  = ''
    out  = ''
    insd = ''
    batch_cmds = []
    # Enter the directory so its variables become visible
    subdir(d)
    vars = sub_variables
    # After subdir(), the following variables MUST exist:
    #   source_file
    #   install_bin_dir
    src  = vars.get_variable('source_file')
    insd = vars.get_variable('install_bin_dir')

    if src == ''
      error('In ' + d + '/meson.build, source_file is empty.')
    elif insd == ''
      error('In ' + d + '/meson.build, install_bin_dir is empty.')
    endif

    # Append current directory name to insd
    insd += '/' + d

    # When TCC compiles, almost always the resulting .EXE file will be named
    # as <src_C_file>.exe, without the .C file extension.
    # Therefore, we can automate output file detection by taking the filename
    # of the SRC file, stripping away the extension, and then appending '.EXE'.
    out = src.split('.')[0] + '.EXE'

    # Write new command
    batch_cmds = ['del ' + out + ' >NUL'] # Delete previously made output, so it will not falsely take previous executable if tcc fails
    batch_cmds +=  ['tcc.exe /IX:\\include /LX:\\LIB /II:\\ -ms Y:\\' + d + '\\' + src + ' O:\\MPCLIB.OBJ O:\\MININI.OBJ'
                   + (get_option('TCC_OUTPUT_TO_FILE') ? ' >> TCC_LOG.TXT' : '')]
    # Append command to batch_cmds if file is modified
    message('DOSAPP Target Input file: ' + d + '/' + src)
    message('DOSAPP Target Output file: ' + out)
    message('DOSAPP Target InstallDir: ' + insd)
    t = custom_target(
      out + '_DRIP',
      input: d + '/' + src,
      output: out,
      command: [py, files('append.py'), meson.current_build_dir() + '/CMPDAPPS.BAT'] + batch_cmds,
      build_by_default: true,
      install: true,
      install_dir: insd,
    )
    dos_targets += [t]

  endif
endforeach

# Add exit command if needed
exit_target = []
if get_option('EXIT_ON_16BIT_COMPILATION')
  exit_target = [custom_target(
    'append_exit',
    output: 'exit.stamp',
    command: [py, files('append.py'),
              meson.current_build_dir() + '/CMPDAPPS.BAT',
              'exit'],
    depends: dos_targets,
    build_always_stale: true,
    build_by_default: true,
  )]
endif

# Run dosbox
final_deps = [mpc_dos] + dos_targets
if exit_target != []
  final_deps += [exit_target]
endif

dosbox_execute = custom_target(
  'other_dos_apps',
  output: 'ALL_DOS_APPS_BUILT.TXT',
  command: [dosbox] + dosbox_args,
  build_by_default: true,
  depends: final_deps,
)

# Wipe CMPDAPPS.BAT at last by depending on dosbox_execute, for next time.
wipe_bat = custom_target(
  'wipe_cmpdapps_bat',
  output: 'CMPDAPPS.WIPE',
  command: [py, '-c', 'open("' + meson.current_build_dir() + '/CMPDAPPS.BAT","w").close()'],
  build_by_default: true,
  build_always_stale: true,
  depends: dosbox_execute
)