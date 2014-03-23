

      subroutine gsdrw2(x0,y0,ivis0,x1,y1,ivis1)
c     
c     clip line to clipping box.   pass on only visible line segments to
c     gsdrw3 to be drawn in the current line type.   this subroutine also
c     worries about whether the graphics device will require a "move"
c     before the "draw" is done.
c     
      include 'gcclip.prm'
      include 'gcltyp.prm'
c     
      logical ldid1
c     
cd    type *,'clipping (',x0,',',y0,')  ivis=',ivis0
cd    type *,' to (',x1,',',y1,')  ivis=',ivis1
      if (iand(ivis0,ivis1) .ne. 0) return
      if (ivis0 .eq. 0) go to 10
      lposnd = .false.
      linilt = .true.
 10   continue
c     
c     calculate the number of clips necessary
c     
      nclips = 0
      if (ivis0 .ne. 0) nclips = 1
      if (ivis1 .ne. 0) nclips = nclips + 1
      if (nclips .ne. 0) go to 100
c     
c     line totally visible, just draw it
c     
      call gsdrw3(x0,y0,x1,y1)
      return
c     
c     find the intersection(s) with the clipping box edges
c     
 100  continue
cd    type *,'nclips=',nclips
      ldid1 = .false.
      ist = 1
      dx = x1-x0
      if (dx .eq. 0.0) ist = 3
      ifn = 4
      dy = y1-y0
      if (dy .eq. 0.0) ifn = 2
      if (ist .gt. ifn) return
      ivisc = ior(ivis0,ivis1)
      ibit = 2**(ist-1)
cd    type *,'ist=',ist,'   ifn=',ifn
      do 210 i = ist, ifn
         if (iand(ivisc,ibit) .eq. 0) go to 200
         if (i .gt. 2) go to 110
         xi = xcm0
         if (i .eq. 2) xi = xcm1
         yi = y0 + (xi-x0)*dy/dx
         if (yi .lt. ycm0 .or. yi .gt. ycm1) go to 200
         go to 120
 110     continue
         yi = ycm0
         if (i .eq. 4) yi = ycm1
         xi = x0 + (yi-y0)*dx/dy
cd    type *,'y intersection',xi,yi
         if (xi .lt. xcm0 .or. xi .gt. xcm1) go to 200
 120     continue
c     
c     got an intersection.   if it's the only one, the draw the line.
c     
         if (nclips .gt. 1) go to 140
         if (ivis0 .eq. 0) go to 130
         call gsdrw3(xi,yi,x1,y1)
         return
 130     continue
         call gsdrw3(x0,y0,xi,yi)
         return
 140     continue
c     
c     two clips necessary.   if we already have one, draw the double clipped
c     line, else save first clip and wait for last.
c     note, if double clipped, it doesn't matter in which direction it
c     is drawn.
c     
         if (.not. ldid1) go to 180
         call gsdrw3(x2,y2,xi,yi)
         return
 180     continue
         x2 = xi
         y2 = yi
         ldid1 = .true.
 200     continue
         ibit = 2*ibit
 210  continue
c     
c     segment is not visible if we drop thru to here
c     
      return
      end
