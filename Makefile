# TeX-ing Options
AUX_DIRECTORY := aux/
LATEX_OPTIONS := -interaction=nonstopmode -file-line-error -auxdir=$(AUX_DIRECTORY)
LATEX_ENGINE := lua
LATEX_COMMAND := latexmk -pdf$(LATEX_ENGINE) $(LATEX_OPTIONS)


# Handout Options
HANDOUT_WORK_DIR := handouts-work
HANDOUT_MARGINS := 10


# Automatically detect files to build/build from
SLIDES_FILES:=$(wildcard **/slides.tex)
SLIDES_PDFS:=$(patsubst %.tex,%.pdf,$(SLIDES_FILES))
HANDOUTS_PDFS:=$(patsubst %/slides.tex,%/handout.pdf,$(SLIDES_FILES))
SPEAKERS_PDFS:=$(patsubst %/slides.tex,%/speakers-notes.pdf,$(SLIDES_FILES))

NOTES_FILES:=$(wildcard **/notes.tex)
NOTES_PDFS:=$(patsubst %.tex,%.pdf,$(NOTES_FILES))


# Top-level targets

.PHONY: all
all: slides handouts speakers-notes notes

.PHONY: print-info
print-info:
	@echo TeXing Options:
	@echo - LaTeX Engine: $(LATEX_ENGINE)
	@echo - Auxilliary Directory: $(AUX_DIRECTORY)
	@echo - LaTeX Options: $(LATEX_OPTIONS)
	@echo - LaTeX Command: \"$(LATEX_COMMAND)\"
	@echo
	@echo Handout Options:
	@echo - Handout Work Directory: $(HANDOUT_WORK_DIR)
	@echo - Handout Margins \(bp\): \"$(HANDOUT_MARGINS)\"
	@echo
	@echo Target Files:
	@echo - Slides: $(SLIDES_PDFS)
	@echo - Handouts: $(HANDOUTS_PDFS)
	@echo - Speakers Notes: $(SPEAKERS_PDFS)
	@echo - Notes: $(NOTES_PDFS)
	@echo
	@echo Available Targets:
	@echo - all: Build slides, notes, handouts and speaker\'s notes
	@echo - print-info: Show this message
	@echo - zip: Build zip files containing artifacts
	@echo - clean: Clean all artifacts
	@echo - slides: Build slide decks
	@echo - notes: Build written notes
	@echo - handouts: Build handouts
	@echo - speakers-notes: Build speaker\'s notes \(handout-style PDFs without handout mode set\)


# Build a Zip File

.PHONY: zip
zip: notes.zip all.zip

notes.zip: $(HANDOUTS_PDFS) $(NOTES_PDFS)
	zip -ur $@ $^

all.zip: $(SLIDES_PDFS) $(HANDOUTS_PDFS) $(SPEAKERS_PDFS) $(NOTES_PDFS)
	zip -ur $@ $^


# Clean Up

.PHONY: clean
clean:
	$(RM) -rf $(AUX_DIRECTORY)
	$(RM) notes.zip all.zip
	$(RM) -r $(dir $(wildcard **/handout/*))
	$(RM) -r $(dir $(wildcard **/speakers-notes/*))
	$(RM) -r $(wildcard **/*.synctex.gz)
	$(RM) $(SLIDES_PDFS)
	$(RM) $(HANDOUTS_PDFS)
	$(RM) $(SPEAKERS_PDFS)
	$(RM) $(NOTES_PDFS)


# Build Slides

.PHONY: slides
slides: $(SLIDES_PDFS)

%/slides.pdf: %/slides.tex
	$(LATEX_COMMAND) -outdir=$(@D) $<


# Build Notes

.PHONY: notes
notes: $(NOTES_PDFS)

%/notes.pdf: %/notes.tex
	$(LATEX_COMMAND) -outdir=$(@D) $<



# Build Handouts

.PHONY: handouts
handouts: $(HANDOUTS_PDFS)

%/handout.pdf: %/handout/cropped.pdf
	pdfjam --nup 1x2 $< --letterpaper --landscape --outfile $@

%/handout/cropped.pdf: %/handout/handout.pdf
	pdfcrop --margins $(HANDOUT_MARGINS) $< $@

%/handout/handout.pdf: %/slides.tex
	mkdir -p $(@D)
	sed -e 's/\\documentclass\[/\\documentclass[handout,notes,/g' -e 's/\\documentclass{/\\documentclass[handout,notes]{/g' $< > $(basename $@).ltx
	$(LATEX_COMMAND) -outdir=$(@D) $(basename $@).ltx


# Build Speaker's Notes

.PHONY: speakers-notes
speakers-notes: $(SPEAKERS_PDFS)

%/speakers-notes.pdf: %/speakers-notes/cropped.pdf
	pdfjam --nup 1x2 $< --letterpaper --landscape --outfile $@

%/speakers-notes/cropped.pdf: %/speakers-notes/speakers-notes.pdf
	pdfcrop --margins $(HANDOUT_MARGINS) $< $@

%/speakers-notes/speakers-notes.pdf: %/slides.tex
	mkdir -p $(@D)
	sed -e 's/\\documentclass\[/\\documentclass[notes,/g' -e 's/\\documentclass{/\\documentclass[notes]{/g' $< > $(basename $@).ltx
	$(LATEX_COMMAND) -outdir=$(@D) $(basename $@).ltx

