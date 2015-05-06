
SAGE=~/Developer/snapshots/sage/sage-6.6/sage
# the following command is obsolete since we can use
# Sage script directly because no variation take place.
cmd=$"
from sage.all import *
load('../RiordanGroup.sage')

d(t)=(1/2)*(1+1/sqrt(1-4*t) )
h(t)=(1-sqrt(1-4*t))/2
Riordan_array = RiordanArray(
    SubgroupCharacterization(
        VanillaDHfunctionsSubgroup(d, h, d.args()[0]))) 
order=127
pascal_matrix, tikz_nodes = coloured_triangle(d,h, order=order)
repeated_differences_matrix = repeated_applications(pascal_matrix)
#show(pascal_matrix)
#show(repeated_differences_matrix)
pascal_matrix, tikz_nodes = coloured_triangle(d=None, h=None,
    explicit_matrix=repeated_differences_matrix, order=order)
write_tikz_lines_to_file(tikz_nodes)"

echo "$cmd"

$SAGE catalan.sage
