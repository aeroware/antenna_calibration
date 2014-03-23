      function gsivis(x,y)
      integer gsivis
c     
      include 'gcclip.prm'
c     
c     
      gsivis = 0
      if (x .lt. xcm0) gsivis = 1
      if (x .gt. xcm1) gsivis = gsivis + 2
      if (y .lt. ycm0) gsivis = gsivis + 4
      if (y .gt. ycm1) gsivis = gsivis + 8
      return
      end
