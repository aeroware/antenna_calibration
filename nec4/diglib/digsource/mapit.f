      subroutine mapit(xlow,xhigh,ylow,yhigh,xlab,ylab,title,iaxes)
      include 'pltcom.prm'
      include 'pltsiz.prm'
      include 'pltclp.prm'
      include 'pltprm.prm'
      include 'gcltyp.prm'
c     
      external len
      character*1 xlab(2), ylab(2), title(2)
      character*1 numbr(14)
      logical logxx, logyy, logt, lrmtex, lshort, lraggd
      dimension zlog(8)
c     
      data zlog /0.3010, 0.4771, 0.6021, 0.6990, 0.7782, 0.8451,
     1           0.9031, 0.9542 /
      data tminld /0.1/
      data shortf /2.0/
c     
c     use solid lines here, but save callers line type
c     
      ioldl = ilntyp
      call gsltyp(1)
c     
      yvlen = yvini
c     
c     set logx and logy to false for our usage of scale
c     
      logx = .false.
      logy = .false.
c     
c     see what type of axes are desired
c     
      logxx = iand(iaxes,1) .ne. 0
      logyy = iand(iaxes,2) .ne. 0
      lraggd = iand(iaxes,256) .ne. 0
c     
c     do the axes scaling
c     
      numtk = min0(10,int(xvlen/((ilabsz()+1.0)*cxsize)))
      if (logxx) go to 20
      lshort = iand(iaxes,16) .ne. 0
      call axis(xlow,xhigh,numtk,lshort,lraggd,xmin,xmax,xtmin,xtmax,
     1    xtick,ixpwr)
      go to 40
 20   call laxis(xlow,xhigh,numtk,xmin,xmax,xtick)
      xtmin = xmin
      xtmax = xmax
      ixpwr = 0
 40   numtk = min0(10,int(yvlen/(3.0*cysize)))
      if (logyy) go to 60
      lshort = iand(iaxes,32) .ne. 0
      call axis(ylow,yhigh,numtk,lshort,lraggd,ymin,ymax,ytmin,ytmax,
     1    ytick,iypwr)
      go to 80
 60   call laxis(ylow,yhigh,numtk,ymin,ymax,ytick)
      ytmin = ymin
      ytmax = ymax
      iypwr = 0
 80   continue
c     
c     set up scaling factors for scale
c     
      ux0 = xmin
      udx = xmax - xmin
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
      x = xmin
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
      call gsdraw(vx+tcksgn,vy)
      if (x .eq. xmax) go to 185
      if (iand(iaxes,1024) .ne. 0) go to 183
c     
c     place the appropiate label
c     
      if (logyy) go to 160
      call linlab(int(y),iypwr,numbr,lrmtex)
      go to 180
 160  call loglab(int(y),numbr)
 180  del = gslens(numbr) + cxsize*0.25
      delmx = amax1(del,delmx)
      call gsmove(vx-ticksp-del,vy-cysize/2.0)
      call gspstr(numbr)
c     
c     add grid line at tick if desired
c     
 183  continue
      if (iand(iaxes,8) .eq. 0) go to 185
      call gsltyp(3)
      call gsmove(vx,vy)
      call scale(xmax,y*tenexp,vx,vy)
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
         call gsdraw(vx+tcksgn/shortf,vy)
 190  continue
 200  continue
      y = y + ytick
      n = n-1
      if (n .gt. 0) go to 110
      if (x .eq. xmax) go to 300
c     
c     if linear axis, place remote exponent if needed
c     
      if (logyy .or. (.not. lrmtex)) go to 260
      if (iand(iaxes,1024) .ne. 0) go to 260
      call scale(xmin,(ytmin+ytick/2.0)*tenexp,vx,vy)
      call scopy('E'//char(0),numbr)
      call numstr(iypwr,numbr(2))
      call gsmove(vx-(0.5*cxsize+gslens(numbr)),vy-cysize/2.0)
      call gspstr(numbr)
c     
c     now place y lable
c     
 260  call scale(xmin,(ymin+ymax)/2.0,vx,vy)
      call gsmove(vx-delmx-ticksp-cysize,vy-gslens(ylab)/2.0)
      call gssetc(cysize,90.0)
      call gspstr(ylab)
      call gssetc(cysize,0.0)
      if (iand(iaxes,128) .eq. 0) go to 300
      x = xmax
      tcksgn = tickln
      go to 100
 300  continue
c     
c     ********** draw x axis **********
c     
      logt = .false.
      if (.not. logxx .or. xtick .ne. 1.0) go to 310
      call scale(xmin,ymin,temp,vy)
      call scale(xmin+1.0-zlog(8),ymin,vx,vy)
      if ((vx-temp) .ge. tminld) logt = .true.
 310  continue
c     
c     draw x axis line
c     
      y = ymin
      tcksgn = -tickln
      tenexp = 10.0**ixpwr
      ticksp = amax1(0.5*cysize,tickln)
 320  continue
      call scale(xmin,y,vx,vy)
      call gsmove(vx,vy)
      call scale(xmax,y,vx,vy)
      call gsdraw(vx,vy)
c     
c     draw and label x axis ticks
c     
      x = xtmin
      n = (xtmax-xtmin)/xtick + 1.1
 400  continue
      call scale(x*tenexp,y,vx,vy)
      call gsmove(vx,vy)
      call gsdraw(vx,vy+tcksgn)
      if (y .eq. ymax) go to 430
      if (iand(iaxes,512) .ne. 0) go to 423
      if (logxx) go to 410
      call linlab(int(x),ixpwr,numbr,lrmtex)
      go to 420
 410  call loglab(int(x),numbr)
 420  call gsmove(vx-gslens(numbr)/2.0,vy-ticksp-1.5*cysize)
      call gspstr(numbr)
c     
c     add grid line at tick if desired
c     
 423  continue
      if (iand(iaxes,4) .eq. 0) go to 430
      call gsltyp(3)
      call gsmove(vx,vy)
      call scale(x*tenexp,ymax,vx,vy)
      call gsdraw(vx,vy)
      call gsltyp(1)
 430  continue
c     
c     do extra ticking if extra ticks will be far enough apart
c     
      if ((.not. logt) .or. (x .eq. xtmax)) go to 490
      do 450 j = 1, 8
         call scale(x+zlog(j),y,vx,vy)
         call gsmove(vx,vy)
         call gsdraw(vx,vy+tcksgn/shortf)
 450  continue
 490  continue
      x = x + xtick
      n = n-1
      if (n .gt. 0) go to 400
      if (y .eq. ymax) go to 590
c     
c     now place remote exponent if needed on linear axis
c     
      if (logxx .or. (.not. lrmtex)) go to 520
      if (iand(iaxes,512) .ne. 0) go to 520
      call scale(xmin,ymin,vx,vy)
      call scopy('E'//char(0),numbr)
      call numstr(ixpwr,numbr(2))
      call gsmove(vx+3*cxsize,vy-ticksp-2.75*cysize)
      call gspstr(numbr)
c     
c     now place x axis lable
c     
 520  call scale((xmin+xmax)/2.0,ymin,vx,vy)
      call gsmove(vx-gslens(xlab)/2.0,vy-ticksp-4.0*cysize)
      call gspstr(xlab)
      if (iand(iaxes,64) .eq. 0) go to 590
      y = ymax
      tcksgn = tickln
      go to 320
 590  continue
c     
c     ********** place title **********
c     
      call scale((xmin+xmax)/2.0,ymax,vx,vy)
      tcksgn = 0.0
      if (iand(iaxes,64) .ne. 0) tcksgn = ticksp
      call gsmove(vx-gslens(title)/2.0,vy+tcksgn+cysize)
      call gspstr(title)
c     
c     make sure "pltclp" contains limits picked by mapit.   only maintained
c     for callers info.
c     
      if (.not. logxx) go to 610
      xmin = 10.0**xmin
      xmax = 10.0**xmax
      logx = .true.
 610  continue
      if (.not. logyy) go to 620
      ymin = 10.0**ymin
      ymax = 10.0**ymax
      logy = .true.
 620  continue
c     
c     restore caller's line type
c     
      call gsltyp(ioldl)
      return
      end
