      subroutine gsdraw(x,y)
c     
c     
      include 'gcvpos.prm'
      include 'gcapos.prm'
      integer gsivis
c     
c     transform virt. coor. to screen coord.
c     
      xvpos = x
      yvpos = y
      call gsrst(xvpos,yvpos,x1,y1)
      ivis1 = gsivis(x1,y1)
      call gsdrw2(xapos,yapos,ivis,x1,y1,ivis1)
      xapos = x1
      yapos = y1
      ivis = ivis1
      return
      end
