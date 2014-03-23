C     *****
C     This set of subroutines performs the graphics I/O functions for most
C     terminals using the standard terminal driver.
C     It was originally written for a VMS system and then modified to run
C     under UNIX.
C     ****
      subroutine gbinit(termin,endstr,ttname,ierr)
      character*1 endstr(1), termin
c     
c     this subroutine initializes the graphics drivers buffering
c     subroutines
c     
      include 'gbcomm.cmn'
c     
      external len
c     
c     assign a channel to the device output device
c     
      ierr = 0
      iochan=6
      call scopy(endstr,cendst)
      iendle = len(cendst)
c     
      termch = termin
c     
      call gbnewb
      return
      end
      
      
      
      subroutine gbnewb
c     
c     subroutine to initialize the graphic command buffer
c     
      include 'gbcomm.cmn'
c     
      ibfptr = 1
      lusete = .false.
      return
      end
      
      
      
      function gbtest(numchr)
      logical gbtest
c     
c     this subroutine checks to make sure there is enough room in
c     the buffer for "numchr" more characters, if not, if makes room by
c     emptying the buffer.
c     
      include 'gbcomm.cmn'
c     
      if (ibfptr+numchr+iendle .ge. ibfsiz) then
         call gbempt
         gbtest = .true.
      else
         gbtest = .false.
      endif
      return
      end
      
      
      
      subroutine gbuset
c     
c     this subroutine sets the "use terminator" flag to true.
c     the flag is set to false by emptying/clearing the buffer.
c     
      include 'gbcomm.cmn'
c     
      lusete = .true.
      return
      end
      
      
      
      subroutine gbnote
c     
c     this subroutine clears the "use terminator" flag to false.
c     
      include 'gbcomm.cmn'
c     
      lusete = .false.
      return
      end
      
      
      
      subroutine gbempt
c     
c     this subroutine emptys the buffer if it has anything
c     
      include 'gbcomm.cmn'
c     
c     
      if (ibfptr .eq. 1) go to 900
      if (lusete) call gbinse(termch)
      if (iendle .ne. 0) call gbinst(cendst)
      if (ibfptr .gt. ibfsiz+1) stop 'buffering error'
c     
c     send to tty
c     
      call gbsend(buffer,ibfptr-1)
 900  call gbnewb
      return
      end
      
      
      
      subroutine gbsend(buff,ibufrl)
      character*1 buff(ibufrl)
c     
c     this subroutine emptys the buffer if it has anything
c     
      include 'gbcomm.cmn'
c     
      do 100 i=1,ibufrl
c         call fputc(iochan,buff(i))
         write(*,90)buff(i)
90       format(a1,$)
 100  continue
      return
      end
      
      
      
      subroutine gbsenc(buff,ibufrl)
c     
c     this subroutine necessary for compatibility with gdio2buf.for
c     and the way it works
c     
      call gbsend(buff,ibufrl)
      return
      end
      
      
      
      subroutine gbinse(bchar)
      character*1 bchar
c     
c     this subroutine inserts a character into the buffer
c     
      include 'gbcomm.cmn'
c     
      buffer(ibfptr) = bchar
      ibfptr = ibfptr + 1
      return
      end
      
      
      subroutine gbinst(string)
      character*1 string(2)
c     
c     this subroutine inserts the string into the graphics buffer
c     
      external len
c     
      do 100 i=1, len(string)
         call gbinse(string(i))
 100  continue
      return
      end
      
      
      subroutine gbfini(relstr)
      character*1 relstr(2)
c     
c     this subroutine releases the i/o channal to the output device
c     
      include 'gbcomm.cmn'
c     
      external len
c     
      if (len(relstr) .ne. 0) then
         call gbempt
         call gbinst(relstr)
         call gbempt
      endif
      return
      end
      
      
      subroutine gbgin(prompt,iginch,lterms,ginbuf)
      character*1 ginbuf(2), prompt(2)
      logical lterms
c     
c     this subroutine does a gin operation via a "read-after-prompt"
c     qiow.
c     
      include 'gbcomm.cmn'
c     
      external len
c     
      iprlen = len(prompt)
      ii = 1
      nget = iginch
      do 97 i=1,iprlen
c         call fputc(iochan,prompt(i))
         write(*,90)prompt(i)
90       format(a1,$)
 97   continue
      do 98 i=1,nget
         call getc(ginbuf(i))
         if (ginbuf(i).eq.char(13)) goto 99
 98   continue
      i=nget
 99   continue
      ginbuf(i)='\0'
      ngot=i-1
      return
      end
