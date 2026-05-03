
# DOS Applet Template

When adding a new DOS `.C` app, you must also create a `meson.build` file. Use the template below and replace only the indicated placeholders.

## Meson Build File Template

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

## Replacing the Placeholders

After copying the template, make the following replacements:

- **`<src_c_file>`**  
  Replace with the name of your `.C` file (e.g. `'my_app.c'`).

- **`bin_(patches/utils/drivers/cosmetics)`**  
  Choose one of the base installation directories by replacing the whole expression:  
  - `bin_patches`  
  - `bin_utils`  
  - `bin_drivers`  
  - `bin_cosmetics`

- **`(+ '/<any_sub_dir>')`**  
  If you want to install into a subdirectory under the chosen base directory, replace `'<any_sub_dir>'` with the desired path (e.g. `'/network'`).  
  If no subdirectory is needed, **remove the entire `(+ '/<any_sub_dir>')` part** so that the line simply reads:  
  `install_bin_dir = bin_<your_choice>`

> **Important:** Do **not** change anything below the `# Stop right there.` comment. The `declare_dependency` block must remain exactly as shown.

### Example

If your app source is `my_tool.c` and you want it installed under `RES/UTILS/myapps`, the final `meson.build` would look like this:

```meson
source_file = 'my_tool.c'
install_bin_dir = bin_utils + '/myapps'

# Stop right there.

sub_variables = declare_dependency(
  variables : {
    'source_file' : source_file,
    'install_bin_dir' : install_bin_dir,
  }
)
```
