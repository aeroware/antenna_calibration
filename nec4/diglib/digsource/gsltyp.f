      subroutine gsltyp(itype)
c     
c     
      include 'gcltyp.prm'
c     
c     set the current line type
c     
      ilntyp = itype
      if (ilntyp .le. 0 .or. (ilntyp .gt. 4)) ilntyp = 1
      linilt = .true.
      return
      end
