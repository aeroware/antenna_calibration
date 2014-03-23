      function levelc(z,cl,nl)
      dimension cl(nl)
c     
      levelc = 1
 100  continue
      if (z .le. cl(levelc)) return
      levelc = levelc + 1
      if (levelc .gt. nl) return
      go to 100
      end
