      PROGRAM TESTCN
C     PARAMETER NX=31, NY=31
C     PARAMETER NLEVEL=10
      INCLUDE 'GCDCHR.PRM'
      INTEGER*1 LINE(10)
C     DIMENSION Z(NX,NY)
      DIMENSION Z(31,31)
C     DIMENSION CONLEV(NLEVEL)
      DIMENSION CONLEV(10)
C     INTEGER*1 IZ(NX,NY)
      INTEGER*1 IZ(31,31)
C
      DATA NX,NY /31,31/
      DATA NLEVEL /10/
      DATA XMIN,XMAX,YMIN,YMAX /-10.0,10.0,-10.0,10.0/
C
C
C
      WRITE(*,'('' Enter DIGLIB device number >'',$)')
      READ(*,*) IDEV
      CALL DEVSEL(IDEV,4,IERR)
      DX = (XMAX-XMIN)/(NX-1)
      DY = (YMAX-YMIN)/(NY-1)
      ZMIN=1.E30
      ZMAX=-1.E30
      DO 65 I=1,NX
      X = XMIN + (I-1)*DX
      DO 60 J=1,NY
      Y = YMIN + (J-1)*DY
      Z(I,J) = FXY(X,Y,0.0,0.0,15.0,10.0) +
     &   0.9*FXY(X,Y,-5.0,-2.5,10.0,20.0) +
     &   0.75*FXY(X,Y,7.0,3.0,20.0,20.0) +
     &   0.85*FXY(X,Y,2.0,-4.0,15.0,15.0) +
     &   0.85*FXY(X,Y,-2.5,6.5,25.0,35.0)
      ZMIN=AMIN1(ZMIN,Z(I,J))
60    ZMAX=AMAX1(ZMAX,Z(I,J))
65    CONTINUE
      DO 100 J=1,NLEVEL
        CONLEV(J) = ZMIN + J*(ZMAX-ZMIN)/FLOAT(NLEVEL+1)
100     CONTINUE
      CALL BGNPLT
      CALL FULMAP
      CALL MAPIT(XMIN,XMAX,YMIN,YMAX,'X LAB'//CHAR(0),'YLAB'//CHAR(0),
     &'TITLE'//CHAR(0),0)
      CALL CONTOR(Z,NX,IZ,NX,NY,XMIN,XMAX,YMIN,YMAX,NLEVEL,CONLEV)
      CALL ENDPLT
      CALL RLSDEV
      CALL POSTDMP
	PAUSE
      STOP
      END
      FUNCTION FXY(X,Y,XC,YC,XS,YS)
      R = (X-XC)**2/XS + (Y-YC)**2/YS
      FXY = COS(R)*EXP(-R)
      RETURN
      END
