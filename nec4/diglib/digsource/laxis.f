	SUBROUTINE LAXIS(ALOW,AHIGH,MAXTCK,BMIN,BMAX,BTICK)
C
C	THIS ROUTINE FINDS A SUITABLE TICK FOR LOG AXES
C
	DATA SMLREL /1E-38/
C
	BLOW = ALOG10(AMAX1(SMLREL,AMIN1(AHIGH,ALOW)))
	BHIGH = ALOG10(AMAX1(ALOW,AHIGH,1E2*SMLREL))
	RANGE = BHIGH-BLOW
C	!1E-2 IS FUZZ FACTOR
	IF (RANGE .LE. 1E-2) RANGE = 1.0
	ISTRT = 1
	IMAX = 5
30	DO 50 I=ISTRT,IMAX,ISTRT
	NTCKS = RANGE/I + 0.999
	IF (NTCKS .LE. MAXTCK) GO TO 60
50	CONTINUE
	ISTRT = 10
	IMAX = 80
	GO TO 30
60	BTICK = I
	BMIN = BTICK*AINT(BLOW/BTICK)
	BMAX = BTICK*AINT(BHIGH/BTICK)
	IF ((BMIN-BLOW)/RANGE .GT. 0.001) BMIN = BMIN - BTICK
	IF ((BHIGH-BMAX)/RANGE .GT. 0.001) BMAX = BMAX + BTICK
	RETURN
	END
