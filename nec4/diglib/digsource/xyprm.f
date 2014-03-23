      subroutine xyprm(x,y,zeta,iline)
c     
      include 'comdp.inc'
      include 'dbase.inc'
c     
      dimension xs(3),xc(3)
c     
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     
      xs(1)=xmin+(x-1.0)*gx(1)-camwkg(1)
      xs(2)=ymin+(y-1.0)*gx(2)-camwkg(2)
      xs(3)=zorg + zeta*gx(3)-camwkg(3)
      call rotate(xs,amtx,xc)
      vx=(xc(1)/xc(3)-xorg(1))*focall+pltorg(1)+center(1)
      vy=(xc(2)/xc(3)-xorg(2))*focall+pltorg(2)+center(2)
      if (iline) 30, 20, 10
 10   call gsdraw(vx,vy)
      go to 30
 20   call gsmove(vx,vy)
 30   return
      end
