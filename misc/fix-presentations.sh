#!/bin/sh

sed -i 's/\\documentclass\[aspectratio=169\]{beamer}/\\DocumentMetadata{\n  tagging = on,\n  lang = en,\n  pdfstandard = ua-2,\n  tagging-setup = {math\/setup={mathml-AF,mathml-SE}}}\n\\documentclass{ltx-talk}/' $@


perl -0777 -i.original -pe 's/\\usetheme\[sectionpage=none,progressbar=foot,block=fill,standoutnumbering=hide\]{moloch}\n\\setbeamertemplate{page number in head\/foot}\[totalframenumber\]\n\n?//' $@

perl -0777 -i.original -pe 's/\\newcommand{\\timegoal}\[1\]{\\note{\\textbf{Goal Time: #1}\\\\\\vspace{0.75em}}}\n\n//' $@

perl -0777 -i.original -pe 's/\\usepackage{pgfpages}\n\\setbeameroption{show notes on second screen}\n\n//' $@
perl -0777 -i.original -pe 's/\\author{Samuel W\. Flint}\n\\date{\\term}\n//' $@

perl -0777 -i.original -pe 's/\\begin{frame}\n  \\titlepage\n\\end{frame}/\\maketitle/' $@
perl -0777 -i.original -pe 's/\\usepakage\[overridenote\]{pdfpc}\n//' $@

sed -E -i 's/\\begin\{lstlisting\}\[language=(.*)\]/\\begin\{minted\}\{\1\}/' $@
sed -i 's/\\end{lstlisting}/\\end{minted}/' $@
perl -0777 -i.original -pe 's/\\usepackage{listings}\n//' $@
sed -i 's/\\begin{frame}\[fragile\]/\\begin{frame*}/' $@

sed -i 's/\[etbb\]/[plextt,etbb]/' $@
sed -i 's/,amssymb//' $@
sed -i 's/\[aspect-?ratio=169\]//' $@
sed -E -i 's/\\setbeamer(covered|color|font)/% \\setbeamer\1/' $@
sed -i 's/againframe/reuseframe/' $@
sed -i 's/label=/name=/' $@
sed -i 's/\\begin{definition}/\\begin{block}{Definition}/' $@
sed -i 's/\\end{definition}/\\end{block}/' $@

