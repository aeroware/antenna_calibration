      subroutine gsfill(x,y,n,tx,ty)
      dimension x(n),y(n), tx(n),ty(n)
c     
c     diglib polygon fill support
c     derived from "hatch" algorithm by kelly booth
c     
      include 'gcdchr.prm'
      include 'gcdprm.prm'
      include 'gcltyp.prm'
c     
      dimension xins(40)
      integer gsivis
      logical left
      data fact /16.0/
c     
c     *****
c     define arithmetic statement function to mapping vertices
      ymap(yyy) = 2.0*aint(yscale*yyy+0.5)+1.0
c     *****
c     
      if (n .lt. 3) return
c     
c     
c     convert to absolute coord.
c     
      do 10 i=1,n
         call gsrst(x(i),y(i),tx(i),ty(i))
 10   continue
      call minmax(ty,n,ymin,ymax)
      call minmax(tx,n,xmin,xmax)
c     
c     if clipping needed or if no hardware polygon fill, use software
c     
      if ((gsivis(xmin,ymin) .ne. 0) .or.
     1     (gsivis(xmax,ymax) .ne. 0) .or.
     2     (iand(idvbts,256) .eq. 0)) go to 200
c     
c     if can handle concave polygons, just call driver
c     
      if ((iand(idvbts,512) .eq. 0) .or.
     1     (n .eq. 3)) go to 150
c     
c     if here, driver can handle convex non-intersecting polygons only,
c     so make sure this polygon is convex and non-self-intersecting.
c     
      dx1 = x(1)-x(n)
      dy1 = y(1)-y(n)
      dy = dy1
      nchngs = 0
      l = 1
      costh = 0.0
 110  continue
c     
c     convexity test
c     
      dx2 = x(l+1)-x(l)
      dy2 = y(l+1)-y(l)
      a = dx1*dy2-dx2*dy1
      if (a*costh .lt. 0.0) go to 200
      if (costh .eq. 0.0) costh = a
c     
c     self intersection check - relys on "convexity" check
c     
      if (dy .ne. 0.0) go to 120
      dy = dy2
      go to 130
 120  continue
      if (dy2*dy .ge. 0.0) go to 130
      dy = dy2
      nchngs = nchngs + 1
      if (nchngs .ge. 3) go to 200
 130  continue
      dx1 = dx2
      dy1 = dy2
      l = l + 1
      if (l .lt. n) go to 110
 150  continue
      call gsdrvr(1024+n,tx,ty)
      return
c     
c     **********
c     software fill
c     **********
c     
 200  continue
c     
c     filling a polygon is very simple if and only if the vertices of
c     the polygon never lie on a scan line.   we can force this to happen
c     by the following trick: make all vertices lie just barely above
c     the scan line they should lie on.   this is done by mapping the
c     vertices to a grid that is "fact" times the device resolution,
c     and then doubling the grid density, and offsetting the vertices
c     by 1.   because we do this, we must outline the polygon.
c     
c     *******
c     
c     fill with solid lines
c     
      linold = ilntyp
      ilntyp = 1
c     
      left = .true.
      yscale = ys*yres*fact
      dlines = 2.0*fact
      call minmax(y,n,ymin,ymax)
      ymin = aint(ymap(ymin)/dlines)*dlines+dlines
      ymax = aint(ymap(ymax)/dlines)*dlines
      yscan = ymin
 210  continue
      inisec = 0
      ifirst = 0
c     
c     do each side of the polygon. put any x intersections
c     with the scan line y=yscan in xins
c     
      ybegin = ymap(y(n))
      xbegin = x(n)
      do 400 l = 1, n
         yend = ymap(y(l))
         dy = yscan-ybegin
         if (dy*(yscan-yend) .gt. 0.0) go to 390
c     
c     insert an intersection
c     
         inisec = inisec + 1
         xins(inisec) = dy*(x(l)-xbegin)/(yend-ybegin)+xbegin
c     
 390     continue
         ybegin = yend
         xbegin = x(l)
 400  continue
c     
c     fill if there were any intersections
c     
      if (inisec .eq. 0) goto 500
c     
c     first we must sort on x intersection.
c     use bubble sort because usually only 2.
c     when "left" is true, ascending sort, false is descending sort.
c     
      do 450 i =  1, inisec-1
         xkey = xins(i)
         do 430 j = i+1, inisec
            if (.not. left) goto 420
            if (xkey .ge. xins(j)) go to 430
 410        continue
            temp = xkey
            xkey = xins(j)
            xins(j) = temp
            go to 430
 420        if (xkey .gt. xins(j)) goto 410
 430     continue
         xins(i) = xkey
 450  continue
c     
c     draw fill lines now
c     
      yy = yscan/(2.0*yscale)
      do 460 i = 1, inisec, 2
         call gsmove(xins(i),yy)
         call gsdraw(xins(i+1),yy)
 460  continue
 500  continue
      yscan = yscan + dlines*nfline
      left = .not. left
      if (yscan .le. ymax) go to 210
c     
c     finally, outline the polygon
c     
      call gsmove(x(n),y(n))
      do 510 l=1,n
         call gsdraw(x(l),y(l))
 510  continue
c     
c     restore line type
c     
      ilntyp = linold
      return
      end
