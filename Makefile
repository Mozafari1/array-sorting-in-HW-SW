PANDOC_FLAGS= \
	--template=template.latex \
	--toc \
	--toc-depth 2 \
	--number-sections \
	--pdf-engine=xelatex \
	--standalone \
	--listings \
	--top-level-division=chapter \
	--metadata-file=metadata.yaml \
	--filter pandoc-plot \
	--filter pandoc-include-code \
	--filter pandoc-crossref \
	--filter pandoc-citeproc

%.pdf: %.md metadata.yaml paper.bib
	pandoc $(PANDOC_FLAGS) $< -o $@

%.latex: %.md metadata.yaml paper.bib
	pandoc $(PANDOC_FLAGS) $< -o $@

default: paper.pdf

.PHONY: default
