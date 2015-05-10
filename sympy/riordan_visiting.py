
from sage.matrix.constructor import *

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
        except Exception as e: 
            print e
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


def strip_array_as_generator(array, filter_block=lambda row, col: col <= row):
    """ Visit the given array, tringularly by default, top->bottom, left->right. """
    return (array[row, col] for row in range(self.order)
                            for col in range(self.order) if filter_block(row, col)) 
