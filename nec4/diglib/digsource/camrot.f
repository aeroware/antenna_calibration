      subroutine camrot 
c     make up camera rotation matrix 
c     
c     rotation is done so that z prime axis is directed from the
c     camera to the aiming point.   note also that the primed
c     coordinate system is left-handed if epslon=-1.
c     this is so that the picture comes out right when projected
c     on the primed coordinate system.
c     
      include 'comdp.inc'
c     
c     local cde 
      dimension au(3),av(3),aw(3) 
c     handedness parameter, -1 for left-handed usually 
      data epslon/-1.0/ 
c     
      s = 0.0 
      do 1 j = 1,3 
         av(j) = 0.0 
         aw(j) = 0.0 
         au(j) = camwkg(j+3)-camwkg(j) 
         s = s + au(j)**2
 1    continue
      s = sqrt(s) 
      do 2 j = 1,3 
         au(j) = au(j)/s
 2    continue
      sigma = sqrt(au(1)**2 + au(2)**2) 
c     prepare looking straight up or down 
      av(1) = 1.0 
      aw(2) = -epslon 
      if(au(3) .gt. 0.0) aw(2) = -aw(2) 
      if(sigma .lt. 1.0e-3) go to 4 
c     x axis 
      av(1) = au(2)/sigma 
      av(2) = -au(1)/sigma 
      av(3) = 0.0 
c     y axis 
      aw(1) = epslon*au(1)*au(3)/sigma 
      aw(2) = epslon*au(2)*au(3)/sigma 
      aw(3) = -epslon*sigma 
c     transfer axis direction cosines to rotation matrix rows 
 4    do 3 j = 1,3 
         amtx(1,j) = av(j) 
         amtx(2,j) = aw(j) 
         amtx(3,j) = au(j)
 3    continue
      return 
      end 
