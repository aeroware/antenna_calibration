      subroutine fill3d(z,izdim1,iz,kx,ky,camloc,xylim,
     $     xlab,ylab,zlab,csize,marplt,clevel,nlevel,icolrs,igrid)
      dimension z(izdim1,ky), camloc(*), xylim(2,6)
      dimension clevel(nlevel), icolrs(nlevel+1)
      integer*2 iz(kx,ky)
      character*1 xlab(2), ylab(2), zlab(2)
c     
c Purpose:
c     This subroutine will plot a function z=f(x,y) as a filled surface.
c     the function must be defined on a regular grid.  This routine uses
c     the "painter's algorithm" to remove hidden surfaces, i.e. it draws
c     from back to front and lets overwrite take care of the hidden surfaces.
c     
c Arguments:
c     
c   Input
c     
c     z		* type: real array.
c               * the function values: z(i,j)=f(xi,yj), where
c                  xi = xmin + (i-1)*(xmax-xmin)/(kx-1)
c                  yj = ymin + (j-1)*(ymax-ymin)/(ky-1)
c     
c     izdim1	* type: integer constant or variable.
c               * the first dimension of the z array - not
c                  necessarily the number of x values.
c     
c     iz	* type: integer*2 array.
c               * a working array dimensioned atleast kx*ky long.
c     
c     kx	* type: integer constant or variable.
c               * the number of x values in the z array.
c                  kx <= izdim1 ofcourse.
c     
c     ky	* type: integer constant or variable.
c               * the number of y values in the z array.
c     
c     camloc	* type: real array.
c               * the relative location of the viewer in space.
c                  the viewer always faces toward the center
c                  of the surface.	
c                  camloc(1) = distance from surface in units
c                               the same as those of z.
c                  camloc(2) = angle between the viewer and the
c                              x axis in degrees.   usually, multiples of
c                              30 or 45 degrees are best.
c                  camloc(3) = angle between the viewer and the
c                              xy plane located at z=(zmin+zmax)/2 in
c                              degrees.  Thus 90 degrees is directly above
c                              the surface - an unexciting picture!  Usually
c                              the angle is selected near 45 degrees.
c     
c     xylim	* type: real two dimensional array dimensioned (2,6).
c               * general parameters:
c                  xylim(1,1) = xmin ==> the minimum value of x.
c                  xylim(2,1) = xmax ==> the maximum value of x.
c                  xylim(1,2) = ymin ==> the minimum value of y.
c                  xylim(2,2) = ymax ==> the maximum value of y.
c                  note: z(i,j) = f(xi,yj) where:
c                            xi = xmin + (i-1)*(xmax-xmin)/(kx-1)
c                            yj = ymin + (j-1)*(ymax-ymin)/(ky-1)
c                  xylim(1,3) = zmin ==> the minimum value of z.
c                  xylim(2,3) = zmax ==> the maximum value of z.
c                               these z values define the range of z values
c                               to fit on the screen.  It is strongly
c                               advised that zmin and zmax bound z(i,j).
c                  xylim(1,4) = x/z axis length ratio.   if this
c                               parameter is 0, then x and z are assumed to
c                               have the same units, so their relative
c                               lengths will be in proportion to their
c                               ranges.  If this parameter is nonzero, then
c                               the x axis will be xylim(1,4) times as long
c                               as the z axis.
c                  xylim(2,4) = y/z axis length ratio.   same as
c                  xylim(1,4), but for y axis.
c                  xylim(1,5) = plot width in virtual coordinates
c                  xylim(2,5) = plot height in virtual coord.
c                  note: the plot is expanded/contracted until
c                        it all fits within the box defined by
c                  xylim(1,5) and xylim(2,5).
c                  xylim(1,6) = virtual x coord. of the lower
c                               left corner of the plot box.
c                  xylim(2,6) = virtual y coord. of the lower
c                               left corner of the box.
c     
c     xlab	* type: string constant or variable.
c               * the x axis lable.
c     
c     ylab	* type: string constant or variable.
c               * the y axis lable.
c     
c     zlab	* type: string constant or variable.
c               * the z axis lable.
c     
c     csize	* type: real constant or variable.
c               * the character size in virtual coord. for the tick
c                  mark lables and the axis lables.
c     
c     marplt	* type: integer constant or variable.
c               * suppress axes and labels flag:
c                  0 ==> draw axes
c                  4 ==> suppress axes; this is useful on small plots.
c     
c     collev	* type: real array.
c               * color level array containing nlevls real values
c                  that demark the boundaries of the color
c                  levels. all points with z values less than
c                  collev(1) are drawn in color icolrs(1).
c                  all points with z values between collev(1)
c                  and collev(2) are draw in color icolrs(2),
c                  etc.
c     
c     nlevls	* type: integer constant or variable.
c               * number of levels.
c     
c     icolrs	* type: integer array.
c               * colors array. see collev description.
c     
c     igrid	* type: integer constant or variable.
c               * the color in which the surface will be gridded.
c                  if this value is negative, no gridding
c                  will be done.
c     
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     
      include 'gcdchr.prm'
      include 'comdp.inc'
      include 'dbase.inc'
c     
      dimension xmina(2,6)
      dimension x(4), y(4), zp(4), levz(4)
      logical llable
      equivalence (xmin,xmina(1,1)) 
      external drwpl3
c     
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     
c     save xy limits, box sizes, etc. in our common block
c     
      do 9 j=1,6 
         xmina(1,j) = xylim(1,j) 
         xmina(2,j) = xylim(2,j) 
 9    continue
      mx=kx 
      fmx=float(kx) 
      ny=ky 
      fny=float(ny) 
c     
c     now set up limits if axis ratios are requested
c     
      if (axisr(1) .ne. 0.0) then
         xmina(1,1)=axisr(1)*zmin
         xmina(2,1)=axisr(1)*zmax
      endif
      if (axisr(2) .ne. 0.0) then
         xmina(1,2)=axisr(2)*zmin
         xmina(2,2)=axisr(2)*zmax
      endif
c     
c     set tolerance for visible tests = half plotter step size 
c     
      pqlmt = amin1(0.5/xres,0.5/yres)
c     
c     convert camera r, phi, theta displacement to dx, dy, dz
c     
      rad = 3.14159/180.0
      phi = camloc(2)*rad
      theta = camloc(3)*rad
      camwkg(1)=camloc(1)*cos(phi)*cos(theta)
      camwkg(2)=camloc(1)*sin(phi)*cos(theta)
      camwkg(3)=camloc(1)*sin(theta)
c     
c     point camera a center of "cube' and displace camera from center
c     
      do 3 j=1,3
         camwkg(j+3)=(xmina(1,j)+xmina(2,j))/2.0
         camwkg(j)=camwkg(j+3)+camwkg(j)
 3    continue
c     
c     compute rotation matrix from camera position and aim
c     
      call camrot
c     
c     compute scale factors to convert user coordinates to indices 
c     
      gx(1) = (xmax-xmin)/(fmx-1.0) 
      gx(2) = (ymax-ymin)/(fny-1.0) 
      gx(3)=1.0
      zorg=0.0
c     
c     find scale factors for plot 
c     
      llable = iand(marplt,4) .eq. 0
      call sclplt(z,izdim1,csize,llable,ierr)
      if (ierr .ne. 0) go to 50
c     
c     compute camera location expressed as xy indices 
c     
      u = 1.0+(fmx-1.0)*(camwkg(1)-xmin)/(xmax-xmin) 
      v = 1.0+(fny-1.0)*(camwkg(2)-ymin)/(ymax-ymin) 
c     
c     for visibility checking, scale camera z coordinate opposite to the
c     way z will be scaled for plotting - rather than scaling all the 
c     z-s on the surface when checking. 
c     
      w = (camwkg(3)-zorg)/gx(3) 
c     
c     calculate visibilities 
c     
      if (igrid .ge. 0) then
         lsolid = .false.
         do 112 k = 1,ny 
            eta = float(k) 
            do 111 j =1,mx 
               iz(j,k) = ivis(float(j),eta,z(j,k),
     $              z,izdim1) + 1 
 111        continue
 112     continue
      endif
c     
c*****************************************************************
c     
c     now plot from back to front
c     
      idx = sign(1.0,dx)
      idy = sign(1.0,dy)
      ipplcl = -1
c     
c     start from the back
c     
      ix = ib
      x(4) = ix
      x(3) = ix
      do 400 i = 1, mx-1
         x(1) = x(4)
         x(2) = x(3)
         ixpdx = ix + idx
         x(4) = ixpdx
         x(3) = ixpdx
         jy = jb
         y(2) = jy
         y(3) = y(2)
         zp(2) = z(ix,jy)
         levz(2) = levelc(zp(2),clevel,nlevel)
         zp(3) = z(ixpdx,jy)
         levz(3) = levelc(zp(3),clevel,nlevel)
         do 380 j=1,ny-1
            jy = jy + idy
            y(1) = y(2)
            y(2) = jy
            y(4) = y(3)
            y(3) = jy
            zp(1) = zp(2)
            levz(1) = levz(2)
            zp(4) = zp(3)
            levz(4) = levz(3)
            zp(2) = z(ix,jy)
            levz(2) = levelc(zp(2),clevel,nlevel)
            zp(3) = z(ixpdx,jy)
            levz(3) = levelc(zp(3),clevel,nlevel)
            call pickpl(x,y,zp,levz,4,clevel,nlevel,
     $           icolrs,drwpl3)
 380     continue
         ix = ixpdx
 400  continue
c     
c     add gridding if desired
c     
      if (igrid .ge. 0) then
         call gscolr(igrid,ierr)
         call draw3d(z,izdim1,iz,kx)
      endif
c     
c*********************************************************************
c     
c     
c     draw the base
c     
      call gscolr(1,ierr)
      call drawbs(z,izdim1,llable,xylim,xlab,ylab,zlab)
      return 
c     
c     point on the surface is behind the camera. quit. 
c     
 50   print 603 
 603  format('0part of surface is behind the camera, unable to plot.')
      return 
      end
      
      subroutine drwpl3(x,y,z,npts,icolor)
      dimension x(npts),y(npts),z(npts)
c     
      common /pickem/ ipplcl
c     
      dimension vx(8),vy(8),tx(8),ty(8)
c     
      if (icolor .ne. ipplcl) then
         ipplcl = icolor
         call gscolr(ipplcl,ierr)
      endif
      do 100 i=1,npts
         call scalit(x(i),y(i),z(i),vx(i),vy(i))
 100  continue
      call gsfill(vx,vy,npts,tx,ty)
      return
      end
      
      subroutine scalit(x,y,z,vx,vy)
      dimension xs(3), xc(3)
c     
      include 'comdp.inc'
c     
      xs(1) = xmin + (x-1.0)*gx(1)-camwkg(1)
      xs(2) = ymin + (y-1.0)*gx(2)-camwkg(2)
      xs(3) = zorg + z*gx(3)-camwkg(3)
      call rotate(xs,amtx,xc)
      vx=(xc(1)/xc(3)-xorg(1))*focall+pltorg(1)+center(1)
      vy=(xc(2)/xc(3)-xorg(2))*focall+pltorg(2)+center(2)
      return
      end
