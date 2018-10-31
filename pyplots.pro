@lare

plt = Python.Import('matplotlib.pyplot')
mpl = python.import('matplotlib')
!null = Python.run('import matplotlib.pyplot as plt')
!null = Python.run("plt.rc('text', usetex=True)")
!null = Python.run("plt.rc('font', **{'size':8})")
!null = Python.run("plt.rc('font', **{'family':'serif', 'serif':['Computer Modern Roman']})")
np = Python.Import('numpy')
idl2mpl = Python.Import('idl2matplotlibct')

False = 0
yticks = np.linspace(-1, 1, 5)

fig = plt.figure(figsize=[15/2.55, 15/2.55])

pressure = 1
current = 0
x = -0.85
y = 0.75
ax13 = fig.add_subplot(337)
cplot, fr=25, xz=0, pressure=pressure, current=current, matplotlib=[fig, ax13], mmlev=[0.95, 1.07]
!null = ax13.set_yticks(yticks)
ax13.text(x, y, '(g)', color='w')

ax23 = fig.add_subplot(338, sharey=ax13)
cplot, fr=35, xz=0, pressure=pressure, current=current, diff=25, matplotlib=[fig, ax23], smlev=0.002
!null = plt.setp(ax23.get_yticklabels(), visible=False)
!null = plt.ylabel('')
ax23.text(x, y, '(h)', color='w')

ax33 = fig.add_subplot(339, sharey=ax13)
cplot, fr=65, xz=0, pressure=pressure, current=current, diff=25, matplotlib=[fig, ax33], smlev=0.002
!null = plt.setp(ax33.get_yticklabels(), visible=False)
!null = plt.ylabel('')
ax33.text(x, y, '(i)', color='w')

ax11 = fig.add_subplot(331, sharex=ax13)
cplot, fr=25, xy=0, pressure=pressure, current=current, matplotlib=[fig, ax11], mmlev=[1.06, 1.07]
!null = ax11.set_yticks(yticks)
!null = plt.setp(ax11.get_xticklabels(), visible=False)
!null = plt.xlabel('')
ax11.text(x, y, '(a)', color='w')

ax21 = fig.add_subplot(332, sharex=ax23, sharey=ax11)
cplot, fr=35, xy=0, pressure=pressure, current=current, matplotlib=[fig, ax21], smlev=0.002, diff=25
!null = plt.setp(ax21.get_xticklabels(), visible=False)
!null = plt.setp(ax21.get_yticklabels(), visible=False)
!null = plt.xlabel('')
!null = plt.ylabel('')
ax21.text(x, y, '(b)', color='w')

ax31 = fig.add_subplot(333, sharex=ax33, sharey=ax11)
cplot, fr=65, xy=0, pressure=pressure, current=current, matplotlib=[fig, ax31], smlev=0.002, diff=25
!null = plt.setp(ax31.get_xticklabels(), visible=False)
!null = plt.setp(ax31.get_yticklabels(), visible=False)
!null = plt.xlabel('')
!null = plt.ylabel('')
ax31.text(x, y, '(c)', color='w')

ax12 = fig.add_subplot(334, sharex=ax13)
!null = ax12.set_yticks(yticks)
cplot, fr=25, xy=0.8, pressure=pressure, current=current, matplotlib=[fig, ax12], mmlev=[0.95, 1.07]
!null = plt.setp(ax12.get_xticklabels(), visible=False)
!null = plt.xlabel('')
ax12.text(x, y, '(d)', color='w')

ax22 = fig.add_subplot(335, sharex=ax23, sharey=ax21)
cplot, fr=35, xy=0.8, pressure=pressure, current=current, matplotlib=[fig, ax22], smlev=0.002, diff=25
!null = plt.setp(ax22.get_xticklabels(), visible=False)
!null = plt.setp(ax22.get_yticklabels(), visible=False)
!null = plt.xlabel('')
!null = plt.ylabel('')
ax22.text(x, y, '(e)', color='w')

ax32 = fig.add_subplot(336, sharex=ax33, sharey=ax21)
cplot, fr=65, xy=0.8, pressure=pressure, current=current, matplotlib=[fig, ax32], smlev=0.002, diff=25
!null = plt.setp(ax32.get_xticklabels(), visible=False)
!null = plt.setp(ax32.get_yticklabels(), visible=False)
!null = plt.xlabel('')
!null = plt.ylabel('')
ax32.text(x, y, '(f)', color='w')

!null = plt.tight_layout()

if pressure eq 1 then savstr = 'pressure'
if current eq 1 then savstr = 'current'

!null = plt.savefig('lare-'+savstr+'-grid.pgf', dpi=600)
void = plt.show()






fig = plt.figure(figsize=[15/2.55, 15/2.55])

pressure = 0
current = 1

; x = -0.75
; y = 0.5
yticks = np.linspace(-1,1,5)
ax13 = fig.add_subplot(337)
cplot, fr=25, xz=0, pressure=pressure, current=current, matplotlib=[fig, ax13], mmlev=[0,10]
!null = ax13.set_yticks(yticks)
ax13.text(x, y, '(g)')

ax23 = fig.add_subplot(338, sharey=ax13)
cplot, fr=35, xz=0, pressure=pressure, current=current, diff=25, matplotlib=[fig, ax23], smlev=0.02
!null = plt.setp(ax23.get_yticklabels(), visible=False)
!null = plt.ylabel('')
ax23.text(x, y, '(h)')

ax33 = fig.add_subplot(339, sharey=ax13)
cplot, fr=65, xz=0, pressure=pressure, current=current, diff=25, matplotlib=[fig, ax33], smlev=0.02
!null = plt.setp(ax33.get_yticklabels(), visible=False)
!null = plt.ylabel('')
ax33.text(x, y, '(i)')

ax11 = fig.add_subplot(331, sharex=ax13)
cplot, fr=25, xy=0, pressure=pressure, current=current, matplotlib=[fig, ax11], mmlev=[0,1]
!null = ax11.set_yticks(yticks)
!null = plt.setp(ax11.get_xticklabels(), visible=False)
!null = plt.xlabel('')
ax11.text(x, y, '(a)*')

ax21 = fig.add_subplot(332, sharex=ax23, sharey=ax11)
cplot, fr=35, xy=0, pressure=pressure, current=current, matplotlib=[fig, ax21], smlev=0.02, diff=25
!null = plt.setp(ax21.get_xticklabels(), visible=False)
!null = plt.setp(ax21.get_yticklabels(), visible=False)
!null = plt.xlabel('')
!null = plt.ylabel('')
ax21.text(x, y, '(b)')

ax31 = fig.add_subplot(333, sharex=ax33, sharey=ax11)
cplot, fr=65, xy=0, pressure=pressure, current=current, matplotlib=[fig, ax31], smlev=0.02, diff=25
!null = plt.setp(ax31.get_xticklabels(), visible=False)
!null = plt.setp(ax31.get_yticklabels(), visible=False)
!null = plt.xlabel('')
!null = plt.ylabel('')
ax31.text(x, y, '(c)')

ax12 = fig.add_subplot(334, sharex=ax13)
!null = ax12.set_yticks(yticks)
cplot, fr=25, xy=0.8, pressure=pressure, current=current, matplotlib=[fig, ax12], mmlev=[0,10]
!null = plt.setp(ax12.get_xticklabels(), visible=False)
!null = plt.xlabel('')
ax12.text(x, y, '(d)')

ax22 = fig.add_subplot(335, sharex=ax23, sharey=ax21)
cplot, fr=35, xy=0.8, pressure=pressure, current=current, matplotlib=[fig, ax22], smlev=0.02, diff=25
!null = plt.setp(ax22.get_xticklabels(), visible=False)
!null = plt.setp(ax22.get_yticklabels(), visible=False)
!null = plt.xlabel('')
!null = plt.ylabel('')
ax22.text(x, y, '(e)')

ax32 = fig.add_subplot(336, sharex=ax33, sharey=ax21)
cplot, fr=65, xy=0.8, pressure=pressure, current=current, matplotlib=[fig, ax32], smlev=0.02, diff=25
!null = plt.setp(ax32.get_xticklabels(), visible=False)
!null = plt.setp(ax32.get_yticklabels(), visible=False)
!null = plt.xlabel('')
!null = plt.ylabel('')
ax32.text(x, y, '(f)')

!null = plt.tight_layout()

if pressure eq 1 then savstr = 'pressure'
if current eq 1 then savstr = 'current'

!null = plt.savefig('lare-'+savstr+'-grid.pgf', dpi=600)
void = plt.show()






fig = plt.figure(figsize=[5/2.55, 1.65/2.55])
idl2mpl = Python.Import('idl2matplotlibct')
ct = lct(pressure=1)
cmap = idl2mpl.make_colourmap(dindgen(256), ct[*, 0], ct[*, 1], ct[*, 2], 'map')
bound = [0.95, 1.07]
norm = mpl.colors.Normalize(vmin=bound[0], vmax=bound[1])
ax1 = fig.add_axes([0.05, 0.7, 0.9, 0.25])
cb1 = mpl.colorbar.ColorbarBase(ax1, cmap=cmap, norm=norm, orientation='horizontal', extend='both', ticks=np.linspace(bound[0], bound[1], 5))
!null = Python.run("plt.rc('font', **{'size':8})")
cb1.set_label('\( p (\mathbf{r}, 0) \)')
plt.savefig('press-cb1.pgf')
void = plt.show()

fig = plt.figure(figsize=[5/2.55, 1.65/2.55])
idl2mpl = Python.Import('idl2matplotlibct')
ct = lct(current=1)
cmap = idl2mpl.make_colourmap(dindgen(256), ct[*, 0], ct[*, 1], ct[*, 2], 'map')
bound = [0, 10]
norm = mpl.colors.Normalize(vmin=bound[0], vmax=bound[1])
ax1 = fig.add_axes([0.05, 0.7, 0.9, 0.25])
cb1 = mpl.colorbar.ColorbarBase(ax1, cmap=cmap, norm=norm, orientation='horizontal', extend='max', ticks=np.linspace(bound[0], bound[1], 5))
!null = Python.run("plt.rc('font', **{'size':8})")
cb1.set_label('\( | \mathbf{J} (\mathbf{r}, 0) | \)')
plt.savefig('current-cb1.pgf')
void = plt.show()




fig = plt.figure(figsize=[5/2.55, 1.65/2.55])
idl2mpl = Python.Import('idl2matplotlibct')
ct = lct(pressure=1, diff=1)
cmap = idl2mpl.make_colourmap(dindgen(256), ct[*, 0], ct[*, 1], ct[*, 2], 'map')
bound = [-0.002, 0.002]
norm = mpl.colors.Normalize(vmin=bound[0], vmax=bound[1])
ax1 = fig.add_axes([0.05, 0.7, 0.9, 0.25])
cb1 = mpl.colorbar.ColorbarBase(ax1, cmap=cmap, norm=norm, orientation='horizontal', extend='both', ticks=np.linspace(bound[0], bound[1], 5))
!null = Python.run("plt.rc('font', **{'size':8})")
cb1.set_label('\( p (\mathbf{r}, t) - p (\mathbf{r}, 0) \)')
plt.savefig('press-cb2.pgf')
void = plt.show()

fig = plt.figure(figsize=[5/2.55, 1.65/2.55])
idl2mpl = Python.Import('idl2matplotlibct')
ct = lct(current=1, diff=1)
cmap = idl2mpl.make_colourmap(dindgen(256), ct[*, 0], ct[*, 1], ct[*, 2], 'map')
bound = [-0.02, 0.02]
norm = mpl.colors.Normalize(vmin=bound[0], vmax=bound[1])
ax1 = fig.add_axes([0.05, 0.7, 0.9, 0.25])
cb1 = mpl.colorbar.ColorbarBase(ax1, cmap=cmap, norm=norm, orientation='horizontal', extend='both', ticks=np.linspace(bound[0], bound[1], 5))
!null = Python.run("plt.rc('font', **{'size':8})")
cb1.set_label('\(| \mathbf{J} (\mathbf{r}, t) | - | \mathbf{J} (\mathbf{r}, 0) | \)')
plt.savefig('current-cb2.pgf')
void = plt.show()















restore, 'pngs/intepar/intepar026z0.95.sav'
x = stpt[0,*]
y = stpt[1,*]
x = reform(x, 1000, 1000)
y = reform(y, 1000, 1000)
int = reform(int, 1000, 1000)
fig = plt.figure(figsize=[7.5/2.55, 7/2.55])
ax = fig.add_subplot(111)
ax.set_aspect('equal')
ct = colortable(17, /reverse)
cmap = idl2mpl.make_colourmap(dindgen(256), ct[*, 0], ct[*, 1], ct[*, 2], 'map')
ax.contourf(x, y, int, np.linspace(-0.004, 0, 256), extend='both', cmap=cmap, zorder=-5)
!null = ax.set_rasterization_zorder(-1)
ax.set_xlabel('$x$')
ax.set_ylabel('$y$')
ticks = np.linspace(-0.5, 0.5, 5)
ax.set_xticks(ticks)
ax.set_yticks(ticks)
plt.tight_layout()
plt.savefig('intepar-26.pgf', dpi=600)
plt.show()

restore, 'pngs/intepar/intepar030z0.95.sav'
x = stpt[0,*]
y = stpt[1,*]
x = reform(x, 1000, 1000)
y = reform(y, 1000, 1000)
int = reform(int, 1000, 1000)
fig = plt.figure(figsize=[7.5/2.55, 7/2.55])
ax = fig.add_subplot(111)
ax.set_aspect('equal')
ct = colortable(17, /reverse)
cmap = idl2mpl.make_colourmap(dindgen(256), ct[*, 0], ct[*, 1], ct[*, 2], 'map')
ax.contourf(x, y, int, np.linspace(-0.004, 0, 256), extend='both', cmap=cmap, zorder=-5)
!null = ax.set_rasterization_zorder(-1)
ax.set_xlabel('$x$')
ax.set_ylabel('$y$')
ticks = np.linspace(-0.5, 0.5, 5)
ax.set_xticks(ticks)
ax.set_yticks(ticks)
plt.tight_layout()
plt.savefig('intepar-30.pgf', dpi=600)
plt.show()

fig = plt.figure(figsize=[7.5/2.55, 1.65/2.55])
idl2mpl = Python.Import('idl2matplotlibct')
ct = colortable(17, /reverse)
cmap = idl2mpl.make_colourmap(dindgen(256), ct[*, 0], ct[*, 1], ct[*, 2], 'map')
bound = [-0.004, 0]
norm = mpl.colors.Normalize(vmin=bound[0], vmax=bound[1])
ax1 = fig.add_axes([0.05, 0.7, 0.9, 0.25])
cb1 = mpl.colorbar.ColorbarBase(ax1, cmap=cmap, norm=norm, orientation='horizontal', extend='min', ticks=np.linspace(bound[0], bound[1], 5))
!null = Python.run("plt.rc('font', **{'size':8})")
cb1.set_label('\( R \)')
plt.savefig('intepar-cb.pgf')
void = plt.show()




restore, 'pngs/spinetimeevo/discrb.sav'
d = getdata(35, /grid)
y = d.grid.z[2:-3]
tf = 0.3679
fig = plt.figure(figsize=[15/2.55, 6/2.55])
ax = fig.add_subplot(111)
ct = lct(/eparsep)
time = time-50
cmap = idl2mpl.make_colourmap(dindgen(256), ct[*, 0], ct[*, 1], ct[*, 2], 'map')
c2 = ax.contourf(time/tf, y, transpose(epar), np.linspace(-0.008, 0.008, 256), extend='both', cmap=cmap, zorder=-5)
levs = np.linspace(-60., 0., 7)
c1 = ax.contour(time/tf, y, transpose(disb), levs, colors='black', extend='both', zorder=-5, linewidths=0.5, linestyles='solid')
plt.clabel(c1, fmt='%3d', colors='k', fontsize=6)
ax.set_xscale('log')
!null = ax.set_rasterization_zorder(-1)
ax.set_xlabel('$t/t_f$')
ax.set_ylabel('Distance along spine ($z$-axis)')
ticks = np.linspace(-1, 1, 5)
ax.set_yticks(ticks)
cb = plt.colorbar(c2)
cb.set_ticks(np.linspace(-0.008, 0.008, 5))
plt.tight_layout()
plt.savefig('discrb.pgf', dpi=600)
plt.show()









restore, 'pngs/spinetimeevo/disvperp.sav'
d = getdata(35, /grid)
y = d.grid.z[2:-3]
tf = 0.3679
fig = plt.figure(figsize=[15/2.55, 6/2.55])
ax = fig.add_subplot(111)
ct = lct(/vperpsep, /onesign)
time = time-50
cmap = idl2mpl.make_colourmap(dindgen(256), ct[*, 0], ct[*, 1], ct[*, 2], 'map')
levs = np.linspace(-0.15, 0, 256)
c2 = ax.contourf(time/tf, y, transpose(disv), levs, extend='both', cmap=cmap, zorder=-5)
cb = plt.colorbar(c2)
cb.set_ticks(np.linspace(-0.15, 0, 5))
levs = [-0.008, -0.006, -0.004, -0.002, 0.002, 0.004, 0.006, 0.008]
c1 = ax.contour(time/tf, y, transpose(epar), levs, colors='black', extend='both', zorder=-5, linewidths=0.5, linestyles='solid')
plt.clabel(c1, fmt='%3.3f', colors='k', fontsize=6)
ax.set_xscale('log')
!null = ax.set_rasterization_zorder(-1)
ax.set_xlabel('$t/t_f$')
ax.set_ylabel('Distance along spine ($z$-axis)')
ticks = np.linspace(-1, 1, 5)
ax.set_yticks(ticks)

plt.tight_layout()
plt.savefig('disvperp.pgf', dpi=600)
plt.show()







restore, 'pngs/spinetimeevo/vortz.sav'
d = getdata(35, /grid)
y = d.grid.z[2:-3]
y1 = d.grid.z[1:-2]
tf = 0.3679
fig = plt.figure(figsize=[15/2.55, 6/2.55])
ax = fig.add_subplot(111)
ct = lct(/vortzsep)
time = time-50
cmap = idl2mpl.make_colourmap(dindgen(256), ct[*, 0], ct[*, 1], ct[*, 2], 'map')
levs = np.linspace(-0.3, 0.3, 256)
c2 = ax.contourf(time/tf, y1, transpose(vortz), levs, extend='both', cmap=cmap, zorder=-5)
cb = plt.colorbar(c2)
cb.set_ticks(np.linspace(-0.3, 0.3, 5))
levs = [-0.15, -0.1, -0.05, -0.02, -0.01, 0]
c1 = ax.contour(time/tf, y, transpose(disv), levs, colors='black', extend='both', zorder=-5, linewidths=0.5, linestyles='solid')
plt.clabel(c1, fmt='%3.3f', colors='k', fontsize=6)
ax.set_xscale('log')
!null = ax.set_rasterization_zorder(-1)
ax.set_xlabel('$t/t_f$')
ax.set_ylabel('Distance along spine ($z$-axis)')
ticks = np.linspace(-1, 1, 5)
ax.set_yticks(ticks)

plt.tight_layout()
plt.savefig('vortz.pgf', dpi=600)
plt.show()


plt = Python.Import('matplotlib.pyplot')
mpl = python.import('matplotlib')
!null = Python.run('import matplotlib.pyplot as plt')
!null = Python.run("plt.rc('text', usetex=True)")
!null = Python.run("plt.rc('font', **{'size':8})")
!null = Python.run("plt.rc('font', **{'family':'serif', 'serif':['Computer Modern Roman']})")
np = Python.Import('numpy')
idl2mpl = Python.Import('idl2matplotlibct')

fig = plt.figure(figsize=[7.5/2.55, 7/2.55])
ax = fig.add_subplot(111)
cplot, fr=0, /forces, xy=0, matplotlib=[fig,ax], mmlev=[0,1.2]
d = getdata(0, /magnetic_field, /grid)
bgrid = mkbg(d)
nflines = 32
spt = dblarr(3, nflines)
r = 0.9d0
for i = 0, nflines-1 do spt[*, i] = [r*cos(!dpi*i*2/nflines), r*sin(!dpi*i*2/nflines), 0]
l = list()
for i = 0, nflines-1 do l.add, fieldline3d(spt[*, i], bgrid, d.x, d.y, d.z, 1d-3, 1d-4, 1d-2, 1d-6, mxline=1000)
foreach line, l do !null = ax.plot(line[0, *], line[1, *], 'k-', lw=0.5)
ax.set_xlim(-1,1)
ax.set_ylim(-1,1)
ax.set_xlabel('$x$')
ax.set_ylabel('$y$')
ticks = np.linspace(-1, 1, 5)
ax.set_yticks(ticks)
fig.tight_layout()
plt.savefig('forces-init-z0.pgf', dpi=600)
; plt.show()




fig = plt.figure(figsize=[7.5/2.55, 7/2.55])
ax = fig.add_subplot(111)
cplot, fr=25, /forces, xy=0, matplotlib=[fig,ax], mmlev=[0,0.1]
d = getdata(25, /magnetic_field, /grid)
bgrid = mkbg(d)
nflines = 32
spt = dblarr(3, nflines)
r = 0.9d0
for i = 0, nflines-1 do spt[*, i] = [r*cos(!dpi*i*2/nflines), r*sin(!dpi*i*2/nflines), 0]
l = list()
for i = 0, nflines-1 do l.add, fieldline3d(spt[*, i], bgrid, d.x, d.y, d.z, 1d-3, 1d-4, 1d-2, 1d-6, mxline=1000)
foreach line, l do !null = ax.plot(line[0, *], line[1, *], 'k-', lw=0.5)
ax.set_xlim(-1,1)
ax.set_ylim(-1,1)
ax.set_xlabel('$x$')
ax.set_ylabel('$y$')
ticks = np.linspace(-1, 1, 5)
ax.set_yticks(ticks)
fig.tight_layout()
plt.savefig('forces-equil-z0.pgf', dpi=600)
plt.show()




fig = plt.figure(figsize=[7.5/2.55, 7/2.55])
ax = fig.add_subplot(111)
cplot, fr=25, /forces, xz=0, matplotlib=[fig,ax], mmlev=[0,0.1]
d = getdata(25, /magnetic_field, /grid)
bgrid = mkbg(d)
nflines = 32
zval=0.01
startpt1 = dblarr(3,16)
r = 0.9d;0.01d
for i = 0,15 do startpt1[*,i] = [r*cos(i*!dpi/8.),r*sin(i*!dpi/8.),0]
l = list()
for i = 0, 15 do l.add, fieldline3d(startpt1[*, i], bgrid, d.x, d.y, d.z, 1d-3, 1d-4, 1d-2, 1d-6, mxline=1000)
lcol1 = [0,255,43,255.]/255
l2 = list()
foreach line, l do l2.add, line[*, where(abs(line[2, *]) lt 0.01)]
foreach line, l2 do !null = ax.plot(line[0, *], line[2, *], '-', c=lcol1, lw=0.5)

startpt2 = dblarr(3,2)
for i = 0,1 do startpt2[*,i] = [0,0,-0.005+i*0.01]
l = list()
for i = 0, 1 do l.add, fieldline3d(startpt2[*, i], bgrid, d.x, d.y, d.z, 1d-3, 1d-4, 1d-2, 1d-6, mxline=1000)
lcol2 = [0,245,255,255.]/255
foreach line, l do !null = ax.plot(line[0, *], line[2, *], '-', c=lcol2, lw=0.5)

startpt3 = dblarr(3,16)
r = 0.9d
for i = 0,15 do startpt3[*,i] = [r*cos(i*!dpi/8.),r*sin(i*!dpi/8.),zval]
l = list()
for i = 0, 15 do l.add, fieldline3d(startpt3[*, i], bgrid, d.x, d.y, d.z, 1d-3, 1d-4, 1d-2, 1d-6, mxline=1000)
lcol3 = [255,180,60,255.]/255
foreach line, l do !null = ax.plot(line[0, *], line[2, *], '-', c=lcol3, lw=0.5)

startpt4 = dblarr(3,16)
r = 0.9d
for i = 0,15 do startpt4[*,i] = [r*cos(i*!dpi/8.),r*sin(i*!dpi/8.),-zval]
l = list()
for i = 0, 15 do l.add, fieldline3d(startpt4[*, i], bgrid, d.x, d.y, d.z, 1d-3, 1d-4, 1d-2, 1d-6, mxline=1000)
lcol4 = [170,0,220,255.]/255
foreach line, l do !null = ax.plot(line[0, *], line[2, *], '-', c=lcol4, lw=0.5)
ax.set_xlim(-1,1)
ax.set_ylim(-1,1)
ax.set_xlabel('$x$')
ax.set_ylabel('$z$')
ticks = np.linspace(-1, 1, 5)
ax.set_yticks(ticks)
fig.tight_layout()
plt.savefig('forces-equil-y0.pgf', dpi=600)
plt.show()


fig = plt.figure(figsize=[7.5/2.55, 7/2.55])
ax = fig.add_subplot(111)
cplot, fr=0, /forces, xz=0, matplotlib=[fig,ax], mmlev=[0,1.2]
d = getdata(0, /magnetic_field, /grid)
bgrid = mkbg(d)
nflines = 32
zval=0.01
startpt1 = dblarr(3,16)
r = 0.9d;0.01d
for i = 0,15 do startpt1[*,i] = [r*cos(i*!dpi/8.),r*sin(i*!dpi/8.),0]
l = list()
for i = 0, 15 do l.add, fieldline3d(startpt1[*, i], bgrid, d.x, d.y, d.z, 1d-3, 1d-4, 1d-2, 1d-6, mxline=1000)
lcol1 = [0,255,43,255.]/255
l2 = list()
foreach line, l do l2.add, line[*, where(abs(line[2, *]) lt 0.01)]
foreach line, l2 do !null = ax.plot(line[0, *], line[2, *], '-', c=lcol1, lw=0.5)

startpt2 = dblarr(3,2)
for i = 0,1 do startpt2[*,i] = [0,0,-0.005+i*0.01]
l = list()
for i = 0, 1 do l.add, fieldline3d(startpt2[*, i], bgrid, d.x, d.y, d.z, 1d-3, 1d-4, 1d-2, 1d-6, mxline=1000)
lcol2 = [0,245,255,255.]/255
foreach line, l do !null = ax.plot(line[0, *], line[2, *], '-', c=lcol2, lw=0.5)

startpt3 = dblarr(3,16)
r = 0.9d
for i = 0,15 do startpt3[*,i] = [r*cos(i*!dpi/8.),r*sin(i*!dpi/8.),zval]
l = list()
for i = 0, 15 do l.add, fieldline3d(startpt3[*, i], bgrid, d.x, d.y, d.z, 1d-3, 1d-4, 1d-2, 1d-6, mxline=1000)
lcol3 = [255,180,60,255.]/255
foreach line, l do !null = ax.plot(line[0, *], line[2, *], '-', c=lcol3, lw=0.5)

startpt4 = dblarr(3,16)
r = 0.9d
for i = 0,15 do startpt4[*,i] = [r*cos(i*!dpi/8.),r*sin(i*!dpi/8.),-zval]
l = list()
for i = 0, 15 do l.add, fieldline3d(startpt4[*, i], bgrid, d.x, d.y, d.z, 1d-3, 1d-4, 1d-2, 1d-6, mxline=1000)
lcol4 = [170,0,220,255.]/255
foreach line, l do !null = ax.plot(line[0, *], line[2, *], '-', c=lcol4, lw=0.5)
ax.set_xlim(-1,1)
ax.set_ylim(-1,1)
ax.set_xlabel('$x$')
ax.set_ylabel('$z$')
ticks = np.linspace(-1, 1, 5)
ax.set_yticks(ticks)
fig.tight_layout()
plt.savefig('forces-init-y0.pgf', dpi=600)
plt.show()











fig = plt.figure(figsize=[7.5/2.55, 1.65/2.55])
idl2mpl = Python.Import('idl2matplotlibct')
ct = colortable(55)
cmap = idl2mpl.make_colourmap(dindgen(256), ct[*, 0], ct[*, 1], ct[*, 2], 'map')
bound = [0, 1.2]
norm = mpl.colors.Normalize(vmin=bound[0], vmax=bound[1])
ax1 = fig.add_axes([0.05, 0.7, 0.9, 0.25])
cb1 = mpl.colorbar.ColorbarBase(ax1, cmap=cmap, norm=norm, orientation='horizontal', extend='max', ticks=np.linspace(bound[0], bound[1], 5))
!null = Python.run("plt.rc('font', **{'size':8})")
cb1.set_label('\( |\mathbf{J} \times \mathbf{B} - {\nabla} p | \)')
plt.savefig('forces-cb1.pgf')
void = plt.show()


fig = plt.figure(figsize=[7.5/2.55, 1.65/2.55])
idl2mpl = Python.Import('idl2matplotlibct')
ct = colortable(55)
cmap = idl2mpl.make_colourmap(dindgen(256), ct[*, 0], ct[*, 1], ct[*, 2], 'map')
bound = [0, 0.1]
norm = mpl.colors.Normalize(vmin=bound[0], vmax=bound[1])
ax1 = fig.add_axes([0.05, 0.7, 0.9, 0.25])
cb1 = mpl.colorbar.ColorbarBase(ax1, cmap=cmap, norm=norm, orientation='horizontal', extend='max', ticks=np.linspace(bound[0], bound[1], 5))
!null = Python.run("plt.rc('font', **{'size':8})")
cb1.set_label('\( |\mathbf{J} \times \mathbf{B} - {\nabla} p | \)')
plt.savefig('forces-cb2.pgf')
void = plt.show()