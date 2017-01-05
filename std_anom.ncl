; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Monday, September 26 2016

load "$nsc/is.ncl"
load "$nsc/resources.ncl"
load "./cfsdiag.ncl"

begin
  type = "pdf"
  diag = "std_anom"
  masking = False

  expmt1 = "ref"
  expmt2 = "ftpc"

  plotname = diag + "_" + varname
  wks = gsn_open_wks(type,plotname)

  var1 = load_data(expmt1, varname)
  var2 = load_data(expmt2, varname)

  std1mon = stdMonTLL(var1)
  std1 = dim_avg_n_Wrap(std1mon,0)

  std2mon = stdMonTLL(var2)
  std2 = dim_avg_n_Wrap(std2mon,0)

  anom = std1 - std2
  printMinMax(anom,True)
  copy_VarCoords(std1,anom)

  if ( varname .eq. "ts" ) then
    masking = True
  end if

  if ( masking ) then
    landmask(anom)
  end if

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

; NOTE: the calculation method tsfc and ts are varies
; they yeild mostly same results though.
; if ( varname .eq. "tsfc" ) then
;   clm_ref = clmMonTLL(var_ref(stref:etref,0,:,:)) ; monthly climatology
;   xAnom = calcMonAnomTLL(var_ref(stref:etref,0,:,:),clm_ref)
;   std_ref = dim_stddev_n_Wrap(xAnom,0)

;   clm_ftpc = clmMonTLL(var_ftpc(stftpc:etftpc,0,:,:)) ; monthly climatology
;   xAnom = calcMonAnomTLL(var_ftpc(stftpc:etftpc,0,:,:),clm_ftpc)
;   std_ftpc = dim_stddev_n_Wrap(xAnom,0)
; end if
