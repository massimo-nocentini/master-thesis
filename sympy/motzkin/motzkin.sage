
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

tex_parent_prefix = "../sympy/motzkin/"

partitioning=RemainderClassesPartitioning(modulo=2)

colouring = TriangleColouring(
    colouring_scheme="standard", 
    order=127,
    centered=True, 
    handle_negatives=False)

t = var('t')

#________________________________________________________________________

# the following version is the one given by Prof. Merlini, paired 
# with the diamond definition.
d(t)=(1-t-sqrt(1-2*t-3*t**2))/(2*t**2)
h(t)=(1-t-sqrt(1-2*t-3*t**2))/(2*t)

# building Riordan group
Riordan_array = RiordanArray(
    SubgroupCharacterization(
        VanillaDHfunctionsSubgroup(d, h, t)), 
    name='Motzkin', math_name=r'\mathcal{M}',
    additional_caption_text=r"""
No closed form for the generic element $\mathcal{M}_{dk}$ is known.""") 


# first we build the colouring for the standard triangle, timing it
M_results, elapsed_time = timed_execution(
    lambda: colouring( 
        array=Riordan_array, 
        partitioning=partitioning))
# a formatting pattern for a *datetime* object could be `.strftime("%M:%S.%f")'
# here `elapsed_time' is a timedelta object, hence it doesn't apply
print "**** Motzkin colouring computed in {0} ****".format(elapsed_time)

# building tex files
M_tex_files = build_tex_files_about_colouring(
    Riordan_array, M_results, colouring, partitioning, tex_parent_prefix)

#________________________________________________________________________
# now tackle `diamond' triangle of $\mathcal{M}$ defined above.

d(t)=1-t**2
h(t)=t/(1+t+t**2)

# building Riordan group
Riordan_array = RiordanArray(
    SubgroupCharacterization(
        VanillaDHfunctionsSubgroup(d, h, t)), 
    name='Motzkin diamond', math_name=r'\mathcal{M}^{\diamond}',
    additional_caption_text=r"""
No closed form for the generic element $\mathcal{M}_{dk}$ is known.""") 


# first we build the colouring for the standard triangle, timing it
M_diamond_results, elapsed_time = timed_execution(
    lambda: colouring( 
        array=Riordan_array, 
        partitioning=partitioning))
# a formatting pattern for a *datetime* object could be `.strftime("%M:%S.%f")'
# here `elapsed_time' is a timedelta object, hence it doesn't apply
print "**** Motzkin diamond colouring computed in {0} ****".format(elapsed_time)

# building tex files
M_diamond_tex_files = build_tex_files_about_colouring(
    Riordan_array, M_diamond_results, colouring, partitioning, tex_parent_prefix)

#________________________________________________________________________
#________________________________________________________________________

# The following one is what Prof. Merlini calls variant $\mathcal{T}$:
# fot this one we study normal, inverse, diamond and perpendicular
# arrays.

d(t)=1/sqrt(1-2*t-3*t**2)
h(t)=(1-t-sqrt(1-2*t-3*t**2))/(2*t)

# building Riordan group
Riordan_array = RiordanArray(
    SubgroupCharacterization(
        VanillaDHfunctionsSubgroup(d, h, t)), 
    name='Motzkin variant T', math_name=r'\mathcal{T}',
    additional_caption_text=r"""
This array is a variant of array $\mathcal{M}$, its generic element
has the following closed form:
\begin{displaymath}
    \mathcal{T}_{nk}=\sum_{j=0}^{n}{{{n}\choose{j}}{{j}\choose{n+k-j}}}
\end{displaymath}""") 

# first we build the colouring for the standard triangle, timing it
T_results, elapsed_time = timed_execution(
    lambda: colouring( 
        array=Riordan_array, 
        partitioning=partitioning))
# a formatting pattern for a *datetime* object could be `.strftime("%M:%S.%f")'
# here `elapsed_time' is a timedelta object, hence it doesn't apply
print "**** T colouring computed in {0} ****".format(elapsed_time)

# building tex files
T_tex_files = build_tex_files_about_colouring(
    Riordan_array, T_results, colouring, partitioning, tex_parent_prefix)

#________________________________________________________________________

#colouring.colouring_scheme = "repeated-differences"

# now we apply repeated difference in order to get a new array
#repeated_differences_matrix, elapsed_time = timed_execution(
#    lambda: repeated_applications(standard_results[0]))
#print "**** repeated differences colouring computed in {0} ****".format(elapsed_time)

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
    h_comp_inverse_proof=lambda y, t, equation: (equation*2*t*(-1) -(t-1))**2)

# first we build the colouring for the standard triangle, timing it
T_inverse_results, elapsed_time = timed_execution(
    lambda: colouring( 
        array=inverse_array, 
        partitioning=partitioning))
# a formatting pattern for a *datetime* object could be `.strftime("%M:%S.%f")'
# here `elapsed_time' is a timedelta object, hence it doesn't apply
print "**** T inverse colouring computed in {0} ****".format(elapsed_time)

# building tex files
T_inverse_tex_files = build_tex_files_about_colouring(
    inverse_array, T_inverse_results, 
    colouring, partitioning, tex_parent_prefix)

#________________________________________________________________________

# now study the diamond array of $\mathcal{T}$.

colouring.colouring_scheme = "standard"

d(t)=1
h(t)=t/(1+t+t**2)

# building Riordan group
diamond_Riordan_array = RiordanArray(
    SubgroupCharacterization(
        VanillaDHfunctionsSubgroup(d, h, t)), 
    name='Motzkin variant T diamond', math_name=r'\mathcal{T}^{\diamond}') 

# first we build the colouring for the standard triangle, timing it
T_diamond_results, elapsed_time = timed_execution(
    lambda: colouring( 
        array=diamond_Riordan_array, 
        partitioning=partitioning))

# a formatting pattern for a *datetime* object could be `.strftime("%M:%S.%f")'
# here `elapsed_time' is a timedelta object, hence it doesn't apply
print "**** T diamond colouring computed in {0} ****".format(elapsed_time)

# building tex files
T_diamond_tex_files = build_tex_files_about_colouring(
    diamond_Riordan_array, T_diamond_results, 
    colouring, partitioning, tex_parent_prefix)
#________________________________________________________________________

# now study the perpendicular array of $\mathcal{T}$.

colouring.colouring_scheme = "standard"

d(t)=1/(1+t+t**2)
h(t)=t/(1+t+t**2)

# building Riordan group
perp_Riordan_array = RiordanArray(
    SubgroupCharacterization(
        VanillaDHfunctionsSubgroup(d, h, t)), 
    name='Motzkin variant T perp', math_name=r'\mathcal{T}^{\perp}') 

# first we build the colouring for the standard triangle, timing it
T_perp_results, elapsed_time = timed_execution(
    lambda: colouring( 
        array=perp_Riordan_array, 
        partitioning=partitioning))

# a formatting pattern for a *datetime* object could be `.strftime("%M:%S.%f")'
# here `elapsed_time' is a timedelta object, hence it doesn't apply
print "**** T perp colouring computed in {0} ****".format(elapsed_time)

T_perp_tex_files = build_tex_files_about_colouring(
    perp_Riordan_array, T_perp_results, colouring, partitioning, tex_parent_prefix)
#________________________________________________________________________

write_tex_files("motzkin-typesetting-commands.sh",
    M_tex_files, M_diamond_tex_files,
    T_tex_files, T_inverse_tex_files,
    T_diamond_tex_files, T_perp_tex_files)

print "**** wrote tex files ****"




