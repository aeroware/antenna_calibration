      subroutine rlsdev
c     
c     
      include 'gcdsel.prm'
c     
c     release current device
c     
      if (idev .ne. 0) call gsdrvr(6,dummy,dummy)
      idev = 0
c     
c     all done here
c     
      return
      end
