      BLOCK DATA GDPOSD
      COMMON/POSTDCM/LUNPOS,INITPOST,L_NOTHING_PLOTTED
      DATA INITPOST/0/
      END
      SUBROUTINE GDPSTT(IFXN,XA,YA)
      DIMENSION XA(8), YA(3)
C
C   *******  MODIFIED FOR DELAYED RELEASE TO PRINTER ************
C   *******  MUST CALL POSTDMP TO SEND PLOTS TO PRINTER ********
C
C     POST SCRIPT DRIVER - HARD COPY DEVICE HAS 300 DOTS/INCH
      PARAMETER (DOTS_PER_INCH = 300.0)
C
C-----------------------------------------------------------------------
C
C     DECLARE VARS NEED FOR DRIVER OPERATION
C
      LOGICAL*1 L_NOTHING_PLOTTED, L_WIDE
      LOGICAL*1 COORD(20)
      CHARACTER COORDC*20
      LOGICAL*1 EOF(2)
C
      DIMENSION DCHAR(8)
      COMMON/POSTDCM/LUNPOS,INITPOST,L_NOTHING_PLOTTED
C
C     MAKE NICE NAMES FOR THE DEVICES RESOLUTION IN X AND Y
C      ("XGUPCM" IS X GRAPHICS UNITS PER CENTIMETER)
C
      EQUIVALENCE (DCHAR(4),XGUPCM), (DCHAR(5),YGUPCM)
      EQUIVALENCE (COORDC,COORD)
C
C     PAPER DEFINITIONS (INCHES)
C
      PARAMETER (PSRES = 72.0)
      REAL*4 LEFT_MARGIN
      PARAMETER (LEFT_MARGIN = 0.5)
      PARAMETER (RIGHT_MARGIN = 0.25)
      PARAMETER (TOP_MARGIN = 0.5)
      PARAMETER (BOTTOM_MARGIN = 0.25)
      PARAMETER (PAPER_HEIGHT = 11.0)
      PARAMETER (PAPER_WIDTH = 8.5)
C           DERIVED PARAMETERS
      PARAMETER (USEABLE_WIDTH = PAPER_WIDTH-LEFT_MARGIN-RIGHT_MARGIN)
      PARAMETER (USEABLE_HEIGHT = PAPER_HEIGHT-TOP_MARGIN-BOTTOM_MARGIN)
      PARAMETER (WIDTH_CM = 2.54*USEABLE_WIDTH)
      PARAMETER (HEIGHT_CM = 2.54*USEABLE_HEIGHT)
      PARAMETER (RESOLUTION = DOTS_PER_INCH/2.54)
      PARAMETER (PSRESCM = PSRES/2.54)
      PARAMETER (XOFF = PSRES*LEFT_MARGIN)
      PARAMETER (YOFF = PSRES*BOTTOM_MARGIN)
C
      PARAMETER (MAX_POINTS_PER_PATH = 900)
C
C     DIGLIB DEVICE CHARACTERISTICS WORDS
C
      DATA DCHAR /910.0, WIDTH_CM, HEIGHT_CM, RESOLUTION,
     1   RESOLUTION, 1.0, 27.0, 4.0/
C
      DATA EOF /4,0/
C
      L_WIDE = .FALSE.
10    CONTINUE
C
C*****************
C
C     FIRST VERIFY WE GOT A GRAPHICS FUNCTION WE CAN HANDLE
C
      IF (IFXN .LE. 0 .OR. IFXN .GT. 7) RETURN
C
C     NOW DISPATCH TO THE PROPER CODE TO HANDLE THAT FUNCTION
C
      GO TO (100,200,300,400,500,600,700) IFXN
C
C     *********************
C     INITIALIZE THE DEVICE
C     *********************
C
100   CONTINUE
      IF(INITPOST.EQ.0)THEN
            INITPOST=1
C            LUN = XA(1)
            LUN = 33
              LUNPOS=LUN
            OPEN (UNIT=LUN,FILE='DIGOUT.PSC',STATUS='NEW',ERR=9000)
C
C     SHOW INITIALIZATION WORKED, I.E. WE OPENED THE FILE.
C
            YA(1) = 0.0
            CALL GDPOS_OPEN_BUFR(LUN)
C           CALL GDPSTI(EOF)
            CALL GDPSTI
     1     ('erasepage initgraphics 1 setlinecap 1 setlinejoin ')
            CALL GDPSTI('/m {moveto} def /l {lineto} def ')
            CALL GDPSTD
190         CONTINUE
            L_NOTHING_PLOTTED = .TRUE.
            N_POINTS_IN_PATH = 0
      END IF
      RETURN
C
C     **************************
C     GET FRESH PLOTTING SURFACE
C     **************************
C
200   CONTINUE
      IF (.NOT. L_NOTHING_PLOTTED) THEN
            CALL GDPSTI('stroke showpage ')
      ENDIF
      CALL GDPSTI('newpath ')
      GO TO 190
C
C     ****
C     MOVE
C     ****
C
300   CONTINUE
C
C     ****
C     DRAW
C     ****
C
400   CONTINUE
      N_POINTS_IN_PATH = N_POINTS_IN_PATH + 1
      IF (N_POINTS_IN_PATH .GT. MAX_POINTS_PER_PATH) THEN
            CALL GDPSTI('stroke newpath ')
            IF (IFXN .EQ. 4) THEN
                  CALL GDPSTI(COORD)
                  CALL GDPSTI('m ')
            ENDIF
            N_POINTS_IN_PATH = 1
      ENDIF
      IF (L_WIDE) THEN
            X = PSRESCM*YA(1)+XOFF
            Y = PSRESCM*(HEIGHT_CM-XA(1))+YOFF
          ELSE
            X = PSRESCM*XA(1)+XOFF
            Y = PSRESCM*YA(1)+YOFF
      ENDIF
      ENCODE (14,451,COORDC) X,Y
451   FORMAT(F6.1,1X,F6.1,1X)
      COORD(15) = 0
      CALL GDPSTI(COORD)
      IF (IFXN .EQ. 3) THEN
            CALL GDPSTI('m ')
          ELSE
            CALL GDPSTI('l ')
      ENDIF
      L_NOTHING_PLOTTED = .FALSE.
      RETURN
C
C     *****************************
C     FLUSH GRAPHICS COMMAND BUFFER
C     *****************************
C
500   CONTINUE
      RETURN            !DONE BY BGNPLT WHEN NECESSARY.
C
C     ******************
C     RELEASE THE DEVICE  ** MODIFIED FOR SEPARATE CALL TO RELEASE
C     ******************
C
600   CONTINUE
C     IF (.NOT. L_NOTHING_PLOTTED) THEN
C           CALL GDPSTI('stroke showpage ')
C           CALL GDPSTI(EOF) 
C           CALL GDPSTD
C     ENDIF
C     CLOSE (UNIT=LUN)
C     ISTATUS = LIB$SPAWN('$ DIGLASEROUT SYS$SCRATCH:POSTSCRPT.DIG')
      RETURN
C
C     *****************************
C     RETURN DEVICE CHARACTERISTICS
C     *****************************
C
700   CONTINUE
      DO 720 I=1,8
      XA(I) = DCHAR(I)
720   CONTINUE
      IF (L_WIDE) THEN
            XA(2) = DCHAR(3)
            XA(3) = DCHAR(2)
      ENDIF
      RETURN
C
C     HANDLE FILE OPEN ERROR
C
9000  CONTINUE
      YA(1) = 3.0
      RETURN
C
C     ***********************************************************
C
      ENTRY GDPSTW(IFXN,XA,YA)
      L_WIDE = .TRUE.
      GO TO 10
      END


      SUBROUTINE GDPOS_OPEN_BUFR(LUN)
C
      PARAMETER (IBUFR_SIZE = 80)
      LOGICAL*1 L_NOTHING_PLOTTED
      LOGICAL*1 BUFFER
      COMMON /GDLSR/ NXTCHR, LUNOUT, BUFFER(IBUFR_SIZE)
      COMMON/POSTDCM/LUNPOS,INITPOST,L_NOTHING_PLOTTED
C
      LUNOUT = LUN
      NXTCHR = 1
      RETURN
      END


      SUBROUTINE GDPOS_INIT_BUFR
C
      PARAMETER (IBUFR_SIZE = 80)
      LOGICAL*1 BUFFER
      COMMON /GDLSR/ NXTCHR, LUNOUT, BUFFER(IBUFR_SIZE)
C
      NXTCHR = 1
      RETURN
      END


      SUBROUTINE GDPSTI(STRING)
      LOGICAL*1 STRING(30)
C
      PARAMETER (IBUFR_SIZE = 80)
      LOGICAL*1 BUFFER
      COMMON /GDLSR/ NXTCHR, LUNOUT, BUFFER(IBUFR_SIZE)
C
      EXTERNAL LEN
C
      L = LEN(STRING)
      IF ((NXTCHR+L) .GT. IBUFR_SIZE) CALL GDPSTD
            DO 100 I = 1, L
            BUFFER(NXTCHR) = STRING(I)
            NXTCHR = NXTCHR + 1
100         CONTINUE
      RETURN
      END

      SUBROUTINE GDPSTD
C
      PARAMETER (IBUFR_SIZE = 80)
      INTEGER*1 CR
      PARAMETER (CR = 13)
      LOGICAL*1 BUFFER
      COMMON /GDLSR/ NXTCHR, LUNOUT, BUFFER(IBUFR_SIZE)
C
      IF (NXTCHR .EQ. 1) RETURN
      WRITE (LUNOUT,900) (BUFFER(I), I=1,NXTCHR-1), CR
900   FORMAT(80A)
      NXTCHR = 1
      RETURN
      END
        SUBROUTINE POSTDMP
      LOGICAL*1 L_NOTHING_PLOTTED
      COMMON/POSTDCM/LUNPOS,INITPOST,L_NOTHING_PLOTTED
      IF(INITPOST.EQ.0)RETURN
      IF (.NOT. L_NOTHING_PLOTTED) THEN
            CALL GDPSTI('stroke showpage ')
            CALL GDPSTI(EOF) 
            CALL GDPSTD
      ENDIF
      CLOSE (UNIT=LUNPOS)
C      ISTATUS = LIB$SPAWN('$ DIGLASEROUT SYS$SCRATCH:POSTSCRPT.DIG')
      INITPOST=0
      RETURN
      END
      SUBROUTINE GSETLW(XLW)
      COMMON /GCDSEL/ IDEV
        LOGICAL*1 BLW(26)
      CHARACTER CLW*26
      EQUIVALENCE (BLW,CLW)
      IF(IDEV.EQ.6)THEN
            WRITE(CLW,90)XLW
90          FORMAT(' stroke',F5.2,' setlinewidth')
                CLW(26:26)=CHAR(0)
            CALL GDPSTI(BLW)
        END IF
      RETURN
      END
