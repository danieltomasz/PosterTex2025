# Makefile — LaTeX build + cleanup

JOBNAME ?= baps2025

.PHONY: all clean distclean
.SILENT:

all: $(JOBNAME).pdf

$(JOBNAME).pdf: $(JOBNAME).tex
	latexmk -pdf -interaction=nonstopmode -halt-on-error -file-line-error \
			-synctex=1 -use-make -jobname=$(JOBNAME) $(JOBNAME).tex

# Remove auxiliary junk but keep PDFs
clean:
	echo "Cleaning LaTeX auxiliary files…"
	latexmk -c -jobname=$(JOBNAME) >/dev/null 2>&1 || true
	find . -type f \( \
		-name '*.aux'    -o -name '*.log'    -o -name '*.out'    -o -name '*.toc'    -o \
		-name '*.lof'    -o -name '*.lot'    -o -name '*.fls'    -o -name '*.fdb_latexmk' -o \
		-name '*.synctex.gz' -o -name '*.bbl' -o -name '*.blg'   -o -name '*.bcf'    -o \
		-name '*.run.xml' -o -name '*.nav'   -o -name '*.snm'    -o -name '*.vrb'    -o \
		-name '*.xdv'    -o -name '*.pdfsync' -o -name '*.thm'   -o -name '*.glg'    -o \
		-name '*.glo'    -o -name '*.gls'    -o -name '*.ist'    -o -name '*.acn'    -o \
		-name '*.acr'    -o -name '*.alg'    -o -name '*.idx'    -o -name '*.ilg'    -o \
		-name '*.ind'    -o -name '*.pyg'    -o -name '*.maf'    -o -name '*.mtc'    -o \
		-name '*.mtc*'   -o -name '*.auxlock' -o -name '.auxlock' \
	\) -print -delete
	rm -rf _minted-* *-converted-to.pdf

# Also remove generated PDFs and DVI/PS
distclean: clean
	echo "Removing final outputs…"
	latexmk -C -jobname=$(JOBNAME) >/dev/null 2>&1 || true
	rm -f $(JOBNAME).pdf $(JOBNAME).dvi $(JOBNAME).ps