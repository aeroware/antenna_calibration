C     Program to plot antenna pattern from NEC output file
C
      PARAMETER (MXANG=1000)
      CHARACTER INFILE*60
      COMMON/NECPAT/NPT,RDANG(MXANG),ETHM(MXANG),EPHM(MXANG),FREQ,RIN,
     &XIN,EFFIC,ITHPH
      COMMON/PATDEV/IDEV,IDLASR
      IDEV=2
      IDLASR=4
1     CLOSE(UNIT=2,ERR=4)
4     WRITE(*,90)
90    FORMAT(' ENTER NAME OF NEC OUTPUT FILE >',$)
      READ(*,'(A)',ERR=2) INFILE
      IF(INFILE.EQ.' ')THEN
         CALL RLSDEV
         CALL POSTDMP
         CALL CLEARS
         STOP
      END IF
      OPEN (UNIT=2,FILE=INFILE,STATUS='OLD',ERR=2)
C      OPEN (UNIT=2,FILE=INFILE,STATUS='OLD',READONLY,ERR=2)
C      OPEN (UNIT=2,FILE=INFILE,STATUS='OLD',ACTION='READ',ERR=2)
      GO TO 3
2     CALL ERROR
      GO TO 1
3     CALL APATPLT
      GO TO 1
      END
      SUBROUTINE APATPLT
      CHARACTER*2 CMD
      COMMON/PATDEV/IDEV,IDLASR
      IZERO=1
      CALL NFLREAD(IEND,FNEXT)
      IF(IEND.NE.0)GO TO 2
      CALL PATPLT(IDEV,IZERO)
1     WRITE(*,93)
93    FORMAT(' >',$)
      READ(*,94)CMD,FNEXT
94    FORMAT(A,E12.5)
      CALL UPCASE(CMD,CMD,LENGTH)
      IF(CMD.EQ.'UP')THEN
         IZERO=1
         CALL PATPLT(IDEV,IZERO)
      ELSE IF(CMD.EQ.'UM')THEN
         IZERO=2
         CALL PATPLT(IDEV,IZERO)
      ELSE IF(CMD.EQ.'RP')THEN
         IZERO=3
         CALL PATPLT(IDEV,IZERO)
      ELSE IF(CMD.EQ.'RM')THEN
         IZERO=4
         CALL PATPLT(IDEV,IZERO)
      ELSE IF(CMD.EQ.'PT')THEN
         CALL PATPLT(IDEV,IZERO)
      ELSE IF(CMD.EQ.'PL')THEN
         CALL PATPLT(IDLASR,IZERO)
      ELSE IF(CMD.EQ.' ')THEN
         CALL NFLREAD(IEND,FNEXT)
         IF(IEND.NE.0)GO TO 2
         CALL PATPLT(IDEV,IZERO)
      ELSE IF(CMD.EQ.'NF')THEN
         GO TO 2
      ELSE IF(CMD.EQ.'EX')THEN
         CALL CLEARS
         CALL POSTDMP
         STOP
      END IF
      GO TO 1
2     RETURN
      END
      SUBROUTINE NFLREAD(IEND,FNEXT)
      PARAMETER (MXANG=1000)
      CHARACTER TEXT*120
      COMMON/NECPAT/NPT,RDANG(MXANG),ETHM(MXANG),EPHM(MXANG),FREQ,RIN,
     &XIN,EFFIC,ITHPH
      IEND=0
1     READ(2,90,END=703)TEXT
90    FORMAT(A)
      IF(TEXT(44:54).EQ.'- FREQUENCY')THEN
C
C        READ FREQUENCY
C
         READ(2,90)TEXT
         READ(2,91)FREQ
91       FORMAT(46X,E11.4)
      ELSE IF(TEXT(43:58).EQ.'- - - ANTENNA IN')THEN
C
C        READ INPUT IMPEDANCE
C
         DO 3 I=1,3
3        READ(2,90)TEXT
         READ(2,93)RIN,XIN
93       FORMAT(60X,2E12.5)
      ELSE IF(TEXT(44:53).EQ.'RADIATED P')THEN
C
C        READ ANTENNA EFFICIENCY
C
         NEFFIC=0
2        READ(2,96)TEXT,EFFIC
96       FORMAT(43X,A10,5X,F7.2)
         NEFFIC=NEFFIC+1
         IF(NEFFIC.GT.4)THEN
            EFFIC=0.
            GO TO 1
         END IF
         IF(TEXT(1:10).NE.'EFFICIENCY')GO TO 2
      ELSE IF(TEXT(53:65).EQ.'- RADIATION P')THEN
4        DO 5 I=1,4
5        READ(2,90)TEXT
C
C        READ PATTERN DATA
C
         CALL PATREAD
         IF(NPT.LT.2)GO TO 1
         RETURN
      END IF
      GO TO 1
703   IEND=1
      RETURN
      END
      SUBROUTINE PATREAD
C
C     PATREAD READS THE RADIATION PATTERN TABLE FROM A NEC OUTPUT FILE
C
      SAVE
      PARAMETER (MXANG=1000)
      CHARACTER TEXT*120
      COMMON/NECPAT/NPT,RDANG(MXANG),ETHM(MXANG),EPHM(MXANG),FREQ,RIN,
     &XIN,EFFIC,ITHPH
      ICNTD=0
      ITHPH=0
      NPT=0
6     READ(2,'(A)')TEXT
      IF(TEXT.EQ.' ')GO TO 7
      READ(TEXT,97,ERR=7)THETANG,PHIANG,VGAIN,HGAIN,ETHMAG,ETHPH,EPHMAG,
     &EPHPH
97    FORMAT(F8.2,F9.2,3X,2F8.2,39X,E12.5,F9.2,3X,E12.5,F9.2)
      NPT=NPT+1
C
C     SAVE THETA OR PHI ANGLE -- WHICHEVER IS CHANGING
C
      IF(NPT.EQ.1)THEN
         THSAV=THETANG
         PHISAV=PHIANG
      ELSE IF(NPT.EQ.2)THEN
         IF(ABS(PHIANG-PHISAV).GT.1.E-6)THEN
            ITHPH=1
            RDANG(1)=PHISAV
            ANSIGN=1.
            IF(PHIANG.LT.PHISAV)ANSIGN=-1.
         ELSE
            ITHPH=0
            RDANG(1)=THSAV
            ANSIGN=1.
            IF(THETANG.LT.THSAV)ANSIGN=-1.
         END IF
      END IF
      IF(NPT.GT.1)THEN
         IF(ITHPH.EQ.0)THEN
            RDANG(NPT)=THETANG
         ELSE
            RDANG(NPT)=PHIANG
         END IF
         IF((RDANG(NPT)-RDANG(NPT-1))*ANSIGN.LT.0.)THEN
            NPT=NPT-1
            ICNTD=1
            RETURN
         END IF
      END IF
      ETHM(NPT)=VGAIN
      EPHM(NPT)=HGAIN
      IF(NPT.LT.MXANG)GO TO 6
7     CONTINUE
      RETURN
      END
      SUBROUTINE PATPLT(IDEV,IZERO)
      CALL PPAXIS(IDEV)
      CALL PPPLOT(IZERO)
      CALL ENDPLT
      RETURN
      END
      SUBROUTINE PPPLOT(IZERO)
C
C     PLOT POLAR PATTERN
C
      PARAMETER (MXANG=1000)
      COMMON/NECPAT/NPT,RDANG(MXANG),ETHM(MXANG),EPHM(MXANG),FREQ,RIN,
     &XIN,EFFIC,ITHPH
      DATA TA/0.01745329252/,DBRANGE/40./
      CALL MINMAX(ETHM,NPT,RMIN,RMAX)
      CALL MINMAX(EPHM,NPT,HMIN,HMAX)
      IF(HMAX.GT.RMAX)RMAX=HMAX
      RSMAX=INT(RMAX/10.)*10.
      IF(RMAX.GT.0.)RSMAX=RSMAX+10.
      IF(RSMAX.LT.-60.)RSMAX=-60.
      RSMIN=RSMAX-DBRANGE
      CALL POLABL(RSMAX)
      CALL GSETLW(1.)
      DO 1 ITH=1,NPT
      ETHMX=(ETHM(ITH)-RSMAX)/DBRANGE+1.
      IF(ETHMX.LT.0.)ETHMX=0.
      IF(IZERO.EQ.1)THEN
         XETHM=-SIN(RDANG(ITH)*TA)*ETHMX
         YETHM=COS(RDANG(ITH)*TA)*ETHMX
      ELSE IF(IZERO.EQ.2)THEN
         XETHM=SIN(RDANG(ITH)*TA)*ETHMX
         YETHM=COS(RDANG(ITH)*TA)*ETHMX
      ELSE IF(IZERO.EQ.3)THEN
         YETHM=SIN(RDANG(ITH)*TA)*ETHMX
         XETHM=COS(RDANG(ITH)*TA)*ETHMX
      ELSE IF(IZERO.EQ.4)THEN
         YETHM=-SIN(RDANG(ITH)*TA)*ETHMX
         XETHM=COS(RDANG(ITH)*TA)*ETHMX
      END IF
      IF(ITH.EQ.1)THEN
         CALL GSMOVE(XETHM,YETHM)
      ELSE
         CALL GSDRAW(XETHM,YETHM)
      END IF
1     CONTINUE
      CALL GSLTYP(3)
      DO 2 ITH=1,NPT
      EPHMX=(EPHM(ITH)-RSMAX)/DBRANGE+1.
      IF(EPHMX.LT.0.)EPHMX=0.
      IF(IZERO.EQ.1)THEN
         XEPHM=-SIN(RDANG(ITH)*TA)*EPHMX
         YEPHM=COS(RDANG(ITH)*TA)*EPHMX
      ELSE IF(IZERO.EQ.2)THEN
         XEPHM=SIN(RDANG(ITH)*TA)*EPHMX
         YEPHM=COS(RDANG(ITH)*TA)*EPHMX
      ELSE IF(IZERO.EQ.3)THEN
         YEPHM=SIN(RDANG(ITH)*TA)*EPHMX
         XEPHM=COS(RDANG(ITH)*TA)*EPHMX
      ELSE IF(IZERO.EQ.4)THEN
         YEPHM=-SIN(RDANG(ITH)*TA)*EPHMX
         XEPHM=COS(RDANG(ITH)*TA)*EPHMX
      END IF
      IF(ITH.EQ.1)THEN
         CALL GSMOVE(XEPHM,YEPHM)
      ELSE
         CALL GSDRAW(XEPHM,YEPHM)
      END IF
2     CONTINUE
      CALL GSLTYP(1)
      CHRSZ=GOODCS(.04)
      IF(IZERO.EQ.1)THEN
         CALL GSMOVE(-.02,1.04)
         CALL GSSETC(CHRSZ,0.)
         CALL GSPSTR('<'//CHAR(0))
      ELSE IF(IZERO.EQ.2)THEN
         CALL GSMOVE(0.,1.04)
         CALL GSSETC(CHRSZ,0.)
         CALL GSPSTR('>'//CHAR(0))
      ELSE IF(IZERO.EQ.3)THEN
         CALL GSMOVE(1.07,0.)
         CALL GSSETC(CHRSZ,90.)
         CALL GSPSTR('>'//CHAR(0))
      ELSE IF(IZERO.EQ.4)THEN
         CALL GSMOVE(1.07,-.02)
         CALL GSSETC(CHRSZ,90.)
         CALL GSPSTR('<'//CHAR(0))
      END IF
      RETURN
      END
      SUBROUTINE POLABL(RSMAX)
      PARAMETER (MXANG=1000)
      BYTE LRCS(10),LABL(70)
      CHARACTER LRCSC*10,LABLC*70
      EQUIVALENCE (LRCS,LRCSC),(LABL,LABLC)
      COMMON/NECPAT/NPT,RDANG(MXANG),ETHM(MXANG),EPHM(MXANG),FREQ,RIN,
     &XIN,EFFIC,ITHPH
C      DATA LRCS/'G','A','I','N',' ','(','D','B',')',0/
      LRCSC='GAIN (DB)'//CHAR(0)
      RS1=RSMAX-10.
      RS2=RS1-10.
      RS3=RS2-10.
      RS4=RS3-10.
C
C     LABEL HORIZONTAL AXIS
C
      CALL GSETLW(.25)
C      CALL AXLABL(0.,1,RS4)
      CALL AXLABL(.2,1,RS3)
      CALL AXLABL(.45,1,RS2)
      CALL AXLABL(.7,1,RS1)
      CALL AXLABL(.95,1,RSMAX)
      CALL GSETLW(1.)
C
C     WRITE TITLE AND PARAMETERS
C
      CHRSZ=GOODCS(.04)
      CALL GSSETC(CHRSZ,0.)
      CALL GSMOVE(-.2,1.12)
      CALL GSPSTR(LRCS)
      IF(ITHPH.EQ.0)THEN
         WRITE(LABLC,90)FREQ
90       FORMAT('Frequency =',F7.2,' MHz',25X,'THETA')
      ELSE
         WRITE(LABLC,92)FREQ
92       FORMAT('Frequency =',F7.2,' MHz',25X,'  PHI')
      END IF
      LABL(53)=0
      CALL GSMOVE(-1.7,-1.1)
      CALL GSPSTR(LABL)
      WRITE(LABLC,91)RIN,XIN,EFFIC
91    FORMAT('Impedance =',1P2E10.3,' Ohms,   Efficiency =',0PF5.1,
     &' Percent')
      LABL(66)=0
      CALL GSMOVE(-1.7,-1.2)
      CALL GSPSTR(LABL)
      RETURN
      END
      SUBROUTINE AXLABL(DIST,IAX,VAL)
      BYTE LABL(5)
      CHARACTER LABLC*5
      EQUIVALENCE (LABL,LABLC)
      CHRSZ=GOODCS(.03)
      IF(VAL.GE.0.)IVAL=VAL+.5
      IF(VAL.LT.0.)IVAL=VAL-.5
      WRITE(LABLC,90)IVAL
90    FORMAT(I3)
      LABL(4)=0
      IF(IAX.EQ.1)THEN
      CALL GSSETC(CHRSZ,0.)
      CALL GSMOVE(DIST-2.*CHRSZ,-2.*CHRSZ)
      CALL GSPSTR(LABL)
      ELSE
      CALL GSSETC(CHRSZ,90.)
      CALL GSMOVE(-CHRSZ,DIST-2.*CHRSZ)
      CALL GSPSTR(LABL)
      END IF
      RETURN
      END
      SUBROUTINE PPAXIS(IDEV)
C
C     PPAXIS DRAWS A POLAR CHART
C
      TP=8.*ATAN(1.)
      DANG=TP/72.
      IF(IDEV.NE.0)CALL DEVSEL(IDEV,4,IERR)
      CALL BGNPLT
      CALL GSETLW(.25)
      XLEN=GSXLCM()
      YLEN=GSYLCM()
      SLEN=AMIN1(XLEN,YLEN)
      SCALE=.35*SLEN
      CALL GSETDP(0.,SCALE,SCALE,.6*SLEN,.5*SLEN)
C
C     DRAW HORIZONTAL AND VERTICAL AXES
C
      CALL LINE(-1.,0.,1.,0.)
      CALL LINE(.86603,.5,-.86603,-.5)
      CALL LINE(-.5,-.86603,.5,.86603)
      CALL LINE(0.,1.,0.,-1.)
      CALL LINE(.86603,-.5,-.86603,.5)
      CALL LINE(-.5,.86603,.5,-.86603)
C
C     DRAW CIRCLES
C
      CALL CIRCLZ(1.)
      CALL CIRCLZ(.75)
      CALL CIRCLZ(.5)
      CALL CIRCLZ(.25)
      CALL GSETLW(1.)
      RETURN
      END
      SUBROUTINE LINE(X1,Y1,X2,Y2)
      CALL GSMOVE(X1,Y1)
      CALL GSDRAW(X2,Y2)
      RETURN
      END
      SUBROUTINE PLTLAB(X,Y,LAB)
      BYTE LAB(10)
      CALL GSMOVE(X,Y)
      CALL GSPSTR(LAB)
      RETURN
      END
      SUBROUTINE CIRCLZ(R)
C
C     CIRCLZ DRAWS A CIRCLE WITH CENTER AT ORIGIN AND RADIUS R.
C
C      COMMON/SMTCOM/TP,DANG
      DATA TP,DANG/6.28318531,.0628318531/
      NA=TP/DANG+1.
      DA=TP/NA
      SDA=SIN(DA)
      CDA=COS(DA)
      X=R
      Y=0.
      CALL GSMOVE(X,Y)
      DO 1 IA=1,NA
      XSAV=X
      X=XSAV*CDA-Y*SDA
      Y=XSAV*SDA+Y*CDA
1     CALL GSDRAW(X,Y)
      RETURN
      END
      SUBROUTINE CLEARS
C
C     CLEARS CLEARS THE SCREEN OF A DEC VT100 TERMINAL
C
C      BYTE GS,FF,ESC,GG,Q,Z
C      CHARACTER*1 CGS,CFF,CESC,CQ,CZ,CGG
C      EQUIVALENCE (CGS,GS),(CFF,FF),(CESC,ESC),(CQ,Q),(CZ,Z),(CGG,GG)
C      DATA GS/29/,FF/12/,ESC/27/,Q/34/,Z/48/,GG/103/
Cc      CLOSE(6)
C      WRITE(*,90) CGS,CESC,CFF,CESC,CQ,CZ,CGG
Cc90    FORMAT('+',A1,$)
C90    FORMAT(7A1,$)
Cc      CLOSE(6)
C
C     MACINTOSH:
C      CALL GDMACSE(2,XA,YA)
      RETURN
      END
      SUBROUTINE ERROR
C      IMPLICIT INTEGER (A-Z)
C      CHARACTER MSG*80
C      CALL ERRSNS(FNUM,RMSSTS,RMSSTV,IUNIT,CONDVAL)
C      CALL SYS$GETMSG(%VAL(RMSSTS),MSGLEN,MSG,,,)
C      CALL STR$UPCASE(MSG,MSG)
C      IND=INDEX(MSG,',')
C      TYPE 1,MSG(IND+2:MSGLEN)
C1     FORMAT(//,'  ****  ERROR  ****   ',//,5X,A,//)
      WRITE(*,*)' INPUT ERROR'
      RETURN
      END
      SUBROUTINE READCM(INUNIT,CODE,F1,F2,F3,F4,F5,F6,IERROR)
C
C     Purpose:
C     READCM calls PARSIT to read an input command
C
      CHARACTER*(*) CODE
      DIMENSION INTVAL(1),REAVAL(6)
C
C  Call the routine to read the record and parse it.
C
      CALL PARSIT(INUNIT,0,6,CODE,INTVAL,REAVAL,IERROR)
C
C  Set the return variables to the buffer array elements.
C
      F1=REAVAL(1)
      F2=REAVAL(2)
      F3=REAVAL(3)
      F4=REAVAL(4)
      F5=REAVAL(5)
      F6=REAVAL(6)
      RETURN
      END
      SUBROUTINE PARSIT(INUNIT,MAXINT,MAXREA,CMND,INTFLD,REAFLD,IERROR)
C
C     PARSIT reads an input record and parses it.
C
C     OUTPUT:
C     MAXINT     total number of integers in record
C     MAXREA     total number of real values in record
C     CMND       two letter mnemonic code
C     INTFLD     integer values from record
C     REAFLD     real values from record

C  *****  Internal Variables
C     BGNFLD     list of starting indices
C     BUFFER     text buffer
C     ENDFLD     list of ending indices
C     FLDTRM     flag to indicate that pointer is in field position
C     REC        input line as read
C     TOTCOL     total number of columns in REC
C     TOTFLD     number of numeric fields
      CHARACTER  CMND*2, BUFFER*20, REC*80
      INTEGER    INTFLD(*)
      INTEGER    BGNFLD(12), ENDFLD(12), TOTCOL, TOTFLD
      REAL       REAFLD(*)
      LOGICAL    FLDTRM
C
      READ(INUNIT, 8000, IOSTAT=IERROR) REC
      IF(IERROR.LT.0)RETURN
      CALL UPCASE( REC, REC, TOTCOL )
C
C  Store opcode and clear field arrays.
C
      CMND= REC(1:2)
      DO 3000 I=1,MAXINT
           INTFLD(I)= 0
 3000 CONTINUE
      DO 3010 I=1,MAXREA
           REAFLD(I)= 0.0
 3010 CONTINUE
      DO 3020 I=1,12
           BGNFLD(I)= 0
           ENDFLD(I)= 0
 3020 CONTINUE
C
C  Find the beginning and ending of each field as well as the total number of
C  fields.
C
      TOTFLD= 0
      FLDTRM= .FALSE.
      LAST= MAXREA + MAXINT
      DO 4000 J=3,TOTCOL
           K= ICHAR( REC(J:J) )
C
C  Check for end of line comment (`!').  This is a new modification to allow
C  VAX-like comments at the end of data records, i.e.
C       GW 1 7 0 0 0 0 0 .5 .0001 ! DIPOLE WIRE
C       GE ! END OF GEOMETRY
C
      IF (K .EQ. 33) THEN
         IF (FLDTRM) ENDFLD(TOTFLD)= J - 1
         GO TO 5000
C
C  Set the ending index when the character is a comma or space and the pointer
C  is in a field position (FLDTRM = .TRUE.).
C
          ELSE IF (K .EQ. 32  .OR.  K .EQ. 44) THEN
             IF (FLDTRM) THEN
                ENDFLD(TOTFLD)= J - 1
                FLDTRM= .FALSE.
             ENDIF
C
C  Set the beginning index when the character is not a comma or space and the
C  pointer is not currently in a field position (FLDTRM = .FALSE).
C
          ELSE IF (.NOT. FLDTRM) THEN
              TOTFLD= TOTFLD + 1
              FLDTRM= .TRUE.
              BGNFLD(TOTFLD)= J
          ENDIF
 4000   CONTINUE
        IF (FLDTRM) ENDFLD(TOTFLD)= TOLCOL

C  Check to see if the total number of value fields is within the precribed
C  limits.

 5000   IF (TOTFLD .EQ. 0) THEN
             RETURN
        ELSE IF (TOTFLD .GT. LAST) THEN
             WRITE( *, 8001 )
             GOTO 9010
        ENDIF
        J= MIN( TOTFLD, MAXINT )

C  Parse out integer values and store into integer buffer array.

        DO 5090 I=1,J
             LENGTH= ENDFLD(I) - BGNFLD(I) + 1
             BUFFER= REC(BGNFLD(I):ENDFLD(I))
             IND= INDEX( BUFFER(1:LENGTH), '.' )
             IF (IND .GT. 0  .AND.  IND .LT. LENGTH) GO TO 9000
             IF (IND .EQ. LENGTH) LENGTH= LENGTH - 1
             READ( BUFFER(1:LENGTH), *, ERR=9000 ) INTFLD(I)
 5090   CONTINUE

C  Parse out real values and store into real buffer array.

        IF (TOTFLD .GT. MAXINT) THEN
             J= MAXINT + 1
             DO 6000 I=J,TOTFLD
                  LENGTH= ENDFLD(I) - BGNFLD(I) + 1
                  BUFFER= REC(BGNFLD(I):ENDFLD(I))
                  IND= INDEX( BUFFER(1:LENGTH), '.' )
                  IF (IND .EQ. 0) THEN
                       INDE= INDEX( BUFFER(1:LENGTH), 'E' )
                       LENGTH= LENGTH + 1
                       IF (INDE .EQ. 0) THEN
                            BUFFER(LENGTH:LENGTH)= '.'
                       ELSE
                            BUFFER= BUFFER(1:INDE-1)//'.'//
     &                               BUFFER(INDE:LENGTH-1)
                       ENDIF
                  ENDIF
                  READ( BUFFER(1:LENGTH), *, ERR=9000 ) REAFLD(I-MAXINT)
 6000        CONTINUE
        ENDIF
        RETURN

C  Print out text of record line when error occurs.

 9000   IF (I .LE. MAXINT) THEN
             WRITE( *, 8002 ) I
        ELSE
             I= I - MAXINT
             WRITE( *, 8003 ) I
        ENDIF
 9010   WRITE( *, 8004 ) REC
        IERROR=1
        RETURN
C
C  Input formats and output messages.
C
 8000   FORMAT (A80)
 8001   FORMAT (//,' ***** CARD ERROR - TOO MANY FIELDS IN RECORD')
 8002   FORMAT (//,' ***** CARD ERROR - INVALID NUMBER AT INTEGER',
     &          ' POSITION ',I1)
 8003   FORMAT (//,' ***** CARD ERROR - INVALID NUMBER AT REAL',
     &          ' POSITION ',I1)
 8004   FORMAT (' ***** TEXT -->  ',A80)
        END
        SUBROUTINE UPCASE( INTEXT, OUTTXT, LENGTH )
C
C  UPCASE finds the length of INTEXT and converts it to upper case.
C
        CHARACTER *(*) INTEXT, OUTTXT
C
C
        LENGTH = LEN( INTEXT )
        DO 3000 I=1,LENGTH
             J  = ICHAR( INTEXT(I:I) )
             IF (J .GE. 96) J = J - 32
             OUTTXT(I:I) = CHAR( J )
 3000   CONTINUE
        RETURN
        END
      SUBROUTINE GDPST(IFXN,XA,YA)
      DIMENSION XA(8), YA(3)
C
C     POST SCRIPT DRIVER - HARD COPY DEVICE HAS 300 DOTS/INCH
      PARAMETER (DPI = 300.0)
C   *******  MODIFIED FOR DELAYED RELEASE TO PRINTER ************
C   *******  MUST CALL POSTDMP TO SEND PLOTS TO PRINTER ********
C
C-----------------------------------------------------------------------
C
C     DECLARE VARS NEED FOR DRIVER OPERATION
C
      LOGICAL LNOPLT, LWIDE
      CHARACTER*16 COORD
      CHARACTER*8 CTIME
      CHARACTER*80 FNAME
      CHARACTER*120 COMAND
C
      DIMENSION DCHAR(8)
      COMMON/POSTDCM/LUNPOS,INITPOST,LNOPLT,FNAME
C
C     MAKE NICE NAMES FOR THE DEVICES RESOLUTION IN X AND Y
C      ("XGUPCM" IS X GRAPHICS UNITS PER CENTIMETER)
C
      EQUIVALENCE (DCHAR(4),XGUPCM), (DCHAR(5),YGUPCM)
C
C     PAPER DEFINITIONS (INCHES)
C
c     PARAMETER (PSRES = 72.0)
      REAL*4 LMARGN
      PARAMETER (LMARGN = 0.5)
      PARAMETER (RMARGN = 0.25)
      PARAMETER (TMARGN = 0.5)
      PARAMETER (BMARGN = 0.25)
      PARAMETER (PAPERH = 11.0)
      PARAMETER (PAPERW = 8.5)
C           DERIVED PARAMETERS
      PARAMETER (UWD = PAPERW-LMARGN-RMARGN)
      PARAMETER (UHT = PAPERH-TMARGN-BMARGN)
      PARAMETER (WDCM = 2.54*UWD)
      PARAMETER (HTCM = 2.54*UHT)
      PARAMETER (RESOLUTION = DPI/2.54)
c     PARAMETER (PSRESCM = PSRES/2.54)
      PARAMETER (XOFF = DPI*LMARGN)
      PARAMETER (YOFF = DPI*BMARGN)
C
      PARAMETER (MAXPTS = 900)
C
C     UNIX routine for getting process id (so we can have a unique
C        file name for the scratch file).
      integer*4 getpid, fputc
      external getpid, fputc
C
      CHARACTER*1 EOF
C
C     DIGLIB DEVICE CHARACTERISTICS WORDS
C
      DATA DCHAR /910.0, WDCM, HTCM, RESOLUTION,
     &   RESOLUTION, 1.0, 27.0, 2.0/
C
      LWIDE = .FALSE.
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
C     CALL IDATE(IM,ID,IY)
C      CALL TIME(CTIME)
C     IF (ID .GT. 26) ID = ID-26 + (48-64)
      write(fname,101) mod(getpid(),100000)
101   format('/tmp/diglib_',i5.5,'.ps')
      FNAME(21:21)=char(0)
      IF(INITPOST.EQ.0)THEN
            INITPOST=1
            LUN = XA(1)
            LUNPOS=LUN
            OPEN(UNIT=LUN,FILE=FNAME,STATUS='NEW',ERR=9000)
C     FNAME = 'SYS$SCRATCH:POSTSCRIPT.DIG'//CHAR(IM+64)//CHAR(ID+64)
C    &   //CTIME(1:2)//CTIME(4:5)//CTIME(7:8)
C     OPEN (UNIT=LUN,NAME=FNAME,TYPE='NEW',
C    &   FORM='UNFORMATTED',CARRIAGECONTROL='NONE',RECORDTYPE='VARIABLE',
C    &   INITIALSIZE = 50, EXTENDSIZE = 50,
C    &   ERR=9000)
C
C        SHOW INITIALIZATION WORKED, I.E. WE OPENED THE FILE.
C
         EOF = char(4)
         YA(1) = 0.0
         CALL GDPSOP(LUN)
C         CALL GDPSIN(EOF)
         CALL GDPSIN('%! DIGLIB PLOT'//char(0))
         CALL GDPSDU
         CALL GDPSIN('/m {moveto} def /l {lineto} def '//char(0))
         call gdpsse(DPI)
         CALL GDPSDU
         LNOPLT = .TRUE.
         NPTS = 0
      END IF
      RETURN
C
C     **************************
C     GET FRESH PLOTTING SURFACE
C     **************************
C
200   CONTINUE
      IF (.NOT. LNOPLT) THEN
C           CALL GDPSDU
            CALL GDPSIN('stroke showpage '//char(0))
      ENDIF
      CALL GDPSDU
        call gdpsse(DPI)
      CALL GDPSIN('newpath '//char(0))
      LNOPLT = .TRUE.
      NPTS = 0
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
      NPTS = NPTS + 1
      IF (NPTS .GT. MAXPTS) THEN
            CALL GDPSDU
            CALL GDPSIN('stroke newpath '//char(0))
            IF (IFXN .EQ. 4) THEN
                  CALL GDPSIN(COORD)
                  CALL GDPSIN('m '//char(0))
            ENDIF
            NPTS = 1
      ENDIF
      IF (LWIDE) THEN
            ix = RESOLUTION*YA(1)+XOFF
            iy = RESOLUTION*(HTCM-XA(1))+YOFF
          ELSE
            ix = RESOLUTION*XA(1)+XOFF
            iy = RESOLUTION*YA(1)+YOFF
      ENDIF
      WRITE(COORD,451) ix,iy
 451    FORMAT(i4,1X,i4,1X)
      COORD(11:11) = char(0)
      CALL GDPSIN(COORD)
      IF (IFXN .EQ. 3) THEN
            CALL GDPSIN('m '//char(0))
          ELSE
            CALL GDPSIN('l '//char(0))
      ENDIF
      LNOPLT = .FALSE.
      RETURN
C
C     *****************************
C     FLUSH GRAPHICS COMMAND BUFFER
C     *****************************
C
C           !DONE BY BGNPLT WHEN NECESSARY.
500   CONTINUE
      RETURN
C
C     ******************
C     RELEASE THE DEVICE  ** MODIFIED FOR SEPARATE CALL TO RELEASE
C     ******************
C
600   CONTINUE
C      IF (.NOT. LNOPLT) THEN
C            CALL GDPSDU
C            CALL GDPSIN('stroke showpage '//char(0))
C            CALL GDPSDU
C            CALL GDPSIN(EOF)
C            CALL GDPSDU
C      ENDIF
C      CLOSE (UNIT=LUN)
C      COMAND = 'lpr -r '//FNAME
C      ISTATUS = system(COMAND)
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
      IF (LWIDE) THEN
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
      ENTRY GDPSW(IFXN,XA,YA)
      LWIDE = .TRUE.
      GO TO 10
      END


        subroutine gdpsse(dpi)
        character*16 dpistr
      call gdpsin('initgraphics 1 setlinecap 1 setlinejoin '//char(0))
      call gdpsdu
        call gdpsin('72 '//char(0))
      write(dpistr,181) dpi
 181    format(g14.7)
        dpistr(15:15) = char(0)
        call gdpsin(dpistr)
        call gdpsin(' div dup scale 3 setlinewidth'//char(0))
      call gdpsdu
        return
        end


      SUBROUTINE GDPSOP(LUN)
C
      PARAMETER (IBUFSZ = 80)
      LOGICAL LNOPLT
      CHARACTER BUFFER*1,FNAME*80
      COMMON /GDLSR/ NXTCHR, LUNOUT, BUFFER(IBUFSZ)
      COMMON/POSTDCM/LUNPOS,INITPOST,LNOPLT,FNAME
C
      LUNOUT = LUN
      NXTCHR = 1
      RETURN
      END


      SUBROUTINE GDPSIT
C
      PARAMETER (IBUFSZ = 80)
      CHARACTER*1 BUFFER
      COMMON /GDLSR/ NXTCHR, LUNOUT, BUFFER(IBUFSZ)
C
      NXTCHR = 1
      RETURN
      END


      SUBROUTINE GDPSIN(STRING)
      CHARACTER*1 STRING(*)
C
      PARAMETER (IBUFSZ = 80)
      CHARACTER*1 BUFFER
      COMMON /GDLSR/ NXTCHR, LUNOUT, BUFFER(IBUFSZ)
C
      EXTERNAL LEN
C
      L = LEN(STRING)
      IF ((NXTCHR+L) .GT. IBUFSZ) CALL GDPSDU
            DO 100 I = 1, L
            BUFFER(NXTCHR) = STRING(I)
            NXTCHR = NXTCHR + 1
100         CONTINUE
      RETURN
      END

      SUBROUTINE GDPSDU
C
      PARAMETER (IBUFSZ = 80)
      CHARACTER*1 BUFFER
      COMMON /GDLSR/ NXTCHR, LUNOUT, BUFFER(IBUFSZ)
C
      IF (NXTCHR .EQ. 1) RETURN
      WRITE (LUNOUT,111) (BUFFER(I), I=1,NXTCHR-1)
 111    format(80a1)
      NXTCHR = 1
      RETURN
      END
      SUBROUTINE POSTDMP
      CHARACTER COMAND*120,FNAME*80,EOF*1
      LOGICAL LNOPLT
      COMMON/POSTDCM/LUNPOS,INITPOST,LNOPLT,FNAME
      EOF=CHAR(4)
      IF(INITPOST.EQ.0)RETURN
      IF (.NOT. LNOPLT) THEN
         CALL GDPSDU
         CALL GDPSIN('stroke showpage '//CHAR(0))
         CALL GDPSDU
c         CALL GDPSIN(EOF) 
         CALL GDPSDU
      ENDIF
      CLOSE (UNIT=LUNPOS)
c      COMAND = 'lpr -r '//FNAME
      COMAND = 'lpr '//FNAME
      ISTATUS = system(COMAND)
      INITPOST=0
      RETURN
      END
      SUBROUTINE GSETLW(XLW)
C
C     GSETLW sets the line width for PostScript plots
C
      COMMON /GCDSEL/ IDEV
      CHARACTER CLW*27
      IF(IDEV.EQ.3.OR.IDEV.EQ.4)THEN
         WRITE(CLW,90)XLW
90       FORMAT(' stroke',F5.2,' setlinewidth ')
         CLW(27:27)=CHAR(0)
         CALL GDPSIN(CLW)
      END IF
      RETURN
      END
