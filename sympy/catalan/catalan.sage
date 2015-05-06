
from sage.all import *

load('../RiordanGroup.sage')

t = var('t')
d(t)=(1/2)*(1+1/sqrt(1-4*t))
h(t)=(1-sqrt(1-4*t))/2

# building Riordan group
Riordan_array = RiordanArray(
    SubgroupCharacterization(
        VanillaDHfunctionsSubgroup(d, h, t))) 

order=127

# first we build the colouring for the standard triangle
pascal_matrix, tikz_nodes = coloured_triangle(array=Riordan_array, order=order)
filename="standard-colouring.tex"
write_tikz_lines_to_file(tikz_nodes, filename)
write_tikz_lines_to_file(
    prepare_tex_document("../templates/coloured.tex", filename), 
    "catalan-standard-colouring.tex") # writing this file here allow to *not* copy it in the Makefile rule
# here we can than generate the little code in order to embed the 
# triangle in a bigger document.


# now we apply repeated difference in order to get a new array
repeated_differences_matrix = repeated_applications(pascal_matrix)
#show(pascal_matrix)
#show(repeated_differences_matrix)
pascal_matrix, tikz_nodes = coloured_triangle(
    explicit_matrix=repeated_differences_matrix, order=order)
write_tikz_lines_to_file(tikz_nodes, filename="repeated-differences-colouring.tex")

