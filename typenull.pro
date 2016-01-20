pro typenull,snap

s1test=string(snap,format='(I3.3)')
ssnap = strmid(strcompress(string(s1test),/remove_all),0,3)
res=512.

get=getnulls(snap)
help,get,/str
sz=size(get)
;;CHANGE FILE NAME!!
openw,lun,'/sraid2v/julie/Lare3d/test_damp_003/analysis/snap'+ssnap+'/nulls_type_'+ssnap+'.dat',/get_lun
if (n_elements(sz) ne 4) then begin &$
printf,lun,0 &$
close,lun &$
free_lun,lun &$
endif else begin &$
printf,lun,sz(1) &$
position=fltarr(3) &$
for i=0,sz(1)-1 do begin &$
position(0)=((get[i].pos)(0)+1)*(res/2.) &$
position(1)=((get[i].pos)(1)+1)*(res/2.) &$
position(2)=((get[i].pos)(2)+1.75)*(768./4.5) &$
printf,lun,format='(4(F,:," "))',position(0:2),get(i).type &$
endfor &$
endelse &$
close,lun
free_lun,lun


end
