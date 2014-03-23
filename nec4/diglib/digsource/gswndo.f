      subroutine gswndo(uxl,uxh,uyl,uyh,xoff,yoff,xawdth,yahigh)
c     
c     this subroutine provides diglib v3's window/viewport mechanism.
c     
      include 'gcclip.prm'
      include 'gcdchr.prm'
      include 'gcdprm.prm'
c     
c     
      rcos = 1.0
      rsin = 0.0
      xs = xawdth/(uxh-uxl)
      ys = yahigh/(uyh-uyl)
      xt = xoff - xs*uxl
      yt = yoff - ys*uyl
      xcm0 = amax1(amin1(xoff,xoff+xawdth),0.0)
      ycm0 = amax1(amin1(yoff,yoff+yahigh),0.0)
      xcm1 = amin1(xclipd,amax1(xoff,xoff+xawdth))
      ycm1 = amin1(yclipd,amax1(yoff,yoff+yahigh))
c     
c     save virtual coordinate extent
c     
      vxl = uxl
      vxh = uxh
      vyl = uyl
      vyh = uyh
      return
      end
