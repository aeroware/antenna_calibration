      subroutine savmap(area)
      dimension area(15)
c     
c     this subroutine saves the status from the last mapprm-mapit calls.
c     when used in conjuction "rstmap", the user can switch around between
c     multiple graphic regions on the screen created with "mapit".
c     
      include 'pltclp.prm'
      include 'pltcom.prm'
      include 'pltsiz.prm'
c     
c     save the mapit clipping limits
c     
      area(1) = xmin
      area(2) = xmax
      area(3) = ymin
      area(4) = ymax
c     
c     save world to virtual coord. transformation const.
c     
      area(5) = ux0
      area(6) = udx
      area(7) = uy0
      area(8) = udy
      area(9) = 0.0
      if (logx) area(9) = 1.0
      area(10) = 0.0
      if (logy) area(10) = 1.0
c     
c     now save virt. coord. location of axes
c     
      area(11) = xvstrt
      area(12) = yvstrt
      area(13) = xvlen
      area(14) = yvlen
c     
c     all done
c     
      return
      end
