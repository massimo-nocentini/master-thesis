
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

tex_parent_prefix = "../sympy/gi-sang-cheon/"

t = var('t')
d(t)=1/(1-t)
h(t)=t/(1-t)

# building Riordan group
Riordan_array = RiordanArray(
    SubgroupCharacterization(
        VanillaDHfunctionsSubgroup(d, h, t)), 
    name='Pascal', math_name=r'\mathcal{P}') 

# set to `None' if classic *mod* partitioning is desired
    
partitioning=RemainderClassesPartitioning(modulo=2)
#partitioning=IsPrimePartitioning()
#partitioning=MultiplesOfPrimePartitioning(prime=3)

colouring = TriangleColouring(
    colouring_scheme="standard", 
    order=21,
    centered=False, 
    handle_negatives=False)

two_vars_matrix = matrix([
                            [1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0],
                            [1 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0],
                            [1 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0],
                            [1 , 2 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0],
                            [2 , 2 , 2 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0],
                            [1 , 0 , 2 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0],
                            [1 , 3 , 0 , 3 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0],
                            [3 , 6 , 3 , 3 , 3 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0],
                            [3 , 3 , 6 , 0 , 3 , 3 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0],
                            [1 , 0 , 3 , 0 , 0 , 3 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0],
                            [1 , 4 , 0 , 6 , 0 , 0 , 4 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0],
                            [4 , 12 , 4 , 12 , 6 , 0 , 4 , 4 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0],
                            [6 , 12 , 12 , 6 , 12 , 6 , 0 , 4 , 4 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0],
                            [4 , 4 , 12 , 0 , 6 , 12 , 0 , 0 , 4 , 4 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0],
                            [1 , 0 , 4 , 0 , 0 , 6 , 0 , 0 , 0 , 4 , 0 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0 , 0],
                            [1 , 5 , 0 , 10 , 0 , 0 , 10 , 0 , 0 , 0 , 5 , 0 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0 , 0],
                            [5 , 20 , 5 , 30 , 10 , 0 , 20 , 10 , 0 , 0 , 5 , 5 , 0 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 0],
                            [10 , 30 , 20 , 30 , 30 , 10 , 10 , 20 , 10 , 0 , 0 , 5 , 5 , 0 , 0 , 0 , 0 , 1 , 0 , 0 , 0],
                            [10 , 20 , 30 , 10 , 30 , 30 , 0 , 10 , 20 , 10 , 0 , 0 , 5 , 5 , 0 , 0 , 0 , 0 , 1 , 0 , 0],
                            [5 , 5 , 20 , 0 , 10 , 30 , 0 , 0 , 10 , 20 , 0 , 0 , 0 , 5 , 5 , 0 , 0 , 0 , 0 , 1 , 0],
                            [1 , 0 , 5 , 0 , 0 , 10 , 0 , 0 , 0 , 10 , 0 , 0 , 0 , 0 , 5 , 0 , 0 , 0 , 0 , 0 , 1]
                           ])

two_vars_matrix.name="two vars matrix"
two_vars_matrix.math_name="\mathcal{M}_{xy}"


 #def __call__(self, d=None, h=None, array=None,
 #107                     explicit_matrix=None, partitioning=None,
 #108                     handle_triangular_region_only=True):


# first we build the colouring for the standard triangle, timing it
standard_results, elapsed_time = timed_execution(
    lambda: colouring( 
        explicit_matrix=two_vars_matrix, 
        partitioning=partitioning,
        handle_triangular_region_only=False))

# a formatting pattern for a *datetime* object could be `.strftime("%M:%S.%f")'
# here `elapsed_time' is a timedelta object, hence it doesn't apply
print "**** standard colouring computed in {0} ****".format(elapsed_time)

# building tex files
standard_tex_files = build_tex_files_about_colouring(
    two_vars_matrix, standard_results, colouring, partitioning, tex_parent_prefix)


write_tex_files("pascal-typesetting-commands.sh", standard_tex_files)
print "**** wrote tex files ****"




