      PROGRAM CONVERT
C     
C     Modified for UNIX by S. Azevedo 12/22/86
C     Modified by Hal R. Brand 5-Apr-1990
C     
C     This program converts a ASCII font file into the DIGLIB compressed
C     binary format.   The default file type for input is .fnt and on
C     output, a .fon file is created.   This utility is distributed with
C     DIGLIB for creating the necessary binary font files.
c
      integer*2 iptr(129)
      integer*2 bx(9),by(9)
      integer*2 bwidth(127)
      integer*2 coords(10000)
      character*80 prefix,fname
c     
      print *,'Enter font file (.fnt)>'
      read (5,'(a)') prefix
c      fname = prefix(:lnblnk(prefix)) // '.fnt'
      fname=prefix(:index(prefix,' ')-1) //'.fnt'
c      print 1,fname(:lnblnk(fname))
      print 1,fname(:index(fname,' ')-1)
 1    format('Reading file "',a,'"')
      open (unit=1,file=fname,status='old')
      minchar = 9999
      maxchar = -9999
      next = 1
      do 5 i=1,127
         bwidth(i) = -1
 5    continue
c     
c     loop reading in all characters
c     
      print *,'Reading the characters...'
 10   continue
      read (1,11,end=900) jchar,nstrokes,ileft,iright,
     $     (bx(i),by(i), i=1,7)
 11   format(18i4)
      if (jchar .eq. 0) goto 10
      call putc(char(jchar))
cd    type *,'jchar is ',jchar
cd    if (jchar .le. 0 .or. jchar .gt. 128) stop 'character out of range'
      maxchar = max(jchar,maxchar)
      minchar = min(jchar,minchar)
      iptr(jchar) = next
      if (nstrokes .le. 0) go to 10
      bwidth(jchar) = iright-ileft
      nstrokes = (nstrokes-2)/2
      i = 1
      maxi = 7
 100  continue
      if (i .gt. maxi) then
         read (1,11) (bx(i),by(i), i=1,9)
         i = 1
         maxi = 9
      endif
      if (nstrokes .gt. 1) then
         if (bx(i) .eq. -999) then
cd    if (by(i) .eq. -999) stop 'error - double -999'
            coords(next) = -64
         else
            coords(next) = bx(i) - ileft
            next = next + 1
            coords(next) = by(i) + 9
         endif
         next = next + 1
      endif
      i = i + 1
      nstrokes = nstrokes-1
      if (nstrokes .gt. 0) go to 100
      go to 10
 900  continue
      close (unit=1)
      iptr(128) = next
      i = iptr(65)-1
 905  continue
      i = i + 1
      if (i .ge. iptr(66)) go to 907
      if (coords(i) .eq. -64) go to 905
      i = i + 1
      j = coords(i)
      maxheight = max(maxheight,j)
      go to 905
 907  continue
      itotal = next -1
      print 901, minchar,maxchar,maxheight,itotal
 901  format(//' minimum character code was ',i5,
     1     /' maximum character code was ',i3,
     2     /' height of "a" is ',i3,
     3     /' total number of bytes in stroke table is ',i5//)
      iblocks = 1+(itotal+511)/512
c      fname = prefix(:lnblnk(prefix)) // '.fon'
c      print 921,fname(:lnblnk(fname))
      fname=prefix(:index(prefix,' ')-1)//'.fon'
      print 921,fname(:index(fname,' ')-1)
 921  format('Writing file "',a,'"')
      open (unit=2,file=fname,status='new',access='sequential',
     1     form='unformatted')
      write (2) itotal, maxheight, (iptr(i), i=33,128),
     1     (bwidth(i), i=33,127)
      do 910 i=1,iblocks-1
         write (2) (coords(j), j=1+512*(i-1),512*i)
 910  continue
      close (unit=2)
      stop
      end
