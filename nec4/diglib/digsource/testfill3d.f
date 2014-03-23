      program testfill3d
c     
      include 'gcdchr.prm'
c     
      parameter (nx = 31, ny = 31)
      parameter (nlevel = 10, ncolors = 6, ifcolor = 2)
c     
      dimension z(nx,ny),xylim(2,6),camloc(3)
      dimension clevel(nlevel), icolrs(nlevel+1)
      integer*2 iz(nx,ny)
      equivalence (xylim(1,1),xmin),(xylim(2,1),xmax),
     $     (xylim(1,2),ymin),(xylim(2,2),ymax),
     $     (xylim(1,3),zmin),(xylim(2,3),zmax),
     $     (xylim(1,5),width),(xylim(2,5),height),
     $     (xylim(1,6),xoff),(xylim(2,6),yoff)
      data xmin,xmax,ymin,ymax /-10.0,10.0,-10.0,10.0/
c     
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     
      call seldev(4,ierr)
c     
c     fake some data and find the z min and max while doing so
c     
      dx = (xmax-xmin)/(nx-1)
      dy = (ymax-ymin)/(ny-1)
      zmin=1e30
      zmax=-1e30
      do 65 i=1,nx
         x = xmin + (i-1)*dx
         do 60 j=1,ny
            y = ymin + (j-1)*dy
            z(i,j) = fxy(x,y,0.0,0.0,15.0,10.0) +
     $           0.9*fxy(x,y,-5.0,-2.5,10.0,20.0) +
     $           0.75*fxy(x,y,7.0,3.0,20.0,20.0) +
     $           0.85*fxy(x,y,2.0,-4.0,15.0,15.0) +
     $           0.85*fxy(x,y,-2.5,6.5,25.0,35.0)
            zmin=amin1(zmin,z(i,j))
            zmax=amax1(zmax,z(i,j))
 60      continue
 65   continue
c     
c     figure levels for colors
c     
      dz = (zmax-zmin)/(nlevel+1)
      do 80 i=1,nlevel
         clevel(i) = zmin + i*dz
 80   continue
      j = ifcolor
      do 90 i=1,nlevel+1
         icolrs(i) = j
         j = j + 1
         if (j .ge. ncolors+ifcolor) j = ifcolor
 90   continue
c     
c     plot as a cube
c     
      xylim(1,4)=1.0
      xylim(2,4)=1.0
c     
c     allow a little room around the edges
c     
      xoff = 0.5
      yoff = 0.5
      width = xlencm-2.0*xoff
      height = ylencm-2.0*yoff
c     
c     get location of viewer/camera
c     
      print 120
 120  format('Relative camera position - r,phi,theta:')
      read (5,150) camloc(1),camloc(2),camloc(3)
 150  format(3f14.0)
      print 161
 161  format('Color of gridding?')
      read (5,162) igrid
 162  format(i5)
c     
c     plot that sucker in glorious living color
c     
      call bgnplt
      csize = goodcs(0.3)
      call fill3d(z,nx,iz,nx,ny,camloc,xylim,'x axis'//char(0),
     $     'y axis'//char(0),'z axis'//char(0),csize,marplt,clevel,
     &nlevel,icolrs,igrid)
      call endplt
      print 801
 801  format('Hit return to exit')
      read (5,802) idummy
 802  format(a1)
      call rlsdev
      stop
      end

      function fxy(x,y,xc,yc,xs,ys)
      r = (x-xc)**2/xs + (y-yc)**2/ys
      fxy = cos(r)*exp(-r)
      return
      end
