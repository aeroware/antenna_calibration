      subroutine gsetdp(angle,xscale,yscale,xtran,ytran)
c     
c     
      include 'gcdprm.prm'
      include 'piodef.prm'
c     
c     set scale and translation factors
c     
      xs = xscale
      ys = yscale
      xt = xtran
      yt = ytran
c     
c     set rotation factors
c     
      rad = -angle*pio180
      rcos = cos(rad)
      rsin = sin(rad)
      return
      end
