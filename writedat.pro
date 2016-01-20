pro writedat

;nf=''
;read,'How many frames are there? ',nf
st = ''
en = ''
read,'What file do you want to start at ? ',st
read,'What file do you want to end at ? ',en
;This is for using ./nullfinder 0. This creates the bv and stretch.dat
;files for a specified snap.
st = st + 0.
en = en + 0.
for snap=st,en do begin 
s1test=string(snap,format='(I3.3)')
ssnap = strmid(strcompress(string(s1test),/remove_all),0,3)

;@Start
d = getdata(snap,/grid,/magnetic_field)

bx = (d.bx(0:d.grid.npts(0)-2,*,*)+d.bx(1:d.grid.npts(0)-1,*,*))/2
by = (d.by(*,0:d.grid.npts(1)-2,*)+d.by(*,1:d.grid.npts(1)-1,*))/2
bz = (d.bz(*,*,0:d.grid.npts(2)-2)+d.bz(*,*,1:d.grid.npts(2)-1))/2

x = d.x
y = d.y
z = d.z

d = 0

;j_b_centre,snap,x,y,z,bx,by,bz,jx,jy,jz
openw,lun,"finders/data/bv_"+ssnap+".dat",/get_lun
writeu,lun,bx,by,bz
close,lun
free_lun,lun
openw,lun,"finders/data/stretch.dat",/get_lun
writeu,lun,x,y,z
close,lun
free_lun,lun

print,"Written file", snap
endfor
 end
