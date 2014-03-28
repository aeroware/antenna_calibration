      BLOCK DATA DIGINIT
C      COMMON /GCDSEL/ IDEV
      INCLUDE 'GCDSEL.PRM'
	COMMON/BAKREV/IREVB
      DATA IDEV/0/,IREVB/0/
      END
	SUBROUTINE GSBKRV
	COMMON/BAKREV/IREVB
      IF(IREVB.EQ.0)THEN
	   IREVB=1
	ELSE
	   IREVB=0
	END IF
	RETURN
	END
      SUBROUTINE GDWIN95(IFXN,XA,YA)
C      IMPLICIT NONE
      USE MSFLIB
C
C     Screen driver for Windows 95 compiled with Microsoft Fortran
C     Powerstation V. 4.
C
      LOGICAL               modestatus
      TYPE (windowconfig)   digwin
      TYPE (xycoord) XYCD
      LOGICAL LVECTOR_GOING
      INTEGER(4) IFXN, NUMBER_FG_COLORS, NPTS,I
      INTEGER(2)  X_DOTS, Y_DOTS, IXPOSN,IYPOSN, IX, IY,STATUS
      REAL(4) XA(8), YA(3), DCHAR(8), TERM_NUMBER,
     &X_RES, Y_RES, RESOLUTION, XLENGTH, YLENGTH, XGUPCM, YGUPCM
C
      PARAMETER (TERM_NUMBER = 1.)
      PARAMETER (NUMBER_FG_COLORS = 7)
C
C     MAKE NICE NAMES FOR THE DEVICES RESOLUTION IN X AND Y
C      ("XGUPCM" IS X GRAPHICS UNITS PER CENTIMETER)
C
      COMMON/DEV_PARAM/DCHAR
	COMMON/BAKREV/IREVB
      EQUIVALENCE (DCHAR(4),XGUPCM), (DCHAR(5),YGUPCM)
      INTEGER(4) DCOLORS(0:7)
	DATA INIT95/0/
      SAVE /DEV_PARAM/,INIT95,DCOLORS,digwin
C
C     Initialize and set device characteristics first,
C     since DIGLIB asks for device characteristics before
C     initializing and may ask at any other time.
C
	IF(INIT95.EQ.0)THEN
	   INIT95=1
         digwin.numxpixels=-1
         digwin.numypixels=-1
         digwin.numtextcols=-1
         digwin.numtextrows=-1
         digwin.numcolors=-1
c         digwin.numcolors=256
         digwin.fontsize=-1
         digwin.title="DIGLIB"C
         modestatus=SETWINDOWCONFIG(digwin)
         IF(.NOT.modestatus)modestatus=SETWINDOWCONFIG(digwin)
         modestatus=GETWINDOWCONFIG(digwin)
         XLENGTH=31.    !Size in cm assuming 17 inch screen
         YLENGTH=23.
         X_DOTS=digwin.numxpixels
         Y_DOTS=digwin.numypixels
         X_RES = (X_DOTS-1)/XLENGTH
         Y_RES = (Y_DOTS-1)/YLENGTH
         RESOLUTION = (X_RES+Y_RES)/2.0
         DCHAR(1)=TERM_NUMBER
         DCHAR(2)=XLENGTH
         DCHAR(3)=YLENGTH
         DCHAR(4)=RESOLUTION
         DCHAR(5)=RESOLUTION
         DCHAR(6)=NUMBER_FG_COLORS
	   DCHAR(7)=1.+4.+64.
         DCHAR(8)=1.0
	END IF
C
C     FIRST VERIFY WE GOT A GRAPHICS FUNCTION WE CAN HANDLE
C
      IF (IFXN .GT. 1026) GO TO 20000
      IF (IFXN .LE. 0 .OR. IFXN .GT. 10) RETURN
C
C     NOW DISPATCH TO THE PROPER CODE TO HANDLE THAT FUNCTION
C
      GO TO (100,200,300,400,500,600,700,800,900,1000) IFXN
C
C     *********************
C     INITIALIZE THE DEVICE
C     *********************
C
100   CONTINUE
C
C     Standard DIGLIB colors: 0=black, 1=white, 2=red, 3=green, 4=blue,
C                             5=yellow, 6=magenta, 7=cyan
      IF(IREVB.EQ.0)THEN
         DCOLORS(0)=#000000     !Black background
         DCOLORS(1)=#FFFFFF     !Black background
	ELSE
         DCOLORS(1)=#000000     !White background
         DCOLORS(0)=#FFFFFF     !White background
	END IF
      DCOLORS(2)=#0000FF
      DCOLORS(3)=#00FF00
      DCOLORS(4)=#FF0000
      DCOLORS(5)=#00FFFF
      DCOLORS(6)=#FF00FF
      DCOLORS(7)=#FFFF00
	LASTCL=SETTEXTCOLORRGB(DCOLORS(1))
      LASTCL=SETBKCOLORRGB(DCOLORS(0))
      LASTCL=SETCOLORRGB(DCOLORS(1))
      YA(1)=0.
      LVECTOR_GOING=.false.
      RETURN
C
C     **************************
C     GET FRESH PLOTTING SURFACE
C     **************************
C
200   CONTINUE
      CALL CLEARSCREEN($GCLEARSCREEN)
      LVECTOR_GOING=.false.
      RETURN
C
C     ****
C     MOVE
C     ****
C
300   CONTINUE
C     CONVERT CM. TO GRAPHICS UNITS ROUNDED
      IXPOSN = XGUPCM*XA(1)+0.5
      IYPOSN = Y_DOTS-YGUPCM*YA(1)+0.5
      LVECTOR_GOING=.false.
      RETURN
C
C     ****
C     DRAW
C     ****
C
400   CONTINUE
      IF(.NOT.LVECTOR_GOING)THEN
         CALL MOVETO(IXPOSN,IYPOSN,XYCD)
         LVECTOR_GOING=.TRUE.
      END IF
      IX = XGUPCM*XA(1)+0.5
      IY = Y_DOTS-YGUPCM*YA(1)+0.5
      STATUS=LINETO(IX,IY)
      RETURN
C
C     *****************************
C     FLUSH GRAPHICS COMMAND BUFFER
C     *****************************
C
500   CONTINUE
      RETURN
C
C     ******************
C     RELEASE THE DEVICE
C     ******************
C
600   CONTINUE
C
C      CALL CLEARSCREEN($GCLEARSCREEN)
C
C     De-assign the channal, close the widnow, etc.
C     But not here since we did not open a window.
C
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
      RETURN
C
C     ****************************
C     SELECT CURRENT DRAWING COLOR
C     ****************************
C
800   CONTINUE
      ICOLR=INT4(XA(1)+.5)
	IF(ICOLR.GT.NUMBER_FG_COLORS)RETURN
      LASTCL=SETCOLORRGB(DCOLORS(ICOLR))
      RETURN
C
C     **********************
C     PERFORM GRAPHICS INPUT
C     **********************
C
900   CONTINUE
C
C     POSITION CURSOR TO ITS LAST GIN POSITION (ELSE MIDDLE OF SCREEN)
C
      RETURN
C
C     **********************
C     SET A COLOR FROM RGB INPUT
C     **********************
C
1000  CONTINUE
      ICOLR=INT4(XA(1)+.5)
	IF(ICOLR.GT.NUMBER_FG_COLORS)RETURN
	IRED=#FF*YA(1)/100.+.1
	IGRN=#FF*YA(2)/100.+.1
	IBLU=#FF*YA(3)/100.+.1
	IF(IRED.GT.#FF)IRED=#FF
	IF(IGRN.GT.#FF)IGRN=#FF
	IF(IBLU.GT.#FF)IBLU=#FF
C	DCOLORS(ICOLR)=IRED+IGRN*#100+IBLU*#10000
	DCOLORS(ICOLR)=RGBTOINTEGER(IRED,IGRN,IBLU)
c	WRITE(*,'(I5,2X,Z6,2X,Z6)')ICOLR,DCOLORS(ICOLR)
      RETURN
C
C     *******************
C     DRAW FILLED POLYGON
C     *******************
C
20000 CONTINUE
      NPTS = IFXN - 1024
      IX = XGUPCM*XA(1)+0.5
      IY = YGUPCM*YA(1)+0.5
C
C     DO VERTICES 2 THRU N.   NOTE: WE START WITH A <GS> SINCE
C      LVECTOR_GOING IS "FALSE"
C
            DO 20010 I = 2, NPTS
C           MAKE SURE 10 CHARS (4 FOR X,Y AND 6 FOR END POLYGON)
20010       CONTINUE
      RETURN
      END
      BLOCK DATA GDPOSD
	LOGICAL*1 L_NOTHING_PLOTTED
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
      CHARACTER COORDC*20,PSOUT*60
      INTEGER(1) IZRO
      CHARACTER CZRO*1
C
      DIMENSION DCHAR(8)
      COMMON/POSTDCM/LUNPOS,INITPOST,L_NOTHING_PLOTTED
C
C     MAKE NICE NAMES FOR THE DEVICES RESOLUTION IN X AND Y
C      ("XGUPCM" IS X GRAPHICS UNITS PER CENTIMETER)
C
      EQUIVALENCE (DCHAR(4),XGUPCM), (DCHAR(5),YGUPCM)
      EQUIVALENCE (COORDC,COORD),(CZRO,IZRO)
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
      DATA IZRO/0_1/
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
C         LUN = XA(1)
         LUN = 33
         LUNPOS=LUN
1        WRITE(*,'('' File name for PostScript output >'',$)')
         READ(*,'(A)')PSOUT
         IF(PSOUT.EQ.' ')PSOUT='DIGOUT.PSC'
C         OPEN (UNIT=LUN,FILE='DIGOUT.PSC',STATUS='UNKNOWN',ERR=9000,
C     &   DISPOSE='PRINT/DELETE')
         OPEN (UNIT=LUN,FILE=PSOUT,STATUS='NEW',ERR=9001)
         GO TO 2
9001     WRITE(*,'('' Error opening file '',A)')PSOUT
         GO TO 1
C
C     SHOW INITIALIZATION WORKED, I.E. WE OPENED THE FILE.
C
2           YA(1) = 0.0
            CALL GDPOS_OPEN_BUFR(LUN)
	      CALL GDPSTI("%!PS"C)
	      CALL GDPSTD
            CALL GDPSTI
     1     ("erasepage initgraphics 1 setlinecap 1 setlinejoin "C)
            CALL GDPSTI("/m {moveto} def /l {lineto} def "C)
            CALL GDPSTD
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
            CALL GDPSTI("stroke showpage "C)
      ENDIF
      CALL GDPSTI("newpath "C)
      L_NOTHING_PLOTTED = .TRUE.
      N_POINTS_IN_PATH = 0
      RETURN
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
            CALL GDPSTI("stroke newpath "C)
            IF (IFXN .EQ. 4) THEN
                  CALL GDPSTI(COORDC)
                  CALL GDPSTI("m "C)
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
	WRITE(COORDC,'(F6.1,1X,F6.1,1X)')X,Y
      COORD(15) = 0
      CALL GDPSTI(COORDC)
      IF (IFXN .EQ. 3) THEN
            CALL GDPSTI("m "C)
          ELSE
            CALL GDPSTI("l "C)
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
C           CALL GDPSTI("stroke showpage "C)
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
C9000  CONTINUE
C      YA(1) = 3.0
C      RETURN
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
      INTEGER(1) BUFFER
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
      INTEGER(1) BUFFER
      COMMON /GDLSR/ NXTCHR, LUNOUT, BUFFER(IBUFR_SIZE)
C
      NXTCHR = 1
      RETURN
      END
      SUBROUTINE GDPSTI(STRING)
      CHARACTER*(*) STRING
      PARAMETER (IBUFR_SIZE = 80)
      INTEGER(1) BUFFER, IARY(1)
C
      COMMON /GDLSR/ NXTCHR, LUNOUT, BUFFER(IBUFR_SIZE)
C
      L = LEN_TRIM(STRING)
      IF ((NXTCHR+L) .GT. IBUFR_SIZE) CALL GDPSTD
            DO 100 I = 1, L
	      IARY=ICHAR(STRING(I:I))
            BUFFER(NXTCHR) = IARY(1)
            NXTCHR = NXTCHR + 1
100         CONTINUE
      RETURN
      END
      SUBROUTINE GDPSTD
C
      PARAMETER (IBUFR_SIZE = 80)
      INTEGER(1) BUFFER,CR,LF
      COMMON /GDLSR/ NXTCHR, LUNOUT, BUFFER(IBUFR_SIZE)
      DATA CR/13_1/,LF/10_1/
C
      IF (NXTCHR .EQ. 1) RETURN
      WRITE (LUNOUT,900) (BUFFER(I), I=1,NXTCHR-1), CR,LF
900   FORMAT(80A,A,A)
      NXTCHR = 1
      RETURN
      END
      SUBROUTINE POSTDMP
      LOGICAL*1 L_NOTHING_PLOTTED
      COMMON/POSTDCM/LUNPOS,INITPOST,L_NOTHING_PLOTTED
      IF(INITPOST.EQ.0)RETURN
      IF (.NOT. L_NOTHING_PLOTTED) THEN
            CALL GDPSTI("stroke showpage "C)
C            CALL GDPSTI(EOF) 
            CALL GDPSTD
      ENDIF
      CLOSE (UNIT=LUNPOS)
C      ISTATUS = LIB$SPAWN('$ DIGLASEROUT SYS$SCRATCH:POSTSCRPT.DIG')
      INITPOST=0
      RETURN
      END
      SUBROUTINE GSETLW(XLW)
      COMMON /GCDSEL/ IDEV
      DATA IDPSCRPT/4/
      CHARACTER CLW*27
      IF(IDEV.EQ.IDPSCRPT)THEN
            WRITE(CLW,90)XLW
90          FORMAT(' stroke',F5.2,' setlinewidth ')
                CLW(27:27)=CHAR(0)
            CALL GDPSTI(CLW)
        END IF
      RETURN
      END
      SUBROUTINE GDHPOL(IFXN,XA,YA)
C
C     This subroutine has an alternate entry point given by the ENTRY
C     statement.  You MUST remember to change that name also when
C     configuring for a different HPGL plotter!!!!!!!
C
C     HP PLOTTER DRIVER -- MODIFIED TO CREATE A FILE OF HPGL COMMANDS.
C
      CHARACTER CHOUT*80
      DIMENSION XA(8), YA(3)
C
C***********************************************************************
C                                                                      *
C     PLOTTER CONFIGURATION PARAMETERS                                 *
C                                                                      *
      PARAMETER (PLOTTER_ID = 7475.0)         !PLOTTER DESIGNATION     *
      PARAMETER (X_WIDTH_CM = 25.0)           !PAPER WIDTH IN CM.      *
      PARAMETER (Y_HEIGHT_CM = 18.0)          !PAPER HEIGHT IN CM.     *
      PARAMETER (X_RESOLUTION = 400.0)        !X GRAPHICS UNITS PER CM *
      PARAMETER (Y_RESOLUTION = 400.0)        !Y GRAPHICS UNITS PER CM *
      PARAMETER (FOREGROUND_COLORS =6.)       !NUMBER OF VIRTUAL PENS  *
      PARAMETER (MAX_COLOR_PENS=6)            !NUMBER OF PEN POSITIONS *
      PARAMETER (PEN_WIDTH_IN_PLOTTER_UNITS = 15.0) !                  *
      LOGICAL AUTO_PAGE_PLOTTER     !                                  *
      PARAMETER (AUTO_PAGE_PLOTTER = .FALSE.) !                        *
C                                                                      *
C***********************************************************************
C
C     DELCARE VARS NEEDED FOR DRIVER OPERATION
C
      LOGICAL LVECTOR_GOING, LPEN_UP, LTALL
C
      DIMENSION DCHAR(8)
C
C     MAKE NICE NAMES FOR THE DEVICES RESOLUTION IN X AND Y
C      ("XGUPCM" IS X GRAPHICS UNITS PER CENTIMETER)
C
      EQUIVALENCE (DCHAR(4),XGUPCM), (DCHAR(5),YGUPCM)
      DATA DCHAR /PLOTTER_ID, X_WIDTH_CM, Y_HEIGHT_CM,
     &   X_RESOLUTION, Y_RESOLUTION,FOREGROUND_COLORS,
     &   24.0, PEN_WIDTH_IN_PLOTTER_UNITS/
C
C-------------------------------------------------------------------------
C
C     REMEMBER THAT WE ARE PLOTTER LONG IF THRU THE TOP
C
      LTALL = .FALSE.
      GO TO 10
C
C     ######### ALTERNATE ENTRY POINT ###########
C
      ENTRY GDHPOT(IFXN,XA,YA)
      LTALL = .TRUE.
10    CONTINUE
C
C     FIRST VERIFY WE GOT A GRAPHICS FUNCTION WE CAN HANDLE
C
      IF (IFXN .LE. 0 .OR. IFXN .GT. 9) RETURN
C
C     NOW DISPATCH TO THE PROPER CODE TO HANDLE THAT FUNCTION
C
      GO TO (100,200,300,400,500,600,700,800) IFXN
C
C     *********************
C     INITIALIZE THE DEVICE
C     *********************
C
100   CONTINUE
      CALL FOUTINIT(CHOUT)                  !INIT. SERIAL OUTPUT ROUTINE
      CALL FOUTHP(CHAR(27)//'.(')           !PLOTTER ON
C      CALL FOUTHP(CHAR(27)//'.@;0:')        !NO HARDWIRED HANDSHAKE
      CALL FOUTHP(CHAR(27)//'.I128;;17:')   !XON/XOFF HANDSHAKE
      CALL FOUTHP(CHAR(27)//'.N;19:')       !XON/XOFF HANDSHAKE
      CALL FOUTHP('DF;')                    !SET PLOTTER DEFAULT VALUES
C
      IX_FULL_SCALE = X_RESOLUTION*X_WIDTH_CM
      IY_FULL_SCALE = Y_RESOLUTION*Y_HEIGHT_CM
      WRITE(CHOUT,900) IX_FULL_SCALE, IY_FULL_SCALE
900   FORMAT('SC0,',I8,',0,',I8,';')
      CALL FOUTHP(CHOUT)
      YA(1)=0.
      NUMBER_FOREGROUND_COLORS=FOREGROUND_COLORS
      NCOLOR_LAST=MAX_COLOR_PENS
      RETURN
C
C     **************************
C     GET FRESH PLOTTING SURFACE
C     **************************
C
200   CONTINUE
C      CALL FOUTHP('PU; SP0;')                 !PUT PEN AWAY
      LPEN_UP=.TRUE.
      LVECTOR_GOING = .FALSE.
      IF (AUTO_PAGE_PLOTTER) THEN
            CALL FOUTHP('WHATEVER')
          ELSE
            WRITE(*,90)
C90          FORMAT(' HPGL output to file DIGOUT.HPG',/,
C     &      'Enter pen speed as percent of maximum >',$)
90          FORMAT(' Enter pen speed as percent of maximum >',$)
            READ(*,91,IOSTAT=IOS)PCENT_SPEED
91          FORMAT(E12.5)
      ENDIF
      IF(PCENT_SPEED.GT.100..OR.PCENT_SPEED.LT.1..OR.IOS.NE.0)THEN
         CALL FOUTHP('SP1;VS;')                     !GET PEN 1
      ELSE
         PEN_SPEED=0.391*PCENT_SPEED
         WRITE(CHOUT,904)PEN_SPEED
904      FORMAT('SP1;VS',F6.3,';')
         CALL FOUTHP(CHOUT)
      END IF
      RETURN
C
C     ****
C     MOVE
C     ****
C
300   CONTINUE
      IF (.NOT. LPEN_UP) THEN
            IF (LVECTOR_GOING) THEN
                  CALL FOUTHP(';')
                  LVECTOR_GOING = .FALSE.
            ENDIF
            CALL FOUTHP('PU;')
            LPEN_UP = .TRUE.
      ENDIF
      GO TO 450
C
C     ****
C     DRAW
C     ****
C
400   CONTINUE
      IF (LPEN_UP) THEN
            IF (LVECTOR_GOING) THEN
                  CALL FOUTHP(';')
                  LVECTOR_GOING = .FALSE.
            ENDIF
            CALL FOUTHP('PD;')
            LPEN_UP = .FALSE.
      ENDIF
450   CONTINUE
      IXPOSN = XGUPCM*XA(1)+0.5
      IYPOSN = YGUPCM*YA(1)+0.5
      IF (LTALL) THEN
C                             PLOTTER X = TALL_Y
C                             PLOTTER Y = Y_FULL_SCALE - TALL_X
            ITEMP = IXPOSN
            IXPOSN = IYPOSN
            IYPOSN = IY_FULL_SCALE - ITEMP
      ENDIF
      IF (LVECTOR_GOING) THEN
            CALL FOUTHP(',')
          ELSE
            CALL FOUTHP('PA')
            LVECTOR_GOING = .TRUE.
      ENDIF
      WRITE(CHOUT,901)IXPOSN,IYPOSN
901   FORMAT(I8,',',I8)
      CALL FOUTHP(CHOUT)
      RETURN
C
C     *****************************
C     FLUSH GRAPHICS COMMAND BUFFER
C     *****************************
C
500   CONTINUE
      IF (LVECTOR_GOING) THEN
            CALL FOUTHP(';')
            LVECTOR_GOING = .FALSE.
      ENDIF
      IF (.NOT. LPEN_UP) THEN
            CALL FOUTHP('PU;')
            LPEN_UP = .TRUE.
      ENDIF
      CALL FOUTHP('  ')
C      CALL GB_EMPTY
      RETURN
C
C     ******************
C     RELEASE THE DEVICE
C     ******************
C
600   CONTINUE
C      CALL GB_EMPTY
      IX_OUT=0
      IY_OUT=IY_FULL_SCALE/2
      WRITE(CHOUT,902)IX_OUT,IY_OUT
902   FORMAT('PU;SP0;PA',I8,',',I8,';')
      CALL FOUTHP(CHOUT)
      LPEN_UP=.TRUE.
      CALL FOUTHP(CHAR(27)//'.)')    !PLOTTER OFF WHEN Y/D SWITCH TO Y
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
      IF (LTALL) THEN
            XA(2) = DCHAR(3)
            XA(3) = DCHAR(2)
            XA(4) = DCHAR(5)
            XA(5) = DCHAR(4)
      ENDIF
      RETURN
C
C     ****************************
C     SELECT CURRENT DRAWING COLOR
C     ****************************
C
800   CONTINUE
      IF (LVECTOR_GOING) THEN
            CALL FOUTHP(';')
            LVECTOR_GOING = .FALSE.
      ENDIF
      IF (.NOT. LPEN_UP) THEN
            CALL FOUTHP('PU;')
            LPEN_UP = .TRUE.
      ENDIF
      ICOLOR = XA(1)
      IF (ICOLOR .LE. 0 .OR. ICOLOR.GT.NUMBER_FOREGROUND_COLORS) RETURN
      IF (ICOLOR .GE. MAX_COLOR_PENS)THEN
         IF(ICOLOR.NE.NCOLOR_LAST) THEN
            CALL FOUTHP('SP0;')
            WRITE(*,297)ICOLOR,MAX_COLOR_PENS
297         FORMAT($,' INSERT PEN FOR COLOR',I3,' IN PEN POSITION',I3,
     &      ' >')
            READ(*,905)CHOUT
905         FORMAT(A)
            NCOLOR_LAST=ICOLOR
         END IF
         ICOLOR=MAX_COLOR_PENS
      END IF
      WRITE(CHOUT,903)ICOLOR
903   FORMAT('SP',I3,';')
      CALL FOUTHP(CHOUT)
      RETURN
      END
      SUBROUTINE FOUTINIT(CHOUT)
C
C     FOUTINIT OPENS THE OUTPUT FILE FOR HPGL COMMANDS
C     ENTRY FOUTHP writes characters from to the file
C
      SAVE
      CHARACTER CHOUT*(*),HPOUT*60
1     WRITE(*,'('' File name for HPGL output >'',$)')
      READ(*,'(A)')HPOUT
      IF(HPOUT.EQ.' ')HPOUT='DIGOUT.HPG'
      CLOSE(UNIT=34,ERR=2)
2     OPEN (UNIT=34,FILE=HPOUT,STATUS='NEW',ERR=704)
      RETURN
704   WRITE(*,705)HPOUT
705   FORMAT(' Error opening file ',A)
      GO TO 1
C
C********************** WRITE CHARACTERS TO PLOTTER ****************
C
      ENTRY FOUTHP(CHOUT)
C
      WRITE(34,900)CHOUT
900   FORMAT(A)
      RETURN
      END
      SUBROUTINE AXIS(BLOW,BHIGH,MAXTKS,LSHORT,LRAGGD,BMIN,BMAX,
     &   BTMIN,BTMAX,BTICK,IPWR)
      LOGICAL*1 LSHORT, LRAGGD
C
C     THIS SUBROUTINE IS MAINLY FOR INTERNAL USE,
C     ITS FUNCTION IS TO DETERMINE A SUITABLE
C     "TICK" DISTANCE OVER THE RANGE SPECIFIED BETWEEN
C     ALOW AND AHIGH.   IT OUTPUTS THE AXIS RANGE BMIN,BMAX
C     AND THE TICK DISTANCE BTICK STRIPPED OF THEIR POWER OF
C     TEN.   THE POWER OF TEN IS RETURNED IN THE VAR. IPWR.
C
      DIMENSION JTICKS(6)
      LOGICAL LDIVDS
      LOGICAL*1 LISNEG
C
C     IF A RAGGED AXIS IS "TOO CLOSE" TO THE NEXT TICK, THEN EXTEND IT.
C      THE "TOO CLOSE" PARAMETER IS THE VARIABLE TOOCLS
C
      DATA TOOCLS /0.8/
C
      DATA FUZZ /0.001/
      DATA JTICKS /1,2,5,4,3,10/
C
C
      MAXTKS = MAX0(1,MAXTKS)
      MINTKS = MAX0(1,MAXTKS/2)
      BMAX = BHIGH
      BMIN = BLOW
      LISNEG = .FALSE.
      IF (BMAX .GE. BMIN) GO TO 30
      BMAX = BLOW
      BMIN = BHIGH
      LISNEG = .TRUE.
C
C     MAKE SURE WE HAVE ENOUGH RANGE, IF NOT, INCREASE AHIGH
C
30    RANGE = BMAX - BMIN
      TEMP = AMAX1(ABS(BMIN),ABS(BMAX))
      IF (TEMP .EQ. 0.0) TEMP = 10.0
      IF (RANGE/TEMP .GE. 5.0E-3) GO TO 40
            BMIN = BMIN - 5.0E-3*TEMP
            BMAX = BMAX + 5.0E-3*TEMP
40    CONTINUE
C
C     STRIP THE RANGE OF ITS POWER OF TEN
C
      IPWR=ALOG10(BMAX-BMIN)-2
50    TENX = 10.0**IPWR
      ASTRT = AINT(BMIN/TENX)
      AFIN = AINT(BMAX/TENX+0.999)
      IF (AFIN*TENX .LT. BMAX) AFIN = AFIN + 1
      RANGE = AFIN - ASTRT
      IF (RANGE .LE. 10*MAXTKS) GO TO 75
      IPWR = IPWR + 1
      GO TO 50
75    CONTINUE
C
C     SEARCH FOR A SUITABLE TICK
C
D     TYPE 9999, BMIN, ASTRT, BMAX, AFIN, TENX
D9999 FORMAT(/' AXIS DEBUG'/'      DATA          STRIPPED'/
D    &   2(1X,G14.7,2X,G14.7/)/' POWER = ',G14.7)
      BTICK = 0
      DO 100 I=1,6
      TICK = JTICKS(I)
      NTICK = RANGE/TICK+0.999
      IF (NTICK .LT. MINTKS .OR. NTICK .GT. MAXTKS) GO TO 100
      IF (LDIVDS(ASTRT,TICK) .AND. LDIVDS(AFIN,TICK)) GO TO 150
      IF (BTICK .EQ. 0) BTICK = TICK
100   CONTINUE
C
C     USE BEST NON-PERFECT TICK
C
      GO TO 160
C
C     FOUND A GOOD TICK
C
150   BTICK=JTICKS(I)
160   CONTINUE
      IF (BTICK .NE. 10.0) GO TO 165
        BTICK = 1.0
        IPWR = IPWR + 1
        TENX = 10.0*TENX
165   TICK = BTICK*TENX
C
C     FIGURE OUT TICK LIMITS
C
      BTMIN = BTICK*AINT(BMIN/TICK)
      IF (BTMIN*TENX .LT. BMIN) BTMIN = BTMIN + BTICK
      BTMAX = BTICK*AINT(BMAX/TICK)
      IF (BTMAX*TENX .GT. BMAX) BTMAX = BTMAX - BTICK
      NINTVL = (BTMAX-BTMIN)/BTICK
C
C     IF USER ABSOLUTELY MUST HAVE RAGGED AXIS, THEN FORCE IT.
C
      IF (LSHORT .AND. LRAGGD) GO TO 180
C
C     CHECK INDIVIDUALLY
C
      IF (LSHORT .AND. (NINTVL .GT. 0) .AND.
     &   ((BTMIN-BMIN/TENX)/BTICK .LE. TOOCLS) ) GO TO 170
        IF ((BTMIN-BMIN/TENX) .GT. FUZZ) BTMIN = BTMIN - BTICK
        BMIN = BTMIN*TENX
170   CONTINUE
      IF (LSHORT .AND. (NINTVL .GT. 0) .AND.
     &   ((BMAX/TENX-BTMAX)/BTICK .LE. TOOCLS) ) GO TO 180
        IF ((BMAX/TENX-BTMAX) .GT. FUZZ) BTMAX = BTMAX + BTICK
        BMAX = BTMAX*TENX
180   CONTINUE
      IF (.NOT. LISNEG) GO TO 200
C     SWITCH BACK TO BACKWARDS
      BTICK = -BTICK
      TEMP = BMIN
      BMIN = BMAX
      BMAX = TEMP
      TEMP = BTMIN
      BTMIN = BTMAX
      BTMAX = TEMP
200   RETURN
      END
      FUNCTION LDIVDS(ANUMER,ADENOM)
      LOGICAL LDIVDS
      IF (ANUMER/ADENOM .EQ. AINT(ANUMER/ADENOM)) GO TO 10
      LDIVDS = .FALSE.
      RETURN
10    LDIVDS = .TRUE.
      RETURN
      END
      SUBROUTINE BARGRA(XLOW,XHIGH,NOBARS,IMXPTS,X,
     &                 SXLAB,SYLAB,STITLE,TYPE)
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
C     PROJECT NAME: GRAPHICS UTILITY
C     FILE NAME   : BARGRA.FOR
C     ROUTINE NAME: BARGRA
C     ROUTINE TYPE: SUBROUTINE
C     LANGUAGE    : COMPATIBLE FORTRAN
C
C     VERSION     : 1
C
C     ORIGINAL AUTHOR: JOE P GARBARINI JR
C     DATE           : 02-JUL-82
C
C     MAINTAINER     : HAL R BRAND L126 X26313 (DIGLIB V2 VERSION)
C
C     REVISION: 0
C       REVISION AUTHOR:
C       REVISION DATE  :
C       REVISION NOTES :
C
C     SUMMARY:
C
C           This routine makes a bar graph (frequency graph)
C           from an array of real data.
C
C     INPUT VARIABLES:
C
C           XLOW  : REAL*4 CONSTANT OR VARIABLE.
C                 THE LOW LIMIT FOR THE X-AXIS.
C                 MUST HAVE XLOW <= X(I) FOR ALL I.
C           XHIGH : REAL*4 CONSTANT OR VARIABLE.
C                 THE HIGH LIMIT FOR THE X-AXIS.
C                 MUST HAVE X(I) <= XHIGH FOR ALL I.
C           NOBARS: INTEGER CONSTANT OR VARIABLE.
C                 THE NUMBER OF BARS TO DRAW.
C                 1 <= *NOBARS* <= 200
C                 SEE LOCAL VARIABLE *IMXC*.
C           IMXPTS: INTEGER CONSTANT OR VARIABLE.
C                 THE DIMESION OF ARRAY *X*.
C           X     : REAL*4 VARIABLE.
C                 THE ARRAY OF REAL DATA TO GRAPH.
C           SXLAB : CHARACTER*1 CONSTANT OR VARIABLE.
C                 THE X-AXIS LABLE.
C           SYLAB : CHARACTER*1 CONSTANT OR VARIABLE.
C                 THE Y-AXIS LABLE.
C           STITLE: CHARACTER*1 CONSTANT OR VARIABLE.
C                 THE TITLE.
C           TYPE  : INTEGER CONSTANT OR VARIABLE.
C                 THE AXIS FLAG.  SEE *DIGLIB* DOCUMENTATION.
C
C     OUTPUT VARIABLES: NONE
C
C     INOUT VARIABLES: NONE
C
C     COMMON VARIABLES: NONE
C
C     LOCAL VARIABLES: SEE CODE.
C
C     EXCEPTION HANDLING: NONE
C
C     SIDE EFFECTS: NONE
C
C     PROGRAMMING NOTES:
C
C           This routine does all the calls to DIGLIB necessary
C           to do the plot EXCEPT for a call to DEVSEL.  This
C           way the calling program can choose the device.
C
C           DIGLIB's MAPIT routine uses its own rules for the
C           actual lowest and highest values on the axes.  They
C           always include the users values.  If you wish to move
C           the bar graph away from the left and/or (imaginary) right
C           y axis do the following:
C
C           Let S = (XH - XL) / NOBARS where XH = max X(i)
C           and XL = min X(i).  Now set XLOW = XL - N * S
C           XHIGH = XH + M * S where N,M are chosen at your discretion.
C
C           MAKE SURE THAT XLOW <= X(I) <= XHIGH FOR ALL I.
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
      INTEGER IMXPTS,NOBARS,TYPE
      REAL*4    XLOW,XHIGH
      REAL*4    X
      DIMENSION X(IMXPTS)
      CHARACTER*20 SXLAB,SYLAB,STITLE
C
      INTEGER I,J,IMXC
      REAL*4    COUNT(200),STEP,FBAR,YLOW,YHIGH,X0,Y0,VX0,VX1
      REAL*4    VY0,VY1,FIMX
C
      IMXC   = 200
      YLOW   = 0.0
      YHIGH  = 1.0
      FBAR   = FLOAT(NOBARS)
C
      IF (XLOW .GE. XHIGH) GOTO 9999
      IF (NOBARS .GT. IMXC) GOTO 9999
C
      STEP   = (XHIGH - XLOW) / FBAR
C
      DO 100 I = 1,NOBARS
C
          COUNT(I) = 0.0
C
 100  CONTINUE
C
      DO 200 I = 1,IMXPTS
C
          J      = INT((X(I)-XLOW)/STEP)+1
          IF (J .GT. NOBARS) J = NOBARS
          COUNT(J) = COUNT(J) + 1.0
C
 200  CONTINUE
C
      FIMX   = FLOAT(IMXPTS) * STEP
C
      DO 300 I = 1,NOBARS
C
          COUNT(I) = COUNT(I) / FIMX
C
 300  CONTINUE
C
      CALL MINMAX(COUNT,NOBARS,YLOW,YHIGH)
      YLOW   = 0.0
      YHIGH  = YHIGH + 0.1 * YHIGH
C
      CALL BGNPLT
      CALL MAPSIZ(0.0,100.0,0.0,100.0,0.0)
      CALL MAPIT(XLOW,XHIGH,YLOW,YHIGH,SXLAB,SYLAB,STITLE,TYPE)
C
      X0     = XLOW
      Y0     = 0.0
      CALL SCALE(X0,Y0,VX0,VY0)
      CALL GSMOVE(VX0,VY0)
C
      DO 400 I = 1,NOBARS
C
          X0     = XLOW + I * STEP
          Y0     = COUNT(I)
          CALL SCALE(X0,Y0,VX1,VY1)
          CALL GSDRAW(VX0,VY1)
          CALL GSDRAW(VX1,VY1)
          CALL GSDRAW(VX1,VY0)
C
          VX0    = VX1
C
 400  CONTINUE
C
      CALL ENDPLT
C
 9999 CONTINUE
C
C     BYE
C
      RETURN
      END
      SUBROUTINE BGNPLT
      REAL(4) X(1),Y(1)
C
C
      CALL GSDRVR(2,X,Y)
      RETURN
      END
      SUBROUTINE CLLINE(X1,Y1,X2,Y2)
C
C     THIS SUBROUTINE DRAWS THE LINE FROM X1,Y1 TO X2,Y2 WITH
C     THE APPROPIATE CLIPPING
C
      INCLUDE 'PLTSIZ.PRM'
C
      DIMENSION AREA(4)
C
      CALL GSSCLP(XVSTRT,XVSTRT+XVLEN,YVSTRT,YVSTRT+YVLEN,AREA)
      CALL SCALE(X1,Y1,VX,VY)
      CALL GSMOVE(VX,VY)
      CALL SCALE(X2,Y2,VX,VY)
      CALL GSDRAW(VX,VY)
      CALL GSRCLP(AREA)
      RETURN
      END
      FUNCTION CSZMAP()
      INCLUDE 'PLTPRM.PRM'
C
C     RETURN CHARACTER SIZE MAP USED/WILL USE
C
      CSZMAP = CYSIZE
      RETURN
      END
      SUBROUTINE CURSOR(X,Y,KEY)
      INTEGER*1 KEY
C
C     DISPLAY AND READ THE GRAPHICS CURSOR AND RETURN ITS POSITION
C     IN USER COORDINATES.
C
      INCLUDE 'PLTCOM.PRM'
      INCLUDE 'PLTSIZ.PRM'
C
C     GET CURSOR POSITION IN VIRTUAL COORDINATES.
C
      CALL GSGIN(X,Y,KEY,IERR)
      IF (IERR .GE. 0) GO TO 50
      X = XVSTRT
      Y = YVSTRT
50    X = (X-XVSTRT)*UDX/XVLEN + UX0
      IF (LOGX) X = 10.0**X
      Y = (Y-YVSTRT)*UDY/YVLEN + UY0
      IF (LOGY) Y = 10.0**Y
      RETURN
      END
      SUBROUTINE CURVE(X,Y,NPTS,ISYMNO,SYMSIZ,NPBSYM)
      DIMENSION X(NPTS), Y(NPTS)
C
C     THIS SUBROUTINE TRACES THE LINE FROM X(1),Y(1) TO
C     X(NPTS),Y(NPTS) WITH APPROPIATE CLIPPING.
C     IT THEN ADDS THE DESIRED SYMBOL (ISYMNO) TO THE PLOT SPACED
C     "NPBSYM" POINTS APART.
C
      DIMENSION AREA(4)
C
      INCLUDE 'GCLTYP.PRM'
      INCLUDE 'PLTSIZ.PRM'
C
      CALL GSSCLP(XVSTRT,XVSTRT+XVLEN,YVSTRT,YVSTRT+YVLEN,AREA)
      CALL SCALE(X(1),Y(1),VX,VY)
      CALL GSMOVE(VX,VY)
      IF (NPTS .LE. 1) GO TO 110
10    DO 100 I=2,NPTS
      CALL SCALE(X(I),Y(I),VX,VY)
      CALL GSDRAW(VX,VY)
100   CONTINUE
C
C     NOW ADD SYMBOLS IF DESIRED
C
110   CONTINUE
      IF (ISYMNO .LE. 0) GO TO 800
C
C     SAVE LINE TYPE, AND DO SYMBOLS IN SOLID LINES
C
      IOLDLT = ILNTYP
      ILNTYP = 1
      DO 200 I=1, NPTS, NPBSYM
      CALL SCALE(X(I),Y(I),VX,VY)
      CALL GSMOVE(VX,VY)
      CALL SYMBOL(ISYMNO,SYMSIZ)
200   CONTINUE
C
C     RESTORE LINE TYPE
C
      ILNTYP = IOLDLT
800   CONTINUE
      CALL GSRCLP(AREA)
      RETURN
      END
      SUBROUTINE CURVEY(XMIN,XMAX,Y,NPTS,ISYMNO,SYMSIZ,NPBSYM)
      DIMENSION Y(NPTS)
C
C     THIS SUBROUTINE TRACES THE LINE FROM X(1),Y(1) TO
C     X(NPTS),Y(NPTS) WITH APPROPIATE CLIPPING.
C     USE THIS ROUTINE WHEN CLIPPING IS DESIRED AND THE
C     INDEPENDANT VARIABLE IS IMPLIED BY THE SUBSCRIPT
C     USING EQUAL INTERVALS FROM XMIN TO XMAX.
C        IT THEN ADDS THE DESIRED SYMBOL IN THE REQUIRED SIZE SPACED
C     EVERY "NPBSYM" POINTS APART.
C
      DIMENSION AREA(4)
C
      INCLUDE 'GCLTYP.PRM'
      INCLUDE 'PLTSIZ.PRM'
C
      CALL GSSCLP(XVSTRT,XVSTRT+XVLEN,YVSTRT,YVSTRT+YVLEN,AREA)
      CALL SCALE(XMIN,Y(1),VX,VY)
      CALL GSMOVE(VX,VY)
10    DX = (XMAX-XMIN)/(NPTS-1)
      XNEW = XMIN
      DO 100 I=2,NPTS
      XNEW = XMIN + (I-1)*DX
      CALL SCALE(XNEW,Y(I),VX,VY)
100   CALL GSDRAW(VX,VY)
C
C     NOW ADD SYMBOLS IF DESIRED
C
      IF (ISYMNO .LE. 0) GO TO 800
      IOLDLT = ILNTYP
      ILNTYP = 1
      DO 200 I=1,NPTS,NPBSYM
      XNEW = XMIN + (I-1)*DX
      CALL SCALE(XNEW,Y(I),VX,VY)
      CALL GSMOVE(VX,VY)
      CALL SYMBOL(ISYMNO,SYMSIZ)
200   CONTINUE
      ILNTYP = IOLDLT
800   CONTINUE
      CALL GSRCLP(AREA)
      RETURN
      END
      SUBROUTINE DEVSEL(NEWDEV,LUN,IERR)
C
C     Make sure the block data routines get linked
C
      EXTERNAL DIGINIT
      EXTERNAL GDPOSD
C
      INCLUDE 'GCDSEL.PRM'
      INCLUDE 'GCDPRM.PRM'
      INCLUDE 'GCCPAR.PRM'
      INCLUDE 'GCVPOS.PRM'
      INCLUDE 'GCAPOS.PRM'
      INCLUDE 'GCCLIP.PRM'
      INCLUDE 'GCDCHR.PRM'
      INCLUDE 'GCLTYP.PRM'
      DIMENSION DEVCHR(8), GDCOMN(5), ARRAY(1), DUMMY(1)
      DIMENSION DFDIST(4,3)
C
C     DEFINE DEFAULT LINE STYLES
C
      EQUIVALENCE (DEVID,GDCOMN(1))
      DATA DFDIST /
     &    0.5,  0.5,  0.5,  0.5,
     &   0.25, 0.25, 0.25, 0.25,
     &    0.5, 0.25, 0.25, 0.25/
C
C     RELEASE CURRENT DEVICE
C
      IF (IDEV .NE. 0) CALL GSDRVR(6,DUMMY,DUMMY)
C
C     NOW INIT. THE NEW DEVICE
C
      IF (NEWDEV .LE. 0) GO TO 900
      IDEV = NEWDEV
C
C     GET THE DEVICE CHARACTERISTICS (AND SEE IF DEVICE THERE)
C
      DEVCHR(8) = 1.0
      CALL GSDRVR(7,DEVCHR,DUMMY)
      IF (DEVCHR(1) .EQ. 0.0) GO TO 900
C
C     INITIALIZE THE DEVICE FOR DIGLIB GRAPHICS
C
      ARRAY(1)=FLOAT(LUN)
      CALL GSDRVR(1,ARRAY,DUMMY)
      IERR = DUMMY(1)+.5
      IF (IERR .NE. 0) GO TO 910
C
C     SET DEVICE CHARACTERISTICS FOR LATER USE
C
      DO 100 I=1,5
100   GDCOMN(I) = DEVCHR(I)
      NDCLRS = DEVCHR(6)
      IDVBTS = DEVCHR(7)
      NFLINE = DEVCHR(8)
      XCLIPD = XLENCM + 0.499/DEVCHR(4)
      YCLIPD = YLENCM + 0.499/DEVCHR(5)
C
C     NOW INIT THE PARAMETERS
C
      XS = 1.0
      YS = 1.0
      XT = 0.0
      YT = 0.0
      RCOS = 1.0
      RSIN = 0.0
      CSIZE = GOODCS(0.3)
      CCOS = 1.0
      CSIN = 0.0
      XCUR = 0.0
      YCUR = 0.0
      IVIS = 0
      XCM0 = 0.0
      YCM0 = 0.0
      XCM1 = XCLIPD
      YCM1 = YCLIPD
      ILNTYP = 1
            DO 120 I=1,3
                  DO 110 J=1,4
                  DIST(J,I) = DFDIST(J,I)
110               CONTINUE
120         CONTINUE
      LCURNT = .FALSE.
      RETURN
C
C     NON-EXISTANT DEVICE SELECTED, REPORT ERROR AND DESELECT DEVICE
C
900   IERR = -1
C
C     DEVICE INITIALIZATION FAILED, DESELCT DEVICE
C
910   IDEV = 0
      RETURN
      END
      SUBROUTINE ENDPLT
C
      REAL(4) X(1),Y(1)
      CALL GSDRVR(5,X,Y)
      RETURN
      END
      SUBROUTINE FULMAP
C
      INCLUDE 'GCDCHR.PRM'
C
C     DEFINE BORDER SIZE
C
      DATA BORDER /0.15/
C
C     SET THE PLOTING AREA TO THE WHOLE SCREEN
C
      CALL PLTBOX(BORDER,XLENCM-BORDER,BORDER,YLENCM-BORDER)
      RETURN
      END
      FUNCTION GOODCS(APPROX)
      INCLUDE 'GCDCHR.PRM'
      INCLUDE 'GCDPRM.PRM'
      DATA YCELL /8.0/
C
C     CALCULATE MINIMUM VIRTUAL COORD. SIZE OF CHARS THAT ARE READALBE WITH
C      THE DEVICES RESOLUTION.
C
      SIZE = (YCELL/YRES)/YS
C
C     NOW SCALE UP THIS MINIMUM SIZE SO THAT CHARACTERS ARE ABOUT
C      THE SIZE DESIRED.
C
      N = APPROX/SIZE + 0.25
C
C     MUST BE ATLEAST N=1
C
      IF (N .EQ. 0) N=1
C
C     NOW RETURN OUR ANSWER
C
      GOODCS = N*SIZE
      RETURN
      END
      SUBROUTINE GRAFIN(X,Y,LFLAG)
      INTEGER LFLAG
C
C     DISPLAY AND READ THE GRAPHICS CURSOR AND RETURN ITS POSITION
C     IN WORLD COORDINATES.
C
      INCLUDE 'PLTCOM.PRM'
      INCLUDE 'PLTSIZ.PRM'
C
C     GET CURSOR POSITION IN VIRTUAL COORDINATES.
C
      CALL GSCRSR(X,Y,LFLAG,IERR)
      IF (IERR .NE. 0) RETURN
      X = (X-XVSTRT)*UDX/XVLEN + UX0
      IF (LOGX) X = 10.0**X
      Y = (Y-YVSTRT)*UDY/YVLEN + UY0
      IF (LOGY) Y = 10.0**Y
      RETURN
      END
      SUBROUTINE GSCCLC(X,Y,DX,DY)
C
C     THIS SUBROUTINE DOES THE CHARACTER SIZING AND ROTATION.
C
      INCLUDE 'GCCPAR.PRM'
      INCLUDE 'GCCOFF.PRM'
C
      XS = X*CSIZE
      YS = Y*CSIZE
      DX = CCOS*XS + CSIN*YS + XOFF
      DY = CCOS*YS - CSIN*XS + YOFF
      RETURN
      END
      SUBROUTINE GSCCMP(IX,IY,XOFF,YOFF,X,Y)
C
C
      INCLUDE 'GCCPAR.PRM'
      INCLUDE 'GCAPOS.PRM'
C
C     SCALE TO PROPER SIZE
C
      XS = CSIZE*IX
      YS = CSIZE*IY
C
C     ROTATE AND TRANSLATE
C
      X = CCOS*XS + CSIN*YS + XOFF
      Y = CCOS*YS - CSIN*XS + YOFF
D     TYPE 9999, IX, IY, X,Y
D9999 FORMAT(' CMOVE TO (',I2,',',I2,') GOES TO (',F9.4,',',F9.4,')')
      RETURN
      END
      SUBROUTINE GSCGET(IPTR,DX,DY,LMOVE)
C
C     THIS SUBROUTINE GETS THE NEXT NODE (POINT) ON THE CHARACTER
C     BASED UPON "IPTR".   IT THEN SCALES AND ROTATES IT.
C
      LOGICAL LMOVE
      INCLUDE 'GCCTBL.PRM'
C
      LMOVE = .FALSE.
50    IF (BX(IPTR) .NE. -64) GO TO 100
      LMOVE = .TRUE.
      IPTR = IPTR + 1
      GO TO 50
100   X=BX(IPTR)
      Y=BY(IPTR)
      CALL GSCCLC(X,Y,DX,DY)
      IPTR = IPTR + 1
      END
      FUNCTION GSCHIT()
C
C     THIS FUNCTION RETURNS THE "HEIGHT" OF A CAPITAL LETTER
C     IN THE CHARACTER STROKE TABLE.   ALL CHARACTERS ARE STROKED
C     FROM POINTS (COORDINATE PAIRS) STORED IN A STROKE TABLE.
C     CAPITAL LETTERS ARE DEFINED ON A GRID SO THAT (0,0) IS AT THE
C     LOWER LEFT CORNER OF THE CHARACTER CELL, AND (GSCWID(),GSCHIT())
C     IS AT THE UPPER RIGHT BOUNDARY.   NOTE, GSCWID() INCLUDES THE
C     SPACE BETWEEN CHARACTERS, THAT IS, CHARACTERS ARE GSCWID() APART.
C
      GSCHIT = 8.0
      RETURN
      END
      SUBROUTINE GSCOLR(ICOLOR,IERR)
      INCLUDE 'GCDCHR.PRM'
      REAL(4) ARRAY(1),DUMMY(1)
C
C     SELECT COLOR "ICOLOR" ON CURRENT DEVICE
C
      LOGICAL*1 LNOBKG
      IERR = 0
C
C     LNOBKG SET TO TRUE IF NO BACKGROUND COLOR EXISTS ON THIS DEVICE
C
      LNOBKG = IAND(IDVBTS,4) .EQ. 0
C
C     FIRST, ERROR IF BACKGROUND COLOR REQUESTED AND DEVICE DOES NOT
C     SUPPORT BACKGROUND COLOR WRITE.
C
      IF (ICOLOR .EQ. 0 .AND. LNOBKG) GO TO 900
C
C     SECOND, ERROR IF COLOR REQUESTED IS LARGER THAN THE NUMBER OF
C     FOREGROUND COLORS AVAILABLE ON THIS DEVICE
C
      IF (ICOLOR .GT. NDCLRS) GO TO 900
C
C     IF ONLY 1 FOREGROUND COLOR AND NO BACKGROUND COLOR, THEN
C     DRIVER WILL NOT SUPPORT SET COLOR, AND OF COURSE, THE
C     COLOR MUST BE COLOR 1 TO HAVE GOTTEN THIS FAR, SO JUST RETURN
C
      IF (NDCLRS .EQ. 1 .AND. LNOBKG) RETURN
C
C     ALL IS OK, SO SET THE REQUESTED COLOR
C
      ARRAY(1)=FLOAT(ICOLOR)
100   CALL GSDRVR(8,ARRAY,DUMMY)
      RETURN
900   IERR = -1
      RETURN
      END
      SUBROUTINE GSCRSR(X,Y,IBUTN,IERR)
C
C     THIS DIGLIB SUBROUTINE TRIES TO GET GRAPHIC INPUT FROM
C     THE CURRENTLY SELECTED DEVICE.   IF THE DEVICE IS NOT CAPABLE
C     OF IT, IERR=-1, ELSE IERR=0 AND:
C       X   = X POSITION OF CURSOR IN VIRTUAL COORDINATES
C       Y   = Y POSITION OF CURSOR IN VIRTUAL COORDINATES
C       IBUTN     = NEW BUTTON STATE
C
      INCLUDE 'GCDCHR.PRM'
      INCLUDE 'GCDPRM.PRM'
      DIMENSION ARRAY(3),DUMMY(1)
C
C     SEE IF DEVICE SUPPORTS CURSOR
C
      IF (IAND(IDVBTS,1024) .EQ. 0) GO TO 900
C
C     NOW ASK FOR CURSOR FROM DEVICE DRIVER
C
      CALL GSDRVR(12,ARRAY,DUMMY)
C
C     CONVERT ABSOLUTE CM. COORD. TO VIRTUAL COORDINATES
C
      CALL GSIRST(ARRAY(2),ARRAY(3),X,Y)
C
C     GET BUTTON STATE
C
      IBUTN = ARRAY(1)
120   CONTINUE
      IERR = 0
      RETURN
C
C     DEVICE DOESN'T SUPPORT GIN
C
900   IERR = -1
      RETURN
      END
      FUNCTION GSCWID()
C
C     THIS FUNCTION RETURNS THE "WIDTH" OF A CAPITAL LETTER
C     IN THE CHARACTER STROKE TABLE.   ALL CHARACTERS ARE STROKED
C     FROM POINTS (COORDINATE PAIRS) STORED IN A STROKE TABLE.
C     CAPITAL LETTERS ARE DEFINED ON A GRID SO THAT (0,0) IS AT THE
C     LOWER LEFT CORNER OF THE CHARACTER CELL, AND (GSCWID(),GSCHIT())
C     IS AT THE UPPER RIGHT BOUNDARY.   NOTE, GSCWID() INCLUDES THE
C     SPACE BETWEEN CHARACTERS, THAT IS, CHARACTERS ARE GSCWID() APART.
C
      GSCWID = 9.0
      RETURN
      END
      SUBROUTINE GSDLNS(ILTYPE,ON1,OFF1,ON2,OFF2)
C
C     Define LiNe Style
C
      INCLUDE 'GCLTYP.PRM'
C
      IF (ILTYPE .LT. 2 .OR. ILTYPE .GT. 4) RETURN
      INDEX = ILTYPE-1
      DIST(1,INDEX) = ON1
      DIST(2,INDEX) = OFF1
      DIST(3,INDEX) = ON2
      DIST(4,INDEX) = OFF2
      RETURN
      END
      SUBROUTINE GSDRAW(X,Y)
C
C
      INCLUDE 'GCVPOS.PRM'
      INCLUDE 'GCAPOS.PRM'
      INTEGER GSIVIS
C
C     TRANSFORM VIRT. COOR. TO SCREEN COORD.
C
D     TYPE *,'OLD POSITION ',XAPOS,YAPOS,IVIS
      XVPOS = X
      YVPOS = Y
      CALL GSRST(XVPOS,YVPOS,X1,Y1)
      IVIS1 = GSIVIS(X1,Y1)
      CALL GSDRW2(XAPOS,YAPOS,IVIS,X1,Y1,IVIS1)
      XAPOS = X1
      YAPOS = Y1
      IVIS = IVIS1
D     TYPE *,'NEW POSITION ',XAPOS,YAPOS,IVIS
      RETURN
      END
      SUBROUTINE GSDRGB(ICOLOR,RED,GRN,BLU,IERR)
      INCLUDE 'GCDCHR.PRM'
      DIMENSION RGB(3),ARRAY(1)
C
C     DEFINE A COLOR
C
      IF ( IAND(IDVBTS,64) .EQ. 0 .OR.
     &   (ICOLOR .GT. NDCLRS) .OR.
     &   (ICOLOR .LT. 0)) THEN
	   IERR=-1
	ELSE
         IERR = 0
         RGB(1) = RED
         RGB(2) = GRN
         RGB(3) = BLU
         ARRAY(1)=FLOAT(ICOLOR)
         CALL GSDRVR(10,ARRAY,RGB)
	END IF
      RETURN
      END
      SUBROUTINE GSDRVR(IFXN,X,Y)
C
C
      INCLUDE 'GCDSEL.PRM'
      DATA MAXDEV /6/
      REAL(4) X(*),Y(*)
C
C     SEE IF DEVICE EXISTS
C
      IF (IDEV .GT. 0 .AND. IDEV .LE. MAXDEV) GO TO 50
C
C     NON-EXISTANT DEVICE, SO SEE IF USER IS JUST ENQUIRING??
C
      IF (IFXN .NE. 7) RETURN
C
C     RETURN DEVICE TYPE EQUAL ZERO IF ENQUIRING ABOUT NON-EXISTANT
C      DEVICE.
C
      X(1) = 0.0
      RETURN
C
C     DISPATCH TO THE PROPER DRIVER
C
50    CONTINUE
      GO TO (100,200,300,400), IDEV
C
C     DEVICE 1. Windows 95 - one window
C
100   CALL GDWIN95(IFXN,X,Y)
      RETURN
C
C     DEVICE 2. HP 7475 PLOTTER - LONG --- HPGL OUTPUT TO FILE
C
200   CALL GDHPOL(IFXN,X,Y)
      RETURN
C
C     DEVICE 3. HP 7475 PLOTTER - TALL --- HPGL OUTPUT TO FILE
C
300   CALL GDHPOT(IFXN,X,Y)
      RETURN
C
C     DEVICE 4. POSTSCRIPT OUTPUT TO FILE
C
400   CALL GDPSTW(IFXN,X,Y)
      RETURN
      END
      SUBROUTINE GSDNAM(IDEV,BNAME)
      INTEGER*1 BNAME(40)
C
C     THIS SUBROUTINE RETURNS THE DEVICE NAME OF THE SPECIFIED DEVICE
C     *********** DEVICE NAMES ARE LIMITED TO 39 CHARACTERS **********
C
      DATA MAXDEV /4/
C
      BNAME(1) = 0
      IF ((IDEV .LE. 0) .OR. (IDEV .GT. MAXDEV)) RETURN
      GO TO (100,200,300,400), IDEV
100   CALL SICOPY("Windows 95 - one window"C,BNAME)
      RETURN
200   CALL SICOPY("HP PLOTTER (LONG) -- FILE OUTPUT"C,BNAME)
      RETURN
300   CALL SICOPY("HP PLOTTER (TALL) -- FILE OUTPUT"C,BNAME)
      RETURN
400   CALL SICOPY("POSTSCRIPT -- FILE OUTPUT"C,BNAME)
      RETURN
      END
      SUBROUTINE GSDRW2(X0,Y0,IVIS0,X1,Y1,IVIS1)
C
C     CLIP LINE TO CLIPPING BOX.   PASS ON ONLY VISIBLE LINE SEGMENTS TO
C      GSDRW3 TO BE DRAWN IN THE CURRENT LINE TYPE.   THIS SUBROUTINE ALSO
C      WORRIES ABOUT WHETHER THE GRAPHICS DEVICE WILL REQUIRE A "MOVE"
C      BEFORE THE "DRAW" IS DONE.
C
      INCLUDE 'GCCLIP.PRM'
      INCLUDE 'GCLTYP.PRM'
C
      LOGICAL*1 LDID1
C
D     TYPE *,'CLIPPING (',X0,',',Y0,')  IVIS=',IVIS0
D     TYPE *,' TO (',X1,',',Y1,')  IVIS=',IVIS1
      IF (IAND(IVIS0,IVIS1) .NE. 0) RETURN
      IF (IVIS0 .EQ. 0) GO TO 10
            LPOSND = .FALSE.
            LINILT = .TRUE.
10    CONTINUE
C
C     CALCULATE THE NUMBER OF CLIPS NECESSARY
C
      NCLIPS = 0
      IF (IVIS0 .NE. 0) NCLIPS = 1
      IF (IVIS1 .NE. 0) NCLIPS = NCLIPS + 1
      IF (NCLIPS .NE. 0) GO TO 100
C
C     LINE TOTALLY VISIBLE, JUST DRAW IT
C
      CALL GSDRW3(X0,Y0,X1,Y1)
      RETURN
C
C     FIND THE INTERSECTION(S) WITH THE CLIPPING BOX EDGES
C
100   CONTINUE
D     TYPE *,'NCLIPS=',NCLIPS
      LDID1 = .FALSE.
      IST = 1
      DX = X1-X0
      IF (DX .EQ. 0.0) IST = 3
      IFN = 4
      DY = Y1-Y0
      IF (DY .EQ. 0.0) IFN = 2
      IF (IST .GT. IFN) RETURN
      IVISC = IOR(IVIS0,IVIS1)
      IBIT = 2**(IST-1)
D     TYPE *,'IST=',IST,'   IFN=',IFN
      DO 210 I = IST, IFN
      IF (IAND(IVISC,IBIT) .EQ. 0) GO TO 200
      IF (I .GT. 2) GO TO 110
            XI = XCM0
            IF (I .EQ. 2) XI = XCM1
            YI = Y0 + (XI-X0)*DY/DX
            IF (YI .LT. YCM0 .OR. YI .GT. YCM1) GO TO 200
            GO TO 120
110       CONTINUE
            YI = YCM0
            IF (I .EQ. 4) YI = YCM1
            XI = X0 + (YI-Y0)*DX/DY
D           TYPE *,'Y INTERSECTION',XI,YI
            IF (XI .LT. XCM0 .OR. XI .GT. XCM1) GO TO 200
120   CONTINUE
C
C     GOT AN INTERSECTION.   IF IT'S THE ONLY ONE, THE DRAW THE LINE.
C
      IF (NCLIPS .GT. 1) GO TO 140
            IF (IVIS0 .EQ. 0) GO TO 130
                  CALL GSDRW3(XI,YI,X1,Y1)
                  RETURN
130            CONTINUE
                  CALL GSDRW3(X0,Y0,XI,YI)
                  RETURN
140       CONTINUE
C
C     TWO CLIPS NECESSARY.   IF WE ALREADY HAVE ONE, DRAW THE DOUBLE CLIPPED
C      LINE, ELSE SAVE FIRST CLIP AND WAIT FOR LAST.
C      NOTE, IF DOUBLE CLIPPED, IT DOESN'T MATTER IN WHICH DIRECTION IT
C      IS DRAWN.
C
            IF (.NOT. LDID1) GO TO 180
                  CALL GSDRW3(X2,Y2,XI,YI)
                  RETURN
180             CONTINUE
                  X2 = XI
                  Y2 = YI
                  LDID1 = .TRUE.
200         CONTINUE
      IBIT = 2*IBIT
210   CONTINUE
C
C     SEGMENT IS NOT VISIBLE IF WE DROP THRU TO HERE
C
      RETURN
      END
      SUBROUTINE GSDRW3(X0,Y0,X1,Y1)
C
C     DRAW A LINE FROM (X0,Y0) TO (X1,Y1) IN ABSOLUTE COORDINATES.
C      ASSUMES THAT CLIPPING HAS ALREADY BEEN DONE.   TO SUPPRESS UNNECESSARY
C      "MOVES", THIS IS THE ONLY ROUTINE THAT SHOULD CALL GSDRVR(3,,,).
C      THE LINE IS DRAWN IN THE CURRENT LINE TYPE.   THIS ROUTINE DOES NOT
C      SET THE ABSOLUTE POSITION (XAPOS,YAPOS).   IT IS UP TO THE CALLER TO
C      DO SO IF NECESSARY.
C
      INCLUDE 'GCLTYP.PRM'
      REAL(4) AX0(1),AY0(1),AX1(1),AY1(1)
C
      IF (ILNTYP .LE. 1) THEN
         IF (.NOT. LPOSND)THEN
            AX0(1)=X0
            AY0(1)=Y0
	      CALL GSDRVR(3,AX0,AY0)
   	   END IF
         AX1(1)=X1
         AY1(1)=Y1
         CALL GSDRVR(4,AX1,AY1)
         LPOSND = .TRUE.
	   RETURN
	END IF
C
C     SEGMENT LINE TO MAKE CURRENT LINE TYPE
C
      IF (.NOT. LINILT) GO TO 100
      INXTL = 1
      DLEFT = DIST(1,ILNTYP-1)
      LINILT = .FALSE.
      IF (.NOT. LPOSND)THEN 
         AX0(1)=X0
         AY0(1)=Y0
	   CALL GSDRVR(3,AX0,AY0)
	END IF
100   DX = X1-X0
      DY = Y1-Y0
      DL = SQRT(DX**2+DY**2)
C
C     SEE IF THIS SEGMENT IS SHORTER THAT DIST. LEFT ON LINE TYPE
C
      IF (DL .LE. DLEFT) GO TO 200
C
C     SEGMENT IS LONGER, SO ADVANCE TO LINE TYPE BREAK
C
      S = DLEFT/DL
      X0 = S*DX+X0
      Y0 = S*DY+Y0
C
C     SEE IF THIS PART OF THE LINE TYPE IS DRAWN OR SKIPPED
C
      AX0(1)=X0
      AY0(1)=Y0
      IF (IAND(INXTL,1) .EQ. 0) THEN
         CALL GSDRVR(3,AX0,AY0)
      ELSE
         CALL GSDRVR(4,AX0,AY0)
      END IF
C
C     NOW GO TO NEXT PORTION OF LINE TYPE
C
      INXTL = INXTL + 1
      IF (INXTL .GT. 4) INXTL = 1
      DLEFT = DIST(INXTL,ILNTYP-1)
      GO TO 100
C
C     DRAW LAST OF LINE IF DRAWN
C
200   CONTINUE
      DLEFT = DLEFT - DL
      IF (IAND(INXTL,1) .EQ. 0) THEN
         LPOSND = .FALSE.
      ELSE
	   AX1(1)=X1
         AY1(1)=Y1
         CALL GSDRVR(4,AX1,AY1)
         LPOSND = .TRUE.
      END IF
      RETURN
      END
      SUBROUTINE GSETDP(ANGLE,XSCALE,YSCALE,XTRAN,YTRAN)
C
C
      INCLUDE 'GCDPRM.PRM'
      INCLUDE 'PIODEF.PRM'
C
C     SET SCALE AND TRANSLATION FACTORS
C
      XS = XSCALE
      YS = YSCALE
      XT = XTRAN
      YT = YTRAN
C
C     SET ROTATION FACTORS
C
      RAD = -ANGLE*PIO180
      RCOS = COS(RAD)
      RSIN = SIN(RAD)
      RETURN
      END
      SUBROUTINE GSFILL(X,Y,N,TX,TY)
      DIMENSION X(N),Y(N), TX(N),TY(N)
C
C     DIGLIB POLYGON FILL SUPPORT
C     DERIVED FROM "HATCH" ALGORITHM BY KELLY BOOTH
C
      INCLUDE 'GCDCHR.PRM'
      INCLUDE 'GCDPRM.PRM'
      INCLUDE 'GCLTYP.PRM'
C
      DIMENSION XINS(40)
      INTEGER GSIVIS
      LOGICAL*1 LEFT
      DATA FACT /16.0/
C
C     *****
C     DEFINE ARITHMETIC STATEMENT FUNCTION TO MAPPING VERTICES
      YMAP(YYY) = 2.0*AINT(YSCALE*YYY+0.5)+1.0
C     *****
C
      IF (N .LT. 3) RETURN
C
C
C     CONVERT TO ABSOLUTE COORD.
C
      DO 10 I=1,N
            CALL GSRST(X(I),Y(I),TX(I),TY(I))
10          CONTINUE
      CALL MINMAX(TY,N,YMIN,YMAX)
      CALL MINMAX(TX,N,XMIN,XMAX)
C
C     IF CLIPPING NEEDED OR IF NO HARDWARE POLYGON FILL, USE SOFTWARE
C
      IF ((GSIVIS(XMIN,YMIN) .NE. 0) .OR.
     &   (GSIVIS(XMAX,YMAX) .NE. 0) .OR.
     &   (IAND(IDVBTS,256) .EQ. 0)) GO TO 200
C
C     IF CAN HANDLE CONCAVE POLYGONS, JUST CALL DRIVER
C
      IF ((IAND(IDVBTS,512) .EQ. 0) .OR.
     &   (N .EQ. 3)) GO TO 150
C
C     IF HERE, DRIVER CAN HANDLE CONVEX NON-INTERSECTING POLYGONS ONLY,
C      SO MAKE SURE THIS POLYGON IS CONVEX AND NON-SELF-INTERSECTING.
C
      DX1 = X(1)-X(N)
      DY1 = Y(1)-Y(N)
      DY = DY1          !OLD NON-ZERO DELTA-Y
      NCHNGS = 0        !NUMBER OF TIMES DELTA-Y CHANGES SIGN
      L = 1
      COSTH = 0.0
110   CONTINUE
C
C           CONVEXITY TEST
C
            DX2 = X(L+1)-X(L)
            DY2 = Y(L+1)-Y(L)
            A = DX1*DY2-DX2*DY1
            IF (A*COSTH .LT. 0.0) GO TO 200
            IF (COSTH .EQ. 0.0) COSTH = A
C
C           SELF INTERSECTION CHECK - RELYS ON "CONVEXITY" CHECK
C
            IF (DY .NE. 0.0) GO TO 120
                  DY = DY2
                  GO TO 130
120         CONTINUE
            IF (DY2*DY .GE. 0.0) GO TO 130
                  DY = DY2
                  NCHNGS = NCHNGS + 1
                  IF (NCHNGS .GE. 3) GO TO 200
130         CONTINUE
            DX1 = DX2
            DY1 = DY2
            L = L + 1
            IF (L .LT. N) GO TO 110
150   CONTINUE
      CALL GSDRVR(1024+N,TX,TY)
      RETURN
C
C     **********
C     SOFTWARE FILL
C     **********
C
200   CONTINUE
C
C     FILLING A POLYGON IS VERY SIMPLE IF AND ONLY IF THE VERTICES OF
C      THE POLYGON NEVER LIE ON A SCAN LINE.   WE CAN FORCE THIS TO HAPPEN
C      BY THE FOLLOWING TRICK: MAKE ALL VERTICES LIE JUST BARELY ABOVE
C      THE SCAN LINE THEY SHOULD LIE ON.   THIS IS DONE BY MAPPING THE
C      VERTICES TO A GRID THAT IS "FACT" TIMES THE DEVICE RESOLUTION,
C      AND THEN DOUBLING THE GRID DENSITY, AND OFFSETTING THE VERTICES
C      BY 1.   BECAUSE WE DO THIS, WE MUST OUTLINE THE POLYGON.
C
C     *******
C
C     FILL WITH SOLID LINES
C
      LINOLD = ILNTYP
      ILNTYP = 1
C
      LEFT = .TRUE.
      YSCALE = AMAX1(XS,YS)*YRES*FACT
      DLINES = 2.0*FACT
      YMIN = AINT(YMAP(YMIN)/DLINES)*DLINES+DLINES
      YMAX = AINT(YMAP(YMAX)/DLINES)*DLINES
      YSCAN = YMIN
210   CONTINUE
            INISEC = 0
            IFIRST = 0
C
C           DO EACH SIDE OF THE POLYGON. PUT ANY X INTERSECTIONS
C           WITH THE SCAN LINE Y=YSCAN IN XINS
C
            YBEGIN = YMAP(Y(N))
            XBEGIN = X(N)
            DO 400 L = 1, N
                  YEND = YMAP(Y(L))
                  DY = YSCAN-YBEGIN
                  IF (DY*(YSCAN-YEND) .GT. 0.0) GO TO 390
C
C                 INSERT AN INTERSECTION
C
                  INISEC = INISEC + 1
                  XINS(INISEC) = DY*(X(L)-XBEGIN)/(YEND-YBEGIN)+XBEGIN
C
390               CONTINUE
                  YBEGIN = YEND
                  XBEGIN = X(L)
400               CONTINUE
C
C           FILL IF THERE WERE ANY INTERSECTIONS
C
            IF (INISEC .EQ. 0) GOTO 500
C           FIRST WE MUST SORT.   USE BUBBLE SORT BECAUSE USUALLY ONLY 2.
            DO 450 I =  1, INISEC-1
                  XKEY = XINS(I)
                  DO 430 J = I+1, INISEC
                        IF (.NOT. LEFT) GOTO 420
                        IF (XKEY .GE. XINS(J)) GO TO 430
410                     CONTINUE
                        TEMP = XKEY
                        XKEY = XINS(J)
                        XINS(J) = TEMP
                        GO TO 430
420                     IF (XKEY .GT. XINS(J)) GOTO 410
430                     CONTINUE
                  XINS(I) = XKEY
450               CONTINUE
C
C           DRAW FILL LINES NOW
C
            YY = YSCAN/(2.0*YSCALE)
            DO 460 I = 1, INISEC, 2
                  CALL GSMOVE(XINS(I),YY)
                  CALL GSDRAW(XINS(I+1),YY)
460               CONTINUE
500         CONTINUE
      YSCAN = YSCAN + DLINES
      LEFT = .NOT. LEFT
      IF (YSCAN .LE. YMAX) GO TO 210
C
C     FINALLY, OUTLINE THE POLYGON
C
      CALL GSMOVE(X(N),Y(N))
      DO 510 L=1,N
            CALL GSDRAW(X(L),Y(L))
510         CONTINUE
C
C     RESTORE LINE TYPE
C
      ILNTYP = LINOLD
      RETURN
      END
      SUBROUTINE GSGIN(X,Y,BCHAR,IERR)
      INTEGER*1 BCHAR
C
C     THIS DIGLIB SUBROUTINE TRIES TO GET GRAPHIC INPUT (GIN) FROM
C     THE CURRENTLY SELECTED DEVICE.   IF THE DEVICE IS NOT CAPABLE
C     OF GIN, IERR=-1.   FOR GIN DEVICES, IERR=0 AND:
C       X   = X POSITION OF CURSOR IN ABSOLUTE SCREEN CM.
C       Y   = Y POSITION OF CURSOR IN ABSOLUTE SCREEN CM.
C       BCHAR     = CHARACTER STUCK AT TERMINAL TO SIGNAL CURSOR HAS
C                 BEEN POSITIONED (BYTE).
C
      INCLUDE 'GCDCHR.PRM'
      INCLUDE 'GCDPRM.PRM'
      DIMENSION ARRAY(3),DUMMY(1)
      INTEGER*1 SPACE
      DATA SPACE /' '/
C
C     SEE IF DEVICE SUPPORTS GIN
C
      IF ((IDVBTS .AND. 128) .EQ. 0) GO TO 900
C
C     NOW ASK FOR GIN FROM DEVICE DRIVER
C
      CALL GSDRVR(9,ARRAY,DUMMY)
C
C     CONVERT ABSOLUTE CM. COORD. TO VIRTUAL CM. COORDINATES
C
      CALL GSIRST(ARRAY(2),ARRAY(3),X,Y)
C
C     GET CHARACTER AS 7 BIT ASCII
C
      IF (ARRAY(1) .LT. 0.0 .OR. ARRAY(1) .GT. 127.0) GOTO 110
            BCHAR = ARRAY(1)
            GOTO 120
C         ELSE
110         CONTINUE
            BCHAR = SPACE
C     ENDIF
120   CONTINUE
      IERR = 0
      RETURN
C
C     DEVICE DOESN'T SUPPORT GIN
C
900   IERR = -1
      RETURN
      END
      FUNCTION GSHGHT()
C
C     THIS FUNCTIONS RETURNS THE CURRENT CHARACTER HEIGHT IN VIRTUAL
C      COORDINATES.
C
      INCLUDE 'GCCPAR.PRM'
C
      GSHGHT = CSIZE/GSCHIT()
      RETURN
      END
      SUBROUTINE GSINPT(X,Y,LFLAG,IERR)
      LOGICAL LFLAG
C
C     DO A GENERIC GRAPHICS INPUT
C
      INTEGER*1 CHAR, SPACE
      DATA SPACE /' '/
C
      CALL GSCRSR(X,Y,IBUTN,IERR)
      IF (IERR .NE. 0) GO TO 100
            LFLAG = (IAND(IBUTN,1) .EQ. 1)
            RETURN
100   CONTINUE
      CALL GSGIN(X,Y,CHAR,IERR)
      IF (IERR .NE. 0) RETURN
      LFLAG = (CHAR .EQ. SPACE)
      RETURN
      END
      FUNCTION GSIVIS(X,Y)
      INTEGER GSIVIS
C
      INCLUDE 'GCCLIP.PRM'
C
C
      GSIVIS = 0
      IF (X .LT. XCM0) GSIVIS = 1
      IF (X .GT. XCM1) GSIVIS = GSIVIS + 2
      IF (Y .LT. YCM0) GSIVIS = GSIVIS + 4
      IF (Y .GT. YCM1) GSIVIS = GSIVIS + 8
      RETURN
      END
      FUNCTION GSLENS(BSTRNG)
      INTEGER*1 BSTRNG(2)
C
C     This function returns the length in virtual coordinates of
C        the string BSTRNG.   The current character size is assumed.
C
      INCLUDE 'GCCPAR.PRM'
C
      GSLENS = (GSCWID()*CSIZE)*LENB(BSTRNG)
      RETURN
      END
      FUNCTION GSLENC(CSTRNG)
      CHARACTER CSTRNG*(*)
C
C     This function returns the length in virtual coordinates of
C        the string BSTRNG.   The current character size is assumed.
C
      INCLUDE 'GCCPAR.PRM'
C
      GSLENC = (GSCWID()*CSIZE)*LEN_TRIM(CSTRNG)
      RETURN
      END
      SUBROUTINE GSLTYP(ITYPE)
C
C
      INCLUDE 'GCLTYP.PRM'
C
C     SET THE CURRENT LINE TYPE
C
      ILNTYP = ITYPE
      IF (ILNTYP .LE. 0 .OR. (ILNTYP .GT. 4)) ILNTYP = 1
      LINILT = .TRUE.
      RETURN
      END
      SUBROUTINE GSMOVE(X,Y)
C
C     MOVE THE THE POINT (X,Y).
C
      INCLUDE 'GCLTYP.PRM'
      INCLUDE 'GCVPOS.PRM'
      INCLUDE 'GCAPOS.PRM'
      INTEGER GSIVIS
C
C     RESET LINE STYLE TO BEGINNING OF PATTERN AND SHOW MOVED
C
      LINILT = .TRUE.
      LPOSND = .FALSE.
C
C     TRANSFORM VIRTUAL COORD. TO ABSOLUTE COORD.
C
      XVPOS = X
      YVPOS = Y
      CALL GSRST(XVPOS,YVPOS,XAPOS,YAPOS)
      IVIS = GSIVIS(XAPOS,YAPOS)
      RETURN
      END
      SUBROUTINE GSPOLY(X,Y,N)
      DIMENSION X(2),Y(2)
C
C     DIGLIB POLYGON SUPPORT
C
      CALL GSMOVE(X(N),Y(N))
      DO 100 I = 1, N
            CALL GSDRAW(X(I),Y(I))
100         CONTINUE
      RETURN
      END
      SUBROUTINE GSPSTR(BSTRNG)
      INTEGER*1 BSTRNG(80)
C
C     THIS SUBROUTINE STROKES OUT THE CHARACTER STRING "BSTRNG" (A BYTE
C     ARRAY WITH 0 AS A TERMINATOR) AT THE CURRENT POSITION.
C
      INCLUDE 'GCVPOS.PRM'
      INCLUDE 'GCCOFF.PRM'
      INCLUDE 'GCLTYP.PRM'
C					  
C     DON'T DRAW CHARACTERS IN LINETYPES
C
      IOLD = ILNTYP
      ILNTYP = 1
C
      NBYTE = 0
100   NBYTE = NBYTE + 1
C
C     SAVE THE (0,0) POSITION OF THE CHARACTER
C
      XOFF = XVPOS
      YOFF = YVPOS
C
C     GET THE CHARACTER TO STROKE
C
      IICHAR = BSTRNG(NBYTE)
      IF (IICHAR.EQ.0)GO TO 200
C
C     STROKE THE CHARACTER
C
      CALL GSSTRK(IICHAR)
      GO TO 100
C
C     RETURN LINE TYPE TO THAT OF BEFORE
C
200   CONTINUE
      ILNTYP = IOLD
      RETURN
      END
      SUBROUTINE GSPSTC(BSTRNG)
      CHARACTER BSTRNG*(*)
      DIMENSION ICHARA(1)
C
C     THIS SUBROUTINE STROKES OUT THE CHARACTER STRING "BSTRNG" (A
C     CHARACTER STRING WITH 0 AS A TERMINATOR) AT THE CURRENT POSITION.
C
      INCLUDE 'GCVPOS.PRM'
      INCLUDE 'GCCOFF.PRM'
      INCLUDE 'GCLTYP.PRM'
C					  
C     DON'T DRAW CHARACTERS IN LINETYPES
C
      IOLD = ILNTYP
      ILNTYP = 1
C
      MAXLEN=LEN_TRIM(BSTRNG)
      NBYTE = 0
100   NBYTE = NBYTE + 1
      IF(NBYTE.GT.MAXLEN)GO TO 200
C
C     SAVE THE (0,0) POSITION OF THE CHARACTER
C
      XOFF = XVPOS
      YOFF = YVPOS
C
C     GET THE CHARACTER TO STROKE
C
      ICHARA=ICHAR(BSTRNG(NBYTE:NBYTE))
      IICHAR = ICHARA(1)
      IF (IICHAR.EQ.0)GO TO 200
C
C     STROKE THE CHARACTER
C
      CALL GSSTRK(IICHAR)
      GO TO 100
C
C     RETURN LINE TYPE TO THAT OF BEFORE
C
200   CONTINUE
      ILNTYP = IOLD
      RETURN
      END
      SUBROUTINE GSRCLP(AREA)
      DIMENSION AREA(4)
C
C     THIS SUBROUTINE RESTORES A SAVED ABSOLUTE CLIPPING WINDOW PREVIOUSLY
C      SAVED BY "GSSCLP".   NO ERROR CHECKING IS PERFORMED HERE!!!
C
      INCLUDE 'GCCLIP.PRM'
C					   
      XCM0 = AREA(1)
      XCM1 = AREA(2)
      YCM0 = AREA(3)
      YCM1 = AREA(4)
      RETURN
      END
      SUBROUTINE GSRST(XV,YV,XA,YA)
C
C
      INCLUDE 'GCDPRM.PRM'
C
C     ROTATE, SCALE, AND THEN TRANSLATE COORDINATES
C     (TAKE VIRT. COORD. INTO SCREEN COORD.)
C
      XTEMP = XV
      XA = XS*(RCOS*XTEMP+RSIN*YV) + XT
      YA = YS*(RCOS*YV-RSIN*XTEMP) + YT
      RETURN
      END
      SUBROUTINE GSIRST(XA,YA,XV,YV)
C
C     INVERSE ROTATE, SCALE, AND THEN TRANSLATE
C     (TAKE ABSOLUTE COORD. INTO VIRTUAL COORD.)
C
      INCLUDE 'GCDPRM.PRM'
C
C     CONVERT ABSOLUTE CM. COORD. TO VIRTUAL CM. COORDINATES
C
      XTEMP = (XA-XT)/XS
      YV = (YA-YT)/YS
      XV = RCOS*XTEMP-RSIN*YV
      YV = RCOS*YV+RSIN*XTEMP
      RETURN
      END
      SUBROUTINE GSSCLP(VX0,VX1,VY0,VY1,AREA)
      DIMENSION AREA(4)
C
C     THIS SUBROUTINE SAVES THE CURRENT ABSOLUTE CLIPPING WINDOW AND
C      SETS A NEW ABSOLUTE CLIPPING WINDOW GIVEN VIRTUAL COORDINATES.
C      IT MAKES SURE THAT THE CLIPPING WINDOW NEVER LIES OUTSIDE THE
C      PHYSICAL DEVICE.
C
      INCLUDE 'GCCLIP.PRM'
      INCLUDE 'GCDCHR.PRM'
C
      AREA(1) = XCM0
      AREA(2) = XCM1
      AREA(3) = YCM0
      AREA(4) = YCM1
C
      CALL GSRST(VX0,VY0,AX0,AY0)
      CALL GSRST(VX1,VY1,AX1,AY1)
      XCM0 = AMAX1(AMIN1(AX0,AX1),0.0)
      YCM0 = AMAX1(AMIN1(AY0,AY1),0.0)
      XCM1 = AMIN1(XCLIPD,AMAX1(AX0,AX1))
      YCM1 = AMIN1(YCLIPD,AMAX1(AY0,AY1))
      RETURN
      END
      SUBROUTINE GSSETC(SIZE,ANGLE)
C
C
      INCLUDE 'GCCPAR.PRM'
      INCLUDE 'PIODEF.PRM'
C
C     SET UP SIZE MULTIPLIER
C
      CSIZE = SIZE/GSCHIT()
C
C     CALCULATE THE ROTATION FACTORS
C
      RAD = -PIO180*ANGLE
      CCOS = COS(RAD)
      CSIN = SIN(RAD)
      RETURN
      END
      FUNCTION GSSLEN(NCHARS)
C
C     This function returns the length in virtual coordinates of
C        a string of length NCHARS. The current character size is assumed.
C
      INCLUDE 'GCCPAR.PRM'
C
      GSSLEN = (GSCWID()*CSIZE)*NCHARS
      RETURN
      END
      SUBROUTINE GSSTRK(ICHAR)
C
C     THIS SUBROUTINE STROKES OUT A CHARACTER.
C
      LOGICAL LMOVE
      INCLUDE 'GCCIDX.PRM'
C
C     SPACE FILL ALL NON-PRINTING
C
      IF (ICHAR .LE. 32 .OR. ICHAR .GE. 128) GO TO 200
C
C     STROKE THIS CHARACTER
C
      INDX = INDEXC(ICHAR-32)
      IDONE = INDEXC(ICHAR-31)
C
C     GET THE SCALED AND ROTATED NEXT NODE ON THE CHARACTER
C
100   CALL GSCGET(INDX,DX,DY,LMOVE)
      IF (LMOVE) GO TO 140
      CALL GSDRAW(DX,DY)
      GO TO 160
140   CALL GSMOVE(DX,DY)
C
C     SEE IF ALL DONE
C
160   IF (INDX .LT. IDONE) GO TO 100
C
C     ALL DONE WITH THE CHARACTER, MOVE TO NEXT CHARACTER POSITION
C
200   CALL GSCCLC(GSCWID(),0.0,DX,DY)
      CALL GSMOVE(DX,DY)
      RETURN
      END
      FUNCTION GSWDTH(SIZE)
C
C     This function returns the width in virtual coordinates of
C        a character.   If SIZE=0 then the current character size is assumed.
C
      INCLUDE 'GCCPAR.PRM'
C
      TEMP = SIZE/GSCHIT()
      IF (TEMP .EQ. 0.0) TEMP = CSIZE
      GSWDTH = GSCWID()*TEMP
      RETURN
      END
      SUBROUTINE GSWNDO(UXL,UXH,UYL,UYH,XOFF,YOFF,XAWDTH,YAHIGH)
C
C     THIS SUBROUTINE PROVIDES DIGLIB V3'S WINDOW/VIEWPORT MECHANISM.
C
      INCLUDE 'GCCLIP.PRM'
      INCLUDE 'GCDCHR.PRM'
      INCLUDE 'GCDPRM.PRM'
C
C
      RCOS = 1.0
      RSIN = 0.0
      XS = XAWDTH/(UXH-UXL)
      YS = YAHIGH/(UYH-UYL)
      XT = XOFF - XS*UXL
      YT = YOFF - YS*UYL
      XCM0 = AMAX1(AMIN1(XOFF,XOFF+XAWDTH),0.0)
      YCM0 = AMAX1(AMIN1(YOFF,YOFF+YAHIGH),0.0)
      XCM1 = AMIN1(XCLIPD,AMAX1(XOFF,XOFF+XAWDTH))
      YCM1 = AMIN1(YCLIPD,AMAX1(YOFF,YOFF+YAHIGH))
      RETURN
      END
      FUNCTION GSXLCM()
C
C     THIS FUNCTION RETURNS THE X AXIS LENGTH OF THE CURRENT DEVICE
C     IN CENTIMETERS.
C
      INCLUDE 'GCDCHR.PRM'
C
      GSXLCM = XLENCM
      RETURN
      END
      FUNCTION GSYLCM()
C
C     THIS FUNCTION RETURNS THE Y AXIS LENGTH OF THE CURRENT DEVICE
C     IN CENTIMETERS.
C
      INCLUDE 'GCDCHR.PRM'
C
      GSYLCM = YLENCM
      RETURN
      END
      SUBROUTINE HATCH(XVERT, YVERT, NUMPTS, PHI, CMSPAC, IFLAG,
     &   XX, YY)
      DIMENSION XVERT(NUMPTS), YVERT(NUMPTS), XX(NUMPTS), YY(NUMPTS)
C
C     ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
C     H A T C H
C     by Kelly Booth and modified for DIGLIB by Hal Brand
C
C     PROVIDE SHADING FOR A GENERAL POLYGONAL REGION.  THERE IS ABSOLUTELY NO
C     ASSUMPTION MADE ABOUT CONVEXITY.  A POLYGON IS SPECIFIED BY ITS VERTICES,
C     GIVEN IN EITHER A CLOCKWISE OR COUNTER-CLOCKWISE ORDER.  THE DENSITY OF
C     THE SHADING LINES (OR POINTS) AND THE ANGLE FOR THE SHADING LINES ARE
C     BOTH DETERMINED BY THE PARAMETERS PASSED TO THE SUBROUTINE.
C
C     THE INPUT PARAMETERS ARE INTERPRETED AS FOLLOWS:
C
C      XVERT    -  AN ARRAY OF X COORDINATES FOR THE POLYGON VERTICES
C
C      YVERT    -  AN ARRAY OF Y COORDINATES FOR THE POLYGON VERTICES
C
C      NUMPTS  -  THE NUMBER OF VERTICES IN THE POLYGON
C
C      PHI      -  THE ANGLE FOR THE SHADING, MEASURED COUNTER-CLOCKWISE
C                 IN DEGREES FROM THE POSITIVE X-AXIS
C
C      CMSPAC       -  THE DISTANCE IN VIRTUAL COORDINATES (CM. USUALLY)
C                 BETWEEN SHADING LINES.   THIS VALUE MAY BE ROUNDED
C                 A BIT, SO SOME CUMMULATIVE ERROR MAY BE APPARENT.
C
C      IFLAG    -  GENERAL FLAGS CONTROLLING HATCH
C                 0 ==>  BOUNDARY NOT DRAWN, INPUT IS VIRTUAL COORD.
C                 1 ==>  BOUNDARY DRAWN, INPUT IS VIRTUAL COORD.
C                 2 ==>  BOUNDARY NOT DRAWN, INPUT IS WORLD COORD.
C                 3 ==>  BOUNDARY DRAWN, INPUT IS WORLD COORD.
C
C      XX     -  A WORK ARRAY ATLEAST "NUMPTS" LONG.
C
C      YY     -  A SECOND WORK ARRAY ATLEAST "NUMPTS" LONG.
C
C     ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C
      INCLUDE 'GCDCHR.PRM'
C 
C     THIS SUBROUTINE HAS TO MAINTAIN AN INTERNAL ARRAY OF THE TRANSFORMED
C     COORDINATES.  THIS REQUIRES THE PASSING OF THE TWO WORKING ARRAYS
C     CALLED "XX" AND "YY".
C     THIS SUBROUTINE ALSO NEEDS TO STORE THE INTERSECTIONS OF THE HATCH
C     LINES WITH THE POLYGON.   THIS IS DONE IN "XINTCP".
C
      REAL XINTCP(20)
      LOGICAL LMOVE
C 
C     'BIGNUM' SIGNALS THE END OF A POLYGON IN THE INPUT.
C
      DATA BIGNUM /1E38/
      DATA FACT /16.0/
      DATA PI180 /0.017453292/
C
C------------------------------------------------------------------------
C 
C     CHECK FOR VALID NUMBER OF VERTICES.
C
      IF (NUMPTS .LT. 3) RETURN
C 
C     CONVERT ALL OF THE POINTS TO INTEGER COORDINATES SO THAT THE SHADING
C     LINES ARE HORIZONTAL.  THIS REQUIRES A ROTATION FOR THE GENERAL CASE.
C     THE TRANSFORMATION FROM VIRTUAL TO INTERNAL COORDINATES HAS THE TWO
C     OR THREE PHASES:
C
C     (1)  CONVERT WORLD TO VIRTUAL COORD. IF INPUT IN WORLD COORD.
C
C     (2)  ROTATE CLOCKWISE THROUGH THE ANGLE PHI SO SHADING IS HORIZONTAL,
C
C     (3)  SCALE TO INTEGERS IN THE RANGE
C           [0...2*FACT*(DEVICE_MAXY_COORDINATE)], FORCING COORDINATES
C           TO BE ODD INTEGERS.
C
C     THE COORDINATES ARE ALL ODD SO THAT LATER TESTS WILL NEVER HAVE AN
C     OUTCOME OF "EQUAL" SINCE ALL SHADING LINES HAVE EVEN COORDINATES.
C     THIS GREATLY SIMPLIFIES SOME OF THE LOGIC.
C
C     AT THE SAME TIME THE PRE-PROCESSING IS BEING DONE, THE INPUT IS CHECKED
C     FOR MULTIPLE POLYGONS.  IF THE X-COORDINATE OF A VERTEX IS A 'BIGNUM'
C     THEN THE POINT IS NOT A VERTEX, BUT RATHER IT SIGNIFIES THE END OF A
C     PARTICULAR POLYGON.  AN IMPLIED EDGE EXISTS BETWEEN THE FIRST AND LAST
C     VERTICES IN EACH POLYGON.  A POLYGON MUST HAVE AT LEAST THREE VERTICES.
C     ILLEGAL POLYGONS ARE REMOVED FROM THE INTERNAL LISTS.
C 
C 
C     COMPUTE TRIGONOMETRIC FUNCTIONS FOR THE ANGLE OF ROTATION.
C
      COSPHI = COS(PI180*PHI)
      SINPHI = SIN(PI180*PHI)
C
C     FIRST CONVERT FROM WORLD TO VIRTUAL COORD. IF NECESSARY AND ELIMINATE
C     ANY POLYGONS WITH TWO OR FEWER VERTICES
C
      ITAIL = 1
      IHEAD = 0
      DO 120 I = 1, NUMPTS
C 
C           ALLOCATE ANOTHER POINT IN THE VERTEX LIST.
C
            IHEAD = IHEAD + 1
C 
C           A 'BIGNUM' IN THE X-COORDINATE IS A SPECIAL FLAG.
C
            IF (XVERT(I) .NE. BIGNUM) GO TO 110
             XX(IHEAD) = BIGNUM
             IF ((IHEAD-ITAIL) .LT. 2) IHEAD = ITAIL - 1
             ITAIL = IHEAD + 1
             GO TO 120
110         CONTINUE
C
C           CONVERT FROM WORLD TO VIRTUAL COORD. IF INPUT IS WORLD COORD.
C
            IF ((IFLAG .AND. 2) .EQ. 0) GO TO 115
                  CALL SCALE(XVERT(I),YVERT(I),XX(IHEAD),YY(IHEAD))
                  GO TO 120
115             CONTINUE
                  XX(IHEAD) = XVERT(I)
                  YY(IHEAD) = YVERT(I)
120         CONTINUE
      IF ((IHEAD-ITAIL) .LT. 2) IHEAD = ITAIL - 1
      NVERT = IHEAD
C
C     DRAW BOUNDARY(S) IF DESIRED
C
      IHEAD = 0
      ITAIL = 1
      LMOVE = .TRUE.
130         CONTINUE
            IHEAD = IHEAD + 1
            IF (IHEAD .GT. NVERT) GO TO 133
            IF (XX(IHEAD) .NE. BIGNUM) GO TO 135
133          CONTINUE
             CALL GSDRAW(XX(ITAIL),YY(ITAIL))
             ITAIL = IHEAD + 1
             LMOVE = .TRUE.
             GO TO 139
135         CONTINUE
            IF (LMOVE) GO TO 137
             CALL GSDRAW(XX(IHEAD),YY(IHEAD))
             GO TO 139
137         CONTINUE
            CALL GSMOVE(XX(IHEAD),YY(IHEAD))
            LMOVE = .FALSE.
139         CONTINUE          
            IF (IHEAD .LE. NVERT) GO TO 130
C
C     ROTATE TO MAKE SHADING LINES HORIZONTAL
C
      YMIN = BIGNUM
      YMAX = -BIGNUM
      YSCALE = YRES*FACT
      YSCAL2 = 2.0*YSCALE
      DO 140 I = 1, NVERT
            IF (XX(I) .EQ. BIGNUM) GO TO 140
C
C           PERFORM THE ROTATION TO ACHIEVE HORIZONTAL SHADING LINES.
C
            XV1 = XX(I)
            XX(I) = +COSPHI*XV1 + SINPHI*YY(I)
            YY(I) = -SINPHI*XV1 + COSPHI*YY(I)
C 
C           CONVERT TO INTEGERS AFTER SCALING, AND MAKE VERTICES ODD. IN Y
C
            YY(I) = 2.0*AINT(YSCALE*YY(I)+0.5)+1.0
            YMIN = AMIN1(YMIN,YY(I))
            YMAX = AMAX1(YMAX,YY(I))
140         CONTINUE
C
C     MAKE SHADING START ON A MULTIPLE OF THE STEP SIZE.
C
      STEP = 2.0*AINT(YRES*CMSPAC*FACT)
      YMIN = AINT(YMIN/STEP) * STEP
      YMAX = AINT(YMAX/STEP) * STEP
C 
C     AFTER ALL OF THE COORDINATES FOR THE VERTICES HAVE BEEN PRE-PROCESSED
C     THE APPROPRIATE SHADING LINES ARE DRAWN.  THESE ARE INTERSECTED WITH
C     THE EDGES OF THE POLYGON AND THE VISIBLE PORTIONS ARE DRAWN.
C
      Y = YMIN
150         CONTINUE
            IF (Y .GT. YMAX) GO TO 250
C 
C           INITIALLY THERE ARE NO KNOWN INTERSECTIONS.
C
            ICOUNT = 0
            IBASE = 1
            IVERT = 1
160               CONTINUE
                  ITAIL = IVERT
                  IVERT = IVERT + 1
                  IHEAD = IVERT
                  IF (IHEAD .GT. NVERT) GO TO 165
                  IF (XX(IHEAD) .NE. BIGNUM) GO TO 170
C 
C                   THERE IS AN EDGE FROM VERTEX N TO VERTEX 1.
C
165                 IHEAD = IBASE
                    IBASE = IVERT + 1
                    IVERT = IVERT + 1
170               CONTINUE
C 
C                 SEE IF THE TWO ENDPOINTS LIE ON
C                 OPPOSITE SIDES OF THE SHADING LINE.
C
                  YHEAD =  Y - YY(IHEAD)
                  YTAIL =  Y - YY(ITAIL)
                  IF (YHEAD*YTAIL .GE. 0.0) GO TO 180
C 
C                 THEY DO.  THIS IS AN INTERSECTION.  COMPUTE X.
C
                  ICOUNT = ICOUNT + 1
                  DELX = XX(IHEAD) - XX(ITAIL)
                  DELY = YY(IHEAD) - YY(ITAIL)
                  XINTCP(ICOUNT) = (DELX/DELY) * YHEAD + XX(IHEAD)
180               CONTINUE
                  IF ( IVERT .LE. NVERT ) GO TO 160
C 
C           SORT THE X INTERCEPT VALUES.  USE A BUBBLESORT BECAUSE THERE
C           AREN'T VERY MANY OF THEM (USUALLY ONLY TWO).
C 
            IF (ICOUNT .EQ. 0) GO TO 240
            DO 200 I = 2, ICOUNT
                  XKEY = XINTCP(I)
                  K = I - 1
                  DO 190 J = 1, K
                        IF (XINTCP(J) .LE. XKEY)      GO TO 190
                        XTEMP = XKEY
                        XKEY = XINTCP(J)
                        XINTCP(J) = XTEMP
190                     CONTINUE
                  XINTCP(I) = XKEY
200               CONTINUE
C 
C           ALL OF THE X COORDINATES FOR THE SHADING SEGMENTS ALONG THE
C           CURRENT SHADING LINE ARE NOW KNOWN AND ARE IN SORTED ORDER.
C           ALL THAT REMAINS IS TO DRAW THEM.  PROCESS THE X COORDINATES
C           TWO AT A TIME.
C
            YR = Y/YSCAL2
            DO 230 I = 1, ICOUNT, 2
C
C                 CONVERT BACK TO VIRTUAL COORDINATES.
C                 ROTATE THROUGH AN ANGLE OF -PHI TO ORIGINAL ORIENTATION.
C                 THEN UNSCALE FROM GRID TO VIRTUAL COORD.
C
                  XV1 = + COSPHI*XINTCP(I) - SINPHI*YR
                  YV1 = + SINPHI*XINTCP(I) + COSPHI*YR
                  XV2 = + COSPHI*XINTCP(I+1) - SINPHI*YR
                  YV2 = + SINPHI*XINTCP(I+1) + COSPHI*YR
D                 TYPE *,'LINE: (',XV1,YV1,') TO (',XV2,YV2,')'
C 
C                 DRAW THE SEGMENT OF THE SHADING LINE.
C
                  CALL GSMOVE(XV1,YV1)
                  CALL GSDRAW(XV2,YV2) 
230               CONTINUE
240         CONTINUE
            Y = Y + STEP
            GO TO 150
250   CONTINUE
      RETURN
      END
      SUBROUTINE LAXIS(ALOW,AHIGH,MAXTCK,BMIN,BMAX,BTICK)
C
C     THIS ROUTINE FINDS A SUITABLE TICK FOR LOG AXES
C
      DATA SMLREL /1E-38/
C
      BLOW = ALOG10(AMAX1(SMLREL,AMIN1(AHIGH,ALOW)))
      BHIGH = ALOG10(AMAX1(ALOW,AHIGH,1E2*SMLREL))
      RANGE = BHIGH-BLOW
      IF (RANGE .LE. 1E-2) RANGE = 1.0    !1E-2 IS FUZZ FACTOR
      ISTRT = 1
      IMAX = 5
30    DO 50 I=ISTRT,IMAX,ISTRT
      NTCKS = RANGE/I + 0.999
      IF (NTCKS .LE. MAXTCK) GO TO 60
50    CONTINUE
      ISTRT = 10
      IMAX = 80
      GO TO 30
60    BTICK = I
      BMIN = BTICK*AINT(BLOW/BTICK)
      BMAX = BTICK*AINT(BHIGH/BTICK)
      IF ((BMIN-BLOW)/RANGE .GT. 0.001) BMIN = BMIN - BTICK
      IF ((BHIGH-BMAX)/RANGE .GT. 0.001) BMAX = BMAX + BTICK
      RETURN
      END
      SUBROUTINE LINLAB(NUM,IEXP,STRNG,LRMTEX)
      LOGICAL*1 LRMTEX
      INTEGER*1 STRNG(8)
C
      INTEGER*1 BMINUS, BZERO(4)
      DATA BMINUS /'-'/
      DATA BZERO /'0', '.', '0', 0/
C
C
      LRMTEX = .TRUE.
C
C     WORK WITH ABSOLUTE VALUE AS IT IS EASIER TO PUT SIGN IN NOW
C
      IF (NUM .LT. 0) GO TO 10
            NVAL = NUM
            ISTART = 1
            GO TO 20
10        CONTINUE
            NVAL = -NUM
            ISTART = 2
            STRNG(1) = BMINUS
20    CONTINUE
      IF (IEXP .GE. -2 .AND. IEXP .LE. 2) LRMTEX = .FALSE.
      IF (IEXP .GT. 0 .AND. (.NOT. LRMTEX)) NVAL = NVAL*10**IEXP
      CALL NUMSTR(NVAL,STRNG(ISTART))
      IF ((NVAL .EQ. 0) .OR. LRMTEX .OR. (IEXP .GE. 0)) GOTO 800
C
C     NUMBER IS IN RANGE 10**-1 OR 10**-2, SO FORMAT PRETTY
C
      N = -IEXP
      L = LENB(STRNG(ISTART))
      IZBGN = 1
      NIN = 3
      IF (N .EQ. L) NIN = 2
C
C     IF N<L THEN WE NEED ONLY INSERT A DECIMAL POINT
C
      IF (N .GE. L) GO TO 40
            IZBGN = 2
            NIN = 1
40    CONTINUE
C
C     ALLOW ROOM FOR DECIMAL POINT AND ZERO(S) IF NECESSARY
C
      IBEGIN = ISTART + MAX0(0,L-N)
            DO 50 I = 0, MIN0(N,L)
            STRNG(ISTART+L+NIN-I) = STRNG(ISTART+L-I)
50          CONTINUE
C
C     INSERT LEADING ZEROS IF NECESSARY, OR JUST DECIMAL POINT
C
            DO 60 I=0,NIN-1
            STRNG(IBEGIN+I) = BZERO(IZBGN+I)
60          CONTINUE
C
C     ALL DONE
C
800   RETURN
      END
      FUNCTION ILABSZ()
C
C     THIS FUNCTION RETURNS THE MAXIMUM LENGTH THAT "LINLAB" WILL RETURN.
C
      ILABSZ = 6
      RETURN
      END
      SUBROUTINE LOGLAB(NUM,STRNG)
      INTEGER*1 STRNG(2), LLABS(6,8)
      DATA LLABS / '.','0','0','1',2*0,
     &   '.','0','1',3*0,
     &   '.','1',4*0,
     &   '1',5*0,
     &   '1','0',4*0,
     &   '1','0','0',3*0,
     &   '1','0','0','0',2*0,
     &   '1','0','0','0','0',0/
      IF (NUM .GT. -4 .AND. NUM .LT. 5) GO TO 100
      CALL SICOPY("1E"C,STRNG)
      CALL NUMSTR(NUM,STRNG(3))
      GO TO 200
100   CALL SCOPY(LLABS(1,4+NUM),STRNG)
200   RETURN
      END
      SUBROUTINE MAPIT(XLOW,XHIGH,YLOW,YHIGH,XLAB,YLAB,TITLE,IAXES)
      INCLUDE 'PLTCOM.PRM'
      INCLUDE 'PLTSIZ.PRM'
      INCLUDE 'PLTCLP.PRM'
C      INCLUDE 'PLTCLP.PRM'           !ONLY KEPT FOR CALLER'S INFO
      INCLUDE 'PLTPRM.PRM'
C
      CHARACTER*(*) XLAB, YLAB, TITLE
      INTEGER*1 NUMBR(14)
      LOGICAL*1 LOGXX, LOGYY, LOGT, LRMTEX, LSHORT, LRAGGD
      DIMENSION ZLOG(8)
C
      DATA ZLOG /0.3010, 0.4771, 0.6021, 0.6990, 0.7782, 0.8451,
     &   0.9031, 0.9542 /
      DATA TMINLD /0.1/ !MINIMUM DISTANCE BETWEEN SHORT TICKS (1 MM)
      DATA SHORTF /2.0/ !SHORT TICKS = TICKLN/SHORTF
C
C     SET LOGX AND LOGY TO FALSE FOR OUR USAGE OF SCALE
C
      LOGX = .FALSE.
      LOGY = .FALSE.
C
C     SEE WHAT TYPE OF AXES ARE DESIRED
C
      LOGXX = IAND(IAXES,1) .NE. 0
      LOGYY = IAND(IAXES,2) .NE. 0
      LRAGGD = IAND(IAXES,256) .NE. 0
C
C     DO THE AXES SCALING
C
      NUMTK = MIN0(10,INT(XVLEN/((ILABSZ()+1.0)*CXSIZE)))
      IF (LOGXX) GO TO 20
      LSHORT = IAND(IAXES,16) .NE. 0
      CALL AXIS(XLOW,XHIGH,NUMTK,LSHORT,LRAGGD,XMIN,XMAX,XTMIN,XTMAX,
     &   XTICK,IXPWR)
      GO TO 40
20    CALL LAXIS(XLOW,XHIGH,NUMTK,XMIN,XMAX,XTICK)
      XTMIN = XMIN
      XTMAX = XMAX
      IXPWR = 0
40    NUMTK = MIN0(10,INT(YVLEN/(3.0*CYSIZE)))
      IF (LOGYY) GO TO 60
      LSHORT = IAND(IAXES,32) .NE. 0
      CALL AXIS(YLOW,YHIGH,NUMTK,LSHORT,LRAGGD,YMIN,YMAX,YTMIN,YTMAX,
     &   YTICK,IYPWR)
      GO TO 80
60    CALL LAXIS(YLOW,YHIGH,NUMTK,YMIN,YMAX,YTICK)
      YTMIN = YMIN
      YTMAX = YMAX
      IYPWR = 0
80    CONTINUE
C
C     SET UP SCALING FACTORS FOR SCALE
C
      UX0 = XMIN
      UDX = XMAX - XMIN
      UY0 = YMIN
      UDY = YMAX - YMIN
C
C     ********** DRAW Y AXES **********
C
      CALL GSSETC(CYSIZE,0.0)
      LOGT = .FALSE.
      IF (.NOT. LOGYY .OR. YTICK .NE. 1.0) GO TO 90
      CALL SCALE(XMIN,YMIN,VX,TEMP)
      CALL SCALE(XMIN,YMIN+1.0-ZLOG(8),VX,VY)
      IF ((VY-TEMP) .GE. TMINLD) LOGT = .TRUE.
90    CONTINUE
C
C     DRAW Y AXIS LINE
C
      MXLAB = 3
      TENEXP = 10.0**IYPWR
      X = XMIN
      TICKSP = AMAX1(0.0,TICKLN)    !TICK SPACING
      IF (IAND(IAXES,64) .NE. 0) YVLEN = YVLEN - TICKSP
      TCKSGN = -TICKLN        !TICKS TO LEFT FOR LEFT Y AXIS
100   CONTINUE
      CALL SCALE(X,YMAX,VX,VY)
      CALL GSMOVE(VX,VY)
      CALL SCALE(X,YMIN,VX,VY)
      CALL GSDRAW(VX,VY)
C
C     DRAW AND LABEL Y AXIS TICKS
C
      Y = YTMIN
      N = (YTMAX-YTMIN)/YTICK + 1.1
110   CONTINUE
      CALL SCALE(X,Y*TENEXP,VX,VY)
      CALL GSMOVE(VX,VY)
      CALL GSDRAW(VX+TCKSGN,VY)
      IF (X .EQ. XMAX) GO TO 185
      IF (IAND(IAXES,1024) .NE. 0) GO TO 183
C
C     PLACE THE APPROPIATE LABEL
C
      IF (LOGYY) GO TO 160
      CALL LINLAB(INT(Y),IYPWR,NUMBR,LRMTEX)
      GO TO 180
160   CALL LOGLAB(INT(Y),NUMBR)
180   LN = LENB(NUMBR)
      MXLAB = MAX0(MXLAB,LN)
      CALL GSMOVE(VX-TICKSP-CXSIZE*(LN+0.25),VY-CYSIZE/2.0)
      CALL GSPSTR(NUMBR)
C
C     ADD GRID LINE AT TICK IF DESIRED
C
183   CONTINUE
      IF (IAND(IAXES,8) .EQ. 0) GO TO 185
      CALL GSLTYP(3)
      CALL GSMOVE(VX,VY)
      CALL SCALE(XMAX,Y*TENEXP,VX,VY)
      CALL GSDRAW(VX,VY)
      CALL GSLTYP(1)
185   CONTINUE
C
C     DO EXTRA TICKING IF EXTRA TICKS WILL BE FAR ENOUGH APART
C
      IF ((.NOT. LOGT) .OR. (Y .EQ. YTMAX)) GO TO 200
      DO 190 J = 1, 8
      CALL SCALE(X,Y+ZLOG(J),VX,VY)
      CALL GSMOVE(VX,VY)
190   CALL GSDRAW(VX+TCKSGN/SHORTF,VY)
200   CONTINUE
      Y = Y + YTICK
      N = N-1
      IF (N .GT. 0) GO TO 110
      IF (X .EQ. XMAX) GO TO 300
C
C     IF LINEAR AXIS, PLACE REMOTE EXPONENT IF NEEDED
C
      IF (LOGYY .OR. (.NOT. LRMTEX)) GO TO 260
      IF (IAND(IAXES,1024) .NE. 0) GO TO 260
      CALL SCALE(XMIN,(YTMIN+YTICK/2.0)*TENEXP,VX,VY)
      CALL SICOPY("E"C,NUMBR)
      CALL NUMSTR(IYPWR,NUMBR(2))
      CALL GSMOVE(VX-CXSIZE*(LENB(NUMBR)+0.5),VY-CYSIZE/2.0)
      CALL GSPSTR(NUMBR)
C
C     NOW PLACE Y LABLE
C
260   CALL SCALE(XMIN,(YMIN+YMAX)/2.0,VX,VY)
      CALL GSMOVE(VX-(MXLAB+0.25)*CXSIZE-TICKSP-CYSIZE,
     &   VY-CXSIZE*LEN_TRIM(YLAB)/2.0)
      CALL GSSETC(CYSIZE,90.0)
      CALL GSPSTC(YLAB)
      CALL GSSETC(CYSIZE,0.0)
      IF (IAND(IAXES,128) .EQ. 0) GO TO 300
      X = XMAX
      TCKSGN = TICKLN
      GO TO 100
300   CONTINUE
C
C     ********** DRAW X AXIS **********
C
      LOGT = .FALSE.
      IF (.NOT. LOGXX .OR. XTICK .NE. 1.0) GO TO 310
      CALL SCALE(XMIN,YMIN,TEMP,VY)
      CALL SCALE(XMIN+1.0-ZLOG(8),YMIN,VX,VY)
      IF ((VX-TEMP) .GE. TMINLD) LOGT = .TRUE.
310   CONTINUE
C
C     DRAW X AXIS LINE
C
      Y = YMIN
      TCKSGN = -TICKLN
      TENEXP = 10.0**IXPWR
      TICKSP = AMAX1(0.5*CYSIZE,TICKLN)   !TICK SPACING
320   CONTINUE
      CALL SCALE(XMIN,Y,VX,VY)
      CALL GSMOVE(VX,VY)
      CALL SCALE(XMAX,Y,VX,VY)
      CALL GSDRAW(VX,VY)
C
C     DRAW AND LABEL X AXIS TICKS
C
      X = XTMIN
      N = (XTMAX-XTMIN)/XTICK + 1.1
400   CONTINUE
      CALL SCALE(X*TENEXP,Y,VX,VY)
      CALL GSMOVE(VX,VY)
      CALL GSDRAW(VX,VY+TCKSGN)
      IF (Y .EQ. YMAX) GO TO 430
      IF (IAND(IAXES,512) .NE. 0) GO TO 423
      IF (LOGXX) GO TO 410
      CALL LINLAB(INT(X),IXPWR,NUMBR,LRMTEX)
      GO TO 420
410   CALL LOGLAB(INT(X),NUMBR)
420   CALL GSMOVE(VX-CXSIZE*LENB(NUMBR)/2.0,VY-TICKSP-1.5*CYSIZE)
      CALL GSPSTR(NUMBR)
C
C     ADD GRID LINE AT TICK IF DESIRED
C
423   CONTINUE
      IF (IAND(IAXES,4) .EQ. 0) GO TO 430
      CALL GSLTYP(3)
      CALL GSMOVE(VX,VY)
      CALL SCALE(X*TENEXP,YMAX,VX,VY)
      CALL GSDRAW(VX,VY)
      CALL GSLTYP(1)
430   CONTINUE
C
C     DO EXTRA TICKING IF EXTRA TICKS WILL BE FAR ENOUGH APART
C
      IF ((.NOT. LOGT) .OR. (X .EQ. XTMAX)) GO TO 490
      DO 450 J = 1, 8
      CALL SCALE(X+ZLOG(J),Y,VX,VY)
      CALL GSMOVE(VX,VY)
      CALL GSDRAW(VX,VY+TCKSGN/SHORTF)
450   CONTINUE
490   CONTINUE
      X = X + XTICK
      N = N-1
      IF (N .GT. 0) GO TO 400
      IF (Y .EQ. YMAX) GO TO 590
C
C     NOW PLACE REMOTE EXPONENT IF NEEDED ON LINEAR AXIS
C
      IF (LOGXX .OR. (.NOT. LRMTEX)) GO TO 520
      IF (IAND(IAXES,512) .NE. 0) GO TO 520
      CALL SCALE(XMIN,YMIN,VX,VY)
      CALL SICOPY("E"C,NUMBR)
      CALL NUMSTR(IXPWR,NUMBR(2))
      CALL GSMOVE(VX+3*CXSIZE,VY-TICKSP-2.75*CYSIZE)
      CALL GSPSTR(NUMBR)
C
C     NOW PLACE X AXIS LABLE
C
520   CALL SCALE((XMIN+XMAX)/2.0,YMIN,VX,VY)
      CALL GSMOVE(VX-CXSIZE*LEN_TRIM(XLAB)/2.0,VY-TICKSP-4.0*CYSIZE)
      CALL GSPSTC(XLAB)
      IF (IAND(IAXES,64) .EQ. 0) GO TO 590
      Y = YMAX
      TCKSGN = TICKLN
      GO TO 320
590   CONTINUE
C
C     ********** PLACE TITLE **********
C
      CALL SCALE((XMIN+XMAX)/2.0,YMAX,VX,VY)
      TCKSGN = 0.0
      IF (IAND(IAXES,64) .NE. 0) TCKSGN = TICKSP
      CALL GSMOVE(VX-CXSIZE*LEN_TRIM(TITLE)/2.0,VY+TCKSGN+CYSIZE)
      CALL GSPSTC(TITLE)
C
C     MAKE SURE "PLTCLP" CONTAINS LIMITS PICKED BY MAPIT.   ONLY MAINTAINED
C     FOR CALLERS INFO.
C
      IF (.NOT. LOGXX) GO TO 610
            XMIN = 10.0**XMIN
            XMAX = 10.0**XMAX
            LOGX = .TRUE.
610   CONTINUE
      IF (.NOT. LOGYY) GO TO 620
            YMIN = 10.0**YMIN
            YMAX = 10.0**YMAX
            LOGY = .TRUE.
620   CONTINUE
      RETURN
      END
      SUBROUTINE MAPPRM(XLEFT,XRIGHT,YBOT,YTOP,CSIZE,TKLN,LRAXIS)
      LOGICAL LRAXIS
      INCLUDE 'PLTSIZ.PRM'
      INCLUDE 'PLTPRM.PRM'
C
C
      CXSIZE = GSCWID()*CSIZE/GSCHIT()
      CYSIZE = CSIZE
      TICKLN = TKLN
      TICKSP = AMAX1(0.0,TICKLN)
      TLABLN = ILABSZ()+0.25
      XVSTRT = XLEFT + TICKSP + TLABLN*CXSIZE + 2.0*CYSIZE + 0.25
      XVLEN = XRIGHT - XVSTRT - (TLABLN/2.0)*CXSIZE - 0.25
      IF (LRAXIS) XVLEN = XVLEN - (TICKSP + TLABLN*CXSIZE + 2.0*CYSIZE)
      TICKSP = AMAX1(0.5*CYSIZE,TICKLN)
      YVSTRT = YBOT + TICKSP + 4.25*CYSIZE + 0.25
      YVLEN = YTOP - YVSTRT - 2.0*CYSIZE - 0.25
      RETURN
      END
      SUBROUTINE MAPSET(XLEFT,XRIGHT,YBOT,YTOP,CSIZE,TKLN,LRAXIS)
      LOGICAL LRAXIS
C
      INCLUDE 'GCDCHR.PRM'
C
C
      CALL MAPPRM(XLEFT*XLENCM/100.0,XRIGHT*XLENCM/100.0,
     &   YBOT*YLENCM/100.0,YTOP*YLENCM/100.0,CSIZE,TKLN,LRAXIS)
      RETURN
      END
      SUBROUTINE MAPSIZ(XL,XR,YB,YT,CHRSIZ)
      INCLUDE 'GCDCHR.PRM'
C
      XLEFT = XLENCM*XL/100.0
      IF (XLEFT .EQ. 0.0) XLEFT = 0.1
      XRIGHT = XLENCM*XR/100.0
      IF (XR .EQ. 100.0) XRIGHT = XRIGHT - 0.1
      YBOT = YLENCM*YB/100.0
      IF (YB .EQ. 0.0) YBOT = 0.1
      YTOP = YLENCM*YT/100.0
      IF (YT .EQ. 100.0) YTOP = YTOP - 0.1
      CSIZE = CHRSIZ
      IF (CSIZE .EQ. 0.0)
     &   CSIZE = GOODCS(AMAX1(0.3,AMIN1(YTOP-YBOT,XRIGHT-XLEFT)/80.0))
      CALL MAPPRM(XLEFT,XRIGHT,YBOT,YTOP,CSIZE,0.9*CSIZE,.FALSE.)
      RETURN
      END
      SUBROUTINE MAPSML(XLOW,XHIGH,YLOW,YHIGH,XLAB,YLAB,TITLE,IAXES)
C
C     Cut down version of MAPIT for those users who only need MAPIT to do
C     simple things.
C
C     The following options have been commented out:
C
C     OPTION            COMMENT CHARS           ADDED LINE CMNT CHARS
C     ------            -------------           ---------------------
C     GRID LINES        CC                !!
C     LOG AXES          CCC               !!!
C     BOXED PLOT        CCCC              !!!!
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
      INCLUDE 'PLTCOM.PRM'
      INCLUDE 'PLTSIZ.PRM'
      INCLUDE 'PLTCLP.PRM'
      INCLUDE 'PLTPRM.PRM'
C
      CHARACTER*(*) XLAB, YLAB, TITLE
      INTEGER*1 NUMBR(14)
      LOGICAL*1 LRMTEX, LSHORT, LRAGGD
CCC   LOGICAL*1 LOGXX, LOGYY
CCC   LOGICAL*1 LOGT
CCC   DIMENSION ZLOG(8)
C
CCC   DATA ZLOG /0.3010, 0.4771, 0.6021, 0.6990, 0.7782, 0.8451,
CCC  &   0.9031, 0.9542 /
CCC   DATA TMINLD /0.1/ !MINIMUM DISTANCE BETWEEN SHORT TICKS (1 MM)
CCC   DATA SHORTF /2.0/ !SHORT TICKS = TICKLN/SHORTF
C
C
C     SET LOGX AND LOGY TO FALSE FOR OUR USAGE OF SCALE
C
      LOGX = .FALSE.
      LOGY = .FALSE.
C
C     SEE WHAT TYPE OF AXES ARE DESIRED
C
CCC   LOGXX = IAND(IAXES,1) .NE. 0
CCC   LOGYY = IAND(IAXES,2) .NE. 0
      LRAGGD = IAND(IAXES,256) .NE. 0
C
C     DO THE AXES SCALING
C
      NUMTK = MIN0(10,INT(XVLEN/((ILABSZ()+1.0)*CXSIZE)))
CCC   IF (LOGXX) GO TO 20
      LSHORT = IAND(IAXES,16) .NE. 0
      CALL AXIS(XLOW,XHIGH,NUMTK,LSHORT,LRAGGD,XMIN,XMAX,XTMIN,XTMAX,
     &   XTICK,IXPWR)
CCC   GO TO 40
CCC20 CALL LAXIS(XLOW,XHIGH,NUMTK,XMIN,XMAX,XTICK)
CCC   XTMIN = XMIN
CCC   XTMAX = XMAX
CCC   IXPWR = 0
CCC40 CONTINUE
      NUMTK = MIN0(10,INT(YVLEN/(3.0*CYSIZE)))
CCC   IF (LOGYY) GO TO 60
      LSHORT = IAND(IAXES,32) .NE. 0
      CALL AXIS(YLOW,YHIGH,NUMTK,LSHORT,LRAGGD,YMIN,YMAX,YTMIN,YTMAX,
     &   YTICK,IYPWR)
CCC   GO TO 80
CCC60 CALL LAXIS(YLOW,YHIGH,NUMTK,YMIN,YMAX,YTICK)
CCC   YTMIN = YMIN
CCC   YTMAX = YMAX
CCC   IYPWR = 0
CCC80 CONTINUE
C
C     SET UP TEMPORARY SCALING FACTORS
C
      UX0 = XMIN
      UDX = XMAX - XMIN
      UY0 = YMIN
      UDY = YMAX - YMIN
C
C     ********** DRAW Y AXES **********
C
      CALL GSSETC(CYSIZE,0.0)
CCC   LOGT = .FALSE.
CCC   IF (.NOT. LOGYY .OR. YTICK .NE. 1.0) GO TO 90
CCC   CALL SCALE(XMIN,YMIN,VX,TEMP)
CCC   CALL SCALE(XMIN,YMIN+1.0-ZLOG(8),VX,VY)
CCC   IF ((VY-TEMP) .GE. TMINLD) LOGT = .TRUE.
CCC90 CONTINUE
C
C     DRAW Y AXIS LINE
C
      MXLAB = 3
      TENEXP = 10.0**IYPWR
      X = XMIN
      TICKSP = AMAX1(0.0,TICKLN)    !TICK SPACING
CCCC  IF (IAND(IAXES,64) .NE. 0) YVLEN = YVLEN - TICKSP
      TCKSGN = -TICKLN        !TICKS TO LEFT FOR LEFT Y AXIS
100   CONTINUE
      CALL SCALE(X,YMAX,VX,VY)
      CALL GSMOVE(VX,VY)
      CALL SCALE(X,YMIN,VX,VY)
      CALL GSDRAW(VX,VY)
C
C     DRAW AND LABEL Y AXIS TICKS
C
      Y = YTMIN
      N = (YTMAX-YTMIN)/YTICK + 1.1
110   CONTINUE
      CALL SCALE(X,Y*TENEXP,VX,VY)
      CALL GSMOVE(VX,VY)
      CALL GSDRAW(VX+TCKSGN,VY)
CCCC  IF (X .EQ. XMAX) GO TO 185
      IF (IAND(IAXES,1024) .NE. 0) GO TO 183
C
C     PLACE THE APPROPIATE LABEL
C
CCC   IF (LOGYY) GO TO 160
      CALL LINLAB(INT(Y),IYPWR,NUMBR,LRMTEX)
CCC   GO TO 180
CCC160      CALL LOGLAB(INT(Y),NUMBR)
180   LN = LENB(NUMBR)
      MXLAB = MAX0(MXLAB,LN)
      CALL GSMOVE(VX-TICKSP-CXSIZE*(LN+0.25),VY-CYSIZE/2.0)
      CALL GSPSTR(NUMBR)
C
C     ADD GRID LINE AT TICK IF DESIRED
C
183   CONTINUE
CC    IF (IAND(IAXES,8) .EQ. 0) GO TO 185
CC    CALL GSLTYP(3)
CC    CALL GSMOVE(VX,VY)
CC    CALL SCALE(XMAX,Y*TENEXP,VX,VY)
CC    CALL GSDRAW(VX,VY)
CC    CALL GSLTYP(1)
185   CONTINUE
C
C     DO EXTRA TICKING IF EXTRA TICKS WILL BE FAR ENOUGH APART
C
CCC   IF ((.NOT. LOGT) .OR. (Y .EQ. YTMAX)) GO TO 200
CCC   DO 190 J = 1, 8
CCC   CALL SCALE(X,Y+ZLOG(J),VX,VY)
CCC   CALL GSMOVE(VX,VY)
CCC190      CALL GSDRAW(VX+TCKSGN/SHORTF,VY)
200   CONTINUE
      Y = Y + YTICK
      N = N-1
      IF (N .GT. 0) GO TO 110
CCCC  IF (X .EQ. XMAX) GO TO 300
C
C     IF LINEAR AXIS, PLACE REMOTE EXPONENT IF NEEDED
C
CCC   IF (LOGYY .OR. (.NOT. LRMTEX)) GO TO 260
      IF (.NOT. LRMTEX) GO TO 260         !!!INSTEAD OF PREVIOUS LINE
      IF (IAND(IAXES,1024) .NE. 0) GO TO 260
      CALL SCALE(XMIN,(YTMIN+YTICK/2.0)*TENEXP,VX,VY)
      CALL SICOPY("E"C,NUMBR)
      CALL NUMSTR(IYPWR,NUMBR(2))
      CALL GSMOVE(VX-CXSIZE*(LENB(NUMBR)+0.5),VY-CYSIZE/2.0)
      CALL GSPSTR(NUMBR)
C
C     NOW PLACE Y LABLE
C
260   CALL SCALE(XMIN,(YMIN+YMAX)/2.0,VX,VY)
      CALL GSMOVE(VX-(MXLAB+0.25)*CXSIZE-TICKSP-CYSIZE,
     &   VY-CXSIZE*LEN_TRIM(YLAB)/2.0)
      CALL GSSETC(CYSIZE,90.0)
      CALL GSPSTC(YLAB)
      CALL GSSETC(CYSIZE,0.0)
CCCC  IF (IAND(IAXES,128) .EQ. 0) GO TO 300
CCCC  X = XMAX
CCCC  TCKSGN = TICKLN
CCCC  GO TO 100
300   CONTINUE
C
C     ********** DRAW X AXIS **********
C
CCC   LOGT = .FALSE.
CCC   IF (.NOT. LOGXX .OR. XTICK .NE. 1.0) GO TO 310
CCC   CALL SCALE(XMIN,YMIN,TEMP,VY)
CCC   CALL SCALE(XMIN+1.0-ZLOG(8),YMIN,VX,VY)
CCC   IF ((VX-TEMP) .GE. TMINLD) LOGT = .TRUE.
CCC310      CONTINUE
C
C     DRAW X AXIS LINE
C
      Y = YMIN
      TCKSGN = -TICKLN
      TENEXP = 10.0**IXPWR
      TICKSP = AMAX1(0.5*CYSIZE,TICKLN)   !TICK SPACING
320   CONTINUE
      CALL SCALE(XMIN,Y,VX,VY)
      CALL GSMOVE(VX,VY)
      CALL SCALE(XMAX,Y,VX,VY)
      CALL GSDRAW(VX,VY)
C
C     DRAW AND LABEL X AXIS TICKS
C
      X = XTMIN
      N = (XTMAX-XTMIN)/XTICK + 1.1
400   CONTINUE
      CALL SCALE(X*TENEXP,Y,VX,VY)
      CALL GSMOVE(VX,VY)
      CALL GSDRAW(VX,VY+TCKSGN)
CCCC  IF (Y .EQ. YMAX) GO TO 430
      IF (IAND(IAXES,512) .NE. 0) GO TO 423
CCC   IF (LOGXX) GO TO 410
      CALL LINLAB(INT(X),IXPWR,NUMBR,LRMTEX)
CCC   GO TO 420
CCC410      CALL LOGLAB(INT(X),NUMBR)
420   CALL GSMOVE(VX-CXSIZE*LENB(NUMBR)/2.0,VY-TICKSP-1.5*CYSIZE)
      CALL GSPSTR(NUMBR)
C
C     ADD GRID LINE AT TICK IF DESIRED
C
423   CONTINUE
CC    IF (IAND(IAXES,4) .EQ. 0) GO TO 430
CC    CALL GSLTYP(3)
CC    CALL GSMOVE(VX,VY)
CC    CALL SCALE(X*TENEXP,YMAX,VX,VY)
CC    CALL GSDRAW(VX,VY)
CC    CALL GSLTYP(1)
CC430 CONTINUE
C
C     DO EXTRA TICKING IF EXTRA TICKS WILL BE FAR ENOUGH APART
C
CCC   IF ((.NOT. LOGT) .OR. (X .EQ. XTMAX)) GO TO 490
CCC   DO 450 J = 1, 8
CCC   CALL SCALE(X+ZLOG(J),Y,VX,VY)
CCC   CALL GSMOVE(VX,VY)
CCC   CALL GSDRAW(VX,VY+TCKSGN/SHORTF)
CCC450      CONTINUE
CCC490      CONTINUE
      X = X + XTICK
      N = N-1
      IF (N .GT. 0) GO TO 400
CCCC  IF (Y .EQ. YMAX) GO TO 590
C
C     NOW PLACE REMOTE EXPONENT IF NEEDED ON LINEAR AXIS
C
CCC   IF (LOGXX .OR. (.NOT. LRMTEX)) GO TO 520
      IF (.NOT. LRMTEX) GO TO 520         !!!INSTEAD OF PREVIOUS LINE
      IF (IAND(IAXES,512) .NE. 0) GO TO 520
      CALL SCALE(XMIN,YMIN,VX,VY)
      CALL SICOPY("E"C,NUMBR)
      CALL NUMSTR(IXPWR,NUMBR(2))
      CALL GSMOVE(VX+3*CXSIZE,VY-TICKSP-2.75*CYSIZE)
      CALL GSPSTR(NUMBR)
C
C     NOW PLACE X AXIS LABLE
C
520   CALL SCALE((XMIN+XMAX)/2.0,YMIN,VX,VY)
      CALL GSMOVE(VX-CXSIZE*LEN_TRIM(XLAB)/2.0,VY-TICKSP-4.0*CYSIZE)
      CALL GSPSTC(XLAB)
CCCC  IF (IAND(IAXES,64) .EQ. 0) GO TO 590
CCCC  Y = YMAX
CCCC  TCKSGN = TICKLN
CCCC  GO TO 320
CCCC590     CONTINUE
C
C     ********** PLACE TITLE **********
C
      CALL SCALE((XMIN+XMAX)/2.0,YMAX,VX,VY)
      TCKSGN = 0.0
CCCC  IF (IAND(IAXES,64) .NE. 0) TCKSGN = TICKSP
      CALL GSMOVE(VX-CXSIZE*LEN_TRIM(TITLE)/2.0,VY+TCKSGN+CYSIZE)
      CALL GSPSTC(TITLE)
C
C     MAKE SURE "PLTCLP" CONTAINS LIMITS PICKED BY MAPIT.   ONLY MAINTAINED
C     FOR CALLERS INFO.
C
CCC   IF (.NOT. LOGXX) GO TO 610
CCC         XMIN = 10.0**XMIN
CCC         XMAX = 10.0**XMAX
CCC610      CONTINUE
CCC   IF (.NOT. LOGYY) GO TO 620
CCC         YMIN = 10.0**YMIN
CCC         YMAX = 10.0**YMAX
CCC620      CONTINUE
C
C     TELL SCALE ABOUT LOG AXIS SCALING NOW
C
CCC   LOGX = LOGXX
CCC   LOGY = LOGYY
      RETURN
      END
      SUBROUTINE MAPSZ2(XL,XR,YB,YT,CHRSIZ)
      INCLUDE 'GCDCHR.PRM'
C
      XLEFT = XLENCM*XL/100.0
      IF (XLEFT .EQ. 0.0) XLEFT = 0.1
      XRIGHT = XLENCM*XR/100.0
      IF (XR .EQ. 100.0) XRIGHT = XRIGHT - 0.1
      YBOT = YLENCM*YB/100.0
      IF (YB .EQ. 0.0) YBOT = 0.1
      YTOP = YLENCM*YT/100.0
      IF (YT .EQ. 100.0) YTOP = YTOP - 0.1
      CSIZE = CHRSIZ
      IF (CSIZE .EQ. 0.0)
     &   CSIZE = GOODCS(AMAX1(0.3,AMIN1(YTOP-YBOT,XRIGHT-XLEFT)/80.0))
      CALL MAPPRM(XLEFT,XRIGHT,YBOT,YTOP,CSIZE,0.9*CSIZE,.TRUE.)
      RETURN
      END
      SUBROUTINE MINMAX(ARRAY,NPTS,BMIN,BMAX)
C
C     FIND MINIMUM AND MAXIMUM OF THE ARRAY
C
      DIMENSION ARRAY(NPTS)
      BMIN = ARRAY(1)
      BMAX = BMIN
      DO 100 I=2,NPTS
      BMIN = AMIN1(BMIN,ARRAY(I))
100   BMAX = AMAX1(BMAX,ARRAY(I))
      RETURN
      END
      SUBROUTINE NUMSTR(JVAL,BSTRNG)
C
C     THIS SUBROUTINE CONVERTS "JVAL" (INTEGER) TO AN INTEGER STRING
C     WITH NO LEADING OR TRAILING SPACES.
C
      INTEGER(1) BSTRNG(1),NUMBER(10), BNULL
      CHARACTER*10 NUMCHAR
      EQUIVALENCE (NUMCHAR,NUMBER)
      DATA BNULL /0/
C
      WRITE(NUMCHAR,11)JVAL
11    FORMAT(I9)
      NUMBER(10) = BNULL
      CALL STRPBL(NUMBER)
      CALL SICOPY(NUMCHAR,BSTRNG)
      RETURN
      END
      SUBROUTINE PLTBOX(XLEFT,XRIGHT,YBOT,YTOP)
C
C
      CSIZE = GOODCS(AMIN1(YTOP-YBOT,XRIGHT-XLEFT)/80.0)
      CALL MAPPRM(XLEFT,XRIGHT,YBOT,YTOP,CSIZE,0.9*CSIZE,.FALSE.)
      RETURN
      END
      SUBROUTINE PLTBX2(XLEFT,XRIGHT,YBOT,YTOP)
C
C
      CSIZE = GOODCS(AMIN1(YTOP-YBOT,XRIGHT-XLEFT)/80.0)
      CALL MAPPRM(XLEFT,XRIGHT,YBOT,YTOP,CSIZE,0.9*CSIZE,.TRUE.)
      RETURN
      END
      SUBROUTINE POINTC(X,Y,NPTS)
      DIMENSION X(NPTS), Y(NPTS)
C
C     THIS SUBROUTINE PLOTS THE VISIBLE POINTS ON THE SCREEN
C
      INCLUDE 'PLTSIZ.PRM'
C
      DIMENSION AREA(4)
C
      CALL GSSCLP(XVSTRT,XVSTRT+XVLEN,YVSTRT,YVSTRT+YVLEN,AREA)
      DO 100 I=1,NPTS
      CALL SCALE(X(I),Y(I),VX,VY)
      CALL GSMOVE(VX,VY)
      CALL SYMBOL(3,0.3)
100   CONTINUE
      CALL GSRCLP(AREA)
      RETURN
      END
      SUBROUTINE POINTS(X,Y,NPTS)
C
C     THIS SUBROUTINE IS USED TO PLOT POINTS ON THE SCREEN
C
      DIMENSION X(NPTS),Y(NPTS)
      DO 100 I=1, NPTS
      CALL SCALE(X(I),Y(I),VX,VY)
      CALL GSMOVE(VX,VY)
100   CALL SYMBOL(3,0.3)
      RETURN
      END
      SUBROUTINE RLSDEV
C
C
      INCLUDE 'GCDSEL.PRM'
      REAL(4) DUMMY(1)
C
C     RELEASE CURRENT DEVICE
C
      IF (IDEV .NE. 0) CALL GSDRVR(6,DUMMY,DUMMY)
      IDEV = 0
C
C     ALL DONE HERE
C
      RETURN
      END
      SUBROUTINE RSTMAP(AREA)
      DIMENSION AREA(14)
C
C     THIS SUBROUTINE RESTORES THE MAPPING PARAMETERS SAVED BY "SAVMAP".
C
      INCLUDE 'PLTCLP.PRM'
      INCLUDE 'PLTCOM.PRM'
      INCLUDE 'PLTSIZ.PRM'
C
C     RESTORE THE MAPIT CLIPPING LIMITS
C
      XMIN = AREA(1)
      XMAX = AREA(2)
      YMIN = AREA(3)
      YMAX = AREA(4)
C
C     SAVE WORLD TO VIRTUAL COORD. TRANSFORMATION CONST.
C
      UX0 = AREA(5)
      UDX = AREA(6)
      UY0 = AREA(7)
      UDY = AREA(8)
      LOGX = .FALSE.
      IF (AREA(9) .NE. 0.0) LOGX = .TRUE.
      LOGY = .FALSE.
      IF (AREA(10) .NE. 0.0) LOGY = .TRUE.
C
C     RESTORE VIRT. COORD. OF AXES
C
      XVSTRT = AREA(11)
      YVSTRT = AREA(12)
      XVLEN = AREA(13)
      YVLEN = AREA(14)
C
C     ALL DONE
C
      RETURN
      END
      SUBROUTINE SAVMAP(AREA)
      DIMENSION AREA(15)
C
C     THIS SUBROUTINE SAVES THE STATUS FROM THE LAST MAPPRM-MAPIT CALLS.
C     WHEN USED IN CONJUCTION "RSTMAP", THE USER CAN SWITCH AROUND BETWEEN
C     MULTIPLE GRAPHIC REGIONS ON THE SCREEN CREATED WITH "MAPIT".
C
      INCLUDE 'PLTCLP.PRM'
      INCLUDE 'PLTCOM.PRM'
      INCLUDE 'PLTSIZ.PRM'
C
C     SAVE THE MAPIT CLIPPING LIMITS
C
      AREA(1) = XMIN
      AREA(2) = XMAX
      AREA(3) = YMIN
      AREA(4) = YMAX
C
C     SAVE WORLD TO VIRTUAL COORD. TRANSFORMATION CONST.
C
      AREA(5) = UX0
      AREA(6) = UDX
      AREA(7) = UY0
      AREA(8) = UDY
      AREA(9) = 0.0
      IF (LOGX) AREA(9) = 1.0
      AREA(10) = 0.0
      IF (LOGY) AREA(10) = 1.0
C
C     NOW SAVE VIRT. COORD. LOCATION OF AXES
C
      AREA(11) = XVSTRT
      AREA(12) = YVSTRT
      AREA(13) = XVLEN
      AREA(14) = YVLEN
C
C     ALL DONE
C
      RETURN
      END
      SUBROUTINE SCALE(X,Y,VX,VY)
C
C     THIS SUBROUTINE CONVERTS THE POINT (X,Y) FROM WORLD COORDINATES
C     TO THE POINT (VX,VY) IN VIRTUAL COORDINATES.
C
      INCLUDE 'PLTCOM.PRM'
      INCLUDE 'PLTSIZ.PRM'
C
C     DEFINE "LOG10(0.0)" AS SMLLOG
C
      DATA SMLLOG /-100.0/
C
      XX = X
      IF (.NOT. LOGX) GO TO 10
            IF (X .LE. 0.0) GO TO 5
                  XX = ALOG10(X)
                  GO TO 10
5               CONTINUE
                  XX = SMLLOG
10    CONTINUE
      YY = Y
      IF (.NOT. LOGY) GO TO 20
            IF (Y .LE. 0.0) GO TO 15
                  YY = ALOG10(Y)
                  GO TO 20
15              CONTINUE
                  YY = SMLLOG
20    CONTINUE
      VX = XVSTRT + XVLEN*(XX-UX0)/UDX
      VY = YVSTRT + YVLEN*(YY-UY0)/UDY
      RETURN
      END
      Subroutine SelDev(Lun)
      INTEGER*1 BNAME(40)
C
C     Show the device numbers and their names and ask for
C     a device number. Attempt to select that device. If
C     not successful, display an error message and ask for
C     a new device number.
C
C     Display device numbers and names.
C
      WRITE(*,91)
91    FORMAT(/)
      IDEV = 1
110         CALL GSDNAM(IDEV,BNAME)
            L = LENB(BNAME)
            IF (L .EQ. 0) GO TO 120
            WRITE(*,111) IDEV, (BNAME(I), I=1,L)
111         FORMAT(' Device ',I2,' is ',40A1)
            IDEV = IDEV + 1
            GO TO 110
120   CONTINUE

C     Ask for a device number.

      WRITE(*,91)
5     WRITE(*,121)
121   FORMAT('$Graphics device number? ')
      READ(*,'(I5)') IDEV

C     Select that device.

      CALL DEVSEL(IDEV,Lun,IERR)

      IF (IERR .EQ. 0) GO TO 200

      WRITE(*,131)
131   FORMAT(' That device is not available at this time!')
      GO TO 5

200   Continue

      Return
      END
      SUBROUTINE STRPBL(S)
C
C     STRPBL STRIPS LEADING AND TRAILING BLANKS FROM THE STRING S
C
      INTEGER(1) S(1),NUL
      DATA NUL/0/
      NONBLK=0
      DO 1 I=1,1000
      IF(S(I).NE.ICHAR(' '))THEN
         NONBLK=NONBLK+1
         IF(I.NE.NONBLK)S(NONBLK)=S(I)
      END IF
      IF(S(I).EQ.NUL)THEN
         S(NONBLK+1)=NUL
         RETURN
      END IF
1     CONTINUE
      WRITE(*,90)
90    FORMAT(' ERROR IN STRPBL - LOOKS LIKE A RUNAWAY STRING')
      END
      SUBROUTINE SYAXIS(YLOW,YHIGH,YLAB,IAXES)
      INCLUDE 'PLTCOM.PRM'
      INCLUDE 'PLTSIZ.PRM'
      INCLUDE 'PLTCLP.PRM'
      INCLUDE 'PLTPRM.PRM'
C
      CHARACTER*(*) YLAB
      INTEGER*1 NUMBR(14)
      LOGICAL*1 LOGYY, LOGT, LRMTEX, LSHORT, LRAGGD
      DIMENSION ZLOG(8)
C
      DATA ZLOG /0.3010, 0.4771, 0.6021, 0.6990, 0.7782, 0.8451,
     &   0.9031, 0.9542 /
      DATA TMINLD /0.1/ !MINIMUM DISTANCE BETWEEN SHORT TICKS (1 MM)
      DATA SHORTF /2.0/ !SHORT TICKS = TICKLN/SHORTF
C
C
C     SET LOGY TO FALSE FOR OUR USAGE OF SCALE
C
      LOGY = .FALSE.
C
C     SEE WHAT TYPE OF AXIS IS DESIRED
C
      LOGYY = IAND(IAXES,2) .NE. 0
      LRAGGD = IAND(IAXES,256) .NE. 0
C
C     DO THE AXES SCALING
C
      NUMTK = MIN0(10,INT(YVLEN/(3.0*CYSIZE)))
      IF (LOGYY) GO TO 60
      LSHORT = IAND(IAXES,32) .NE. 0
      CALL AXIS(YLOW,YHIGH,NUMTK,LSHORT,LRAGGD,YMIN,YMAX,YTMIN,YTMAX,
     &   YTICK,IYPWR)
      GO TO 80
60    CALL LAXIS(YLOW,YHIGH,NUMTK,YMIN,YMAX,YTICK)
      YTMIN = YMIN
      YTMAX = YMAX
      IYPWR = 0
80    CONTINUE
C
C     SET UP TEMPORARY SCALING FACTORS
C
      UY0 = YMIN
      UDY = YMAX - YMIN
C
C     ********** DRAW Y AXES **********
C
      CALL GSSETC(CYSIZE,0.0)
      LOGT = .FALSE.
      IF (.NOT. LOGYY .OR. YTICK .NE. 1.0) GO TO 90
      CALL SCALE(XMIN,YMIN,VX,TEMP)
      CALL SCALE(XMIN,YMIN+1.0-ZLOG(8),VX,VY)
      IF ((VY-TEMP) .GE. TMINLD) LOGT = .TRUE.
90    CONTINUE
C
C     DRAW Y AXIS LINE
C
      MXLAB = 3
      TENEXP = 10.0**IYPWR
      X = XMAX
      TICKSP = AMAX1(0.0,TICKLN)    !TICK SPACING
100   CONTINUE
      CALL SCALE(X,YMAX,VX,VY)
      CALL GSMOVE(VX,VY)
      CALL SCALE(X,YMIN,VX,VY)
      CALL GSDRAW(VX,VY)
C
C     DRAW AND LABEL Y AXIS TICKS
C
      Y = YTMIN
110   CONTINUE
      CALL SCALE(X,Y*TENEXP,VX,VY)
      CALL GSMOVE(VX,VY)
      CALL GSDRAW(VX+TICKLN,VY)
C
C     PLACE THE APPROPIATE LABEL
C
      IF (IAND(IAXES,1024) .NE. 0) GO TO 183
      IF (LOGYY) GO TO 160
      CALL LINLAB(INT(Y),IYPWR,NUMBR,LRMTEX)
      GO TO 180
160   CALL LOGLAB(INT(Y),NUMBR)
180   LN = LENB(NUMBR)
      MXLAB = MAX0(MXLAB,LN)
      CALL GSMOVE(VX+TICKSP+0.5*CXSIZE,VY-CYSIZE/2.0)
      CALL GSPSTR(NUMBR)
183   CONTINUE
C
C     ADD GRID LINE AT TICK IF DESIRED
C
      IF (IAND(IAXES,8) .EQ. 0) GO TO 185
      CALL GSLTYP(3)
      CALL GSMOVE(VX,VY)
      CALL SCALE(XMIN,Y*TENEXP,VX,VY)
      CALL GSDRAW(VX,VY)
      CALL GSLTYP(1)
185   CONTINUE
C
C     DO EXTRA TICKING IF EXTRA TICKS WILL BE FAR ENOUGH APART
C
      IF ((.NOT. LOGT) .OR. (Y .EQ. YTMAX)) GO TO 200
      DO 190 J = 1, 8
      CALL SCALE(X,Y+ZLOG(J),VX,VY)
      CALL GSMOVE(VX,VY)
190   CALL GSDRAW(VX+TICKLN/SHORTF,VY)
200   CONTINUE
      Y = Y + YTICK
      IF (Y .LE. YTMAX) GO TO 110
C
C     IF LINEAR AXIS, PLACE REMOTE EXPONENT IF NEEDED
C
      IF (LOGYY .OR. (.NOT. LRMTEX)) GO TO 260
      IF (IAND(IAXES,1024) .NE. 0) GO TO 260
      CALL SCALE(XMAX,(YTMIN+YTICK/2.0)*TENEXP,VX,VY)
      CALL SICOPY("E"C,NUMBR)
      CALL NUMSTR(IYPWR,NUMBR(2))
      CALL GSMOVE(VX+0.5*CXSIZE,VY-CYSIZE/2.0)
      CALL GSPSTR(NUMBR)
C
C     NOW PLACE Y LABLE
C
260   CALL SCALE(X,(YMIN+YMAX)/2.0,VX,VY)
      CALL GSMOVE(VX+(MXLAB+0.5)*CXSIZE+TICKSP+1.5*CYSIZE,
     &   VY-CXSIZE*LEN_TRIM(YLAB)/2.0)
      CALL GSSETC(CYSIZE,90.0)
      CALL GSPSTC(YLAB)
      CALL GSSETC(CYSIZE,0.0)
300   CONTINUE
C
C     TELL USER THE SCALING LIMITS
C
      IF (.NOT. LOGYY) GO TO 320
            YMIN = 10.0**YMIN
            YMAX = 10.0**YMAX
320   CONTINUE
C
C     TELL SCALE ABOUT LOG AXIS SCALING NOW
C
      LOGY = LOGYY
      RETURN
      END
      SUBROUTINE SYMBOL(ISYMNO,SYMSIZ)
C
C     This subroutine places the desired symbol ("ISYMNO") at the
c     current location with a size of "SYMSIZ".
C
C     1: triangle   4: hour glass              7: theta
C     2: square     5: upside down triangle    8: phi
C     3: diamond    6: circle
C
      INCLUDE 'GCVPOS.PRM'
      DIMENSION SYMMOV(110), ISYMST(9)
      DATA SYMMOV /
     &   0.0,0.666667,  -0.5,-0.333333,  0.5,-0.333333,  0.0,0.666667,
     &   -0.45,0.45,  -0.45,-0.45,  0.45,-0.45,  0.45,0.45,  -0.45,0.45,
     &   0.0,0.55,  -0.44,0.0,  0.0,-0.55,  0.44,0.0,  0.0,0.55,
     &   -0.4,0.5,  0.4,0.5,  -0.4,-0.5,  0.4,-0.5,  -0.4,0.5,
     &   0.0,-0.666667,  -0.5,0.333333,  0.5,0.333333,  0.0,-0.666667,
     &   .5,0., .353,.353, 0.,.5, -.353,.353, -.5,0., -.353,-.353, 
     &   0.,-.5, .353,-.353, .5,0.,
     &   .4,0.,.4,.3,.2,.5,-.2,.5,-.4,.3,-.4,-.3,-.2,-.5,.2,-.5,.4,-.3,
     &   .4,0.,-.4,0.,
     &   .3,.3,.2,.4,-.2,.4,-.4,.2,-.4,-.2,-.2,-.4,.2,-.4,.4,-.2,.4,.2,
     &   .3,.3,.5,.5,-.5,-.5/

      DATA ISYMST /1,9,19,29,39,47,65,87,111/
      DATA NSYM /8/
C
C     SAVE CURRENT LOCATION
C
      X0 = XVPOS
      Y0 = YVPOS
C
C     DRAW SYMBOL IN PROPER SIZE
C
      IF (ISYMNO .LE. 0 .OR. ISYMNO .GT. NSYM) RETURN
      IPTR = ISYMST(ISYMNO)
      CALL GSMOVE(X0+SYMSIZ*SYMMOV(IPTR),Y0+SYMSIZ*SYMMOV(IPTR+1))
100   IPTR = IPTR + 2
      IF (IPTR .EQ. ISYMST(ISYMNO+1)) GO TO 200
      CALL GSDRAW(X0+SYMSIZ*SYMMOV(IPTR),Y0+SYMSIZ*SYMMOV(IPTR+1))
      GO TO 100
200   CALL GSMOVE(X0,Y0)
      RETURN
      END
      SUBROUTINE TRACCY(XMIN,XMAX,Y,NPTS)
      DIMENSION Y(NPTS)
C
C     THIS SUBROUTINE TRACES THE LINE FROM X(1),Y(1) TO
C     X(NPTS),Y(NPTS) WITH APPROPIATE CLIPPING.
C     USE THIS ROUTINE WHEN CLIPPING IS DESIRED AND THE
C     INDEPENDANT VARIABLE IS IMPLIED BY THE SUBSCRIPT
C     USING EQUAL INTERVALS FROM XMIN TO XMAX.
C
      INCLUDE 'PLTSIZ.PRM'
C
      DIMENSION AREA(4)
C
      CALL GSSCLP(XVSTRT,XVSTRT+XVLEN,YVSTRT,YVSTRT+YVLEN,AREA)
      CALL SCALE(XMIN,Y(1),VX,VY)
      CALL GSMOVE(VX,VY)
10    DX = (XMAX-XMIN)/(NPTS-1)
      DO 100 I=2,NPTS
      CALL SCALE(XMIN+(I-1)*DX,Y(I),VX,VY)
      CALL GSDRAW(VX,VY)
100   CONTINUE
      CALL GSRCLP(AREA)
      RETURN
      END
      SUBROUTINE TRACE(X,Y,NPTS)
C
C     THIS SUBROUTINE IS USED TO PLOT DATA ON THE SCREEN AS
C     A CONTINOUS LINE.
C
      DIMENSION X(2), Y(2)
      CALL SCALE(X(1),Y(1),VX,VY)
      CALL GSMOVE(VX,VY)
      DO 100 I=2,NPTS
      CALL SCALE(X(I),Y(I),VX,VY)
100   CALL GSDRAW(VX,VY)
      RETURN
      END
      SUBROUTINE TRACEC(X,Y,NPTS)
      DIMENSION X(NPTS), Y(NPTS)
C
C     THIS SUBROUTINE TRACES THE LINE FROM X(1),Y(1) TO
C     X(NPTS),Y(NPTS) WITH APPROPIATE CLIPPING.
C
      INCLUDE 'PLTSIZ.PRM'
C
      DIMENSION AREA(4)
C
      CALL GSSCLP(XVSTRT,XVSTRT+XVLEN,YVSTRT,YVSTRT+YVLEN,AREA)
      CALL SCALE(X(1),Y(1),VX,VY)
      CALL GSMOVE(VX,VY)
10    DO 100 I=2,NPTS
      CALL SCALE(X(I),Y(I),VX,VY)
      CALL GSDRAW(VX,VY)
100   CONTINUE
      CALL GSRCLP(AREA)
      RETURN
      END
      SUBROUTINE TRACEY(XMIN,XMAX,Y,NPTS)
C
C     THIS SUBROUTINE IS USED TO PLOT DATA ON THE SCREEN AS
C     A CONTINOUS LINE, GIVEN ONLY THE Y ARRAY AND XMIN AND XMAX.
C
      DIMENSION Y(2)
      CALL SCALE(XMIN,Y(1),VX,VY)
      CALL GSMOVE(VX,VY)
      XINC = (XMAX-XMIN)/(NPTS-1)
      X = XMIN
      DO 100 I=2,NPTS
      X = X + XINC
      CALL SCALE(X,Y(I),VX,VY)
100   CALL GSDRAW(VX,VY)
      RETURN
      END
      INTEGER FUNCTION LENB(S)
C
C     LENB.FOR --- LENGTH OF BYTE STRING
      INTEGER*1 S(1)
      INTEGER I
      I = 0
 10   I = I+1
      IF(I.GT.1000)THEN
         WRITE(*,90)
90       FORMAT(' ERROR IN LENB - LOOKS LIKE A RUNAWAY STRING')
         STOP
      END IF
      IF (S(I).EQ.0)THEN
         LENB=I-1
         RETURN
      END IF
      GO TO 10
      END
      SUBROUTINE SICOPY(S1,IS2)
C
      CHARACTER S1*(*)
      INTEGER*1 IS1(1),IS2(*)
      INTEGER I
C
      I = 0
10    I = I+1
      IF(I.GT.1000)THEN
         WRITE(*,90)
90       FORMAT(' ERROR IN SICOPY - LOOKS LIKE A RUNAWAY STRING')
         STOP
      END IF
	IS1=ICHAR(S1(I:I)) 
      IS2(I) = IS1(1)
      IF (IS1(1).EQ.0)THEN
         RETURN
      END IF
      GO TO 10
      END
      SUBROUTINE SCOPY(S1,S2)
C
      INTEGER*1 S1(1), S2(1)
      INTEGER I
C
      I = 0
10    I = I+1
      IF(I.GT.1000)THEN
         WRITE(*,90)
90       FORMAT(' ERROR IN SCOPY - LOOKS LIKE A RUNAWAY STRING')
         STOP
      END IF 
      S2(I) = S1(I)
      IF (S1(I).EQ.0)THEN
         S2(I)=0
         RETURN
      END IF
      GO TO 10
      END
