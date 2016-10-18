; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Friday, October 14 2016

; load "$nsc/is.ncl"
; load "$nsc/resources.ncl"

begin
  store_nc = False
  ; varname = "tsfc"
  varname_values = (/"tsfc", "prate", "ts"/)
  type = "pdf"
  diag = "mean_yr"

  if ( .not. isdefined("varname") ) then
    varname = "tsfc"
  end if

  stref = 66
  etref = 485

  if ( varname .eq. "ts" ) then
    stftpc = 0
    etftpc = 419
  else
    stftpc = 3
    etftpc = 422
  end if
  sy = 2020
  ey = 2054

  if ( varname .eq. "ts" ) then
    fbit = "_1m_2020_2055_"
  else
    fbit = "_1m_2019_2055_"
  end if

  dirrfc = "~/git/cfsdiag/cfs/cfs2_ref/orig/"
  dirftpc = "~/git/cfsdiag/cfs/cfs2_ftpc/orig/"
  finrfc = "cfs2_ref_1m_2014_2064_" + varname + ".nc"
  finftpc = "cfs2_ftpc" + fbit + varname + ".nc"

  fr = addfile(dirrfc + finrfc, "r")
  fs = addfile(dirftpc + finftpc, "r")

  var_ref = fr->$varname$
  var_ftpc = fs->$varname$

  if ( varname .eq. "tsfc" ) then
    clim_ref = dim_avg_n_Wrap(var_ref(stref:etref,0,:,:),(/1,2/)) ; t dim has some odd beg end values
    clim_ftpc = dim_avg_n_Wrap(var_ftpc(stftpc:etftpc,0,:,:),(/1,2/)) ; t dim has some odd beg end values
    masking = True
  end if

  if ( varname .eq. "ts" ) then
    clim_ref = dim_avg_n_Wrap(var_ref(stref:etref,:,:),(/1,2/)) ; t dim has some odd beg end values
    clim_ftpc = dim_avg_n_Wrap(var_ftpc(stftpc:etftpc,:,:),(/1,2/)) ; t dim has some odd beg end values
    masking = False
  end if


  if ( varname .eq. "prate" ) then
    clim_ref = dim_avg_n_Wrap(var_ref(stref:etref,:,:),(/1,2/)) ; t dim has some odd beg end values
    clim_ftpc = dim_avg_n_Wrap(var_ftpc(stftpc:etftpc,:,:),(/1,2/)) ; t dim has some odd beg end values

    clim_ftpc = clim_ftpc * PRATE@UNITMULT
    clim_ref = clim_ref * PRATE@UNITMULT
    masking = False
  end if


  time = fr->time(stref:etref)
  utc = cd_calendar(time,0)
  ; printVarSummary(clim_ref)
  ; printVarSummary(clim_ftpc)
  ; printVarSummary(time)


  plotname = diag + "_" + varname
  wks = gsn_open_wks(type,plotname)

  resL = True
  resL@xyLineColors      = "red"                    ; line color

  resR = resL
  resR@gsnLeftString = diag + "_" + varname
  resR@xyLineColors      = "blue"                    ; line color

  plot = gsn_csm_xy2(wks, utc(:12,0), month_to_annual(clim_ref,1),\
         month_to_annual(clim_ftpc,1), resL, resR)

end