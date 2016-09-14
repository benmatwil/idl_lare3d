function fieldline3d, startpt, bgrid, x, y, z, h, hmin, hmax, epsilon, mxline=mxline, oneway=oneway, boxedge=boxedge

  ;startpt[3,nl] - start point for field line
  ;bgrid[nx,ny,nz,3] - magnetic field 
  ;x[nx],y[ny],z[nz] - grid of points on which magnetic field given 

  ;h - initial step length
  ;hmin - minimum step length
  ;hmax - maximum step length
  ;epsilon - tolerance to which we require point on field line known

  ;define edges of box
  if keyword_set(boxedge) then begin
    xmin = max([boxedge[0,0],min(x)])
    ymin = max([boxedge[0,1],min(y)])
    zmin = max([boxedge[0,2],min(z)])
    xmax = min([boxedge[1,0],max(x)])
    ymax = min([boxedge[1,1],max(y)])
    zmax = min([boxedge[1,2],max(z)])
  endif else begin
    xmin = min(x)
    ymin = min(y)
    zmin = min(z)
    xmax = max(x)
    ymax = max(y)
    zmax = max(z)
  endelse

  ;a2 = 0.25d
  b2 = 0.25d
  ;a3 = 3d/8d
  b3 = 3d/32d
  c3 = 9d/32d
  ;a4 = 12d/13d
  b4 = 1932d/2197d
  c4 = -7200d/2197d
  d4 = 7296d/2197d
  ;a5 = 1d
  b5 = 439d/216d 
  c5 = -8d
  d5 = 3680d/513d
  e5 = -845d/4104d
  ;a6 = 0.5d 
  b6 = -8d/27d
  c6 = 2d 
  d6 = -3544d/2565d
  e6 = 1859d/4104d
  f6 = -11d/40d

  ;used to determine y_i+1 from y_i if using rkf45 (4th order)
  n1 = 25d/216d
  n3 = 1408d/2565d
  n4 = 2197d/4104d
  n5 = -1d/5d
    
  ;used to determine y_i+1 from y_i if using rkf54 (5th order)
  nn1 = 16d/135d
  nn3 = 6656d/12825d
  nn4 = 28561d/56430d
  nn5 = -9d/50d
  nn6 = 2d/55d

  x0 = startpt[0]
  y0 = startpt[1]
  z0 = startpt[2]

  if (x0 lt xmin or x0 gt xmax or y0 lt ymin or y0 gt ymax or z0 lt zmin or z0 gt zmax) then begin
    print, "Error: Start point not in range"
    print, "Start point is:", x0,y0,z0
    if (x0 lt xmin or x0 gt xmax) then print, x0, " (x0) is the issue"
    if (y0 lt ymin or y0 gt ymax) then print, y0, " (y0) is the issue"
    if (z0 lt zmin or z0 gt zmax) then print, z0, " (z0) is the issue"
    print, "Bounds are: ", "xmin = ", xmin, " xmax = ", xmax
    print, "Bounds are: ", "ymin = ", ymin, " ymax = ", ymax
    print, "Bounds are: ", "zmin = ", zmin, " zmax = ", zmax

    return,0
  endif

  if not keyword_set(mxline) then mxline = 10000

  s = [0.]
  line = startpt

  ;##################################################

  if keyword_set(oneway) then ih = [h] else ih = [h,-h]
  foreach h, ih do begin

    count = 0
    out = 0
    
    if (h lt 0) then begin
      minh = -hmax
      maxh = -hmin
      hmin = minh
      hmax = maxh
    endif

    while count lt mxline do begin

      if h gt 0 then jl = count else jl = 0
      t = s[jl]
      xx = line[0,jl]
      yy = line[1,jl]
      zz = line[2,jl]
      
      hvec = [h,h,h]
      r0 = [xx,yy,zz]

      rt = r0
      b = trilinear_3d(rt[0],rt[1],rt[2],bgrid,x,y,z)
      k1 = hvec*b/sqrt(b[0]^2+b[1]^2+b[2]^2)
      rt = r0 + b2*k1

      if rt[0] lt xmin or rt[0] gt xmax or rt[1] lt ymin or rt[1] gt ymax or rt[2] lt zmin or rt[2] gt zmax then begin
        rout = rt
        out = 1 & break
      endif

      b = trilinear_3d(rt[0],rt[1],rt[2],bgrid,x,y,z)
      k2 = hvec*b/sqrt(b[0]^2+b[1]^2+b[2]^2)
      rt = r0 + b3*k1 + c3*k2

      if rt[0] lt xmin or rt[0] gt xmax or rt[1] lt ymin or rt[1] gt ymax or rt[2] lt zmin or rt[2] gt zmax then begin
        rout = rt
        out = 1 & break
      endif

      b = trilinear_3d(rt[0],rt[1],rt[2],bgrid,x,y,z)
      k3 = hvec*b/sqrt(b[0]^2+b[1]^2+b[2]^2)
      rt = r0 + b4*k1 + c4*k2 + d4*k3

      if rt[0] lt xmin or rt[0] gt xmax or rt[1] lt ymin or rt[1] gt ymax or rt[2] lt zmin or rt[2] gt zmax then begin
        rout = rt
        out = 1 & break
      endif

      b = trilinear_3d(rt[0],rt[1],rt[2],bgrid,x,y,z)
      k4 = hvec*b/sqrt(b[0]^2+b[1]^2+b[2]^2)
      rt = r0 + b5*k1 + c5*k2 + d5*k3 + e5*k4

      if rt[0] lt xmin or rt[0] gt xmax or rt[1] lt ymin or rt[1] gt ymax or rt[2] lt zmin or rt[2] gt zmax then begin
        rout = rt
        out = 1 & break
      endif

      b = trilinear_3d(rt[0],rt[1],rt[2],bgrid,x,y,z)
      k5 = hvec*b/sqrt(b[0]^2+b[1]^2+b[2]^2)
      rt = r0 + b6*k1 + c6*k2 + d6*k3 + e6*k4 + f6*k5

      if rt[0] lt xmin or rt[0] gt xmax or rt[1] lt ymin or rt[1] gt ymax or rt[2] lt zmin or rt[2] gt zmax then begin
        rout = rt
        out = 1 & break
      endif

      b = trilinear_3d(rt[0],rt[1],rt[2],bgrid,x,y,z)
      k6 = hvec*b/sqrt(b[0]^2+b[1]^2+b[2]^2)

      rtest4 = r0 + n1*k1 + n3*k3 + n4*k4 + n5*k5
      rtest5 = r0 + nn1*k1 + nn3*k3 + nn4*k4 + nn5*k5 + nn6*k6

      ;check that line is still in domain
      if rtest4[0] lt xmin or rtest4[0] gt xmax or rtest4[1] lt ymin or rtest4[1] gt ymax or rtest4[2] lt zmin or rtest4[2] gt zmax then begin
        rout = rtest4
        out = 1 & break
      endif

      ;optimum stepsize
      diff = rtest5 - rtest4
      err = sqrt(diff[0]^2 + diff[1]^2 + diff[2]^2)
      t = (epsilon*abs(h)/(2*err))^0.25 ; do we want to update this

      if t lt 0.1 then t = 0.1
      if t gt 4 then t = 4

      h = t*h
      if h lt hmin then h = hmin
      if h gt hmax then h = hmax
      
      count++

      if h gt 0 then begin
        s = [[s],t]
        line = [[line],[rtest4]]
      endif else begin
        s = [t,[s]]
        line = [[rtest4],[line]]
      endelse
    
      ;checkline is still moving
      if (count ge 2) then begin
        if h gt 0 then il = count-1 else il = 1
          dl = line[*,il]-line[*,il-1]
          mdl = sqrt(dl[0]^2+dl[1]^2+dl[2]^2)
        if (h gt 0 and mdl lt hmin*0.5) or (h lt 0 and mdl lt abs(hmax*0.5)) then break
      endif

    end

    if out eq 1 then begin
      if h gt 0 then il = count-1 else il = 0
        rin = line[*,il]
      if rout[0] gt xmax or rout[0] lt xmin then begin
        if rout[0] gt xmax then xedge = xmax else xedge = xmin
        s = (xedge-rin[0])/(rout[0]-rin[0])
        rout = [xedge, s*(rout[1]-rin[1])+rin[1], s*(rout[2]-rin[2])+rin[2]]
      endif
      if rout[1] gt ymax or rout[1] lt ymin then begin
        if rout[1] gt ymax then yedge = ymax else yedge = ymin
        s = (yedge-rin[1])/(rout[1]-rin[1])
        rout = [s*(rout[0]-rin[0])+rin[0], yedge, s*(rout[2]-rin[2])+rin[2]]
      endif
      if rout[2] gt zmax or rout[2] lt zmin then begin
        if rout[2] gt zmax then zedge = zmax else zedge = zmin
        s = (zedge-rin[2])/(rout[2]-rin[2])
        rout = [s*(rout[0]-rin[0])+rin[0], s*(rout[1]-rin[1])+rin[1], zedge]
      endif
      if h gt 0 then line = [[line],[rout]] else line = [[rout],[line]]
    endif

  endforeach

  return, line

end
