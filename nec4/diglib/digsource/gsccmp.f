      subroutine gsccmp(ix,iy,xoff,yoff,x,y)
c     
c     
      include 'gccpar.prm'
      include 'gcapos.prm'
c     
c     scale to proper size
c     
      xs = csize*ix
      ys = csize*iy
c     
c     rotate and translate
c     
      x = ccos*xs + csin*ys + xoff
      y = ccos*ys - csin*xs + yoff
      return
      end
