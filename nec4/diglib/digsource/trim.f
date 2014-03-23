      subroutine trim(str)
      character*1 str(2)
c
c     TRIM - Trim (remove) trailing spaces from a string
c
cccccccccccccccccccccccccccccc
c
      external len
c
      i = len(str) + 1
 10   continue
      i = i - 1
      if (str(i) .eq. ' ') goto 10
      str(i+1) = char(0)
      return
      end
