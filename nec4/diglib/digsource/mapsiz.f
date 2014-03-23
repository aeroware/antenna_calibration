      subroutine mapsiz(xlpct,xrpct,ybpct,ytpct,chrsiz)
      include 'gcdprm.prm'
c     
      xleft = vxl + (vxh-vxl)*xlpct/100.0
      xright = vxl + (vxh-vxl)*xrpct/100.0
      ybot = vyl + (vyh-vyl)*ybpct/100.0
      ytop = vyl + (vyh-vyl)*ytpct/100.0
      csize = chrsiz
      if (csize .eq. 0.0)
     1     csize = goodcs(amax1(0.3,amin1(ytop-ybot,xright-xleft)/80.0))
      call mapprm(xleft,xright,ybot,ytop,csize,0.9*csize,.false.)
      return
      end
