#!/usr/bin/env python3
"""Generate CMPDAPPS.BAT only with compilations that are actually needed."""

import os, sys, argparse

def find_file_insensitive(directory, target):
    """Return the actual filename matching 'target' case-insensitively, or target if not found."""
    try:
        entries = os.listdir(directory)
    except FileNotFoundError:
        return target
    target_lower = target.lower()
    for entry in entries:
        if entry.lower() == target_lower:
            return entry
    return target

def needs_compile(src_path, obj_files, exe_dir, exe_target):
    """
    Return True if the EXE (case‑insensitive) does not exist or is older than
    the source file or any of the library OBJ files.
    """
    # Resolve the actual EXE name in the build directory
    actual_exe = find_file_insensitive(exe_dir, exe_target)
    exe_path = os.path.join(exe_dir, actual_exe)

    if not os.path.exists(exe_path):
        return True

    exe_mtime = os.path.getmtime(exe_path)

    # check source file
    if not os.path.exists(src_path):
        return True
    if os.path.getmtime(src_path) > exe_mtime:
        return True

    # check library OBJ files
    for obj in obj_files:
        if os.path.exists(obj) and os.path.getmtime(obj) > exe_mtime:
            return True
    return False

def main():
    p = argparse.ArgumentParser(description='Incremental batch file generator')
    p.add_argument('--batch', required=True, help='Output batch file path')
    p.add_argument('--builddir', required=True, help='Build directory (where EXE files are)')
    p.add_argument('--srcdir', required=True, help='Absolute source directory for DOS/APPS')
    p.add_argument('--tcc', required=True)
    p.add_argument('--objdir', required=True, help='Directory containing MPCLIB.OBJ and MININI.OBJ')
    p.add_argument('--redirect-log', action='store_true')
    p.add_argument('--exit', action='store_true')
    # remaining args are triples: subdir source output
    args, rest = p.parse_known_args()

    if len(rest) % 3 != 0:
        sys.exit('Need triples of subdir,source,output')

    lib_objs = [
        os.path.join(args.objdir, 'MPCLIB.OBJ'),
        os.path.join(args.objdir, 'MININI.OBJ'),
    ]

    lines = ['@echo off']
    for i in range(0, len(rest), 3):
        subdir, src, out = rest[i], rest[i+1], rest[i+2]
        src_full = os.path.join(args.srcdir, subdir, src)
        exe_dir = args.builddir

        if needs_compile(src_full, lib_objs, exe_dir, out):
            lines.append(f'echo Compiling {subdir}/{src}')
            lines.append(f'if exist {out} del {out}')  # DOSBox is case‑insensitive
            cmd = f'tcc.exe /IX:\\include /LX:\\LIB /II:\\ -ms Y:\\{subdir}\\{src} O:\\MPCLIB.OBJ O:\\MININI.OBJ'
            if args.redirect_log:
                cmd += ' >> TCC_LOG.TXT'
            lines.append(cmd)

    if args.exit:
        lines.append('exit')

    with open(args.batch, 'w', newline='\r\n') as f:
        f.write('\r\n'.join(lines) + '\r\n')

if __name__ == '__main__':
    main()