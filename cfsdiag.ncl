; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Thursday, January  5 2017

load "./config.ncl"
load "$nsc/generic.ncl"
load "$nsc/resources.ncl"

;_____________________________________________________________________________
; Function: time_indices
; Doc:
;_____________________________________________________________________________
undef("time_indices")
function time_indices(expmt, varname)
local expmt, varname, st, et

begin
  if ( expmt .eq. "ref" ) then
    st = 66
    et = 521
  else
    st = 0
    et = 455
  end if

  if ( expmt .eq. "obs" .and. varname .eq. "prate"  ) then
    st = 0
    et = 431
    else if ( expmt .eq. "obs" .and. varname .eq. "ts"  ) then
      st = 0
      et = 1751
    end if
  end if

  return((/st, et/))
end

;_____________________________________________________________________________
; Function: get_filenames
; Doc:
;_____________________________________________________________________________
undef("get_filenames")
function get_filenames(expmt, varname)
local dir, finname, fbit, expmt, varname

begin
  sy = 2020
  ey = 2057

  if ( expmt .eq. "obs" ) then
    dir = "~/git/cfsdiag/cfs/" + expmt + "/"
  else
    dir = "~/git/cfsdiag/cfs/cfs2_" + expmt + "/"
  end if

  if ( expmt .eq. "ref" ) then
    fbit = "_1m_2014_2064_"
  else
    fbit = "_1m_2020_2057_"
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

  return((/dir, finname/))
end


;_____________________________________________________________________________
; Function: load_landmask
; Doc:
;_____________________________________________________________________________
undef("load_landmask")
function load_landmask()
local f, dir, finname

begin
  dir = "~/git/cfsdiag/cfs/obs/"
  finname = "cfs2_global_slmask.cfsgrid.nc"
  f = addfile(dir + finname, "r")
  return(f->LAND_GDS4_SFC_51)
end

;_____________________________________________________________________________
; procedure: landmask
; Doc:
;_____________________________________________________________________________
undef("landmask")
procedure landmask(var:numeric)
local lm

begin
    lm = load_landmask()
    if ( rank_of(var) .eq. 2 ) then
      var(:,:) = where(lm.eq.1, lm@_FillValue,var(:,:))
      else if ( rank_of(var) .eq. 3 ) then
        do it = 0, dim_len0(var) - 1, 1    ; doc
          var(it,:,:) = where(lm.eq.1, lm@_FillValue,var(it,:,:))
        end do
      end if
    end if
    var@_FillValue = lm@_FillValue
  return
end

;_____________________________________________________________________________
; procedure: seamask
; Doc:
;_____________________________________________________________________________
undef("seamask")
procedure seamask(var:numeric)
local lm

begin
    lm = load_landmask()
    if ( rank_of(var) .eq. 2 ) then
      var(:,:) = where(lm.eq.1, lm@_FillValue,var(:,:))
      else if ( rank_of(var) .eq. 3 ) then
        do it = 0, dim_len0(var) - 1, 1    ; doc
          var(it,:,:) = where(lm.eq.0, lm@_FillValue,var(it,:,:))
        end do
      end if
    end if
    var@_FillValue = lm@_FillValue
  return
end

;_____________________________________________________________________________
; Function: load_data
; Doc:
;_____________________________________________________________________________
undef("load_data")
function load_data(expmt, varname)
local var, expmt, varname, st, et

begin
  inds = time_indices(expmt, varname)
  st = inds(0)
  et = inds(1)

  fins = get_filenames(expmt, varname)
  dir = fins(0)
  finname = fins(1)

  f = addfile(dir + finname, "r")

  if ( expmt .eq. "obs" ) then
    if ( varname .eq. "prate" ) then
      var = f->precip(st:et,:,:)
      else if ( varname .eq. "ts" ) then
        var = f->sst(st:et,:,:)
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

  if ( varname .eq. "ts" .and. expmt .ne. "obs" ) then
    landmask(var)
  end if

  return(var)
end

;_____________________________________________________________________________
; Function: get_time
; Doc:
;_____________________________________________________________________________
undef("get_time")
function get_time(expmt:string)
local st, et, time, inds, fins

begin
  inds = time_indices(expmt, varname)
  st = inds(0)
  et = inds(1)

  fins = get_filenames(expmt, varname)
  dir = fins(0)
  finname = fins(1)

  f = addfile(dir + finname, "r")

  time = f->time(st:et)
  return(cd_calendar(time,0))
end


;_____________________________________________________________________________
; Function: cfsdiag_set_res_placeholder
; Doc:
;_____________________________________________________________________________
undef("cfsdiag_set_res_placeholder")
function cfsdiag_set_res_placeholder(res)
local res

begin
  res@gsnStringFontHeightF = 14
  return(res)
end


;_____________________________________________________________________________
; Function: cfsdiag_set_cn_limits
; Doc:
;_____________________________________________________________________________
undef("cfsdiag_set_cn_limits")
function cfsdiag_set_cn_limits(res_in, varname, diag)
local res_in, varname, diag

begin
  if ( diag .eq. "mean" ) then
    if ( varname .eq. "prate" ) then
      set_res_cn_limits(res_in, PRATE@CNMIN, PRATE@CNMAX, PRATE@CNINT)
      else if ( varname .eq. "ts" .or. varname .eq. "tsfc" ) then
        set_res_cn_limits(res_in,TSFC@CNMIN, TSFC@CNMAX, TSFC@CNINT)
      end if
    end if
  end if

  if ( diag .eq. "std" ) then
    set_res_cn_limits(res_in, STD@CNMIN, STD@CNMAX, STD@CNINT)
  end if

  if ( diag .eq. "anom" ) then
    if ( varname .eq. "prate" ) then
      set_res_cn_limits(res_in,ANOM_PRATE@CNMIN, ANOM_PRATE@CNMAX, ANOM_PRATE@CNINT)
      else if ( varname .eq. "ts" .or. varname .eq. "tsfc" ) then
        set_res_cn_limits(res_in,ANOM_TSFC@CNMIN, ANOM_TSFC@CNMAX, ANOM_TSFC@CNINT)
      end if
    end if
  end if

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


;_____________________________________________________________________________
; Function: cfsdiag_set_res_cn_map
; Doc:
;_____________________________________________________________________________
undef("cfsdiag_set_res_cn_map")
function cfsdiag_set_res_cn_map(res)
local res

begin
  res = set_res_no_margin(res)
  res = set_res_cn(res)
  res = set_res_highres_coast(res)
  res = set_res_mp_lat_limits(res, -40., 40.)
  res = set_res_centered_pacific(res)   ; make pacific center.
  return(res)
end
