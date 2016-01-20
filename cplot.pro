pro cplot, frame=frame, dat=dat, bgp=bgp, xy=xy, xz=xz, yz=yz, xeqy=xeqy, xeqnegy=xeqnegy, current=current, perp=perp, parallel=parallel, pressure=pressure, png=png, dims=dims, res=res, ctable=ctable, rctable=rctable, customct=customct, samelevels=samelevels, mmlevels=mmlevels, smlevels=smlevels, customlevels=customlevels, addfname=addfname, magnitude=magnitude, flines=flines, nflines=nflines, eigenvectors=eigenvectors, hires=hires, circle=circle, lines=lines, intepar=intepar, difference=difference, customfname=customfname, plotmax=plotmax, plotmin=plotmin, plotpositions=plotpositions, cplt=cplt, filename=filename, spine=spine, eparsep=eparsep, vperpsep=vperpsep, vortzsep=vortzsep, vzsep=vzsep, ylog=ylog, xlog=xlog, onesign=onesign, vorticity=vorticity, forces=forces, fast=fast, notitle=notitle

; Plots one of a range of different plots from LARE data
; Inputs:
;     frame - frame number input, will load frame with the correct data automatically
;     diff - use this to load frame number to take away from data, only works with frame
;     din - input data, make sure all data required is loaded
;     hires - save at high resolution 4000x3200, if keyword isn't set, plots will save at 1000x800 resolution
;     bgp - B.grad(p) contour plot
;     current - a current contour plot
;         perp - current perpendicular to the magnetic field
;         parallel - current parallel to the magnetic field
;     pressure - pressure contour plot
;     png - save resulting plot as a .png
;     xy - z=xy plane, yz - x=yz plane, xz - y=xz plane, xeqy - x=y plane, xeqnegy - x=-y plane (Need to define the plane required)
;     ctable - input number of colourtable to use (rctable is the same but reverses the table)
;     mmlevels - input size 2 array [minlev,maxlev] with min and max of contour levels wanted, anything outside the range will be the min/max colour in the colourtable
;     smlevels - similar to mmlevels, but symmetric so becomes [-smlevels,smlevels]
;     customlevels - input a custom contour level array e.g. 10^findgen(10)
;     samelevels - same contour levels for all 5 planar plots
;     magnitude - magnitude of data (currents are already positive)
;     customct - input a custom colourtable, give array for only certain colours from full colourtable e.g. [indgen(96), indgen(144-112)+112, indgen(255-160)+160]
;     dims - pixel dimensions of the plotting window (**not added yet**), default: 640 x 512 (5:4)
;     addfname - add extra details to the filename for saving, ignored if no /png
;     customfname - make a custom filename for saving (without .png)
;     flines - add field lines to the contour plot
;         nflines - add how many field lines to plot, default: 32
; Outputs:
;     cplt - output the contour plot created for use elsewhere
;     filename - output the filename of the plot created if it were saved by this procedure

; To add new data to plot: need to add required if statements, the data to plot (pdata), the colourtable (add to lct.pro or define here)

t0 = systime(/seconds)
;if not keyword_set(dims) then dims = [750, 600]
  
;##################################################

  if keyword_set(current) or keyword_set(bgp) or keyword_set(pressure) or keyword_set(vorticity) or keyword_set(forces) then begin
	  
    if difference ne !null then diffarr = [frame, difference] else diffarr = [frame]
	  
	  foreach nframe, diffarr do begin
	  
	    print, "Looking at frame " + string(nframe, format='(I3.3)')
	  
      if keyword_set(current) then begin ; calculate the data for currents
	      if frame ne !null then dat = gdata(nframe)
	      if keyword_set(perp) then begin
          pngname = "jperp"
          title = "$\bf J_\perp\rm$"
          pdata = absjperp(dat)
        endif else begin
          if keyword_set(parallel) then begin
            pngname = "jparallel"
            title = "$\bf J_\parallel\rm$"
            pdata = absjparallel(dat)
          endif else begin
            pngname = "jtotal"
            title = "$\bf J\rm$"
            pdata = sqrt(vecmag2(mkjg(dat)))
          endelse
        endelse
        title = "$\mid$" + title +"$\mid$"
        dirname = 'current'
    
      endif

      if keyword_set(bgp) then begin ; calculate the data for b.grad(p)
        if frame ne !null then dat = gdata(nframe,/bgp)
        pngname = "bgp"
        title = "$ \bf B \rm \cdot \bf \nabla \rm p$"
        pdata = gridmove(bgradp(dat))
        if keyword_set(magnitude) then begin
          pdata = abs(temporary(pdata))
          title = "$\mid$" + title +"$\mid$"
        endif
        dirname = 'bgradp'
      endif
    
      if keyword_set(pressure) then begin
        if frame ne !null then dat = gdata(nframe,/pressure)
        pngname = "pressure"
        title = "Pressure"
        pdata = gridmove(dat.pressure)
        dirname = 'pressure'
      endif
      
      if keyword_set(vorticity) then begin
        if frame ne !null then dat = getdata(nframe, /grid, /velocity)
        pdata = gridmove((mkvortg(dat))[*,*,*,2])
        title = "$\omega_z$
        dirname = "vorticity"
        pngname = "vort"
        opdata = (mkvg(dat))[*,*,*,0:1]
        z = dat.grid.z
        iz = posfinder(xy,z) ; select the correct data to plot
        opdata = opdata[*,*,iz,*] + (xy - z[iz])/(z[iz+1]-z[iz])*(opdata[*,*,iz+1,*]-opdata[*,*,iz,*])
        ovec = 1
        skip = 32
        opdata = opdata[0:*:skip,0:*:skip,*,*]
        opdata = reform(opdata)
        sopd = size(opdata)
        opdata = opdata[sopd[1]/4:3*sopd[1]/4,sopd[2]/4:3*sopd[2]/4,*]
        ox = (dat.grid.x[0:*:skip])[sopd[1]/4:3*sopd[1]/4]
        oy = (dat.grid.y[0:*:skip])[sopd[2]/4:3*sopd[2]/4]
      endif
      
      if keyword_set(forces) then begin
        if frame ne !null then dat = getdata(nframe,/pressure,/magnetic_field,/grid)
        pngname = "forces"
        title = "Forces"
        pdata = sqrt(vecmag2(mkjxbg(dat) - mkgradpg(dat)))
        dirname = 'forces'
      endif
    
      title = title + " in the plane "
    
      if keyword_set(samelevels) then begin
        maxlev = max(pdata)
        minlev = min(pdata)
      endif
      
      if opdata ne !null and ovec eq !null then ntimes = 2 else ntimes = 1 
      
      for in = 1, ntimes do begin
        if ntimes eq 2 and in eq 2 then pdata = opdata
        
        npt = intarr(3)
        npt[0] = n_elements(dat.grid.x)
        npt[1] = n_elements(dat.grid.y)
        npt[2] = n_elements(dat.grid.z)
        npd = (size(pdata))[1:3] ; size of pdata
        ss = (npt-npd)/2 ; start subscripts
        es = npt-1-ss ; end subscripts
        mps = (npd-1)/2 ; midpoint subscripts
    
        if xy ne !null then begin
          x = dat.grid.x[ss[0]:es[0]] ; create x grid
          y = dat.grid.y[ss[1]:es[1]] ; create y grid
          z = dat.grid.z[ss[2]:es[2]]
          iz = posfinder(xy,z) ; select the correct data to plot
          pdata = pdata[*,*,iz] + (xy - z[iz])/(z[iz+1]-z[iz])*(pdata[*,*,iz+1]-pdata[*,*,iz])
          if xy lt 0 then plane = string(xy, format='(F6.3)') else plane = string(xy, format='(F5.3)')
          title = title + "z = "
          pngname = pngname + "xy"
          xtitle = "x"
          ytitle = "y"
        endif
		
        if xz ne !null then begin
          x = dat.grid.x[ss[0]:es[0]]
          y = dat.grid.z[ss[2]:es[2]]
          z = dat.grid.y[ss[1]:es[1]]
          iz = posfinder(xz,z)
          pdata = pdata[*,iz,*] + (xz - z[iz])/(z[iz+1]-z[iz])*(pdata[*,iz+1,*]-pdata[*,iz,*])
          if xz lt 0 then plane = string(xz, format='(F6.3)') else plane = string(xz, format='(F5.3)')
          title = title + "y = "
          pngname = pngname + "xz"
          xtitle = "x"
          ytitle = "z"
        endif
		
        if yz ne !null then begin
          x = dat.grid.y[ss[1]:es[1]]
          y = dat.grid.z[ss[2]:es[2]]
          z = dat.grid.x[ss[0]:es[0]]
          iz = posfinder(yz,z)
          pdata = pdata[iz,*,*] + (yz - z[iz])/(z[iz+1]-z[iz])*(pdata[iz+1,*,*]-pdata[iz,*,*])
          if yz lt 0 then plane = string(yz, format='(F6.3)') else plane = string(yz, format='(F5.3)')
          title = title + "x = "
          pngname = pngname + "yz"
          xtitle = "y"
          ytitle = "z"
        endif
        
        if xy ne !null or xz ne !null or yz ne !null then begin
          title = title + plane
          pngname = pngname + plane
        endif
		    
        if keyword_set(xeqy) then begin
          x = dat.grid.x[ss[0]:es[0]]*sqrt(2)
          y = dat.grid.z[ss[2]:es[2]]
          pdata1 = dblarr(es[0]-ss[0]+1,es[2]-ss[2]+1)
          for i = 0, es[0]-ss[0] do pdata1[i,*] = pdata[i,i,*]
          pdata = temporary(pdata1)
          title = title + "x = y"
          pngname = pngname + "x=y"
          xtitle = "Along line x = y"
          ytitle = "z"
        endif

        if keyword_set(xeqnegy) then begin
          x = dat.grid.x[ss[0]:es[0]]*sqrt(2)
          y = dat.grid.z[ss[2]:es[2]]
          pdata1 = dblarr(es[0]-ss[0]+1,es[2]-ss[2]+1)
          for i = 0, es[0]-ss[0] do pdata1[i,*] = pdata[i,es[0]-ss[0]-i,*]
          pdata = temporary(pdata1)
          title = title + "x = -y"
          pngname = pngname + "x=-y"
          xtitle = "Along line x = -y"
          ytitle = "z"
        endif
        
        if nframe eq diffarr[0] then time = dat.time
      
        if difference ne !null then begin
          if nframe eq diffarr[0] then begin
            pdata2 = pdata
            if keyword_set(flines) then bgrid = mkbg(dat, /v)
          endif
          if nframe eq diffarr[1] then begin
            pdata = pdata2 - pdata
            title = 'Difference in '+  title
          endif
        endif
        
        if ntimes eq 2 and in eq 1 then temppdata = pdata
        if ntimes eq 2 and in eq 2 then begin
          opdata = pdata
          pdata = temppdata
        endif
        
      endfor
      
      pdata = reform(temporary(pdata))
      if opdata ne !null then opdata = reform(temporary(opdata))
	  
    endforeach
  
  endif
  
;##################################################
  
  if keyword_set(intepar) then begin ; for plotting the integral of E parallel in a plane
    zval = intepar
    if zval lt 0 then zval = string(zval, format='(F5.2)') else zval = string(zval, format='(F4.2)')
    datasave = 'pngs/intepar/intepar' + string(frame, format='(I3.3)') + "z" + zval + '.sav'
    stpt = intepargrid(dat, zval, regular = 1000L)
    
    if file_test(datasave) then restore, datasave else begin
      npts = n_elements(stpt)/3
      npercent = npts/100
      k = 0

      dat = getdata(frame, /magnetic_field, /grid, /eta, /velocity)
      egrid = mkeg(dat)
      bgrid = mkbg(dat)
      dat = getdata(frame, /grid)
      
      int = dblarr(npts)
      endpt1 = dblarr(3,npts)
      endpt2 = dblarr(3,npts)
      magf = dblarr(3,npts)
      length = dblarr(npts)

      for i = 0, npts-1 do begin
        fl = fieldline3d(stpt[*,i],bgrid,dat.x,dat.y,dat.z,2d-3,1d-4,1d-2,1d-6)
        output = intepar(dat, fl, egrid)

        n = n_elements(fl)/3-1
        int[i] = output[0]
        endpt1[*,i] = fl[*,0]
        endpt2[*,i] = fl[*,n]
        magf[*,i] = trilinear_3d(stpt[0,i],stpt[1,i],stpt[2,i],bgrid,dat.x,dat.y,dat.z)
        length[i] = output[1]
        
        if i mod npercent eq 0 then begin
          print, k
          k++
        endif
      endfor
      save, int, stpt, endpt1, endpt2, magf, length, filename=datasave
    endelse
    
    pdata = int
    x = stpt[0,*]
    y = stpt[1,*]
    title = "Integral of $E_\parallel$ along fieldline passing through the point at z = " + zval
    pngname = "intepar" + zval
    xtitle = "x"
    ytitle = "y"
    xstyle = 1
    ystyle = 1
    dirname = 'intepar'
  endif
  
;##################################################
  
  if keyword_set(spine) then begin
    dirname = 'spinetimeevo'
    if keyword_set(eparsep) then begin
      dat = getdata(26, /grid)
      nx = dat.grid.npts[0]-2
      ny = dat.grid.npts[1]-2
      nz = dat.grid.npts[2]-2
      epar = dblarr(nz-2,40)
      disb = epar
      time = []
      datasave = "pngs/spinetimeevo/discrb.sav"
      
      if file_test(datasave) then restore, datasave else begin
        for i = 26, 65 do begin
          print, i
          d = getdata(i, /grid, /magnetic_field, /eta)
          time = [time, d.time]
          epar[*,i-26] = reform((gridmove(eparallel(dat)))[nx/2-1,ny/2-1,*])
          
          b = reform((mkbg(d,/v))[nx/2-1:nx/2+1,ny/2-1:ny/2+1,1:nz-2,0:1])
          x = (dat.grid.x[1:nx])[nx/2-1:nx/2+1]
          y = (dat.grid.y[1:ny])[ny/2-1:ny/2+1]
          dbxdx = reform((b[2,1,*,0] - b[0,1,*,0])/(x[2]-x[0]))
          dbydy = reform((b[1,2,*,1] - b[1,0,*,1])/(y[2]-y[0]))
          dbxdy = reform((b[1,2,*,0] - b[1,0,*,0])/(y[2]-y[0]))
          dbydx = reform((b[2,1,*,1] - b[0,1,*,1])/(x[2]-x[0]))
          disb[*,i-26] = (dbxdx-dbydy)^2 + 4*dbydx*dbxdy
        endfor
        save, epar, disb, time, filename=datasave
      endelse
      
      pdata = epar
      opdata = disb
      x = dat.grid.z[2:nz-1]
      title = "Evolution of $\bf E_\parallel \rm$ (filled) and the discriminant of $\bf B_\perp \rm$ (contours) along the spine"
      pngname = 'discrb'
      
    endif
    
    if keyword_set(vortzsep) then begin
      dat = getdata(26, /grid)
      nx = dat.grid.npts[0]-1
      ny = dat.grid.npts[1]-1
      nz = dat.grid.npts[2]-1
      vortz = dblarr(nz-1,40)
      time = []
      datasave = 'pngs/spinetimeevo/vortz.sav'
      
      ;restore, "pngs/spinetimeevo/discrb.sav"
      ;time = []
      
      restore, "pngs/spinetimeevo/disvperp.sav"
      time = [] 
      
      if file_test(datasave) then restore, datasave else begin
        for i = 26, 65 do begin
          print, i
          dat = getdata(i, /grid, /velocity)
          vortg = gridmove(mkvortg(dat))
          time = [time, dat.time]
          vortz[*,i-26] = vortg[nx/2-1,ny/2-1,*,2]
        endfor
        save, vortz, time, filename=datasave
      endelse
      
      pdata = vortz[1:nz-3,*]
      opdata = disv
      ;c_value = [-8,-6,-4,-2,2,4,6,8]*0.001
      c_value = 0.01*(indgen(15)-14)
      x = dat.grid.z[2:nz-2]
      title = "Evolution of $\omega_z$ along the spine"
      pngname = 'vortz'
    endif
    
    if keyword_set(vperpsep) then begin
      dat = getdata(26, /grid)
      nx = dat.grid.npts[0]
      ny = dat.grid.npts[1]
      nz = dat.grid.npts[2]
      epar = dblarr(nz-4,40)
      v = dblarr(3,3,nz-4,2)
      disv = epar
      time = []
      datasave = 'pngs/spinetimeevo/disvperp.sav'

      if file_test(datasave) then restore, datasave else begin
        for i = 26, 65 do begin
          print, i
          dat = getdata(i, /grid, /magnetic_field, /eta, /velocity)
          time = [time, dat.time]
          epar[*,i-26] = reform((gridmove(eparallel(dat)))[nx/2-2,ny/2-2,*])
          
          v[*,*,*,0] = d.vx[nx/2-1:nx/2+1,ny/2-1:ny/2+1,2:nz-3]
          v[*,*,*,1] = d.vy[nx/2-1:nx/2+1,ny/2-1:ny/2+1,2:nz-3]
          x = dat.grid.x[nx/2-1:nx/2+1]
          y = dat.grid.y[ny/2-1:ny/2+1]
          dvxdx = reform((v[2,1,*,0] - v[0,1,*,0])/(x[2]-x[0]))
          dvydy = reform((v[1,2,*,1] - v[1,0,*,1])/(y[2]-y[0]))
          dvxdy = reform((v[1,2,*,0] - v[1,0,*,0])/(y[2]-y[0]))
          dvydx = reform((v[2,1,*,1] - v[0,1,*,1])/(x[2]-x[0]))
          disv[*,i-26] = (dvxdx-dvydy)^2 + 4*dvydx*dvxdy
        endfor
        save, epar, disv, time, filename=datasave
      endelse
      
      pdata = disv
      opdata = epar
      x = dat.grid.z[2:nz-3]
      title = "Evolution of the discriminant of $\bf v_\perp \rm$ (filled) and $\bf E_\parallel \rm$ (contours) along the spine"
      pngname = 'discrv'
      c_value = [-8,-6,-4,-2,2,4,6,8]*0.001
    endif
    xtitle = "Distance along spine ($z$-axis)"
    ytitle = "$log_{10}t$"
    ylog = 1
    yrange = [0.05,2]
    y = time-50
    if fast ne !null then begin
      y = y/fasttime(fast)
      yrange = yrange/fasttime(fast)
      ytitle = "$log_{10}(t/t_f)$"
    endif
  endif
  
;##################################################

; load the colourtable
  maxpd = max(pdata)
  minpd = min(pdata)
  if minpd ge 0 or maxpd le 0 then onesign=1
  if keyword_set(ctable) then ct = colortable(ctable) else if keyword_set(rctable) then ct = colortable(rctable, /reverse) else begin
    ct = lct(current=current, pressure=pressure, difference=difference, bgp=bgp, intepar=intepar, eparsep=eparsep, vperpsep=vperpsep, vortzsep=vortzsep, vzsep=vzsep, onesign=onesign, vorticity=vorticity, forces=forces)
  endelse
  
; set the colours from the colourtable required
  if keyword_set(customct) then index = customct else index = bindgen(n_elements(ct)/3)
  ncolors = n_elements(index)
  
  slev = findgen(ncolors+1)/ncolors

; set the contour levels for the plot
  if keyword_set(customlevels) then begin
    lev = customlevels
  endif else begin
    if keyword_set(mmlevels) or keyword_set(smlevels) then begin
      if keyword_set(smlevels) then mmlevels = smlevels*[-1,1]
      if mmlevels[0] lt minpd and mmlevels[1] gt maxpd then begin
        lev = slev*(mmlevels[1]-mmlevels[0]) + mmlevels[0]
      endif else begin
        lev = dblarr(ncolors+1)
        lev[0] = minpd;*1.01
        lev[ncolors] = maxpd;*1.01
        lev[1:ncolors-1] = (dindgen(ncolors-1)/(ncolors-2))*(mmlevels[1]-mmlevels[0])+mmlevels[0]
      endelse
      ;lev = slev*(mmlevels[1]-mmlevels[0]) + mmlevels[0]
    endif else begin
      if minlev eq !null then begin
        minlev = minpd
        maxlev = maxpd
      endif
      lev = (slev*(maxlev-minlev) + minlev);*1.02
    endelse
  endelse
  
; if keyword_set(intepar) then irregular = 0 else irregular = 0

; add the time to the title
  if not (keyword_set(spine) or keyword_set(intepar)) then title = title + ' at t = ' + string(time,format='(F-6.3)')
  if keyword_set(spine) then asprat = 0 else asprat = 1
  
  mid = 0.5 & cbstretch = 0.4
  
  if keyword_set(notitle) then begin
    ; prepare for colourbar at the top horizontally
    margin = [0.15,0.15,0.05,0.15]
    title = !null
    cbpos = [mid-cbstretch, 1.1, mid+cbstretch, 1.18]
    cborient = 0
  endif else begin
    ; prepare for colourbar on the right vertically
    margin = [0.15,0.15,0.15,0.1]
    cbpos = [1.12, mid-cbstretch, 1.18, mid+cbstretch]
    cborient = 1
  endelse

; plot the contours
  cplt = contour(pdata, x, y, /fill, title=title, rgb_table=ct, c_value=lev, aspect_ratio=asprat, rgb_indices=index, xtitle=xtitle, ytitle=ytitle, xtickfont_size=12, ytickfont_size=12, xlog=xlog, ylog=ylog, xrange=xrange, yrange=yrange, margin=margin, xstyle=xstyle, ystyle=ystyle)
  
  if keyword_set(plotmax) or keyword_set(plotmin) then begin
    if keyword_set(plotmax) then !null = max(pdata, loc) else !null = min(pdata, loc)
    loc = array_indices(pdata, loc)
    if n_elements(x) eq n_elements(pdata) then plt = plot([x[loc],x[loc]], [y[loc],y[loc]], symbol="+", /overplot) else plt = plot([x[loc[0]],x[loc[0]]], [y[loc[1]],y[loc[1]]], symbol="+", /overplot)
    ;ch = cplt.crosshair
    ;if n_elements(x) eq n_elements(pdata) then ch.location = [x[loc],y[loc]] else ch.location = [x[loc[0]],y[loc[1]]]
  endif
  
  if keyword_set(plotpositions) then begin
    npos = n_elements(plotpositions)/2
    for i = 0, npos-1 do if abs(plotpositions[0,i]) lt max(x) and abs(plotpositions[1,i]) lt max(y) then plt = plot([plotpositions[0,i],plotpositions[0,i]], [plotpositions[1,i],plotpositions[1,i]], symbol="+", sym_thick=3, /overplot, col='green')
  endif
	
;##################################################
  
  ; overplot fan fieldlines (xy-plane)
  if xy ne !null then if keyword_set(flines) and xy eq 0 then fanfield, nframe, plot=cplt
  
;##################################################
  
  if keyword_set(eigenvectors) and keyword_set(xy) then begin
    zf = 1
    !NULL = findnull_null_char([0,0,0], mkbg(dat), dat.x, dat.y, dat.z, 0.1, fan_vecs=fan_vecs)
    plt = plot(zf*[0,fan_vecs[0,0]],zf*[0,fan_vecs[1,0]],/overplot)
    plt = plot(zf*[0,fan_vecs[0,1]],zf*[0,fan_vecs[1,1]],/overplot)
    ;print, fan_vecs
    ;p = plot(zf*[0,0.73701134],zf*[0,0.16334426],/overplot)
    if zf lt 1 then begin
      cplt.xr=[-zf,zf]
      cplt.yr=[-zf,zf]
    endif
    pngname = pngname + 'eigen'
  endif

  if cplt['axis2'] ne !null then cplt['axis2'].delete
  if cplt['axis3'] ne !null then cplt['axis3'].delete
  cplt.xtickdir = 1
  cplt.ytickdir = 1
	
  ; plot the colourbar
  l1 = min(lev) & dl = max(lev) - l1
  if keyword_set(mmlevels) then begin & l1 = mmlevels[0] & dl = mmlevels[1] - l1 & endif
  cblev = dl*findgen(5)/4 + l1 ; assumes symmetric/uniform colourbar, needs changing for customlev
  cb = colorbar(range=[0,1]*dl + l1, tickvalues=cblev, tickname=string(cblev, format='(F0.3)'), orientation=cborient, target=cplt, /relative, position=cbpos, tickdir=1, ticklen=0.25)
  
  if keyword_set(xeqy) or keyword_set(xeqnegy) then begin
    cplt.translate, 0, 0.06, /normal
    cb.orientation = 0
    cb.position = [pos-0.25, 0.05, pos+0.25, 0.1]
    cb.translate, 0, 0.02, /normal
  endif
  
  if opdata ne !null then if ovec ne !null then begin
    if ovec eq 1 then ocplt = vector(opdata[*,*,0], opdata[*,*,1], ox, oy, /overplot, head_ind=1)
  endif else ocplt = contour(opdata, x, y, overplot=cplt, color='black', c_value=c_value)
  
  if not keyword_set(spine) then filename = "pngs/" + dirname + '/' + pngname + 'frame' + string(frame, format='(I3.3)') else filename = "pngs/" + dirname + '/' + pngname
  if keyword_set(addfname) then filename = filename + addfname
  if difference ne !null then filename = filename + "diff"
  if keyword_set(customfname) then filename = "pngs/" + customfname
  filename = filename + ".png"
  if not file_test('pngs', /directory) then file_mkdir, 'pngs'
  if not file_test('pngs/' + dirname, /directory) then file_mkdir, 'pngs/' + dirname
  
; save as a png
  if keyword_set(png) then begin
    if keyword_set(hires) then cplt.save, filename else cplt.save, filename, width=1000
    cplt.close
    print, "Saved as " + filename
  endif
  
  print, "Plotting took " + string(long(systime(/seconds) - t0),format='(I6)') + " seconds"

end

;    for j = 1, 5 do begin
;      case j of
;        1: bgp1(*,*,0) = (bgp(*,*,(nz-2)/2)+bgp(*,*,(nz-2)/2+1))/2
;        2: bgp1(*,*,1) = (bgp(*,(ny-2)/2,*)+bgp(*,(ny-2)/2+1,*))/2
;        3: bgp1(*,*,2) = (bgp((nx-2)/2,*,*)+bgp((nz-2)/2+1,*,*))/2
;        4: for i = 0,nx-3 do bgp1(i,*,3) = bgp(i,i,*)
;        5: for i = 0,nx-3 do bgp1(i,*,4) = bgp(i,nx-3-i,*)
;      endcase
;      arr(j-1,0) = max(bgp1(*,*,j-1))
;      arr(j-1,1) = min(bgp1(*,*,j-1))
;      if keyword_set(mag) then bgp1=temporary(abs(bgp1))
;    endfor
