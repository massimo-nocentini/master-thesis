
SAGE=~/Developer/snapshots/sage/sage-6.6/sage
cmd=$"
from sage.all import *
load('../RiordanGroup.sage')

d_t, h_t = from_pattern_family_j_j(5)
d(t) = d_t
h(t) = h_t

pascal_matrix, tikz_nodes = coloured_triangle(d,h)
write_tikz_lines_to_file(tikz_nodes)"

echo "$cmd"

$SAGE -c "$cmd"
