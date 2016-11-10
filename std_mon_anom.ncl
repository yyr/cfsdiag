; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Monday, September 26 2016

load "$nsc/is.ncl"
load "$nsc/resources.ncl"
load "./config.ncl"

begin
  store_nc = False
  ; varname = "tsfc"
  varname_values = (/"tsfc", "prate", "ts"/)
  type = "pdf"
  diag = "std_mon_anom"

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

  if ( varname .eq. "tsfc" ) then
    std_ref = stdMonTLL(var_ref(stref:etref,0,:,:)) ; t dim has some odd beg end values
    std_ftpc = stdMonTLL(var_ftpc(stftpc:etftpc,0,:,:)) ; t dim has some odd beg end values
    masking = True
  end if

  if ( varname .eq. "tsfc" ) then
    std_ref = stdMonTLL(var_ref(stref:etref,0,:,:)) ; t dim has some odd beg end values
    std_ftpc = stdMonTLL(var_ftpc(stftpc:etftpc,0,:,:)) ; t dim has some odd beg end values
    masking = True
  end if

  if ( varname .eq. "ts" ) then
    std_ref = stdMonTLL(var_ref(stref:etref,:,:)) ; t dim has some odd beg end values
    std_ftpc = stdMonTLL(var_ftpc(stftpc:etftpc,:,:)) ; t dim has some odd beg end values
    masking = False
  end if


  if ( varname .eq. "prate" ) then
    std_ref = stdMonTLL(var_ref(stref:etref,:,:)) ; t dim has some odd beg end values
    std_ftpc = stdMonTLL(var_ftpc(stftpc:etftpc,:,:)) ; t dim has some odd beg end values

    std_ftpc = std_ftpc * PRATE@UNITMULT
    std_ref = std_ref * PRATE@UNITMULT
    masking = False
  end if

  anom = std_ref - std_ftpc
  printMinMax(anom,True)
  copy_VarCoords(std_ref,anom)

  if ( masking ) then
    lmfh = addfile("true_landmask.nc","r")
    lm = lmfh->LAND_GDS4_SFC_51
    ; printVarSummary(lm)
    do it = 0, 11, 1    ; doc
      anom(it,:,:) = where(lm.eq.1, lm@_FillValue,anom(it,:,:))
    end do
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
    gsn_define_colormap(wks,ANOM_PRATE@COLORMAP)
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

  do it = 0, 11, 1
    res@gsnCenterString = month_name(it)
    plot = gsn_csm_contour_map(wks, anom(it,:,:), res)
  end do

  ; output
  if ( store_nc ) then
    foutname = "anom_" + varname + "_" + sy + "_" + ey + ".nc"
    system("rm " + foutname)
    anout =  addfile(foutname, "c")
    output_varname = "mon_ano_" + varname
    anout->$output_varname$ = anom
  end if
end
