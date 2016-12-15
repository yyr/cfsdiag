; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Monday, September 26 2016

load "$nsc/is.ncl"
load "$nsc/resources.ncl"
load "./config.ncl"

begin
  varname_values = (/"tsfc", "prate", "ts"/)
  type = "pdf"
  diag = "std_anom"
  masking = False

  if ( .not. isdefined("varname") ) then
    varname = "tsfc"
  end if

  stref = 66
  etref = 197

  stftpc = 0
  etftpc = 131

  sy = 2020
  ey = 2030

  fbit = "_1m_2020_2030_"

  dirrfc = "~/git/cfsdiag/cfs/cfs2_ref/orig/"
  dirftpc = "~/git/cfsdiag/cfs/cfs2_ftpc/orig/"
  finrfc = "cfs2_ref_1m_2014_2064_" + varname + ".nc"
  finftpc = "cfs2_ftpc" + fbit + varname + ".nc"

  fr = addfile(dirrfc + finrfc, "r")
  fs = addfile(dirftpc + finftpc, "r")

  var_ref = fr->$varname$
  var_ftpc = fs->$varname$

  ; NOTE: the calculation method tsfc and ts are varies
  ; they yeild mostly same results though.
  if ( varname .eq. "tsfc" ) then
    clm_ref = clmMonTLL(var_ref(stref:etref,0,:,:)) ; monthly climatology
    xAnom = calcMonAnomTLL(var_ref(stref:etref,0,:,:),clm_ref)
    std_ref = dim_stddev_n_Wrap(xAnom,0)

    clm_ftpc = clmMonTLL(var_ftpc(stftpc:etftpc,0,:,:)) ; monthly climatology
    xAnom = calcMonAnomTLL(var_ftpc(stftpc:etftpc,0,:,:),clm_ftpc)
    std_ftpc = dim_stddev_n_Wrap(xAnom,0)
  end if

  if ( varname .eq. "ts" ) then
    std_ref_mon = stdMonTLL(var_ref(stref:etref,:,:))
    std_ref = dim_avg_n_Wrap(std_ref_mon,0)

    std_ftpc_mon = stdMonTLL(var_ftpc(stftpc:etftpc,:,:))
    std_ftpc = dim_avg_n_Wrap(std_ftpc_mon,0)
  end if

  if ( varname .eq. "prate" ) then
    var_ref = var_ref * PRATE@UNITMULT
    var_ftpc = var_ftpc * PRATE@UNITMULT

    std_ref_mon = stdMonTLL(var_ref(stref:etref,:,:))
    std_ref = dim_avg_n_Wrap(std_ref_mon,0)

    std_ftpc_mon = stdMonTLL(var_ftpc(stftpc:etftpc,:,:))
    std_ftpc = dim_avg_n_Wrap(std_ftpc_mon,0)
  end if

  anom = std_ref - std_ftpc
  printMinMax(anom,True)
  copy_VarCoords(std_ref,anom)

  if ( masking ) then
    lmfh = addfile("cfs_landmask.nc","r")
    lm = lmfh->LAND_GDS4_SFC_51
    ; printVarSummary(lm)
    anom(:,:) = where(lm.eq.1, lm@_FillValue,anom(:,:))
    anom@_FillValue = lm@_FillValue
  end if

  res = True
  res = set_res_cn(res)
  res@gsnLeftString = diag + "_" + varname
  res = set_res_cn(res)
  res@cnLinesOn = False

  plotname = diag + "_" + varname
  wks = gsn_open_wks(type,plotname)
  ppname(plotname,type)
  if ( varname .eq. "prate" ) then
    gsn_define_colormap(wks,ANOM_TSFC@COLORMAP)
    set_res_cn_limits(res,ANOM_PRATE@CNMIN, ANOM_PRATE@CNMAX, ANOM_PRATE@CNINT)
    else if ( varname .eq. "tsfc" ) then
      gsn_define_colormap(wks,ANOM_TSFC@COLORMAP)
      set_res_cn_limits(res,ANOM_TSFC@CNMIN, ANOM_TSFC@CNMAX, ANOM_TSFC@CNINT)
      else if ( varname .eq. "ts" ) then
        gsn_define_colormap(wks,ANOM_TSFC@COLORMAP)
        set_res_cn_limits(res,ANOM_TSFC@CNMIN, ANOM_TSFC@CNMAX, ANOM_TSFC@CNINT)
      end if
    end if
  end if

  ; make pacific center.
  res@mpMinLonF=0
  res@mpMaxLonF=360
  res@mpCenterLonF=180

  plot = gsn_csm_contour_map(wks, anom, res)
end
