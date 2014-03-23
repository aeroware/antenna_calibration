	subroutine cursor(x,y,key)
	character*1 key
c
c	display and read the graphics cursor and return its position
c	in user coordinates.
c
	include 'pltcom.prm'
	include 'pltsiz.prm'
c
c	get cursor position in virtual coordinates.
c
	call gsgin(x,y,key,ierr)
	if (ierr .ge. 0) go to 50
	x = xvstrt
	y = yvstrt
50	x = (x-xvstrt)*udx/xvlen + ux0
	if (logx) x = 10.0**x
	y = (y-yvstrt)*udy/yvlen + uy0
	if (logy) y = 10.0**y
	return
	end
