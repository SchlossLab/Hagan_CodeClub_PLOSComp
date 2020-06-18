################################################################################
#
# Render the manuscript
#
################################################################################

submission/manuscript.pdf submission/manuscript.md submission/manuscript.tex : \
		submission/manuscript.Rmd\
		submission/references.bib\
		submission/plos-computational-biology.csl\
		submission/header.tex
	R -e 'library(rmarkdown); render("submission/manuscript.Rmd", clean=FALSE)'
	mv submission/manuscript.knit.md submission/manuscript.md
	rm submission/manuscript.utf8.md


submission/manuscript.docx : submission/manuscript.tex
	pandoc $< -o $@


submission/marked_up.pdf : submission/manuscript.tex
	git cat-file -p de7ac6b35ed:submission/manuscript.tex > submission/manuscript_old.tex
	latexdiff submission/manuscript_old.tex submission/manuscript.tex > submission/marked_up.tex
	pdflatex -output-directory=submission submission/marked_up.tex
	rm submission/marked_up.aux
	rm submission/marked_up.log
	rm submission/marked_up.out
	rm submission/marked_up.tex
	rm submission/manuscript_old.tex


submission/response_to_reviewers.pdf : submission/response_to_reviewers.md submission/header.tex
	pandoc -s --include-in-header=submission/header.tex -V geometry:margin=1in -o $@ $<
