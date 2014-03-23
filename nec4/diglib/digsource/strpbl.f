      subroutine strpbl(str)
      character*1 str(2)
c
c     STRPBL - strip leading blanks (spaces) from STR.
c
ccccccccccccccc
c
c     Find first non-space
c
      i = 0
 10   continue
      i = i + 1
      if (str(i) .eq. ' ') goto 10
c
c     If first character is non-space, we are done!
c
      if (i .eq. 1) return
c
c     Copy string with leading spaces removed
c
      j = 1
 20   continue
      str(j) = str(i)
      if (str(i) .eq. char(0)) return
      j = j + 1
      i = i + 1
      goto 20
      end
