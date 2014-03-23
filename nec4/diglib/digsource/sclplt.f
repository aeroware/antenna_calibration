      subroutine sclplt(z,izdim,csize,llable,ierr)
      dimension z(izdim,ny)
      logical llable
c     
      include 'comdp.inc'
      include 'dbase.inc'
c     
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     
      xa = 1.0e30
      xb = -1.0e30
      ya = 1.0e30 
      yb = -1.0e30 
      if (camwkg(3) .ge. camwkg(6)) then
         cysize = csize
         call gssetc(csize,0.0)
         cxsize = gslens('0'//char(0))
         dx=float(mx-1)/20.0
         dy=float(ny-1)/20.0
         if=mx
         xz = xmax
         ib=1
         jf=ny
         yz = ymin
         jb=1
         if (camwkg(1) .lt. camwkg(4)) then
            if=1
            xz = xmin
            ib=mx
            dx=-dx
         endif
         if (camwkg(2) .lt. camwkg(5)) then
            jf=1
            yz = ymax
            jb=ny
            dy=-dy
         endif
         frx=if
         bkx=ib
         fry=jf
         bky=jb
         vx = xmin + (frx-1.0)*gx(1) - camwkg(1)
         vy = ymin + (bky-1.0-dy)*gx(2) - camwkg(2)
         call extrma(vx,vy,zmax-camwkg(3),xa,xb,ya,yb,ierr)
         if (ierr .ne. 0) go to 9000
         temp = zmin - camwkg(3)
         call extrma(vx,vy,temp,xa,xb,ya,yb,ierr)
         if (ierr .ne. 0) go to 9000
         vy = ymin + (fry-1.0+dy)*gx(2) - camwkg(2)
         call extrma(vx,vy,temp,xa,xb,ya,yb,ierr)
         if (ierr .ne. 0) go to 9000
         call extrma(xmin+(bkx-1.0)*gx(1)-camwkg(1),vy,temp,
     $        xa,xb,ya,yb,ierr)
         if (ierr .ne. 0) go to 9000
         vx = vx + dx*gx(1)
         call extrma(vx,ymin+(bky-1.0)*gx(2)-camwkg(2),temp,
     $        xa,xb,ya,yb,ierr)
         if (ierr .ne. 0) go to 9000
         call extrma(vx,vy-dy*gx(2),temp,xa,xb,ya,yb,ierr)
         if (ierr .ne. 0) go to 9000
      endif
      do 22 j=1,ny
         vy = ymin + (j-1)*gx(2) - camwkg(2)
         do 20 i=1,mx
            vx = xmin + (i-1)*gx(1) - camwkg(1)
            call extrma(vx,vy,z(i,j)-camwkg(3),xa,xb,ya,yb,ierr)
            if (ierr .ne. 0) go to 9000
 20      continue
 22   continue
c     
c     scale x and y ranges to fit on plot
c     
      if (llable) then
         temp = (2.0*tickln()+0.5)*cxsize
      else
         temp = 0.0
      endif
      fx(1) = (plotx-temp)/(xb-xa) 
      if (llable) then
         temp = 2.0*cysize
      else
         temp = 0.0
      endif
      fx(2) = (ploty-temp)/(yb-ya) 
c     
c     choose minimum focal length of the two 
c     
      focall = amin1(fx(1),fx(2)) 
c     
c     set x,y origins (before scaling to focal length) 
c     
      xorg(1) = xa 
      xorg(2) = ya 
c     
c     sizes in x,y (not including out-of-box poiints that get in pic) 
c     
      xb = (xb-xa)*focall 
      yb = (yb-ya)*focall 
c     
c     center plot in region user gave us
c     
      center(1) = (plotx-xb)/2.0 
      center(2) = (ploty-yb)/2.0 
      ierr = 0
      return 
 9000 continue
      ierr = -1
      return
      end 
