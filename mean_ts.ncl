; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Friday, October 14 2016

load "$nsc/is.ncl"
load "$nsc/resources.ncl"
load "./cfsdiag.ncl"

begin
  type = "pdf"
  diag = "mean_yr"

  expmt1 = "ref"
  expmt2 = "ftpc"

  plotname = diag + "_" + varname
  wks = gsn_open_wks(type,plotname)

  var1 = load_data(expmt1, varname)
  var2 = load_data(expmt2, varname)

  clim1 = dim_avg_n_Wrap(var1,(/1,2/))
  clim2 = dim_avg_n_Wrap(var2,(/1,2/))

  mr = month_to_annual(clim1,1) ; yearly mean.
  mn = month_to_annual(clim2,1)

  utc = get_time(expmt1)

  res = True
  res = set_res_xy(res)
  res = set_res_legend(res)
  res = set_res_aspectratio_manual(res, 0.6, 0.4)
  res@gsnLeftString = "yearly mean" + " (" + varname + ")"
  res@xyLineColors      = (/"red", "blue"/)          ; change line color

  res@xyExplicitLegendLabels = (/" ref"," ftpc"/)         ; create explicit labels

  ppname(plotname,type)
  plot = gsn_csm_xy(wks, utc(::12,0), (/mr,mn/), res)
end
