; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Friday, November 11 2016

load "$nsc/is.ncl"
load "$nsc/resources.ncl"
load "./config.ncl"

begin
  reg = "nino"

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


  type = "pdf"
  varname = "sst"

  obsdir = "~/git/cfsdiag/cfs/obs/"
  refdir = "~/git/cfsdiag/cfs/cfs2_ref/orig/"
  ftcdir = "~/git/cfsdiag/cfs/cfs2_ftpc/orig/"

  obsinf = "HadISST_sst.nc"
  refinf = "cfs2_ref_1m_2014_2064_ts.nc"
  ftcinf = "cfs2_ftpc_1m_2020_2030_ts.nc"

  stobs = 0
  etobs = 1751

  stref = 66
  etref = 197

  stftc = 0
  etftc = 131

  sy = 2020
  ey = 2030

  fo = addfile(obsdir + obsinf, "r")
  fr = addfile(refdir + refinf, "r")
  fs = addfile(ftcdir + ftcinf, "r")

  obs_var = fo->sst
  ref_var = fr->ts
  ftc_var = fs->ts

  obs_mean = clmMonTLL(obs_var(stobs:etobs,:,:))
  ref_mean = clmMonTLL(ref_var(stref:etref,:,:))
  ftc_mean = clmMonTLL(ftc_var(stftc:etftc,:,:))

  ; printVarSummary(obs_mean)
  ; printVarSummary(ref_mean)
  ; printVarSummary(ftc_mean)

  obs_ir = obs_mean({month| :}, {latitude | N:S}, {longitude | W:E})
  if ( reg .eq. "nino" ) then
    W = W + 360.
    E = E + 360.
  end if
  ref_ir = ref_mean({month| :}, {lat | N:S}, {lon | W:E})
  ftc_ir = ftc_mean({month| :}, {lat | N:S}, {lon | W:E})

  obs_ir_ave = dim_avg_n_Wrap(obs_ir,(/1,2/))
  ref_ir_ave = dim_avg_n_Wrap(ref_ir,(/1,2/))
  ftc_ir_ave = dim_avg_n_Wrap(ftc_ir,(/1,2/))

  ref_ir_ave = ref_ir_ave - 273.15
  ftc_ir_ave = ftc_ir_ave - 273.15

  res = True
  res = set_res_no_frame(res)
  res@gsnLeftString = reg + " SST (C)"
  res@xyLineColors      = (/"black", "blue", "red"/)          ; change line color

  res = set_res_legend(res)
  res@xyExplicitLegendLabels = (/" obs", " ref"," ftpc" /)         ; create explicit labels

  plotname =  "annual_cycle" + "_" + varname + "_" + reg
  ppname(plotname,type)
  wks = gsn_open_wks(type,plotname)

  plot = gsn_csm_xy(wks, ispan(1,12,1), \
                    (/obs_ir_ave, ref_ir_ave, ftc_ir_ave/), res)
  maximize_output(wks,True)
end
