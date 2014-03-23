      program demox11
      dimension y1(101), y2(101)
      dimension idw(3)
      integer gdx11cdw, gdx11setdw
      character*1 pick
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
      call gdx11setwindow(400,300)
      call seldev(4)
 10   call bgnplt
c     
      call fulmap
      call mapit(xmin,xmax,ymin,ymax1,'X Axis'//char(0),
     &'Y Axis'//char(0),'PLOT 1'//char(0),0)
      call gscolr(2,ierr)
      call curvey(xmin,xmax,y1,101,1,0.3,10)
      call endplt
c
      idw(2) = gdx11cdw(0,400,300)
      idw(1) = gdx11setdw(idw(2))
      call bgnplt
      call fulmap
      call mapit(xmin,xmax,ymin,ymax2,'X Axis'//char(0),
     &'Y Axis'//char(0),'PLOT 2'//char(0),0)
      call gscolr(3,ierr)
      call curvey(xmin,xmax,y2,101,2,0.3,5)
      call endplt

      idw(3) = gdx11cdw(0,600,450)
      idummy = gdx11setdw(idw(3))
      call bgnplt
      call fulmap
      call mapit(xmin,xmax,ymin,ymax2,'X Axis'//char(0),
     &'Y Axis'//char(0),'PLOT 3'//char(0),2)
      call gscolr(2,ierr)
      call curvey(xmin,xmax,y1,101,-1,0.3,10)
      call gscolr(3,ierr)
      call curvey(xmin,xmax,y2,101,-2,0.3,5)
      call endplt
      write (6,1)
 1    format('Select a point from the large window with the mouse!')
      call cursor(xxx,yyy,pick)
      write (6,2) pick,xxx,yyy
 2    format('GIN key "',A1,'" at ',f9.2,',',f10.1)
      write (6,11)
 11   format('Type a "q" in any DIGLIB Window to quit!')
      call gdx11maintain(idw,3,'q'//char(0),0)
      call rlsdev
      stop
      end
