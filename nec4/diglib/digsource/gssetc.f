      subroutine gssetc(size,angle)
c     
c     
      include 'gccpar.prm'
      include 'piodef.prm'
c     
c     set up size multiplier
c     
      csize = size/gschit()
c     
c     calculate the rotation factors
c     
      rad = -pio180*angle
      ccos = cos(rad)
      csin = sin(rad)
      return
      end
