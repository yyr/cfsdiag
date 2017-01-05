; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Monday, September 26 2016

load "$nsc/is.ncl"
load "$nsc/resources.ncl"
load "./dataloader.ncl"

begin
  type = "pdf"
  diag = "mean"
  varname_values = (/"mslp", "prate", "ts"/)
  expmt_values = (/"ftpc", "ref", "obs"/)

  plotname = diag + "_" + expmt + "_" + varname
  wks = gsn_open_wks(type,plotname)

  var = load_data(expmt, varname)
  var_mean = dim_avg_n_Wrap(var,0)

  res = True
  res@gsnLeftString = diag + "_"  + expmt + "_" + varname
  res = set_res_cn(res)
  res@cnLinesOn = False

  ppname(plotname,type)

  res = cfsdiag_set_cn_limits(res, varname)
  cfsdiag_set_res_colormap(wks, varname)

  plot = gsn_csm_contour_map(wks, var_mean, res)
end
