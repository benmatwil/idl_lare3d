pro fanfield, frame, nflines=nflines, linear=linear, plot=plot, png=png

  dat = getdata(frame, /grid, /magnetic_field)
  
  bgrid = mkbg(dat, /v)
  bgrid = reform(bgrid[*,*,dat.grid.npts[2]/2-1,0:1])
  
  x = dat.grid.x[1:dat.grid.npts[0]-2]
  y = dat.grid.y[1:dat.grid.npts[1]-2]
  
  if nflines eq !null then nflines = 32
  sptx = dblarr(nflines)
  spty = sptx

  r = 0.01d0
  for i = 0, nflines-1 do begin
    sptx[i] = r*cos(!dpi*i*2/nflines)
    spty[i] = r*sin(!dpi*i*2/nflines)
  endfor
  if keyword_set(linear) then begin
    for i = 0, nflines/2-1 do begin
      sptx[0:nflines/2-1] = (findgen(nflines/2)/(nflines/2-1)-0.5)*1.8
      spty[i] = 0.5
    endfor
    for i = nflines/2, nflines-1 do begin
      sptx[nflines/2:nflines-1] = (findgen(nflines/2)/(nflines/2-1)-0.5)*1.8
      spty[i] = -0.5
    endfor
  endif
  
  if plot eq !null then plt = plot([0,0], /nodata, aspect_ratio=1, xtitle="x", ytitle="y", title = "Fieldlines in the fan at t = " + string(dat.time,format='(F-6.3)'), xtickdir = 1, ytickdir = 1)

  for i = 0, n_elements(sptx)-1 do begin
    line = fieldline2d([sptx[i],spty[i]],bgrid[*,*,0],bgrid[*,*,1],x,y,2d-3,1d-4,1d-2,1d-6)
    plt = plot(line[0,*],line[1,*],/overplot)
  endfor
  
  if plot eq !null then begin
    plt['axis2'].delete
    plt['axis3'].delete
    plt.xtickdir = 1
    plt.ytickdir = 1
  endif
  
; save as a png
  if keyword_set(png) then begin
    filename = "pngs/fanfield" + string(frame, format='(I3.3)') + ".png"
    if not file_test('pngs', /directory) then file_mkdir, 'pngs'
    if keyword_set(hires) then plt.save, filename else plt.save, filename, width=1000
    plt.close
    print, "Saved as " + filename
  endif

end
