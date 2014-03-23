      subroutine gsdrgb(icolor,red,grn,blu,ierr)
      include 'gcdchr.prm'
      dimension rgb(3)
c     
c     define a color
c     
      if ( iand(idvbts,64) .eq. 0 .or.
     1     (icolor .gt. ndclrs) .or.
     2     (icolor .lt. 0)) go to 900
      ierr = 0
      rgb(1) = red
      rgb(2) = grn
      rgb(3) = blu
      call gsdrvr(10,float(icolor),rgb)
      return
 900  ierr = -1
      return
      end
