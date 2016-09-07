pro plotrecons, sf=sf, title=title

  ; Load energy file
  e = getenergy()
  ; Get reconnection section of energy file
  sz = n_elements(e.time)-1
  s1 = max(where(e.heating_ohmic eq 0))-1
  s2 = n_elements(e.time)-1
  ; Pick correct time section
  etime = e.time[s1:s2]-e.time[s1]
  vh = e.heating_visc
  oh = e.heating_ohmic
  vhr = ([e.heating_visc[0],(vh[0:sz-1]-vh[1:sz])/(e.time[0:sz-1]-e.time[1:sz])])[s1:s2]
  ohr = ([e.heating_ohmic[0],(oh[0:sz-1]-oh[1:sz])/(e.time[0:sz-1]-e.time[1:sz])])[s1:s2]
  
  ; Load reconnection data
  restore, 'pngs/intepar/inteparevo.sav'
  rtime = time
  int = abs(int)
  
  ; Calculate the cumulative reconnection rate
  cumrecon = [int[0]]
  for i = 1, n_elements(int)-1 do begin
    cumrecon = [cumrecon, cumrecon[-1] + int[i]*(time[i]-time[i-1])]
  endfor
  
  ; Divide by fasttime
  etime = etime/fasttime(0)
  rtime = (rtime-e.time[s1])/fasttime(0)
  print, e.time[s1]
  
  ; And plot
  if sf eq !null then sf = 1
  thick = 3
  p1 = plot(rtime, int, thick=thick, /xlog, xstyle=1, title=title+string(sf), name = 'Inst. Reconnection Rate')
  p2 = plot(rtime, cumrecon, 'b', thick=thick, name = 'Cumulative Reconnection Rate', /overplot)
  p3 = plot(etime, ohr*sf, col='purple', thick=thick, name = 'Inst. Ohmic Heating', /overplot)
  p4 = plot(etime, vhr*sf, col='orange', thick=thick, name = 'Inst. Viscous Heating', /overplot)
  
  leg = legend(target=[p1,p2,p3,p4])
  
  p1.save, 'pngs/intepar/reconen.png', width=1000
  ;p1.close

end
