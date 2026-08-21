# Course Notes Template

This template repository provides a reusable structure for generating (mostly) compliant, tagged slides using [`ltx-talk`](https://ctan.org/pkg/ltx-talk) and the [`spectrum`](https://ctan.org/pkg/beamertheme-spectrum) theme.
Currently, it is design around a) my courses, and b) DSU branding, but this is (reasonably) easily changed.

## Build Instructions

Normally, to build a particular deck, you would run `make name/slides.pdf` from the project root.

### Description of Targets

### AucTeX Users

Add the following lines to your Emacs configuration, to allow building using the project make file.

```elisp
("Makefile Build" "make %R%o" TeX-run-TeX-project-root nil t :help "Build using project Makefile")
```

## Title Images

To set a course-wide title image, set the `titlegraphic` option for `talkthemespectrum` in `texmf/course.sty`.
This image should be 7" x 3" (to fit correctly in the default 16:9 slides).

## Branding

See the `themecolor` and `background-color` options in `texmf/course.sty`
