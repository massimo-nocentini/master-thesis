
load("../append_root_directory_to_sys_path.py")

#________________________________________________________________________

from sage.all import *

from riordan_group import *
from riordan_characterizations import *
from riordan_subgroups import *
from riordan_utils import *
from riordan_partitionings import *
from riordan_colouring import *
from riordan_texing import *

tex_parent_prefix = "../sympy/catalan/"

t = var('t')
d(t)=(1-sqrt(1-4*t))/(2*t)
h(t)=(1-sqrt(1-4*t))/2

# building Riordan group
Riordan_array = RiordanArray(
    SubgroupCharacterization(
        VanillaDHfunctionsSubgroup(d, h, t)), 
    name='Catalan traditional', math_name=r'\mathcal{C}') 

# set to `None' if classic *mod* partitioning is desired
    
partitioning=RemainderClassesPartitioning(modulo=2)

colouring = TriangleColouring(
    colouring_scheme="standard", 
    order=127,
    centered=True, 
    handle_negatives=True)

# first we build the colouring for the standard triangle, timing it
standard_results, elapsed_time = timed_execution(
    lambda: colouring( 
        array=Riordan_array, 
        partitioning=partitioning))
# a formatting pattern for a *datetime* object could be `.strftime("%M:%S.%f")'
# here `elapsed_time' is a timedelta object, hence it doesn't apply
print "**** standard colouring computed in {0} ****".format(elapsed_time)

# building tex files
standard_tex_files = build_tex_files_about_colouring(
    Riordan_array, standard_results, colouring, partitioning, tex_parent_prefix)

#________________________________________________________________________

colouring.colouring_scheme = "repeated-differences"

# now we apply repeated difference in order to get a new array
repeated_differences_matrix, elapsed_time = timed_execution(
    lambda: repeated_applications(standard_results[0]))
print "**** repeated differences colouring computed in {0} ****".format(elapsed_time)

# draw again a coloured triangles as a list of tikz nodes, 
# discard the first result since it is `explicit_matrix' itself
#repeated_differences_results = colouring(
    #explicit_matrix=repeated_differences_matrix, 
    #partitioning=partitioning)

# here we should create a Riordan array object from an explicit matrix
# before calling the tex files builder

# building tex files
#repeated_differences_tex_files = build_tex_files_about_colouring(
    #Riordan_array, repeated_differences_results, 
    #colouring, partitioning, tex_parent_prefix)

#________________________________________________________________________

colouring.colouring_scheme = "inverse"

inverse_array = Riordan_array.inverse(
    variable=var('y'), 
    h_comp_inverse_proof=lambda y, t, equation: (equation*2*(-1) + 1)**2)

# first we build the colouring for the standard triangle, timing it
inverses_results, elapsed_time = timed_execution(
    lambda: colouring( 
        array=inverse_array, 
        partitioning=partitioning))
# a formatting pattern for a *datetime* object could be `.strftime("%M:%S.%f")'
# here `elapsed_time' is a timedelta object, hence it doesn't apply
print "**** inverse colouring computed in {0} ****".format(elapsed_time)

# building tex files
inverses_tex_files = build_tex_files_about_colouring(
    inverse_array, inverses_results, 
    colouring, partitioning, tex_parent_prefix)

write_tex_files("catalan-traditional-typesetting-commands.sh",
    standard_tex_files, inverses_tex_files)
print "**** wrote tex files ****"




