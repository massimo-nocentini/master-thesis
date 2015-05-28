
from riordan_utils import *
from sage.rings.integer import Integer

class AbstractPartitioning: 

    def colours_table(self):
        return NumberedColoursTable()

class IsPrimePartitioning(AbstractPartitioning):

    def partition(self, negatives_handling_choice, element):
        return negatives_handling_choice.dispatch_on(self, element)

    def dispatched_from_IgnoreNegativesChoice(self, choice, element):
        return 1 if element.is_prime() else 0

    def dispatched_from_HandleNegativesChoice(self, choice, element):
        raise Exception("No prime can be negative")

    def str_for(self, filename=False, summary=False):

        if filename: template = r"is-prime-partitioning"
        elif summary: template = r"is prime partitioning"
        else: template = 'partitioning'

        return template


class RemainderClassesPartitioning(AbstractPartitioning): 

    def __init__(self, modulo):
        self.modulo = modulo

    def partition(self, negatives_handling_choice, element):
        return negatives_handling_choice.dispatch_on(self, element)

    def dispatched_from_IgnoreNegativesChoice(self, choice, element):
        return element.mod(self.modulo)

    def dispatched_from_HandleNegativesChoice(self, choice, element):
        return element.sign(), element.mod(self.modulo)

    def str_for(self, filename=False, summary=False):

        if filename: template = r"{partitioning}{modulo}-partitioning"
        elif summary: template = r"{partitioning}{modulo} partitioning"
        else: template = 'partitioning'

        return template.format(partitioning="mod", modulo=str(self.modulo))

class MultiplesOfPrimePartitioning(AbstractPartitioning): 

    def __init__(self, prime):
#        if not Integer(prime).is_prime():
#            raise ValueError("It is mandatory that the required argument to be a prime.")
              
        self.prime = prime

    def partition(self, negatives_handling_choice, element):
        return negatives_handling_choice.dispatch_on(self, element)

    def dispatched_from_IgnoreNegativesChoice(self, choice, element):
        return self.prime.divides(element)

    def dispatched_from_HandleNegativesChoice(self, choice, element):
        return element.sign(), self.prime.divides(element)

    def str_for(self, filename=False, summary=False):

        if filename: template = r"multiples-of-{modulo}-partitioning"
        elif summary: template = r"multiples of {modulo} partitioning"
        else: template = 'partitioning'

        return template.format(modulo=str(self.prime))

class PowersOfPrimePartitioning(AbstractPartitioning): 

    def __init__(self, prime):
        self.prime = prime

    def partition(self, negatives_handling_choice, element):
        return negatives_handling_choice.dispatch_on(self, element)

    def dispatched_from_IgnoreNegativesChoice(self, choice, element):
        return element.is_power_of(self.prime)

    def dispatched_from_HandleNegativesChoice(self, choice, element):
        raise Exception('No negative number can be a power of a prime, there'' always -1 in its factorization')


