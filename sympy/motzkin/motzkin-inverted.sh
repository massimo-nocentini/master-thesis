
SAGE=~/Developer/snapshots/sage/sage-6.6/sage
cmd=$"
from sage.all import *
load('../RiordanGroup.sage')

d(t)=sqrt(-2*t/(t**2 + t + 1) - 3*t**2/(t**2 + t + 1)**2 + 1)
h(t)=t/(1+t+t**2)
pascal_matrix, tikz_nodes = coloured_triangle(d,h,for_inverses=False)
write_tikz_lines_to_file(tikz_nodes)"

echo "$cmd"

$SAGE -c "$cmd"
