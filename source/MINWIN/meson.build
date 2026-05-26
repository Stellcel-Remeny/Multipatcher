# Filesystem lib
fs = import('fs')

# Base directory (directory containing this meson.build)
base_dir = meson.current_source_dir()

# Bootable template (Boot code)
template_img = base_dir / 'TEMPLATE.IMG'

# Content Directory (Contains stuff to put into boot image)
content_dir = base_dir / 'CONTENT'

# Output Boot Image filename
boot_img_out = 'BOOT.IMG'

# If template image is not found, stop.
if not fs.is_file(template_img)
    error('Missing TEMPLATE.IMG at ' + template_img)
endif

# If content directory is not found, stop.
if not fs.is_dir(content_dir)
    error('Missing CONTENT directory at ' + content_dir)
endif

# Current build directory
build_dir = meson.current_build_dir()

# Always build boot image depending on OS (Windows / Linux)
# Because modifying CONTENT directory must also modify image.

os = host_machine.system()
if os == 'windows'
    gen_script = base_dir / 'genimg.bat'
    cmd = ['cmd', '/c',
            gen_script]
elif os == 'linux'
    gen_script = base_dir / 'genimg.sh'
    cmd = ['sh', gen_script]
else
    error('Unsupported OS, expected Windows or Linux but detected: ' + os)
endif

# Append common arguments to cmd
cmd += [template_img,
        content_dir,
        build_dir / boot_img_out]

# Build the Boot image
boot_target = custom_target(
    'boot_img',
    input: [template_img, gen_script],
    output: boot_img_out,
    command: cmd,
    build_by_default: true,
    build_always_stale: true
)
