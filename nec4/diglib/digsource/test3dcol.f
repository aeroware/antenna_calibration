      program test3dcol
      parameter (nx=31, ny=31, nlevls = 10, ncolors = 6, ifcolor = 2)
      include 'gcdchr.prm'
      dimension z(nx,ny),xylim(2,6),camloc(3)
      dimension collev(nlevls), icolrs(nlevls+1)
      integer*2 iz(nx,ny)
c     
      equivalence (xylim(1,1),xmin),(xylim(2,1),xmax),
     $     (xylim(1,2),ymin),(xylim(2,2),ymax),
     $     (xylim(1,3),zmin),(xylim(2,3),zmax),
     $     (xylim(1,5),width),(xylim(2,5),height),
     $     (xylim(1,6),xoff),(xylim(2,6),yoff)
c     
      data xmin,xmax,ymin,ymax /-10.0,10.0,-10.0,10.0/
c     
c     
c     
      call seldev(4)
      zmx = 1.0
      zmn = 0.0
      dx = (xmax-xmin)/(nx-1)
      dy = (ymax-ymin)/(ny-1)
      dz = (zmx-zmn)
      zmin=1e30
      zmax=-1e30
      do 65 i=1,nx
         x = xmin + (i-1)*dx
         do 60 j=1,ny
            y = ymin + (j-1)*dy
            z(i,j) = zmn + dz*(fxy(x,y,0.0,0.0,15.0,10.0) +
     $           0.9*fxy(x,y,-5.0,-2.5,10.0,20.0) +
     $           0.75*fxy(x,y,7.0,3.0,20.0,20.0) +
     $           0.85*fxy(x,y,2.0,-4.0,15.0,15.0) +
     $           0.85*fxy(x,y,-2.5,6.5,25.0,35.0))
            zmin=amin1(zmin,z(i,j))
            zmax=amax1(zmax,z(i,j))
 60      continue
 65   continue
      dz = (zmax-zmin)/(nlevls+1)
      do 20 i=1,nlevls
         collev(i) = zmin + i*dz
 20   continue
      j = ifcolor
      do 30 i=1,nlevls+1
         icolrs(i) = j
         j = j + 1
         if (j .ge. ncolors+ifcolor) j = ifcolor
 30   continue
      xylim(1,4)=1.0
      xylim(2,4)=1.0
 85   width = xlencm-1.0
      height = ylencm-1.0
      xoff = 0.5
      yoff = 0.5
 100  print 120
 120  format('Relative camera position - r,phi,theta')
      read (5,150) camloc(1),camloc(2),camloc(3)
 150  format(3f10.0)
      print 131
 131  format('Enter visibilty parameter "marplt":')
      read (5,140) marplt
 140  format(i6)
      call bgnplt
      csize = goodcs(0.3)
      call purjoycol(z,nx,iz,nx,ny,camloc,xylim,'x axis'//char(0),
     $     'y axis'//char(0),'z axis'//char(0),csize,marplt,collev,
     &nlevls,icolrs)
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
