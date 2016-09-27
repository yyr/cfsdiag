; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Tuesday, September 27 2016

begin
  varname = "tsfc"
;  type = "X11"
  type = "pdf"

  dirrfc = "~/git/cfsdiag/cfs/cfs2_ref/orig/"
  dirftpc = "~/git/cfsdiag/cfs/cfs2_ftpc/orig/"
  finrfc = "cfs2_ref_1m_2014_2064_" + varname + ".nc"
  finftpc = "cfs2_ftpc_1m_2019_2055_" + varname + ".nc"

  fr = addfile(dirrfc + finrfc, "r")
  fs = addfile(dirftpc + finftpc, "r")

  foutname = varname + "_anom.nc"
  system("rm " + foutname)
  anout =  addfile(foutname, "c")

  var_ref = fr->$varname$
  var_ftpc = fs->$varname$

  clim_ref = clmMonTLL(var_ref(6:593,0,:,:)) ; t dim has some odd beg end values
  clim_ftpc = clmMonTLL(var_ftpc(3:14,0,:,:)) ; t dim has some odd beg end values

  anom = clim_ref - clim_ftpc
  copy_VarCoords(clim_ref,anom)

  ; printVarSummary(clim_ftpc)
  ; printVarSummary(anom)

  masking = True
  if ( masking ) then
    lmfh = addfile("true_landmask.nc","r")
    lm = lmfh->LAND_GDS4_SFC_51
    ; printVarSummary(lm)
    do it = 0, 11, 1    ; doc
      anom(it,:,:) = where(lm.eq.1, lm@_FillValue,anom(it,:,:))
    end do
    anom@_FillValue = lm@_FillValue
  end if

  output_varname = "mon_ano_" + varname
  ; write out
  anout->$output_varname$ = anom
;  anout->$output_varname$ = anom

  res = True
  res@cnFillOn = True

  wks = gsn_open_wks(type,varname + "_anom")
  plot = gsn_contour_map(wks, anom(0,:,:), res)

end
