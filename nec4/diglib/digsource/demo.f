      program demo
      dimension y1(101), y2(101)
c     
      external len
c     
      do 100 i=1,101
         x = 9.0*(i-1)/10.0 + 1.0
         y1(i) = x**2
         y2(i) = x**3
 100  continue
      xmin = 1.0
      xmax = x
      call minmax(y1,101,ymin,ymax1)
      call minmax(y2,101,ymin,ymax2)
c     
      call seldev(4)
 10   call bgnplt
c     
      call mapsiz(0.0,48.5,52.5,100.0,0.0)
      call mapit(xmin,xmax,ymin,ymax1,'X Axis'//char(0),
     &'Y Axis'//char(0),'PLOT 1'//char(0),0)
      call gscolr(2,ierr)
      call curvey(xmin,xmax,y1,101,1,0.3,10)
c     
      call gscolr(1,ierr)
      call mapsiz(51.5,100.0,52.5,100.0,0.0)
      call mapit(xmin,xmax,ymin,ymax2,'X Axis'//char(0),
     &'Y Axis'//char(0),'PLOT 2'//char(0),0)
      call gscolr(3,ierr)
      call curvey(xmin,xmax,y2,101,2,0.3,5)
      call gscolr(1,ierr)
      call mapsiz(0.0,100.0,0.0,47.5,0.0)
      call mapit(xmin,xmax,ymin,ymax2,'X Axis'//char(0),
     &'Y Axis'//char(0),'PLOT 3'//char(0),2)
      call gscolr(2,ierr)
      call curvey(xmin,xmax,y1,101,-1,0.3,10)
      call gscolr(3,ierr)
      call curvey(xmin,xmax,y2,101,-2,0.3,5)
      call endplt
      call rlsdev
      write(*,*)' >'
      read(*,*)dummy
      stop
      end
