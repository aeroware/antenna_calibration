      SUBROUTINE GDHP_LONG(IFXN,XA,YA)
C
C     This subroutine has an alternate entry point given by the ENTRY
C     statement.  You MUST remember to change that name also when
C     configuring for a different HPGL plotter!!!!!!!
C
C     GENERIC HP PLOTTER (WITH RS-232C INTERFACE.)  THIS DRIVER SHOULD
C     HANDLE ALL HPGL SPEAKING PLOTTERS WHEN PROPERLY CONFIGURED.
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
      PARAMETER (NUMBER_FOREGROUND_COLORS = 2.0)   !NUMBER OF PENS     *
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
     &   X_RESOLUTION, Y_RESOLUTION, NUMBER_FOREGROUND_COLORS,
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
      ENTRY GDHP_TALL(IFXN,XA,YA)
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
      CALL SERINIT(CHOUT)                  !INIT. SERIAL OUTPUT ROUTINE
      CALL SEROUT(CHAR(27)//'.(')           !PLOTTER ON
C      CALL SEROUT(CHAR(27)//'.@;0:')        !NO HARDWIRED HANDSHAKE
      CALL SEROUT(CHAR(27)//'.I128;;17:')   !XON/XOFF HANDSHAKE
      CALL SEROUT(CHAR(27)//'.N;19:')       !XON/XOFF HANDSHAKE
      CALL SEROUT('DF;')                    !SET PLOTTER DEFAULT VALUES
C
      IX_FULL_SCALE = X_RESOLUTION*X_WIDTH_CM
      IY_FULL_SCALE = Y_RESOLUTION*Y_HEIGHT_CM
      WRITE(CHOUT,900) IX_FULL_SCALE, IY_FULL_SCALE
900   FORMAT('SC0,',I8,',0,',I8,';')
      CALL SEROUT(CHOUT)
      RETURN
C
C     **************************
C     GET FRESH PLOTTING SURFACE
C     **************************
C
200   CONTINUE
      CALL SEROUT('PU; SP0;')                 !PUT PEN AWAY
      LPEN_UP=.TRUE.
      LVECTOR_GOING = .FALSE.
      IF (AUTO_PAGE_PLOTTER) THEN
            CALL SEROUT('WHATEVER')
          ELSE
            WRITE(*,299)
299         FORMAT(' Place a fresh sheet of paper in the HP Plotter')
            READ(*,298)CHOUT
298         FORMAT(A)
      ENDIF
      CALL SEROUT('SP1;')                     !GET PEN 1
      RETURN
C
C     ****
C     MOVE
C     ****
C
300   CONTINUE
      IF (.NOT. LPEN_UP) THEN
            IF (LVECTOR_GOING) THEN
                  CALL SEROUT(';')
                  LVECTOR_GOING = .FALSE.
            ENDIF
            CALL SEROUT('PU;')
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
                  CALL SEROUT(';')
                  LVECTOR_GOING = .FALSE.
            ENDIF
            CALL SEROUT('PD;')
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
            CALL SEROUT(',')
          ELSE
            CALL SEROUT('PA')
            LVECTOR_GOING = .TRUE.
      ENDIF
      WRITE(CHOUT,901)IXPOSN,IYPOSN
901   FORMAT(I8,',',I8)
      CALL SEROUT(CHOUT)
      RETURN
C
C     *****************************
C     FLUSH GRAPHICS COMMAND BUFFER
C     *****************************
C
500   CONTINUE
      IF (LVECTOR_GOING) THEN
            CALL SEROUT(';')
            LVECTOR_GOING = .FALSE.
      ENDIF
      IF (.NOT. LPEN_UP) THEN
            CALL SEROUT('PU;')
            LPEN_UP = .TRUE.
      ENDIF
      CALL SEROUT('  ')
C      CALL GB_EMPTY
      RETURN
C
C     ******************
C     RELEASE THE DEVICE
C     ******************
C
600   CONTINUE
C      CALL GB_EMPTY
      WRITE(CHOUT,902)IX_FULL_SCALE,IY_FULL_SCALE
902   FORMAT('PU;SP0;PA',I8,',',I8,';')
      CALL SEROUT(CHOUT)
      LPEN_UP=.TRUE.
      CALL SEROUT(CHAR(27)//'.)')    !PLOTTER OFF WHEN Y/D SWITCH TO Y
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
      ICOLOR = XA(1)
      IF (ICOLOR .LE. 0 .OR.
     &   ICOLOR .GT. INT(NUMBER_FOREGROUND_COLORS)) RETURN
      IF (LVECTOR_GOING) THEN
            CALL SEROUT(';')
            LVECTOR_GOING = .FALSE.
      ENDIF
      IF (.NOT. LPEN_UP) THEN
            CALL SEROUT('PU;')
            LPEN_UP = .TRUE.
      ENDIF
      WRITE(CHOUT,903)ICOLOR
903   FORMAT('SP',I3,';')
      CALL SEROUT(CHOUT)
      RETURN
      ENDm�_I�      _e������������ _G �����������     �
