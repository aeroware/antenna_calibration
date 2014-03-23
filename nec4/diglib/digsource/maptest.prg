	program maptest
c
	character*1 answer
c
	call seldev(4,ierr)
c
100	continue
	write (6,101)
101	format('Enter xmin, xmax, ymin, ymax, ioptns: ')
	read (5,102) xmin, xmax, ymin, ymax, ioptns
102	format(4f14.0,i5)
	call bgnplt
	call fulmap
	call mapit(xmin,xmax,ymin,ymax,'X axis', 'Y axis','Title',ioptns)
	call endplt
	write (6,111)
111	format('Another plot? ')
	read (5,112) answer
112	format(a1)
	if (answer .eq. 'Y' .or. answer .eq. 'y') go to 100
	call rlsdev
	stop
	end
