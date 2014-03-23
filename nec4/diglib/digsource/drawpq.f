      subroutine drawpq(z,izdim1)
      dimension z(izdim1,2)
c     
c     draw visible part of segment pc-qc
c     
      include 'comdp.inc'
      include 'comdpa.inc'
c     
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     
      p(1) = pc(1) 
      p(2) = pc(2) 
      p(3) = pc(3) 
      q(1) = qc(1) 
      q(2) = qc(2) 
      q(3) = qc(3) 
c     test if p visible 
 2    if(phip .eq. 0) go to 30 
c     yes, test q 
 7    if(phip*phiq)10,4,3 
c     both visible   segment drawable, plot   exit 
 3    kgoto = 0 
      go to 300 
c     q is invisible, find last visible point on segment pq 
 4    jgoto = 1
      go to 200 
c     give up if not found in maxcut1 bisections 
 5    if(kflag .ne. 0) go to 6 
c     next point 
      ibeam = 0 
      return 
c     point found 
 6    q(1) = enda(1) 
      q(2) = enda(2) 
      q(3) = enda(3) 
      go to 3 
c     
c     gap in segment, find last point to connect p. 
 10   jgoto = 2 
      go to 200 
c     if not found (cannot find point with same visibility fn). try 2nd 
 11   if(kflag .eq. 0) go to 15 
c     save old q, reset point   plot this piece. 
      oldq(1) = q(1) 
      oldq(2) = q(2) 
      oldq(3) = q(3) 
      q(1) = enda(1) 
      q(2) = enda(2) 
      q(3) = enda(3) 
c     draw first part of segment and come back here 
      kgoto = 2 
      go to 300 
c     restore q   find lower limit of upper segment. 
c     limits for search 
 12   p(1) = q(1) 
      p(2) = q(2) 
      p(3) = q(3) 
      q(1) = oldq(1) 
      q(2) = oldq(2) 
      q(3) = oldq(3) 
c     beam off first 
 15   ibeam = 0 
      jgoto = 3 
      go to 201 
c     if segment too short, give up. 
 13   if(kflag .eq. 0) go to 50 
c     lower end now newly found point. 
 14   p(1) = enda(1) 
      p(2) = enda(2) 
      p(3) = enda(3) 
      go to 3 
c     p invisible, check q. if invisible, advance. 
 30   ibeam = 0 
      if(phiq .eq. 0) go to 50 
c     find p 
      jgoto = 4 
      go to 201 
c     if no point, give up. 
 31   if(kflag) 14,50,14 
c     
c     
c     p visible, q invisible, find q. 
c     endb = invisible end of interval, enda = visible 
 200  endb(1) = q(1) 
      endb(2) = q(2) 
      endb(3) = q(3) 
      enda(1) = p(1) 
      enda(2) = p(2) 
      enda(3) = p(3) 
c     required ivis function 
c     in case of gap in segment, consider point visible if its visib. 
c     function matches this one and update enda, else endb. 
      phia = phip 
      go to 205 
c     p invisible, q visible. find p. 
 201  endb(1) = p(1) 
      endb(2) = p(2) 
      endb(3) = p(3) 
      enda(1) = q(1) 
      enda(2) = q(2) 
      enda(3) = q(3) 
      phia = phiq 
 205  kflag = 0 
c     get projected length of segment 
      pk(1) = xmin + (enda(1)-1.0)*gx(1) - camwkg(1) 
      pk(2) = ymin + (enda(2)-1.0)*gx(2) - camwkg(2) 
      pk(3) = enda(3)*gx(3) + zorg - camwkg(3) 
      call rotate(pk,amtx,enda(4)) 
      pk(1) = xmin + (endb(1)-1.0)*gx(1) - camwkg(1) 
      pk(2) = ymin + (endb(2)-1.0)*gx(2) - camwkg(2) 
      pk(3) = endb(3)*gx(3) + zorg - camwkg(3) 
      call rotate(pk,amtx,endb(4)) 
c     next step 
 210  t(1) = (enda(1)+endb(1))/2.0 
      t(2) = (enda(2)+endb(2))/2.0 
      t(3) = (enda(3)+endb(3))/2.0 
      t(4) = (enda(4)+endb(4))/2.0 
      t(5) = (enda(5)+endb(5))/2.0 
      t(6) = (enda(6)+endb(6))/2.0 
      mflag = ivis(t(1),t(2),t(3),z,izdim1) 
      if(mflag .eq. phia) go to 220 
c     not visible, reset invisible end. 
      endb(1) = t(1) 
      endb(2) = t(2) 
      endb(3) = t(3) 
      endb(4) = t(4) 
      endb(5) = t(5) 
      endb(6) = t(6) 
c     check segment length (use max of x, y differences) 
 216  sl = focall*amax1(abs(enda(4)/enda(6)-endb(4)/endb(6)), 
     $     abs(enda(5)/enda(6)-endb(5)/endb(6))) 
      if(sl .ge. pqlmt) go to 210 
      go to (5,11,13,31), jgoto 
c     record visible, update enda 
 220  kflag = mflag 
      enda(1) = t(1) 
      enda(2) = t(2) 
      enda(3) = t(3) 
      enda(4) = t(4) 
      enda(5) = t(5) 
      enda(6) = t(6) 
      go to 216 
c     
c     
c     draw p to q 
c     
c     if beam is on, just move it to q. 
 300  if(ibeam .gt. 0) go to 310 
c     move to p, beam off. 
      pk(1) = xmin + (p(1)-1.0)*gx(1) - camwkg(1) 
      pk(2) = ymin + (p(2)-1.0)*gx(2) - camwkg(2) 
      pk(3) = p(3)*gx(3) + zorg - camwkg(3) 
      call rotate(pk,amtx,pw) 
      pw(1) = (pw(1)/pw(3)-xorg(1))*focall + pltorg(1) + center(1) 
      pw(2) = (pw(2)/pw(3)-xorg(2))*focall + pltorg(2) + center(2) 
      call gsmove(pw(1),pw(2))
c     move to q, beam on. beam is left and at point q. 
 310  qk(1) = xmin + (q(1)-1.0)*gx(1) - camwkg(1) 
      qk(2) = ymin + (q(2)-1.0)*gx(2) - camwkg(2) 
      qk(3) = q(3)*gx(3) + zorg - camwkg(3) 
      call rotate(qk,amtx,qw) 
      qw(1) = (qw(1)/qw(3)-xorg(1))*focall + pltorg(1) + center(1) 
      qw(2) = (qw(2)/qw(3)-xorg(2))*focall + pltorg(2) + center(2) 
      call gsdraw(qw(1),qw(2))
      ibeam = 1 
      if(kgoto .ne. 0) go to 12 
c     
 50   return 
      end 
