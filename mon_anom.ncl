; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Tuesday, September 27 2016

begin
  var = "tsfc"
;  type = "X11"
  type = "pdf"

  dircfc = "~/git/cfsdiag/cfs/cfs2_ref/orig/"
  dirftpc = "~/git/cfsdiag/cfs/cfs2_ftpc/orig/"
  fincfc = "cfs2_ref_1m_2014_2064_" + var + ".nc"
  finftpc = "cfs2_ftpc_1m_2019_2055_" + var + ".nc"

  fr = addfile(dircfc + fincfc, "r")
  fs = addfile(dirftpc + finftpc, "r")

  foutname = var + "_anom.nc"
  system("rm " + foutname)
  anout =  addfile(foutname, "c")

  prate_ref = fr->$var$
  prate_ftpc = fs->$var$

  clim_ref = clmMonTLL(prate_ref(6:593,0,:,:)) ; t dim has some odd beg end values
  clim_ftpc = clmMonTLL(prate_ftpc(3:14,0,:,:)) ; t dim has some odd beg end values


  anom = clim_ref - clim_ftpc
  copy_VarCoords(clim_ref,anom)

  ; printVarSummary(clim_ftpc)
  ; printVarSummary(anom)

  masking = True
  if ( masking ) then
    lmfh = addfile("true_landmask.nc","r")
    lm = lmfh->LAND_GDS4_SFC_51
    printVarSummary(lm)
    do it = 0, 11, 1    ; doc
      anom(it,:,:) = where(lm.eq.1, lm@_FillValue,anom(it,:,:))
    end do
    anom@_FillValue = lm@_FillValue
  end if

  output_var = "mon_ano_" + var
  ; write out
  anout->$output_var$ = anom
;  anout->$output_var$ = anom

  res = True
  res@cnFillOn = True

  wks = gsn_open_wks(type,var + "_anom")
  plot = gsn_contour_map(wks, anom(0,:,:), res)

end
