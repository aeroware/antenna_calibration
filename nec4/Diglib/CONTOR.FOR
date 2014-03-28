      SUBROUTINE CONTOR(Z,NZ,IZ,MX,MY,X1,XMX,Y1,YMY,NL,CL)
C
C     THIS SUBROUTINE WILL PRODUCE A CONTOUR PLOT OF THE FUNCTION
C     DEFINED BY Z(I,J) = F(X(I),Y(J)).   IT IS ASSUMED THAT
C     A CALL TO "MAPIT" HAS ALREADY BEEN MADE TO ESTABLISH THE
C     COORDINATE AXIS (X,Y), WITH X LIMITS COVERING THE RANGE
C     X1 TO XMX, AND Y LIMITS COVERING THE RANGE Y1 TO YMY.
C
CArguments:
C
C  Input
C
C     Z           * Type: real array.
C                 * The values of the function to contour:
C                    Z(I,J) = F(Xi,Yj) where:
C                      Xi = X1 + (i-1)*(XMX-X1)/(MX-1)
C                      Yj = Y1 + (j-1)*(YMX-Y1)/(MY-1)
C
C     MX          * Type: integer constant or variable.
C                 * The number of X grid points.
C
C     X1          * Type: real constant or variable.
C                 * The minimum X value.
C
C     XMX         * Type: real constant or variable.
C                 * The maximum X value.
C
C     MY          * Type: integer constant or variable.
C                 * The number of Y grid points.
C
C     Y1          * Type: real constant or variable.
C                 * The minimum Y value.
C
C     YMY         * Type: real constant or variable.
C                 * The maximum Y value.
C
C     NL          * Type: integer constant or variable.
C                 * The number of contour levels.
C
C     CL          * Type: real array.
C                 * The coutour levels to draw.   (Same units as
C                       F() or Z().)
C
C     IZ          * Type: byte array.
C                 * Used internally for working storage.
C
C     NZ          * Type: integer constant or variable.
C                 * The first dimension of the array Z - not necessarily
C                       equal to MX, but MX <= NZ.
C
C  Output
C
C    None.
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
      DIMENSION Z(NZ,MY)
      DIMENSION CL(NL)
      INTEGER*1 IZ(MX,MY)
      COMMON /CONTR/ CLEVEL,IOLD,JOLD,IN,JN,
     &   NX,NY,XL,DX,YL,DY
C
C     INITIALIZE ROUTINE
C
      XL = X1
      YL = Y1
      DX = XMX-X1
      DY = YMY-Y1
      NX=MX
      NY=MY
      NLOOP=MIN1(FLOAT(NX)/2.0+.5,FLOAT(NY)/2.0+.5)
C     START SEARCHING FOR PLUS-MINUS TRANSITIONS
C     TO START A CONTOR ON.
      DO 50 NC=1,NL
C     ZERO ARRAY SHOWING WHERE WE HAVE BEEN
      DO 1 I=1,NX
      DO 1 J=1,NY
1     IZ(I,J)=0
      CLEVEL=CL(NC)
      DO 50 ICIR=1,NLOOP
      IU=NX+1-ICIR
      JU=NY+1-ICIR
      DO 10 J=ICIR,JU-1
10    CALL LOOK(Z,ICIR,J,1,IZ,NZ,NX)
      DO 20 I=ICIR,IU-1
20    CALL LOOK(Z,I,JU,2,IZ,NZ,NX)
      DO 30 J=JU,ICIR+1,-1
30    CALL LOOK(Z,IU,J,3,IZ,NZ,NX)
      DO 40 I=IU,ICIR+1,-1
40    CALL LOOK(Z,I,ICIR,4,IZ,NZ,NX)
50    CONTINUE
      RETURN
      END
C
C
C
      SUBROUTINE LOOK(Z,II,JJ,M,IZ,NZ,IZDIM)
      INTEGER*1 IZ(IZDIM,2)
      DIMENSION Z(NZ,2)
      COMMON /CONTR/ CLEVEL,IOLD,JOLD,IN,JN,
     &   NX,NY,XL,DX,YL,DY
      DIMENSION IDMODE(3,4)
      DATA IDMODE/4,1,2,  1,2,3,  2,3,4,  3,4,1/
      IOLD=II
      JOLD=JJ
      MODE=M
      CALL NEWP(1,MODE)
C     LOOK FOR CONTOR STARTING HERE
      IF (Z(IOLD,JOLD) .GT. CLEVEL .AND. Z(IN,JN) .LE. CLEVEL) GOTO 20
100   RETURN
C     CHECK FOR CONTOR PREVIOUSLY THRU HERE
20    CALL SEGMNT(ICI,ICJ,ISEG)
      IF ((IZ(ICI,ICJ) .AND. ISEG) .NE. 0) RETURN
      CALL ZPNT(XX,YY,Z,NZ)
      CALL SCALE(XX,YY,VX,VY)
      CALL GSMOVE(VX,VY)
      IOLD=IN
      JOLD=JN
30    DO 50 N=2,4
      CALL NEWP(N,MODE)
      IF (IN .LT. 1 .OR. IN .GT. NX) GO TO 100
      IF (JN .LT. 1 .OR. JN .GT. NY) GO TO 100
      IF (SIGN(1.0,Z(IOLD,JOLD)-CLEVEL) .NE.
     &  SIGN(1.0,Z(IN,JN)-CLEVEL)) GO TO 60
      IOLD=IN
      JOLD=JN
50    CONTINUE
60    CALL SEGMNT(ICI,ICJ,ISEG)
      IF ((IZ(ICI,ICJ) .AND. ISEG) .NE. 0) RETURN
      IZ(ICI,ICJ)=IZ(ICI,ICJ) .OR. ISEG
      CALL ZPNT(XX,YY,Z,NZ)
      CALL SCALE(XX,YY,VX,VY)
      CALL GSDRAW(VX,VY)
      MODE=IDMODE(N-1,MODE)
      GO TO 30
      END
C
C
C
      SUBROUTINE SEGMNT(ICI,ICJ,ISEG)
      COMMON /CONTR/ CLEVEL,IOLD,JOLD,IN,JN,
     &   NX,NY,XL,DX,YL,DY
      ICI=MIN0(IOLD,IN)
      ICJ=MIN0(JOLD,JN)
      ISEG=1
      IF (IOLD .EQ. IN) ISEG=2
      RETURN
      END
C
C
C
      SUBROUTINE NEWP(I,M)
      COMMON /CONTR/ CLEVEL,IOLD,JOLD,IN,JN,
     &   NX,NY,XL,DX,YL,DY
      DIMENSION IDELI(4),JDELJ(4)
      DATA IDELI,JDELJ / 0,1,0,-1,   1,0,-1,0/
      INDEX=MOD(2+I+M,4)+1
      IN=IOLD+IDELI(INDEX)
      JN=JOLD+JDELJ(INDEX)
      RETURN
      END
C
C
C
      SUBROUTINE ZPNT(X,Y,Z,NZ)
      DIMENSION Z(NZ,2)
      COMMON /CONTR/ CLEVEL,IOLD,JOLD,IN,JN,
     &   NX,NY,XL,DX,YL,DY
      A=Z(IN,JN)-Z(IOLD,JOLD)
C     IF NO CHANGE IN Z'S, PICK OLD POINT SO AS TO STAY TO RIGHT
      IF (A .EQ. 0.0) GO TO 10
      A=(CLEVEL-Z(IOLD,JOLD))/A
10    X=A*(IN-IOLD)+IOLD
      Y=A*(JN-JOLD)+JOLD
C     NOW CONVERT INDEXS TO X,Y VALUES
      X=(X-1.0)*DX/(NX-1)+XL
      Y=(Y-1.0)*DY/(NY-1)+YL
      RETURN
      END
