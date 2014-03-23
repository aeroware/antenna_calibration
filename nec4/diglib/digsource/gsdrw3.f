      subroutine gsdrw3(x0,y0,x1,y1)
c     
c     draw a line from (x0,y0) to (x1,y1) in absolute coordinates.
c     assumes that clipping has already been done.   to suppress unnecessary
c     "moves", this is the only routine that should call gsdrvr(3,,,).
c     the line is drawn in the current line type.   this routine does not
c     set the absolute position (xapos,yapos).   it is up to the caller to
c     do so if necessary.
c     
      include 'gcltyp.prm'
c     
      if (ilntyp .gt. 1) go to 50
      if (.not. lposnd) call gsdrvr(3,x0,y0)
      go to 220
c     
c     segment line to make current line type
c     
 50   continue
      if (.not. linilt) go to 100
      inxtl = 1
      dleft = dist(1,ilntyp-1)
      linilt = .false.
      if (.not. lposnd) call gsdrvr(3,x0,y0)
 100  dx = x1-x0
      dy = y1-y0
      dl = sqrt(dx**2+dy**2)
c     
c     see if this segment is shorter that dist. left on line type
c     
      if (dl .le. dleft) go to 200
c     
c     segment is longer, so advance to line type break
c     
      s = dleft/dl
      x0 = s*dx+x0
      y0 = s*dy+y0
c     
c     see if this part of the line type is drawn or skipped
c     
      if (iand(inxtl,1) .ne. 0) go to 120
      call gsdrvr(3,x0,y0)
      go to 140
 120  continue
      call gsdrvr(4,x0,y0)
 140  continue
c     
c     now go to next portion of line type
c     
      inxtl = inxtl + 1
      if (inxtl .gt. 4) inxtl = 1
      dleft = dist(inxtl,ilntyp-1)
      go to 100
c     
c     draw last of line if drawn
c     
 200  continue
      dleft = dleft - dl
      if (iand(inxtl,1) .ne. 0) go to 220
      lposnd = .false.
      go to 240
 220  continue
      call gsdrvr(4,x1,y1)
      lposnd = .true.
 240  continue
      return
      end
