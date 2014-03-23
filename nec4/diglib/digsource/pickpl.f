      subroutine pickpl(x,y,z,lev,npts,cl,nl,icolrs,drawpl)
      dimension x(4),y(4),z(4),lev(4),cl(nl),icolrs(nl+1)
      external drawpl
c     
c     this subroutine extracts the polygons of each level.
c     
      dimension xpoly(8),ypoly(8),zpoly(8)
      dimension xb(6), yb(6), zb(6)
      logical folded
c     
      lmin = lev(1)
      lmax = lmin
      do 20 i=2,npts
         if (lmin .gt. lev(i)) lmin = lev(i)
         if (lmax .lt. lev(i)) lmax = lev(i)
 20   continue
c     
c     see if we can do it simply, without any work!
c     
      if (lmin .eq. lmax) then
         call drawpl(x,y,z,npts,icolrs(lmin))
         return
      endif
c     
c     well, its gonna have to be the hard way, so pick out the polygons!
c     in increasing order of height
c     
ccccccccccccccccccccccccccccccccccccccccccccc
c     
c     start at corner at lowest level. if more than one, just pick
c     the first found.
c     
      jstart = 0
 40   continue
      jstart = jstart + 1
      if (lmin .lt. lev(jstart)) go to 40
c     
c     find the opposite corner and see if this is a folded rectangle
c     (i.e. one set of opposite corners is complete above or below the
c     other set of opposite corners) that will require special treatment,
c     i.e. the forward corner is lower in level that the backward corner.
c     
      if (npts .eq. 4) then
         joppos = nextf(nextf(jstart,4),4)
         levfld = min0(lev(nextf(jstart,4)),lev(nextb(jstart,4)))
         folded = max0(lev(jstart),lev(joppos)) .lt. levfld .and.
     $        lev(nextf(jstart,4)) .lt. lev(nextb(jstart,4))
      else
         folded = .false.
      endif
c     
c     do all levels
c     
      do 500 level = lmin, lmax
         if (folded .and. level .eq. levfld) then
            istart = joppos
         else
            istart = jstart
         endif
 100     continue
c     
c     get starting point going forward around tri/rectangle
c     
         irf = istart
         iforw = nextf(irf,npts)
         if (lev(irf) .eq. level) then
c     
c     corner "irf" (or "istart") is in the polygon
c     
            xpoly(1) = x(irf)
            ypoly(1) = y(irf)
            zpoly(1) = z(irf)
         else
c     
c     go forward around the tri/rectangle to find the first
c     point in the polygon
c     
 110        continue
            if (lev(iforw) .ge. level) go to 120
            irf = iforw
            iforw = nextf(irf,npts)
            go to 110
 120        continue
            call interp(x,y,z,irf,iforw,cl(level-1),
     $           xpoly(1),ypoly(1),zpoly(1))
         endif
         ip = 1
c     
c     include any points on tri/rectangle at same level while
c     going forward.
c     
 150     continue
         if (lev(iforw) .ne. level) go to 160
         ip = ip + 1
         xpoly(ip) = x(iforw)
         ypoly(ip) = y(iforw)
         zpoly(ip) = z(iforw)
         irf = iforw
         iforw = nextf(irf,npts)
         go to 150
 160     continue
c     
c     find forward end point on polygon going forward.
c     polygon must end between "irf" and "iforw"
c     
         if (lev(iforw) .gt. level) then
            c = cl(level)
         else
            c = cl(level-1)
         endif
         ip = ip + 1
         call interp(x,y,z,irf,iforw,c,xpoly(ip),ypoly(ip),zpoly(ip))
c     
c     now find beginning of backward points
c     
         irb = istart
         iback = nextb(irb,npts)
         if (lev(irb) .ne. level) then
c     
c     search backward for first point in polygon
c     
 210        continue
c     
c     see if forward sweep picked up entire polygon
c     
            if (iforw .eq. irb) then
               call drawpl(xpoly,ypoly,zpoly,ip,icolrs(level))
               go to 500
            endif
            if (lev(iback) .ge. level) go to 220
            irb = iback
            iback = nextb(irb,npts)
            go to 210
 220        continue
            call interp(x,y,z,irb,iback,cl(level-1),xb(1),yb(1),zb(1))
            ib = 1
         else
            ib = 0
         endif
c     
c     insert tri/rectangle points at same level
c     
 260     continue
         if (lev(iback) .ne. level) go to 270
         ib = ib + 1
         xb(ib) = x(iback)
         yb(ib) = y(iback)
         zb(ib) = z(iback)
         irb = iback
         iback = nextb(irb,npts)
         go to 260
 270     continue
c     
c     rectangles are hard, triangles easy. triangles can
c     be folded, so skip this check if triangle
c     
         if (npts .eq. 4) then
c     make sure backward end point is at transisition to
c     higher level or whole rectangle has been scanned,
c     else fancy stuff to pick out whole polygon
c     
            if (lev(iback) .lt. level .and. iback .ne. iforw) then
            ib = ib + 1
            call interp(x,y,z,irb,iback,cl(level-1),
     $           xb(ib),yb(ib),zb(ib))
c     
c     must be another after the next vertex, so
c     get it also
c     
            irb = iback
            iback = nextb(irb,4)
            ib = ib + 1
            call interp(x,y,z,irb,iback,cl(level-1),
     $           xb(ib),yb(ib),zb(ib))
         endif
      endif
c     
c     insert backward end point into polygon
c     
      if (lev(iback) .gt. level) then
         c = cl(level)
      else
         c = cl(level-1)
      endif
      ip = ip + 1
      call interp(x,y,z,irb,iback,c,xpoly(ip),ypoly(ip),zpoly(ip))
c     
c     add reversed list of backward points to polygon
c     
      do 290 i = ib, 1, -1
         ip = ip + 1
         xpoly(ip) = xb(i)
         ypoly(ip) = yb(i)
         zpoly(ip) = zb(i)
 290  continue
      call drawpl(xpoly,ypoly,zpoly,ip,icolrs(level))
c     
c     if a polygon exists on the corner opposite from "jstart"
c     then go back and do it.
c     
      if (npts .eq. 4 .and.
     $     iforw .ne. iback .and.
     $     istart .eq. jstart .and.
     $     lev(joppos) .le. level) then
      istart = joppos
      go to 100
      endif
 500  continue
      return
      end
      
      subroutine interp(x,y,z,ist,iend,c,xi,yi,zi)
      dimension x(4),y(4),z(4)
c     
      d = (c-z(ist))/(z(iend)-z(ist))
      xi = d*(x(iend)-x(ist)) + x(ist)
      yi = d*(y(iend)-y(ist)) + y(ist)
      zi = c
      return
      end
      
      function nextf(ipt,npts)
      if (ipt .eq. npts) then
         nextf = 1
      else
         nextf = ipt + 1
      endif
      return
      end
      
      function nextb(ipt,npts)
      if (ipt .eq. 1) then
         nextb = npts
      else
         nextb = ipt - 1
      endif
      return
      end
