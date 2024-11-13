# TeX-ing Options
LATEX_OPTIONS := -interaction=nonstopmode -file-line-error
LATEX_ENGINE := lua
LATEX_COMMAND := latexmk -cd -auxdir=aux -pdf$(LATEX_ENGINE) $(LATEX_OPTIONS)


# Handout Options
HANDOUT_MARGINS := "15 20 15 20"


# Automatically detect files to build/build from
SLIDES_FILES:=$(wildcard **/slides.tex)
SLIDES_PDFS:=$(patsubst %.tex,%.pdf,$(SLIDES_FILES))
HANDOUTS_PDFS:=$(patsubst %/slides.tex,%/handout.pdf,$(SLIDES_FILES))
SPEAKERS_PDFS:=$(patsubst %/slides.tex,%/speakers-notes.pdf,$(SLIDES_FILES))
NOTES_FILES:=$(wildcard **/notes.tex)
NOTES_PDFS:=$(patsubst %.tex,%.pdf,$(NOTES_FILES))

# Named files
NAMED_SLIDES:=$(patsubst %/slides.pdf,slides/%.pdf,$(SLIDES_PDFS))
NAMED_HANDOUTS:=$(patsubst %/handout.pdf,handouts/%.pdf,$(HANDOUTS_PDFS))
NAMED_SPEAKERS:=$(patsubst %/speakers-notes.pdf,speakers-notes/%.pdf,$(SPEAKERS_PDFS))
NAMED_NOTES:=$(patsubst %/notes.pdf,notes/%.pdf,$(NOTES_PDFS))


# Top-level targets

.PHONY: all
all: slides handouts speakers-notes notes named

.PHONY: print-info
print-info:
	@echo TeXing Options:
	@echo - LaTeX Engine: $(LATEX_ENGINE)
	@echo - LaTeX Options: $(LATEX_OPTIONS)
	@echo - LaTeX Command: \"$(LATEX_COMMAND)\"
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
	@echo - named: Build slides, notes, handouts and speaker\'s notes named after their directories
	@echo - print-info: Show this message
	@echo - zip: Build zip files containing artifacts
	@echo - clean: Clean all artifacts \(clean-name\)
	@echo - slides: Build slide decks \(named-slides\)
	@echo - clean-slides: Clean slide-related artifacts \(will clean aux directory\)
	@echo - notes: Build written notes \(named-notes\)
	@echo - clean-notes: Clean notes-related artifacts \(will clean aux directory\)
	@echo - handouts: Build handouts \(named-handouts\)
	@echo - clean-handouts: Clean handout-related artifacts \(will clean aux directory\)
	@echo - speakers-notes: Build speaker\'s notes \(handout-style PDFs without handout mode set\) \(named-speakers-notes\)
	@echo - clean-speakers-notes: Clean speakers-notes-related artifacts \(will clean aux directory\)


# Named File Targets

.PHONY: named
named: named-slides named-handouts named-speakers-notes named-notes

.PHONY: named-slides
named-slides: $(NAMED_SLIDES)
slides/%.pdf: %/slides.pdf
	@mkdir -p slides
	cp $^ $@

.PHONY: named-handouts
named-handouts: $(NAMED_HANDOUTS)
handouts/%.pdf: %/handout.pdf
	@mkdir -p handouts
	cp $^ $@

.PHONY: named-speakers-notes
named-speakers-notes: $(NAMED_SPEAKERS)
speakers-notes/%.pdf: %/speakers-notes.pdf
	@mkdir -p speakers-notes
	cp $^ $@

.PHONY: named-notes
named-notes: $(NAMED_NOTES)
notes/%.pdf: %/notes.pdf
	@mkdir -p notes
	cp $^ $@



# Build a Zip File

.PHONY: zip
zip: notes.zip all.zip named.zip

notes.zip: $(HANDOUTS_PDFS) $(NOTES_PDFS)
	zip -ur $@ $^

all.zip: $(SLIDES_PDFS) $(HANDOUTS_PDFS) $(SPEAKERS_PDFS) $(NOTES_PDFS)
	zip -ur $@ $^

named.zip: $(NAMED_SLIDES) $(NAMED_HANDOUTS) $(NAMED_SPEAKERS) $(NAMED_NOTES)
	zip -ur $@ $^


# Clean Up

.PHONY: clean
clean:
	$(RM) notes.zip all.zip named.zip
	$(RM) -r $(dir $(wildcard **/aux/*))
	$(RM) -r $(wildcard **/*.synctex.gz)
	$(RM) $(SLIDES_PDFS)
	$(RM) $(HANDOUTS_PDFS)
	$(RM) $(SPEAKERS_PDFS)
	$(RM) $(NOTES_PDFS) $(wildcard **/slide-images.pdf)
	$(RM) -r notes speakers-notes handouts slides

.PHONY: clean-slides
clean-slides:
	$(RM) $(SLIDES_PDFS)
	$(RM) -r $(wildcard **/*.synctex.gz)

.PHONY: clean-handouts
clean-handouts:
	$(RM) $(HANDOUTS_PDFS)
	$(RM) -r $(wildcard **/*.synctex.gz)

.PHONY: clean-speakers-notes
clean-speakers-notes:
	$(RM) $(SPEAKERS_PDFS)
	$(RM) -r $(wildcard **/*.synctex.gz)

.PHONY: clean-notes
clean-notes:
	$(RM) $(NOTES_PDFS)
	$(RM) -r $(wildcard **/*.synctex.gz)

.PHONY: clean-named
clean-named:
	$(RM) -r notes speakers-notes handouts slides


# Build Forcing
.PHONY: FORCE_LATEX


# Build Slides

.PHONY: slides
slides: $(SLIDES_PDFS)

%/slides.pdf: %/slides.tex FORCE_LATEX
	$(LATEX_COMMAND) $<


# Build Notes

.PHONY: notes
notes: $(NOTES_PDFS)

%/notes.pdf: %/notes.tex %/slide-images.pdf FORCE_LATEX
	$(LATEX_COMMAND) $<

%/slide-images.ltx: %/slides.tex
	sed -e 's/show notes on second screen\(=left\|=right\|=bottom\|=top\)\?/hide notes/g' -e 's/\\documentclass\[/\\documentclass[handout,/g' -e 's/\\documentclass{/\\documentclass[handout]{/g' $< > $@

.PRECIOUS: %/slide-images.pdf
%/slide-images.pdf: %/slide-images.ltx
	$(LATEX_COMMAND) $<
	@$(RM) $(basename $@).synctex.gz


# Build Handouts

.PHONY: handouts
handouts: $(HANDOUTS_PDFS)

%/handout.pdf: %/cropped.pdf
	pdfjam --nup 1x2 $< --letterpaper --landscape --outfile $@

%/cropped.pdf: %/handout-temp.pdf
	pdfcrop --margins $(HANDOUT_MARGINS) $< $@

%/handout-temp.ltx: %/slides.tex
	sed -e 's/\\documentclass\[/\\documentclass[handout,notes,/g' -e 's/\\documentclass{/\\documentclass[handout,notes]{/g' $< > $@

%/handout-temp.pdf: %/handout-temp.ltx
	$(LATEX_COMMAND) $<
	@$(RM) $(basename @).synctex.gz


# Build Speaker's Notes

.PHONY: speakers-notes
speakers-notes: $(SPEAKERS_PDFS)

%/speakers-notes.pdf: %/speakers-notes-cropped.pdf
	pdfjam --nup 1x2 $< --letterpaper --landscape --outfile $@

%/speakers-notes-cropped.pdf: %/speakers-notes-temp.pdf
	pdfcrop --margins $(HANDOUT_MARGINS) $< $@

%/speakers-notes-temp.ltx: %/slides.tex
	sed -e 's/\\documentclass\[/\\documentclass[notes,/g' -e 's/\\documentclass{/\\documentclass[notes]{/g' $< > $(basename $@).ltx

%/speakers-notes-temp.pdf: %/speakers-notes-temp.ltx
	$(LATEX_COMMAND) $<
	@$(RM) $(basename @).synctex.gz
