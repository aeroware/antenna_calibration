      function gslens(bstrng)
      character*1 bstrng(2)
c     
c     this function returns the length in virtual coordinates of
c     the string bstrng.   the current character size is assumed,
c     but font blips are recognized.
c     
      external len
c     
      include 'gccpar.prm'
      include 'gcfont.cmn'
c     
      gslens = 0.0
      iorigfont = islotfont(icfontslot)
      ioff = 95*(icfontslot-2) - 32
      nbyte = 0
 100  continue
      nbyte = nbyte + 1
      ich = ichar(bstrng(nbyte))
      if (ich .eq. 0) go to 200
c     
c     check for temporary font change
c     
c       if not "\" then not a font change
c
      if (ich .ne. 92) go to 150
      nsbyte = nbyte
      nbyte = nbyte + 1
      ich = ichar(bstrng(nbyte))
c       double "\" is print single "\"
      if (ich .eq. 92) go to 150
      numfnt = 0
 120  continue
c       strip to digit
      n = ich - 48
      if (n .lt. 0 .or. n .gt. 9) goto 130
      numfnt = numfnt*10+n
      nbyte = nbyte + 1
      ich = ichar(bstrng(nbyte))
      if (ich .ne. 92) goto 120
      if (numfnt .eq. 0) then
         call gsfont(iorigfont,ierr)
      else
         call gsfont(numfnt,ierr)
      endif
      ioff = 95*(icfontslot-2) - 32
      go to 100
c     
c     what appeared to be a font change wasn't
c     
 130  continue
      nbyte = nsbyte
      ich = ichar(bstrng(nbyte))
 150  continue	
      if (icfontslot .eq. 1) then
         gslens = gslens + 9.0*csize
      else
         if (ich .le. 32 .or. ich .ge. 128 .or.
     1        bwidth(ich+ioff) .le. 0) ich = 65
         iwidth = bwidth(ich+ioff)
         gslens = gslens + csize*iwidth
      endif
      go to 100
c     
c     all done
c     
 200  continue
      call gsfont(iorigfont,ierr)
      return
      end
