TIKZFIGS += tikzfigures/figure.apng
tikzfigures/figure.apng : tikzfigures/figure.pdf tikzfigures/custom.makefile
	magick convert -delay 70 -loop 0 -density 1200 $< "apng:$@"
