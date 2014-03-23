C  program to directly call the driver and draw a circle
C   needs only the routines in GDIO and the driver (GDxxxx)
C
      CALL gdrtro(1,4.,DUMMY)
C
      CALL gdrtro(2,X,Y)
COMMENT---- draw a circle
      XSTART=5.
      YSTART=2.5
      CALL gdrtro(3,XSTART, YSTART)
      TWOPI=8.*ATAN(1.)
      RADIUS=3.
      FACTOR=TWOPI/90
      DO 111 I=0,90
      XVAL=XSTART+RADIUS*SIN(FACTOR*I)
      YVAL=YSTART+RADIUS*(1.-COS(FACTOR*I))
      CALL gdrtro(4,XVAL,YVAL)
  111 CONTINUE
      CALL gdrtro(5,X,Y)
      stop
      end
C
      subroutine scopy(a,b)
      character*(*) a(1),b(1)
      l=len(a)
      do 100 i=1,l+1
  100 b(i)=a(i)
      return
      end
