TIKZFIGS += tikzfigures/figure.apng
tikzfigures/figure.apng : tikzfigures/figure.pdf tikzfigures/custom.makefile
	magick convert -delay $(ANIMATION_DELAY) -loop 0 -density $(PNG_DENSITY) $< "apng:$@"
