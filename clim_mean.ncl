; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Monday, September 26 2016

load "$nsc/resources.ncl"

begin
  type = "pdf"
  varname = "prate"
  expmt = "ftpc"                 ; "ref", "ftpc"
  diag = "mean"


  if ( expmt .eq. "ref" ) then
    st = 66
    et = 593
  else
    st = 3
    et = 422
  end if
  sy = 2020
  ey = 2054

  plotname = expmt + "_" + varname + "_" + diag

  dir = "~/git/cfsdiag/cfs/cfs2_" + expmt + "/orig/"

  if ( expmt .eq. "ref" ) then
    fbit = "_1m_2014_2064_"
  else
    fbit = "_1m_2019_2055_"
  end if

  finname = "cfs2_" + expmt + fbit + varname + ".nc"
  f = addfile(dir + finname, "r")

  var = f->$varname$
;  printMinMax(var,True)

  var_mean = dim_avg_n_Wrap(var(st:et,:,:),0)
;  printVarSummary(var_mean)

  ; output
  ; foutname = "clim_" + expmt + "_" + varname + "_" + sy + "_" + ey + ".nc"
  ; system("rm " + foutname)
  ; out = addfile(foutname, "c")
  ; outvarname = "clim_" + varname
  ; out->$outvarname$ = var_mean

  wks = gsn_open_wks(type,plotname)
  gsn_define_colormap(wks,"hotcold_18lev")

  res = True
  res = set_res_cn(res)
  res@gsnLeftString = expmt + "_" + varname  + "_" + diag
  set_res_cn_limits(res,0,0.00026, 0.00002)

  plot = gsn_csm_contour_map(wks, var_mean, res)

end
