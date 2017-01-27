#!/bin/bash
# Created: Sunday, January 22 2017

convert mean_obs_ts.pdf          -undercolor '#00000080' -gravity NorthWest -pointsize 20 -annotate +0+0 '(a)' mean_obs_ts.png
convert std_obs_ts.pdf           -undercolor '#00000080' -gravity NorthWest -pointsize 20 -annotate +0+0 '(b)' std_obs_ts.png
convert mean_ref_ts.pdf          -undercolor '#00000080' -gravity NorthWest -pointsize 20 -annotate +0+0 '(c)' mean_ref_ts.png
convert std_ref_ts.pdf           -undercolor '#00000080' -gravity NorthWest -pointsize 20 -annotate +0+0 '(d)' std_ref_ts.png
convert mean_ftpc_ts.pdf          -undercolor '#00000080' -gravity NorthWest -pointsize 20 -annotate +0+0 '(e)' mean_ftpc_ts.png
convert std_ftpc_ts.pdf           -undercolor '#00000080' -gravity NorthWest -pointsize 20 -annotate +0+0 '(f)' std_ftpc_ts.png
convert mean_anom_ts_ref-obs.pdf -undercolor '#00000080' -gravity NorthWest -pointsize 20 -annotate +0+0 '(g)' mean_anom_ts_ref-obs.png
convert std_anom_ts_ref-obs.pdf  -undercolor '#00000080' -gravity NorthWest -pointsize 20 -annotate +0+0 '(h)' std_anom_ts_ref-obs.png
convert mean_anom_ts.pdf         -undercolor '#00000080' -gravity NorthWest -pointsize 20 -annotate +0+0 '(i)' mean_anom_ts.png
convert std_anom_ts.pdf          -undercolor '#00000080' -gravity NorthWest -pointsize 20 -annotate +0+0 '(j)' std_anom_ts.png


montage mean_obs_ts.png          \
        std_obs_ts.png           \
        mean_ref_ts.png          \
        std_ref_ts.png           \
        mean_ftpc_ts.png         \
        std_ftpc_ts.png          \
        mean_anom_ts_ref-obs.png \
        std_anom_ts_ref-obs.png  \
        mean_anom_ts.png         \
        std_anom_ts.png          \
        -tile 2x4 -geometry +0+0 \
        sst_dist_expmts.png
