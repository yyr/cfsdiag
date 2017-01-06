; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Friday, November 11 2016

load "$nsc/is.ncl"
load "$nsc/resources.ncl"
load "./cfsdiag.ncl"

begin
  reg = "ir"
  type = "pdf"
  varname = "prate"

  plotname =  "variablity" + "_" + varname + "_" + reg
  wks = gsn_open_wks(type,plotname)

  var_obs  = load_data("obs", varname)
  var_ref  = load_data("ref", varname)
  var_ftpc = load_data("ftpc", varname)

  obs_std = stdMonTLL(var_obs)
  ref_std = stdMonTLL(var_ref)
  ftc_std = stdMonTLL(var_ftpc)

  landmask(obs_std)
  landmask(ref_std)
  landmask(ftc_std)

  ; printVarSummary(obs_std)
  ; printVarSummary(ref_std)
  ; printVarSummary(ftc_std)

  obs_ir = obs_std({month| :}, {lat | IR_N: IR_S},{lon | IR_W:IR_E})
  ref_ir = ref_std({month| :}, {lat | IR_N: IR_S},{lon | IR_W:IR_E})
  ftc_ir = ftc_std({month| :}, {lat | IR_N: IR_S},{lon | IR_W:IR_E})

  obs_ir_ave = dim_avg_n_Wrap(obs_ir,(/1,2/))
  ref_ir_ave = dim_avg_n_Wrap(ref_ir,(/1,2/))
  ftc_ir_ave = dim_avg_n_Wrap(ftc_ir,(/1,2/))

  res = True
  res@gsnLeftString = "IR" + " (mm/day)"
  res@xyLineColors      = (/"black", "blue", "red"/)          ; change line color
  res@xyExplicitLegendLabels = (/" obs", " ref"," ftpc" /)         ; create explicit labels

  res = set_res_no_frame(res)
  res = set_res_tix_limits(res, 1, 12)
  res = set_res_legend(res)
  res = set_res_aspectratio_manual(res, 0.4, 0.6)
  res = set_res_tm_explicit(res, (/1,3,5,7,9,11/), \
                            (/"J", "M", "M", "J", "S", "N"/), ispan(1,12,1))

  ppname(plotname,type)
  plot = gsn_csm_xy(wks, ispan(1,12,1), \
                    (/obs_ir_ave, ref_ir_ave, ftc_ir_ave/), res)
  maximize_output(wks,True)
end
