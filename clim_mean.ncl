; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Monday, September 26 2016

begin

  var = "mslp"
;  type = "X11"
  type = "pdf"

  dir = "~/git/cfsdiag/cfs/cfs2_ref/orig/"
  finname = "cfs2_ref_1m_2014_2064_" + var + ".nc"

  foutname = "clim_mean.nc"

  f = addfile(dir + finname, "r")

  system("rm " + foutname)
  out = addfile(foutname, "c")

;  print(getfilevarnames(f));

  mslp = f->mslp
  printVarSummary(mslp)

  t = f->time
  t_l = cd_calendar(t,2)

  ; mlsp though starts in between the year and ..
  ; climslp = clmMonTLL(mslp(6:593,:,:))

  mslp_mean = dim_avg_n_Wrap(mslp(6:593,:,:),0)
  wks = gsn_open_wks(type,var)
  res = True
  res@cnFillOn = True
;  res@trGridType = "TriangularMesh"

  mslp_reverse = mslp_mean(::-1,:)

  printVarSummary(mslp_mean)
  printVarSummary(mslp_reverse)

  plot = gsn_contour_map(wks, mslp_mean, res)
  out->clim_mslp = mslp_reverse

end
