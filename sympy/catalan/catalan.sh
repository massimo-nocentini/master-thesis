
SAGE=~/Developer/snapshots/sage/sage-6.6/sage
cmd=$"
from sage.all import *
load('../RiordanGroup.sage')

d(t)=(1/2)*(1+1/sqrt(1-4*t) )
h(t)=(1-sqrt(1-4*t))/2
pascal_matrix, tikz_nodes = coloured_triangle(d,h, order=10)
repeated_differences_matrix = repeated_applications(pascal_matrix)
show(pascal_matrix)
show(repeated_differences_matrix)
write_tikz_lines_to_file(tikz_nodes)"

echo "$cmd"

$SAGE -c "$cmd"
