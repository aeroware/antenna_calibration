      subroutine gsrst(xv,yv,xa,ya)
c     
c     
      include 'gcdprm.prm'
c     
c     rotate, scale, and then translate coordinates
c     (take virt. coord. into screen coord.)
c     
      xtemp = xv
      xa = xs*(rcos*xtemp+rsin*yv) + xt
      ya = ys*(rcos*yv-rsin*xtemp) + yt
      return
      end
      
      subroutine gsirst(xa,ya,xv,yv)
c     
c     inverse rotate, scale, and then translate
c     (take absolute coord. into virtual coord.)
c     
      include 'gcdprm.prm'
c     
c     convert absolute cm. coord. to virtual cm. coordinates
c     
      xtemp = (xa-xt)/xs
      yv = (ya-yt)/ys
      xv = rcos*xtemp-rsin*yv
      yv = rcos*yv+rsin*xtemp
      return
      end
