; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Monday, September 26 2016

begin

  var = "mslp"

  dir = "~/git/cfsdiag/cfs/cfs2_ref/orig/"
  finname = "cfs2_ref_1m_2014_2064_" + var + ".nc"

  f = addfile(dir + finname, "r")
  print(getfilevarnames(f));

  mslp = f->mslp
  printVarSummary(mslp)

  t = f->time
  t_l = cd_calendar(t,2)

  ; mlsp though starts in between the year and ..
  ; climslp = clmMonTLL(mslp(6:593,:,:))
  mslp_mean = dim_avg_n_Wrap(mslp,0)

end
