; Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
; Created: Thursday, September 22 2016

begin
  dir = "~/cfsdiag/cfs/"
  filename = "landmask.nc"

  f = addfile(dir + filename, "r")
  print(getfilevarnames(f))
end
