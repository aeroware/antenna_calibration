      subroutine tickl(anum,up)
c     
      include 'dbase.inc'
c     
      character*10 cnumbr
c     
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     
      write(cnumbr,100) anum
 100  format(g9.3)
      cnumbr(10:10) = char(0)
      call trim(cnumbr)
      call strpbl(cnumbr)
      temp = gslens(cnumbr) + 0.25*cxsize
      if (vx .gt. voldx) temp = -0.5*cxsize
      call gsmove(vx-temp,vy+up*cysize)
      call gspstr(cnumbr)
      return
      end
