
compiler = pdflatex

all:
	$(compiler) --shell-escape modular-article.tex

complete:
	$(compiler) --shell-escape modular-article.tex
	bibtex modular-article
	$(compiler) --shell-escape modular-article.tex
	$(compiler) --shell-escape modular-article.tex
