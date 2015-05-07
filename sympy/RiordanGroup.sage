
from sage.all import *
from string import Template
from datetime import datetime

def Riordan_matrix_latex_code(
        array, order=10, handlers_tuple=None, handle_triangular_region_only=True):
    """
    Produces a chunk of infinite lower matrix denoted by functions *d* and *h*

    Enhancement:
        1.  Add optional arguments that request to return a sympy matrix
            (expansion of function *h* is interesting only if the returned object
            is of class Eq, otherwise the client could expand *h* by itself)

    Fixes:
        1.  change name of functions *g* and *f* to *d* and *h*, also change 
            default var name to *t*.
    """

    # adjust handlers in order to talk witk "null objects" if no action are desired.
    if handlers_tuple is None:
        on_computed_coefficient=None
        on_computed_row_coefficients=None
    else:
        on_computed_coefficient, on_computed_row_coefficients = handlers_tuple

    if on_computed_coefficient is None: 
        on_computed_coefficient=lambda row, col, coeff: coeff

    if on_computed_row_coefficients is None:
        on_computed_row_coefficients=lambda row_index, coefficients: coefficients

    # initialize coefficient matrix, aka the Riordan array expansion
    QQ_matrix = matrix(QQ, order, order)

    def handler(row_index, col_index):

        # indexing `array' is the only requirement for it to be a Riordan array
        QQ_matrix[row_index, col_index] = coefficient = array[row_index, col_index]

        try:
            result_from_supplied_block = on_computed_coefficient(
                row_index, col_index, coefficient)
        except: 
            result_from_supplied_block = None

        return result_from_supplied_block


    result_list_from_supplied_block = []
    result_list_from_supplied_block_per_row = {}

    for row_index in range(order):

        col_limit = row_index + 1 if handle_triangular_region_only else order

        result_list_from_supplied_block_per_row[row_index] = []

        for col_index in range(col_limit): 

            element = handler(row_index, col_index)
            result_list_from_supplied_block.append(element)  
            result_list_from_supplied_block_per_row[row_index].append(element)
        
        result_list_from_supplied_block_per_row[row_index] = \
            on_computed_row_coefficients(
                row_index, 
                result_list_from_supplied_block_per_row[row_index])

    return (QQ_matrix, 
            result_list_from_supplied_block, 
            result_list_from_supplied_block_per_row)

class RiordanArray:

    def __init__(self, characterization):
        self.characterization = characterization
        self.expansion = None
        self.order = None

    def __getitem__(self, index):

        row_index, col_index = index

        if self.order is None or max(row_index, col_index) >= self.order: 
            self.augment_expansion()

#       Under the hood, the first `column' index works over a dictionary,
#       hence it a *key*; on the other hand, the latter `row' index works over
#       a list, hence it is a proper positional index.
        return self.expansion[col_index][row_index]

        #col_fps = self.columns_as_power_series[col_index]
        #coefficient = col_fps.coefficient(var**row_index) \
                        #if row_index > 0 else col_fps.trailing_coefficient(var)

        #return coefficient

    def augment_expansion(self):
        if self.order is None: self.order = 1
        self.order *= 2
        self.characterization.expansion_for_Riordan_array(self)

class VanillaDHfunctionsSubgroup:

    def __init__(self, d, h, variable):
        self.d, self.h, self.variable = d, h, variable

    def dispatch_on(self, recipient):
        recipient.dispatched_from_VanillaDHfunctionsSubgroup(self)
        

#________________________________________________________________________

# The following classes fixes some ideas about characterizations.

class AbstractCharacterization: pass

class SequencesCharacterization(AbstractCharacterization):
    
    def __init__(self, d_zero, A_sequence, Z_sequence): pass


class MatrixCharacterization(AbstractCharacterization):

    def __init__(self, A_matrix): pass


class SubgroupCharacterization(AbstractCharacterization):

    def __init__(self, subgroup): 
        self.subgroup = subgroup

    def expansion_for_Riordan_array(self, Riordan_array):
        # maybe the following message should say Subgroup characterization explicitly
        self.subgroup.dispatch_on(
            ExpansionActionUsingSubgroupCharacterization(self, Riordan_array))


class ExpansionActionUsingSubgroupCharacterization: 

    def __init__(self, *args): 
        self.subgroup_characterization, self.Riordan_array = args

    def dispatched_from_VanillaDHfunctionsSubgroup(self, subgroup): 

        d, h, var = subgroup.d, subgroup.h, subgroup.variable
        order = self.Riordan_array.order

        # remember that in Python 2.7, `map' function returns a list, not a *map* object
        self.Riordan_array.expansion = \
            {i:map( lambda coeffs_pair: coeffs_pair[0],
                    (d(var) * h(var)**i).series(var,order).coefficients()) 
                for i in range(order)}
#________________________________________________________________________

def colouring(  
        partitioning, 
        colours_mapping=lambda witness:str(witness), 
        on_tikz_node_generated=lambda node: node,
        casting_coeff=lambda coeff: Integer(coeff)):

    def handler(row_index, col_index, coeff): 
        eqclass_witness = partitioning(casting_coeff(coeff))
        colour_code = colours_mapping(eqclass_witness)
        tikz_node = on_tikz_node_generated(
                        r'\node[box={2}] (p-{0}-{1}) at (-{0}/2+{1},-{0}) {{}};'.format(
                            row_index, col_index, colour_code))
        return tikz_node

    return handler, None 

def enhanced_latex(order, row_template):

    def coefficient_handler(row_index, col_index, coeff):
        return '' if coeff is 0 and col_index > row_index else str(coeff)

    def row_handler(row_index, coefficients): 
        #matrix_rows.append(row_template.format(* map(str, coefficients)))
        return row_template.format(*coefficients)

    return coefficient_handler, row_handler


def coloured_triangle(  d=None, h=None, array=None,
                        classes=2, order=100, 
                        for_inverses=False,
                        explicit_matrix=None,
                        partitioning=None):

    if for_inverses:
        # the following function change "tonality" for negative entries
        def colours_mapping_for_inverses(witness):
            sign, witness_class = witness
            return str(witness_class) + ('-for-negatives' if sign < 0 else '')

        if partitioning is None:
            partitioning=lambda coeff: (coeff.sign(), coeff.mod(classes))

        colouring_handlers = colouring(partitioning, colours_mapping_for_inverses) 
    else:
        if partitioning is None:
            partitioning=lambda coeff: coeff.mod(classes) 

        colouring_handlers = colouring(partitioning) 

    if d and h:
        # First ensures that both `d' both `h' 
        # use the same *indeterminate*
        assert d.args() == h.args() and len(d.args()) == 1

        Riordan_array = RiordanArray(
            SubgroupCharacterization(
                VanillaDHfunctionsSubgroup(d, h, d.args()[0]))) 

    elif explicit_matrix:   Riordan_array = explicit_matrix
    elif array:             Riordan_array = array
    else:                   raise Exception("No array to work with")

    pascal_matrix, tikz_coloured_nodes, _ = Riordan_matrix_latex_code ( 
        array=Riordan_array, order=order, handlers_tuple=colouring_handlers)

    return pascal_matrix, tikz_coloured_nodes


def latex_triangle(d, h):

    order = 100
    row_template = r' & '.join(['{{{0}}}'.format(i) for i in range(order)]) + r' & '

    def make_latex_code(s):
        return (r'\left[ \begin{array}' 
                + '{{{0}}}'.format('c' * (order+1)) + s + ' \\\\ '
                + row_template.format(*[r'\vdots' for i in range(order)]) + r'\ddots'
                + r'\end{array} \right]')

    latex_handler = enhanced_latex(order, row_template)

    pascal_matrix, _, coefficients_per_rows = Riordan_matrix_latex_code ( 
        array=(d,h), order=order, on_computed_coefficient=latex_handler)

    matrix_rows = [coefficients_per_rows[row_index] for row_index in range(order)]

    return pascal_matrix, r'\begin{{equation}} \left( {0}, {1} \right) = {2} \end{{equation}}'.format(
        latex(d(t)), latex(h(t)), make_latex_code(' \\\\ '.join(matrix_rows)))

def repeated_applications(aMatrix, func=lambda row, previous_row: row - previous_row):
    """ Apply repeated differences to the given matrix """

    result_matrix = copy(aMatrix)
    len_rows = aMatrix.dimensions()[0] # get number of rows
    for j in range(1, len_rows):
        sandbox_matrix = copy(result_matrix)
        for i in range(j, len_rows):
            result_matrix[i,:] = func(sandbox_matrix[i,:], sandbox_matrix[i-1,:])
        #show(result_matrix)
    return result_matrix

def write_tikz_lines_to_file(lines, filename='new_results.tex', joiner='\n'):
    with open(filename,'w') as fp:
        fp.write(joiner.join(lines) if joiner else lines)

def substitute_from_filename(
    template_filename, 
    substitutions=dict(tikz_lines_input_filename='new_results.tex')):

    with open(template_filename) as tf:
        content = Template(tf.read())
        return content.safe_substitute(substitutions)

def timed_execution(block):

    start_timestamp=datetime.now()
    try: results = block()
    except Exception as e: results = e

    return results, datetime.now() - start_timestamp


#________________________________________________________________________
#
# PATTERN STUFF
#________________________________________________________________________

def from_pattern_family_10j_1(j, variable=var('t')):
    """
    This function allow to build a pair of functions (d, h) to 
    build a Riordan array for the pattern family (10)**j1, for a given j.
    """
    
    def make_sum(from_index): return sum(variable**i, i, from_index, j)

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
    
    def make_sum(from_index, to=j): return sum(variable**i, i, from_index, to)

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
    
    d = 1/sqrt(1-4*t + 2*t**j + t**(2*j))

    h = (1 + t**j - sqrt(1-4*t + 2*t**j + t**(2*j)))/2

    return d,h


def from_pattern_family_1_succj_0_j(j, variable=var('t')):
    """
    This function allow to build a pair of functions (d, h) to 
    build a Riordan array for the pattern family (10)**j1, for a given j.
    """
    
    d = 1/sqrt(1-4*t + 4*t**(j+1))

    h = (1 - sqrt(1-4*t + 4*t**(j+1)))/2

    return d,h


def from_pattern_family_0_succj_1_j(j, variable=var('t')):
    """
    This function allow to build a pair of functions (d, h) to 
    build a Riordan array for the pattern family (10)**j1, for a given j.
    """
    
    d = 1/sqrt(1-4*t + 4*t**(j+1))

    h = (1 - sqrt(1-4*t + 4*t**(j+1)))/(2*(1-t**j))

    return d,h









