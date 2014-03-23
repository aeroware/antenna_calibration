      subroutine devsel(newdev,lun,ierr)
c     
      include 'gcdsel.prm'
      EXTERNAL blkcmn
c     
      dimension devchr(8)
c     
c     release current device
c     
      if (idev .ne. 0) call gsdrvr(6,dummy,dummy)
c     
c     now init. the new device
c     
      if (newdev .lt. 0) go to 900
      if (newdev .ne. 0) idev = newdev
c     
c     get the device characteristics (and see if device there)
c     
      devchr(8) = 1.0
      call gsdrvr(7,devchr,dummy)
      if (devchr(1) .eq. 0.0) go to 900
c     
c     initialize the device for diglib graphics
c     
      call gsdrvr(1,float(lun),dummy)
      ierr = dummy
      if (ierr .ne. 0) go to 910
c     
c     set device characteristics for later use
c     (second call to driver needed to get actual size of display window)
c     
      call gsgdev
      return
c     
c     non-existant device selected, report error and deselect device
c     
 900  ierr = -1
c     
c     device initialization failed, deselct device
c     
 910  idev = 0
      return
      end
