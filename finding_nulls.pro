@Start

.r ~/idl/skeleton_tools/findnull_reduction
.r ~/idl/skeleton_tools/findnull_2D 
.r ~/idl/skeleton_tools/findnull_2Dbilinear
.r ~/idl/skeleton_tools/trilinear_3D 
.r ~/idl/skeleton_tools/findnull_3Dfaces 
.r ~/idl/skeleton_tools/findnull_3Dtrilinear  
.r ~/idl/skeleton_tools/findnull_3D_v2
.r  ~/idl/skeleton_tools/findnull_3D
.r  ~/idl/skeleton_tools/findnull_local_extrema
.r  ~/idl/skeleton_tools/findnull_null_char

d = getdata(frame,/magnetic_field, /grid)

bgrid = dblarr(d.grid.npts(0)-1,d.grid.npts(1)-1,d.grid.npts(2)-1,3)

bgrid(*,*,*,0) = (d.bx(0:d.grid.npts(0)-2,*,*)+d.bx(1:d.grid.npts(0)-1,*,*))/2.
bgrid(*,*,*,1) = (d.by(*,0:d.grid.npts(1)-2,*)+d.by(*,1:d.grid.npts(1)-1,*))/2.
bgrid(*,*,*,2) = (d.bz(*,*,0:d.grid.npts(2)-2)+d.bz(*,*,1:d.grid.npts(2)-1))/2.

xx = (d.grid.x(0:d.grid.npts(0)-2)+d.grid.x(1:d.grid.npts(0)-1))/2.
yy = (d.grid.y(0:d.grid.npts(1)-2)+d.grid.y(1:d.grid.npts(1)-1))/2.
zz = (d.grid.z(0:d.grid.npts(2)-2)+d.grid.z(1:d.grid.npts(2)-1))/2.

 ;determine position of nulls

 nullpos_grd = findnull_3D(bgrid,xx,yy,zz)
 help,nullpos_grd
 sz_np = size(nullpos_grd)
 if (sz_np[0] eq 1) then nnulls = 1 else nnulls = sz_np[2]
 nullpos = dblarr(3,nnulls)
 nullpos[0,*] = xx[0]+ dx*nullpos_grd[0,*]
 nullpos[1,*] = yy[0]+ dy*nullpos_grd[1,*]
 nullpos[2,*] = zz[0]+ dz*nullpos_grd[2,*]
 dd = min([xx[1]-xx[0],yy[1]-yy[0],zz[1]-zz[0]])
