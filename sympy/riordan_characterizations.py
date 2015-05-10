
from riordan_subgroup_characterization_actions import *

class AbstractCharacterization: pass

class SequencesCharacterization(AbstractCharacterization):
    
    def __init__(self, d_zero, A_sequence, Z_sequence): pass


class MatrixCharacterization(AbstractCharacterization):

    def __init__(self, A_matrix): pass


class SubgroupCharacterization(AbstractCharacterization):

    def __init__(self, subgroup): 
        self.subgroup = subgroup

    def new(self, subgroup):
        return SubgroupCharacterization(subgroup)

    def expansion_for_Riordan_array(self, Riordan_array):
        # maybe the following message should say Subgroup characterization explicitly
        self.subgroup.dispatch_on(
            ExpansionActionUsingSubgroupCharacterization(self, Riordan_array))

    def formal_def_for_Riordan_array(self, Riordan_array):
        return self.subgroup.dispatch_on(
            FormalDefLatexCodeUsingSubgroupCharacterization(self, Riordan_array))

    def build_inverse_for_Riordan_array(self, Riordan_array, **kwds):
        return self.subgroup.dispatch_on(
            BuildInverseActionUsingSubgroupCharacterization(self, Riordan_array, **kwds))

