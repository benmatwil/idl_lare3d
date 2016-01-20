pro lplotold, energy=energy, mag=mag, int=int, kin=kin, logke=logke, total=total, all=all, fast=fast, png=png, filename=filename, relax=relax, recon=recon, xr=xr, yr=yr, legend=legend, ohmic=ohmic, shift=shift, thick=thick, normalcoord=normalcoord, datacoord=datacoord

; Line plots one of a range of different plots from LARE data
; Inputs:
;     energy - an energy plot
;         fast - normalise the time by the fast crossing time
;         all - plot all energies together, edit shift parameter for positioning
;             shift - shift all lines by this amount
;             thick - plot line thickness
;         logke - log of the kinetic energy
;         me, ie, ke, ohmic - magnetic/internal/kinetic energy/ohmic heating
;         total - total normalised energy
;     png - save as a png
;         filename - filename to save png as
;     legend - top left corner location of the legend in data (by default) or /normal coordinates

  plotstart, ct = 39

  if keyword_set(energy) then begin
  
    dirname = 'energy'

	  e = getenergy()
	  
	  if keyword_set(relax) then begin
	    s1 = 0
	    s2 = max(where(e.heating_ohmic eq 0))-1
	  endif else begin
      if keyword_set(recon) then begin
        s1 = max(where(e.heating_ohmic eq 0))-1
        s2 = n_elements(e.time)-1
	    endif else begin
	      s1 = 0
        s2 = n_elements(e.time)-1
	    endelse
	  endelse

	  ; Normalise if required
	  if keyword_set(fast) then begin
	    time = e.time/fasttime(fast) & xtitle = "Normalised time"
	  endif else time = e.time & xtitle = "Time"

	  ; Create variables of the correct length
	  sz = n_elements(time)-1
	  time = time[s1:s2]-time[s1]
	  me = e.en_b[s1:s2]
	  ke = e.en_ke[s1:s2]
	  ie = e.en_int[s1:s2]
	  vh = e.heating_visc
	  oh = e.heating_ohmic
	  ah = e.en_int - vh - oh
	  vhr = ([0,(vh[0:sz-1]-vh[1:sz])/(e.time[0:sz-1]-e.time[1:sz])])[s1:s2]
	  ohr = ([0,(oh[0:sz-1]-oh[1:sz])/(e.time[0:sz-1]-e.time[1:sz])])[s1:s2]
	  ahr = ([0,(ah[0:sz-1]-ah[1:sz])/(e.time[0:sz-1]-e.time[1:sz])])[s1:s2]
	  vh = vh[s1:s2]
	  oh = oh[s1:s2]
	  ah = ah[s1:s2]
	  tne = ((e.en_b+e.en_ke+e.en_int)/(e.en_b(0)+e.en_ke(0)+e.en_int(0)))[s1:s2]
	  sz = n_elements(time)-1
	  
	  charsize = 3

	  if keyword_set(mag) then begin
      plot, time, me, xr = xr, yr = yr, title = "Magnetic energy", xtitle = xtitle, charsize = charsize
      fname = 'me'
    endif

	  if keyword_set(int) then begin
	    plot, time, ie, xr = xr, yr = yr, title = "Internal energy", xtitle = xtitle, charsize = charsize
	    fname = 'ie'
	  endif

	  if keyword_set(kin) then begin
	    plot, time, ke, xr = xr, yr = yr, title = "Kinetic energy", xtitle = xtitle, charsize = charsize
	    fname = 'ke'
	  endif

	  if keyword_set(logke) then begin
	    plot_io, time, ke, title = "Log of the Kinetic Energy", xtitle = xtitle, charsize = charsize
	    fname = 'logke'
	  endif

	  if keyword_set(total) then begin
	    plot, time, tne, xr = xr, yr = yr, title = "Total Normalised energy", xtitle = xtitle, charsize = charsize
	    fname = 'totnormen'
	  endif

	  if keyword_set(ohmic) then begin
	    plot, time, ohr, xr = xr, yr = yr, title = "Total Normalised energy", xtitle = xtitle, charsize = charsize
	    fname = 'ohmic'
	  endif

  ;##################################################

	  if keyword_set(all) then begin
	  
	    if not keyword_set(thick) then thick = 2
	  
	    ; legend spacing/location options
	    if keyword_set(legend) then begin
    	  if keyword_set(normalcoord) then ncoord = legend else ncoord = convert_coord(legend(0),legend(1),/data,/to_normal)
	      lcx = ncoord(0) ; legend x position of corner
	      lcy = ncoord(1) ;  legend y position of corner
	    endif else begin
	      lcx = 0.2
	      lcy = 0.6
	    endelse

	    bdr = 15
	    bdr = convert_coord(bdr,bdr,/device,/to_normal)

	    lx = lcx + bdr(0)
	    ly = lcy - bdr(1)

	    ygap = 0.03 ; gap between lines
	    lf = lx+0.05 ; how long for the line in x
	    txsx = lf+0.01 ; set x position for text starting
	    txsy = ly-0.005-ygap/2 ; set y position for text starting
	    ltxtsize = 1.5 ; legend textsize
	  
	    if keyword_set(relax) then begin
		    if not keyword_set(shift) then shift = 0.8
		    me1 = me - me(0) + shift
		    ie1 = ie - ie(0) + me1(sz)
		    vh1 = vh - vh(0) + ie1(0)
		    plt = [[tne], [ke], [me1], [ie1], [vh1], [ah - ah(0) + (vh1)(sz)], [oh - oh(0)]]
		    ltit = ['Total Normalised Energy','Kinetic Energy','Magnetic Energy','Internal Energy','Viscous Heating','Adiabatic Heating','Ohmic Heating']
		    cval = [255,95,50,150,207,250,18]
		    dval = [me1(0),me1(sz),(vh - vh(0) + ie1(0))(sz)]
		    fname = 'energiesrelax'
		  endif

		  if keyword_set(recon) then begin
		    xticks = 4
		    if recon eq 1 then begin
		      me0 = me[0]
		      me = temporary(me)/me0
		      ie = temporary(ie)/me0
		      ke = temporary(ke)/me0
		      tne = temporary(tne)/me0
          me1 = me - me[sz]
          ke1 = ke - ke[0] + me1[sz]
          ie1 = ie - ie[0] + ke1[sz]
		      plt = [[tne-tne[0]+1.1*me1[0]], [me1], [ke1], [ie1]]
		      ltit = ['Total Normalised Energy','Magnetic Energy','Kinetic Energy','Internal Energy']
		      cval = [255,50,95,150]
		      dval = [me1(0),me1(sz)]
		      fname = 'energiesrecon'
		    endif
		    
		    if recon eq 2 then begin
		      plt = [[ohr], [vhr], [ahr]]
		      ltit = ['Ohmic Heating','Viscous Heating','Adiabatic Heating']
		      cval = [18,207,250]
		      dval = !null
		      fname = 'energiesreconheat'
		    endif
		  endif
		  
		  if min(plt) gt 0 then ysize = [0,max(plt)*1.02] else ysize = [min(plt)*1.02,max(plt)*1.02]

	    ;Create first plot (Total normalised energy)
	    if keyword_set(relax) then plot_oi, [time[0],time[sz]], ysize, title = "Energy Evolution", xtitle = xtitle, xticks = xticks, /nodata, xr = xr, yr = yr else plot, [time[0],time[sz]], ysize, title = "Energy Evolution", xtitle = xtitle, xticks = xticks, /nodata, xr = xr, yr = yr

	    nplts = n_elements(plt)/n_elements(time)
	    txtwid = dblarr(nplts)
	    foreach col, cval, i do begin
	      oplot, time, plt[*,i], col = cval(i), thick = thick
	      plots, [lx,lf], [ly-ygap*(i+0.5),ly-ygap*(i+0.5)], col = col, /normal, thick=thick
	      xyouts, txsx, txsy-ygap*i, ltit(i), /normal, charsize=ltxtsize, width = width
	      txtwid(i) = width
	    endforeach

	    sw = [lcx,ly-nplts*ygap-bdr(1)]
	    nea = [txsx+max(txtwid)+bdr(0),lcy]
	    bdrcoord = [[lcx,lcy],[nea],[nea(0),sw(1)],[sw]]

	    plots, bdrcoord(*,0), /normal
	    foreach i, [1,2,3,0] do plots, bdrcoord(*,i), /normal, /continue

	    foreach val, dval do oplot, time, replicate(val,sz+1), thick = thick, linestyle = 1

	  endif

  endif

  ; if want to plot something not used by options, insert here (set the filename with fname)

  if keyword_set(png) then begin
    if keyword_set(filename) then filename = 'pngs/' + dirname + '/' + filename +'.png' else filename = 'pngs/' + dirname + '/' + fname + '.png'
    if not file_test('pngs', /directory) then file_mkdir, 'pngs'
    if not file_test('pngs/'+dirname, /directory) then file_mkdir, 'pngs/'+dirname
    write_png, filename, tvrd(/true)
    wdelete
  endif

end

; for an evolution of current plot
;restore, 'evocurrents.sav'
;times = indgen(26)*2
;plot, times, maxj(*,0), yr = [0,16], xtitle = 'time', title = 'Evolution of max current', psym = -7, thick = 2
;oplot, times, maxj(*,1), col = 50, psym = -7, thick = 2
;oplot, times, maxj(*,2), col = 250, psym = -7, thick = 2

;oplot, [30,30], [10,10], col = 50, psym = 7, thick = 2
;xyouts, 32, 9.8, 'J = 2'
;oplot, [30,30], [11,11], psym = 7, thick = 2
;xyouts, 32, 10.8, 'J = 1'
;oplot, [30,30], [12,12], col = 250, psym = 7, thick = 2
;xyouts, 32, 11.8, 'J = 0.5'
