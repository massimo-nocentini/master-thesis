

all:
	lualatex triangles-document.tex

diff:
	# build a difference file, comparing the current working copy
	# with the most recent one versioned on Git, overwriting differences,
	# if a such *old* different file exists.
	latexdiff-vc --git --force -r 3313f4084bac7471 triangles-document.tex
	lualatex triangles-document-diff3313f4084bac7471.tex
	lualatex triangles-document-diff3313f4084bac7471.tex
	evince triangles-document-diff3313f4084bac7471.pdf &
