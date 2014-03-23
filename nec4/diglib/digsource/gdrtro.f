      SUBROUTINE GDRTRO(IFXN,XA,YA)
      DIMENSION XA(8), YA(3)
C
C     VT100 WITH 640x480 RETROGRAPHICS DRIVER FOR DIGLIB/VAX
C       *** Modified for UNIX by Steve Azevedo  11 Apr 1984
C
C-----------------------------------------------------------------------
C
      EXTERNAL LEN
c
c*** The following lines are illegal in UNIX.  In fact, DATA loading a
c***   character array is quite a pain.  So, all loading of character
c***   strings is done at run-time into one array called strout.
c     BYTE ESC, CSUB, TMODE, GS, CR, FF
c     PARAMETER (ESC=27, CSUB=26, TMODE=24, GS=29, CR=13, FF=12)
c     CHARACTER*(*) TERMINAL
c     PARAMETER (TERMINAL='TT')
C
C     DEFINITIONS FOR DEVICE CONTROL
C
c     BYTE STR_BEGIN_PLOT(14), STR_COLOR_SET(6)
c     BYTE STR_END_PLOT(8)
c     DATA STR_BEGIN_PLOT /ESC,'[','H',ESC,'[','J',GS,ESC,FF,
c    1   ESC,'/','0','d',NULL/
c     DATA STRCOL /GS,ESC,'/','0','d',NULL/
c     DATA STREND /ESC,'[','H',ESC,'[','J',NULL,NULL/
      character*1 strout(14)
C
C     DEFINITIONS FOR GIN
C
      character*1 GINBUF(8)
c     BYTE PROMPT(4)
c     DATA PROMPT /GS, ESC, CSUB, 0/
C
C     DECLARE BUFFERING FUNCTION
C
      LOGICAL GBTEST
C
C     DECLARE VARS NEED FOR DRIVER OPERATION
C
      LOGICAL LVECGO, LDUMMY
      DIMENSION DCHAR(8)
C
C     MAKE NICE NAMES FOR THE DEVICES RESOLUTION IN X AND Y
C      ("XGUPCM" IS X GRAPHICS UNITS PER CENTIMETER)
C
      EQUIVALENCE (DCHAR(4),XGUPCM), (DCHAR(5),YGUPCM)
      DATA DCHAR /100.0,21.001,15.747,30.419,30.419,1.0,133.0,1.0/
C
Comment--- NOTE: This DATA Statement must go after ALL declarations!
Comment--- 5 characters FROM 4010 GIN, PLUS <CR>
      DATA IGININ /6/
C
C*****************
C
C     FIRST VERIFY WE GOT A GRAPHICS FUNCTION WE CAN HANDLE
C
      IF (IFXN .LE. 0 .OR. IFXN .GT. 9) RETURN
C
C     NOW DISPATCH TO THE PROPER CODE TO HANDLE THAT FUNCTION
C
      GO TO (100,200,300,400,500,600,700,800,900) IFXN
C
C     *********************
C     INITIALIZE THE DEVICE
C     *********************
C
100   CONTINUE
C
C     FIRST, INITIALIZE THE BUFFER SUBROUTINES
C
c     CALL GB_INITIALIZE(TMODE,0,TERMINAL,IERR)
      CALL GBINIT(char(24),char(0),'TT'//char(0),IERR)
      YA(1) = IERR
      LVECGO = .FALSE.
      RETURN
C
C     **************************
C     GET FRESH PLOTTING SURFACE
C     **************************
C
200   CONTINUE
      CALL GBEMPT
      strout(1)=char(27)
      strout(2)='['
      strout(3)='H'
      strout(4)=char(27)
      strout(5)='['
      strout(6)='J'
      strout(7)=char(29)
      strout(8)=char(27)
      strout(9)=char(12)
      strout(10)=char(27)
      strout(11)='/'
      strout(12)='0'
      strout(13)='d'
      strout(14)=char(0)
      CALL GBINST(strout)
      CALL GBUSET
      LVECGO = .FALSE.
      RETURN
C
C     ****
C     MOVE
C     ****
C
300   CONTINUE
C     CONVERT CM. TO GRAPHICS UNITS ROUNDED
      IXPOSN = XGUPCM*XA(1)+0.5
      IYPOSN = YGUPCM*YA(1)+0.5
      LVECGO = .FALSE.
      RETURN
C
C     ****
C     DRAW
C     ****
C
400   CONTINUE
      IX = XGUPCM*XA(1)+0.5
      IY = YGUPCM*YA(1)+0.5
      LVECGO = LVECGO .AND. (.NOT. GBTEST(4))
      IF (LVECGO) GO TO 410
      LDUMMY = GBTEST(9)
      LVECGO = .TRUE.
      CALL GBINSE(char(29))
      CALL GBUSET
      CALL GD4CON((8*IXPOSN/5),(13*IYPOSN)/8)
410   CALL GD4CON((8*IX/5),(13*IY)/8)
      IXPOSN = IX
      IYPOSN = IY
      RETURN
C
C     *****************************
C     FLUSH GRAPHICS COMMAND BUFFER
C     *****************************
C
500   CONTINUE
      CALL GBEMPT
      strout(1)=char(27)
      strout(2)='['
      strout(3)='H'
      strout(4)=char(27)
      strout(5)='['
      strout(6)='J'
      strout(7)=char(0)
      CALL GBINST(strout)
      CALL GBEMPT
      LVECGO = .FALSE.
      RETURN
C
C     ******************
C     RELEASE THE DEVICE
C     ******************
C
600   CONTINUE
C
C     DE-ASSIGN THE CHANNAL
C
      CALL GBFINI(0)
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
      LDUMMY = GBTEST(8)
      ICOLOR = XA(1)
      IF (ICOLOR .LT. 0 .OR. ICOLOR .GT. 1) RETURN
Comment---- CONVERT 1 TO 0 AND 0 INTO 1
      ICOLOR = 1-ICOLOR
Comment---- MAKE ASCII CHARACTER 0 OR 1
      strout(1)=char(29)
      strout(2)=char(27)
      strout(3)='/'
      strout(4)=char(48+ICOLOR)
      strout(5)='d'
      strout(6)=char(0)
      CALL GBINST(strout)
      CALL GBUSET
      LVECGO = .FALSE.
      RETURN
C
C     **********************
C     PERFORM GRAPHICS INPUT
C     **********************
C
900   CONTINUE
      CALL GBEMPT
      LVECGO = .FALSE.
C
C     IT IS COMPLETELY UNCLEAR WHY THIS DELAY IS REQUIRED IN SOME CASES
C     BY THE RETRO-GRAPHICS, BUT IT SEEMS TO BE.
C
c     CALL GDWAIT(400)
C
      strout(1)=char(29)
      strout(2)=char(27)
      strout(3)=char(26)
      strout(4)=char(0)
      CALL GBGIN(strout,IGININ,.TRUE.,GINBUF)
C
      ICH = ichar(GINBUF(1))
      IX1 = ichar(GINBUF(2))
      IX2 = ichar(GINBUF(3))
      IY1 = ichar(GINBUF(4))
      IY2 = ichar(GINBUF(5))
C
      XA(1) = AND(ICH,127)
      XA(2) = (5.0*(32*AND(IX1,31)+AND(IX2,31))/8.0)/XGUPCM
      XA(3) = (8.0*(32*AND(IY1,31)+AND(IY2,31))/13.0)/YGUPCM
C
      CALL GBSEND(char(24),1)
      RETURN
      END
