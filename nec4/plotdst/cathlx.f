      PARAMETER (MAXSEG=1000)
      CHARACTER TXT*1
      COMMON /DATA/ LD,N1,N2,N,NP,M1,M2,M,MP,X(MAXSEG),Y(MAXSEG),
     &Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),ALP(MAXSEG),BET(MAXSEG),
     &ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),ICONX(MAXSEG),WLAM,IPSYM
      DIMENSION X2(1),Y2(1),Z2(1)
      EQUIVALENCE (X2,SI),(Y2,ALP),(Z2,BET)
      LD=MAXSEG
      N=0
      NP=0
      N1=0
      N2=0
1     WRITE(*,900)
900   FORMAT(/,' Enter C for Catenary, H for Spiral or Helix, E to ',
     &'end >',$)
      READ(*,'(A)')TXT
      CALL UPCASE(TXT,TXT,LENGTH)
      IF(TXT.NE.'C')GO TO 20
C
C     GENERATE SEGMENT DATA FOR A CATENARY WIRE
C
      WRITE(*,901)
901   FORMAT(/,' Catenary Wire',/,
     &' Enter coord. of first end (X1,Y1,Z1) >',$)
      READ(*,*)XW1,YW1,ZW1
      WRITE(*,902)
902   FORMAT(' Enter coord. of 2nd end   (X2,Y2,Z2) >',$)
      READ(*,*)XW2,YW2,ZW2
      WRITE(*,903)
903   FORMAT(' Enter the wire radius >',$)
      READ(*,*)RAD
      WRITE(*,904)
904   FORMAT(/,' Enter 1 to specify height at a midpoint',/,
     &7X,'2 to specify sag at a midpoint',/,
     &7X,'3 to specify the total wire length',/,' >',$)
      READ(*,*)ICAT
      IF(ICAT.EQ.1)THEN
         WRITE(*,905)
905      FORMAT(/,' Enter the horizontal distance to the specified ',
     &   'point',/,' and the height at that point',/,' (DIST,HGT) >',$)
         READ(*,*)DST,HGT
      ELSE IF(ICAT.EQ.2)THEN
         WRITE(*,906)
906      FORMAT(/,' Enter the horizontal distance to the specified ',
     &   'point ',/,' and the sag below a straight line at that point',
     &   /,' (DIST,SAG) >',$)
         READ(*,*)DST,HGT
      ELSE IF(ICAT.EQ.3)THEN
         WRITE(*,907)
907      FORMAT(/,' Enter the total wire length >',$)
         READ(*,*)DST
      ELSE
         WRITE(*,*)' Error in data entry'
         GO TO 1
      END IF
      WRITE(*,908)
908   FORMAT(/,' Enter the number of segments and the tag number',/,
     &' (NS,ITG) >',$)
      READ(*,*)NS,ITG
      CALL CATNRY(XW1,YW1,ZW1,XW2,YW2,ZW2,RAD,ICAT,DST,HGT,NS,ITG)
      GO TO 1
C
C     Generate spiral or helix
C
20    IF(TXT.EQ.'H')THEN
      WRITE(*,909)
909   FORMAT(/,' Enter 0 for a Log Spiral, 1 for an Archimedes Spiral >'
     &,$)
      READ(*,*)IHELIX
      IF(XW2.EQ.0.)XW2=ZW1
      IF(ZW2.EQ.0.)ZW2=YW2
      WRITE(*,910)
910   FORMAT(/,' Enter the number of turns and length along the Z axis',
     &/,' (NTURNS,LEN) >',$)
      READ(*,*)TURNS,ZLEN
      WRITE(*,911)
911   FORMAT(/,' Enter the initial and final radii of the spiral',
     &/,' (HRAD1,HRAD2) >',$)
      READ(*,*)HRAD1,HRAD2
      WRITE(*,912)
912   FORMAT(/,' Enter the initial and final radii of the wire',
     &/,' (WRAD1,WRAD2) >',$)
      READ(*,*)WRAD1,WRAD2
      WRITE(*,908)
      READ(*,*)NS,ITG
      CALL HELIX(IHELIX,TURNS,ZLEN,HRAD1,HRAD2,WRAD1,WRAD2,NS,ITG)
      GO TO 1
      ELSE IF(TXT.EQ.'E')THEN
         CALL GWOUT
      ELSE
         GO TO 1
      END IF
      END
      SUBROUTINE GWOUT
      PARAMETER (MAXSEG=1000)
      CHARACTER FNAME*60,FMT*90
      COMMON /DATA/ LD,N1,N2,N,NP,M1,M2,M,MP,X(MAXSEG),Y(MAXSEG),
     &Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),ALP(MAXSEG),BET(MAXSEG),
     &ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),ICONX(MAXSEG),WLAM,IPSYM
      DIMENSION X2(1),Y2(1),Z2(1)
      EQUIVALENCE (X2,SI),(Y2,ALP),(Z2,BET)
1     WRITE(*,90)
90    FORMAT(/,' Enter name of the output file >',$)
      READ(*,'(A)')FNAME  
      OPEN(UNIT=31,FILE=FNAME,STATUS='NEW',ERR=1)
      DO 2 I=1,N
      FMT='(''GW'',I3,'' 1'''
      NFM=13
      CALL FMTGEN(X(I),NFM,FMT)
      CALL FMTGEN(Y(I),NFM,FMT)
      CALL FMTGEN(Z(I),NFM,FMT)
      CALL FMTGEN(X2(I),NFM,FMT)
      CALL FMTGEN(Y2(I),NFM,FMT)
      CALL FMTGEN(Z2(I),NFM,FMT)
      CALL FMTGEN(BI(I),NFM,FMT)
      FMT=FMT(1:NFM)//')'
      WRITE(31,FMT)ITAG(I),X(I),Y(I),Z(I),X2(I),Y2(I),Z2(I),BI(I)
2     CONTINUE
      RETURN
      END
      SUBROUTINE FMTGEN(RNUM,NFM,FMAT)
C
C     FMTGEN generates a format with each number fitting into 10 fields.
C     E format is used for large and small numbers, while F format is
C     used to maximize precision when possible.
C
C     INPUT:
C     RNUM = the number to be written
C     NFM = the length of the format to which the new entry is appended
C
      CHARACTER FMAT*(*)
      ANUM=ABS(RNUM)
      IF(ANUM.GT.9999999.)THEN
         FMAT=FMAT(1:NFM)//',1PE10.2'
         NFM=NFM+8
      ELSE IF(ANUM.GT.999999.)THEN
         FMAT=FMAT(1:NFM)//',0PF10.0'
         NFM=NFM+8
      ELSE IF(ANUM.GT.99999.9)THEN
         FMAT=FMAT(1:NFM)//',0PF10.1'
         NFM=NFM+8
      ELSE IF(ANUM.GT.9999.99)THEN
         FMAT=FMAT(1:NFM)//',0PF10.2'
         NFM=NFM+8
      ELSE IF(ANUM.GT.999.999)THEN
         FMAT=FMAT(1:NFM)//',0PF10.3'
         NFM=NFM+8
      ELSE IF(ANUM.GT.99.9999)THEN
         FMAT=FMAT(1:NFM)//',0PF10.4'
         NFM=NFM+8
      ELSE IF(ANUM.GT.9.99999)THEN
         FMAT=FMAT(1:NFM)//',0PF10.5'
         NFM=NFM+8
      ELSE IF(ANUM.GT..000999)THEN
         FMAT=FMAT(1:NFM)//',0PF10.6'
         NFM=NFM+8
      ELSE
         FMAT=FMAT(1:NFM)//',1PE10.2'
         NFM=NFM+8
      END IF
      RETURN
      END
      SUBROUTINE CATNRY(XW1,YW1,ZW1,XW2,YW2,ZW2,RAD,ICT,RHMP,ZMP,NS,ITG)
C
C     Purpose:
C     CATNRY generates segment geometry data for a wire with NS segments
C     in the shape of a catenary.
C
C     INPUT:
C     XW1,YW1,ZW1 = starting point of the catenary
C     XW2,YW2,ZW2 = final point of the catenary
C     RAD = wire radius
C     ICT = flag to set method of determining the catenary shape
C     RHMP = horizontal distance from (XW1,YW1,ZW1) to a point along
C            the catenary for ICT=1 or 2; catenary length for ICT=3.
C     ZMP = height of the catenary at the distance RHMP for ICT=1 or 2.
C     NS = number of segments along the catenary
C     ITG = tag number for segments
C
      PARAMETER (MAXSEG=1000)
      COMMON /DATA/ LD,N1,N2,N,NP,M1,M2,M,MP,X(MAXSEG),Y(MAXSEG),
     &Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),ALP(MAXSEG),BET(MAXSEG),
     &ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),ICONX(MAXSEG),WLAM,IPSYM
      DIMENSION X2(1), Y2(1), Z2(1)
      EQUIVALENCE (X2(1),SI(1)), (Y2(1),ALP(1)), (Z2(1),BET(1))
      IST=N+1
      N=N+NS
      NP=N
      IPSYM=0
      IF (NS.LT.1) RETURN
      X(IST)=XW1
      Y(IST)=YW1
      Z(IST)=ZW1
      BI(IST)=RAD
      ITAG(IST)=ITG
      X2(N)=XW2
      Y2(N)=YW2
      Z2(N)=ZW2
      XD=XW2-XW1
      YD=YW2-YW1
      ZD=ZW2-ZW1
      RHD=SQRT(XD**2+YD**2)
      IF(RHD.LT.1.E-20)THEN
         WRITE(*,90)
         STOP
      END IF
      XD=XD/RHD
      YD=YD/RHD
      IF(ICT.EQ.1)THEN
         ZHGT=ZMP-ZW1
      ELSE IF(ICT.EQ.2)THEN
         ZHGT=ZD*RHMP/RHD-ZMP
      END IF
      CALL CATSOL(RHD,ZD,RHMP,ZHGT,C1,RH,ICT-2)
      CALL CATEXP(RHD,RH,EX2,EXRP,EXRM,EXRS)
      CLEN=.5*(EXRP*C1-EXRM/C1)
      CSEGL=CLEN/NS
      CFAC=.5*(C1-1./C1)
      CLENX=0.
      XLENX=0.
      SLEN=0.
      IST=IST+1
      DO 1 I=IST,N
      IF(RH.GT.1.E-20)THEN
         CLENX=CLENX+CSEGL
         AA=RH*CLENX+CFAC
         XLENX=ALOG((AA+SQRT(AA**2+1.))/C1)/RH
      ELSE
         XLENX=XLENX+RHD/NS
      END IF
      CALL CATEXP(XLENX,RH,EX2,EXRP,EXRM,EXRS)
      X(I)=XW1+XLENX*XD
      Y(I)=YW1+XLENX*YD
      Z(I)=ZW1+.5*(EXRP*C1+EXRM/C1)
      BI(I)=RAD
      ITAG(I)=ITG
      X2(I-1)=X(I)
      Y2(I-1)=Y(I)
      Z2(I-1)=Z(I)
      SLEN=SLEN+SQRT((X2(I-1)-X(I-1))**2+(Y2(I-1)-Y(I-1))**2+(Z2(I-1)-
     &Z(I-1))**2)
1     CONTINUE
      SLEN=SLEN+SQRT((X2(N)-X(N))**2+(Y2(N)-Y(N))**2+(Z2(N)-Z(N))**2)
      WRITE(*,91)CLEN,SLEN
      RETURN
C
90    FORMAT(' CATNRY: ERROR - INCORRECT PARAMETERS RECEIVED')
91    FORMAT(/,' Catenary length =',1PE12.5,4X,
     &'Total segment length =',E12.5)
      END
      SUBROUTINE CATEXP(X,RH,EXR,EXRP,EXRM,EXRS)
C
C     CATEXP evaluates exponential terms for a catenary
C
      XR=X*RH
      EXR=EXP(XR)
      IF(ABS(XR).GT.0.1)THEN
         EXRP=(EXR-1.)/RH
         EXRM=(1./EXR-1.)/RH
         EXRS=(EXRM+EXRP)/RH
      ELSE
         EXRP=X*((((8.333333E-3*XR+.04166667)*XR+.1666667)*XR+.5)*XR+1.)
         EXRM=X*((((-8.333333E-3*XR+.04166667)*XR-.1666667)*XR+.5)*XR-
     &1.)
         EXRS=X**2*(1.+.08333333*XR**2)
      END IF
      RETURN
      END
      SUBROUTINE CATSOL(X2,Y2,XMX,YMX,C1,RH,ICAT)
C
C     CATSOL solves for the constants C1 and RH for a catenary
C     Y=((EXP(RH*X)-1.)*C1 + (EXP(-RH*X)-1.)/C1)/(2.*RH).  The catenary
C     passes through the points (0,0) and (X2,Y2).  For ICAT=0 the
C     the catenary passes through the point (XMX,YMX).  For ICAT=1 the
C     XMX is the total length of the catenary.
C
C     OUTPUT: C1, RH = constants for the catenary.
C
      DATA MAXITR/51/
      IF(ICAT.EQ.1)THEN
         XM=X2
         YM=XMX
         IF(YM.LE.SQRT(X2**2+Y2**2))THEN
            RH=0.
            C1=(Y2+SQRT(X2**2+Y2**2))/X2
            RETURN
         END IF
      ELSE
         XM=XMX
         YM=YMX
      END IF
      RH=1./X2
      RHDIF=1.
      DO 1 I=1,MAXITR
      CALL CATEXP(X2,RH,EXRX,EXRP,EXRM,EXRS)
      SQFAC=SQRT(Y2**2+EXRS)
      IF(X2.LT.0.)SQFAC=-SQFAC
      C1=(Y2+SQFAC)/EXRP
C
C     EXIT IF ITERATION HAS CONVERGED OR LIMIT HAS BEEN REACHED.
C
      IF(ABS(RHDIF/RH).LT.1.E-5)GO TO 2
      IF(I.GE.MAXITR)THEN
         WRITE(*,90)
         GO TO 2
      END IF
C
      CP=(Y2+.5*(X2*(EXRP-EXRM)+2.*Y2**2)/SQFAC)/EXRP - X2*EXRX*(Y2+
     &SQFAC)/EXRP**2
      IF(ICAT.EQ.1)THEN
         EXRM=-EXRM
         RXRX=-1./EXRX
      ELSE
         CALL CATEXP(XM,RH,EXRX,EXRP,EXRM,EXRS)
         RXRX=1./EXRX
      END IF
      YF=.5*(EXRP*C1+EXRM/C1)
      DYF=(-YF+.5*(XM*(EXRX*C1-RXRX/C1)+CP*(EXRP-EXRM/C1**2)))/RH
      RHDIF=(YF-YM)/DYF
      RH=RH-RHDIF
      IF(RH*X2.GT.50.)RH=50./X2
1     CONTINUE
2     RETURN
C
90    FORMAT(' CATSOL: SOLUTION DID NOT CONVERGE')
      END
      SUBROUTINE HELIX(IHLX,TURNS,ZLEN,HRAD1,HRAD2,WRAD1,WRAD2,NS,ITG)
C
C     Purpose:
C     HELIX generates segment geometry data for a helix, log spiral or
C     Archimedes spiral.  The spiral starts on the x axis at y=z=0 and
C     has its axis along the z axis.
C
C     INPUT:
C     IHLX = 0 for a log spiral, 1 for an Archimedes spiral.
C     TURNS = number of turns (may be fractional), positive for a
C             right-hand spiral relative to the positive z axis,
C             negative for left-hand.
C     ZLEN = length of the helix or spiral along the z axis.
C     HRAD1 = starting radius of the spiral.  Starting point is X=HRAD1.
C     HRAD2 = final radius of the spiral.
C     WRAD1, WRAD2 = starting and final segment radius.
C     NS = number of segments.
C     ITG = tag number assigned to all segments.
C
      PARAMETER (MAXSEG=1000)
      COMMON /DATA/ LD,N1,N2,N,NP,M1,M2,M,MP,X(MAXSEG),Y(MAXSEG),
     &Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),ALP(MAXSEG),BET(MAXSEG),
     &ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),ICONX(MAXSEG),WLAM,IPSYM
      DIMENSION X2(1), Y2(1), Z2(1)
      EQUIVALENCE (X2(1),SI(1)), (Y2(1),ALP(1)), (Z2(1),BET(1))
      DATA TP/6.28318531/
      IST=N+1
      N=N+NS
      NP=N
      IPSYM=0
      IF (NS.LT.1) RETURN
      RADRAT=(WRAD2/WRAD1)**(1./(NS-1.))
      THMAX=TP*ABS(TURNS)
      IF (IHLX.EQ.0)THEN
         AHLX=(HRAD2/HRAD1)**(1./THMAX)
         IF(ABS(AHLX-1.).GT.0.02)THEN
            ISMALL=0
            HFAC=ZLEN/(HRAD2/HRAD1-1.)
         ELSE
            ISMALL=1
         END IF
      ELSE
         AHLX=(HRAD2-HRAD1)/THMAX
      END IF
      SUM=0.
      TINC=THMAX/NS
      THET=0. 
      DO 1 I=IST,N
      THET=THET+TINC
      ITAG(I)=ITG
      IF(I.EQ.IST)THEN
         X(I)=HRAD1
         Y(I)=0.
         Z(I)=0.
         BI(I)=WRAD1
      ELSE
         X(I)=X2(I-1)
         Y(I)=Y2(I-1)
         Z(I)=Z2(I-1)
         BI(I)=BI(I-1)*RADRAT
      END IF
      IF(I.EQ.N)THEN
         HRAD=HRAD2
         ZHLX=ZLEN
      ELSE
C
C     LOG SPIRAL - RADIUS AND POSITION ALONG Z AXIS
C
         IF(IHLX.EQ.0)THEN
            HRAD=HRAD1*AHLX**THET
            IF(ISMALL.EQ.0)THEN
               ZHLX=HFAC*(AHLX**THET-1.)
            ELSE
               ZHLX=ZLEN*(THET/THMAX)*(1.+.5*(AHLX-1.)*(THET-THMAX))
            END IF
         ELSE
C
C     ARCHIMEDES SPIRAL
C
            HRAD=HRAD1+AHLX*THET
            ZHLX=ZLEN*THET/THMAX
         END IF
      END IF
      X2(I)=HRAD*COS(THET)
      Y2(I)=HRAD*SIN(THET)
      IF(TURNS.LT.0.)Y2(I)=-Y2(I)
      Z2(I)=ZHLX
      SUM=SUM+SQRT((X2(I)-X(I))**2+(Y2(I)-Y(I))**2+(Z2(I)-Z(I))**2)
1     CONTINUE
      WRITE(*,90)SUM
90    FORMAT(/,' TOTAL LENGTH OF WIRE IN THE SPIRAL = ',1PE12.5)
      RETURN
      END
      SUBROUTINE UPCASE( INTEXT, OUTTXT, LENGTH )
C
C     UPCASE finds the length of INTEXT and converts it to upper case.
C
      CHARACTER *(*) INTEXT, OUTTXT
C
C
      LENGTH=LEN( INTEXT )
      DO 3000 I=1,LENGTH
         J=ICHAR( INTEXT(I:I) )
         IF (J .GE. 96) J=J - 32
         OUTTXT(I:I)=CHAR( J )
3000  CONTINUE
      RETURN
      END
