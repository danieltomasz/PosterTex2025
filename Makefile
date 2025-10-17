# Makefile — LaTeX build + cleanup

JOBNAME ?= baps2025_improved
LATEXMK := $(shell command -v latexmk 2>/dev/null || echo "$(HOME)/Library/TinyTeX/bin/universal-darwin/latexmk")

.PHONY: all clean distclean
.SILENT:

all: $(JOBNAME).pdf clean

$(JOBNAME).pdf: $(JOBNAME).tex
	latexmk -pdf -interaction=nonstopmode -halt-on-error -file-line-error \
			-synctex=1 -use-make -jobname=$(JOBNAME) $(JOBNAME).tex

# Remove auxiliary junk but keep PDFs
clean:
	echo "Cleaning LaTeX auxiliary files…"
	LATEXMK -c -jobname=$(JOBNAME) >/dev/null 2>&1 || true
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
	LATEXMK -C -jobname=$(JOBNAME) >/dev/null 2>&1 || true
	rm -f $(JOBNAME).pdf $(JOBNAME).dvi $(JOBNAME).ps

# Install required LaTeX packages
install-deps:
	echo "Installing required LaTeX packages..."
	tlmgr install tex-gyre
	tlmgr install import
	tlmgr install lgreek
	tlmgr install cbfonts-fd
	tlmgr install babel-greek
	tlmgr install textgreek
	tlmgr install textpos
	tlmgr install beamerposter
	tlmgr install type1cm
	tlmgr install blindtext
	tlmgr install relsize
	tlmgr install fira cbfonts
	tlmgr install ncctools
	tlmgr install mathdesign
	tlmgr install xcharter
	tlmgr install xfrac 
	echo "All packages installed successfully!"

# Generate LLM prompt from .tex files
llm-prompt:
	@echo "Generating LLM prompt from .tex files..."
	@if command -v files-to-prompt >/dev/null 2>&1; then \
		files-to-prompt . -e .tex > llm-context.txt; \
		echo "✓ Prompt saved to llm-prompt.txt"; \
		echo "  Total lines: $$(wc -l < llm-prompt.txt)"; \
		echo "  Total chars: $$(wc -c < llm-prompt.txt)"; \
	else \
		echo "✗ files-to-prompt not found. Install with:"; \
		echo "  npm install -g files-to-prompt"; \
		echo "  or use: npx files-to-prompt --include '*.tex'"; \
		exit 1; \
	fi