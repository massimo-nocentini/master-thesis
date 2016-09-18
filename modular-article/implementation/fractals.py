

import matplotlib.pyplot as plt
import matplotlib.patches as patches

import math

from sympy import *

def colour_matrix(matrix, colors={0:'blue', 1:'orange'}, strait=False, filename=None):

    fig = plt.figure()
    usual_layout = fig.add_subplot(111, aspect='equal')

    radius = .55
    rows = matrix.rows
    coordinates = {(r,c):(-r//2 + c, -r) if strait else (-r/2 + c, -r) # // vs /
                    for r in range(rows) for c in range(r+1)}


    for (mr,mc), co in coordinates.items():
        c, r = co
        color = colors[matrix[mr, mc]]
        circle = patches.Circle(co, radius, facecolor=color, alpha=1, fill=True) 
                                #joinstyle='miter',fill=False,hatch='*')
        #if c is -3: circle.set_visible(False)
        usual_layout.add_patch(circle)

    usual_layout.set_xlim(-((rows+2*radius)/2),(rows+2*radius)/2)
    usual_layout.set_ylim(-rows,1)
    usual_layout.set_autoscale_on(True)
    usual_layout.set_axis_off()
    
    if filename: fig.savefig(filename, dpi=600)#, bbox_inches='tight')

    return fig
    

def triangle_copy(source, target, point):
    pr, pc = point
    for r in range(source.rows):
        for c in range(r+1):
            target[pr + r, pc + c] = source[r,c]
            
def mirror_triangle(principal_cluster, point, mirror_segment):
    r, c = point
    for m in mirror_segment:
        for s in range(1, m+1):
            principal_cluster[r+(m-s), c-s] = principal_cluster[r+m, c+s]
            
def fill_odd_coeffs(principal_cluster, row, cols):
    principal_cluster[row, :cols] = ones(1, cols)    

def build_modular_catalan(principal_cluster, modulo=Integer(2)):
    d = Dummy()
    eq = Eq(modulo**d, principal_cluster.rows)
    sols = solve(eq, d)
    assert len(sols) is 1
    alpha = sols[0]
    
    end_of_principal_cluster = modulo**alpha
    next_alpha = modulo**(alpha + 1)
    next_pc = zeros(next_alpha, next_alpha)

    triangle_copy(principal_cluster, next_pc, (0,0))
    triangle_copy(principal_cluster, next_pc, 
                    (end_of_principal_cluster,end_of_principal_cluster))
    mirror_triangle(next_pc, (end_of_principal_cluster, end_of_principal_cluster-1), 
                    range(end_of_principal_cluster-1))
    fill_odd_coeffs(next_pc, next_alpha-1, end_of_principal_cluster)

    return next_pc
