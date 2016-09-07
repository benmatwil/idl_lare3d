pro lplot, energy=energy, magnetic=magnetic, internal=internal, kinetic=kinetic, logke=logke, total=total, all=all, fast=fast, relax=relax, recon=recon, png=png, filename=filename, xr=xr, yr=yr, legpos=legpos, ohmic=ohmic, shift=shift, thick=thick, scale=scale, xlog=xlog, ylog=ylog, plt=plt, xtitle=xtitle, ytitle=ytitle, intepar=intepar, notitle=notitle, vdata=vdata, hdata=hdata, axistxtsize=axistxtsize

; Line plots one of a range of different plots from LARE data
; Inputs:
;     energy - an energy plot
;       fast - normalise the time by the fast crossing time
;       all - plot all energies together, edit shift parameter for positioning
;         relax - Relaxation part of the experiment
;         recon=1 - Reconnection part of the experiment with usual energies
;         recon=2 - Reconnection part of the experiment with heatings
;       logke - log of the kinetic energy
;       total - total normalised energy

if keyword_set(energy) then begin

  dirname = "energy"
  
  if not keyword_set(thick) then thick = 2

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
  
  ;stop
  
; Normalise if required
  if fast ne !null then begin
    time = e.time/fasttime(fast) & xtitle = "Normalised time $t/t_f$"
  endif else begin time = e.time & xtitle = "Time" & endelse
  
  if keyword_set(scale) then sf = scale else sf = 1
	  
; Create variables of the correct length
  sz = n_elements(time)-1
  time = time[s1:s2]-time[s1]
  me = sf*e.en_b[s1:s2]
  ke = sf*e.en_ke[s1:s2]
  ie = sf*e.en_int[s1:s2]
  vh = sf*e.heating_visc
  oh = sf*e.heating_ohmic
  ah = sf*e.en_int - vh - oh
  vhr = ([0,(vh[0:sz-1]-vh[1:sz])/(e.time[0:sz-1]-e.time[1:sz])])[s1:s2]
  ohr = ([0,(oh[0:sz-1]-oh[1:sz])/(e.time[0:sz-1]-e.time[1:sz])])[s1:s2]
  ahr = ([0,(ah[0:sz-1]-ah[1:sz])/(e.time[0:sz-1]-e.time[1:sz])])[s1:s2]
  vh = vh[s1:s2]
  oh = oh[s1:s2]
  ah = ah[s1:s2]
  tne = ((e.en_b+e.en_ke+e.en_int)/(e.en_b(s1)+e.en_ke(s1)+e.en_int(s1)))[s1:s2]
  sz = n_elements(time)-1

	if keyword_set(all) then begin

		if keyword_set(relax) then begin
	    if not keyword_set(shift) then shift = 0.8
	    me1 = me - me[0] + shift
	    ie1 = ie - ie[0] + me1[sz]
	    vh1 = vh - vh[0] + ie1[0]
	    pltval = [[tne], [ke], [me1], [ie1], [vh1], [ah - ah[0] + vh1[sz]], [oh - oh[0]]]
	    ltit = ['Total Normalised Energy', 'Kinetic Energy', 'Magnetic Energy', 'Internal Energy', 'Viscous Heating', 'Adiabatic Heating', 'Ohmic Heating']
	    cval = ['black','cyan','blue','lime','orange','red','purple']
	    dval = [me1[0],me1[sz],(vh - vh(0) + ie1(0))[sz]]
	    style = ['-','-','-','-','-','-','-']
	    pngname = 'energiesrelax'
	  endif

	  if keyword_set(recon) then begin
	    xticks = 4
	    if recon eq 1 then begin
	      me0 = me[0]
	      me = temporary(me)/me0
	      ie = temporary(ie)/me0
	      ke = temporary(ke)/me0
	      vh = temporary(vh)/me0
	      oh = temporary(oh)/me0
	      ah = temporary(ah)/me0
	      tne = temporary(tne)/me0
        ke1 = ke - ke[0]
        me1 = me - me[sz] + ke[sz]
        ie1 = ie - ie[0] + ke1[sz]
        oh1 = oh - oh[0]
        vh1 = vh - vh[0] + oh1[sz]
        ah1 = ah - ah[0] + vh1[sz]
        mult1 = 80
        ke2 = mult1*ke1
        mult = 5
	      pltval = [[tne-tne[0]+1.1*me1[0]], [me1], [ke1], [ie1], [oh1], [vh1], [ah1], [ke2]]*(10d)^mult
	      ltit = ['Total Normalised Energy','Magnetic Energy','Kinetic Energy','Internal Energy','Ohmic Heating','Viscous Heating','Adiabatic Heating','Kinetic Energy $\times$'+strcompress(string(mult1))]
	      cval = ["black","blue","cyan","lime","purple","orange","red","cyan"]
	      style = ['-','-','-','-','-','-','-','--']
	      dval = [me1(0),me1(sz)]*(10d)^mult
	      pngname = 'energiesrecon'
	    endif
	    
	    if recon eq 2 then begin
	      mult1 = 40;fix(max(ohr)/max(vhr))
        vhr2 = mult1*vhr
        mult = 4
	      pltval = [[ohr], [vhr], [ahr], [vhr2]]*(10d)^mult
	      ltit = ['Ohmic Heating','Viscous Heating','Adiabatic Heating','Viscous Heating $\times$'+strcompress(string(mult1))]
	      cval = ['purple','orange','red','orange']
	      style = ['-','-','-','--']
	      dval = !null
	      pngname = 'energiesreconheat'
	    endif
	  endif
	  
	  p = objarr(n_elements(cval))
	  
	  if mult ne !null then begin
	    ytitle = "Energy ($\times 10^{-"+strcompress(string(mult),/rem)+"}$)"
	  endif else ytitle = "Energy"
	  
	  if min(pltval) gt 0 then ysize = [0,max(pltval)*1.02] else ysize = [min(pltval)*1.02,max(pltval)*1.02]

		if not keyword_set(thick) then thick = 2
		
		if keyword_set(relax) then begin
		  xlog = 1
		  
		endif
		
		if time[0] eq 0 then begin
	    time = time[1:*]
	    pltval = pltval[1:*,*]
	    sz = sz-1
	  endif
		
		if relax ne !null then begin
		  skip = 50
		  time = time[0:sz:skip]
		  pltval = pltval[0:sz:skip,*]
		  sz = sz/skip
		endif
		
		title="Energy Evolution"
		
		if keyword_set(relax) then xlog = 1
		
		if keyword_set(notitle) then begin
      title = !null
      margin = [0.15,0.15,0.05,0.05]
      textsize = 16
    endif else margin = [0.15,0.15,0.05,0.1]
		
		plt = plot([time[0],time[sz]], ysize, title=title, xtitle=xtitle, ytitle=ytitle, /nodata, xr=xr, yr=yr, xlog=xlog, dim=[900,600], font_size=textsize)
		
		;xticks=xticks
		
		foreach col, cval, i do p[i] = plot(time, pltval[*,i], col=cval[i], thick=thick, name=ltit[i], /overplot, linestyle=style[i])
		foreach val, dval do p2 = plot(time, replicate(val,sz+1), thick=thick, linestyle=1, /overplot)

; Need to position legend depending on plotted lines
		leg = legend(target=p, position=legpos, /normal)
		;if keyword_set(axistxtsize) then plt.

	endif

;##################################################

  if not keyword_set(all) then begin

	  if keyword_set(magnetic) then begin
	    pdata = me
	    title = "Magnetic energy"
	    pngname = 'me'
	  endif

	  if keyword_set(internal) then begin
	    pdata = ie
	    title = "Internal energy"
	    pngname = 'ie'
	  endif

	  if keyword_set(kinetic) then begin
	    pdata = ke
	    title = "Kinetic energy"
	    pngname = 'ke'
	  endif

	  if keyword_set(logke) then begin
	    pdata = ke
	    title = "Log of the Kinetic Energy"
	    ytitle = 'log($E_k$)'
	    ylog = 1
	    pngname = "logke"
	  endif

	  if keyword_set(total) then begin
	    pdata = tne
	    title = "Total Normalised energy"
	    pngname = 'totalnorm'
	  endif

  endif

endif

if keyword_set(intepar) then begin
start=0
finish=0
int=!null
time=[0]
done=0

dirname = 'intepar'
datasave = 'pngs/'+dirname+'/inteparevo.sav'

  if file_test(datasave) then restore, datasave else begin  
    while done eq 0 do begin
      read, start, prompt="start="
      read, finish, prompt="end="
      for i = start, finish do begin
        print, i
        if (getdata(i, /empty)).time gt time[-1] then begin
          dat = getdata(i, /magnetic_field, /grid, /eta, /velocity)
          bgrid = mkbg(dat)
          egrid = mkeg(dat, bgrid=bgrid)
          dat = getdata(i, /grid)

          fl = fieldline3d([0,0,0.5],bgrid,dat.x,dat.y,dat.z,2d-3,1d-4,1d-2,1d-6)
          output = intepar(dat, fl, egrid)

          int = [int,output[0]]
          time = [time, dat.time]
        endif
        save, time, int, filename='inteparevoprogress.sav'
      endfor
      print, "To end calculations, set done = 1 otherwise change to new directory and .continue" & stop
    endwhile
    if time[0] eq 0 then time = time[1:-1]
    save, time, int, filename=datasave
  endelse
  
  time = time - 50
  if fast ne !null then time=time/fasttime(fast)
  title = "Evolution of the reconnection rate on the spine"
  if fast ne !null then xtitle = "$log_{10}(t/t_f)$" else xtitle = "$log_{10}t$"
  ytitle = "Reconnection rate"
  xlog = 1
  pngname = "inteparevo"
  pdata = abs(int)

  start = 0 & finish = 5
  l1 = ladfit(alog10(time[start:finish]),pdata[start:finish])
  print, l1
  start = 50 & finish = 199
  l2 = ladfit(alog10(time[start:finish]),pdata[start:finish])
  print, l2
  ;oplot1 = plot([time[start],time[start]],0.25*[-0.005,-0.015],/overplot)
  ;oplot2 = plot([time[finish],time[finish]],0.25*[-0.005,-0.015],/overplot)

endif

if vdata ne !null and hdata ne !null then begin
  time = vdata
  pdata = hdata
endif

if keyword_set(notitle) then begin
  title = !null
  margin = [0.15,0.15,0.05,0.05]
  textsize = 16
endif else margin = [0.15,0.15,0.05,0.1]

if not keyword_set(all) then plt = plot(time, pdata, xr=xr, yr=yr, title=title, xtitle=xtitle, ytitle=ytitle, ylog=ylog, xlog=xlog, thick=thick, dim=[900,600], xstyle=1, margin=margin, xtickfont_size=textsize, ytickfont_size=textsize)

if keyword_set(intepar) then begin
  y1 = l1[0] + l1[1]*alog10(time)
  plt1 = plot(time, y1, /overplot, col='red', name='$y = ' + string(l1[0], /print) + '+' + string(l1[1], /print) + 'log_{10}t $', thick=thick, linestyle='--')
  y2 = l2[0] + l2[1]*alog10(time)
  plt2 = plot(time, y2, /overplot, col='blue', name='$y = ' + string(l2[0], /print) + '+' + string(l2[1], /print) + 'log_{10}t $', thick=thick, linestyle='--')
  
  print, 'Adjust x, y axes with plt.{xr,yr}=[min,max]'
  print, 'Use leg = legend(target=[plt1,plt2], position=legpos, /normal) for a legend'
  print, '.cont when ready to continue'
  stop
  ;plt.yr=[-0.015,0]

  ;e = getenergy()          
  ;s1 = max(where(e.heating_ohmic eq 0))-1
  ;s2 = n_elements(e.time)-1
  ;time = e.time
  ;sz = n_elements(time)-1
  ;time = time[s1:s2]-time[s1]
  ;oh = e.heating_ohmic
  ;ohr = ([0,(oh[0:sz-1]-oh[1:sz])/(e.time[0:sz-1]-e.time[1:sz])])[s1:s2]
  ;sz = n_elements(time)-1
  ;p3  = plot(time, ohr, 'purple', /current, name=ohmic, xr=[0,max(time)], yrange=[0,max(ohr)], axis_style=0, margin=margin, /xlog)
  ;stop
  
  ;leg = legend(target=[plt1,plt2], position=legpos, /normal)
endif

;stop

; only have x,y axis and put ticks pointing outward
plt['axis2'].delete
plt['axis3'].delete
plt.xtickdir = 1
plt.ytickdir = 1
if not keyword_set(notitle) then plt.title.font_size = 18

if keyword_set(png) then begin
  if keyword_set(filename) then filename = 'pngs/' + dirname + '/' + filename +'.png' else filename = 'pngs/' + dirname + '/' + pngname + '.png'
  if not file_test('pngs', /directory) then file_mkdir, 'pngs'
  if not file_test('pngs/'+dirname, /directory) then file_mkdir, 'pngs/'+dirname
  plt.save, filename, width=1600;, antialias=0; need to sort this
  plt.close
endif

end
