# To append to batch file.

import sys

outfile = sys.argv[1]
lines = sys.argv[2:]

with open(outfile, 'a', newline='\n') as f:
    for l in lines:
        f.write(l + '\n')
