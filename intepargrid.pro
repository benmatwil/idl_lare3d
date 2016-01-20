function intepargrid, dat, zval, irregular=irregular, regular=regular

  minx = -0.5d
  maxx = 0.5d
  miny = -0.5d
  maxy = 0.5d
  i = 0LL
  if keyword_set(irregular) then begin
    np = 100L
    stpt = dblarr(3,28*np^2)
    for ix = 0, np-1 do begin
      for iy = 0, 4*np-1 do begin
        stpt(0,i) = (-0.5-minx)*ix/np+minx
        stpt(1,i) = (maxy-miny)*iy/(4*np)+miny
        i++
      endfor
    endfor
    for ix = 0, np-1 do begin
      for iy = 0, 4*np-1 do begin
        stpt(0,i) = (maxx-0.5)*ix/np+0.5
        stpt(1,i) = (maxy-miny)*iy/(4*np)+miny
        i++
      endfor
    endfor
    for ix = 0, 2*np-1 do begin
      for iy = 0, np-1 do begin
        stpt(0,i) = ix/double(2*np)-0.5
        stpt(1,i) = (maxy-0.5)*iy/np+0.5
        i++
      endfor
    endfor
    for ix = 0, 2*np-1 do begin
      for iy = 0, np-1 do begin
        stpt(0,i) = ix/double(2*np)-0.5
        stpt(1,i) = (-0.5-miny)*iy/np+miny
        i++
      endfor
    endfor
    for ix = 0, 4*np-1 do begin
      for iy = 0, 4*np-1 do begin
        stpt(0,i) = ix/double(4*np)-0.5
        stpt(1,i) = iy/double(4*np)-0.5
        i++
      endfor
    endfor
    stpt(2,*) = zval
  endif
  if keyword_set(regular) then begin
    stpt = dblarr(3,regular^2)
    for ix = 0, regular-1 do begin
      for iy = 0, regular-1 do begin
      stpt(0,i) = (maxx-minx)*ix/(regular-1)+minx
      stpt(1,i) = (maxy-miny)*iy/(regular-1)+miny
      i++
      endfor
    endfor
    stpt(2,*) = zval
  endif
  
  ;stpt = dblarr(3,n_elements(nt)*n_elements(nr))
  ;i=0
    ;foreach t, nt do begin
    ;  foreach r, nr do begin
    ;    stpt(0,i) = r*cos(t)
    ;    stpt(1,i) = r*sin(t)
    ;    i++
    ;  endforeach
    ;endforeach
    
  return, stpt

end
