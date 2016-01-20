function bf2d,xp,yp,bx,by,x,y
  
;uses trilinear method to calculate the value of the magnetic field at
;the point (xp,yp) given bx and by on the grid of points (x,y)
  nx = n_elements(x)
  ny = n_elements(y)

  ix = where(x gt xp)
  if (ix(0) eq -1) then ix(0) = nx-1
  if (ix(0) eq 0) then ix(0) = 1
  x1 = x(ix(0)-1)
  x2 = x(ix(0))
  dx = (xp-x1)/(x2-x1)
  iy = where(y gt yp)
  if (iy(0) eq -1) then iy(0) = ny-1
  if (iy(0) eq 0) then iy(0) = 1
  y1 = y(iy(0)-1)
  y2 = y(iy(0))
  dy = (yp-y1)/(y2-y1)
  bx00 = bx(ix(0)-1,iy(0)-1) 
  bx10 = bx(ix(0),iy(0)-1) 
  bx01 = bx(ix(0)-1,iy(0)) 
  bx11 = bx(ix(0),iy(0)) 
  a1 = bx00
  b1 = bx10-bx00
  c1 = bx01-bx00
  d1 = bx11-bx10-bx01+bx00
  bxp = a1+b1*dx+c1*dy+d1*dx*dy
  by00 = by(ix(0)-1,iy(0)-1) 
  by10 = by(ix(0),iy(0)-1) 
  by01 = by(ix(0)-1,iy(0)) 
  by11 = by(ix(0),iy(0)) 
  a2 = by00
  b2 = by10-by00
  c2 = by01-by00
  d2 = by11-by10-by01+by00
  byp = a2+b2*dx+c2*dy+d2*dx*dy

return,[bxp,byp]
END


FUNCTION fieldline2d,startpt,bx,by,x,y,h,hmin,hmax,epsilon,mxline=mxline

; [x0,y0] - start point for field line
; bx[nx,ny],by[nx,ny] - magnetic field 
; x[nx],y[ny] - grid of points on which mag field given 

; h - initial step length
; hmin - minimum step length
; hmax - maximum step length
; epsilon - tolerance to which we require point on field line known
; mxline - maximum number of points along any one line - set to a large number

;define edges of box
xmin = min(x)
ymin = min(y)
xmax = max(x)
ymax = max(y)

a2 = 0.25
b2 = 0.25
a3 = 3./8. 
b3 = 3./32.
c3 = 9./32.
a4 = 12./13. 
b4 = 1932./2197.
c4 = -7200./2197.
d4 = 7296./2197.
a5 = 1.
b5 = 439./216. 
c5 = -8.
d5 = 3680./513.
e5 = -845./4104.
a6 = 0.5 
b6 = -8./27
c6 = 2. 
d6 = -3544./2565.
e6 = 1859./4104.
f6 = -11./40.

;used to determine y_i+1 from y_i if using rkf45 (4th order)
m1 = 25./216.
m3 = 1408./2565.
m4 = 2197./4104.
m5 = -1./5.
  
;used to determine y_i+1 from y_i if using rkf54 (5th order)
mm1 = 16./135.
mm3 = 6656./12825.
mm4 = 28561./56430.
mm5 = -9./50
mm6 = 2./55.

x0 = startpt(0)
y0 = startpt(1)

if x0 lt xmin or x0 gt xmax or y0 lt ymin or y0 gt ymax then begin
  print,"Error: Start point not in range" 
  return, startpt
endif

if not keyword_set(mxline) then mxline = 10000

s = [0.]
line = startpt

;##################################################

foreach h, [h,-h] do begin

  count = 0
  out = 0

  if h lt 0 then begin
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

    xx1 = xx
    yy1 = yy
    bbf = bf2d(xx1,yy1,bx,by,x,y)
    bbf2 = sqrt(bbf[0]*bbf[0]+bbf[1]*bbf[1])
    k1 = h*bbf[0]/bbf2
    l1 = h*bbf[1]/bbf2
    xx2 = xx + b2*k1
    yy2 = yy + b2*l1

    if not (xx2 gt xmin and xx2 lt xmax and yy2 gt ymin and yy2 lt ymax) then begin
      xout = xx2
      yout = yy2
      out = 1 & break
    endif

    bbf = bf2d(xx2,yy2,bx,by,x,y)
    bbf2 = sqrt(bbf[0]*bbf[0]+bbf[1]*bbf[1])
    k2 = h*bbf[0]/bbf2
    l2 = h*bbf[1]/bbf2
    xx3 = xx + b3*k1+c3*k2
    yy3 = yy + b3*l1+c3*l2

    if not (xx3 gt xmin and xx3 lt xmax and yy3 gt ymin and yy3 lt ymax) then begin
      xout = xx3
      yout = yy3
      out = 1 & break
    endif

    bbf = bf2d(xx3,yy3,bx,by,x,y)
    bbf2 = sqrt(bbf[0]*bbf[0]+bbf[1]*bbf[1])
    k3 = h*bbf[0]/bbf2
    l3 = h*bbf[1]/bbf2
    xx4 = xx + b4*k1+c4*k2+d4*k3
    yy4 = yy + b4*l1+c4*l2+d4*l3

    if not (xx4 gt xmin and xx4 lt xmax and yy4 gt ymin and yy4 lt ymax) then begin
      xout = xx4
      yout = yy4
      out = 1 & break
    endif

    bbf = bf2d(xx4,yy4,bx,by,x,y)
    bbf2 = sqrt(bbf[0]*bbf[0]+bbf[1]*bbf[1])
    k4 = h*bbf[0]/bbf2
    l4 = h*bbf[1]/bbf2
    xx5 = xx + b5*k1+c5*k2+d5*k3+e5*k4
    yy5 = yy + b5*l1+c5*l2+d5*l3+e5*l4

    if not (xx5 gt xmin and xx5 lt xmax and yy5 gt ymin and yy5 lt ymax) then begin
      xout = xx5
      yout = yy5
      out = 1 & break
    endif

    bbf = bf2d(xx5,yy5,bx,by,x,y)
    bbf2 = sqrt(bbf[0]*bbf[0]+bbf[1]*bbf[1])
    k5 = h*bbf[0]/bbf2
    l5 = h*bbf[1]/bbf2
    xx6 = xx + b6*k1+c6*k2+d6*k3+e6*k4+f6*k5
    yy6 = yy + b6*l1+c6*l2+d6*l3+e6*l4+f6*l5

    if not (xx6 gt xmin and xx6 lt xmax and yy6 gt ymin and yy6 lt ymax) then begin
      xout = xx6
      yout = yy6
      out = 1 & break
    endif

    bbf = bf2d(xx6,yy6,bx,by,x,y)
    bbf2 = sqrt(bbf[0]*bbf[0]+bbf[1]*bbf[1])
    k6 = h*bbf[0]/bbf2
    l6 = h*bbf[1]/bbf2

    xxnew4 = xx + m1*k1+m3*k3+m4*k4+m5*k5
    yynew4 = yy + m1*l1+m3*l3+m4*l4+m5*l5
    xxnew5 = xx + mm1*k1+mm3*k3+mm4*k4+mm5*k5+mm6*k6
    yynew5 = yy + mm1*l1+mm3*l3+mm4*l4+mm5*l5+mm6*l6

    ;check that line is still in domain
    if not (xxnew4 gt xmin and xxnew4 lt xmax and yynew4 gt ymin and yynew4 lt ymax) then begin
      xout = xxnew4
      yout = yynew4
      out = 1 & break
    endif

    ;optimum stepsize
    err = sqrt((xxnew5-xxnew4)^2 + (yynew5-yynew4)^2)
    t = (epsilon*abs(h)/(2*err))^0.25

    if t lt 0.1 then t = 0.1
    if t gt 4 then t = 4

    h = t*h
    if h lt hmin then h = hmin
    if h gt hmax then h = hmax

    count++

    if h gt 0 then begin
      s = [[s],t]
      line = [[line],[xxnew4,yynew4]]
    endif else begin
      s = [t,[s]]
      line = [[xxnew4,yynew4],[line]]
    endelse

    ;checkline is still moving
    if (count ge 2) then begin
      if h gt 0 then il = count-1 else il = 1
        dlx = line[0,il]-line[0,il-1]
        dly = line[1,il]-line[1,il-1]
        dl = sqrt(dlx*dlx+dly*dly)
      if (h gt 0 and dl lt hmin*0.5) or (h lt 0 and dl lt abs(hmax*0.5)) then break
    endif

  end

  if out eq 1 then begin
    if h gt 0 then il = count-1 else il = 0
      xin = line[0,il]
      yin = line[1,il]
    if xout gt xmax or xout lt xmin then begin
      if xout gt xmax then x0 = xmax else x0 = xmin
      s = (x0-xin)/(xout-xin)
      xout = x0
      yout = s*(yout-yin)+yin
    endif
    if yout gt ymax or yout lt ymin then begin
      if yout gt ymax then y0 = ymax else y0 = ymin
      s = (y0-yin)/(yout-yin)
      yout = y0
      xout = s*(xout-xin)+xin
    endif
    if h gt 0 then line = [[line],[xout,yout]] else line = [[xout,yout],[line]]
  endif

endforeach

return, line

end

;k1 = h*funbx(t,xx,yy)
;l1 = h*funby(t,xx,yy)

;k2 = h*funbx(t+a2*h,xx+b2*k1,yy+b2*l1)
;l2 = h*funby(t+a2*h,xx+b2*k1,yy+b2*l1)

;k3 = h*funbx(t+a3*h,xx+b3*k1+c3*k2,yy+b3*l1+c3*l2)
;l3 = h*funby(t+a3*h,xx+b3*k1+c3*k2,yy+b3*l1+c3*l2)

;k4 = h*funbx(t+a4*h,xx+b4*k1+c4*k2+d4*k3,yy+b4*l1+c4*l2+d4*l3)
;l4 = h*funby(t+a4*h,xx+b4*k1+c4*k2+d4*k3,yy+b4*l1+c4*l2+d4*l3)

;k5 = h*funbx(t+a5*h,xx+b5*k1+c5*k2+d5*k3+e5*k4,yy+b5*l1+c5*l2+d5*l3+e5*l4)
;l5 = h*funby(t+a5*h,xx+b5*k1+c5*k2+d5*k3+e5*k4,yy+b5*l1+c5*l2+d5*l3+e5*l4)

;k6 = h*funbx(t+a6*h,xx+b6*k1+c6*k2+d6*k3+e6*k4+f6*k5,yy+b6*l1+c6*l2+d6*l3+e6*l4+f6*l5)
;l6 = h*funby(t+a6*h,xx+b6*k1+c6*k2+d6*k3+e6*k4+f6*k5,yy+b6*l1+c6*l2+d6*l3+e6*l4+f6*l5)
