      subroutine gssclp(vx0,vx1,vy0,vy1,area)
      dimension area(4)
c     
c     this subroutine saves the current absolute clipping window and
c     sets a new absolute clipping window given virtual coordinates.
c     it makes sure that the clipping window never lies outside the
c     physical device.
c     
      include 'gcclip.prm'
      include 'gcdchr.prm'
c     
      area(1) = xcm0
      area(2) = xcm1
      area(3) = ycm0
      area(4) = ycm1
c     
      call gsrst(vx0,vy0,ax0,ay0)
      call gsrst(vx1,vy1,ax1,ay1)
      xcm0 = amax1(amin1(ax0,ax1),0.0)
      ycm0 = amax1(amin1(ay0,ay1),0.0)
      xcm1 = amin1(xclipd,amax1(ax0,ax1))
      ycm1 = amin1(yclipd,amax1(ay0,ay1))
      return
      end
