#!/usr/bin/env python3
"""Generate CMPDAPPS.BAT from a list of compilations."""

import sys, argparse

def main():
    p = argparse.ArgumentParser()
    p.add_argument('--batch', required=True, help='Output batch file')
    p.add_argument('--tcc', required=True, help='TCC path (mounted as X:)')
    p.add_argument('--objdir', required=True, help='OBJ directory mount (O:)')
    p.add_argument('--redirect-log', action='store_true', help='Redirect TCC output to TCC_LOG.TXT')
    p.add_argument('--exit', action='store_true', help='Add exit command')
    # Remaining arguments come in triples: subdir, source, output
    args, rest = p.parse_known_args()

    if len(rest) % 3 != 0:
        sys.exit('Need triples of subdir,source,output after script options')

    lines = ['@echo off']
    for i in range(0, len(rest), 3):
        subdir, src, out = rest[i], rest[i+1], rest[i+2]
        lines.append(f'echo Compiling {subdir}/{src}')
        # Delete previous output to avoid false positives
        lines.append(f'if exist {out} del {out}')
        # Build the tcc command
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