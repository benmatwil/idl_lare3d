function read_sepsurf,filename,points=points,flags=flags,getpoints=getpoints, $
  maxrings=maxrings

  p={SS_POINT,pos:dblarr(3),flags:long(0),in_idx:long(0)}

  openr,lun,filename,/get_lun

  nrings=long(0) & readu,lun,nrings
  if keyword_set(maxrings) then begin
    if maxrings gt 0 then nrings=nrings<maxrings
  endif

  ptrs=ptrarr(nrings)
  rng_sz=intarr(nrings)
  
  for i=0,nrings-1 do begin
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
