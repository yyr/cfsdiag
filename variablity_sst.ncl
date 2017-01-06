; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Friday, November 11 2016

load "$nsc/is.ncl"
load "$nsc/resources.ncl"
load "./cfsdiag.ncl"

begin
  type = "pdf"
  varname = "ts"
  diag = "variablity"

  plotname =  "variablity" + "_" + "sst" + "_" + reg
  wks = gsn_open_wks(type,plotname)

  if ( reg .eq. "nino" ) then
    S = NINO_S
    N = NINO_N
    W = NINO_W
    E = NINO_E
  end if

  if ( reg .eq. "wiod" ) then
    S = wIOD_S
    N = wIOD_N
    W = wIOD_W
    E = wIOD_E
  end if

  if ( reg .eq. "eiod" ) then
    S = eIOD_S
    N = eIOD_N
    W = eIOD_W
    E = eIOD_E
  end if

  var_obs  = load_data("obs", varname)
  var_ref  = load_data("ref", varname)
  var_ftpc = load_data("ftpc", varname)

  obs_std = stdMonTLL(var_obs)
  ref_std = stdMonTLL(var_ref)
  ftc_std = stdMonTLL(var_ftpc)

  if ( reg .eq. "nino" ) then
    W = W + 360.
    E = E + 360.
  end if

  obs_reg = obs_std({month| :}, {lat | N:S}, {lon | W:E})
  ref_reg = ref_std({month| :}, {lat | N:S}, {lon | W:E})
  ftc_reg = ftc_std({month| :}, {lat | N:S}, {lon | W:E})

  obs_reg_ave = dim_avg_n_Wrap(obs_reg,(/1,2/))
  ref_reg_ave = dim_avg_n_Wrap(ref_reg,(/1,2/))
  ftc_reg_ave = dim_avg_n_Wrap(ftc_reg,(/1,2/))

  res = True
  res@gsnLeftString = reg + " SST (C)"
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
                    (/obs_reg_ave, ref_reg_ave, ftc_reg_ave/), res)
  maximize_output(wks,True)
end
