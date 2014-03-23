      subroutine gsmove(x,y)
c     
c     move the the point (x,y).
c     
      include 'gcltyp.prm'
      include 'gcvpos.prm'
      include 'gcapos.prm'
      integer gsivis
c     
c     reset line style to beginning of pattern and show moved
c     
      linilt = .true.
      lposnd = .false.
c     
c     transform virtual coord. to absolute coord.
c     
      xvpos = x
      yvpos = y
      call gsrst(xvpos,yvpos,xapos,yapos)
      ivis = gsivis(xapos,yapos)
      return
      end
