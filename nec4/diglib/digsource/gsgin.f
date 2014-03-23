      subroutine gsgin(x,y,bchar,ierr)
      character*1 bchar
c     
c     this diglib subroutine tries to get graphic input (gin) from
c     the currently selected device.   if the device is not capable
c     of gin, ierr=-1.   for gin devices, ierr=0 and:
c     x	= x position of cursor in absolute screen cm.
c     y	= y position of cursor in absolute screen cm.
c     bchar	= character stuck at terminal to signal cursor has
c     been positioned.
c     
      include 'gcdchr.prm'
      include 'gcdprm.prm'
      dimension array(3)
      character*1 space
      data space /' '/
c     
c     see if device supports gin
c     
      if (iand(idvbts,128) .eq. 0) go to 900
c     
c     now ask for gin from device driver
c     
      call gsdrvr(9,array,dummy)
c     
c     convert absolute cm. coord. to virtual cm. coordinates
c     
      call gsirst(array(2),array(3),x,y)
c     
c     get character as 7 bit ascii
c     
      if (array(1) .ge. 0.0 .and. array(1) .le. 127.0) then
         bchar = char(int(array(1)))
      else
         bchar = space
      endif
      ierr = 0
      return
c     
c     device doesn't support gin
c     
 900  ierr = -1
      return
      end
