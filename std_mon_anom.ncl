; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Monday, September 26 2016

load "$nsc/is.ncl"
load "$nsc/resources.ncl"
load "./cfsdiag.ncl"

begin
  type = "pdf"
  diag = "std_mon_anom"

  plotname = diag + "_" + varname
  wks = gsn_open_wks(type,plotname)

  expmt1 = "ref"
  expmt2 = "ftpc"

  var1 = load_data(expmt1, varname)
  var2 = load_data(expmt2, varname)

  std1mon = stdMonTLL(var1)
  std2mon = stdMonTLL(var2)

  anom = std1mon - std2mon
  printMinMax(anom,True)
  copy_VarCoords(std1mon,anom)

  res = True
  res = set_res_cn(res)
  res@gsnLeftString = diag + "_" + varname
  res@cnLinesOn = False

  ppname(plotname,type)
  res = cfsdiag_set_cn_limits(res, varname, "anom")
  gsn_define_colormap(wks,ANOM_TSFC@COLORMAP)
  res = set_res_centered_pacific(res)   ; make pacific center.

  do it = 0, 11, 1
    res@gsnCenterString = month_name(it)
    plot = gsn_csm_contour_map(wks, anom(it,:,:), res)
  end do
end
