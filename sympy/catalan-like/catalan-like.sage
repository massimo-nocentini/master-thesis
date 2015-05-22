
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

tex_parent_prefix = "../sympy/catalan-like/"

partitioning=RemainderClassesPartitioning(modulo=2)

colouring = TriangleColouring(
    colouring_scheme="standard", 
    order=127,
    centered=True, 
    handle_negatives=False)

#________________________________________________________________________

# The following stuff is related to what Professor called \mathcal{S}.

t = var('t')
d(t)=(1-sqrt(1-4*t))/(2*t)
h(t)=(1-2*t-sqrt(1-4*t))/(2*t)

# building Riordan group
Riordan_array = RiordanArray(
    SubgroupCharacterization(
        VanillaDHfunctionsSubgroup(d, h, t)), 
    name='Catalan variant S', math_name=r'\mathcal{S}',
    additional_caption_text=r"""
This is the first variant for Catalan array, we've called this array $\mathcal{S}$ 
and its generic element has the following closed form:
\begin{displaymath}
    \mathcal{S}_{nk}=\frac{2k+1}{n+k+1}{{{2n}\choose{n-k}}}
\end{displaymath}""") 
    

# first we build the colouring for the standard triangle, timing it
S_results, elapsed_time = timed_execution(
    lambda: colouring( 
        array=Riordan_array, 
        partitioning=partitioning))
# a formatting pattern for a *datetime* object could be `.strftime("%M:%S.%f")'
# here `elapsed_time' is a timedelta object, hence it doesn't apply
print "**** S standard colouring computed in {0} ****".format(elapsed_time)

# building tex files
S_tex_files = build_tex_files_about_colouring(
    Riordan_array, S_results, colouring, partitioning, tex_parent_prefix)

# now we build the inverse too
colouring.colouring_scheme = "inverse"

inverse_array = Riordan_array.inverse(
    variable=var('y'), 
    h_comp_inverse_proof=lambda y, t, equation: (equation*2*t*(-1) + 1 -2*t)**2)
    
inverse_array.additional_caption_text=r"""
This is the inverse of the first variant for Catalan array $\mathcal{S}$ 
and its generic element has the following closed form:
\begin{displaymath}
    \mathcal{S}_{nk}^{-1}=(-1)^{n-k}{{{n+k}\choose{n-k}}}
\end{displaymath}""" 

# first we build the colouring for the standard triangle, timing it
S_inverses_results, elapsed_time = timed_execution(
    lambda: colouring( 
        array=inverse_array, 
        partitioning=partitioning))
# a formatting pattern for a *datetime* object could be `.strftime("%M:%S.%f")'
# here `elapsed_time' is a timedelta object, hence it doesn't apply
print "**** S inverse colouring computed in {0} ****".format(elapsed_time)

# building tex files
S_inverses_tex_files = build_tex_files_about_colouring(
    inverse_array, S_inverses_results, 
    colouring, partitioning, tex_parent_prefix)


#________________________________________________________________________

# The following stuff is related to what Professor called \mathcal{C}.

t = var('t')
d(t)=1
h(t)=(1-sqrt(1-4*t))/2

# restore standard colouring scheme
colouring.colouring_scheme = "standard"

# building Riordan group
Riordan_array = RiordanArray(
    SubgroupCharacterization(
        VanillaDHfunctionsSubgroup(d, h, t)), 
    name='Catalan variant C', math_name=r'\mathcal{C}',
    additional_caption_text=r"""
This is the second variant for Catalan array, we've called this array $\mathcal{C}$ 
and its generic element has the following closed form:
\begin{displaymath}
    \mathcal{C}_{nk}=\frac{k}{2n-k}{{{2n-k}\choose{n-k}}}
\end{displaymath}""") 
    

# first we build the colouring for the standard triangle, timing it
C_results, elapsed_time = timed_execution(
    lambda: colouring( 
        array=Riordan_array, 
        partitioning=partitioning))
# a formatting pattern for a *datetime* object could be `.strftime("%M:%S.%f")'
# here `elapsed_time' is a timedelta object, hence it doesn't apply
print "**** C standard colouring computed in {0} ****".format(elapsed_time)

# building tex files
C_tex_files = build_tex_files_about_colouring(
    Riordan_array, C_results, colouring, partitioning, tex_parent_prefix)

# now we build the inverse too
colouring.colouring_scheme = "inverse"

inverse_array = Riordan_array.inverse(
    variable=var('y'), 
    h_comp_inverse_proof=lambda y, t, equation: (equation*2*(-1) + 1)**2)
    
inverse_array.additional_caption_text=r"""
This is the inverse of the second variant for Catalan array $\mathcal{C}$ 
and its generic element has the following closed form:
\begin{displaymath}
    \mathcal{C}_{nk}^{-1}=(-1)^{n-k}{{{k}\choose{n-k}}}
\end{displaymath}""" 

# first we build the colouring for the standard triangle, timing it
C_inverses_results, elapsed_time = timed_execution(
    lambda: colouring( 
        array=inverse_array, 
        partitioning=partitioning))
# a formatting pattern for a *datetime* object could be `.strftime("%M:%S.%f")'
# here `elapsed_time' is a timedelta object, hence it doesn't apply
print "**** C inverse colouring computed in {0} ****".format(elapsed_time)

# building tex files
C_inverses_tex_files = build_tex_files_about_colouring(
    inverse_array, C_inverses_results, 
    colouring, partitioning, tex_parent_prefix)

#________________________________________________________________________


# The following stuff is related to what Professor called \mathcal{B}.

t = var('t')
d(t)=1/sqrt(1-4*t)
h(t)=(1-2*t-sqrt(1-4*t))/(2*t)

# restore standard colouring scheme
colouring.colouring_scheme = "standard"

# building Riordan group
Riordan_array = RiordanArray(
    SubgroupCharacterization(
        VanillaDHfunctionsSubgroup(d, h, t)), 
    name='Catalan variant B', math_name=r'\mathcal{B}',
    additional_caption_text=r"""
This is the third variant for Catalan array, we've called this array $\mathcal{B}$ 
and its generic element has the following closed form:
\begin{displaymath}
    \mathcal{B}_{nk}={{{2n}\choose{n-k}}}
\end{displaymath}""") 
    

# first we build the colouring for the standard triangle, timing it
B_results, elapsed_time = timed_execution(
    lambda: colouring( 
        array=Riordan_array, 
        partitioning=partitioning))
# a formatting pattern for a *datetime* object could be `.strftime("%M:%S.%f")'
# here `elapsed_time' is a timedelta object, hence it doesn't apply
print "**** B standard colouring computed in {0} ****".format(elapsed_time)

# building tex files
B_tex_files = build_tex_files_about_colouring(
    Riordan_array, B_results, colouring, partitioning, tex_parent_prefix)

#________________________________________________________________________

t = var('t')
d(t)=1
h(t)=t/((1+t)**2)

# restore standard colouring scheme
colouring.colouring_scheme = "standard"


# building Riordan group
Riordan_array = RiordanArray(
    SubgroupCharacterization(
        VanillaDHfunctionsSubgroup(d, h, t)), 
    name='Catalan variant B diamond', math_name=r'\mathcal{B}^{\diamond}',
    additional_caption_text=r"""
This is the third variant for Catalan array, we've called this array 
$\mathcal{B}^{\diamond}$ and its generic element has the following closed form:
\begin{displaymath}
    \mathcal{B}_{nk}^{\diamond}=(-1)^{n-k}{{{n+k-1}\choose{n-k}}}
\end{displaymath}""") 
    

# first we build the colouring for the standard triangle, timing it
B_diamond_results, elapsed_time = timed_execution(
    lambda: colouring( 
        array=Riordan_array, 
        partitioning=partitioning))
# a formatting pattern for a *datetime* object could be `.strftime("%M:%S.%f")'
# here `elapsed_time' is a timedelta object, hence it doesn't apply
print "**** B diamond standard colouring computed in {0} ****".format(elapsed_time)

# building tex files
B_diamond_tex_files = build_tex_files_about_colouring(
    Riordan_array, B_diamond_results, colouring, partitioning, tex_parent_prefix)

#________________________________________________________________________

write_tex_files("catalan-like-typesetting-commands.sh",
    S_tex_files, S_inverses_tex_files,
    C_tex_files, C_inverses_tex_files,
    B_tex_files, B_diamond_tex_files)
print "**** wrote tex files ****"




