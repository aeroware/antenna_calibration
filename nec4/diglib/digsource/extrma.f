      subroutine extrma(xv,yv,zv,xa,xb,ya,yb,ierr)
c     
      include 'comdp.inc'
c     
      dimension xs(3), xc(3)
c     
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     
      xs(1) = xv
      xs(2) = yv
      xs(3) = zv
      call rotate(xs,amtx,xc) 
c     quit if point is behind camera 
      if(xc(3).le.0.0) go to 50 
      xc(1) = xc(1)/xc(3) 
      xc(2) = xc(2)/xc(3) 
      xa = amin1(xa,xc(1)) 
      xb = amax1(xb,xc(1)) 
      ya = amin1(ya,xc(2)) 
      yb = amax1(yb,xc(2)) 
      ierr = 0
      return
 50   ierr = -1
      return
      end
