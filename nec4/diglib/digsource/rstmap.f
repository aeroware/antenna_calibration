      subroutine rstmap(area)
      dimension area(14)
c     
c     this subroutine restores the mapping parameters saved by "savmap".
c     
      include 'pltclp.prm'
      include 'pltcom.prm'
      include 'pltsiz.prm'
c     
c     restore the mapit clipping limits
c     
      xmin = area(1)
      xmax = area(2)
      ymin = area(3)
      ymax = area(4)
c     
c     save world to virtual coord. transformation const.
c     
      ux0 = area(5)
      udx = area(6)
      uy0 = area(7)
      udy = area(8)
      logx = .false.
      if (area(9) .ne. 0.0) logx = .true.
      logy = .false.
      if (area(10) .ne. 0.0) logy = .true.
c     
c     restore virt. coord. of axes
c     
      xvstrt = area(11)
      yvstrt = area(12)
      xvlen = area(13)
      yvlen = area(14)
c     
c     all done
c     
      return
      end
