#include "share/atspre_define.hats"
#include "share/atspre_staload.hats"
staload _ = "./src/DATS/sqlite.dats"

staload
SQLITE = "./src/SATS/sqlite.sats"

%{#
#include "./src/CATS/lib.cats"
%}
