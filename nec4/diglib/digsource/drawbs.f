      subroutine drawbs(z,izdim1,llable,xylim,xlab,ylab,zlab)
      dimension z(izdim1,2)
      logical llable
      dimension xylim(2,6)
      character*1 xlab(2),ylab(2),zlab(2)
c     
      include 'comdp.inc'
      include 'dbase.inc'
c     
c     
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     
c     if camera is below surface, forget it
c     
      if (camwkg(3) .lt. camwkg(6)) return
      call gssetc(cysize,0.0)
      cxsize = gslens('0'//char(0))
      call xyprm(frx,bky,zmax,0)
      voldx=vx
      voldy=vy
      vxt=vx
      vyt=vy
      call xyprm(frx,bky-dy,zmax,1)
      if (llable) call tickl(zmax,-0.5)
      call gsmove(vxt,vyt)
      call xyprm(frx,bky,zmin,1)
      voldx=vx
      voldy=vy
      call xyprm(frx,bky-dy,zmin,1)
      if (llable) then
         call tickl(zmin,0.25)
         temp = amax1(voldx,vxt)+1.5*cysize
         if (vx .lt. voldx) temp = amin1(voldx,vxt)-0.5*cysize
         call gsmove(temp,(voldy+vyt-gslens(zlab))/2.0)
         call gssetc(cysize,90.0)
         call gspstr(zlab)
         call gssetc(cysize,0.0)
      endif
      call gsmove(voldx,voldy)
      call xyprm(frx+dx,bky,zmin,1)
      if (llable) call tickl(xylim(1+jb/ny,2),-0.5)
      call gsmove(voldx,voldy)
      call xyprm(frx,fry+dy,zmin,1)
      if (llable) then
         call tickl(xylim(1+if/mx,1),-0.5)
         temp = gslens(ylab)+0.25*cxsize
         if (vx .lt. voldx) temp = -0.5*cxsize
         call gsmove((vx+voldx)/2.0-temp,(vy+voldy)/2.0-cysize)
         call gspstr(ylab)
      endif
      call xyprm(frx,fry,z(if,jf),-1)
      call gsmove(vx,vy)
      call xyprm(frx,fry,zmin,1)
      voldx=vx
      voldy=vy
      call xyprm(frx+dx,fry,zmin,1)
      if (llable) call tickl(xylim(1+jf/ny,2),-0.5)
      call gsmove(voldx,voldy)
      call xyprm(bkx,fry,zmin,1)
      if (llable) then
         temp = gslens(xlab)+0.25*cxsize
         if (vx .gt. voldx) temp = -0.5*cxsize
         call gsmove((vx+voldx)/2.0-temp,(vy+voldy)/2.0-cysize)
         call gspstr(xlab)
      endif
      voldx=vx
      voldy=vy
      call gsmove(vx,vy)
      call xyprm(bkx,fry+dy,zmin,1)
      if (llable) call tickl(xylim(1+ib/mx,1),-0.5)
      call gsmove(voldx,voldy)
      call xyprm(bkx,fry,z(ib,jf),1)
      return 
      end 
