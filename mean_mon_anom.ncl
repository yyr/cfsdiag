; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Monday, September 26 2016

load "$nsc/is.ncl"
load "$nsc/resources.ncl"
load "./cfsdiag.ncl"

begin
  type = "pdf"
  diag = "mean_mon_anom"

  if ( .not. isdefined("expmt1") ) then
    expmt1 = "ref"
  end if
  if ( .not. isdefined("expmt2") ) then
    expmt2 = "ftpc"
  end if

  plotname = diag + "_" + varname
  wks = gsn_open_wks(type,plotname)
  gsn_define_colormap(wks,ANOM_TSFC@COLORMAP)

  var1 = load_data(expmt1, varname)
  var2 = load_data(expmt2, varname)

  clim1 = clmMonTLL(var1)
  clim2 = clmMonTLL(var2)

  anom = clim1 - clim2
  printMinMax(anom,True)
  copy_VarCoords(clim1,anom)

  res = cfsdiag_set_res_cn_map(True)
  res = cfsdiag_set_cn_limits(res, varname, "anom")
  res@gsnLeftString = diag + "_" + varname

  ppname(plotname,type)
  do it = 0, 11, 1
    res@gsnCenterString = month_name(it)
    plot = gsn_csm_contour_map(wks, anom(it,:,:), res)
  end do
end
