
from sage.rings.integer import Integer
from riordan_utils import *
from riordan_group import *
from riordan_visiting import *

class AbstractTriangleShape:

    def format_tikz_node_template_string(self, **kwds):
        return self.build_tikz_node_template_string().format(**kwds)

    def build_tikz_node_template_string(self):
        return (r'\node[box={colour}] (p-{row}-{col}) at ('
            + self.build_column_offset_template_substring() + r',-{row}) {{}};')

    def build_column_offset_template_substring(self): pass


class PlainTriangleShape(AbstractTriangleShape): 

    def build_column_offset_template_substring(self):
        return r'{col}'

    def __str__(self):
        return 'plain'

class CenteredTriangleShape(AbstractTriangleShape):

    def build_column_offset_template_substring(self):
        return r'-{row}/2+{col}'

    def __str__(self):
        return 'centered'

class NegativesStrFormatter:

    def str_for(self, negatives_handling_choice):
        return negatives_handling_choice.dispatch_on(self)
        
    def dispatched_from_IgnoreNegativesChoice(self, choice):
        return "ignore-negatives"

    def dispatched_from_HandleNegativesChoice(self, choice):
        return "handle-negatives"

class TriangleColouring:

    def __init__(self, colouring_scheme, centered=True, handle_negatives=False):
        self.colouring_scheme = colouring_scheme
        self.shape = CenteredTriangleShape() if centered else PlainTriangleShape()
        self.negatives_handling_choice = (HandleNegativesChoice() if handle_negatives 
            else IgnoreNegativesChoice())
        
    def str_for(self, filename=False, summary=False):

        if filename: template = r"{colouring_scheme}-{shape}-{negatives}-colouring"
        elif summary: template = r"{colouring_scheme}, {negatives}, {shape} colouring"
        else: template = 'colouring'

        return template.format(
            colouring_scheme=self.colouring_scheme, shape=self.shape,
            negatives=NegativesStrFormatter().str_for(self.negatives_handling_choice))


    def colouring(self, partitioning, 
            on_tikz_node_generated=lambda node: node,
            casting_coeff=lambda coeff: Integer(coeff)):

        def handler(row_index, col_index, coeff): 

            eqclass_witness = partitioning.partition(
                self.negatives_handling_choice, casting_coeff(coeff))

            colour_code = partitioning.colours_table().colour_of(
                self.negatives_handling_choice, eqclass_witness)

            tikz_node = on_tikz_node_generated(
                self.shape.format_tikz_node_template_string(
                    row=row_index, col=col_index, colour=colour_code))

            return tikz_node

        return handler, None 


    def __call__(self, d=None, h=None, array=None,
                            order=127, 
                            explicit_matrix=None,
                            partitioning=None):

        colouring_handlers = self.colouring(partitioning)

        if d and h:
            # First ensures that both `d' both `h' use the same *indeterminate*
            assert d.args() == h.args() and len(d.args()) == 1

            Riordan_array = RiordanArray(
                SubgroupCharacterization(
                    VanillaDHfunctionsSubgroup(d, h, d.args()[0]))) 
        elif explicit_matrix:   
            Riordan_array, order = explicit_matrix, explicit_matrix.dimensions()[0]  
        elif array:             Riordan_array = array
        else:                   raise Exception("No array to work with")

        pascal_matrix, tikz_coloured_nodes, _ = Riordan_matrix_latex_code ( 
            array=Riordan_array, order=order, handlers_tuple=colouring_handlers)

        return pascal_matrix, tikz_coloured_nodes

