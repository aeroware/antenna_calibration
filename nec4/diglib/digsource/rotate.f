      subroutine rotate(xin,a,xout) 
      dimension xin(3),a(9),xout(3) 
c     
c     rotate vector xin by matrix a to get xout 
c     
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     
      xout(1) = a(1)*xin(1) + a(4)*xin(2) + a(7)*xin(3) 
      xout(2) = a(2)*xin(1) + a(5)*xin(2) + a(8)*xin(3) 
      xout(3) = a(3)*xin(1) + a(6)*xin(2) + a(9)*xin(3) 
      return 
      end
