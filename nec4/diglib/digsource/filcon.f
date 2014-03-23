      subroutine filcon(z,nz,mx,my,x1,xmx,y1,ymy,nl,cl,icolrs)
      dimension z(nz,my), cl(nl), icolrs(nl+1)
c     
c     this subroutine will produce a filled contour plot of the function
c     defined by z(i,j) = f(x(i),y(j)).   it is assumed that
c     a call to "mapit" has already been made to establish the
c     coordinate axis (x,y), with x limits covering the range
c     x1 to xmx, and y limits covering the range y1 to ymy.
c     values of z that are less than the constant "phony" are treated
c     as missing data and so aren't used. note: strange results will
c     be obtained when opposite grid point corners are both missing!
c     
c     
c arguments:
c     
c   input
c     
c     z		* type: real array.
c               * the values of the function to contour:
c                  z(i,j) = f(xi,yj) where:
c                  xi = x1 + (i-1)*(xmx-x1)/(mx-1)
c                  yj = y1 + (j-1)*(ymx-y1)/(my-1)
c     
c     nz        * type: integer constant or variable.
c               * the first dimension of the array z - not necessarily
c                  equal to mx, but mx <= nz.
c     
c     mx 	* type: integer constant or variable.
c               * the number of x grid points.
c     
c     my	* type: integer constant or variable.
c               * the number of y grid points.
c     
c     x1	* type: real constant or variable.
c               * the minimum x value.
c     
c     xmx	* type: real constant or variable.
c               * the maximum x value.
c     
c     y1	* type: real constant or variable.
c               * the minimum y value.
c     
c     ymy	* type: real constant or variable.
c               * the maximum y value.
c     
c     nl	* type: integer constant or variable.
c               * the number of contour levels.
c     
c     cl	* type: real array.
c               * the coutour levels to draw.   (same units as f() or z().)
c     
c     icolrs	* type: integer array.
c               * the colors of the fill areas:
c                  icolrs(1)    ==> area < cl(1)
c                  ...		     ...
c                  icolrs(nl+1) ==> area >= cl(nl)
c     
c   output
c     
c     none.
c     
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     
      external drwpl2
c     
      common /pickem/ ipplcl
c     
      dimension xvert(4), yvert(4), zvert(4), lvert(4)
c     
      data phony /-1.0e30/
c     
cccccccccccccccccccccccccccccc
c     
c     calc. some scaling constants needed
c     
      dx = (xmx-x1)/(mx-1)
      dy = (ymy-y1)/(my-1)
c     
c     move thru array a rectangle at a time extracting and plotting
c     the polygons in each rectangle.
c     the following point labeling scheme is used through-out!
c     
c               2 ----- 3
c             ^	!	!
c             !	!	!
c             j	!	!
c               1 -----	4
c               i-->
c     
      do 400 i=1,mx-1
         do 300 j=1,my-1
            npts = 0
            if (z(i,j) .gt. phony) then
               npts = 1
               xvert(1) = x1 + (i-1)*dx
               yvert(1) = y1 + (j-1)*dy
               zvert(1) = z(i,j)
               lvert(1) = levelc(zvert(1),cl,nl)
            endif
            if (z(i,j+1) .gt. phony) then
               npts = npts + 1
               xvert(npts) = x1 + (i-1)*dx
               yvert(npts) = y1 + j*dy
               zvert(npts) = z(i,j+1)
               lvert(npts) = levelc(zvert(npts),cl,nl)
            endif
            if (npts .eq. 0) go to 300
            if (z(i+1,j+1) .gt. phony) then
               npts = npts + 1
               xvert(npts) = x1 + i*dx
               yvert(npts) = y1 + j*dy
               zvert(npts) = z(i+1,j+1)
               lvert(npts) = levelc(zvert(npts),cl,nl)
            endif
            if (z(i+1,j) .gt. phony) then
               npts = npts + 1
               xvert(npts) = x1 + i*dx
               yvert(npts) = y1 + (j-1)*dy
               zvert(npts) = z(i+1,j)
               lvert(npts) = levelc(zvert(npts),cl,nl)
            endif
            if (npts .ge. 3) then
               call pickpl(xvert,yvert,zvert,lvert,
     $              npts,cl,nl,icolrs,drwpl2)
            endif
 300     continue
 400  continue
      call endplt
      return
      end
      
      subroutine drwpl2(x,y,z,npts,icolor)
      dimension x(npts),y(npts),z(npts)
c     
      common /pickem/ ipplcl
c     
      dimension vx(8),vy(8),tx(8),ty(8)
c     
      if (npts .lt. 3) then
         print *, 'Too few points to drawpl: ',npts
      endif
      if (icolor .ne. ipplcl) then
         ipplcl = icolor
         call gscolr(ipplcl,ierr)
      endif
      do 100 i=1,npts
         call scale(x(i),y(i),vx(i),vy(i))
 100  continue
      call gsfill(vx,vy,npts,tx,ty)
      return
      end
