
from sage.all import *

def Riordan_matrix_latex_code(  array, 
                                var=var('t'), 
                                order=10, 
                                handlers_tuple=None,
                                handle_triangular_region_only=True):
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

    if handlers_tuple is None:
        on_computed_coefficient=None
        on_computed_row_coefficients=None
    else:
        on_computed_coefficient, on_computed_row_coefficients = handlers_tuple

    if on_computed_coefficient is None: 
        on_computed_coefficient=lambda row, col, coeff: coeff

    if on_computed_row_coefficients is None:
        on_computed_row_coefficients=lambda row_index, coefficients: coefficients

    g, f = array

    columns_as_power_series = [(g(var) * f(var)**i).series(var,order) 
                                for i in range(order)]

    QQ_matrix = matrix(QQ, order, order)

    def handler(row_index, col_index):

        col_fps = columns_as_power_series[col_index]
        coefficient = col_fps.coefficient(var**row_index) \
                        if row_index > 0 else col_fps.trailing_coefficient(var)
        QQ_matrix[row_index, col_index] = coefficient

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


def coloured_triangle(d, h, classes=2, order=100):

    def colours_mapping(witness):
        if witness == 0: return 'zero'
        elif witness == 1: return 'one'
        elif witness == 2: return 'two'
        else: return 'three'

    colouring_handlers = colouring(  
        partitioning=lambda coeff: coeff.mod(classes)) 
        #colours_mapping=lambda witness: 'zero' if witness == 0 else 'odd')
        #colours_mapping=colours_mapping)

    pascal_matrix, tikz_coloured_nodes, _ = Riordan_matrix_latex_code ( 
        array=(d,h), order=order, handlers_tuple=colouring_handlers)

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

def write_tikz_lines_to_file(lines, filename='new_results.tex'):
    fp = open(filename,'w')
    fp.write('\n'.join(lines))
    fp.close()

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









