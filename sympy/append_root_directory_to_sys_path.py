
# the following is an attempt to handle the Sage script `RiordanGroup' as a 
# python module but it can be the case, since that file isn't a python module really.
import sys

entry_riordan_path = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.append(entry_riordan_path)

# the following is only for debugging
#print sys.path
