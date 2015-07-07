
from sage.all import *

def diophantine_solver(a, b, c = None):
   
    if b > a or not a or not b: return []
    
    a = Integer(a)
    b = Integer(b)

    # it should be sufficient to not swap `a' with `b' if `b > a'
    if c is None: c = a*b

    quo, rem = a.quo_rem(b)
    extended_gcd_matrix = matrix(ZZ,[
       [a, 1, 0, -1],
       [b, 0, 1, quo] ]) 

    while True:
        row = [rem, extended_gcd_matrix[0, 1] -quo*extended_gcd_matrix[1, 1], 
                extended_gcd_matrix[0, 2] -quo*extended_gcd_matrix[1, 2], None]

        if not row[0]: break

        quo, rem = extended_gcd_matrix[1,0].quo_rem(row[0])
        row[-1] = quo
        extended_gcd_matrix[0, :] = extended_gcd_matrix[1,:]
        extended_gcd_matrix[1, :] = matrix([row])
        if rem == 0: break

    x_zero = c * extended_gcd_matrix[-1, 1]
    y_zero = c * extended_gcd_matrix[-1, 2]

    k = var('k')
    ab_gcd = gcd(a,b)

    x_equation = (x_zero + k*b/ab_gcd)
    y_equation = (y_zero - k*a/ab_gcd)

    x_sol = solve(x_equation >= 0, k)[0][0].rhs()
    y_sol = solve(y_equation >= 0, k)[0][0].rhs()

    x_function = x_equation.function(k)
    y_function = y_equation.function(k)

    print x_function, y_function

    solutions = [(x_function(k), y_function(k)) for k in range(ceil(x_sol), floor(y_sol) + 1)]
    print solutions

    return solutions

    #print x_equation, y_equation
    #print x_sol, y_sol

#diophantine_solver(Integer(31), Integer(21))
        
def build_matrix(n=20): 
    return matrix(n, lambda i,j: len(diophantine_solver(i,j)))

