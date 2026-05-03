#!/usr/bin/env python3
"""Copy built EXE files into the staging directory, merging case-insensitively."""

import os, sys, shutil, argparse

def find_file_case_insensitive(directory, target):
    """
    Return the actual filename inside 'directory' that matches 'target'
    case-insensitively. If no match, return the original target.
    """
    try:
        entries = os.listdir(directory)
    except FileNotFoundError:
        return target
    target_lower = target.lower()
    for entry in entries:
        if entry.lower() == target_lower:
            return entry
    return target

def resolve_case(start_dir, rel_path):
    """
    Walk 'rel_path' component by component, starting from 'start_dir'.
    For each component, if a directory entry with a case‑insensitive match already
    exists, use its actual name. If not, use the component in ALL CAPS.
    Return the final absolute path.
    """
    current = start_dir
    parts = rel_path.split(os.sep)
    for part in parts:
        if part == '':
            continue
        try:
            entries = os.listdir(current)
        except OSError:
            entries = []
        match = None
        part_lower = part.lower()
        for entry in entries:
            if entry.lower() == part_lower:
                match = entry
                break
        # Use existing match if found, otherwise create directory in ALL CAPS
        chosen = match if match else part.upper()
        current = os.path.join(current, chosen)
        os.makedirs(current, exist_ok=True)
    return current

def main():
    p = argparse.ArgumentParser()
    p.add_argument('--builddir', required=True)
    p.add_argument('--staging', required=True)
    args, rest = p.parse_known_args()

    if len(rest) % 2 != 0:
        sys.exit('Need pairs of output_file,dest_path')

    builddir = args.builddir
    staging = args.staging

    for i in range(0, len(rest), 2):
        out_file = rest[i]
        dest_rel = rest[i+1]

        # Find the actual built EXE (case‑insensitive)
        actual_exe = find_file_case_insensitive(builddir, out_file)
        src = os.path.join(builddir, actual_exe)

        if not os.path.isfile(src):
            print(f'WARNING: EXE not found – skipping: {out_file}')
            continue

        dest_dir_rel = os.path.dirname(dest_rel)
        final_dest_dir = resolve_case(staging, dest_dir_rel)
        # The basename of the output file (keep the case of the actual built file)
        final_dest_file = os.path.join(final_dest_dir, actual_exe)
        os.makedirs(os.path.dirname(final_dest_file), exist_ok=True)
        shutil.copy2(src, final_dest_file)
        print(f'Copied {actual_exe} -> {final_dest_file}')

if __name__ == '__main__':
    main()