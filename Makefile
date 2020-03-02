# utility function to print various variables. For example, running the
# following at the command line:
#
#	make print-BAM
#
# will generate:
#	BAM=data/raw_june/V1V3_0001.bam data/raw_june/V1V3_0002.bam ...
print-%:
	@echo '$*=$($*)'



################################################################################
#
# Render the manuscript
#
################################################################################

# figures/mothur_citations.pdf : code/plot_citations.R data/citations.tsv
# 	Rscript code/plot_citations.R
#
# submission/figure_1.ps : figures/mothur_citations.pdf
# 	pdf2ps $^ $@
#
# submission/figure_1.png : submission/figure_1.ps
# 	convert -density 300 $^ $@
#
# submission/figure_2.png : figures/homepage.png
# 	cp $^ $@
#
# submission/figure_3.png : figures/mothur_welcome.png
# 	cp $^ $@

submission/manuscript.pdf submission/manuscript.md submission/manuscript.tex : \
		submission/manuscript.Rmd\
		submission/references.bib\
		submission/plos-computational-biology.csl\
		submission/header.tex
	R -e 'library(rmarkdown); render("submission/manuscript.Rmd", clean=FALSE)'
	mv submission/manuscript.knit.md submission/manuscript.md
	rm submission/manuscript.utf8.md submission/manuscript.log


submission/manuscript.docx : submission/manuscript.tex
	pandoc $< -o $@

#module load perl-modules latexdiff/1.2.0
# submission/marked_up.pdf : submission/manuscript.tex
# 	git cat-file -p b36048114f6:submission/manuscript.tex > submission/manuscript_old.tex
# 	latexdiff submission/manuscript_old.tex submission/manuscript.tex > submission/marked_up.tex
# 	pdflatex -output-directory=submission submission/marked_up.tex
# 	rm submission/marked_up.aux
# 	rm submission/marked_up.log
# 	rm submission/marked_up.out
# 	rm submission/marked_up.tex
# 	rm submission/manuscript_old.tex
#
# submission/response_to_reviewers.pdf : submission/response_to_reviewers.md submission/header.tex
# 	pandoc -s --include-in-header=submission/header.tex -V geometry:margin=1in -o $@ $<
