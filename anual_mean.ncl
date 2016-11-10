; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Friday, November 11 2016

load "$nsc/is.ncl"
load "$nsc/resources.ncl"
load "./config.ncl"

begin

  reg = "IR"

  type = "pdf"
  varname = "prate"

  obsdir = "~/git/cfsdiag/cfs/obs/"
  obsinf = "precip.mon.mean.nc"

  fo = addfile(obsdir + obsinf, "r")

  obs_prec = fo->precip
  st = 0
  et = 431

  var_mean = clmMonTLL(obs_prec(st:et,:,:))

  printVarSummary(var_mean)

  var_ir = var_mean({month| :}, {lat | IR_N: IR_S},{lon | IR_W:IR_E})

  var_ir_ave = dim_avg_n_Wrap(var_ir,(/1,2/))

  res = True
  res = set_res_no_frame(res)
  res@gsnLeftString = "IR" + "_" + varname

  plotname =  "annual_cycle" + "_" + varname
  ppname(plotname,type)
  wks = gsn_open_wks(type,plotname)

  plot = gsn_csm_y(wks, var_ir_ave, res)
  maximize_output(wks,True)
end
