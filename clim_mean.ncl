; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Monday, September 26 2016

load "$nsc/is.ncl"
load "$nsc/resources.ncl"
load "./config.ncl"

begin
  type = "pdf"
  ; varname = "tsfc"
  ; expmt = "ftpc"                 ; "ref", "ftpc"
  diag = "clim_mean"
  varname_values = (/"tsfc", "prate"/)
  expmt_values = (/"ftpc", "ref"/)

  store_nc = False

  if ( .not. isdefined("varname") ) then
    varname = "tsfc"
  end if
  if ( .not. isdefined("expmt") ) then
    varname = "ftpc"
  end if


  if ( expmt .eq. "ref" ) then
    st = 66
    et = 593
  else
    st = 3
    et = 422
  end if
  sy = 2020
  ey = 2054

  plotname = diag + "_" + expmt + "_" + varname

  dir = "~/git/cfsdiag/cfs/cfs2_" + expmt + "/orig/"

  if ( expmt .eq. "ref" ) then
    fbit = "_1m_2014_2064_"
  else
    fbit = "_1m_2019_2055_"
  end if

  finname = "cfs2_" + expmt + fbit + varname + ".nc"
  f = addfile(dir + finname, "r")

  var = f->$varname$
;  printMinMax(var,True)

  if ( varname .eq. "tsfc" ) then
    var_mean = dim_avg_n_Wrap(var(st:et,0,:,:),0)
  else
    var_mean = dim_avg_n_Wrap(var(st:et,:,:),0)
  end if

  wks = gsn_open_wks(type,plotname)

  res = True
  res = set_res_cn(res)
  res@gsnLeftString = diag + "_"  + expmt + "_" + varname
  res = set_res_cn(res)
  res@cnLinesOn = False

  ppname(plotname,type)
  if ( varname .eq. "prate" ) then
    set_res_cn_limits(res, PRATE@CNMIN, PRATE@CNMAX, PRATE@CNINT)
    else if ( varname .eq. "tsfc" ) then
      gsn_define_colormap(wks,TSFC@COLORMAP)
      set_res_cn_limits(res,TSFC@CNMIN, TSFC@CNMAX, TSFC@CNINT)
    else
    end if
  end if

  plot = gsn_csm_contour_map(wks, var_mean, res)

  ; output
  if ( store_nc ) then
    foutname = diag + "_" + expmt + "_" + varname + "_" + sy + "_" + ey + ".nc"
    system("rm " + foutname)
    out = addfile(foutname, "c")
    outvarname = "clim_" + varname
  end if

end
