      subroutine hatch(xvert, yvert, numpts, phi, cmspac, iflags,
     1     xx, yy)
      dimension xvert(numpts), yvert(numpts), xx(numpts), yy(numpts)
c     
c     ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c     
c     h a t c h
c     by Kelly Booth and modified for diglib by Hal Brand
c     
c     provide shading for a general polygonal region.  there is absolutely no
c     assumption made about convexity.  a polygon is specified by its vertices,
c     given in either a clockwise or counter-clockwise order.  the density of
c     the shading lines (or points) and the angle for the shading lines are
c     both determined by the parameters passed to the subroutine.
c     
c     the input parameters are interpreted as follows:
c     
c     xvert    -  an array of x coordinates for the polygon(s) vertices
c     
c     yvert    -  an array of y coordinates for the polygon(s) vertices
c     
c     note: an x value >=1e38 signals a new polygon.   this allows
c     filling areas that have holes where the holes are
c     defined as polygons.   it also allows multiple
c     polygons to be filled in one call to hatch.
c     
c     numpts  -  the number of vertices in the polygon(s) including
c     the seperator(s) if any.
c     
c     phi      -  the angle for the shading, measured counter-clockwise
c     in degrees from the positive x-axis
c     
c     cmspac	  -  the distance in virtual coordinates (cm. usually)
c     between shading lines.   this value may be rounded
c     a bit, so some cummulative error may be apparent.
c     a value of 0.0 will cause solid filling.
c     
c     iflags   -  general flags controlling hatch
c     0 ==>  boundary not drawn, input is virtual coord.
c     1 ==>  boundary drawn, input is virtual coord.
c     2 ==>  boundary not drawn, input is world coord.
c     3 ==>  boundary drawn, input is world coord.
c     
c     xx	  -  a work array atleast "numpts" long.
c     
c     yy	  -  a second work array atleast "numpts" long.
c     
c     ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c     
      include 'gcdchr.prm'
      include 'gcdprm.prm'
c     
c     this subroutine has to maintain an internal array of the transformed
c     coordinates.  this requires the passing of the two working arrays
c     called "xx" and "yy".
c     this subroutine also needs to store the intersections of the hatch
c     lines with the polygon.   this is done in "xintcp".
c     
      real xintcp(20)
      logical lmove
      data idimx /20/
c     
c     x >= "bignum" signals the end of a polygon in the input.
c     
      data bignum /1e30/
      data fact /16.0/
      data pi180 /0.017453292/
c     
c------------------------------------------------------------------------
c     
c     check for valid number of vertices.
c     
      if (numpts .lt. 3) return
c     
c     convert all of the points to integer coordinates so that the shading
c     lines are horizontal.  this requires a rotation for the general case.
c     the transformation from virtual to internal coordinates has the two
c     or three phases:
c     
c     (1)  convert world to virtual coord. if input in world coord.
c     
c     (2)  rotate clockwise through the angle phi so shading is horizontal,
c     
c     (3)  scale to integers in the range
c     [0...2*fact*(device_maxy_coordinate)], forcing coordinates
c     to be odd integers.
c     
c     the coordinates are all odd so that later tests will never have an
c     outcome of "equal" since all shading lines have even coordinates.
c     this greatly simplifies some of the logic.
c     
c     at the same time the pre-processing is being done, the input is checked
c     for multiple polygons.  if the x-coordinate of a vertex is >= "bignum"
c     then the point is not a vertex, but rather it signifies the end of a
c     particular polygon.  an implied edge exists between the first and last
c     vertices in each polygon.  a polygon must have at least three vertices.
c     illegal polygons are removed from the internal lists.
c     
c     
c     compute trigonometric functions for the angle of rotation.
c     
      cosphi = cos(pi180*phi)
      sinphi = sin(pi180*phi)
c     
c     first convert from world to virtual coord. if necessary and eliminate
c     any polygons with two or fewer vertices
c     
      itail = 1
      ihead = 0
      do 120 i = 1, numpts
c     
c     allocate another point in the vertex list.
c     
         ihead = ihead + 1
c     
c     a xvert >= "bignum" is a special flag.
c     
         if (xvert(i) .lt. bignum) go to 110
         xx(ihead) = bignum
         if ((ihead-itail) .lt. 2) ihead = itail - 1
         itail = ihead + 1
         go to 120
 110     continue
c     
c     convert from world to virtual coord. if input is world coord.
c     
         if (iand(iflags,2) .eq. 0) go to 115
         call scale(xvert(i),yvert(i),xx(ihead),yy(ihead))
         go to 120
 115     continue
         xx(ihead) = xvert(i)
         yy(ihead) = yvert(i)
 120  continue
      if ((ihead-itail) .lt. 2) ihead = itail - 1
      nvert = ihead
c     
c     draw boundary(s) if desired
c     
      if (iand(iflags,1) .eq. 0) go to 138
      ihead = 0
      itail = 1
      lmove = .true.
 130  continue
      ihead = ihead + 1
      if (ihead .gt. nvert) go to 133
      if (xx(ihead) .ne. bignum) go to 135
 133  continue
      call gsdraw(xx(itail),yy(itail))
      itail = ihead + 1
      lmove = .true.
      go to 139
 135  continue
      if (lmove) go to 137
      call gsdraw(xx(ihead),yy(ihead))
      go to 139
 137  continue
      call gsmove(xx(ihead),yy(ihead))
      lmove = .false.
 139  continue		
      if (ihead .le. nvert) go to 130
 138  continue
c     
c     rotate to make shading lines horizontal
c     
      ymin = bignum
      ymax = -bignum
      yscale = ys*yres*fact
      yscal2 = 2.0*yscale
      do 140 i = 1, nvert
         if (xx(i) .eq. bignum) go to 140
c     
c     perform the rotation to achieve horizontal shading lines.
c     
         xv1 = xx(i)
         xx(i) = +cosphi*xv1 + sinphi*yy(i)
         yy(i) = -sinphi*xv1 + cosphi*yy(i)
c     
c     convert to integers after scaling, and make vertices odd. in y
c     
         yy(i) = 2.0*aint(yscale*yy(i)+0.5)+1.0
         ymin = amin1(ymin,yy(i))
         ymax = amax1(ymax,yy(i))
 140  continue
c     
c     make shading start on a multiple of the step size.
c     
      step = 2.0*aint(ys*yres*fact*cmspac)
      if (step .eq. 0.0) step = 2.0*aint(ys*nfline*fact)
      ymin = aint(ymin/step) * step
      ymax = aint(ymax/step) * step
c     
c     after all of the coordinates for the vertices have been pre-processed
c     the appropriate shading lines are drawn.  these are intersected with
c     the edges of the polygon and the visible portions are drawn.
c     
      y = ymin
 150  continue
      if (y .gt. ymax) go to 250
c     
c     initially there are no known intersections.
c     
      icount = 0
      ibase = 1
      ivert = 1
 160  continue
      itail = ivert
      ivert = ivert + 1
      ihead = ivert
      if (ihead .gt. nvert) go to 165
      if (xx(ihead) .ne. bignum) go to 170
c     
c     there is an edge from vertex n to vertex 1.
c     
 165  ihead = ibase
      ibase = ivert + 1
      ivert = ivert + 1
 170  continue
c     
c     see if the two endpoints lie on
c     opposite sides of the shading line.
c     
      yhead =  y - yy(ihead)
      ytail =  y - yy(itail)
      if (yhead*ytail .ge. 0.0) go to 180
c     
c     they do.  this is an intersection.  compute x.
c     
      icount = icount + 1
      delx = xx(ihead) - xx(itail)
      dely = yy(ihead) - yy(itail)
      xintcp(icount) = (delx/dely) * yhead + xx(ihead)
 180  continue
      if ( ivert .le. nvert ) go to 160
c     
c     sort the x intercept values.  use a bubblesort because there
c     aren't very many of them (usually only two).
c     
      if (icount .eq. 0) go to 240
      do 200 i = 2, icount
         xkey = xintcp(i)
         k = i - 1
         do 190 j = 1, k
            if (xintcp(j) .le. xkey)	go to 190
            xtemp = xkey
            xkey = xintcp(j)
            xintcp(j) = xtemp
 190     continue
         xintcp(i) = xkey
 200  continue
c     
c     all of the x coordinates for the shading segments along the
c     current shading line are now known and are in sorted order.
c     all that remains is to draw them.  process the x coordinates
c     two at a time.
c     
      yr = y/yscal2
      do 230 i = 1, icount, 2
c     
c     convert back to virtual coordinates.
c     rotate through an angle of -phi to original orientation.
c     then unscale from grid to virtual coord.
c     
         xv1 = + cosphi*xintcp(i) - sinphi*yr
         yv1 = + sinphi*xintcp(i) + cosphi*yr
         xv2 = + cosphi*xintcp(i+1) - sinphi*yr
         yv2 = + sinphi*xintcp(i+1) + cosphi*yr
c     
c     draw the segment of the shading line.
c     
         call gsmove(xv1,yv1)
         call gsdraw(xv2,yv2) 
 230  continue
 240  continue
      y = y + step
      go to 150
 250  continue
      return
      end
