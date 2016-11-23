# intial  cfs2_global_slmask.t126.nc has gaussian grid with 385x191
# convert it 360x181 latlon grid.
# check landmask.coords file.
cdo remapbil,landmask.coords cfs2_global_slmask.t126.nc landmask.nc
