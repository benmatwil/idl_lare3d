pro view3d, frame, png=png, jval=jval, bval=bval, epval=epval, fan=fan, sideview=sideview, separator=separator, isosurf=isosurf, null=null, spines=spines, flines=flines, zval=zval, xz=xz, thick=thick, reconbox=reconbox, box=box, axes=axes, locaxes=locaxes, pbeta=pbeta, fontsize=fontsize

  device,retain=2
  device,decompose=0
  
  if not keyword_set(thick) then thick = 1

  ;load magnetic field & grid
  if keyword_set(epval) then d = getdata(frame, /grid, /magnetic_field, /eta) else if keyword_set(pbeta) then d = gdata(frame, /bgp) else d = gdata(frame)
  
  print, 'Making bgrid'
  bgrid = mkbg(d)

  xx = d.x
  yy = d.y
  zz = d.z
  
  if keyword_set(null) then null = 0.05
  if not keyword_set(zval) then zval = 0.01

  startpt1 = dblarr(3,16)
  r = 0.9d;0.01d
  for i = 0,15 do startpt1[*,i] = [r*cos(i*!dpi/8.),r*sin(i*!dpi/8.),0]
  lcol1 = [0,255,43]
  
  startpt2 = dblarr(3,2)
  for i = 0,1 do startpt2[*,i] = [0,0,-0.005+i*0.01]
  lcol2 = [0,245,255]
  
  startpt3 = dblarr(3,16)
  r = 0.9d
  for i = 0,15 do startpt3[*,i] = [r*cos(i*!dpi/8.),r*sin(i*!dpi/8.),zval]
  lcol3 = [255,180,60]
  
  startpt4 = dblarr(3,16)
  r = 0.9d
  for i = 0,15 do startpt4[*,i] = [r*cos(i*!dpi/8.),r*sin(i*!dpi/8.),-zval]
  lcol4 = [170,0,220]

  if keyword_set(fan) then begin
    files = findfile(string(format='("finders/output/null_",I3.3,' + '"_*.dat")', frame))
    o = read_out(files[0]) ; only one null
    pnts = *o[(n_elements(o)-1)/10]
    startptfan = pnts.pos
    startptfan = startptfan(*,0:n_elements(startptfan)/3-1:n_elements(startptfan)/48)
    lcolfan = [255,0,0]
  endif
  
  if keyword_set(spine) then begin
    print, 'Calculating spine'
    nulls = getnulls(frame)
    nullpos = nulls.pos
    spine_vec = nulls.spine
    nulltype = nulls.type-1
  endif
  
  if keyword_set(null) then begin
    print, 'Calculating null'
    ;nulls = getnulls(frame)
    ;nullpos = nulls.pos
    ;nulltype = nulls.type-1
    !null = findnull_3D_v2(bgrid,xx,yy,zz,tol=1.0d-7,accur=5.0d-5,nullpos=nullpos)
  endif
  
  if keyword_set(sep) then begin
    files = findfile(string(format='("finders/output/separators_",I3.3,' + '"_*.dat")', frame))
    o = read_out(files[0]) ; only one null
    pnts = *o[(n_elements(o)-1)/10]
    startptsep = pnts.pos
    startptsep = startptsep(*,0:n_elements(startptsep)/3-1:n_elements(startptsep)/48)
    lcolsep = [0,0,0]
  endif
  
  print, 'Now making model'
  
  o = mk_3dmodel(bgrid, xx, yy, zz, nullpos=nullpos, nulltype=nulltype, spine_vec=spine_vec, startpt1=startpt1, startpt2=startpt2, startpt3=startpt3, startpt4=startpt4, startptfan=startptfan, startptsep=startptsep, lcol1=lcol1, lcol2=lcol2, lcol3=lcol3, lcol4=lcol4, lcolfan=lcolfan, lcolsep=lcolsep, epval=epval, bval=bval, flines=flines, jval=jval, data=d, nullb=nullb, nulls=null, /isosurf, box=box, axes=axes, reconbox=reconbox, locaxes=locaxes, spines=spines, thick=thick, pbeta=pbeta, fontsize=fontsize)

  xobjview, o, tlb=tlb

  if keyword_set(png) then begin
    if not file_test('pngs', /directory) then file_mkdir, 'pngs'
    if not file_test('pngs/3dmodels', /directory) then file_mkdir, 'pngs/3dmodels'
	  if keyword_set(sideview) then xobjview_rotate,[1,0,0],90 else begin
	    if keyword_set(xz) then begin
	      xobjview_rotate,[1,0,0], 90                
        xobjview_rotate,[0,0,1], 90
        xobjview_rotate,[0,0,1], 90
        xobjview_rotate,[0,1,0], 90
        xobjview_rotate,[0,1,0], 90
      endif else begin
	    xobjview_rotate, [1,0,0], -60
	    xobjview_rotate, [0,1,0], -20
	    xobjview_rotate, [0,0,1], -11.17
	    endelse
	  endelse
	  fnum = strmid(strcompress(string(100+frame),/remove_all),1,2)
	  filename = 'pngs/3dmodels/field' + fnum
	  if keyword_set(jval) then begin
	    jnum = strmid(strcompress(string(100+jval),/remove_all),1,2)
	    filename = filename + 'j' + jnum
	  endif
	  if keyword_set(bval) then begin
	    bnum = strmid(strcompress(string(100+bval),/remove_all),1,2)
	    filename = filename + 'b' + bnum
	  endif
	  if keyword_set(epval) then begin
	    enum = strmid(strcompress(string(0.+epval),/remove_all),1,4)
	    filename = filename + 'ep' + enum
	  endif
	  if keyword_set(zval) then begin
	    znum = strmid(strcompress(string(0.+zval),/remove_all),1,4)
	    filename = filename + 'z' + znum
	  endif
	  if keyword_set(xz) then filename = filename + "xz"
	  filename = filename + '.png'

	  xobjview_write_image,filename,'png',dimensions=[1200,1200]
	  Widget_Control, tlb, /Destroy
	  print, 'Saved as ' + filename
  endif
  ;xobjview_rotate, [1,0,0],120
	;xobjview_rotate, [0,1,0],-20
	;xobjview_rotate, [0,0,1],-11.17

end
