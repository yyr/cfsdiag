; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Monday, September 26 2016

load "$nsc/is.ncl"
load "$nsc/resources.ncl"
load "./dataloader.ncl"

begin
  type = "pdf"
  diag = "std_mon"

  plotname = diag + "_" + expmt + "_" + varname
  wks = gsn_open_wks(type,plotname)

  var = load_data(expmt, varname)

  var_std_mon = stdMonTLL(var)
  printMinMax(var_std_mon,True)

  res = True
  res = set_res_cn(res)
  res@gsnLeftString = diag + "_"  + expmt + "_" + varname
  res@cnLinesOn = False

  ppname(plotname,type)
  res = cfsdiag_set_cn_limits(res, varname, diag)
  res = set_res_centered_pacific(res)   ; make pacific center.

  do it = 0, 11, 1
    res@gsnCenterString = month_name(it)
    plot = gsn_csm_contour_map(wks, var_std_mon(it,:,:), res)
  end do
end
