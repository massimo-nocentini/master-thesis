
compiler = pdflatex

pdf:
	$(compiler) --shell-escape ClassicThesis.tex

bibtex-and-references:
	$(compiler) --shell-escape ClassicThesis.tex
	bibtex ClassicThesis
	$(compiler) --shell-escape ClassicThesis.tex
	$(compiler) --shell-escape ClassicThesis.tex

complete: pascal-explanations bibtex-and-references

#________________________________________________________________________________

pascal-explanations:
	# recursive make subfolders with dedicated pictures
	$(MAKE) -C Chapters/mod-p-characterization/pascal/
