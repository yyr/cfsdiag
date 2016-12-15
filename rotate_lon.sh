#!/bin/bash
# Created: Thursday, December 15 2016

cat <<- EOF > /tmp/outgrid
gridtype  = lonlat
xname     = longitude
xlongname = longitude
xunits    = degrees_east
yname     = latitude
ylongname = latitude
yunits    = degrees_north

xsize     = 360
ysize     = 181

xfirst    = 0
xinc      = 1

yfirst    = 90
yinc      = -1
EOF


# rotates the lon 180
cdo remapbil,/tmp/outgrid HadISST_sst.nc HadISST_sst_lon.nc


# INPUT GRID
# #
# # gridID 1
# #
# gridtype  = generic
# gridsize  = 2
# xsize     = 2
# #
# # gridID 2
# #
# gridtype  = lonlat
# gridsize  = 64800
# xname     = longitude
# xlongname = longitude
# xunits    = degrees_east
# yname     = latitude
# ylongname = latitude
# yunits    = degrees_north
# xsize     = 360
# ysize     = 180
# xfirst    = -179.5
# xinc      = 1
# yfirst    = 89.5
# yinc      = -1

# OUTPUT GRID
# #
# # gridID 1
# #
# gridtype  = generic
# gridsize  = 2
# xsize     = 2
# #
# # gridID 2
# #
# gridtype  = lonlat
# gridsize  = 64800
# xname     = longitude
# xlongname = longitude
# xunits    = degrees_east
# yname     = latitude
# ylongname = latitude
# yunits    = degrees_north
# xsize     = 360
# ysize     = 180
# xfirst    = 0
# xinc      = 1
# yfirst    = 90
# yinc      = -1
