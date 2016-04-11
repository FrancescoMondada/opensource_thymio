## Makefile to copmile .tex files.

## targets and dependencies
# by default all .tex will be converted into .pdf:
targets=$(subst .tex,.pdf,$(wildcard *.tex))
#svgfigs=$(wildcard figures/*.svg)
#genfigs=$(svgfigs:figures/%.svg=generated-figures/%.pdf)
deps=$(wildcard *.sty) $(wildcard *.inc) $(wildcard figures/*.pdf) $(wildcard figures/*.jpg) $(wildcard figures/*.png) $(genfigs) Makefile 
# Alternatively for one document split in several .tex:
#targets=main.pdf
#deps=$(wildcard images/*.pdf) $(wildcard images/*.jpg) $(wildcard images/*.png) Makefile $(wildcard *.tex)
##

## list of bibtex files
bib=$(wildcard *.bib)
##

## You should not have to touch anything below.

# default: all
all: $(targets) 

%.pdf: %.tex $(bib) $(deps) | build
	cd build && TEXINPUTS=..:${TEXINPUTS} BSTINPUTS=..:${BSTINPUTS} pdflatex ../$<
ifneq ($(bib),)
	cd build && BIBINPUTS=..:${BIBINPUTS} BSTINPUTS=..:${BSTINPUTS} bibtex $*
	cd build && TEXINPUTS=..:${TEXINPUTS} BSTINPUTS=..:${BSTINPUTS} pdflatex ../$<
endif
	cd build && TEXINPUTS=..:${TEXINPUTS} BSTINPUTS=..:${BSTINPUTS} pdflatex ../$<
	mv build/$@ .

build:
	mkdir -p build
	
generated-figures:
	mkdir -p generated-figures
	
# generated-figures/%.pdf: figures/%.svg | generated-figures
# 	inkscape --export-area-page --export-pdf=$@ -f=$<

debug:
	@echo $(targets)

clean: buildclean

buildclean:
	rm -rf build *~ figures/*~ generated-figures

distclean: clean
	rm -f $(targets)

.PHONY: all clean buildclean distclean debug generated-figures

