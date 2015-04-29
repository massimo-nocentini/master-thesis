
SAGE=~/Developer/snapshots/sage/sage-6.6/sage
cmd=$"
from sage.all import *
load('../RiordanGroup.sage')

d_t, h_t = from_pattern_family_10j_1(2)
d(t) = d_t
h(t) = h_t

pascal_matrix, tikz_nodes = coloured_triangle(d,h, order=20)
write_tikz_lines_to_file(tikz_nodes)

array_tex_code = [latex(pascal_matrix)]

write_tikz_lines_to_file(array_tex_code, 'matrix.tex')"

echo "$cmd"

$SAGE -c "$cmd"
