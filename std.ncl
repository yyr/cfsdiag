; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Monday, September 26 2016

load "$nsc/is.ncl"
load "$nsc/resources.ncl"
load "./cfsdiag.ncl"

begin
  type = "pdf"
  diag = "std"

  plotname = diag + "_" + expmt + "_" + varname
  wks = gsn_open_wks(type,plotname)

  var = load_data(expmt, varname)

  var_std_mon = stdMonTLL(var)
  var_std = dim_avg_n_Wrap(var_std_mon,0)

  printMinMax(var_std,True)

  res = cfsdiag_set_res_cn_map(True)
  res = cfsdiag_set_cn_limits(res, varname, "std")
  res@gsnLeftString = diag + "_"  + expmt + "_" + varname

  ppname(plotname,type)
  plot = gsn_csm_contour_map(wks, var_std, res)
end
