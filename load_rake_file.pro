function parse_stream,lun,vars=vars

ch_type=[ $
  -1, 0, 0, 0, 0, 0, 0, 0,  0,10,-1, 0, 0,10, 0, 0, $ ; control
   0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0, $ ; control
  10, 0, 0,14, 0, 0, 0, 0,  0, 0, 0,16,18,16,17, 0, $ ;  !"#$%&'()*+,-./
  15,15,15,15,15,15,15,15, 15,15, 0,12, 0,13, 0, 0, $ ; 0123456789:;<=>?
   0, 6, 1,11, 9, 2,11, 3, 11, 4,11, 8,11,11, 5,11, $ ; @ABCDEFGHIJKLMNO
  11,11, 7,11,11,11,11,11, 11,11,11, 0, 0, 0, 0,11, $ ; PQRSTUVWXYZ[\]^_
   0, 6, 1,11, 9, 2,11, 3, 11, 4,11, 8,11,11, 5,11, $ ; @abcdefghijklmno
  11,11, 7,11,11,11,11,11, 11,11,11, 0, 0, 0, 0, 0, $ ; pqrstuvwxyz{|}~ 
   0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0, $
   0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0, $
   0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0, $
   0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0, $
   0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0, $
   0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0, $
   0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0, 0, $
   0, 0, 0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0, 0,-1  $
]

state_matrix=[ $
  [ 0,  0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0], $
  [ 0,  2,13,23,23,23,23, 23,23,23, 1,23,28,  0,99,30,29,31, 0], $
                                                                 $
  [ 0, 23, 3,23,23,23,23, 23,23,23, 0,23, 0, 25, 0, 0, 0, 0, 0], $
  [ 0, 23,23, 4,23,23,23, 23,23,23, 0,23, 0, 25, 0, 0, 0, 0, 0], $
  [ 0, 23,23,23, 5,23,23, 23,23,23, 0,23, 0, 25, 0, 0, 0, 0, 0], $
  [ 0, 23,23,23,23, 6,23, 23,23,23, 0,23, 0, 25, 0, 0, 0, 0, 0], $
  [ 0, 23,23,23,23,23,23, 23,23,23, 7,23, 0, 25, 0, 0, 0, 0, 0], $
  [ 0,  0, 0, 0, 0, 0, 0,  8, 0, 0, 7, 0, 0, 25, 0, 0, 0, 0, 0], $
  [ 0,  0, 0, 0, 0, 0, 9,  0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0], $
  [ 0,  0, 0, 0, 0, 0, 0,  0,10, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0], $
  [ 0,  0,11, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0], $
  [ 0,  0, 0, 0, 0, 0, 0,  0, 0, 0,11, 0,12,  0, 0, 0, 0, 0, 0], $
  [12, 12,12,12,12,12,12, 12,12,12,12,12,12, 12,12,12,12,12,12], $
                                                                 $
  [ 0, 23,23,23,23,14,23, 23,23,23, 0,23, 0, 25, 0, 0, 0, 0, 0], $
  [ 0, 23,23,23,23,23,23, 23,23,15, 0,23, 0, 25, 0, 0, 0, 0, 0], $
  [ 0, 23,23,23,23,23,23, 23,23,23,16,23, 0, 25, 0, 0, 0, 0, 0], $
  [ 0,  0, 0, 0, 0, 0, 0, 18, 0, 0,16, 0,17, 25, 0, 0, 0, 0, 0], $
  [ 0, 17,17,17,17,17,17, 17,17,17,17,17,17, 17,17,17,17,17,17], $
  [ 0,  0, 0, 0, 0, 0,19,  0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0], $
  [ 0,  0, 0, 0, 0, 0, 0,  0,20, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0], $
  [ 0,  0,21, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0], $
  [ 0,  0, 0, 0, 0, 0, 0,  0, 0, 0,21, 0,22,  0, 0, 0, 0, 0, 0], $
  [ 0, 22,22,22,22,22,22, 22,22,22,22,22,22, 22,22,22,22,22,22], $
                                                                 $
  [ 0, 23,23,23,23,23,23, 23,23,23,24,23, 0, 25, 0,23, 0, 0, 0], $
  [ 0,  0, 0, 0, 0, 0, 0,  0, 0, 0,24, 0, 0, 25, 0, 0, 0, 0, 0], $
  [ 0, 26,26,26,26,26,26, 26,26,26,25,26,27, 26,26,26,26,26,26], $
  [26, 26,26,26,26,26,26, 26,26,26,26,26,27, 26,26,26,26,26,26], $
  [27, 27,27,27,27,27,27, 27,27,27,27,27,27, 27,27,27,27,27,27], $
                                                                 $
  [28, 28,28,28,28,28,28, 28,28,28,28,28,28, 28,28,28,28,28,28], $
                                                                 $
  [ 0,  0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0,  0, 0,30, 0,31, 0], $
  [ 0,  0,33, 0, 0, 0, 0,  0, 0, 0,36, 0, 0,  0, 0,30, 0,32,37], $
  [ 0,  0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0,  0, 0,32, 0, 0, 0], $
  [ 0,  0,33, 0, 0, 0, 0,  0, 0, 0,36, 0, 0,  0, 0,32, 0, 0,37], $
  [ 0,  0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0,  0, 0,35,34, 0, 0], $
  [ 0,  0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0,  0, 0,35, 0, 0, 0], $
  [ 0,  0, 0, 0, 0, 0, 0,  0, 0, 0,36, 0, 0,  0, 0,35, 0, 0,37], $
  [ 0,  0, 0, 0, 0, 0, 0,  0, 0, 0,36, 0, 0,  0, 0,39,38,40,37], $
  [ 0,  0, 0, 0, 0, 0, 0,  0, 0, 0,37, 0, 0,  0, 0,39,38,40, 0], $
                                                                 $
  [ 0,  0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0,  0, 0,39, 0,40, 0], $
  [ 0,  0,42, 0, 0, 0, 0,  0, 0, 0,45, 0, 0,  0, 0,39, 0,41,46], $
  [ 0,  0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0,  0, 0,41, 0, 0, 0], $
  [ 0,  0,42, 0, 0, 0, 0,  0, 0, 0,45, 0, 0,  0, 0,41, 0, 0,46], $
  [ 0,  0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0,  0, 0,44,43, 0, 0], $
  [ 0,  0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0,  0, 0,44, 0, 0, 0], $
  [ 0,  0, 0, 0, 0, 0, 0,  0, 0, 0,45, 0, 0,  0, 0,44, 0, 0,46], $
  [ 0,  0, 0, 0, 0, 0, 0,  0, 0, 0,45, 0, 0,  0, 0,48,47,49,46], $
  [ 0,  0, 0, 0, 0, 0, 0,  0, 0, 0,46, 0, 0,  0, 0,48,47,49, 0], $
                                                                 $
  [ 0,  0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0,  0, 0,48, 0,49, 0], $
  [ 0,  0,51, 0, 0, 0, 0,  0, 0, 0,54, 0,55,  0, 0,48, 0,50, 0], $
  [ 0,  0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0,  0, 0,50, 0, 0, 0], $
  [ 0,  0,51, 0, 0, 0, 0,  0, 0, 0,54, 0,55,  0, 0,50, 0, 0, 0], $
  [ 0,  0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0,  0, 0,53,52, 0, 0], $
  [ 0,  0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0,  0, 0,53, 0, 0, 0], $
  [ 0,  0, 0, 0, 0, 0, 0,  0, 0, 0,54, 0,55,  0, 0,53, 0, 0, 0], $
  [ 0,  0, 0, 0, 0, 0, 0,  0, 0, 0,54, 0,55,  0, 0, 0, 0, 0, 0], $
  [55, 55,55,55,55,55,55, 55,55,55,55,55,55, 55,55,55,55,55,55], $
                                                                 $
  [ 0,  0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0], $
  [ 0,  0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0], $
  [ 0,  0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0], $
  [ 0,  0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0], $
  [ 0,  0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0,  0, 0, 0, 0, 0, 0]  $
]

stop=[ $
  0,1,0,0,0, 0,0,0,0,0, $
  2,2,0,0,0, 3,3,3,0,0, $
  0,3,3,0,0, 4,4,4,1,0, $
  0,0,0,0,0, 0,0,0,0,0, $
  0,0,0,0,0, 0,0,0,5,0, $
  5,0,0,5,5, 5,0,0,0,0  $
]

store=[ $
  0,0,1,1,1, 1,1,0,0,0, $
  0,0,0,1,1, 1,0,0,0,0, $
  0,0,0,1,0, 0,2,0,0,1, $
  1,1,1,1,1, 1,0,0,2,2, $
  2,2,2,2,2, 0,0,3,3,3, $
  3,3,3,3,0, 0,0,0,0,0  $
]
  
  ch=byte(0)
  state=1
  type=0
  vars=strarr(3)
  
  readu,lun,ch
  while ch_type[ch] ge 0 do begin
    type=ch_type[ch]
    state=state_matrix[type,state]
    if state lt 0 or state ge 60 then stop; return,(state eq 99)? 99 : -1
    if store[state] ge 1 and store[state] le 3 then begin
      index=store[state]-1
      
      vars[index]=vars[index]+string(ch)
    endif
    readu,lun,ch
  endwhile
  
  vars[0]=strtrim(vars[0])
  return,stop[state]
end

pro evaluate_parameter,f,vars

  parameters=[ $
    {name:"closed"   ,svalue:"true"    ,sign: 1,mask:1,value:1}, $
    {name:"closed"   ,svalue:"false"   ,sign: 0,mask:1,value:0}, $
    {name:"direction",svalue:"positive",sign: 1,mask:6,value:4}, $
    {name:"direction",svalue:"negative",sign:-1,mask:6,value:2}, $
    {name:"direction",svalue:"both"    ,sign: 0,mask:6,value:6}, $
    {name:"direction",svalue:"none"    ,sign: 0,mask:6,value:0}  $
  ]

  sgn_set=0
  sgn=0
  
  if strmid(vars[1],0,1) eq '+' then begin
    if strlen(vars[1]) eq 1 then begin
      sgn=1
      sgn_set=1
    endif else if (byte(vars[1]))[1] ge byte('0') $
      and (byte(vars[1]))[1] le byte('9') then begin
      
      sgn=fix(vars[1])
      sgn_set=1
    endif
  endif else if (byte(vars[1]))[0] eq byte('-') then begin
    if strlen(vars[1]) eq 1 then begin
      sgn=-1
      sgn_set=1
    endif else if (byte(vars[1]))[1] ge byte('0') $
      and (byte(vars[1]))[1] le byte('9') then begin
      
      sgn=fix(vars[1])
      sgn_set=1
    endif
  endif else if (byte(vars[1]))[0] ge byte('0') $
    and (byte(vars[1]))[0] le byte('9') then begin
    
    sgn=fix(vars[1])
    sgn_set=1
  endif

  for i=0,n_elements(parameters)-1 do begin
    if strcmp(vars[0],parameters[i].name,/fold_case) then begin
      if (sgn_set and ((parameters[i].sign gt 0)? sgn gt 0 : $
         (parameters[i].sign lt 0)? sgn lt 0 : sgn eq 0)) $
         or strcmp(vars[1],parameters[i].svalue,/fold_case) then begin
        f=(f and not parameters[i].mask) or parameters[i].value
      endif
    endif
  endfor
end


function load_rake_file,filename,verbose=verbose

  OUTER=0
  RAKE=1
  state=OUTER
  point_list=0
  flags=0
  npoints=0
  rakes=0
  if keyword_set(verbose) eq 0 then verbose=0
  
  openr,lun,filename,/get_lun
  
  while not eof(lun) do begin
    case parse_stream(lun,vars=vars) of 
      1: begin & end; empty line - ignore!
      2: begin
           if verbose then print,format='(A,$)',"Begin Rake "
           if state ne OUTER then goto,error
           flags=0
           npoints=0
           points=0
           state=RAKE
         end
      3: begin
           if verbose then print,format='(A,$)',"End Rake "
           if state ne RAKE then goto,error
           if npoints gt 0 then begin
             newrake={closed:(flags and 1) eq 1,neg:(flags and 2) eq 2, $
               pos:(flags and 4) eq 4,points:ptr_new(reform(points,3,npoints))}
             rakes=keyword_set(rakes)? [rakes,newrake] : newrake
           endif
           state=OUTER
         end
      4: begin
           if verbose then print,format='(A,$)',"Parameter "
           if state ne RAKE then goto,error
           evaluate_parameter,flags,vars
         end
      5: begin
           if verbose then print,format='(A,$)',"Point "
           if state ne RAKE then goto,error
           if npoints eq 0 then points=double(vars[*]) $
           else points=[points,double(vars[*])]
           npoints=npoints+1
         end
      99: begin
           if verbose then print,format='(A,$)',"Binary stream "
           if state ne OUTER then goto,error
           flags=bytarr(3) & npoints=long(0)
           readu,lun,flags,npoints
           flags=flags[0]+256*(flags[1]+long(256)*flags[2])
           points=dblarr(3,npoints)
           readu,10,points
           if npoints gt 0 then begin
             newrake={closed:(flags and 1) eq 1,neg:(flags and 2) eq 2, $
               pos:(flags and 4) eq 4,points:ptr_new(reform(points,3,npoints))}
             rakes=keyword_set(rakes)? [rakes,newrake] : newrake
           endif           
         end
      -1: begin
           if verbose then print,format='(A,$)',"Error"
           goto,error 
         end
      0: begin
           if verbose then print,format='(A,$)',"Bad line type"
           goto,error 
         end
      else: begin
           if verbose then print,format='(A,$)',"Unknown"
           goto,error 
         end
    endcase
    if verbose then print,format='(%"(%s,%s,%s)")',vars[*]
  endwhile

  if state ne OUTER then goto,error
  close,lun
  free_lun,lun
  return,rakes
error:
  if verbose then print
  return,0
end

