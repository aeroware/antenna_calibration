      subroutine symbol(isymno,symsiz)
c     
c     this subroutine places the desired symbol ("isymno") at the
c     current location with a size of "symsiz".   if "isymno" is
c     negative, the symbol is filled rather than open.
c     
      include 'gcvpos.prm'
      include 'gcltyp.prm'
c     
      dimension symmov(30), isymst(5), x(4), y(4), tx(4), ty(4)
c     
      data symmov /
     1     0.0,0.666667,  -0.5,-0.333333,  0.5,-0.333333,
     2     -0.5,0.5,  -0.5,-0.5,  0.5,-0.5,  0.5,0.5,
     3     0.0,0.5,  -0.4,0.0,  0.0,-0.5,  0.4,0.0,
     4     -0.4,0.5,  0.4,0.5,  -0.4,-0.5,  0.4,-0.5/
      data isymst /1,7,15,23,31/
      data nsym /4/
c     
c     save old line type, use solid lines
c     
      iold = ilntyp
      ilntyp = 1
c     
c     save current location
c     
      x0 = xvpos
      y0 = yvpos
c     
c     compute polygon scaled and translated
c     
      isym = iabs(isymno)
      if (isym .le. 0 .or. isym .gt. nsym) return
      iptr = isymst(isym)
      i = 0
 100  continue
      i = i + 1
      x(i) = x0+symsiz*symmov(iptr)
      y(i) = y0+symsiz*symmov(iptr+1)
      iptr = iptr + 2
      if (iptr .lt. isymst(isym+1)) go to 100
      if (isymno .lt. 0) goto 150
      call gspoly(x,y,i)
      go to 200
 150  continue
      call gsfill(x,y,i,tx,ty)
 200  continue
      call gsmove(x0,y0)
c     
c     restore original line type
c     
      ilntyp = iold
      return
      end
