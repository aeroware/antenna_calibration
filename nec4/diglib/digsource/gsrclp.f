      subroutine gsrclp(area)
      dimension area(4)
c     
c     this subroutine restores a saved absolute clipping window previously
c     saved by "gssclp".   no error checking is performed here!!!
c     
      include 'gcclip.prm'
c     
      xcm0 = area(1)
      xcm1 = area(2)
      ycm0 = area(3)
      ycm1 = area(4)
      return
      end
