# You only need to edit source_file, output_file, and install_bin_dir
# 
# An appropriate INFO.INI file must accompany it. You must add this INI file to
# source/BASE/RES/<directory>/INFO.INi
#

# Edit these variables only.
source_file = 'CRFIXINS.C'
output_file = 'CRFIXINS.EXE'
install_bin_dir = bin_drivers / 'CREGFIX'

# Stop right there.

sub_variables = declare_dependency(
  variables : {
    'source_file' : source_file,
    'output_file' :  output_file,
    'install_bin_dir' : install_bin_dir,
  }
)
