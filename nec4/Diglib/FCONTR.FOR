	SUBROUTINE CONTOR(Z,NZ,IZ,MX,MY,X1,XMX,Y1,YMY,NL,CL)
C
C	THIS SUBROUTINE WILL PRODUCE A CONTOUR PLOT OF THE FUNCTION
C	DEFINED BY Z(I,J) = F(X(I),Y(J)).   IT IS ASSUMED THAT
C	A CALL TO "MAPIT" HAS ALREADY BEEN MADE TO ESTABLISH THE
C	COORDINATE AXIS (X,Y), WITH X LIMITS COVERING THE RANGE
C	X1 TO XMX, AND Y LIMITS COVERING THE RANGE Y1 TO YMY.
C
C	FAST VERSION FOR USE WITH CRTS ONLY
C
C	Modified 21 May 1985 to add pre-tests. Allyn Saroyan
C
CArguments:
C
C  Input
C
C	Z		* Type: real array.
C			* The values of the function to contour:
C			   Z(I,J) = F(Xi,Yj) where:
C			     Xi = X1 + (i-1)*(XMX-X1)/(MX-1)
C			     Yj = Y1 + (j-1)*(YMX-Y1)/(MY-1)
C
C	NZ		* Type: integer constant or variable.
C			* The first dimension of the array Z - not necessarily
C				equal to MX, but MX <= NZ.
C
C	IZ		* Type: Anything - a dummy for compatibility
C			* Not used!!!
C
C	MX 		* Type: integer constant or variable.
C			* The number of X grid points.
C
C	MY		* Type: integer constant or variable.
C			* The number of Y grid points.
C
C	X1		* Type: real constant or variable.
C			* The minimum X value.
C
C	XMX		* Type: real constant or variable.
C			* The maximum X value.
C
C	Y1		* Type: real constant or variable.
C			* The minimum Y value.
C
C	YMY		* Type: real constant or variable.
C			* The maximum Y value.
C
C	NL		* Type: integer constant or variable.
C			* The number of contour levels.
C
C	CL		* Type: real array.
C			* The coutour levels to draw.   (Same units as
C				F() or Z().)
C
C  Output
C
C    None.
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

	DIMENSION Z(NZ,MY)
	DIMENSION CL(NL)
C
	COMMON /CONTR/ X0,Y0,DX,DY
	DIMENSION ZB(4)

	REAL min, max
C
C	CALC. SOME SCALING CONSTANTS NEEDED
C
	DX = (XMX-X1)/(MX-1)
	DY = (YMY-Y1)/(MY-1)
	X0 = X1-DX
	Y0 = Y1-DY
C
C	MOVE THRU ARRAY LOOKING FOR CONTOUR SEGMENTS IN EACH BOX.
C
	DO 100 J=1,MY-1
		J2 = J+1
		ZB(3) = Z(1,J2)
		ZB(4) = Z(1,J)
		DO 90 I=1,MX-1
			I2 = I+1
			ZB(1) = ZB(4)
			ZB(2) = ZB(3)
			ZB(3) = Z(I2,J2)
			ZB(4) = Z(I2,J)
C			Test for all points equal -- skip if true
			IF ( zb(1) .eq. zb(2) .and. zb(1) .eq. zb(3)
	1			.and. zb(1) .eq. zb(4) ) goto 90

C			Find extremes of box
			min = 1.0E30
			max = -min
			DO l=1, 4
				if ( zb(l) .lt. min ) min = zb(l)
				if ( zb(l) .gt. max ) max = zb(l)
			enddo
C			If a contour falls within the box, plot it.
			icolor = 0
			DO 50 K=1,NL
				icolor = icolor+1
				if ( icolor .gt. 7 ) icolor = 1
				Call GsColr(icolor,err)
				IF ( cl(k) .ge. min .and. cl(k) .le. max )
	1				CALL SEGMNT(I,J,ZB,CL(K))
50			CONTINUE
90		CONTINUE
100	CONTINUE
	RETURN
	END

	SUBROUTINE SEGMNT(IX,JY,ZB,CLEVEL)
	DIMENSION ZB(4)
C
C	This subroutine looks for a contour segment in the box defined by
C	the points (IX,JY,ZB1), (IX,JY+1,ZB2), (IX+1,JY+1,ZB3)
C	and (IX+1,JY,ZB4).   If found, the segment is drawn.
C
	COMMON /CONTR/ X0,Y0,DX,DY
	DIMENSION IOFF(4), JOFF(4)
	LOGICAL LFIRST
	DATA IOFF /0,0,1,1/
	DATA JOFF /0,1,1,0/
C
	LFIRST = .TRUE.
	IPREVS = 4
	ZOLD = ZB(IPREVS)
	ZDIFF = CLEVEL - ZOLD
	DO 100 I=1,4
		ZNEW = ZB(I)
		DIFF = CLEVEL - ZNEW
		IF (SIGN(1.0,ZDIFF) .EQ. SIGN(1.0,DIFF)) GO TO 90
		TEMP = ZNEW-ZOLD
		IF (TEMP .NE. 0.0) GO TO 30
			PCTCHG = 0.0
			GO TO 40
30		    CONTINUE			
			PCTCHG = ZDIFF/TEMP
40		CONTINUE
		X = IX + IOFF(IPREVS) + (IOFF(I)-IOFF(IPREVS))*PCTCHG
		Y = JY + JOFF(IPREVS) + (JOFF(I)-JOFF(IPREVS))*PCTCHG
		CALL SCALE(X*DX+X0,Y*DY+Y0,VX,VY)
		IF (LFIRST) GOTO 50
			CALL GSDRAW(VX,VY)
			LFIRST = .TRUE.
			GO TO 90
50		    CONTINUE
			CALL GSMOVE(VX,VY)
			LFIRST = .FALSE.
90		CONTINUE
		ZDIFF = DIFF
		ZOLD = ZNEW
		IPREVS = I
100	CONTINUE
	RETURN
	END
