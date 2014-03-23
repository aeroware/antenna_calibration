      subroutine gscolr(icolor,ierr)
      include 'gcdchr.prm'
c     
c     select color "icolor" on current device
c     
      logical lnobkg
      ierr = 0
c     
c     lnobkg set to true if no background color exists on this device
c     
      lnobkg = iand(idvbts,4) .eq. 0
c     
c     first, error if background color requested and device does not
c     support background color write.
c     
      if (icolor .eq. 0 .and. lnobkg) go to 900
c     
c     second, error if color requested is larger than the number of
c     foreground colors available on this device
c     
      if (icolor .gt. ndclrs) go to 900
c     
c     if only 1 foreground color and no background color, then
c     driver will not support set color, and of course, the
c     color must be color 1 to have gotten this far, so just return
c     
      if (ndclrs .eq. 1 .and. lnobkg) return
c     
c     all is ok, so set the requested color
c     
 100  call gsdrvr(8,float(icolor),dummy)
      return
 900  ierr = -1
      return
      end
