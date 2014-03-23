      subroutine syaxis(ylow,yhigh,ylab,iaxes)
      include 'pltcom.prm'
      include 'pltsiz.prm'
      include 'pltclp.prm'
      include 'pltprm.prm'
c     
      external len
      character*1 ylab(2)
      character*1 numbr(14)
      logical logyy, logt, lrmtex, lshort, lraggd
      dimension zlog(8)
c     
      data zlog /0.3010, 0.4771, 0.6021, 0.6990, 0.7782, 0.8451,
     1     0.9031, 0.9542 /
c     !minimum distance between short ticks (1 mm)
      data tminld /0.1/
c     !short ticks = tickln/shortf
      data shortf /2.0/
c     
      yvlen = yvini
c     
c     
c     set logy to false for our usage of scale
c     
      logy = .false.
c     
c     see what type of axis is desired
c     
      logyy = iand(iaxes,2) .ne. 0
      lraggd = iand(iaxes,256) .ne. 0
c     
c     do the axes scaling
c     
      numtk = min0(10,int(yvlen/(3.0*cysize)))
      if (logyy) go to 60
      lshort = iand(iaxes,32) .ne. 0
      call axis(ylow,yhigh,numtk,lshort,lraggd,ymin,ymax,ytmin,ytmax,
     1     ytick,iypwr)
      go to 80
 60   call laxis(ylow,yhigh,numtk,ymin,ymax,ytick)
      ytmin = ymin
      ytmax = ymax
      iypwr = 0
 80   continue
c     
c     set up temporary scaling factors
c     
      uy0 = ymin
      udy = ymax - ymin
c     
c     ********** draw y axes **********
c     
      call gssetc(cysize,0.0)
      logt = .false.
      if (.not. logyy .or. ytick .ne. 1.0) go to 90
      call scale(xmin,ymin,vx,temp)
      call scale(xmin,ymin+1.0-zlog(8),vx,vy)
      if ((vy-temp) .ge. tminld) logt = .true.
 90   continue
c     
c     draw y axis line
c     
      mxlab = 3
      tenexp = 10.0**iypwr
      x = xmax
      ticksp = amax1(0.0,tickln)
      if (iand(iaxes,64) .ne. 0) yvlen = yvlen - ticksp
      tcksgn = -tickln
 100  continue
      call scale(x,ymax,vx,vy)
      call gsmove(vx,vy)
      call scale(x,ymin,vx,vy)
      call gsdraw(vx,vy)
c     
c     draw and label y axis ticks
c     
      delmx = 0.0
      y = ytmin
      n = (ytmax-ytmin)/ytick + 1.1
 110  continue
      call scale(x,y*tenexp,vx,vy)
      call gsmove(vx,vy)
      call gsdraw(vx+tickln,vy)
c     
c     place the appropiate label
c     
      if (iand(iaxes,1024) .ne. 0) go to 183
      if (logyy) go to 160
      call linlab(int(y),iypwr,numbr,lrmtex)
      go to 180
 160  call loglab(int(y),numbr)
 180  del = gslens(numbr)
      delmx = amax1(del,delmx)
      call gsmove(vx+ticksp+0.5*cxsize,vy-cysize/2.0)
      call gspstr(numbr)
 183  continue
c     
c     add grid line at tick if desired
c     
      if (iand(iaxes,8) .eq. 0) go to 185
      call gsltyp(3)
      call gsmove(vx,vy)
      call scale(xmin,y*tenexp,vx,vy)
      call gsdraw(vx,vy)
      call gsltyp(1)
 185  continue
c     
c     do extra ticking if extra ticks will be far enough apart
c     
      if ((.not. logt) .or. (y .eq. ytmax)) go to 200
      do 190 j = 1, 8
         call scale(x,y+zlog(j),vx,vy)
         call gsmove(vx,vy)
         call gsdraw(vx+tickln/shortf,vy)
 190  continue
 200  continue
      y = y + ytick
      n = n-1
      if (n .gt. 0) go to 110
c     
c     if linear axis, place remote exponent if needed
c     
      if (logyy .or. (.not. lrmtex)) go to 260
      if (iand(iaxes,1024) .ne. 0) go to 260
      call scale(xmax,(ytmin+ytick/2.0)*tenexp,vx,vy)
      call scopy('E'//char(0),numbr)
      call numstr(iypwr,numbr(2))
      call gsmove(vx+0.5*cxsize,vy-cysize/2.0)
      call gspstr(numbr)
c     
c     now place y lable
c     
 260  call scale(x,(ymin+ymax)/2.0,vx,vy)
      call gsmove(vx+0.5*cxsize+delmx+ticksp+1.5*cysize,
     1     vy-gslens(ylab)/2.0)
      call gssetc(cysize,90.0)
      call gspstr(ylab)
      call gssetc(cysize,0.0)
 300  continue
c     
c     tell user the scaling limits
c     
      if (.not. logyy) go to 320
      ymin = 10.0**ymin
      ymax = 10.0**ymax
 320  continue
c     
c     tell scale about log axis scaling now
c     
      logy = logyy
      return
      end
