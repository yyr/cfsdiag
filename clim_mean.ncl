; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Monday, September 26 2016

begin

  varname = "prate"
;  type = "X11"
  type = "pdf"

  dir = "~/git/cfsdiag/cfs/cfs2_ref/orig/"
  finname = "cfs2_ref_1m_2014_2064_" + varname + ".nc"

  f = addfile(dir + finname, "r")

  var = f->$varname$
;  printMinMax(var,True)

  t = f->time
  t_l = cd_calendar(t,2)
  var_mean = dim_avg_n_Wrap(var(6:593,:,:),0)
;  printVarSummary(var_mean)

  wks = gsn_open_wks(type,varname)
  res = True
  res@cnFillOn = True

;  var_reverse = var_mean(::-1,:)
  plot = gsn_contour_map(wks, var_mean, res)

  ; output
  foutname = "clim_" + varname + ".nc"
  system("rm " + foutname)
  out = addfile(foutname, "c")
  outvarname = "clim_" + varname
  out->$outvarname$ = var

end
