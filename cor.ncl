; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Wednesday, March 15 2017

; load ref prate
; load ref sst
; load obs sst
; take subset of prate for IR and sst for nino3.4 region.
;


load "$nsc/is.ncl"
load "./cfsdiag.ncl"

begin
  type = "pdf"
  diag = "cor"
  plotname = "lead_lag_" + "cor"

  varname = "prate"
  reg = "ir"

  obs_sst = load_data("obs", "sst")
  ref_sst = load_data("obs", "sst")

  ; intialize area variables
  N = 0.
  E = 0.
  W = 0.
  S = 0.
  ; print("N: " + N + " E: " + E + " W: " + W + " S: " + S)

  ; sub section of sst for given region
  nino_region_change("nino", N, E, W, S)
  obs_sst_nino = obs_sst({time | :}, {lat | N:S}, {lon | W:E})
  ref_sst_nino = ref_sst({time | :}, {lat | N:S}, {lon | W:E})

  var = load_data("ref", varname)
  seamask(var)


  ; IR region precipitation.
  nino_region_change(reg, N, E, W, S)
  var_reg   =   var({time| :}, {lat | N:S}, {lon | W:E})
  var_reg_m = reshape(var_reg, (/dim_len0(var_reg)/12, 12, \
                         dim_len1(var_reg), dim_len2(var_reg)/))

  printVarSummary(var_reg_m)
end
