pro wavefronts1

  stpts = [[-0.22d,-0.8d],[-0.15d,-0.6d],[0,-0.23d],[0.15d,-0.6d],[0.22d,-0.8d]]

  points = dblarr(2,n_elements(stpts)*3/2)

  ;cplot, /current, xz=0, fr=25, diff=25, /png, mmlev=0.25*[-1,1], plotposition = [stpts[0,*],stpts[2,*]]

  for i = 0, 4 do for j = 0, 2 do points[*,3*i+j] = stpts[*,i]

  ;set-up
  gam = 5d/3d
  d = getdata(25, /grid)
  nx = n_elements(d.x)
  ny = n_elements(d.y)
  nz = n_elements(d.z)
  d = !null
  sg = dblarr(nx,ny,nz,3)
  npts = n_elements(points)/2
  sp = dblarr(npts,2)
  dir = dblarr(2,npts,2)
  time = dblarr(2)
  col = ['Green', 'Blue', 'Red']
  ;for j = 0, npts-1 do begin
  ;  if j le 17 then neg = -1 else neg = 1
  ;  if j mod 6 le 2 then dir[*,j] = neg*[1,0,0] else dir[*,j] = [0,0,1]
  ;endfor

  for i = 26, 45 do begin
    for k = 1, 0, -1 do begin
      d = getdata(i-k, /grid, /magnetic_field, /pressure, /rho)
      bgrid = mkbg(d)
      sg[*,*,*,0] = sqrt(gam*d.pressure/d.rho)
      sg[*,*,*,1] = sqrt(vecmag2(bgrid)/d.rho)
      sg[*,*,*,2] = sqrt(sg[*,*,*,0]^2+sg[*,*,*,1]^2)
      for j = 0, npts-1 do begin
        sp[j,1-k] = trilinear_3d(points[0,j], 0, points[1,j], sg[*,*,*,j mod 3], d.x, d.y, d.z)
        dir1 = trilinear_3d(points[0,j], 0, points[1,j], bgrid, d.x, d.y, d.z)
        dir1 = [dir1[0],dir1[2]]
        dir[*,j,1-k] = dir1/sqrt(dotvec(dir1,dir1))
      endfor
      time[1-k] = d.time
      bgrid = !null
      d = !null
    endfor
    dt = (time[1]-time[0])/2
    for j = 0, npts-1 do points[*,j] = points[*,j] + 0.5*(dir[*,j,0]*sp[j,0]+dir[*,j,1]*sp[j,1])*dt
    cplot, /current, xz=0, fr=i, diff=25, mmlev=0.25*[-1,1], cplt=cplt, filename=filename
    for k = 0, npts-1 do plt = plot([points[0,k],points[0,k]], [points[1,k],points[1,k]], symbol="+", color=col[k mod 3], /overplot)
    filename = strjoin(strsplit(filename, '.p', /extract, /regex),'speed.p')
    cplt.save, filename, width=1000 & cplt.close & print, "Saved as " + filename
  endfor

end

pro wavefronts

  stpts = [[-0.22d,-0.8d],[-0.15d,-0.6d],[0,-0.23d],[0.15d,-0.6d],[0.22d,-0.8d]]

  ;points = dblarr(2,n_elements(stpts)*2/2)

  ;cplot, /current, xz=0, fr=25, diff=25, /png, mmlev=0.25*[-1,1], plotposition = [stpts[0,*],stpts[2,*]]

  ;for i = 0, 4 do for j = 0, 1 do points[*,2*i+j] = stpts[*,i]
  points = [[stpts],[stpts]]

  ;set-up
  gam = 5d/3d
  d = getdata(25, /grid)
  nx = n_elements(d.x)
  ny = n_elements(d.y)
  nz = n_elements(d.z)
  d = !null
  sg = dblarr(nx,ny,nz,3)
  npts = n_elements(points)/2
  sp = dblarr(npts,2)
  dir = dblarr(2,npts,2)
  time = dblarr(2)
  col = 'Green'

  for i = 26, 65 do begin
  print, i
    for k = 1, 0, -1 do begin
      d = getdata(i-k, /grid, /magnetic_field, /pressure, /rho)
      bgrid = mkbg(d)
      sg = sqrt(vecmag2(bgrid)/d.rho)
      for j = 0, npts-1 do begin
        sp[j,1-k] = trilinear_3d(points[0,j], 0, points[1,j], sg, d.x, d.y, d.z)
        if j le npts/2-1 then neg = 1 else neg = -1
        dir1 = trilinear_3d(points[0,j], 0, points[1,j], bgrid, d.x, d.y, d.z)
        dir1 = [dir1[0],dir1[2]]
        dir[*,j,1-k] = neg*dir1/sqrt(dotvec(dir1,dir1))
      endfor
      time[1-k] = d.time
      bgrid = !null
      d = !null
      sg = !null
    endfor
    
    dt = (time[1]-time[0])/2
    
    for j = 0, npts-1 do points[*,j] = points[*,j] + (dir[*,j,0]*sp[j,0]+dir[*,j,1]*sp[j,1])*dt
    
    if i eq 35 then begin
      cplot, /current, xz=0, fr=i, diff=25, smlev=0.02, cplt=cplt, filename=filename, plotpositions=points, /notitle
      filename = strjoin(strsplit(filename, '.p', /extract, /regex),'speed2.p')
      cplt.save, filename, width=1000 & cplt.close & print, "Saved as " + filename
      stop
    endif
    
    ;for k = 0, npts-1 do if abs(points[0,k]) lt 1 and abs(points[1,k]) lt 1 then plt = plot([points[0,k],points[0,k]], [points[1,k],points[1,k]], symbol="+", color=col, /overplot)
    
    ;if cplt['axis2'] ne !null then cplt['axis2'].delete
    ;if cplt['axis3'] ne !null then cplt['axis3'].delete
    ;cplt.xtickdir = 1
    ;cplt.ytickdir = 1
    
    
    
  endfor

end
