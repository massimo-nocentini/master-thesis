
SAGE=~/Developer/snapshots/sage/sage-6.6/sage
cmd=$"
from sage.all import *
load('../RiordanGroup.sage')

d(t)=1/(1-t) 
h(t)=t/(1-t)
pascal_matrix, tikz_nodes = coloured_triangle(d,h, classes=2)
repeated_differences_matrix = repeated_applications(pascal_matrix)
pascal_matrix, tikz_nodes = coloured_triangle(d=None, h=None,
    explicit_matrix=repeated_differences_matrix)
write_tikz_lines_to_file(tikz_nodes)"

echo "$cmd"

$SAGE -c "$cmd"
