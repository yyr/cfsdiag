; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Monday, September 26 2016

load "$nsc/is.ncl"
load "$nsc/resources.ncl"
load "./cfsdiag.ncl"

begin
  type = "pdf"
  diag = "std_mon"

  plotname = diag + "_" + expmt + "_" + varname
  wks = gsn_open_wks(type,plotname)

  var = load_data(expmt, varname)

  var_std_mon = stdMonTLL(var)
  printMinMax(var_std_mon,True)

  res = cfsdiag_set_res_placeholder(True)
  res = cfsdiag_set_res_cn_map(res)
  res = cfsdiag_set_cn_limits(res, varname, "std")
  res@gsnLeftString = diag + "_"  + expmt + "_" + varname

  ppname(plotname,type)
  do it = 0, 11, 1
    res@gsnCenterString = month_name(it)
    plot = gsn_csm_contour_map(wks, var_std_mon(it,:,:), res)
  end do
end
