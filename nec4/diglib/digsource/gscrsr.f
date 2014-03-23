      subroutine gscrsr(x,y,ibutn,ierr)
c     
c     this diglib subroutine tries to get graphic input from
c     the currently selected device.   if the device is not capable
c     of it, ierr=-1, else ierr=0 and:
c       x	= x position of cursor in virtual coordinates
c       y	= y position of cursor in virtual coordinates
c     ibutn	= new button state
c     
      include 'gcdchr.prm'
      include 'gcdprm.prm'
      dimension array(3)
c     
c     see if device supports cursor
c     
      if (iand(idvbts,1024) .eq. 0) go to 900
c     
c     now ask for cursor from device driver
c     
      call gsdrvr(12,array,dummy)
c     
c     convert absolute cm. coord. to virtual coordinates
c     
      call gsirst(array(2),array(3),x,y)
c     
c     get button state
c     
      ibutn = array(1)
 120  continue
      ierr = 0
      return
c     
c     device doesn't support gin
c     
 900  ierr = -1
      return
      end
