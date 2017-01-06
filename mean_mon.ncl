; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Monday, September 26 2016

load "$nsc/is.ncl"
load "$nsc/resources.ncl"
load "./cfsdiag.ncl"

begin
  type = "pdf"
  diag = "mean_mon"

  plotname = diag + "_" + expmt + "_" + varname
  wks = gsn_open_wks(type,plotname)

  var = load_data(expmt, varname)
  printMinMax(var,True)

  var_mean = clmMonTLL(var)

  res = True
  res = set_res_cn(res)
  res@gsnLeftString = diag + "_"  + expmt + "_" + varname
  res@cnLinesOn = False

  ppname(plotname,type)

  res = cfsdiag_set_cn_limits(res, varname, "mean")
  cfsdiag_set_res_colormap(wks, varname)
  res = set_res_centered_pacific(res)   ; make pacific center.

  do it = 0, 11, 1
    res@gsnCenterString = month_name(it)
    plot = gsn_csm_contour_map(wks, var_mean(it,:,:), res)
  end do

end
