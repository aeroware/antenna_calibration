      subroutine mpclip(area)
      dimension area(4)
c     
c     This subroutine sets up the clipping window for the current map
c     
      include 'pltsiz.prm'
      include 'pltprm.prm'
c     
      ticksp = amax1(0.0,tickln)
c
c     Make diglib clipping occur at ends of bounding axis of end of outside
c      ticks.
c
      call gssclp(xvstrt-ticksp,xvstrt+xvlen+2.0*ticksp,
     1     yvstrt-ticksp,yvstrt+yvlen+2.0*ticksp,area)
      return
      end
