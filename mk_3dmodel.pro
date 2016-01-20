pro model_add_isosurface, oModel, bgrid, bval=bval, jval=jval, epval=epval, pbeta=pbeta, data=data, thick=thick

  wireframe=0
  
  nx = n_elements(data.x)
  ny = n_elements(data.y)
  nz = n_elements(data.z)
  
  todo = []
  if keyword_set(bval) then todo = [todo,1]
  if keyword_set(jval) then todo = [todo,2]
  if keyword_set(epval) then todo = [todo,3]
  if keyword_set(pbeta) then todo = [todo,4]
  
  foreach field, todo do begin
  
    if field eq 1 then begin
      grid = sqrt(vecmag2(bgrid))
      val = bval
      x = data.x
      y = data.y
      z = data.z
      col = [120,0,0]
    endif
    if field eq 2 then begin
      grid = sqrt(vecmag2(mkjg(data)))
      val = jval
      x = data.grid.x(1:nx-1)
      y = data.grid.y(1:ny-1)
      z = data.grid.z(1:nz-1)
      col = [0,120,0]
    endif
    if field eq 3 then begin
      grid = abs(eparallel(data))
      val = epval
      x = data.x(1:nx-2)
      y = data.y(1:ny-2)
      z = data.z(1:nz-2)
      col = [0,0,120]
    endif
    if field eq 4 then begin
      grid = pbeta(data)
      val = pbeta
      x = data.x
      y = data.y
      z = data.z
      col = [120,120,120]
    endif
    
    shade_volume,grid,val,vert,poly
    
    dx = x[1]-x[0]
    dy = y[1]-y[0]
    dz = z[1]-z[0]
    
    vert[0,*]=vert[0,*]*dx+x[0]
	  vert[1,*]=vert[1,*]*dy+y[0]
	  vert[2,*]=vert[2,*]*dz+z[0]
	
	  oSurface=obj_new(keyword_set(wireframe)? "IDLgrPolyline" : $
        "IDLgrPolygon",data=vert,polygons=poly,color=col)
    oModel->add,oSurface
  
  endforeach
  
end

pro model_add_fieldlines, oModel, bgrid, xx, yy, zz, startpt=startpt, lcol=lcol, thick=thick, nospine=nospine

  sz_stp = size(startpt)
  if sz_stp(0) eq 2 then nl = sz_stp[2] else nl = 1
  for i=0, nl-1 do begin
    h = 2d-3
    hmin = 1d-4
    hmax = 1d-2
    epsilon = 1d-6
    mxline = 10000
    
    line = fieldline3d(startpt[*,i],bgrid,xx,yy,zz,h,hmin,hmax,epsilon,mxline=mxline)
    if keyword_set(nospine) then begin
      ispine = where(abs(line[2,*]) lt 0.01)
      line = line[*,ispine]
    endif
    oModel->add,obj_new("IDLgrPolyline",line[0,*],line[1,*],line[2,*],color=lcol,thick=thick)
  endfor

end

pro model_add_separator, oModel, seplines=seplines, sepcol=sepcol, thick=thick

 oModel->add,obj_new("IDLgrPolyline",seplines[0,*],seplines[1,*],seplines[2,*],color=sepcol,thick=2+thick)

end

pro model_add_spinelines, oModel, bgrid, xx, yy, zz, nullpos=nullpos, nulltype=nulltype, spine_vec=spine_vec, thick=thick

  dx = xx[1]-xx[0]
  h = 0.01*dx
  hmin = 0.001*dx
  hmax = 0.5*dx
  epsilon = 1.0d-5
  mxline = 1000
  nnulls = n_elements(nulltype)
  ro = 0.01*dx

  for j=0,nnulls-1 do begin
    if (nulltype[j] eq 1) then col = [250,125,0]
    if (nulltype[j] eq -1) then col = [150,0,250]
    
    startpt = nullpos[*,j]+ro*spine_vec[*,j]
    linef = fieldline3d(startpt,bgrid,xx,yy,zz,-nulltype[j]*h,hmin,hmax,epsilon,mxline=mxline)
    oModel->add,obj_new("IDLgrPolyline",linef[0,*],linef[1,*],linef[2,*],color=col,thick=1+thick)
    
    startpt = nullpos[*,j]-ro*spine_vec[*,j]
    linef = fieldline3d(startpt,bgrid,xx,yy,zz,-nulltype[j]*h,hmin,hmax,epsilon,mxline=mxline,/oneway)
    oModel->add,obj_new("IDLgrPolyline",linef[0,*],linef[1,*],linef[2,*],color=col,thick=1+thick)
 endfor

end

pro model_add_fanlines, oModel, bgrid, xx, yy, zz, nullpos=nullpos, nulltype=nulltype, fannorm_vec=fannorm_vec, thick=thick

  dx = xx[1]-xx[0]
  h = 0.01*dx
  hmin = 0.001*dx
  hmax = 0.5*dx
  epsilon = 1.0d-5
  mxline = 5000
  nnulls = n_elements(nulltype)
  ro = 1.5*dx   
  nl = 31

  for j=0,nnulls-1 do begin
    startpt = circle_of_points_in_plane(nullpos[*,j],fannorm_vec[*,j],ro,nl)
    sz_stp = size(startpt)
    if (sz_stp(0) eq 2) then nl = sz_stp[2] else nl = 1
    col = [10,10,10]
    if (nulltype[j] eq 1) then col = [250,0,0]
    if (nulltype[j] eq -1) then col = [0,0,250]
    for i=0,nl-1 do begin 
      linef = fieldline3d(startpt[*,i],bgrid,xx,yy,zz,nulltype[j]*h,hmin,hmax,epsilon,mxline=mxline,/oneway)
      oModel->add,obj_new("IDLgrPolyline",linef[0,*],linef[1,*],linef[2,*],color=col,thick=thick)
    endfor
  endfor

end

pro model_add_nulls, oModel, xx, yy, zz, nullpos=nullpos, nulltype=nulltype

  lx = max(xx)-min(xx)
  sznullpos = size(nullpos)
  if (sznullpos(0) eq 1) then nnulls = 1
  if (sznullpos(0) eq 2) then nnulls = sznullpos(2)
   
  radius=0.02*lx
  for i=0,nnulls-1 do begin
    ;if abs(nulltype[i]) eq 2 then begin
    ;  mesh_obj,6,vert,poly,[[0,0,-1/sqrt(8)],[1,0,-1/sqrt(8)],[0,0,3/sqrt(8)]]*radius
    ;endif else begin
    ;  mesh_obj,4,vert,poly,replicate(radius,21,21)
    ;endelse
    
    mesh_obj,4,vert,poly,replicate(radius,21,21)
    
    ;for j=0,2 do vert[j,*]=vert[j,*]+nullpos[j,i]
    ;colour = (nulltype[i] gt 0) ? [255,110,0] : (nulltype[i] lt 0) ? [0,220,255] : [0,255,0]
    ;oModel->add,obj_new("IDLgrPolygon",data=vert,polygons=poly,color=colour,/shading)
    for j=0,2 do vert[j,*]=vert[j,*]+nullpos[j,i]
    oModel->add,obj_new("IDLgrPolygon",data=vert,polygons=poly,color=[255,0,0],/shading)
    
  endfor
  
end

pro model_add_box, oModel, bmnmx, thick=thick

  xmin = bmnmx[0,0]
  xmax = bmnmx[0,1]
  ymin = bmnmx[1,0]
  ymax = bmnmx[1,1]
  zmin = bmnmx[2,0]
  zmax = bmnmx[2,1]
  
  ; add the box
  line=transpose([[0.,0.,0.],[1.,0.,0.],[1.,0.,1.],[1.,0.,0.],[1.,1.,0.] $
          ,[1.,1.,1.],[1.,1.,0.],[0.,1.,0.],[0.,1.,1.],[0.,1.,0.] $
          ,[0.,0.,0.],[0.,0.,1.],[1.,0.,1.],[1.,1.,1.],[0.,1.,1.],[0.,0.,1.]])
  
  line[*,0]=line[*,0]*(xmax-xmin)+xmin
  line[*,1]=line[*,1]*(ymax-ymin)+ymin
  line[*,2]=line[*,2]*(zmax-zmin)+zmin
  
  oModel->add,obj_new('IDLgrPolyline',line[*,0],line[*,1],line[*,2],color=[20,20,20],thick=thick)

end

pro model_add_reconbox, oModel, bmnmx, thick=thick

  xmin = -0.5
  xmax = 0.5
  ymin = -0.5
  ymax = 0.5
  zmin = bmnmx[2,0]
  zmax = bmnmx[2,1]

  line=transpose([[0.,0.,0.],[1.,0.,0.],[1.,0.,1.],[1.,0.,0.],[1.,1.,0.] $
          ,[1.,1.,1.],[1.,1.,0.],[0.,1.,0.],[0.,1.,1.],[0.,1.,0.] $
          ,[0.,0.,0.],[0.,0.,1.],[1.,0.,1.],[1.,1.,1.],[0.,1.,1.],[0.,0.,1.]])
  
  line[*,0]=line[*,0]*(xmax-xmin)+xmin
  line[*,1]=line[*,1]*(ymax-ymin)+ymin
  line[*,2]=line[*,2]*(zmax-zmin)+zmin
  
  oModel->add,obj_new('IDLgrPolyline',line[*,0],line[*,1],line[*,2],color=[20,20,20],thick=thick)
  
end

pro model_add_axes, oModel, bmnmx, thick=thick, r0=r0, fontsize=fontsize

  xmin = bmnmx[0,0]
  xmax = bmnmx[0,1]
  ymin = bmnmx[1,0]
  ymax = bmnmx[1,1]
  zmin = bmnmx[2,0]
  zmax = bmnmx[2,1]
  
  sf = 0.1*max([(xmax-xmin),(ymax-ymin),(zmax-zmin)])
  
  if keyword_set(r0) then begin
    x0 = r0[0]
    y0 = r0[1]
    z0 = r0[2]
  endif else begin
    x0 = xmin
    y0 = ymin
    z0 = zmin
  endelse
  
  if keyword_set(fontsize) then size=fontsize
  font = obj_new('idlgrfont', name='helvetica', size=size)
  
  ;x-axis
  oModel->add,obj_new('IDLgrPolyline',[x0,x0+sf],[y0,y0],[z0,z0],color=[20,20,20],thick=1+thick)
  oModel->add,obj_new('idlgrtext','x',locations=[x0+1.1*sf,y0,z0+0.2*sf], /onglass, font=font)
  oModel->add,obj_new('IDLgrPolyline',[x0+0.9*sf,x0+sf,x0+0.9*sf],[y0,y0,y0],[z0-0.1*sf,z0,z0+0.1*sf],color=[20,20,20],thick=1+thick)
  
  ;y-axis
  oModel->add,obj_new('IDLgrPolyline',[x0,x0],[y0,y0+sf],[z0,z0],color=[20,20,20],thick=1+thick)
  oModel->add,obj_new('idlgrtext','y',locations=[x0,y0+1.1*sf,z0+0.3*sf], /onglass, font=font)
  oModel->add,obj_new('IDLgrPolyline',[x0-0.1*sf,x0,x0+0.1*sf],[y0+0.9*sf,y0+sf,y0+0.9*sf],[z0,z0,z0],color=[20,20,20],thick=1+thick)
  
  ;z-axis
  oModel->add,obj_new('IDLgrPolyline',[x0,x0],[y0,y0],[z0,z0+sf],color=[20,20,20],thick=1+thick)
  oModel->add,obj_new('idlgrtext','z',locations=[x0-0.3*sf,y0,z0+1.1*sf], /onglass, font=font)
  oModel->add,obj_new('IDLgrPolyline',[x0-0.1*sf,x0,x0+0.1*sf],[y0,y0,y0],[z0+0.9*sf,z0+sf,z0+0.9*sf],color=[20,20,20],thick=1+thick)

end

function mk_3dmodel, bgrid, xx, yy, zz, nullpos=nullpos, nulltype=nulltype, fannorm_vec=fannorm_vec, spine_vec=spine_vec, startpt1=startpt1, startpt2=startpt2, startpt3=startpt3, startpt4=startpt4, startptfan=startptfan, startptsep=startptsep, lcol1=lcol1, lcol2=lcol2, lcol3=lcol3, lcol4=lcol4, lcolfan=lcolfan, lcolsep=lcolsep, epval=epval, bval=bval, seplines=seplines, sepcol=sepcol, box=box, reconbox=reconbox, nulls=nulls, spines=spines, fans=fans, flines=flines, separator=separator, isosurf=isosurf, jval=jval, data=data, nullb=nullb, thick=thick, axes=axes, locaxes=locaxes, pbeta=pbeta, fontsize=fontsize

  xmin = min(xx)
  xmax = max(xx)
  ymin = min(yy)
  ymax = max(yy)
  zmin = min(zz)
  zmax = max(zz)

  bmnmx = [[xmin,ymin,zmin],[xmax,ymax,zmax]]

  oModel = obj_new("IDLgrModel")

  if keyword_set(box) then model_add_box,oModel,bmnmx,thick=thick
  if keyword_set(reconbox) then model_add_reconbox,oModel,bmnmx,thick=thick
  if keyword_set(axes) then model_add_axes,oModel,bmnmx,thick=thick,r0=locaxes, fontsize=fontsize

  if keyword_set(nulls) then model_add_nulls,oModel,xx,yy,zz,nullpos=nullpos,nulltype=nulltype

  if keyword_set(fans) then model_add_fanlines,omodel,bgrid,xx,yy,zz,nullpos=nullpos,nulltype=nulltype,fannorm_vec=fannorm_vec,thick=thick

  if keyword_set(separator) then model_add_separator,omodel,seplines=seplines,sepcol=sepcol,thick=thick

  if keyword_set(flines) and keyword_set(startpt1) then model_add_fieldlines,omodel,bgrid,xx,yy,zz,startpt=startpt1,lcol=lcol1,thick=thick,/nospine
  if keyword_set(flines) and keyword_set(startpt2) then model_add_fieldlines,omodel,bgrid,xx,yy,zz,startpt=startpt2,lcol=lcol2,thick=thick
  if keyword_set(flines) and keyword_set(startpt3) then model_add_fieldlines,omodel,bgrid,xx,yy,zz,startpt=startpt3,lcol=lcol3,thick=thick
  if keyword_set(flines) and keyword_set(startpt4) then model_add_fieldlines,omodel,bgrid,xx,yy,zz,startpt=startpt4,lcol=lcol4,thick=thick

  if keyword_set(startptfan) then model_add_fieldlines,omodel,bgrid,xx,yy,zz,startpt=startptfan,lcol=lcolfan,thick=thick

  if keyword_set(startptsep) then model_add_fieldlines,omodel,bgrid,xx,yy,zz,startpt=startptsep,lcol=lcolsep,thick=thick
  
  if keyword_set(spine) then model_add_spinelines,omodel,bgrid,xx,yy,zz,nullpos=nullpos,nulltype=nulltype,spine_vec=spine_vec,thick=thick

  if keyword_set(isosurf) then model_add_isosurface,oModel,bgrid,bval=bval,jval=jval,epval=epval,pbeta=pbeta,data=data

  if keyword_set(nullb) then model_add_isosurface,oModel,bgrid,bval=nullb,data=data

return, oModel

end
