; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Friday, November 11 2016

load "$nsc/is.ncl"
load "$nsc/resources.ncl"
load "./config.ncl"

begin
  reg = "ir"
  type = "pdf"
  varname = "prate"

  obsdir = "~/git/cfsdiag/cfs/obs/"
  refdir = "~/git/cfsdiag/cfs/cfs2_ref/orig/"
  ftcdir = "~/git/cfsdiag/cfs/cfs2_ftpc/orig/"

  obsinf = "precip.mon.mean.nc"
  refinf = "cfs2_ref_1m_2014_2064_prate.nc"
  ftcinf = "cfs2_ftpc_1m_2020_2030_prate.nc"

  obsmaskinf = "precip.mon.mean.landmask.nc"
  cfsmaskinf = "cfs_landmask.nc"

  stobs = 0
  etobs = 431

  stref = 66
  etref = 197

  stftc = 0
  etftc = 131

  sy = 2020
  ey = 2030

  fo = addfile(obsdir + obsinf, "r")
  fr = addfile(refdir + refinf, "r")
  fs = addfile(ftcdir + ftcinf, "r")

  obs_prec = fo->precip
  ref_prec = fr->prate
  ftc_prec = fs->prate

  ; load the mask files
  fom = addfile(obsdir + obsmaskinf, "r")
  obs_mask = fom->LAND_GDS4_SFC_51

  fcm = addfile(cfsmaskinf, "r")
  cfs_mask = fcm->LAND_GDS4_SFC_51

  obs_mean = clmMonTLL(obs_prec(stobs:etobs,:,:))
  ref_mean = clmMonTLL(ref_prec(stref:etref,:,:))
  ftc_mean = clmMonTLL(ftc_prec(stftc:etftc,:,:))

  do it = 0, 11, 1
    obs_mean(it,:,:) = obs_mean(it,:,:) * obs_mask
    ref_mean(it,:,:) = ref_mean(it,:,:) * cfs_mask
    ftc_mean(it,:,:) = ftc_mean(it,:,:) * cfs_mask
  end do

  ; printVarSummary(obs_mean)
  ; printVarSummary(ref_mean)
  ; printVarSummary(ftc_mean)

  obs_ir = obs_mean({month| :}, {lat | IR_N: IR_S},{lon | IR_W:IR_E})
  ref_ir = ref_mean({month| :}, {lat | IR_N: IR_S},{lon | IR_W:IR_E})
  ftc_ir = ftc_mean({month| :}, {lat | IR_N: IR_S},{lon | IR_W:IR_E})

  obs_ir_ave = dim_avg_n_Wrap(obs_ir,(/1,2/))
  ref_ir_ave = dim_avg_n_Wrap(ref_ir,(/1,2/))
  ftc_ir_ave = dim_avg_n_Wrap(ftc_ir,(/1,2/))

  ref_ir_ave = ref_ir_ave * PRATE@UNITMULT
  ftc_ir_ave = ftc_ir_ave * PRATE@UNITMULT

  res = True
  res = set_res_no_frame(res)
  res@gsnLeftString = "IR" + "_" + varname
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
