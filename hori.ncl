; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Wednesday, November 16 2016

load "$nsc/is.ncl"
load "$nsc/resources.ncl"
load "./config.ncl"

begin
  type = "pdf"

  indir = "./cfs/obs/"
  infile = "HadISST_sst.nc"

  fh = addfile(indir + infile, "r")
  varname = "sst"
  var = fh->$varname$

  var_mean = dim_avg_n_Wrap(var,0)

  res = True
  res = set_res_no_frame(res)
  res = set_res_cn(res)
  set_res_cn_limits(res,TC@CNMIN, TC@CNMAX, TC@CNINT)

  plotname =  "hori" + "_" + varname

  ppname(plotname,type)
  wks = gsn_open_wks(type,plotname)

  plot = gsn_csm_contour_map(wks, var_mean, res)

  maximize_output(wks,True)
end