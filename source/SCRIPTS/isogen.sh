#!/bin/sh
# isogen.sh – generate bootable ISO using xorriso
# Usage: isogen.sh <staging_dir> <output_iso> [xorriso_binary]
# Example: isogen.sh builddir/bin builddir/MultiPatcher.iso /usr/bin/xorriso

set -eu

die() {
    echo "ERROR: $*" >&2
    exit 1
}

[ $# -ge 2 ] || die "Usage: $0 <staging_dir> <output_iso> [xorriso]"

STAGING="$1"
OUTPUT="$2"
XORRISO="${3:-xorriso}"   # default to 'xorriso' from PATH

[ -d "$STAGING" ] || die "Staging directory not found: $STAGING"
# Check that the required boot files exist in staging
[ -f "$STAGING/BOOT/BOOT.IMG" ]     || die "Missing $STAGING/BOOT/BOOT.IMG"
[ -f "$STAGING/BOOT/isolinux.bin" ] || die "Missing $STAGING/BOOT/isolinux.bin"
[ -f "$STAGING/isohdpfx.bin" ]      || die "Missing $STAGING/isohdpfx.bin (for isohybrid)"
[ -f "$STAGING/BOOT/efi.img" ]      || die "Missing $STAGING/BOOT/efi.img"

# Check that xorriso works
if ! command -v "$XORRISO" >/dev/null 2>&1; then
    die "xorriso not found at '$XORRISO' nor in PATH. Please install xorriso."
fi

# Create the ISO
# Options mirror the original batch file exactly.
"$XORRISO" -as mkisofs \
  -iso-level 3 \
  -full-iso9660-filenames \
  -volid MPC \
  -eltorito-boot BOOT/isolinux.bin \
  -eltorito-catalog boot.cat \
  -no-emul-boot \
  -boot-load-size 4 \
  -boot-info-table \
  -eltorito-alt-boot \
  -e BOOT/efi.img \
  -no-emul-boot \
  -eltorito-platform efi \
  -isohybrid-mbr "$STAGING/isohdpfx.bin" \
  -isohybrid-gpt-basdat \
  -o "$OUTPUT" \
  "$STAGING" || die "xorriso failed"

echo "ISO successfully created: $OUTPUT"
exit 0