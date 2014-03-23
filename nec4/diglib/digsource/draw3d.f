      subroutine draw3d(z,izdim1,iz,kx)
c     draw plot 
c     
      dimension z(izdim1,2)
      integer*2 iz(kx,2)
c     
      include 'comdp.inc'
      include 'comdpa.inc'
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
 55   if(kscan .eq. 2) return 
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
      end 
