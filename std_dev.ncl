; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Monday, September 26 2016

load "$nsc/is.ncl"
load "$nsc/resources.ncl"
load "./config.ncl"

begin
  store_nc = False
  ; varname = "tsfc"
  varname_values = (/"tsfc", "prate"/)
  type = "pdf"
  diag = "std_anom"

  if ( .not. isdefined("varname") ) then
    varname = "tsfc"
  end if

  stref = 66
  etref = 593

  stftpc = 3
  etftpc = 422

  sy = 2020
  ey = 2054

  dirrfc = "~/git/cfsdiag/cfs/cfs2_ref/orig/"
  dirftpc = "~/git/cfsdiag/cfs/cfs2_ftpc/orig/"
  finrfc = "cfs2_ref_1m_2014_2064_" + varname + ".nc"
  finftpc = "cfs2_ftpc_1m_2019_2055_" + varname + ".nc"

  fr = addfile(dirrfc + finrfc, "r")
  fs = addfile(dirftpc + finftpc, "r")

  var_ref = fr->$varname$
  var_ftpc = fs->$varname$

  if ( varname .eq. "tsfc" ) then
    std_ref = stdMonTLL(var_ref(stref:etref,0,:,:)) ; t dim has some odd beg end values
    std_ftpc = stdMonTLL(var_ftpc(stftpc:etftpc,0,:,:)) ; t dim has some odd beg end values
    masking = True
  end if
  if ( varname .eq. "prate" ) then
    std_ref = stdMonTLL(var_ref(stref:etref,:,:)) ; t dim has some odd beg end values
    std_ftpc = stdMonTLL(var_ftpc(stftpc:etftpc,:,:)) ; t dim has some odd beg end values
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
      gsn_define_colormap(wks,STD_ANOM_PRATE@COLORMAP)
      set_res_cn_limits(res,STD_ANOM_PRATE@CNMIN, STD_ANOM_PRATE@CNMAX, STD_ANOM_PRATE@CNINT)
    else if ( varname .eq. "tsfc" ) then
      gsn_define_colormap(wks,ANOM_TSFC@COLORMAP)
      set_res_cn_limits(res,STD_ANOM_TSFC@CNMIN, STD_ANOM_TSFC@CNMAX, STD_ANOM_TSFC@CNINT)
    else
    end if
  end if

  do it = 0, 11, 1
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
