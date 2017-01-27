; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Friday, November 11 2016

load "$nsc/is.ncl"
load "$nsc/resources.ncl"
load "./cfsdiag.ncl"

begin
  reg = "ir"
  type = "pdf"
  varname = "prate"

  plotname =  "anual_cycle" + "_" + varname + "_" + reg
  wks = gsn_open_wks(type,plotname)

  var_obs  = load_data("obs", varname)
  var_ref  = load_data("ref", varname)
  var_ftpc = load_data("ftpc", varname)

  obs_mean = clmMonTLL(var_obs)
  ref_mean = clmMonTLL(var_ref)
  ftc_mean = clmMonTLL(var_ftpc)

  seamask(obs_mean)
  seamask(ref_mean)
  seamask(ftc_mean)

  obs_ir = obs_mean({month| :}, {lat | IR_N: IR_S},{lon | IR_W:IR_E})
  ref_ir = ref_mean({month| :}, {lat | IR_N: IR_S},{lon | IR_W:IR_E})
  ftc_ir = ftc_mean({month| :}, {lat | IR_N: IR_S},{lon | IR_W:IR_E})

  ; Plot horizontally before doing area average (just to verify).
  ; ppname(plotname,type)
  ; res =   set_res_cn(True)
  ; set_res_cn_limits(res, 0 , 25, 0.5)
  ; plot = gsn_csm_contour(wks, obs_ir(4,:,:), res)
  ; plot = gsn_csm_contour(wks, ftc_ir(4,:,:), res)
  ; plot = gsn_csm_contour(wks, ref_ir(4,:,:), res)

  obs_ir_ave = dim_avg_n_Wrap(obs_ir,(/1,2/))
  ref_ir_ave = dim_avg_n_Wrap(ref_ir,(/1,2/))
  ftc_ir_ave = dim_avg_n_Wrap(ftc_ir,(/1,2/))

  ; printMinMax(obs_ir_ave, True)
  ; printMinMax(ref_ir_ave, True)
  ; printMinMax(ftc_ir_ave, True)

  ; Another method to calculate.
  ; obs_ir_sum = dim_sum_n_Wrap(obs_ir,(/1,2/))
  ; ref_ir_sum = dim_sum_n_Wrap(ref_ir,(/1,2/))
  ; ftc_ir_sum = dim_sum_n_Wrap(ftc_ir,(/1,2/))

  ; obs_ir_ave = obs_ir_sum/num(ind(ndtooned(obs_ir).ne.0))
  ; ref_ir_ave = ref_ir_sum/num(ind(ndtooned(ref_ir).ne.0))
  ; ftc_ir_ave = ftc_ir_sum/num(ind(ndtooned(ftc_ir).ne.0))

  res = cfsdiag_set_res_placeholder(True)
  res@gsnLeftString = "ir" + "_" + varname
  res@xyLineColors      = (/"black", "blue", "red"/)          ; change line color
  res@xyExplicitLegendLabels = (/" obs", " ref"," ftpc" /)         ; create explicit labels
  res = set_res_xy(res)

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
