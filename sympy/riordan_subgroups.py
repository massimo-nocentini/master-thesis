
class VanillaDHfunctionsSubgroup:

    def __init__(self, d, h, variable):
        self.d, self.h, self.variable = d, h, variable

    def dispatch_on(self, recipient):
        return recipient.dispatched_from_VanillaDHfunctionsSubgroup(self)
        
