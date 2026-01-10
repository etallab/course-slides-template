# TeX-ing Options
LATEX_OPTIONS := -interaction=nonstopmode -file-line-error
LATEX_ENGINE :=
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
BOOKLETS_PDFS:=$(patsubst %/notes.pdf,%/booklet.pdf,$(NOTES_PDFS))
RESOURCES_ZIPS:=$(patsubst %/resources/,%/resources.zip,$(wildcard **/resources/))
TIKZ_FIGURES:=$(wildcard tikzfigures/*.tex)
TIKZ_PDFS:=$(patsubst %.tex,%.pdf,$(TIKZ_FIGURES))
TIKZ_PNGS:=$(patsubst %.tex,%.png,$(TIKZFIGURES))

# Named files
NAMED_SLIDES:=$(patsubst %/slides.pdf,slides/%.pdf,$(SLIDES_PDFS))
NAMED_HANDOUTS:=$(patsubst %/handout.pdf,handouts/%.pdf,$(HANDOUTS_PDFS))
NAMED_SPEAKERS:=$(patsubst %/speakers-notes.pdf,speakers-notes/%.pdf,$(SPEAKERS_PDFS))
NAMED_NOTES:=$(patsubst %/notes.pdf,notes/%.pdf,$(NOTES_PDFS))
NAMED_BOOKLETS:=$(patsubst %/booklet.pdf,booklets/%.pdf,$(BOOKLETS_PDFS))
NAMED_RESOURCES:=$(patsubst %/resources.zip,resources/%.zip,$(RESOURCES_ZIPS))


# Top-level targets

.PHONY: all
all: tikzfigs slides handouts speakers-notes notes booklets resources named

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
	@echo - Booklets: $(BOOKLETS_PDFS)
	@echo - Resource Zips: $(RESOURCES_ZIPS)
	@echo
	@echo Available Targets:
	@echo - all: Build standalone figures, slides, notes, handouts and speaker\'s notes
	@echo - named: Build slides, notes, handouts and speaker\'s notes named after their directories
	@echo - print-info: Show this message
	@echo - zip: Build zip files containing artifacts
	@echo - clean: Clean all artifacts \(clean-name\)
	@echo - slides: Build slide decks \(named-slides\)
	@echo - clean-slides: Clean slide-related artifacts \(will clean aux directory\)
	@echo - notes: Build written notes \(named-notes\)
	@echo - clean-notes: Clean notes-related artifacts \(will clean aux directory\)
	@echo - booklets: Build Notes Booklets \(named-booklets\)
	@echo - clean-booklets: Clean booklets-related artifacts
	@echo - handouts: Build handouts \(named-handouts\)
	@echo - clean-handouts: Clean handout-related artifacts \(will clean aux directory\)
	@echo - speakers-notes: Build speaker\'s notes \(handout-style PDFs without handout mode set\) \(named-speakers-notes\)
	@echo - clean-speakers-notes: Clean speakers-notes-related artifacts \(will clean aux directory\)
	@echo - resources: Generate resources.zip files for
	@echo - clean-resources: Clean resources.zip related artifacts.
	@echo - tikzfigs: Build standalone figures
	@echo - clean-tikzfigs: Clean TikZ figures


# Named File Targets

.PHONY: named
named: named-slides named-handouts named-speakers-notes named-notes named-booklets named-resources

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

.PHONY: named-booklets
named-booklets: $(NAMED_BOOKLETS)
booklets/%.pdf: %/booklet.pdf
	@mkdir -p booklets
	cp $^ $@

.PHONY: named-resources
named-resources: $(NAMED_RESOURCES)
resources/%.zip: %/resources.zip
	@mkdir -p resources
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
	$(RM) $(BOOKLETS_PDFS)
	$(RM) $(RESOURCES_ZIPS)
	$(RM) -r notes speakers-notes handouts slides booklets resources

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

.PHONY: clean-booklets
clean-booklets:
	$(RM) $(BOOKLETS_PDFS)

.PHONY: clean-resources
	$(RM) $(RESOURCES_ZIPS)

.PHONY: clean-named
clean-named:
	$(RM) -r notes speakers-notes handouts slides booklets resources


# Build Forcing
.PHONY: FORCE_LATEX


# Build Tikz Figures
.PHONY: tikzfigs
tikzfigs: $(TIKZ_PDFS) $(TIKZ_PNGS)

tikzfigures/%.pdf: tikzfigures/%.tex FORCE_LATEX
	$(LATEX_COMMAND) $<

tikzfigures/%.png: tikzfigures/%.pdf
	magick $< $@

.PHONY: clean-tikzfigs
clean-tikzfigs:
	$(RM) $(TIKZ_PDFS) $(TIKZ_PNGS)



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


# Build Booklets

.PHONY: booklets
booklets: $(BOOKLETS_PDFS)

%/booklet.pdf: %/notes.pdf
	pdfjam -o $@ --papersize '{17in,11in}' --booklet true $< '-'


# Build Resource Zips
.PHONY: FORCE_ZIP

.PHONY: resources
resources: $(RESOURCE_ZIPS)

%/resources.zip: FORCE_ZIP
	7z u -xr@texmf/zip-excludes.txt $@ $(basename $@)
	7z l -ba -slt $@ | grep '^Path =' | cut -d' ' -f 3- > original-names.txt
	cut -d/ -f 1,3- original-names.txt > new-names.txt
	paste -d'\n' original-names.txt new-names.txt > renames.txt
	7z rn $@ -ssc @renames.txt
	$(RM) original-names.txt new-names.txt renames.txt


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
