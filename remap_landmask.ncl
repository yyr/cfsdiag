; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Thursday, September 22 2016

; This is shoulder script for remap_landmask.sh

begin
  dir = "~/git/cfsdiag/"
  finname = "cfs/obs/cfs2_global_slmask.cfsgrid.dirty.nc"
  foutname = "cfs/obs/cfs2_global_slmask.cfsgrid.nc"

  f = addfile(dir + finname, "r")
  fout = addfile(dir + foutname, "c")

;  print(getfilevarnames(f))

  lm = f->LAND_GDS4_SFC_51
  lm = where(lm.lt.0.5,0,1)

  fout->LAND_GDS4_SFC_51 = lm
end
