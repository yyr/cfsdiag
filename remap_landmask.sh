# intial  cfs2_global_slmask.t126.nc has gaussian grid with 385x191
# convert it 360x181 latlon grid.
# check landmask.coords file.
cat <<- EOF > /tmp/landmask
gridtype = lonlat
xsize    = 360
ysize    = 181
xfirst   = 0
xinc     = 1
yfirst   = 90
yinc     = -1
EOF

cdo remapbil,/tmp/landmask cfs/cfs2_global_slmask.t126.nc cfs/landmask.nc
