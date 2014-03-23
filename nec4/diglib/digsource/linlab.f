      subroutine linlab(num,iexp,strng,lrmtex)
      logical lrmtex
      character*1 strng(8)
c     
      character*1 bminus, bzero(4)
      external len
      data bminus /'-'/
      data bzero /'0', '.', '0', '\0'/
c     
c     
      lrmtex = .true.
c     
c     work with absolute value as it is easier to put sign in now
c     
      if (num .lt. 0) go to 10
      nval = num
      istart = 1
      go to 20
 10   continue
      nval = -num
      istart = 2
      strng(1) = bminus
 20   continue
      if (iexp .ge. -2 .and. iexp .le. 2) lrmtex = .false.
      if (iexp .gt. 0 .and. (.not. lrmtex)) nval = nval*10**iexp
      call numstr(nval,strng(istart))
      if ((nval .eq. 0) .or. lrmtex .or. (iexp .ge. 0)) goto 800
c     
c     number is in range 10**-1 or 10**-2, so format pretty
c     
      n = -iexp
      l = len(strng(istart))
      izbgn = 1
      nin = 3
      if (n .eq. l) nin = 2
c     
c     if n<l then we need only insert a decimal point
c     
      if (n .ge. l) go to 40
      izbgn = 2
      nin = 1
 40   continue
c     
c     allow room for decimal point and zero(s) if necessary
c     
      ibegin = istart + max0(0,l-n)
      do 50 i = 0, min0(n,l)
         strng(istart+l+nin-i) = strng(istart+l-i)
 50   continue
c     
c     insert leading zeros if necessary, or just decimal point
c     
      do 60 i=0,nin-1
         strng(ibegin+i) = bzero(izbgn+i)
 60   continue
c     
c     all done
c     
 800  return
      end
      
      
      function ilabsz()
c     
c     this function returns the maximum length that "linlab" will return.
c     
      ilabsz = 6
      return
      end
