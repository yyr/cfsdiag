# intial  cfs2_global_slmask.t126.nc has gaussian grid with 385x191
# convert it 360x181 latlon grid.
# check landmask.coords file.
cat <<- EOF > /tmp/cfsgrid
gridtype = lonlat
xsize    = 360
ysize    = 181
xfirst   = 0
xinc     = 1
yfirst   = 90
yinc     = -1
EOF

#
mkdir -p remapped
for file in $@; do
    echo cdo remapbil,/tmp/cfsgrid $file orig/$file
    cdo remapbil,/tmp/cfsgrid $file remapped/$file
done
