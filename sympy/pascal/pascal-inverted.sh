
SAGE=~/Developer/snapshots/sage/sage-6.6/sage
cmd=$"
from sage.all import *
load('../RiordanGroup.sage')

d(t)=1/(1+t) 
h(t)=t/(1+t)
pascal_matrix, tikz_nodes = coloured_triangle(d,h, classes=6, for_inverses=False)
write_tikz_lines_to_file(tikz_nodes)"

echo "$cmd"

$SAGE -c "$cmd"
