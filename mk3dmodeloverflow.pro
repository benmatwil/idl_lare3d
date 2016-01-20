  if keyword_set(bval) then begin
  
    dx = xx[1]-xx[0]
    dy = yy[1]-yy[0]
    dz = zz[1]-zz[0]

    bx = bgrid[*,*,*,0]
    by = bgrid[*,*,*,1]
    bz = bgrid[*,*,*,2]

    bmag = sqrt(bx*bx+by*by+bz*bz)
    shade_volume,bmag,bval,vert,poly

    vert[0,*]=vert[0,*]*dx+xx[0]
    vert[1,*]=vert[1,*]*dy+yy[0]
    vert[2,*]=vert[2,*]*dz+zz[0]

    oSurface=obj_new(keyword_set(wireframe)? "IDLgrPolyline" : $
      "IDLgrPolygon",data=vert,polygons=poly,color=[64,0,0])
    oModel->add,oSurface
    
  endif
  
  if keyword_set(jval) then begin
  	
  	jmag = sqrt(vecmag2(mkjg(data)))
  	
  	shade_volume,jmag,jval,vert,poly
  	
  	xx = (xx(0:data.grid.npts(0)-3)+xx(1:data.grid.npts(0)-2))/2
  	yy = (yy(0:data.grid.npts(1)-3)+yy(1:data.grid.npts(1)-2))/2
  	zz = (zz(0:data.grid.npts(2)-3)+zz(1:data.grid.npts(2)-2))/2
  	
  	dx = xx[1]-xx[0]
  	dy = yy[1]-yy[0]
  	dz = zz[1]-zz[0]

  	oSurface=obj_new(keyword_set(wireframe)? "IDLgrPolyline" : $
      "IDLgrPolygon",data=vert,polygons=poly,color=[0,120,0])
  	oModel->add,oSurface
  	
  endif
  
  if keyword_set(eval) then begin

  	epar = 
  	
  	emag = sqrt(vecmag2(epar)) ; sort epar!
  	
  	shade_volume,emag,eval,vert,poly
  	
  	xx = (xx(0:data.grid.npts(0)-3)+xx(1:data.grid.npts(0)-2))/2
  	yy = (yy(0:data.grid.npts(1)-3)+yy(1:data.grid.npts(1)-2))/2
  	zz = (zz(0:data.grid.npts(2)-3)+zz(1:data.grid.npts(2)-2))/2
  	
  	dx = jxx[1]-jxx[0]
  	dy = jyy[1]-jyy[0]
  	dz = jzz[1]-jzz[0]
  	
  	vert[0,*]=vert[0,*]*dx+xx[0]
  	vert[1,*]=vert[1,*]*dy+yy[0]
  	vert[2,*]=vert[2,*]*dz+zz[0]

  	oSurface=obj_new(keyword_set(wireframe)? "IDLgrPolyline" : $
      "IDLgrPolygon",data=vert,polygons=poly,color=[0,120,0])
  	oModel->add,oSurface
  endif
  
  
  
pro model_add_eparallel, oModel, bgrid, egrid, xx, yy, zz, eval=eval

  wireframe=0

  ex = egrid[*,*,*,0]
  ey = egrid[*,*,*,1]
  ez = egrid[*,*,*,2]
  bx = bgrid[*,*,*,0]
  by = bgrid[*,*,*,1]
  bz = bgrid[*,*,*,2]

  bmag = sqrt(bx*bx+by*by+bz*bz)
  epar = (ex*bx+ey*by+ez*bz)/bmag

  if (eval eq -99) then begin
     mxepar = max(epar)
     mnepar = min(epar)
     val_epar = (mxepar-mnepar)/2.
     val = 0.85*[-val_epar,val_epar]
     print,frame,'   epar [min,max]: [',mxepar,',',mnepar,']'
     print,frame,'   values - 0.333*[min,max]: [',val[0],',',val[1],']'
  endif else begin
    case n_elements(value) of
      0: val=[-1e-5,1e-5]
      1: val=[-1,1]*abs((value eq 1)? 1e-5 : value)
      else: val=value[0:1]
    endcase
  endelse

  for i=0,1 do begin
    if val[i] ge max(epar) or val[0] le min(epar) then continue
    shade_volume,epar,val[i],vert,poly

    vert[0,*]=vert[0,*]*10./65.
    vert[1,*]=vert[1,*]*10./65.
    vert[2,*]=vert[2,*]*10./65.

    oSurface=obj_new(keyword_set(wireframe)? "IDLgrPolyline" : $
      "IDLgrPolygon",data=vert,polygons=poly,color=(i)? [64,0,0] : [0,0,64])
    oModel->add,oSurface

  endfor
end

