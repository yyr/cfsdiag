; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Thursday, September 22 2016

; There are places (near poles) where sst is set < -750.  This script convert
; them to missing values so that standard deviation doesn't mess up.


begin
  dir = "./cfs/obs/"
  finname = "HadISST_sst.cfsgrid.nc"
  foutname = "HadISST_sst_cfsgrid.nc"

  f = addfile(dir + finname, "r")
  fout = addfile(dir + foutname, "c")

  ; print(getfilevarnames(f))

  sst = f->sst
  sst = where(sst.lt.-100,sst@_FillValue,sst)

  fout->sst = sst
end
