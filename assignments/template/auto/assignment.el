;; -*- lexical-binding: t; -*-

(TeX-add-style-hook
 "assignment"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("scrartcl" "paper=letter" "twoside" "fontsize=10pt" "parskip=half" "mpinclude=true")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("isodate" "cleanlook" "british") ("mycommon" "plextt" "etbb") ("csquotes" "") ("booktabs" "") ("tabularx" "") ("caption" "") ("subcaption" "") ("graphicx" "") ("standalone" "subpreambles=false" "mode=tex") ("enumitem" "inline") ("course" "") ("snotez" "footnote=true") ("hyperref" "") ("biblatex" "style=authoryear") ("cleveref" "nameinlink" "capitalise") ("listings" "")))
   (TeX-run-style-hooks
    "latex2e"
    "scrartcl"
    "scrartcl10"
    "isodate"
    "mycommon"
    "csquotes"
    "booktabs"
    "tabularx"
    "caption"
    "subcaption"
    "graphicx"
    "standalone"
    "enumitem"
    "course"
    "snotez"
    "hyperref"
    "biblatex"
    "cleveref"
    "listings")
   (LaTeX-add-bibliographies
    "bibliography"))
 :latex)

