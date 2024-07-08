# -*- cperl -*-

use Cwd qw/cwd/;
my $rootdir = cwd;

ensure_path("TEXINPUTS", "${rootdir}/texmf//");
ensure_path("TEXINPUTS", "${rootdir}/tikzfigures//");
ensure_path("TEXINPUTS", "${rootdir}/figures//");

ensure_path("BIBINPUTS", "${rootdir}/texmf//");
ensure_path("BIBINPUTS", "${rootdir}/");

ensure_path("BSTINPUTS", "${rootdir}/texmf//");
