
pdf:
	pdflatex --shell-escape ClassicThesis.tex

bibtex-and-references:
	pdflatex --shell-escape ClassicThesis.tex
	bibtex ClassicThesis
	pdflatex --shell-escape ClassicThesis.tex
	pdflatex --shell-escape ClassicThesis.tex

complete: pascal-explanations bibtex-and-references

########################################################################## 
# recursive make subfolders with dedicated pictures

pascal-explanations:
	$(MAKE) -C Chapters/mod-p-characterization/pascal/
