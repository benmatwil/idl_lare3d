function getnulls,frame,spherical=spherical

  n={NP,pos:dblarr(3),spine:dblarr(3),fan:dblarr(3,2),type:long(0),ss:long64(0)}

  if not file_test('finders',/directory) then dir = 'data/' else dir = 'finders/data/'
  filename=(size(/type,frame) eq 7) ? frame : string(dir,format='(a,"nullpoints_",I3.3,".dat")',frame)
  if file_test(filename) eq 0 then return,0
  openr,lun,/get_lun,filename
  
  n=long(0)
  readu,lun,n
  
  if n gt 0 then begin
    n=replicate({NP},n)
    readu,lun,n
    
    if keyword_set(spherical) then begin
      ;r=n.pos[0] & theta=n.pos[1] & phi=n.pos[2] & 
      ;n.pos[0]=r*sin(theta)*cos(phi)
      ;n.pos[1]=r*sin(theta)*sin(phi)
      ;n.pos[2]=r*cos(theta)
      r=n.pos[0] & theta=n.pos[1] & phi=n.pos[2] & 
      n.pos[0]=r*cos(theta)*cos(phi)
      n.pos[1]=r*sin(theta)*cos(phi)
      n.pos[2]=r*sin(phi)

      for i=0,n_elements(n)-1 do begin
        pos=n[i].pos
        bigR=sqrt(pos[0]^2+pos[1]^2) 
        r=sqrt(total(pos^2))
        mat=[[pos[0]/r, -pos[1]/bigR,-(pos[0]*pos[2])/(r*bigR)], $
             [pos[1]/r,  pos[0]/bigR,-(pos[1]*pos[2])/(r*bigR)], $
             [pos[2]/r,        0    ,            bigR/r       ]]
        n[i].spine   =mat ## n[i].spine
        n[i].fan[*,0]=mat ## n[i].fan[*,0]
        n[i].fan[*,1]=mat ## n[i].fan[*,1]
      endfor

    endif
  endif
  
  close,lun
  free_lun,lun
  return,n
end
