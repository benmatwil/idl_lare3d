;cplot, fr=35, diff=25, /current, xy=0, smlev=0.02, /png, /notitle
;cplot, fr=65, diff=25, /current, xy=0, smlev=0.02, /png, /notitle

;cplot, fr=35, diff=25, /current, xy=0.8, smlev=0.02, /png, /notitle
;cplot, fr=65, diff=25, /current, xy=0.8, smlev=0.02, /png, /notitle

;cplot, fr=35, diff=25, /current, xz=0, smlev=0.02, /png, /notitle
;cplot, fr=65, diff=25, /current, xz=0, smlev=0.02, /png, /notitle


;cplot, fr=35, diff=25, /pressure, xy=0, smlev=0.002, /png, /notitle
;cplot, fr=65, diff=25, /pressure, xy=0, smlev=0.002, /png, /notitle

;cplot, fr=35, diff=25, /pressure, xy=0.8, smlev=0.002, /png, /notitle
;cplot, fr=65, diff=25, /pressure, xy=0.8, smlev=0.002, /png, /notitle

;cplot, fr=35, diff=25, /pressure, xz=0, smlev=0.002, /png, /notitle
;cplot, fr=65, diff=25, /pressure, xz=0, smlev=0.002, /png, /notitle

;cplot, fr=25, /current, xy=0, /png, mmlev=[0,1], /notitle
;cplot, fr=25, /current, xy=0.8, /png, mmlev=[0,10], /notitle
;cplot, fr=25, /current, xz=0, /png, mmlev=[0,10], /notitle

;cplot, fr=25, /pressure, xy=0, /png, mmlev=[1.06,1.07], /notitle
;cplot, fr=25, /pressure, xy=0.8, /png, mmlev=[0.95,1.07], /notitle
;cplot, fr=25, /pressure, xz=0, /png, mmlev=[0.95,1.07], /notitle


cplot, fr=0, /forces, xy=0, /png
cplot, fr=25, /forces, xy=0, /png
cplot, fr=0, /forces, xz=0, /png
cplot, fr=25, /forces, xz=0, /png

cd, '../j1'

cplot, fr=0, /forces, xy=0, /png
cplot, fr=25, /forces, xy=0, /png
cplot, fr=0, /forces, xz=0, /png
cplot, fr=25, /forces, xz=0, /png

cplot, fr=25, /current, xy=0, /png
cplot, fr=25, /pressure, xy=0, /png

cplot, fr=25, /current, xz=0, /png
cplot, fr=25, /pressure, xz=0, /png

cplot, fr=25, /current, xy=0.8, /png
cplot, fr=25, /pressure, xy=0.8, /png

lplot, /energy, /all, /relax, scale=3, /png

view3d, 25, j=3, /flines, /null, /box, /png

cd, '../j0.5'

cplot, fr=25, /current, xy=0, /png
cplot, fr=25, /pressure, xy=0, /png

cplot, fr=25, /current, xz=0, /png
cplot, fr=25, /pressure, xz=0, /png

cplot, fr=25, /current, xy=0.8, /png
cplot, fr=25, /pressure, xy=0.8, /png

lplot, /energy, /all, /relax, scale=3, /png

view3d, 25, j=1.5, /flines, /null, /box, /png


