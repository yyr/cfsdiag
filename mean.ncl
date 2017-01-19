; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Monday, September 26 2016

load "$nsc/is.ncl"
load "./cfsdiag.ncl"

begin
  type = "pdf"
  diag = "mean"
  varname_values = (/"mslp", "prate", "ts"/)
  expmt_values = (/"ftpc", "ref", "obs"/)

  plotname = diag + "_" + expmt + "_" + varname
  wks = gsn_open_wks(type,plotname)
  cfsdiag_set_res_colormap(wks, varname)

  var = load_data(expmt, varname)
  var_mean = dim_avg_n_Wrap(var,0)
  printMinMax(var_mean,True)

  res = cfsdiag_set_res_cn_map(True)
  res = cfsdiag_set_cn_limits(res, varname, diag)
  res@gsnLeftString = diag + "_"  + expmt + "_" + varname

  ppname(plotname,type)
  plot = gsn_csm_contour_map(wks, var_mean, res)
end
