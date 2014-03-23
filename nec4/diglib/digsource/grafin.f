      subroutine grafin(x,y,lflag)
      logical lflag
c     
c     display and read the graphics cursor and return its position
c     in world coordinates.
c     
      include 'pltcom.prm'
      include 'pltsiz.prm'
c     
c     get cursor position in virtual coordinates.
c     
      call gscrsr(x,y,lflag,ierr)
      if (ierr .ne. 0) return
      x = (x-xvstrt)*udx/xvlen + ux0
      if (logx) x = 10.0**x
      y = (y-yvstrt)*udy/yvlen + uy0
      if (logy) y = 10.0**y
      return
      end
