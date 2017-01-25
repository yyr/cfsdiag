; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Monday, September 26 2016

load "$nsc/is.ncl"
load "$nsc/resources.ncl"
load "./cfsdiag.ncl"

begin
  type = "pdf"
  diag = "mean_anom"

  if ( .not. isdefined("expmt1") ) then
    expmt1 = "ftpc"
  end if
  if ( .not. isdefined("expmt2") ) then
    expmt2 = "ref"
  end if

  plotname = diag + "_" + varname + "_" + expmt1 + "-" + expmt2
  wks = gsn_open_wks(type,plotname)
  gsn_define_colormap(wks,ANOM_TSFC@COLORMAP)

  var1 = load_data(expmt1, varname)
  var2 = load_data(expmt2, varname)

  clim1 = dim_avg_n_Wrap(var1,0)
  clim2 = dim_avg_n_Wrap(var2,0)

  anom = clim1 - clim2
  printMinMax(anom,True)
  copy_VarCoords(clim1,anom)

  res = cfsdiag_set_res_placeholder(True)
  res = cfsdiag_set_res_cn_map(res)
  res = cfsdiag_set_cn_limits(res, varname, "anom")
  res@gsnLeftString = expmt1 + "-" + expmt2 + " " + varname

  ppname(plotname,type)
  plot = gsn_csm_contour_map(wks, anom, res)
end
