
# TEMPLATE

When adding a new dos .C app, you must also add a meson.build file with the following code:

```meson
# Edit these variables only.
source_file = '<src_c_file>'
install_bin_dir = bin_(patches/utils/drivers/cosmetics) (+ '/<any_sub_dir>')

# Stop right there.

sub_variables = declare_dependency(
  variables : {
    'source_file' : source_file,
    'install_bin_dir' : install_bin_dir,
  }
)

```

Then, replace:

- ```<src_c_file>``` with the name of your .C file,
