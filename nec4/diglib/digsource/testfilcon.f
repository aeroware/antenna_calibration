      program testfill
      parameter (nx=33, ny=33)
      parameter (nlevel=10)
      parameter (ncolors = 6)
      parameter (ifcolor = 2)
      dimension z(nx,ny)
      dimension conlev(nlevel), icolrs(nlevel+1)
c     
      data xmin,xmax,ymin,ymax /-10.0,10.0,-10.0,10.0/
c     
c     pick diglib device for plot
c     
      call seldev(4)
c     
c     fake up some z(x,y) data
c     
      dx = (xmax-xmin)/(nx-1)
      dy = (ymax-ymin)/(ny-1)
      zmx = 1.0
      zmn = 0.0
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
c     
c     pick contour levels evenly spaced across the range
c     
      do 100 j=1,nlevel
         conlev(j) = zmin + j*(zmax-zmin)/float(nlevel+1)
 100  continue
      j = ifcolor
      do 110 i=1,nlevel+1
         icolrs(i) = j
         j = j + 1
         if (j .ge. ncolors+ifcolor) j = ifcolor
 110  continue
      call bgnplt
      call fulmap
      call mapit(xmin,xmax,ymin,ymax,'x lab'//char(0),'ylab'//char(0),
     $     'demo of filled contours'//char(0),0)
      call filcon(z,nx,nx,ny,xmin,xmax,ymin,ymax,nlevel,conlev,icolrs)
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
