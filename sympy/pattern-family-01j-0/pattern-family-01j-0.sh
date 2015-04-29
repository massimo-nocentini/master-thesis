
SAGE=~/Developer/snapshots/sage/sage-6.6/sage
cmd=$"
from sage.all import *
load('../RiordanGroup.sage')

d_t, h_t = from_pattern_family_01j_0(5)
d(t) = d_t
h(t) = h_t

pascal_matrix, tikz_nodes = coloured_triangle(d,h,classes=5)
write_tikz_lines_to_file(tikz_nodes)

array_tex_code = [
    '\\left({0},{1} \\right)'.format(latex(d),latex(h)),
    latex(pascal_matrix)]

write_tikz_lines_to_file(array_tex_code, 'matrix.tex')"

echo "$cmd"

$SAGE -c "$cmd"
