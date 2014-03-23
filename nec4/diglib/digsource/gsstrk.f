      subroutine gsstrk(ichar)
c     
c     this subroutine strokes out a character.
c     
      logical lmove
      include 'gcfont.cmn'
c     
c     space fill all non-printing and non-defined with space size of
c     a capital "a".
c     
      jchar = (ichar-32) + 95*(icfontslot-1)
      if (ichar .le. 32 .or. ichar .ge. 128) go to 800
      if (icfontslot .gt. 1) then
         if (bwidth(jchar-95) .le. 0) go to 800
      endif
c     
c     stroke this character
c     
      index = indx(jchar)
      idone = indx(jchar+1)
c     
c     first position is an assumed move
c     
      lmove = .true.
c     
c     get the scaled and rotated next position on the character
c     
 100  continue
 150  if (bxy(index) .ne. -64) go to 160
      lmove = .true.
      index = index + 1
      go to 100
c     
 160  x=bxy(index)
      y=bxy(index+1)
      call gscclc(x,y,dx,dy)
      index = index + 2
      if (lmove) then
         call gsmove(dx,dy)
      else
         call gsdraw(dx,dy)
      endif
      lmove = .false.
      if (index .lt. idone) go to 100
c     
c     all done with the character, move to next character position
c     
 200  continue
      if (icfontslot .eq. 1) then
         width = 9.0
      else
         width = bwidth(jchar-95)
      endif
      call gscclc(width,0.0,dx,dy)
      call gsmove(dx,dy)
      return
c     
c     use capital "a" for size of space and all non-printing and non-defined
c     
 800  continue
      jchar = (65-32) + 95*(icfontslot-1)
      go to 200
      end
