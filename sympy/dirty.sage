
#import sympy
#from sympy import *
#from sympy.abc import x, n, z, t

import sage.all

def Riordan_matrix_latex_code(g, f, var=x, order=7):
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

    row_template = r' & '.join(['{{{0}}}'.format(i) for i in range(order)]) + r' & '

    def make_latex_code(s):
        from IPython.display import Latex
        return (r'\left[ \begin{array}' 
                + '{{{0}}}'.format('c' * (order+1)) + s + ' \\\\ '
                + row_template.format(*[r'\vdots' for i in range(order)]) + r'\ddots'
                + r'\end{array} \right]')

    columns_as_power_series = [taylor(g(var) * f(var)**i,var,0,order) 
                                for i in range(order)]

    matrix_rows = []
    QQ_matrix = matrix(QQ, order, order)
    coloured_triangle_tikz_lines = []
    for row_index in range(order):

        def for_latex_code(col_index):
            coefficient = columns_as_power_series[col_index].coefficient(var**row_index)
            QQ_matrix[row_index, col_index] = coefficient
            if col_index <= row_index:
                coloured_triangle_tikz_lines.append(
                    r'\node[box={2}] (p-{0}-{1}) at (-{0}/2+{1},-{0}) {{}};'.format(
                        row_index, col_index, 'even' if is_even(Integer(coefficient)) else 'odd'))
            return '' if coefficient is 0 and col_index > row_index else coefficient

        coefficients = [for_latex_code(i) for i in range(order)]
        matrix_rows.append(row_template.format(* map(str, coefficients)))

    QQ_matrix[0,0] = g(0)

    return r'\begin{{equation}} \left( {0}, {1} \right) = {2} \end{{equation}}'.format(
        latex(g(var).factor()), latex(f(var).factor()), make_latex_code(' \\\\ '.join(matrix_rows))), QQ_matrix, coloured_triangle_tikz_lines

def write_tikz_lines_to_file(lines, filename='new_results.tex'):
    fp = open(filename,'w')
    fp.write('\n'.join(lines))
    fp.close()

