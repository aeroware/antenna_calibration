      PROGRAM TESTER
C
C Rules for converting this program to sun and tops
C    for sun:  change all byte to character*1
C              change text: ctrl-z to ctrl-d
C              note that once ctrl-d is typed all reads receive ctrl-d
C    for tops: change all byte to character*1
C              change len to lenstr and delete line: external len
C
      DIMENSION AREA(30)
      DIMENSION Y(101)
      DIMENSION Y1(101), Y2(101)
C
      DIMENSION DEVCHR(10)
      DIMENSION IBIT(12)

      CHARACTER*1 BCHAR
      CHARACTER*1 ICHAR
      CHARACTER*1 NAME(40)
      EXTERNAL LEN
C
      COMMON /TESCOM/ LUIN,LUOUT

      DIMENSION XVERTS(4),YVERTS(4),XT(4),YT(4)
      DATA XVERTS/12.,12.,16.,16./
      DATA YVERTS/2.5,6.5,6.5,2.5/
      DATA NVERTS/4/

      LUIN=5
      LUOUT=6
C                LOOP TO GET NAMES OF ALL DIGLIB DEVICES
      WRITE(LUOUT,508)
  508 FORMAT(/,' DIGLIB Devices are:')
      NDEV=1
   98 CONTINUE
      CALL GSDNAM(NDEV,NAME)
      NCHARS=LEN(NAME)
      IF(NCHARS.EQ.0) GO TO 99
      WRITE(LUOUT,509) NDEV,(NAME(I),I=1,NCHARS)
  509 FORMAT(' ',I2,': ',40A1)
      NDEV=NDEV+1
      GO TO 98
C
   99 CONTINUE
      NDEV=NDEV-1
      WRITE(LUOUT,520)
  520 FORMAT(/,'$ DIGLIB device number (I2)? >')
  400 CONTINUE
      READ(LUIN,530,END=900,ERR=400) IDEV
  530 FORMAT(I2)
      IF (IDEV.LT.1 .OR. IDEV.GT.NDEV)  GOTO 400
      CALL DEVSEL(IDEV,4,IERR)
      IF (IERR .NE. 0) STOP
C
C put up menu to select desired test
  899 CONTINUE
  445 CONTINUE
  444 CONTINUE
      CALL BGNPLT
      CALL ENDPLT
      WRITE(LUOUT,540)
  540 FORMAT(/,'   0) ALL',/,
     $  '   1) Circle',/,
     $  '   2) Box + Char Set in color',/,
     $  '   3) Two Plots with SAVMAP',/,
     $  '   4) Dash and Fill',/,
     $  '   5) Right and Left Y-axes',/,
     $  '   6) Graphics Input (Screen Coords)',/,
     $  '   7) Graphics Input (World Coords)',/,
     $  '   8) Viewporting and Release/Re-initialize',/,
     $  '   9) Device Characteristics',/,
     $   /,'$ Choice (ctrl-z = quit)?> ')

      READ (LUIN,545,END=895,ERR=444) ISEL
  545 FORMAT(I1)

      IF(ISEL.LT.0 .OR. ISEL.GT.9) GO TO 445

      IF(ISEL.NE.1 .AND. ISEL.NE.0) GO TO 810

      CALL BGNPLT
COMMENT---- draw a circle
      CALL GSMOVE(0.5,.75)
      CALL GSSETC(GOODCS(.3),0.0)
      CALL GSPSTR('Test: Draw a Circle'//char(0))
      XSTART=.5*GSXLCM(0)
      YSTART=.25*GSYLCM(0)
      CALL GSMOVE(XSTART, YSTART)
      TWOPI=8.*ATAN(1.)
      RADIUS=GSXLCM(0)
      IF(GSXLCM(0).GT.GSYLCM(0)) RADIUS=GSYLCM(0)
      RADIUS=.333*RADIUS
      FACTOR=TWOPI/90
      DO 111 I=0,90
            XVAL=XSTART+RADIUS*SIN(FACTOR*I)
            YVAL=YSTART+RADIUS*(1.-COS(FACTOR*I))
            CALL GSDRAW(XVAL,YVAL)
  111 CONTINUE
      CALL PAUSE
C
  810 CONTINUE
      IF(ISEL.NE.2 .AND. ISEL.NE.0) GO TO 820

      CALL BGNPLT
COMMENT---- draw two lines at 45 degrees to look for gliches
      SIDE=GSXLCM(0) - .1
      IF(GSXLCM(0).GT.GSYLCM(0)) SIDE=GSYLCM(0) - .1
      CALL GSMOVE(.1,.1)
      CALL GSDRAW(SIDE,SIDE)
      CALL GSMOVE(.1,SIDE)
      CALL GSDRAW(SIDE,.1)
C
COMMENT---- draw a box .1cm smaller than the max
      EPS=.1
      CALL GSMOVE(EPS,EPS)
      CALL GSDRAW(GSXLCM(0)-EPS, EPS)
      CALL GSDRAW(GSXLCM(0)-EPS, GSYLCM(0)-EPS)
      CALL GSDRAW(EPS, GSYLCM(0)-EPS)
      CALL GSDRAW(EPS, EPS)
C
COMMENT---- draw the character set
      CALL GSMOVE(0.5,12.0)
      CALL GSSETC(GOODCS(0.1),0.0)
      CALL GSPSTR('Smallest goodcs: `abcdefghijklmnopqrstuvwxyz{|}'
     &//char(0))
      CALL GSMOVE(0.5,10.0)
      CALL GSSETC(GOODCS(1.0),0.0)
      CALL GSPSTR('abcdefghij'//char(0))
      CALL GSMOVE(0.5,8.0)
      CALL GSPSTR('klmnopqrst'//char(0))
      CALL GSMOVE(0.5,6.0)
      CALL GSPSTR('uvwxyz{|}'//char(0))
C
      CALL GSSETC(GOODCS(0.1),0.0)
      CALL GSMOVE(0.5,5.)
      CALL GSCOLR(1,IERR)
      CALL GSPSTR('DIGLIB colors:'//char(0))
      CALL GSMOVE(5.,4.)
      CALL GSCOLR(2,IERR)
      CALL GSPSTR('Red'//char(0))
      CALL GSMOVE(10.,4.)
      CALL GSCOLR(3,IERR)
      CALL GSPSTR('Green'//char(0))
      CALL GSMOVE(15.,4.)
      CALL GSCOLR(4,IERR)
      CALL GSPSTR('Blue'//char(0))
      CALL GSMOVE(5.,2.)
      CALL GSCOLR(5,IERR)
      CALL GSPSTR('Yellow'//char(0))
      CALL GSMOVE(10.,2.)
      CALL GSCOLR(6,IERR)
      CALL GSPSTR('Magenta'//char(0))
      CALL GSMOVE(15.,2.)
      CALL GSCOLR(7,IERR)
      CALL GSPSTR('Cyan'//char(0))
      CALL GSCOLR(1,IERR)
      CALL PAUSE
C
C*****************************************
C
  820 CONTINUE
      IF(ISEL.NE.3 .AND. ISEL.NE.0) GO TO 830
C
      CALL BGNPLT
C
      CALL MAPSIZ(0.0,100.0,0.0,47.5,goodcs(0.))
      CALL MAPIT(0.0,10.0,0.0,100.0,'X AXIS'//char(0),'Y AXIS'//char(0),
     &'PLOT 1'//char(0),0)
      CALL SAVMAP(AREA(1))
C
      CALL MAPSIZ(0.0,100.0,52.5,100.0,goodcs(0.))
      CALL MAPIT(0.0,10.0,0.0,1000.0,'X AXIS'//char(0),'Y AXIS'//char(0)
     &,'PLOT 2'//char(0),0)
      CALL SAVMAP(AREA(16))
C
      DO 100 I=1,101
            X = (I-1)/10.0
            Y1(I) = X**2
            Y2(I) = X**3
  100 CONTINUE
C
      CALL RSTMAP(AREA(1))
      CALL TRACEY(0.0,10.0,Y1,101)
      CALL RSTMAP(AREA(16))
      CALL TRACEY(0.0,10.0,Y2,101)
      CALL PAUSE
C
C*****************************************
C  DASH AND FILL
C*****************************************
C
  830 CONTINUE
      IF(ISEL.NE.4 .AND. ISEL.NE.0) GO TO 840
      CALL BGNPLT
      CALL GSLTYP(2)
      DO 101 I=1,10
            CALL GSMOVE(1.0,FLOAT(I))
            CALL GSDRAW(10.0-FLOAT(I)/10.0,FLOAT(I))
  101 CONTINUE
      CALL GSLTYP(1)
CCC      DO 102 I=1,400
CCC            XYINC=.01*FLOAT(I-1)
CCC            CALL GSMOVE(12.,1.+XYINC)
CCC            CALL GSDRAW(16.,1.+XYINC)
CCC            CALL GSMOVE(12.+XYINC,6.)
CCC            CALL GSDRAW(12.+XYINC,10.)
CCC  102 CONTINUE
      CALL GSFILL(XVERTS,YVERTS,NVERTS,XT,YT)
      CALL PAUSE
C
C*****************************************
C  RIGHT Y-AXIS TEST
C*****************************************
C
  840 CONTINUE
      IF(ISEL.NE.5 .AND. ISEL.NE.0) GO TO 850
C
      IAXES=2
      XMIN = 0.0
      XMAX = 100.0
      DX = 1.0
      DO 103 I=1,101
            X = I-1
            Y(I) = (X-50)**2/250.0
            Y2(I) = 10.0+X**2
  103 CONTINUE
      CALL MINMAX(Y,101,YMIN1,YMAX1)
      CALL MINMAX(Y2,101,YMIN2,YMAX2)
      CALL BGNPLT
      CALL MAPSZ2(0.0,100.0,0.0,80.0,0.0)
      CALL MAPIT(XMIN,XMAX,YMIN1,YMAX1,'X AXIS'//char(0),
     &'LEFT Y AXIS'//char(0),'PLOT TITLE'//char(0),0)
      CALL CURVEY(XMIN,XMAX,Y,101,3,0.3,10)
      CALL SYAXIS(YMIN2,YMAX2,'RIGHT Y AXIS'//char(0),IAXES)
      CALL CURVEY(XMIN,XMAX,Y2,101,4,0.3,15)
      CALL PAUSE
C
C*****************************************
C   GRAPHICS INPUT TEST
C*****************************************
C
  850 CONTINUE
      IF(ISEL.NE.6 .AND. ISEL.NE.0) GO TO 860
C
      CALL BGNPLT
      CALL GSMOVE(0.5,10.0)
      CALL GSSETC(GOODCS(.3),0.0)
      CALL GSPSTR(
     $  'Graphics Input (GIN) test (space=again non-space=quit)')
   15 CALL GSGIN(XIN,YIN,BCHAR,IERR)
      CALL GSMOVE(1.0,1.0)
      CALL GSDRAW(XIN,1.0)
      CALL GSDRAW(XIN,YIN)
      CALL GSDRAW(1.0,YIN)
      CALL GSDRAW(1.0,1.0)
      CALL ENDPLT
      WRITE(LUOUT,505) IERR,BCHAR
  505 FORMAT(' IERR = ',I4,'  Character is ',A1)
      WRITE(LUOUT,506) XIN,YIN
  506 FORMAT(' Position is (',G10.3,',',G10.3,')')
      IF(BCHAR.EQ.' ') GO TO 15
      CALL ENDPLT
C
C*****************************************
C   GIN PRINTING VALUES IN WORLD COORDINATES
C*****************************************
C
  860 CONTINUE
      IF(ISEL.NE.7 .AND. ISEL.NE.0) GO TO 870
C
      CALL BGNPLT
      CALL MAPSIZ(0.0,100.0,0.0,100.0,goodcs(0.))
      CALL MAPIT(-1.,2.0,-1.0,2.0,'X'//char(0),'Y'//char(0),
     1'VERTICES AT (0,0) and (1,1) -- space=again non-space=quit'
     &//char(0),0)
      CALL CLLINE(0.,0., 1.,0.)
      CALL CLLINE(1.,0., 1.,1.)
      CALL CLLINE(1.,1., 0.,1.)
      CALL CLLINE(0.,1., 0.,0.)
      CALL ENDPLT
  115 CALL CURSOR(XIN,YIN,ICHAR)
      WRITE(LUOUT,555) ICHAR
  555 FORMAT('  Character is ',a1)
      WRITE(LUOUT,554) XIN,YIN
  554 FORMAT(' Position in world coordinates is (',G10.3,',',G10.3,')')
      IF(ICHAR.EQ.' ') GO TO 115
      CALL ENDPLT
C
C*****************************************
C   VIEWPORTING AND COLOR
C*****************************************
C
  870 CONTINUE
      IF(ISEL.NE.8 .AND. ISEL.NE.0) GO TO 880
C
      DO 4100 I=1,101
            X = 9.0*(I-1)/100.0 + 1.0
            Y1(I) = X**2
            Y2(I) = X**3
 4100 CONTINUE
C
      CALL BGNPLT
C
      CALL MAPSIZ(0.0,48.5,52.5,100.0,goodcs(0.))
      CALL MAPIT(1.0,10.0,1.0,100.0,'X AXIS'//char(0),'Y AXIS'//char(0),
     &'PLOT 1'//char(0),0)
      CALL GSCOLR(2,IERR)
      CALL CURVEY(1.0,10.0,Y1,101,1,0.3,10)
C
C     Release and re-select the device to verify no screen erase
C       SIG is multi-tasked so screen must not erase between re-selects.
      CALL ENDPLT
      CALL RLSDEV
      CALL DEVSEL(IDEV,4,IERR)
C
      CALL GSCOLR(1,IERR)
      CALL MAPSIZ(51.5,100.0,52.5,100.0,goodcs(0.))
      CALL MAPIT(1.0,10.0,1.0,1000.0,'X AXIS'//char(0),'Y AXIS'//char(0)
     &,'PLOT 2'//char(0),0)
      CALL GSCOLR(3,IERR)
      CALL CURVEY(1.0,10.0,Y2,101,2,0.3,5)
      CALL GSCOLR(1,IERR)
      CALL MAPSIZ(0.0,100.0,0.0,47.5,goodcs(0.))
      CALL MAPIT(1.0,10.0,1.0,1000.0,'X AXIS'//char(0),'Y AXIS'//char(0)
     &,'PLOT 3'//char(0),2)
      CALL GSCOLR(4,IERR)
      CALL CURVEY(1.0,10.0,Y1,101,1,0.3,10)
      CALL GSCOLR(5,IERR)
      CALL CURVEY(1.0,10.0,Y2,101,2,0.3,5)
      CALL PAUSE
C
C*****************************************
C  PRINT DEVICE CHARACTERISTICS
C*****************************************
C
 880  CONTINUE
      IF(ISEL.NE.9 .AND. ISEL.NE.0) GO TO 890
C
      CALL GSDRVR(7,DEVCHR,DUMMY)
      ICBITS=DEVCHR(7)

      CALL BGNPLT
      CALL ENDPLT
      WRITE(LUOUT,5000)
5000  FORMAT(' DEVICE CHARACTERISTICS:')
      WRITE(LUOUT,5010) INT(DEVCHR(1)),(DEVCHR(I),I=2,5),INT(DEVCHR(6)),
     $  INT(DEVCHR(8))
5010  FORMAT(
     $   '               Device ID No.:',I5,
     $ /,'               X-length (cm):',G16.8,
     $ /,'               Y-length (cm):',G16.8,
     $ /,'    X-resolution (pixels/cm):',G16.8,
     $ /,'    Y-resolution (pixels/cm):',G16.8,
     $ /,' Number of Foreground Colors:',I5
     $ /,'    Pixel Increment for Fill:',I5
     $ ) 
      WRITE(LUOUT,5100)
5100  FORMAT(/,' DEVICE CHARACTERISTIC BITS:')

      DO 222 I=1,12
      IBIT(I)=0
 222  CONTINUE

      IBIT(1)=IAND(ICBITS,1)
      IF(IAND(ICBITS,2).GT.0) IBIT(2)=1
      IBIT(3)=IAND(ICBITS,3)
      IF(IAND(ICBITS,4).GT.0) IBIT(4)=1
      IF(IAND(ICBITS,8).GT.0) IBIT(5)=1
      IF(IAND(ICBITS,16).GT.0) IBIT(6)=1
      IF(IAND(ICBITS,32).GT.0) IBIT(7)=1
      IF(IAND(ICBITS,64).GT.0) IBIT(8)=1
      IF(IAND(ICBITS,128).GT.0) IBIT(9)=1
      IF(IAND(ICBITS,256).GT.0) IBIT(10)=1
      IF(IAND(ICBITS,512).GT.0) IBIT(11)=1
      IF(IAND(ICBITS,1024).GT.0) IBIT(12)=1

      WRITE(LUOUT,5110) (IBIT(I),I=1,12)

5110  FORMAT(5X,I1,' Stroke (plotter) device',
     $ /,5X,I1,' Raster Device',
     $ /,5X,I1,' Storage Tube',
     $ /,5X,I1,' Printer/Plotter (if value = 3)',
     $ /,5X,I1,' Background Color Draw Available',
     $ /,5X,I1,' Hardcopy Device',
     $ /,5X,I1,' Colors are HLS Selectable',
     $ /,5X,I1,' Colors are RGB Selectable',
     $ /,5X,I1,' Graphics Input with Pick Character is Available',
     $ /,5X,I1,' Device Has Hardware Polygon Fill',
     $ /,5X,I1,' Device Requires Convex Polygons for Hardware Fill',
     $ /,5X,I1,' Graphics Input with Buttons is Available',
     $ /) 

      WRITE(LUOUT,5200)
5200  FORMAT('$ Hit RETURN to continue> ')
      READ(LUIN,5210,END=896) DUMMY
5210  FORMAT(1X,A1)
C
C*****************************************
C  CLEAR THE SCREEN AND QUIT
C*****************************************
C
  890 CONTINUE
      IF(ISEL.NE.0) GO TO 899
  895 CONTINUE
  896 CONTINUE
C
      CALL BGNPLT
      CALL ENDPLT
      CALL RLSDEV
      WRITE(LUOUT,514)
 514  FORMAT(' All Done!!')
      STOP
C
C*****************************************
C   ERROR OR END
C*****************************************
C
  900 CONTINUE
      WRITE(LUOUT,515)
  515 FORMAT(' OK, I quit.')
      STOP
      END
C
C**************************************
C   PAUSE
C**************************************
C
      SUBROUTINE PAUSE
      COMMON /TESCOM/ LUIN,LUOUT
      CALL ENDPLT
      WRITE(LUOUT,500)
  500 FORMAT('$*')
      READ(LUIN,501,END=10) DUMMY
  501 FORMAT(1X,A1)
      RETURN
   10 CONTINUE
C -- Clear screen and quit 
      CALL BGNPLT
      CALL ENDPLT
      CALL RLSDEV
      WRITE(LUOUT,514)
 514  FORMAT(' OK, I quit.')
      STOP
      END
