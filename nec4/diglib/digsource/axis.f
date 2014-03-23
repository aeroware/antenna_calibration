      subroutine axis(blow,bhigh,maxtks,lshort,lraggd,bmin,bmax,
     1                btmin,btmax,btick,ipwr)
      logical lshort, lraggd
c     
c     this subroutine is mainly for internal use,
c     its function is to determine a suitable
c     "tick" distance over the range specified between
c     alow and ahigh.   it outputs the axis range bmin,bmax
c     and the tick distance btick stripped of their power of
c     ten.   the power of ten is returned in the var. ipwr.
c     
      dimension jticks(6)
      logical ldivds
      logical lisneg
c     
c     if a ragged axis is "too close" to the next tick, then extend it.
c     the "too close" parameter is the variable toocls
c     
      data toocls /0.8/
c     
      data fuzz /0.001/
      data jticks /1,2,5,4,3,10/
      data smlrng /0.01/
c     
c     
      toobig = 1.0/smlrng
      maxtks = max0(1,maxtks)
      mintks = max0(1,maxtks/2)
      bmax = bhigh
      bmin = blow
      lisneg = .false.
      if (bmax .ge. bmin) go to 30
      bmax = blow
      bmin = bhigh
      lisneg = .true.
c     
c     make sure we have enough range, if not, increase ahigh
c     
 30   range = bmax - bmin
      temp = amax1(abs(bmin),abs(bmax))
      if (temp .eq. 0.0) temp = 10.0
      if (range/temp .ge. smlrng) go to 40
      bmin = bmin - smlrng*temp
      bmax = bmax + smlrng*temp
 40   continue
c     
c     strip the range of its power of ten
c     
      ipwr=alog10(bmax-bmin)-2
 50   tenx = 10.0**ipwr
      astrt = aint(bmin/tenx)
      afin = aint(bmax/tenx+0.999)
      if (afin*tenx .lt. bmax) afin = afin + 1
      if (abs(afin) .ge. toobig .or. abs(astrt) .ge. toobig) goto 70
      range = afin - astrt
      if (range .le. 10*maxtks) go to 75
 70   ipwr = ipwr + 1
      go to 50
 75   continue
c     
c     search for a suitable tick
c     
      btick = 0
      do 100 i=1,6
         tick = jticks(i)
         ntick = range/tick+0.999
         if (ntick .gt. maxtks) go to 100
         if (ntick .ge. mintks .and.
     1       ldivds(astrt,tick) .and. ldivds(afin,tick)) go to 150
         if (btick .eq. 0) btick = tick
 100  continue
c     
c     use best non-perfect tick
c     
      go to 160
c     
c     found a good tick
c     
 150  btick=jticks(i)
 160  continue
      if (btick .ne. 10.0) go to 165
      btick = 1.0
      ipwr = ipwr + 1
      tenx = 10.0*tenx
 165  tick = btick*tenx
c     
c     figure out tick limits
c     
      btmin = btick*aint(bmin/tick)
      if (btmin*tenx .lt. bmin) btmin = btmin + btick
      btmax = btick*aint(bmax/tick)
      if (btmax*tenx .gt. bmax) btmax = btmax - btick
      nintvl = (btmax-btmin)/btick
c     
c     if user absolutely must have ragged axis, then force it.
c     
      if (lshort .and. lraggd) go to 180
c     
c     check individually
c     
      if (lshort .and. (nintvl .gt. 0) .and.
     1    ((btmin-bmin/tenx)/btick .le. toocls) ) go to 170
      if ((btmin-bmin/tenx) .gt. fuzz) btmin = btmin - btick
      bmin = btmin*tenx
 170  continue
      if (lshort .and. (nintvl .gt. 0) .and.
     1    ((bmax/tenx-btmax)/btick .le. toocls) ) go to 180
      if ((bmax/tenx-btmax) .gt. fuzz) btmax = btmax + btick
      bmax = btmax*tenx
 180  continue
      if (.not. lisneg) go to 200
c     switch back to backwards
      btick = -btick
      temp = bmin
      bmin = bmax
      bmax = temp
      temp = btmin
      btmin = btmax
      btmax = temp
 200  return
      end
      
      function ldivds(anumer,adenom)
      logical ldivds
      if (anumer/adenom .eq. aint(anumer/adenom)) go to 10
      ldivds = .false.
      return
 10   ldivds = .true.
      return
      end
