
from sage.misc.latex import latex
from riordan_utils import *

def enhanced_latex(order, row_template):

    def coefficient_handler(row_index, col_index, coeff):
        return '' if coeff is 0 and col_index > row_index else str(coeff)

    def row_handler(row_index, coefficients): 
        #matrix_rows.append(row_template.format(* map(str, coefficients)))
        return row_template.format(*coefficients)

    return coefficient_handler, row_handler

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

def build_tex_files_about_colouring(
    Riordan_array, results, 
    colouring, partitioning, 
    path_prefix, matrix_cutter=lambda m: m[:10, :10]):

    # prepating dictionary for collecting results
    tex_files = {}

    # unpacking results
    array_as_expanded_matrix, tikz_nodes = results

    def characteristic_prefix_template(suffix=''):
        return r"{array_name}-{colouring_scheme}-{partitioning}{suffix}".format(
            array_name="-".join(Riordan_array.name.split(" ")),
            colouring_scheme=colouring.str_for(filename=True),
            partitioning=partitioning.str_for(filename=True),
            suffix='-' + suffix if suffix else '').lower()

    def ends_with_extension(filename, file_extension='tex'):
        return filename + (r'.' + file_extension if file_extension else '')

    def make_dict_value(**kwds): 
        # the following assert ensures that the keys
        # we need for typesetting are in the *automatically* 
        # build dictionary, collecting keywords arguments.
        assert 'content' in kwds and 'typesettable' in kwds
        return kwds

    # save tikz lines to a dedicated file
    tikz_lines_input_filename = ends_with_extension(
        characteristic_prefix_template("tikz-nodes"))
    tex_files[tikz_lines_input_filename] = make_dict_value(
        content=tikz_nodes, typesettable=False)

    # instantiate the template file in order to build the coloured triangle
    colouring_triangle_filename = characteristic_prefix_template("triangle")
    tex_files[ends_with_extension(colouring_triangle_filename)] = make_dict_value( 
        content=substitute_from_filename(
                    template_filename="../templates/coloured.tex", 
                    tikz_lines_input_filename=tikz_lines_input_filename),
        typesettable=True)

    # instantiate the template file for include figure tex generation
    include_figure_filename = characteristic_prefix_template("include-figure")

    colouring_triangle_pdf_filename = "{path_prefix}{triangle_filename}.pdf".format(
        path_prefix=path_prefix, triangle_filename=colouring_triangle_filename)
    
    caption = r'''
        {array_name} triangle, formally: 
        \begin{{displaymath}}
            {formal_def}
        \end{{displaymath}} % \newline % new line no more necessary
        {colouring}, {partitioning}'''.format(
        array_name=Riordan_array.name,
        formal_def=Riordan_array.formal_def(),
        colouring=colouring.str_for(summary=True),
        partitioning=partitioning.str_for(summary=True))

    tex_files[ends_with_extension(include_figure_filename)] = make_dict_value(
        content=substitute_from_filename(
                    template_filename="../templates/include-figure.tex", 
                    triangle_filename=colouring_triangle_pdf_filename,
                    caption=caption,
                    label=colouring_triangle_filename),
        typesettable=False)
    
    tex_files[ends_with_extension(
        characteristic_prefix_template("include-matrix"))] = make_dict_value(
            content=r'\begin{displaymath}' 
                        + latex(matrix_cutter(array_as_expanded_matrix))
                        + r'\end{displaymath}',
        typesettable=False)

    return tex_files


