
load("../append_root_directory_to_sys_path.py")

#________________________________________________________________________

from sage.all import *
from riordan_group import *

t = var('t')
d(t)=(1/2)*(1+1/sqrt(1-4*t))
h(t)=(1-sqrt(1-4*t))/2

# building Riordan group
Riordan_array = RiordanArray(
    SubgroupCharacterization(
        VanillaDHfunctionsSubgroup(d, h, t)), 
    name='C') 

order=127

# set to `None' if classic *mod* partitioning is desired
def partitioning(coeff):
    color_code = None

    if coeff.is_prime():            color_code = 1 
    elif coeff.is_prime_power():    color_code = 2 
    elif coeff.is_pseudoprime():    color_code = 3
    else:                           color_code = 0

    return color_code
    
partitioning=None

# first we build the colouring for the standard triangle, timing it
results, elapsed_time = timed_execution(
    lambda: coloured_triangle( 
        array=Riordan_array, 
        order=order, 
        partitioning=partitioning))

pascal_matrix, tikz_nodes = results
# a formatting pattern for a *datetime* object could be `.strftime("%M:%S.%f")'
# here `elapsed_time' is a timedelta object, hence it doesn't apply
print "**** standard colouring computed in {0} ****".format(elapsed_time)

# save tikz lines to a dedicated file
filename="standard-colouring-tikz-nodes.tex"
write_tikz_lines_to_file(tikz_nodes, filename)

# instantiate the template file in order to build the coloured triangle
standard_colouring_filename_prefix = "catalan-standard-colouring"

write_tikz_lines_to_file(
    substitute_from_filename(
        "../templates/coloured.tex", 
        dict(tikz_lines_input_filename=filename)), 
    "{}.tex".format(standard_colouring_filename_prefix), 
    joiner=None) 

# instantiate the template file for include figure tex generation
write_tikz_lines_to_file(
    substitute_from_filename(
        "../templates/include-figure.tex", 
        dict(   triangle_filename="{path_prefix}{triangle_filename}.pdf".format(
                    path_prefix="../sympy/catalan/",
                    triangle_filename=standard_colouring_filename_prefix),
#               it should be nice to include in the description 
#               the way the triangle is partitioned...
                caption="Catalan triangle, formally ${formal_def}$".format(
                    formal_def=Riordan_array.formal_def()),
                label=standard_colouring_filename_prefix)), 
    "include-figure-{}.tex".format(standard_colouring_filename_prefix), 
    joiner=None)
print "**** standard colouring include figure tex chunk generated ****"

#________________________________________________________________________

# now we apply repeated difference in order to get a new array
repeated_differences_matrix, elapsed_time = timed_execution(
    lambda: repeated_applications(pascal_matrix))
print "**** repeated differences colouring computed in {0} ****".format(elapsed_time)

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


#________________________________________________________________________

# for inverses

catalan_inverse = Riordan_array.inverse(
    variable=var('y'), 
    h_comp_inverse_proof=lambda y, t, equation: (equation*2*(-1) + 1)**2)


# first we build the colouring for the standard triangle, timing it
results, elapsed_time = timed_execution(
    lambda: coloured_triangle( 
        array=catalan_inverse, 
        order=order, 
        partitioning=partitioning))

pascal_matrix, tikz_nodes = results
# a formatting pattern for a *datetime* object could be `.strftime("%M:%S.%f")'
# here `elapsed_time' is a timedelta object, hence it doesn't apply
print "**** inverse colouring computed in {0} ****".format(elapsed_time)

# save tikz lines to a dedicated file
filename="inverse-colouring-tikz-nodes.tex"
write_tikz_lines_to_file(tikz_nodes, filename)

# instantiate the template file in order to build the coloured triangle
standard_colouring_filename_prefix = "catalan-inverse-colouring"

write_tikz_lines_to_file(
    substitute_from_filename(
        "../templates/coloured.tex", 
        dict(tikz_lines_input_filename=filename)), 
    "{}.tex".format(standard_colouring_filename_prefix), 
    joiner=None) 

# instantiate the template file for include figure tex generation
write_tikz_lines_to_file(
    substitute_from_filename(
        "../templates/include-figure.tex", 
        dict(   triangle_filename="{path_prefix}{triangle_filename}.pdf".format(
                    path_prefix="../sympy/catalan/",
                    triangle_filename=standard_colouring_filename_prefix),
#               it should be nice to include in the description 
#               the way the triangle is partitioned...
                caption="Catalan inverse triangle, formally ${formal_def}$".format(
                    formal_def=catalan_inverse.formal_def()),
                label=standard_colouring_filename_prefix)), 
    "include-figure-{}.tex".format(standard_colouring_filename_prefix), 
    joiner=None)
print "**** inverse colouring include figure tex chunk generated ****"



