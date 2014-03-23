      subroutine scale(x,y,vx,vy)
c     
c     this subroutine converts the point (x,y) from world coordinates
c     to the point (vx,vy) in virtual coordinates.
c     
      include 'pltcom.prm'
      include 'pltsiz.prm'
c     
c     define "log10(0.0)" as smllog
c     
      data smllog /-100.0/
c     
      xx = x
      if (.not. logx) go to 10
      if (x .le. 0.0) go to 5
      xx = alog10(x)
      go to 10
 5    continue
      xx = smllog
 10   continue
      yy = y
      if (.not. logy) go to 20
      if (y .le. 0.0) go to 15
      yy = alog10(y)
      go to 20
 15   continue
      yy = smllog
 20   continue
      vx = xvstrt + xvlen*(xx-ux0)/udx
      vy = yvstrt + yvlen*(yy-uy0)/udy
      return
      end
