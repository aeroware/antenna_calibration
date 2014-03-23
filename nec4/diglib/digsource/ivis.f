      function ivis(xi,eta,zeta,z,izdim1)
      dimension z(izdim1,2)
c     
c     corrected version, 24feb69 
c     determine if point xi, eta is visible 
c     point is given by xi, eta, zin 
c     and visibility is tested with respect to surface z(x,y) 
c     xi, eta coordinates expressed as indices of array z, but need not
c     be integers in general. for entry ivis, they must be. 
c     
c     
      include 'comdp.inc'
c     
      equivalence (cx,cy), (dxi,deta), (xiw,etaw),
     $     (xiend,etaend), (kdxi,kdeta), (kxiend,ketend),
     $     (dx,dy)
c     
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     
c     initial p function 
 5    ivis = 0 
      r = u-xi 
      s = v-eta 
      t = w-zeta 
c     test if we check along x 
      if(abs(r) .lt. 1.0) go to 20 
c     constants for y(x),z(x) 
      cy = s/r 
      cz = t/r 
      dxi = sign(1.0,r) 
c     initial point. take aint(xi) if .ne. xi and steps in right directi
      xiw = aint(xi) 
      if((xiw-xi)*dxi .le. 0.0) xiw = xiw+dxi 
c     skip if off limits (we are on edge of plot region) 
      if((xiw-1.0)*(xiw-fmx) .gt. 0.0) go to 20 
c     final point. take aint(u) if it moves opposite dxi, else round 
      xiend = aint(u) 
      if((xiend-u)*dxi .ge. 0.0) xiend = xiend-dxi 
c     but do not go beyond edges 
      xiend = amax1(1.0,amin1(xiend,fmx)) 
c     
c     after testing, re-prder these statements 
      j = ifix(xiw) 
      kdxi = ifix(dxi) 
      kxiend = ifix(xiend) 
      xw = xiw-u 
c     
c     if limits cross, no test 
      if((xiend-xiw)*dxi .le. 0.0) go to 20 
c     get y(x) 
 3    yw = v + xw*cy 
c     if y is off limits, done 
      if((yw-1.0)*(yw-fny)) 21,25,20 
c     on edge exactly, no interpolation 
 25   k = ifix(yw) 
      if(w + xw*cz - z(j,k)) 4,10,7 
c     index for lower y of interval 
 21   k = ifix(yw) 
      dy = yw-float(k) 
c     test z of line - z of surface. accept zero difference. 
      if((w + xw*cz)-(z(j,k) + dy*(z(j,k+1)-z(j,k)))) 4,10,7 
c     negative. ok if ivis neg. or zero, else reject 
 4    if(ivis) 10,6,40 
c     ivis was zero, set neg. 
 6    ivis = -1 
      go to 10 
c     plus. ok if ivis + or zero, else, reject 
 7    if(ivis) 40,8,10 
c     set plus 
 8    ivis = 1
c     test if done. advance if not 
 10   if(j .eq. kxiend) go to 20 
      j = j+kdxi 
      xw = xw+dxi 
      go to 3 
c     
c     check if we test in y direction 
 20   if(abs(s) .lt. 1.0) go to 45 
c     constants for x(y),z(y) 
      cx = r/s 
      cz = t/s 
      deta = sign(1.0,s) 
      etaw = aint(eta) 
      if((etaw-eta)*deta .le. 0.0) etaw = etaw+deta 
c     check whether on limits 
      if((etaw-1.0)*(etaw-fny) .gt. 0.0) go to 45 
      etaend = aint(v) 
      if((etaend-v)*deta .ge. 0.0) etaend = etaend-deta 
      etaend = amax1(1.0,amin1(fny,etaend)) 
      k = ifix(etaw) 
      kdeta = ifix(deta) 
      yw = etaw-v 
      ketend = ifix(etaend) 
c     if limits cross, no test, but test single point if we have already
c     tested x 
      a = etaend-etaw 
      if(a*deta .lt. 0.0) go to 45 
      if(a .eq. 0.0 .and. ivis .eq. 0) go to 45 
c     get x(y) 
 23   xw = u + yw*cx 
c     if x off limits, done 
      if((xw-1.0)*(xw-fmx)) 44,46,45 
 46   j = ifix(xw) 
      if(w + yw*cz - z(j,k)) 24,30,27 
 44   j = ifix(xw) 
      dx = xw-float(j) 
      if((w + yw*cz) - (z(j,k)+dx*(z(j+1,k)-z(j,k)))) 24,30,27 
c     neg., ivis must be neg or zero else rejct 
 24   if(ivis) 30,26,40 
c     set ivis neg 
 26   ivis = -1 
      go to 30 
c     pos, ivis must be zero or + else reject 
 27   if(ivis) 40,28,30 
 28   ivis = 1
c     test if done, advance if not. 
 30   if(k .eq. ketend) go to 45 
      k = k+kdeta 
      yw = yw+deta 
      go to 23 
c     
c     reject this point, return zero. 
 40   ivis = 0 
      return 
c     
c     accept. return +/- 1
c     if ivis zero, camera was right over xi, eta. 
 45   if(ivis .eq. 0) ivis = sign(1.0,t) 
      if (lsolid .and. (ivis .eq. -1)) go to 40
      return 
      end 
