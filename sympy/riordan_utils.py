
from string import Template
from datetime import datetime

def write_tikz_lines_to_file(lines, filename='new_results.tex', joiner='\n'):
    
    joiner = None if isinstance(lines, str) else joiner

    with open(filename,'w') as fp:
        fp.write(joiner.join(lines) if joiner else lines)
    
    return filename

def write_tex_files(build_bash_script=None, *dictionaries):
    filenames = []
    for dictionary in dictionaries:
        for filename, content in dictionary.items():
            write_tikz_lines_to_file(content, filename)
            if build_bash_script: filenames.append(filename)

    bash_commands = ["lualatex {}".format(filename) for filename in filenames]
    write_tikz_lines_to_file(bash_commands, build_bash_script)

def substitute_from_filename(template_filename, **substitutions):

    with open(template_filename) as tf:
        content = Template(tf.read())
        return content.safe_substitute(substitutions)

def timed_execution(block):

    start_timestamp=datetime.now()
    try: results = block()
    except Exception as e: results = e

    return results, datetime.now() - start_timestamp


class AbstractNegativesChoice: 

    def dispatch_on(self, recipient): pass

class IgnoreNegativesChoice: 

    def dispatch_on(self, recipient, *args): 
        return recipient.dispatched_from_IgnoreNegativesChoice(self, *args)

class HandleNegativesChoice: 

    def dispatch_on(self, recipient, *args):
        return recipient.dispatched_from_HandleNegativesChoice(self, *args)

class NumberedColoursTable:

    def colour_of(self, negatives_handling_choice, element):
        return negatives_handling_choice.dispatch_on(self, element)

    def dispatched_from_IgnoreNegativesChoice(self, choice, witness):
        return str(witness) 

    def dispatched_from_HandleNegativesChoice(self, choice, witness):
        sign, witness_class = witness
        return str(witness_class) + ('-for-negatives' if sign < 0 else '')



