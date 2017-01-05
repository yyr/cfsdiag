; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Monday, September 26 2016

load "$nsc/is.ncl"
load "$nsc/resources.ncl"
load "./config.ncl"

begin
  type = "pdf"
  diag = "mean"
  varname_values = (/"mslp", "prate", "ts"/)
  expmt_values = (/"ftpc", "ref", "obs"/)

  if ( .not. isdefined("varname") ) then
    varname = "tsfc"
  end if
  if ( .not. isdefined("expmt") ) then
    expmt = "ftpc"
  end if

  if ( expmt .eq. "ts" ) then
    st = 66
    et = 197
  else
    st = 0
    et = 131
  end if

  sy = 2020
  ey = 2030

  plotname = diag + "_" + expmt + "_" + varname

  if ( expmt .eq. "obs" ) then
    dir = "~/git/cfsdiag/cfs/" + expmt + "/"
  else
    dir = "~/git/cfsdiag/cfs/cfs2_" + expmt + "/orig/"
  end if

  if ( expmt .eq. "ref" ) then
    fbit = "_1m_2014_2064_"
  else
    fbit = "_1m_2020_2030_"
  end if

  if ( expmt .eq. "obs" ) then
    if ( varname .eq. "prate" ) then
        finname = "precip.mon.mean.cfsgrid.nc"
      else if ( varname .eq. "ts" ) then
        finname = "HadISST_sst_cfsgrid.nc"
      else
        print("skipping; NO INPUT" )
        exit
      end if
    end if
  else
    finname = "cfs2_" + expmt + fbit + varname + ".nc"
  end if

  f = addfile(dir + finname, "r")

  if ( expmt .eq. "obs" ) then
    if ( varname .eq. "prate" ) then
      var = f->precip
      else if ( varname .eq. "ts" ) then
        var = f->sst
      end if
    end if
  else
    var = f->$varname$
  end if

;  printMinMax(var,True)

  if ( varname .eq. "tsfc" ) then
    var_mean = dim_avg_n_Wrap(var(st:et,0,:,:),0)
  else
    var_mean = dim_avg_n_Wrap(var(st:et,:,:),0)
  end if

  if ( varname .eq. "prate" .and. expmt .ne. "obs" ) then
    var_mean = var_mean * PRATE@UNITMULT
  end if

  if ( varname .eq. "ts" .and. expmt .eq. "obs" ) then
    var_mean = var_mean + C2T
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
      else if ( varname .eq. "ts" ) then
        gsn_define_colormap(wks,TSFC@COLORMAP)
        set_res_cn_limits(res,TSFC@CNMIN, TSFC@CNMAX, TSFC@CNINT)
      end if
    end if
  end if

  plot = gsn_csm_contour_map(wks, var_mean, res)
end
