      subroutine mapprm(xleft,xright,ybot,ytop,csize,tkln,lraxis)
      logical lraxis
      include 'pltsiz.prm'
      include 'pltprm.prm'
      include 'gcdprm.prm'
c
c
      xbordr = 0.25/xs
      ybordr = 0.25/ys
      call gssetc(csize,0.0)
      cxsize = gslens('0'//char(0))
      cysize = csize
      tickln = tkln
      ticksp = amax1(0.0,tickln)
      tlabln = ilabsz()+0.25
      xvstrt = xleft + ticksp + tlabln*cxsize + 2.0*cysize + xbordr
      xvlen = xright - xvstrt - (tlabln/2.0)*cxsize - xbordr
      if (lraxis) xvlen = xvlen - (ticksp + tlabln*cxsize + 2.0*cysize)
      ticksp = amax1(0.5*cysize,tickln)
      yvstrt = ybot + ticksp + 4.25*cysize + ybordr
      yvini = ytop - yvstrt - 2.0*cysize - ybordr
      return
      end
