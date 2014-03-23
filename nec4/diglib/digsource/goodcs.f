      function goodcs(approx)
      include 'gcdchr.prm'
      include 'gcdprm.prm'
c     
c     calculate minimum virtual coord. size of chars that are readalbe with
c     the devices resolution.
c     
      size = (gschit()/yres)/ys
c     
c     now scale up this minimum size so that characters are about
c     the size desired.
c     
      n = approx/size + 0.25
c     
c     must be atleast n=1
c     
      if (n .eq. 0) n=1
c     
c     now return our answer
c     
      g = n*size
c     
c     for laser printers, set a minimum font size of 5 point (.176 cm)
      if (g*ys.lt.0.176) then
         n = 0.176/(size*ys) + 1
         g = n*size
      endif
      goodcs = g
      return
      end
