
SAGE=~/Developer/snapshots/sage/sage-6.6/sage
cmd=$"
from sage.all import *
load('../RiordanGroup.sage')

d(t)= 2/(1/sqrt(4*t**2 - 4*t + 1) + 1)
h(t)=t-t**2
pascal_matrix, tikz_nodes = coloured_triangle(d,h, for_inverses=True)
show(pascal_matrix)
write_tikz_lines_to_file(tikz_nodes)"

echo "$cmd"

$SAGE -c "$cmd"
