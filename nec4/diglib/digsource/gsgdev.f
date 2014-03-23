      subroutine gsgdev
c
      include 'gcdsel.prm'
      include 'gcdprm.prm'
      include 'gccpar.prm'
      include 'gcvpos.prm'
      include 'gcapos.prm'
      include 'gcclip.prm'
      include 'gcdchr.prm'
      include 'gcltyp.prm'
c
      dimension devchr(8), gdcomn(5)
      dimension dfdist(4,3)
c     
c     define default line styles
c     
      equivalence (devid,gdcomn(1))
c
      data dfdist /
     1     0.5,  0.5,  0.5,  0.5,
     2     0.25, 0.25, 0.25, 0.25,
     3     0.5, 0.25, 0.25, 0.25/
c     
c     set device characteristics for later use
c     
      call gsdrvr(7,devchr,dummy)
      do 100 i=1,5
         gdcomn(i) = devchr(i)
 100  continue
      ndclrs = devchr(6)
      idvbts = devchr(7)
      nfline = devchr(8)
      xclipd = xlencm + 0.499/devchr(4)
      yclipd = ylencm + 0.499/devchr(5)
c     
c     now init the parameters
c     
      xs = 1.0
      ys = 1.0
      xt = 0.0
      yt = 0.0
      rcos = 1.0
      rsin = 0.0
      vxl = 0.0
      vxh = xlencm
      vyl = 0.0
      vyh = ylencm
      csize = goodcs(0.3)/gschit()
      ccos = 1.0
      csin = 0.0
      xcur = 0.0
      ycur = 0.0
      ivis = 0
      xcm0 = 0.0
      ycm0 = 0.0
      xcm1 = xclipd
      ycm1 = yclipd
      ilntyp = 1
      do 120 i=1,3
         do 110 j=1,4
            dist(j,i) = dfdist(j,i)
 110     continue
 120  continue
      lcurnt = .false.
      return
      end
