      PROGRAM TEST3D
C     PARAMETER NX=31, NY=31
      INCLUDE 'GCDCHR.PRM'
      INTEGER*1 LINE(10)
C     DIMENSION Z(NX,NY),XYLIM(2,6),CAMLOC(3)
      DIMENSION Z(31,31),XYLIM(2,6),CAMLOC(3)
C     INTEGER*1 IZ(NX,NY)
      INTEGER*1 IZ(31,31)
C
      EQUIVALENCE (XYLIM(1,1),XMIN),(XYLIM(2,1),XMAX),
     &  (XYLIM(1,2),YMIN),(XYLIM(2,2),YMAX),
     &  (XYLIM(1,3),ZMIN),(XYLIM(2,3),ZMAX),
     &  (XYLIM(1,5),WIDTH),(XYLIM(2,5),HEIGHT),
     &  (XYLIM(1,6),XOFF),(XYLIM(2,6),YOFF)
C
      DATA NX /31/
      DATA NY /31/
      DATA XMIN,XMAX,YMIN,YMAX /-10.0,10.0,-10.0,10.0/
C
C
C
      WRITE(*,'('' Enter DIGLIB device number (1 for terminal) >'',$)')
      READ(*,*)IDEV
      DX = (XMAX-XMIN)/(NX-1)
      DY = (YMAX-YMIN)/(NY-1)
      ZMIN=1E30
      ZMAX=-1E30
      DO I=1,NX
      X = XMIN + (I-1)*DX
         DO J=1,NY
            Y = YMIN + (J-1)*DY
            Z(I,J) = FXY(X,Y,0.0,0.0,15.0,10.0) +
     &      0.9*FXY(X,Y,-5.0,-2.5,10.0,20.0) +
     &      0.75*FXY(X,Y,7.0,3.0,20.0,20.0) +
     &      0.85*FXY(X,Y,2.0,-4.0,15.0,15.0) +
     &      0.85*FXY(X,Y,-2.5,6.5,25.0,35.0)
            ZMIN=AMIN1(ZMIN,Z(I,J))
            ZMAX=AMAX1(ZMAX,Z(I,J))
         END DO
      END DO
100   WRITE(*,120)
120   FORMAT(1X,'Relative camara position- R,THETA,PHI ',
     &' (10.,45.,45.,) >',$)
      READ(*,*) CAMLOC(1),THETA,CAMLOC(2)
      IF(CAMLOC(1).LT.0.)STOP
      CAMLOC(3)=90-THETA
C      WRITE(*,131)
C131   FORMAT(' ENTER VISIBILTY PARAMETER "MARPLT": ',$)
C      READ(*,*) MARPLT
      CALL DEVSEL(IDEV,4,IERR)
      XYLIM(1,4)=1.0
      XYLIM(2,4)=1.0
      WIDTH = XLENCM-1.0
      HEIGHT = YLENCM-1.0
      XOFF = 0.5
      YOFF = 0.5
      MARPLT=1
      CALL BGNPLT
      CSIZE = GOODCS(0.3)
      CALL PURJOY(Z,NX,IZ,NX,NY,CAMLOC,XYLIM,'X AXIS'//CHAR(0),
     &   'Y AXIS'//CHAR(0),'Z AXIS'//CHAR(0),CSIZE,MARPLT)
      CALL ENDPLT
      CALL RLSDEV
      CALL POSTDMP
	GO TO 100
      END
      FUNCTION FXY(X,Y,XC,YC,XS,YS)
      R = (X-XC)**2/XS + (Y-YC)**2/YS
      FXY = COS(R)*EXP(-R)
      RETURN
      END
