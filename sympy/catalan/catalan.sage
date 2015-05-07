
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

# set to `None' if classic *mod* partitioning is desired
partitioning=lambda coeff: 1 if coeff.is_prime() else 0

# first we build the colouring for the standard triangle, timing it
results, elapsed_time = timed_execution(
    lambda: coloured_triangle( 
        array=Riordan_array, 
        order=order, 
        partitioning=partitioning))

pascal_matrix, tikz_nodes = results
# a formatting pattern for a *datetime* object could be `.strftime("%M:%S.%f")'
# here `elapsed_time' is a timedelta object, hence it doesn't apply
print "**** standard colouring computed in {0}****".format(elapsed_time)

# save tikz lines to a dedicated file
filename="standard-colouring-tikz-nodes.tex"
write_tikz_lines_to_file(tikz_nodes, filename)

# instantiate the template file in order to build the coloured triangle
write_tikz_lines_to_file(
    substitute_from_filename(
        "../templates/coloured.tex", 
        dict(tikz_lines_input_filename=filename)), 
    "catalan-standard-colouring.tex", 
    joiner=None) 

#________________________________________________________________________

# now we apply repeated difference in order to get a new array
repeated_differences_matrix, elapsed_time = timed_execution(
    lambda: repeated_applications(pascal_matrix))
print "**** repeated differences colouring computed in {0}****".format(elapsed_time)

# draw again a coloured triangles as a list of tikz nodes, 
# discard the first result since it is `explicit_matrix' itself
_, tikz_nodes = coloured_triangle(
    explicit_matrix=repeated_differences_matrix, 
    order=order, 
    partitioning=partitioning)

filename="repeated-differences-colouring-tikz-nodes.tex"
write_tikz_lines_to_file(tikz_nodes, filename)

# instantiate the template file in order to build the coloured triangle
write_tikz_lines_to_file(
    substitute_from_filename(
        "../templates/coloured.tex", 
        dict(tikz_lines_input_filename=filename)), 
    "catalan-repeated-differences-colouring.tex", 
    joiner=None) 





