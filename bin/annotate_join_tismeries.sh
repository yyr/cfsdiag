#!/bin/bash
# Created: Sunday, January 22 2017

convert anual_cycle_prate_ir.pdf -undercolor '#00000080' -gravity North -pointsize 30 -annotate +0+0 '(a)'  anual_cycle_prate_ir.png
convert anual_cycle_sst_nino.pdf -undercolor '#00000080' -gravity North -pointsize 30 -annotate +0+0 '(b)'  anual_cycle_sst_nino.png
convert anual_cycle_sst_wiod.pdf -undercolor '#00000080' -gravity North -pointsize 30 -annotate +0+0 '(c)'  anual_cycle_sst_wiod.png
convert anual_cycle_sst_eiod.pdf -undercolor '#00000080' -gravity North -pointsize 30 -annotate +0+0 '(d)'  anual_cycle_sst_eiod.png
convert variablity_prate_ir.pdf  -undercolor '#00000080' -gravity North -pointsize 30 -annotate +0+0 '(e)'   variablity_prate_ir.png
convert variablity_sst_nino.pdf  -undercolor '#00000080' -gravity North -pointsize 30 -annotate +0+0 '(f)'   variablity_sst_nino.png
convert variablity_sst_wiod.pdf  -undercolor '#00000080' -gravity North -pointsize 30 -annotate +0+0 '(g)'   variablity_sst_wiod.png
convert variablity_sst_eiod.pdf  -undercolor '#00000080' -gravity North -pointsize 30 -annotate +0+0 '(h)'   variablity_sst_eiod.png

montage  anual_cycle_prate_ir.png\
         anual_cycle_sst_nino.png\
         anual_cycle_sst_wiod.png\
         anual_cycle_sst_eiod.png\
         \
         variablity_prate_ir.png\
         variablity_sst_nino.png\
         variablity_sst_wiod.png\
         variablity_sst_eiod.png\
         -tile 4x2 -geometry +0+0 \
         time_series.png
