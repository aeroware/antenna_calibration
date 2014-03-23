      subroutine gspstr(bstrng)
      character*1 bstrng(80)
c     
c     this subroutine strokes out the character string "bstrng" (a byte
c     array with 0 as a terminator) at the current position.
c     
      include 'gcvpos.prm'
      include 'gccoff.prm'
      include 'gcltyp.prm'
      include 'gcfont.cmn'
c     
c     don't draw characters in linetypes
c     
      iold = ilntyp
      ilntyp = 1
c     
c     remember original font
c     
      ioldfont = islotfont(icfontslot)
c     
      nbyte = 0
 100  nbyte = nbyte + 1
c     
c     save the (0,0) position of the character
c     
      xoff = xvpos
      yoff = yvpos
c     
c     get the character to stroke
c     
      iichar = ichar(bstrng(nbyte))
      if (iichar .eq. 0) go to 200
c     
c     check for temporary font change
c     
c     !if not "\" then not a font change
      if (iichar .ne. 92) go to 150
      nsbyte = nbyte
      nbyte = nbyte + 1
      iichar = ichar(bstrng(nbyte))
c     !double "\" is print single "\"
      if (iichar .eq. 92) go to 150
      numfnt = 0
 120  continue
c     !strip to digit
      n = iichar - 48
      if (n .lt. 0 .or. n .gt. 9) goto 130
      numfnt = numfnt*10+n
      nbyte = nbyte + 1
      iichar = ichar(bstrng(nbyte))
      if (iichar .ne. 92) goto 120
      if (numfnt .eq. 0) then
         call gsfont(ioldfont,ierr)
      else
         call gsfont(numfnt,ierr)
      endif
      go to 100
c     
c     what appeared to be a font change wasn't
c     
 130  continue
      nbyte = nsbyte
      iichar = ichar(bstrng(nbyte))
c     
c     stroke the character
c     
 150  continue
      call gsstrk(iichar)
      go to 100
c     
c     return line type and font to that of before
c     
 200  continue
      ilntyp = iold
      call gsfont(ioldfont,ierr)
      return
      end
