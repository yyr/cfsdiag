; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Wednesday, November 16 2016

load "$nsc/is.ncl"
load "./cfsdiag.ncl"

begin
  type = "pdf"

  indir = "./cfs/obs/"
  infile = "HadISST_sst_cfsgrid.nc"

  fh = addfile(indir + infile, "r")
  varname = "sst"
  var = fh->$varname$

  var_mean = dim_avg_n_Wrap(var,0)

  res = cfsdiag_set_res_cn_map(True)
  res = set_res_no_frame(res)
  set_res_cn_limits(res,TC@CNMIN, TC@CNMAX, TC@CNINT)

  plotname =  "hori_cfsgrid" + "_" + varname
  ppname(plotname,type)
  wks = gsn_open_wks(type,plotname)

  plot = gsn_csm_contour_map(wks, var_mean, res)
  maximize_output(wks,True)
end
