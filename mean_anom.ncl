; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Monday, September 26 2016

load "$nsc/is.ncl"
load "$nsc/resources.ncl"
load "./cfsdiag.ncl"

begin
  type = "pdf"
  diag = "mean_anom"

  expmt1 = "ref"
  expmt2 = "ftpc"

  plotname = diag + "_" + varname
  wks = gsn_open_wks(type,plotname)

  var1 = load_data(expmt1, varname)
  var2 = load_data(expmt2, varname)

  clim1 = dim_avg_n_Wrap(var1,0)
  clim2 = dim_avg_n_Wrap(var2,0)

  anom = clim1 - clim2
  printMinMax(anom,True)
  copy_VarCoords(clim1,anom)

  res = True
  res = set_res_cn(res)
  res@gsnLeftString = diag + "_" + varname
  res@cnLinesOn = False

  ppname(plotname,type)
  res = cfsdiag_set_cn_limits(res, varname, "anom")
  gsn_define_colormap(wks,ANOM_TSFC@COLORMAP)

  res = set_res_centered_pacific(res)   ; make pacific center.
  plot = gsn_csm_contour_map(wks, anom, res)
end
