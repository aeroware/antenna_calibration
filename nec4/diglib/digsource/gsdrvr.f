      subroutine gsdrvr(ifxn,x,y)
c     
c     
      include 'gcdsel.prm'
      data maxdev /4/
c     
c     see if device exists
c     
      if (idev .gt. 0 .and. idev .le. maxdev) go to 50
c     
c     non-existant device, so see if user is just enquiring??
c     
      if (ifxn .ne. 7) return
c     
c     return device type equal zero if enquiring about non-existant
c     device.
c     
      x = 0.0
      return
c     
c     dispatch to the proper driver
c     
 50   continue
      go to (400,100,200,300) idev
c
c     device VT-100 with RETRO-GRAPHICS
c
400   call gdrtro(ifxn,x,y)
      return
c     
c     device 1 X11
c     
 100  call gdx11(ifxn,x,y)
      return
c     
c     device 2 is tall postscript driver
c     
 200  call gdpst(ifxn,x,y)
      return
c     
c     device 3 is wide postscript driver
c     
 300  call gdpsw(ifxn,x,y)
      return
      end

      
      subroutine gsdnam(idev,bname)
      character bname(40)
c     
c     this subroutine returns the device name of the specified device
c     *********** device names are limited to 39 characters **********
c     
c     
      data maxdev /4/
c     
      bname(1) = char(0)
      if ((idev .le. 0) .or. (idev .gt. maxdev)) return
      go to (400,100,200,300) idev
 400  call scopy('VT-100/RetroGraphics'//char(0),bname)
      return
 100  call scopy('X Windows (X11R3)'//char(0),bname)
      return
 200  call scopy('Tall PostScript -- laser printer (tall)'//char(0),
     &bname)
      return
 300  call scopy('Wide PostScript -- laser printer (wide)'//char(0),
     &bname)
      return
      end
