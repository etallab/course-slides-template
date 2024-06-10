# TeX-ing Options
AUX_DIRECTORY := aux/
LATEX_OPTIONS := -interaction=nonstopmode -file-line-error -auxdir=$(AUX_DIRECTORY)
LATEX_ENGINE := lua
LATEX_COMMAND := latexmk -pdf$(LATEX_ENGINE) $(LATEX_OPTIONS)


# Handout Options
HANDOUT_WORK_DIR := handouts-work
HANDOUT_MARGINS := 10


# Automatically detect files to build/build from
TEX_FILES:=$(wildcard ??-*.tex)
COMPILED_PRESENTATIONS:=$(patsubst %.tex,presentations/%.pdf,$(TEX_FILES))
COMPILED_HANDOUTS:=$(patsubst %.tex,handouts/%.pdf,$(TEX_FILES))


# Basic and debugging targets
.PHONY: all
all: presentations handouts


.PHONY: print-info
print-info:
	@echo Build Targets:
	@echo Detected TeX files: $(TEX_FILES)
	@echo Presentations to be built: $(COMPILED_PRESENTATIONS)
	@echo Handouts to be built: $(COMPILED_HANDOUTS)
	@echo
	@echo TeXing Options:
	@echo LaTeX Engine: $(LATEX_ENGINE)
	@echo Auxilliary Directory: $(AUX_DIRECTORY)
	@echo LaTeX Options: $(LATEX_OPTIONS)
	@echo LaTeX Command: \"$(LATEX_COMMAND)\"
	@echo
	@echo Handout Options:
	@echo Handout Work Directory: $(HANDOUT_WORK_DIR)
	@echo Handout Margins (bp): \"$(HANDOUT_MARGINS)\"


# Build Presentations

.PHONY: presentations
presentations: $(COMPILED_PRESENTATIONS)

presentations/%.pdf: %.tex
	mkdir -p $(AUX_DIRECTORY)
	mkdir -p presentations/
	$(LATEX_COMMAND) -outdir=presentations/ $<


# Build Handouts

.PHONY: handouts
handouts: $(COMPILED_HANDOUTS)

$(HANDOUT_WORK_DIR)/%-handout.pdf: %.tex
	mkdir -p $(AUX_DIRECTORY)
	mkdir -p $(HANDOUT_WORK_DIR)
	sed -e 's/\\documentclass\[/\\documentclass[handout,notes,/g' -e 's/\\documentclass{/\\documentclass[handount,notes]{/g' $< > $(HANDOUT_WORK_DIR)/$(basename $<)-handout.tex
	$(LATEX_COMMAND) -outdir=$(HANDOUT_WORK_DIR)/ $(HANDOUT_WORK_DIR)/$(basename $<)-handout.tex

$(HANDOUT_WORK_DIR)/%-cropped.pdf: $(HANDOUT_WORK_DIR)/%-handout.pdf
	pdfcrop --margins $(HANDOUT_MARGINS) $< $@

handouts/%.pdf: $(HANDOUT_WORK_DIR)/%-cropped.pdf
	mkdir -p handouts/
	pdfjam --nup 1x2 $< --letterpaper --landscape --outfile $@


# Clean-up
.PHONY: clean
clean:
	$(RM) -rf $(AUX_DIRECTORY)
	$(RM) -rf $(HANDOUT_WORK_DIR)

.PHONY: clean-all
clean-all: clean
	$(RM) -rf presentations/
	$(RM) -rf handounts/
