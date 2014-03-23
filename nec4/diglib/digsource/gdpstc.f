        subroutine gdpstc(ifxn,xa,ya)
        dimension xa(8), ya(3)
c
c       Authors : Brian Cabral/Steve Azevedo
c       modified for color: Tom Spelce
c       May 1990
c
c       post script driver - hard copy device has 300 dots/inch
        parameter (dpi = 300.0)
c
c-----------------------------------------------------------------------
c
c       declare vars need for driver operation
c
        logical lnoplt, lwide
        character*16 coord
c       character*8 ctime
        character*7 fname
c       character*120 comand
        character*24 cdate
        character*8 uname
        character*2 np
        logical fexist
c
        dimension dchar(8)
c
c       make nice names for the devices resolution in x and y
c        ("xgupcm" is x graphics units per centimeter)
c
        equivalence (dchar(4),xgupcm), (dchar(5),ygupcm)
c
c       paper definitions (inches)
c
        parameter (psres = 72.0)
        real*4 lmargn
        parameter (lmargn = 0.2)
        parameter (rmargn = 0.2)
        parameter (tmargn = 0.7)
        parameter (bmargn = 1.3)
        parameter (paperh = 11.0)
        parameter (paperw = 8.5)
c               derived parameters
        parameter (uwd = paperw-lmargn-rmargn)
        parameter (uht = paperh-tmargn-bmargn)
        parameter (wdcm = 2.54*uwd)
        parameter (htcm = 2.54*uht)
        parameter (resolution = dpi/2.54)
        parameter (psrescm = psres/2.54)
        parameter (xoff = psres*lmargn)
        parameter (yoff = psres*bmargn)
c
c       parameter (maxpts = 900)
        parameter (maxpts = 750)
c
c       diglib device characteristics words
c
        data dchar /910.0, wdcm, htcm, resolution,
     1   resolution, 8.0, 283.0, 4.0/
c
        lwide = .false.
        npage=0
10      continue
c
c*****************
c
c       first verify we got a graphics function we can handle
c
        if (ifxn .gt. 1026) go to 20000
        if (ifxn .le. 0 .or. ifxn .gt. 8) return
c
c       now dispatch to the proper code to handle that function
c
        go to (100,200,300,400,500,600,700,800) ifxn
c
c       *********************
c       initialize the device
c       *********************
c
100     continue
        lun = xa(1)
        fname= 'dig.ps '
        inquire(file=fname,exist=fexist)
        if ( fexist ) then
           n=0
  101      continue
           n=n+1
           fname(7:7) = char(96+n)
           inquire(file=fname,exist=fexist)
           if ( fexist ) then
              if ( n.eq.26) stop 'cannot create postscript file'
              go to 101
           endif
        endif

c       show initialization worked, i.e. we opened the file.
c
  102   write(*,103) fname(1:7)
  103   format('opening diglib plot file named ', a7 )
        open(unit=lun,file=fname,status='unknown')

c get the current date and user's name for banner page
c these will need to be changed for non UNIX systems
        call fdate(cdate)
        call getlog(uname)

        ya(1) = 0.0
        call gdpsop(lun)
c       the following line is required for unix systems
c       see adobe systems red and blue manuals for more info
c       clear the buffer to avoid spurious null characters
        call gdpsdu
        call gdpsin('%!PS-Adobe-2.0'//char(0))
        call gdpsdu
        call gdpsin('%%Title: Diglib Graphics Plot'//char(0))
        call gdpsdu
        call gdpsin('%%Creator: '//uname//char(0))
        call gdpsdu
        call gdpsin('%%Creation Date: '//cdate//char(0))
        call gdpsdu
        call gdpsin('%%EndComments'//char(0))
        call gdpsdu
        call gdpsin('initgraphics 1 setlinecap 1 setlinejoin '//char(0))
        call gdpsdu
        call gdpsin('/m {moveto} def /l {lineto} def '//char(0))
        call gdpsdu
190     continue
        lnoplt = .true.
        npts = 0
        return
c
c       **************************
c       get fresh plotting surface
c       **************************
c
200     continue
        if (.not. lnoplt) then
                call gdpsin('stroke showpage '//char(0))
                call gdpsdu
        endif
        npage = npage + 1
        write(np,'(i2)') npage
        call gdpsin('%%Page: '//np//char(0))
        call gdpsdu
        call gdpsin('newpath '//char(0))
        call gdpsdu
c set the foreground to black for QMS ColorScript 100
c the Cyan-Magenta-Yellow color model used is equivalent to [1,1,1]-[R,G,B] 
c and is used because it is the preferred method for this
c printer (and most other color Postscript devices) 
        call gdpsin('0 0 0 1 setcmykcolor '//char(0))
        call gdpsdu()
        go to 190
c
c       ****
c       move
c       ****
c
300     continue
c
c       ****
c       draw
c       ****
c
400     continue
        npts = npts + 1
        if (npts .gt. maxpts) then
                call gdpsin('stroke newpath '//char(0))
                if (ifxn .eq. 4) then
                        call gdpsin(coord)
                        call gdpsin('m '//char(0))
                endif
                npts = 1
        endif
        if (lwide) then
                x = psrescm*ya(1)+xoff
                y = psrescm*(htcm-xa(1))+yoff
            else
                x = psrescm*xa(1)+xoff
                y = psrescm*ya(1)+yoff
        endif
        write(coord,451) x,y
c       encode (14,451,coord) x,y
451     format(f6.1,1x,f6.1,1x)
c       coord(15) = 0
        call gdpsin(coord)
        if (ifxn .eq. 3) then
                call gdpsin('m '//char(0))
            else
                call gdpsin('l '//char(0))
        endif
        lnoplt = .false.
        return
c
c       *****************************
c       flush graphics command buffer
c       *****************************
c
c               !done by bgnplt when necessary.
500     continue
        return
c
c       ******************
c       release the device
c       ******************
c
600     continue
        if (.not. lnoplt) then
                call gdpsin('stroke showpage '//char(0))
                call gdpsdu
        endif
        close (unit=lun)

        return
c
c       *****************************
c       return device characteristics
c       *****************************
c
700     continue
        do 720 i=1,8
        xa(i) = dchar(i)
720     continue
        if (lwide) then
                xa(2) = dchar(3)
                xa(3) = dchar(2)
        endif
        return
c
c       color stuff
c
800     continue
        icolor =  int ( xa(1) )
        call gdpsdu()
        call gdpsin('stroke '//char(0))
        call gdpsdu()
        if ( icolor .eq. 1 ) then
           call gdpsin('0 0 0 1 setcmykcolor '//char(0))
        elseif(icolor .eq. 2 ) then
           call gdpsin('0 1 1 0 setcmykcolor '//char(0))
        elseif(icolor .eq. 3 ) then
           call gdpsin('1 0 1 0 setcmykcolor '//char(0))
        elseif(icolor .eq. 4 ) then
           call gdpsin('1 1 0 0 setcmykcolor '//char(0))
        elseif(icolor .eq. 5 ) then
           call gdpsin('0 0 1 0 setcmykcolor '//char(0))
        elseif(icolor .eq. 6 ) then
           call gdpsin('0 1 0 0 setcmykcolor '//char(0))
        elseif(icolor .eq. 7 ) then
           call gdpsin('1 0 0 0 setcmykcolor '//char(0))
        endif
        call gdpsdu()
c
c       handle file open error
c
9000    continue
        ya(1) = 3.0
        return

c  
c draw filled polygon
c
20000   continue
        nverts = ifxn - 1024
        if (lwide) then
                x = psrescm*ya(1)+xoff
                y = psrescm*(htcm-xa(1))+yoff
            else
                x = psrescm*xa(1)+xoff
                y = psrescm*ya(1)+yoff
        endif
        write(coord,451)x,y
        call gdpsin(coord)
        call gdpsin('m '//char(0))
        do 20010 i=2, nverts 
        if (lwide) then
                x = psrescm*ya(i)+xoff
                y = psrescm*(htcm-xa(i))+yoff
            else
                x = psrescm*xa(i)+xoff
                y = psrescm*ya(i)+yoff
        endif
           write(coord,451)x,y
           call gdpsin(coord)
           call gdpsin('l '//char(0))
20010   continue
        call gdpsin('closepath fill '//char(0))
        return
        

c
c       ***********************************************************
c
        entry gdpswc(ifxn,xa,ya)
        lwide = .true.
        go to 10
        end
