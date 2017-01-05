; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Thursday, January  5 2017

load "./config.ncl"

;_____________________________________________________________________________
; Function: load_data
; Doc:
;_____________________________________________________________________________
undef("load_data")
function load_data(expmt, varname)
local var, expmt, varname


begin
  if ( expmt .eq. "ref" ) then
    st = 66
    et = 197
  else
    st = 0
    et = 131
  end if

  sy = 2020
  ey = 2030

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
    var = f->$varname$(st:et,:,:)
  end if

  if ( varname .eq. "prate" .and. expmt .ne. "obs" ) then
    var = var * PRATE@UNITMULT
  end if

  if ( varname .eq. "ts" .and. expmt .eq. "obs" ) then
    var = var + C2T
  end if

  return(var)
end

;_____________________________________________________________________________
; Function: cfsdiag_set_cn_limits
; Doc:
;_____________________________________________________________________________
undef("cfsdiag_set_cn_limits")
function cfsdiag_set_cn_limits(res_in, varname)
local res_in, varname

begin
  if ( varname .eq. "prate" ) then
    set_res_cn_limits(res_in, PRATE@CNMIN, PRATE@CNMAX, PRATE@CNINT)
    else if ( varname .eq. "ts" .or. varname .eq. "tsfc" ) then
      set_res_cn_limits(res_in,TSFC@CNMIN, TSFC@CNMAX, TSFC@CNINT)
    end if
  end if
  return(res_in)
end

;_____________________________________________________________________________
; Function: cfsdiag_set_std_cn_limits
; Doc:
;_____________________________________________________________________________
undef("cfsdiag_set_std_cn_limits")
function cfsdiag_set_std_cn_limits(res_in, varname)
local res_in, varname

begin
  set_res_cn_limits(res_in, STD@CNMIN, STD@CNMAX, STD@CNINT)
  return(res_in)
end

;_____________________________________________________________________________
; Function: cfsdiag_set_res_colormap
; Doc:
;_____________________________________________________________________________
undef("cfsdiag_set_res_colormap")
procedure cfsdiag_set_res_colormap(wks, varname:string)
local varname

begin
  if ( varname .eq. "prate" ) then
      gsn_define_colormap(wks,PRATE@COLORMAP)
    else if ( varname .eq. "ts" .or. varname .eq. "tsfc" ) then
      gsn_define_colormap(wks,TSFC@COLORMAP)
    end if
  end if
  return
end
