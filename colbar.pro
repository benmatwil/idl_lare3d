pro colbar,mini,maxi,reverse=reverse,zerobar=zerobar, ncolors = ncolors
;This programme plots a colourbar. 
;loc decides the position of the colorbar frame, then the bar is
;picked to be vertical, the colours only go to 252 so I have 2 colours for the
;sepsurfs. The bar is drawn at a position by tv.

if not keyword_set(ncolors) then ncolors = 254

nxpixels = 900
nypixels = 800

loc = [0.04, 0.4, 0.08, 0.4+float(ncolors-2)/nypixels]
;loc = [0.125,0.3,0.1655,0.81*252./256.]

bar = Replicate(1B, (loc(2) - loc(0))*nxpixels) # Bindgen(ncolors-2)
bar = 2+BytScl(bar, Top=ncolors-2)

if keyword_set(reverse) then begin
print,'Reversing!'
bar = Replicate(1B, 22) # (251 - Bindgen(251))
bar = 2+BytScl(bar, Top=252)
endif

if keyword_set(zerobar) then begin
bar = Replicate(1B, 22) # Bindgen(250)
bar = 2+BytScl(bar, Top=254)
endif

tv, bar, loc(0),loc(1),/normal
PlotS, [loc(0), loc(0), loc(2), loc(2), loc(0)], $
       [loc(1), loc(3), loc(3), loc(1), loc(1)], /Normal
Plot, [0,1], [0,1], /NoData, /NoErase, Position=loc, $
     yrange=[mini,maxi], yTicks=4, xTickFormat='(A1)', xTicks=1, $
     xMinor=0, yTicklen=0.25, yMinor=0, yStyle=1, xStyle=1, charsize=0.8
;, col = 255

;change charsize to 1.0 for fan_surf_cep
end
