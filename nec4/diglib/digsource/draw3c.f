      subroutine draw3c(z,izdim1,iz,kx,collev,nlev,icolrs)
      dimension z(izdim1,2), collev(nlev), icolrs(nlev+1)
      integer*2 iz(kx,2)
c     
c     draw plot 
c     
      include 'comdp.inc'
      include 'comdpa.inc'
c     
      integer phir
c     
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     
c     get ready for colored segments
c     
      icolor = -1
c     
c     save z dimension in common to pass along through drawpq to ivis 
c     scan along x first at constant y 
c     
c     index of coordinate being stepped along a line 
      kscan = 1 
c     index of coordinate being held fixed 
      kfix = 2 
c     set fixed coordinate   increment 
      pc(kfix) = 1.0 
      delfix = 1.0 
c     set roving coordinate   increment initially 
      delscn = 1.0 
      qc(kscan) = 1.0 
c     begin scanning a line 
 101  qc(kfix) = pc(kfix) 
      ibeam = 0 
c     next point in line scan 
 102  pc(kscan) = qc(kscan) 
      qc(kscan) = pc(kscan) + delscn 
c     working indices 
      jpc = ifix(pc(1)) 
      kpc = ifix(pc(2)) 
      jqc = ifix(qc(1)) 
      kqc = ifix(qc(2)) 
c     phi functions 
      pc(3)=z(jpc,kpc) 
      qc(3)=z(jqc,kqc) 
      phip=iz(jpc,kpc)-1 
      phiq=iz(jqc,kqc)-1 
c     
c     break segment into color segments as necessary
c     
      lp = levelc(pc(3),collev,nlev)
      lq = levelc(qc(3),collev,nlev)
      if (icolor .ne. icolrs(lp)) then
         icolor = icolrs(lp)
         call gscolr(icolor,ierr)
      endif
 110  continue
      if (lp .eq. lq) goto 200
c     save q in r
      phir = phiq
      rscan = qc(kscan)
      rz = qc(3)
c     determine location of intersection with next level towards q
      if (lp .lt. lq) then
         lnext = lp + 1
         d = (collev(lp)-pc(3))/(qc(3)-pc(3))
         qc(3) = collev(lp)
      else
         lnext = lp-1
         d = (collev(lnext)-pc(3))/(qc(3)-pc(3))
         qc(3) = collev(lnext)
      endif
      qc(kscan) = d*(qc(kscan)-pc(kscan)) + pc(kscan)
c     determine visibility of intersection point and draw
      phiq = ivis(qc(1),qc(2),qc(3),z,izdim1)
      call drawpq(z,izdim1)
c     now, set p to q and q to r
      pc(kscan) = qc(kscan)
      pc(3) = qc(3)
      qc(kscan) = rscan
      qc(3) = rz
      phip = phiq
      phiq = phir		
c     note we have moved to the next colored segment
      lp = lnext
      icolor = icolrs(lp)
      call gscolr(icolor,ierr)
c     loop back and handle the new (shorter) p-q segment
      go to 110
 200  call drawpq(z,izdim1) 
c     test if line is done 
      if((qc(kscan)-1.0)*(qc(kscan)-flim(kscan)) .lt. 0.0) go to 102 
c     line done. advance fixed coordinate. 
      pc(kfix) = pc(kfix) + delfix 
c     test if fixed coordinate now off limits 
      if((pc(kfix)-1.0)*(pc(kfix)-flim(kfix)) .gt. 0.0) go to 55 
c     flip increment. scan begins at qc of previous line. 
      delscn = -delscn 
      go to 101 
c     test if we have done y scan yet. 
 55   if(kscan .eq. 2) goto 300
c     no, scan y direction at fixed x. 
      kscan = 2 
      kfix = 1 
c     start fixed x at x of last traverse 
      pc(1) = qc(1) 
c     then step x in opposite direction 
      delfix = -delscn 
c     we ended up at max. y, so first y scan goes backwards 
      delscn = -1.0 
c     initial y for first line 
      qc(2) = fny 
      go to 101 
 300  continue
      call gscolr(1,ierr)
      return
      end 
