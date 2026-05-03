#!/usr/bin/env python3
"""Print the real filename that matches case-insensitively in the given directory."""

import os, sys

if len(sys.argv) != 3:
    print("Usage: resolve_case.py <directory> <target-filename>", file=sys.stderr)
    sys.exit(1)

dir_, target = sys.argv[1], sys.argv[2]

try:
    entries = os.listdir(dir_)
except FileNotFoundError:
    print(f"Directory not found: {dir_}", file=sys.stderr)
    sys.exit(1)

matches = [f for f in entries if f.lower() == target.lower()]

if not matches:
    print(f"No case-insensitive match for {target} in {dir_}", file=sys.stderr)
    sys.exit(1)

print(matches[0])