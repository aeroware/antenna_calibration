      subroutine gsfont(newfont,ierr)
c     
c     this subroutine selects a new font, loading it if necessary
c     
      parameter (lun=91)
c     
      character*256 filnam,prefix
c     
      include 'gccpar.prm'
      include 'gcfont.cmn'
c     
      character*12 fontnm(maxfnt)
c     
c     use a 16-bit number to read in the offsets, but the data
c     is really supposed to be in a long int.
      integer*2 jndx(96)
c     
      data fontnm / 'default', 'bromns.fon', 'broman.fon',
     1     'bitals.fon', 'script.fon', 'bscrpt.fon',
     2     'uncial.fon', 'bgreek.fon', 'gothen.fon',
     3     'gothgr.fon' /
c     
c     
      if (newfont .le. 0 .or. newfont .gt. maxfnt) then
         ierr = -1
         return
      endif
      islot = 1
 100  continue
      if (islotfont(islot) .eq. newfont) go to 200
      islot = islot + 1
      if (islot .le. maxslot) go to 100
c     
c     ***** load new font ***
c     
      maxslot = islot
      islotfont(islot) = newfont
c     
      call getenv('DIGLIB'//char(0),prefix)
c      filnam = prefix(:lnblnk(prefix)) // fontnm(newfont)
      filnam=prefix(:index(prefix,' ')-1)//fontnm(newfont)
c     
c     
      open (unit=lun,file=filnam,status='old',access='sequential',
     1     form='unformatted',err=900)
c     
c     calculate offsets into tables
c     
      ist = 1 + 95*(islot-1)
      iend = ist + 95
      ioff = indx(ist)-1
      read (lun) itotby, iheight(islot),
     1     (jndx(i), i=1,96),
c     changed       (indx(i), i=ist,iend),
     2     (bwidth(i), i=ist-95,iend-96)
c     
c     make sure it all fits
c     
      if ((ioff+itotby) .gt. maxstrokes) then
         close (unit=lun)
         ierr = -1
         return
      endif
c     
c     now add offset to indexes
c     
      j=1
      do 180 i=ist,iend
         indx(i) = jndx(j)
         if (indx(i) .gt. 0) indx(i) = indx(i) + ioff
         j=j+1
 180  continue
c     
c     read in the strokes
c     
      iblocks = (itotby+511)/512
      jst = ioff+1
      do 190 i=1,iblocks-1
         read (lun) (bxy(j), j=jst,jst+511)
         jst = jst + 512
 190  continue
      if (jst .le. itotby+ioff) then
         read (lun) (bxy(j), j=jst,itotby+ioff)
      endif
      close (unit=lun)
c     
c     ***** select the new font *****
c     
 200  continue
      oldh = gschit()
      icfontslot = islot
      csize = oldh*csize/gschit()
      ierr = 0
      return
c     
c     font file not found
c     
 900  continue
      ierr = -2
      return
      end
