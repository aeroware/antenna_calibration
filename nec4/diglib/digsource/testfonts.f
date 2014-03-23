      program testfonts
c     
c     this program will display all the available diglib fonts (as long
c     as there are no gaps).   it is merely here for your viewing pleasure
c     and is completely unsupported.
c     
c     character*1 bname(40),dummy
c     
      external len
c     
c     note: seldev is a new and supported thing with diglib v3.0
c     
      call seldev(4,ierr)
 10   call bgnplt
c     
      y = gsylcm()
      i = 0
 100  continue
      i = i + 1
      call gsfont(i,ierr)
      if (ierr .lt. 0) go to 200
      size = goodcs(0.3)
      if ((y-7.0*size) .lt. 0.0) then
         call endplt
         print 191
 191     format('$hit return to see more fonts.')
         read(5,192) dummy
 192     format(a1)
         call bgnplt
         y = gsylcm()
      endif
      call gssetc(size,0.0)
      y = y - 2.0*size
      call gsmove(0.5,y)
      call gspstr('ABCDEFGHIJKLMNOPQRSTUVWXYZ'//char(0))
      y = y - 2.0*size
      call gsmove(0.5,y)
      call gspstr('abcdefghijklmnopqrstuvwxyz'//char(0))
      y = y - 2.0*size
      call gsmove(0.5,y)
      call gspstr('!@#$%^&*()-+={}[];:<>,.?/"'//char(0))
      go to 100
 200  continue
      call endplt
      print *,'Hit return to exit testfonts'
      read (5,'(a)') dummy
      call rlsdev
      stop
      end
