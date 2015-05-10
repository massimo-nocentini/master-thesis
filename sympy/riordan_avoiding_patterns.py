
from sage.misc.functional import symbolic_sum
from sage.calculus import var

def from_pattern_family_10j_1(j, variable=var('t')):
    """
    This function allow to build a pair of functions (d, h) to 
    build a Riordan array for the pattern family (10)**j1, for a given j.
    """
    
    def make_sum(from_index): return symbolic_sum(variable**i, i, from_index, j)

    i = var('i')

    d = make_sum(from_index=0)/sqrt(
        1-2*make_sum(from_index=1)-3*make_sum(from_index=1)**2)

    h = (make_sum(from_index=0) - sqrt(
        1-2*make_sum(from_index=1)-3*make_sum(from_index=1)**2))/(2*make_sum(from_index=0))

    return d,h

def from_pattern_family_01j_0(j, variable=var('t')):
    """
    This function allow to build a pair of functions (d, h) to 
    build a Riordan array for the pattern family (10)**j1, for a given j.
    """
    
    def make_sum(from_index, to=j): return symbolic_sum(variable**i, i, from_index, to)

    i = var('i')

    d = make_sum(from_index=0)/sqrt(
        1-2*make_sum(from_index=1)-3*make_sum(from_index=1)**2)

    h = (make_sum(from_index=0) - sqrt(
        1-2*make_sum(from_index=1)-3*make_sum(from_index=1)**2))/(2*make_sum(
            from_index=0, to=j-1))

    return d,h


def from_pattern_family_j_j(j, variable=var('t')):
    """
    This function allow to build a pair of functions (d, h) to 
    build a Riordan array for the pattern family (10)**j1, for a given j.
    """
    
    d = 1/sqrt(1-4*variable + 2*variable**j + variable**(2*j))

    h = (1 + variable**j - sqrt(1-4*variable + 2*variable**j + variable**(2*j)))/2

    return d,h


def from_pattern_family_1_succj_0_j(j, variable=var('t')):
    """
    This function allow to build a pair of functions (d, h) to 
    build a Riordan array for the pattern family (10)**j1, for a given j.
    """
    
    d = 1/sqrt(1-4*variable + 4*variable**(j+1))

    h = (1 - sqrt(1-4*variable + 4*variable**(j+1)))/2

    return d,h


def from_pattern_family_0_succj_1_j(j, variable=var('t')):
    """
    This function allow to build a pair of functions (d, h) to 
    build a Riordan array for the pattern family (10)**j1, for a given j.
    """
    
    d = 1/sqrt(1-4*variable + 4*variable**(j+1))

    h = (1 - sqrt(1-4*variable + 4*variable**(j+1)))/(2*(1-variable**j))

    return d,h


