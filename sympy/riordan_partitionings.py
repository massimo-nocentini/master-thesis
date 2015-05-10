
from riordan_utils import *

class AbstractPartitioning: 

    def colours_table(self):
        return NumberedColoursTable()

class IsPrimePartitioning(AbstractPartitioning):

    def partition(self, negatives_handling_choice, element):
        return negatives_handling_choice.dispatch_on(self, element)

    def dispatched_from_IgnoreNegativesChoice(self, choice, element):
        return element.is_prime()

    def dispatched_from_HandleNegativesChoice(self, choice, element):
        raise Exception("No prime can be negative")


class RemainderClassesPartitioning(AbstractPartitioning): 

    def __init__(self, modulo):
        self.modulo = modulo

    def partition(self, negatives_handling_choice, element):
        return negatives_handling_choice.dispatch_on(self, element)

    def dispatched_from_IgnoreNegativesChoice(self, choice, element):
        return element.mod(self.modulo)

    def dispatched_from_HandleNegativesChoice(self, choice, element):
        return element.sign(), element.mod(classes)

    def str_for(self, filename=False, summary=False):

        if filename: template = r"{partitioning}{modulo}-partitioning"
        elif summary: template = r"{partitioning}{modulo} partitioning"
        else: template = 'partitioning'

        return template.format(partitioning="mod", modulo=str(self.modulo))

class MultiplesOfPrimePartitioning(AbstractPartitioning): 

    def __init__(self, prime):
        self.prime = prime

    def partition(self, negatives_handling_choice, element):
        return negatives_handling_choice.dispatch_on(self, element)

    def dispatched_from_IgnoreNegativesChoice(self, choice, element):
        return self.prime.divides(element)

    def dispatched_from_HandleNegativesChoice(self, choice, element):
        return element.sign(), self.prime.divides(element)

class PowersOfPrimePartitioning(AbstractPartitioning): 

    def __init__(self, prime):
        self.prime = prime

    def partition(self, negatives_handling_choice, element):
        return negatives_handling_choice.dispatch_on(self, element)

    def dispatched_from_IgnoreNegativesChoice(self, choice, element):
        return element.is_power_of(self.prime)

    def dispatched_from_HandleNegativesChoice(self, choice, element):
        raise Exception('No negative number can be a power of a prime, there'' always -1 in its factorization')


