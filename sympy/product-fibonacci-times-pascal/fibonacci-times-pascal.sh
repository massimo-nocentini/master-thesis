
SAGE=~/Developer/snapshots/sage/sage-6.6/sage
cmd=$"
from sage.all import *
load('../RiordanGroup.sage')

d(t)=(1-sqrt(1-4*t))/(2*t*(1-t-t**2 ))
h(t)=(1-2*t-sqrt(1-4*t))/(2*t)
pascal_matrix, tikz_nodes = coloured_triangle(d,h)
write_tikz_lines_to_file(tikz_nodes)"

echo "$cmd"

$SAGE -c "$cmd"
