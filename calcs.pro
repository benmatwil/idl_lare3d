; Many calculations required for LARE and other .pro files
; Many assume a cubic grid for ease

;##################################################

function gdata, n, bgp=bgp, fast=fast, pressure=pressure
	
	if keyword_set(bgp) then begin
		data = getdata(n,/magnetic_field,/grid,/pressure)
	endif else begin
	  if keyword_set(fast) then begin
		  data = getdata(n,/magnetic_field,/grid,/pressure,/rho)
	  endif else begin
      if keyword_set(pressure) then begin
        data = getdata(n,/grid,/pressure)
	    endif else begin
		    data = getdata(n,/magnetic_field,/grid)
	    endelse
	  endelse
	endelse

return, data

end

;##################################################

function gridmove, grid

; moves a grid from vertices to centres or centres to vertices

  gridsize = size(grid)
  
  for i = 1, gridsize[0] do if gridsize[i] eq 1 then begin grid = reform(grid) & break & endif
  
  if gridsize[0] eq 2 then return, (grid[0:-2,0:-2] + grid[1:-1,0:-2] + grid[1:-1,1:-1] + grid[0:-2,1:-1])/4
  if gridsize[0] ge 3 then return, (grid[0:-2,0:-2,0:-2,*] + grid[1:-1,0:-2,0:-2,*] + $
                                    grid[1:-1,1:-1,0:-2,*] + grid[1:-1,0:-2,1:-1,*] + $
                                    grid[0:-2,1:-1,0:-2,*] + grid[0:-2,0:-2,1:-1,*] + $
                                    grid[0:-2,1:-1,1:-1,*] + grid[1:-1,1:-1,1:-1,*])/8

end

;##################################################

function fasttime, frame, recalculate=recalculate

  if keyword_set(recalculate) then begin
    d = gdata(frame,/fast)
    
    nx = d.grid.npts[0]-1
    ny = d.grid.npts[1]-1
    nz = d.grid.npts[2]-1
    
    bx = (d.bx[1:nx,*,*]+d.bx[0:nx-1,*,*])/2
    by = (d.by[*,1:ny,*]+d.by[*,0:ny-1,*])/2
    bz = (d.bz[*,*,1:nz]+d.bz[*,*,0:nz-1])/2
    
    b2 = bx^2+by^2+bz^2
    
    cf = d.rho/(b2+5*d.pressure/3)
    
    nx = d.grid.npts[0]-1
    ny = d.grid.npts[1]-1
    nz = d.grid.npts[2]-1
    
    tfxpos = total((cf[nx/2:nx-1,ny/2,ny/2]+cf[nx/2:nx-1,ny/2-1,nz/2]+cf[nx/2:nx-1,ny/2-1,nz/2-1]+cf[nx/2:nx-1,ny/2,nz/2-1])/(2*nx))
    tfxneg = total((cf[0:nx/2-1,ny/2,nz/2]+cf[0:nx/2-1,ny/2-1,nz/2]+cf[0:nx/2-1,ny/2-1,nz/2-1]+cf[0:nx/2-1,ny/2,nz/2-1])/(2*nx))
    
    tfypos = total((cf[nx/2,ny/2:ny-1,nz/2]+cf[nx/2,ny/2:ny-1,nz/2-1]+cf[nx/2-1,ny/2:ny-1,nz/2]+cf[nx/2-1,ny/2:ny-1,nx/2-1])/(2*ny))
    tfyneg = total((cf[nx/2,0:ny/2-1,nz/2]+cf[nx/2,0:ny/2-1,nz/2-1]+cf[nx/2-1,0:ny/2-1,nz/2]+cf[nx/2-1,0:ny/2-1,nx/2-1])/(2*ny))
    
    tfzpos = total((cf[nx/2,ny/2,nz/2:nz-1]+cf[nx/2,ny/2-1,nz/2:nz-1]+cf[nx/2-1,ny/2,nz/2:nz-1]+cf[nx/2-1,ny/2-1,nz/2:nz-1])/(2*nz))
    tfzneg = total((cf[nx/2,ny/2,0:nz/2-1]+cf[nx/2,ny/2-1,0:nz/2-1]+cf[nx/2-1,ny/2,0:nz/2-1]+cf[nx/2-1,ny/2-1,0:nz/2-1])/(2*nz))
  
    return, min([tfxpos, tfxneg, tfypos, tfyneg, tfzpos, tfzneg])
  endif else return, 0.38636466249575013d0
  ;b2
  ;0.30064919395138334
  
  ;b1
  ;0.38636466249575013
  ;0.38636369633363948
  
  ;b0.5
  ;0.44417571392523025
  ;0.44417541373613512
  ;0.44417421298401794

end

;##################################################

function bgradp, d

; defined at the centre of cells

  nx = d.grid.npts[0]-1
  ny = d.grid.npts[1]-1
  nz = d.grid.npts[2]-1
  
  px = dblarr(nx-1,ny,nz)
  py = dblarr(nx,ny-1,nz)
  pz = dblarr(nx,ny,nz-1)
  
  for i = 0, nx-2 do px[i,*,*] = (d.pressure[i+1,*,*]-d.pressure[i,*,*])/(d.x[i+1]-d.x[i])
  for i = 0, ny-2 do py[*,i,*] = (d.pressure[*,i+1,*]-d.pressure[*,i,*])/(d.y[i+1]-d.y[i])
  for i = 0, nz-2 do pz[*,*,i] = (d.pressure[*,*,i+1]-d.pressure[*,*,i])/(d.z[i+1]-d.z[i])
  
  bgradpx = d.bx[1:-2,*,*]*px
  bgradpy = d.by[*,1:-2,*]*py
  bgradpz = d.bz[*,*,1:-2]*pz
  
  px = !null
  py = !null
  pz = !null
  
  bgpx = bgradpx[0:-2,1:-2,1:-2]+bgradpx[1:-1,1:-2,1:-2]
  bgpy = bgradpy[1:-2,0:-2,1:-2]+bgradpy[1:-2,1:-1,1:-2]
  bgpz = bgradpz[1:-2,1:-2,0:-2]+bgradpz[1:-2,1:-2,1:-1]

  return, (bgpx + bgpy + bgpz)/2 ; corrected this... CHECK!

end

;##################################################

function jx, d

; defined in the middle of the edge between Bz and By

  nx = d.grid.npts[0]-1
  ny = d.grid.npts[1]-1
  nz = d.grid.npts[2]-1

  dbzdy = dblarr(nx,ny-1,nz+1)
  dbydz = dblarr(nx,ny+1,nz-1)

  for i = 0, ny-2 do dbzdy[*,i,*] = (d.bz[*,i+1,*]-d.bz[*,i,*])/(d.y[i+1]-d.y[i])
  for i = 0, nz-2 do dbydz[*,*,i] = (d.by[*,*,i+1]-d.by[*,*,i])/(d.z[i+1]-d.z[i])

  return, dbzdy[*,*,1:nz-1] - dbydz[*,1:ny-1,*]

end

;##################################################

function jy, d

; defined in the middle of the edge between Bz and Bx

  nx = d.grid.npts[0]-1
  ny = d.grid.npts[1]-1
  nz = d.grid.npts[2]-1

  dbxdz = dblarr(nx+1,ny,nz-1)
  dbzdx = dblarr(nx-1,ny,nz+1)

  for i = 0, nz-2 do dbxdz[*,*,i] = (d.bx[*,*,i+1]-d.bx[*,*,i])/(d.z[i+1]-d.z[i])
  for i = 0, nx-2 do dbzdx[i,*,*] = (d.bz[i+1,*,*]-d.bz[i,*,*])/(d.x[i+1]-d.x[i])

  return, dbxdz[1:nx-1,*,*] - dbzdx[*,*,1:nz-1]

end

;##################################################

function jz, d

; defined in the middle of the edge between Bx and By

  nx = d.grid.npts[0]-1
  ny = d.grid.npts[1]-1
  nz = d.grid.npts[2]-1

  dbydx = dblarr(nx-1,ny+1,nz)
  dbxdy = dblarr(nx+1,ny-1,nz)

  for i = 0, nx-2 do dbydx[i,*,*] = (d.by[i+1,*,*]-d.by[i,*,*])/(d.x[i+1]-d.x[i])
  for i = 0, ny-2 do dbxdy[*,i,*] = (d.bx[*,i+1,*]-d.bx[*,i,*])/(d.y[i+1]-d.y[i])

  return, dbydx[*,1:ny-1,*] - dbxdy[1:nx-1,*,*]


end

;##################################################

function jcrossbx, d

; defined at the corner where velocity is

  bz = (d.bz[1:-1,*,*]+d.bz[0:-2,*,*])/2
  by = (d.by[1:-1,*,*]+d.by[0:-2,*,*])/2
  
  jybz = jy(d)*bz[*,*,1:-2]
  jzby = jz(d)*by[*,1:-2,*]

  return, (jybz[*,0:-2,*]+jybz[*,1:-1,*] - (jzby[*,*,0:-2]+jzby[*,*,1:-1]))/2

end

;##################################################

function jcrossby, d

; defined at the corner where velocity is

  bx = (d.bx[*,1:-1,*]+d.bx[*,0:-2,*])/2
  bz = (d.bz[*,1:-1,*]+d.bz[*,0:-2,*])/2

  jzbx = jz(d)*bx[1:-2,*,*] 
  jxbz = jx(d)*bz[*,*,1:-2]

  return, (jzbx[*,*,0:-2]+jzbx[*,*,1:-1] - (jxbz[0:-2,*,*]+jxbz[1:-1,*,*]))/2

end

;##################################################

function jcrossbz, d

; defined at the corner where velocity is

  by = (d.by[*,*,1:-1]+d.by[*,*,0:-2])/2
  bx = (d.bx[*,*,1:-1]+d.bx[*,*,0:-2])/2

  jxby = jx(d)*by[*,1:-2,*]
  jybx = jy(d)*bx[1:-2,*,*]

  return, (jxby[0:-2,*,*]+jxby[1:-1,*,*] - (jybx[*,0:-2,*]+jybx[*,1:-1,*]))/2

end

;##################################################

pro evoj, n

; calculates the maximum J at each frame (needs sorting)

  maxj = dblarr(n+1,3)

  times = 2*indgen(n)

  for j = 0, 2 do begin

	  for i = 0, n do begin
		
	  	jgrid = mkjg(gdata[i])
	
	  	modj = sqrt(vecmag2[jgrid])
		
	  	maxj[i,j] = max(modj[nx/4:3*nx/4,ny/4:3*ny/4,nz/4:3*nz/4])
	  	print, i
		
	  endfor
    if j eq 0 then plot, times, maxj[*,0], yr = [0,16], xtitle = 'time', title = 'Evolution of max current'
	  if j ne 0 then oplot, times, maxj[*,j], col = 100*j

	  if j eq 0 then cd, '../j2'
	  if j eq 1 then cd, '../j0.5'

  endfor

oplot, [25,30], [10,10], col = 100
xyouts, 32, 9.8, 'J = 2'
oplot, [25,30], [11,11]
xyouts, 32, 10.8, 'J = 1'
oplot, [25,30], [12,12], col = 200
xyouts, 32, 11.8, 'J = 0.5'

CD, '../j1'

SAVE, maxj, FILENAME = 'evocurrents.sav'

end

;##################################################

function mkbg, d, vertex=vertex

; makes the magnetic field at the centres or vertices (/v) of each grid cell

  if keyword_set(vertex) then begin
	  
	  bgrid = dblarr(d.grid.npts[0]-2,d.grid.npts[1]-2,d.grid.npts[2]-2,3)
	  
    bgrid[*,*,*,0] = d.bx[1:-2,0:-2,0:-2] + d.bx[1:-2,0:-2,1:-1] + d.bx[1:-2,1:-1,0:-2] + d.bx[1:-2,1:-1,1:-1]
    bgrid[*,*,*,1] = d.by[0:-2,1:-2,0:-2] + d.by[0:-2,1:-2,1:-1] + d.by[1:-1,1:-2,0:-2] + d.by[1:-1,1:-2,1:-1]
    bgrid[*,*,*,2] = d.bz[0:-2,0:-2,1:-2] + d.bz[0:-2,1:-1,1:-2] + d.bz[1:-1,0:-2,1:-2] + d.bz[1:-1,1:-1,1:-2]
   
    bgrid = temporary(bgrid)/4
    
  endif else begin
  
	  bgrid = dblarr(d.grid.npts[0]-1,d.grid.npts[1]-1,d.grid.npts[2]-1,3)

	  bgrid[*,*,*,0] = d.bx[0:-2,*,*]+d.bx[1:-1,*,*]
	  bgrid[*,*,*,1] = d.by[*,0:-2,*]+d.by[*,1:-1,*]
	  bgrid[*,*,*,2] = d.bz[*,*,0:-2]+d.bz[*,*,1:-1]
	  
	  bgrid = temporary(bgrid)/2
	  
  endelse
  
return, bgrid

end 

;##################################################

function mkjg, d

; makes current grid at the vertices of the grid
	
	j0 = jx(d)
	j1 = jy(d)
	j2 = jz(d)
	
	;move J onto the vertices.
	jgrid = dblarr(d.grid.npts[0]-2, d.grid.npts[1]-2, d.grid.npts[2]-2, 3)
	jgrid[*,*,*,0] = (j0[0:-2,*,*]+j0[1:-1,*,*])/2
	jgrid[*,*,*,1] = (j1[*,0:-2,*]+j1[*,1:-1,*])/2
	jgrid[*,*,*,2] = (j2[*,*,0:-2]+j2[*,*,1:-1])/2

  return, jgrid

end

;##################################################

function mkeg, d, bgrid=bgrid, jgrid=jgrid

; makes electric field grid at the vertices of the grid

  if bgrid ne !null then begin
    bgrid1 = bgrid
    bgrid = gridmove(bgrid)
    delete = 0
  endif else begin
    bgrid = mkbg(d,/v)
    delete = 1
  endelse
	vgrid = bgrid
  vgrid[*,*,*,0] = d.vx[1:-2,1:-2,1:-2]
  vgrid[*,*,*,1] = d.vy[1:-2,1:-2,1:-2]
  vgrid[*,*,*,2] = d.vz[1:-2,1:-2,1:-2]
  
  vcrossb = bgrid
  for i = -3,-1 do vcrossb[*,*,*,i] = bgrid[*,*,*,i+2]*vgrid[*,*,*,i+1] - bgrid[*,*,*,i+1]*vgrid[*,*,*,i+2]
  if delete eq 1 then bgrid = !null else bgrid = bgrid1
  vgrid = !null
  if (size(jgrid))[0] ne 4 then jgrid = mkjg(d)
  egrid = jgrid
  eta = gridmove(d.eta)

  for i = 0, 2 do egrid[*,*,*,i] = eta*jgrid[*,*,*,i] - vcrossb[*,*,*,i]

  return, egrid

end

;##################################################

function mkvg, d
  
  vgrid = dblarr(d.grid.npts[0],d.grid.npts[1],d.grid.npts[2],3)
  vgrid[*,*,*,0] = d.vx
  vgrid[*,*,*,1] = d.vy
  vgrid[*,*,*,2] = d.vz
  
  return, vgrid

end

;##################################################

function mkvortg, d

  nx = d.grid.npts[0]-1
	ny = d.grid.npts[1]-1
	nz = d.grid.npts[2]-1

  curlv = dblarr(nx,ny,nz,3)
  dv1 = dblarr(nx,ny,nz)
  dv2 = dblarr(nx,ny,nz)
	
	for i = 0, ny-1 do dv1[*,i,*] = gridmove(d.vz[*,i+1,*] - d.vz[*,i,*])/(d.grid.y[i+1] - d.grid.y[i])
	for i = 0, nz-1 do dv2[*,*,i] = gridmove(d.vy[*,*,i+1] - d.vy[*,*,i])/(d.grid.z[i+1] - d.grid.z[i])
	
	curlv[*,*,*,0] = dv1 - dv2

	for i = 0, nz-1 do dv1[*,*,i] = gridmove(d.vx[*,*,i+1] - d.vx[*,*,i])/(d.grid.z[i+1] - d.grid.z[i])
	for i = 0, nx-1 do dv2[i,*,*] = gridmove(d.vz[i+1,*,*] - d.vz[i,*,*])/(d.grid.x[i+1] - d.grid.x[i])
	
	curlv[*,*,*,1] = dv1 - dv2
	
	for i = 0, nx-1 do dv1[i,*,*] = gridmove(d.vy[i+1,*,*] - d.vy[i,*,*])/(d.grid.x[i+1] - d.grid.x[i])
	for i = 0, ny-1 do dv2[*,i,*] = gridmove(d.vx[*,i+1,*] - d.vx[*,i,*])/(d.grid.y[i+1] - d.grid.y[i])
	
	curlv[*,*,*,2] = dv1 - dv2
	
	return, curlv
	
end

;##################################################

function mkvortg1, d

  nx = d.grid.npts[0]-1
	ny = d.grid.npts[1]-1
	nz = d.grid.npts[2]-1

  curlv = dblarr(nx-1,ny-1,nz-1,3)
  
  dv1 = dblarr(nx+1,ny,nz+1)
  dv2 = dblarr(nx+1,ny+1,nz)
	for i = 0, ny-1 do dv1[*,i,*] = (d.vz[*,i+1,*] - d.vz[*,i,*])/(d.grid.y[i+1] - d.grid.y[i])
	dv1 = (dv1[*,0:ny-2,*]+dv1[*,1:ny-1,*])/2
	for i = 0, nz-1 do dv2[*,*,i] = (d.vy[*,*,i+1] - d.vy[*,*,i])/(d.grid.z[i+1] - d.grid.z[i])
	dv2 = (dv2[*,*,0:nz-2]+dv2[*,*,1:nz-1])/2
	
	curlv[*,*,*,0] = dv1[1:nx-1,*,1:nz-1] - dv2[1:nx-1,1:ny-1,*]

	dv1 = dblarr(nx+1,ny+1,nz)
  dv2 = dblarr(nx,ny+1,nz+1)
	for i = 0, nz-1 do dv1[*,*,i] = (d.vx[*,*,i+1] - d.vx[*,*,i])/(d.grid.z[i+1] - d.grid.z[i])
	dv1 = (dv1[*,*,0:nz-2]+dv1[*,*,1:nz-1])/2
	for i = 0, nx-1 do dv2[i,*,*] = (d.vz[i+1,*,*] - d.vz[i,*,*])/(d.grid.x[i+1] - d.grid.x[i])
	dv2 = (dv2[0:nx-2,*,*]+dv2[1:nx-1,*,*])/2
	
	curlv[*,*,*,1] = dv1[1:nx-1,1:ny-1,*] - dv2[*,1:ny-1,1:nz-1]
	
	dv1 = dblarr(nx,ny+1,nz+1)
  dv2 = dblarr(nx+1,ny,nz+1)
	for i = 0, nx-1 do dv1[i,*,*] = (d.vy[i+1,*,*] - d.vy[i,*,*])/(d.grid.x[i+1] - d.grid.x[i])
	dv1 = (dv1[0:nx-2,*,*]+dv1[1:nx-1,*,*])/2
	for i = 0, ny-1 do dv2[*,i,*] = (d.vx[*,i+1,*] - d.vx[*,i,*])/(d.grid.y[i+1] - d.grid.y[i])
	dv2 = (dv2[*,0:ny-2,*]+dv2[*,1:ny-1,*])/2
	
	curlv[*,*,*,2] = dv1[*,1:ny-1,1:nz-1] - dv2[1:nx-1,*,1:nz-1]
	
	return, curlv
	
end

;##################################################

function mkjxbg, d

  
  jxbgrid = dblarr(d.grid.npts[0]-2,d.grid.npts[1]-2,d.grid.npts[2]-2,3)
  jxbgrid[*,*,*,0] = jcrossbx(d)
  jxbgrid[*,*,*,1] = jcrossby(d)
  jxbgrid[*,*,*,2] = jcrossbz(d)
  
  return, jxbgrid

end

;##################################################

function mkgradpg, d

  nx = d.grid.npts[0]-1
  ny = d.grid.npts[1]-1
  nz = d.grid.npts[2]-1
  
  px = dblarr(nx-1,ny,nz)
  py = dblarr(nx,ny-1,nz)
  pz = dblarr(nx,ny,nz-1)
  
  for i = 0, nx-2 do px[i,*,*] = (d.pressure[i+1,*,*]-d.pressure[i,*,*])/(d.x[i+1]-d.x[i])
  for i = 0, ny-2 do py[*,i,*] = (d.pressure[*,i+1,*]-d.pressure[*,i,*])/(d.y[i+1]-d.y[i])
  for i = 0, nz-2 do pz[*,*,i] = (d.pressure[*,*,i+1]-d.pressure[*,*,i])/(d.z[i+1]-d.z[i])
  
  pgrid = dblarr(nx-1,ny-1,nz-1,3)
  
  px = px[*,0:ny-2,*] + px[*,1:ny-1,*]
  px = px[*,*,0:nz-2] + px[*,*,1:nz-1]
  py = py[0:nx-2,*,*] + py[1:nx-1,*,*]
  py = py[*,*,0:nz-2] + py[*,*,1:nz-1]
  pz = pz[*,0:ny-2,*] + pz[*,1:ny-1,*]
  pz = pz[0:nx-2,*,*] + pz[1:nx-1,*,*]
  
  pgrid[*,*,*,0] = px
  pgrid[*,*,*,1] = py
  pgrid[*,*,*,2] = pz
  
  return, pgrid/4

end

;##################################################

function dotgrid, a, b

; calculates the dot product of two grids

  return, a[*,*,*,0] * b[*,*,*,0] + a[*,*,*,1] * b[*,*,*,1] + a[*,*,*,2] * b[*,*,*,2]

end

;##################################################

function dotvec, a, b

; calculates the dot product of two vectors

  ;na = n_elements(a)
  ;nb = n_elements(b)
  ;if na ne nb then print, "Vectors not the same size, making the same size..."
  ;if na lt nb then a = [a, make_array(nb-na, type=size(a,/type))]
  ;if na gt nb then b = [b, make_array(na-nb, type=size(b,/type))]

  return, total(a*b)

end

;##################################################

function vecmag2, grid

; calculates the square of the magnitude of a vector grid
  
  return, grid[*,*,*,0]^2 + grid[*,*,*,1]^2 + grid[*,*,*,2]^2

end

;##################################################

function pbeta, d

;calculates the plasma beta

  return, 2*d.pressure/vecmag2(mkbg(d))

end

;##################################################

function absjperp, d

; calculates the absolute value of the component of J perpendicular to B

  bg = mkbg(d,/v)
  jg = mkjg(d)
	modbv2 = vecmag2(bg)
	modj2 = vecmag2(jg)
	jb = dotgrid(jg,bg)

  return, sqrt(abs(modj2 - jb^2/modbv2))

end

;##################################################

function jparallel, d

; calculates component of J parallel to B

  bg = mkbg(d,/v)
	modbv2 = vecmag2(bg)
	jb = dotgrid(bg,mkjg(d))

  return, jb/sqrt(modbv2)

end

;##################################################

function absjparallel, d

; calculates the absolute value of the component of J parallel to B

  return, abs(jparallel(d))

end

;##################################################

function jacobian, d

; calculates the jacobian for a null at the centre of the grid

  bgrid = mkbg(d)

  nx = (size(bgrid))[1]
  ny = (size(bgrid))[2]
  nz = (size(bgrid))[3]

  bgrid = bgrid[nx/2:nx/2+1,ny/2:ny/2+1,nz/2:nz/2+1,*]

  b11 = reform(bgrid[0,0,0,*] + bgrid[0,1,0,*] + bgrid[0,0,1,*] + bgrid[0,1,1,*])/4
  b12 = reform(bgrid[1,0,0,*] + bgrid[1,1,0,*] + bgrid[1,0,1,*] + bgrid[1,1,1,*])/4
  j1 = (b12 - b11)/(d.x[nx/2+1]-d.x[nx/2])

  b21 = reform(bgrid[0,0,0,*] + bgrid[0,0,1,*] + bgrid[1,0,0,*] + bgrid[1,0,1,*])/4
  b22 = reform(bgrid[0,1,0,*] + bgrid[0,1,1,*] + bgrid[1,1,0,*] + bgrid[1,1,1,*])/4
  j2 = (b22 - b21)/(d.y[ny/2+1]-d.y[ny/2])

  b31 = reform(bgrid[0,0,0,*] + bgrid[0,1,0,*] + bgrid[1,0,0,*] + bgrid[1,1,0,*])/4
  b32 = reform(bgrid[0,0,1,*] + bgrid[0,1,1,*] + bgrid[1,0,1,*] + bgrid[1,1,1,*])/4
  j3 = (b32 - b31)/(d.z[nz/2+1]-d.z[nz/2])

  return, [[j1[0],j2[0],j3[0]],[j1[1],j2[1],j3[1]],[j1[2],j2[2],j3[2]]]

end

;##################################################

function eparallel, d

; calculates the components of E parallel to B

  return, gridmove(jparallel(d))*d.eta[1:-2,1:-2,1:-2]

end

;##################################################

function intepar, d, fl, egrid

; calculates the integral of E parallel along a set of fieldlines defined by points in fl
; returns the integral and the length of the field line the calculation is done on

  nx = d.grid.npts[0]-2
  ny = d.grid.npts[1]-2
  nz = d.grid.npts[2]-2

  n = n_elements(fl)/3-1
  midpts = (fl[*,0:n-1] + fl[*,1:n])/2
  vecs = fl[*,1:n]-fl[*,0:n-1]
  dists = sqrt((vecs[0,0:n-1])^2+(vecs[1,0:n-1])^2+(vecs[2,0:n-1])^2)
  integral = dblarr(n)
  
  for j = 0, n-1 do begin
    evec = trilinear_3d(midpts[0,j],midpts[1,j],midpts[2,j],egrid,d.grid.x[1:nx],d.grid.y[1:ny],d.grid.z[1:nz])
    integral[j] = dotvec(evec,vecs[*,j])
  endfor
  
  return, [total(integral),total(dists)]
  
end

;##################################################

function posfinder, value, posgrid

  foreach pos, posgrid, i do begin
    if value lt pos then break
  endforeach
  
  return, i-1

end

;OLD INTEGRAL OF EPARALLEL CODE
;    for j = 0, n-1 do begin
;      evec = trilinear_3d(midpts(0,j),midpts(1,j),midpts(2,j),egrid,d.grid.x(1:nx),d.grid.y(1:ny),d.grid.z(1:nz))
;      bvec = trilinear_3d(midpts(0,j),midpts(1,j),midpts(2,j),bgrid,d.x,d.y,d.z)
;      epvec = dotvec(evec,bvec)*bvec/dotvec(bvec,bvec)
;      integral[j] = dotvec(epvec,vecs(*,j))
;    endfor
    
;    for j = 0, n-1 do begin
;      evec = trilinear_3d(midpts(0,j),midpts(1,j),midpts(2,j),egrid,d.grid.x(1:nx),d.grid.y(1:ny),d.grid.z(1:nz))
;      bvec = trilinear_3d(midpts(0,j),midpts(1,j),midpts(2,j),bgrid,d.x,d.y,d.z)
;      ep = dotvec(evec,bvec)/sqrt(dotvec(bvec,bvec))
;      integral[j] = ep*dists[j]
;    endfor
