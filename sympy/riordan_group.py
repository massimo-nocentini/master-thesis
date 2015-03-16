
def Riordan_matrix_latex_code(g, f, var=x, order=7):

    row_template = r' & '.join(['{{{0}}}'.format(i) for i in range(order)]) + r' & '

    def make_latex_code(s):
        from IPython.display import Latex
        return (r'\[ \left[ \begin{array}' 
                + '{{{0}}}'.format('c' * (order+1)) + s + ' \\\\ '
                + row_template.format(*[r'\vdots' for i in range(order)]) + r'\ddots'
                + r'\end{array} \right] \]')

    columns_as_power_series = (series(g(var) * f(var)**i,x=var,n=order) for i in range(order))

    coefficients_per_column = [col.as_coefficients_dict() for col in columns_as_power_series]

    matrix_rows = []
    for j in range(order):

        def for_latex_code(col_index):
            coefficient = coefficients_per_column[col_index][var**j]
            return '' if coefficient is 0 else coefficient

        coefficients = [for_latex_code(i) for i in range(order)]
        matrix_rows.append(row_template.format(* map(str, coefficients)))

    return make_latex_code( ' \\\\ '.join(matrix_rows) )

