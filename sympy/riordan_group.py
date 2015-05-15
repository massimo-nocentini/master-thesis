

class RiordanArray:

    def __init__(
        self, characterization, name=None, math_name=None,
        additional_caption_text=None, inverse_of=None):

        self.characterization = characterization
        self.expansion = None
        self.order = None
        self.name = name
        self.math_name = math_name
        self.additional_caption_text = additional_caption_text

        if inverse_of:
#           we add `inverse' since in a group every element in it has
#           an inverse one, it always exists.
            self.inverse_of = inverse_of 
            self.is_build_from_invertion = True
        else:
            self.inverse_of = None
            self.is_build_from_invertion = False


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


    def formal_def(self):
        return self.characterization.formal_def_for_Riordan_array(self)


    def inverse(self, rebuild=False, **kwds):

        if self.inverse_of is None or rebuild is True:
            self.characterization.build_inverse_for_Riordan_array(self, **kwds)

        return self.inverse_of


    def __str__(self):
        return self.formal_def()

#________________________________________________________________________

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


