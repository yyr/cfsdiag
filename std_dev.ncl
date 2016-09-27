; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Tuesday, September 27 2016

begin
  var = "tsfc"
;  type = "X11"
  type = "pdf"
  masking = True


  dircfc = "~/git/cfsdiag/cfs/cfs2_ref/orig/"
  dirftpc = "~/git/cfsdiag/cfs/cfs2_ftpc/orig/"
  fincfc = "cfs2_ref_1m_2014_2064_" + var + ".nc"
  finftpc = "cfs2_ftpc_1m_2019_2055_" + var + ".nc"

  fr = addfile(dircfc + fincfc, "r")
  fs = addfile(dirftpc + finftpc, "r")


  prate_ref = fr->$var$
  prate_ftpc = fs->$var$

  std_ref = stdMonTLL(prate_ref(6:593,0,:,:)) ; t dim has some odd beg end values
  std_ftpc = stdMonTLL(prate_ftpc(3:14,0,:,:)) ; t dim has some odd beg end values

  if ( masking ) then
    lmfh = addfile("true_landmask.nc","r")
    lm = lmfh->LAND_GDS4_SFC_51
    do it = 0, 11, 1    ; doc
      std_ref(it,:,:) = where(lm.eq.1, lm@_FillValue,std_ref(it,:,:))
      std_ftpc(it,:,:) = where(lm.eq.1, lm@_FillValue,std_ftpc(it,:,:))
    end do
  end if

  std_ref@_FillValue = lm@_FillValue
  std_ftpc@_FillValue = lm@_FillValue

  fout_refname = var + "ref_std.nc"
  system("rm " + fout_refname)
  anout =  addfile(fout_refname, "c")
  output_var = var + "_std"

  anout->$output_var$ = std_ftpc

  fout_ftpcname = var + "ftpc_std.nc"
  system("rm " + fout_ftpcname)
  anout =  addfile(fout_ftpcname, "c")
  output_var = var + "_std"

  anout->$output_var$ = std_ftpc
end
