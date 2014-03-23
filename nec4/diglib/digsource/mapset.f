      subroutine mapset(xleft,xright,ybot,ytop,csize,tkln,lraxis)
      logical lraxis
c     
      include 'gcdchr.prm'
c     
c     
      call mapprm(xleft*xlencm/100.0,xright*xlencm/100.0,
     1     ybot*ylencm/100.0,ytop*ylencm/100.0,csize,tkln,lraxis)
      return
      end
