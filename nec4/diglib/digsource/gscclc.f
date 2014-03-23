      subroutine gscclc(x,y,dx,dy)
c     
c     this subroutine does the character sizing and rotation.
c     
      include 'gccpar.prm'
      include 'gccoff.prm'
c     
      xs = x*csize
      ys = y*csize
      dx = ccos*xs + csin*ys + xoff
      dy = ccos*ys - csin*xs + yoff
      return
      end
