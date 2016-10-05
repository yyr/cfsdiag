; gsn_define_colormap(wks,"WhBlGrYeRe")   ; overwrite the .hluresfile color map
TSFC = True
TSFC@COLORMAP = "WhBlGrYeRe"
TSFC@CNMIN = 250
TSFC@CNMAX = 300
TSFC@CNINT = 1.
; TSFC@CNMIN, TSFC@CNMAX, TSFC@CNINT

PRATE = True
PRATE@CNMIN = 0
PRATE@CNMAX = 0.00026
PRATE@CNINT = 0.00002

; anomaly
ANOM = True
ANOM@COLORMAP = "BlueRedGray"
