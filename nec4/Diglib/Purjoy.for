      SUBROUTINE PURJOY(Z,IZDIM1,IZ,KX,KY,CAMLOC,XYLIM,
     &   XLAB,YLAB,ZLAB,CSIZE,MARPLT) 
C
CPurpose:   This subroutine will plot a function Z=F(X,Y) as a lined surface.
C     The function must be defined on a regular grid.   This routine will
C     optionally remove hidden lines.
C
CArguments:
C
C  Input
C
C     Z           * Type: real array.
C                 * The function values: Z(I,J)=F(Xi,Yj), where
C                       Xi = XMIN + (i-1)*(XMAX-XMIN)/(KX-1)
C                       Yj = YMIN + (j-1)*(YMAX-YMIN)/(KY-1)
C
C     IZDIM1            * Type: integer constant or variable.
C                 * The first dimension of the Z array - not
C                       necessarily the number of X values.
C
C     IZ          * Type: byte array.
C                 * A working array of bytes dimensioned atleast
C                       KX*KY long.
C
C     KX          * Type: integer constant or variable.
C                 * The number of X values in the Z array.
C                       KX <= IZDIM1 ofcourse.
C
C     KY          * Type: integer constant or variable.
C                 * The number of Y values in the Z array.
C
C     CAMLOC            * Type: real array.
C                 * The relative location of the viewer in space.
C                       The viewer always faces toward the center
C                       of the surface.   
C                       CAMLOC(1) = distance from surface in units
C                        the same as those of Z.
C                       CAMLOC(2) = angle between the viewer and the
C                        X axis in degrees.   Usually, multiples of
C                        30 or 45 degrees are best.
C                       CAMLOC(3) = angle between the viewer and the
C                        XY plane located at Z=(ZMIN+ZMAX)/2 in
C                        degrees.   Thus 90 degrees is directly above
C                        the surface - an unexciting picture!   Usually
C                        the angle is selected near 45 degrees.
C
C     XYLIM       * Type: real two dimensional array dimensioned (2,6).
C                 * General parameters:
C                       XYLIM(1,1) = XMIN ==> the minimum value of X.
C                       XYLIM(2,1) = XMAX ==> the maximum value of X.
C                       XYLIM(1,2) = YMIN ==> the minimum value of Y.
C                       XYLIM(2,2) = YMAX ==> the maximum value of Y.
C                        Note: Z(I,J) = F(Xi,Yj) where:
C                          Xi = XMIN + (i-1)*(XMAX-XMIN)/(KX-1)
C                          Yj = YMIN + (j-1)*(YMAX-YMIN)/(KY-1)
C                       XYLIM(1,3) = ZMIN ==> the minimum value of Z.
C                       XYLIM(2,3) = ZMAX ==> the maximum value of Z.
C                        These Z values define the range of Z values
C                        to fit on the screen.   It is strongly
C                        advised that ZMIN and ZMAX bound Z(I,J).
C                       XYLIM(1,4) = X/Z axis length ratio.   If this
C                        parameter is 0, then X and Z are assumed to
C                        have the same units, so their relative
C                        lengths will be in proportion to their
C                        ranges.   If this parameter is nonzero, then
C                        the X axis will be XYLIM(1,4) times as long
C                        as the Z axis.
C                       XYLIM(2,4) = Y/Z axis length ratio.   Same as
C                        XYLIM(1,4), but for Y axis.
C                       XYLIM(1,5) = plot width in virtual coordinates
C                       XYLIM(2,5) = plot height in virtual coord.
C                        Note: The plot is expanded/contracted until
C                        it all fits within the box defined by
C                        XYLIM(1,5) and XYLIM(2,5).
C                       XYLIM(1,6) = virtual X coord. of the lower
C                        left corner of the plot box.
C                       XYLIM(2,6) = virtual Y coord. of the lower
C                        left corner of the box.
C
C     XLAB        * Type: string constant or variable.
C                 * The X axis lable.
C
C     YLAB        * Type: string constant or variable.
C                 * The Y axis lable.
C
C     ZLAB        * Type: string constant or variable.
C                 * The Z axis lable.
C
C     CSIZE       * Type: real constant or variable.
C                 * The character size in virtual coord. for the tick
C                       mark lables and the axis lables.
C
C     MARPLT            * Type: integer constant or variable.
C                 * Hidden line flag:
C                   0 ==> draw all lines, hidden or not.
C                   1 ==> suppress all lines hidden by the surface, but
C                       display both the top and bottom of the surface
C                   3 ==> suppress all lines hidden by the surface, and
C                       all lines showing the bottom of the surface.
C                   Add 4 to MARPLT if you do not want the axes nor the
C                    ticks labled.   This is useful on small plots.
C
      INCLUDE 'GCDCHR.PRM'
      DIMENSION Z(IZDIM1,KY), CAMLOC(3), XYLIM(2,6)
      INTEGER*1 IZ(KX,KY)
	CHARACTER XLAB*(*),YLAB*(*),ZLAB*(*)
C 
C     COMMON STORAGE DESCRIPTOR
      COMMON/COMDP/XMIN,XMAX,YMIN,YMAX,ZMIN,ZMAX,AXISR(2),PLOTX, 
     &   PLOTY,PLTORG(2),CAMXYZ(3),MX,NY,FMX,FNY,CAMWKG(6),XORG(3), 
     &   GX(3),FX(2),KSCALE,ZORG,CENTER(2),PQLMT,
     &   AMTX(3,3),FOCALL
      DIMENSION LIMIT(2),FLIM(2)
      EQUIVALENCE(U,CAMXYZ(1)),(V,CAMXYZ(2)),(W,CAMXYZ(3)),
     &   (MX,LIMIT(1)),(FMX,FLIM(1))
C     END CDE
C 
      LOGICAL*1 LSOLID
      COMMON /COMDP1/ LSOLID
C 
C     LOCAL CDE 
      DIMENSION XMINA(2,6)
      LOGICAL*1 LLABLE
      EQUIVALENCE(XMIN,XMINA(1,1)) 
      COMMON /DBASE/VX,VY,VOLDX,VOLDY,CXSIZE,CYSIZE
C 
D     TYPE 800, KX,KY,XYLIM
D800  FORMAT(' DEBUG-- KX,KY = ',2I5/' XYLIM='6(/1X,2E14.6))
C     PICK UP XY LIMITS, BOX SIZES, ETC. 
      DO 9 J=1,6 
      XMINA(1,J) = XYLIM(1,J) 
9     XMINA(2,J) = XYLIM(2,J) 
C
C     NOW SET UP LIMITS IF AXIS RATIOS ARE REQUESTED
C
      IF (AXISR(1) .EQ. 0.0) GO TO 260
      DO 255 I=1,2
255   XMINA(1,I)=AXISR(I)*ZMIN
260   IF (AXISR(2) .EQ. 0.0) GO TO 266
      DO 265 I=1,2
265   XMINA(2,I)=AXISR(I)*ZMAX
C     SET TOLERANCE FOR VISIBLE TESTS = HALF PLOTTER STEP SIZE 
266   PQLMT = AMIN1(0.5/XRES,0.5/YRES)
D     TYPE 504, XMINA
C
C     CONVERT R, PHI, THETA TO DX, DY, DZ
C
      RAD = 3.14159/180.0
      PHI = CAMLOC(2)*RAD
      THETA = CAMLOC(3)*RAD
      CAMWKG(1)=CAMLOC(1)*COS(PHI)*COS(THETA)
      CAMWKG(2)=CAMLOC(1)*SIN(PHI)*COS(THETA)
      CAMWKG(3)=CAMLOC(1)*SIN(THETA)
C     PICK UP CAMERA DATA 
      DO 3 J=1,3
      CAMWKG(J+3)=(XMINA(1,J)+XMINA(2,J))/2.0
3     CAMWKG(J)=CAMWKG(J+3)+CAMWKG(J)
      CALL CAMROT
      MX=KX 
      FMX=FLOAT(KX) 
      NY=KY 
      FNY=FLOAT(NY) 
C     OPTION FOR SCALING Z 
C     SCALE FACTORS TO CONVERT USER VALUES TO INDICES 
      GX(1) = (XMAX-XMIN)/(FMX-1.0) 
      GX(2) = (YMAX-YMIN)/(FNY-1.0) 
C 
C     FIND Z SCALE FACTOR 
C 
      GX(3)=1.0
      ZORG=0.0
C 
C     FIND SCALE FACTORS FOR PLOT 
C 
      CYSIZE = CSIZE
      call gssetc(csize,0.0)
      CXSIZE = GSLENC('0'//CHAR(0))
      XA=1.0E30 
      XB=-1.0E30 
      YA=1.0E30 
      YB=-1.0E30 
      IF (CAMWKG(3) .LT. CAMWKG(6)) GO TO 16
      DX=FLOAT(MX-1)/20.0
      DY=FLOAT(NY-1)/20.0
      IF=MX
      XZ = XMAX
      IB=1
      JF=NY
      YZ = YMIN
      JB=1
      IF (CAMWKG(1) .GE. CAMWKG(4)) GO TO 120
      IF=1
      XZ = XMIN
      IB=MX
      DX=-DX
120   IF (CAMWKG(2) .GE. CAMWKG(5)) GO TO 130
      JF=1
      YZ = YMAX
      JB=NY
      DY=-DY
130   FRX=IF
      BKX=IB
      FRY=JF
      BKY=JB
      VX = XMIN + (FRX-1.0)*GX(1) - CAMWKG(1)
      VY = YMIN + (BKY-1.0-DY)*GX(2) - CAMWKG(2)
      CALL EXTRMA(VX,VY,ZMAX-CAMWKG(3),XA,XB,YA,YB,IERR)
      IF (IERR .NE. 0) GO TO 50
      TEMP = ZMIN - CAMWKG(3)
      CALL EXTRMA(VX,VY,TEMP,XA,XB,YA,YB,IERR)
      IF (IERR .NE. 0) GO TO 50
      VY = YMIN + (FRY-1.0+DY)*GX(2) - CAMWKG(2)
      CALL EXTRMA(VX,VY,TEMP,XA,XB,YA,YB,IERR)
      IF (IERR .NE. 0) GO TO 50
      CALL EXTRMA(XMIN+(BKX-1.0)*GX(1)-CAMWKG(1),VY,TEMP,
     &   XA,XB,YA,YB,IERR)
      IF (IERR .NE. 0) GO TO 50
      VX = VX + DX*GX(1)
      CALL EXTRMA(VX,YMIN+(BKY-1.0)*GX(2)-CAMWKG(2),TEMP,
     &   XA,XB,YA,YB,IERR)
      IF (IERR .NE. 0) GO TO 50
      CALL EXTRMA(VX,VY-DY*GX(2),TEMP,XA,XB,YA,YB,IERR)
      IF (IERR .NE. 0) GO TO 50
16    DO 20 J=1,NY
      VY = YMIN + (J-1)*GX(2) - CAMWKG(2)
      DO 20 I=1,MX
      VX = XMIN + (I-1)*GX(1) - CAMWKG(1)
      CALL EXTRMA(VX,VY,Z(I,J)-CAMWKG(3),XA,XB,YA,YB,IERR)
      IF (IERR .NE. 0) GO TO 50
20    CONTINUE
C
C     SCALE X AND Y RANGES TO FIT ON PLOT
C
      TEMP = (2.0*tickln()+0.5)*CXSIZE
      LLABLE = .TRUE.
      IF ((MARPLT .AND. 4) .NE. 0) LLABLE = .FALSE.
      IF (.NOT. LLABLE) TEMP = 0.0
      FX(1) = (PLOTX-TEMP)/(XB-XA) 
      TEMP = 2.0*CYSIZE
      IF (.NOT. LLABLE) TEMP = 0.0
      FX(2) = (PLOTY-TEMP)/(YB-YA) 
C     CHOOSE MINIMUM FOCAL LENGTH OF THE TWO 
      FOCALL = AMIN1(FX(1),FX(2)) 
C     SET X,Y ORIGINS (BEFORE SCALING TO FOCAL LGTH) 
      XORG(1) = XA 
      XORG(2) = YA 
C     SIZES IN X,Y (NOT INCLUDING OUT-OF-BOX POIINTS THAT GET IN PIC) 
      XB = (XB-XA)*FOCALL 
      YB = (YB-YA)*FOCALL 
C     CENTER FOR NOW, BUT LATER MAKE OPTIONAL 
      CENTER(1) = (PLOTX-XB)/2.0 
      CENTER(2) = (PLOTY-YB)/2.0 
D     TYPE 602, FX,XB,YB,PLOTX,PLOTY,CENTER 
C 
C     CAMERA LOCATION EXPRESSED AS XY INDICES 
      U = 1.0+(FMX-1.0)*(CAMWKG(1)-XMIN)/(XMAX-XMIN) 
      V = 1.0+(FNY-1.0)*(CAMWKG(2)-YMIN)/(YMAX-YMIN) 
C     FOR VISIBILITY CHECKING, SCALE CAMERA Z COORDINATE OPPOSITE TO THE
C     WAY Z WILL BE SCALED FOR PLOTTING - RATHER THAN SCALING ALL THE 
C     Z-S ON THE SURFACE WHEN CHECKING. 
      W = (CAMWKG(3)-ZORG)/GX(3) 
C     CALCULATE VISIBILITIES 
C 
C     IF LSB OF MARPLT IS SET, SUPRESS ALL HIDDEN LINES
      IF ((MARPLT .AND. 1) .NE. 0) GO TO 7
      DO 8 K = 1,NY 
      DO 8 J = 1,MX 
8     IZ(J,K)=0 
      GO TO 40 
7     LSOLID = .FALSE.
      IF ((MARPLT .AND. 2) .NE. 0) LSOLID = .TRUE.
      DO 1 K = 1,NY 
      ETA = FLOAT(K) 
      DO 1 J =1,MX 
       L = IVIS(FLOAT(J),ETA,Z(J,K),Z,IZDIM1)+1 
1     IZ(J,K)=L 
C 
C     NOW PLOT 
40    CALL DRAW3D(Z,IZDIM1,IZ,KX) 
      IF (CAMWKG(3) .LT. CAMWKG(6)) GO TO 45
      CALL GSSETC(CYSIZE,0.0)
      CALL XYPRM(FRX,BKY,ZMAX,0)
      VOLDX=VX
      VOLDY=VY
      VXT=VX
      VYT=VY
      CALL XYPRM(FRX,BKY-DY,ZMAX,1)
      IF (LLABLE) CALL TICKL(ZMAX,-0.5)
      CALL GSMOVE(VXT,VYT)
      CALL XYPRM(FRX,BKY,ZMIN,1)
      VOLDX=VX
      VOLDY=VY
      CALL XYPRM(FRX,BKY-DY,ZMIN,1)
      IF (.NOT. LLABLE) GO TO 140
      CALL TICKL(ZMIN,0.25)
      TEMP = AMAX1(VOLDX,VXT)+1.5*CYSIZE
      IF (VX .LT. VOLDX) TEMP = AMIN1(VOLDX,VXT)-0.5*CYSIZE
      CALL GSMOVE(TEMP,(VOLDY+VYT-GSLENC(ZLAB))/2.0)
      CALL GSSETC(CYSIZE,90.0)
      CALL GSPSTC(ZLAB)
      CALL GSSETC(CYSIZE,0.0)
140   CALL GSMOVE(VOLDX,VOLDY)
      CALL XYPRM(FRX+DX,BKY,ZMIN,1)
      IF (LLABLE) CALL TICKL(XYLIM(1+JB/NY,2),-0.5)
      CALL GSMOVE(VOLDX,VOLDY)
      CALL XYPRM(FRX,FRY+DY,ZMIN,1)
      IF (.NOT. LLABLE) GO TO 150
      CALL TICKL(XYLIM(1+IF/MX,1),-0.5)
      TEMP = GSLENC(YLAB)+0.25*cxsize
      IF (VX .LT. VOLDX) TEMP = -0.5*CXSIZE
      CALL GSMOVE((VX+VOLDX)/2.0-TEMP,(VY+VOLDY)/2.0-CYSIZE)
      CALL GSPSTC(YLAB)
150   CALL XYPRM(FRX,FRY,Z(IF,JF),-1)
      CALL GSMOVE(VX,VY)
      CALL XYPRM(FRX,FRY,ZMIN,1)
      VOLDX=VX
      VOLDY=VY
      CALL XYPRM(FRX+DX,FRY,ZMIN,1)
      IF (LLABLE) CALL TICKL(XYLIM(1+JF/NY,2),-0.5)
      CALL GSMOVE(VOLDX,VOLDY)
      CALL XYPRM(BKX,FRY,ZMIN,1)
      IF (.NOT. LLABLE) GO TO 160
      TEMP = GSLENC(XLAB)+0.25*cxsize
      IF (VX .GT. VOLDX) TEMP = -0.5*CXSIZE
      CALL GSMOVE((VX+VOLDX)/2.0-TEMP,(VY+VOLDY)/2.0-CYSIZE)
      CALL GSPSTC(XLAB)
160   VOLDX=VX
      VOLDY=VY
      CALL GSMOVE(VX,VY)
      CALL XYPRM(BKX,FRY+DY,ZMIN,1)
      IF (LLABLE) CALL TICKL(XYLIM(1+IB/MX,1),-0.5)
      CALL GSMOVE(VOLDX,VOLDY)
      CALL XYPRM(BKX,FRY,Z(IB,JF),1)
45      RETURN 
C 
C     POINT ON THE SURFACE IS BEHIND THE CAMERA. QUIT. 
C 
  50  TYPE 603 
      RETURN 
C 
C     Z IS A FLAT PLANE, DO NOT DRAW (FOR NOW) 
C 
  60  TYPE 604 
      RETURN 
C 
D 503 FORMAT(' Z MULTIPLIER',E15.6,', Z ORIGIN SHIFT',E15.6) 
D504  FORMAT('0X LIMITS',2F10.3/' Y LIMITS',2F10.3/' Z LIMITS',2F10.3/ 
D    &' Z CUTOFF',2E15.6/ 
D    &                 ' PLOT SIZE',2F10.3/' PLOT ORIGIN',2F10.3) 
D 602 FORMAT('0FOCAL LENGTHS TO FILL X,Y PLOTTER SPACE',2E15.6, 
D    & ', LESSER VALUE CHOSEN'/'0PICTURE SIZE IN X,Y =',2F9.3, 
D    & ', REQUESTED SIZES',2F9.3/' CENTERS = ',2G14.7)
  603 FORMAT('0PART OF SURFACE IS BEHIND THE CAMERA, UNABLE TO PLOT. SOR
     &RY.') 
  604 FORMAT('0FUNCTION IS LEVEL PLANE, NO USE PLOTTING IT') 
      END 
      SUBROUTINE EXTRMA(XV,YV,ZV,XA,XB,YA,YB,IERR)
C 
C     COMMON STORAGE DESCRIPTOR
      COMMON/COMDP/XMIN,XMAX,YMIN,YMAX,ZMIN,ZMAX,AXISR(2),PLOTX, 
     &   PLOTY,PLTORG(2),CAMXYZ(3),MX,NY,FMX,FNY,CAMWKG(6),XORG(3), 
     &   GX(3),FX(2),KSCALE,ZORG,CENTER(2),PQLMT,
     &   AMTX(3,3),FOCALL
      DIMENSION LIMIT(2),FLIM(2)
      EQUIVALENCE(U,CAMXYZ(1)),(V,CAMXYZ(2)),(W,CAMXYZ(3)),
     &   (MX,LIMIT(1)),(FMX,FLIM(1))
C     END CDE
C 
      DIMENSION XS(3), XC(3)
C
C
      XS(1) = XV
      XS(2) = YV
      XS(3) = ZV
      CALL ROTATE(XS,AMTX,XC) 
C     QUIT IF POINT IS BEHIND CAMERA 
      IF(XC(3).LE.0.0) GO TO 50 
      XC(1) = XC(1)/XC(3) 
      XC(2) = XC(2)/XC(3) 
      XA = AMIN1(XA,XC(1)) 
      XB = AMAX1(XB,XC(1)) 
      YA = AMIN1(YA,XC(2)) 
      YB = AMAX1(YB,XC(2)) 
      IERR = 0
      RETURN
50    IERR = -1
      RETURN
      END
      SUBROUTINE XYPRM(X,Y,ZETA,ILINE)
C
C     COMMON STORAGE DESCRIPTOR
      COMMON/COMDP/XMIN,XMAX,YMIN,YMAX,ZMIN,ZMAX,AXISR(2),PLOTX, 
     &   PLOTY,PLTORG(2),CAMXYZ(3),MX,NY,FMX,FNY,CAMWKG(6),XORG(3), 
     &   GX(3),FX(2),KSCALE,ZORG,CENTER(2),PQLMT,
     &   AMTX(3,3),FOCALL
      DIMENSION LIMIT(2),FLIM(2)
      EQUIVALENCE(U,CAMXYZ(1)),(V,CAMXYZ(2)),(W,CAMXYZ(3)),
     &   (MX,LIMIT(1)),(FMX,FLIM(1))
C     END CDE
C 
      COMMON /DBASE/VX,VY,VOLDX,VOLDY,CXSIZE,CYSIZE
      DIMENSION XS(3),XC(3)
      XS(1)=XMIN+(X-1.0)*GX(1)-CAMWKG(1)
      XS(2)=YMIN+(Y-1.0)*GX(2)-CAMWKG(2)
      XS(3)=ZORG + ZETA*GX(3)-CAMWKG(3)
      CALL ROTATE(XS,AMTX,XC)
      VX=(XC(1)/XC(3)-XORG(1))*FOCALL+PLTORG(1)+CENTER(1)
      VY=(XC(2)/XC(3)-XORG(2))*FOCALL+PLTORG(2)+CENTER(2)
      IF (ILINE) 30, 20, 10
10    CALL GSDRAW(VX,VY)
      GO TO 30
20    CALL GSMOVE(VX,VY)
30    RETURN
      END
      function tickln()
      tickln = 9.0            !maximum number of characters in a tick lable.
      return
      end

      SUBROUTINE TICKL(ANUM,UP)
      COMMON /DBASE/VX,VY,VOLDX,VOLDY,CXSIZE,CYSIZE
      INTEGER*1 NUMBR(10)
	CHARACTER*10 NUMCHAR
	EQUIVALENCE (NUMCHAR,NUMBR)
      WRITE(NUMCHAR,100) ANUM
100   FORMAT(G9.3)
      numbr(10) = 0
C      call trim(numbr)
      call strpbl(numbr)
      TEMP = GSLENS(numbr) + 0.25*cxsize
      IF (VX .GT. VOLDX) TEMP = -0.5*CXSIZE
      CALL GSMOVE(VX-TEMP,VY+UP*CYSIZE)
      CALL GSPSTR(NUMBR)
      RETURN
      END
      SUBROUTINE CAMROT 
C     MAKE UP CAMERA ROTATION MATRIX 
C 
C     ROTATION IS DONE SO THAT Z PRIME AXIS IS DIRECTED FROM THE
C     CAMERA TO THE AIMING POINT.   NOTE ALSO THAT THE PRIMED
C     COORDINATE SYSTEM IS LEFT-HANDED IF EPSLON=-1.
C     THIS IS SO THAT THE PICTURE COMES OUT RIGHT WHEN PROJECTED
C     ON THE PRIMED COORDINATE SYSTEM.
C 
C     COMMON STORAGE DESCRIPTOR
      COMMON/COMDP/XMIN,XMAX,YMIN,YMAX,ZMIN,ZMAX,AXISR(2),PLOTX, 
     &   PLOTY,PLTORG(2),CAMXYZ(3),MX,NY,FMX,FNY,CAMWKG(6),XORG(3), 
     &   GX(3),FX(2),KSCALE,ZORG,CENTER(2),PQLMT,
     &   AMTX(3,3),FOCALL
      DIMENSION LIMIT(2),FLIM(2)
      EQUIVALENCE(U,CAMXYZ(1)),(V,CAMXYZ(2)),(W,CAMXYZ(3)),
     &   (MX,LIMIT(1)),(FMX,FLIM(1))
C     END CDE
C 
C     LOCAL CDE 
      DIMENSION AU(3),AV(3),AW(3) 
C     HANDEDNESS PARAMETER, -1 FOR LEFT-HANDED USUALLY 
      DATA EPSLON/-1.0/ 
C 
      S = 0.0 
      DO 1 J = 1,3 
      AV(J) = 0.0 
      AW(J) = 0.0 
      AU(J) = CAMWKG(J+3)-CAMWKG(J) 
1     S = S + AU(J)**2 
      S = SQRT(S) 
      DO 2 J = 1,3 
2     AU(J) = AU(J)/S 
      SIGMA = SQRT(AU(1)**2 + AU(2)**2) 
C     PREPARE LOOKING STRAIGHT UP OR DOWN 
      AV(1) = 1.0 
      AW(2) = -EPSLON 
      IF(AU(3) .GT. 0.0) AW(2) = -AW(2) 
      IF(SIGMA .LT. 1.0E-3) GO TO 4 
C     X AXIS 
      AV(1) = AU(2)/SIGMA 
      AV(2) = -AU(1)/SIGMA 
      AV(3) = 0.0 
C     Y AXIS 
      AW(1) = EPSLON*AU(1)*AU(3)/SIGMA 
      AW(2) = EPSLON*AU(2)*AU(3)/SIGMA 
      AW(3) = -EPSLON*SIGMA 
C     TRANSFER AXIS DIRECTION COSINES TO ROTATION MATRIX ROWS 
4     DO 3 J = 1,3 
      AMTX(1,J) = AV(J) 
      AMTX(2,J) = AW(J) 
3     AMTX(3,J) = AU(J) 
      RETURN 
      END 
      SUBROUTINE DRAWPQ(Z,IZDIM1)
C     DRAW VISIBLE PART OF SEGMENT PC-QC
C
      DIMENSION Z(IZDIM1,2)
C 
C     COMMON STORAGE DESCRIPTOR
      COMMON/COMDP/XMIN,XMAX,YMIN,YMAX,ZMIN,ZMAX,AXISR(2),PLOTX, 
     &   PLOTY,PLTORG(2),CAMXYZ(3),MX,NY,FMX,FNY,CAMWKG(6),XORG(3), 
     &   GX(3),FX(2),KSCALE,ZORG,CENTER(2),PQLMT,
     &   AMTX(3,3),FOCALL
      DIMENSION LIMIT(2),FLIM(2)
      EQUIVALENCE(U,CAMXYZ(1)),(V,CAMXYZ(2)),(W,CAMXYZ(3)),
     &   (MX,LIMIT(1)),(FMX,FLIM(1))
C     END CDE
C 
C 
C     CDE PACKAGE FOR DRAW3D,DRAWPQ
      COMMON/COMDPA/PC(3),QC(3),P(3),Q(3),ENDA(6),ENDB(6),OLDQ(3), 
     &   PW(3),QW(3),T(6),PK(3),QK(3),PHIP,PHIQ,PHIA,IBEAM,ICOLOR
      INTEGER PHIP,PHIQ,PHIA 
C     END OF CDE PACKAGE
C
      P(1) = PC(1) 
      P(2) = PC(2) 
      P(3) = PC(3) 
      Q(1) = QC(1) 
      Q(2) = QC(2) 
      Q(3) = QC(3) 
C     TEST IF P VISIBLE 
2     IF(PHIP .EQ. 0) GO TO 30 
C     YES, TEST Q 
7     IF(PHIP*PHIQ)10,4,3 
C     BOTH VISIBLE   SEGMENT DRAWABLE, PLOT   EXIT 
3     KGOTO = 0 
      GO TO 300 
C     Q IS INVISIBLE, FIND LAST VISIBLE POINT ON SEGMENT PQ 
4     JGOTO = 1 
      GO TO 200 
C     GIVE UP IF NOT FOUND IN MAXCUT1 BISECTIONS 
5     IF(KFLAG .NE. 0) GO TO 6 
C     NEXT POINT 
      IBEAM = 0 
      RETURN 
C     POINT FOUND 
6     Q(1) = ENDA(1) 
      Q(2) = ENDA(2) 
      Q(3) = ENDA(3) 
      GO TO 3 
C 
C     GAP IN SEGMENT, FIND LAST POINT TO CONNECT P. 
10    JGOTO = 2 
      GO TO 200 
C     IF NOT FOUND (CANNOT FIND POINT WITH SAME VISIBILITY FN). TRY 2ND 
11    IF(KFLAG .EQ. 0) GO TO 15 
C     SAVE OLD Q, RESET POINT   PLOT THIS PIECE. 
      OLDQ(1) = Q(1) 
      OLDQ(2) = Q(2) 
      OLDQ(3) = Q(3) 
      Q(1) = ENDA(1) 
      Q(2) = ENDA(2) 
      Q(3) = ENDA(3) 
C     DRAW FIRST PART OF SEGMENT AND COME BACK HERE 
      KGOTO = 2 
      GO TO 300 
C     RESTORE Q   FIND LOWER LIMIT OF UPPER SEGMENT. 
C     LIMITS FOR SEARCH 
12    P(1) = Q(1) 
      P(2) = Q(2) 
      P(3) = Q(3) 
      Q(1) = OLDQ(1) 
      Q(2) = OLDQ(2) 
      Q(3) = OLDQ(3) 
C     BEAM OFF FIRST 
15    IBEAM = 0 
      JGOTO = 3 
      GO TO 201 
C     IF SEGMENT TOO SHORT, GIVE UP. 
13    IF(KFLAG .EQ. 0) GO TO 50 
C     LOWER END NOW NEWLY FOUND POINT. 
14    P(1) = ENDA(1) 
      P(2) = ENDA(2) 
      P(3) = ENDA(3) 
      GO TO 3 
C     P INVISIBLE, CHECK Q. IF INVISIBLE, ADVANCE. 
30    IBEAM = 0 
      IF(PHIQ .EQ. 0) GO TO 50 
C     FIND P 
      JGOTO = 4 
      GO TO 201 
C     IF NO POINT, GIVE UP. 
31    IF(KFLAG) 14,50,14 
C 
C 
C     P VISIBLE, Q INVISIBLE, FIND Q. 
C     ENDB = INVISIBLE END OF INTERVAL, ENDA = VISIBLE 
200   ENDB(1) = Q(1) 
      ENDB(2) = Q(2) 
      ENDB(3) = Q(3) 
      ENDA(1) = P(1) 
      ENDA(2) = P(2) 
      ENDA(3) = P(3) 
C     REQUIRED IVIS FUNCTION 
C     IN CASE OF GAP IN SEGMENT, CONSIDER POINT VISIBLE IF ITS VISIB. 
C     FUNCTION MATCHES THIS ONE AND UPDATE ENDA, ELSE ENDB. 
      PHIA = PHIP 
      GO TO 205 
C     P INVISIBLE, Q VISIBLE. FIND P. 
201   ENDB(1) = P(1) 
      ENDB(2) = P(2) 
      ENDB(3) = P(3) 
      ENDA(1) = Q(1) 
      ENDA(2) = Q(2) 
      ENDA(3) = Q(3) 
      PHIA = PHIQ 
205   KFLAG = 0 
C     GET PROJECTED LENGTH OF SEGMENT 
      PK(1) = XMIN + (ENDA(1)-1.0)*GX(1) - CAMWKG(1) 
      PK(2) = YMIN + (ENDA(2)-1.0)*GX(2) - CAMWKG(2) 
      PK(3) = ENDA(3)*GX(3) + ZORG - CAMWKG(3) 
      CALL ROTATE(PK,AMTX,ENDA(4)) 
      PK(1) = XMIN + (ENDB(1)-1.0)*GX(1) - CAMWKG(1) 
      PK(2) = YMIN + (ENDB(2)-1.0)*GX(2) - CAMWKG(2) 
      PK(3) = ENDB(3)*GX(3) + ZORG - CAMWKG(3) 
      CALL ROTATE(PK,AMTX,ENDB(4)) 
C     NEXT STEP 
210   T(1) = (ENDA(1)+ENDB(1))/2.0 
      T(2) = (ENDA(2)+ENDB(2))/2.0 
      T(3) = (ENDA(3)+ENDB(3))/2.0 
      T(4) = (ENDA(4)+ENDB(4))/2.0 
      T(5) = (ENDA(5)+ENDB(5))/2.0 
      T(6) = (ENDA(6)+ENDB(6))/2.0 
      MFLAG = IVIS(T(1),T(2),T(3),Z,IZDIM1) 
      IF(MFLAG .EQ. PHIA) GO TO 220 
C     NOT VISIBLE, RESET INVISIBLE END. 
      ENDB(1) = T(1) 
      ENDB(2) = T(2) 
      ENDB(3) = T(3) 
      ENDB(4) = T(4) 
      ENDB(5) = T(5) 
      ENDB(6) = T(6) 
C     CHECK SEGMENT LENGTH (USE MAX OF X, Y DIFFERENCES) 
216   SL = FOCALL*AMAX1(ABS(ENDA(4)/ENDA(6)-ENDB(4)/ENDB(6)), 
     &    ABS(ENDA(5)/ENDA(6)-ENDB(5)/ENDB(6))) 
      IF(SL .GE. PQLMT) GO TO 210 
      GO TO (5,11,13,31), JGOTO 
C     RECORD VISIBLE, UPDATE ENDA 
220   KFLAG = MFLAG 
      ENDA(1) = T(1) 
      ENDA(2) = T(2) 
      ENDA(3) = T(3) 
      ENDA(4) = T(4) 
      ENDA(5) = T(5) 
      ENDA(6) = T(6) 
      GO TO 216 
C 
C 
C     DRAW P TO Q 
C 
C     IF BEAM IS ON, JUST MOVE IT TO Q. 
300   IF(IBEAM .GT. 0) GO TO 310 
C     MOVE TO P, BEAM OFF. 
      PK(1) = XMIN + (P(1)-1.0)*GX(1) - CAMWKG(1) 
      PK(2) = YMIN + (P(2)-1.0)*GX(2) - CAMWKG(2) 
      PK(3) = P(3)*GX(3) + ZORG - CAMWKG(3) 
      CALL ROTATE(PK,AMTX,PW) 
      PW(1) = (PW(1)/PW(3)-XORG(1))*FOCALL + PLTORG(1) + CENTER(1) 
      PW(2) = (PW(2)/PW(3)-XORG(2))*FOCALL + PLTORG(2) + CENTER(2) 
      CALL GSMOVE(PW(1),PW(2))
C     MOVE TO Q, BEAM ON. BEAM IS LEFT AND AT POINT Q. 
310   QK(1) = XMIN + (Q(1)-1.0)*GX(1) - CAMWKG(1) 
      QK(2) = YMIN + (Q(2)-1.0)*GX(2) - CAMWKG(2) 
      QK(3) = Q(3)*GX(3) + ZORG - CAMWKG(3) 
      CALL ROTATE(QK,AMTX,QW) 
      QW(1) = (QW(1)/QW(3)-XORG(1))*FOCALL + PLTORG(1) + CENTER(1) 
      QW(2) = (QW(2)/QW(3)-XORG(2))*FOCALL + PLTORG(2) + CENTER(2) 
      CALL GSDRAW(QW(1),QW(2))
      IBEAM = 1 
      IF(KGOTO .NE. 0) GO TO 12 
C 
50    RETURN 
      END 
      SUBROUTINE DRAW3D(Z,IZDIM1,IZ,KX)
C     DRAW PLOT 
C
      DIMENSION Z(IZDIM1,2)
      INTEGER*1 IZ(KX,2)
C 
C     COMMON STORAGE DESCRIPTOR
      COMMON/COMDP/XMIN,XMAX,YMIN,YMAX,ZMIN,ZMAX,AXISR(2),PLOTX, 
     &   PLOTY,PLTORG(2),CAMXYZ(3),MX,NY,FMX,FNY,CAMWKG(6),XORG(3), 
     &   GX(3),FX(2),KSCALE,ZORG,CENTER(2),PQLMT,
     &   AMTX(3,3),FOCALL
      DIMENSION LIMIT(2),FLIM(2)
      EQUIVALENCE(U,CAMXYZ(1)),(V,CAMXYZ(2)),(W,CAMXYZ(3)),
     &   (MX,LIMIT(1)),(FMX,FLIM(1))
C     END CDE
C 
C
C     CDE PACKAGE FOR DRAW3D,DRAWPQ
      COMMON/COMDPA/PC(3),QC(3),P(3),Q(3),ENDA(6),ENDB(6),OLDQ(3), 
     &   PW(3),QW(3),T(6),PK(3),QK(3),PHIP,PHIQ,PHIA,IBEAM,ICOLOR
      INTEGER PHIP,PHIQ,PHIA 
C     END OF CDE PACKAGE
C     END OF CDE PACKAGE 
C 
C     SAVE Z DIMENSION IN COMMON TO PASS ALONG THROUGH DRAWPQ TO IVIS 
C     SCAN ALONG X FIRST AT CONSTANT Y 
C 
C     INDEX OF COORDINATE BEING STEPPED ALONG A LINE 
      KSCAN = 1 
C     INDEX OF COORDINATE BEING HELD FIXED 
      KFIX = 2 
C     SET FIXED COORDINATE   INCREMENT 
      PC(KFIX) = 1.0 
      DELFIX = 1.0 
C     SET ROVING COORDINATE   INCREMENT INITIALLY 
      DELSCN = 1.0 
      QC(KSCAN) = 1.0 
C     BEGIN SCANNING A LINE 
101   QC(KFIX) = PC(KFIX) 
      IBEAM = 0 
C     NEXT POINT IN LINE SCAN 
102   PC(KSCAN) = QC(KSCAN) 
      QC(KSCAN) = PC(KSCAN) + DELSCN 
C     WORKING INDICES 
      JPC = IFIX(PC(1)) 
      KPC = IFIX(PC(2)) 
      JQC = IFIX(QC(1)) 
      KQC = IFIX(QC(2)) 
C     PHI FUNCTIONS 
      PC(3)=Z(JPC,KPC) 
      QC(3)=Z(JQC,KQC) 
      PHIP=IZ(JPC,KPC)-1 
      PHIQ=IZ(JQC,KQC)-1 
200   CALL DRAWPQ(Z,IZDIM1) 
C     TEST IF LINE IS DONE 
      IF((QC(KSCAN)-1.0)*(QC(KSCAN)-FLIM(KSCAN)) .LT. 0.0) GO TO 102 
C     LINE DONE. ADVANCE FIXED COORDINATE. 
      PC(KFIX) = PC(KFIX) + DELFIX 
C     TEST IF FIXED COORDINATE NOW OFF LIMITS 
      IF((PC(KFIX)-1.0)*(PC(KFIX)-FLIM(KFIX)) .GT. 0.0) GO TO 55 
C     FLIP INCREMENT. SCAN BEGINS AT QC OF PREVIOUS LINE. 
      DELSCN = -DELSCN 
      GO TO 101 
C     TEST IF WE HAVE DONE Y SCAN YET. 
55    IF(KSCAN .EQ. 2) RETURN 
C     NO, SCAN Y DIRECTION AT FIXED X. 
      KSCAN = 2 
      KFIX = 1 
C     START FIXED X AT X OF LAST TRAVERSE 
      PC(1) = QC(1) 
C     THEN STEP X IN OPPOSITE DIRECTION 
      DELFIX = -DELSCN 
C     WE ENDED UP AT MAX. Y, SO FIRST Y SCAN GOES BACKWARDS 
      DELSCN = -1.0 
C     INITIAL Y FOR FIRST LINE 
      QC(2) = FNY 
      GO TO 101 
      END 
      FUNCTION IVIS(XI,ETA,ZETA,Z,IZDIM1)
C                CORRECTED VERSION, 24FEB69 
C     DETERMINE IF POINT XI, ETA IS VISIBLE 
C     POINT IS GIVEN BY XI, ETA, ZIN 
C     AND VISIBILITY IS TESTED WITH RESPECT TO SURFACE Z(X,Y) 
C      XI, ETA COORDINATES EXPRESSED AS INDICES OF ARRAY Z, BUT NEED NOT
C     BE INTEGERS IN GENERAL. FOR ENTRY IVIS, THEY MUST BE. 
C
      DIMENSION Z(IZDIM1,2)
C 
C     COMMON STORAGE DESCRIPTOR
      COMMON/COMDP/XMIN,XMAX,YMIN,YMAX,ZMIN,ZMAX,AXISR(2),PLOTX, 
     &   PLOTY,PLTORG(2),CAMXYZ(3),MX,NY,FMX,FNY,CAMWKG(6),XORG(3), 
     &   GX(3),FX(2),KSCALE,ZORG,CENTER(2),PQLMT,
     &   AMTX(3,3),FOCALL
      DIMENSION LIMIT(2),FLIM(2)
      EQUIVALENCE(U,CAMXYZ(1)),(V,CAMXYZ(2)),(W,CAMXYZ(3)),
     &   (MX,LIMIT(1)),(FMX,FLIM(1))
C     END CDE
C 
      LOGICAL*1 LSOLID
      COMMON /COMDP1/ LSOLID
      EQUIVALENCE (CX,CY), (DXI,DETA), (XIW,ETAW),
     &  (XIEND,ETAEND), (KDXI,KDETA), (KXIEND,KETEND),
     &  (DX,DY)
C 
C 
C 
C     INITIAL P FUNCTION 
5     IVIS = 0 
      R = U-XI 
      S = V-ETA 
      T = W-ZETA 
C     TEST IF WE CHECK ALONG X 
      IF(ABS(R) .LT. 1.0) GO TO 20 
C     CONSTANTS FOR Y(X),Z(X) 
      CY = S/R 
      CZ = T/R 
      DXI = SIGN(1.0,R) 
C     INITIAL POINT. TAKE AINT(XI) IF .NE. XI AND STEPS IN RIGHT DIRECTI
      XIW = AINT(XI) 
      IF((XIW-XI)*DXI .LE. 0.0) XIW = XIW+DXI 
C     SKIP IF OFF LIMITS (WE ARE ON EDGE OF PLOT REGION) 
      IF((XIW-1.0)*(XIW-FMX) .GT. 0.0) GO TO 20 
C     FINAL POINT. TAKE AINT(U) IF IT MOVES OPPOSITE DXI, ELSE ROUND 
      XIEND = AINT(U) 
      IF((XIEND-U)*DXI .GE. 0.0) XIEND = XIEND-DXI 
C     BUT DO NOT GO BEYOND EDGES 
      XIEND = AMAX1(1.0,AMIN1(XIEND,FMX)) 
C 
C              AFTER TESTING, RE-PRDER THESE STATEMENTS 
      J = IFIX(XIW) 
      KDXI = IFIX(DXI) 
      KXIEND = IFIX(XIEND) 
      XW = XIW-U 
C 
C     IF LIMITS CROSS, NO TEST 
      IF((XIEND-XIW)*DXI .LE. 0.0) GO TO 20 
C     GET Y(X) 
3     YW = V + XW*CY 
C     IF Y IS OFF LIMITS, DONE 
      IF((YW-1.0)*(YW-FNY)) 21,25,20 
C     ON EDGE EXACTLY, NO INTERPOLATION 
25    K = IFIX(YW) 
      IF(W + XW*CZ - Z(J,K)) 4,10,7 
C     INDEX FOR LOWER Y OF INTERVAL 
21    K = IFIX(YW) 
      DY = YW-FLOAT(K) 
C     TEST Z OF LINE - Z OF SURFACE. ACCEPT ZERO DIFFERENCE. 
      IF((W + XW*CZ)-(Z(J,K) + DY*(Z(J,K+1)-Z(J,K)))) 4,10,7 
C     NEGATIVE. OK IF IVIS NEG. OR ZERO, ELSE REJECT 
4     IF(IVIS) 10,6,40 
C     IVIS WAS ZERO, SET NEG. 
6     IVIS = -1 
      GO TO 10 
C     PLUS. OK IF IVIS + OR ZERO, ELSE, REJECT 
7     IF(IVIS) 40,8,10 
C     SET PLUS 
8     IVIS = 1 
C     TEST IF DONE. ADVANCE IF NOT 
10    IF(J .EQ. KXIEND) GO TO 20 
      J = J+KDXI 
      XW = XW+DXI 
      GO TO 3 
C 
C     CHECK IF WE TEST IN Y DIRECTION 
20    IF(ABS(S) .LT. 1.0) GO TO 45 
C     CONSTANTS FOR X(Y),Z(Y) 
      CX = R/S 
      CZ = T/S 
      DETA = SIGN(1.0,S) 
      ETAW = AINT(ETA) 
      IF((ETAW-ETA)*DETA .LE. 0.0) ETAW = ETAW+DETA 
C     CHECK WHETHER ON LIMITS 
      IF((ETAW-1.0)*(ETAW-FNY) .GT. 0.0) GO TO 45 
      ETAEND = AINT(V) 
      IF((ETAEND-V)*DETA .GE. 0.0) ETAEND = ETAEND-DETA 
      ETAEND = AMAX1(1.0,AMIN1(FNY,ETAEND)) 
      K = IFIX(ETAW) 
      KDETA = IFIX(DETA) 
      YW = ETAW-V 
      KETEND = IFIX(ETAEND) 
C     IF LIMITS CROSS, NO TEST, BUT TEST SINGLE POINT IF WE HAVE ALREADY
C     TESTED X 
      A = ETAEND-ETAW 
      IF(A*DETA .LT. 0.0) GO TO 45 
      IF(A .EQ. 0.0 .AND. IVIS .EQ. 0) GO TO 45 
C     GET X(Y) 
23    XW = U + YW*CX 
C     IF X OFF LIMITS, DONE 
      IF((XW-1.0)*(XW-FMX)) 44,46,45 
46    J = IFIX(XW) 
      IF(W + YW*CZ - Z(J,K)) 24,30,27 
44    J = IFIX(XW) 
      DX = XW-FLOAT(J) 
      IF((W + YW*CZ) - (Z(J,K)+DX*(Z(J+1,K)-Z(J,K)))) 24,30,27 
C     NEG., IVIS MUST BE NEG OR ZERO ELSE REJCT 
24    IF(IVIS) 30,26,40 
C     SET IVIS NEG 
26    IVIS = -1 
      GO TO 30 
C     POS, IVIS MUST BE ZERO OR + ELSE REJECT 
27    IF(IVIS) 40,28,30 
28    IVIS = 1 
C     TEST IF DONE, ADVANCE IF NOT. 
30    IF(K .EQ. KETEND) GO TO 45 
      K = K+KDETA 
      YW = YW+DETA 
      GO TO 23 
C 
C     REJECT THIS POINT, RETURN ZERO. 
40    IVIS = 0 
      RETURN 
C 
C     ACCEPT. RETURN +/- 1 
C     IF IVIS ZERO, CAMERA WAS RIGHT OVER XI, ETA. 
45    IF(IVIS .EQ. 0) IVIS = SIGN(1.0,T) 
      IF (LSOLID .AND. (IVIS .EQ. -1)) GO TO 40
      RETURN 
      END 
      SUBROUTINE ROTATE(XIN,A,XOUT) 
C     ROTATE VECTOR XIN BY MATRIX A TO GET XOUT 
C 
C 
      DIMENSION XIN(3),A(9),XOUT(3) 
      XOUT(1) = A(1)*XIN(1) + A(4)*XIN(2) + A(7)*XIN(3) 
      XOUT(2) = A(2)*XIN(1) + A(5)*XIN(2) + A(8)*XIN(3) 
      XOUT(3) = A(3)*XIN(1) + A(6)*XIN(2) + A(9)*XIN(3) 
      RETURN 
      END
