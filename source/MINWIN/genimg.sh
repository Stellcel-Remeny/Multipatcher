#!/bin/sh
# genimg.sh – generate a bootable floppy image (BOOT.IMG) by copying content
#             into a copy of the template image.  No root needed.
#
# Usage:  genimg.sh <template> <content-dir> <output>
# Example: genimg.sh TEMPLATE.IMG CONTENT BOOT.IMG
#
# Requires mtools (mcopy) – install with your package manager if missing.
#

set -eu

# ----- helpers -----
die() {
    echo "ERROR: $*" >&2
    exit 1
}

# ----- argument checks -----
[ $# -eq 3 ] || die "Usage: $0 <template> <content-dir> <output>"

TEMPLATE="$1"
CONTENT="$2"
OUTPUT="$3"

[ -f "$TEMPLATE" ] || die "Template image not found: $TEMPLATE"
[ -d "$CONTENT"  ] || die "Content directory not found: $CONTENT"

# ----- check for required tool -----
if ! command -v mcopy >/dev/null 2>&1; then
    die "mtools is not installed.  Please install 'mtools' to use this script."
fi

# ----- work -----
# 1. Copy the template to the output location (preserve template).
cp -- "$TEMPLATE" "$OUTPUT" || die "Failed to copy template to $OUTPUT"

# 2. Copy the *contents* of CONTENT/ into the root of the floppy image.
#    -i = operate on image file
#    -s = recursive (creates needed subdirectories)
#    -o = overwrite existing files without prompting (batch mode).
#    The trailing "::" means root of the FAT filesystem inside the image.
mcopy -i "$OUTPUT" -s -o "$CONTENT"/* :: || die "Copying content into image failed."

echo "BOOT.IMG successfully generated."
exit 0