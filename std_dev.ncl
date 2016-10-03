; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Tuesday, September 27 2016

begin
  var = "prate"

  dircfc = "~/git/cfsdiag/cfs/cfs2_ref/orig/"
  dirftpc = "~/git/cfsdiag/cfs/cfs2_ftpc/orig/"
  fincfc = "cfs2_ref_1m_2014_2064_" + var + ".nc"
  finftpc = "cfs2_ftpc_1m_2019_2055_" + var + ".nc"

  stref = 66
  etref = 593

  stftpc = 3
  etftpc = 422

  sy = 2020
  ey = 2054

  fr = addfile(dircfc + fincfc, "r")
  fs = addfile(dirftpc + finftpc, "r")

  var_ref = fr->$var$
  var_ftpc = fs->$var$

  std_ref = stdMonTLL(var_ref(stref:etref,:,:))
  std_ftpc = stdMonTLL(var_ftpc(stftpc:etftpc,:,:))


  masking = False
  if ( masking ) then
    lmfh = addfile("true_landmask.nc","r")
    lm = lmfh->LAND_GDS4_SFC_51
    do it = 0, 11, 1    ; doc
      std_ref(it,:,:) = where(lm.eq.1, lm@_FillValue,std_ref(it,:,:))
      std_ftpc(it,:,:) = where(lm.eq.1, lm@_FillValue,std_ftpc(it,:,:))
    end do
    std_ref@_FillValue = lm@_FillValue
    std_ftpc@_FillValue = lm@_FillValue
  end if

  foutname = "std_ref_" + var + "_" + sy + "_" + ey + ".nc"
  system("rm " + foutname)
  anout =  addfile(foutname, "c")
  output_var = var + "_std"
  anout->$output_var$ = std_ref

  fout_ftpcname = "std_ftpc_" + var + "_" + sy + "_" + ey + ".nc"
  system("rm " + fout_ftpcname)
  anout =  addfile(fout_ftpcname, "c")
  output_var = var + "_std"
  anout->$output_var$ = std_ftpc
end
