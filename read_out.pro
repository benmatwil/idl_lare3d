function add_line,line1,line2
 
  sz1=size(line1)
  ln1=(sz1[0] eq 2)? reform(line1,[1,sz1[1],sz1[2]]) : line1
  sz2=size(line2)
  ln2=line2
  sz1=size(ln1) & sz2=size(ln2)
  
  lines=dblarr(sz1[1]+1,sz1[2]>sz2[1],3)

  lines[0:sz1[1]-1,0:sz1[2]-1,*]=ln1[*,*,*]
  lines[sz1[1],0:sz2[1]-1,*]=ln2[*,*]
  
  for i=long(0),sz1[1]-1 do for j=0,2 do begin
    lines[i,sz1[2]-1:*,j]=lines[i,sz1[2]-1,j]
  endfor
  for j=0,2 do begin
    lines[sz1[1],sz2[1]-1:*,j]=lines[sz1[1],sz2[1]-1,j]
  endfor

  return,lines
end

function add_lines,line1,line2
 
  sz1=size(line1)
  ln1=(sz1(0) eq 2)? reform(line1,[1,sz1(1),sz1(2)]) : line1
  sz2=size(line2)
  ln2=(sz2(0) eq 2)? reform(line2,[1,sz2(1),sz2(2)]) : line2
  sz1=size(ln1) & sz2=size(ln2)
  
  lines=fltarr(sz1(1)+sz2(1),sz1(2)>sz2(2),3)

  lines(0:sz1(1)-1,0:sz1(2)-1,*)=ln1(*,*,*)
  lines(sz1(1):sz1(1)+sz2(1)-1,0:sz2(2)-1,*)=ln2(*,*,*)
  
  for i=long(0),sz1(1)-1 do for j=0,2 do begin
    lines(i,sz1(2)-1:*,j)=lines(i,sz1(2)-1,j)
  endfor
  for i=long(sz1(1)-1),sz1(1)+sz2(1)-1 do for j=0,2 do begin
    lines(i,sz2(2)-1:*,j)=lines(i,sz2(2)-1,j)
  endfor

  return,lines
end

pro read_polygons,filename,polygons=polygons,points=points

  openr,lun,filename,/get_lun

  np=long64(0) & readu,lun,np & print,"np=",np
  pnts=dblarr(3,np)
  readu,lun,pnts
  points=transpose(temporary(pnts))
  
  readu,lun,np
  polys=dblarr(np)
  readu,lun,polys
  polygons=polys
  
  close,lun
  free_lun,lun
end

function read_out,filename,points=points,flags=flags,getpoints=getpoints

  p={SS_POINT,pos:dblarr(3),flags:long(0),in_idx:long(0)}

  openr,lun,filename,/get_lun

  nrings=long(0) & readu,lun,nrings
  
  ptrs=ptrarr(nrings)
  rng_sz=intarr(nrings)
  
  for i=0l,nrings-1 do begin
    n=long(0) & readu,lun,n
    p=replicate({SS_POINT},n)
    readu,lun,p
    ptrs(i)=ptr_new(p)
    rng_sz(i)=n
  endfor
  close,lun
  free_lun,lun
  
  if keyword_set(getpoints) ne 0 then begin
    points=transpose(reform((*ptrs[0]).pos,[3,n_elements(*ptrs[0])]))
    flags=[(*ptrs[0]).flags]
    for i=1,nrings-1 do begin
      points=[points,transpose((*ptrs[i]).pos)]
      flags=[flags,(*ptrs[i]).flags]
    endfor
  endif
  return,ptrs
end

function read_separator,filename

  openr,lun,filename,/get_lun
  np=long(0) & readu,lun,np
  if np le 0 then begin
    close,lun
    free_lun,lun
    return,0
  endif
  
  sep=dblarr(3,np)
  readu,lun,sep
  close,lun
  free_lun,lun
  
  return,transpose(sep)
end

function read_separators,filename,maxseparators=maxseparators

  openr,lun,filename,/get_lun
  nseps=long(0) & readu,lun,nseps
  
  if nseps eq 0 then begin
    close,lun
    free_lun,lun
    return,0
  endif
  if keyword_set(maxseparators) gt 0 then nseps=nseps<maxseparators
  
  for i=0,nseps-1 do begin
    np=long(0) & readu,lun,np
    sep=dblarr(3,np) & readu,lun,sep
    sep=transpose(sep)
    if i eq 0 then seplines=reform(sep,[1,np,3]) $
    else seplines=add_line(seplines,sep)
  endfor
  
  close,lun
  free_lun,lun
  
  return,seplines
end

pro plot_sepsurf,ssfile,sepfile,lines=lines,seps=sep,lcolours=lcol, $
  noplot=noplot,maxlines=maxlines

  if keyword_set(noplot) eq 0 then noplot=0
  
  ptrs=read_out(ssfile,points=p,flags=f,/getpoints)
  print,"Read null file"
  
  if noplot eq 0 then plot,[-3,3],[-3,3],/nodata
  loadct,39,/silent
  n=n_elements(ptrs)
  ;for i=0,n-1 do begin
  ;  oplot,[(*ptrs[i]).pos[1]],[(*ptrs[i]).pos[2]],psym=3,col=50+i*204/n
  ;endfor
  ii=where((f and 32) ne 0)
  if noplot eq 0 and ii[0] ne -1 then $
    oplot,p[ii,1],p[ii,2],color=192,psym=2,symsize=0.5
  
  if keyword_set(sepfile) eq 0 then sepfile=""
  if file_test(sepfile) then begin
    sep=read_separator(sepfile)
    if noplot eq 0 and keyword_set(sep) then $
      oplot,sep[*,1],sep[*,2],thick=3,color=255
  endif
  
  ii=where((f and 16) ne 0)
  if noplot eq 0 and ii[0] ne -1 then $
    oplot,p[ii,1],p[ii,2],color=254,psym=2,symsize=1
  
  lines=reform([0,0,0,0,0,0],[1,2,3])
  lcol=[0]
  plotted=0
  for i=0,n-1 do begin
    pnts=[*ptrs[i],(*ptrs[i])[0]]
    
    line=reform([0,0,0],[1,3])
    for j=0,n_elements(pnts)-1 do begin
      line=[line,reform(pnts[j].pos[*],[1,3])]
      if (pnts[j].flags and 8) eq 0 and j ne n_elements(pnts)-1 then continue
      line=line[1:*,*]
      lines=add_line(lines,line)
      lcol=[lcol,50+i*204./n]
      if noplot eq 0 then oplot,[line[*,1]],[line[*,2]],col=50+i*204./n
      plotted=plotted+1
      if keyword_set(maxlines) then if plotted ge maxlines then goto,escapeloop
      line=reform([0,0,0],[1,3])
    endfor
  endfor
escapeloop:
  
  ;for i=0,n_elements(lines[*,0,0])-1 do oplot,lines[i,*,1],lines[i,*,2]
  
  help,plotted
  help,lines
  lcol=lcol[1:*]
  lines=lines[1:*,*,*]
  if noplot eq 0 and keyword_set(sep) then $
    oplot,sep[*,1],sep[*,2],thick=3,color=255
  
  ptr_free,ptrs
  
  ii=where((f and 16) ne 0)
  print,"Number of separators (guess) = ",n_elements(ii)-1
  ;help,ptrs,p,f,sep
end
