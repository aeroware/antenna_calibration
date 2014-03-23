      logical lsolid
      common /comdp/ xmin,xmax,ymin,ymax,zmin,zmax,axisr(2),plotx, 
     $     ploty,pltorg(2),camxyz(3),mx,ny,fmx,fny,camwkg(6),xorg(3), 
     $     gx(3),fx(2),kscale,zorg,center(2),pqlmt,
     $     amtx(3,3),focall, lsolid
      dimension limit(2),flim(2)
      equivalence(u,camxyz(1)),(v,camxyz(2)),(w,camxyz(3)),
     $     (mx,limit(1)),(fmx,flim(1))
