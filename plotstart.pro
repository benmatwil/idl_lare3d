pro plotstart,rr=rr,gg=gg,bb=bb,ct=ct,width=width

  if not keyword_set(width) then width = 1600
  if keyword_set(ct) then if ct eq 39 then begin
    loadct,ct
    tvlct,rr,gg,bb,/get
    rr(0)=255 & gg(0)=255 & bb(0)=255
    rr(255)=0 & gg(255)=0 & bb(255)=0
    tvlct,rr,gg,bb
  endif
  if not keyword_set(ct) then begin
    tvlct,rr,gg,bb,/get
    rr(0)=255 & gg(0)=255 & bb(0)=255
    rr(255)=0 & gg(255)=0 & bb(255)=0
    tvlct,rr,gg,bb
  endif
  tvlct,rr,gg,bb
  window, xsize=width, ysize=9*width/16, retain=2
  
end
