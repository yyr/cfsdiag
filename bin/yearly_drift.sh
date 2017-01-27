#!/bin/bash
# Created: Sunday, January 22 2017

convert mean_yr_ts.pdf     -undercolor '#00000080' -gravity North -pointsize 30 -annotate +0+0 '(a)' mean_yr_ts.png
convert mean_yr_prate.pdf  -undercolor '#00000080' -gravity North -pointsize 20 -annotate +0+0 '(b)' mean_yr_prate.png

convert mean_yr_global_ts.pdf    -undercolor '#00000080' -gravity North -pointsize 30 -annotate +0+0 '(a)' mean_yr_global_ts.png
convert mean_yr_global_prate.pdf -undercolor '#00000080' -gravity North -pointsize 30 -annotate +0+0 '(b)' mean_yr_global_prate.png
convert mean_yr_wiod_ts.pdf      -undercolor '#00000080' -gravity North -pointsize 30 -annotate +0+0 '(c)' mean_yr_wiod_ts.png
convert mean_yr_wiod_prate.pdf   -undercolor '#00000080' -gravity North -pointsize 30 -annotate +0+0 '(d)' mean_yr_wiod_prate.png
convert mean_yr_ts.pdf           -undercolor '#00000080' -gravity North -pointsize 30 -annotate +0+0 '(e)' mean_yr_ts.png
convert mean_yr_prate.pdf        -undercolor '#00000080' -gravity North -pointsize 30 -annotate +0+0 '(f)' mean_yr_prate.png
convert mean_yr_eiod_ts.pdf      -undercolor '#00000080' -gravity North -pointsize 30 -annotate +0+0 '(g)' mean_yr_eiod_ts.png
convert mean_yr_eiod_prate.pdf   -undercolor '#00000080' -gravity North -pointsize 30 -annotate +0+0 '(h)' mean_yr_eiod_prate.png
convert mean_yr_nino_ts.pdf      -undercolor '#00000080' -gravity North -pointsize 30 -annotate +0+0 '(i)' mean_yr_nino_ts.png
convert mean_yr_nino_prate.pdf   -undercolor '#00000080' -gravity North -pointsize 30 -annotate +0+0 '(j)' mean_yr_nino_prate.png


montage mean_yr_global_ts.png \
        mean_yr_global_prate.png \
        mean_yr_wiod_ts.png    \
        mean_yr_wiod_prate.png \
        mean_yr_ts.png         \
        mean_yr_prate.png      \
        mean_yr_eiod_ts.png    \
        mean_yr_eiod_prate.png \
        mean_yr_nino_ts.png    \
        mean_yr_nino_prate.png \
        -tile 2x5 -geometry +0+0 \
        yearly.png
