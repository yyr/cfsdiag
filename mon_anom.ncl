; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Tuesday, September 27 2016

begin
  var = "prate"
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

  clim_ref = clmMonTLL(prate_ref(6:593,:,:)) ; t dim has some odd beg end values
  clim_ftpc = clmMonTLL(prate_ftpc(3:14,:,:)) ; t dim has some odd beg end values

  printVarSummary(clim_ref)
  printVarSummary(clim_ftpc)

  anom = clim_ref - clim_ftpc
  copy_VarCoords(clim_ref,anom)
  printVarSummary(anom)

  anout->mon_ano_prate = anom

  res = True
  res@cnFillOn = True

  wks = gsn_open_wks(type,var + "_anom")
  plot = gsn_contour_map(wks, anom(0,:,:), res)

end
