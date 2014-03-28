      USE MSFLIB
      USE DFLIB
C     Program to plot antenna pattern from NEC output file
C
      PARAMETER (MXANG=1000)
      CHARACTER INFILE*80
      CHARACTER DRIVE*10,DIR*80,FNAME*30,EXT*30
      LOGICAL LDIR
      COMMON/NECPAT/RDANG(MXANG),ETHM(MXANG),EPHM(MXANG),RDANGS(MXANG),
     &ETHMS(MXANG),EPHMS(MXANG),FREQ,RIN,XIN,EFFIC,FXANG,ITHPH,IANT,NPT,
     &NPTS
      COMMON/PATDEV/IDEVT,IDEVH
      IDEVT=1
      IDEVH=4
      NPTS=0
      CALL SET3D
1     CLOSE(UNIT=2,ERR=4)
4     CONTINUE
C      WRITE(*,'('' Enter name of nec output file >'',$)')
C      READ(*,'(A)',ERR=2) INFILE
CC      OPEN (UNIT=2,FILE=INFILE,STATUS='OLD',ERR=2)
C      OPEN (UNIT=2,FILE=INFILE,STATUS='OLD',READONLY,ERR=2)
CC      OPEN (UNIT=2,FILE=INFILE,STATUS='OLD',ACTION='READ',ERR=2)
C*** Windows 95
      CALL SETMESSAGEQQ("Open NEC output file , *.*",
     & QWIN$MSG_FILEOPENDLG)
      OPEN (UNIT=2,FILE=" ",STATUS='OLD',ACTION='READ',ERR=2)
      INQUIRE(UNIT=2,NAME=INFILE)
      LENDIR=SPLITPATHQQ(INFILE,DRIVE,DIR,FNAME,EXT)
      LDIR=CHANGEDIRQQ(DIR)
      GO TO 3
2     CALL ERROR
      GO TO 1
3     CALL APATPLT
      GO TO 1
      END
      SUBROUTINE APATPLT
      CHARACTER*2 CMD
      COMMON/PATDEV/IDEVT,IDEVH
      IPCP=1
      IRCAL=0
      IZERO=2
      ICONT=0
      IRDALL=0
3     CALL NFLREAD(IEND,ICONT,IRDALL)
      IF(IEND.NE.0)GO TO 2
      CALL PATPLP(IDEVT,IRCAL,IZERO,IPCP)
1     IF(ICONT.NE.0)WRITE(*,'('' Reading 3D pattern'')')
      WRITE(*,'('' 2D >'',$)')
      READ(*,'(A)')CMD
      CALL UPCASE(CMD,CMD,LENGTH)
      IF(CMD.EQ.'UP')THEN
         IZERO=1
      ELSE IF(CMD.EQ.'UM')THEN
         IZERO=2
      ELSE IF(CMD.EQ.'RP')THEN
         IZERO=3
      ELSE IF(CMD.EQ.'RM')THEN
         IZERO=4
      ELSE IF(CMD.EQ.'ST')THEN
         CALL PATSTR
         IRCAL=0
         GO TO 1
      ELSE IF(CMD.EQ.'RC')THEN
         IRCAL=1
      ELSE IF(CMD.EQ.'RX')THEN
         IRCAL=0
      ELSE IF(CMD.EQ.'CP')THEN
         IPCP=0
      ELSE IF(CMD.EQ.'PP')THEN
         IPCP=1
      ELSE IF(CMD.EQ.'PT')THEN
         CALL PATPLP(IDEVT,IRCAL,IZERO,IPCP)
         GO TO 1
      ELSE IF(CMD.EQ.'PL')THEN
         CALL PATPLP(IDEVH,IRCAL,IZERO,IPCP)
         GO TO 1
      ELSE IF(CMD.EQ.'PH')THEN
         CALL PATPLP(2,IRCAL,IZERO,IPCP)
         GO TO 1
      ELSE IF(CMD.EQ.'PS')THEN
         CALL PATPLP(4,IRCAL,IZERO,IPCP)
         GO TO 1
      ELSE IF(CMD.EQ.'RB')THEN
         CALL GSBKRV
      ELSE IF(CMD.EQ.' ')THEN
         CALL NFLREAD(IEND,ICONT,IRDALL)
         IF(IEND.NE.0)GO TO 2
      ELSE IF(CMD.EQ.'RF')THEN
         ICONT=0
         CALL NFLREAD(IEND,ICONT,IRDALL)
         IF(IEND.NE.0)GO TO 2
      ELSE IF(CMD.EQ.'RW')THEN
         REWIND(2)
         ICONT=0
         CALL NFLREAD(IEND,ICONT,IRDALL)
         IF(IEND.NE.0)GO TO 2
      ELSE IF(CMD.EQ.'RD')THEN
         IRDALL=1
         CALL NFLREAD(IEND,ICONT,IRDALL)
         IF(IEND.NE.0)GO TO 2
      ELSE IF(CMD.EQ.'NF')THEN
         GO TO 2
      ELSE IF(CMD.EQ.'EX')THEN
         CALL CLEARS
         CALL POSTDMP
         STOP
      END IF
      IF(IRDALL.EQ.0)CALL PATPLP(IDEVT,IRCAL,IZERO,IPCP)
      CALL PAT3DC(IP3D)
      IF(IRDALL.EQ.1.AND.IP3D.EQ.0)CALL PATPLP(IDEVT,IRCAL,IZERO,IPCP)
      IRDALL=0
      IF(IP3D.EQ.1)GO TO 3
      GO TO 1
2     RETURN
      END
      SUBROUTINE PAT3DC(IP3D)
      USE MSFLIB
      PARAMETER (MXANG=1000,IDIM=182,JDIM=362)
      CHARACTER AIN1*1,AIN*2
      COMMON/GPAT/ GV(IDIM,JDIM),GH(IDIM,JDIM),GT(IDIM,JDIM),
     &ETPH(IDIM,JDIM),EPPH(IDIM,JDIM),AXRAT(IDIM,JDIM),THETA(IDIM),
     &PHIA(JDIM),GVMAX,GHMAX,GTMAX,IGVTMX,IGVPMX,IGHTMX,IGHPMX,IGTTMX,
     &IGTPMX,NATH,NAPH
      COMMON/NECPAT/RDANG(MXANG),ETHM(MXANG),EPHM(MXANG),RDANGS(MXANG),
     &ETHMS(MXANG),EPHMS(MXANG),FREQ,RIN,XIN,EFFIC,FXANG,ITHPH,IANT,NPT,
     &NPTS
      COMMON/SET3DC/THETAD,PHID,GRANGE,IGVHT,IPHAZ
      COMMON/PATDEV/IDEVT,IDEVH
      IP3D=0
      IF(NAPH.LT.2)RETURN
      WRITE(*,'('' Plot 3D pattern? [y] >'',$)')
      READ(*,'(A)')AIN1
      CALL UPCASE(AIN1,AIN1,LENGTH)
      IF(AIN1.EQ.'N')RETURN
      IP3D=1
      ICUT=1
      AXISLN=100.
      IPHIDN=1
2     CALL VHPLOT(ICUT,IPHIDN,AXISLN,FREQ,THETAD,PHID,GRANGE,IGVHT,
     &IDEVT)
1     WRITE(*,'('' GV,GH,GT,VA,GR,CR,EX,PL,2D >'',$)')
      CALL READCM(5,AIN,F1,F2,F3,F4,F5,F6,IERROR)
      IF(IERROR.NE.0)GO TO 1
      CALL UPCASE(AIN,AIN,LENGTH)
      IF(AIN.EQ.'GV')THEN
         IGVHT=1
      ELSE IF(AIN.EQ.'GH')THEN
         IGVHT=2
      ELSE IF(AIN.EQ.'GT')THEN
         IGVHT=3
      ELSE IF(AIN.EQ.'LV')THEN
         IGVHT=4
      ELSE IF(AIN.EQ.'LH')THEN
         IGVHT=5
      ELSE IF(AIN.EQ.'LT')THEN
         IGVHT=6
      ELSE IF(AIN.EQ.'PL')THEN
C
C        Turn off color, since the DEC Alpha Postscript driver has some
C        sort of "color/greyscale" output that generates Postscript
C        errors.
         IPHAZS=IPHAZ
         IPHAZ=0
         CALL VHPLOT(ICUT,IPHIDN,AXISLN,FREQ,THETAD,PHID,GRANGE,IGVHT,
     &   IDEVH)
         IPHAZ=IPHAZS
         GO TO 1
      ELSE IF(AIN.EQ.'PT')THEN
         CALL VHPLOT(ICUT,IPHIDN,AXISLN,FREQ,THETAD,PHID,GRANGE,IGVHT,
     &   IDEVT)
         GO TO 1
      ELSE IF(AIN.EQ.'CR')THEN
         IF(IPHAZ.EQ.0)THEN
            IPHAZ=1
         ELSE
            IPHAZ=0
         END IF
      ELSE IF(AIN.EQ.'EX')THEN
         CALL CLEARS
         CALL POSTDMP
         STOP
      ELSE IF(AIN.EQ.'2D')THEN
         RETURN
      ELSE IF(AIN.EQ.'VA')THEN
         THETAD=F1
         PHID=F2
      ELSE IF(AIN.EQ.'GR')THEN
         GRANGE=F1
         IF(GRANGE.LT.0.001)GRANGE=40.
      ELSE IF(AIN.EQ.'RB')THEN
         CALL GSBKRV
      END IF
      GO TO 2
      END
      SUBROUTINE SET3D
      SAVE
      COMMON/SET3DC/THETAD,PHID,GRANGE,IGVHT,IPHAZ
      THETAD=45.
      PHID=45.
      GRANGE=40.
      IGVHT=1
      IPHAZ=1
      RETURN
      END
      SUBROUTINE PATSTR
      PARAMETER (MXANG=1000)
      COMMON/NECPAT/RDANG(MXANG),ETHM(MXANG),EPHM(MXANG),RDANGS(MXANG),
     &ETHMS(MXANG),EPHMS(MXANG),FREQ,RIN,XIN,EFFIC,FXANG,ITHPH,IANT,NPT,
     &NPTS
      NPTS=NPT
      DO I=1,NPT
         RDANGS(I)=RDANG(I)
         ETHMS(I)=ETHM(I)
         EPHMS(I)=EPHM(I)
      END DO
      RETURN
      END
      SUBROUTINE NFLREAD(IEND,ICONT,IRDALL)
      PARAMETER (MXANG=1000)
      CHARACTER TEXT*120
      COMMON/NECPAT/RDANG(MXANG),ETHM(MXANG),EPHM(MXANG),RDANGS(MXANG),
     &ETHMS(MXANG),EPHMS(MXANG),FREQ,RIN,XIN,EFFIC,FXANG,ITHPH,IANT,NPT,
     &NPTS
      IEND=0
      IF(ICONT.NE.0)THEN
         CALL PATREAD(ICONT,IRDALL)
         IF(NPT.LT.2)THEN
            ICONT=0
            GO TO 1
         END IF
         RETURN
      END IF
1     READ(2,'(A)',END=703)TEXT
      IF(TEXT(44:54).EQ.'- FREQUENCY')THEN
C
C        READ FREQUENCY
C
         READ(2,'(A)')TEXT
         READ(2,'(46X,E11.4)')FREQ
         IANT=0
      ELSE IF(TEXT(43:58).EQ.'- - - ANTENNA IN')THEN
C
C        READ INPUT IMPEDANCE
C
         DO 3 I=1,3
3        READ(2,'(A)')TEXT
         READ(2,93)RIN,XIN
93       FORMAT(60X,2E12.5)
         IANT=1
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
5        READ(2,'(A)')TEXT
C
C        READ PATTERN DATA
C
         CALL PATREAD(ICONT,IRDALL)
         IF(NPT.LT.2)GO TO 1
         RETURN
      END IF
      GO TO 1
703   IEND=1
      CALL POSTDMP
      RETURN
      END
      SUBROUTINE PATREAD(ICONT,IRDALL)
C
C     PATREAD reads the radiation pattern table from a nec output file.
C
      SAVE
      PARAMETER (MXANG=1000,IDIM=182,JDIM=362)
      CHARACTER TEXT*120,AIN*1
      COMMON/GPAT/ GV(IDIM,JDIM),GH(IDIM,JDIM),GT(IDIM,JDIM),
     &ETPH(IDIM,JDIM),EPPH(IDIM,JDIM),AXRAT(IDIM,JDIM),THETA(IDIM),
     &PHIA(JDIM),GVMAX,GHMAX,GTMAX,IGVTMX,IGVPMX,IGHTMX,IGHPMX,IGTTMX,
     &IGTPMX,NATH,NAPH
      COMMON/NECPAT/RDANG(MXANG),ETHM(MXANG),EPHM(MXANG),RDANGS(MXANG),
     &ETHMS(MXANG),EPHMS(MXANG),FREQ,RIN,XIN,EFFIC,FXANG,ITHPH,IANT,NPT,
     &NPTS
      DATA DTOR/0.01745328/,PI/3.141596/
      ILIMT=0
      ILIMP=0
4     ITHPH=0
      NPT=0
      NAPH=0
      IF(ICONT.EQ.0)THEN
         IPHA=1
         GVMAX=-100.
         GHMAX=-100.
         GTMAX=-100.
      ELSE
         IPHA=IPHA+1
         IF(IPHA.GT.JDIM)THEN
            IPHA=JDIM
            ILIMP=1
         ELSE
            PHIA(IPHA)=PHIANG*DTOR
         END IF
         GO TO 3
      END IF
1     READ(2,'(A)')TEXT
      IF(TEXT.EQ.' ')GO TO 2
      READ(TEXT,'(F8.2,F9.2,3X,3F8.2,3X,F8.5,11X,A2,7X,E12.5,F9.2,3X,
     &E12.5,F9.2)',ERR=2)THETANG,PHIANG,VGAIN,HGAIN,TGAIN,AXRAX,PSENS,
     &ETHMAG,ETHPH,EPHMAG,EPHPH
      IF(PSENS.EQ.'LE')AXRAX=-AXRAX
3     NPT=NPT+1
C
C     SAVE THETA OR PHI ANGLE -- WHICHEVER IS CHANGING
C
      IF(NPT.EQ.1)THEN
         THSAV=THETANG
         PHISAV=PHIANG
         VGSAV=VGAIN
         HGSAV=HGAIN
         TGSAV=TGAIN
         ETPSAV=ETHPH
         EPPSAV=EPHPH
         AXRSAV=AXRAX
      ELSE IF(NPT.EQ.2)THEN
         IF(ABS(PHIANG-PHISAV).GT.1.E-6)THEN
            ITHPH=1
            RDANG(1)=PHISAV
            FXANG=THSAV
            ANSIGN=1.
            IF(PHIANG.LT.PHISAV)ANSIGN=-1.
         ELSE
            ITHPH=0
            RDANG(1)=THSAV
            FXANG=PHISAV
            ANSIGN=1.
            IF(THETANG.LT.THSAV)ANSIGN=-1.
            THETA(1)=THSAV*DTOR
            IF(IPHA.EQ.1)PHIA(1)=PHISAV*DTOR
            GV(1,IPHA)=VGSAV
            GH(1,IPHA)=HGSAV
            GT(1,IPHA)=TGSAV
            ETPH(1,IPHA)=ETPSAV
            EPPH(1,IPHA)=EPPSAV
            AXRAT(1,IPHA)=AXRSAV
            IF(ETHM(1).GT.GVMAX)THEN
                 GVMAX=ETHM(1)
               IGVTMX=1
               IGVPMX=IPHA
            END IF
            IF(EPHM(1).GT.GHMAX)THEN
                 GHMAX=EPHM(1)
               IGHTMX=1
               IGHPMX=IPHA
            END IF
            IF(TGSAV.GT.GTMAX)THEN
                 GTMAX=TGSAV
               IGTTMX=1
               IGTPMX=IPHA
            END IF
         END IF
      END IF
      IF(NPT.GT.1)THEN
         IF(ITHPH.EQ.0)THEN
            RDANG(NPT)=THETANG
            IF(NPT.LE.IDIM)THEN
               THETA(NPT)=THETANG*DTOR
               GV(NPT,IPHA)=VGAIN
               GH(NPT,IPHA)=HGAIN
               GT(NPT,IPHA)=TGAIN
               ETPH(NPT,IPHA)=ETHPH
               EPPH(NPT,IPHA)=EPHPH
               AXRAT(NPT,IPHA)=AXRAX
               IF(VGAIN.GT.GVMAX)THEN
                  GVMAX=VGAIN
                  IGVTMX=NPT
                  IGVPMX=IPHA
               END IF
               IF(HGAIN.GT.GHMAX)THEN
                  GHMAX=HGAIN
                  IGHTMX=NPT
                  IGHPMX=IPHA
               END IF
               IF(TGAIN.GT.GTMAX)THEN
                  GTMAX=TGAIN
                  IGTTMX=NPT
                  IGTPMX=IPHA
               END IF
            ELSE
               ILIMT=1
            END IF
         ELSE
            RDANG(NPT)=PHIANG
         END IF
         IF((RDANG(NPT)-RDANG(NPT-1))*ANSIGN.LT.0.)THEN
            NPT=NPT-1
            ICONT=1
            IF(IRDALL.NE.0)GO TO 4
            RETURN
         END IF
      END IF
      ETHM(NPT)=VGAIN
      EPHM(NPT)=HGAIN
      IF(NPT.LT.MXANG)GO TO 1
2     ICONT=0
      NATH=NPT
      NAPH=IPHA
      IF(PHIA(NAPH).GT.6.2828.AND.PHIA(NAPH).LT.6.2834)
     &   PHIA(NAPH)=6.2828
      IF(ILIMP.NE.0.OR.ILIMT.NE.0)THEN
         IF(ILIMP.NE.0)THEN
            WRITE(*,'('' Number of phi samples > limit of'')')JDIM
         END IF
         IF(ILIMT.NE.0)THEN
            WRITE(*,'('' Number of theta samples > limit of'')')IDIM
            NATH=IDIM
         END IF
         WRITE(*,'('' RETURN to continue >'',$)')
         READ(*,'(A)')AIN
      END IF
      RETURN
      END
      SUBROUTINE PATPLP(IDEV,IRCAL,IZERO,IPCP)
      IF(IPCP.EQ.0)THEN
         CALL PPCART(IDEV,IRCAL)
      ELSE
         CALL PPAXIS(IDEV)
         CALL PPPLOT(IZERO,IRCAL)
      END IF
      CALL ENDPLT
      RETURN
      END
      SUBROUTINE PPCART(IDEV,IRCAL)
      PARAMETER (MXANG=1000)
      INTEGER*1 LABL(70)
      CHARACTER LABLC*70
      EQUIVALENCE (LABL,LABLC)
      COMMON/NECPAT/RDANG(MXANG),ETHM(MXANG),EPHM(MXANG),RDANGS(MXANG),
     &ETHMS(MXANG),EPHMS(MXANG),FREQ,RIN,XIN,EFFIC,FXANG,ITHPH,IANT,NPT,
     &NPTS
      CALL MINMAX(ETHM,NPT,RMIN,RMAX)
      CALL MINMAX(EPHM,NPT,HMIN,HMAX)
      IF(HMAX.GT.RMAX)RMAX=HMAX
      ANMIN=MIN(RDANG(1),RDANG(NPT))
      ANMAX=MAX(RDANG(1),RDANG(NPT))
      IF(IRCAL.NE.0)THEN
         CALL MINMAX(ETHMS,NPTS,HMIN,HMAX)
         IF(HMAX.GT.RMAX)RMAX=HMAX
         CALL MINMAX(EPHMS,NPTS,HMIN,HMAX)
         IF(HMAX.GT.RMAX)RMAX=HMAX
         ANMIN=MIN(ANMIN,RDANGS(1),RDANGS(NPTS))
         ANMAX=MAX(ANMAX,RDANGS(1),RDANGS(NPTS))
      END IF
      RSMAX=INT(RMAX/10.)*10.
      IF(RMAX.GT.0.)RSMAX=RSMAX+10.
      IF(RSMAX.LT.-60.)RSMAX=-60.
      RSMIN=RSMAX-40.
      CALL DEVSEL(IDEV,4,IERR)
      CALL BGNPLT
      CALL MAPSIZ(10.,90.,12.,97.,0.)
      IF(ITHPH.EQ.0)THEN
         CALL MAPIT(ANMIN,ANMAX,RSMIN,RSMAX,'Theta','Gain (dB)',
     &'Solid: vertical gain    Dashed: horizontal gain',192)
      ELSE
         CALL MAPIT(ANMIN,ANMAX,RSMIN,RSMAX,'Phi','Gain (dB)',
     &'Solid: vertical gain    Dashed: horizontal gain',192)
      END IF
      CALL GSLTYP(1)
      CALL GSCOLR(2,IERR)
      CALL TRACEC(RDANG,ETHM,NPT)
      CALL GSLTYP(3)
      CALL GSCOLR(3,IERR)
      CALL TRACEC(RDANG,EPHM,NPT)
      IF(IRCAL.NE.0)THEN
         CALL GSETLW(.5)
         CALL GSLTYP(1)
         CALL GSCOLR(4,IERR)
         CALL TRACEC(RDANGS,ETHMS,NPTS)
         CALL GSLTYP(3)
         CALL GSCOLR(4,IERR)
         CALL TRACEC(RDANGS,EPHMS,NPTS)
         CALL GSETLW(1.)
      END IF
      CALL GSCOLR(1,IERR)
C
C     WRITE TITLE AND PARAMETERS
C
      CHRSZ=GOODCS(.04)
      CALL GSSETC(CHRSZ,0.)
C     Write Theta or Phi plot
      IF(ITHPH.EQ.0)THEN
         WRITE(LABLC,'(''Phi ='',F7.2)')FXANG
         LABL(13)=0
      ELSE
         WRITE(LABLC,'(''Theta ='',F7.2)')FXANG
         LABL(15)=0
      END IF
      CALL GSMOVE(14.,1.6)
      CALL GSPSTC(LABLC)
C     Write Frequency and fixed angle
      WRITE(LABLC,'(''Frequency ='',F7.2,'' MHz'')')FREQ
      LABL(23)=0
      CALL GSMOVE(.1,1.6)
      CALL GSPSTC(LABLC)
      IF(IANT.NE.0)THEN
         WRITE(LABLC,'(''Impedance ='',1P2E10.3,'' Ohms'')')RIN,XIN
         LABL(37)=0
         CALL GSMOVE(.1,.7)
         CALL GSPSTC(LABLC)
         WRITE(LABLC,'(''Efficiency ='',0PF5.1,'' Percent'')')EFFIC
         LABL(26)=0
         CALL GSMOVE(14.,.7)
         CALL GSPSTC(LABLC)
      END IF
      RETURN
      END
      SUBROUTINE PPPLOT(IZERO,IRCAL)
C
C     PLOT POLAR PATTERN
C
      PARAMETER (MXANG=1000)
      COMMON/NECPAT/RDANG(MXANG),ETHM(MXANG),EPHM(MXANG),RDANGS(MXANG),
     &ETHMS(MXANG),EPHMS(MXANG),FREQ,RIN,XIN,EFFIC,FXANG,ITHPH,IANT,NPT,
     &NPTS
      DATA TA/0.01745329252/,DBRANGE/40./
      CALL MINMAX(ETHM,NPT,RMIN,RMAX)
      CALL MINMAX(EPHM,NPT,HMIN,HMAX)
      IF(HMAX.GT.RMAX)RMAX=HMAX
      IF(IRCAL.NE.0)THEN
         CALL MINMAX(ETHMS,NPTS,HMIN,HMAX)
         IF(HMAX.GT.RMAX)RMAX=HMAX
         CALL MINMAX(EPHMS,NPTS,HMIN,HMAX)
         IF(HMAX.GT.RMAX)RMAX=HMAX
      END IF
      RSMAX=INT(RMAX/10.)*10.
      IF(RMAX.GT.0.)RSMAX=RSMAX+10.
      IF(RSMAX.LT.-60.)RSMAX=-60.
      CALL POLABL(RSMAX)
      CALL GSETLW(1.)
      CALL PPTRAC(1,2,IZERO,RSMAX,NPT,RDANG,ETHM)
      CALL PPTRAC(3,3,IZERO,RSMAX,NPT,RDANG,EPHM)
      IF(IRCAL.NE.0)THEN
         CALL GSETLW(.5)
         CALL PPTRAC(1,4,IZERO,RSMAX,NPTS,RDANGS,ETHMS)
         CALL PPTRAC(3,4,IZERO,RSMAX,NPTS,RDANGS,EPHMS)
         CALL GSETLW(1.)
      END IF
      CALL GSLTYP(1)
      CALL GSETLW(.25)
      CALL GSCOLR(1,IERR)
      CHRSZ=GOODCS(.04)
      CALL GSSETC(CHRSZ,0.)
      IF(IZERO.EQ.1)THEN
         CALL GSMOVE(-.01,1.02)
         CALL GSPSTC('0'//CHAR(0))
         CALL GSMOVE(-1.1,-.02)
         CALL GSPSTC('90'//CHAR(0))
         CALL GSMOVE(-.06,-1.06)
         CALL GSPSTC('180'//CHAR(0))
         CALL GSMOVE(1.03,-.02)
         CALL GSPSTC('270'//CHAR(0))
      ELSE IF(IZERO.EQ.2)THEN
         CALL GSMOVE(-.01,1.02)
         CALL GSPSTC('0'//CHAR(0))
         CALL GSMOVE(1.03,-.02)
         CALL GSPSTC('90'//CHAR(0))
         CALL GSMOVE(-.06,-1.06)
         CALL GSPSTC('180'//CHAR(0))
         CALL GSMOVE(-1.14,-.02)
         CALL GSPSTC('270'//CHAR(0))
      ELSE IF(IZERO.EQ.3)THEN
         CALL GSMOVE(1.02,-.02)
         CALL GSPSTC('0'//CHAR(0))
         CALL GSMOVE(-.03,1.02)
         CALL GSPSTC('90'//CHAR(0))
         CALL GSMOVE(-1.14,-.02)
         CALL GSPSTC('180'//CHAR(0))
         CALL GSMOVE(-.05,-1.06)
         CALL GSPSTC('270'//CHAR(0))
      ELSE IF(IZERO.EQ.4)THEN
         CALL GSMOVE(1.02,-.02)
         CALL GSPSTC('0'//CHAR(0))
         CALL GSMOVE(-.04,-1.06)
         CALL GSPSTC('90'//CHAR(0))
         CALL GSMOVE(-1.14,-.02)
         CALL GSPSTC('180'//CHAR(0))
         CALL GSMOVE(-.05,1.02)
         CALL GSPSTC('270'//CHAR(0))
      END IF
      CALL GSETLW(1.)
      RETURN
      END
      SUBROUTINE PPTRAC(ILINE,ICOLR,IZERO,RSMAX,NPT,ANG,EMAGA)
      DIMENSION ANG(*),EMAGA(*)
      DATA TA/0.01745329252/,DBRANGE/40./
      CALL GSLTYP(ILINE)
      CALL GSCOLR(ICOLR,IERR)
      DO ITH=1,NPT
         EMAG=(EMAGA(ITH)-RSMAX)/DBRANGE+1.
         IF(EMAG.LT.0.)EMAG=0.
         IF(IZERO.EQ.1)THEN
            XEMAG=-SIN(ANG(ITH)*TA)*EMAG
            YEMAG=COS(ANG(ITH)*TA)*EMAG
         ELSE IF(IZERO.EQ.2)THEN
            XEMAG=SIN(ANG(ITH)*TA)*EMAG
            YEMAG=COS(ANG(ITH)*TA)*EMAG
         ELSE IF(IZERO.EQ.3)THEN
            YEMAG=SIN(ANG(ITH)*TA)*EMAG
            XEMAG=COS(ANG(ITH)*TA)*EMAG
         ELSE IF(IZERO.EQ.4)THEN
            YEMAG=-SIN(ANG(ITH)*TA)*EMAG
            XEMAG=COS(ANG(ITH)*TA)*EMAG
         END IF
         IF(ITH.EQ.1)THEN
            CALL GSMOVE(XEMAG,YEMAG)
         ELSE
            CALL GSDRAW(XEMAG,YEMAG)
         END IF
      END DO
      RETURN
      END
      SUBROUTINE POLABL(RSMAX)
      PARAMETER (MXANG=1000)
      INTEGER*1 LRCS(10),LABL(70),LABL2(70)
      CHARACTER LRCSC*10,LABLC*70,LABLC2*70
      EQUIVALENCE (LRCS,LRCSC),(LABL,LABLC),(LABL2,LABLC2)
      COMMON/NECPAT/RDANG(MXANG),ETHM(MXANG),EPHM(MXANG),RDANGS(MXANG),
     &ETHMS(MXANG),EPHMS(MXANG),FREQ,RIN,XIN,EFFIC,FXANG,ITHPH,IANT,NPT,
     &NPTS
      LRCSC='Gain (dB)'//CHAR(0)
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
C     Write GAIN (dB) at top of plot
      CHRSZ=GOODCS(.04)
      CALL GSSETC(CHRSZ,0.)
      CALL GSMOVE(-.2,1.12)
      CALL GSPSTC(LRCSC)
C     Write Theta or Phi plot
      IF(ITHPH.EQ.0)THEN
         WRITE(LABLC,'(''Theta plot'')')
         WRITE(LABLC2,'(''Phi ='',F7.2)')FXANG
         LABL(11)=0
         LABL2(13)=0
      ELSE
         WRITE(LABLC,'(''Phi plot'')')
         WRITE(LABLC2,'(''Theta ='',F7.2)')FXANG
         LABL(9)=0
         LABL2(15)=0
      END IF
      CALL GSMOVE(.7,-1.0)
      CALL GSPSTC(LABLC)
      CALL GSMOVE(.7,-1.1)
      CALL GSPSTC(LABLC2)
C     Write Frequency and fixed angle
      WRITE(LABLC,'(''Frequency ='',F7.2,'' MHz'')')FREQ
      LABL(23)=0
      CALL GSMOVE(-1.7,-1.1)
      CALL GSPSTC(LABLC)
      IF(IANT.NE.0)THEN
         WRITE(LABLC,'(''Impedance ='',1P2E10.3,'' Ohms'')')RIN,XIN
         LABL(37)=0
         CALL GSMOVE(-1.7,-1.2)
         CALL GSPSTC(LABLC)
         WRITE(LABLC,'(''Efficiency ='',0PF5.1,'' Percent'')')EFFIC
         LABL(26)=0
         CALL GSMOVE(.5,-1.2)
         CALL GSPSTC(LABLC)
      END IF
      LABLC='Solid: vertical gain'
      LABL(21)=0
      CALL GSMOVE(.8,1.3)
      CALL GSPSTC(LABLC)
       LABLC='Dashed: horizontal gain'
      LABL(24)=0
      CALL GSMOVE(.8,1.2)
      CALL GSPSTC(LABLC)
      RETURN
      END
      SUBROUTINE AXLABL(DIST,IAX,VAL)
      INTEGER*1 LABL(5)
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
      CALL GSPSTC(LABLC)
      ELSE
      CALL GSSETC(CHRSZ,90.)
      CALL GSMOVE(-CHRSZ,DIST-2.*CHRSZ)
      CALL GSPSTC(LABLC)
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
      INTEGER*1 LAB(10)
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
      USE MSFLIB
C      BYTE GS,FF,ESC,GG,Q,Z
C      CHARACTER*1 CGS,CFF,CESC,CQ,CZ,CGG
C      EQUIVALENCE (CGS,GS),(CFF,FF),(CESC,ESC),(CQ,Q),(CZ,Z),(CGG,GG)
C      DATA GS/29/,FF/12/,ESC/27/,Q/34/,Z/48/,GG/103/
c      CLOSE(6)
c      WRITE(*,90) CGS,CESC,CFF,CESC,CQ,CZ,CGG
c90    FORMAT('+',A1,$)
c90    FORMAT(7A1,$)
c      CLOSE(6)
C
C     MACINTOSH:
C      CALL GDMACSE(2,XA,YA)
C
C     Windows 95
      CALL CLEARSCREEN($GCLEARSCREEN)
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
      WRITE(*,*)' Error opening input file'
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
        IF (FLDTRM) ENDFLD(TOTFLD)= TOTCOL

C  Check to see if the total number of value fields is within the precribed
C  limits.

 5000   IF (TOTFLD .EQ. 0) THEN
           RETURN
        ELSE IF (TOTFLD .GT. LAST) THEN
           WRITE( *, 8001 )
           GO TO 9010
        ENDIF
        J= MIN( TOTFLD, MAXINT )

C  Parse out integer values and store into integer buffer array.

        DO 5090 I=1,J
           LENGTH= ENDFLD(I) - BGNFLD(I) + 1
           BUFFER= REC(BGNFLD(I):ENDFLD(I))
           IND= INDEX( BUFFER(1:LENGTH), '.' )
           IF (IND .GT. 0  .AND.  IND .LT. LENGTH) GO TO 9000
           IF (IND .EQ. LENGTH) LENGTH= LENGTH - 1
           READ( BUFFER(1:LENGTH), '(I15)', ERR=9000 ) INTFLD(I)
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
     &                      BUFFER(INDE:LENGTH-1)
                 ENDIF
              ENDIF
              READ(BUFFER(1:LENGTH),'(E15.5)',ERR=9000)REAFLD(I-MAXINT)
 6000      CONTINUE
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
 8001   FORMAT (//,' ***** Input error - too many fields in record')
 8002   FORMAT (//,' ***** Input error - invalid number at integer',
     &          ' position ',I1)
 8003   FORMAT (//,' ***** Input error - invalid number at real',
     &          ' position ',I1)
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
      SUBROUTINE VHPLOT(ICUT,IPHIDN,AXISLN,FREQ,THETAD,PHID,GRANGE,
     &IGVHT,IDEV)
      CHARACTER LABC*80,LABC1*20,LABC2*20
      PARAMETER (IDIM=182,JDIM=362)
      BYTE LABL(80),LABL1(20),LABL2(20)
      REAL GAINA(IDIM,JDIM)
      COMMON/GPAT/ GV(IDIM,JDIM),GH(IDIM,JDIM),GT(IDIM,JDIM),
     &ETPH(IDIM,JDIM),EPPH(IDIM,JDIM),AXRAT(IDIM,JDIM),THETA(IDIM),
     &PHIA(JDIM),GVMAX,GHMAX,GTMAX,IGVTMX,IGVPMX,IGHTMX,IGHPMX,IGTTMX,
     &IGTPMX,NATH,NAPH
      EQUIVALENCE (LABL,LABC),(LABL1,LABC1),(LABL2,LABC2)
      DATA DTOR/.01745329252/
      THETAV=THETAD*DTOR
      PHIV=PHID*DTOR
      CALL SETGN(IGVHT,GRANGE,GAINA)
      CALL DEVSEL(IDEV,4,IERR)
      CALL BGNPLT
      CALL GSETLW(.25)
      CALL PLT3DS(GAINA,THETA,PHIA,NATH,NAPH,ICUT,IPHIDN,AXISLN,
     &            THETAV,PHIV)
      CALL GSETDP(0.,1.,1.,0.,0.)
      YSLEN=GSYLCM()
      CHRSZ=GOODCS(.3)
      CALL GSSETC(CHRSZ,0.)
      CALL GSETLW(1.)
C
      WRITE(LABC,'(''F ='',1PE9.2,'' MHz'')')FREQ
      LABL(17)=0
      CALL GSMOVE(.2,1.7)
      CALL GSPSTR(LABL)
      IF(IGVHT.EQ.1.OR.IGVHT.EQ.4)THEN
         WRITE(LABC,'(''V. Gain: Max ='',F6.2,'' dB'')')GVMAX
           WRITE(LABC1,'(''max ='',F6.1)')THETA(IGVTMX)/DTOR
           WRITE(LABC2,'(''max ='',F6.1)')PHIA(IGVPMX)/DTOR
      ELSE IF(IGVHT.EQ.2.OR.IGVHT.EQ.5)THEN
         WRITE(LABC,'(''H. Gain: Max ='',F6.2,'' dB'')')GHMAX
           WRITE(LABC1,'(''max ='',F6.1)')THETA(IGHTMX)/DTOR
           WRITE(LABC2,'(''max ='',F6.1)')PHIA(IGHPMX)/DTOR
      ELSE
         WRITE(LABC,'(''T. Gain: Max ='',F6.2,'' dB'')')GTMAX
           WRITE(LABC1,'(''max ='',F6.1)')THETA(IGTTMX)/DTOR
           WRITE(LABC2,'(''max ='',F6.1)')PHIA(IGTPMX)/DTOR
      END IF
      LABL(24)=0
      LABL1(12)=0
      LABL2(12)=0
      CALL GSMOVE(.2,.9)
      CALL GSPSTR(LABL)
      IF(IGVHT.LT.4)THEN
         WRITE(LABC,'(7X,''Range ='',F6.2,'' dB'')')GRANGE
         LABL(26)=0
      ELSE
         WRITE(LABC,'(11X,''Linear scale'')')
         LABL(24)=0
      END IF
      CALL GSMOVE(.2,.3)
      CALL GSPSTR(LABL)
      CALL GSMOVE(9.5,1.05)
      CALL SYMBOL(7,CHRSZ)
      CALL GSMOVE(9.8,.9)
      CALL GSPSTR(LABL1)
      CALL GSMOVE(9.5,.45)
      CALL SYMBOL(8,CHRSZ)
      CALL GSMOVE(9.8,.3)
      CALL GSPSTR(LABL2)
      WRITE(LABC,'(''view:'')')
      LABL(6)=0
      CALL GSMOVE(15.3,.9)
      CALL GSPSTR(LABL)
      CALL GSMOVE(17.2,1.05)
      CALL SYMBOL(7,CHRSZ)
      WRITE(LABC,'(''='',F6.1)')THETAD
      LABL(8)=0
      CALL GSMOVE(17.7,.9)
      CALL GSPSTR(LABL)
      CALL GSMOVE(17.2,.45)
      CALL SYMBOL(8,CHRSZ)
      WRITE(LABC,'(''='',F6.1)')PHID
      LABL(8)=0
      CALL GSMOVE(17.7,.3)
      CALL GSPSTR(LABL)
      IF(IGVHT.EQ.3.OR.IGVHT.EQ.6)THEN
         CALL AXLGND(1.,YSLEN-2.,12.)
      ELSE
         CALL PHLGND(1.,YSLEN-2.,12.)
      END IF
      CALL ENDPLT
      RETURN
      END
      SUBROUTINE SETGN(IGVHT,GRANGE,GAINA)
      PARAMETER (MXANG=1000,IDIM=182,JDIM=362)
      COMMON/GPAT/ GV(IDIM,JDIM),GH(IDIM,JDIM),GT(IDIM,JDIM),
     &ETPH(IDIM,JDIM),EPPH(IDIM,JDIM),AXRAT(IDIM,JDIM),THETA(IDIM),
     &PHIA(JDIM),GVMAX,GHMAX,GTMAX,IGVTMX,IGVPMX,IGHTMX,IGHPMX,IGTTMX,
     &IGTPMX,NATH,NAPH
      REAL GAINA(IDIM,JDIM)
      IF(IGVHT.EQ.1)THEN
         ADJ=GRANGE-GVMAX
         DO I=1,NATH
            DO J=1,NAPH
               GAINA(I,J)=GV(I,J)+ADJ
               IF(GAINA(I,J).LT.0.)GAINA(I,J)=0.
            END DO
         END DO
      ELSE IF(IGVHT.EQ.2)THEN
         ADJ=GRANGE-GHMAX
         DO I=1,NATH
            DO J=1,NAPH
               GAINA(I,J)=GH(I,J)+ADJ
               IF(GAINA(I,J).LT.0.)GAINA(I,J)=0.
            END DO
         END DO
      ELSE IF(IGVHT.EQ.3)THEN
         ADJ=GRANGE-GTMAX
         DO I=1,NATH
            DO J=1,NAPH
               GAINA(I,J)=GT(I,J)+ADJ
               IF(GAINA(I,J).LT.0.)GAINA(I,J)=0.
            END DO
         END DO
      ELSE IF(IGVHT.EQ.4)THEN
         DO I=1,NATH
            DO J=1,NAPH
               GAINA(I,J)=10.**((GV(I,J)-GVMAX)/10.)
            END DO
         END DO
      ELSE IF(IGVHT.EQ.5)THEN
         DO I=1,NATH
            DO J=1,NAPH
               GAINA(I,J)=10.**((GH(I,J)-GHMAX)/10.)
            END DO
         END DO
      ELSE IF(IGVHT.EQ.6)THEN
         DO I=1,NATH
            DO J=1,NAPH
               GAINA(I,J)=10.**((GT(I,J)-GTMAX)/10.)
            END DO
         END DO
      END IF
      RETURN
      END
      SUBROUTINE PLT3DS(R,THETA,PHI,NI,NJ,ICUT,
     &                                   IPHIDN,AXISLN,THETAV,PHIV)
C     (C) COPYRIGHT WAYMOND R. SCOTT, JR., 1987
C     DESCRIBED IN THE PAPER W.R. SCOTT, JR., "A GENERAL PROGRAM FOR PLOTTING
C     THREE-DIMENSIONAL ANTENNA PATTERNS," IEEE ANTENNAS AND PROPAGATION
C     SOCIETY NEWSLETTER, VOL. 31, NO. 6, PP. 6-11, DECEMBER 1989.
C-----INPUTS-------------------------------------------------------------------
C
C     R(I,J)  - RADIUS IN INCHES AT THE ANGULAR COORDINATES THETA(I) AND PHI(J).
C     THETA(I)- ANGULAR COORDINATE IN RADIANS OF THE I'TH COLUMN OF R(I,J).
C     PHI(J)  - ANGULAR COORDINATE IN RADIANS OF THE J'TH ROW OF R(I,J).
C     NI, NJ  - DIMENSIONS FOR THE PORTIONS OF THE ARRAYS R, THETA, AND PHI THAT
C               ARE FILLED WITH DATA. THE ACTUAL DIMENSIONS ARE SET BY THE
C               PARAMETERS IDIM AND JDIM.
C     ICUT    - IF ICUT=0 THE LINES BEHIND THE CUT ARE DRAWN, AND
C               IF ICUT=1 THE LINES BEHIND THE CUT ARE NOT DRAWN.
C     IPHIDN  - IF IPHIDN=1 BOTH THE COMPLETLY AND PARTIALLY VISIBLE LINE
C               SEGMENTS ARE DRAWN OTHERWISE ONLY THE COMPLETLY VISIBLE LINE
C               SEGMENTS ARE DRAWN.
C     AXISLN  - LENGTH OF THE AXES (BEFORE PROJECTION).
C               IF AXISLN=0 THE AXES ARE NOT DRAWN.
C     THETAV, - THE VIEWER ANGLES FOR THE PROJECTION IN RADIANS.
C     PHIV
C------------------------------------------------------------------------------
      PARAMETER ( IDIM=182 , JDIM=362 )
      REAL R(IDIM,JDIM),THETA(IDIM),PHI(JDIM)
      REAL X(IDIM,JDIM),Y(IDIM,JDIM),Z(IDIM,JDIM)
      DO 10 I=1,NI
      DO 10 J=1,NJ
        CALL SPTORT(R(I,J),THETA(I),PHI(J),X(I,J),Y(I,J),Z(I,J))
   10 CONTINUE
      CALL PLT3DG(X,Y,Z,NI,NJ,ICUT,0.,IPHIDN,AXISLN,THETAV,PHIV)
      RETURN
      END
      SUBROUTINE PLT3DG(X,Y,Z,NI,NJ,ICUT,ZCUT,IPHIDN,AXISLN,
     &                                              THETAX,PHIX)
C     (C) COPYRIGHT WAYMOND R. SCOTT, JR., 1987
C     DESCRIBED IN THE PAPER W.R. SCOTT, JR., "A GENERAL PROGRAM FOR PLOTTING
C     THREE-DIMENSIONAL ANTENNA PATTERNS," IEEE ANTENNAS AND PROPAGATION
C     SOCIETY NEWSLETTER, VOL. 31, NO. 6, PP. 6-11, DECEMBER 1989.
C-----INPUTS-------------------------------------------------------------------
C
C     X(I,J), Y(I,J), Z(I,J) - X, Y, AND Z COORDINATES OF THE (I,J)'TH POINT.
C     NI, NJ  - DIMENSIONS FOR THE PORTIONS OF THE ARRAYS R, THETA, AND PHI THAT
C               ARE FILLED WITH DATA. THE ACTUAL DIMENSIONS ARE SET BY THE
C               PARAMETERS IDIM AND JDIM.
C     ICUT    - IF ICUT=0 THE LINES BEHIND THE CUT ARE DRAWN, AND
C               IF ICUT=1 OR 2 THE LINES BEHIND THE CUT ARE NOT DRAWN.
C     ZCUT    - AUXILIARY POINT ON THE Z-AXIS USED IN THE PROCEDURE FOR
C               REMOVING THE LINES BEHIND THE CUT (ONLY USED WHEN ICUT=2).
C     IPHIDN  - IF IPHIDN=1 BOTH THE COMPLETLY AND PARTIALLY VISIBLE LINE
C               SEGMENTS ARE DRAWN OTHERWISE ONLY THE COMPLETLY VISIBLE LINE
C               SEGMENTS ARE DRAWN.
C     AXISLN  - LENGTH OF THE AXES (BEFORE PROJECTION).  IF AXISLN=0
C               THE AXES ARE NOT DRAWN.
C     THETAV, - THE VIEWER ANGLES FOR THE PROJECTION IN RADIANS.
C     PHIV
C------------------------------------------------------------------------------
      PARAMETER ( IDIM=182 , JDIM=362 , IJDIM=IDIM*JDIM )
      COMMON/PLTLIM/XVMIN,XVMAX,YVMIN,YMVAX,SCALE,XTRAN,YTRAN
      REAL X(IDIM,JDIM),Y(IDIM,JDIM),Z(IDIM,JDIM),XK(IJDIM)
      INTEGER IHID(IDIM,JDIM),KP(IJDIM),KPI(IDIM,JDIM)
      EQUIVALENCE ( XK,KPI )
      NIJ=NI*NJ
      NIM1=NI-1
      NJM1=NJ-1
C-----PROJECT THE GRID POINTS
C     PATCH TO REDUCE THE CHANCE THAT GRID POINT WILL LINE UP EXACTLY:
C     ADD 1.75E-5 RADIANS (1.E-3 DEGREES) TO THETAV AND PHIV.
      THETAV=THETAX+1.75E-5
      PHIV  =PHIX  +1.75E-5
      XVMIN=1.E10
      XVMAX=-1.E10
      YVMIN=1.E10
      YVMAX=-1.E10
      K=0
      DO 10 J=1,NJ
      DO 10 I=1,NI
        IHID(I,J)=0
        CALL PROJ(X(I,J),Y(I,J),Z(I,J),X(I,J),Y(I,J),Z(I,J),THETAV,PHIV)
        IF(X(I,J).LT.XVMIN)XVMIN=X(I,J)
        IF(X(I,J).GT.XVMAX)XVMAX=X(I,J)
        IF(Y(I,J).LT.YVMIN)YVMIN=Y(I,J)
        IF(Y(I,J).GT.YVMAX)YVMAX=Y(I,J)
        K=K+1
        KP(K)=K
        XK(K)=X(I,J)
   10 CONTINUE
C
C**** SET SCALE FACTOR AND ORIGIN BASED ON MAX AND MIN OF PLOT
C
      IF(ABS(XVMAX-XVMIN).GT.1.E-30)THEN
         XSCALE=GSXLCM()/(XVMAX-XVMIN)
      ELSE
         XSCALE=1.
      END IF
      IF(ABS(YVMAX-YVMIN).GT.1.E-30)THEN
         YSCALE=GSYLCM()/(YVMAX-YVMIN)
      ELSE
         YSCALE=1.
      END IF
      TSCALE=AMIN1(XSCALE,YSCALE)
      SCALE=.6*TSCALE
      XTRAN=.5*(GSXLCM()-(XVMIN+XVMAX)*SCALE)
      YTRAN=.5*(GSYLCM()-(YVMIN+YVMAX)*SCALE)
C      WRITE(*,977)XVMIN,XVMAX,YVMIN,YVMAX,SCALE,XTRAN,YTRAN
977   FORMAT('XYMINMX:',1P,4E12.5,/,4E12.5)
      CALL GSETDP(0.,SCALE,SCALE,XTRAN,YTRAN)
C****
C-----ORDER THE POINTS IN THE X DIRECTION
      CALL SORT(XK,NIJ,KP,IJDIM)
      DO 20 K=1,NIJ
        J=(KP(K)-1)/NI+1
        I=KP(K)-(J-1)*NI
        KPI(I,J)=K
   20 CONTINUE
C-----FIND THE GRID POINTS THAT ARE BEHIND THE CUT
      IF(ICUT.EQ.2)THEN
        CALL PROJ(0.,0.,ZCUT,XP0,YP0,ZP0,THETAV,PHIV)
      END IF
      IF(ICUT.NE.0) THEN
        DO 40 J=1,NJ,NJM1
          IF(ICUT.EQ.2)THEN
            X0=XP0
            Y0=YP0
            Z0=ZP0
          ELSE
            X0=X(1,J)
            Y0=Y(1,J)
            Z0=Z(1,J)
          END IF
          DO 40 I=1,NIM1
            X1=X(I,J)
            Y1=Y(I,J)
            Z1=Z(I,J)
            X2=X(I+1,J)
            Y2=Y(I+1,J)
            Z2=Z(I+1,J)
            KMIN=MIN(KPI(1,J),KPI(I,J),KPI(I+1,J))
            KMAX=MAX(KPI(1,J),KPI(I,J),KPI(I+1,J))
            ZMAX=MAX(Z0,Z1,Z2)
            YMIN=MIN(Y0,Y1,Y2)
            YMAX=MAX(Y0,Y1,Y2)
            DO 40 KK=KMIN+1,KMAX-1
              JJ=INT((KP(KK)-1)/NI)+1
              II=KP(KK)-(JJ-1)*NI
              IF(Z(II,JJ).LT.ZMAX.AND.Y(II,JJ).GT.
     &                       YMIN.AND.Y(II,JJ).LT.YMAX)THEN
                XP=X(II,JJ)
                YP=Y(II,JJ)
                ZP=Z(II,JJ)
                CALL INSIDT(ITEST,XP,YP,X0,Y0,X1,Y1,X2,Y2)
                IF(ITEST.EQ.1) THEN
                  IF(ZP.LT.ZEVAL(XP,YP,X0,Y0,Z0,X1,Y1,Z1,X2,Y2,Z2)) THEN
                    IHID(II,JJ)=MOD(IHID(II,JJ)+ITEST,2)
                  END IF
                END IF
              END IF
   40   CONTINUE
        DO 45 I=1,NI
          IHID(I,1 )=0
          IHID(I,NJ)=0
   45   CONTINUE
      END IF
C-----FIND THE HIDDEN GRID POINTS
      DO 90 I=1,NIM1
      DO 90 J=1,NJM1
        X1=X(I,J)
        Y1=Y(I,J)
        Z1=Z(I,J)
        X2=X(I,J+1)
        Y2=Y(I,J+1)
        Z2=Z(I,J+1)
        X3=X(I+1,J+1)
        Y3=Y(I+1,J+1)
        Z3=Z(I+1,J+1)
        X4=X(I+1,J)
        Y4=Y(I+1,J)
        Z4=Z(I+1,J)
        XMIN=X1
        KMIN=KPI(I,J)
        XMAX=XMIN
        KMAX=KMIN
        DO 50 II=I,I+1
        DO 50 JJ=J,J+1
          IF(X(II,JJ).GT.XMAX)THEN
            XMAX=X(II,JJ)
            KMAX=KPI(II,JJ)
          END IF
          IF(X(II,JJ).LT.XMIN)THEN
            XMIN=X(II,JJ)
            KMIN=KPI(II,JJ)
          END IF
   50   CONTINUE
        KMIN=KMIN+1
        KMAX=KMAX-1
        YMIN=AMIN1(Y1,Y2,Y3,Y4)
        YMAX=AMAX1(Y1,Y2,Y3,Y4)
        ZMIN=AMIN1(Z1,Z2,Z3,Z4)
        ZMAX=AMAX1(Z1,Z2,Z3,Z4)
        DO 80 KK=KMIN,KMAX
          KK1=KP(KK)
          JJ=(KK1-1)/NI+1
          II=KK1-(JJ-1)*NI
          IF(IHID(II,JJ).EQ.1   .OR.Z(II,JJ).GT.ZMAX.OR.
     &        Y(II,JJ).LE.YMIN.OR.Y(II,JJ).GE.YMAX) GO TO 70
          IF((II.EQ.I.OR.II.EQ.I+1).AND.(JJ.EQ.J.OR.JJ.EQ.J+1))GO TO  70
          XP=X(II,JJ)
          YP=Y(II,JJ)
          ZP=Z(II,JJ)
          IF(II.EQ.1.OR.II.EQ.NI.OR.JJ.EQ.1.OR.JJ.EQ.NJ) THEN
            IF(ABS(XP-X1)+ABS(YP-Y1)+ABS(ZP-Z1).LT.1.E-4.OR.
     &         ABS(XP-X2)+ABS(YP-Y2)+ABS(ZP-Z2).LT.1.E-4.OR.
     &         ABS(XP-X3)+ABS(YP-Y3)+ABS(ZP-Z3).LT.1.E-4.OR.
     &         ABS(XP-X4)+ABS(YP-Y4)+ABS(ZP-Z4).LT.1.E-4)GO TO 70
          END IF
          CALL INSIDT(I123,XP,YP,X1,Y1,X2,Y2,X3,Y3)
          CALL INSIDT(I134,XP,YP,X1,Y1,X3,Y3,X4,Y4)
          IF(MOD(I123+I134,2).EQ.0) GOTO 70
          IF(ZP.LT.ZMIN)GO TO 60
          IF(ZP.GT.ZPOINT(XP,YP,X1,Y1,Z1,
     &        X2,Y2,Z2,X3,Y3,Z3,X4,Y4,Z4,I123)) GO TO 70
  60      IHID(II,JJ)=1
  70    CONTINUE
  80    CONTINUE
  90  CONTINUE
C-----DRAW THE AXES
      IF(AXISLN.GT.1.E-10)THEN
        CALL AXIS3D(AXISLN,.1,X,Y,Z,NI,NJ,IDIM,JDIM,IHID,THETAV,PHIV)
      END IF
C-----PATCH FOR SPHERICAL GRAPHS WITH BOTH HIDDEN AND VISIBLE GRID POINTS
C-----AT THE ORIGIN
      DO 900 I=1,NI
      DO 900 J=1,NJ
        IF(ABS(X(I,J)).LT.1.E-3.AND.ABS(Y(I,J)).LT.1.E-3)
     &                                           IHID(I,J)=1
  900 CONTINUE
C-----DRAW THE GRAPH
      DO 100 I=1,NI
        IF(IHID(I,1).EQ.0) CALL PLOTC(I,1,X(I,1),Y(I,1),3)
        DO 100 J=1,NJM1
          IF(IHID(I,J).EQ.0.AND.IHID(I,J+1).EQ.0) THEN
             CALL PLOTC(I,J+1,X(I,J+1),Y(I,J+1),2)
          ELSE
            IF(IHID(I,J).EQ.0.AND.IHID(I,J+1).EQ.1) THEN
              IF(IPHIDN.EQ.1) THEN
                CALL HIDDEN(XX,YY,I,J+1,I,J,X,Y,Z,NI,NJ,IDIM,JDIM,
     &                                          IHID,ICUT,XP0,YP0,ZP0)
                CALL PLOTC(I,J+1,XX,YY,2)
              END IF
            ELSE
              IF(IHID(I,J).EQ.1.AND.IHID(I,J+1).EQ.0) THEN
                IF(IPHIDN.EQ.1) THEN
                 CALL HIDDEN(XX,YY,I,J,I,J+1,X,Y,Z,NI,NJ,IDIM,JDIM,
     &                                           IHID,ICUT,XP0,YP0,ZP0)
                  CALL PLOTC(I,J,XX,YY,3)
                  CALL PLOTC(I,J+1,X(I,J+1),Y(I,J+1),2)
                ELSE
                  CALL PLOTC(I,J+1,X(I,J+1),Y(I,J+1),3)
                END IF
              END IF
            END IF
          END IF
  100 CONTINUE
      DO 110 J=1,NJ
        IF(IHID(1,J).EQ.0)CALL PLOTC(1,J,X(1,J),Y(1,J),3)
        DO 110 I=1,NIM1
          IF(IHID(I,J).EQ.0.AND.IHID(I+1,J).EQ.0) THEN
            CALL PLOTC(I+1,J,X(I+1,J),Y(I+1,J),2)
          ELSE
            IF(IHID(I,J).EQ.0.AND.IHID(I+1,J).EQ.1) THEN
              IF(IPHIDN.EQ.1) THEN
                CALL HIDDEN(XX,YY,I+1,J,I,J,X,Y,Z,NI,NJ,IDIM,JDIM,
     &                                          IHID,ICUT,XP0,YP0,ZP0)
                CALL PLOTC(I+1,J,XX,YY,2)
              END IF
            ELSE
              IF(IHID(I,J).EQ.1.AND.IHID(I+1,J).EQ.0) THEN
                IF(IPHIDN.EQ.1)THEN
                 CALL HIDDEN(XX,YY,I,J,I+1,J,X,Y,Z,NI,NJ,IDIM,JDIM,
     &                                           IHID,ICUT,XP0,YP0,ZP0)
                  CALL PLOTC(I,J,XX,YY,3)
                  CALL PLOTC(I+1,J,X(I+1,J),Y(I+1,J),2)
                ELSE
                  CALL PLOTC(I+1,J,X(I+1,J),Y(I+1,J),3)
                END IF
              END IF
            END IF
          END IF
  110 CONTINUE
      CALL GSCOLR(1,IERR)
C     UNDO PATCH
      THETAV=THETAV-1.75E-5
      PHIV  =PHIV  -1.75E-5
      RETURN
      END
      SUBROUTINE PROJ(X,Y,Z,XP,YP,ZP,THETA,PHI)
C     (C) COPYRIGHT WAYMOND R. SCOTT, JR., 1987
C     DESCRIBED IN THE PAPER W.R. SCOTT, JR., "A GENERAL PROGRAM FOR PLOTTING
C     THREE-DIMENSIONAL ANTENNA PATTERNS," IEEE ANTENNAS AND PROPAGATION
C     SOCIETY NEWSLETTER, VOL. 31, NO. 6, PP. 6-11, DECEMBER 1989.
C
C     COORDINATE TRANSFORMATION
C-----INPUTS-------------------------------------------------------------------
C     X, Y, AND Z   - INPUT COORDINATES.
C     THETA AND PHI - VIEWER ANGLES IN DEGRRES.
C-----OUTPUTS------------------------------------------------------------------
C     XP, YP, AND ZP - TRANSFORMED COORDINATES. XP AND YP ARE THE PAPER
C                      COORDINATES AND ZP IS THE HEIGHT ABOVE THE PAGE.
C------------------------------------------------------------------------------
      CP=COS(PHI)
      SP=SIN(PHI)
      CT=COS(THETA)
      ST=SIN(THETA)
      XT=-SP*X+CP*Y
      YT=-CP*CT*X-SP*CT*Y+ST*Z
      ZP= CP*ST*X+SP*ST*Y+CT*Z
      XP=XT
      YP=YT
      RETURN
      END
      FUNCTION ZPOINT(X,Y,X1,Y1,Z1,X2,Y2,Z2,X3,Y3,Z3,X4,Y4,Z4,I123)
C     (C) COPYRIGHT WAYMOND R. SCOTT, JR., 1987
C     DESCRIBED IN THE PAPER W.R. SCOTT, JR., "A GENERAL PROGRAM FOR PLOTTING
C     THREE-DIMENSIONAL ANTENNA PATTERNS," IEEE ANTENNAS AND PROPAGATION
C     SOCIETY NEWSLETTER, VOL. 31, NO. 6, PP. 6-11, DECEMBER 1989.
C
C     EVALUATE Z GIVEN (X,Y) AND THE VALUES OF X, Y, AND Z AT
C     THE POINTS 1-2-3-4
C
      IF(I123.EQ.1) THEN
        ZPOINT=ZEVAL(X,Y,X1,Y1,Z1,X2,Y2,Z2,X3,Y3,Z3)
      ELSE
        ZPOINT=ZEVAL(X,Y,X1,Y1,Z1,X3,Y3,Z3,X4,Y4,Z4)
      END IF
      RETURN
      END
      SUBROUTINE INSIDT(INSIDE,X,Y,X1,Y1,X2,Y2,X3,Y3)
C     (C) COPYRIGHT WAYMOND R. SCOTT, JR., 1987
C     DESCRIBED IN THE PAPER W.R. SCOTT, JR., "A GENERAL PROGRAM FOR PLOTTING
C     THREE-DIMENSIONAL ANTENNA PATTERNS," IEEE ANTENNAS AND PROPAGATION
C     SOCIETY NEWSLETTER, VOL. 31, NO. 6, PP. 6-11, DECEMBER 1989.
C
C     TEST THE POINT (X,Y) TO FIND WHETHER IT IS IN THE TRIANGLE 1-2-3
C     RETURNS;
C            INSIDE=0 IF THE POINT IS OUTSIDE OF THE TRIAGLE
C            INSIDE=1 IF THE POINT IS INSIDE OF THE TRIAGLE
C
      P1=(X2-X1)*(Y-Y1)-(Y2-Y1)*(X-X1)
      P2=(X3-X2)*(Y-Y2)-(Y3-Y2)*(X-X2)
      P3=(X1-X3)*(Y-Y3)-(Y1-Y3)*(X-X3)
C
      INSIDE=0
      IF(P1*P2.GT.0.AND.P1*P3.GT.0.AND.P2*P3.GT.0) INSIDE=1
      RETURN
      END
      FUNCTION ZEVAL(X,Y,X1,Y1,Z1,X2,Y2,Z2,X3,Y3,Z3)
C     (C) COPYRIGHT WAYMOND R. SCOTT, JR., 1987
C     DESCRIBED IN THE PAPER W.R. SCOTT, JR., "A GENERAL PROGRAM FOR PLOTTING
C     THREE-DIMENSIONAL ANTENNA PATTERNS," IEEE ANTENNAS AND PROPAGATION
C     SOCIETY NEWSLETTER, VOL. 31, NO. 6, PP. 6-11, DECEMBER 1989.
C
C     FIT A PLANE THROUGH THE POINTS 1-2-3
C     EVALUATE Z GIVEN (X,Y) AND THE VALUES OF X, Y, AND Z AT
C     THE POINTS 1-2-3
C
      ZEVAL=Z1-((X-X1)*((Y2-Y1)*(Z3-Z1)-(Y3-Y1)*(Z2-Z1))+
     &          (Y-Y1)*((Z2-Z1)*(X3-X1)-(Z3-Z1)*(X2-X1)))/
     &                 (X1*(Y2-Y3)+X2*(Y3-Y1)+X3*(Y1-Y2))
      RETURN
      END
      SUBROUTINE SPTORT(R,THETA,PHI,X,Y,Z)
C     (C) COPYRIGHT WAYMOND R. SCOTT, JR., 1987
C     DESCRIBED IN THE PAPER W.R. SCOTT, JR., "A GENERAL PROGRAM FOR PLOTTING
C     THREE-DIMENSIONAL ANTENNA PATTERNS," IEEE ANTENNAS AND PROPAGATION
C     SOCIETY NEWSLETTER, VOL. 31, NO. 6, PP. 6-11, DECEMBER 1989.
C
C     SPHERICAL TO RECTANGULAR COORDINATE CONVERSION.
      X=R*SIN(THETA)*COS(PHI)
      Y=R*SIN(THETA)*SIN(PHI)
      Z=R*COS(THETA)
      RETURN
      END
      SUBROUTINE HIDDEN(XX,YY,IH,JH,IV,JV,X,Y,Z,NI,NJ,IDIM,JDIM,
     &                                        IHID,ICUT,XP0,YP0,ZP0)
C     (C) COPYRIGHT WAYMOND R. SCOTT, JR., 1987
C     DESCRIBED IN THE PAPER W.R. SCOTT, JR., "A GENERAL PROGRAM FOR PLOTTING
C     THREE-DIMENSIONAL ANTENNA PATTERNS," IEEE ANTENNAS AND PROPAGATION
C     SOCIETY NEWSLETTER, VOL. 31, NO. 6, PP. 6-11, DECEMBER 1989.
C
C     DETERMINES THE POINT (XX,YY) WHICH DIVIDES THE PARTIALLY HIDDEN LINE
C     SEGMENT (XV,YV)-(XH,YH) INTO A COMPLETELY VISIBLE LINE SEGMENT
C     (XV,YV)-(XX,YY) AND A COMPLETELY HIDDEN LINE SEGMENT (XX,YY)-(XH,YH).
      REAL X(IDIM,JDIM),Y(IDIM,JDIM),Z(IDIM,JDIM),LENGTH
      INTEGER IHID(IDIM,JDIM)
      NIM1=NI-1
      NJM1=NJ-1
      XH=X(IH,JH)
      YH=Y(IH,JH)
      ZH=Z(IH,JH)
      XV=X(IV,JV)
      YV=Y(IV,JV)
      ZV=Z(IV,JV)
      XX=XV
      YY=YV
      XVH=XV-XH
      YVH=YV-YH
      LENGTH=SQRT(XVH*XVH+YVH*YVH)
      IF (LENGTH.LT.1.E-2) RETURN
      XT=XV+(XH-XV)*1.E-6/LENGTH
      YT=YV+(YH-YV)*1.E-6/LENGTH
      ZT=ZV+(ZH-ZV)*1.E-6/LENGTH
      DI=IH-IV
      DJ=JH-JV
      I4=IV-DI
      J4=JV-DJ
      IF(I4.EQ.0.OR.I4.EQ.NI+1.OR.J4.EQ.0.OR.J4.EQ.NJ+1) THEN
        ITEST=0
        IF(ICUT.NE.0) THEN
          DO 5 J=1,NJ,NJM1
            IF(ICUT.EQ.2)THEN
              X0=XP0
              Y0=YP0
              Z0=ZP0
            ELSE
              X0=X(1,J)
              Y0=Y(1,J)
              Z0=Z(1,J)
            END IF
            DO 5 I=1,NIM1
              X1=X(I,J)
              Y1=Y(I,J)
              Z1=Z(I,J)
              X2=X(I+1,J)
              Y2=Y(I+1,J)
              Z2=Z(I+1,J)
              CALL INSIDT(INSIDE,XT,YT,X0,Y0,X1,Y1,X2,Y2)
              IF(INSIDE.EQ.1) THEN
                IF(ZT.LT.ZEVAL(XT,YT,X0,Y0,Z0,X1,Y1,Z1,X2,Y2,Z2)) THEN
                  ITEST=MOD(ITEST+INSIDE,2)
                END IF
              END IF
    5     CONTINUE
        END IF
        IF(ITEST.EQ.1) THEN
          RETURN
        ELSE
          GOTO 65
        END IF
      END IF
      X4=X(I4,J4)
      Y4=Y(I4,J4)
      Z4=Z(I4,J4)
      IF ((IV.EQ.1.OR.IV.EQ.NI) .AND. (DJ.NE.0)) GOTO 10
      IF ((JV.EQ.1.OR.JV.EQ.NJ) .AND. (DI.NE.0)) GOTO 20
      I1=IV-DJ
      J1=JV-DI
      I2=IV+DJ
      J2=JV+DI
      I3=IV+DJ-DI
      J3=JV+DI-DJ
      I5=IV-DJ-DI
      J5=JV-DI-DJ
      GOTO 50
   10 CONTINUE
      IF(ABS(X(1,JV)-X(NI,JV))+ABS(Y(1,JV)-Y(NI,JV))+
     &                         ABS(Z(1,JV)-Z(NI,JV)).GT.1.E-4) GOTO 30
      I1=2
      J1=JV
      I2=NI-1
      J2=JV
      I3=NI-1
      J3=JV-DJ
      I5=2
      J5=JV-DJ
      GOTO 50
   20 CONTINUE
      IF(ABS(X(IV,1)-X(IV,NJ))+ABS(Y(IV,1)-Y(IV,NJ))+
     &                         ABS(Z(IV,1)-Z(IV,NJ)).GT.1.E-4) GOTO 40
      I1=IV
      J1=2
      I2=IV
      J2=NJ-1
      I3=IV-DI
      J3=NJ-1
      I5=IV-DI
      J5=2
      GOTO 50
   30 CONTINUE
      J1=JV
      J5=JV-DJ
      IF (IV.EQ.1) THEN
        I1=2
        I5=2
      ELSE
        I1=NI-1
        I5=NI-1
      END IF
      GOTO 60
   40 CONTINUE
      I1=IV
      I5=IV-DI
      IF (JV.EQ.1) THEN
        J1=2
        J5=2
      ELSE
        J1=NJ-1
        J5=NJ-1
      END IF
      GOTO 60
   50 CONTINUE
      X2=X(I2,J2)
      Y2=Y(I2,J2)
      Z2=Z(I2,J2)
      X3=X(I3,J3)
      Y3=Y(I3,J3)
      Z3=Z(I3,J3)
      CALL INSIDT(INSID1,XT,YT,XV,YV,X2,Y2,X3,Y3)
      CALL INSIDT(INSID2,XT,YT,XV,YV,X3,Y3,X4,Y4)
      IF (MOD(INSID1+INSID2,2).EQ.1) THEN
        ZC=ZPOINT(XT,YT,XV,YV,ZV,X2,Y2,Z2,X3,Y3,Z3,X4,Y4,Z4,INSID1)
        IF (ZT.LT.ZC) RETURN
      ENDIF
   60 CONTINUE
      X1=X(I1,J1)
      Y1=Y(I1,J1)
      Z1=Z(I1,J1)
      X5=X(I5,J5)
      Y5=Y(I5,J5)
      Z5=Z(I5,J5)
      CALL INSIDT(INSID1,XT,YT,XV,YV,X1,Y1,X5,Y5)
      CALL INSIDT(INSID2,XT,YT,XV,YV,X5,Y5,X4,Y4)
      IF (MOD(INSID1+INSID2,2).EQ.1) THEN
        ZC=ZPOINT(XT,YT,XV,YV,ZV,X1,Y1,Z1,X5,Y5,Z5,X4,Y4,Z4,INSID1)
        IF (ZT.LT.ZC) RETURN
      ENDIF
   65 CONTINUE
      XX=XH
      YY=YH
      XMIN=AMIN1(XV,XH)
      XMAX=AMAX1(XV,XH)
      YMIN=AMIN1(YV,YH)
      YMAX=AMAX1(YV,YH)
      ZMIN=AMIN1(ZV,ZH)
      TMAX=0
      DO 80 L=1,2
        IL=L-1
        JL=2-L
        NIL=NI-IL
        NJL=NJ-JL
        DO 80 I=1,NIL
        DO 80 J=1,NJL
          IF(IHID(I,J).EQ.1.AND.IHID(I+IL,J+JL).EQ.1)GO TO 70
          IF((I.EQ.IH.AND.J.EQ.JH).OR.(I+IL.EQ.IH.AND.J+JL.EQ.JH)
     &   .OR.(I.EQ.IV.AND.J.EQ.JV).OR.(I+IL.EQ.IV.AND.J+JL.EQ.JV))
     &                                           GO TO 70
          X1=X(I,J)
          Y1=Y(I,J)
          Z1=Z(I,J)
          X2=X(I+IL,J+JL)
          Y2=Y(I+IL,J+JL)
          Z2=Z(I+IL,J+JL)
          IF((X1.LT.XMIN.AND.X2.LT.XMIN).OR.(X1.GT.XMAX.AND.X2.GT.XMAX)
     &   .OR.(Y1.LT.YMIN.AND.Y2.LT.YMIN).OR.(Y1.GT.YMAX.AND.Y2.GT.YMAX)
     &   .OR.(Z1.LT.ZMIN.AND.Z2.LT.ZMIN)) GO TO 70
          X21=X2-X1
          Y21=Y2-Y1
          DENOM=X21*YVH-XVH*Y21
          IF(ABS(DENOM).LT.1.E-10) GO TO 70
          XP=(X21*XVH*(Y1-YH)-X1*XVH*Y21+XH*X21*YVH)/DENOM
          YP=(Y21*YVH*(X1-XH)-Y1*YVH*X21+YH*Y21*XVH)/(-DENOM)
          IF((X1-XP)*(X2-XP)+(Y1-YP)*(Y2-YP).GE.0) GO TO 70
          IF((XH-XP)*(XV-XP)+(YH-YP)*(YV-YP).GE.0) GO TO 70
          ZL=ZH+(ZV-ZH)*((XP-XH)*XVH+(YP-YH)*YVH)/
     &                  (XVH*XVH+YVH*YVH)
          ZT=Z1+(Z2-Z1)*((XP-X1)*X21+(YP-Y1)*Y21)/
     &                  (X21*X21+Y21*Y21)
          IF(ZL.GT.ZT) GO TO 70
          TEST=(XP-XH)*(XP-XH)+(YP-YH)*(YP-YH)
          IF(TEST.LT.TMAX) GO TO 70
            TMAX=TEST
            XX=XP
            YY=YP
   70     CONTINUE
   80 CONTINUE
      RETURN
      END
      SUBROUTINE AXIS3D(ALGTH,ASPACE,X,Y,Z,NI,NJ,IDIM,JDIM,
     &                                        IHID,THETAV,PHIV)
C     (C) COPYRIGHT WAYMOND R. SCOTT, JR., 1987
C     DESCRIBED IN THE PAPER W.R. SCOTT, JR., "A GENERAL PROGRAM FOR PLOTTING
C     THREE-DIMENSIONAL ANTENNA PATTERNS," IEEE ANTENNAS AND PROPAGATION
C     SOCIETY NEWSLETTER, VOL. 31, NO. 6, PP. 6-11, DECEMBER 1989.
C
C     DRAWS THE X, Y, AND Z AXES. THE AXES STOP A DISTANCE ASPACE AWAY
C     FROM THE EDGE OF THE GRAPH SO THEY WILL NOT OVERLAP THE GRAPH.
      REAL X(IDIM,JDIM),Y(IDIM,JDIM),Z(IDIM,JDIM)
      INTEGER IHID(IDIM,JDIM)
      COMMON/PLTLIM/XVMIN,XVMAX,YVMIN,YMVAX,SCALE,XTRAN,YTRAN
      XH=0.
      YH=0.
      ZH=0.
      DO 90 M=1,3
        XV=1.E-4
        YV=1.E-4
        ZV=1.E-4
        IF(M.EQ.1) XV=ALGTH
        IF(M.EQ.2) YV=ALGTH
        IF(M.EQ.3) ZV=ALGTH
        CALL PROJ(XV,YV,ZV,XV,YV,ZV,THETAV,PHIV)
        XVH=XV-XH
        YVH=YV-YH
        XX=XH
        YY=YH
        XMIN=AMIN1(XV,XH)
        XMAX=AMAX1(XV,XH)
        YMIN=AMIN1(YV,YH)
        YMAX=AMAX1(YV,YH)
        TMAX=0
        DO 80 L=1,2
          IL=L-1
          JL=2-L
          NIL=NI-IL
          NJL=NJ-JL
          DO 80 I=1,NIL
          DO 80 J=1,NJL
            IF(IHID(I,J).EQ.1.AND.IHID(I+IL,J+JL).EQ.1)GO TO 70
            X1=X(I,J)
            Y1=Y(I,J)
            Z1=Z(I,J)
            X2=X(I+IL,J+JL)
            Y2=Y(I+IL,J+JL)
            Z2=Z(I+IL,J+JL)
            IF((X1.LT.XMIN.AND.X2.LT.XMIN).OR.
     &      (X1.GT.XMAX.AND.X2.GT.XMAX).OR.(Y1.LT.YMIN.AND.Y2.LT.YMIN)
     &      .OR.(Y1.GT.YMAX.AND.Y2.GT.YMAX)) GO TO 70
            X21=X2-X1
            Y21=Y2-Y1
            DENOM=X21*YVH-XVH*Y21
            IF(ABS(DENOM).LT.1.E-10) GO TO 70
            XP=(X21*XVH*(Y1-YH)-X1*XVH*Y21+XH*X21*YVH)/DENOM
            YP=(Y21*YVH*(X1-XH)-Y1*YVH*X21+YH*Y21*XVH)/(-DENOM)
            IF((X1-XP)*(X2-XP)+(Y1-YP)*(Y2-YP).GE.0) GO TO 70
            TEST=(XP-XH)*(XP-XH)+(YP-YH)*(YP-YH)
            IF(TEST.GT.TMAX) THEN
              TMAX=TEST
              XX=XP
              YY=YP
            END IF
   70     CONTINUE
   80   CONTINUE
        XX=XX*1.1
        YY=YY*1.1
C        XX=XX+ASPACE*XV/SQRT(XV*XV+YV*YV)
C        YY=YY+ASPACE*YV/SQRT(XV*XV+YV*YV)
        XAMIN=-XTRAN/SCALE*.95
        XAMAX=(GSXLCM()-XTRAN)/SCALE*.95
        YAMIN=-YTRAN/SCALE*.95
        YAMAX=(GSYLCM()-YTRAN)/SCALE*.95
        IF(XV.LT.XAMIN)THEN
           YV=YV*XAMIN/XV
           XV=XAMIN
        ELSE IF(XV.GT.XAMAX)THEN
           YV=YV*XAMAX/XV
           XV=XAMAX
        END IF
        IF(YV.LT.YAMIN)THEN
           XV=XV*YAMIN/YV
           YV=YAMIN
        ELSE IF(YV.GT.YAMAX)THEN
           XV=XV*YAMAX/YV
           YV=YAMAX
        END IF
        CALL PLOT(XX,YY,3)
        CALL PLOT(XV,YV,2)
   90 CONTINUE
      RETURN
      END
      SUBROUTINE SORT(A,N,B,NDIM)
C     SORTS ARRAY A INTO INCREASING ORDER WITH THE PERMITATIONS STORED
C     IN THE ARRAY B.
C     ARRAYS IU(K) AND IL(K) PERMIT SORTING UP TO 2**(K+1)-1 ELEMENTS.
C     THIS SUBROUTINE IS A MODIFIED VERSION OF THE THE SUBROUTINE SORT
C     WRIITEN BY RICHARD C. SINGLETON, "AN EFFICIENT ALGORITHM FOR SORTING
C     WITH MINIMAL STORAGE," COLLECTED ALGORITMS FROM CACM, ALGORITHM 347.
      REAL    A(NDIM),T ,TT
      INTEGER B(NDIM),TB,TTB,IU(21),IL(21)
      II=1
      JJ=N
      M=1
      I=II
      J=JJ
    5 IF(I .GE. J) GO TO 70
   10 K=I
      IJ=(J+I)/2
      T=A(IJ)
      TB=B(IJ)
      IF(A(I) .LE. T) GO TO 20
      A(IJ)=A(I)
      A(I) = T
      T=A(IJ)
      B(IJ)=B(I)
      B(I)=TB
      TB=B(IJ)
   20 L=J
      IF(A(J) .GE. T) GO TO 40
      A(IJ)=A(J)
      A(J)=T
      T=A(IJ)
      B(IJ)=B(J)
      B(J)=TB
      TB=B(IJ)
      IF(A(I) .LE. T) GO TO 40
      A(IJ)=A(I)
      A(I)=T
      T=A(IJ)
      B(IJ)=B(I)
      B(I)=TB
      TB=B(IJ)
      GO TO 40
   30 A(L)=A(K)
      A(K)=TT
      B(L)=B(K)
      B(K)=TTB
   40 L=L-1
      IF(A(L) .GT. T) GO TO 40
      TT=A(L)
      TTB=B(L)
   50 K=K+1
      IF(A(K) .LT. T) GO TO 50
      IF(K .LE. L) GO TO 30
      IF(L-I .LE. J-K) GO TO 60
      IL(M)=I
      IU(M)=L
      I=K
      M=M+1
      GO TO 80
   60 IL(M)=K
      IU(M)=J
      J=L
      M=M+1
      GO TO 80
   70 M=M-1
      IF(M .EQ. 0)RETURN
      I=IL(M)
      J=IU(M)
   80 IF(J-I .GE. 11) GO TO 10
      IF(I .EQ. II) GO TO 5
      I=I-1
   90 I=I+1
      IF(I .EQ. J) GO TO 70
      T=A(I+1)
      TB=B(I+1)
      IF(A(I) .LE. T) GO TO 90
      K=I
  100 A(K+1)=A(K)
      B(K+1)=B(K)
      K=K-1
      IF(T .LT. A(K)) GO TO 100
      A(K+1)=T
      B(K+1)=TB
      GO TO 90
      END
      SUBROUTINE PLOTC(I,J,X,Y,IX)
      SAVE
      PARAMETER (IDIM=182,JDIM=362)
      COMMON/GPAT/ GV(IDIM,JDIM),GH(IDIM,JDIM),GT(IDIM,JDIM),
     &ETPH(IDIM,JDIM),EPPH(IDIM,JDIM),AXRAT(IDIM,JDIM),THETA(IDIM),
     &PHIA(JDIM),GVMAX,GHMAX,GTMAX,IGVTMX,IGVPMX,IGHTMX,IGHPMX,IGTTMX,
     &IGTPMX,NATH,NAPH
      COMMON/SET3DC/THETAD,PHID,GRANGE,IGVHT,IPHAZ
      IF(IPHAZ.NE.0.AND.IX.EQ.2)THEN
         IF(IGVHT.EQ.1.OR.IGVHT.EQ.4)THEN
            PHAZ=PHAVG(ETPH(ISAVE,JSAVE),ETPH(I,J))
            CALL HTORGB(PHAZ/360.,RED,GRN,BLU)
         ELSE IF(IGVHT.EQ.2.OR.IGVHT.EQ.5)THEN
            PHAZ=PHAVG(EPPH(ISAVE,JSAVE),EPPH(I,J))
            CALL HTORGB(PHAZ/360.,RED,GRN,BLU)
         ELSE IF(IGVHT.EQ.3.OR.IGVHT.EQ.6)THEN
            PHAZ=AXAVG(AXRAT(ISAVE,JSAVE),AXRAT(I,J))
            CALL HTORGB(PHAZ,RED,GRN,BLU)
         END IF
         CALL GSDRGB(7,RED*100.,GRN*100.,BLU*100.,IERR)
         CALL GSCOLR(7,IERR)
      END IF
      CALL PLOT(X,Y,IX)
      ISAVE=I
      JSAVE=J
      RETURN
      END
      SUBROUTINE AXLGND(X0,Y0,XLEN)
      NC=40
      DX=XLEN/(NC-1)
      DC=2./(NC-1)
      X=X0
      COL=-1.
      CALL PLOT(X0,Y0,3)
      DO I=1,NC
         IF(I.GT.1)THEN
            X=X+DX
            COL=COL+DC
         END IF
         HUE=AXAVG(COL,COL)
         CALL HTORGB(HUE,RED,GRN,BLU)
         CALL GSDRGB(7,RED*100.,GRN*100.,BLU*100.,IERR)
         IF(IERR.NE.0)RETURN
         CALL GSCOLR(7,IERR)
         CALL PLOT(X,Y0,2)
      END DO
      CALL GSCOLR(1,IERR)
      CHRSZ=GOODCS(.04)
      CALL GSSETC(CHRSZ,0.)
      CALL GSMOVE(X0+.1,Y0-.6)
      CALL GSPSTC('l.h.p.'//CHAR(0))
      CALL GSMOVE(X0+.5*XLEN-1.8,Y0-.6)
      CALL GSPSTC('Axial Ratio'//CHAR(0))
      CALL GSMOVE(X0+XLEN-1.8,Y0-.6)
      CALL GSPSTC('r.h.p.'//CHAR(0))
      CALL GSMOVE(X0-.1,Y0+.2)
      CALL GSPSTC('1'//CHAR(0))
      CALL GSMOVE(X0+.5*XLEN-.1,Y0+.2)
      CALL GSPSTC('0'//CHAR(0))
      CALL GSMOVE(X0+XLEN-.1,Y0+.2)
      CALL GSPSTC('1'//CHAR(0))
      RETURN
      END
      SUBROUTINE PHLGND(X0,Y0,XLEN)
      NC=40
      DX=XLEN/(NC-1)
      DC=360./(NC-1)
      X=X0
      COL=-180.
      CALL PLOT(X0,Y0,3)
      DO I=1,NC
         IF(I.GT.1)THEN
            X=X+DX
            COL=COL+DC
         END IF
         HUE=PHAVG(COL,COL)/360.
         CALL HTORGB(HUE,RED,GRN,BLU)
         CALL GSDRGB(7,RED*100.,GRN*100.,BLU*100.,IERR)
         IF(IERR.NE.0)RETURN
         CALL GSCOLR(7,IERR)
         CALL PLOT(X,Y0,2)
      END DO
      CALL GSCOLR(1,IERR)
      CHRSZ=GOODCS(.04)
      CALL GSSETC(CHRSZ,0.)
      CALL GSMOVE(X0+.5*XLEN-.8,Y0-.6)
      CALL GSPSTC('Phase'//CHAR(0))
      CALL GSMOVE(X0-.6,Y0+.2)
      CALL GSPSTC('-180'//CHAR(0))
      CALL GSMOVE(X0+.5*XLEN-.1,Y0+.2)
      CALL GSPSTC('0'//CHAR(0))
      CALL GSMOVE(X0+XLEN-.4,Y0+.2)
      CALL GSPSTC('180'//CHAR(0))
      RETURN
      END
      FUNCTION PHAVG(PH1,PH2)
C
C     PHAVG averages the phases PH1 and PH2 and attempts to correct
C     when the values wrap around from + to - 180 degrees.
C
      PHAVG=.5*(PH1+PH2)
      IF(ABS(PH2-PH1).GT.160.)PHAVG=PHAVG+180.
      IF(PHAVG.GT.180.)PHAVG=PHAVG-360.
      RETURN
      END
      FUNCTION AXAVG(AX1,AX2)
C
C     AXAVG averages the axial ratios and reduces the range so that the
C     ends of the range (l.h.p. and r.h.p.) have unique colors.
C
      AXAVG=.35*.5*(AX1+AX2)
      RETURN
      END
      SUBROUTINE PLOT(X,Y,IX)
      IF(IX.EQ.3)THEN
         CALL GSMOVE(X,Y)
      ELSE IF(IX.EQ.2)THEN
         CALL GSDRAW(X,Y)
      ELSE IF(IX.EQ.999)THEN
         CALL ENDPLT
         CALL RLSDEV
         CALL POSTDMP
      ELSE IF(IX.EQ.-3)THEN
C     DIGLIB:
      CALL DEVSEL(1,4,IERR)
      CALL BGNPLT
C      CALL GSETLW(.25)
      END IF
      RETURN
      END
      SUBROUTINE HTORGB(HUE,RED,GRN,BLU)
C
C     HTORGB converts HUE to RGB color.
C
      DATA BRK1,BRK2,BRK3,BRK4,BRK5/.166667,.333333,.5,.666667,.833333/
      HUEX=HUE-INT(HUE)
      IF(HUEX.LT.0.)HUEX=HUEX+1.
      IF(HUEX.LT.BRK1)THEN
         RED=1.
         GRN=HUEX/BRK1
         BLU=0.
      ELSE IF(HUEX.LT.BRK2)THEN
         RED=(BRK2-HUEX)/(BRK2-BRK1)
         GRN=1.
         BLU=0.
      ELSE IF(HUEX.LT.BRK3)THEN
         RED=0.
         GRN=1.
         BLU=(HUEX-BRK2)/(BRK3-BRK2)
      ELSE IF(HUEX.LT.BRK4)THEN
         RED=0.
         GRN=(BRK4-HUEX)/(BRK4-BRK3)
         BLU=1.
      ELSE IF(HUEX.LT.BRK5)THEN
         RED=(HUEX-BRK4)/(BRK5-BRK4)
         GRN=0.
         BLU=1.
      ELSE IF(HUEX.LE.1.)THEN
         RED=1.
         GRN=0.
         BLU=(1.-HUEX)/(1.-BRK5)
      END IF
      RETURN
      END
