; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Friday, October 14 2016

load "$nsc/is.ncl"
load "$nsc/resources.ncl"
load "./cfsdiag.ncl"

begin
  type = "pdf"
  diag = "mean_yr"

  input_args = (/"reg", "varname"/)
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

  if ( reg .eq. "nino" ) then
    W = W + 360.
    E = E + 360.
  end if

  expmt1 = "ref"
  expmt2 = "ftpc"

  plotname = diag + "_" + reg + "_" + varname
  wks = gsn_open_wks(type,plotname)

  var1 = load_data(expmt1, varname)
  var2 = load_data(expmt2, varname)

  if ( reg .eq. "global" ) then
    var1_reg = var1
    var2_reg = var2
  else
    var1_reg = var1({time| :}, {lat | N:S}, {lon | W:E})
    var2_reg = var2({time| :}, {lat | N:S}, {lon | W:E})
  end if

  clim1 = dim_avg_n_Wrap(var1_reg,(/1,2/))
  clim2 = dim_avg_n_Wrap(var2_reg,(/1,2/))

  mr = month_to_annual(clim1,1) ; yearly mean.
  mn = month_to_annual(clim2,1)

  utc = get_time(expmt1)

  res = cfsdiag_set_res_placeholder(True)
  res = set_res_aspectratio_manual(res, 0.6, 0.3)
  res = set_res_xy(res)
  res = set_res_legend(res)
  res = set_res_aspectratio_manual(res, 0.6, 0.4)

  ; if ( varname .eq. "ts" ) then
  ;   if ( reg .eq. "global" ) then
  ;     res = set_res_tiy_limits(res, 284.5, 286.)
  ;   else
  ;     res = set_res_tiy_limits(res, 296., 305.)
  ;   end if

  ;   else if ( varname .eq. "prate" ) then
  ;     if ( reg .eq. "global" ) then
  ;       res = set_res_tiy_limits(res, 2.4, 2.8)
  ;     else
  ;       res = set_res_tiy_limits(res, 2., 3.)
  ;     end if
  ;   end if
  ; end if

  res@gsnLeftString = "yearly mean of " + varname + " (" + reg + ")"
  res@xyLineColors      = (/"red", "blue"/)          ; change line color

  res@xyExplicitLegendLabels = (/" ref"," ftpc"/)         ; create explicit labels

  ppname(plotname,type)
  plot = gsn_csm_xy(wks, utc(::12,0), (/mr,mn/), res)
end
