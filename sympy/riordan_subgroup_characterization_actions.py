
from sage.misc.latex import latex
from sage.symbolic.relation import solve
from sage.calculus.var import var

from riordan_group import *
from riordan_characterizations import *
from riordan_subgroups import *

class AbstractActionUsingSubgroupCharacterization: 

    def __init__(self, *args): 
        self.subgroup_characterization, self.Riordan_array = args


class ExpansionActionUsingSubgroupCharacterization(
        AbstractActionUsingSubgroupCharacterization): 

    def dispatched_from_VanillaDHfunctionsSubgroup(self, subgroup): 

        d, h, var = subgroup.d, subgroup.h, subgroup.variable
        order = self.Riordan_array.order

        # remember that in Python 2.7, `map' function returns a list, not a *map* object
        self.Riordan_array.expansion = \
            {i:map( lambda coeffs_pair: coeffs_pair[0],
                    (d(var) * h(var)**i).series(var,order).coefficients()) 
                for i in range(order)}

class FormalDefLatexCodeUsingSubgroupCharacterization(
        AbstractActionUsingSubgroupCharacterization):

    def dispatched_from_VanillaDHfunctionsSubgroup(self, subgroup): 

        def prepare_function_code(func_body):
            return latex(func_body.factor())

        d, h, var = subgroup.d, subgroup.h, subgroup.variable

        return r"{name}{downscript}{upscript}=\left({d}, {h}\right)".format(
            name=self.Riordan_array.math_name if self.Riordan_array.math_name else 'R',
            upscript='^{-1}' if self.Riordan_array.is_build_from_invertion else '',
            downscript='',
            d=prepare_function_code(d(var)), 
            h=prepare_function_code(h(var)))


class BuildInverseActionUsingSubgroupCharacterization(
        AbstractActionUsingSubgroupCharacterization): 

    def __init__(self, 
            characterization, 
            Riordan_array,
            variable=var('yyy'),                     
            h_comp_inverse_proof=lambda uv, gv, eq: eq): 

        args = (characterization, Riordan_array)

        AbstractActionUsingSubgroupCharacterization.__init__(self, *args)

        # the default value for `variable' should be generated a-la' lisp, using
        # an equivalent of `gensym' function. However adding heading and trailing
        # underscores should protect its capture.
        self.user_var = variable

        # use the identity proof if no one is given, this could be the case
        # where computing the compositional inverse is quite 'trivial'
        # and `solve' Sage function can handle the equation directly
        # (ie. when the equation is rational with no sqrt function in it)
        self.h_comp_inverse_proof = h_comp_inverse_proof

    def dispatched_from_VanillaDHfunctionsSubgroup(self, subgroup): 

        d, h, subgroup_var, user_var = (
            subgroup.d, subgroup.h, subgroup.variable, self.user_var)

        equation = user_var == h(subgroup_var)

        to_solve = self.h_comp_inverse_proof(user_var, subgroup_var, equation)

        solutions = solve(to_solve, subgroup_var)

        # check if the given proof yield an unique solution
        assert len(solutions) == 1
        
        sol = solutions[0]

        h_comp_inverse = sol.rhs().function(user_var)
        
        # check that the compositional inverse has no free variables
        assert len(h_comp_inverse.variables()) == 1

        variable_in_h, = h_comp_inverse.variables()

        # check that the only variable in the compositional inverse is 
        # the variable supplied by the user
        assert variable_in_h == user_var

        # check the defining condition for compositional inverse functions
        assert h_comp_inverse(h(subgroup_var)).factor() == subgroup_var

        # this check maybe doesn't pass, maybe it needs a little more help
        #assert h(h_comp_inverse(subgroup_var)).factor() == subgroup_var

        # okay, the proof effectively allow to build a compositional inverse
        # so we build a function `h_bar' in the subgroup variable.
        h_bar = h_comp_inverse(subgroup_var).function(subgroup_var)
        
        # just one more step in order to tie the `inverse_of' knot
        inverse_array = RiordanArray(
            self.subgroup_characterization.new(
            #SubgroupCharacterization(
                VanillaDHfunctionsSubgroup(
                    d=(1/d(h_bar(subgroup_var))).function(subgroup_var),
                    h=h_bar,
                    variable=subgroup_var)),
            name=self.Riordan_array.name,
            math_name=self.Riordan_array.math_name,
            inverse_of=self.Riordan_array)

        # finally it is possible to set the inverse on the former caller
        self.Riordan_array.inverse_of = inverse_array

        # if it can be useful we return the compositional inverse `h_comp_inverse'
        # in the variable supplied by the user, in order to better distinguish it 
        # from the characteristic `h_bar' used for the inverse array (however they
        # *denotes* the same function)
        return h_comp_inverse

