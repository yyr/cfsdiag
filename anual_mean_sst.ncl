; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Friday, November 11 2016

load "$nsc/resources.ncl"
load "./cfsdiag.ncl"

begin
  type = "pdf"
  varname = "ts"
  diag = "anual_cycle"

  plotname =  diag + "_" + "sst" + "_" + reg
  wks = gsn_open_wks(type,plotname)

  input_args = (/"reg"/)

  do it = 0, dimsizes(input_args) - 1, 1    ; doc
    if ( .not. isdefined(input_args(it)) ) then
      print("'" + input_args(it) + "' argument is not passed, Exiting..")
      exit
    end if
  end do

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

  obs_mean = clmMonTLL(var_obs)
  ref_mean = clmMonTLL(var_ref)
  ftc_mean = clmMonTLL(var_ftpc)

  ; printVarSummary(obs_mean)
  ; printVarSummary(ref_mean)
  ; printVarSummary(ftc_mean)


  if ( reg .eq. "nino" ) then
    W = W + 360.
    E = E + 360.
  end if

  obs_reg = obs_mean({month| :}, {lat | N:S}, {lon | W:E})
  ref_reg = ref_mean({month| :}, {lat | N:S}, {lon | W:E})
  ftc_reg = ftc_mean({month| :}, {lat | N:S}, {lon | W:E})

  obs_reg_ave = dim_avg_n_Wrap(obs_reg,(/1,2/))
  ref_reg_ave = dim_avg_n_Wrap(ref_reg,(/1,2/))
  ftc_reg_ave = dim_avg_n_Wrap(ftc_reg,(/1,2/))

  ; printMinMax(obs_reg_ave, True)
  ; printMinMax(ref_reg_ave, True)
  ; printMinMax(ftc_reg_ave, True)

  obs_reg_ave = obs_reg_ave - 273.15
  ref_reg_ave = ref_reg_ave - 273.15
  ftc_reg_ave = ftc_reg_ave - 273.15

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
