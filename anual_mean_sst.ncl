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

  obs_ir = obs_mean({month| :}, {lat | N:S}, {lon | W:E})
  ref_ir = ref_mean({month| :}, {lat | N:S}, {lon | W:E})
  ftc_ir = ftc_mean({month| :}, {lat | N:S}, {lon | W:E})

  obs_ir_ave = dim_avg_n_Wrap(obs_ir,(/1,2/))
  ref_ir_ave = dim_avg_n_Wrap(ref_ir,(/1,2/))
  ftc_ir_ave = dim_avg_n_Wrap(ftc_ir,(/1,2/))

  ; printMinMax(obs_ir_ave, True)
  ; printMinMax(ref_ir_ave, True)
  ; printMinMax(ftc_ir_ave, True)

  obs_ir_ave = obs_ir_ave - 273.15
  ref_ir_ave = ref_ir_ave - 273.15
  ftc_ir_ave = ftc_ir_ave - 273.15

  res = True
  res = set_res_no_frame(res)
  res@gsnLeftString = reg + " SST (C)"
  res@xyLineColors      = (/"black", "blue", "red"/)          ; change line color

  res = set_res_legend(res)
  res@xyExplicitLegendLabels = (/" obs", " ref"," ftpc" /)         ; create explicit labels

  ppname(plotname,type)

  plot = gsn_csm_xy(wks, ispan(1,12,1), \
                    (/obs_ir_ave, ref_ir_ave, ftc_ir_ave/), res)
  maximize_output(wks,True)
end
