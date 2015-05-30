
from sage.misc.latex import latex
from sage.symbolic.relation import solve
from sage.calculus.var import var

from riordan_group import *
from riordan_characterizations import *
from riordan_subgroups import *
#from sage.misc.functional import show

class AbstractActionUsingSubgroupCharacterization: 

    def __init__(self, *args): 
        self.subgroup_characterization, self.Riordan_array = args


class ExpansionActionUsingSubgroupCharacterization(
        AbstractActionUsingSubgroupCharacterization): 

    def dispatched_from_VanillaDHfunctionsSubgroup(self, subgroup): 

        d, h, var = subgroup.d, subgroup.h, subgroup.variable
        order = self.Riordan_array.order

        # remember that in Python 2.7, `map' function returns a list, not a *map* object
        expansion = {}
        for i in range(order):

            try:
                expanded_series = (d(var) * h(var)**i).series(var,order+1)
            except ValueError as e:
                var_setting_string = 'd(t)=', str(d), ';h(t)=',str(h), ';var=', var, ';i=', i, ';order=', order
                statement_string = r'\nstatement: expanded_series = (d(var) * h(var)**i).series(var,order+1)'
                print "{exception_message}\n{settings:}\n{statement}".format( 
                    exception_message=str(e), settings=var_setting_string, statement=statement_string)
                raise e

            expansion[i] = [expanded_series.coefficient(var**n) 
                if n > 0 else expanded_series.trailing_coeff(var)
                    for n in range(order)]

        #expansion = {i:map( lambda coeffs_pair: coeffs_pair[0],
                    #(d(var) * h(var)**i).series(var,order+1).coefficients()) 
                #for i in range(1, order)}

        #expansion[0] = [d(0)] + [0 for i in range(order)]

        self.Riordan_array.expansion = expansion
        #print self.Riordan_array.expansion


class FormalDefLatexCodeUsingSubgroupCharacterization(
        AbstractActionUsingSubgroupCharacterization):

    def dispatched_from_VanillaDHfunctionsSubgroup(self, subgroup): 

        def prepare_function_code(func_body):
            return latex(func_body.factor())

        d, h, var = subgroup.d, subgroup.h, subgroup.variable

        math_name = None
        if '^' in self.Riordan_array.math_name:
            math_name = r"\left({name}\right)".format(
                name=self.Riordan_array.math_name) 
        else:
            math_name = self.Riordan_array.math_name

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

        # filter found solutions in order to consider only those
        # that allow to build a function in `user_var' only
        solutions = filter(lambda sol: sol.rhs().variables() == (user_var,), solutions)

        # remove heading sqrt applications and factor
        possible_compositional_inverses_rhses = map(
            lambda sol: sol.rhs().canonicalize_radical().factor(),
            solutions)


        # build candidate compositional inverses
        possible_compositional_inverses = map(
            lambda candidate: candidate.function(user_var), 
            possible_compositional_inverses_rhses)


        # apply *compositional inverse condition* effectively
        possible_compositional_inverses = filter(
            lambda candidate: candidate(
                h(subgroup_var)).canonicalize_radical().factor() == subgroup_var,
            possible_compositional_inverses)

        if len(possible_compositional_inverses) > 1:

            print "Compositional inverse is not unique, valuating at zero attempt: {candidates}".format(candidates=possible_compositional_inverses)

            # include only those inverses `h_bar' such that `h_bar(0) == 0'
            possible_compositional_inverses = filter(
                lambda candidate: candidate(0) == 0, 
                possible_compositional_inverses)
        
        if not possible_compositional_inverses: 
            raise Exception(r"No compositional inverse candidate found solving equation: {equation} (latex code: ${latex_code}$)".format(
                equation=str(to_solve), latex_code=latex(to_solve))) #, equation=to_solve)

        #print possible_compositional_inverses

        # the following expression is very interesting to evaluate at the REPL:
        #  map(show, map(lambda f: (delannoy_h(f(t)).canonicalize_radical(),f), map(lambda sol: sol.rhs().function(y), solve(delannoy_h(t)==y,t)))) 
        #solutions = filter(lambda expr, h_compositional_inverse: , 
                        #map(lambda h_compositional_inverse: (h_compositional_inverse(h(subgroup_var)), h_compositional_inverse), 
                            #possible_compositional_inverses)) 

        # The following code is subsumed by the above one
        #trivial_sol = subgroup_var == 0
        #if trivial_sol in solutions: solutions.remove(trivial_sol)

        # check if the given proof yield an unique solution
#        assert len(possible_compositional_inverses) == 1
        
        # the following checks now could be removed.
        sol = possible_compositional_inverses[0]

        #h_comp_inverse = sol.rhs().function(user_var)
        h_comp_inverse = sol
        
        # check that the compositional inverse has no free variables
        assert len(h_comp_inverse.variables()) == 1

        variable_in_h, = h_comp_inverse.variables()

        # check that the only variable in the compositional inverse is 
        # the variable supplied by the user
        assert variable_in_h == user_var

        # check the defining condition for compositional inverse functions
        assert h_comp_inverse(h(subgroup_var)).canonicalize_radical().factor() == subgroup_var

        # this check maybe doesn't pass, maybe it needs a little more help
        #assert h(h_comp_inverse(subgroup_var)).factor() == subgroup_var

        # okay, the proof effectively allow to build a compositional inverse
        # so we build a function `h_bar' in the subgroup variable.
        h_bar = h_comp_inverse(subgroup_var).function(subgroup_var)
        
        # preparing inverse functions: it should be interesting to write
        # a kind of fix point search for the expression, toward removing
        # sqrt applications in first instance, which are not handled
        # by Sage simplification because have lower priority than factorials...
        def prepare_inverse(func): 
            return func.canonicalize_radical().simplify_full().function(subgroup_var)

        d_inverse = prepare_inverse((1/d(h_bar(subgroup_var))))
        h_inverse = prepare_inverse(h_bar)

        # just one more step in order to tie the `inverse_of' knot
        inverse_array = RiordanArray(
            self.subgroup_characterization.new(
            #SubgroupCharacterization(
                VanillaDHfunctionsSubgroup(
                    d=d_inverse, h=h_inverse, variable=subgroup_var)),
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

