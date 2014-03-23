      subroutine gsdlns(iltype,on1,off1,on2,off2)
c     
c     define line style
c     
      include 'gcltyp.prm'
c     
      if (iltype .lt. 2 .or. iltype .gt. 4) return
      index = iltype-1
      dist(1,index) = on1
      dist(2,index) = off1
      dist(3,index) = on2
      dist(4,index) = off2
      return
      end
