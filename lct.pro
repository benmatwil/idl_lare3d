function lct, current=current, pressure=pressure, difference=difference, bgp=bgp, intepar=intepar, eparsep=eparsep, vperpsep=vperpsep, vortzsep=vortzsep, vzsep=vzsep, onesign=onesign, vorticity=vorticity, forces=forces

  if keyword_set(forces) then bgp=1

  if difference ne !null then begin
    if keyword_set(current) then begin
      s1 = 98
      sf1 = dindgen(s1)/(s1-1)
      s2 = 30
      sf2 = dindgen(s2)/(s2-1)

      ;Black to cyan
      r = dblarr(s1)  ;0 -> 0
      g = 255*sf1     ;0 -> 255
      b = 255*sf1     ;0 -> 255

      ;Cyan to white
      r = [r, 255*sf2]            ;0 -> 255
      g = [g, dblarr(s2) + 255]   ;255 -> 255
      b = [b, dblarr(s2) + 255]   ;255 -> 255

      ;White to pink
      r = [r, dblarr(s2) + 255]       ;255 -> 255
      g = [g, 255 + (20 - 255)*sf2]   ;255 -> 20
      b = [b, 255 + (147 - 255)*sf2]  ;255 -> 114

      ;Pink to red
      r = [r, dblarr(s1) + 255]     ;255 -> 255
      g = [g, 20 - 20*sf1]          ;20 -> 0
      b = [b, 147 - 147*sf1]        ;147 -> 0
    endif
    
    if keyword_set(pressure) then begin
      s1 = 98
      sf1 = dindgen(s1)/(s1-1)
      s2 = 30
      sf2 = dindgen(s2)/(s2-1)

      ;Dark blue to cyan
      r = dblarr(s1)        ;0 -> 0
      g = 255 * sf1         ;0 -> 255
      b = dblarr(s1) + 255  ;255 -> 255

      ;Cyan to green
      r = [r, dblarr(s2)]             ;0 -> 0
      g = [g, 255 + (100 - 255)*sf2]  ;255 -> 100
      b = [b, 255 - 255*sf2]          ;255 -> 0

      ;Green to yellow
      r = [r, 255*sf2]                ;0 -> 255
      g = [g, 100 + (255 - 100)*sf2]  ;100 -> 255
      b = [b, dblarr(s2)]             ;0 -> 0

      ;Yellow to red
      r = [r, dblarr(s1) + 255] ;255 -> 255
      g = [g, 255 - 255*sf1]    ;255 -> 0
      b = [b, dblarr(s1)]       ;0 -> 0
    endif
  endif else begin
    if keyword_set(current) then ct = colortable(53)
    if keyword_set(bgp) then ct = colortable(55)
    if keyword_set(pressure) then ct = colortable(62)
    if keyword_set(vorticity) then ct = colortable(73)
    if keyword_set(intepar) then ct = colortable(17, /reverse)
    if keyword_set(eparsep) then ct = colortable(20)
    if keyword_set(vzsep) then begin
      s1 = 128
      sf1 = dindgen(s1)/(s1-1)
      s2 = 64
      sf2 = dindgen(s2)/(s2-1)

      ;Dark purple to lilac
      r = 75 + (230 - 75)*sf1     ;75 -> 230
      g = 230*sf1                 ;0 -> 230
      b = 130 + (250 - 130)*sf1   ;130 -> 250

      ;light green to med green
      r = [r, 118 - 118*sf2]          ;118 -> 0
      g = [g, 238 + (250 - 238)*sf2]  ;238 -> 250
      b = [b, 198 + (154 - 198)*sf2]  ;198 -> 154

      ;med green to dark green
      r = [r, 46*sf2]                 ;0 -> 46
      g = [g, 250 + (139 - 250)*sf2]  ;250 -> 139
      b = [b, 154 + (87 - 154)*sf2]   ;154 -> 87
    endif
    if keyword_set(vortzsep) then begin
      s1 = 126
      sf1 = dindgen(s1)/(s1-1)
      s2 = 63
      sf2 = dindgen(s2)/(s2-1)
      s3 = 256 - s1 - 2*s2

      ;Dark blue to cyan
      r = dblarr(s1)        ;0 -> 0
      g = 255*sf1           ;0 -> 255
      b = dblarr(s1) + 255  ;255 -> 255
      
      r = [r, dblarr(s3)]
      g = [g, dblarr(s3) + 255]
      b = [b, dblarr(s3)]

      ;Yellow to orange
      r = [r, dblarr(s2) + 255]       ;255 -> 255
      g = [g, 255 + (165 - 255)*sf2]  ;255 -> 165
      b = [b, dblarr(s2)]             ;0 -> 0

      ;Orange to red
      r = [r, dblarr(s2) + 255]   ;255 -> 255
      g = [g, 165 - 165*sf2]      ;165 -> 0
      b = [b, dblarr(s2)]         ;0 -> 0
    endif
    if keyword_set(vperpsep) then begin
      if keyword_set(onesign) then step = 128 else step = 64
      sf = dindgen(step)/(step-1)
      
      r = 255*sf               ;0 -> 255
      g = 50 + (62 - 50)*sf    ;50 -> 62
      b = 72 + (150 - 72)*sf   ;72 -> 150
      
      r = [r, 255 + dblarr(step)]     ;255 -> 255
      g = [g, 62 + (225 - 62)*sf]     ;62 -> 225
      b = [b, 150 + (255 - 150)*sf]   ;150 -> 255
      
      if not keyword_set(onesign) then begin
        ct = colortable(18)
        ct = [[[r],[g],[b]],ct[130:150,*],ct[150,*],ct[151:200,*],ct[200,*],ct[201:*,*]]
      endif
    endif
  endelse
  
  if r ne !null and g ne !null and b ne !null and ct eq !null then ct = [[r],[g],[b]]

  return, ct

end
