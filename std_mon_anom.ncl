; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Monday, September 26 2016

load "./cfsdiag.ncl"

begin
  type = "pdf"
  diag = "std_mon_anom"

  plotname = diag + "_" + varname + "_" + expmt1 + "-" + expmt2
  wks = gsn_open_wks(type,plotname)
  gsn_define_colormap(wks,ANOM_TSFC@COLORMAP)

  if ( .not. isdefined("expmt1") ) then
    expmt1 = "ref"
  end if
  if ( .not. isdefined("expmt2") ) then
    expmt2 = "ftpc"
  end if

  var1 = load_data(expmt1, varname)
  var2 = load_data(expmt2, varname)

  std1mon = stdMonTLL(var1)
  std2mon = stdMonTLL(var2)

  anom = std1mon - std2mon
  printMinMax(anom,True)
  copy_VarCoords(std1mon,anom)

  res = cfsdiag_set_res_placeholder(True)
  res = cfsdiag_set_res_cn_map(res)
  res = cfsdiag_set_cn_limits(res, varname, "anom")
  res@gsnLeftString = diag + "_" + varname

  ppname(plotname,type)
  do it = 0, 11, 1
    res@gsnCenterString = month_name(it)
    plot = gsn_csm_contour_map(wks, anom(it,:,:), res)
  end do
end
