pro lare_to_msat, id, out

  d = getdata(id, /grid, /magnetic_field)
  
  bx = (d.bx[0:-2, *, *] + d.bx[1:-1, *, *])/2
  by = (d.by[*, 0:-2, *] + d.by[*, 1:-1, *])/2
  bz = (d.bz[*, *, 0:-2] + d.bz[*, *, 1:-1])/2
  
  bx = bx[*, 1:-1, 1:-1] ; confirmed z
  by = by[1:-1, *, 1:-1] ; confirmed z
  bz = bz[1:-1, 1:-1, *] ; confirmed x
  
  x = (d.grid.x[0:-2] + d.grid.x[1:-1])/2
  y = (d.grid.y[0:-2] + d.grid.y[1:-1])/2
  z = (d.grid.z[0:-2] + d.grid.z[1:-1])/2
  
  openw, 1, out + '/flux_' + string(id, '(I4.4)') + '.dat'
  writeu, 1, d.grid.npts-1
  writeu, 1, bx, by, bz
  writeu, 1, x, y, z
  close, 1

end
