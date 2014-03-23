      subroutine mapsml(xlow,xhigh,ylow,yhigh,xlab,ylab,title,iaxes)
c     
c     cut down version of mapit for those users who only need mapit to do
c     simple things.
c     
c     the following options have been commented out:
c     
c     option		comment chars		added line cmnt chars
c     ------		-------------		---------------------
c     grid lines		cc			!!
c     log axes		ccc			!!!
c     boxed plot		cccc			!!!!
c     
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     
      include 'pltcom.prm'
      include 'pltsiz.prm'
      include 'pltclp.prm'
      include 'pltprm.prm'
c     
      external len
      character*1 xlab(2), ylab(2), title(2)
      character*1 numbr(14)
ccc   logical*1 logxx, logyy
      logical lrmtex, lshort, lraggd
ccc   logical*1 logt
ccc   dimension zlog(8)
c     
ccc   data zlog /0.3010, 0.4771, 0.6021, 0.6990, 0.7782, 0.8451,
ccc   1   0.9031, 0.9542 /
ccc   data tminld /0.1/	!minimum distance between short ticks (1 mm)
ccc   data shortf /2.0/	!short ticks = tickln/shortf
c     
      yvlen = yvini
c     
c     
c     set logx and logy to false for our usage of scale
c     
      logx = .false.
      logy = .false.
c     
c     see what type of axes are desired
c     
ccc   logxx = iand(iaxes,1) .ne. 0
ccc   logyy = iand(iaxes,2) .ne. 0
      lraggd = iand(iaxes,256) .ne. 0
c     
c     do the axes scaling
c     
      numtk = min0(10,int(xvlen/((ilabsz()+1.0)*cxsize)))
ccc   if (logxx) go to 20
      lshort = iand(iaxes,16) .ne. 0
      call axis(xlow,xhigh,numtk,lshort,lraggd,xmin,xmax,xtmin,xtmax,
     1     xtick,ixpwr)
ccc   go to 40
ccc20 call laxis(xlow,xhigh,numtk,xmin,xmax,xtick)
ccc   xtmin = xmin
ccc   xtmax = xmax
ccc   ixpwr = 0
ccc40 continue
      numtk = min0(10,int(yvlen/(3.0*cysize)))
ccc   if (logyy) go to 60
      lshort = iand(iaxes,32) .ne. 0
      call axis(ylow,yhigh,numtk,lshort,lraggd,ymin,ymax,ytmin,ytmax,
     1     ytick,iypwr)
ccc   go to 80
ccc60 call laxis(ylow,yhigh,numtk,ymin,ymax,ytick)
ccc   ytmin = ymin
ccc   ytmax = ymax
ccc   iypwr = 0
ccc80 continue
c     
c     set up temporary scaling factors
c     
      ux0 = xmin
      udx = xmax - xmin
      uy0 = ymin
      udy = ymax - ymin
c     
c     ********** draw y axes **********
c     
      call gssetc(cysize,0.0)
ccc   logt = .false.
ccc   if (.not. logyy .or. ytick .ne. 1.0) go to 90
ccc   call scale(xmin,ymin,vx,temp)
ccc   call scale(xmin,ymin+1.0-zlog(8),vx,vy)
ccc   if ((vy-temp) .ge. tminld) logt = .true.
ccc90 continue
c     
c     draw y axis line
c     
      mxlab = 3
      tenexp = 10.0**iypwr
      x = xmin
      ticksp = amax1(0.0,tickln)
cccc  if (iand(iaxes,64) .ne. 0) yvlen = yvlen - ticksp
      tcksgn = -tickln
 100  continue
      call scale(x,ymax,vx,vy)
      call gsmove(vx,vy)
      call scale(x,ymin,vx,vy)
      call gsdraw(vx,vy)
c     
c     draw and label y axis ticks
c     
      y = ytmin
      n = (ytmax-ytmin)/ytick + 1.1
 110  continue
      call scale(x,y*tenexp,vx,vy)
      call gsmove(vx,vy)
      call gsdraw(vx+tcksgn,vy)
cccc  if (x .eq. xmax) go to 185
      if (iand(iaxes,1024) .ne. 0) go to 183
c     
c     place the appropiate label
c     
ccc   if (logyy) go to 160
      call linlab(int(y),iypwr,numbr,lrmtex)
ccc   go to 180
ccc160call loglab(int(y),numbr)
 180  ln = len(numbr)
      mxlab = max0(mxlab,ln)
      call gsmove(vx-ticksp-cxsize*(ln+0.25),vy-cysize/2.0)
      call gspstr(numbr)
c     
c     add grid line at tick if desired
c     
 183  continue
cc    if (iand(iaxes,8) .eq. 0) go to 185
cc    call gsltyp(3)
cc    call gsmove(vx,vy)
cc    call scale(xmax,y*tenexp,vx,vy)
cc    call gsdraw(vx,vy)
cc    call gsltyp(1)
 185  continue
c     
c     do extra ticking if extra ticks will be far enough apart
c     
ccc   if ((.not. logt) .or. (y .eq. ytmax)) go to 200
ccc   do 190 j = 1, 8
ccc   call scale(x,y+zlog(j),vx,vy)
ccc   call gsmove(vx,vy)
ccc190call gsdraw(vx+tcksgn/shortf,vy)
 200  continue
      y = y + ytick
      n = n-1
      if (n .gt. 0) go to 110
cccc  if (x .eq. xmax) go to 300
c     
c     if linear axis, place remote exponent if needed
c     
ccc   if (logyy .or. (.not. lrmtex)) go to 260
      if (.not. lrmtex) go to 260
      if (iand(iaxes,1024) .ne. 0) go to 260
      call scale(xmin,(ytmin+ytick/2.0)*tenexp,vx,vy)
      call scopy('E'//char(0),numbr)
      call numstr(iypwr,numbr(2))
      call gsmove(vx-cxsize*(len(numbr)+0.5),vy-cysize/2.0)
      call gspstr(numbr)
c     
c     now place y lable
c     
 260  call scale(xmin,(ymin+ymax)/2.0,vx,vy)
      call gsmove(vx-(mxlab+0.25)*cxsize-ticksp-cysize,
     1     vy-cxsize*len(ylab)/2.0)
      call gssetc(cysize,90.0)
      call gspstr(ylab)
      call gssetc(cysize,0.0)
cccc  if (iand(iaxes,128) .eq. 0) go to 300
cccc  x = xmax
cccc  tcksgn = tickln
cccc  go to 100
 300  continue
c     
c     ********** draw x axis **********
c     
ccc   logt = .false.
ccc   if (.not. logxx .or. xtick .ne. 1.0) go to 310
ccc   call scale(xmin,ymin,temp,vy)
ccc   call scale(xmin+1.0-zlog(8),ymin,vx,vy)
ccc   if ((vx-temp) .ge. tminld) logt = .true.
ccc310continue
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
cccc  if (y .eq. ymax) go to 430
      if (iand(iaxes,512) .ne. 0) go to 423
ccc   if (logxx) go to 410
      call linlab(int(x),ixpwr,numbr,lrmtex)
ccc   go to 420
ccc410call loglab(int(x),numbr)
 420  call gsmove(vx-cxsize*len(numbr)/2.0,vy-ticksp-1.5*cysize)
      call gspstr(numbr)
c     
c     add grid line at tick if desired
c     
 423  continue
cc    if (iand(iaxes,4) .eq. 0) go to 430
cc    call gsltyp(3)
cc    call gsmove(vx,vy)
cc    call scale(x*tenexp,ymax,vx,vy)
cc    call gsdraw(vx,vy)
cc    call gsltyp(1)
cc430 continue
c     
c     do extra ticking if extra ticks will be far enough apart
c     
ccc   if ((.not. logt) .or. (x .eq. xtmax)) go to 490
ccc   do 450 j = 1, 8
ccc   call scale(x+zlog(j),y,vx,vy)
ccc   call gsmove(vx,vy)
ccc   call gsdraw(vx,vy+tcksgn/shortf)
ccc450continue
ccc490continue
      x = x + xtick
      n = n-1
      if (n .gt. 0) go to 400
cccc  if (y .eq. ymax) go to 590
c     
c     now place remote exponent if needed on linear axis
c     
ccc   if (logxx .or. (.not. lrmtex)) go to 520
      if (.not. lrmtex) go to 520
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
      call gsmove(vx-cxsize*len(xlab)/2.0,vy-ticksp-4.0*cysize)
      call gspstr(xlab)
cccc  if (iand(iaxes,64) .eq. 0) go to 590
cccc  y = ymax
cccc  tcksgn = tickln
cccc  go to 320
cccc590continue
c     
c     ********** place title **********
c     
      call scale((xmin+xmax)/2.0,ymax,vx,vy)
      tcksgn = 0.0
cccc  if (iand(iaxes,64) .ne. 0) tcksgn = ticksp
      call gsmove(vx-cxsize*len(title)/2.0,vy+tcksgn+cysize)
      call gspstr(title)
c     
c     make sure "pltclp" contains limits picked by mapit.   only maintained
c     for callers info.
c     
ccc   if (.not. logxx) go to 610
ccc   xmin = 10.0**xmin
ccc   xmax = 10.0**xmax
ccc610continue
ccc   if (.not. logyy) go to 620
ccc   ymin = 10.0**ymin
ccc   ymax = 10.0**ymax
ccc620continue
c     
c     tell scale about log axis scaling now
c     
ccc   logx = logxx
ccc   logy = logyy
      return
      end
