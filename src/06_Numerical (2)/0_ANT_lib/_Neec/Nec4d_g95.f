cx
cx This is NEC4d_g95.f, a version of NEC4d.f adapted such that it can
cx be compiled with g95. In this version the input and output files have
cx to be given as command line parameters
cx (Windows: 2nd parameter=input file, 3rd par.=output file, 1st is dummy)
cx ---------------------------------------------------------------------
cx  USE MSFLIB
cx  USE DFPORT
C     Numerical Electromagnetics Code (NEC-4.1)  Developed at Lawrence
C     Livermore National Laboratory, Livermore, CA.
C     (Contact G. Burke at 510-422-8414)
C
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C                        ***** WARNING *****
C
C             INFORMATION SUBJECT TO EXPORT CONTROL LAWS
C
C     This document may contain information subject to the International
C     Traffic in Arms Regulation (ITAR) or the Export Administration
C     Act (EAA) of 1979, extended by Executive Order 12730.  This
C     material may not be exported, released or disclosed to foreign
C     nationals inside or outside the United States without first
C     obtaining an export license.  A Violation of the ITAR or EAA may
C     be subject to a penalty of up to 10 years imprisonment and a fine
C     of $100,000 under 22 U.S.C. 2778 or Section 2410 of the Export
C     Administration Act of 1979.  Include this notice with any
C     reproduced portion of this document.
C
C                ***********NOTICE**********
C
C     This computer code material was prepared as an account of work
C     sponsored by the United States Government.  Neither the United
C     States nor the United States Department of Energy, nor any of
C     their employees, nor any of their contractors, subcontractors, or
C     their employees, makes any warranty, express or implied, or
C     assumes any legal liability or responsibility for the accuracy,
C     completeness or usefulness of any information, apparatus, product
C     or process disclosed, or represents that its use would not
C     infringe privately-owned rights.
C
C     History:
C        Date      Change
C      -------     ----------------------------------------------
C      8/11/95     Call to SETTL added before 2nd call to COUPLE in MAIN
C      7/12/94     Routines QSOLVE, QJRATV, QMFIL changed to avoid
C                     instability in charge solution for junctions
C                     with many wires.
C      7/12/94     SEGCHK: tolerance on DEN for parallel wires tightened
C      7/12/94     EFCAP: exact field of cap used when series is not
C                         accurate
C      7/12/94     EXRINT: approximation for large R used in place of
C                          3-point Gaussian integration.
C      7/26/94     Added LE and LH commands to compute near E and H
C                  along lines.
C      5/04/95     Matrix re-transposed in subroutine FACTR.
C                  FACTR and SOLVE changed for non-transposed matrix.
C      1/16/96     Added call to SETGND on reading GD command
C      4/26/96     Changed call to RECOT to 'write D in FACGF' to fix
C                  error in NGF with matrix D out of core.
C      8/16/01     Sommerfeld solution modified to include point charge
C                  on wire ends within a margin inside the region
C                  for integrating over the segment.  This was needed
C                  to avoid unbalanced charge when switching to the
C                  one-point integration for the segments.
C      8/16/01     Lock switching between l.s. approx. and asymptotic
C                  while evaluating H from diferences to avoid a glitch.
C
      INCLUDE 'NECPAR.INC'
      PARAMETER (IRESRV=MAXMAT**2)
      IMPLICIT REAL*8 (A-H,O-Z)
      EXTERNAL SOMSET,SECOND
      CHARACTER AIN*2,FILNAM*40,PLFNAM*60
      COMPLEX*16 CM,ZARRAY,CEINS,ZPEDA,AX,BX,CX,ZPED,AIX,BIX,CIX,CUR,
     &XKS,XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,FRATI,ETAL2,TLYT1,TLYT2,YN11,
     &YN12,YN22,SVOLTS,ENINTG,HNINTG
C***
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON/FRQDAT/IFRQ,NFRQ,FMHZS,DELFRQ,FMHZ
      COMMON/OUTFIL/IPLOT,LUNPLT,PLFNAM
      COMMON /CMB/CM(IRESRV),IP(2*MAXSEG),IB11,IC11,ID11,NEQMAT,NEQ,NEQ2
      COMMON /MATPAR/ ICASE,NBLOKS,NPBLK,NLAST,NBLSYM,NPSYM,NLSYM,IMAT,
     &ICASX,NBBX,NPBX,NLBX,NBBL,NPBL,NLBL
      COMMON/CRNT/AIX(MAXSEG),BIX(MAXSEG),CIX(MAXSEG),CUR(3*MAXSEG),
     &XKS(MAXSEG)
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      COMMON/ZLOAD/ ZARRAY(MAXSEG),NLOAD,NLODF,LDTYP(LOADMX),
     &LDTAG(LOADMX),LDTAGF(LOADMX),LDTAGT(LOADMX),ZLR(LOADMX),
     &ZLI(LOADMX),ZLC(LOADMX)
      COMMON/INSCOM/CEINS(MAXSEG),BRINS(MAXSEG),NINS,NINSF,INTAG(MAXIS),
     &INTAGF(MAXIS),INTAGT(MAXIS),EPSIN(MAXIS),SIGIN(MAXIS),RADIN(MAXIS)
      COMMON/ZPSAV/ZPEDA(200),FRMHZA(200),ZPNORM,NZSAVE,NZLIMT,ISZSAV
      COMMON /SEGJ/ AX(NSJMAX),BX(NSJMAX),CX(NSJMAX),JCO(NSJMAX),JSNO,
     &ISCON(NSCNGF),NSCON,IPCON(NSPNGF),NPCON
      COMMON /SORCES/ PSOR1(NSOMAX),PSOR2(NSOMAX),PSOR3(NSOMAX),
     &PSOR4(NSOMAX),PSOR5(NSOMAX),PSOR6(NSOMAX),DTHINC,DPHINC,NTHINC,
     &NPHINC,NSCINC,NSORC,ISORTP(NSOMAX)
      COMMON/NETDEF/TLYT1(NETMX),TLYT2(NETMX),YN11(NETMX),YN12(NETMX),
     &YN22(NETMX),SVOLTS(NSOMAX),TLZCH(NETMX),TLLEN(NETMX),NVSOR,
     &NVSORA(NSOMAX),ISEG1(NETMX),ISEG2(NETMX),NONET,NETYP(NETMX)
      COMMON/NETCX/ZPED,PIN,PNLS,IZSAVE,NPEQ,NTSOL,NPRINT
      COMMON /NFDAT/ ENINTG,HNINTG,XNR,YNR,ZNR,DXNR,DYNR,DZNR,NEAR,NFEH,
     &NRX,NRY,NRZ
      COMMON/PTCONT/IPTFLG,IPTAG,IPTAGF,IPTAGT,IPTFLQ,IPTAQ,IPTAQF,
     &IPTAQT
      COMMON/CPPRAM/ICPT1,ICPS1,ICPT2,ICPS2
C***
      CALL CONSET
      CALL GETIOF
      CALL SECOND(EXTIM)
      LD=MAXSEG
1     CALL NECTTL
      DO 2 I=1,LD
      CEINS(I)=(1.,0.)
      BRINS(I)=0.
2     ZARRAY(I)=(0.,0.)
      MPCNT=0
      IMAT=0
C
C     SET UP GEOMETRY DATA IN SUBROUTINE DATAGN
C
      CALL DATAGN
      IFLOW=1
      IF(IMAT.NE.0)THEN
C
C     CORE ALLOCATION FOR ARRAYS B, C, AND D FOR N.G.F. SOLUTION
C
         NEQ=N1+2*M1
         NEQ2=N-N1+2*(M-M1)+NSCON+2*NPCON
         CALL FBNGF(NEQ,NEQ2,IRESRV,IB11,IC11,ID11,IX11)
      ELSE
         NEQ=N+2*M
         NEQ2=0
         IB11=1
         IC11=1
         ID11=1
         IX11=1
         ICASX=0
      END IF
      NPEQ=NP+2*MP
      NEQMAT=NEQ+NEQ2
      WRITE(3,135)
      CALL CDEFLT(IGO,IPED,IRNGF,ICASX,IXTYP)
C
C     MAIN INPUT SECTION - STANDARD READ STATEMENT - JUMPS TO APPRO-
C     PRIATE SECTION FOR SPECIFIC PARAMETER SET UP
C
14    CALL READMN(2,AIN,ITMP1,ITMP2,ITMP3,ITMP4,TMP1,TMP2,TMP3,TMP4,
     &TMP5,TMP6,TMP7,FILNAM)
      MPCNT=MPCNT+1
      IF(ABS(TMP7).LT.1.E-25.AND.FILNAM.EQ.' ')THEN
         WRITE(3,137) MPCNT,AIN,ITMP1,ITMP2,ITMP3,ITMP4,TMP1,TMP2,TMP3,
     &   TMP4,TMP5,TMP6
      ELSE
         WRITE(3,139) MPCNT,AIN,ITMP1,ITMP2,ITMP3,ITMP4,TMP1,TMP2,TMP3,
     &   TMP4,TMP5,TMP6,TMP7,FILNAM
      END IF
C
      IF (AIN.EQ.'EK'.OR.AIN.EQ.'KH') THEN
         WRITE(3,145)
         GO TO 14
C
      ELSE IF (AIN.EQ.'EX') THEN
         CALL RSETEX(ITMP1,ITMP2,ITMP3,ITMP4,TMP1,TMP2,TMP3,TMP4,TMP5,
     &   TMP6,TMP7,IFLOW,IGO,IPED,IXTYP,NTSOL,ZPNORM)
         GO TO 14
C
      ELSE IF (AIN.EQ.'NT'.OR.AIN.EQ.'TL') THEN
         CALL RSETNT(AIN,ITMP1,ITMP2,ITMP3,ITMP4,TMP1,TMP2,TMP3,TMP4,
     &   TMP5,TMP6,IFLOW,IGO,NTSOL)
         GO TO 14
C
      ELSE IF (AIN.EQ.'FR') THEN
         CALL RSETFR(ITMP1,ITMP2,TMP1,TMP2,IGO,IFLOW,ICASX,IPED,ZPNORM)
         GO TO 14
C
      ELSE IF (AIN.EQ.'IS') THEN
         CALL RSETIS(ITMP1,ITMP2,ITMP3,ITMP4,TMP1,TMP2,TMP3,IGO,IFLOW)
         GO TO 14
C
      ELSE IF (AIN.EQ.'PS') THEN
      IFLOW=14
      GO TO 41
C
      ELSE IF (AIN.EQ.'LD') THEN
         CALL RSETLD(ITMP1,ITMP2,ITMP3,ITMP4,TMP1,TMP2,TMP3,IGO,IFLOW)
         GO TO 14
C
      ELSE IF (AIN.EQ.'GN') THEN
         CALL RSETGN(ITMP1,ITMP2,TMP1,TMP2,TMP3,TMP4,TMP5,TMP6,FILNAM,
     &   IGO,IFLOW,ICASX)
         GO TO 14
C
      ELSE IF (AIN.EQ.'JN') THEN
         CALL RSETJN(ITMP1,IGO,IFLOW)
         GO TO 14
C
      ELSE IF (AIN.EQ.'PT') THEN
         CALL RSETPT(ITMP1,ITMP2,ITMP3,ITMP4)
         GO TO 14
C
      ELSE IF (AIN.EQ.'PQ') THEN
         CALL RSETPQ(ITMP1,ITMP2,ITMP3,ITMP4)
         GO TO 14
C
      ELSE IF (AIN.EQ.'PL') THEN
         CALL RSETPL(ITMP1,IFLOW,FILNAM)
         IF(IPLOT.NE.0)CALL GEOOUT
         GO TO 14
C
      ELSE IF (AIN.EQ.'GD') THEN
         CALL RSETGD(ITMP1,TMP1,TMP2,TMP3,TMP4,IFLOW)
         IF(IGO.GT.2)CALL SETGND(FMHZ)
         GO TO 14
C
      ELSE IF (AIN.EQ.'UM') THEN
         CALL RSETUM(TMP1,TMP2,IGO,IFLOW,ICASX)
         GO TO 14
C
      ELSE IF (AIN.EQ.'VC') THEN
         CALL RSETVC(ITMP1,IGO,IFLOW)
         GO TO 14
C
      ELSE IF (AIN.EQ.'CP') THEN
         CALL RSETCP(ITMP1,ITMP2,ITMP3,ITMP4,IFLOW)
         IF(IGO.GT.2)THEN
            CALL COUPLE(ICPT1,ICPS1,ICPT2,ICPS2)
            GO TO 14
         END IF
         GO TO (41,46),IGO
C
      ELSE IF (AIN.EQ.'NE'.OR.AIN.EQ.'NH') THEN
         CALL RSETNF(AIN,ITMP1,ITMP2,ITMP3,ITMP4,TMP1,TMP2,TMP3,TMP4,
     &   TMP5,TMP6,IFLOW)
         IF (NFRQ.NE.1) GO TO 14
         GO TO (41,46,53,72), IGO
C
      ELSE IF (AIN.EQ.'LE'.OR.AIN.EQ.'LH') THEN
         CALL RSETNL(AIN,ITMP1,ITMP2,TMP1,TMP2,TMP3,TMP4,TMP5,TMP6,
     &   IFLOW)
         IF (NFRQ.NE.1) GO TO 14
         GO TO (41,46,53,72), IGO
C
      ELSE IF (AIN.EQ.'EN') THEN
         CALL SECOND(TMP1)
         TMP1=TMP1-EXTIM
         WRITE(3,201)TMP1
         CLOSE(UNIT=11,STATUS='DELETE',ERR=3)
3        STOP
C
      ELSE IF (AIN.EQ.'WG') THEN
         IFLOW=12
         IF(ICASX.NE.0)THEN
            WRITE(3,302)
            STOP
         END IF
         IRNGF=IRESRV/2
         IF(IGO.GT.2)THEN
            CALL GFOUT(FILNAM)
            GO TO 14
         END IF
         GO TO (41,46),IGO
      ELSE IF (AIN.EQ.'RP') THEN
         CALL RSETRP(ITMP1,ITMP2,ITMP3,ITMP4,TMP1,TMP2,TMP3,TMP4,TMP5,
     &   TMP6,IFLOW)
         GO TO (41,46,53,78), IGO
C
      ELSE IF (AIN.EQ.'XQ') THEN
         IF (IFLOW.EQ.10.AND.ITMP1.EQ.0) GO TO 14
         IF (NFRQ.EQ.1.AND.ITMP1.EQ.0.AND.IFLOW.GT.7) GO TO 14
         CALL RSETXQ(ITMP1,IFLOW)
         GO TO (41,46,53,78), IGO
C
      ELSE IF (AIN.EQ.'NX') THEN
         CLOSE(UNIT=11,STATUS='DELETE',ERR=1)
         GO TO 1
C
      ELSE
         WRITE(3,138)
         STOP
      END IF
C
C     END OF THE MAIN INPUT SECTION
C
C     BEGINNING OF THE FREQUENCY DO LOOP
C
41    MHZ=1
      FMHZ=FMHZS
C     CORE ALLOCATION FOR PRIMARY INTERACTON MATRIX.  (A)
      IF(IMAT.EQ.0)CALL FBLOCK(NPEQ,NEQ,IRESRV,IRNGF,IPSYM)
42    IF (MHZ.GT.1) THEN
         IF (IFRQ.EQ.1) THEN
            FMHZ=FMHZ*DELFRQ
         ELSE
            FMHZ=FMHZ+DELFRQ
         END IF
      END IF
      IGO=2
C
C     SET FREQUENCY DEPENDENT GROUND PARAMETERS
C
46    CALL SETGND(FMHZ)
C
C     INSET COMPUTES WIRE SHEATH PARAMETERS THAT DEPEND ON FREQUENCY
C
      CALL INSET(OMEGAG)
      CALL XKSET
      IF(IFLOW.EQ.14)THEN
         CALL PTSLEN
         IFLOW=4
         GO TO 14
      END IF
C
C     SET FREQUENCY DEPENDENT LOADING PARAMETERS
C
      WRITE(3,146)
      IF(NLOAD.NE.0) CALL LOAD(FMHZ,XKU)
      IF(NLOAD.EQ.0.AND.NLODF.EQ.0)WRITE(3,147)
      IF(NLOAD.EQ.0.AND.NLODF.NE.0)WRITE(3,327)
C * * *
C     FILL AND FACTOR PRIMARY INTERACTION MATRIX
C
      CALL JNQSET
      CALL SECOND (TIM1)
      IF(ICASX.EQ.0)THEN
         CALL CMSET(NEQ,CM,11)
         CALL SECOND (TIM2)
         TIM=TIM2-TIM1
         CALL FACTRS(NPEQ,NEQ,CM,IP,11,12)
         CALL SECOND (TIM1)
         TIM2=TIM1-TIM2
         WRITE(3,153) TIM,TIM2
C
C     N.G.F. - FILL B, C, AND D AND FACTOR D-C(INV(A)B)
C
      ELSE IF (NEQ2.NE.0) THEN
         CALL CMNGF(CM(IB11),CM(IC11),CM(ID11),NPBX,NEQ,NEQ2)
         CALL SECOND (TIM2)
         TIM=TIM2-TIM1
         CALL FACGF(CM,CM(IB11),CM(IC11),CM(ID11),CM(IX11),IP,NP,N1,MP,
     &   M1,NEQ,NEQ2)
         CALL SECOND (TIM1)
         TIM2=TIM1-TIM2
         WRITE(3,153) TIM,TIM2
      END IF
      IGO=3
      NTSOL=0
      IF (IFLOW.EQ.12) THEN
C
C        WRITE N.G.F. FILE AND RETURN TO READING INPUT
C
         CALL GFOUT(FILNAM)
         GO TO 14
      END IF
      IF (IFLOW.EQ.13) THEN
C
C        COMPUTE MAXIMUM COUPLING AND RETURN TO READING INPUT
C
         IF(NONET.GT.0)CALL SETTLX
         CALL COUPLE(ICPT1,ICPS1,ICPT2,ICPS2)
         GO TO 14
      END IF
C
C     EXCITATION SET UP (RIGHT HAND SIDE, -E INC.)
C
53    INC=0
      NPRINT=0
      IF(NSCINC.GT.0)THEN
        THSAVE=PSOR1(NSCINC)
        PHSAVE=PSOR2(NSCINC)
      END IF
      DO 55 ITHINC=1,NTHINC
      IF(ITHINC.GT.1)PSOR1(NSCINC)=PSOR1(NSCINC)+DTHINC
      DO 54 IPHINC=1,NPHINC
      IF(IPHINC.GT.1)PSOR2(NSCINC)=PSOR2(NSCINC)+DPHINC
      INC=INC+1
      CALL PTEXCT(IPTFLG)
      CALL ETMNS (CUR)
C
C     MATRIX SOLVING  (NETWK CALLS SOLVES)
C
      IF (NONET.GT.0.AND.INC.EQ.1)THEN
C
C     SET PARAMETERS FOR TRANSMISSION LINES AND PRINT NETWORK AND
C     TRANSMISSION LINE INFORMATION.
C
         CALL PTNETW
         CALL SETTLX
      END IF
      IF (INC.GT.1.AND.IPTFLG.GT.0) NPRINT=1
      CALL NETWK(CUR)
      IF(IPLOT.NE.0)CALL CUROUT
      NTSOL=1
      IF (IPED.NE.0)CALL ZPSAVE(MHZ,FMHZ,ZPED,IZSAVE)
C
C     PRINTING STRUCTURE CURRENT AND CHARGE
C
      IF(IPTFLG.LE.0)CALL PTWIRC(IPTFLG,IPTAG,IPTAGF,IPTAGT)
      IF(IPTFLG.GT.0)CALL PTRECP(PSOR1(NSCINC),PSOR2(NSCINC),
     &   PSOR3(NSCINC),PSOR5(NSCINC),IPTFLG,IPTAG,IPTAGF,IPTAGT,INC)
      IF(IPTFLQ.NE.-1)CALL PTWIRQ(IPTFLQ,IPTAQ,IPTAQF,IPTAQT)
      IF(IPTFLG.EQ.-2.OR.IPTFLG.EQ.0)CALL PTPCHC
      IF (IXTYP.EQ.0.OR.IXTYP.EQ.5) CALL PWRBGT(PIN,PNLS,PLOSS)
      IGO=4
      IF (IFLOW.EQ.7) THEN
         IF (IXTYP.GT.0.AND.IXTYP.LT.4) GO TO 54
           IF(NSCINC.GT.0)THEN
          PSOR1(NSCINC)=THSAVE
          PSOR2(NSCINC)=PHSAVE
           END IF
        IF (NFRQ.NE.1) GO TO 120
        WRITE(3,135)
        GO TO 14
      END IF
C
C     NEAR AND FAR FIELD CALCULATIONS
C
      IF (NEAR.EQ.0.OR.NEAR.EQ.1) CALL NFPAT
      IF (NEAR.EQ.2)CALL NFLINE
      IF (IFAR.NE.-1) CALL RDPAT(PIN,PNLS,PLOSS)
54    CONTINUE
      IF(NSCINC.GT.0)PSOR2(NSCINC)=PHSAVE
55    CONTINUE
      IF(NSCINC.GT.0)PSOR1(NSCINC)=THSAVE
      IF(IPTFLG.GE.2)CALL PTRECN
      IF (MHZ.EQ.NFRQ) THEN
         IFAR=-1
         NEAR=-1
      END IF
      IF (NFRQ.EQ.1) THEN
         WRITE(3,135)
         GO TO 14
      END IF
120   MHZ=MHZ+1
      IF (MHZ.LE.NFRQ) GO TO 42
      IF(IPED.NE.0)CALL PTZPED
      NFRQ=1
      MHZ=1
      FMHZS=FMHZ
      WRITE(3,135)
      GO TO 14
72    IF (NEAR.EQ.0.OR.NEAR.EQ.1)THEN
         CALL NFPAT
      ELSE
         CALL NFLINE
      END IF
      NEAR=-1
      WRITE(3,135)
      GO TO 14
78    IF(IFAR.NE.-1)CALL RDPAT(PIN,PNLS,PLOSS)
      IFAR=-1
      WRITE(3,135)
      GO TO 14
C
135   FORMAT (///)
137   FORMAT (' ***** INPUT LINE',I3,2X,A2,1X,I3,3I5,6(1X,1PE12.5))
139   FORMAT (' ***** INPUT LINE',I3,2X,A2,1X,I3,3I5,6(1X,1PE12.5),/
     &43X,(1X,1PE12.5),2X,A)
138   FORMAT (///,10X,'MAIN: FAULTY INPUT COMMAND LABEL AFTER GEOMETRY',
     &' SECTION')
145   FORMAT(/,' THE EK AND KH COMMANDS HAVE NO EFFECT IN NEC-4',/)
146   FORMAT (///,31X,'- - - STRUCTURE IMPEDANCE LOADING - - -')
147   FORMAT (/ ,35X,'THIS STRUCTURE IS NOT LOADED')
153   FORMAT (///,32X,'- - - MATRIX TIMING - - -',//,24X,'FILL=',F9.3,
     &' SEC.,  FACTOR=',F9.3,' SEC.')
201   FORMAT(/,' RUN TIME =',F10.3)
327   FORMAT(/,36X,'LOADING ONLY IN N.G.F. SECTION')
302   FORMAT(' MAIN: ERROR - N.G.F. IN USE.  CANNOT WRITE NEW N.G.F.')
      END
      SUBROUTINE CUROUT
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     CUROUT WRITES A,B,C COEFFICIENTS FOR CURRENT TO A FILE FOR
C     PLOTTING BY PROGRAM PLT2D3D
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER PLFNAM*60,TEXT*20
      COMPLEX*16 AIX,BIX,CIX,CUR,XKS,XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,
     &FRATI,ETAL2
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON/FRQDAT/IFRQ,NFRQ,FMHZS,DELFRQ,FMHZ
      COMMON/CRNT/AIX(MAXSEG),BIX(MAXSEG),CIX(MAXSEG),CUR(3*MAXSEG),
     &XKS(MAXSEG)
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      COMMON/OUTFIL/IPLOT,LUNPLT,PLFNAM
      TEXT='***NEC4 CURRENT'
      WRITE(LUNPLT,'(A)')TEXT
      WRITE(LUNPLT,'(I8,1PE13.5)')N,FMHZ
      DO I=1,N
         WRITE(LUNPLT,'(1P9E13.5)')AIX(I),BIX(I),CIX(I),SI(I),XKS(I)
      END DO
      RETURN
      END
      SUBROUTINE GEOOUT
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     GEOOUT WRITES SEGMENT DATA TO A FILE FOR PLOTTING BY PLOT2D3D
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER PLFNAM*60,TEXT*20
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON/OUTFIL/IPLOT,LUNPLT,PLFNAM
      TEXT='***NEC4 GEOM'
      WRITE(LUNPLT,'(A)')TEXT
      WRITE(LUNPLT,'(I8)')N
      DO I=1,N
         WRITE(LUNPLT,'(I8,1P7E13.5,3I8)')I,X(I),Y(I),Z(I),SI(I),
     &   ALP(I),BET(I),SALP(I),ICON1(I),ICON2(I),ITAG(I)
      END DO
      RETURN
      END
      SUBROUTINE RSETPL(ITMP1,IFLOW,FILNAM)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER FILNAM*(*),PLFNAM*60
      COMMON/OUTFIL/IPLOT,LUNPLT,PLFNAM
      IFLOW=1
      IF(ITMP1.NE.0)THEN
         IPLOT=0
         RETURN
      END IF
      IPLOT=1
      LUNPLT=22
      IF(PLFNAM.EQ.' '.OR.FILNAM.NE.' ')THEN
         PLFNAM=FILNAM
         IF(FILNAM.EQ.' ')PLFNAM='PLFIL.NEC'
         OPEN(UNIT=LUNPLT,FILE=PLFNAM,STATUS='unknown')
      END IF
      RETURN
      END
      SUBROUTINE CATNRY(XW1,YW1,ZW1,XW2,YW2,ZW2,RAD,ICT,RHMP,ZMP,NS,ITG)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
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
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      DIMENSION X2(MAXSEG), Y2(MAXSEG), Z2(MAXSEG)
      EQUIVALENCE (X2(1),SI(1)), (Y2(1),ALP(1)), (Z2(1),BET(1))
      IST=N+1
      N=N+NS
      NP=N
      MP=M
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
         WRITE(3,90)
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
         XLENX=LOG((AA+SQRT(AA**2+1.))/C1)/RH
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
      WRITE(3,91)CLEN,SLEN
      RETURN
C
90    FORMAT(' CATNRY: ERROR - INCORRECT PARAMETERS RECEIVED')
91    FORMAT(10X,'Catenary length =',1PE12.5,4X,
     &'Total segment length =',E12.5)
      END
      SUBROUTINE CATEXP(X,RH,EXR,EXRP,EXRM,EXRS)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     CATEXP evaluates exponential terms for a catenary
C
      IMPLICIT REAL*8 (A-H,O-Z)
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
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     CATSOL solves for the constants C1 and RH for a catenary
C     Y=((EXP(RH*X)-1.)*C1 + (EXP(-RH*X)-1.)/C1)/(2.*RH).  The catenary
C     passes through the points (0,0) and (X2,Y2).  For ICAT=0 the
C     the catenary passes through the point (XMX,YMX).  For ICAT=1 the
C     XMX is the total length of the catenary.
C
C     OUTPUT: C1, RH = constants for the catenary.
C
      IMPLICIT REAL*8 (A-H,O-Z)
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
         WRITE(3,90)
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
      SUBROUTINE CONSET
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     CONSET sets the values of constants (pi, etc.) in COMMON/CONSTN/
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON/CONSTN/PI,TP,DTORAD,CVEL,EPSRZ,RMUZ,ETAZ
      PI=3.141592654
      TP=6.2831853071796D0
      DTORAD=0.01745329252
      CVEL=2.998E8
      EPSRZ=8.854E-12
      RMUZ=4E-7*PI
      ETAZ=376.73
      RETURN
      END
      SUBROUTINE SETGND(FMHZ)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     SETGND sets parameters for the upper (or infinite) medium and for
C     ground. Ground and upper medium parameters are printed in the
C     output file. For the Sommerfeld ground model, subroutine GNDINO is
C     called to read the tables generated by SOMNTX.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,XLA,GCK1,
     &GCK1SQ,GCK2,GCK2SQ,CK1,CK1SQ,CK2,CK2SQ,CKS12,CON1,CON2,CON3,CON4,
     &EPSC1,XJK,XK,EPSC2
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      COMMON/SETGN/GEPS,GSIG,UEPS,USIG
      COMMON /GPARM/ XLA(21,21),GCK1,GCK1SQ,GCK2,GCK2SQ,ZRAT,RHON
      COMMON /GNRZZ/ CK1,CK1SQ,CK2,CK2SQ,CKS12,CON1,CON2,CON3,CON4,EPSC1
     &,XJK,RHO,ZS,ZO,ZZ,ZZP,AZP,ICASE
      COMMON/CONSTN/PI,TP,DTORAD,CVEL,EPSRZ,RMUZ,ETAZ
C
C     UPPER MEDIUM PARAMETERS
C
      IF(USIG.LT.0.)USIG=-USIG*TP*FMHZ*1.E6*EPSRZ
      CEPSU=DCMPLX(UEPS,-USIG/(TP*FMHZ*1.E6*EPSRZ))
      CEPSL=CEPSU
      XK=SQRT(CEPSU)
      XKU=TP*FMHZ*1.E6*XK/CVEL
      GCK2=TP*XK
      GCK2SQ=GCK2*GCK2
      CK2=GCK2
      ETAU=ETAZ/XK
      XKL=XKU
      ETAL=ETAU
      GSCAL=FMHZ*1.E6/CVEL
      OMEGAG=TP*FMHZ*1.E6
      WLAM=TP/DREAL(XKU)
      WRITE(3,900) FMHZ,WLAM
      DELSK=ABS(DIMAG(XKU))
      IF(DELSK*WLAM.GT.1.E-20)THEN
         DELSK=1./DELSK
         WRITE(3,901)DELSK
      END IF
      WRITE(3,902)
      IF (KSYMP.EQ.1)THEN
         IF(ABS(CEPSU-1.).LT.1.E-6)THEN
            WRITE(3,903)
         ELSE
            WRITE(3,904)
            WRITE(3,905)UEPS,USIG,CEPSU
         END IF
         RETURN
      END IF
C
C     SET FREQUENCY DEPENDENT GROUND PARAMETERS
C
      FRATI=(1.,0.)
      IF (IPERF.EQ.1)THEN
         WRITE(3,906)
      ELSE
         IF(GSIG.LT.0.)GSIG=-GSIG*TP*FMHZ*1.E6*EPSRZ
         EPSC1=DCMPLX(GEPS,-GSIG/(TP*FMHZ*1.E6*EPSRZ))
         CEPSL=EPSC1
         XK=SQRT(EPSC1)
         XKL=TP*FMHZ*1.E6*XK/CVEL
         GCK1=TP*XK
         GCK1SQ=GCK1*GCK1
         CK1=GCK1
         ETAL=ETAZ/XK
      END IF
      IF(ICLIFT.NE.0)THEN
         IF(SIG2.LT.0.)SIG2=-SIG2*TP*FMHZ*1.E6*EPSRZ
         EPSC2=DCMPLX(EPSR2,-SIG2/(TP*FMHZ*1.E6*EPSRZ))
         XK=SQRT(EPSC2)
         ETAL2=ETAZ/XK
      END IF
      IF(IPERF.NE.1)THEN
         IF (NRADL.GT.0)THEN
            WRITE(3,907) NRADL,SCNRAD,SCNWRD
            WRITE(3,908)
         END IF
         IF(IPERF.EQ.2)THEN
            FRATI=(XKL*XKL-XKU*XKU)/(XKL*XKL+XKU*XKU)
            CALL GNDINO(EPSC1,21)
            WRITE(3,909)
         ELSE
            WRITE(3,910)
         END IF
         WRITE(3,912) GEPS,GSIG,EPSC1
      END IF
      IF(ABS(CEPSU-1.).GT.1.E-6)THEN
         WRITE(3,911)
         WRITE(3,912)UEPS,USIG,CEPSU
      END IF
      RETURN
C
900   FORMAT (////,33X,'- - - - - - FREQUENCY - - - - - -',//,36X,
     &'FREQUENCY=',1PE11.4,' MHZ',/,36X,'WAVELENGTH=',E11.4,' METERS')
901   FORMAT(36X,'SKIN DEPTH=',1PE11.4,' METERS')
902   FORMAT (///,34X,'- - - ANTENNA ENVIRONMENT - - -',/)
903   FORMAT (  44X,'FREE SPACE')
904   FORMAT (40X,'INFINITE MEDIUM')
905   FORMAT (40X,'RELATIVE DIELECTRIC CONST.=',F7.3,/,40X,
     &'CONDUCTIVITY=',1PE10.3,' MHOS/METER',/,40X,
     &'COMPLEX DIELECTRIC CONSTANT=',2E12.5)
906   FORMAT (  42X,'PERFECT GROUND')
907   FORMAT (40X,'RADIAL WIRE GROUND SCREEN',/,40X,I5,' WIRES',/,40X,
     &'WIRE LENGTH=',F8.2,' METERS',/,40X,'WIRE RADIUS=',1PE10.3,
     &' METERS')
908   FORMAT (40X,'MEDIUM UNDER SCREEN -')
909   FORMAT(40X,'FINITE GROUND.  SOMMERFELD SOLUTION')
910   FORMAT(40X,'FINITE GROUND.  REFLECTION COEFFICIENT APPROXIMATION')
911   FORMAT(/,40X,'UPPER MEDIUM:')
912   FORMAT (40X,'RELATIVE DIELECTRIC CONST.=',F7.3,/,40X,
     &'CONDUCTIVITY=',1PE10.3,' MHOS/METER',/,40X,
     &'COMPLEX DIELECTRIC CONSTANT=',2E12.5)
      END
      SUBROUTINE SETTLX
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     SETTLX computes the short-circuit admittance parameters for
C     ideal transmission lines.
C
C     DESCRIPTION:
C     TWO-PORT ADMITTANCE PARAMETERS ARE COMPUTED FROM THE LENGTH AND
C     CHARACTERISTIC IMPEDANCE OF THE TRANSMISSION LINE AND FREQUENCY.
C
C     INPUT:
C     TLZCH = CHARACTERISTIC IMPEDANCE OF TRANSMISSION LINE (OHMS)
C     TLLEN = LENGTH OF TRANSMISSION LINE (M)
C     TLYT1 = LOAD ADMITTANCE ACROSS END ONE OF TRANSMISSION LINE (MHOS)
C     TLYT2 = LOAD ADMITTANCE ACROSS END TWO OF TRANSMISSION LINE (MHOS)
C     OMEGAG = 2.*PI*(FREQUENCY)
C     OTHER INPUT FROM COMMON /NETDEF/
C
C     OUTPUT:
C     YN11 = ADMITTANCE AT END ONE OF THE TRANSMISSION LINE WITH END
C            TWO SHORT CIRCUITED (MHOS)
C     YN22 = ADMITTANCE AT END TWO OF THE TRANSMISSION LINE WITH END
C            ONE SHORT CIRCUITED (MHOS)
C     YN12 = CURRENT IN END TWO (SHORT CURCUITED) WITH ONE VOLT ON END
C            ONE OF THE TRANSMISSION LINE
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 TLYT1,TLYT2,YN11,YN12,YN22,SVOLTS,XKU,XKL,ETAU,ETAL,
     &CEPSU,CEPSL,FRATI,ETAL2
      COMMON/NETDEF/TLYT1(NETMX),TLYT2(NETMX),YN11(NETMX),YN12(NETMX),
     &YN22(NETMX),SVOLTS(NSOMAX),TLZCH(NETMX),TLLEN(NETMX),NVSOR,
     &NVSORA(NSOMAX),ISEG1(NETMX),ISEG2(NETMX),NONET,NETYP(NETMX)
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      COMMON/CONSTN/PI,TP,DTORAD,CVEL,EPSRZ,RMUZ,ETAZ
      XKZERO=OMEGAG/CVEL
      DO 1 INET=1,NONET
      IF(NETYP(INET).EQ.1)GO TO 1
      YN11(INET)=-(0.,1.)/(TLZCH(INET)*TAN(XKZERO*TLLEN(INET)))
      YN22(INET)=YN11(INET)
      YN12(INET)=(0.,1.)/(TLZCH(INET)*SIN(XKZERO*TLLEN(INET)))
C
C     REVERSE SIGN OF YN12 IF THE LINE IS TWISTED (NETYP=3)
C
      IF(NETYP(INET).EQ.3)YN12(INET)=-YN12(INET)
C
C     ADD ADMITTANCES OF TERMINATING LOADS
C
      YN11(INET)=YN11(INET)+TLYT1(INET)
      YN22(INET)=YN22(INET)+TLYT2(INET)
1     CONTINUE
      RETURN
      END
      SUBROUTINE CDEFLT(IGO,IPED,IRNGF,ICASX,IXTYP)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     CDEFLT sets default parameters including frequency, sources,
C     radiation patterns, loading, networks, transmission lines, near
C     field output, print control and coupling calculation.
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER PLFNAM*60
      COMPLEX*16 ZARRAY,TLYT1,TLYT2,YN11,YN12,YN22,ENINTG,HNINTG,SVOLTS,
     &XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,FRATI,ETAL2,CEINS
      COMMON/FRQDAT/IFRQ,NFRQ,FMHZS,DELFRQ,FMHZ
      COMMON /SORCES/ PSOR1(NSOMAX),PSOR2(NSOMAX),PSOR3(NSOMAX),
     &PSOR4(NSOMAX),PSOR5(NSOMAX),PSOR6(NSOMAX),DTHINC,DPHINC,NTHINC,
     &NPHINC,NSCINC,NSORC,ISORTP(NSOMAX)
      COMMON/ZLOAD/ ZARRAY(MAXSEG),NLOAD,NLODF,LDTYP(LOADMX),
     &LDTAG(LOADMX),LDTAGF(LOADMX),LDTAGT(LOADMX),ZLR(LOADMX),
     &ZLI(LOADMX),ZLC(LOADMX)
      COMMON/NETDEF/TLYT1(NETMX),TLYT2(NETMX),YN11(NETMX),YN12(NETMX),
     &YN22(NETMX),SVOLTS(NSOMAX),TLZCH(NETMX),TLLEN(NETMX),NVSOR,
     &NVSORA(NSOMAX),ISEG1(NETMX),ISEG2(NETMX),NONET,NETYP(NETMX)
      COMMON /NFDAT/ ENINTG,HNINTG,XNR,YNR,ZNR,DXNR,DYNR,DZNR,NEAR,NFEH,
     &NRX,NRY,NRZ
      COMMON/PTCONT/IPTFLG,IPTAG,IPTAGF,IPTAGT,IPTFLQ,IPTAQ,IPTAQF,
     &IPTAQT
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      COMMON/SETGN/GEPS,GSIG,UEPS,USIG
      COMMON /VLCAPC/IVCAP
      COMMON/SETJN/ISETJN
      COMMON/OUTFIL/IPLOT,LUNPLT,PLFNAM
      COMMON/CONSTN/PI,TP,DTORAD,CVEL,EPSRZ,RMUZ,ETAZ
      COMMON/INSCOM/CEINS(MAXSEG),BRINS(MAXSEG),NINS,NINSF,INTAG(MAXIS),
     &INTAGF(MAXIS),INTAGT(MAXIS),EPSIN(MAXIS),SIGIN(MAXIS),RADIN(MAXIS)
      COMMON/GLOCK/IGLOCK
      IGO=1
      NFRQ=1
      NSORC=0
      IXTYP=0
      NLOAD=0
      NONET=0
      IVCAP=0
      ISETJN=1
      NEAR=-1
      IPTFLG=-2
      IPTFLQ=-1
      ICLIFT=0
      IFAR=-1
      IPED=0
      IRNGF=0
      NINS=0
      IPLOT=0
      PLFNAM=' '
      IF(ICASX.GT.0)RETURN
      FMHZS=CVEL*1.E-6
      NLODF=0
      KSYMP=1
      NRADL=0
      IPERF=0
      UEPS=1.
      USIG=0.
      NINSF=0
      IGLOCK=0
      RETURN
      END
      SUBROUTINE GETIOF
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     GETIOF requests names for the input and output files and reads
C     the names entered from the terminal.
C
cx  USE MSFLIB
cx  USE DFLIB
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER COMIN*78,INFILE*80,OUTFILE*80
      CHARACTER DRIVE*10,DIR*80,FNAME*30,EXT*30
      LOGICAL LDIR
      INTEGER*2 ISTAT
      COMMON/NINFO/KCOM,COMIN(5),INFILE,OUTFILE
      MAXERR=20
C
C     Check for command line arguments
cx      IF(NARGS().GT.1)THEN
cx         CALL GETARG(2,INFILE,ISTAT)
cx previous line replaced with the following two lines:
         CALL GETARG(2,INFILE)
         ISTAT=0
         IF(ISTAT.EQ.-1)THEN
            WRITE(*,*)' ERROR getting input file from command line'
            STOP
         END IF
cx         OPEN (UNIT=2,FILE=INFILE,STATUS='OLD',READONLY,ERR=3)
cx previous line replaced with the following:
         OPEN (UNIT=2,FILE=INFILE,STATUS='OLD',ERR=3)
cx         CALL GETARG(3,OUTFILE,ISTAT)
cx previous line replaced with the following two lines:
         CALL GETARG(3,OUTFILE)
         ISTAT=0
         IF(ISTAT.EQ.-1)THEN
            WRITE(*,*)' ERROR getting output file from command line'
            STOP
         END IF
         OPEN (UNIT=3,FILE=OUTFILE,STATUS='UNKNOWN',ERR=4)
         RETURN
cx      END IF
cxC
cxC     Open input file
cx      IERR=0
cx1     WRITE(*,'('' Enter INPUT file name (or RETURN) >'',$)')
cx      READ(*,'(A)',ERR=3) INFILE
cx  IF(INFILE.EQ.' ')THEN
cx         CALL SETMESSAGEQQ("Open INPUT file , *.*",
cx     &   QWIN$MSG_FILEOPENDLG)
cx        OPEN (UNIT=2,FILE="",STATUS='OLD',ERR=3)
cx  ELSE
cx        OPEN (UNIT=2,FILE=INFILE,STATUS='OLD',ERR=3)
cx  END IF
cx  INQUIRE(UNIT=2,NAME=INFILE)
cx  LENDIR=SPLITPATHQQ(INFILE,DRIVE,DIR,FNAME,EXT)
cx  LDIR=CHANGEDIRQQ(DIR)
cxC
cxC     Open output file
cx      IERR=0
cx2     WRITE(*,'('' Enter OUTPUT file name (or RETURN) >'',$)')
cx      READ(*,'(A)',ERR=4) OUTFILE
cx      IF(OUTFILE.EQ.' ')THEN
cx         CALL SETMESSAGEQQ("Open OUTPUT file, *.*",
cx     &   QWIN$MSG_FILEOPENDLG)
cx         OPEN (UNIT=3,FILE=" ",STATUS='UNKNOWN',ERR=4)
cx  ELSE
cx         OPEN (UNIT=3,FILE=OUTFILE,STATUS='UNKNOWN',ERR=4)
cx  END IF
cx  INQUIRE(UNIT=3,NAME=OUTFILE)
cxC
cx      WRITE(*,94)INFILE
cx      WRITE(*,96)OUTFILE
cx      WRITE(*,95)
cx      RETURN
3     CALL ERROR
      IERR=IERR+1
cx      IF(IERR.GT.MAXERR)THEN
         WRITE(*,93)INFILE
         STOP
cx      END IF
cx      GO TO 1
4     CALL ERROR
      IERR=IERR+1
cx      IF(IERR.GT.MAXERR)THEN
         WRITE(*,93)OUTFILE
         STOP
cx      END IF
cx      GO TO 2
C
93    FORMAT(' GETIOF: ERROR - UNABLE TO OPEN FILE ',A)
94    FORMAT(//,' NEC-4.1 RUN IN PROGRESS',//,'  INPUT FILE: ',A60)
96    FORMAT('  OUTPUT FILE: ',A60)
95    FORMAT(//,22X,'*** WARNING ***',//,
     &' The NEC-4.1 code is subject to export restrictions under the',/,
     &' Export Administration Act of 1979, extended by Executive',/,
     &' Order 12730.  All requests except foreign requests shall be',/,
     &' directed to Lawrence Livermore National Laboratory (LLNL) at',/,
     &' P.O. Box 808, L-156, Livermore, CA 94550.  Foreign requests',/,
     &' shall be submitted through embassy channels and HQDA',/,
     &' (DAMI-CIT) to Commander, USAISC, ATTN: ASIS, Fort Huachuca,',/,
     &' AZ 85613-5000.  Further distribution by authorized',/,
     &' recipients is not permitted.',////)
      END
      SUBROUTINE NECTTL
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     NECTTL inserts a page eject and then prints the NEC output
C     heading.  Also, the counter for comment data lines is initialized.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER COMIN*78,INFILE*80,OUTFILE*80
      COMMON/NINFO/KCOM,COMIN(5),INFILE,OUTFILE
      KCOM=0
      WRITE(3,91)
      WRITE(3,92)
      RETURN
C
91    FORMAT  ('1')
92    FORMAT (///,
     &32X,'***********************************************',/,
     &32X,'*',45X,'*',/,
     &32X,'*  NUMERICAL ELECTROMAGNETICS CODE (NEC-4.1)  *',/,
     &32X,'*',45X,'*',/,
     &32X,'***********************************************',//)
      END
      SUBROUTINE COMOUT(RECDAT,ICMBLK)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     COMOUT prints text lines from the input file for title and
C     information.  The first 4 lines and the last line are saved.
C
C     INPUT:
C     RECDAT = CHARACTER STRING TO BE PRINTED
C     ICMBLK = 0 TO START A TEXT BLOCK, 1 TO CONTINUE A TEXT BLOCK
C              OR 2 TO PRINT THE TERMINATING BORDER.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER RECDAT*78,COMIN*78,INFILE*80,OUTFILE*80
      COMMON/NINFO/KCOM,COMIN(5),INFILE,OUTFILE
      IF(ICMBLK.EQ.2)THEN
         WRITE(3,90)
         ICMBLK=0
         RETURN
      ELSE IF(ICMBLK.EQ.0)THEN
         WRITE(3,91)
         ICMBLK=1
      END IF
      KCOM=KCOM+1
      IF (KCOM.GT.5) KCOM=5
      COMIN(KCOM)=RECDAT
      WRITE(3,92) RECDAT
      RETURN
C
90    FORMAT(/,22X,58('*'),//)
91    FORMAT(//,22X,58('*'),/)
92    FORMAT (25X,A)
      END
      SUBROUTINE RSETEX(ITMP1,ITMP2,ITMP3,ITMP4,TMP1,TMP2,TMP3,TMP4,
     &TMP5,TMP6,TMP7,IFLOW,IGO,IPED,IXTYP,NTSOL,ZPNORM)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     RSETEX stores the input data for EX input commands in
C     COMMON/SORCES/.
C
C     INPUT DEPENDS ON THE VALUE OF ITMP1:
C
C     ITMP1 = 0 FOR APPLIED FIELD VOLTAGE SOURCE
C          ITMP2 = TAG NUMBER OF SOURCE SEGMENT
C          ITMP3 = SOURCE SEGMENT NUMBER, OR NUMBER WITHIN TAG SET
C          ITMP4 = FLAG TO REQUEST IMPEDANCE NORMALIZATION IN FREQ. LOOP
C          CMPLX(TMP1,TMP2) = SOURCE VOLTAGE
C
C     ITMP1 = 1 FOR INCIDENT PLANE WAVE, LINEAR POLARIZATION
C             2 FOR INCIDENT PLANE WAVE, RIGHT-HAND ELLIPTIC POL.
C             3 FOR INCIDENT PLANE WAVE, LEFT-HAND ELLIPTIC POL.
C          TMP1,TMP2,TMP3 = THETA, PHI AND ETA DEFINING DIRECTION AND
C                           POLARIZATION OF INCIDENT WAVE (DEGREES)
C          TMP4 = INCREMENT FOR THETA (DEGREES)
C          TMP5 = INCREMENT FOR PHI (DEGREES)
C          TMP6 = AXIAL RATIO FOR ELLIPTIC POLARIZATION
C          TMP7 = FIELD STRENGTH (V/M) (MAJOR AXIS FOR ELLIPTIC POL.)
C          ITMP2 = NUMBER OF INCREMENTS IN THETA
C          ITMP3 = NUMBER OF INCREMENTS IN PHI
C
C     ITMP1 = 4 FOR HERTZIAN DIPOLE SOURCE
C          TMP1,TMP2,TMP3 = X,Y,Z COORDINATES OF CENTER OF THE DIPOLE
C          TMP4,TMP5 = ELEVATION AND AZIMUTH ANGLES OF DIPOLE (DEG.)
C          TMP6 = CURRENT MOMENT (AMP-METERS)
C
C     ITMP1 = 5 FOR BICONE VOLTAGE SOURCE
C          ITMP2 = TAG NUMBER OF SOURCE SEGMENT
C          ITMP3 = SEGMENT NUMBER OR NUMBER WITHIN TAG SET
C          CMPLX(TMP1,TMP2) = SOURCE VOLTAGE
C
C     OUTPUT (IN ADDITION TO PARAMETERS STORED IN COMMON/SORCES/):
C
C     IFLOW = FLAG TO INDICATE PREVIOUS COMMAND (= 5 FOR "EX" COMMAND)
C     IGO = FLAG TO INDICATE POINT FROM WHICH SOLUTION MUST BE REPEATED
C     IPED = FLAG TO REQUEST NORMALIZATION OF IMPEDANCES FROM FREQ. LOOP
C     MASYM = FLAG TO REQUEST CALC. OF MAX. RELATIVE MATRIX ASYMMETRY
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON /SORCES/ PSOR1(NSOMAX),PSOR2(NSOMAX),PSOR3(NSOMAX),
     &PSOR4(NSOMAX),PSOR5(NSOMAX),PSOR6(NSOMAX),DTHINC,DPHINC,NTHINC,
     &NPHINC,NSCINC,NSORC,ISORTP(NSOMAX)
C
C     INITIALIZE IF STARTING A NEW SET OF EX COMMANDS
C
      IF (IFLOW.NE.5)THEN
         IFLOW=5
         NSORC=0
         IPED=0
         IF (IGO.GT.3) IGO=3
      END IF
C
C     STORE INPUT DATA
C
      NSORC=NSORC+1
      IF(NSORC.GT.NSOMAX)THEN
         WRITE(3,90)
         STOP
      END IF
      IXTYP=ITMP1
      NTSOL=0
      IF (ITMP1.EQ.0.OR.ITMP1.EQ.5) THEN
C
C     VOLTAGE SOURCE - APPLIED FIELD OR BICONE.
C
         ISORTP(NSORC)=1
         IF(ITMP1.EQ.5)ISORTP(NSORC)=4
         PSOR1(NSORC)=ISEGNO(ITMP2,ITMP3)
         PSOR2(NSORC)=TMP1
         PSOR3(NSORC)=TMP2
         IF(TMP1**2+TMP2**2.LT.1.E-37)PSOR2(NSORC)=1.
         IPED=ITMP4-(ITMP4/10)*10
         ZPNORM=TMP3
         NTHINC=1
         NPHINC=1
         RETURN
      ELSE IF (ITMP1.GE.1.AND.ITMP1.LE.3)THEN
C
C     INCIDENT PLANE WAVE, LINEAR OR ELLIPTIC POLARIZATION
C
         ISORTP(NSORC)=2
         PSOR1(NSORC)=TMP1
         PSOR2(NSORC)=TMP2
         PSOR3(NSORC)=TMP3
         PSOR4(NSORC)=1.
         IF(ABS(TMP7).GT.1.E-25)PSOR4(NSORC)=TMP7
         PSOR5(NSORC)=0.
         IF(ITMP1.EQ.2)PSOR5(NSORC)=TMP6
         IF(ITMP1.EQ.3)PSOR5(NSORC)=-TMP6
         NTHINC=ITMP2
         NPHINC=ITMP3
         DTHINC=TMP4
         DPHINC=TMP5
         NSCINC=NSORC
         RETURN
      ELSE IF(ITMP1.EQ.4)THEN
C
C     HERTZIAN DIPOLE SOURCE
C
         ISORTP(NSORC)=3
         PSOR1(NSORC)=TMP1
         PSOR2(NSORC)=TMP2
         PSOR3(NSORC)=TMP3
         PSOR4(NSORC)=TMP4
         PSOR5(NSORC)=TMP5
         PSOR6(NSORC)=TMP6
         NTHINC=1
         NPHINC=1
         RETURN
      END IF
C
C     INVALID EXCITATION TYPE
C
      WRITE(3,91)ITMP1
      STOP
C
90    FORMAT (///,10X,'RSETEX: NUMBER OF EXCITATION COMMANDS EXCEEDS',
     &' STORAGE ALLOTTED')
91    FORMAT(' RSETEX: ERROR IN EX COMMAND - EXCITATION TYPE',I5,' IS',
     &' INVALID')
      END
      SUBROUTINE RSETXQ(ITMP1,IFLOW)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     RSETXQ stores data from XQ commands from the input file.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,FRATI,ETAL2
      COMMON /RPDAT/ THETS,DTH,PHIS,DPH,RFLD,GNOR,NTH,NPH,IPD,IAVP,INOR,
     &IAX
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      IF (ITMP1.EQ.0) THEN
         IF (IFLOW.LE.7) THEN
            IFLOW=7
         ELSE
            IFLOW=11
         END IF
         RETURN
      END IF
      IFAR=0
      RFLD=0.
      IPD=0
      IAVP=0
      INOR=0
      IAX=0
      NTH=91
      NPH=1
      THETS=0.
      PHIS=0.
      DTH=1.0
      DPH=0.
      IF (ITMP1.EQ.2) PHIS=90.
      IF (ITMP1.NE.3) RETURN
      NPH=2
      DPH=90.
      RETURN
      END
      SUBROUTINE RSETRP(ITMP1,ITMP2,ITMP3,ITMP4,TMP1,TMP2,TMP3,TMP4,
     &TMP5,TMP6,IFLOW)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     RSETRP stores data from RP commands
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,FRATI,ETAL2
      COMMON /RPDAT/ THETS,DTH,PHIS,DPH,RFLD,GNOR,NTH,NPH,IPD,IAVP,INOR,
     &IAX
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      IFAR=ITMP1
      NTH=ITMP2
      NPH=ITMP3
      IF (NTH.EQ.0) NTH=1
      IF (NPH.EQ.0) NPH=1
      IPD=ITMP4/10
      IAVP=ITMP4-IPD*10
      INOR=IPD/10
      IPD=IPD-INOR*10
      IAX=INOR/10
      INOR=INOR-IAX*10
      IF (IAX.NE.0) IAX=1
      IF (IPD.NE.0) IPD=1
      IF (NTH.LT.2.OR.NPH.LT.2) IAVP=0
      IF (IFAR.EQ.1) IAVP=0
      THETS=TMP1
      PHIS=TMP2
      DTH=TMP3
      DPH=TMP4
      RFLD=TMP5
      GNOR=TMP6
      IFLOW=10
      RETURN
      END
      SUBROUTINE RSETNF(AIN,ITMP1,ITMP2,ITMP3,ITMP4,TMP1,TMP2,TMP3,TMP4,
     &TMP5,TMP6,IFLOW)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     RSETNF stores data from NE or NH commands requesting near field
C     output.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*2 AIN
      COMPLEX*16 ENINTG,HNINTG
      COMMON /NFDAT/ ENINTG,HNINTG,XNR,YNR,ZNR,DXNR,DYNR,DZNR,NEAR,NFEH,
     &NRX,NRY,NRZ
      COMMON/FRQDAT/IFRQ,NFRQ,FMHZS,DELFRQ,FMHZ
      IF(AIN.EQ.'NE')NFEH=0
      IF(AIN.EQ.'NH')NFEH=1
      IF ((IFLOW.EQ.8.OR.IFLOW.EQ.9).AND.NFRQ.NE.1) WRITE(3,90)
      NEAR=ITMP1
      NRX=ITMP2
      NRY=ITMP3
      NRZ=ITMP4
      XNR=TMP1
      YNR=TMP2
      ZNR=TMP3
      DXNR=TMP4
      DYNR=TMP5
      DZNR=TMP6
      IFLOW=8
      RETURN
C
90    FORMAT(///,' WHEN MULTIPLE FREQUENCIES ARE REQUESTED, ONLY ONE',
     &' NEAR FIELD REQUEST CAN BE USED -',/,' LAST REQUEST READ IS',
     &' USED')
      END
      SUBROUTINE RSETNL(AIN,ITMP1,ITMP2,TMP1,TMP2,TMP3,TMP4,TMP5,TMP6,
     &IFLOW)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     RSETNL stores data from LE or LH commands requesting computation
C     of near E or H fields along a line.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*2 AIN
      COMPLEX*16 ENINTG,HNINTG
      COMMON /NFDAT/ ENINTG,HNINTG,XNR,YNR,ZNR,DXNR,DYNR,DZNR,NEAR,NFEH,
     &NRX,NRY,NRZ
      COMMON/FRQDAT/IFRQ,NFRQ,FMHZS,DELFRQ,FMHZ
      IF(AIN.EQ.'LE')NFEH=0
      IF(AIN.EQ.'LH')NFEH=1
      IF(IFLOW.NE.9.OR.ITMP1.EQ.-1)THEN
         ENINTG=(0.,0.)
         HNINTG=(0.,0.)
      END IF
      IF ((IFLOW.EQ.8.OR.IFLOW.EQ.9).AND.NFRQ.NE.1) WRITE(3,90)
      NEAR=2
      NRX=ITMP2
      XNR=TMP1
      YNR=TMP2
      ZNR=TMP3
      DXNR=TMP4
      DYNR=TMP5
      DZNR=TMP6
      IFLOW=9
      RETURN
C
90    FORMAT(///,' WHEN MULTIPLE FREQUENCIES ARE REQUESTED, ONLY ONE',
     &' NEAR FIELD REQUEST CAN BE USED -',/,' LAST REQUEST READ IS',
     &' USED')
      END
      SUBROUTINE RSETCP(ITMP1,ITMP2,ITMP3,ITMP4,IFLOW)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     RSETCP stores data from a CP command to request calculation of
C     maximum coupling
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON/CPPRAM/ICPT1,ICPS1,ICPT2,ICPS2
      IFLOW=13
      ICPT1=ITMP1
      ICPS1=ITMP2
      ICPT2=ITMP3
      ICPS2=ITMP4
      RETURN
      END
      SUBROUTINE RSETVC(ITMP1,IGO,IFLOW)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON /VLCAPC/IVCAP
      IF(IGO.GT.2)IGO=2
      IFLOW=1
      IVCAP=1
      IF(ITMP1.EQ.1)IVCAP=0
      RETURN
      END
      SUBROUTINE RSETUM(TMP1,TMP2,IGO,IFLOW,ICASX)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     RSETUM stores upper medium parameters from a UM command.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON/SETGN/GEPS,GSIG,UEPS,USIG
      IF(ICASX.NE.0)THEN
         WRITE(3,90)
         STOP
      END IF
      UEPS=TMP1
      USIG=TMP2
      IF(UEPS.EQ.0.)THEN
         UEPS=1.
         USIG=0.
      END IF
      IF(IGO.GT.2)IGO=2
      IFLOW=1
      RETURN
C
90    FORMAT(/,' RSETUM: ERROR - UM COMMAND IS NOT ALLOWED WITH N.G.F.')
      END
      SUBROUTINE RSETJN(ITMP1,IGO,IFLOW)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     RSETJN selects the method for determining the charge at a junction
C
C     ISETJN = 1 for MM solution for charge
C              2 for charge proportional to log of wire radius (Wu-King)
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON/SETJN/ISETJN
      IF(ITMP1.EQ.0)THEN
         ISETJN=2
      ELSE
         ISETJN=1
      END IF
      IF(IGO.GT.2)IGO=2
      IFLOW=1
      RETURN
C
      END
      SUBROUTINE RSETGD(ITMP1,TMP1,TMP2,TMP3,TMP4,IFLOW)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     RSETGD stores parameters from a GD command defining second ground
C     medium or cliff.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,FRATI,ETAL2
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      ICLIFT=ITMP1
      EPSR2=TMP1
      SIG2=TMP2
      CLIFL=TMP3
      CLIFH=TMP4
      IFLOW=4
      RETURN
      END
      SUBROUTINE RSETPT(ITMP1,ITMP2,ITMP3,ITMP4)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     RSETPT stores parameters from a PT command limiting printing of
C     currents.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON/PTCONT/IPTFLG,IPTAG,IPTAGF,IPTAGT,IPTFLQ,IPTAQ,IPTAQF,
     &IPTAQT
      IPTFLG=ITMP1
      IPTAG=ITMP2
      IPTAGF=ITMP3
      IPTAGT=ITMP4
      IF(ITMP3.EQ.0.AND.IPTFLG.NE.-1)IPTFLG=-2
      IF (ITMP4.EQ.0) IPTAGT=IPTAGF
      RETURN
      END
      SUBROUTINE RSETPQ(ITMP1,ITMP2,ITMP3,ITMP4)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     RSETPQ stores parameters from a PQ command requesting printing of
C     charge on wires.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON/PTCONT/IPTFLG,IPTAG,IPTAGF,IPTAGT,IPTFLQ,IPTAQ,IPTAQF,
     &IPTAQT
      IPTFLQ=ITMP1
      IPTAQ=ITMP2
      IPTAQF=ITMP3
      IPTAQT=ITMP4
      IF(ITMP3.EQ.0.AND.IPTFLQ.NE.-1)IPTFLQ=-2
      IF(ITMP4.EQ.0)IPTAQT=IPTAQF
      RETURN
      END
      SUBROUTINE RSETGN(ITMP1,ITMP2,TMP1,TMP2,TMP3,TMP4,TMP5,TMP6,
     &FILNAM,IGO,IFLOW,ICASX)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     RSETGN stores parameters from a GN command defining ground
C     parameters in COMMON/GND/.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER FILNAM*40,SOMFIL*40
      COMPLEX*16 XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,FRATI,ETAL2
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      COMMON /GNDFIL/NSFILE,SOMFIL
      COMMON/SETGN/GEPS,GSIG,UEPS,USIG
      IFLOW=4
      IF(ICASX.NE.0)THEN
         WRITE(3,90)
         STOP
      END IF
      IF (IGO.GT.2) IGO=2
      IF (ITMP1.EQ.(-1))THEN
         KSYMP=1
         NRADL=0
         IPERF=0
         RETURN
      END IF
      IPERF=ITMP1
      NRADL=ITMP2
      KSYMP=2
      GEPS=TMP1
      GSIG=TMP2
      IF (NRADL.GT.0)THEN
         IF(IPERF.EQ.2)THEN
            WRITE(3,91)
            STOP
         END IF
         SCNRAD=TMP3
         SCNWRD=TMP4
         RETURN
      END IF
      IF(TMP3.GT.1.E-20)THEN
         ICLIFT=1
         EPSR2=TMP3
         SIG2=TMP4
         CLIFL=TMP5
         CLIFH=TMP6
      END IF
      IF(FILNAM.EQ.' ')THEN
         FILNAM='SOMD.NEC'
      ELSE
         NSFILE=0
      END IF
      SOMFIL=FILNAM
      RETURN
C
90    FORMAT(/,' RSETGN: ERROR - GN COMMAND IS NOT ALLOWED WITH N.G.F.')
91    FORMAT(' RSETGN: RADIAL WIRE G. S. APPROXIMATION MAY NOT BE USED',
     &' WITH SOMMERFELD GROUND OPTION')
      END
      SUBROUTINE RSETIS(ITMP1,ITMP2,ITMP3,ITMP4,TMP1,TMP2,TMP3,IGO,
     &IFLOW)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     RSETIS stores parameters for an insulating sheath from an IS
C     command.  Parameters are stored in COMMON/INSPAR/.
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 CEINS
      COMMON/INSCOM/CEINS(MAXSEG),BRINS(MAXSEG),NINS,NINSF,INTAG(MAXIS),
     &INTAGF(MAXIS),INTAGT(MAXIS),EPSIN(MAXIS),SIGIN(MAXIS),RADIN(MAXIS)
      IF (IFLOW.NE.2) THEN
         IFLOW=2
         NINS=0
         IF (IGO.GT.2) IGO=2
         IF (ITMP1.EQ.(-1)) RETURN
      END IF
      NINS=NINS+1
      IF (NINS.GT.MAXIS) THEN
         WRITE(3,90)
         STOP
      END IF
      INTAG(NINS)=ITMP2
      IF (ITMP4.EQ.0) ITMP4=ITMP3
      INTAGF(NINS)=ITMP3
      INTAGT(NINS)=ITMP4
      IF (ITMP4.LT.ITMP3) THEN
         WRITE(3,91) NINS,ITMP3,ITMP4
         STOP
      END IF
      EPSIN(NINS)=TMP1
      SIGIN(NINS)=TMP2
      RADIN(NINS)=TMP3
      RETURN
C
90    FORMAT(///,10X,'RSETIS: NUMBER OF IS COMMANDS EXCEEDS STORAGE',
     &' ALLOTTED')
91    FORMAT (///,10X,'RSETIS: DATA FAULT ON IS COMMAND NO.',I5,5X,
     &'ITAG STEP1=',I5,'  IS GREATER THAN ITAG STEP2=',I5)
      END
      SUBROUTINE RSETLD(ITMP1,ITMP2,ITMP3,ITMP4,TMP1,TMP2,TMP3,IGO,
     &IFLOW)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     RSETLD stores loading parameters from a LD command into
C     COMMON/ZLOAD/.
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 ZARRAY
      COMMON/ZLOAD/ ZARRAY(MAXSEG),NLOAD,NLODF,LDTYP(LOADMX),
     &LDTAG(LOADMX),LDTAGF(LOADMX),LDTAGT(LOADMX),ZLR(LOADMX),
     &ZLI(LOADMX),ZLC(LOADMX)
      IF (IFLOW.NE.3) THEN
         IFLOW=3
         NLOAD=0
         IF (IGO.GT.2) IGO=2
         IF (ITMP1.EQ.(-1)) RETURN
      END IF
      NLOAD=NLOAD+1
      IF (NLOAD.GT.LOADMX) THEN
         WRITE(3,90)
         STOP
      END IF
      LDTYP(NLOAD)=ITMP1
      LDTAG(NLOAD)=ITMP2
      IF (ITMP4.EQ.0) ITMP4=ITMP3
      LDTAGF(NLOAD)=ITMP3
      LDTAGT(NLOAD)=ITMP4
      IF (ITMP4.LT.ITMP3) THEN
         WRITE(3,91) NLOAD,ITMP3,ITMP4
         STOP
      END IF
      ZLR(NLOAD)=TMP1
      ZLI(NLOAD)=TMP2
      ZLC(NLOAD)=TMP3
      RETURN
C
90    FORMAT(///,10X,'RSETLD: NUMBER OF LD COMMANDS EXCEEDS STORAGE',
     &' ALLOTTED')
91    FORMAT (///,10X,'RSETLD: DATA FAULT ON LD COMMAND NO.',I5,5X,
     &'ITAG STEP1=',I5,'  IS GREATER THAN ITAG STEP2=',I5)
      END
      SUBROUTINE RSETFR(ITMP1,ITMP2,TMP1,TMP2,IGO,IFLOW,ICASX,IPED,
     &ZPNORM)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     RSETFR stores frequency and looping parameters from the FR command
C     into COMMON/FRQDAT/.
C
C     INPUT:
C     ITMP1 = 0 FOR LINEAR INCREMENTING, 1 FOR MULTIPLICATIVE INCREMENT
C     ITMP2 = NUMBER OF FREQUENCY STEPS
C     TMP1 = INITIAL FREQUENCY (MHZ)
C     TMP2 = FREQUENCY INCREMENT (MHZ FOR LINEAR INC., FACTOR FOR MULT.)
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON/FRQDAT/IFRQ,NFRQ,FMHZS,DELFRQ,FMHZ
      IF(ICASX.NE.0)THEN
         WRITE(3,90)
         STOP
      END IF
      IFRQ=ITMP1
      NFRQ=ITMP2
      IF (NFRQ.EQ.0) NFRQ=1
      FMHZS=TMP1
      DELFRQ=TMP2
      IF(IPED.EQ.1)ZPNORM=0.
      IGO=1
      IFLOW=1
      RETURN
C
90    FORMAT(/,' RSETFR: ERROR - FR COMMAND IS NOT ALLOWED WITH N.G.F.')
      END
      SUBROUTINE RSETNT(AIN,ITMP1,ITMP2,ITMP3,ITMP4,TMP1,TMP2,TMP3,TMP4,
     &TMP5,TMP6,IFLOW,IGO,NTSOL)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     RSETNT stores parameters from NT or TL commands into
C     COMMON/NETDEF/.
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*2 AIN
      COMPLEX*16 TLYT1,TLYT2,YN11,YN12,YN22,SVOLTS
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON/NETDEF/TLYT1(NETMX),TLYT2(NETMX),YN11(NETMX),YN12(NETMX),
     &YN22(NETMX),SVOLTS(NSOMAX),TLZCH(NETMX),TLLEN(NETMX),NVSOR,
     &NVSORA(NSOMAX),ISEG1(NETMX),ISEG2(NETMX),NONET,NETYP(NETMX)
      IF (IFLOW.NE.6) THEN
         IFLOW=6
         NONET=0
         NTSOL=0
         IF (IGO.GT.3) IGO=3
         IF (ITMP2.EQ.(-1)) RETURN
      END IF
      NONET=NONET+1
      IF (NONET.GT.NETMX) THEN
         WRITE(3,90)
         STOP
      END IF
      ISEG1(NONET)=ISEGNO(ITMP1,ITMP2)
      ISEG2(NONET)=ISEGNO(ITMP3,ITMP4)
      IF (AIN.EQ.'NT') THEN
           NETYP(NONET)=1
           YN11(NONET)=DCMPLX(TMP1,TMP2)
           YN12(NONET)=DCMPLX(TMP3,TMP4)
           YN22(NONET)=DCMPLX(TMP5,TMP6)
           RETURN
      ELSE
           IF(TMP1.GE.0.)NETYP(NONET)=2
           IF(TMP1.LT.0.)NETYP(NONET)=3
           TLZCH(NONET)=ABS(TMP1)
           IF(ABS(TMP2).LT.1.E-20)THEN
C
C     TRANSMISSION LINE LENGTH IS ZERO SO SET IT TO THE DISTANCE BETWEEN
C     CONNECTION POINTS
C
                ISG1=ISEG1(NONET)
                ISG2=ISEG2(NONET)
                TMP2=SQRT((X(ISG2)-X(ISG1))**2+(Y(ISG2)-Y(ISG1))**2+
     &          (Z(ISG2)-Z(ISG1))**2)
           END IF
           TLLEN(NONET)=TMP2
           TLYT1(NONET)=DCMPLX(TMP3,TMP4)
           TLYT2(NONET)=DCMPLX(TMP5,TMP6)
      END IF
      RETURN
C
90    FORMAT (///,10X,'RSETNT: NUMBER OF NETWORK COMMANDS EXCEEDS',
     &' STORAGE ALLOTTED')
      END
      SUBROUTINE ETMNS (E)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     ETMNS is the master routine for filling the excitation array E.
C     E is the right hand side of the matrix equation for current.
C
C     DESCRIPTION:
C     ETMNS FILLS THE ARRAY E FOR THE EXCITATION DESCRIBED IN COMMON
C     BLOCK /SORCES/.
C
C     INPUT: FROM COMMON/SORCES/.
C
C     OUTPUT:
C     E(I) FOR I= 1 THROUGH N CONTAINS THE NEGATIVE OF THE INCIDENT
C          ELECTRIC FIELD ON THE N WIRE SEGMENTS.
C     E(I) FOR I=N+1 THROUGH N+2*M CONTAINS THE TANGENTIAL COMPONENTS OF
C          MAGNETIC FIELD ON THE M PATCHES.
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 E(*)
      COMMON /SORCES/ PSOR1(NSOMAX),PSOR2(NSOMAX),PSOR3(NSOMAX),
     &PSOR4(NSOMAX),PSOR5(NSOMAX),PSOR6(NSOMAX),DTHINC,DPHINC,NTHINC,
     &NPHINC,NSCINC,NSORC,ISORTP(NSOMAX)
      DATA TA/.01745329252D0/
C
C     INITIALIZE ARRAY E
C
      CALL SORINI(E)
      DO 10 ISOR=1,NSORC
      GO TO (1,2,3,4),ISORTP(ISOR)
C
C     APPLIED FIELD VOLTAGE SOURCE
C
1     CALL SORVT1(IROUND(PSOR1(ISOR)),DCMPLX(PSOR2(ISOR),PSOR3(ISOR)),E)
      GO TO 10
C
C     INCIDENT PLANE WAVE SOURCE
C
2     CALL SORPWA(PSOR1(ISOR)*TA,PSOR2(ISOR)*TA,PSOR3(ISOR)*TA,
     &PSOR4(ISOR),PSOR5(ISOR),E)
      GO TO 10
C
C     HERTZIAN DIPOLE SOURCE
C
3     CALL SORHTZ(PSOR1(ISOR),PSOR2(ISOR),PSOR3(ISOR),PSOR4(ISOR)*TA,
     &PSOR5(ISOR)*TA,PSOR6(ISOR),E)
      GO TO 10
C
C     CHARGE DISCONTINUITY (BICONE) VOLTAGE SOURCE
C
4     CALL SORVQD(IROUND(PSOR1(ISOR)),DCMPLX(PSOR2(ISOR),PSOR3(ISOR)),E)
10    CONTINUE
      RETURN
      END
      SUBROUTINE SORINI(E)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     SORINI initializes the excitation array E to zero.
C
C     DESCRIPTION:
C     INPUT: NEQMAT = LENGTH OF EXCITATION ARRAY TO BE INITIALIZED
C                    (NEQMAT = NO. SEGMENTS + 2* NO. OF PATCHES)
C
C     OUTPUT: ARRAY E SET TO ZERO
C
      INCLUDE 'NECPAR.INC'
      PARAMETER (IRESRV=MAXMAT**2)
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 E,CM
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON /CMB/CM(IRESRV),IP(2*MAXSEG),IB11,IC11,ID11,NEQMAT,NEQ,NEQ2
      DIMENSION E(*)
      DO 1 I=1,NEQMAT
1     E(I)=(0.,0.)
      RETURN
      END
      SUBROUTINE SORVT1(ISEG,VOLTS,E)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     SORVT1 increments the excitation array E by the field of an
C     applied-field voltage source.  The field due to end caps on the
C     source segment is included if IVCAP=1.
C
C     DESCRIPTION:
C     INPUT:
C     ISEG = NUMBER OF THE SEGMENT ON WHICH THE VOLTAGE SOURCE IS
C            LOCATED
C     VOLTS = SOURCE VOLTAGE (VOLTS)
C     SI(ISEG) = LENGTH OF SEGMENT ISEG (FROM COMMON/DATA/)
C
C     OUTPUT:
C     E = EXCITATION ARRAY INCREMENTED BY FIELD OF VOLTAGE SOURCE
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 VOLTS,E
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON /VLCAPC/IVCAP
      DIMENSION E(*),CAB(MAXSEG),SAB(MAXSEG)
      EQUIVALENCE (CAB,ALP),(SAB,BET)
      E(ISEG)=E(ISEG)-VOLTS/SI(ISEG)
      IF(IVCAP.EQ.1)THEN
         CALL VLTCAP(X(ISEG),Y(ISEG),Z(ISEG),CAB(ISEG),SAB(ISEG),
     &   SALP(ISEG),SI(ISEG),BI(ISEG),VOLTS,E)
      END IF
      RETURN
      END
      SUBROUTINE SORPWA(THET,PHI,ET,EMAX,AXRAT,E)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     SORPWA increments the excitation array E by the field of a plane
C     wave with linear or elliptic polarization.
C
C     DESCRIPTION:
C     INPUT:
C     THET,PHI = ANGLES (RADIANS) IN SPHERICAL COORDINATES OF THE VECTOR
C                TOWARD THE SOURCE OF THE PLANE WAVE.
C     ET = POLARIZATION ANGLE OF E FIELD.  FOR ET=0, E FIELD IS ALONG
C          THE THETA UNIT VECTOR.  POSITIVE ET ROTATES POLARIZATION
C          COUNTER CLOCKWISE WHEN VIEWED IN THE DIRECTION OF PROPAGATION
C     EMAX = MAGNITUDE OF E FIELD (ALONG MAJOR AXIS OF POLARIZATION
C            ELLIPSE)
C     AXRAT = RATIO OF MINOR AXIS TO MAJOR AXIS FIELD (POSITIVE FOR
C             RIGHT HAND POLARIZATION.
C
C     OUTPUT:
C     E = EXCITATION ARRAY INCREMENTED BY FIELD OF PLANE WAVE
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 E,XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,FRATI,ETAL2,FJ,CX,CY,
     &CZ,XK,XKX,ETA,CKX,CKY,CKZ,YSTE,ZSTM,RX,RY,RZ,TX,TY,TZ,CKZX,ARG,
     &RCX,RCY,RCZ,ROMU,THX,THY,THZ
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      DIMENSION CAB(MAXSEG),SAB(MAXSEG),T1X(MAXSEG),T1Y(MAXSEG),
     &   T1Z(MAXSEG)
      DIMENSION E(*)
      EQUIVALENCE (CAB,ALP),(SAB,BET),(T1X,SI),(T1Y,ALP),(T1Z,BET)
      DATA FJ/(0.D0,1.D0)/
      CTH=COS(THET)
      STH=SIN(THET)
      CPH=COS(PHI)
      SPH=SIN(PHI)
      CET=COS(ET)
      SET=SIN(ET)
C
C     WX,WY,WZ = UNIT VECTOR IN DIRECTION OF PROPAGATION
C     PX,PY,PZ = UNIT VECTOR IN DIRECTION OF MAJOR AXIS OF POLARIZATION
C     QX,QY,QZ = UNIT VECTOR IN DIRECTION OF MINOR AXIS OF POLARIZATION
C     CX,CY,CZ = COMPLEX VECTOR FOR INCIDENT E FIELD
C     CKX,CKY,CKZ = COMPLEX PROPAGATION VECTOR (K)
C
      PX=CTH*CPH*CET-SPH*SET
      PY=CTH*SPH*CET+CPH*SET
      PZ=-STH*CET
      WX=-STH*CPH
      WY=-STH*SPH
      WZ=-CTH
      QX=WY*PZ-WZ*PY
      QY=WZ*PX-WX*PZ
      QZ=WX*PY-WY*PX
      CX=EMAX*(PX-FJ*AXRAT*QX)
      CY=EMAX*(PY-FJ*AXRAT*QY)
      CZ=EMAX*(PZ-FJ*AXRAT*QZ)
      IF (CTH.GT.-1.E-7) THEN
C
C     RAY IS INCIDENT ON THE INTERFACE FROM ABOVE
C
         SIDE=1.
         XK=XKU
         XKX=XKL
         ETA=ETAU
      ELSE
C
C     RAY IS INCIDENT ON THE INTERFACE FROM BELOW
C
         SIDE=-1.
         XK=XKL
         XKX=XKU
         ETA=ETAL
      END IF
      IF(KSYMP.EQ.1)SIDE=0.
      CKX=XK*WX
      CKY=XK*WY
      CKZ=XK*WZ
      IF (KSYMP.GT.1) THEN
C
C     IF SOURCE IS IN A CONDUCTING HALF SPACE, THEN THE FIELD IS ZERO.
C
         IF(DIMAG(XK).LT.0.)RETURN
         IF(IPERF.EQ.1.AND.SIDE.LT.0.)RETURN
C
C     FINITELY CONDUCTING GROUND.  COMPUTE REF. AND TRANS. FIELD.
C
         CALL ZYSURF(CTH,0.D0,0.D0,SIDE,IPERFG,YSTE,ZSTM)
         CALL REFCOF(CTH,-SPH,CPH,ETA,IPERFG,YSTE,ZSTM,CX,CY,CZ,RX,RY,RZ
     &   )
         IF(IPERF.NE.1)THEN
            CALL TRXKNO(CTH,XK,XKX,CKZX)
            CALL TRXCOF(-SPH,CPH,CKZ,CKZX,XK,XKX,CX,CY,CZ,TX,TY,TZ)
         END IF
      END IF
      IF (N.EQ.0) GO TO 17
      DO 16 I=1,N
      IF (SIDE*Z(I).GE.0.) THEN
C
C     DIRECT FIELD
C
         ARG=CKX*X(I)+CKY*Y(I)+CKZ*Z(I)
         E(I)=E(I)-(CX*CAB(I)+CY*SAB(I)+CZ*SALP(I))*EXP(-FJ*ARG)
         IF (KSYMP.EQ.1) GO TO 16
         IF(ICLIFT.EQ.0.AND.NRADL.EQ.0)THEN
C
C     REFLECTED FIELD FOR UNIFORM GROUND
C
            ARG=CKX*X(I)+CKY*Y(I)-CKZ*Z(I)
            E(I)=E(I)-(RX*CAB(I)+RY*SAB(I)+RZ*SALP(I))*EXP(-FJ*ARG)
C
C     REFLECTED FIELD FOR VARYING GROUND
C
         ELSE
            CALL REFPT1(WX,WY,WZ,X(I),Y(I),Z(I),XSP,YSP,ZSP)
            CALL ZYSURF(CTH,XSP,YSP,SIDE,IPERFG,YSTE,ZSTM)
            CALL REFCOF(CTH,-SPH,CPH,ETA,IPERFG,YSTE,ZSTM,CX,CY,CZ,RCX,
     &      RCY,RCZ)
            ARG=CKX*X(I)+CKY*Y(I)-CKZ*(Z(I)-2.*ZSP)
            E(I)=E(I)-(RCX*CAB(I)+RCY*SAB(I)+RCZ*SALP(I))*EXP(-FJ*ARG)
         END IF
      ELSE
C
C     FIELD TRANSMITTED ACROSS INTERFACE
C
         ARG=CKX*X(I)+CKY*Y(I)+CKZX*Z(I)
         E(I)=E(I)-(TX*CAB(I)+TY*SAB(I)+TZ*SALP(I))*EXP(-FJ*ARG)
      END IF
16    CONTINUE
17    IF (M.EQ.0) RETURN
C
C     MAGNETIC FIELD FOR PATCHES
C     MAGNETIC FIELD COMPONENTS ARE COMPUTED FROM (K VECTOR) X (E)
C
      ROMU=1./(XKU*ETAU)
      THX=CX
      THY=CY
      THZ=CZ
      CX=(CKY*THZ-CKZ*THY)*ROMU
      CY=(CKZ*THX-CKX*THZ)*ROMU
      CZ=(CKX*THY-CKY*THX)*ROMU
      IF (KSYMP.GT.1) THEN
C
C     SET UP FOR REFLECTED FIELD
C
         THX=RX
         THY=RY
         THZ=RZ
         RX=(CKY*THZ+CKZ*THY)*ROMU
         RY=(-CKZ*THX-CKX*THZ)*ROMU
         RZ=(CKX*THY-CKY*THX)*ROMU
         IF (IPERF.NE.1) THEN
            THX=(CKY*TZ-CKZX*TY)*ROMU
            THY=(CKZX*TX-CKX*TZ)*ROMU
            THZ=(CKX*TY-CKY*TX)*ROMU
         END IF
      END IF
      I=LD+1
      I1=N-1
      DO 21 IS=1,M
      I=I-1
      I1=I1+2
      I2=I1+1
      IF((KSYMP.EQ.1.OR.IPERF.EQ.1).OR.CTH*Z(I).GE.0.)THEN
C
C     DIRECT MAGNETIC FIELD
C
         ARG=EXP(-FJ*(CKX*X(I)+CKY*Y(I)+CKZ*Z(I)))*SALP(I)
         E(I2)=E(I2)+(CX*T1X(I)+CY*T1Y(I)+CZ*T1Z(I))*ARG
         E(I1)=E(I1)+(CX*T2X(I)+CY*T2Y(I)+CZ*T2Z(I))*ARG
         IF (KSYMP.GT.1) THEN
C
C     REFLECTED MAGNETIC FIELD
C
            ARG=EXP(-FJ*(CKX*X(I)+CKY*Y(I)-CKZ*Z(I)))*SALP(I)
            E(I2)=E(I2)+(RX*T1X(I)+RY*T1Y(I)+RZ*T1Z(I))*ARG
            E(I1)=E(I1)+(RX*T2X(I)+RY*T2Y(I)+RZ*T2Z(I))*ARG
         END IF
      ELSE
C
C     MAGNETIC FIELD TRANSMITTED ACROSS INTERFACE
C
         ARG=EXP(-FJ*(CKX*X(I)+CKY*Y(I)+CKZX*Z(I)))*SALP(I)
         E(I2)=E(I2)+(THX*T1X(I)+THY*T1Y(I)+THZ*T1Z(I))*ARG
         E(I1)=E(I1)+(THX*T2X(I)+THY*T2Y(I)+THZ*T2Z(I))*ARG
      END IF
21    CONTINUE
      RETURN
      END
      SUBROUTINE SORHTZ(XS,YS,ZS,DALP,DBET,DIPMOM,E)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     SORHTZ increments the excitation array E by the field of a
C     hertzian dipole source.
C
C     DESCRIPTION:
C     INPUT:
C     XS,YS,ZS = COORDINATES OF THE HERTZIAN DIPOLE SOURCE
C     DALP = ELEVATION ANGLE (RADIANS) OF THE HERTZIAN DIPOLE ABOVE THE
C            X-Y PLANE
C     DBET = ANGLE (RADIANS) BETWEEN X AXIS AND THE PROJECTION OF THE
C            HERTZIAN DIPOLE ONTO THE X-Y PLANE
C     DIPMOM = DIPOLE MOMENT OF HERTZIAN DIPOLE
C
C     OUTPUT:
C     E = EXCITATION ARRAY INCREMENTED BY THE FIELD OF THE HERTZIAN
C         DIPOLE
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 E,XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,FRATI,ETAL2,XKSEG,FJ,
     &DS,ARG,TT1,ER,ET,EZH,ERH,CX,CY,CZ,EGND
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      COMMON /INCOM/ XKSEG,SEGL,XSJ,YSJ,ZSJ,DIRX,DIRY,DIRZ,SN,XSN,YSN,
     &XO,YO,ZO,ISNOR,IREG,IDIRX
      DIMENSION E(*),CAB(MAXSEG),SAB(MAXSEG),T1X(MAXSEG),T1Y(MAXSEG),
     &   T1Z(MAXSEG),EGND(9)
      EQUIVALENCE (CAB,ALP),(SAB,BET),(T1X,SI),(T1Y,ALP),(T1Z,BET)
      COMMON/CONSTN/PI,TP,DTORAD,CVEL,EPSRZ,RMUZ,ETAZ
      DATA FJ/(0.D0,1.D0)/
      DDZ=COS(DALP)
      DDX=DDZ*COS(DBET)
      DDY=DDZ*SIN(DBET)
      DDZ=SIN(DALP)
      IF (IPERF.EQ.2) GO TO 28
      DS=DIPMOM*ETAU/TP
      DSH=DIPMOM/(2.*TP)
      NPM=N+M
      IS=LD+1
      I1=N-1
      DO 27 I=1,NPM
      II=I
      IF (I.GT.N) THEN
         IS=IS-1
         II=IS
         I1=I1+2
         I2=I1+1
      END IF
C
C     RX,RY,RZ = UNIT VECTOR FROM SEGMENT OR PATCH TOWARD THE DIPOLE
C     DDX,DDY,DDZ = UNIT VECTOR IN THE DIRECTION OF THE DIPOLE SOURCE
C     RHX,RHY,RHZ = UNIT VECTOR NORMAL TO THE DIPOLE SOURCE IN THE PLANE
C                   CONTAINING THE SEGMENT OR PATCH CENTER
C
      RX=X(II)-XS
      RY=Y(II)-YS
      RZ=Z(II)-ZS
      RS=RX*RX+RY*RY+RZ*RZ
      IF (RS.LT.1.E-30) GO TO 27
      R=SQRT(RS)
      RX=RX/R
      RY=RY/R
      RZ=RZ/R
      CTH=RX*DDX+RY*DDY+RZ*DDZ
      STH=SQRT(1.-CTH*CTH)
      RHX=RX-DDX*CTH
      RHY=RY-DDY*CTH
      RHZ=RZ-DDZ*CTH
      SN=SQRT(RHX*RHX+RHY*RHY+RHZ*RHZ)
      IF (SN.GT.1.E-30) THEN
         RHX=RHX/SN
         RHY=RHY/SN
         RHZ=RHZ/SN
      ELSE
         RHX=1.
         RHY=0.
         RHZ=0.
      END IF
      ARG=EXP(-FJ*XKU*R)
      IF (I.LE.N) THEN
C
C     E FIELD ON SEGMENTS
C
         TT1=(1.-FJ/(XKU*R))/RS
         ER=DS*ARG*TT1*CTH
         ET=.5*DS*ARG*(FJ*XKU/R+TT1)*STH
         EZH=ER*CTH-ET*STH
         ERH=ER*STH+ET*CTH
         CX=EZH*DDX+ERH*RHX
         CY=EZH*DDY+ERH*RHY
         CZ=EZH*DDZ+ERH*RHZ
         E(I)=E(I)-(CX*CAB(I)+CY*SAB(I)+CZ*SALP(I))
      ELSE
C
C     H FIELD ON PATCHES
C
         RX=DDY*RHZ-DDZ*RHY
         RY=DDZ*RHX-DDX*RHZ
         RZ=DDX*RHY-DDY*RHX
         TT1=DSH*ARG*(1./RS+FJ*XKU/R)*STH*SALP(II)
         CX=TT1*RX
         CY=TT1*RY
         CZ=TT1*RZ
         E(I2)=E(I2)+CX*T1X(II)+CY*T1Y(II)+CZ*T1Z(II)
         E(I1)=E(I1)+CX*T2X(II)+CY*T2Y(II)+CZ*T2Z(II)
      END IF
27    CONTINUE
      RETURN
C
C     E FIELD OF A POINT SOURCE NEAR AN INTERFACE (SOMMERFELD)
C
C     ****** NOTE: MAGNETIC FIELD FOR PATCHES IS NOT IMPLEMENTED. ******
C     DO NOT USE HERTZIAN DIPOLE SOURCE WITH PATCHES AND GROUND
C
28    SEGL=1.
      XSJ=XS
      YSJ=YS
      ZSJ=ZS
      DIRX=DDX
      DIRY=DDY
      DIRZ=DDZ
      SN=SQRT(DIRX*DIRX+DIRY*DIRY)
      IF (SN.GT.1.E-5) THEN
         XSN=DIRX/SN
         YSN=DIRY/SN
      ELSE
         SN=0.
         XSN=0.
         YSN=0.
      END IF
      XKSEG=XKU
      ISNOR=2
      IREG=0
      IDIRX=0
      DO 31 I=1,N
      XO=X(I)
      YO=Y(I)
      ZO=Z(I)
      CALL SFLDS (0.D0,EGND)
31    E(I)=E(I)-(EGND(1)*CAB(I)+EGND(2)*SAB(I)+EGND(3)*SALP(I))*DIPMOM
      RETURN
      END
      SUBROUTINE SORVQD(ISEG,VOLTS,E)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     SORVQD increments the excitation array E by the field of a charge
C     discontinuity (bicone) source.
C
C     DISCRIPTION:
C     THE BICONE SOURCE IS LOCATED ON END ONE OF SEGMENT ISEG.  A BASIS
C     FUNCTION FOR SEGMENT ISEG IS COMPUTED AS IF END ONE OF SEGMENT
C     ISEG WERE A FREE END.  ICON1(ISEG) IS TEMPORARILY SET TO ZERO FOR
C     THIS PURPOSE.  THE AMPLITUDE OF THIS BASIS FUNCTION TO PRODUCE THE
C     REQUIRED CHARGE DISCONTINUITY IS COMPUTED IN CURD.  SUBROUTINE
C     EFLD IS THEN CALLED TO COMPUTE THE E FIELD THAT THIS BASIS
C     FUNCTION PRODUCES ON EACH SEGMENT AND HSFLD TO COMPUTE THE H FIELD
C     ON PATCHES
C
C     INPUT:
C     ISEG = SOURCE SEGMENT NUMBER.  SOURCE IS ON END ONE OF SEGMENT
C            NUMBER ISEG.
C     VOLTS = SOURCE VOLTAGE (VOLTS)
C
C     OUTPUT:
C     E = EXCITATION ARRAY INCREMENTED BY THE SOURCE FIELD
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 VOLTS,E,AX,BX,CX,XKSJ,EXK,EYK,EZK,EXS,EYS,EZS,EXC,EYC,
     &EZC,ZPEDS,ZARRAY,CEINS,XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,FRATI,ETAL2,
     &AIX,BIX,CIX,CUR,XKS,QSEGE1,QSEGE2,CCJ,CURD,ETK,ETS,ETC,CFCON
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON /SEGJ/ AX(NSJMAX),BX(NSJMAX),CX(NSJMAX),JCO(NSJMAX),JSNO,
     &ISCON(NSCNGF),NSCON,IPCON(NSPNGF),NPCON
      COMMON /DATAJ/ XKSJ,EXK,EYK,EZK,EXS,EYS,EZS,EXC,EYC,EZC,ZPEDS,
     &SLENJ,ARADJ,XJ,YJ,ZJ,DXJ,DYJ,DZJ,IND1,IND2
      COMMON/ZLOAD/ ZARRAY(MAXSEG),NLOAD,NLODF,LDTYP(LOADMX),
     &LDTAG(LOADMX),LDTAGF(LOADMX),LDTAGT(LOADMX),ZLR(LOADMX),
     &ZLI(LOADMX),ZLC(LOADMX)
      COMMON/INSCOM/CEINS(MAXSEG),BRINS(MAXSEG),NINS,NINSF,INTAG(MAXIS),
     &INTAGF(MAXIS),INTAGT(MAXIS),EPSIN(MAXIS),SIGIN(MAXIS),RADIN(MAXIS)
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      COMMON/CRNT/AIX(MAXSEG),BIX(MAXSEG),CIX(MAXSEG),CUR(3*MAXSEG),
     &XKS(MAXSEG)
      COMMON/JNQCOM/QSEGE1(MAXSEG),QSEGE2(MAXSEG),IPQEND(MAXSEG)
      DIMENSION E(*),CAB(MAXSEG),SAB(MAXSEG),T1X(MAXSEG),T1Y(MAXSEG),
     &   T1Z(MAXSEG)
      EQUIVALENCE (CAB,ALP),(SAB,BET),(T1X,SI),(T1Y,ALP),(T1Z,BET)
      COMMON/CONSTN/PI,TP,DTORAD,CVEL,EPSRZ,RMUZ,ETAZ
      DATA CCJ/(0.D0,-.01666666667D0)/
      I=ICON1(ISEG)
      ICON1(ISEG)=0
      CALL TBF (ISEG,0)
      ICON1(ISEG)=I
      SLENJ=SI(ISEG)*.5
      XKSJ=XKS(ISEG)
      CURD=CCJ*VOLTS/((LOG(2.*SLENJ/BI(ISEG))-1.)*(BX(JSNO)*COS(XKSJ*
     &SLENJ)+CX(JSNO)*SIN(XKSJ*SLENJ)))
C
C     LOOP OVER SEGMENTS ONTO WHICH THE BASIS FUNCTION EXTENDS
C
      DO 20 JX=1,JSNO
      J=JCO(JX)
      SLENJ=SI(J)
      ARADJ=BI(J)
      XJ=X(J)
      YJ=Y(J)
      ZJ=Z(J)
      DXJ=CAB(J)
      DYJ=SAB(J)
      DZJ=SALP(J)
      XKSJ=XKS(J)
      ZPEDS=ZARRAY(J)
C
C     COMPUTE E FIELD ON SEGMENTS DUE TO THE MODIFIED BASIS FUNCTION
C
      IND1=ICON1(J)
      IND2=ICON2(J)
      IF(IPQEND(J).EQ.1.OR.IPQEND(J).EQ.3)IND1=60000
      IF(IPQEND(J).GT.1)IND2=60000
      DO 17 I=1,N
      XI=X(I)
      YI=Y(I)
      ZI=Z(I)
      CALL EFLD (XI,YI,ZI)
      CABI=CAB(I)
      SABI=SAB(I)
      SALPI=SALP(I)
      ETK=EXK*CABI+EYK*SABI+EZK*SALPI
      ETS=EXS*CABI+EYS*SABI+EZS*SALPI
      ETC=EXC*CABI+EYC*SABI+EZC*SALPI
17    E(I)=E(I)-(ETK*AX(JX)+ETS*BX(JX)+ETC*CX(JX))*CURD
      IF (M.EQ.0) GO TO 19
      IJ=LD+1
      I1=N
C
C     COMPUTE H FIELD ON PATCHES DUE TO THE MODIFIED BASIS FUNCTION
C
      DO 18 I=1,M
      IJ=IJ-1
      XI=X(IJ)
      YI=Y(IJ)
      ZI=Z(IJ)
      CALL HSFLD (XI,YI,ZI)
      I1=I1+1
      TX=T2X(IJ)
      TY=T2Y(IJ)
      TZ=T2Z(IJ)
      ETK=EXK*TX+EYK*TY+EZK*TZ
      ETS=EXS*TX+EYS*TY+EZS*TZ
      ETC=EXC*TX+EYC*TY+EZC*TZ
      E(I1)=E(I1)+(ETK*AX(JX)+ETS*BX(JX)+ETC*CX(JX))*CURD*SALP(IJ)
      I1=I1+1
      TX=T1X(IJ)
      TY=T1Y(IJ)
      TZ=T1Z(IJ)
      ETK=EXK*TX+EYK*TY+EZK*TZ
      ETS=EXS*TX+EYS*TY+EZS*TZ
      ETC=EXC*TX+EYC*TY+EZC*TZ
18    E(I1)=E(I1)+(ETK*AX(JX)+ETS*BX(JX)+ETC*CX(JX))*CURD*SALP(IJ)
C
C     ADD E FIELD DUE TO LOADING (Z*I VOLTAGE)
C
19    IF (NLOAD.GT.0.OR.NLODF.GT.0) E(J)=E(J)+ZARRAY(J)*CURD*AX(JX)*XKU
      IF(NINS.NE.0.OR.NINSF.NE.0)THEN
         IF(BRINS(J).GT.0.)THEN
            IF(Z(J).GE.0.)CFCON=ETAU*(CEINS(J)-CEPSU)/XKU
            IF(Z(J).LT.0.)CFCON=ETAL*(CEINS(J)-CEPSL)/XKL
            CFCON=CFCON*(0.,1.)*LOG(BRINS(J)/BI(J))/(TP*CEINS(J))
            E(J)=E(J)+CFCON*CX(JX)
         END IF
      END IF
20    CONTINUE
      RETURN
      END
      SUBROUTINE ZYSURF(CTH,XS,YS,SIDE,IPERFG,YSTE,ZSTM)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     ZYSURF computes the surface admittance and impedance of the
C     ground plane at coordinates XS,YS.
C
C     DESCRIPTION:
C     THE SURFACE ADMITTANCE AND IMPEDANCE ARE COMPUTED FOR THE GIVEN
C     INCIDENCE ANGLE OF THE RAY AND THE INTRINSIC IMPEDANCE OF THE
C     UPPER AND LOWER MEDIA.  IF THE CLIFF OPTION IS IN USE AND THE
C     REFLECTION POINT IS BEYOND THE EDGE OF THE CLIFF THEN THE
C     INTRINSIC IMPEDANCE OF THE OUTER MEDIUM (ETAL2) IS USED.  IF THE
C     RADIAL WIRE GROUND SCREEN OPTION IS IN USE THEN THE SURFACE
C     ADMITTANCE OF THE SCREEN (TM ONLY AT THIS TIME) IS ADDED IN
C     PARALLEL WITH THAT OF THE GROUND.
C
C     INPUT:
C     CTH = COSINE OF THE ANGLE BETWEEN THE INCIDENT RAY AND THE NORMAL
C     XS,YS = X AND Y COORDINATES OF THE REFLECTION POINT ON THE X-Y
C             PLANE
C     SIDE = 1 IF THE RAY IS INCIDENT FROM ABOVE THE INTERFACE
C            -1 IF THE RAY IS INCIDENT FROM BELOW THE INTERFACE
C            0 IF THERE IS NO INTERFACE
C     OTHER INPUT FROM COMMON/GND/
C
C     OUTPUT:
C     IPERFG = 1 IF REFLECTION POINT IS ON A PERFECTLY CONDUCING
C              GROUND, = 0 OTHERWISE.
C     YSTE = SURFACE ADMITTANCE FOR A TE POLARIZED FIELD
C     ZSTM = SURFACE IMPEDANCE FOR A TM POLARIZED FIELD
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 YSTE,ZSTM,XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,FRATI,ETAL2,
     &ETA,ETAX,CTHM,ZSCRN,YSCRN
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      COMMON/CONSTN/PI,TP,DTORAD,CVEL,EPSRZ,RMUZ,ETAZ
      IPERFG=IPERF
      IF(IPERF.EQ.1)THEN
C
C     PERFECTLY CONDUCTING GROUND UNLESS (XS,YS) IS ON SECOND MEDIUM.
C
         IF(SIDE.LT.0.)RETURN
         IF(ICLIFT.EQ.1.AND.XS.GT.CLIFL)IPERFG=0
         IF(ICLIFT.EQ.2.AND.XS*XS+YS*YS.GT.CLIFL**2)IPERFG=0
         IF(IPERFG.EQ.1)RETURN
      END IF
C
C     ETA = INTRINSIC IMPEDANCE OF MEDIUM IN WHICH RAY IS PROPAGATING
C     ETAX = INTRINSIC IMPEDANCE ON OTHER SIDE OF INTERFACE (GROUND)
C
      IF(SIDE.LE.0.)THEN
         ETA=ETAL
         ETAX=ETAU
      ELSE
         ETA=ETAU
         ETAX=ETAL
         IF(ICLIFT.NE.0)THEN
C
C     RESET ETAX IF REFLECTION POINT IS ON OUTER MEDIUM BEYOND CLIFF.
C
            IF(ICLIFT.EQ.1.AND.XS.GT.CLIFL)ETAX=ETAL2
            IF(ICLIFT.EQ.2.AND.XS*XS+YS*YS.GT.CLIFL**2)ETAX=ETAL2
         END IF
      END IF
C
C     COMPUTE SURFACE IMPEDANCE AND ADMITTANCE OF GROUND
C
      CTHM=SQRT(1.-(ETAX/ETA)**2*(1.-CTH*CTH))
      IF(CTH.LT.0.)CTHM=-CTHM
      IF(ABS(DREAL(CTHM)).LT.ABS(DIMAG(CTHM))*1.E-6)THEN
        IF(CTH*DIMAG(CTHM).GE.0.)CTHM=-CTHM
      END IF
      YSTE=CTHM/ETAX
      ZSTM=CTHM*ETAX
      IF(SIDE.LT.0..OR.NRADL.EQ.0)RETURN
C
C     ADD SURFACE IMPEDANCE OF RADIAL-WIRE GROUND SCREEN IN PARALLEL
C     WITH THAT OF THE GROUND
C
      RHOSCN=SQRT(XS*XS+YS*YS+(SCNWRD*NRADL)**2)
      IF(RHOSCN.GT.SCNRAD)RETURN
      ZSCRN=(0.,1.)*RMUZ*OMEGAG*RHOSCN/NRADL*LOG(RHOSCN/(SCNWRD*NRADL))
      IF(ABS(ZSCRN).GT.0.)THEN
         YSCRN=1./ZSCRN
      ELSE
         YSCRN=1.E15
      END IF
      ZSTM=ZSTM*ZSCRN/(ZSTM+ZSCRN)
      YSTE=YSTE+YSCRN
      RETURN
      END
      SUBROUTINE REFCOF(CTH,VNORX,VNORY,ETA,IPERFG,YSTE,ZSTM,EX,EY,EZ,
     &RX,RY,RZ)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     REFCOF computes the reflected electric field at the interface for
C     a given incident electric field.
C
C     DESCRIPTION:
C     INPUT:
C     CTH = COSINE OF THE ANGLE BETWEEN THE INCIDENT RAY AND THE NORMAL
C     VNORX,VNORY = X AND Y COMPONENTS OF THE UNIT VECTOR NORMAL TO THE
C                   PLANE OF INCIDENCE OF THE INCIDENT RAY
C     ETA = INTRINSIC IMPEDANCE OF THE MEDIUM IN WHICH THE RAY IS
C           PROPAGATING
C     IPERFG = 1 IF GROUND IS PERFECTLY CONDUCTING, 0 OTHERWISE
C     YSTE = SURFACE ADMITTANCE FOR TE POLARIZED FIELD
C     ZSTM = SUMFACE IMPEDANCE FOR TM POLARIZED FIELD
C     EX,EY,EZ = VECTOR COMPONENTS OF THE INCIDENT E FIELD
C
C     OUTPUT:
C     RX,RY,RZ = VECTOR COMPONENTS OF THE REFLECTED E FIELD
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 ETA,YSTE,ZSTM,EX,EY,EZ,RX,RY,RZ,YZTE,ZZTM,REFTE,REFTM,
     &ENOR
      IF(IPERFG.EQ.1)THEN
C
C     PERFECTLY CONDUCTING GROUND
C
         RX=-EX
         RY=-EY
         RZ=EZ
         RETURN
      END IF
C
C     FINITELY CONDUCTING GROUND
C
      YZTE=CTH/ETA
      ZZTM=CTH*ETA
      REFTE=(YZTE-YSTE)/(YZTE+YSTE)
      REFTM=-(ZZTM-ZSTM)/(ZZTM+ZSTM)
      ENOR=(EX*VNORX+EY*VNORY)*(REFTE-REFTM)
      RX=REFTM*EX+ENOR*VNORX
      RY=REFTM*EY+ENOR*VNORY
      RZ=-REFTM*EZ
      RETURN
      END
      SUBROUTINE TRXKNO(CTH,XK,XKX,CKZX)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     TRXKNO computes the Z component of the wave propagation vector k
C     on the opposite side of the interface from an incident plane wave.
C
C     DESCRIPTION:
C     THE Z COMPONENT OF THE WAVE PRORAGATION VECTOR ON THE OPPOSITE
C     SIDE OF THE INTERFACE IS DETERMINED BY SNELL'S LAW.  THE SIGN OF
C     THE SQUARE ROOT IS CHOSEN FOR A WAVE PROPAGATING AWAY FROM THE
C     INTERFACE AND ATTENUATING.
C
C     INPUT:
C     CTH = COSINE OF THE ANGLE BETWEEN THE INCIDENT RAY AND THE NORMAL
C     XK = WAVE NUMBER IN THE MEDIUM CONTAINING THE INCIDENT RAY
C     XKX = WAVE NUMBER ON OPPOSITE SIDE OF THE INTERFACE
C
C     OUTPUT:
C     CKZX = Z COMPONENT OF WAVE PROPAGATION VECTOR K ON THE OPPOSITE
C            SIDE OF THE INTERFACE FROM THE INCIDENT RAY.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 XK,XKX,CKZX
      CKZX=SQRT(XKX*XKX-(1.-CTH*CTH)*XK*XK)
      IF (CTH.GT.0.) CKZX=-CKZX
      IF(DREAL(CKZX).EQ.0..AND.CTH*DIMAG(CKZX).LT.0.) CKZX=-CKZX
      RETURN
      END
      SUBROUTINE TRXCOF(VNORX,VNORY,CKZ,CKZX,XK,XKX,EX,EY,EZ,TX,TY,TZ)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     TRXCOF computes the E field transmitted across an interface given
C     an incident plane-wave field at the interface.
C
C     DESCRIPTION:
C     INPUT:
C     VNORX,VNORY = X AND Y COMPONENTS OF THE UNIT VECTOR NORMAL TO THE
C                   PLANE OF INCIDENCE OF THE INCIDENT RAY
C     CKZ = Z COMPONENT OF THE WAVE PROPAGATION VECTOR K OF THE INCIDENT
C           RAY
C     CKZX = Z COMPONENT OF THE PROPAGATION VECTOR K OF RAY AFTER
C            CROSSING THE INTERFACE
C     XK = WAVE NUMBER IN THE MEDIUM CONTAINING THE INCIDENT RAY
C     XKX = WAVE NUMBER ON OPPOSITE SIDE OF THE INTERFACE
C     EX,EY,EZ = VECTOR COMPONENTS OF THE INCIDENT E FIELD
C
C     OUTPUT:
C     TX,TY,TZ = VECTOR COMPONENTS OF THE E FIELD TRANSMITTED ACROSS THE
C                INTERFACE
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 CKZ,CKZX,XK,XKX,EX,EY,EZ,TX,TY,TZ,TZZ,TRR,TPP,ERHO,EPHI
      IF(DIMAG(XK).NE.0.)THEN
C
C     WAVE INCIDENT FROM LOSSY MEDIUM IS ZERO
C
         TX=(0.,0.)
         TY=(0.,0.)
         TZ=(0.,0.)
         RETURN
      END IF
      TZZ=2.*XK*XK/(XKX*XKX*CKZ+XK*XK*CKZX)
      TRR=TZZ*CKZX
      TPP=2.*CKZ/(CKZ+CKZX)
      TZZ=TZZ*CKZ
      VRHOX=VNORY
      VRHOY=-VNORX
      ERHO=(VRHOX*EX+VRHOY*EY)*TRR
      EPHI=(VNORX*EX+VNORY*EY)*TPP
      TX=ERHO*VRHOX+EPHI*VNORX
      TY=ERHO*VRHOY+EPHI*VNORY
      TZ=TZZ*EZ
      RETURN
      END
      SUBROUTINE REFPT1(DX,DY,DZ,XP,YP,ZP,XS,YS,ZS)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     REFPT1 computes the specular reflection point (XS,YS,ZS) for a ray
C     with direction (DX,DY,DZ) incident on the two-level ground plane
C     defined in COMMON/GND/ and passing through the point (XP,YP,ZP).
C
C     DESCRIPTION:
C     SUBROUTINE REFPT IS CALLED TO GET THE SPECULAR REFLECTION POINT
C     ON A GIVEN HORIZONTAL PLANE.  IF THE TWO-MEDIUM GROUND OPTION IS
C     IN USE, THE CLIFF LOCATION AND HEIGHT IS CHECKED TO DETERMINE
C     WHICH MEDIUM THE RAY REFLECTS FROM.
C
C     INPUT:
C     DX,DY,DZ = X, Y AND Z COMPONENTS OF THE UNIT VECTOR IN THE
C                DIRECTION OF PROPAGATION OF THE RADIATED FIELD (RAY
C                FROM (XP,YP,ZP) AFTER REFLECTION)
C     XP,YP,ZP = X, Y AND Z COORDINATES OF THE POINT REPRESENTING THE
C                SOURCE OF THE RAY
C
C     OUTPUT:
C     XS,YS,ZS = X, Y AND Z COORDINATES OF THE REFLECTION POINT ON THE
C                INTERFACE.  ZS WILL BE ZERO UNLESS THE RAY REFLECTS ON
C                THE SECOND MEDIUM, BEYOND A "CLIFF".
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,FRATI,ETAL2
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      CALL REFPT(0.D0,DX,DY,DZ,XP,YP,ZP,XS,YS,ZS)
      IF(ICLIFT.EQ.0)GO TO 1
      IF(ICLIFT.EQ.1.AND.XS.LT.CLIFL)GO TO 1
      IF(ICLIFT.EQ.2.AND.XS*XS+YS*YS.LT.CLIFL**2)GO TO 1
      CALL REFPT(-CLIFH,DX,DY,DZ,XP,YP,ZP,XS,YS,ZS)
1     RETURN
      END
      SUBROUTINE REFPT(ZGND,DX,DY,DZ,XP,YP,ZP,XS,YS,ZS)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     REFPT computes the specular reflection point (XS,YS,ZS) for a ray
C     with direction (DX,DY,DZ) incident on a horizontal plane at height
C     ZGND and passing through the point (XP,YP,ZP).
C
C     DESCRIPTION:
C
C
C     INPUT:
C     ZGND = HEIGHT OF THE HORIZONTAL GROUND PLANE
C     DX,DY,DZ = X, Y AND Z COMPONENTS OF THE UNIT VECTOR IN THE
C                DIRECTION OF PROPAGATION OF THE RADIATED FIELD (RAY
C                FROM (XP,YP,ZP) AFTER REFLECTION)
C     XP,YP,ZP = X, Y AND Z COORDINATES OF THE POINT REPRESENTING THE
C                SOURCE OF THE RAY
C
C     OUTPUT:
C     XS,YS,ZS = X, Y AND Z COORDINATES OF THE REFLECTION POINT ON THE
C                INTERFACE.  ZS IS ALWAYS SET EQUAL TO ZGND.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      AA=1.E10
      IF(ABS(DZ).GT.1.E-10)AA=(ZP-ZGND)/DZ
      XS=XP+AA*DX
      YS=YP+AA*DY
      ZS=ZGND
      RETURN
      END
      FUNCTION IROUND(R)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     IROUND rounds the real number R to an integer, IROUND
C
      IMPLICIT REAL*8 (A-H,O-Z)
      IROUND=R+.5
      RETURN
      END
      SUBROUTINE NETWK (EINC)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     NETWK controls the solution for currents on a structure for a
C     given excitation and prints "ANTENNA INPUT PARAMETERS".
C
C     DISCRIPTION:
C     THIS SUBROUTINE IS THE REMNANT OF THE OLD SUBROUTINE NETWK WITH
C     THE NETWORK-SOLUTION CODING REMOVED TO SUBROUTINES NETSOL AND
C     NTSORT.  WHEN NETWORKS OR TRANSMISSION LINES ARE IN USE,
C     SUBROUTINE NETSOL IS CALLED TO SOLVE THE NETWORK EQUATIONS
C     TOGETHER WITH THE STRUCTURE INTERACTION EQUATIONS.
C
C     INPUT:
C     EINC = EXCITATION ARRAY, FILLED BY SUBROUTINE ETMNS FROM USER-
C            DEFINED SOURCES
C     OTHER INPUT FROM COMMON BLOCKS /DATA/, /CMB/, /SORCES/, /NETDEF/,
C     AND /NETCX/
C
C     OUTPUT:
C     EINC = ARRAY OF CURRENTS ON SEGMENTS AND PATCHES
C     PARAMETERS IN COMMON/NETCX/
C
      INCLUDE 'NECPAR.INC'
      PARAMETER (IRESRV=MAXMAT**2)
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 EINC,CM,TLYT1,TLYT2,YN11,YN12,YN22,SVOLTS,CMN,RHNX,
     &RHNT,VLTNET,ZPED,VLT,CUX,YMIT
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON /CMB/CM(IRESRV),IP(2*MAXSEG),IB11,IC11,ID11,NEQMAT,NEQ,NEQ2
      COMMON /SORCES/ PSOR1(NSOMAX),PSOR2(NSOMAX),PSOR3(NSOMAX),
     &PSOR4(NSOMAX),PSOR5(NSOMAX),PSOR6(NSOMAX),DTHINC,DPHINC,NTHINC,
     &NPHINC,NSCINC,NSORC,ISORTP(NSOMAX)
      COMMON/NETDEF/TLYT1(NETMX),TLYT2(NETMX),YN11(NETMX),YN12(NETMX),
     &YN22(NETMX),SVOLTS(NSOMAX),TLZCH(NETMX),TLLEN(NETMX),NVSOR,
     &NVSORA(NSOMAX),ISEG1(NETMX),ISEG2(NETMX),NONET,NETYP(NETMX)
      COMMON/NETWRK/CMN(NETMX,NETMX),RHNX(NETMX),RHNT(NETMX),
     &VLTNET(NETMX),IPNT(NETMX),NTEQ,NTEQA(NETMX),NTVEQ,NTVEQA(NETMX)
      COMMON/NETCX/ZPED,PIN,PNLS,IZSAVE,NPEQ,NTSOL,NPRINT
      DIMENSION EINC(*)
      NETMXP=NETMX+1
      PIN=0.
      PNLS=0.
      IF(NONET.EQ.0)GO TO 48
C
C     SOLUTION WHEN NETWORKS ARE PRESENT
C
      NVSOR=0
C
C     FILL ARRAYS FOR VOLTAGE SOURCES IN PARALLEL WITH NETWORK PORTS.
C     THE FIELDS DUE TO THESE VOLTAGES MUST ALSO BE INCLUDED IN THE
C     EXCITATION VECTOR EINC.  THE VOLTAGE ENTERED IN ARRAY SVOLTS IS
C     TREATED AS BEING ACROSS THE NETWORK PORT, WHILE ANY REMAINDER IN
C     THE FIELD (V/DELTA) IN ARRAY EINC IS OUTBOARD OF THE PORT.
C
      IF(NSORC.GT.0)THEN
         DO 1 I=1,NSORC
         IF(ISORTP(I).EQ.1)THEN
            NVSOR=NVSOR+1
            NVSORA(NVSOR)=IROUND(PSOR1(I))
            SVOLTS(NVSOR)=DCMPLX(PSOR2(I),PSOR3(I))
         END IF
1        CONTINUE
      END IF
C
C     CALL NETSOL TO SOLVE NETWORK EQUATIONS
C
      CALL NETSOL(EINC,NTSOL)
C
C     PRINT "STRUCTURE EXCITATION DATA AT NETWORK CONNECTION POINTS."
C     POWER DISSAPATED IN NETWORKS IS ALSO COMPUTED AS PNLS.
C
      IF (NPRINT.EQ.0) WRITE(3,63)
      IF (NPRINT.EQ.0) WRITE(3,62)
C
C     FOR NETWORK PORTS WITHOUT VOLTAGE SOURCES
C
      DO 46 I=1,NTEQ
      IROW1=NTEQA(I)
      VLT=RHNT(I)
      CALL YAMIT1(IROW1,VLT,CUX,YMIT)
      ZPED=1./YMIT
      IROW2=ITAG(IROW1)
      PWR=.5*DREAL(VLT*DCONJG(VLT*YMIT))
      PNLS=PNLS-PWR
      IF (NPRINT.EQ.0) WRITE(3,64) IROW2,IROW1,VLT,CUX,ZPED,YMIT,PWR
46    CONTINUE
      IF (NTVEQ.EQ.0) GO TO 49
C
C     FOR NETWORK PORTS WITH VOLTAGE SOURCES
C
      DO 47 I=1,NTVEQ
      IROW1=NTVEQA(I)
      VLT=VLTNET(I)
      CALL YAMIT1(IROW1,VLT,CUX,YMIT)
      ZPED=1./YMIT
      IROW2=ITAG(IROW1)
      PWR=.5*DREAL(VLT*DCONJG(VLT*YMIT))
      PNLS=PNLS-PWR
47    IF (NPRINT.EQ.0) WRITE(3,64) IROW2,IROW1,VLT,CUX,ZPED,YMIT,PWR
      GO TO 49
C
C     SOLVE FOR CURRENTS WHEN NO NETWORKS ARE PRESENT
C
48    NEQZ2=NEQ2
      IF(NEQZ2.EQ.0)NEQZ2=1
      CALL SOLGF (CM,CM(IB11),CM(IC11),CM(ID11),EINC,IP,NP,N1,N,MP,M1,
     &M,NEQ,NEQ2,NEQZ2)
      CALL CABC (EINC)
      NTVEQ=0
49    LABLV=0
C
C     PRINT "ANTENNA INPUT PARAMETERS".  TOTAL INPUT POWER FROM SOURCES
C     IS ALSO COMPUTED AS PIN.
C
      DO 3 I=1,NSORC
C
C     FIRST FOR APPLIED FIELD (GAP) VOLTAGE SOURCES
C
      IF(ISORTP(I).NE.1)GO TO 3
      IF(LABLV.EQ.0)THEN
         LABLV=1
         WRITE(3,65)
         WRITE(3,62)
      END IF
      ISC1=IROUND(PSOR1(I))
      VLT=DCMPLX(PSOR2(I),PSOR3(I))
      CALL YAMIT1(ISC1,VLT,CUX,YMIT)
      IROW1=0
C
C     IF THE VOLTAGE SOURCE IS IN PARALLEL WITH ONE OR MORE NETWORK
C     PORTS, ADD THE CURRENTS INTO THE NETWORK PORTS TO THE SEGMENT
C     CURRENT TO GET TOTAL CURRENT THROUGH THE SOURCE.
C
      IF (NTVEQ.GT.0) THEN
         DO 50 J=1,NTVEQ
         IF (NTVEQA(J).EQ.ISC1) THEN
            IROW1=NETMXP-J
            CUX=CUX+RHNT(IROW1)
            YMIT=YMIT+RHNT(IROW1)/VLT
            GO TO 51
         END IF
50       CONTINUE
      END IF
51    ZPED=1./YMIT
      IZSAVE=ISC1
      PWR=.5*DREAL(VLT*DCONJG(VLT*YMIT))
      PIN=PIN+PWR
      IF (IROW1.NE.0) PNLS=PNLS+PWR
      IROW2=ITAG(ISC1)
      WRITE(3,64) IROW2,ISC1,VLT,CUX,ZPED,YMIT,PWR
3     CONTINUE
C
C     NOW DO CHARGE DISCONTINUITY (BICONE) VOLTAGE SOURCES.  NOTE THAT
C     THESE ARE NEVER IN PARALLEL WITH NETWORK PORTS.
C
      DO 5 I=1,NSORC
      IF(ISORTP(I).NE.4)GO TO 5
      IF(LABLV.EQ.0)THEN
         LABLV=1
         WRITE(3,65)
         WRITE(3,62)
      END IF
      ISC1=IROUND(PSOR1(I))
      VLT=DCMPLX(PSOR2(I),PSOR3(I))
      CALL YAMIT2(ISC1,VLT,CUX,YMIT)
      ZPED=1./YMIT
      IZSAVE=ISC1
      PWR=.5*DREAL(VLT*DCONJG(VLT*YMIT))
      PIN=PIN+PWR
      IROW2=ITAG(ISC1)
      WRITE(3,66) IROW2,ISC1,VLT,CUX,ZPED,YMIT,PWR
5     CONTINUE
      RETURN
C
62    FORMAT (/,3X,'TAG',3X,'SEG.',4X,'VOLTAGE (VOLTS)',9X,
     &'CURRENT (AMPS)',9X,'IMPEDANCE (OHMS)',8X,'ADMITTANCE (MHOS)',6X,
     &'POWER',/,3X,'NO.',3X,'NO.',4X,'REAL',8X,'IMAG.',3(7X,'REAL',8X,
     &'IMAG.'),5X,'(WATTS)')
63    FORMAT (///,27X,'- - - STRUCTURE EXCITATION DATA AT NETWORK CONNEC
     &TION POINTS - - -')
64    FORMAT (2(1X,I5),1P9E12.5)
65    FORMAT (///,42X,'- - - ANTENNA INPUT PARAMETERS - - -')
66    FORMAT (1X,I5,' *',I4,1P9E12.5)
      END
      SUBROUTINE NETSOL (EINC,NTSOL)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     NETSOL solves for structure currents and network-port voltages and
C     currents for structures with non-radiating networks.
C
C     DESCRIPTION:
C     AN ADMITTANCE MATRIX IS DERIVED FOR THE ELECTROMAGNETIC
C     INTERACTION OF THE SEGMENTS TO WHICH NETWORK PORTS CONNECT.  THIS
C     MATRIX IS COMBINED WITH THE ADMITTANCE MATRIX FOR THE NETWORKS
C     AND SOLVED FOR THE VOLTAGES AND CURRENTS AT NETWORK PORTS.
C
C     INPUT:
C     EINC = EXCITATION ARRAY, FILLED BY SUBROUTINE ETMNS FROM USER-
C            DEFINED SOURCES
C     NTSOL = FLAG TO INDICATE (WHEN .NE. 0) THAT NETWORK EQUATIONS DO
C             NOT NEED TO BE RECOMPUTED.  THIS SITUATION OCCURS WHEN
C             NETSOL IS CALLED REPEATEDLY WITH ONLY THE STRUCTURE
C             EXCITATION, EXCLUDING VOLTAGE SOURCES IN PARALLEL WITH
C             NETWORK PORTS, CHANGING.  IF VOLTAGE SOURCES IN PARALLEL
C             WITH NETWORK PORTS ARE CHANGED, NETSOL MUST BE CALLED WITH
C             NTSOL EQUAL TO ZERO.
C     NVSOR = NUMBER OF VOLTAGE SOURCES IN THE STRUCTURE
C     NVSORA(I) = SEGMENT NUMBER FOR VOLTAGE SOURCE I
C     SVOLTS(I) = VOLTAGE ON SOURCE I.  THE FIELD DUE TO THIS VOLTAGE
C                 MUST ALSO BE INCLUDED IN THE EXCITATION VECTOR EINC.
C                 THE COMPONENT DUE TO SVOLTS IS TREATED AS BEING ACROSS
C                 THE NETWORK PORT, WHILE ANY REMAINDER IN EINC IS
C                 OUTBOARD OF THE PORT.
C     OTHER INPUT FROM COMMON BLOCKS /DATA/, /CMB/ AND /NETDEF/
C
C     OUTPUT:
C     EINC = ARRAY OF CURRENTS ON SEGMENTS AND PATCHES
C     NTEQ = NUMBER OF SEGMENTS THAT CONNECT TO NETWORK PORTS WITHOUT
C            VOLTAGE SOURCES
C     NTEQA(I) = SEGMENT NUMBER OF THE I th SEGMENT THAT CONNECTS TO A
C                NETWORK PORT WITHOUT A VOLTAGE SOURCE
C     NTVEQ = NUMBER OF SEGMENTS THAT CONNECT TO NETWORK PORTS WITH
C             VOLTAGE SOURCES
C     NTVEQA(I) = SEGMENT NUMBER OF THE I th SEGMENT THAT CONNECTS TO A
C                NETWORK PORT WITH A VOLTAGE SOURCE
C     RHNT(I) = PORT VOLTAGE (VOLTS) ON SEGMENT NUMBER NTEQA(I) FOR I
C               FROM 1 THROUGH NTEQ
C     RHNT(NETMXP - I) = NETWORK COMPONENT OF SOURCE CURRENT (AMPS) FOR
C                        THE SOURCE IN PARALLEL WITH THE NETWORK PORT ON
C                        SEGMENT NTVEQA(I) FOR I FROM 1 THROUGH NTVEQ.
C                        THE TOTAL SOURCE CURRENT IS THE SUM OF THIS
C                        QUANTITY AND THE CURRENT IN THE SEGMENT.
C
      INCLUDE 'NECPAR.INC'
      PARAMETER (IRESRV=MAXMAT**2)
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 EINC,TLYT1,TLYT2,YN11,YN12,YN22,SVOLTS,CMN,RHNX,RHNT,
     &CM,RHS,CURX,VLTNET
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON/NETDEF/TLYT1(NETMX),TLYT2(NETMX),YN11(NETMX),YN12(NETMX),
     &YN22(NETMX),SVOLTS(NSOMAX),TLZCH(NETMX),TLLEN(NETMX),NVSOR,
     &NVSORA(NSOMAX),ISEG1(NETMX),ISEG2(NETMX),NONET,NETYP(NETMX)
      COMMON/NETWRK/CMN(NETMX,NETMX),RHNX(NETMX),RHNT(NETMX),
     &VLTNET(NETMX),IPNT(NETMX),NTEQ,NTEQA(NETMX),NTVEQ,NTVEQA(NETMX)
      COMMON /CMB/CM(IRESRV),IP(2*MAXSEG),IB11,IC11,ID11,NEQMAT,NEQ,NEQ2
      DIMENSION EINC(*),RHS(3*MAXSEG)
      NETMXP=NETMX+1
      NEQZ2=NEQ2
      IF(NEQZ2.EQ.0)NEQZ2=1
      IF (NTSOL.NE.0) GO TO 42
C
C     INITIALIZE ARRAYS FOR NETWORK EQUTIONS
C
      DO 15 I=1,NETMX
      RHNX(I)=(0.,0.)
      DO 15 J=1,NETMX
15    CMN(I,J)=(0.,0.)
      NTEQ=0
      NTVEQ=0
C
C     SORT NETWORK AND SOURCE DATA AND ASSIGN EQUATION NUMBERS TO
C     SEGMENTS.  EQUATIONS FOR PORTS WITHOUT VOLTAGE SOURCES ARE
C     STORED DOWNWARD FROM THE TOP ROW OF CMN.  EQUATIONS FOR PORTS
C     WITH VOLTAGE SOURCES ARE STORED UPWARD FROM THE BOTTOM OF CMN AND
C     USED LATER TO COMPUTE THE INPUT ADMITTANCES SEEN BY THE SOURCES.
C
      DO 38 J=1,NONET
      NSEG1=ISEG1(J)
      NSEG2=ISEG2(J)
      CALL NTSORT(NSEG1,IROW1,IVSC1)
      CALL NTSORT(NSEG2,IROW2,IVSC2)
      IF(IVSC1.NE.0)IROW1=NETMXP-IROW1
      IF(IVSC2.NE.0)IROW2=NETMXP-IROW2
      IF (NTEQ+NTVEQ.GT.NETMX) THEN
         WRITE(3,61)
         STOP
      END IF
C
C     FILL NETWORK EQUATION MATRIX AND RIGHT HAND SIDE VECTOR WITH
C     NETWORK SHORT-CIRCUIT ADMITTANCE MATRIX COEFFICIENTS.  THE
C     (Y sub i,j) COMPONENTS OF THE MATRIX IN EQ. 202 OF PART I OF THE
C     NEC-2 MANUAL ARE STORED IN CMN.  THE NEGATIVE OF (C sub i) IN EQ.
C     202 IS STORED IN RHNX.  CMN IS STORRED TRANSPOSED.
C
      IF (IVSC1.EQ.0) THEN
         CMN(IROW1,IROW1)=CMN(IROW1,IROW1)-YN11(J)*SI(NSEG1)
         CMN(IROW1,IROW2)=CMN(IROW1,IROW2)-YN12(J)*SI(NSEG1)
      ELSE
         RHNX(IROW1)=RHNX(IROW1)+YN11(J)*SVOLTS(IVSC1)
         RHNX(IROW2)=RHNX(IROW2)+YN12(J)*SVOLTS(IVSC1)
      END IF
      IF (IVSC2.EQ.0) THEN
         CMN(IROW2,IROW2)=CMN(IROW2,IROW2)-YN22(J)*SI(NSEG2)
         CMN(IROW2,IROW1)=CMN(IROW2,IROW1)-YN12(J)*SI(NSEG2)
      ELSE
         RHNX(IROW1)=RHNX(IROW1)+YN12(J)*SVOLTS(IVSC2)
         RHNX(IROW2)=RHNX(IROW2)+YN22(J)*SVOLTS(IVSC2)
      END IF
38    CONTINUE
C
C     ADD INTERACTION-MATRIX ADMITTANCE ELEMENTS TO NETWORK EQUATION
C     MATRIX.  THESE ARE THE INVERSE(G sub i,j) COMPONENTS OF THE
C     NETWORK MATRIX IN EQ. 202 OF PART I OF THE NEC-2 MANUAL.
C
      DO 41 J=1,NTEQ
      CALL SORINI(RHS)
      IROW1=NTEQA(J)
      RHS(IROW1)=(1.,0.)
      CALL SOLGF (CM,CM(IB11),CM(IC11),CM(ID11),RHS,IP,NP,N1,N,MP,M1,M,
     &NEQ,NEQ2,NEQZ2)
      CALL CABC (RHS)
      DO 40 I=1,NTEQ
      IROW1=NTEQA(I)
40    CMN(J,I)=CMN(J,I)+RHS(IROW1)
41    CONTINUE
C
C     FACTOR NETWORK EQUATION MATRIX
C
      CALL FACTR (NTEQ,CMN,IPNT,NETMX)
C
C     ADD TO NETWORK EQUATION RIGHT HAND SIDE THE TERMS DUE TO ELEMENT
C     INTERACTIONS.  THESE ARE THE (B sub i) TERMS IN EQ. 202.
C
42    DO 43 I=1,NEQMAT
43    RHS(I)=EINC(I)
      CALL SOLGF (CM,CM(IB11),CM(IC11),CM(ID11),RHS,IP,NP,N1,N,MP,M1,M,
     &NEQ,NEQ2,NEQZ2)
      CALL CABC (RHS)
      DO 44 I=1,NTEQ
      IROW1=NTEQA(I)
44    RHNT(I)=RHNX(I)+RHS(IROW1)
C
C     SOLVE NETWORK EQUATIONS
C
      CALL SOLVE (NTEQ,CMN,IPNT,RHNT,NETMX)
C
C     ADD FIELDS DUE TO NETWORK VOLTAGES TO ELECTRIC FIELDS APPLIED TO
C     STRUCTURE AND SOLVE FOR INDUCED CURRENT
C
      DO 45 I=1,NTEQ
      IROW1=NTEQA(I)
45    EINC(IROW1)=EINC(IROW1)-RHNT(I)
      CALL SOLGF (CM,CM(IB11),CM(IC11),CM(ID11),EINC,IP,NP,N1,N,MP,M1,
     &M,NEQ,NEQ2,NEQZ2)
      CALL CABC (EINC)
C
C     FOR PORTS WITH VOLTAGE SOURCES, EVALUATE THE TOTAL CURRENT INTO
C     NETWORK PORTS AT EACH SEGMENT AND STORE IN THE BOTTOM OF RHNT.
C     THE SOURCE CURRENT IN EQ. 203 OF PART I OF NEC-2 MANUAL IS THE SUM
C     OF THIS QUANTITY AND THE CURRENT IN THE SEGMENT.
C
      DO 50 I=1,NTVEQ
      IROW1=NETMXP-I
      CURX=RHNX(IROW1)
      DO 51 J=1,NTEQ
51    CURX=CURX-CMN(J,IROW1)*RHNT(J)
50    RHNT(IROW1)=CURX
C
C     CONVERT FIELD VALUES FOR PORTS WITHOUT VOLTAGE SOURCES TO PORT
C     VOLTAGES AND STORE IN TOP PART OF RHNT.
C
      DO 46 I=1,NTEQ
      IROW1=NTEQA(I)
46    RHNT(I)=RHNT(I)*SI(IROW1)
      RETURN
C
61    FORMAT (' NETSOL: ERROR - NETWORK ARRAY DIMENSIONS TOO SMALL')
      END
      SUBROUTINE NTSORT(NETSEG,NETEQN,IVSRC)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     NTSORT determines the network equation for segment NETSEG.
C
C     DESCRIPTION:
C     INPUT:
C     NETSEG = SEGMENT NUMBER FOR WHICH NETWORK EQUATION NUMBER IS TO BE
C              DETERMINED
C     NTEQA = ARRAY OF SEGMENTS WITHOUT VOLTAGE SOURCES FOR WHICH
C             NETWORK EQUATION NUMBERS HAVE BEEN ESTABLISHED (COMMON
C             /NETWRK/)
C     NTVEQA = ARRAY OF SEGMENTS WITH VOLTAGE SOURCES FOR WHICH NETWORK
C             EQUATION NUMBERS HAVE BEEN ESTABLISHED (COMMON/NETWRK/)
C     OTHER INPUT FROM COMMON BLOCKS /NETDEF/ AND /NETWRK/
C
C     OUTPUT:
C     NETEQN = NETWORK EQUATION NUMBER FOR PORTS WITHOUT VOLTAGE SOURCES
C              IF IVSRC .EQ. 0; NETWORK EQUATION NUMBER FOR PORTS WITH
C              VOLTAGE SOURCES IF IVSRC .NE. 0.
C     IVSRC = INDEX OF SEGMENT NETSEG IN ARRAY NVSORA IF SEGMENT NETSEG
C             WAS FOUND TO HAVE A VOLTAGE SOURCE.  IF SEGMENT NETSEG
C             WAS NOT FOUND IN ARRAY NVSORA THEN IVSRC = 0.
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 TLYT1,TLYT2,YN11,YN12,YN22,SVOLTS,CMN,RHNX,RHNT,VLTNET
      COMMON/NETDEF/TLYT1(NETMX),TLYT2(NETMX),YN11(NETMX),YN12(NETMX),
     &YN22(NETMX),SVOLTS(NSOMAX),TLZCH(NETMX),TLLEN(NETMX),NVSOR,
     &NVSORA(NSOMAX),ISEG1(NETMX),ISEG2(NETMX),NONET,NETYP(NETMX)
      COMMON/NETWRK/CMN(NETMX,NETMX),RHNX(NETMX),RHNT(NETMX),
     &VLTNET(NETMX),IPNT(NETMX),NTEQ,NTEQA(NETMX),NTVEQ,NTVEQA(NETMX)
C
C     CHECK IF NETWORK PORT ALSO HAS A VOLTAGE SOURCE
C
      IF(NVSOR.GT.0)THEN
         DO 1 I=1,NVSOR
         IF(NETSEG.EQ.NVSORA(I))THEN
            IVSRC=I
            GO TO 3
         END IF
1        CONTINUE
      END IF
C
C     NETWORK PORT WITHOUT VOLTAGE SOURCE.  GET EQUATION NUMBER.
C
      IVSRC=0
      IF(NTEQ.GT.0)THEN
         DO 2 I=1,NTEQ
         IF(NETSEG.EQ.NTEQA(I))THEN
            NETEQN=I
            RETURN
         END IF
2        CONTINUE
      END IF
C
C     NEW NETWORK EQUATION.  ENTER SEGMENT NUMBER IN ARRAY NTEQA.
C
      NTEQ=NTEQ+1
      NTEQA(NTEQ)=NETSEG
      NETEQN=NTEQ
      RETURN
C
C     NETWORK PORT WITH VOLTAGE SOURCE.  GET EQUATION NUMBER.
C
3     IF(NTVEQ.GT.0)THEN
         DO 4 I=1,NTVEQ
         IF(NETSEG.EQ.NTVEQA(I))THEN
            NETEQN=I
            RETURN
         END IF
4        CONTINUE
      END IF
C
C     NEW NETWORK-VOLTAGE SOURCE EQUATION.  ENTER SEGMENT NUMBER IN
C     ARRAY NTVEQA
C
      NTVEQ=NTVEQ+1
      NTVEQA(NTVEQ)=NETSEG
      NETEQN=NTVEQ
      VLTNET(NTVEQ)=SVOLTS(IVSRC)
      RETURN
      END
      SUBROUTINE YAMIT1(ISEG,VOLTS,CRNT,YMIT)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     YAMIT1 computes the input admittance and source current for a
C     segment with an applied-field voltage source.
C
C     DESCRIPTION:
C     INPUT ADMITTANCE IS COMPUTED AS THE RATIO OF THE CURRENT AT THE
C     CENTER OF THE SEGMENT TO THE SPECIFIED VOLTAGE.  NOTE THAT THIS
C     IS THE INPUT ADMITTANCE FOR THE STRUCTURE.  IT DOES NOT INCLUDE
C     CURRENT INTO ANY NETWORKS OR TRANSMISSION LINES ON THIS SEGMENT.
C     INPUT:
C     ISEG = NUMBER OF THE SEGMENT ON WHICH THE SOURCE IS LOCATED
C     VOLTS = SOURCE VOLTAGE (VOLTS)
C
C     OUTPUT:
C     CRNT = SOURCE CURRENT (AMPS)
C     YMIT = INPUT ADMITTANCE (MHOS)
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 VOLTS,CRNT,YMIT,AIX,BIX,CIX,CUR,XKS
      COMMON/CRNT/AIX(MAXSEG),BIX(MAXSEG),CIX(MAXSEG),CUR(3*MAXSEG),
     &XKS(MAXSEG)
      CRNT=CUR(ISEG)
      YMIT=CRNT/VOLTS
      RETURN
      END
      SUBROUTINE YAMIT2(ISEG,VOLTS,CRNT,YMIT)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     YAMIT2 computes the input admittance and source current for a
C     segment with a charge discontinuity voltage source.
C
C     DESCRIPTION:
C     INPUT ADMITTANCE IS COMPUTED AS THE RATIO OF THE CURRENT AT END
C     ONE OF THE SEGMENT TO THE SPECIFIED VOLTAGE.  NOTE THAT THIS
C     IS THE INPUT ADMITTANCE FOR THE STRUCTURE.  IT DOES NOT INCLUDE
C     CURRENT INTO ANY NETWORKS OR TRANSMISSION LINES ON THIS SEGMENT.
C     INPUT:
C     ISEG = NUMBER OF THE SEGMENT ON WHICH THE SOURCE IS LOCATED
C     VOLTS = SOURCE VOLTAGE (VOLTS)
C
C     OUTPUT:
C     CRNT = SOURCE CURRENT (AMPS)
C     YMIT = INPUT ADMITTANCE (MHOS)
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 VOLTS,CRNT,YMIT,XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,FRATI,
     &ETAL2,AIX,BIX,CIX,CUR,XKS
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      COMMON/CRNT/AIX(MAXSEG),BIX(MAXSEG),CIX(MAXSEG),CUR(3*MAXSEG),
     &XKS(MAXSEG)
      CRNT=.5*SI(ISEG)*XKS(ISEG)
      CRNT=AIX(ISEG)-BIX(ISEG)*SIN(CRNT)+CIX(ISEG)*(COS(CRNT)-1.)
      YMIT=CRNT/VOLTS
      RETURN
      END
      SUBROUTINE ZPSAVE(MHZ,FMHZ,ZPED,IZSAVE)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     ZPSAVE stores values in COMMON/ZPSAV/ for printing a table of
C     input impedances.
C
C     DESCRIPTION:
C     INPUT:
C     MHZ = ARRAY INDEX AT WHICH THE PRESENT VALUES WILL BE STORED
C     FMHZ = FREQUENCY (MHZ)
C     ZPED = VALUE OF INPUT IMPEDANCE (VOLTS, COMPLEX)
C     IZSAVE = NUMBER OF THE SEGMENT ON WHICH THE INPUT IMPEDANCE WAS
C              COMPUTED (OHMS)
C
C     OUTPUT: TO COMMON /ZPSAV/
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 ZPED,ZPEDA
      COMMON/ZPSAV/ZPEDA(200),FRMHZA(200),ZPNORM,NZSAVE,NZLIMT,ISZSAV
      DATA NZSMAX/200/
      IF(MHZ.EQ.1)NZLIMT=0
      IF(MHZ.GT.NZSMAX)THEN
           IF(NZLIMT.EQ.0)WRITE(3,185)
           NZLIMT=1
           RETURN
      END IF
      NZSAVE=MHZ
      ISZSAV=IZSAVE
      FRMHZA(MHZ)=FMHZ
      ZPEDA(MHZ)=ZPED
      RETURN
C
185   FORMAT (///,4X,'ZPSAVE: STORAGE FOR IMPEDANCE NORMALIZATION TOO',
     &' SMALL; ARRAY TRUNCATED')
      END
      SUBROUTINE PTZPED
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     PTZPED prints a table of input impedances and normalized input
C     impedances versus frequency.
C
C     DESCRIPTION:
C     IMPEDANCE IS TAKEN FROM ARRAY ZPEDA AND FREQUENCY FROM FRMHZA.
C     IMPEDANCE IS NORMALIZED BY THE VALUE OF ZPNORM.  IF THIS VALUE IS
C     ZERO, THE MAXIMUM MAGNITUDE IN ZPEDA IS DETERMINED AND USED FOR
C     NORMALIZATION.
C
C     INPUT: FROM COMMON/ZPSAV/
C     OUTPUT:
C     FRMHZA = FREQUENCY (MHZ)
C     ZPEDA = IMPEDANCE (OHMS, COMPLEX)
C     ZPEDM = MAGNITUDE OF ZPEDA
C     ZPEDP = PHASE OF ZPEDA
C     ZPRNOR = REAL PART OF ZPEDA NORMALIZED
C     ZPXNOR = IMAGINARY PART OF ZPEDA NORMALIZED
C     ZPMNOR = MAGNITUDE OF ZPEDA NORMALIZED
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 ZPEDA
      COMMON/ZPSAV/ZPEDA(200),FRMHZA(200),ZPNORM,NZSAVE,NZLIMT,ISZSAV
      IF(ZPNORM.EQ.0.)THEN
C
C     DETERMINE MAXIMUM MAGNITUDE OF IMPEDANCE FOR USE IN NORMALIZATION
C
           DO 1 I=1,NZSAVE
           ZPEDM=ABS(ZPEDA(I))
           IF(ZPEDM.GT.ZPNORM)ZPNORM=ZPEDM
1          CONTINUE
      END IF
C
C     PRINT TABLE OF IMPEDANCE AND NORMALIZED IMPEDANCE
C
      WRITE(3,184)ISZSAV,ZPNORM
      DO 2 I=1,NZSAVE
      ZPEDM=ABS(ZPEDA(I))
      ZPEDP=CANG(ZPEDA(I))
      ZPRNOR=DREAL(ZPEDA(I))/ZPNORM
      ZPXNOR=DIMAG(ZPEDA(I))/ZPNORM
      ZPMNOR=ZPEDM/ZPNORM
2     WRITE(3,186)FRMHZA(I),ZPEDA(I),ZPEDM,ZPEDP,ZPRNOR,ZPXNOR,ZPMNOR,
     &ZPEDP
      WRITE(3,187)
      RETURN
C
184   FORMAT (///,36X,'- - - INPUT IMPEDANCE DATA - - -',/   ,45X,
     &'SOURCE SEGMENT NO.',I4,/  ,45X,'NORMALIZATION FACTOR=',1PE12.5,
     &//,7X,'FREQ.',13X,'-  -  UNNORMALIZED IMPEDANCE  -  -',21X,
     &'-  -  NORMALIZED IMPEDANCE  -  -',/,19X,'RESISTANCE',4X,
     &'REACTANCE',6X,'MAGNITUDE',4X,'PHASE',7X,'RESISTANCE',4X,
     &'REACTANCE',6X,'MAGNITUDE',4X,'PHASE',/,8X,'MHZ',11X,'OHMS',10X,
     &'OHMS',11X,'OHMS',5X,'DEGREES',47X,'DEGREES',/)
186   FORMAT (3X,F9.3,2X,2(2X,1PE12.5),3X,E12.5,2X,0PF7.2,2X,
     &2(2X,1PE12.5),3X, E12.5,2X,0PF7.2)
187   FORMAT(//)
      END
      SUBROUTINE PTNETW
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     PTNETW prints a description of transmission lines and two port
C     networks that have been defined.
C
C     DESCRIPTION:
C     INPUT: FROM COMMON BLOCKS /NETDEF/ AND /DATA/
C     OUTPUT: FROM COMMON BLOCKS /NETDEF/ AND /DATA/
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 TLYT1,TLYT2,YN11,YN12,YN22,SVOLTS
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON/NETDEF/TLYT1(NETMX),TLYT2(NETMX),YN11(NETMX),YN12(NETMX),
     &YN22(NETMX),SVOLTS(NSOMAX),TLZCH(NETMX),TLLEN(NETMX),NVSOR,
     &NVSORA(NSOMAX),ISEG1(NETMX),ISEG2(NETMX),NONET,NETYP(NETMX)
      WRITE(3,158)
      IHEAD=0
      DO 1 I=1,NONET
      IF(NETYP(I).NE.2.AND.NETYP(I).NE.3)GO TO 1
      IF(IHEAD.EQ.0)THEN
           WRITE(3,159)
           IHEAD=1
      END IF
      IS1=ISEG1(I)
      IS2=ISEG2(I)
      IF(NETYP(I).EQ.2)WRITE(3,90) ITAG(IS1),IS1,ITAG(IS2),IS2,TLZCH(I),
     &TLLEN(I),TLYT1(I),TLYT2(I)
      IF(NETYP(I).EQ.3)WRITE(3,91) ITAG(IS1),IS1,ITAG(IS2),IS2,TLZCH(I),
     &TLLEN(I),TLYT1(I),TLYT2(I)
1     CONTINUE
      IHEAD=0
      DO 2 I=1,NONET
      IF(NETYP(I).NE.1)GO TO 2
      IF(IHEAD.EQ.0)THEN
           WRITE(3,160)
           IHEAD=1
      END IF
      IS1=ISEG1(I)
      IS2=ISEG2(I)
      WRITE(3,92) ITAG(IS1),IS1,ITAG(IS2),IS2,YN11(I),YN12(I),YN22(I)
2     CONTINUE
      RETURN
C
90    FORMAT (4X,4(I5,1X),6(3X,1PE11.4),3X,'STRAIGHT')
91    FORMAT (4X,4(I5,1X),6(3X,1PE11.4),3X,'CROSSED')
92    FORMAT (4X,4(I5,1X),6(3X,1PE11.4))
158   FORMAT (///,44X,'- - - NETWORK DATA - - -')
159   FORMAT (/,6X,'- FROM -    - TO -',11X,'TRANSMISSION LINE',15X,
     &'-  -  SHUNT ADMITTANCES (MHOS)  -  -',14X,'LINE',/,6X,
     &'TAG  SEG.   TAG  SEG.',6X,'IMPEDANCE',6X,'LENGTH',12X,
     &'- END ONE -',17X,'- END TWO -',12X,'TYPE',/,6X,
     &'NO.   NO.   NO.   NO.',9X,'OHMS',8X,'METERS',9X,'REAL',10X,
     &'IMAG.',9X,'REAL',10X,'IMAG.')
160   FORMAT (/,6X,'- FROM -',4X,'- TO -',26X,'-  -  ADMITTANCE MATRIX E
     &LEMENTS (MHOS)  -  -',/,6X,'HTAG  SEG.   TAG  SEG.',13X,
     &'(ONE,ONE)',19X,'(ONE,TWO)',19X,'(TWO,TWO)',/ ,6X,
     &'NO.   NO.   NO.   NO.',8X,'REAL',10X,'IMAG.',9X,'REAL',10X,
     &'IMAG.',9X,'REAL',10X,'IMAG.')
      END
      SUBROUTINE PTPCHC
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     PTPCHC prints a table of surface patch currents.
C
C     DESCRIPTION:
C     INPUT: FROM COMMON BLOCKS /DATA/, /CRNT/ AND /GND/
C
C     OUTPUT:
C     IPAT = NUMBER OF THE PATCH
C     XNOR,YNOR,ZNOR = X, Y AND Z COORDINATES OF THE CENTER OF THE PATCH
C                      NORMALIZED TO WAVELENGTH
C     CURT1M,CURT1A = MAGNITUDE AND PHASE OF THE COMPONENT OF CURRENT
C                     ALONG UNIT VECTOR T1 ON THE SURFACE OF THE PATCH
C     CURT2M,CURT2A = MAGNITUDE AND PHASE OF THE COMPONENT OF CURRENT
C                     ALONG UNIT VECTOR T2 ON THE SURFACE OF THE PATCH
C     CURX,CURY,CURZ = X, Y AND Z COMPONENTS OF THE CURRENT ON THE PATCH
C                      (AMPS)
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 AIX,BIX,CIX,CUR,XKS,XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,
     &FRATI,ETAL2,CURX,CURY,CURZ,CURT1,CURT2,XK
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON/CRNT/AIX(MAXSEG),BIX(MAXSEG),CIX(MAXSEG),CUR(3*MAXSEG),
     &XKS(MAXSEG)
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      DIMENSION T1X(MAXSEG),T1Y(MAXSEG),T1Z(MAXSEG)
      EQUIVALENCE (T1X,SI),(T1Y,ALP),(T1Z,BET)
      IF(M.EQ.0)RETURN
      WRITE(3,197)
      ICUR=N-2
      IXYZ=LD+1
      DO 1 IPAT=1,M
      ICUR=ICUR+3
      IXYZ=IXYZ-1
      CURX=CUR(ICUR)
      CURY=CUR(ICUR+1)
      CURZ=CUR(ICUR+2)
C
C     COMPUTE COMPONENTS OF CURRENT ALONG THE UNIT VECTORS T1 AND T2
C
      CURT1=CURX*T1X(IXYZ)+CURY*T1Y(IXYZ)+CURZ*T1Z(IXYZ)
      CURT2=CURX*T2X(IXYZ)+CURY*T2Y(IXYZ)+CURZ*T2Z(IXYZ)
      CURT1M=ABS(CURT1)
      CURT1A=CANG(CURT1)
      CURT2M=ABS(CURT2)
      CURT2A=CANG(CURT2)
C
C     COMPUTE PATCH COORDINATES NORMALIZED TO WAVELENGTH
C
      XK=XKU
      IF(Z(IXYZ).LT.0.)XK=XKL
      WLAM=6.2831853071796D0/ABS(XK)
      XNOR=X(IXYZ)/WLAM
      YNOR=Y(IXYZ)/WLAM
      ZNOR=Z(IXYZ)/WLAM
      WRITE(3,198)IPAT,XNOR,YNOR,ZNOR,CURT1M,CURT1A,CURT2M,CURT2A,CURX,
     &CURY,CURZ
1     CONTINUE
      RETURN
C
197   FORMAT(   ////,41X,'- - - - SURFACE PATCH CURRENTS - - - -',//,
     &50X,'DISTANCES IN WAVELENGTHS (2.*PI/CABS(K))',/,50X,
     &'CURRENT IN AMPS/METER',//,28X,'- - SURFACE COMPONENTS - -',19X,
     &'- - - RECTANGULAR COMPONENTS - - -',/,6X,'PATCH CENTER',6X,
     &'TANGENT VECTOR 1',3X,'TANGENT VECTOR 2',11X,'X',19X,'Y',19X,
     &'Z',/,5X,'X',6X,'Y',6X,'Z',5X,'MAG.',7X,'PHASE',3X,'MAG.',7X,
     &'PHASE',3(4X,'REAL',6X,'IMAG. '))
198   FORMAT(1X,I4,/,1X,3F7.3,2(1PE11.4,0PF8.2),1P6E10.2)
      END
      SUBROUTINE PTRECN
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     PTRECN prints a normalized receiving pattern table.
C
C     DESCRIPTION:
C     INPUT: FROM COMMON /RECPAT/
C
C     OUTPUT:
C     THETRC = SPHERICAL COORDINATE ANGLE THETA (DEGREES) OF THE INCIDENT
C              PLANE WAVE
C     PHIRC = SPHERICAL COORDINATE ANGLE PHI (DEGREES) OF THE INCIDENT
C             PLANE WAVE
C     PATDB = NORMALIZED PATTERN VALUE IN DB
C     PATRCN = NORMALIZED PATTERN VALUE
C
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*6 POLTYP
      COMMON/RECPAT/THETRC(200),PHIRC(200),ETARC,ARATRC,PATRC(200),
     &NPATRC,MAXRCX,ISEGRP,POLTYP
      IF(MAXRCX.EQ.1)WRITE(3,181)
      PMAX=PATRC(1)
      DO 1 I=2,NPATRC
      IF (PATRC(I).GT.PMAX) PMAX=PATRC(I)
1     CONTINUE
      WRITE(3,182) PMAX,ETARC,POLTYP,ARATRC,ISEGRP
      DO 2 I=1,NPATRC
      PATRCN=PATRC(I)/PMAX
      PATDB=DB20(PATRCN)
2     WRITE(3,183) THETRC(I),PHIRC(I),PATDB,PATRCN
      RETURN
C
181   FORMAT (///,4X,'PTRECN: RECEIVING PATTERN STORAGE TOO SMALL;',
     &' ARRAY TRUNCATED')
182   FORMAT (///,32X,'- - - NORMALIZED RECEIVING PATTERN - - -',/,41X,
     & 'NORMALIZATION FACTOR=',1PE11.4,/,41X,'ETA=',0PF7.2,' DEGREES',
     &/,41X,'TYPE -',A6,/,41X,'AXIAL RATIO=',F6.3,/,41X,'SEGMENT NO.=',
     &I5,//,21X,'THETA',6X,'PHI',9X,'-  PATTERN  -',/,21X,'(DEG)',5X,
     &'(DEG)',8X,'DB',8X,'MAGNITUDE',/)
183   FORMAT (20X,2(F7.2,3X),1X,F7.2,4X,1PE11.4)
      END
      SUBROUTINE WCHARG(DSEG,ISEG,QSEG,XSNOR,YSNOR,ZSNOR,SINOR)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     WCHARG computes the linear charge density at a point on a wire
C     using the previously computed current.
C
C     DESCRIPTION:
C     INPUT:
C     DSEG = DISTANCE FROM THE CENTER OF SEGMENT ISEG TO THE POINT AT
C            WHICH THE CHARGE IS TO BE COMPUTED (M)
C     ISEG = NUMBER OF THE SEGMENT ON WHICH CHARGE IS TO BE COMPUTED
C
C     OUTPUT:
C     QSEG = LINEAR CHARGE DENSITY AT THE SPECIFIED POINT (COULOMBS/M)
C     XSNOR = X COORDINATE OF THE POINT NORMALIZED BY WAVELENGTH
C     YSNOR = Y COORDINATE OF THE POINT NORMALIZED BY WAVELENGTH
C     ZSNOR = Z COORDINATE OF THE POINT NORMALIZED BY WAVELENGTH
C     SINOR = LENGTH OF SEGMENT ISEG NORMALIZED BY WAVELENGTH
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 QSEG,AIX,BIX,CIX,CUR,XKS,XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,
     &FRATI,ETAL2,XK,XKSS
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON/CRNT/AIX(MAXSEG),BIX(MAXSEG),CIX(MAXSEG),CUR(3*MAXSEG),
     &XKS(MAXSEG)
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      XK=XKU
      IF(Z(ISEG).LT.0.)XK=XKL
      XKSS=XKS(ISEG)
      QSEG=(0.,1.)*DREAL(XK*XK)*XKSS/(OMEGAG*XK**2)*(BIX(ISEG)*
     &COS(XKSS*DSEG)-CIX(ISEG)*SIN(XKSS*DSEG))
      WLAM=6.2831853071796D0/ABS(XK)
      XSNOR=(X(ISEG)+ALP(ISEG)*DSEG)/WLAM
      YSNOR=(Y(ISEG)+BET(ISEG)*DSEG)/WLAM
      ZSNOR=(Z(ISEG)+SALP(ISEG)*DSEG)/WLAM
      SINOR=SI(ISEG)/WLAM
      RETURN
      END
      SUBROUTINE PTWIRQ(IPTFLQ,IPTAQ,IPTAQF,IPTAQT)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     PTWIRQ prints the linear charge density on wire segments.
C
C     DESCRIPTION:
C     INPUT:
C     IPTFLQ = PRINT CONTROL FLAG FOR CHARGE (FIRST INTEGER FROM PQ
C              COMMAND)
C     IPTAQ = SEGMENT TAG FOR PRINTING A LIMITED RANGE OF SEGMENTS
C     IPTAQF,IPTAQT = SEGMENT NUMBERS FOR PRINTING A LIMITED RANGE OF
C                     SEGMENTS.  CHARGE IS PRINTED FOR SEGMENTS HAVING
C                     TAGS EQUAL TO IPTAQ FROM SEGMENT IPTAQF THROUGH
C                     SEGMENT IPTAQT.
C
C     OUTPUT:
C     ISEG = SEGMENT NUMBER
C     ITAG = SEGMENT TAG
C     XSNOR,YSNOR,ZSNOR = X, Y AND Z COORDINATES OF THE SEGMENT CENTER
C                         NORMALIZED TO WAVELENGTH
C     SINOR = SEGMENT LENGTH NORMALIZED TO WAVELENGTH
C     QSEG = LINEAR CHARGE DENSITY (COULOMBS/M)
C     QMAG = MAGNITUDE OF QSEG
C     PH = PHASE OF QSEG
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 QSEG
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      IF(N.EQ.0)RETURN
      WRITE(3,315)
      ICOUNT=0
      DO 69 ISEG=1,N
      IF(IPTFLQ.EQ.0)THEN
C
C     CHECK WHETHER SEGMENT ISEG IS IN THE LIMITED PRINTING RANGE
C
           IF (IPTAQ.NE.0.AND.IPTAQ.NE.ITAG(ISEG)) GO TO 69
           ICOUNT=ICOUNT+1
           IF (ICOUNT.LT.IPTAQF.OR.ICOUNT.GT.IPTAQT) GO TO 69
      END IF
      IF(ICON1(ISEG).EQ.0)THEN
C
C     END ONE OF SEGMENT ISEG IS A FREE END.  PRINT CHARGE.
C
           CALL WCHARG(-.5*SI(ISEG),ISEG,QSEG,XSNOR,YSNOR,ZSNOR,SINOR)
           QMAG=ABS(QSEG)
           PH=CANG(QSEG)
           WRITE(3,166)ISEG,ITAG(ISEG),XSNOR,YSNOR,ZSNOR,SINOR,QSEG,
     &     QMAG,PH
      END IF
C
C     PRINT CHARGE AT THE CENTER OF SEGMENT ISEG.
C
      CALL WCHARG(0.D0,ISEG,QSEG,XSNOR,YSNOR,ZSNOR,SINOR)
      QMAG=ABS(QSEG)
      PH=CANG(QSEG)
      WRITE(3,165)ISEG,ITAG(ISEG),XSNOR,YSNOR,ZSNOR,SINOR,QSEG,QMAG,PH
      IF(ICON2(ISEG).EQ.0)THEN
C
C     END TWO OF SEGMENT ISEG IS A FREE END.  PRINT CHARGE.
C
           CALL WCHARG(.5*SI(ISEG),ISEG,QSEG,XSNOR,YSNOR,ZSNOR,SINOR)
           QMAG=ABS(QSEG)
           PH=CANG(QSEG)
           WRITE(3,166)ISEG,ITAG(ISEG),XSNOR,YSNOR,ZSNOR,SINOR,QSEG,
     &     QMAG,PH
      END IF
69    CONTINUE
      RETURN
C
315   FORMAT(///,34X,'- - - CHARGE DENSITIES - - -',//,23X,
     &'LENGTHS NORMALIZED TO WAVELENGTH (OR 2.*PI/CABS(K))',///,2X,
     &'SEG.',2X,'TAG',4X,'COORD. OF SEG. CENTER',5X,'SEG.',10X,
     &'CHARGE DENSITY (COULOMBS/METER)',/,2X,'NO.',3X,'NO.',5X,'X',8X,
     &'Y',8X,'Z',6X,'LENGTH',5X,'REAL',8X,'IMAG.',7X,'MAG.',8X,'PHASE')
165   FORMAT (1X,2I5,3F9.4,F9.5,1X,1P3E12.4,0PF9.3)
166   FORMAT (1X,I5,'E',I4,3F9.4,F9.5,1X,1P3E12.4,0PF9.3)
      END
      SUBROUTINE PTRECP(THET,PHI,ETA,AXRAT,IPTFLG,IPTAG,IPTAGF,IPTAGT,
     &INC)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     PTRECP prints structure currents in a format for receiving
C     patterns.
C
C     DESCRIPTION:
C     EACH TIME THAT PTRECP IS CALLED IT PRINTS THE CURRENTS ON SEGMENTS
C     WITHIN THE SPECIFIED RANGE IN A FORMAT FOR RECEIVING PATTERNS.
C     WHEN IT IS CALLED WITH INC=1 IT PRINTS A HEADING FOR THE TABLE.
C     PTRECP ALSO STORES THE VALUES IN COMMON/RECPAT/ FOR SUBSEQUENT
C     PRINTING OF NORMALIZED RECEIVING PATTERN.
C
C     INPUT:
C     THET,PHI = ANGLES (DEGREES) IN SPHERICAL COORDINATES OF THE VECTOR
C                TOWARD THE SOURCE OF THE PLANE WAVE.
C     ETA = POLARIZATION ANGLE OF E FIELD.  FOR ETA=0, E FIELD IS ALONG
C           THE THETA UNIT VECTOR.  POSITIVE ETA ROTATES POLARIZATION
C           COUNTER CLOCKWISE WHEN VIEWED IN THE DIRECTION OF PROPAGATION
C     AXRAT = RATIO OF MINOR AXIS TO MAJOR AXIS FIELD OF AN ELLIPTICALLY
C             POLARIZED INCIDENT WAVE
C     IPTFLG = PRINT CONTROL FLAG FOR CURRENT (FIRST INTEGER FROM PT
C              COMMAND)
C     IPTAG = SEGMENT TAG FOR PRINTING A LIMITED RANGE OF SEGMENTS
C     IPTAGF,IPTAGT = SEGMENT NUMBERS FOR PRINTING A LIMITED RANGE OF
C                     SEGMENTS.  CURRENT IS PRINTED FOR SEGMENTS HAVING
C                     TAGS EQUAL TO IPTAG FROM SEGMENT IPTAGF THROUGH
C                     SEGMENT IPTAGT.
C     INC = ARRAY INDEX FOR STORING VALUES IN COMMON/RECPAT/
C
C     OUTPUT:
C     ETARC = ETA FROM INPUT
C     POLTYP = DESCRIPTION OF ELLIPTIC POLARIZATION (CHARACTER)
C     ARATRC = AXRAT FROM INPUT
C     THET,PHI = SAME AS INPUT
C     CMAG = MAGNITUDE OF CURRENT (AMPS)
C     PH = PHASE OF CURRENT (DEGREES)
C     ISEG = SEGMENT NUMBER
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*6 HPOL(3),POLTYP
      COMPLEX*16 AIX,BIX,CIX,CUR,XKS,XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,
     &FRATI,ETAL2,CURI
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON/CRNT/AIX(MAXSEG),BIX(MAXSEG),CIX(MAXSEG),CUR(3*MAXSEG),
     &XKS(MAXSEG)
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      COMMON/RECPAT/THETRC(200),PHIRC(200),ETARC,ARATRC,PATRC(200),
     &NPATRC,MAXRCX,ISEGRP,POLTYP
      DATA HPOL/'LINEAR','RIGHT','LEFT'/,MAXRCP/200/
      IF(N.EQ.0)RETURN
      IF(INC.EQ.1)THEN
C
C     PRINT HEADING
C
         IF(AXRAT.GT.1.E-5)THEN
            POLTYP=HPOL(2)
         ELSE IF(AXRAT.LT.-1.E-5)THEN
            POLTYP=HPOL(3)
         ELSE
            POLTYP=HPOL(1)
         END IF
         ARATRC=ABS(AXRAT)
         ETARC=ETA
         MAXRCX=0
         IF(IPTFLG.NE.3)WRITE(3,163) ETARC,POLTYP,ARATRC
      END IF
      ICOUNT=0
C
C     LOOP TO PRINT CURRENTS
C
      DO 69 ISEG=1,N
      IF (IPTAG.NE.0.AND.IPTAG.NE.ITAG(ISEG)) GO TO 69
      ICOUNT=ICOUNT+1
      IF (ICOUNT.LT.IPTAGF.OR.ICOUNT.GT.IPTAGT) GO TO 69
      CURI=CUR(ISEG)
      CMAG=ABS(CURI)
      PH=CANG(CURI)
      IF (IPTFLG.NE.3) WRITE(3,164) THET,PHI,CMAG,PH,ISEG
      IF (IPTFLG.LT.2) GO TO 69
      IF (INC.GT.MAXRCP)THEN
C
C     ARRAY IS FULL SO CAN'T STORE ANY MORE CURRENTS FOR NORM. RAD. PAT.
C
           MAXRCX=1
           GO TO 69
      END IF
C
C     STORE ANGLES AND CURRENT FOR NORMALIZED RADIATION PATTERN TABLE
C
      THETRC(INC)=THET
      PHIRC(INC)=PHI
      PATRC(INC)=CMAG
      NPATRC=INC
      ISEGRP=ISEG
69    CONTINUE
      RETURN
C
163   FORMAT (///,33X,'- - - RECEIVING PATTERN PARAMETERS - - -',/  ,43X
     &,'ETA=',F7.2,' DEGREES',/,43X,'TYPE -',A6,/,43X,'AXIAL RATIO=',
     &F6.3,//,11X,'THETA',6X,'PHI',10X,'-  CURRENT  -',9X,'SEG',/,11X,
     &'(DEG)',5X,'(DEG)',7X,'MAGNITUDE',4X,'PHASE',6X,'NO.',/)
164   FORMAT (10X,2(F7.2,3X),1X,1PE11.4,3X,0PF7.2,4X,I5)
      END
      SUBROUTINE PTWIRC(IPTFLG,IPTAG,IPTAGF,IPTAGT)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     PTWIRC prints a table of currents on wire segments.
C
C     DESCRIPTION:
C     INPUT:
C     IPTFLG = PRINT CONTROL FLAG FOR CURRENT (FIRST INTEGER FROM PT
C              COMMAND)
C     IPTAG = SEGMENT TAG FOR PRINTING A LIMITED RANGE OF SEGMENTS
C     IPTAGF,IPTAGT = SEGMENT NUMBERS FOR PRINTING A LIMITED RANGE OF
C                     SEGMENTS.  CURRENT IS PRINTED FOR SEGMENTS HAVING
C                     TAGS EQUAL TO IPTAG FROM SEGMENT IPTAGF THROUGH
C                     SEGMENT IPTAGT.
C     OTHER INPUT FROM COMMON BLOCKS /DATA/, /GND/ AND /CRNT/
C
C     OUTPUT:
C     ISEG = SEGMENT NUMBER
C     ITAG = TAG NUMBER OF SEGMENT
C     XNORM,YNORM,ZNORM = X, Y AND Z COORDINATES OF THE CENTER OF THE
C                         SEGMENT, NORMALIZED TO WAVELENTGH
C     SNORM = SEGMENT LENGTH NORMALIZED TO WAVELENGTH
C     CURI = SEGMENT CURRENT (AMPS, COMPLEX)
C     CMAG = MAGNITUDE OF CURI (AMPS)
C     PH = PHASE OF CURI (DEGREES)
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 AIX,BIX,CIX,CUR,XKS,XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,
     &FRATI,ETAL2,XK,CURI
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON/CRNT/AIX(MAXSEG),BIX(MAXSEG),CIX(MAXSEG),CUR(3*MAXSEG),
     &XKS(MAXSEG)
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      IF(IPTFLG.EQ.-1)RETURN
      IF(N.EQ.0)RETURN
      WRITE(3,161)
      ICOUNT=0
      DO 69 ISEG=1,N
      IF(IPTFLG.EQ.0)THEN
C
C     CURRENTS PRINTED FOR LIMITED RANGE OF SEGMENTS.  CHECK TAGS.
C
           IF (IPTAG.NE.0.AND.IPTAG.NE.ITAG(ISEG)) GO TO 69
           ICOUNT=ICOUNT+1
           IF (ICOUNT.LT.IPTAGF.OR.ICOUNT.GT.IPTAGT) GO TO 69
      END IF
C
C     PRINT SEGMENT COORDINATES AND CURRENT
C
      XK=XKU
      IF(Z(ISEG).LT.0.)XK=XKL
      WLAM=6.2831853071796D0/ABS(XK)
      XNORM=X(ISEG)/WLAM
      YNORM=Y(ISEG)/WLAM
      ZNORM=Z(ISEG)/WLAM
      SNORM=SI(ISEG)/WLAM
      CURI=CUR(ISEG)
      CMAG=ABS(CURI)
      PH=CANG(CURI)
      WRITE(3,165) ISEG,ITAG(ISEG),XNORM,YNORM,ZNORM,SNORM,CURI,CMAG,PH
69    CONTINUE
      RETURN
C
161   FORMAT (///,29X,'- - - CURRENTS AND LOCATION - - -',//,21X,
     &'LENGTHS NORMALIZED BY WAVELENGTH (OR 2.*PI/CABS(K))',//,2X,'SEG.'
     &,2X,'TAG',4X,'COORD. OF SEG. CENTER',5X,'SEG.',12X,
     &'- - - CURRENT (AMPS) - - -',/,2X,'NO.',3X,'NO.',5X,'X',8X,'Y',8X,
     &'Z',6X,'LENGTH',5X,'REAL',8X,'IMAG.',7X,'MAG.',8X,'PHASE')
165   FORMAT (1X,2I5,3F9.4,F9.5,1X,1P3E12.4,0PF9.3)
      END
      SUBROUTINE PWRBGT(PIN,PNLS,PLOSS)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     PWRBGT prints a power budget of input power, radiated power and
C     dissipated power.
C
C     DESCRIPTION:
C     INPUT:
C     PIN = TOTAL INPUT POWER FROM VOLTAGE SOURCES (WATTS)
C     PNLS = TOTAL POWER DISSIPATED IN NETWORKS AND TRANSMISSION LINES
C            (WATTS)
C     OTHER INPUT FROM COMMON BLOCKS
C
C     OUTPUT:
C     PLOSS = TOTAL POWER DISSIPATED IN WIRES AND SHEATH
C
      IMPLICIT REAL*8 (A-H,O-Z)
      CALL WIRLOS(PWLOSS,PSLOSS)
      PLOSS=PWLOSS+PSLOSS
      PWRRAD=PIN-PNLS-PLOSS
      EFFNCY=100.*PWRRAD/PIN
      WRITE(3,90) PIN,PWRRAD,PWLOSS
      IF(PSLOSS.GT.0.)WRITE(3,91)PSLOSS
      IF(PNLS.GT.0.)WRITE(3,92)PNLS
      WRITE(3,93)EFFNCY
      RETURN
C
90    FORMAT(///,40X,'- - - POWER BUDGET - - -',//,43X,'INPUT POWER   ='
     &,1PE11.4,' WATTS',/,43X,'RADIATED POWER=',E11.4,' WATTS',/ ,43X,
     &'WIRE LOSS     =',E11.4,' WATTS')
91    FORMAT(43X,'SHEATH LOSS   =',1PE11.4,' WATTS')
92    FORMAT(43X,'NETWORK LOSS  =',1PE11.4,' WATTS')
93    FORMAT(43X,'EFFICIENCY    =',F7.2,' PERCENT')
      END
      SUBROUTINE WIRLOS(PWLOSS,PSLOSS)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     WIRLOS computes the power dissipated by ohmic loss in wires and
C     in lossy sheaths.
C
C     INPUT: FROM COMMON BLOCKS
C
C     OUTPUT:
C     PWLOSS = POWER DISSIPATED IN FINITELY CONDUCTING WIRES
C     PSLOSS = POWER DISSIPATED IN A LOSSY SHEATH ON THE WIRE
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 AIX,BIX,CIX,CUR,XKS,XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,
     &ETAL2,FRATI,ZARRAY,CEINS,XK
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON/CRNT/AIX(MAXSEG),BIX(MAXSEG),CIX(MAXSEG),CUR(3*MAXSEG),
     &XKS(MAXSEG)
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      COMMON/ZLOAD/ ZARRAY(MAXSEG),NLOAD,NLODF,LDTYP(LOADMX),
     &LDTAG(LOADMX),LDTAGF(LOADMX),LDTAGT(LOADMX),ZLR(LOADMX),
     &ZLI(LOADMX),ZLC(LOADMX)
      COMMON/INSCOM/CEINS(MAXSEG),BRINS(MAXSEG),NINS,NINSF,INTAG(MAXIS),
     &INTAGF(MAXIS),INTAGT(MAXIS),EPSIN(MAXIS),SIGIN(MAXIS),RADIN(MAXIS)
      COMMON/CONSTN/PI,TP,DTORAD,CVEL,EPSRZ,RMUZ,ETAZ
      PWLOSS=0.
      PSLOSS=0.
C
C     COMPUTE OHMIC LOSS ON WIRE SEGMENTS
C
      IF(NLOAD.NE.0.OR.NLODF.NE.0)THEN
           DO 1 I=1,N
           ZARR=DREAL(ZARRAY(I)*XKU)
           IF (ABS(ZARR).LT.1.E-20) GO TO 1
           PWLOSS=PWLOSS+DREAL(CUR(I)*DCONJG(CUR(I)))*ZARR*SI(I)
1          CONTINUE
           PWLOSS=.5*PWLOSS
      END IF
C
C     LOSS IN WIRE SHEATH
C
      IF(NINS.NE.0.OR.NINSF.NE.0)THEN
C        EPCON=-1./(4.*PI*OMEGA*EPSRZ)
         EPCON=-1./(OMEGAG*1.1126E-10)
         DO 3 I=1,N
         IF(BRINS(I).EQ.0.)GO TO 3
         XK=XKS(I)
         BMAGS=DREAL(BIX(I))**2+DIMAG(BIX(I))**2
         XMAGS=DREAL(XK)**2+DIMAG(XK)**2
         ARG=DREAL(XK)*SI(I)
         IF(ABS(ARG).LT.1.E-2)THEN
            CINT=SI(I)*XMAGS*BMAGS
         ELSE
            SF1=SIN(ARG)/ARG
            ARG=DIMAG(XK)*SI(I)
            SF2=1.
            IF(ABS(ARG).GT.1.E-3)SF2=SINH(ARG)/ARG
            CMAGS=DREAL(CIX(I))**2+DIMAG(CIX(I))**2
            CINT=.5*SI(I)*XMAGS*((SF1+SF2)*BMAGS+(SF2-SF1)*CMAGS)
         END IF
         XMAGS=LOG(BRINS(I)/BI(I))/(DREAL(CEINS(I))**2+DIMAG(CEINS(I)
     &         )**2)
         PSLOSS=PSLOSS+EPCON*DIMAG(CEINS(I))*XMAGS*CINT
3        CONTINUE
      END IF
      RETURN
      END
      SUBROUTINE PTEXCT(IPTFLG)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     PTEXCT prints a description of the excitation for an incident
C     plane wave or hertzian dipole source.
C
C     DESCRIPTION:
C     INPUT:
C     IPTFLG = PRINT CONTROL FLAG FOR CURRENTS.  IF CURRENTS ARE TO BE
C              PRINTED IN THE RECEIVING PATTERN FORMAT THEN THE PLANE
C              WAVE DISCRIPTION IS NOT PRINTED AT THIS POINT.
C     OTHER INPUT FROM COMMON /SORCES/
C
C     OUTPUT:
C     FROM COMMON /SORCES/
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER*6 HPOL(3)
      COMMON /SORCES/ PSOR1(NSOMAX),PSOR2(NSOMAX),PSOR3(NSOMAX),
     &PSOR4(NSOMAX),PSOR5(NSOMAX),PSOR6(NSOMAX),DTHINC,DPHINC,NTHINC,
     &NPHINC,NSCINC,NSORC,ISORTP(NSOMAX)
      DATA HPOL/'LINEAR','RIGHT','LEFT'/
      IPHEAD=0
C
C     SEARCH SOURCE ARRAY FOR PLANE WAVE OR HERTZIAN DIPOLE SOURCES.
C     NOTHING IS DONE FOR VOLTAGE SOURCES.
      DO 1 I=1,NSORC
      ISP=ISORTP(I)
      IF(ISP.EQ.1.OR.ISP.EQ.4)GO TO 1
      IF ((IPTFLG.LE.0.OR.ISP.EQ.3).AND.IPHEAD.EQ.0)THEN
C
C     PRINT HEADING FOR PLANE WAVE OR HERTZIAN DIPOLE SOURCE
C
           WRITE(3,154)
           IPHEAD=1
      END IF
      IF (ISP.EQ.2.AND.IPTFLG.LE.0) THEN
C
C     PRINT DESCRIPTION OF INCIDENT PLANE WAVE
C
           IF(PSOR5(I).EQ.0.)IPOL=1
           IF(PSOR5(I).GT.0.)IPOL=2
           IF(PSOR5(I).LT.0.)IPOL=3
           AXRAT=ABS(PSOR5(I))
           WRITE(3,155) PSOR1(I),PSOR2(I),PSOR3(I),HPOL(IPOL),AXRAT
      END IF
C
C     PRINT DESCRIPTION OF HERTZIAN DIPOLE SOURCE
C
      IF (ISP.EQ.3) WRITE(3,156) PSOR1(I),PSOR2(I),PSOR3(I),PSOR4(I),
     &PSOR5(I),PSOR6(I)
1     CONTINUE
      RETURN
C
154   FORMAT (///,40X,'- - - EXCITATION - - -')
155   FORMAT (/,4X,'PLANE WAVE',4X,'THETA=',F7.2,' DEG,  PHI=',F7.2,
     &' DEG,  ETA=',F7.2,' DEG,  TYPE -',A6,'=  AXIAL RATIO=',F6.3)
156   FORMAT (/,31X,'POSITION (METERS)',14X,'ORIENTATION (DEG)=',/,28X,
     &'X',12X,'Y',12X,'Z',10X,'ALPHA',5X,'BETA',4X,'DIPOLE MOMENT',//
     & ,4X,'CURRENT SOURCE',1X,3(3X,F10.5),1X,2(3X,F7.2),4X,F8.3)
      END
      SUBROUTINE FFLD (THET,PHI,ETH,EPH)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     FFLD calculates the far zone radiated electric fields.
C
C     DESCRIPTION:
C     FFLD CALLS SUBROUTINES TO COMPUTE THE RADIATED ELECTRIC FIELD OF
C     A STRUCTURE.  IF A GROUND PLANE IS PRESENT, FFLD COMPUTES THE
C     TOTAL FIELD INCLUDING DIRECT AND REFLECTED FIELD AND FIELD
C     TRANSMITTED ACROSS THE INTERFACE.  SURFACE WAVE IS NOT INCLUDED.
C     THE FACTOR EXP(-J*K*R)/R IS OMITTED FROM THE RESULT.
C
C     INPUT:
C     THET,PHI = SPHERICAL COORDINATE ANGLES (RADIANS) OF THE VECTOR
C                IN THE DIRECTION IN WHICH THE RADIATED FIELD IS TO BE
C                COMPUTED
C     OTHER INPUT FROM COMMON BLOCKS /DATA/ AND /GND/
C
C     OUTPUT:
C     ETH,EPH = COMPONENT OF (E FIELD)*R*EXP(-J*K*R) ALONG THE UNIT
C               VECTORS THETA AND PHI, RESPECTIVELY
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 ETH,EPH,XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,FRATI,ETAL2,
     &CONS,CONST,XK,XKX,ETA,CKX,CKY,CKZ,EX,EY,EZ,CEX,CEY,CEZ,YSTE,ZSTM,
     &REX,REY,REZ,CKZX
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      DIMENSION CAB(MAXSEG),SAB(MAXSEG),S(MAXSEG)
      EQUIVALENCE (CAB,ALP),(SAB,BET),(S,BI)
      DATA CONS/(0.D0,.07957747151D0)/
      CONST=-XKU*ETAU*CONS
      SPH=SIN(PHI)
      CPH=COS(PHI)
      STH=SIN(THET)
      CTH=COS(THET)
      PHX=-SPH
      PHY=CPH
      THX=CTH*CPH
      THY=CTH*SPH
      THZ=-STH
      ROX=STH*CPH
      ROY=STH*SPH
      ROZ=CTH
C
C     SET FIELD TO ZERO BELOW PERFECTLY CONDUCTING GROUND
C
      IF (IPERF.NE.1.OR.ROZ.GT.-1.E-7) GO TO 4
      ETH=(0.,0.)
      EPH=(0.,0.)
      RETURN
C
C     SET PARAMETERS FOR FIELD ABOVE OR BELOW INTERFACE
C
4     IF (IPERF.NE.1.AND.ROZ.LT.-1.E-7) GO TO 1
      XK=XKU
      XKX=XKL
      ETA=ETAU
      SIDE=1.
      GO TO 2
1     XK=XKL
      XKX=XKU
      ETA=ETAL
      SIDE=-1.
2     IF(KSYMP.EQ.1)SIDE=0.
C
C     SET FIELD TO ZERO BELOW INTERFACE OF CONDUCTING GROUND
C
      IF(KSYMP.EQ.1)GO TO 3
      IF (ABS(DIMAG(XK)).LT.ABS(DREAL(XK))*1.E-6) GO TO 3
      ETH=(0.,0.)
      EPH=(0.,0.)
      RETURN
C
C     CALCULATE DIRECT FIELD FROM SEGMENTS ON NEAR SIDE OF INTERFACE
C
3     CKX=-ROX*XK
      CKY=-ROY*XK
      CKZ=-ROZ*XK
      CALL FFLDIR(XK,CKX,CKY,CKZ,SIDE,EX,EY,EZ)
      IF(KSYMP.EQ.1)GO TO 29
C
C     ADD REFLECTED FIELD FOR UNIFORM GROUND
C
      IF(ICLIFT.NE.0.OR.NRADL.NE.0)GO TO 5
      CALL FFLDIR(XK,CKX,CKY,-CKZ,SIDE,CEX,CEY,CEZ)
      CALL ZYSURF(CTH,0.D0,0.D0,SIDE,IPERFG,YSTE,ZSTM)
      CALL REFCOF(CTH,PHX,PHY,ETA,IPERF,YSTE,ZSTM,CEX,CEY,CEZ,REX,REY,
     &REZ)
      GO TO 6
C
C     ADD REFLECTED FIELD FOR VARYING GROUND
C
5     CALL FFLREF(XK,ETA,PHX,PHY,ROX,ROY,ROZ,SIDE,REX,REY,REZ)
6     EX=EX+REX
      EY=EY+REY
      EZ=EZ+REZ
C
C     ADD FIELD TRANSMITED ACROSS THE INTERFACE
C
      IF(IPERF.EQ.1)GO TO 29
      CALL TRXKNO(CTH,XK,XKX,CKZX)
      CALL FFLDIR(XKX,CKX,CKY,CKZX,-SIDE,CEX,CEY,CEZ)
      CALL TRXCOF(PHX,PHY,CKZ,CKZX,XK,XKX,CEX,CEY,CEZ,REX,REY,REZ)
      EX=EX+REX
      EY=EY+REY
      EZ=EZ+REZ
C
C     CONVERT TO THETA AND PHI COMPONENTS OF RADIATED FIELD
C
29    ETH=(EX*THX+EY*THY+EZ*THZ)*CONST
      EPH=(EX*PHX+EY*PHY)*CONST
      RETURN
      END
      SUBROUTINE FFLDIR (XK,CKX,CKY,CKZ,SIDE,EX,EY,EZ)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     FFLDIR calculates the far zone radiated electric fields in an
C     infinite medium.
C
C     DESCRIPTION:
C     THE E FIELD IS COMPUTED IN RECTANGULAR COMPONENTS, WITH A
C     MEANINGLESS RADIAL COMPONENT INCLUDED.  ALSO, THE FACTOR
C     -J*W*MU/(4.*PI)*EXP(-J*K*R)/R IS OMITTED AT THIS POINT.  TO OBTAIN
C     RADIATED ELECTRIC FIELD, THE COMPONENTS TRANSVERSE TO THE
C     DIRECTION OF PROPAGATION SHOULD BE MULTIPLIED BY THE ABOVE FACTOR.
C
C     INPUT:
C     XK = WAVE NUMBER IN THE MEDIUM
C     CKX,CKY,CKZ = WAVE PROPAGATION VECTOR K FOR A WAVE ARRIVING FROM
C                   A POINT AT INFINITY IN THE DIRECTION IN WHICH THE
C                   RADIATED FIELD IS BEING COMPUTED.
C     SIDE = +1 TO COMPUTE FIELD DUE TO CURRENTS AT + Z COORD. ONLY
C            -1 TO COMPUTE FIELD DUE TO CURRENTS AT - Z COORD. ONLY
C             0 TO COMPUTE FIELD DUE TO ALL CURRENTS.
C             SIDE IS USED TO COMPUTE THE "DIRECT" REFLECTED AND
C             TRANSMITTED FIELDS WHICH ARE THEN TRANSFORMED BY THE
C             APPROPRIATE REFLECTION OR TRANSMISSION COEFFICIENTS.
C
C     OUTPUT:
C     EX,EY,EZ = RECTANGULAR COMPONENTS OF A VECTOR FROM WHICH THE
C                RADIATED FIELD CAN BE DERIVED. SEE "DISCRIPTION" ABOVE.
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 XK,CKX,CKY,CKZ,EX,EY,EZ,AIX,BIX,CIX,CUR,XKS,FJ,OMEGA,
     &XKK,SILL,TOP,BOT,A,QI,ARG,EXA,CURX,CURY,CURZ
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON/CRNT/AIX(MAXSEG),BIX(MAXSEG),CIX(MAXSEG),CUR(3*MAXSEG),
     &XKS(MAXSEG)
      DIMENSION CAB(MAXSEG),SAB(MAXSEG),S(MAXSEG)
      EQUIVALENCE (CAB,ALP),(SAB,BET),(S,BI)
      DATA FJ/(0.D0,1.D0)/
      EX=(0.,0.)
      EY=(0.,0.)
      EZ=(0.,0.)
      IF (N.EQ.0) GO TO 25
C
C     LOOP OVER STRUCTURE SEGMENTS
C
      DO 23 I=1,N
      IF(Z(I)*SIDE.LT.0.)GO TO 23
      OMEGA=CKX*CAB(I)+CKY*SAB(I)+CKZ*SALP(I)
      EL=.5*SI(I)
      XKK=XKS(I)
      IF(ABS(EL*XK).LT..05)THEN
         QI=OMEGA*OMEGA*AIX(I)+(0.,2.)*XKK*OMEGA*BIX(I)+XKK*XKK*CIX(I)
         QI=SI(I)*AIX(I)-EL*EL*EL*QI/3.
      ELSE
         SILL=OMEGA*EL
         TOP=(XKK+OMEGA)*EL
         BOT=(XKK-OMEGA)*EL
         IF (ABS(SILL).GT.1.E-3)THEN
            A=2.*SIN(SILL)/SILL
         ELSE
            A=2.-SILL*SILL/3.
         END IF
         IF (ABS(TOP).GT.1.E-3)THEN
            TOP=SIN(TOP)/TOP
         ELSE
            TOP=1.-TOP*TOP/6.
         END IF
         IF (ABS(BOT).GT.1.E-3)THEN
            BOT=SIN(BOT)/BOT
         ELSE
            BOT=1.-BOT*BOT/6.
         END IF
         QI=EL*(A*AIX(I)-FJ*(BOT-TOP)*BIX(I)+(BOT+TOP-A)*CIX(I))
      END IF
      ARG=X(I)*CKX+Y(I)*CKY+Z(I)*CKZ
      EXA=EXP(-FJ*ARG)*QI
C
C     SUMMATION FOR FAR FIELD INTEGRAL
C
      EX=EX+EXA*CAB(I)
      EY=EY+EXA*SAB(I)
      EZ=EZ+EXA*SALP(I)
23    CONTINUE
25    IF (M.EQ.0)RETURN
C
C     CONTRIBUTION FROM SURFACE PATCHES
C
      IC=N-3
      IP=LD+1
      DO 28 I=1,M
      IC=IC+3
      IP=IP-1
      IF(Z(IP)*SIDE.LT.0.)GO TO 28
      CURX=CUR(IC+1)
      CURY=CUR(IC+2)
      CURZ=CUR(IC+3)
      EXA=EXP(-FJ*(CKX*X(IP)+CKY*Y(IP)+CKZ*Z(IP)))*S(IP)
      EX=EX+CURX*EXA
      EY=EY+CURY*EXA
      EZ=EZ+CURZ*EXA
28    CONTINUE
      RETURN
      END
      SUBROUTINE FFLREF (XK,ETA,VNORX,VNORY,DX,DY,DZ,SIDE,EX,EY,EZ)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     FFLREF calculates the far zone radiated electric fields reflected
C     from a ground plane.  The height and the electrical parameters of
C     the ground plane may vary with position.
C
C     DESCRIPTION:
C     THE FIELD OF THE IMAGE OF EACH SEGMENT OR PATCH IS COMPUTED AND
C     MULTIPLIED BY THE REFLECTION COEFFICIENTS COMPUTED FOR THE POINT
C     WHERE THE RAY REFLECTS FROM THE INTERFACE.  RECTANGULAR COMPONENTS
C     OF FIELD WITH A MEANINGLESS RADIAL COMPONENT ARE USED HERE.  ALSO,
C     THE FACTOR -J*W*MU/(4.*PI)*EXP(-J*K*R)/R IS OMITTED.
C
C     INPUT:
C     XK = WAVE NUMBER IN THE MEDIUM
C     ETA = INTRINSIC IMPEDANCE OF THE MEDIUM (OHMS)
C     VNORX,VNORY = X AND Y COMPONENTS OF THE UNIT VECTOR NORMAL TO THE
C                   VERTICAL PLANE CONTAINING THE RAY
C     DX,DY,DZ = X, Y AND Z COMPONENTS OF THE UNIT VECTOR IN THE
C                DIRECTION OF PROPAGATION OF THE RADIATED FIELD
C                (REFLECTED RAY)
C     SIDE = +1 TO COMPUTE FIELD DUE TO CURRENTS AT + Z COORD. ONLY
C            -1 TO COMPUTE FIELD DUE TO CURRENTS AT - Z COORD. ONLY
C             0 TO COMPUTE FIELD DUE TO ALL CURRENTS.
C             SIDE IS USED TO COMPUTE THE "DIRECT" REFLECTED AND
C             TRANSMITTED FIELDS WHICH ARE THEN TRANSFORMED BY THE
C             APPROPRIATE REFLECTION OR TRANSMISSION COEFFICIENTS.
C
C     OUTPUT:
C     EX,EY,EZ = RECTANGULAR COMPONENTS OF A VECTOR FROM WHICH THE
C                RADIATED FIELD CAN BE DERIVED. SEE "DISCRIPTION" ABOVE.
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 XK,ETA,EX,EY,EZ,AIX,BIX,CIX,CUR,XKS,FJ,CKX,CKY,CKZ,
     &OMEGA,XKK,SILL,TOP,BOT,A,QI,ARG,EXA,CEX,CEY,CEZ,YSTE,ZSTM,RX,RY,
     &RZ,CURX,CURY,CURZ
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON/CRNT/AIX(MAXSEG),BIX(MAXSEG),CIX(MAXSEG),CUR(3*MAXSEG),
     &XKS(MAXSEG)
      DIMENSION CAB(MAXSEG),SAB(MAXSEG),S(MAXSEG)
      EQUIVALENCE (CAB,ALP),(SAB,BET),(S,BI)
      DATA FJ/(0.D0,1.D0)/
      CKX=-XK*DX
      CKY=-XK*DY
      CKZ=-XK*DZ
      EX=(0.,0.)
      EY=(0.,0.)
      EZ=(0.,0.)
      IF (N.EQ.0) GO TO 25
C
C     LOOP OVER STRUCTURE SEGMENTS
C
      DO 23 I=1,N
      IF(Z(I)*SIDE.LT.0.)GO TO 23
      OMEGA=CKX*CAB(I)+CKY*SAB(I)-CKZ*SALP(I)
      EL=.5*SI(I)
      XKK=XKS(I)
      IF(ABS(EL*XK).LT..05)THEN
         QI=OMEGA*OMEGA*AIX(I)+(0.,2.)*XKK*OMEGA*BIX(I)+XKK*XKK*CIX(I)
         QI=SI(I)*AIX(I)-EL*EL*EL*QI/3.
      ELSE
         SILL=OMEGA*EL
         TOP=(XKK+OMEGA)*EL
         BOT=(XKK-OMEGA)*EL
         IF (ABS(SILL).GT.1.E-3)THEN
            A=2.*SIN(SILL)/SILL
         ELSE
            A=2.-SILL*SILL/3.
         END IF
         IF (ABS(TOP).GT.1.E-3)THEN
            TOP=SIN(TOP)/TOP
         ELSE
            TOP=1.-TOP*TOP/6.
         END IF
         IF (ABS(BOT).GT.1.E-3)THEN
            BOT=SIN(BOT)/BOT
         ELSE
            BOT=1.-BOT*BOT/6.
         END IF
         QI=EL*(A*AIX(I)-FJ*(BOT-TOP)*BIX(I)+(BOT+TOP-A)*CIX(I))
      END IF
      CALL REFPT1(DX,DY,DZ,X(I),Y(I),Z(I),XSP,YSP,ZSP)
      ARG=X(I)*CKX+Y(I)*CKY-(Z(I)-2.*ZSP)*CKZ
      EXA=EXP(-FJ*ARG)*QI
      CEX=EXA*CAB(I)
      CEY=EXA*SAB(I)
      CEZ=EXA*SALP(I)
      CALL ZYSURF(DZ,XSP,YSP,SIDE,IPERFG,YSTE,ZSTM)
      CALL REFCOF(DZ,VNORX,VNORY,ETA,IPERFG,YSTE,ZSTM,CEX,CEY,CEZ,RX,RY,
     &RZ)
C
C     SUMMATION FOR FAR FIELD INTEGRAL
C
      EX=EX+RX
      EY=EY+RY
      EZ=EZ+RZ
23    CONTINUE
25    IF (M.EQ.0)RETURN
C
C     CONTRIBUTION FROM SURFACE PATCHES
C
      IC=N-3
      IP=LD+1
      DO 28 I=1,M
      IC=IC+3
      IP=IP-1
      IF(Z(IP)*SIDE.LT.0.)GO TO 28
      CURX=CUR(IC+1)
      CURY=CUR(IC+2)
      CURZ=CUR(IC+3)
      CALL REFPT1(DX,DY,DZ,X(IP),Y(IP),Z(IP),XSP,YSP,ZSP)
      EXA=EXP(-FJ*(CKX*X(IP)+CKY*Y(IP)-CKZ*(Z(IP)-2.*ZSP)))*S(IP)
      CEX=CURX*EXA
      CEY=CURY*EXA
      CEZ=CURZ*EXA
      CALL ZYSURF(DZ,XSP,YSP,SIDE,IPERFG,YSTE,ZSTM)
      CALL REFCOF(DZ,VNORX,VNORY,ETA,IPERFG,YSTE,ZSTM,CEX,CEY,CEZ,RX,RY,
     &RZ)
      EX=EX+RX
      EY=EY+RY
      EZ=EZ+RZ
28    CONTINUE
      RETURN
      END
      SUBROUTINE ARCNEC (ITG,NS,RADA,ANG1,ANG2,RAD)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     ARCNEC generates segment geometry data for an arc of NS segments.
C     Subroutine ARC renamed to avoid conflict with QUICKWIN
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      DIMENSION X2(MAXSEG), Y2(MAXSEG), Z2(MAXSEG)
      EQUIVALENCE (X2,SI), (Y2,ALP), (Z2,BET)
      DATA TA/.01745329252D0/
      IST=N+1
      N=N+NS
      NP=N
      MP=M
      IPSYM=0
      IF (NS.LT.1) RETURN
      IF (ABS(ANG2-ANG1).LT.360.00001) GO TO 1
      WRITE(3,3)
      STOP
1     ANG=ANG1*TA
      DANG=(ANG2-ANG1)*TA/NS
      XS1=RADA*COS(ANG)
      ZS1=RADA*SIN(ANG)
      DO 2 I=IST,N
      ANG=ANG+DANG
      XS2=RADA*COS(ANG)
      ZS2=RADA*SIN(ANG)
      X(I)=XS1
      Y(I)=0.
      Z(I)=ZS1
      X2(I)=XS2
      Y2(I)=0.
      Z2(I)=ZS2
      XS1=XS2
      ZS1=ZS2
      BI(I)=RAD
2     ITAG(I)=ITG
      RETURN
C
3     FORMAT (' ARCNEC: ERROR - ARC ANGLE EXCEEDS 360. DEGREES')
      END
      FUNCTION ATGN2 (X,Y)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     ATGN2 is arctangent function modified to return 0. when X=Y=0.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      IF (X) 3,1,3
1     IF (Y) 3,2,3
2     ATGN2=0.
      RETURN
3     ATGN2=ATAN2(X,Y)
      RETURN
      END
      FUNCTION CANG (Z)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     CANG returns the phase angle of a complex number in degrees.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 Z
      CANG=ATGN2(DIMAG(Z),DREAL(Z))*57.29577951
      RETURN
      END
      SUBROUTINE CMSS (J1,J2,IM1,IM2,CM,NROW,ITRP)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     CMSS computes matrix elements for surface-surface interactions.
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 CM,H1X,H1Y,H1Z,H2X,H2Y,H2Z,G11,G12,G21,G22
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON/DATAP/H1X,H1Y,H1Z,H2X,H2Y,H2Z,SPATJ,XPATJ,YPATJ,ZPATJ,T1XJ,
     &T1YJ,T1ZJ,T2XJ,T2YJ,T2ZJ,IPGND
      DIMENSION CM(NROW,*)
      DIMENSION T1X(MAXSEG), T1Y(MAXSEG), T1Z(MAXSEG)
      EQUIVALENCE (T1X,SI), (T1Y,ALP), (T1Z,BET)
      LDP=LD+1
      I1=(IM1+1)/2
      I2=(IM2+1)/2
      ICOMP=I1*2-3
      II1=-1
      IF (ICOMP+2.LT.IM1) II1=-2
C     LOOP OVER OBSERVATION PATCHES
      DO 5 I=I1,I2
      IL=LDP-I
      ICOMP=ICOMP+2
      II1=II1+2
      II2=II1+1
      T1XI=T1X(IL)*SALP(IL)
      T1YI=T1Y(IL)*SALP(IL)
      T1ZI=T1Z(IL)*SALP(IL)
      T2XI=T2X(IL)*SALP(IL)
      T2YI=T2Y(IL)*SALP(IL)
      T2ZI=T2Z(IL)*SALP(IL)
      XI=X(IL)
      YI=Y(IL)
      ZI=Z(IL)
      JJ1=-1
C     LOOP OVER SOURCE PATCHES
      DO 5 J=J1,J2
      JL=LDP-J
      JJ1=JJ1+2
      JJ2=JJ1+1
      SPATJ=BI(JL)
      XPATJ=X(JL)
      YPATJ=Y(JL)
      ZPATJ=Z(JL)
      T1XJ=T1X(JL)
      T1YJ=T1Y(JL)
      T1ZJ=T1Z(JL)
      T2XJ=T2X(JL)
      T2YJ=T2Y(JL)
      T2ZJ=T2Z(JL)
      CALL HINTG (XI,YI,ZI)
      G11=-(T2XI*H1X+T2YI*H1Y+T2ZI*H1Z)
      G12=-(T2XI*H2X+T2YI*H2Y+T2ZI*H2Z)
      G21=-(T1XI*H1X+T1YI*H1Y+T1ZI*H1Z)
      G22=-(T1XI*H2X+T1YI*H2Y+T1ZI*H2Z)
      IF (I.NE.J) GO TO 1
      G11=G11-.5
      G22=G22+.5
1     IF (ITRP.NE.0) GO TO 3
C     NORMAL FILL
      IF (ICOMP.LT.IM1) GO TO 2
      CM(II1,JJ1)=G11
      CM(II1,JJ2)=G12
2     IF (ICOMP.GE.IM2) GO TO 5
      CM(II2,JJ1)=G21
      CM(II2,JJ2)=G22
      GO TO 5
C     TRANSPOSED FILL
3     IF (ICOMP.LT.IM1) GO TO 4
      CM(JJ1,II1)=G11
      CM(JJ2,II1)=G12
4     IF (ICOMP.GE.IM2) GO TO 5
      CM(JJ1,II2)=G21
      CM(JJ2,II2)=G22
5     CONTINUE
      RETURN
      END
      SUBROUTINE CMWS (J,I1,I2,CM,NR,CW,NW,ITRP)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     CMWS computes matrix elements for H at surface patches due to
C     current on wire segments.
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 CM,CW,ETK,ETS,ETC,XKSJ,EXK,EYK,EZK,EXS,EYS,EZS,EXC,EYC,
     &EZC,ZPEDS,AX,BX,CX,AIX,BIX,CIX,CUR,XKS,XKU,XKL,ETAU,ETAL,CEPSU,
     &CEPSL,FRATI,ETAL2
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON /SEGJ/ AX(NSJMAX),BX(NSJMAX),CX(NSJMAX),JCO(NSJMAX),JSNO,
     &ISCON(NSCNGF),NSCON,IPCON(NSPNGF),NPCON
      COMMON /DATAJ/ XKSJ,EXK,EYK,EZK,EXS,EYS,EZS,EXC,EYC,EZC,ZPEDS,
     &SLENJ,ARADJ,XJ,YJ,ZJ,DXJ,DYJ,DZJ,IND1,IND2
      COMMON/CRNT/AIX(MAXSEG),BIX(MAXSEG),CIX(MAXSEG),CUR(3*MAXSEG),
     &XKS(MAXSEG)
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      DIMENSION CM(NR,*), CW(NW,*), CAB(MAXSEG), SAB(MAXSEG)
      DIMENSION T1X(MAXSEG), T1Y(MAXSEG), T1Z(MAXSEG)
      EQUIVALENCE (CAB,ALP), (SAB,BET), (T1X,SI), (T1Y,ALP), (T1Z,BET)
      LDP=LD+1
      SLENJ=SI(J)
      ARADJ=BI(J)
      XJ=X(J)
      YJ=Y(J)
      ZJ=Z(J)
      DXJ=CAB(J)
      DYJ=SAB(J)
      DZJ=SALP(J)
      XKSJ=XKS(J)
C
C     OBSERVATION LOOP
C
      IPR=0
      DO 9 I=I1,I2
      IPR=IPR+1
      IPATCH=(I+1)/2
      IK=I-(I/2)*2
      IF (IK.EQ.0.AND.IPR.NE.1) GO TO 1
      JS=LDP-IPATCH
      XI=X(JS)
      YI=Y(JS)
      ZI=Z(JS)
      CALL HSFLD (XI,YI,ZI)
      IF (IK.EQ.0) GO TO 1
      TX=T2X(JS)
      TY=T2Y(JS)
      TZ=T2Z(JS)
      GO TO 2
1     TX=T1X(JS)
      TY=T1Y(JS)
      TZ=T1Z(JS)
2     ETK=-(EXK*TX+EYK*TY+EZK*TZ)*SALP(JS)/XKU
      ETS=-(EXS*TX+EYS*TY+EZS*TZ)*SALP(JS)/XKU
      ETC=-(EXC*TX+EYC*TY+EZC*TZ)*SALP(JS)/XKU
C
C     FILL MATRIX ELEMENTS.  ELEMENT LOCATIONS DETERMINED BY CONNECTION
C     DATA.
C
      IF (ITRP.NE.0) GO TO 4
C     NORMAL FILL
      DO 3 IJ=1,JSNO
      JX=JCO(IJ)
3     CM(IPR,JX)=CM(IPR,JX)+ETK*AX(IJ)+ETS*BX(IJ)+ETC*CX(IJ)
      GO TO 9
4     IF (ITRP.EQ.2) GO TO 6
C     TRANSPOSED FILL
      DO 5 IJ=1,JSNO
      JX=JCO(IJ)
5     CM(JX,IPR)=CM(JX,IPR)+ETK*AX(IJ)+ETS*BX(IJ)+ETC*CX(IJ)
      GO TO 9
C     TRANSPOSED FILL - C(WS) AND D(WS)PRIME (=CW)
6     DO 8 IJ=1,JSNO
      JX=JCO(IJ)
      IF (JX.GT.NR) GO TO 7
      CM(JX,IPR)=CM(JX,IPR)+ETK*AX(IJ)+ETS*BX(IJ)+ETC*CX(IJ)
      GO TO 8
7     JX=JX-NR
      CW(JX,IPR)=CW(JX,IPR)+ETK*AX(IJ)+ETS*BX(IJ)+ETC*CX(IJ)
8     CONTINUE
9     CONTINUE
      RETURN
      END
      SUBROUTINE CONECT (IGND,ICHK)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     CONECT sets up segment connection data in arrays ICON1 and ICON2
C     by searching for segment ends that are in contact.
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 AX,BX,CX
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON /SEGJ/ AX(NSJMAX),BX(NSJMAX),CX(NSJMAX),JCO(NSJMAX),JSNO,
     &ISCON(NSCNGF),NSCON,IPCON(NSPNGF),NPCON
      DIMENSION X2(MAXSEG), Y2(MAXSEG), Z2(MAXSEG)
      EQUIVALENCE (X2,SI), (Y2,ALP), (Z2,BET)
      DATA SMIN/1.D-3/
      NSCON=0
      NPCON=0
      IF (IGND.EQ.0) GO TO 3
      WRITE(3,54)
      IF (IGND.GT.0) WRITE(3,55)
      IF (IPSYM.NE.2) GO TO 1
      NP=2*NP
      MP=2*MP
1     IF (IABS(IPSYM).LE.2) GO TO 2
      NP=N
      MP=M
2     IF (NP.GT.N) STOP
      IF (NP.EQ.N.AND.MP.EQ.M) IPSYM=0
3     IF (N.EQ.0) GO TO 26
      DO 15 I=1,N
      ICONX(I)=0
      XI1=X(I)
      YI1=Y(I)
      ZI1=Z(I)
      XI2=X2(I)
      YI2=Y2(I)
      ZI2=Z2(I)
      SLEN=SQRT((XI2-XI1)**2+(YI2-YI1)**2+(ZI2-ZI1)**2)*SMIN
C
C     DETERMINE CONNECTION DATA FOR END 1 OF SEGMENT.
C
      IF (IGND.LT.1) GO TO 5
      IF (ZI1.GT.-SLEN) GO TO 4
      WRITE(3,56) I
      STOP
4     IF (ZI1.GT.SLEN) GO TO 5
      ICON1(I)=I
      Z(I)=0.
      GO TO 9
5     IC=I
      DO 7 J=2,N
      IC=IC+1
      IF (IC.GT.N) IC=1
      SEP=ABS(XI1-X(IC))+ABS(YI1-Y(IC))+ABS(ZI1-Z(IC))
      IF (SEP.GT.SLEN) GO TO 6
      ICON1(I)=-IC
      GO TO 8
6     SEP=ABS(XI1-X2(IC))+ABS(YI1-Y2(IC))+ABS(ZI1-Z2(IC))
      IF (SEP.GT.SLEN) GO TO 7
      ICON1(I)=IC
      GO TO 8
7     CONTINUE
      IF (I.LT.N2.AND.ICON1(I).GT.30000) GO TO 8
      ICON1(I)=0
C
C     DETERMINE CONNECTION DATA FOR END 2 OF SEGMENT.
C
8     IF (IGND.LT.1) GO TO 12
9     IF (ZI2.GT.-SLEN) GO TO 10
      WRITE(3,56) I
      STOP
10    IF (ZI2.GT.SLEN) GO TO 12
      IF (ICON1(I).NE.I) GO TO 11
      WRITE(3,57) I
      STOP
11    ICON2(I)=I
      Z2(I)=0.
      GO TO 15
12    IC=I
      DO 14 J=2,N
      IC=IC+1
      IF (IC.GT.N) IC=1
      SEP=ABS(XI2-X(IC))+ABS(YI2-Y(IC))+ABS(ZI2-Z(IC))
      IF (SEP.GT.SLEN) GO TO 13
      ICON2(I)=IC
      GO TO 15
13    SEP=ABS(XI2-X2(IC))+ABS(YI2-Y2(IC))+ABS(ZI2-Z2(IC))
      IF (SEP.GT.SLEN) GO TO 14
      ICON2(I)=-IC
      GO TO 15
14    CONTINUE
      IF (I.LT.N2.AND.ICON2(I).GT.30000) GO TO 15
      ICON2(I)=0
15    CONTINUE
      IF (M.EQ.0) GO TO 26
C     FIND WIRE-SURFACE CONNECTIONS FOR NEW PATCHES
      IX=LD+1-M1
      I=M2
16    IF (I.GT.M) GO TO 20
      IX=IX-1
      XS=X(IX)
      YS=Y(IX)
      ZS=Z(IX)
      DO 18 ISEG=1,N
      XI1=X(ISEG)
      YI1=Y(ISEG)
      ZI1=Z(ISEG)
      XI2=X2(ISEG)
      YI2=Y2(ISEG)
      ZI2=Z2(ISEG)
      SLEN=(ABS(XI2-XI1)+ABS(YI2-YI1)+ABS(ZI2-ZI1))*SMIN
C     FOR FIRST END OF SEGMENT
      SEP=ABS(XI1-XS)+ABS(YI1-YS)+ABS(ZI1-ZS)
      IF (SEP.GT.SLEN) GO TO 17
C     CONNECTION - DIVIDE PATCH INTO 4 PATCHES AT PRESENT ARRAY LOC.
      ICON1(ISEG)=30000+I
      IC=0
      CALL SUBPH (I,IC,XI1,YI1,ZI1,XI2,YI2,ZI2,XA,YA,ZA,XS,YS,ZS)
      GO TO 19
17    SEP=ABS(XI2-XS)+ABS(YI2-YS)+ABS(ZI2-ZS)
      IF (SEP.GT.SLEN) GO TO 18
      ICON2(ISEG)=30000+I
      IC=0
      CALL SUBPH (I,IC,XI1,YI1,ZI1,XI2,YI2,ZI2,XA,YA,ZA,XS,YS,ZS)
      GO TO 19
18    CONTINUE
19    I=I+1
      GO TO 16
C     REPEAT SEARCH FOR NEW SEGMENTS CONNECTED TO NGF PATCHES.
20    IF (M1.EQ.0.OR.N2.GT.N) GO TO 26
      IX=LD+1
      I=1
21    IF (I.GT.M1) GO TO 25
      IX=IX-1
      XS=X(IX)
      YS=Y(IX)
      ZS=Z(IX)
      DO 23 ISEG=N2,N
      XI1=X(ISEG)
      YI1=Y(ISEG)
      ZI1=Z(ISEG)
      XI2=X2(ISEG)
      YI2=Y2(ISEG)
      ZI2=Z2(ISEG)
      SLEN=(ABS(XI2-XI1)+ABS(YI2-YI1)+ABS(ZI2-ZI1))*SMIN
      SEP=ABS(XI1-XS)+ABS(YI1-YS)+ABS(ZI1-ZS)
      IF (SEP.GT.SLEN) GO TO 22
      ICON1(ISEG)=30001+M
      IC=1
      NPCON=NPCON+1
      IPCON(NPCON)=I
      CALL SUBPH (I,IC,XI1,YI1,ZI1,XI2,YI2,ZI2,XA,YA,ZA,XS,YS,ZS)
      GO TO 24
22    SEP=ABS(XI2-XS)+ABS(YI2-YS)+ABS(ZI2-ZS)
      IF (SEP.GT.SLEN) GO TO 23
      ICON2(ISEG)=30001+M
      IC=1
      NPCON=NPCON+1
      IPCON(NPCON)=I
      CALL SUBPH (I,IC,XI1,YI1,ZI1,XI2,YI2,ZI2,XA,YA,ZA,XS,YS,ZS)
      GO TO 24
23    CONTINUE
24    I=I+1
      GO TO 21
25    IF (NPCON.LE.NSPNGF) GO TO 26
      WRITE(3,62) NSPNGF
      STOP
26    WRITE(3,58) N,NP,IPSYM
      IF (M.GT.0) WRITE(3,61) M,MP
      ISEG=(N+M)/(NP+MP)
      IF (ISEG.EQ.1) GO TO 30
      IF (IPSYM) 28,27,29
27    STOP
28    WRITE(3,59) ISEG
      GO TO 30
29    IC=ISEG/2
      IF (ISEG.EQ.8) IC=3
      WRITE(3,60) IC
30    IF (N.EQ.0) GO TO 48
      WRITE(3,50)
      ISEG=0
C     ADJUST CONNECTED SEG. ENDS TO EXACTLY COINCIDE.  PRINT JUNCTIONS
C     OF 3 OR MORE SEG.  ALSO FIND OLD SEG. CONNECTING TO NEW SEG.
      DO 44 J=1,N
      IEND=-1
      JEND=-1
      IX=ICON1(J)
      IC=1
      JCO(1)=-J
      XA=X(J)
      YA=Y(J)
      ZA=Z(J)
31    IF (IX.EQ.0) GO TO 43
      IF (IX.EQ.J) GO TO 43
      IF (IX.GT.30000) GO TO 43
      NSFLG=0
32    IF (IX) 33,49,34
33    IX=-IX
      GO TO 35
34    JEND=-JEND
35    IF (IX.EQ.J) GO TO 37
      IF (IX.LT.J) GO TO 43
      IC=IC+1
      IF (IC.GT.NSJMAX) GO TO 49
      JCO(IC)=IX*JEND
      IF (IX.GT.N1) NSFLG=1
      IF (JEND.EQ.1) GO TO 36
      XA=XA+X(IX)
      YA=YA+Y(IX)
      ZA=ZA+Z(IX)
      IX=ICON1(IX)
      GO TO 32
36    XA=XA+X2(IX)
      YA=YA+Y2(IX)
      ZA=ZA+Z2(IX)
      IX=ICON2(IX)
      GO TO 32
37    SEP=IC
      XA=XA/SEP
      YA=YA/SEP
      ZA=ZA/SEP
      DO 39 I=1,IC
      IX=JCO(I)
      IF (IX.GT.0) GO TO 38
      IX=-IX
      X(IX)=XA
      Y(IX)=YA
      Z(IX)=ZA
      GO TO 39
38    X2(IX)=XA
      Y2(IX)=YA
      Z2(IX)=ZA
39    CONTINUE
      IF (N1.EQ.0) GO TO 42
      IF (NSFLG.EQ.0) GO TO 42
      DO 41 I=1,IC
      IX=IABS(JCO(I))
      IF (IX.GT.N1) GO TO 41
      IF (ICONX(IX).NE.0) GO TO 41
      NSCON=NSCON+1
      IF (NSCON.LE.NSCNGF) GO TO 40
      WRITE(3,63) NSCNGF
      STOP
40    ISCON(NSCON)=IX
      ICONX(IX)=NSCON
41    CONTINUE
42    IF (IC.LT.3) GO TO 43
      ISEG=ISEG+1
      WRITE(3,51) ISEG,(JCO(I),I=1,IC)
43    IF (IEND.EQ.1) GO TO 44
      IEND=1
      JEND=1
      IX=ICON2(J)
      IC=1
      JCO(1)=J
      XA=X2(J)
      YA=Y2(J)
      ZA=Z2(J)
      GO TO 31
44    CONTINUE
      IF (ISEG.EQ.0) WRITE(3,52)
      IF (N1.EQ.0.OR.M1.EQ.M) GO TO 48
C     FIND OLD SEGMENTS THAT CONNECT TO NEW PATCHES
      DO 47 J=1,N1
      IX=ICON1(J)
      IF (IX.LT.30000) GO TO 45
      IX=IX-30000
      IF (IX.GT.M1) GO TO 46
45    IX=ICON2(J)
      IF (IX.LT.30000) GO TO 47
      IX=IX-30000
      IF (IX.LT.M2) GO TO 47
46    IF (ICONX(J).NE.0) GO TO 47
      NSCON=NSCON+1
      ISCON(NSCON)=J
      ICONX(J)=NSCON
47    CONTINUE
48    CONTINUE
      IF(ICHK.GE.0)THEN
         CALL SEGCHK(IERROR,IWARN)
         IF(ICHK.EQ.0.AND.IERROR.NE.0)STOP
         IF(ICHK.EQ.1.AND.(IERROR.NE.0.OR.IWARN.NE.0))STOP
      END IF
      RETURN
49    WRITE(3,53) IX
      STOP
C
50    FORMAT (//,9X,'- MULTIPLE WIRE JUNCTIONS -',/,1X,'JUNCTION',4X,
     &'SEGMENTS  (- FOR END 1, + FOR END 2)')
51    FORMAT (1X,I5,5X,20I5,/,(11X,20I5))
52    FORMAT (2X,'NONE')
53    FORMAT (' CONECT: SEGMENT CONNECTION ERROR FOR SEGMENT',I5)
54    FORMAT (/,3X,'GROUND PLANE SPECIFIED.')
55    FORMAT (/,3X,'WHERE WIRE ENDS TOUCH GROUND, CURRENT WILL BE INTERP
     &OLATED TO IMAGE IN GROUND PLANE.',/)
56    FORMAT (' CONECT: ERROR - SEGMENT',I5,' EXTENDS BELOW GROUND')
57    FORMAT (' CONECT: ERROR - SEGMENT',I5,' LIES IN GROUND PLANE')
58    FORMAT (/,3X,'TOTAL SEGMENTS USED=',I5,5X,'NO. SEG. IN ',
     &'A SYMMETRIC CELL=',I5,5X,'SYMMETRY FLAG=',I3)
59    FORMAT (' STRUCTURE HAS',I4,' FOLD ROTATIONAL SYMMETRY',/)
60    FORMAT (' STRUCTURE HAS',I2,' PLANES OF SYMMETRY',/)
61    FORMAT (3X,'TOTAL PATCHES USED=',I5,6X,'NO. PATCHES IN A SYMMETRIC
     & CELL=',I5)
62    FORMAT (' CONECT: ERROR - NO. NGF PATCHES CONNECTING TO NEW',
     &' SEGMENTS EXCEEDS LIMIT OF',I5)
63    FORMAT (' CONECT: ERROR - NO. NGF SEGMENTS CONNECTING TO NEW',
     &' SEGMENTS EXCEEDS LIMIT OF',I5)
      END
      SUBROUTINE SEGCHK(IERROR,IWARN)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     SEGCHK calls SEGXCT to check for illegally intersecting segments
C     or violations of the thin-wire approximation, and prints error and
C     warning messages.
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      DIMENSION X2(MAXSEG), Y2(MAXSEG), Z2(MAXSEG)
      EQUIVALENCE (X2(1),SI(1)), (Y2(1),ALP(1)), (Z2(1),BET(1))
      IERROR=0
      IWARN=0
      NM=N-1
      DO 1 I=1,NM
      IP=I+1
      DO 1 J=IP,N
      CALL SEGXCT(X(I),Y(I),Z(I),X2(I),Y2(I),Z2(I),X(J),Y(J),Z(J),X2(J),
     &Y2(J),Z2(J),BI(I),BI(J),ICHK,INRAD1,INRAD2)
      IF(ICHK.EQ.1)THEN
         IERROR=1
         WRITE(3,90)I,J
      ELSE IF(ICHK.EQ.2)THEN
         IWARN=1
         WRITE(3,91)I,J
      ELSE IF(ICHK.EQ.3)THEN
         IERROR=1
         WRITE(3,92)I,J
      ELSE IF(ICHK.EQ.4)THEN
         IWARN=1
         WRITE(3,93)I,J
      END IF
      IF(INRAD1.NE.0)THEN
         IWARN=1
         WRITE(3,94)I,J
      END IF
      IF(INRAD2.NE.0)THEN
         IWARN=1
         WRITE(3,94)J,I
      END IF
1     CONTINUE
      RETURN
C
90    FORMAT(/,' SEGCHK: ERROR - SEGMENTS',I4,' AND',I4,' ARE PARALLEL',
     &' AND OVERLAPPING')
91    FORMAT(/,' SEGCHK: WARNING - SEGMENTS',I4,' AND',I4,' ARE',
     &' PARALLEL AND SEPARATED BY LESS THAN THE SUM OF THEIR RADII')
92    FORMAT(/,' SEGCHK: ERROR - SEGMENTS',I4,' AND',I4,' INTERSECT',
     &' AT A MIDPOINT')
93    FORMAT(/,' SEGCHK: WARNING - SEGMENTS',I4,' AND',I4,' CROSS AT A',
     &' MIDPOINT WITH SEPARATION LESS THAN THE SUM OF THEIR RADII')
94    FORMAT(/,' SEGCHK: WARNING - THE CENTER OF SEGMENT',I4,' IS',
     &' WITHIN THE VOLUME OF SEGMENT',I4)
      END
      SUBROUTINE SEGXCT(S1X,S1Y,S1Z,S2X,S2Y,S2Z,T1X,T1Y,T1Z,T2X,T2Y,T2Z,
     &SRAD,TRAD,ISGCHK,INRAD1,INRAD2)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     SEGXCT tests a pair of segments to find intersections at
C     midpoints, parallel overlapping segments or the center of a
C     segment buried within an adjacent segment.
C
C     INPUT:
C     S1X,S1Y,S1Z,S2X,S2Y,S2Z = first and second end of first segment
C     T1X,T1Y,T1Z,T2X,T2Y,T2Z = first and second end of second segment
C     SRAD = radius of first segment
C     TRAD = radius of second segment
C
C     OUTPUT:
C     ISGCHK = 1 if segments are parallel and overlapping
C              2 if parallel and separated by less than sum of radii
C              3 if intersecting at a midpoint
C              4 if crossing at a midpoint with separation less than
C                the sum of the radii
C     INRAD1 = 1 if the center of segment 1 is within segment 2
C     INRAD2 = 1 if the center of segment 2 is within segment 1
C
      IMPLICIT REAL*8 (A-H,O-Z)
      ISGCHK=0
      INRAD1=0
      INRAD2=0
      RADTST=(SRAD+TRAD)**2
      DSX=S2X-S1X
      DSY=S2Y-S1Y
      DSZ=S2Z-S1Z
      SLEN=SQRT(DSX**2+DSY**2+DSZ**2)
      DSX=DSX/SLEN
      DSY=DSY/SLEN
      DSZ=DSZ/SLEN
      DTX=T2X-T1X
      DTY=T2Y-T1Y
      DTZ=T2Z-T1Z
      TLEN=SQRT(DTX**2+DTY**2+DTZ**2)
      DTX=DTX/TLEN
      DTY=DTY/TLEN
      DTZ=DTZ/TLEN
      CSEP=.25*((S1X+S2X-T1X-T2X)**2+(S1Y+S2Y-T1Y-T2Y)**2+(S1Z+S2Z-T1Z-
     &T2Z)**2)
      IF(CSEP.GT.1.2*(SLEN+TLEN)**2.AND.CSEP.GT.RADTST)RETURN
      IF(SLEN.LT.TLEN)THEN
         TOL=1.E-3*SLEN
      ELSE
         TOL=1.E-3*TLEN
      END IF
      SDTS=DSX*(S1X-T1X)+DSY*(S1Y-T1Y)+DSZ*(S1Z-T1Z)
      TDTS=DTX*(S1X-T1X)+DTY*(S1Y-T1Y)+DTZ*(S1Z-T1Z)
      SDOTT=DSX*DTX+DSY*DTY+DSZ*DTZ
      DEN=1.-SDOTT**2
      IF(DEN.LT.1.E-6)THEN
C
C     PARALLEL SEGMENTS.  TEST FOR OVERLAP
C
         IF(SDOTT.GT.0.)THEN
            IF(SDTS.LT.-SLEN+TOL.OR.SDTS.GT.TLEN-TOL)GO TO 1
         ELSE
            IF(SDTS.GT.-TOL.OR.SDTS.LT.TOL-(SLEN+TLEN))GO TO 1
         END IF
         TXX=TDTS
         TDX=T1X+TXX*DTX
         TDY=T1Y+TXX*DTY
         TDZ=T1Z+TXX*DTZ
         DMINS=(TDX-S1X)**2+(TDY-S1Y)**2+(TDZ-S1Z)**2
         IF(DMINS.LT.TOL**2)THEN
            ISGCHK=1
         ELSE IF(DMINS.LT.RADTST)THEN
            ISGCHK=2
         END IF
      ELSE
C
C     TEST FOR INTERSECTION AT A MIDPOINT
C
         SXX=(SDOTT*TDTS-SDTS)/DEN
         TXX=(TDTS-SDOTT*SDTS)/DEN
         IF(SXX.LT.-TOL.OR.SXX.GT.SLEN+TOL)GO TO 1
         IF(TXX.LT.-TOL.OR.TXX.GT.TLEN+TOL)GO TO 1
         IF((SXX.LT.TOL.OR.SXX.GT.SLEN-TOL).AND.(TXX.LT.TOL.OR.TXX.GT.
     &   TLEN-TOL))GO TO 1
         SDX=S1X+SXX*DSX
         SDY=S1Y+SXX*DSY
         SDZ=S1Z+SXX*DSZ
         TDX=T1X+TXX*DTX
         TDY=T1Y+TXX*DTY
         TDZ=T1Z+TXX*DTZ
         DMINS=(TDX-SDX)**2+(TDY-SDY)**2+(TDZ-SDZ)**2
         IF(DMINS.LT.TOL**2)THEN
            ISGCHK=3
         ELSE IF(DMINS.LT.RADTST)THEN
            ISGCHK=4
         END IF
      END IF
C
C     TEST FOR THE CENTER OF ONE SEGMENT WITHIN THE OTHER SEGMENT.
C
1     SXX=.5*SLEN
      TXX=SXX*SDOTT+TDTS
      IF(TXX.GT.0..AND.TXX.LT.TLEN)THEN
         SDX=S1X+SXX*DSX
         SDY=S1Y+SXX*DSY
         SDZ=S1Z+SXX*DSZ
         TDX=T1X+TXX*DTX
         TDY=T1Y+TXX*DTY
         TDZ=T1Z+TXX*DTZ
         DMINS=(TDX-SDX)**2+(TDY-SDY)**2+(TDZ-SDZ)**2
         IF(DMINS.LT.TRAD**2)INRAD1=1
      END IF
      TXX=.5*TLEN
      SXX=TXX*SDOTT-SDTS
      IF(SXX.GT.0..AND.SXX.LT.SLEN)THEN
         SDX=S1X+SXX*DSX
         SDY=S1Y+SXX*DSY
         SDZ=S1Z+SXX*DSZ
         TDX=T1X+TXX*DTX
         TDY=T1Y+TXX*DTY
         TDZ=T1Z+TXX*DTZ
         DMINS=(TDX-SDX)**2+(TDY-SDY)**2+(TDZ-SDZ)**2
         IF(DMINS.LT.SRAD**2)INRAD2=1
      END IF
      RETURN
      END
      SUBROUTINE COUPLE (ITT1,ITS1,ITT2,ITS2)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     COUPLE computes the maximum coupling between pairs of segments
C     using the Linville algorithm.
C
C     INPUT:
C     ITT1,ITS1 = TAG AND SEGMENT NUMBERS FOR FIRST SEGMENT
C     ITT2,ITS2 = TAG AND SEGMENT NUMBERS FOR SECOND SEGMENT
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 Y11,Y12,Y21,Y22,YY12,CRHO,YLOAD,YIN,ZLOAD,ZIN
C
      WRITE(3,6)
      ISCY1=ISEGNO(ITT1,ITS1)
      ISCY2=ISEGNO(ITT2,ITS2)
      CALL YSCMAT(ISCY1,ISCY2,Y11,Y12,Y21,Y22)
      YY12=Y12*Y21
      C=ABS(YY12)/(2.*DREAL(Y11)*DREAL(Y22)-DREAL(YY12))
      IF(C.LT.0..OR.C.GT.1.)THEN
         WRITE(3,8) C,ITT1,ITS1,ISCY1,ITT2,ITS2,ISCY2
         RETURN
      END IF
      IF(C.LT.0.01)THEN
         GMAX=.5*(C+.25*C*C*C)
      ELSE
         GMAX=(1.-SQRT(1.-C*C))/C
      END IF
      CRHO=GMAX*DCONJG(YY12)/ABS(YY12)
      YLOAD=((1.-CRHO)/(1.+CRHO)+1.)*DREAL(Y22)-Y22
      YIN=Y11-YY12/(YLOAD+Y22)
      ZLOAD=1./YLOAD
      ZIN=1./YIN
      DBCOUP=DB10(GMAX)
      WRITE(3,7) ITT1,ITS1,ISCY1,ITT2,ITS2,ISCY2,DBCOUP,ZLOAD,ZIN
      RETURN
C
6     FORMAT (///,36X,'- - - ISOLATION DATA - - -',//,6X,'- - COUPLING B
     &ETWEEN - -',8X,'MAXIMUM',15X,'- - - FOR MAXIMUM COUPLING - - -'
     &,/,12X,'SEG.',14X,'SEG.',3X,'COUPLING',4X,'LOAD IMPEDANCE (2ND SEG
     &.)',7X,'INPUT IMPEDANCE',/,2X,'TAG/SEG.',3X,'NO.',4X,'TAG/SEG.',
     &3X,'NO.',6X,'(DB)',8X,'REAL',9X,'IMAG.',9X,'REAL',9X,'IMAG.')
7     FORMAT(2(1X,I4,1X,I4,1X,I5,2X),F9.3,2X,2(2X,1PE12.5,1X,E12.5),
     &///)
8     FORMAT (' COUPLE: ERROR - COUPLING=',1PE12.5,'; MUST BE BETWEEN',
     &' 0 AND 1.  SEGMENTS:',2(1X,I4,1X,I4,1X,I5,1X))
      END
      SUBROUTINE YSCMAT (ISEGY1,ISEGY2,Y11,Y12,Y21,Y22)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     YSCMAT COMPUTES THE SHORT-CIRCUIT ADMITTANCE PARAMETERS FOR THE
C     TWO-PORT NETWORK REPRESENTED BY THE STRUCTURE MODEL EXCITED AT
C     SEGMENTS ISEGY1 AND ISEGY2.
C
C     DISCRIPTION:
C     THE ADMITTANCE PARAMETERS Y11 AND Y12 ARE COMPUTED BY EXCITING
C     SEGMENT ISEGY1 WITH ONE VOLT WHILE SEGMENT ISEGY2 IS SHORT
C     CIRCUITED.  Y11 IS THEN THE CURRENT IN THE VOLTAGE SOURCE AND
C     Y12 IS THE CURRENT IN SEGMENT ISEGY2.  Y22 IS LIKEWISE DETERMINED
C     BY EXCITING SEGMENT ISEGY2 WITH ONE VOLT WITH SEGMENT ISEGY1 SHORT
C     CIRCUITED.  A SEGMENT WITHOUT A NETWORK CONNECTION IS SHORT
C     CIRCUITED BY DEFAULT, WHILE A NETWORK PORT IS SHORTED BY ADDING A
C     VOLTAGE SOURCE WITH ZERO VOLTS.
C
C     INPUT:
C     ISEGY1 = SEGMENT NUMBER FOR PORT ONE
C     ISEGY2 = SEGMENT NUMBER FOR PORT TWO
C
C     OUTPUT:
C     Y11 = INPUT ADMITTANCE AT SEGMENT ISEGY1 WITH SEGMENT ISEGY2 SHORT
C           CIRCUITED (MHOS)
C     Y12 = TRANSFER ADMITTANCE FOR THE CURRENT IN SEGMENT ISEGY2 WITH
C           SEGMENT ISEGY1 EXCITED
C     Y21 = TRANSFER ADMITTANCE FOR THE CURRENT IN SEGMENT ISEGY1 WITH
C           SEGMENT ISEGY2 EXCITED
C     Y22 = INPUT ADMITTANCE AT SEGMENT ISEGY2 WITH SEGMENT ISEGY1 SHORT
C           CIRCUITED (MHOS)
C
      INCLUDE 'NECPAR.INC'
      PARAMETER (IRESRV=MAXMAT**2)
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 Y11,Y12,Y21,Y22,CM,TLYT1,TLYT2,YN11,YN12,YN22,SVOLTS,
     &CMN,RHNX,RHNT,VLTNET,ZPED,EXCIT,VLT
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON /CMB/CM(IRESRV),IP(2*MAXSEG),IB11,IC11,ID11,NEQMAT,NEQ,NEQ2
      COMMON/NETDEF/TLYT1(NETMX),TLYT2(NETMX),YN11(NETMX),YN12(NETMX),
     &YN22(NETMX),SVOLTS(NSOMAX),TLZCH(NETMX),TLLEN(NETMX),NVSOR,
     &NVSORA(NSOMAX),ISEG1(NETMX),ISEG2(NETMX),NONET,NETYP(NETMX)
      COMMON/NETWRK/CMN(NETMX,NETMX),RHNX(NETMX),RHNT(NETMX),
     &VLTNET(NETMX),IPNT(NETMX),NTEQ,NTEQA(NETMX),NTVEQ,NTVEQA(NETMX)
      COMMON/NETCX/ZPED,PIN,PNLS,IZSAVE,NPEQ,NTSOL,NPRINT
      DIMENSION EXCIT(3*MAXSEG)
C
      NETMXP=NETMX+1
      VLT=(1.,0.)
      IF(NONET.EQ.0)GO TO 1
C
C     SOLUTION WHEN NETWORKS ARE PRESENT
C
      NPRSAV=NPRINT
      NPRINT=0
      NTSOL=0
C
C     EXCITE SEGMENT ISEGY1 WITH ONE VOLT; SHORT CURCUIT SEGMENT ISEGY2
C
      NVSOR=2
      NVSORA(1)=ISEGY1
      NVSORA(2)=ISEGY2
      SVOLTS(1)=VLT
      SVOLTS(2)=(0.,0.)
      CALL SORINI(EXCIT)
      CALL SORVT1(ISEGY1,VLT,EXCIT)
      CALL NETSOL(EXCIT,NTSOL)
      Y11=EXCIT(ISEGY1)
      Y12=EXCIT(ISEGY2)
      IF(NTVEQ.GT.0)THEN
C
C     ADD NETWORK CURRENTS TO SEGMENT CURRENT
C
           DO 2 I=1,NTVEQ
           IF(NTVEQA(I).EQ.ISEGY1)Y11=Y11+RHNT(NETMXP-I)
           IF(NTVEQA(I).EQ.ISEGY2)Y12=Y12+RHNT(NETMXP-I)
2          CONTINUE
      END IF
C
C     EXCITE SEGMENT ISEGY2 WITH ONE VOLT; SHORT CIRCUIT SEGMENT ISEGY2
C
      SVOLTS(1)=(0.,0.)
      SVOLTS(2)=VLT
      CALL SORINI(EXCIT)
      CALL SORVT1(ISEGY2,VLT,EXCIT)
      CALL NETSOL(EXCIT,NTSOL)
      Y21=EXCIT(ISEGY1)
      Y22=EXCIT(ISEGY2)
      IF(NTVEQ.GT.0)THEN
C
C     ADD NETWORK CURRENTS TO SEGMENT CURRENT
C
           DO 3 I=1,NTVEQ
           IF(NTVEQA(I).EQ.ISEGY1)Y21=Y21+RHNT(NETMXP-I)
           IF(NTVEQA(I).EQ.ISEGY2)Y22=Y22+RHNT(NETMXP-I)
3          CONTINUE
      END IF
      NPRINT=NPRSAV
      RETURN
C
C     SOLVE FOR CURRENTS WHEN NO NETWORKS ARE PRESENT
C
1     NEQZ2=NEQ2
      IF(NEQZ2.EQ.0)NEQZ2=1
C
C     EXCITE SEGMENT ISEGY1 WITH SEGMENT ISEGY2 SHORT CIRCUITED.
C
      CALL SORINI(EXCIT)
      CALL SORVT1(ISEGY1,VLT,EXCIT)
      CALL SOLGF (CM,CM(IB11),CM(IC11),CM(ID11),EXCIT,IP,NP,N1,N,MP,M1,
     &M,NEQ,NEQ2,NEQZ2)
      CALL CABC (EXCIT)
      Y11=EXCIT(ISEGY1)
      Y12=EXCIT(ISEGY2)
C
C     EXCITE SEGMENT ISEGY2 WITH SEGMENT ISEGY1 SHORT CIRCUITED.
C
      CALL SORINI(EXCIT)
      CALL SORVT1(ISEGY2,VLT,EXCIT)
      CALL SOLGF (CM,CM(IB11),CM(IC11),CM(ID11),EXCIT,IP,NP,N1,N,MP,M1,
     &M,NEQ,NEQ2,NEQZ2)
      CALL CABC (EXCIT)
      Y21=EXCIT(ISEGY1)
      Y22=EXCIT(ISEGY2)
      RETURN
      END
      SUBROUTINE DATAGN
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     DATAGN is the main routine for input of geometry data.
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER GM*2,IFX(2)*1,IFY(2)*1,IFZ(2)*2,IPT(4)*1,FILNAM*80
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      DIMENSION X2(MAXSEG),Y2(MAXSEG),Z2(MAXSEG),T1X(MAXSEG),
     &   T1Y(MAXSEG),T1Z(MAXSEG),CAB(MAXSEG),SAB(MAXSEG)
      EQUIVALENCE (T1X,SI),(T1Y,ALP),(T1Z,BET),(X2,SI),(Y2,ALP),
     &(Z2,BET),(CAB,ALP),(SAB,BET)
      DATA IFX/' ','X'/,IFY/' ','Y'/,IFZ/' ','Z'/
      DATA TA/0.01745329252D0/,TD/57.29577951D0/,IPT/'P','R','T','Q'/
C
      IPSYM=0
      NWIRE=0
      N=0
      NP=0
      M=0
      MP=0
      N1=0
      N2=1
      M1=0
      M2=1
      ISCT=0
      IPHD=0
C
C     READ GEOMETRY DATA COMMAND AND BRANCH TO SECTION FOR OPERATION
C     REQUESTED
C
1     CALL READGM(2,GM,ITG,NS,XW1,YW1,ZW1,XW2,YW2,ZW2,RAD,F8,F9,F10,
     &FILNAM)
C***
      IF (N+M.GT.LD) GO TO 37
      IF (GM.EQ.'GF') GO TO 27
      IF (IPHD.EQ.1) GO TO 2
      WRITE(3,40)
      WRITE(3,41)
      IPHD=1
2     IF (GM.EQ.'SC') GO TO 10
      ISCT=0
      IF (GM.EQ.'GW') GO TO 3
      IF (GM.EQ.'CW') GO TO 4
      IF (GM.EQ.'GX') GO TO 18
      IF (GM.EQ.'GR') GO TO 19
      IF (GM.EQ.'GS') GO TO 21
      IF (GM.EQ.'SP') GO TO 9
      IF (GM.EQ.'SM') GO TO 13
      IF (GM.EQ.'GE') GO TO 29
      IF (GM.EQ.'GM') GO TO 26
      IF (GM.EQ.'GA') GO TO 8
      IF (GM.EQ.'GH') GO TO 123
      WRITE(3,48)
      WRITE(3,49) GM,ITG,NS,XW1,YW1,ZW1,XW2,YW2,ZW2,RAD
      STOP
C
C     GENERATE SEGMENT DATA FOR STRAIGHT WIRE.
C
3     NWIRE=NWIRE+1
      I1=N+1
      I2=N+NS
      WRITE(3,43) NWIRE,XW1,YW1,ZW1,XW2,YW2,ZW2,RAD,NS,I1,I2,ITG
      IF (RAD.NE.0.)THEN
         XS1=1.
         YS1=1.
      ELSE
         CALL READGM(2,GM,IX,IY,XS1,YS1,ZS1,SEGL1,SEGL2,DUMMY,DUMMY,
     &   DUMMY,DUMMY,DUMMY,FILNAM)
         IF (GM.NE.'GC')THEN
            WRITE(3,48)
            STOP
         END IF
         IF(IX.EQ.0)THEN
            WRITE(3,61) XS1,YS1,ZS1
         ELSE IF(IX.EQ.1)THEN
            CALL RDLSOL(NS,XW1,YW1,ZW1,XW2,YW2,ZW2,SEGL1,SEGL2,XS1)
            WRITE(3,62) SEGL1,XS1,YS1,ZS1
         ELSE IF(IX.EQ.2)THEN
            NS=0
            CALL RDLSOL(NS,XW1,YW1,ZW1,XW2,YW2,ZW2,SEGL1,SEGL2,XS1)
            WRITE(3,67) SEGL1,SEGL2,YS1,ZS1,NS,XS1
         END IF
         IF (YS1.EQ.0.OR.ZS1.EQ.0)THEN
            WRITE(3,48)
            STOP
         END IF
         RAD=YS1
         YS1=(ZS1/YS1)**(1./(NS-1.))
      END IF
      CALL WIRE (XW1,YW1,ZW1,XW2,YW2,ZW2,RAD,XS1,YS1,NS,ITG)
      GO TO 1
C
C     GENERATE SEGMENT DATA FOR WIRE ARC
C
8     NWIRE=NWIRE+1
      I1=N+1
      I2=N+NS
      WRITE(3,38) NWIRE,XW1,YW1,ZW1,XW2,NS,I1,I2,ITG
      CALL ARCNEC (ITG,NS,XW1,YW1,ZW1,XW2)
      GO TO 1
C
C     GENERATE SEGMENT DATA FOR A CATENARY WIRE
C
4     NWIRE=NWIRE+1
      I1=N+1
      I2=N+NS
      ICAT=F8+.5
      WRITE(3,63) ICAT,F9,F10
      CALL CATNRY(XW1,YW1,ZW1,XW2,YW2,ZW2,RAD,ICAT,F9,F10,NS,ITG)
      WRITE(3,43) NWIRE,XW1,YW1,ZW1,XW2,YW2,ZW2,RAD,NS,I1,I2,ITG
      GO TO 1
C***
C
C     GENERATE HELIX
C
123   NWIRE=NWIRE+1
      I1=N+1
      I2=N+NS
      IHELIX=RAD+.5
      IF(XW2.EQ.0.)XW2=ZW1
      IF(ZW2.EQ.0.)ZW2=YW2
      IF(IHELIX.EQ.0)WRITE(3,64)NWIRE,NS,I1,I2,ITG
      IF(IHELIX.NE.0)WRITE(3,65)NWIRE,NS,I1,I2,ITG
      WRITE(3,66)XW1,YW1,ZW1,XW2,YW2,ZW2
      CALL HELIX(IHELIX,XW1,YW1,ZW1,XW2,YW2,ZW2,NS,ITG)
      GO TO 1
C
C     GENERATE SINGLE NEW PATCH
C
9     I1=M+1
      NS=NS+1
      IF (ITG.NE.0) GO TO 17
      WRITE(3,51) I1,IPT(NS),XW1,YW1,ZW1,XW2,YW2,ZW2
      IF (NS.EQ.2.OR.NS.EQ.4) ISCT=1
      IF (NS.GT.1) GO TO 14
      XW2=XW2*TA
      YW2=YW2*TA
      GO TO 16
10    IF (ISCT.EQ.0) GO TO 17
      I1=M+1
      NS=NS+1
      IF (ITG.NE.0) GO TO 17
      IF (NS.NE.2.AND.NS.NE.4) GO TO 17
      XS1=X4
      YS1=Y4
      ZS1=Z4
      XS2=X3
      YS2=Y3
      ZS2=Z3
      X3=XW1
      Y3=YW1
      Z3=ZW1
      IF (NS.NE.4) GO TO 11
      X4=XW2
      Y4=YW2
      Z4=ZW2
11    XW1=XS1
      YW1=YS1
      ZW1=ZS1
      XW2=XS2
      YW2=YS2
      ZW2=ZS2
      IF (NS.EQ.4) GO TO 12
      X4=XW1+X3-XW2
      Y4=YW1+Y3-YW2
      Z4=ZW1+Z3-ZW2
12    WRITE(3,51) I1,IPT(NS),XW1,YW1,ZW1,XW2,YW2,ZW2
      WRITE(3,39) X3,Y3,Z3,X4,Y4,Z4
      GO TO 16
C
C     GENERATE MULTIPLE-PATCH SURFACE
C
13    I1=M+1
      WRITE(3,59) I1,IPT(2),XW1,YW1,ZW1,XW2,YW2,ZW2,ITG,NS
      IF (ITG.LT.1.OR.NS.LT.1) GO TO 17
14    CALL READGM(2,GM,IX,IY,X3,Y3,Z3,X4,Y4,Z4,DUMMY,DUMMY,DUMMY,DUMMY,
     &FILNAM)
C
      IF (NS.NE.2.AND.ITG.LT.1) GO TO 15
      X4=XW1+X3-XW2
      Y4=YW1+Y3-YW2
      Z4=ZW1+Z3-ZW2
15    WRITE(3,39) X3,Y3,Z3,X4,Y4,Z4
      IF (GM.NE.'SC') GO TO 17
16    CALL PATCH (ITG,NS,XW1,YW1,ZW1,XW2,YW2,ZW2,X3,Y3,Z3,X4,Y4,Z4)
      GO TO 1
17    WRITE(3,60)
      STOP
C
C     REFLECT STRUCTURE ALONG X,Y, OR Z AXES OR ROTATE TO FORM CYLINDER.
C
18    IY=NS/10
      IZ=NS-IY*10
      IX=IY/10
      IY=IY-IX*10
      IF (IX.NE.0) IX=1
      IF (IY.NE.0) IY=1
      IF (IZ.NE.0) IZ=1
      WRITE(3,44) IFX(IX+1),IFY(IY+1),IFZ(IZ+1),ITG
      GO TO 20
19    WRITE(3,45) NS,ITG
      IX=-1
20    CALL REFLC (IX,IY,IZ,ITG,NS)
      GO TO 1
C
C     SCALE STRUCTURE DIMENSIONS BY FACTOR XW1.
C
21    IF (N.LT.N2) GO TO 23
      DO 22 I=N2,N
      X(I)=X(I)*XW1
      Y(I)=Y(I)*XW1
      Z(I)=Z(I)*XW1
      X2(I)=X2(I)*XW1
      Y2(I)=Y2(I)*XW1
      Z2(I)=Z2(I)*XW1
22    BI(I)=BI(I)*XW1
23    IF (M.LT.M2) GO TO 25
      YW1=XW1*XW1
      IX=LD+1-M
      IY=LD-M1
      DO 24 I=IX,IY
      X(I)=X(I)*XW1
      Y(I)=Y(I)*XW1
      Z(I)=Z(I)*XW1
24    BI(I)=BI(I)*YW1
25    WRITE(3,46) XW1
      GO TO 1
C
C     MOVE STRUCTURE OR REPRODUCE ORIGINAL STRUCTURE IN NEW POSITIONS.
C
26    ITG1=RAD+.5
      ISG1=F8+.5
      ITG2=F9+.5
      ISG2=F10+.5
      IF(ISG1.EQ.0)ISG1=1
      IF(ITG2.EQ.0.AND.ISG2.EQ.0)ISG2=N
      IF(ISG2.EQ.0)ISG2=1
      WRITE(3,47) ITG,NS,XW1,YW1,ZW1,XW2,YW2,ZW2,ITG1,ISG1,ITG2,ISG2
      XW1=XW1*TA
      YW1=YW1*TA
      ZW1=ZW1*TA
      CALL MOVE (XW1,YW1,ZW1,XW2,YW2,ZW2,NS,ITG,ITG1,ISG1,ITG2,ISG2)
      GO TO 1
C
C     READ NUMERICAL GREEN'S FUNCTION TAPE
C
27    IF (N+M.EQ.0) GO TO 28
      WRITE(3,52)
      STOP
28    CALL GFIL (ITG,FILNAM)
      NPSAV=NP
      MPSAV=MP
      IPSAV=IPSYM
      GO TO 1
C
C     TERMINATE STRUCTURE GEOMETRY INPUT.
C
29    IX=N1+M1
      IF (IX.EQ.0) GO TO 30
      NP=N
      MP=M
      IPSYM=0
30    CALL CONECT (ITG,NS)
      IF (IX.EQ.0) GO TO 31
      NP=NPSAV
      MP=MPSAV
      IPSYM=IPSAV
31    IF (N+M.GT.LD) GO TO 37
      IF (N.EQ.0) GO TO 33
      WRITE(3,53)
      WRITE(3,54)
      DO 32 I=1,N
      XW1=X2(I)-X(I)
      YW1=Y2(I)-Y(I)
      ZW1=Z2(I)-Z(I)
      X(I)=(X(I)+X2(I))*.5
      Y(I)=(Y(I)+Y2(I))*.5
      Z(I)=(Z(I)+Z2(I))*.5
      XW2=XW1*XW1+YW1*YW1+ZW1*ZW1
      YW2=SQRT(XW2)
      YW2=(XW2/YW2+YW2)*.5
      SI(I)=YW2
      CAB(I)=XW1/YW2
      SAB(I)=YW1/YW2
      XW2=ZW1/YW2
      IF (XW2.GT.1.) XW2=1.
      IF (XW2.LT.-1.) XW2=-1.
      SALP(I)=XW2
      XW2=ASIN(XW2)*TD
      YW2=ATGN2(YW1,XW1)*TD
      WRITE(3,55) I,X(I),Y(I),Z(I),SI(I),XW2,YW2,BI(I),ICON1(I),I,
     &ICON2(I),ITAG(I)
      IF (SI(I).GT.1.E-20.AND.BI(I).GT.1.E-20) GO TO 32
      WRITE(3,56)
      STOP
32    CONTINUE
33    IF (M.EQ.0) GO TO 35
      WRITE(3,57)
      J=LD+1
      DO 34 I=1,M
      J=J-1
      XW1=(T1Y(J)*T2Z(J)-T1Z(J)*T2Y(J))*SALP(J)
      YW1=(T1Z(J)*T2X(J)-T1X(J)*T2Z(J))*SALP(J)
      ZW1=(T1X(J)*T2Y(J)-T1Y(J)*T2X(J))*SALP(J)
      WRITE(3,58) I,X(J),Y(J),Z(J),XW1,YW1,ZW1,BI(J),T1X(J),T1Y(J)
     &,T1Z(J),T2X(J),T2Y(J),T2Z(J)
34    CONTINUE
35    RETURN
37    WRITE(3,50)
      STOP
C
38    FORMAT (1X,I5,2X,'ARC RADIUS =',F9.5,2X,'FROM',F8.3,' TO',F8.3,
     &' DEGREES',11X,F11.5,2X,I5,4X,I5,1X,I5,3X,I5)
39    FORMAT (6X,3F11.5,1X,3F11.5)
40    FORMAT (///,33X,'- - - STRUCTURE SPECIFICATION - - -',//,37X,
     &'COORDINATES MUST BE INPUT IN',/,37X,'METERS OR BE SCALED TO METER
     &S',/,37X,'BEFORE STRUCTURE INPUT IS ENDED',//)
41    FORMAT (2X,'WIRE',79X,'NO. OF',4X,'FIRST',2X,'LAST',5X,'TAG',/,2X,
     &'NO.',8X,'X1',9X,'Y1',9X,'Z1',10X,'X2',9X,'Y2',9X,'Z2',6X,'RADIUS'
     &,3X,'SEG.',5X,'SEG.',3X,'SEG.',5X,'NO.')
43    FORMAT (1X,I5,3F11.5,1X,4F11.5,2X,I5,4X,I5,1X,I5,3X,I5)
44    FORMAT (6X,'STRUCTURE REFLECTED ALONG THE AXES',3(1X,A1),
     &'.  TAGS INCREMENTED BY',I5)
45    FORMAT (6X,'STRUCTURE ROTATED ABOUT Z-AXIS',I3,
     &' TIMES.  LABELS INCREMENTED BY',I5)
46    FORMAT (6X,'STRUCTURE SCALED BY FACTOR',F10.5)
47    FORMAT (6X,'THE STRUCTURE HAS BEEN MOVED, GM COMMAND DATA IS -',/,
     &6X,I3,I5,6F10.5,4I5)
48    FORMAT (' DATAGN: STRUCTURE GEOMETRY DATA ERROR')
49    FORMAT (1X,A2,I3,I5,7F10.5)
50    FORMAT (' DATAGN: NUMBER OF WIRE SEGMENTS AND SURFACE PATCHES',
     &' EXCEEDS DIMENSION LIMIT.')
51    FORMAT (1X,I5,A1,F10.5,2F11.5,1X,3F11.5)
52    FORMAT (' DATAGN: ERROR - GF MUST BE FIRST COMMAND IN GEOMETRY',
     &' DATA SECTION')
53    FORMAT (////,33X,'- - - - SEGMENTATION DATA - - - -',//,40X,'COORD
     &INATES IN METERS',//,25X,'I+ AND I- INDICATE THE SEGMENTS BEFORE A
     &ND AFTER I',//)
54    FORMAT (2X,'SEG.',3X,'COORDINATES OF SEG. CENTER',5X,'SEG.',5X,
     &'ORIENTATION ANGLES',4X,'WIRE',4X,'CONNECTION DATA',3X,'TAG',/,2X,
     &'NO.',7X,'X',9X,'Y',9X,'Z',7X,'LENGTH',5X,'ALPHA',5X,'BETA',6X,
     &'RADIUS',4X,'I-',3X,'I',4X,'I+',4X,'NO.')
55    FORMAT (1X,I5,4F10.5,1X,3F10.5,1X,3I5,2X,I5)
56    FORMAT (' DATAGN: SEGMENT DATA ERROR')
57    FORMAT (////,44X,'- - - SURFACE PATCH DATA - - -',//,49X,'COORDINA
     &TES IN METERS',//,1X,'PATCH',5X,'COORD. OF PATCH CENTER',7X,
     &'UNIT NORMAL VECTOR',6X,'PATCH',12X,'COMPONENTS OF UNIT TANGENT VE
     &CTORS',/,2X,'NO.',6X,'X',9X,'Y',9X,'Z',9X,'X',7X,'Y',7X,'Z',7X,
     &'AREA',7X,'X1',6X,'Y1',6X,'Z1',7X,'X2',6X,'Y2',6X,'Z2')
58    FORMAT (1X,I4,3F10.5,1X,3F8.4,F10.5,1X,3F8.4,1X,3F8.4)
59    FORMAT (1X,I5,A1,F10.5,2F11.5,1X,3F11.5,5X,'SURFACE -',I4,' BY',I3
     &,' PATCHES')
60    FORMAT (' DATAGN: PATCH DATA ERROR')
61    FORMAT (9X,'ABOVE WIRE IS TAPERED.  SEG. LENGTH RATIO =',F9.5,/,
     &33X,'RADIUS FROM',F9.5,' TO',F9.5)
62    FORMAT (9X,'ABOVE WIRE IS TAPERED.  INITIAL SEG. LENGTH =',F9.5,
     &'   LENGTH RATIO =',F9.5,/,33X,'RADIUS FROM',F9.5,' TO',F9.5)
63    FORMAT(10X,'THE FOLLOWING WIRE IS A CATENARY,',I5,1P2E12.5)
64    FORMAT(1X,I5,6X,'THIS WIRE IS A LOG-SPIRAL OR HELIX',40X,I5,4X,
     &I5,1X,I5,3X,I5)
65    FORMAT(1X,I5,6X,'THIS WIRE IS AN ARCHIMEDES SPIRAL OR HELIX',32X,
     &I5,4X,I5,1X,I5,3X,I5)
66    FORMAT(10X,'SPIRAL DATA: TURNS=',F10.4,'  LENGTH=',1PE12.4,
     &'  H.RAD=',2E12.4,'  W.RAD=',2E12.4)
67    FORMAT (9X,'ABOVE WIRE IS TAPERED.  REQUESTED INITIAL AND FINAL ',
     &'SEG. LENGTHS =',2F9.5,/,33X,'RADIUS FROM',F9.5,' TO',F9.5,/,
     &33X,'COMPUTED NUMBER OF SEGMENTS = ',I5,'   LENGTH RATIO =',F9.5)
      END
      SUBROUTINE RDLSOL(NSEG,X1,Y1,Z1,X2,Y2,Z2,DEL1,DEL2,RDELX)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     RDLSOL SOLVES FOR THE LENGTH RATIO FOR TAPERED SEGMENT LENGTHS
C
C     INPUT:
C     NSEG = NUMBER OF SEGMENTS (=0 WHEN DEL1 AND DEL2 ARE SPECIFIED)
C     X1,Y1,Z1 = FIRST END OF THE WIRE
C     X2,Y2,Z2 = SECOND END OF THE WIRE
C     DEL1 = LENGTH OF THE FIRST SEGMENT
C     DEL2 = LENGTH OF THE LAST SEGMENT (USED ONLY IF NSEG.LE.0)
C
C     OUTPUT:
C     RDELX = RATIO OF LENGTH OF SEGMENT I+1 TO SEGMENT I
C     NSEG = NUMBER OF SEGMENTS (RETURNED WHEN DEL1 AND DEL2 SPECIFIED)
C
      IMPLICIT REAL*8 (A-H,O-Z)
      ELEN=SQRT((X2-X1)**2+(Y2-Y1)**2+(Z2-Z1)**2)
      IF(NSEG.EQ.1)THEN
         RDELX=1.
         RETURN
      ELSE IF(DEL1.GE.ELEN.OR.DEL1.LE.0.)THEN
         WRITE(3,90)
         STOP
      ELSE IF(NSEG.LT.1)THEN
         IF(DEL2.GE.ELEN.OR.DEL2.LE.0.)THEN
            WRITE(3,92)
            STOP
         ELSE IF(ABS((DEL1-DEL2)/DEL1).LT.1.E-6)THEN
            RDELX=1.
            NSEG=ELEN/DEL1+.5
            RETURN
         ELSE
            RDELX=(ELEN-DEL1)/(ELEN-DEL2)
            NSEG=1.5+LOG(DEL2/DEL1)/LOG(RDELX)
            IF(NSEG.LT.2)NSEG=2
         END IF
      END IF
      DNEWT0=2.*(NSEG*DEL1-ELEN)/(DEL1*NSEG*(NSEG-1.))
      DNEWT1=(4.*ELEN*(2.-NSEG)+DEL1*NSEG*(NSEG-5.))/(3.*DEL1*NSEG*
     &(1.-NSEG))
      RMAX=(ELEN/DEL1)**(1./(NSEG-1.))
      RDEL=1.
      NXSTOP=0
      DO 1 ITR=1,200
      IF(RDEL.GT.RMAX)RDEL=RMAX
      DN=RDEL**NSEG
      IF(ABS(DN-1.).GT.0.1)THEN
         OMR=1.-RDEL
         DNEWT=-OMR*(ELEN*OMR-DEL1*(1.-DN))/(DEL1*(1.-DN-DN*NSEG*OMR/
     &   RDEL))
      ELSE
         DNEWT=DNEWT0+DNEWT1*(RDEL-1.)
      END IF
      RDEL=RDEL-DNEWT
      IF(NXSTOP.EQ.1)GO TO 2
      IF(ABS(DNEWT/RDEL).LT.1.E-5)NXSTOP=1
1     CONTINUE
      WRITE(3,91)
2     RDELX=RDEL
      RETURN
C
90    FORMAT(' RDLSOL: ERROR - ILLEGAL STARTING SEGMENT LENGTH')
91    FORMAT(' RDLSOL: SOLUTION DID NOT CONVERGE')
92    FORMAT(' RDLSOL: ERROR - ILLEGAL FINAL SEGMENT LENGTH')
      END
      FUNCTION DB10 (X)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     FUNCTION DB10 returns dB for magnitude (20 log)
C     Entry DB20 returns dB for mag.**2 (10 log).
C
      IMPLICIT REAL*8 (A-H,O-Z)
      F=10.
      GO TO 1
      ENTRY DB20 (X)
      F=20.
1     IF (X.LT.1.E-20) GO TO 2
      DB10=F*LOG10(X)
      RETURN
2     DB10=-999.99
      DB20=DB10
      RETURN
      END
      SUBROUTINE DAOPEN(IUNIT,FIL,STAT,DIS,LRECB)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     DAOPEN OPENS A FILE FOR DIRECT-ACCESS READS AND WRITES OF COMPLEX
C     NUMBERS.  BLOCKS (RECORDS) OUTPUT BY THE PROGRAM ARE BROKEN INTO
C     SMALLER RECORDS IF REQUIRED BY THE LIMITATION ON RECORD LENGTH
C     IMPOSED BY THE COMPUTER SYSTEM.
C
C     INPUT:  (OTHER THAN OBVIOUS FILE PARAMETERS)
C     LRECB = NUMBER OF COMPLEX NUMBERS IN A BLOCK (RECORD) OUTPUT BY
C             THE PROGRAM
C     MXLENR = MAXIMUM RECORD LENGTH (NUMBER OF REAL NUMBERS) SET BY THE
C              COMPUTER SYSTEM
C     MAXFIL = HIGHEST LOGICAL UNIT NUMBER USED BY THE PROGRAM
C
C     OUTPUT:
C     NRPRX(IUNIT) = NUMBER OF LOGICAL RECORDS PER BLOCK FOR LOGICAL
C                    UNIT NUMBER IUNIT
C     LREC = NUMBER OF COMPLEX NUMBERS IN A LOGICAL RECORD (#< NRPRX)
C     LRECL = NUMBER OF COMPLEX NUMBERS IN LOGICAL RECORD # NRPRX
C
      PARAMETER (MAXFIL=21)
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER FIL*(*),STAT*(*),DIS*(*)
      COMMON/RSTRUC/NRPRX(MAXFIL),LREC(MAXFIL),LRECL(MAXFIL)
      DATA MXLENR/8191/
      MXLENC=MXLENR/4
      NRPRX(IUNIT)=(LRECB-1)/MXLENC+1
      IF(NRPRX(IUNIT).GT.1)THEN
         LREC(IUNIT)=MXLENC
         LRECL(IUNIT)=LRECB-(NRPRX(IUNIT)-1)*LREC(IUNIT)
      ELSE
         LREC(IUNIT)=LRECB
         LRECL(IUNIT)=LRECB
      END IF
C***  Windows:   RECL IN WORDS
      OPEN(UNIT=IUNIT,FILE=FIL,STATUS=STAT,FORM='UNFORMATTED',
     &ACCESS='DIRECT',RECL=4*LREC(IUNIT))
C***  UNIX:  RECL IN BYTES ??? Check your compiler manual.
c      OPEN(UNIT=IUNIT,FILE=FIL,STATUS=STAT,FORM='UNFORMATTED',
c     &ACCESS='DIRECT',RECL=16*LREC(IUNIT))
      RETURN
      END
      SUBROUTINE RECOT(A,IUNIT,I1,I2,IREC,TRACE)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     RECOT WRITES A RECORD TO A DIRECT-ACCESS FILE
C
C     INPUT:
C     A = ARRAY FROM WHICH DATA IS WRITTEN (COMPLEX)
C     IUNIT = LOGICAL UNIT NUMBER
C     I1,I2 = STARTING AND ENDING LOCATIONS IN ARRAY A TO BE WRITTEN
C     IREC = NUMBER OF THE PROGRAM RECORD TO BE WRITTEN TO THE FILE
C     TRACE = MESSAGE PRINTED IN CASE OF AN ERROR - WHO CALLED RECOT?
C
      PARAMETER (MAXFIL=21)
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER TRACE*(*)
      COMPLEX*16 A(*)
      COMMON/RSTRUC/NRPRX(MAXFIL),LREC(MAXFIL),LRECL(MAXFIL)
      IRECS=(IREC-1)*NRPRX(IUNIT)+1
      IRECE=IRECS+NRPRX(IUNIT)-1
      K2=I1-1
      DO 1 IR=IRECS,IRECE
      K1=K2+1
      IF(IR.LT.IRECE)THEN
         K2=K2+LREC(IUNIT)
      ELSE
         K2=K2+LRECL(IUNIT)
      END IF
      IF(K1.GT.I2)RETURN
      IF(K2.GT.I2)K2=I2
      WRITE(UNIT=IUNIT,REC=IR,ERR=2)(A(K),K=K1,K2)
1     CONTINUE
      RETURN
2     WRITE(*,90)IUNIT,IREC,IR,I1,I2,TRACE
90    FORMAT(' RECOT: ERROR WRITING FILE',I4,/,' PROGRAM RECORD NO.',
     &I5,' LOGICAL RECORD NO.',I5,' I1,I2=',2I7,/,' TRACE - ',A)
      CALL ERROR
      STOP
      END
      SUBROUTINE RECIN(A,IUNIT,I1,I2,IREC,TRACE)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     RECIN READS A RECORD FROM A DIRECT-ACCESS FILE
C
C     INPUT:
C     IUNIT = LOGICAL UNIT NUMBER
C     I1,I2 = STARTING AND ENDING LOCATIONS TO BE FILLED IN ARRAY A
C     IREC = NUMBER OF THE RECORD TO BE READ FROM THE FILE
C     TRACE = MESSAGE PRINTED IN CASE OF AN ERROR - WHO CALLED RECIN?
C
C     OUTPUT:
C     A = ARRAY CONTAINING DATA READ
C
      PARAMETER (MAXFIL=21)
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER TRACE*(*)
      COMPLEX*16 A(*)
      COMMON/RSTRUC/NRPRX(MAXFIL),LREC(MAXFIL),LRECL(MAXFIL)
      IRECS=(IREC-1)*NRPRX(IUNIT)+1
      IRECE=IRECS+NRPRX(IUNIT)-1
      K2=I1-1
      DO 1 IR=IRECS,IRECE
      K1=K2+1
      IF(IR.LT.IRECE)THEN
         K2=K2+LREC(IUNIT)
      ELSE
         K2=K2+LRECL(IUNIT)
      END IF
      IF(K1.GT.I2)RETURN
      IF(K2.GT.I2)K2=I2
      READ(UNIT=IUNIT,REC=IR,ERR=2)(A(K),K=K1,K2)
1     CONTINUE
      RETURN
2     WRITE(*,90)IUNIT,IREC,IR,I1,I2,TRACE
90    FORMAT(' RECIN: ERROR READING FILE',I4,/,' PROGRAM RECORD NO.',
     &I5,' I1,I2=',2I7,/,' TRACE - ',A)
      CALL ERROR
      STOP
      END
      SUBROUTINE ERROR
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     ERROR prints the reason for a file I/O error on VAX/VMS only.
C
C      IMPLICIT INTEGER (A-Z)
C      CHARACTER MSG*80
C      CALL ERRSNS(FNUM,RMSSTS,RMSSTV,IUNIT,CONDVAL)
C      CALL SYS$GETMSG(%VAL(RMSSTS),MSGLEN,MSG,,,)
C      CALL STR$UPCASE(MSG,MSG)
C      IND=INDEX(MSG,',')
C      WRITE(*,1)MSG(IND+2:MSGLEN)
C1     FORMAT(//,' ERROR: ERROR IN FILE OPERATION --',//,5X,A,//)
      RETURN
      END
      SUBROUTINE VLTCAP(XJ,YJ,ZJ,DXJ,DYJ,DZJ,SLENJ,ARADJ,VOLTS,E)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     VLTCAP evaluates the E field due to charge on segment end caps.
C     The field due to a ground plane, either perfectly conducting or
C     finitely conducting, is included.  In the Sommerfeld-integral mode
C     the quasistatic image is included but not the remaining component
C     from the interpolation tables.
C
C     INPUT:
C     XJ,YJ,ZJ = COORDINATES OF THE SOURCE SEGMENT
C     DXJ,DYJ,DZJ = UNIT VECTOR IN DIRECTION OF THE SOURCE SEGMENT
C     SLENJ = LENGTH OF SOURCE SEGMENT
C     ARADJ = RADIUS OF SOURCE SEGMENT
C     VOLTS = SOURCE VOLTAGE
C
C     OUTPUT:
C     E = ARRAY FOR R.H.S. OF MATRIX EQUATION UPDATED TO INCLUDE FIELD
C         DUE TO CHARGE ON THE END CAPS OF THE SOURCE SEGMENT.
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 VOLTS,E,XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,FRATI,ETAL2,XK,
     &ETX,FRATX,ZRATI,EX,EY,EZ,TX,TY,TZ,TXS,TYS,TZS,TXC,TYC,TZC
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      DIMENSION E(*),CAB(MAXSEG),SAB(MAXSEG)
      EQUIVALENCE (CAB,ALP),(SAB,BET)
      IF (ZJ.GT.0.)THEN
         XK=XKU
         ETX=ETAU
         FRATX=FRATI
         ZRATI=XKU/XKL
      ELSE
         XK=XKL
         ETX=ETAL
         FRATX=-FRATI
         ZRATI=XKL/XKU
      END IF
C
C     LOOP OVER EVALUATION POINT SEGMENTS
C
      DO 1 I=1,N
      XI=X(I)
      YI=Y(I)
      ZI=Z(I)
C
C     TEST WHETHER FIELD IS TRANSMITTED ACROSS AN INTERFACE WITH GROUND.
C     IF SO THE END CAP FIELD CANNOT BE CALCULATED SO E IS UNALTERED.
C
      IF (KSYMP.GT.1.AND.ZI*ZJ.LT.0.)GO TO 1
      XIJ=XI-XJ
      YIJ=YI-YJ
      ZIJ=ZI-ZJ
C
C     EVALUATE DIRECT FIELD FROM SOURCE TO EVALUATION POINT
C
      CALL EFVCAP(XIJ,YIJ,ZIJ,DXJ,DYJ,DZJ,SLENJ,ARADJ,XK,EX,EY,EZ)
      IF(KSYMP.EQ.1)THEN
         E(I)=E(I)-(EX*CAB(I)+EY*SAB(I)+EZ*SALP(I))*VOLTS
         GO TO 1
      END IF
C
C     FOR GROUND, EVALUATE FIELD OF THE IMAGE OF THE SOURCE SEGMENT
C
      DZJR=-DZJ
      ZIJ=ZI+ZJ
      CALL EFVCAP(XIJ,YIJ,ZIJ,DXJ,DYJ,DZJR,SLENJ,ARADJ,XK,TX,TY,TZ)
      IF(IPERF.EQ.0)THEN
C
C     RCTRAN TRANSFORMS THE IMAGE FIELD FOR REFLECTION COEF. APPROX.
C
         CALL RCTRAN(XI,YI,ZI,XJ,YJ,ZJ,ZRATI,ETX,TX,TY,TZ,TXS,TYS,TZS,
     &   TXC,TYC,TZC)
      ELSE IF(IPERF.EQ.2)THEN
         TX=TX*FRATX
         TY=TY*FRATX
         TZ=TZ*FRATX
      END IF
      E(I)=E(I)-((EX-TX)*CAB(I)+(EY-TY)*SAB(I)+(EZ-TZ)*SALP(I))*VOLTS
1     CONTINUE
      RETURN
      END
      SUBROUTINE EFVCAP(XIJ,YIJ,ZIJ,DXJ,DYJ,DZJ,SLENJ,ARADJ,XK,EX,EY,EZ)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     EFVCAP evaluates the E field due to charged end caps on an
C     arbitrarily oriented segment in an infinite medium.  This routine
C     transforms coordinates and then calls subroutine EFCAP to evaluate
C     the field of the end caps of the segment on the Z axis of a
C     cylindrical coordinate system.
C
C     INPUT:
C     XIJ,YIJ,ZIJ = COMPONENTS OF VECTOR FROM SOURCE TO EVALUATON POINT
C     DXJ,DYJ,DZJ = UNIT VECTOR IN DIRECTION OF THE SOURCE SEGMENT
C     SLENJ = LENGTH OF THE SOURCE SEGMENT
C     ARADJ = RADIUS OF THE SOURCE SEGMENT
C     XK = WAVE NUMBER IN THE MEDIUM CONTAINING THE SOURCE
C
C     OUTPUT:
C     EX,EY,EZ = X,Y,Z COMPONENTS OF E DUE TO CHARGE ON END CAPS FOR
C                UNIT CURRENT OUT OF FIRST END OF SEGMENT AND ONTO
C                SECOND END OF SEGMENT.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 XK,EX,EY,EZ,ECR1,ECR2,ECZ1,ECZ2
      SHALF=.5*SLENJ
      ZP=XIJ*DXJ+YIJ*DYJ+ZIJ*DZJ
      RHOX=XIJ-DXJ*ZP
      RHOY=YIJ-DYJ*ZP
      RHOZ=ZIJ-DZJ*ZP
      RH=SQRT(RHOX*RHOX+RHOY*RHOY+RHOZ*RHOZ)
      IF (RH.GT.1.E-12)THEN
         RHOX=RHOX/RH
         RHOY=RHOY/RH
         RHOZ=RHOZ/RH
      ELSE
         RHOX=0.
         RHOY=0.
         RHOZ=0.
      END IF
C
C     EFCAP EVALUATES THE FIELD DUE TO UNIT CHARGE DENSITY ON END CAP
C
      CALL EFCAP(ARADJ,RH,ZP+SHALF,XK,ECR1,ECZ1)
      CALL EFCAP(ARADJ,RH,ZP-SHALF,XK,ECR2,ECZ2)
      ECZ1=(ECZ2-ECZ1)/SLENJ
C      ECR1=(ECR2-ECR1)/SLENJ
C      EX=ECZ1*DXJ+ECR1*RHOX
C      EY=ECZ1*DYJ+ECR1*RHOY
C      EZ=ECZ1*DZJ+ECR1*RHOZ
      EX=ECZ1*DXJ
      EY=ECZ1*DYJ
      EZ=ECZ1*DZJ
      RETURN
      END
      SUBROUTINE FACGF (A,B,C,D,BX,IP,NP,N1,MP,M1,N1C,N2C)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     FACGF computes and factors D-C(INV(A)B) for the NGF solution.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 A,B,C,D,BX,SUM
      COMMON /MATPAR/ ICASE,NBLOKS,NPBLK,NLAST,NBLSYM,NPSYM,NLSYM,IMAT,I
     &CASX,NBBX,NPBX,NLBX,NBBL,NPBL,NLBL
      DIMENSION A(*),B(N1C,*),C(N1C,*),D(N2C,*),BX(N1C,*),IP(*)
      IF (N2C.EQ.0) RETURN
C
C     CONVERT B FROM BLOCKS OF ROWS ON T15 TO BLOCKS OF COL. ON T12
C
      IF (ICASX.GT.2)CALL REBLK (B,C,N1C,NPBX,N2C,15,12)
C
C     COMPUTE INV(A)B AND WRITE ON TAPE14
C
      NPB=NPBL
      DO 2 IB=1,NBBL
      IF (IB.EQ.NBBL) NPB=NLBL
      IF (ICASX.GT.1)CALL RECIN(BX,12,1,N1C*NPB,IB,' READ #1 IN FACGF')
      CALL SOLVES (A,IP,BX,N1C,NPB,NP,N1,MP,M1,11)
      IF (ICASX.GT.1)CALL RECOT(BX,12,1,N1C*NPB,IB,' WRITE #1 IN FACGF')
2     CONTINUE
C
C     COMPUTE D-C(INV(A)B) AND WRITE ON TAPE14
C
      NPC=NPBL
      DO 8 IC=1,NBBL
      IF (IC.EQ.NBBL) NPC=NLBL
      IF (ICASX.GT.1)THEN
         CALL RECIN(C,13,1,N1C*NPC,IC,' READ C IN FACGF')
         CALL RECIN(D,14,1,N2C*NPC,IC,' READ D IN FACGF')
      END IF
      NPB=NPBL
      NIC=0
      DO 7 IB=1,NBBL
      IF (IB.EQ.NBBL) NPB=NLBL
      IF (ICASX.GT.1) CALL RECIN(B,12,1,N1C*NPB,IB,' READ B IN FACGF')
      DO 6 I=1,NPB
      II=I+NIC
      DO 6 J=1,NPC
      SUM=(0.,0.)
      DO 5 K=1,N1C
5     SUM=SUM+B(K,I)*C(K,J)
6     D(II,J)=D(II,J)-SUM
7     NIC=NIC+NPBL
      IF (ICASX.GT.1) CALL RECOT(D,14,1,N2C*NPBL,IC,' WRITE D IN FACGF')
8     CONTINUE
C
C     FACTOR D-C(INV(A)B)
C
      N1CP=N1C+1
      IF (ICASX.EQ.1)THEN
         CALL FACTR (N2C,D,IP(N1CP),N2C)
      ELSE IF (ICASX.EQ.2 .OR. ICASX.EQ.3)THEN
         NPB=NPBL
         IC=0
         DO 11 IB=1,NBBL
         IF (IB.EQ.NBBL) NPB=NLBL
         II=IC+1
         IC=IC+N2C*NPB
11       CALL RECIN(B,14,II,IC,IB,' READ B(II->IC) IN FACGF')
         CALL FACTR (N2C,B,IP(N1CP),N2C)
         NIC=N2C*N2C
         CLOSE(UNIT=14,STATUS='DELETE',ERR=3)
3        CALL DAOPEN(14,'TAPED.NEC','unknown','DELETE',NIC)
         CALL RECOT(B,14,1,NIC,1,' WRITE B IN FACGF')
      ELSE IF (ICASX.EQ.4)THEN
         CALL FACIOD (B,N2C,1,IP(N1CP),NBBL,NPBL,NLBL,14)
      END IF
      RETURN
      END
      SUBROUTINE FACIOD (A,NROW,NOP,IP,NBLOKS,NPBLK,NLAST,IUNIT)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     FACIOD CONTROLS I/O FOR FACTORING A MATRIX STORED ON DISK.
C     MULTIPLE SUB-MATRICES FROM THE SOLUTION OF A CIRCULANT MATRIX
C     WILL BE FACTORED WHEN THEY ARE STORED SEQUENTIALLY ON THE DISK.
C
C     INPUT
C     A = ARRAY FOR SCRATCH STORAGE OF BLOCKS OF MATRIX READ FROM DISK
C     NROW = NUMBER OF ROWS IN THE MATRIX
C     NOP = NUMBER OF SUB-MATRICES IN A CIRCULANT MATRIX SOLUTION
C     NBLOKS = NUMBER OF BLOCKS INTO WHICH EACH MATRIX IS DIVIDED
C     NPBLK = NUMBER OF COLUMNS IN THE BLOCKS (EXECPT THE LAST BLOCK)
C     NLAST = NUMBER OF COLUMNS IN THE LAST BLOCK
C     IUNIT = LOGICAL UNIT NUMBER FOR THE DISK FILE
C
C     OUTPUT:
C     IP = ARRAY OF PIVOT-ELEMENT INDICES FROM FACTORING
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 A
      DIMENSION A(NROW,*),IP(NROW),IX(2*MAXSEG)
      IT=NPBLK*NROW
      NBM=NBLOKS-1
      I1=1
      I2=IT
      I3=IT+1
      I4=2*IT
      TIME=0.
      DO 3 KK=1,NOP
      KA=(KK-1)*NROW+1
      KREC=(KK-1)*NBLOKS
      DO 2 IXBLK1=1,NBM
      CALL RECIN (A,IUNIT,I1,I2,IXBLK1+KREC,'First read in FACIOD')
      IXBP=IXBLK1+1
      DO 1 IXBLK2=IXBP,NBLOKS
      CALL RECIN (A,IUNIT,I3,I4,IXBLK2+KREC,'Second read in FACIOD')
      CALL SECOND (T1)
      CALL LFACTR (A,NROW,IXBLK1,IXBLK2,IX(KA),NBLOKS,NPBLK,NLAST)
      CALL SECOND (T2)
      TIME=TIME+T2-T1
      IF (IXBLK2.EQ.IXBP) CALL RECOT (A,IUNIT,I1,I2,IXBLK1+KREC,
     &'First write in FACIOD')
      CALL RECOT (A,IUNIT,I3,I4,IXBLK2+KREC,'Second write in FACIOD')
1     CONTINUE
2     CONTINUE
3     CONTINUE
      WRITE(3,4) TIME
      CALL LUNSCR (A,NROW,NOP,IP,IX,NBLOKS,NPBLK,IUNIT)
      RETURN
C
4     FORMAT (/,' CP TIME TAKEN FOR FACTORIZATION = ',1PE12.5,' SEC.')
      END
      SUBROUTINE FACTR (N,A,IP,NDIM)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     FACTR computes the LU decomposition of the matrix in A.  The
C     algorithm is described on pages 411-416 OF A. Ralston--A First
C     Course in Numerical Analysis.  Comments below refer to comments in
C     Ralston's text.    (MATRIX TRANSPOSED.)
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 A,D,ARJ
      DIMENSION A(NDIM,NDIM), IP(NDIM)
      COMMON /SCRATM/ D(2*MAXSEG)
      INTEGER R,RM1,RP1,PJ,PR
C
C     Un-transpose the matrix for Gauss elimination
C
      DO 12 I=2,N
         DO 11 J=1,I-1
            ARJ=A(I,J)
            A(I,J)=A(J,I)
            A(J,I)=ARJ
11       CONTINUE
12    CONTINUE
      IFLG=0
      DO 9 R=1,N
C
C     STEP 1
C
      DO 1 K=1,N
      D(K)=A(K,R)
1     CONTINUE
C
C     STEPS 2 AND 3
C
      RM1=R-1
      IF (RM1.LT.1) GO TO 4
      DO 3 J=1,RM1
      PJ=IP(J)
      ARJ=D(PJ)
      A(J,R)=ARJ
      D(PJ)=D(J)
      JP1=J+1
      DO 2 I=JP1,N
      D(I)=D(I)-A(I,J)*ARJ
2     CONTINUE
3     CONTINUE
4     CONTINUE
C
C     STEP 4
C
      DMAX=DREAL(D(R)*DCONJG(D(R)))
      IP(R)=R
      RP1=R+1
      IF (RP1.GT.N) GO TO 6
      DO 5 I=RP1,N
      ELMAG=DREAL(D(I)*DCONJG(D(I)))
      IF (ELMAG.LT.DMAX) GO TO 5
      DMAX=ELMAG
      IP(R)=I
5     CONTINUE
6     CONTINUE
      IF (DMAX.LT.1.E-10) IFLG=1
      PR=IP(R)
      A(R,R)=D(PR)
      D(PR)=D(R)
C
C     STEP 5
C
      IF (RP1.GT.N) GO TO 8
      ARJ=1./A(R,R)
      DO 7 I=RP1,N
      A(I,R)=D(I)*ARJ
7     CONTINUE
8     CONTINUE
      IF (IFLG.EQ.0) GO TO 9
      WRITE(3,10) R,DMAX
      IFLG=0
9     CONTINUE
      RETURN
C
10    FORMAT (' FACTR: PIVOT(',I3,')=',1PE16.8)
      END
      SUBROUTINE FACTRS (NP,NROW,A,IP,IU1,IU2)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     FACTRS, for a symmetric structure, transforms submatrices to form
C     matrices of the symmetric modes and calls a routine to factor the
C     matrices.  With no symmetry, the routine is called to factor the
C     complete matrix.
C
C     INPUT:
C     NP = no. equations in a symetric section (col. in transposed mat.)
C     NROW = total number of equations (rows of transposed matrix)
C     A = input matrix or storage array when matrix is on disk
C     IU1 = log. unit no. for input matrix and output of factored matrix
C     IU2 = log. unit no. for temporary use in reblocking symmetric mat.
C
C     OUTPUT:
C     A = factored matrix (unless written to disk)
C     IP = array of pivot element indices
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 A
      COMMON /MATPAR/ ICASE,NBLOKS,NPBLK,NLAST,NBLSYM,NPSYM,NLSYM,IMAT,I
     &CASX,NBBX,NPBX,NLBX,NBBL,NPBL,NLBL
      DIMENSION A(*), IP(NROW)
      NOP=NROW/NP
      IF (ICASE.LE.2)THEN
C
C        FACTOR MATRIX IN MEMORY, WITH OR WITHOUT SYMMETRY.
C
         DO 1 KK=1,NOP
         KA=(KK-1)*NP+1
1        CALL FACTR (NP,A(KA),IP(KA),NROW)
         RETURN
      ELSE IF (ICASE.EQ.3)THEN
C
C        FACTOR MATRIX FROM DISK WHEN NO SYMMETRY EXISTS.
C
         CALL FACIOD (A,NROW,NOP,IP,NBLOKS,NPBLK,NLAST,IU1)
         RETURN
      END IF
C
C     REWRITE THE MATRICES BY COLUMNS ON FILE IU2
C
      CALL DAOPEN(IU2,'TAPE12.NEC','unknown','DELETE',NP)
      NOUT=NPBLK*NROW
      IREC2=0
      DO 5 K=1,NOP
      ICOLS=NPBLK
      IR2=K*NP
      IR1=IR2-NP+1
      DO 5 LREC=1,NBLOKS
      IF (NBLOKS.GT.1.OR.K.EQ.1)THEN
         CALL RECIN (A,IU1,1,NOUT,LREC,'Read in DO 5 loop in FACTRS')
         IF (LREC.EQ.NBLOKS) ICOLS=NLAST
      END IF
      IRR1=IR1
      IRR2=IR2
      DO 5 ICOLDX=1,ICOLS
      IREC2=IREC2+1
      CALL RECOT(A,IU2,IRR1,IRR2,IREC2,'Write unit IU2 in FACTRS')
      IRR1=IRR1+NROW
      IRR2=IRR2+NROW
5     CONTINUE
      IREC2=0
      IF (ICASE.EQ.4)THEN
         NOUT=NP*NP
         CLOSE(UNIT=IU1,STATUS='DELETE',ERR=2)
2        CALL DAOPEN(IU1,'TAPE11.DAT','unknown','DELETE',NOUT)
         DO 7 KK=1,NOP
         IR1=1-NP
         IR2=0
         DO 6 I=1,NP
         IR1=IR1+NP
         IR2=IR2+NP
         IREC2=IREC2+1
6        CALL RECIN(A,IU2,IR1,IR2,IREC2,
     &   'Read submatrix for ICASE=4 in FACTRS')
         KA=(KK-1)*NP+1
         CALL FACTR (NP,A,IP(KA),NP)
         CALL RECOT(A,IU1,1,NOUT,KK,
     &   'Writing factored submatrices from FACTRS')
7        CONTINUE
      ELSE
         NOUT=NPSYM*NP
         CLOSE(UNIT=IU1,STATUS='DELETE',ERR=3)
3        CALL DAOPEN(IU1,'TAPE11.DAT','unknown','DELETE',NOUT)
         DO 10 KK=1,NOP
         KKR=(KK-1)*NBLSYM
         J2=NPSYM
         DO 10 LREC=1,NBLSYM
         IF (LREC.EQ.NBLSYM) J2=NLSYM
         IR1=1-NP
         IR2=0
         DO 9 J=1,J2
         IR1=IR1+NP
         IR2=IR2+NP
         IREC2=IREC2+1
9        CALL RECIN(A,IU2,IR1,IR2,IREC2,
     &   'Read submatrix block for ICASE=5 in FACTRS')
10       CALL RECOT (A,IU1,1,NOUT,LREC+KKR,
     &   'Writing blocks of submatrices from FACTRS')
         CALL FACIOD (A,NP,NOP,IP,NBLSYM,NPSYM,NLSYM,IU1)
      END IF
      CLOSE(UNIT=IU2,STATUS='DELETE',ERR=4)
4     RETURN
      END
      COMPLEX*16 FUNCTION FBARS(ZX)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     FBARS evaluates FBARS(Z)=1.-SQRT(PI)*Z*CEXP(Z*Z)*ERFC(Z)
C     where ERFC=complementary error function.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 Z,ZX,ZS,SUM,POW,TERM
      DATA TOSP/1.128379167D0/,ACCS/1.D-12/,SP/1.772453851D0/
      Z=ZX
      IF (ABS(Z).GT.3.) GO TO 3
C
C     SERIES EXPANSION
C
      ZS=Z*Z
      SUM=Z
      POW=Z
      DO 1 I=1,100
      POW=-POW*ZS/DFLOAT(I)
      TERM=POW/(2.*I+1.)
      SUM=SUM+TERM
      TMS=DREAL(TERM*DCONJG(TERM))
      SMS=DREAL(SUM*DCONJG(SUM))
      IF (TMS.LT.SMS*ACCS) GO TO 2
1     CONTINUE
2     FBARS=1.-(1.-SUM*TOSP)*Z*EXP(ZS)*SP
      RETURN
C
C     ASYMPTOTIC EXPANSION
C
3     IF (DREAL(Z).GE.0.) GO TO 4
      MINUS=1
      Z=-Z
      GO TO 5
4     MINUS=0
5     ZS=.5/(Z*Z)
      SUM=(0.,0.)
      TERM=(1.,0.)
      DO 6 I=1,6
      TERM=-TERM*(2.*I-1.)*ZS
6     SUM=SUM+TERM
      IF (MINUS.EQ.1) SUM=SUM-2.*SP*Z*EXP(Z*Z)
      FBARS=-SUM
      RETURN
      END
      SUBROUTINE FBLOCK (NROW,NCOL,IMAX,IRNGF,IPSYM)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     FBLOCK sets parameters for out-of-core solution for the MoM
C     matrix (A)
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 SSX,DETER
      COMMON /MATPAR/ ICASE,NBLOKS,NPBLK,NLAST,NBLSYM,NPSYM,NLSYM,IMAT,I
     &CASX,NBBX,NPBX,NLBX,NBBL,NPBL,NLBL
      COMMON /SMAT/ SSX(MAXSYM,MAXSYM)
      IMX1=IMAX-IRNGF
      IF (NROW*NCOL.LE.IMX1)THEN
         NBLOKS=1
         NPBLK=NROW
         NLAST=NROW
         IMAT=NROW*NCOL
         IF (NROW.EQ.NCOL)THEN
            ICASE=1
            RETURN
         END IF
         ICASE=2
      ELSE IF (NROW.EQ.NCOL)THEN
         ICASE=3
         NPBLK=IMAX/(2*NCOL)
         NPSYM=IMX1/NCOL
         IF (NPSYM.LT.NPBLK) NPBLK=NPSYM
         IF (NPBLK.LT.1)THEN
            WRITE(3,17) NROW,NCOL
            STOP
         END IF
         NBLOKS=(NROW-1)/NPBLK
         NLAST=NROW-NBLOKS*NPBLK
         NBLOKS=NBLOKS+1
         NBLSYM=NBLOKS
         NPSYM=NPBLK
         NLSYM=NLAST
         IMAT=NPBLK*NCOL
         WRITE(3,14) NBLOKS,NPBLK,NLAST
         RETURN
      ELSE
         NPBLK=IMAX/NCOL
         IF (NPBLK.LT.1)THEN
            WRITE(3,17) NROW,NCOL
            STOP
         END IF
         IF (NPBLK.GT.NROW) NPBLK=NROW
         NBLOKS=(NROW-1)/NPBLK
         NLAST=NROW-NBLOKS*NPBLK
         NBLOKS=NBLOKS+1
         WRITE(3,14) NBLOKS,NPBLK,NLAST
         IF (NROW*NROW.LE.IMX1)THEN
            ICASE=4
            NBLSYM=1
            NPSYM=NROW
            NLSYM=NROW
            IMAT=NROW*NROW
            WRITE(3,15)
         ELSE
            ICASE=5
            NPSYM=IMAX/(2*NROW)
            NBLSYM=IMX1/NROW
            IF (NBLSYM.LT.NPSYM) NPSYM=NBLSYM
            IF (NPSYM.LT.1)THEN
               WRITE(3,17) NROW,NCOL
               STOP
            END IF
            NBLSYM=(NROW-1)/NPSYM
            NLSYM=NROW-NBLSYM*NPSYM
            NBLSYM=NBLSYM+1
            WRITE(3,16) NBLSYM,NPSYM,NLSYM
            IMAT=NPSYM*NROW
         END IF
      END IF
      NOP=NCOL/NROW
      IF (NOP*NROW.NE.NCOL)THEN
         WRITE(3,18) NROW,NCOL
         STOP
      END IF
      IF(NOP.GT.MAXSYM)THEN
         WRITE(3,19)MAXSYM,NOP
         STOP
      END IF
      IF (IPSYM.LT.0)THEN
C
C        SET UP SSX MATRIX FOR ROTATIONAL SYMMETRY.
C
         PHAZ=6.2831853071796D0/NOP
         DO 6 I=2,NOP
         DO 6 J=I,NOP
         ARG=PHAZ*DFLOAT(I-1)*DFLOAT(J-1)
         SSX(I,J)=DCMPLX(COS(ARG),SIN(ARG))
6        SSX(J,I)=SSX(I,J)
      ELSE
C
C        SET UP SSX MATRIX FOR PLANE SYMMETRY
C
         KK=1
         SSX(1,1)=(1.,0.)
         IF ((NOP.NE.2).AND.(NOP.NE.4).AND.(NOP.NE.8))STOP
         KA=NOP/2
         IF (NOP.EQ.8) KA=3
         DO 10 K=1,KA
         DO 9 I=1,KK
         DO 9 J=1,KK
         DETER=SSX(I,J)
         SSX(I,J+KK)=DETER
         SSX(I+KK,J+KK)=-DETER
9        SSX(I+KK,J)=DETER
10       KK=KK*2
      END IF
      RETURN
C
14    FORMAT (//,' MATRIX FILE STORAGE -  NO. BLOCKS=',I5,
     &' COLUMNS PER BLOCK=',I5,' COLUMNS IN LAST BLOCK=',I5)
15    FORMAT (' SUBMATRICES FIT IN CORE')
16    FORMAT (' SUBMATRIX PARTITIONING -  NO. BLOCKS=',I5,
     &' COLUMNS PER BLOCK=',I5,' COLUMNS IN LAST BLOCK=',I5)
17    FORMAT (' FBLOCK: ERROR - INSUFFICIENT STORAGE FOR MATRIX',2I5)
18    FORMAT (' FBLOCK: SYMMETRY ERROR - NROW,NCOL=',2I5)
19    FORMAT (' FBLOCK: ERROR - NUMBER OF SYMMETRIC SECTIONS EXCEEDS',
     &' LIMIT: MAXSYM =',I6,' NEEDED:',I6)
      END
      SUBROUTINE FBNGF (NEQ,NEQ2,IRESRV,IB11,IC11,ID11,IX11)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     FBNGF sets the blocking parameters for the B, C, and D arrays for
C     out-of-core storage.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON /MATPAR/ ICASE,NBLOKS,NPBLK,NLAST,NBLSYM,NPSYM,NLSYM,IMAT,I
     &CASX,NBBX,NPBX,NLBX,NBBL,NPBL,NLBL
      IRESX=IRESRV-IMAT
      NBLN=NEQ*NEQ2
      NDLN=NEQ2*NEQ2
      NBCD=2*NBLN+NDLN
      IF (NBCD.LE.IRESX)THEN
         ICASX=1
         IB11=IMAT+1
         NBBX=1
         NPBX=NEQ
         NLBX=NEQ
         NBBL=1
         NPBL=NEQ2
         NLBL=NEQ2
      ELSE IF (ICASE.GT.2 .AND. NBCD.LE.IRESRV .AND. NBLN.LE.IRESX)THEN
         ICASX=2
         IB11=1
         NBBX=1
         NPBX=NEQ
         NLBX=NEQ
         NBBL=1
         NPBL=NEQ2
         NLBL=NEQ2
      ELSE
         IR=IRESRV
         IF (ICASE.LT.3) IR=IRESX
         ICASX=3
         IF (NDLN.GT.IR) ICASX=4
         NBCD=2*NEQ+NEQ2
         NPBL=IR/NBCD
         NLBL=IR/(2*NEQ2)
         IF (NLBL.LT.NPBL) NPBL=NLBL
         IF (ICASE.GT.2)THEN
            NLBL=IRESX/NEQ
            IF (NLBL.LT.NPBL) NPBL=NLBL
         END IF
         IF (NPBL.LT.1)THEN
            WRITE(3,7) IRESRV,IMAT,NEQ,NEQ2
            STOP
         END IF
         NBBL=(NEQ2-1)/NPBL
         NLBL=NEQ2-NBBL*NPBL
         NBBL=NBBL+1
         NBLN=NEQ*NPBL
         IR=IR-NBLN
         NPBX=IR/NEQ2
         IF (NPBX.GT.NEQ) NPBX=NEQ
         NBBX=(NEQ-1)/NPBX
         NLBX=NEQ-NBBX*NPBX
         NBBX=NBBX+1
         IB11=1
         IF (ICASE.LT.3) IB11=IMAT+1
      END IF
      IC11=IB11+NBLN
      ID11=IC11+NBLN
      IX11=IMAT+1
      WRITE(3,11) NEQ2
      IF (ICASX.EQ.1) RETURN
      WRITE(3,8) ICASX
      WRITE(3,9) NBBX,NPBX,NLBX
      WRITE(3,10) NBBL,NPBL,NLBL
      RETURN
C
7     FORMAT (' FBNGF: ERROR - INSUFFICIENT STORAGE FOR INTERACTION',
     &' MATRICES; IRESRV,IMAT,NEQ,NEQ2 =',4I5)
8     FORMAT (' FILE STORAGE FOR NEW MATRIX SECTIONS -  ICASX =',I2)
9     FORMAT (' B FILLED BY ROWS -',15X,'NO. BLOCKS =',I3,3X,
     &'ROWS PER BLOCK =',I3,3X,'ROWS IN LAST BLOCK =',I3)
10    FORMAT (' B BY COLUMNS, C AND D BY ROWS -',2X,'NO. BLOCKS =',I3,
     &4X,'R/C PER BLOCK =',I3,4X,'R/C IN LAST BLOCK =',I3)
11    FORMAT (//,' N.G.F. - NUMBER OF NEW UNKNOWNS IS',I4)
      END
      SUBROUTINE FITLS (ERV,EZV,ERH,EPH,EZH,IREG)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     FITLS obtains field values by least-squares approximation.  Static
C     terms are subtracted from reflected field.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 ERV,EZV,ERH,EPH,EZH,RRV,RZV,RRH,RPH,RZH,CK1,CK1SQ,CK2,
     &CK2SQ,CKS12,CON1,CON2,CON3,CON4,EPSC1,XJK,SAV
      COMMON /GREGON/ RHOA(3),RHOB(3),ZZA(3),ZZB(3),ZPA(3),ZPB(3),ELM,EL
     &MX,SCFAC,RHMX1,ZZMX1,ZPMX1,RHMX2,ZZMX2,ZPMX2,ZPMXX
      COMMON /GNRZZ/ CK1,CK1SQ,CK2,CK2SQ,CKS12,CON1,CON2,CON3,CON4,EPSC1
     &,XJK,RHO,ZS,ZO,ZZ,ZZP,AZP,ICASE
C     DETERMINE BEST REGION IF NOT ALREADY FIXED
      IF (IREG.EQ.3) GO TO 2
      IF (IREG.NE.0) GO TO 1
      IF (RHO.LT.RHOA(3).OR.ZZ.GT.RHO) GO TO 1
      IREG=3
      GO TO 2
1     IREG=1
      ZMAX=ZZA(1)
      IF (RHO.LT.ZMAX) ZMAX=RHO
      IF (ZZ.LT.ZMAX) IREG=2
2     CALL FITX (RHO,ZZ,ZZP,ERV,EZV,ERH,EPH,EZH,IREG)
      IF (IREG.NE.1) GO TO 3
      ZLAP=ZMAX*.05
      IF (ZZ.GT.ZMAX+ZLAP) GO TO 3
      CALL FITX (RHO,ZZ,ZZP,RRV,RZV,RRH,RPH,RZH,2)
      SFAC=3.141592654*(ZZ-ZMAX)/ZLAP
      SFAC=.5*(COS(SFAC)+1.)
      ERV=(RRV-ERV)*SFAC+ERV
      EZV=(RZV-EZV)*SFAC+EZV
      ERH=(RRH-ERH)*SFAC+ERH
      EPH=(RPH-EPH)*SFAC+EPH
      EZH=(RZH-EZH)*SFAC+EZH
3     GO TO (4,5,7,6), ICASE
C     REMOVE STATIC TERMS FROM REFLECTED FIELD
4     CALL GFDIR (RHO,-ZS,ZO,CK2,CK2,RRV,RZV,RRH,RPH,RZH)
      SAV=ERV
      ERV=-EZH+RRV-CON2*RRV
      EZV=EPSC1*EZV-RZV-CON2*RZV
      ERH=ERH-RRH+CON2*RRH
      EPH=EPH-RPH+CON2*RPH
      EZH=-EPSC1*SAV+RZH+CON2*RZH
      RETURN
5     CALL GFDIR (RHO,-ZS,ZO,CK2,CK1,RRV,RZV,RRH,RPH,RZH)
      ERV=ERV+RRV+CON2*RRV
      EZV=EZV/EPSC1-RZV+CON2*RZV
      ERH=ERH-RRH-CON2*RRH
      EPH=EPH-RPH-CON2*RPH
      EZH=EZH/EPSC1+RZH-CON2*RZH
      RETURN
6     SAV=ERV
      ERV=-EZH
      EZH=-SAV
7     RETURN
      END
      SUBROUTINE FITX (RHO,ZZ,ZP,E1,E2,E3,E4,E5,IREG)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     FITX combines the function values from subroutine FNFIT with the
C     coefficients obtained for a least-squares approximation.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 E1,E2,E3,E4,E5,FAC1,FAC2,FAC3,FAC4,FAC5,EXX,REXX,CFF1,
     &CFF2,CFF3,CFF4,CFF5,CFF6,CFF7,CFF8,CFF,FAC1L,FAC2L,FAC3L,FAC4L,
     &FAC5L
      COMMON /COFIT/ FAC1(32,3),FAC2(32,3),FAC3(32,3),FAC4(32,3),
     &FAC5(32,3),RKFAC,MFUNF(3),MFUNC(3)
      COMMON /FPARM/ CFF1,CFF2,CFF3,CFF4,CFF5,CFF6,CFF7,CFF8,FF1,FF2,
     &FF3,FF4,FF5,FF6,FF7,FF8,FF9,FF10,FF11,FF12,FF13,FF14,FF15,FF16,
     &FF17,FF18,FF19,FF20,FF21,FF22,FF23,FF24,NFUNF,NFUNC
      DIMENSION FF(24), CFF(8), FAC1L(96), FAC2L(96), FAC3L(96), FAC4L(9
     &6), FAC5L(96)
      EQUIVALENCE (FAC1,FAC1L), (FAC2,FAC2L), (FAC3,FAC3L), (FAC4,FAC4L)
     &, (FAC5,FAC5L), (FF(1),FF1), (CFF(1),CFF1)
      DATA NFROW/32/
      NFUNC=MFUNC(IREG)
      CALL FNFIT (RHO,ZZ,ZP,STH,EXX)
      RAX=ZZ-ZP*RKFAC
      RAX=SQRT(RHO*RHO+RAX*RAX)
      REXX=EXX/RAX
      E1=(0.,0.)
      E2=(0.,0.)
      E3=(0.,0.)
      E4=(0.,0.)
      E5=(0.,0.)
      IX=2
      IFB=NFROW*(IREG-1)
      DO 2 I=1,NFUNF
      IFX=IFB+I
      IX=IX+1
      E1=E1+FF(I)*FAC1L(IFX)
      E3=E3+FF(I)*FAC3L(IFX)
      E4=E4+FF(I)*FAC4L(IFX)
      E5=E5+FF(I)*FAC5L(IFX)
      IF (IX.EQ.3) GO TO 1
      E2=E2+FF(I)*FAC2L(IFX)
      GO TO 2
1     E2=E2+FF(I)*FAC2L(IFX)*STH
      IX=0
2     CONTINUE
      IF (NFUNC.EQ.0) GO TO 4
      IFB=IFB+NFUNF
      DO 3 I=1,NFUNC
      IFX=IFB+I
      E1=E1+CFF(I)*FAC1L(IFX)
      E2=E2+CFF(I)*FAC2L(IFX)
      E3=E3+CFF(I)*FAC3L(IFX)
      E4=E4+CFF(I)*FAC4L(IFX)
3     E5=E5+CFF(I)*FAC5L(IFX)
4     E1=E1*REXX*STH
      E2=E2*REXX
      E3=E3*REXX
      E4=E4*REXX
      E5=E5*REXX*STH
      RETURN
      END
      SUBROUTINE FNFIT (RHO,ZZ,ZP,STH,EXX)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     FNFIT supplies the function values for the least squares approx.
C     of the field crossing an interface.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 XLA,GCK1,GCK1SQ,GCK2,GCK2SQ,FJ,XLS,BET1,BET2,EXX,EXM,
     &CFF1,CFF2,CFF3,CFF4,CFF5,CFF6,CFF7,CFF8,ZZEXP
      COMMON /GPARM/ XLA(21,21),GCK1,GCK1SQ,GCK2,GCK2SQ,ZRAT,RHON
      COMMON /FPARM/ CFF1,CFF2,CFF3,CFF4,CFF5,CFF6,CFF7,CFF8,FF1,FF2,
     &FF3,FF4,FF5,FF6,FF7,FF8,FF9,FF10,FF11,FF12,FF13,FF14,FF15,FF16,
     &FF17,FF18,FF19,FF20,FF21,FF22,FF23,FF24,NFUNF,NFUNC
      DATA FJ/(0.D0,1.D0)/
C
C     FUNCTIONS FOR THE UPPER-MEDIUM RAY.  THE EXPONENTIAL IS HANDLED
C     SEPARATELY SO THAT THE VALUES ARE REAL
C
      CALL SADPT (RHO,ZZ,ZP,XLS)
      BET1=SQRT(GCK1SQ-XLS*XLS)
      BET2=SQRT(GCK2SQ-XLS*XLS)
      EXX=EXP(-FJ*(BET2*ZZ-BET1*ZP+XLS*RHO))
      RRAX=ZZ-ZP*ABS(GCK2/GCK1)
      RRAX=1./SQRT(RHO*RHO+RRAX*RRAX)
      CTH2=ZZ*RRAX
      CTH1=ZP*RRAX
      STH=RHO*RRAX
      FF1=1.
      FF2=FF1*RRAX
      FF3=FF2*RRAX
      FF4=FF1*CTH2
      FF5=FF2*CTH2
      FF6=FF3*CTH2
      FF7=FF4*CTH2
      FF8=FF5*CTH2
      FF9=FF6*CTH2
      FF10=FF7*CTH2
      FF11=FF8*CTH2
      FF12=FF9*CTH2
      FF13=FF1*CTH1
      FF14=FF2*CTH1
      FF15=FF3*CTH1
      FF16=FF4*CTH1
      FF17=FF5*CTH1
      FF18=FF6*CTH1
      FF19=FF7*CTH1
      FF20=FF8*CTH1
      FF21=FF9*CTH1
      FF22=FF10*CTH1
      FF23=FF11*CTH1
      FF24=FF12*CTH1
      NFUNF=24
      IF (NFUNC.EQ.0) RETURN
C
C     FUNCTIONS TO FIT THE LOWER-MEDIUM RAY
C
      RP=SQRT(RHO*RHO+ZP*ZP)
      IF (RP.LT.1.E-20) RP=1.E-20
      XLS=GCK1*RHO/RP
      BET2=-SQRT(GCK2SQ-XLS*XLS)
      EXM=ZZEXP(-FJ*(BET2*ZZ+GCK1*RP))/EXX
      CFF1=EXM*CTH1*STH
      CFF2=CFF1*CTH1
      CFF3=EXM/RP*STH
      CFF4=CFF3*CTH1
      CFF5=CFF1*CTH2
      CFF6=CFF2*CTH2
      CFF7=CFF3*CTH2
      CFF8=CFF4*CTH2
      NFUNC=8
      RETURN
      END
      SUBROUTINE GASY1 (RHO,ZZ,ZP,XLS,IEX,EXX,ERV,EZV,ERH,EPH,EZH)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     GASY1 evaluates the field transmitted across an interface using
C     first order asymptotic approximations (geometric optics.)
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 XLS,EXX,ERV,EZV,ERH,EPH,EZH,XLA,GCK1,GCK1SQ,GCK2,
     &GCK2SQ,CON,FJ,XLSS,CGAM1,CGAM2,RHOXL,ZOG1,ZOG2,PSI,TCV,TCU,ZZEXP
      COMMON /GPARM/ XLA(21,21),GCK1,GCK1SQ,GCK2,GCK2SQ,ZRAT,RHON
      DATA CON/(42.398D0,-42.398D0)/,FJ/(0.D0,1.D0)/
      XLSS=XLS*XLS
      CGAM1=SQRT(XLSS-GCK1SQ)
      CGAM2=SQRT(XLSS-GCK2SQ)
      IF (DREAL(XLS).LE.DREAL(GCK2).AND.DIMAG(CGAM2).LT.0.) CGAM2=-CGAM2
      IF (ABS(XLS/GCK2).GT.1.E-2)THEN
         RHOXL=RHO/XLS
      ELSE
         RHOXL=ZZ/GCK2-ZP/GCK1
      END IF
      IF (ABS(CGAM1/GCK1).GT.1.E-2)THEN
         ZOG1=ZP/CGAM1
      ELSE
         ZOG1=ZZ/CGAM2+FJ*RHOXL
      END IF
      IF (ABS(CGAM2/GCK2).GT.1.E-2)THEN
         ZOG2=ZZ/CGAM2
      ELSE
         ZOG2=ZP/CGAM1-FJ*RHOXL
      END IF
      PSI=GCK1SQ*ZOG1*CGAM2*CGAM2-GCK2SQ*ZOG2*CGAM1*CGAM1
      PSI=CGAM1*CGAM2/SQRT(PSI)
      IF (DIMAG(PSI).LT.0.) PSI=-PSI
      PSI=PSI/SQRT(RHOXL)
      PSI=CON*GCK2*PSI
      EXX=ZZEXP(CGAM1*ZP-CGAM2*ZZ-FJ*XLS*RHO)
      IF (IEX.NE.0) PSI=PSI*EXX
      TCV=PSI/(GCK1SQ*CGAM2+GCK2SQ*CGAM1)
      TCU=PSI/(CGAM1+CGAM2)
      ERV=FJ*TCV*XLS*CGAM2
      EZV=TCV*XLSS
      ERH=-TCV*XLSS+TCU
      EPH=FJ*TCV/RHOXL-TCU
      EZH=FJ*TCV*XLS*CGAM1
      RETURN
      END
      SUBROUTINE GASY2 (RHO,ZZ,ZP,XLS,IEX,ERV,EZV,ERH,EPH,EZH)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     GASY2 evaluates the field transmitted across an interface using
C     asymptotic approximations with surface wave and higher order
C     saddle-point terms.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      SAVE
      COMPLEX*16 XLA,GCK1,GCK1SQ,GCK2,GCK2SQ,CK1X,CK2X,CD,AA,XLP,PG1,
     &PG2,FJOR,XLS,XLS2,XLSQ,CGG2,CGG4,CGG,GAM,GAM2,GAM4,DEN,FMHF,DEN32,
     &FT1,FT2,FT3,EXX,T1,T2,T3,T4,T5,T6,T7,DP0,DP1,DP2,GP0,GP1,GP2,U12,
     &ERV,EZV,ERH,EPH,EZH,FS,FP,BB,VP12,FJ,FBARS,GG0,GG2,GX0,GX2,FA2,
     &FB2,FA4,FB4,ZZEXP
      COMMON /GPARM/ XLA(21,21),GCK1,GCK1SQ,GCK2,GCK2SQ,ZRAT,RHON
      COMMON /GASAV/ CD,AA,XLP,PG1,PG2,GG0,GG2,GX0,GX2,FA2,FB2,FA4,FB4
      DATA FJ/(0.D0,1.D0)/,CK1X/(0.D0,0.D0)/,CK2X/(0.D0,0.D0)/
      T1=GCK1-CK1X
      T2=GCK2-CK2X
      ZXX=DREAL(GCK2)*1.E-8
      IF (ABS(DREAL(T1)).GT.ZXX.OR.ABS(DIMAG(T1)).GT.ZXX) GO TO 1
      IF (ABS(DREAL(T2)).GT.ZXX.OR.ABS(DIMAG(T2)).GT.ZXX) GO TO 1
      GO TO 2
C     COMPUTE CONSTANTS THAT DEPEND ONLY ON GCK1 AND GCK2
1     CK1X=GCK1
      CK2X=GCK2
      CD=SQRT(GCK1SQ+GCK2SQ)
      AA=GCK1*GCK2
      AA=FJ*SQRT(AA*AA*AA)/((GCK2SQ*GCK2SQ-GCK1SQ*GCK1SQ)*SQRT(CD))
      XLP=GCK1*GCK2/CD
      PG1=SQRT(XLP*XLP-GCK1SQ)
      PG2=SQRT(XLP*XLP-GCK2SQ)
      IF (DIMAG(PG2).LT.0.) PG2=-PG2
C     END OF CONSTANTS.  NOW CALCULATE SADDLE-POINT TERMS.
2     FJOR=(0.,.125)/RHO
      ZZ2=ZZ*ZZ
      ZZ4=ZZ2*ZZ2
      XLS2=XLS*XLS
      XLSQ=SQRT(XLS)
      CGG2=XLS2-GCK1SQ
      CGG4=CGG2*CGG2
      CGG=SQRT(CGG2)
      GAM=XLS/(XLS*ZP/CGG-FJ*RHO)
      GAM2=GAM*GAM
      GAM4=GAM2*GAM2
      DEN=1./(-GCK2SQ*CGG2*CGG+GCK1SQ*GAM2*GAM*ZZ2*ZP)
      FMHF=SQRT(CGG2*CGG*GAM2*GAM*DEN)
      IF (DIMAG(FMHF).LT.0.) FMHF=-FMHF
      DEN32=CGG*GAM*DEN*FMHF/24.
      FT1=GAM4*ZZ4*(4.*XLS2+GCK1SQ)+CGG4*(4.*XLS2+GCK2SQ)
      FT1=GCK1SQ*GCK2SQ*CGG*GAM*ZP*(10.*XLS2*CGG2*GAM2*ZZ2-FT1)
      FT1=GCK2SQ*GCK2SQ*CGG4*CGG4+GCK1SQ*GCK1SQ*ZZ4*ZZ2*ZP*ZP*GAM4*GAM4
     &-FT1
      FT1=9.*ZZ*FT1*DEN32*DEN*DEN+ZZ*FMHF
      FT2=GCK2SQ*CGG4*CGG-GCK1SQ*ZZ4*ZP*GAM4*GAM
      FT2=36.*XLS*FT2*DEN32*DEN
      FT3=12.*CGG2*GAM2*DEN32
      EXX=(42.398,-42.398)*GCK2/SQRT(RHO)
      IF (IEX.NE.0) EXX=EXX*ZZEXP(-(GAM*ZZ2-CGG*ZP+FJ*XLS*RHO))
      T1=(XLS-3.*FJOR)*XLSQ
      T2=(XLS-FJOR)/XLSQ
      T3=(1.+FJOR/XLS)/XLSQ
      T4=(4.*XLS-6.*FJOR)*XLSQ
      T5=(2.5*XLS+1.5*FJOR)*XLSQ
      T6=(XLS-7.*FJOR)*XLS*XLSQ
      T7=(2.5*XLS-10.5*FJOR)*XLSQ
      DP0=1./(CGG+GAM*ZZ)
      DP1=-DP0*XLS/(CGG*GAM)
      DP2=(GCK1SQ*ZZ2*ZZ/(CGG2*CGG)+GCK2SQ/(GAM2*GAM))*DP0*DP0
      DP2=DP2+2.*ZZ*DP1*DP1/DP0
      GP0=XLS*T3*DP0
      GP1=.5*ZZ*T2*DP0/XLS+XLS*T3*DP1
      GP2=ZZ2*(-.25*ZZ*T1*DP0/XLS2+T2*DP1)/XLS+XLS*T3*DP2
      U12=(GP0*FT1-GP1*FT2+GP2*FT3)*EXX
      DP0=1./(GCK1SQ*GAM*ZZ+GCK2SQ*CGG)
      DP1=-XLS*(GCK1SQ/GAM+GCK2SQ/CGG*ZZ)*DP0*DP0
      DP2=ZZ/CGG
      DP2=GCK1SQ*GCK2SQ*(DP2*DP2*DP2+1./(GAM2*GAM))*DP0*DP0
      DP2=DP2+2.*ZZ*DP1*DP1/DP0
      GP0=ZZ*GAM*T1*DP0
      GP1=(XLS*T1/GAM+1.5*GAM*ZZ2*T2)*DP0+GAM*ZZ*T1*DP1
      GP2=GAM*ZZ*((.75*T3*ZZ*DP0+3.*T2*DP1)*ZZ2+T1*DP2)
      GP2=(-XLS2*T1*DP0/GAM2+(T4*ZZ*DP0+2.*XLS*T1*DP1)*ZZ)/GAM+GP2
      ERV=(GP0*FT1-GP1*FT2+GP2*FT3)*EXX*FJ
      GP2=XLS2*XLS*T3
      GP0=GP2*DP0
      GP1=T5*DP0*ZZ+GP2*DP1
      GP2=((3.75*XLS+.75*FJOR)/XLSQ*DP0*ZZ+2.*T5*DP1)*ZZ2+GP2*DP2
      EZV=(GP0*FT1-GP1*FT2+GP2*FT3)*EXX
      GP0=T6*DP0
      GP1=T7*DP0*ZZ+T6*DP1
      GP2=((3.75*XLS-5.25*FJOR)/XLSQ*DP0*ZZ+2.*T7*DP1)*ZZ2+T6*DP2
      ERH=-(GP0*FT1-GP1*FT2+GP2*FT3)*EXX+U12
      GP0=T1*DP0
      GP1=1.5*T2*DP0*ZZ+T1*DP1
      GP2=(.75*T3*DP0*ZZ+3.*T2*DP1)*ZZ2+T1*DP2
      EPH=(GP0*FT1-GP1*FT2+GP2*FT3)*EXX*FJ/RHO-U12
      GP0=CGG*T1*DP0
      GP1=(XLS*T1/CGG+1.5*CGG*T2)*DP0*ZZ+CGG*T1*DP1
      GP2=((-XLS2*T1/CGG2+T4)*DP0*ZZ+2.*XLS*T1*DP1)*ZZ2/CGG
      GP2=GP2+CGG*((.75*T3*DP0*ZZ+3.*T2*DP1)*ZZ2+T1*DP2)
      EZH=(GP0*FT1-GP1*FT2+GP2*FT3)*EXX*FJ
C     ADD POLE CONTRIBUTION (SURFACE WAVE)
      FS=-CGG*ZP+GAM*ZZ2+FJ*XLS*RHO
      FP=-PG1*ZP-PG2*ZZ+FJ*XLP*RHO
      BB=SQRT(FP-FS)
      VP12=.70710678*EXX*AA/BB*(FBARS(FJ*BB)+.5/(BB*BB))
      ERV=ERV+VP12*(XLP-3.*FJOR)*GCK2SQ/CD
      EZV=EZV+VP12*(XLP+FJOR)*XLP
      ERH=ERH-VP12*(XLP-7.*FJOR)*XLP
      EPH=EPH+VP12*FJ*(XLP-3.*FJOR)/RHO
      EZH=EZH-VP12*(XLP-3.*FJOR)*GCK1SQ/CD
      RETURN
      END
      SUBROUTINE GASY3 (ZZ,ZP,IEX,EZV,ERH,EPH)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     GASY3 evaluates the field transmitted across an interface at
C     normal incidence using an asymptotic approximation with higher
C     order terms.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      SAVE
      COMPLEX*16 EZV,ERH,EPH,XLA,GCK1,GCK1SQ,GCK2,GCK2SQ,FJ,CK1X,CK2X,
     &T1,T2,GG0,GG2,GX0,GX2,FA2,FB2,FA4,FB4,FP2,FP4,EXX,U12,CD,AA,XLP,
     &PG1,PG2,ZZEXP
      COMMON /GPARM/ XLA(21,21),GCK1,GCK1SQ,GCK2,GCK2SQ,ZRAT,RHON
      COMMON /GASAV/ CD,AA,XLP,PG1,PG2,GG0,GG2,GX0,GX2,FA2,FB2,FA4,FB4
      DATA FJ/(0.D0,1.D0)/,CK1X/(0.D0,0.D0)/,CK2X/(0.D0,0.D0)/
      T1=GCK1-CK1X
      T2=GCK2-CK2X
      ZXX=DREAL(GCK2)*1.E-8
      IF (ABS(DREAL(T1)).GT.ZXX.OR.ABS(DIMAG(T1)).GT.ZXX) GO TO 1
      IF (ABS(DREAL(T2)).GT.ZXX.OR.ABS(DIMAG(T2)).GT.ZXX) GO TO 1
      GO TO 2
C     COMPUTE CONSTANTS THAT DEPEND ONLY ON GCK1 AND GCK2
1     CK1X=GCK1
      CK2X=GCK2
      GG2=GCK1+GCK2
      GX0=-FJ/GG2
      GX2=-FJ*(1./GCK1+1./GCK2)/(GG2*GG2)
      GG0=GX0/(GCK1*GCK2)
      GG2=-FJ*(1./(GCK1*GCK1SQ)+1./(GCK2*GCK2SQ))/(GG2*GG2)
      FA2=-FJ/GCK2
      FB2=FJ/GCK1
      FA4=-3.*FJ/(GCK2*GCK2SQ)
      FB4=3.*FJ/(GCK1*GCK1SQ)
C     END OF CONSTANTS
2     FP2=FA2*ZZ+FB2*ZP
      FP4=FA4*ZZ+FB4*ZP
      T1=2./FP2
      T2=(0.,-29.98)*GCK2*T1
      EZV=T1*T2*(GG0+(2.*GG2*FP2-GG0*FP4)/(FP2*FP2))
      U12=T2*(GX2*FP2-GX0*FP4/3.)/(FP2*FP2)
      IF (IEX.EQ.0) GO TO 3
      EXX=ZZEXP(-FJ*(GCK2*ZZ-GCK1*ZP))
      EZV=EZV*EXX
      U12=(T2*GX0+U12)*EXX
3     ERH=-.5*EZV+U12
      EPH=-ERH
      IF (IEX.EQ.0) EPH=EPH-.5*T1*T2*GG0
      RETURN
      END
      SUBROUTINE GEASY (RHO,ZZ,ZP,ERV,EZV,ERH,EPH,EZH)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     GEASY calls appropriate routines for asymptotic approximations
C     of the E field.
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 ERV,EZV,ERH,EPH,EZH,XLA,GCK1,GCK1SQ,GCK2,GCK2SQ,XLS,
     &EXX,XLSX,FRV,FZV,FRH,FPH,FZH,VZV,VRH,VPH
      COMPLEX*16 GRV,GZV,GRH,GPH,GZH
      COMMON /GPARM/ XLA(21,21),GCK1,GCK1SQ,GCK2,GCK2SQ,ZRAT,RHON
      DATA ALIM/.2D0/,BLIM/.1D0/
      CALL SADPT (RHO,ZZ,ZP,XLS)
      CALL SDLPT (XLS,IERR)
      IF (ZZ.GT..05*(ZZ-ZP)) GO TO 1
      ZXX=-ZP
      BB=ABS(GCK2/GCK1)
      BB=BB/SQRT(1.-BB*BB)
C     BB=TAN(ABS(TOTALLY REFELECTING ANGLE))
      IF (RHO.LT.ZXX*BB) GO TO 5
      BB=(BLIM+BB)/(1.-BLIM*BB)
C     BB=TAN(CABS(TOTALLY REFELECTING ANGLE)+ATAN(BLIM))
      IF (RHO.LT.ZXX*BB) GO TO 4
1     ZXX=(ZZ-ZP)*ALIM
      IF (RHO.LT.ZXX) GO TO 2
      IF (ZZ*DREAL(GCK2).GT.100.) GO TO 5
C
C     CALL GASY2 FOR ASYMPTOTIC APPROX. WITH HIGHER ORDER TERMS AND
C     SURFACE WAVE
C
      CALL GASY2 (RHO,ZZ,ZP,XLS,1,ERV,EZV,ERH,EPH,EZH)
C     ADD FIRST ORDER ASYMPTOTIC FOR RAY IN LOWER MEDIUM
      XLS=GCK1*RHO/SQRT(RHO*RHO+ZP*ZP)
      CALL GASY1 (RHO,ZZ,ZP,XLS,1,EXX,FRV,FZV,FRH,FPH,FZH)
      ERV=ERV+FRV
      EZV=EZV+FZV
      ERH=ERH+FRH
      EPH=EPH+FPH
      EZH=EZH+FZH
      RETURN
2     IF (RHO.LT..001*ALIM) GO TO 3
C
C     GET FIRST ORDER G.O. FOR ACTUAL COORD. AND INTERPOLATE FOR HIGHER
C     ORDER TERMS BETWEEN RHO=0. (GASY3) AND RHO=ZXX (GASY2-GASY1)
C
      CALL SADPT (ZXX,ZZ,ZP,XLSX)
      CALL SDLPT (XLSX,IERR)
      CALL GASY2 (ZXX,ZZ,ZP,XLSX,0,FRV,FZV,FRH,FPH,FZH)
      CALL GASY1 (ZXX,ZZ,ZP,XLSX,0,EXX,GRV,GZV,GRH,GPH,GZH)
      FRV=FRV-GRV
      FZV=FZV-GZV
      FRH=FRH-GRH
      FPH=FPH-GPH
      FZH=FZH-GZH
      CALL GASY3 (ZZ,ZP,0,VZV,VRH,VPH)
      CALL GASY1 (RHO,ZZ,ZP,XLS,0,EXX,ERV,EZV,ERH,EPH,EZH)
      AA1=RHO*RHO/(ZXX*ZXX)
      AA2=(RHO+ZXX)*(RHO-ZXX)/(ZXX*ZXX)
      ERV=(ERV+FRV*RHO/ZXX)*EXX
      EZV=(EZV+FZV*AA1-VZV*AA2)*EXX
      ERH=(ERH+FRH*AA1-VRH*AA2)*EXX
      EPH=(EPH+FPH*AA1-VPH*AA2)*EXX
      EZH=(EZH+FZH*RHO/ZXX)*EXX
      RETURN
C     CALL GASY3 FOR ASYMPTOTIC APPROX. FOR NORMAL INCIDENCE
3     CALL GASY3 (ZZ,ZP,1,EZV,ERH,EPH)
      ERV=(0.,0.)
      EZH=(0.,0.)
      RETURN
C     USE FIRST ORDER G.O. ONLY
4     XLS=GCK1*RHO/SQRT(RHO*RHO+ZP*ZP)
5     CALL GASY1 (RHO,ZZ,ZP,XLS,1,EXX,ERV,EZV,ERH,EPH,EZH)
      RETURN
      END
      SUBROUTINE GFDIR (RHO,ZS,ZO,CKFS,CK,ERV,EZV,ERH,EPH,EZH)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     GFDIR computes the E field of a point source in an infinite medium
C     with wave number CK.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 CKFS,CK,ERV,EZV,ERH,EPH,EZH,FJ,CON,EXF,T1,T2
      DATA FJ/(0.D0,1.D0)/
      CON=(0.,-29.98)*CKFS
      ZD=ZO-ZS
      R=SQRT(RHO*RHO+ZD*ZD)
      RR=1./R
      RR2=RR*RR
      T2=CK*R
      T1=CK*CK
      EXF=CON*EXP(-FJ*T2)*RR2*RR/T1
      T1=3.*(RR2+FJ*CK*RR)-T1
      T2=(T2-FJ)*T2-1.
      ERV=RHO*ZD*T1*EXF
      EZV=(ZD*ZD*T1+T2)*EXF
      ERH=(RHO*RHO*T1+T2)*EXF
      EPH=-T2*EXF
      EZH=ERV
      RETURN
      END
      SUBROUTINE GFIL (IPRT,FILNAM)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     GFIL reads the N.G.F. file written by a previous solution.
C
      INCLUDE 'NECPAR.INC'
      PARAMETER (IRESRV=MAXMAT**2)
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER COMIN*78,INFILE*80,OUTFILE*80,NGFFIL*80,FILNAM*(*)
      COMPLEX*16 CM,SSX,ZARRAY,CEINS,EPSC,XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,
     &FRATI,ETAL2
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON /CMB/CM(IRESRV),IP(2*MAXSEG),IB11,IC11,ID11,NEQMAT,NEQ,NEQ2
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      COMMON /MATPAR/ ICASE,NBLOKS,NPBLK,NLAST,NBLSYM,NPSYM,NLSYM,IMAT,I
     &CASX,NBBX,NPBX,NLBX,NBBL,NPBL,NLBL
      COMMON /SMAT/ SSX(MAXSYM,MAXSYM)
      COMMON/ZLOAD/ ZARRAY(MAXSEG),NLOAD,NLODF,LDTYP(LOADMX),
     &LDTAG(LOADMX),LDTAGF(LOADMX),LDTAGT(LOADMX),ZLR(LOADMX),
     &ZLI(LOADMX),ZLC(LOADMX)
      COMMON/INSCOM/CEINS(MAXSEG),BRINS(MAXSEG),NINS,NINSF,INTAG(MAXIS),
     &INTAGF(MAXIS),INTAGT(MAXIS),EPSIN(MAXIS),SIGIN(MAXIS),RADIN(MAXIS)
      COMMON/SETGN/GEPS,GSIG,UEPS,USIG
      COMMON/NINFO/KCOM,COMIN(5),INFILE,OUTFILE
      COMMON/FRQDAT/IFRQ,NFRQ,FMHZS,DELFRQ,FMHZ
      COMMON/CONSTN/PI,TP,DTORAD,CVEL,EPSRZ,RMUZ,ETAZ
C***
      DATA IGFL/20/
      NGFFIL=FILNAM
      IF(FILNAM.EQ.' ')NGFFIL='NGFD.NEC'
      OPEN(UNIT=IGFL,FILE=NGFFIL,FORM='UNFORMATTED',STATUS='OLD')
      REWIND IGFL
      READ (IGFL) N1,NP,M1,MP,FMHZS,IPSYM,KSYMP,IPERF,NRADL,GEPS,GSIG,
     &UEPS,USIG,SCNRAD,SCNWRD,NLODF,NINSF,KCOM
      N=N1
      M=M1
      N2=N1+1
      M2=M1+1
      IF (N1.GT.0)THEN
C
C        READ SEG. DATA AND CONVERT BACK TO END COORD.
         READ (IGFL) (X(I),I=1,N1),(Y(I),I=1,N1),(Z(I),I=1,N1)
         READ (IGFL) (SI(I),I=1,N1),(BI(I),I=1,N1),(ALP(I),I=1,N1)
         READ (IGFL) (BET(I),I=1,N1),(SALP(I),I=1,N1)
         READ (IGFL) (ICON1(I),I=1,N1),(ICON2(I),I=1,N1)
         READ (IGFL) (ITAG(I),I=1,N1)
         IF (NLODF.NE.0) READ (IGFL) (ZARRAY(I),I=1,N1)
         IF (NINSF.NE.0) READ (IGFL) (CEINS(I),BRINS(I),I=1,N1)
         DO 1 I=1,N1
         XI=X(I)
         YI=Y(I)
         ZI=Z(I)
         DX=SI(I)*.5
         X(I)=XI-ALP(I)*DX
         Y(I)=YI-BET(I)*DX
         Z(I)=ZI-SALP(I)*DX
         SI(I)=XI+ALP(I)*DX
         ALP(I)=YI+BET(I)*DX
         BET(I)=ZI+SALP(I)*DX
1        CONTINUE
      END IF
      IF (M1.GT.0)THEN
         J=LD-M1+1
C
C        READ PATCH DATA
         READ (IGFL) (X(I),I=J,LD),(Y(I),I=J,LD),(Z(I),I=J,LD)
         READ (IGFL) (SI(I),I=J,LD),(BI(I),I=J,LD),(ALP(I),I=J,LD)
         READ (IGFL) (BET(I),I=J,LD),(SALP(I),I=J,LD)
         READ (IGFL) (T2X(I),I=J,LD),(T2Y(I),I=J,LD)
         READ (IGFL) (T2Z(I),I=J,LD)
      END IF
      READ (IGFL) ICASE,NBLOKS,NPBLK,NLAST,NBLSYM,NPSYM,NLSYM,IMAT
      IF (IPERF.EQ.2)THEN
         EPSC=DCMPLX(GEPS,-GSIG/(TP*FMHZS*1.E6*EPSRZ))
         CALL GNDINO(EPSC,IGFL)
      END IF
      NEQ=N1+2*M1
      NPEQ=NP+2*MP
      NOP=NEQ/NPEQ
      IF (NOP.GT.1) READ (IGFL) ((SSX(I,J),I=1,NOP),J=1,NOP)
      READ (IGFL) (IP(I),I=1,NEQ),COMIN
C
C     READ MATRIX A AND WRITE TAPE11 FOR OUT OF CORE
C
      IF (ICASE.LE.2)THEN
         IOUT=NEQ*NPEQ
         READ (IGFL) (CM(I),I=1,IOUT)
      ELSE IF(ICASE.EQ.4)THEN
         IOUT=NPEQ*NPEQ
         CLOSE(UNIT=11,STATUS='DELETE',ERR=2)
2        CALL DAOPEN(11,'TAPE11.NEC','unknown','DELETE',IOUT)
         DO 6 K=1,NOP
         READ (IGFL) (CM(J),J=1,IOUT)
6        CALL RECOT(CM,11,1,IOUT,K,'Write for ICASE=4 in GFIL')
      ELSE
         IOUT=NPSYM*NPEQ
         CLOSE(UNIT=11,STATUS='DELETE',ERR=3)
3        CALL DAOPEN(11,'TAPE11.NEC','unknown','DELETE',IOUT)
         IREC=0
         DO 8 IOP=1,NOP
         DO 8 I=1,NBLSYM
         IREC=IREC+1
         READ(IGFL)(CM(J),J=1,IOUT)
8        CALL RECOT(CM,11,1,IOUT,IREC,'Write for ICASE=5 in GFIL')
      END IF
      REWIND IGFL
C
C     PRINT N.G.F. HEADING
C
      WRITE(3,16)
      WRITE(3,14)
      WRITE(3,14)
      WRITE(3,17)
      WRITE(3,18) FILNAM(1:47),N1,M1
      IF (NOP.GT.1) WRITE(3,19) NOP
      WRITE(3,20) IMAT,ICASE
      IF (ICASE.GT.2)THEN
         NBL2=NEQ*NPEQ
         WRITE(3,21) NBL2
      END IF
      WRITE(3,22) FMHZS
      IF (KSYMP.EQ.2.AND.IPERF.EQ.1) WRITE(3,23)
      IF (KSYMP.EQ.2.AND.IPERF.EQ.0) WRITE(3,27)
      IF (KSYMP.EQ.2.AND.IPERF.EQ.2) WRITE(3,28)
      IF (KSYMP.EQ.2.AND.IPERF.NE.1) WRITE(3,24) GEPS,GSIG
      WRITE(3,17)
      DO 12 J=1,KCOM
12    WRITE(3,15) COMIN(J)
      WRITE(3,17)
      WRITE(3,14)
      WRITE(3,14)
      WRITE(3,16)
      IF (IPRT.EQ.0) RETURN
      WRITE(3,25)
      DO 13 I=1,N1
13    WRITE(3,26) I,X(I),Y(I),Z(I),SI(I),ALP(I),BET(I)
      RETURN
C
14    FORMAT (5X,'**************************************************',
     &'**********************************')
15    FORMAT (5X,'** ',A,' **')
16    FORMAT (////)
17    FORMAT (5X,'**',80X,'**')
18    FORMAT (5X,'** NUMERICAL GREEN''S FUNCTION FILE ',A,'**',/,5X,
     &'** NO. SEGMENTS =',I4,10X,'NO. PATCHES =',I4,34X,'**')
19    FORMAT (5X,'** NO. SYMMETRIC SECTIONS =',I4,51X,'**')
20    FORMAT (5X,'** N.G.F. MATRIX -  CORE STORAGE =',I7,
     &' COMPLEX NUMBERS,  CASE',I2,16X,'**')
21    FORMAT (5X,'**',19X,'MATRIX SIZE =',I7,' COMPLEX NUMBERS',25X,'**'
     &)
22    FORMAT (5X,'** FREQUENCY =',1PE12.5,' MHZ.',51X,'**')
23    FORMAT (5X,'** PERFECT GROUND',65X,'**')
24    FORMAT (5X,'** GROUND PARAMETERS - DIELECTRIC CONSTANT =',
     &1PE12.5,26X,'**',/,5X,'**',21X,'CONDUCTIVITY =',E12.5,' MHOS/M.',
     &25X,'**')
25    FORMAT (39X,'NUMERICAL GREEN''S FUNCTION DATA',/,41X,'COORDINAT',
     &'ES OF SEGMENT ENDS',/,51X,'(METERS)',/,5X,'SEG.',11X,
     &'- - - END ONE - - -',26X,'- - - END TWO - - -',/,6X,'NO.',6X,'X',
     &14X,'Y',14X,'Z',14X,'X',14X,'Y',14X,'Z')
26    FORMAT (1X,I7,1P6E15.6)
27    FORMAT (5X,'** FINITE GROUND.  REFLECTION COEFFICIENT APPROXIMATIO
     &N',27X,'**')
28    FORMAT (5X,'** FINITE GROUND.  SOMMERFELD SOLUTION',44X,'**')
      END
      SUBROUTINE GFOUT(FILNAM)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     GFOUT writes a N.G.F. file.
C
      INCLUDE 'NECPAR.INC'
      PARAMETER (IRESRV=MAXMAT**2)
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER COMIN*78,INFILE*80,OUTFILE*80,NGFFIL*80,FILNAM*(*)
      COMPLEX*16 CM,SSX,ZARRAY,CEINS,XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,
     &FRATI,ETAL2
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON /CMB/CM(IRESRV),IP(2*MAXSEG),IB11,IC11,ID11,NEQMAT,NEQ,NEQ2
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      COMMON /MATPAR/ ICASE,NBLOKS,NPBLK,NLAST,NBLSYM,NPSYM,NLSYM,IMAT,I
     &CASX,NBBX,NPBX,NLBX,NBBL,NPBL,NLBL
      COMMON /SMAT/ SSX(MAXSYM,MAXSYM)
      COMMON/ZLOAD/ ZARRAY(MAXSEG),NLOAD,NLODF,LDTYP(LOADMX),
     &LDTAG(LOADMX),LDTAGF(LOADMX),LDTAGT(LOADMX),ZLR(LOADMX),
     &ZLI(LOADMX),ZLC(LOADMX)
      COMMON/INSCOM/CEINS(MAXSEG),BRINS(MAXSEG),NINS,NINSF,INTAG(MAXIS),
     &INTAGF(MAXIS),INTAGT(MAXIS),EPSIN(MAXIS),SIGIN(MAXIS),RADIN(MAXIS)
      COMMON/SETGN/GEPS,GSIG,UEPS,USIG
      COMMON/NINFO/KCOM,COMIN(5),INFILE,OUTFILE
      COMMON/FRQDAT/IFRQ,NFRQ,FMHZS,DELFRQ,FMHZ
      DATA IGFL/20/
      NGFFIL=FILNAM
      IF(FILNAM.EQ.' ')NGFFIL='NGFD.NEC'
      OPEN(UNIT=IGFL,FILE=NGFFIL,FORM='UNFORMATTED',STATUS='unknown')
      NEQ=N+2*M
      NPEQ=NP+2*MP
      NOP=NEQ/NPEQ
      WRITE (IGFL) N,NP,M,MP,FMHZ,IPSYM,KSYMP,IPERF,NRADL,GEPS,GSIG,
     &UEPS,USIG,SCNRAD,SCNWRD,NLOAD,NINS,KCOM
      IF (N.GT.0)THEN
         WRITE (IGFL) (X(I),I=1,N),(Y(I),I=1,N),(Z(I),I=1,N)
         WRITE (IGFL) (SI(I),I=1,N),(BI(I),I=1,N),(ALP(I),I=1,N)
         WRITE (IGFL) (BET(I),I=1,N),(SALP(I),I=1,N)
         WRITE (IGFL) (ICON1(I),I=1,N),(ICON2(I),I=1,N)
         WRITE (IGFL) (ITAG(I),I=1,N)
         IF (NLOAD.GT.0) WRITE (IGFL) (ZARRAY(I),I=1,N)
         IF (NINS.GT.0) WRITE(IGFL) (CEINS(I),BRINS(I),I=1,N)
      END IF
      IF (M.GT.0)THEN
         J=LD-M+1
         WRITE (IGFL) (X(I),I=J,LD),(Y(I),I=J,LD),(Z(I),I=J,LD)
         WRITE (IGFL) (SI(I),I=J,LD),(BI(I),I=J,LD),(ALP(I),I=J,LD)
         WRITE (IGFL) (BET(I),I=J,LD),(SALP(I),I=J,LD)
         WRITE (IGFL) (T2X(I),I=J,LD),(T2Y(I),I=J,LD)
         WRITE (IGFL) (T2Z(I),I=J,LD)
      END IF
      WRITE (IGFL) ICASE,NBLOKS,NPBLK,NLAST,NBLSYM,NPSYM,NLSYM,IMAT
      IF (IPERF.EQ.2) CALL GNDOUT (IGFL)
      IF (NOP.GT.1) WRITE (IGFL) ((SSX(I,J),I=1,NOP),J=1,NOP)
      WRITE (IGFL) (IP(I),I=1,NEQ),COMIN
      IF (ICASE.LE.2)THEN
         IOUT=NEQ*NPEQ
         WRITE (IGFL) (CM(I),I=1,IOUT)
      ELSE IF(ICASE.EQ.3)THEN
         IOUT=NPBLK*NEQ
         DO 6 IREC=1,NBLOKS
         CALL RECIN(CM,11,1,IOUT,IREC,'Read for ICASE=3 in GFOUT')
6        WRITE(IGFL)(CM(I),I=1,IOUT)
      ELSE IF(ICASE.EQ.4)THEN
         IOUT=NPEQ*NPEQ
         DO 4 K=1,NOP
         CALL RECIN(CM,11,1,IOUT,K,'Read for ICASE=4 in GFOUT')
4        WRITE (IGFL) (CM(J),J=1,IOUT)
      ELSE IF(ICASE.EQ.5)THEN
         IOUT=NPSYM*NPEQ
         IREC=0
         DO 11 IOP=1,NOP
         DO 9 I=1,NBLSYM
         IREC=IREC+1
         CALL RECIN(CM,11,1,IOUT,IREC,'Read for ICASE=5 in GFOUT')
9        WRITE(IGFL)(CM(J),J=1,IOUT)
11       CONTINUE
      END IF
      REWIND IGFL
      WRITE(3,13) NGFFIL(1:70),IMAT
      RETURN
C
13    FORMAT (///,' ****NUMERICAL GREEN''S FUNCTION WRITTEN ON FILE ',
     &A,/,5X,'MATRIX STORAGE -',I7,' COMPLEX NUMBERS',///)
      END
      SUBROUTINE GH (Z,RKJ)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     GH evaluates the integrand for H field of a wire.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 XKJ,RKJ
      COMMON /TMH/ XKJ,ZP,RH2
      RS=Z-ZP
      RS=RH2+RS*RS
      R=SQRT(RS)
      RKJ=XKJ*R
      RKJ=(1.+RKJ)*EXP(-RKJ)/(RS*R)
      RETURN
      END
      SUBROUTINE GNDEF (RHOX,ZSX,ZOX,IDIRX,ERV,EZV,ERH,EPH,EZH)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     GNDEF returns the field at RHO,ZO due to a source at ZS on
C     the Z axis.  Any positions of source and observer with respect
C     to the interface are allowed.  Asymptotic approx. is used for
C     points outside of the interpolation/l.s. approximation region.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 ERV,EZV,ERH,EPH,EZH,DRV,DZV,DRH,DPH,DZH,RRV,RZV,RRH,
     &RPH,RZH,SAV,CK1,CK1SQ,CK2,CK2SQ,CKS12,CON1,CON2,CON3,CON4,EPSC1,
     &XJK,CK
      COMMON /GNRZZ/ CK1,CK1SQ,CK2,CK2SQ,CKS12,CON1,CON2,CON3,CON4,EPSC1
     &,XJK,RHO,ZS,ZO,ZZ,ZZP,AZP,ICASE
      COMMON /GREGON/ RHOA(3),RHOB(3),ZZA(3),ZZB(3),ZPA(3),ZPB(3),ELM,EL
     &MX,SCFAC,RHMX1,ZZMX1,ZPMX1,RHMX2,ZZMX2,ZPMX2,ZPMXX
      COMMON/GLOCK/IGLOCK
C     IRT=1 FOR SOURCE Z .LT. 0., OBS Z .GE. 0.
C     IRT=2 FOR SOURCE Z .GE. 0., OBS Z .LT. 0.
C     IRT=3/4 FOR REFLECTED FIELD ABOVE/BELOW GROUND
      RHO=RHOX
      ZS=ZSX
      ZO=ZOX
      IF (ZS.GE.0.) GO TO 1
      IF (ZO.GE.0.) IRT=1
      IF (ZO.LT.0.) IRT=4
      GO TO 2
1     IF (ZO.GE.0.) IRT=3
      IF (ZO.LT.0.) IRT=2
2     GO TO (3,4,5,6), IRT
3     ZZ=ZO
      ZZP=ZS
      GO TO 7
4     ZZ=ZS
      ZZP=ZO
      GO TO 7
5     ZZ=ZS+ZO
      ZZP=0.
      CK=CK2
      GO TO 7
6     ZZ=0.
      ZZP=ZS+ZO
      CK=CK1
7     AZP=-ZZP
C
C     SOMMERFELD TERM,  CHOICE OF INTERPOLATION/L.S. APPROX. OR
C     ASYMPTOTIC APPROX.
      IF(IGLOCK.EQ.2)GO TO 15
      IF(IGLOCK.EQ.3)GO TO 8
      IF (IDIRX.EQ.-1) GO TO 8
      IF (RHO.GT.RHMX2) GO TO 8
      IF (ZZ.GT.ZZMX2) GO TO 8
      IF (-ZZP.GT.ZPMXX) GO TO 8
      IF (-ZZP.GT.ZPMX2.AND.RHO.GT.ELM) GO TO 8
15    IREG=0
      ICASE=3
      CALL TRXFLD (ERV,EZV,ERH,EPH,EZH,IREG)
      IF(IGLOCK.EQ.1)IGLOCK=2
      GO TO 9
8     CALL GEASY (RHO,ZZ,ZZP,ERV,EZV,ERH,EPH,EZH)
      IF(IGLOCK.EQ.1)IGLOCK=3
9     GO TO (11,10,12,12), IRT
10    SAV=ERV
      ERV=-EZH
      EZH=-SAV
11    RETURN
C
C     IMAGE TERM FOR REFLECTED FIELD
12    CALL GFDIR (RHO,ZS,-ZO,CK2,CK,RRV,RZV,RRH,RPH,RZH)
      IF (IDIRX.EQ.1) GO TO 13
C
C     DIRECT FIELD TERM IF IDIRX.NE.1
      CALL GFDIR (RHO,ZS,ZO,CK2,CK,DRV,DZV,DRH,DPH,DZH)
      RRV=RRV-DRV
      RZV=RZV-DZV
      RRH=RRH-DRH
      RPH=RPH-DPH
      RZH=RZH-DZH
13    IF (IRT.EQ.4) GO TO 14
      SAV=ERV
      ERV=-EZH-RRV
      EZV=EPSC1*EZV-RZV
      ERH=ERH-RRH
      EPH=EPH-RPH
      EZH=-EPSC1*SAV-RZH
      RETURN
14    ERV=ERV-RRV
      EZV=EZV/EPSC1-RZV
      ERH=ERH-RRH
      EPH=EPH-RPH
      EZH=EZH/EPSC1-RZH
      RETURN
      END
      SUBROUTINE GNDNEW(IFLN,SOMFIX)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     GNDNEW opens a file for writing the Sommerfeld integral tables
C     and calls GNDOUT to write the file.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER SOMFIX*(*)
      CLOSE(UNIT=IFLN,ERR=1)
1     OPEN(UNIT=IFLN,FILE=SOMFIX,STATUS='unknown',FORM='UNFORMATTED',
     &ERR=2)
      CALL GNDOUT (IFLN)
      CLOSE(IFLN)
      RETURN
2     WRITE(3,90)SOMFIX
      STOP
C
90    FORMAT(' GNDNEW: ERROR OPENING FILE FOR OUTPUT: ',A)
      END
      SUBROUTINE GNDINO(EPSXX,IFLN)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     GNDINO reads the file of interpolation tables and least-squares
C     approximation parameters and sets other related constants.
C
C     INPUT:
C     EPSXX = COMPLEX RELATIVE PERMITTIVITY OF THE GROUND
C     IFLN = LOGICAL UNIT NUMBER OF THE FILE TO BE READ FROM THE
C            SOMMERFELD GROUND FILE OR NGF FILE.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER SOMFIL*40,SOMFIX*40,FNUM*5,FSUF*10
      COMPLEX*16 FAC1,FAC2,FAC3,FAC4,FAC5,A1,A2,A3,A4,A5,CK1,CK1SQ,CK2,
     &CK2SQ,CKS12,CON1,CON2,CON3,CON4,XJK,EPSC1,EPSXX,EPSCX
      COMMON /COFIT/ FAC1(32,3),FAC2(32,3),FAC3(32,3),FAC4(32,3),
     &FAC5(32,3),RKFAC,MFUNF(3),MFUNC(3)
      COMMON /GREGON/ RHOA(3),RHOB(3),ZZA(3),ZZB(3),ZPA(3),ZPB(3),ELM,EL
     &MX,SCFAC,RHMX1,ZZMX1,ZPMX1,RHMX2,ZZMX2,ZPMX2,ZPMXX
      COMMON /GRIDY/ A1(1200),A2(1200),A3(1200),A4(1200),A5(1200),RH1(3)
     &,ZZ1(3),ZP1(3),DRH(3),DZZ(3),DZP(3),DRZZP(3),ZPM1,ZPM2,ZPMM1,
     &ZPMM2,ZPD1,ZPD2,NRH(3),NZZ(3),NZP(3),NPT(3),INDI(3)
      COMMON /GNRZZ/ CK1,CK1SQ,CK2,CK2SQ,CKS12,CON1,CON2,CON3,CON4,EPSC1
     &,XJK,RHO,ZS,ZO,ZZ,ZZP,AZP,ICASE
      COMMON /GNDCOM/ EPSCX,XRH1,DXRH,XZZ1,DXZZ,XZP1,DXZP,SRH1,DSRH,
     &SZZ1,DSZZ,SZP1,DSZP,RES1,RES2,RES3,RES4,RES5,REX1,REX2,REX3,REX4,
     &REX5,NREG,NXRH,NXZZ,NXZP,NSRH,NSZZ,NSZP
      COMMON /GNDFIL/NSFILE,SOMFIL
      DATA PI/3.141592654D0/
      IF(IFLN.EQ.21)THEN
         IF(ABS((EPSCX-EPSXX)/EPSXX).LT.1.E-4)RETURN
         IF(NSFILE.GT.0)THEN
            IDOT=INDEX(SOMFIL,'.')
            IBLK=INDEX(SOMFIL,' ')
            IF(IDOT.GT.0)THEN
               FSUF=SOMFIL(IDOT:IBLK-1)
            ELSE
               FSUF='.NEC'
               IDOT=IBLK
            END IF
            WRITE(FNUM,'(I5)')NSFILE
            IX=5
            IF(NSFILE.GT.9)IX=4
            IF(NSFILE.GT.99)IX=3
            SOMFIX=SOMFIL(1:IDOT-1)//FNUM(IX:5)//FSUF
         ELSE
            SOMFIX=SOMFIL
         END IF
         NSFILE=NSFILE+1
         OPEN(UNIT=IFLN,FILE=SOMFIX,STATUS='OLD',FORM='UNFORMATTED',
     &   ERR=4)
      END IF
      GO TO 1
4     WRITE(3,90)SOMFIX
      WRITE(3,93)
      CALL SOMNTX(EPSXX,0)
      EPSCX=EPSXX
      NREG=3
      IF(SOMFIL.NE.'NOFILE')CALL GNDNEW(IFLN,SOMFIX)
      GO TO 5
C
C     READ L.S. FIT FILE
C
1     READ (IFLN) NREG,EPSCX
      IF (ABS((EPSCX-EPSXX)/EPSXX).GT.1.E-3)THEN
         WRITE(3,91) EPSCX,EPSXX
         IF(IFLN.NE.21)THEN
            WRITE(3,92)
            STOP
         END IF
         WRITE(3,93)
         CALL SOMNTX(EPSXX,0)
         EPSCX=EPSXX
         NREG=3
         IF(SOMFIL.NE.'NOFILE')CALL GNDNEW(IFLN,SOMFIX)
      ELSE
         DO 3 IR=1,NREG
         READ (IFLN) XRH1,DXRH,NXRH,XZZ1,DXZZ,NXZZ,XZP1,DXZP,NXZP
         READ (IFLN) SRH1,DSRH,NSRH,SZZ1,DSZZ,NSZZ,SZP1,DSZP,NSZP
         READ (IFLN) RHOA(IR),RHOB(IR),ZZA(IR),ZZB(IR),ZPA(IR),ZPB(IR)
         READ (IFLN) RES1,RES2,RES3,RES4,RES5,REX1,REX2,REX3,REX4,REX5
         READ (IFLN) MFUNF(IR),MFUNC(IR)
         MFUN=MFUNF(IR)+MFUNC(IR)
         DO 2 I=1,MFUN
2        READ (IFLN) FAC1(I,IR),FAC2(I,IR),FAC3(I,IR),FAC4(I,IR),
     &   FAC5(I,IR)
3        CONTINUE
C
C        READ INTERPOLATION FILE
C
         READ (IFLN) EPSCX,RH1,ZZ1,ZP1,DRH,DZZ,DZP,DRZZP,NRH,NZZ,NZP,NPT
         IF (ABS((EPSCX-EPSXX)/EPSXX).GT.1.E-3) THEN
            WRITE(3,91) EPSCX,EPSXX
            STOP
         END IF
         NPTS=NPT(1)+NPT(2)+NPT(3)
         READ (IFLN) (A1(IX),IX=1,NPTS)
         READ (IFLN) (A2(IX),IX=1,NPTS)
         READ (IFLN) (A3(IX),IX=1,NPTS)
         READ (IFLN) (A4(IX),IX=1,NPTS)
         READ (IFLN) (A5(IX),IX=1,NPTS)
      END IF
5     ZPM1=ZP1(1)+DZP(1)*(NZP(1)-1)
      ZPM2=ZP1(2)+DZP(2)*(NZP(2)-1)
      ZPMM1=ZP1(2)
      ZPMM2=ZP1(3)
      ZPD1=PI/(ZPM1-ZPMM1)
      ZPD2=PI/(ZPM2-ZPMM2)
      INDI(1)=0
      INDI(2)=NPT(1)
      INDI(3)=NPT(1)+NPT(2)
      CK2=2.*PI
      CK1=CK2*SQRT(EPSXX)
      CK1SQ=CK1*CK1
      CK2SQ=CK2*CK2
      CKS12=CK1SQ+CK2SQ
      CON1=-(0.,188.37)
      CON2=(CK1SQ-CK2SQ)/CKS12
      CON3=CK2SQ*CON2/CKS12
      CON4=2.*CON1*CK2SQ/CKS12
      XJK=(0.,1.)*CK2
      EPSC1=EPSXX
      RKFAC=ABS(CK2/CK1)
      ELM=DRH(1)*(NRH(1)-1)
      ELMX=.95*ELM
C     SET LIMITS FOR INTEGRATION AND USE OF ASYMPTOTIC.  ZPMXX ALLOWS
C     EXTRAPOLATION BY ONE INTERVAL (DZP).
      RHMX1=1.
      ZZMX1=1.
      ZPMX1=ZPB(1)
      RHMX2=2.
      ZZMX2=2.
      ZPMX2=ZPB(1)*1.2
      ZPMXX=ZP1(3)+DZP(3)*NZP(3)
      SCFAC=PI/(ELM-ELMX)
      RETURN
C
90    FORMAT(/,' GNDINO: UNABLE TO OPEN FILE ',A)
91    FORMAT(/,' GNDINO: EPSC FROM FILE =',1P2E12.5,/,14X,'SHOULD BE ',
     &2E12.5)
92    FORMAT(' GNDINO: ERROR READING SOMNTX FILE')
93    FORMAT(' WILL COMPUTE SOMMERFELD-GROUND TABLES')
      END
      SUBROUTINE GNDOUT (IFLN)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     GNDOUT writes the Sommerfeld interpolation tables and
C     least-squares approximation parameters on a file using logical
C     unit number IFLN
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 FAC1,FAC2,FAC3,FAC4,FAC5,A1,A2,A3,A4,A5,EPSCX
      COMMON /COFIT/ FAC1(32,3),FAC2(32,3),FAC3(32,3),FAC4(32,3),
     &FAC5(32,3),RKFAC,MFUNF(3),MFUNC(3)
      COMMON /GREGON/ RHOA(3),RHOB(3),ZZA(3),ZZB(3),ZPA(3),ZPB(3),ELM,EL
     &MX,SCFAC,RHMX1,ZZMX1,ZPMX1,RHMX2,ZZMX2,ZPMX2,ZPMXX
      COMMON /GRIDY/ A1(1200),A2(1200),A3(1200),A4(1200),A5(1200),RH1(3)
     &,ZZ1(3),ZP1(3),DRH(3),DZZ(3),DZP(3),DRZZP(3),ZPM1,ZPM2,ZPMM1,
     &ZPMM2,ZPD1,ZPD2,NRH(3),NZZ(3),NZP(3),NPT(3),INDI(3)
      COMMON /GNDCOM/ EPSCX,XRH1,DXRH,XZZ1,DXZZ,XZP1,DXZP,SRH1,DSRH,
     &SZZ1,DSZZ,SZP1,DSZP,RES1,RES2,RES3,RES4,RES5,REX1,REX2,REX3,REX4,
     &REX5,NREG,NXRH,NXZZ,NXZP,NSRH,NSZZ,NSZP
C
      WRITE (IFLN) NREG,EPSCX
      DO 7 IR=1,NREG
      WRITE (IFLN) XRH1,DXRH,NXRH,XZZ1,DXZZ,NXZZ,XZP1,DXZP,NXZP
      WRITE (IFLN) SRH1,DSRH,NSRH,SZZ1,DSZZ,NSZZ,SZP1,DSZP,NSZP
      WRITE (IFLN) RHOA(IR),RHOB(IR),ZZA(IR),ZZB(IR),ZPA(IR),ZPB(IR)
      WRITE (IFLN) RES1,RES2,RES3,RES4,RES5,REX1,REX2,REX3,REX4,REX5
      WRITE (IFLN) MFUNF(IR),MFUNC(IR)
      MFUN=MFUNF(IR)+MFUNC(IR)
      DO 6 I=1,MFUN
6     WRITE (IFLN)FAC1(I,IR),FAC2(I,IR),FAC3(I,IR),FAC4(I,IR),FAC5(I,IR)
7     CONTINUE
      WRITE (IFLN) EPSCX,RH1,ZZ1,ZP1,DRH,DZZ,DZP,DRZZP,NRH,NZZ,NZP,NPT
      NPTS=NPT(1)+NPT(2)+NPT(3)
      WRITE (IFLN) (A1(IX),IX=1,NPTS)
      WRITE (IFLN) (A2(IX),IX=1,NPTS)
      WRITE (IFLN) (A3(IX),IX=1,NPTS)
      WRITE (IFLN) (A4(IX),IX=1,NPTS)
      WRITE (IFLN) (A5(IX),IX=1,NPTS)
      RETURN
      END
      SUBROUTINE HELIX(IHLX,TURNS,ZLEN,HRAD1,HRAD2,WRAD1,WRAD2,NS,ITG)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
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
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      DIMENSION X2(MAXSEG), Y2(MAXSEG), Z2(MAXSEG)
      EQUIVALENCE (X2(1),SI(1)), (Y2(1),ALP(1)), (Z2(1),BET(1))
      DATA TP/6.2831853071796D0/
      IST=N+1
      N=N+NS
      NP=N
      MP=M
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
      WRITE(3,90)SUM
90    FORMAT(10X,'TOTAL LENGTH OF WIRE IN THE SPIRAL = ',1PE12.5)
      RETURN
      END
      SUBROUTINE HINTG (XI,YI,ZI)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     HINTG computes the H field of current on a patch.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 H1X,H1Y,H1Z,H2X,H2Y,H2Z,XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,
     &ETAL2,FRATI,XK,RKJ,GAM,HXC,HYC,HZC,F1X,F1Y,F1Z,F2X,F2Y,F2Z,ZRATI,
     &RRV,RRH
      COMMON/DATAP/H1X,H1Y,H1Z,H2X,H2Y,H2Z,SPATJ,XPATJ,YPATJ,ZPATJ,T1XJ,
     &T1YJ,T1ZJ,T2XJ,T2YJ,T2ZJ,IPGND
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      DATA FPI/12.56637062D0/
      IF (ZPATJ.LT.0.) GO TO 1
      XK=XKU
      GO TO 2
1     XK=XKL
2     RX=XI-XPATJ
      RY=YI-YPATJ
      RFL=-1.
      H1X=(0.,0.)
      H1Y=(0.,0.)
      H1Z=(0.,0.)
      H2X=(0.,0.)
      H2Y=(0.,0.)
      H2Z=(0.,0.)
      DO 7 IP=1,KSYMP
      RFL=-RFL
      RZ=ZI-ZPATJ*RFL
      RSQ=RX*RX+RY*RY+RZ*RZ
      IF (RSQ.LT.1.E-20) GO TO 7
      R=SQRT(RSQ)
      RKJ=(0.,1.)*XK*R
      GAM=-(1.+RKJ)*EXP(-RKJ)*SPATJ/(FPI*RSQ*R)
      HXC=GAM*RX
      HYC=GAM*RY
      HZC=GAM*RZ
      T1ZR=T1ZJ*RFL
      T2ZR=T2ZJ*RFL
      F1X=HYC*T1ZR-HZC*T1YJ
      F1Y=HZC*T1XJ-HXC*T1ZR
      F1Z=HXC*T1YJ-HYC*T1XJ
      F2X=HYC*T2ZR-HZC*T2YJ
      F2Y=HZC*T2XJ-HXC*T2ZR
      F2Z=HXC*T2YJ-HYC*T2XJ
      IF (IP.EQ.1) GO TO 6
      IF (IPERF.NE.1) GO TO 3
      F1X=-F1X
      F1Y=-F1Y
      F1Z=-F1Z
      F2X=-F2X
      F2Y=-F2Y
      F2Z=-F2Z
      GO TO 6
3     ZRATI=XKU/XKL
      IF (ZPATJ.LT.0.) ZRATI=XKL/XKU
      XYMAG=SQRT(RX*RX+RY*RY)
      IF (XYMAG.GT.1.E-10) GO TO 4
      PX=0.
      PY=0.
      CTH=1.
      RRV=(1.,0.)
      GO TO 5
4     PX=-RY/XYMAG
      PY=RX/XYMAG
      CTH=ABS(RZ)/R
      RRV=SQRT(1.-ZRATI*ZRATI*(1.-CTH*CTH))
5     RRH=ZRATI*CTH
      RRH=(RRH-RRV)/(RRH+RRV)
      RRV=ZRATI*RRV
      RRV=-(CTH-RRV)/(CTH+RRV)
      GAM=(F1X*PX+F1Y*PY)*(RRV-RRH)
      F1X=F1X*RRH+GAM*PX
      F1Y=F1Y*RRH+GAM*PY
      F1Z=F1Z*RRH
      GAM=(F2X*PX+F2Y*PY)*(RRV-RRH)
      F2X=F2X*RRH+GAM*PX
      F2Y=F2Y*RRH+GAM*PY
      F2Z=F2Z*RRH
6     H1X=H1X+F1X
      H1Y=H1Y+F1Y
      H1Z=H1Z+F1Z
      H2X=H2X+F2X
      H2Y=H2Y+F2Y
      H2Z=H2Z+F2Z
7     CONTINUE
      RETURN
      END
      SUBROUTINE HSFLD (XI,YI,ZI)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     HSFLD computes the H field for constant, sine, and cosine current
C     On a segment including ground effects.  The thin-wire approx. is
C     implemented with a filament of current on the wire axis.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 XKSJ,EXK,EYK,EZK,EXS,EYS,EZS,EXC,EYC,EZC,ZPEDS,ZRATI,
     &HPK,HPS,HPC,QX,QY,QZ,RRV,RRH,ZRATX,XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,
     &FRATI,ETAL2,XK,ETX
      COMMON /DATAJ/ XKSJ,EXK,EYK,EZK,EXS,EYS,EZS,EXC,EYC,EZC,ZPEDS,
     &SLENJ,ARADJ,XJ,YJ,ZJ,DXJ,DYJ,DZJ,IND1,IND2
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      COMMON/CONSTN/PI,TP,DTORAD,CVEL,EPSRZ,RMUZ,ETAZ
      IF (ZJ.GE.0.)THEN
         XK=XKU
         ETX=ETAU
      ELSE
         XK=XKL
         ETX=ETAL
      END IF
      XIJ=XI-XJ
      YIJ=YI-YJ
      RFL=-1.
      DO 9 IP=1,KSYMP
      RFL=-RFL
      SALPR=DZJ*RFL
      ZIJ=ZI-RFL*ZJ
      ZP=XIJ*DXJ+YIJ*DYJ+ZIJ*SALPR
      RHOX=XIJ-DXJ*ZP
      RHOY=YIJ-DYJ*ZP
      RHOZ=ZIJ-SALPR*ZP
      RH=SQRT(RHOX*RHOX+RHOY*RHOY+RHOZ*RHOZ)
C
C     SET H FIELD TO ZERO INSIDE THE SEGMENT
C
      IF(RH.LT.0.999*ARADJ)THEN
         EXK=(0.,0.)
         EYK=(0.,0.)
         EZK=(0.,0.)
         EXS=(0.,0.)
         EYS=(0.,0.)
         EZS=(0.,0.)
         EXC=(0.,0.)
         EYC=(0.,0.)
         EZC=(0.,0.)
         GO TO 9
      END IF
      RHOX=RHOX/RH
      RHOY=RHOY/RH
      RHOZ=RHOZ/RH
      PHX=DYJ*RHOZ-SALPR*RHOY
      PHY=SALPR*RHOX-DXJ*RHOZ
      PHZ=DXJ*RHOY-DYJ*RHOX
      CALL HSFLX (SLENJ,RH,ZP,XK,HPK,HPS,HPC)
C
C     STORE DIRECT FIELD COMPONENT
C
      IF (IP.NE.2)THEN
         EXK=HPK*PHX
         EYK=HPK*PHY
         EZK=HPK*PHZ
         EXS=HPS*PHX
         EYS=HPS*PHY
         EZS=HPS*PHZ
         EXC=HPC*PHX
         EYC=HPC*PHY
         EZC=HPC*PHZ
         GO TO 9
      END IF
C
C     ADD IMAGE FIELD FOR PERFECT GROUND
C
      IF (IPERF.EQ.1)THEN
         EXK=EXK-HPK*PHX
         EYK=EYK-HPK*PHY
         EZK=EZK-HPK*PHZ
         EXS=EXS-HPS*PHX
         EYS=EYS-HPS*PHY
         EZS=EZS-HPS*PHZ
         EXC=EXC-HPC*PHX
         EYC=EYC-HPC*PHY
         EZC=EZC-HPC*PHZ
         GO TO 9
      END IF
C
C     ADD IMAGE FIELD FOR FINITELY CONDUCTING GROUND, REFLECTION COEF.
C
      IF(ZJ.GT.0.)THEN
         ZRATI=XKU/XKL
      ELSE
         ZRATI=XKL/XKU
      END IF
      ZRATX=ZRATI
      RMAG=SQRT(ZP*ZP+RH*RH)
      XYMAG=SQRT(XIJ*XIJ+YIJ*YIJ)
C
C     SET PARAMETERS FOR RADIAL WIRE GROUND SCREEN.
C
      IF (NRADL.GT.0)THEN
         XSPEC=(XI*ZJ+ZI*XJ)/(ZI+ZJ)
         YSPEC=(YI*ZJ+ZI*YJ)/(ZI+ZJ)
         RHOSPC=SQRT(XSPEC*XSPEC+YSPEC*YSPEC+(NRADL*SCNWRD)**2)
         IF (RHOSPC.LE.SCNRAD)THEN
            RRV=(0.,1.)*RMUZ*OMEGAG*RHOSPC/NRADL*LOG(RHOSPC/(NRADL*
     &      SCNWRD))
            ZRATX=(RRV*ZRATI)/(ETX*ZRATI+RRV)
         END IF
      END IF
C
C     CALCULATION OF REFLECTION COEFFICIENTS WHEN GROUND IS SPECIFIED.
C
      IF (XYMAG.GT.1.E-10)THEN
         PX=-YIJ/XYMAG
         PY=XIJ/XYMAG
         CTH=ABS(ZIJ)/RMAG
         RRV=SQRT(1.-ZRATX*ZRATX*(1.-CTH*CTH))
      ELSE
         PX=0.
         PY=0.
         CTH=1.
         RRV=(1.,0.)
      END IF
      RRH=ZRATX*CTH
      RRH=-(RRH-RRV)/(RRH+RRV)
      RRV=ZRATX*RRV
      RRV=(CTH-RRV)/(CTH+RRV)
      QY=(PHX*PX+PHY*PY)*(RRV-RRH)
      QX=QY*PX+PHX*RRH
      QY=QY*PY+PHY*RRH
      QZ=PHZ*RRH
      EXK=EXK-HPK*QX
      EYK=EYK-HPK*QY
      EZK=EZK-HPK*QZ
      EXS=EXS-HPS*QX
      EYS=EYS-HPS*QY
      EZS=EZS-HPS*QZ
      EXC=EXC-HPC*QX
      EYC=EYC-HPC*QY
      EZC=EZC-HPC*QZ
9     CONTINUE
      RETURN
      END
      SUBROUTINE INTREG (ERV,EZV,ERH,EPH,EZH)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     INTREG determines which interpolation grid to use and smooths the
C     transitions.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 ERV,EZV,ERH,EPH,EZH,FRV,FZV,FRH,FPH,FZH,A1,A2,A3,A4,
     &A5,CK1,CK2,CK1SQ,CK2SQ,CKS12,CON1,CON2,CON3,CON4,EPSC1,XJK
      COMMON /GRIDY/ A1(1200),A2(1200),A3(1200),A4(1200),A5(1200),RH1(3)
     &,ZZ1(3),ZP1(3),DRH(3),DZZ(3),DZP(3),DRZZP(3),ZPM1,ZPM2,ZPMM1,
     &ZPMM2,ZPD1,ZPD2,NRH(3),NZZ(3),NZP(3),NPT(3),INDI(3)
      COMMON /GNRZZ/ CK1,CK1SQ,CK2,CK2SQ,CKS12,CON1,CON2,CON3,CON4,EPSC1
     &,XJK,RHO,ZS,ZO,ZZ,ZZP,AZP,ICASE
      IF (AZP.GT.ZPM1) GO TO 2
      CALL INTRPC (1,ERV,EZV,ERH,EPH,EZH)
      IF (AZP.LT.ZPMM1) RETURN
      CALL INTRPC (2,FRV,FZV,FRH,FPH,FZH)
      COSX=.5*(1.+COS(ZPD1*(AZP-ZPMM1)))
      GO TO 3
2     IF (AZP.GT.ZPM2) GO TO 4
      CALL INTRPC (2,ERV,EZV,ERH,EPH,EZH)
      IF (AZP.LT.ZPMM2) RETURN
      CALL INTRPC (3,FRV,FZV,FRH,FPH,FZH)
      COSX=.5*(1.+COS(ZPD2*(AZP-ZPMM2)))
3     ERV=(ERV-FRV)*COSX+FRV
      EZV=(EZV-FZV)*COSX+FZV
      ERH=(ERH-FRH)*COSX+FRH
      EPH=(EPH-FPH)*COSX+FPH
      EZH=(EZH-FZH)*COSX+FZH
      RETURN
4     CALL INTRPC (3,ERV,EZV,ERH,EPH,EZH)
      RETURN
      END
      SUBROUTINE INTRPC (KREG,ERV,EZV,ERH,EPH,EZH)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     INTRPC converts the transmitted field for a buried source to the
C     reflected or transmitted field specified by ICASE. The static
C     terms are omitted from the reflected field.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 ERV,EZV,ERH,EPH,EZH,RRV,RZV,RRH,RPH,RZH,CK1,CK1SQ,CK2,
     &CK2SQ,CKS12,CON1,CON2,CON3,CON4,EPSC1,XJK,RF1,RF2,RF3,RF4,CONS,
     &XKR1,XKR2,EKR1,EKR2,EXJK,SAV
      COMMON /GNRZZ/ CK1,CK1SQ,CK2,CK2SQ,CKS12,CON1,CON2,CON3,CON4,EPSC1
     &,XJK,RHO,ZS,ZO,ZZ,ZZP,AZP,ICASE
      CALL INTRPD (KREG,ERV,EZV,ERH,EPH,EZH)
      GO TO (1,3,7,7), ICASE
C     REFLECTED FIELD ABOVE GROUND
1     IF (KREG.GT.1) GO TO 2
      R=SQRT(RHO*RHO+ZZ*ZZ)
      EXJK=CON4*EXP(-XJK*R)/R
      SAV=ERV
      ERV=-EZH
      EZV=EPSC1*EZV
      ERH=ERH-EXJK
      EPH=EPH+EXJK
      EZH=-EPSC1*SAV
      RETURN
2     CALL GFDIR (RHO,-ZS,ZO,CK2,CK2,RRV,RZV,RRH,RPH,RZH)
      SAV=ERV
      ERV=-EZH+RRV-CON2*RRV
      EZV=EPSC1*EZV-RZV-CON2*RZV
      ERH=ERH-RRH+CON2*RRH
      EPH=EPH-RPH+CON2*RPH
      EZH=-EPSC1*SAV+RZH+CON2*RZH
      RETURN
C     REFLECTED FIELD BELOW GROUND
3     IF (KREG.GT.1) GO TO 6
      ZMP=ZO+ZS
      RSQ=RHO*RHO+ZMP*ZMP
      R=SQRT(RSQ)
      CONS=2.*CON1/(CKS12*R)
      XKR1=-(0.,1.)*CK1*R
      XKR2=-(0.,1.)*CK2*R
      EKR1=EXP(XKR1)
      EKR2=EXP(XKR2)
      IF (ABS(CK1*R).LT.0.1) GO TO 4
      RF1=((1.-XKR1)*EKR1-(1.-XKR2)*EKR2)*CONS/RSQ
      GO TO 5
4     RF1=(((.0333333*XKR1+.125)*XKR1+.33333333)*XKR1+.5)*CK1SQ
      RF2=(((.0333333*XKR2+.125)*XKR2+.33333333)*XKR2+.5)*CK2SQ
      RF1=(RF1-RF2)*CONS
5     RF2=(CK1SQ*EKR1-CK2SQ*EKR2)*CONS
      RF3=(3.*RF1-RF2)/RSQ
      RF4=CONS*CK1SQ*EKR1
      ERV=ERV+RHO*ZMP*RF3
      EZV=(EZV-(ZMP*ZMP*RF3-RF1+RF2))/EPSC1
      ERH=ERH-(RHO*RHO*RF3-RF1)-RF4
      EPH=EPH-RF1+RF4
      EZH=-ERV
      RETURN
6     CALL GFDIR (RHO,-ZS,ZO,CK2,CK1,RRV,RZV,RRH,RPH,RZH)
      ERV=ERV+RRV+CON2*RRV
      EZV=EZV/EPSC1-RZV+CON2*RZV
      ERH=ERH-RRH-CON2*RRH
      EPH=EPH-RPH-CON2*RPH
      EZH=EZH/EPSC1+RZH-CON2*RZH
      RETURN
C     TRANSMITTED FIELD.  STATIC TERMS ADDED FOR KREG.EQ.1
7     IF (KREG.GT.1) GO TO 8
      ZMP=ZZ-ZZP
      RSQ=RHO*RHO+ZMP*ZMP
      R=SQRT(RSQ)
      EXJK=2.*CON1*EXP(-XJK*R)/(RSQ*R*CKS12)
      RF1=3./RSQ+3.*XJK/R-CK2SQ
      RF2=XJK*R+1.
      SAV=RHO*ZMP*RF1*EXJK
      ERV=ERV+SAV
      EZV=EZV+(ZMP*ZMP*RF1-RF2+CK2SQ*RSQ)*EXJK
      ERH=ERH+(RHO*RHO*RF1-RF2)*EXJK
      EPH=EPH+RF2*EXJK
      EZH=EZH+SAV
8     IF (ICASE.EQ.3) RETURN
      SAV=ERV
      ERV=-EZH
      EZH=-SAV
      RETURN
      END
      SUBROUTINE INTRPD (KREG,E1,E2,E3,E4,E5)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     INTRPD obtains field values by 3 dim. interpolation.  The 1./R
C     terms are added for KREG.EQ.1 and the values are multiplied by
C     required 1./R and exponential factors for each KREG.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 E1,E2,E3,E4,E5,A1,A2,A3,A4,A5,CK1,CK1SQ,CK2,CK2SQ,
     &CKS12,CON1,CON2,CON3,CON4,EPSC1,XJK,EXJK,F1,F2,F3,F4,F5
      COMMON /GRIDY/ A1(1200),A2(1200),A3(1200),A4(1200),A5(1200),RH1(3)
     &,ZZ1(3),ZP1(3),DRH(3),DZZ(3),DZP(3),DRZZP(3),ZPM1,ZPM2,ZPMM1,
     &ZPMM2,ZPD1,ZPD2,NRH(3),NZZ(3),NZP(3),NPT(3),INDI(3)
      COMMON /GNRZZ/ CK1,CK1SQ,CK2,CK2SQ,CKS12,CON1,CON2,CON3,CON4,EPSC1
     &,XJK,RHO,ZS,ZO,ZZ,ZZP,AZP,ICASE
      NDX=NRH(KREG)
      NDY=NZZ(KREG)
      NDZ=NZP(KREG)
      DX=DRH(KREG)
      DY=DZZ(KREG)
      DZ=DZP(KREG)
      DXYZ=DRZZP(KREG)
      X=RHO-RH1(KREG)
      Y=ZZ-ZZ1(KREG)
      Z=AZP-ZP1(KREG)
      IX=INT(X/DX)+1
      IY=INT(Y/DY)+1
      IZ=INT(Z/DZ)+1
      IF (Y.LT.-1.E-6) GO TO 7
      IF (Z.LT.-1.E-6) GO TO 7
      IF (IX.GT.NDX) GO TO 7
      IF (IY.GT.NDY) GO TO 7
      IF (IZ.GT.NDZ.AND.KREG.LT.3) GO TO 7
      IF (IX.EQ.NDX) IX=NDX-1
      IF (IY.EQ.NDY) IY=NDY-1
      IF (IZ.GE.NDZ) IZ=NDZ-1
      I111=NDX*(NDY*(IZ-1)+IY-1)+IX+INDI(KREG)
      I211=I111+1
      I121=I111+NDX
      I221=I121+1
      I112=I111+NDX*NDY
      I212=I112+1
      I122=I112+NDX
      I222=I122+1
      XP=X-IX*DX
      XM=-(XP+DX)
      YP=Y-IY*DY
      YM=-(YP+DY)
      ZP=Z-IZ*DZ
      ZM=-(ZP+DZ)
      XP=-XP/DXYZ
      XM=-XM/DXYZ
      E1=XP*(YP*(ZP*A1(I111)+ZM*A1(I112))+YM*(ZP*A1(I121)+ZM*A1(I122)))+
     &XM*(YP*(ZP*A1(I211)+ZM*A1(I212))+YM*(ZP*A1(I221)+ZM*A1(I222)))
      E2=XP*(YP*(ZP*A2(I111)+ZM*A2(I112))+YM*(ZP*A2(I121)+ZM*A2(I122)))+
     &XM*(YP*(ZP*A2(I211)+ZM*A2(I212))+YM*(ZP*A2(I221)+ZM*A2(I222)))
      E3=XP*(YP*(ZP*A3(I111)+ZM*A3(I112))+YM*(ZP*A3(I121)+ZM*A3(I122)))+
     &XM*(YP*(ZP*A3(I211)+ZM*A3(I212))+YM*(ZP*A3(I221)+ZM*A3(I222)))
      E4=XP*(YP*(ZP*A4(I111)+ZM*A4(I112))+YM*(ZP*A4(I121)+ZM*A4(I122)))+
     &XM*(YP*(ZP*A4(I211)+ZM*A4(I212))+YM*(ZP*A4(I221)+ZM*A4(I222)))
      E5=XP*(YP*(ZP*A5(I111)+ZM*A5(I112))+YM*(ZP*A5(I121)+ZM*A5(I122)))+
     &XM*(YP*(ZP*A5(I211)+ZM*A5(I212))+YM*(ZP*A5(I221)+ZM*A5(I222)))
      ZMP=ZZ+AZP
      RSQ=RHO*RHO+ZMP*ZMP
      GO TO (1,4,5), KREG
1     R=SQRT(RSQ)
      STH=ZMP/R
      CTH=RHO/R
      IF (CTH.LT.0.1) GO TO 2
      SF1=(1.-STH)/CTH
      SF2=SF1/CTH
      GO TO 3
2     SF2=RHO/ZMP
      SF2=.5*(1.-.25*SF2*SF2)/ZMP
      SF1=RHO*SF2
      SF2=R*SF2
3     SF3=STH-SF2
      SFAC=-AZP/R
      F1=CON3*SF1-CON2*SFAC*CTH
      F2=CON3-CON2*SFAC*STH
      F3=CON3*(SF2-1.)+CON2*SFAC*SF3+1.
      F4=(CON3-CON2*SFAC)*SF2-1.
      F5=-CON3*CK1SQ/CK2SQ*SF1-CON2*SFAC*CTH
      EXJK=EXP(-XJK*R)/R
      E1=(E1+F1*CON1)*EXJK
      E2=(E2+F2*CON1)*EXJK
      E3=(E3+F3*CON1)*EXJK
      E4=(E4+F4*CON1)*EXJK
      E5=(E5+F5*CON1)*EXJK
      RETURN
4     RZ=SQRT(RHO*RHO+ZZ*ZZ)
      EXJK=EXP(-(0.,1.)*(CK2*RZ+CK1*AZP))/RSQ
      GO TO 6
5     RZ=SQRT(RHO*RHO+AZP*AZP)
      EXJK=EXP(-(0.,1.)*(CK2*ZZ+CK1*RZ))/RSQ
6     E1=E1*EXJK
      E2=E2*EXJK
      E3=E3*EXJK
      E4=E4*EXJK
      E5=E5*EXJK
      RETURN
7     WRITE(3,8) RHO,ZZ,AZP
      STOP
C
8     FORMAT(' INTRPD: ERROR - POINT OUT OF GRID; RHO,ZZ,AZP=',1P3E12.5)
      END
      FUNCTION ISEGNO (ITAGI,MX)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     ISEGNO returns the segment number of the Mth segment having the
C     tag number ITAGI.  If ITAGI=0 segment number M is returned.
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      IF (MX.EQ.0) THEN
         WRITE(3,6)
         STOP
      END IF
      IF (ITAGI.EQ.0) THEN
         ISEGNO=MX
         RETURN
      END IF
      IF (N.GE.1) THEN
         ICNT=0
         DO 3 I=1,N
         IF (ITAG(I).EQ.ITAGI) THEN
            ICNT=ICNT+1
            IF (ICNT.EQ.MX) THEN
               ISEGNO=I
               RETURN
            END IF
         END IF
3        CONTINUE
      END IF
      WRITE(3,7) ITAGI,MX
      STOP
C
6     FORMAT (4X,'ISEGNO: ERROR - PARAMETER SPECIFYING SEGMENT POSITIO',
     &'N IN A GROUP OF EQUAL TAGS MUST NOT BE ZERO')
7     FORMAT (///,10X,'ISEGNO: ERROR - NO SEGMENT HAS A TAG-SEGMENT',
     &' REFERENCE OF',2I7)
      END
      SUBROUTINE LFACTR (A,NROW,IX1,IX2,IP,NBLOKS,NPBLK,NLAST)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     LFACTR PERFORMS GAUSS-DOOLITTLE MANIPULATIONS ON THE TWO BLOCKS OF
C     THE TRANSPOSED MATRIX IN CORE STORAGE.  THE GAUSS-DOOLITTLE
C     ALGORITHM IS PRESENTED ON PAGES 411-416 OF A. RALSTON -- A FIRST
C     COURSE IN NUMERICAL ANALYSIS.  COMMENTS BELOW REFER TO COMMENTS IN
C     RALSTONS TEXT.
C
C     INPUT:
C     A = ARRAY CONTAINING TWO BLOCKS OF THE MATRIX FOR ELIMINATION
C     NROW = NUMBER OF ROWS IN EACH BLOCK
C     IX1 = NUMBER OF THE FIRST BLOCK STORED IN A
C     IX2 = NUMBER OF THE SECOND BLOCK STORED IN A
C     NBLOKS = NUMBER OF BLOCKS INTO WHICH EACH MATRIX IS DIVIDED
C     NPBLK = NUMBER OF COLUMNS IN THE BLOCKS (EXECPT THE LAST BLOCK)
C     NLAST = NUMBER OF COLUMNS IN THE LAST BLOCK
C
C     OUTPUT:
C     A = ARRAY CONTAINING COMPLETELY OR PARTIALLY FACTORED BLOCKS
C     IP = ARRAY OF PIVOT-ELEMENT INDICES FROM FACTORING
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 A,D,AJR
      INTEGER R,R1,R2,PJ,PR
      LOGICAL L1,L2,L3
      COMMON /SCRATM/ D(2*MAXSEG)
      DIMENSION A(NROW,*), IP(NROW)
      IFLG=0
C
C     INITIALIZE R1,R2,J1,J2
C
      L1=IX1.EQ.1.AND.IX2.EQ.2
      L2=(IX2-1).EQ.IX1
      L3=IX2.EQ.NBLOKS
      IF (L1) GO TO 1
      GO TO 2
1     R1=1
      R2=2*NPBLK
      J1=1
      J2=-1
      GO TO 5
2     R1=NPBLK+1
      R2=2*NPBLK
      J1=(IX1-1)*NPBLK+1
      IF (L2) GO TO 3
      GO TO 4
3     J2=J1+NPBLK-2
      GO TO 5
4     J2=J1+NPBLK-1
5     IF (L3) R2=NPBLK+NLAST
      DO 16 R=R1,R2
C
C     STEP 1
C
      DO 6 K=J1,NROW
      D(K)=A(K,R)
6     CONTINUE
C
C     STEPS 2 AND 3
C
      IF (L1.OR.L2) J2=J2+1
      IF (J1.GT.J2) GO TO 9
      IXJ=0
      DO 8 J=J1,J2
      IXJ=IXJ+1
      PJ=IP(J)
      AJR=D(PJ)
      A(J,R)=AJR
      D(PJ)=D(J)
      JP1=J+1
      DO 7 I=JP1,NROW
      D(I)=D(I)-A(I,IXJ)*AJR
7     CONTINUE
8     CONTINUE
9     CONTINUE
C
C     STEP 4
C
      J2P1=J2+1
      IF (L1.OR.L2) GO TO 11
      IF (NROW.LT.J2P1) GO TO 16
      DO 10 I=J2P1,NROW
      A(I,R)=D(I)
10    CONTINUE
      GO TO 16
11    DMAX=DREAL(D(J2P1)*DCONJG(D(J2P1)))
      IP(J2P1)=J2P1
      J2P2=J2+2
      IF (J2P2.GT.NROW) GO TO 13
      DO 12 I=J2P2,NROW
      ELMAG=DREAL(D(I)*DCONJG(D(I)))
      IF (ELMAG.LT.DMAX) GO TO 12
      DMAX=ELMAG
      IP(J2P1)=I
12    CONTINUE
13    CONTINUE
      IF (DMAX.LT.1.E-10) IFLG=1
      PR=IP(J2P1)
      A(J2P1,R)=D(PR)
      D(PR)=D(J2P1)
C
C     STEP 5
C
      IF (J2P2.GT.NROW) GO TO 15
      AJR=1./A(J2P1,R)
      DO 14 I=J2P2,NROW
      A(I,R)=D(I)*AJR
14    CONTINUE
15    CONTINUE
      IF (IFLG.EQ.0) GO TO 16
      WRITE(3,17) J2,DMAX
      IFLG=0
16    CONTINUE
      RETURN
C
17    FORMAT (' LFACTR: PIVOT(',I3,')=',1PE16.8)
      END
      SUBROUTINE LOAD (FMHZ,XK)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     LOAD calculates the impedance of specified segments for various
C     types of loading.
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 ZARRAY,ZT,ZINT,OMGJ,XK
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON/ZLOAD/ ZARRAY(MAXSEG),NLOAD,NLODF,LDTYP(LOADMX),
     &LDTAG(LOADMX),LDTAGF(LOADMX),LDTAGT(LOADMX),ZLR(LOADMX),
     &ZLI(LOADMX),ZLC(LOADMX)
      COMMON/CONSTN/PI,TP,DTORAD,CVEL,EPSRZ,RMUZ,ETAZ
      OMGJ=(0.,1.E6)*TP*FMHZ
      WLAM=CVEL/(FMHZ*1.E6)
C
C     PRINT HEADING
C
      WRITE(3,25)
C
C     INITIALIZE D ARRAY, USED FOR TEMPORARY STORAGE OF LOADING
C     INFORMATION.
C
      DO 1 I=N2,N
1     ZARRAY(I)=(0.,0.)
      IWARN=0
C
C     CYCLE OVER LOADING COMMANDS
C
      ISTEP=0
2     ISTEP=ISTEP+1
      IF (ISTEP.GT.NLOAD)THEN
         IF (IWARN.EQ.1) WRITE(3,26)
         IF (N1+2*M1.GT.0)RETURN
         NOP=N/NP
         IF (NOP.EQ.1)RETURN
         DO 3 I=1,NP
         ZT=ZARRAY(I)
         L1=I
         DO 3 L2=2,NOP
         L1=L1+NP
3        ZARRAY(L1)=ZT
         RETURN
      END IF
      IF (LDTYP(ISTEP).GT.5)THEN
         WRITE(3,27) LDTYP(ISTEP)
         STOP
      END IF
      LDTAGS=LDTAG(ISTEP)
      JUMP=LDTYP(ISTEP)+1
C
C     SEARCH SEGMENTS FOR PROPER ITAGS
C
      L1=N2
      L2=N
      IF (LDTAGS.EQ.0)THEN
         IF(LDTAGF(ISTEP).NE.0)L1=LDTAGF(ISTEP)
         IF(LDTAGT(ISTEP).NE.0)L2=LDTAGT(ISTEP)
         IF (L1.LE.N1)THEN
            WRITE(3,29)
            STOP
         END IF
         IF(L2.GT.N.OR.L1.GT.L2)THEN
            WRITE(3,30)
            STOP
         END IF
      END IF
      ICHK=0
      DO 17 I=L1,L2
      IF (LDTAGS.NE.0)THEN
         IF (LDTAGS.NE.ITAG(I)) GO TO 17
         IF (LDTAGF(ISTEP).EQ.0)THEN
            ICHK=1
         ELSE
            ICHK=ICHK+1
            IF (ICHK.LT.LDTAGF(ISTEP).OR.ICHK.GT.LDTAGT(ISTEP))GO TO 17
         END IF
      ELSE
         ICHK=1
      END IF
C
C     CALCULATION OF LAMDA*IMPED. PER UNIT LENGTH, JUMP TO APPROPRIATE
C     SECTION FOR LOADING TYPE
C
      IF(JUMP.EQ.1)THEN
         ZT=ZLR(ISTEP)+OMGJ*ZLI(ISTEP)
         IF (ABS(ZLC(ISTEP)).GT.1.E-20) ZT=ZT+1./(OMGJ*ZLC(ISTEP))
      ELSE IF(JUMP.EQ.2)THEN
         ZT=OMGJ*ZLC(ISTEP)
         IF (ABS(ZLI(ISTEP)).GT.1.E-20) ZT=ZT+1./(OMGJ*ZLI(ISTEP))
         IF (ABS(ZLR(ISTEP)).GT.1.E-20) ZT=ZT+1./ZLR(ISTEP)
         ZT=1./ZT
      ELSE IF(JUMP.EQ.3)THEN
         ZT=(ZLR(ISTEP)+OMGJ*ZLI(ISTEP))*SI(I)
         IF (ABS(ZLC(ISTEP)).GT.1.E-20) ZT=ZT+1./(OMGJ*ZLC(ISTEP)*SI(I))
      ELSE IF(JUMP.EQ.4)THEN
         ZT=OMGJ*ZLC(ISTEP)*SI(I)
         IF (ABS(ZLI(ISTEP)).GT.1.E-20) ZT=ZT+1./(OMGJ*ZLI(ISTEP)*SI(I))
         IF (ABS(ZLR(ISTEP)).GT.1.E-20) ZT=ZT+1./(ZLR(ISTEP)*SI(I))
         ZT=1./ZT
      ELSE IF(JUMP.EQ.5)THEN
         ZT=DCMPLX(ZLR(ISTEP),ZLI(ISTEP))
      ELSE IF(JUMP.EQ.6)THEN
         RMU=ZLI(ISTEP)
         IF(RMU.EQ.0.)RMU=1.
         ZT=ZINT(ZLR(ISTEP)*WLAM,RMU,BI(I)/WLAM)*SI(I)/WLAM
      END IF
      IF((ABS(DREAL(ZARRAY(I)))+ABS(DIMAG(ZARRAY(I)))).GT.1.E-20)IWARN=1
      ZARRAY(I)=ZARRAY(I)+ZT/(SI(I)*XK)
17    CONTINUE
      IF (ICHK.EQ.0)THEN
         WRITE(3,28) LDTAGS
         STOP
      END IF
C
C     PRINTING THE SEGMENT LOADING DATA, JUMP TO PROPER PRINT
C
      IF(JUMP.EQ.1)THEN
         CALL PRNT (LDTAGS,LDTAGF(ISTEP),LDTAGT(ISTEP),ZLR(ISTEP),
     &   ZLI(ISTEP),ZLC(ISTEP),0.D0,0.D0,0.D0,' SERIES ')
      ELSE IF(JUMP.EQ.2)THEN
         CALL PRNT (LDTAGS,LDTAGF(ISTEP),LDTAGT(ISTEP),ZLR(ISTEP),
     &   ZLI(ISTEP),ZLC(ISTEP),0.D0,0.D0,0.D0,'PARALLEL')
      ELSE IF(JUMP.EQ.3)THEN
         CALL PRNT (LDTAGS,LDTAGF(ISTEP),LDTAGT(ISTEP),ZLR(ISTEP),
     &   ZLI(ISTEP),ZLC(ISTEP),0.D0,0.D0,0.D0,' SERIES (PER METER) ')
      ELSE IF(JUMP.EQ.4)THEN
         CALL PRNT (LDTAGS,LDTAGF(ISTEP),LDTAGT(ISTEP),ZLR(ISTEP),
     &   ZLI(ISTEP),ZLC(ISTEP),0.D0,0.D0,0.D0,'PARALLEL (PER METER)')
      ELSE IF(JUMP.EQ.5)THEN
         CALL PRNT (LDTAGS,LDTAGF(ISTEP),LDTAGT(ISTEP),0.D0,0.D0,0.D0,
     &   ZLR(ISTEP),ZLI(ISTEP),0.D0,'FIXED IMPEDANCE ')
      ELSE IF(JUMP.EQ.6)THEN
         CALL PRNT (LDTAGS,LDTAGF(ISTEP),LDTAGT(ISTEP),0.D0,0.D0,0.D0,
     &   0.D0,0.D0,ZLR(ISTEP),'  WIRE  ')
      END IF
      GO TO 2
C
25    FORMAT (//,7X,'LOCATION',10X,'RESISTANCE',3X,'INDUCTANCE',2X,
     &'CAPACITANCE',7X,'IMPEDANCE (OHMS)',5X,'CONDUCTIVITY',4X,'TYPE',/,
     &4X,'ITAG',' FROM THRU',10X,'OHMS',8X,'HENRYS',7X,'FARADS',8X,
     &'REAL',6X,'IMAGINARY',4X,'MHOS/METER')
26    FORMAT (/,10X,'NOTE: SOME OF THE ABOVE SEGMENTS HAVE BEEN',
     &' LOADED TWICE - IMPEDANCES ADDED')
27    FORMAT (/,10X,'LOAD: IMPROPER LOAD TYPE CHOSEN, REQUESTED TYPE',
     &' IS ',I3)
28    FORMAT (/,10X,'LOAD: LD COMMAND ERROR, NO SEGMENT HAS A TAG NO.= '
     &,I5)
29    FORMAT (' LOAD: ERROR - LOADING MAY NOT BE ADDED TO SEGMENTS IN',
     &' N.G.F. SECTION')
30    FORMAT(' LOAD: ERROR IN SPECIFYING LOADED SEGMENTS')
      END
      SUBROUTINE LTSOLV (A,NROW,IP,B,NEQ,NRH,NBLOKS,NPBLK,NLAST,KREC,
     &IUNIT)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     LTSOLV SOLVES THE MATRIX EQ. Y(R)*LU(T)=B(R) WHERE (R) DENOTES ROW
C     VECTOR AND LU(T) DENOTES THE LU DECOMPOSITION OF THE TRANSPOSE OF
C     THE ORIGINAL COEFFICIENT MATRIX.  THE LU(T) DECOMPOSITION IS
C     STORED UNIT IUNIT.
C
C     INPUT:
C     A = ARRAY FOR STORAGE OF MATRIX BLOCKS READ FROM DISK
C     NROW = NUMBER OF ROWS IN EACH BLOCK
C     IP = ARRAY OF PIVOT-ELEMENT INDICES
C     B = ARRAY REPRESENTING RIGHT-HAND SIDE(S) OF THE MATRIX EQUATION
C     NEQ = NUMBER OF EQUATIONS (NROW * NUMBER OF SYMETRIC SECTIONS)
C     NRH = NUMBER OF RIGHT-HAND SIDE VECTORS TO BE SOLVED
C     NBLOKS = NUMBER OF BLOCKS INTO WHICH EACH MATRIX IS DIVIDED
C     NPBLK = NUMBER OF COLUMNS IN THE BLOCKS (EXECPT THE LAST BLOCK)
C     NLAST = NUMBER OF COLUMNS IN THE LAST BLOCK
C     KREC = INCREMENT ADDED TO BLOCK NUMBER TO GET RECORD IN THE RIGHT
C            SUBMATRIX
C     IUNIT = LOGICAL UNIT NUMBER FOR THE DISK FILE
C
C     OUTPUT:
C     B = SOLUTION VECTOR(S) FOR EACH OF THE NRH RIGHT-HAND SIDES
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 A,B,Y,SUM
      COMMON /SCRATM/ Y(2*MAXSEG)
      DIMENSION A(NROW,NROW), B(NEQ,NRH), IP(NEQ)
C
C     FORWARD SUBSTITUTION
C
      I2=NPBLK*NROW
      DO 4 IXBLK1=1,NBLOKS
      CALL RECIN (A,IUNIT,1,I2,IXBLK1+KREC,'First read in LTSOLV')
      K2=NPBLK
      IF (IXBLK1.EQ.NBLOKS) K2=NLAST
      JST=(IXBLK1-1)*NPBLK
      DO 4 IC=1,NRH
      J=JST
      DO 3 K=1,K2
      JM1=J
      J=J+1
      SUM=(0.,0.)
      IF (JM1.LT.1) GO TO 2
      DO 1 I=1,JM1
1     SUM=SUM+A(I,K)*B(I,IC)
2     B(J,IC)=(B(J,IC)-SUM)/A(J,K)
3     CONTINUE
4     CONTINUE
C
C     BACKWARD SUBSTITUTION
C
      JST=NROW+1
      DO 8 IXBLK1=1,NBLOKS
      IBREC=NBLOKS-IXBLK1+1
      IF(IBREC.LT.NBLOKS)CALL RECIN (A,IUNIT,1,I2,IBREC+KREC,
     &'Second read in LTSOLV')
      K2=NPBLK
      IF (IXBLK1.EQ.1) K2=NLAST
      DO 7 IC=1,NRH
      KP=K2+1
      J=JST
      DO 6 K=1,K2
      KP=KP-1
      JP1=J
      J=J-1
      SUM=(0.,0.)
      IF (NROW.LT.JP1) GO TO 6
      DO 5 I=JP1,NROW
5     SUM=SUM+A(I,KP)*B(I,IC)
      B(J,IC)=B(J,IC)-SUM
6     CONTINUE
7     CONTINUE
8     JST=JST-K2
C
C     UNSCRAMBLE SOLUTION
C
      DO 10 IC=1,NRH
      DO 9 I=1,NROW
      IPI=IP(I)
9     Y(IPI)=B(I,IC)
      DO 10 I=1,NROW
10    B(I,IC)=Y(I)
      RETURN
      END
      SUBROUTINE LUNSCR (A,NROW,NOP,IP,IX,NBLOKS,NPBLK,IUNIT)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     LUNSCR UNSCRAMBLES THE FACTORED MATRIX ON DISK ACCORDING TO ROW
C     INTERCHANGES USED FOR PIVOT ELEMENTS.  MULTIPLE SUB-MATRICES FROM
C     THE SOLUTION OF A CIRCULANT MATRIX WILL BE PROCESSED WHEN THEY ARE
C     STORED SEQUENTIALLY ON THE DISK.
C
C     INPUT:
C     A = ARRAY FOR STORAGE OF THE MATRIX BLOCK WHILE IT IS PROCESSED
C     NROW = NUMBER OF ROWS IN THE BLOCK
C     NOP = NUMBER OF SUB-MATRICES IN A CIRCULANT MATRIX SOLUTION
C     IX = ARRAY OF PIVOT-ELEMENT INDICES
C     NBLOKS = NUMBER OF BLOCKS INTO WHICH EACH MATRIX IS DIVIDED
C     NPBLK = NUMBER OF COLUMNS IN THE BLOCKS (EXECPT THE LAST BLOCK)
C     IUNIT = LOGICAL UNIT NUMBER FOR THE DISK FILE
C
C     OUTPUT:
C     IP = ARRAY OF PIVOT-ELEMENT INDICES FROM FACTORING
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 A,TEMP
      DIMENSION A(NROW,*), IX(NROW), IP(NROW)
      I1=1
      I2=NPBLK*NROW
      NM1=NROW-1
      DO 9 KK=1,NOP
      KA=(KK-1)*NROW
      KREC=(KK-1)*NBLOKS
      DO 4 IXBLK1=1,NBLOKS
      CALL RECIN (A,IUNIT,I1,I2,IXBLK1+KREC,'Read in sub. LUNSCR')
      K1=(IXBLK1-1)*NPBLK+2
      IF (NM1.LT.K1) GO TO 3
      J2=0
      DO 2 K=K1,NM1
      IF (J2.LT.NPBLK) J2=J2+1
      IXK=IX(K+KA)
      DO 1 J=1,J2
      TEMP=A(K,J)
      A(K,J)=A(IXK,J)
      A(IXK,J)=TEMP
1     CONTINUE
2     CONTINUE
3     CONTINUE
      CALL RECOT (A,IUNIT,I1,I2,IXBLK1+KREC,'Write in sub. LUNSCR')
4     CONTINUE
      DO 6 I=1,NROW
      IP(I+KA)=I
6     CONTINUE
      DO 7 I=1,NROW
      IXI=IX(I+KA)
      IPT=IP(I+KA)
      IP(I+KA)=IP(IXI+KA)
      IP(IXI+KA)=IPT
7     CONTINUE
9     CONTINUE
      RETURN
      END
      SUBROUTINE MOVE (ROX,ROY,ROZ,XS,YS,ZS,NRPT,ITGI,IT1,IS1,IT2,IS2)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     MOVE moves the structure with respect to its coordinate system or
C     reproduces the structure in new positions.  The structure is
C     rotated about X,Y,Z axes by ROX,ROY,ROZ respectively, then
C     shifted by XS,YS,ZS.
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      DIMENSION T1X(MAXSEG),T1Y(MAXSEG),T1Z(MAXSEG),X2(MAXSEG),
     &   Y2(MAXSEG),Z2(MAXSEG)
      EQUIVALENCE (X2(1),SI(1)), (Y2(1),ALP(1)), (Z2(1),BET(1))
      EQUIVALENCE (T1X,SI), (T1Y,ALP), (T1Z,BET)
      IF (ABS(ROX)+ABS(ROY).GT.1.E-10) IPSYM=IPSYM*3
      SPS=SIN(ROX)
      CPS=COS(ROX)
      STH=SIN(ROY)
      CTH=COS(ROY)
      SPH=SIN(ROZ)
      CPH=COS(ROZ)
      XX=CPH*CTH
      XY=CPH*STH*SPS-SPH*CPS
      XZ=CPH*STH*CPS+SPH*SPS
      YX=SPH*CTH
      YY=SPH*STH*SPS+CPH*CPS
      YZ=SPH*STH*CPS-CPH*SPS
      ZX=-STH
      ZY=CTH*SPS
      ZZ=CTH*CPS
      NRP=NRPT
      IF (NRPT.EQ.0) NRP=1
      IX=1
      IF (N.GE.N2) THEN
         I1=ISEGNO(IT1,IS1)
         I2=ISEGNO(IT2,IS2)
         IF (I1.LT.N2) I1=N2
         IF (I2.LT.N2)THEN
            WRITE(3,90)
            STOP
         END IF
         IF(I1.NE.1.OR.I2.NE.N)IX=2
         K=N
         IF (NRPT.EQ.0) K=I1-1
         DO 2 IR=1,NRP
         DO 1 I=I1,I2
         K=K+1
         XI=X(I)
         YI=Y(I)
         ZI=Z(I)
         X(K)=XI*XX+YI*XY+ZI*XZ+XS
         Y(K)=XI*YX+YI*YY+ZI*YZ+YS
         Z(K)=XI*ZX+YI*ZY+ZI*ZZ+ZS
         XI=X2(I)
         YI=Y2(I)
         ZI=Z2(I)
         X2(K)=XI*XX+YI*XY+ZI*XZ+XS
         Y2(K)=XI*YX+YI*YY+ZI*YZ+YS
         Z2(K)=XI*ZX+YI*ZY+ZI*ZZ+ZS
         BI(K)=BI(I)
         ITAG(K)=ITAG(I)
         IF (ITAG(I).NE.0) ITAG(K)=ITAG(I)+ITGI
1        CONTINUE
         I1=N+1
         I2=K
         IF(NRPT.GT.0)N=K
2        CONTINUE
      END IF
      IF (M.GE.M2) THEN
         I1=M2
         K=M
         LDI=LD+1
         IF (NRPT.EQ.0) K=M1
         DO 5 II=1,NRP
         DO 4 I=I1,M
         K=K+1
         IR=LDI-I
         KR=LDI-K
         XI=X(IR)
         YI=Y(IR)
         ZI=Z(IR)
         X(KR)=XI*XX+YI*XY+ZI*XZ+XS
         Y(KR)=XI*YX+YI*YY+ZI*YZ+YS
         Z(KR)=XI*ZX+YI*ZY+ZI*ZZ+ZS
         XI=T1X(IR)
         YI=T1Y(IR)
         ZI=T1Z(IR)
         T1X(KR)=XI*XX+YI*XY+ZI*XZ
         T1Y(KR)=XI*YX+YI*YY+ZI*YZ
         T1Z(KR)=XI*ZX+YI*ZY+ZI*ZZ
         XI=T2X(IR)
         YI=T2Y(IR)
         ZI=T2Z(IR)
         T2X(KR)=XI*XX+YI*XY+ZI*XZ
         T2Y(KR)=XI*YX+YI*YY+ZI*YZ
         T2Z(KR)=XI*ZX+YI*ZY+ZI*ZZ
         SALP(KR)=SALP(IR)
         BI(KR)=BI(IR)
4        CONTINUE
         I1=M+1
         M=K
5        CONTINUE
      END IF
      IF ((NRPT.EQ.0).AND.(IX.EQ.1)) RETURN
      NP=N
      MP=M
      IPSYM=0
      RETURN
C
90    FORMAT(/,' MOVE: ERROR - SEGMENTS FROM AN NGF FILE CAN NOT BE',
     &' MOVED')
      END
      SUBROUTINE NFPAT
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     NFPAT computes near E or H fields over a range of points.
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 ENINTG,HNINTG,EX,EY,EZ
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON /NFDAT/ ENINTG,HNINTG,XNR,YNR,ZNR,DXNR,DYNR,DZNR,NEAR,NFEH,
     &NRX,NRY,NRZ
      COMMON/CONSTN/PI,TP,DTORAD,CVEL,EPSRZ,RMUZ,ETAZ
      IF (NFEH.EQ.0)THEN
         WRITE(3,10)
      ELSE
         WRITE(3,12)
      END IF
      ZNRT=ZNR-DZNR
      DO 9 I=1,NRZ
      ZNRT=ZNRT+DZNR
      IF (NEAR.NE.0) THEN
         CPH=COS(DTORAD*ZNRT)
         SPH=SIN(DTORAD*ZNRT)
      END IF
      YNRT=YNR-DYNR
      DO 9 J=1,NRY
      YNRT=YNRT+DYNR
      IF (NEAR.NE.0) THEN
         CTH=COS(DTORAD*YNRT)
         STH=SIN(DTORAD*YNRT)
      END IF
      XNRT=XNR-DXNR
      DO 9 KK=1,NRX
      XNRT=XNRT+DXNR
      IF (NEAR.NE.0) THEN
         XOB=XNRT*STH*CPH
         YOB=XNRT*STH*SPH
         ZOB=XNRT*CTH
      ELSE
         XOB=XNRT
         YOB=YNRT
         ZOB=ZNRT
      END IF
      TMP1=XOB
      TMP2=YOB
      TMP3=ZOB
      IF (NFEH.EQ.0) THEN
         CALL NEFLD (TMP1,TMP2,TMP3,EX,EY,EZ)
      ELSE
         CALL NHFLD (TMP1,TMP2,TMP3,EX,EY,EZ)
      END IF
      TMP1=ABS(EX)
      TMP2=CANG(EX)
      TMP3=ABS(EY)
      TMP4=CANG(EY)
      TMP5=ABS(EZ)
      TMP6=CANG(EZ)
      WRITE(3,11) XOB,YOB,ZOB,TMP1,TMP2,TMP3,TMP4,TMP5,TMP6
9     CONTINUE
      RETURN
C
10    FORMAT (///,38X,'- - - NEAR ELECTRIC FIELDS - - -',//,14X,
     &'-  LOCATION  -',21X,'-  EX  -',15X,'-  EY  -',15X,'-  EZ  -',/,8X
     &,'X',11X,'Y',11X,'Z',11X,'MAGNITUDE',3X,'PHASE',6X,'MAGNITUDE',3X,
     &'PHASE',6X,'MAGNITUDE',3X,'PHASE',/,6X,'METERS',6X,'METERS',6X,
     &'METERS',9X,'VOLTS/M',3X,'DEGREES',6X,'VOLTS/M',3X,'DEGREES',6X,
     &'VOLTS/M',3X,'DEGREES')
C11    FORMAT (2X,3F12.4,1X,3(3X,1PE11.4,2X,0PF7.2))
11    FORMAT (2X,1P3E12.4,1X,3(3X,1PE11.4,2X,0PF7.2))
12    FORMAT (///,38X,'- - - NEAR MAGNETIC FIELDS - - -',//,14X,
     &'-  LOCATION  -',21X,'-  HX  -',15X,'-  HY  -',15X,'-  HZ  -',/,8X
     &,'X',11X,'Y',11X,'Z',11X,'MAGNITUDE',3X,'PHASE',6X,'MAGNITUDE',3X,
     &'PHASE',6X,'MAGNITUDE',3X,'PHASE',/,6X,'METERS',6X,'METERS',6X,
     &'METERS',10X,'AMPS/M',3X,'DEGREES',7X,'AMPS/M',3X,'DEGREES',7X,
     &'AMPS/M',3X,'DEGREES')
      END
      SUBROUTINE NFLINE
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     NFLINE computes near E or H fields along a line in space.
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 ENINTG,HNINTG,ENINT,EX,EY,EZ,EA,EH,EV
      COMMON /NFDAT/ ENINTG,HNINTG,XNR,YNR,ZNR,DXNR,DYNR,DZNR,NEAR,NFEH,
     &NRX,NRY,NRZ
      COMMON/CONSTN/PI,TP,DTORAD,CVEL,EPSRZ,RMUZ,ETAZ
      DX=DXNR-XNR
      DY=DYNR-YNR
      DZ=DZNR-ZNR
      IF(NRX.GT.1)THEN
         DX=DX/(NRX-1.)
         DY=DY/(NRX-1.)
         DZ=DZ/(NRX-1.)
      END IF
      DLEN=SQRT(DX**2+DY**2+DZ**2)
      IF(DLEN.GT.1.E-20)THEN
         UAX=DX/DLEN
         UAY=DY/DLEN
         UAZ=DZ/DLEN
      ELSE
         UAX=1.
         UAY=0.
         UAZ=0.
      END IF
      UHX=-UAY
      UHY=UAX
      UHMAG=SQRT(UHX**2+UHY**2)
      IF(UHMAG.GT.1.E-20)THEN
         UHX=UHX/UHMAG
         UHY=UHY/UHMAG
         UVX=-UAZ*UHY
         UVY=UAZ*UHX
         UVZ=UAX*UHY-UAY*UHX
      ELSE
         UHX=1.
         UHY=0.
         UVX=0.
         UVY=1.
         UVZ=0.
         IF(UAZ.LT.0.)UVY=-1.
      END IF
      IF (NFEH.EQ.0)THEN
         WRITE(3,10)
         WRITE(3,91)UAX,UAY,UAZ,UHX,UHY,UVX,UVY,UVZ
         WRITE(3,12)'VOLTS','VOLTS','VOLTS'
      ELSE
         WRITE(3,11)
         WRITE(3,91)UAX,UAY,UAZ,UHX,UHY,UVX,UVY,UVZ
         WRITE(3,12)' AMPS',' AMPS',' AMPS'
      END IF
      ENINT=0.
      XOB=XNR
      YOB=YNR
      ZOB=ZNR
      DO 1 I=1,NRX
      IF(I.GT.1)THEN
         XOB=XOB+DX
         YOB=YOB+DY
         ZOB=ZOB+DZ
      END IF
      IF (NFEH.EQ.0) THEN
         CALL NEFLD (XOB,YOB,ZOB,EX,EY,EZ)
      ELSE
         CALL NHFLD (XOB,YOB,ZOB,EX,EY,EZ)
      END IF
      EA=EX*UAX+EY*UAY+EZ*UAZ
      EH=EX*UHX+EY*UHY
      EV=EX*UVX+EY*UVY+EZ*UVZ
      IF(I.EQ.1.OR.I.EQ.NRX)THEN
         ENINT=ENINT+.5*EA
      ELSE
         ENINT=ENINT+EA
      END IF
      EAMAG=ABS(EA)
      EAPH=CANG(EA)
      EHMAG=ABS(EH)
      EHPH=CANG(EH)
      EVMAG=ABS(EV)
      EVPH=CANG(EV)
      WRITE(3,94) XOB,YOB,ZOB,EAMAG,EAPH,EHMAG,EHPH,EVMAG,EVPH
1     CONTINUE
      IF(NRX.GT.1)THEN
         ENINT=ENINT*DLEN
       ELSE
         ENINT=0.
      END IF
      IF(NFEH.EQ.0)THEN
         ENINTG=ENINTG+ENINT
         WRITE(3,92)ENINT,ENINTG
      ELSE
         HNINTG=HNINTG+ENINT
         WRITE(3,93)ENINT,HNINTG
      END IF
      RETURN
C
10    FORMAT (///,38X,'- - - NEAR ELECTRIC FIELDS - - -',/)
11    FORMAT (///,38X,'- - - NEAR MAGNETIC FIELDS - - -',/)
12    FORMAT(14X,'-  LOCATION  -',20X,'- Axial -',11X,'- Transverse1 -',
     &7X,'- Transverse2 -',/,8X,'X',11X,'Y',11X,'Z',11X,'MAGNITUDE',3X,
     &'PHASE',6X,'MAGNITUDE',3X,'PHASE',6X,'MAGNITUDE',3X,'PHASE',/,6X,
     &'METERS',6X,'METERS',6X,'METERS',9X,A5,'/M',3X,'DEGREES',6X,
     &A5,'/M',3X,'DEGREES',6X,A5,'/M',3X,'DEGREES')
91    FORMAT(' Unit Vectors:',6X,'X',8X,'Y',8X,'Z',/,' Axial',7X,'= ',
     &3F9.5,/,' Transverse1 = ',2F9.5,/,' Transverse2 = ',3F9.5,/)
92    FORMAT(//,' Line integral of E       = ',1P2E12.5,' Volts',/,
     &' Cumulative line integral = ',2E12.5,' Volts')
93    FORMAT(//,' Line integral of H       = ',1P2E12.5,' Amps',/,
     &' Cumulative line integral = ',2E12.5,' Amps')
94    FORMAT (2X,1P3E12.4,1X,3(3X,1PE11.4,2X,0PF7.2))
      END
      SUBROUTINE NHFLD (XOB,YOB,ZOB,HX,HY,HZ)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     NHFLD computes the near field at specified points in space after
C     the structure currents have been computed.
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 HX,HY,HZ,ACX,BCX,CCX,XKSJ,EXK,EYK,EZK,EXS,EYS,EZS,EXC,
     &EYC,EZC,H1X,H1Y,H1Z,H2X,H2Y,H2Z,ZPEDS,AIX,BIX,CIX,CUR,XKS,XKU,XKL,
     &ETAU,ETAL,CEPSU,CEPSL,FRATI,ETAL2,CON
      COMPLEX*16 EXPX,EXMX,EXPY,EXMY,EXPZ,EXMZ
      COMPLEX*16 EYPX,EYMX,EYPY,EYMY,EYPZ,EYMZ
      COMPLEX*16 EZPX,EZMX,EZPY,EZMY,EZPZ,EZMZ
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON/CRNT/AIX(MAXSEG),BIX(MAXSEG),CIX(MAXSEG),CUR(3*MAXSEG),
     &XKS(MAXSEG)
      COMMON /DATAJ/ XKSJ,EXK,EYK,EZK,EXS,EYS,EZS,EXC,EYC,EZC,ZPEDS,
     &SLENJ,ARADJ,XJ,YJ,ZJ,DXJ,DYJ,DZJ,IND1,IND2
      COMMON/DATAP/H1X,H1Y,H1Z,H2X,H2Y,H2Z,SPATJ,XPATJ,YPATJ,ZPATJ,T1XJ,
     &T1YJ,T1ZJ,T2XJ,T2YJ,T2ZJ,IPGND
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      COMMON/GLOCK/IGLOCK
      DIMENSION CAB(MAXSEG),SAB(MAXSEG)
      DIMENSION T1X(MAXSEG),T1Y(MAXSEG),T1Z(MAXSEG),XS(MAXSEG),
     &   YS(MAXSEG),ZS(MAXSEG)
      EQUIVALENCE (T1X,SI),(T1Y,ALP),(T1Z,BET),(XS,X),(YS,Y),(ZS,Z)
      EQUIVALENCE (CAB,ALP),(SAB,BET)
      IF (IPERF.EQ.2) GO TO 6
      HX=(0.,0.)
      HY=(0.,0.)
      HZ=(0.,0.)
      IF (N.EQ.0) GO TO 4
      DO 3 I=1,N
      SLENJ=SI(I)
      ARADJ=BI(I)
      XJ=X(I)
      YJ=Y(I)
      ZJ=Z(I)
      DXJ=CAB(I)
      DYJ=SAB(I)
      DZJ=SALP(I)
      XKSJ=XKS(I)
      CALL HSFLD (XOB,YOB,ZOB)
      ACX=AIX(I)
      BCX=BIX(I)
      CCX=CIX(I)
      HX=HX+EXK*ACX+EXS*BCX+EXC*CCX
      HY=HY+EYK*ACX+EYS*BCX+EYC*CCX
3     HZ=HZ+EZK*ACX+EZS*BCX+EZC*CCX
      IF (M.EQ.0) RETURN
4     JC=N
      JL=LD+1
      DO 5 I=1,M
      JL=JL-1
      SPATJ=BI(JL)
      XPATJ=X(JL)
      YPATJ=Y(JL)
      ZPATJ=Z(JL)
      T1XJ=T1X(JL)
      T1YJ=T1Y(JL)
      T1ZJ=T1Z(JL)
      T2XJ=T2X(JL)
      T2YJ=T2Y(JL)
      T2ZJ=T2Z(JL)
      CALL HINTG (XOB,YOB,ZOB)
      JC=JC+3
      ACX=T1XJ*CUR(JC-2)+T1YJ*CUR(JC-1)+T1ZJ*CUR(JC)
      BCX=T2XJ*CUR(JC-2)+T2YJ*CUR(JC-1)+T2ZJ*CUR(JC)
      HX=HX+ACX*H1X+BCX*H2X
      HY=HY+ACX*H1Y+BCX*H2Y
5     HZ=HZ+ACX*H1Z+BCX*H2Z
      RETURN
C
C     GET H BY FINITE DIFFERENCE OF E FOR SOMMERFELD GROUND
6     IF (ZOB.LT.0.) GO TO 7
      CON=(0.,1.)/(XKU*ETAU)
      DELT=1.E-3*(6.28318/ABS(XKU))
      GO TO 8
7     CON=(0.,1.)/(XKL*ETAL)
      DELT=1.E-3*(6.28318/ABS(XKL))
8     IGLOCK=1
      CALL NEFLD (XOB+DELT,YOB,ZOB,EXPX,EYPX,EZPX)
      CALL NEFLD (XOB-DELT,YOB,ZOB,EXMX,EYMX,EZMX)
      CALL NEFLD (XOB,YOB+DELT,ZOB,EXPY,EYPY,EZPY)
      CALL NEFLD (XOB,YOB-DELT,ZOB,EXMY,EYMY,EZMY)
      CALL NEFLD (XOB,YOB,ZOB+DELT,EXPZ,EYPZ,EZPZ)
      CALL NEFLD (XOB,YOB,ZOB-DELT,EXMZ,EYMZ,EZMZ)
      IGLOCK=0
      HX=CON*(EZPY-EZMY-EYPZ+EYMZ)/(2.*DELT)
      HY=CON*(EXPZ-EXMZ-EZPX+EZMX)/(2.*DELT)
      HZ=CON*(EYPX-EYMX-EXPY+EXMY)/(2.*DELT)
      RETURN
      END
      SUBROUTINE PATCH (NX,NY,X1,Y1,Z1,X2,Y2,Z2,X3,Y3,Z3,X4,Y4,Z4)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     PATCH generates and modifies patch geometry data.
C     Entry SUBPH divides a patch at a wire connection.
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      DIMENSION T1X(MAXSEG), T1Y(MAXSEG), T1Z(MAXSEG)
      EQUIVALENCE (T1X,SI), (T1Y,ALP), (T1Z,BET)
C     NEW PATCHES.  FOR NX=0, NY=1,2,3,4 PATCH IS (RESPECTIVELY)
C     ARBITRARY, RECTAGULAR, TRIANGULAR, OR QUADRILATERAL.
C     FOR NX AND NY .GT. 0 A RECTANGULAR SURFACE IS PRODUCED WITH
C     NX BY NY RECTANGULAR PATCHES.
      M=M+1
      MI=LD+1-M
      NTP=NY
      IF (NX.GT.0) NTP=2
      IF (NTP.GT.1) GO TO 2
      X(MI)=X1
      Y(MI)=Y1
      Z(MI)=Z1
      BI(MI)=Z2
      ZNV=COS(X2)
      XNV=ZNV*COS(Y2)
      YNV=ZNV*SIN(Y2)
      ZNV=SIN(X2)
      XA=SQRT(XNV*XNV+YNV*YNV)
      IF (XA.LT.1.E-6) GO TO 1
      T1X(MI)=-YNV/XA
      T1Y(MI)=XNV/XA
      T1Z(MI)=0.
      GO TO 6
1     T1X(MI)=1.
      T1Y(MI)=0.
      T1Z(MI)=0.
      GO TO 6
2     S1X=X2-X1
      S1Y=Y2-Y1
      S1Z=Z2-Z1
      S2X=X3-X2
      S2Y=Y3-Y2
      S2Z=Z3-Z2
      IF (NX.EQ.0) GO TO 3
      S1X=S1X/NX
      S1Y=S1Y/NX
      S1Z=S1Z/NX
      S2X=S2X/NY
      S2Y=S2Y/NY
      S2Z=S2Z/NY
3     XNV=S1Y*S2Z-S1Z*S2Y
      YNV=S1Z*S2X-S1X*S2Z
      ZNV=S1X*S2Y-S1Y*S2X
      XA=SQRT(XNV*XNV+YNV*YNV+ZNV*ZNV)
      XNV=XNV/XA
      YNV=YNV/XA
      ZNV=ZNV/XA
      XST=SQRT(S1X*S1X+S1Y*S1Y+S1Z*S1Z)
      T1X(MI)=S1X/XST
      T1Y(MI)=S1Y/XST
      T1Z(MI)=S1Z/XST
      IF (NTP.GT.2) GO TO 4
      X(MI)=X1+.5*(S1X+S2X)
      Y(MI)=Y1+.5*(S1Y+S2Y)
      Z(MI)=Z1+.5*(S1Z+S2Z)
      BI(MI)=XA
      GO TO 6
4     IF (NTP.EQ.4) GO TO 5
      X(MI)=(X1+X2+X3)/3.
      Y(MI)=(Y1+Y2+Y3)/3.
      Z(MI)=(Z1+Z2+Z3)/3.
      BI(MI)=.5*XA
      GO TO 6
5     S1X=X3-X1
      S1Y=Y3-Y1
      S1Z=Z3-Z1
      S2X=X4-X1
      S2Y=Y4-Y1
      S2Z=Z4-Z1
      XN2=S1Y*S2Z-S1Z*S2Y
      YN2=S1Z*S2X-S1X*S2Z
      ZN2=S1X*S2Y-S1Y*S2X
      XST=SQRT(XN2*XN2+YN2*YN2+ZN2*ZN2)
      SALPN=1./(3.*(XA+XST))
      X(MI)=(XA*(X1+X2+X3)+XST*(X1+X3+X4))*SALPN
      Y(MI)=(XA*(Y1+Y2+Y3)+XST*(Y1+Y3+Y4))*SALPN
      Z(MI)=(XA*(Z1+Z2+Z3)+XST*(Z1+Z3+Z4))*SALPN
      BI(MI)=.5*(XA+XST)
      S1X=(XNV*XN2+YNV*YN2+ZNV*ZN2)/XST
      IF (S1X.GT.0.9998) GO TO 6
      WRITE(3,14)
      STOP
6     T2X(MI)=YNV*T1Z(MI)-ZNV*T1Y(MI)
      T2Y(MI)=ZNV*T1X(MI)-XNV*T1Z(MI)
      T2Z(MI)=XNV*T1Y(MI)-YNV*T1X(MI)
      SALP(MI)=1.
      IF (NX.EQ.0) GO TO 8
      M=M+NX*NY-1
      XN2=X(MI)-S1X-S2X
      YN2=Y(MI)-S1Y-S2Y
      ZN2=Z(MI)-S1Z-S2Z
      XS=T1X(MI)
      YS=T1Y(MI)
      ZS=T1Z(MI)
      XT=T2X(MI)
      YT=T2Y(MI)
      ZT=T2Z(MI)
      MI=MI+1
      DO 7 IY=1,NY
      XN2=XN2+S2X
      YN2=YN2+S2Y
      ZN2=ZN2+S2Z
      DO 7 IX=1,NX
      XST=IX
      MI=MI-1
      X(MI)=XN2+XST*S1X
      Y(MI)=YN2+XST*S1Y
      Z(MI)=ZN2+XST*S1Z
      BI(MI)=XA
      SALP(MI)=1.
      T1X(MI)=XS
      T1Y(MI)=YS
      T1Z(MI)=ZS
      T2X(MI)=XT
      T2Y(MI)=YT
7     T2Z(MI)=ZT
8     IPSYM=0
      NP=N
      MP=M
      RETURN
C     DIVIDE PATCH FOR WIRE CONNECTION
      ENTRY SUBPH (NX,NY,X1,Y1,Z1,X2,Y2,Z2,X3,Y3,Z3,X4,Y4,Z4)
      IF (NY.GT.0) GO TO 10
      IF (NX.EQ.M) GO TO 10
      NXP=NX+1
      IX=LD-M
      DO 9 IY=NXP,M
      IX=IX+1
      NYP=IX-3
      X(NYP)=X(IX)
      Y(NYP)=Y(IX)
      Z(NYP)=Z(IX)
      BI(NYP)=BI(IX)
      SALP(NYP)=SALP(IX)
      T1X(NYP)=T1X(IX)
      T1Y(NYP)=T1Y(IX)
      T1Z(NYP)=T1Z(IX)
      T2X(NYP)=T2X(IX)
      T2Y(NYP)=T2Y(IX)
9     T2Z(NYP)=T2Z(IX)
10    MI=LD+1-NX
      XS=X(MI)
      YS=Y(MI)
      ZS=Z(MI)
      XA=BI(MI)*.25
      XST=SQRT(XA)*.5
      S1X=T1X(MI)
      S1Y=T1Y(MI)
      S1Z=T1Z(MI)
      S2X=T2X(MI)
      S2Y=T2Y(MI)
      S2Z=T2Z(MI)
      SALN=SALP(MI)
      XT=XST
      YT=XST
      IF (NY.GT.0) GO TO 11
      MIA=MI
      GO TO 12
11    M=M+1
      MP=MP+1
      MIA=LD+1-M
12    DO 13 IX=1,4
      X(MIA)=XS+XT*S1X+YT*S2X
      Y(MIA)=YS+XT*S1Y+YT*S2Y
      Z(MIA)=ZS+XT*S1Z+YT*S2Z
      BI(MIA)=XA
      T1X(MIA)=S1X
      T1Y(MIA)=S1Y
      T1Z(MIA)=S1Z
      T2X(MIA)=S2X
      T2Y(MIA)=S2Y
      T2Z(MIA)=S2Z
      SALP(MIA)=SALN
      IF (IX.EQ.2) YT=-YT
      IF (IX.EQ.1.OR.IX.EQ.3) XT=-XT
      MIA=MIA-1
13    CONTINUE
      M=M+3
      IF (NX.LE.MP) MP=MP+3
      IF (NY.GT.0) Z(MI)=10000.
      RETURN
C
14    FORMAT (' PATCH: ERROR - CORNERS OF QUADRILATERAL PATCH DO NOT',
     &' LIE IN A PLANE')
      END
      SUBROUTINE PCINT (XI,YI,ZI,CABI,SABI,SALPI,E)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     PCINT evaluates the E field due to patches at a wire connection
C     by integrating over the patches.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 H1X,H1Y,H1Z,H2X,H2Y,H2Z,E,E1,E2,E3,E4,E5,E6,E7,E8,E9
      COMMON/DATAP/H1X,H1Y,H1Z,H2X,H2Y,H2Z,SPATJ,XPATJ,YPATJ,ZPATJ,T1XJ,
     &T1YJ,T1ZJ,T2XJ,T2YJ,T2ZJ,IPGND
      DIMENSION E(9)
      DATA TPI/6.2831853071796D0/,NINT/10/
      D=SQRT(SPATJ)*.5
      DS=4.*D/DFLOAT(NINT)
      DA=DS*DS
      GCON=1./SPATJ
      FCON=1./(2.*TPI*D)
      XXJ=XPATJ
      XYJ=YPATJ
      XZJ=ZPATJ
      XS=SPATJ
      SPATJ=DA
      S1=D+DS*.5
      XSS=XPATJ+S1*(T1XJ+T2XJ)
      YSS=YPATJ+S1*(T1YJ+T2YJ)
      ZSS=ZPATJ+S1*(T1ZJ+T2ZJ)
      S1=S1+D
      S2X=S1
      E1=(0.,0.)
      E2=(0.,0.)
      E3=(0.,0.)
      E4=(0.,0.)
      E5=(0.,0.)
      E6=(0.,0.)
      E7=(0.,0.)
      E8=(0.,0.)
      E9=(0.,0.)
      DO 1 I1=1,NINT
      S1=S1-DS
      S2=S2X
      XSS=XSS-DS*T1XJ
      YSS=YSS-DS*T1YJ
      ZSS=ZSS-DS*T1ZJ
      XPATJ=XSS
      YPATJ=YSS
      ZPATJ=ZSS
      DO 1 I2=1,NINT
      S2=S2-DS
      XPATJ=XPATJ-DS*T2XJ
      YPATJ=YPATJ-DS*T2YJ
      ZPATJ=ZPATJ-DS*T2ZJ
      CALL UNERE (XI,YI,ZI)
      H1X=H1X*CABI+H1Y*SABI+H1Z*SALPI
      H2X=H2X*CABI+H2Y*SABI+H2Z*SALPI
      G1=(D+S1)*(D+S2)*GCON
      G2=(D-S1)*(D+S2)*GCON
      G3=(D-S1)*(D-S2)*GCON
      G4=(D+S1)*(D-S2)*GCON
      F2=(S1*S1+S2*S2)*TPI
      F1=S1/F2-(G1-G2-G3+G4)*FCON
      F2=S2/F2-(G1+G2-G3-G4)*FCON
      E1=E1+H1X*G1
      E2=E2+H1X*G2
      E3=E3+H1X*G3
      E4=E4+H1X*G4
      E5=E5+H2X*G1
      E6=E6+H2X*G2
      E7=E7+H2X*G3
      E8=E8+H2X*G4
1     E9=E9+H1X*F1+H2X*F2
      E(1)=E1
      E(2)=E2
      E(3)=E3
      E(4)=E4
      E(5)=E5
      E(6)=E6
      E(7)=E7
      E(8)=E8
      E(9)=E9
      XPATJ=XXJ
      YPATJ=XYJ
      ZPATJ=XZJ
      SPATJ=XS
      RETURN
      END
      SUBROUTINE PRNT(IN1,IN2,IN3,FL1,FL2,FL3,FL4,FL5,FL6,CTYPE)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     PRNT prints the input data for impedance loading, inserting blanks
C     for numbers that are zero.
C
C     INPUT:
C     IN1-3 = INTEGER VALUES TO BE PRINTED
C     FL1-6 = REAL VALUES TO BE PRINTED
C     CTYPE = CHARACTER STRING TO BE PRINTED
C
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER CTYPE*(*), CINT(3)*5, CFLT(6)*13
      DO 1 I=1,3
1     CINT(I)='     '
      IF(IN1.EQ.0.AND.IN2.EQ.0.AND.IN3.EQ.0)THEN
         CINT(1)='  ALL'
      ELSE
         IF(IN1.NE.0)WRITE(CINT(1),90)IN1
         IF(IN2.NE.0)WRITE(CINT(2),90)IN2
         IF(IN3.NE.0)WRITE(CINT(3),90)IN3
      END IF
      DO 2 I=1,6
2     CFLT(I)='     '
      IF(ABS(FL1).GT.1.E-30)WRITE(CFLT(1),91)FL1
      IF(ABS(FL2).GT.1.E-30)WRITE(CFLT(2),91)FL2
      IF(ABS(FL3).GT.1.E-30)WRITE(CFLT(3),91)FL3
      IF(ABS(FL4).GT.1.E-30)WRITE(CFLT(4),91)FL4
      IF(ABS(FL5).GT.1.E-30)WRITE(CFLT(5),91)FL5
      IF(ABS(FL6).GT.1.E-30)WRITE(CFLT(6),91)FL6
      WRITE(3,92)(CINT(I),I=1,3),(CFLT(I),I=1,6),CTYPE
      RETURN
C
90    FORMAT(I5)
91    FORMAT(1PE13.4)
92    FORMAT(/,3X,3A,3X,6A,3X,A)
      END
      SUBROUTINE RDPAT(PIN,PNLS,PLOSS)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     RDPAT calls routines to evaluate the radiation pattern, and prints
C     radiated field, gain and normalized gain.
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER IGNTP*12,IGAX*14,IGTP*19,HCLIF*6,ISENS*6,FUNITS*7
      COMPLEX*16 ETH,EPH,ERD,XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,FRATI,ETAL2
C***
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON /SORCES/ PSOR1(NSOMAX),PSOR2(NSOMAX),PSOR3(NSOMAX),
     &PSOR4(NSOMAX),PSOR5(NSOMAX),PSOR6(NSOMAX),DTHINC,DPHINC,NTHINC,
     &NPHINC,NSCINC,NSORC,ISORTP(NSOMAX)
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      COMMON /RPDAT/ THETS,DTH,PHIS,DPH,RFLD,GNOR,NTH,NPH,IPD,IAVP,INOR,
     &IAX
      COMMON/CONSTN/PI,TP,DTORAD,CVEL,EPSRZ,RMUZ,ETAZ
      COMMON /SCRATM/ GAIN(4*MAXSEG)
      DIMENSION IGTP(3),IGAX(2),IGNTP(5)
C***
      DATA IGTP/'   - POWER GAINS - ','- DIRECTIVE GAINS -',
     &'  - CROSS SECTION -'/
      DATA IGAX/' MAJOR   MINOR',' VERT.   HOR. '/
      DATA IGNTP/' MAJOR AXIS ',' MINOR AXIS ','   VERTICAL ',
     &' HORIZONTAL ','      TOTAL '/
C***
      NORMAX=4*MAXSEG
      IF (ICLIFT.NE.0.OR.NRADL.NE.0)THEN
         WRITE(3,36)
         IF(NRADL.GT.0)WRITE(3,37) NRADL,SCNRAD,SCNWRD
         IF (ICLIFT.NE.0)THEN
            IF (ICLIFT.EQ.1) HCLIF='LINEAR'
            IF (ICLIFT.EQ.2) HCLIF='CIRCLE'
            WRITE(3,38) HCLIF,CLIFL,CLIFH,EPSR2,SIG2
         END IF
      END IF
      IF (IFAR.EQ.1)THEN
         IF (ICLIFT.NE.0.OR.NRADL.NE.0)WRITE(3,49)
         WRITE(3,43)
      ELSE
         WRITE(3,39)
         FUNITS=' VOLTS '
         IF (RFLD.GT.1.E-20)THEN
            FUNITS='VOLTS/M'
            ETH=EXP(-(0.,1.)*XKU*RFLD)/RFLD
            EXRM1=ABS(ETH)
            EXRA1=CANG(ETH)
            WRITE(3,40) RFLD,EXRM1,EXRA1
            IF (KSYMP.GT.1.AND.IPERF.NE.1)THEN
               ETH=EXP(-(0.,1.)*XKL*RFLD)/RFLD
               EXRM2=ABS(ETH)
               EXRA2=CANG(ETH)
               WRITE(3,41) EXRM2,EXRA2
            END IF
         END IF
         IPDX=IPD+1
         IF(ISORTP(NSORC).NE.1.AND.ISORTP(NSORC).NE.4)IPDX=3
         WRITE(3,42) IGTP(IPDX),IGAX(IAX+1),FUNITS,FUNITS
      END IF
      IF(ISORTP(NSORC).EQ.1.OR.ISORTP(NSORC).EQ.4)THEN
C
C        VOLTAGE SOURCES
C
         PRAD=PIN-PLOSS-PNLS
         GCOP=TP/PIN
         GCONN=GCOP
         IF (IPD.NE.0) GCONN=GCONN*PIN/PRAD
      ELSE IF(ISORTP(NSORC).EQ.3)THEN
C
C        HERTZIAN DIPOLE SOURCE
C
         IF (PSOR3(NSORC).GE.0.)THEN
            ETH=ETAU*XKU*XKU
         ELSE
            ETH=ETAL*XKL*XKL
         END IF
         PINHZ=PSOR6(NSORC)**2*ETH/(12.*PI)
         PRAD=PINHZ-PLOSS-PNLS
         GCOP=TP/PINHZ
         GCONN=GCOP
         IF (IPD.NE.0) GCONN=GCONN*PIN/PRAD
      ELSE
C
C     PLANE-WAVE SOURCE
C
         PRAD=0.
C     Changed 1/24/06 to correct use of PSOR5 and PSOR4.
         GCONN=ABS(XKU*XKU)/(PI*(1.+PSOR5(NSORC)**2)*PSOR4(NSORC)**2)
         GCOP=GCONN
      END IF
      I=0
      GMAX=-1.E10
      PINT=0.
      TMP1=DPH*DTORAD
      TMP2=.5*DTH*DTORAD
      PHI=PHIS-DPH
      DO 30 KPH=1,NPH
      PHI=PHI+DPH
      PHA=PHI*DTORAD
      THET=THETS-DTH
      DO 30 KTH=1,NTH
      THET=THET+DTH
      THA=THET*DTORAD
      ETA=ETAU
      IF (ABS(THET).GT.90.) ETA=ETAL
C      IF (ISORTP(NSORC).EQ.2) ETA=1.   !Change 08/15/05
C      GCON=GCONN/ETA
      IF (ISORTP(NSORC).EQ.2)THEN
         GCON=GCONN
      ELSE
         GCON=GCONN/ETA
      END IF
      IF (IFAR.EQ.1)THEN
         IF(IPERF.NE.1)THEN
            CALL GFLD (RFLD,PHA,THET,ETH,EPH,ERD)
            ERDM=ABS(ERD)
            ERDA=CANG(ERD)
         ELSE
            IF(ABS(THET).GT.1.E-20)THEN
               THA=ATAN(RFLD/THET)
            ELSE
               THA=0.5*PI
            END IF
            CALL FFLD (THA,PHA,ETH,EPH)
      RDIST=SQRT(RFLD*RFLD+THET*THET)
            ETH=ETH*EXP(-(0.,1.)*XKU*RDIST)/RDIST
            EPH=EPH*EXP(-(0.,1.)*XKU*RDIST)/RDIST
            ERDM=0.
            ERDA=0.
         END IF
      ELSE
         CALL FFLD (THA,PHA,ETH,EPH)
      END IF
      ETHM2=DREAL(ETH*DCONJG(ETH))
      ETHM=SQRT(ETHM2)
      ETHA=CANG(ETH)
      EPHM2=DREAL(EPH*DCONJG(EPH))
      EPHM=SQRT(EPHM2)
      EPHA=CANG(EPH)
      IF (IFAR.EQ.1)THEN
         WRITE(3,45) RFLD,PHI,THET,ETHM,ETHA,EPHM,EPHA,ERDM,ERDA
         GO TO 30
      END IF
C     ELLIPTICAL POLARIZATION CALC.
      IF (ETHM2.LT.1.E-20.AND.EPHM2.LT.1.E-20)THEN
         TILTA=0.
         EMAJR2=0.
         EMINR2=0.
         AXRAT=0.
         ISENS='      '
      ELSE
         DFAZ=EPHA-ETHA
         IF (EPHA.GE.0.)THEN
            DFAZ2=DFAZ-360.
         ELSE
            DFAZ2=DFAZ+360.
         END IF
         IF (ABS(DFAZ).GT.ABS(DFAZ2)) DFAZ=DFAZ2
         CDFAZ=COS(DFAZ*DTORAD)
         TSTOR1=ETHM2-EPHM2
         TSTOR2=2.*EPHM*ETHM*CDFAZ
         TILTA=.5*ATGN2(TSTOR2,TSTOR1)
         STILTA=SIN(TILTA)
         TSTOR1=TSTOR1*STILTA*STILTA
         TSTOR2=TSTOR2*STILTA*COS(TILTA)
         EMAJR2=-TSTOR1+TSTOR2+ETHM2
         EMINR2=TSTOR1-TSTOR2+EPHM2
         IF (EMINR2.LT.0.) EMINR2=0.
         AXRAT=SQRT(EMINR2/EMAJR2)
         TILTA=TILTA/DTORAD
         IF (AXRAT.LT.1.E-5)THEN
            ISENS='LINEAR'
         ELSE
            IF (DFAZ.LE.0.)THEN
               ISENS='RIGHT '
            ELSE
               ISENS='LEFT  '
            END IF
         END IF
      END IF
      GNMJ=DB10(GCON*EMAJR2)
      GNMN=DB10(GCON*EMINR2)
      GNV=DB10(GCON*ETHM2)
      GNH=DB10(GCON*EPHM2)
      GTOT=DB10(GCON*(ETHM2+EPHM2))
      I=I+1
      IF (INOR.GT.0.AND.I.LE.NORMAX)THEN
         IF(INOR.EQ.1)THEN
            TSTOR1=GNMJ
         ELSE IF(INOR.EQ.2)THEN
            TSTOR1=GNMN
         ELSE IF(INOR.EQ.3)THEN
            TSTOR1=GNV
         ELSE IF(INOR.EQ.4)THEN
            TSTOR1=GNH
         ELSE IF(INOR.EQ.5)THEN
            TSTOR1=GTOT
         END IF
         GAIN(I)=TSTOR1
         IF (TSTOR1.GT.GMAX) GMAX=TSTOR1
      END IF
      IF (IAVP.NE.0)THEN
         TSTOR1=(ETHM2+EPHM2)/ETA
         TMP3=THA-TMP2
         TMP4=THA+TMP2
         IF (KTH.EQ.1) TMP3=THA
         IF (KTH.EQ.NTH) TMP4=THA
         DA=ABS(TMP1*(COS(TMP3)-COS(TMP4)))
         IF (KPH.EQ.1.OR.KPH.EQ.NPH) DA=.5*DA
         PINT=PINT+TSTOR1*DA
         IF (IAVP.EQ.2) GO TO 30
      END IF
      IF (IAX.EQ.1)THEN
         TMP5=GNV
         TMP6=GNH
      ELSE
         TMP5=GNMJ
         TMP6=GNMN
      END IF
      IF (RFLD.GT.1.E-20)THEN
         IF (KSYMP.EQ.1.OR.ABS(THET).LE.90.)THEN
            ETHM=ETHM*EXRM1
            ETHA=ETHA+EXRA1
            EPHM=EPHM*EXRM1
            EPHA=EPHA+EXRA1
         ELSE
            ETHM=ETHM*EXRM2
            ETHA=ETHA+EXRA2
            EPHM=EPHM*EXRM2
            EPHA=EPHA+EXRA2
         END IF
      END IF
      WRITE(3,44) THET,PHI,TMP5,TMP6,GTOT,AXRAT,TILTA,ISENS,ETHM,ETHA
     &,EPHM,EPHA
30    CONTINUE
      IF (IAVP.NE.0)THEN
         TMP3=THETS*DTORAD
         TMP4=TMP3+DTH*DTORAD*DFLOAT(NTH-1)
         TMP3=ABS(DPH*DTORAD*DFLOAT(NPH-1)*(COS(TMP3)-COS(TMP4)))
         PINT=TP*PINT/TMP3
         AVGAIN=GCOP*PINT/TP
         TMP3=TMP3/PI
         WRITE(3,46) AVGAIN,TMP3,PINT
      END IF
      WRITE(3,50)
      IF (INOR.EQ.0)RETURN
      IF (ABS(GNOR).GT.1.E-20) GMAX=GNOR
      WRITE(3,47) IGNTP(INOR),GMAX
      ITMP2=NPH*NTH
      IF (ITMP2.GT.NORMAX) ITMP2=NORMAX
      ITMP1=(ITMP2+2)/3
      ITMP2=ITMP1*3-ITMP2
      ITMP3=ITMP1
      ITMP4=2*ITMP1
      IF (ITMP2.EQ.2) ITMP4=ITMP4-1
      DO 32 I=1,ITMP1
      ITMP3=ITMP3+1
      ITMP4=ITMP4+1
      J=(I-1)/NTH
      TMP1=THETS+DFLOAT(I-J*NTH-1)*DTH
      TMP2=PHIS+DFLOAT(J)*DPH
      J=(ITMP3-1)/NTH
      TMP3=THETS+DFLOAT(ITMP3-J*NTH-1)*DTH
      TMP4=PHIS+DFLOAT(J)*DPH
      J=(ITMP4-1)/NTH
      TMP5=THETS+DFLOAT(ITMP4-J*NTH-1)*DTH
      TMP6=PHIS+DFLOAT(J)*DPH
      TSTOR1=GAIN(I)-GMAX
      IF (I.EQ.ITMP1.AND.ITMP2.NE.0)THEN
         IF (ITMP2.EQ.2)THEN
            WRITE(3,48) TMP1,TMP2,TSTOR1
            RETURN
         ELSE
            TSTOR2=GAIN(ITMP3)-GMAX
            WRITE(3,48) TMP1,TMP2,TSTOR1,TMP3,TMP4,TSTOR2
            RETURN
         END IF
      END IF
      TSTOR2=GAIN(ITMP3)-GMAX
      PINT=GAIN(ITMP4)-GMAX
32    WRITE(3,48) TMP1,TMP2,TSTOR1,TMP3,TMP4,TSTOR2,TMP5,TMP6,PINT
      RETURN
C
36    FORMAT (///,31X,'- - - FAR FIELD GROUND PARAMETERS - - -',//)
37    FORMAT (40X,'RADIAL WIRE GROUND SCREEN',/,40X,I5,' WIRES',/,40X,
     &'WIRE LENGTH=',F8.2,' METERS',/,40X,'WIRE RADIUS=',1PE10.3,
     &' METERS')
38    FORMAT (40X,A6,' CLIFF',/,40X,'EDGE DISTANCE=',F9.2,' METERS',/,
     &40X,'HEIGHT=',F8.2,' METERS',/,40X,'SECOND MEDIUM -',/,40X,
     &'RELATIVE DIELECTRIC CONST.=',F7.3,/,40X,'CONDUCTIVITY=',1PE10.3,
     &' MHOS')
39    FORMAT (///,48X,'- - - RADIATION PATTERNS - - -')
40    FORMAT (54X,'RANGE=',1PE13.6,' METERS',/,54X,'EXP(-JKR)/R=',
     &E12.5,' AT PHASE',0PF7.2,' DEGREES',/)
41    FORMAT (39X,'LOWER MEDIUM - EXP(-JKR)/R=',1PE12.5,' AT PHASE',
     &0PF7.2,' DEGREES')
42    FORMAT (/,2X,'- - ANGLES - -',7X,A19,7X,'- - - POLARIZATION - - -'
     &,4X,'- - - E(THETA) - - -',4X,'- - - E(PHI) - - -',
     &/,2X,'THETA',5X,'PHI',7X,A14,3X,'TOTAL',6X,'AXIAL',5X,'TILT',
     &3X,'SENSE',2(5X,'MAGNITUDE',4X,'PHASE '),/,2(1X,'DEGREES',1X),3(6X
     &,'DB'),8X,'RATIO',5X,'DEG.',8X,2(6X,A,4X,'DEGREES'))
43    FORMAT (///,28X,' - - - RADIATED FIELDS NEAR GROUND - - -',//,8X,
     &'- - - LOCATION - - -',10X,'- - E(THETA) - -',8X,'- - E(PHI) - -',
     &8X,'- - E(RADIAL) - -',/,7X,'RHO',6X,'PHI',9X,'Z',12X,'MAG',6X,
     &'PHASE',9X,'MAG',6X,'PHASE',9X,'MAG',6X,'PHASE',/,5X,'METERS',3X,
     &'DEGREES',4X,'METERS',8X,'VOLTS/M',3X,'DEGREES',6X,'VOLTS/M',3X,
     &'DEGREES',6X,'VOLTS/M',3X,'DEGREES',/)
44    FORMAT(1X,F7.2,F9.2,3X,3F8.2,F11.5,F9.2,2X,A6,2(1PE15.5,0PF9.2))
45    FORMAT (3X,F9.2,2X,F7.2,2X,F9.2,1X,3(3X,1PE11.4,2X,0PF7.2))
46    FORMAT (//,3X,'AVERAGE POWER GAIN=',1PE12.5,7X,'SOLID ANGLE ',
     &'USED IN AVERAGING=(',0PF7.4,')*PI STERADIANS.',//,
     &3X,'POWER RADIATED ASSUMING RADIATION INTO 4*PI STERADIANS =',
     &1PE12.5,' WATTS')
47    FORMAT (//,37X,'- - - - NORMALIZED GAIN - - - -',//,37X,A12,'GAIN'
     &,/,38X,'NORMALIZATION FACTOR =',F9.2,' DB',//,3(4X,
     &'- - ANGLES - -',6X,'GAIN',7X),/,3(4X,'THETA',5X,'PHI',8X,'DB',8X)
     &,/,3(3X,'DEGREES',2X,'DEGREES',16X))
48    FORMAT (3(1X,2F9.2,1X,F9.2,6X))
49    FORMAT(' RDPAT: WARNING - THE CLIFF OR RADIAL-WIRE GROUND SCREEN '
     &,'APPROXIMATIONS ',/,' ARE NOT INCLUDED IN CALCULATING GROUND ',
     &'WAVE (RP1,...)')
50    FORMAT(/)
      END
      SUBROUTINE READGM(INUNIT,CODE,I1,I2,R1,R2,R3,R4,R5,R6,R7,R8,R9,
     &R10,FNAME)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     READGM calls PARSIT to read input commands in the format for
C     structure geometry data.
C
C     OUTPUT:
C     CODE        two letter mnemonic code
C     I1 - I2     integer values from record
C     R1 - R10    real values from record
C
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER CODE*(*),FNAME*(*),RECDAT*78
      DIMENSION INTVAL(2),REAVAL(10)
      ICMBLK=0
C
C     Call the routine to read the record and parse it.
C
1     CALL PARSIT(INUNIT,2,10,CODE,RECDAT,INTVAL,REAVAL,FNAME,IEOF)
      IF(IEOF.LT.0)CODE='GE'
C
C     Process text lines.  Then read next input line.
C
      IF(CODE.EQ.'CM')THEN
         CALL COMOUT(RECDAT,ICMBLK)
         GO TO 1
      END IF
      IF(ICMBLK.EQ.1)THEN
         ICMBLK=2
         CALL COMOUT(RECDAT,ICMBLK)
      END IF
C
C     Set the return variables to the buffer array elements.
C
      I1=INTVAL(1)
      I2=INTVAL(2)
      R1=REAVAL(1)
      R2=REAVAL(2)
      R3=REAVAL(3)
      R4=REAVAL(4)
      R5=REAVAL(5)
      R6=REAVAL(6)
      R7=REAVAL(7)
      R8=REAVAL(8)
      R9=REAVAL(9)
      R10=REAVAL(10)
      RETURN
      END
      SUBROUTINE READMN(INUNIT,CODE,I1,I2,I3,I4,F1,F2,F3,F4,F5,F6,F7,
     &FNAME)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     READMN calls PARSIT to read input commands in the format for
C     electrical parameters (after geometry data.)
C
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER CODE*(*),FNAME*(*),RECDAT*78
      DIMENSION INTVAL(4),REAVAL(7)
      ICMBLK=0
C
C     Call the routine to read the record and parse it.
C
1     CALL PARSIT(INUNIT,4,7,CODE,RECDAT,INTVAL,REAVAL,FNAME,IEOF)
      IF(IEOF.LT.0)CODE='EN'
C
C     Process text lines.  Then read next input line.
C
      IF(CODE.EQ.'CM')THEN
         CALL COMOUT(RECDAT,ICMBLK)
         GO TO 1
      END IF
      IF(ICMBLK.EQ.1)THEN
         ICMBLK=2
         CALL COMOUT(RECDAT,ICMBLK)
      END IF
C
C     Set the return variables to the buffer array elements.
C
      I1=INTVAL(1)
      I2=INTVAL(2)
      I3=INTVAL(3)
      I4=INTVAL(4)
      F1=REAVAL(1)
      F2=REAVAL(2)
      F3=REAVAL(3)
      F4=REAVAL(4)
      F5=REAVAL(5)
      F6=REAVAL(6)
      F7=REAVAL(7)
      RETURN
      END
      SUBROUTINE PARSIT(INLUN,MAXINT,MAXRE,CMND,RECDAT,INTFLD,REFLD,
     &FNAME,IEOF)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     PARSIT reads an input record and parses it.
C
C     OUTPUT:
C     MAXINT     total number of integers in record
C     MAXRE      total number of real values in record
C     CMND       two letter mnemonic code
C     INTFLD     integer values from record
C     REFLD      real values from record
C     FNAME      text returned.  Can be used for a file name.
C
C  *****  Internal Variables
C     BGNFLD     list of starting indices
C     BUFFER     text buffer
C     ENDFLD     list of ending indices
C     FLDTRM     flag to indicate that pointer is in field position
C     REC        input line as read
C     TOTCOL     total number of columns in REC
C     TOTFLD     number of numeric fields
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER  CMND*2, BUFFER*40, REC*80, RECDAT*78, FNAME*(*)
      INTEGER    INTFLD(MAXINT)
      INTEGER    BGNFLD(17), ENDFLD(17), TOTCOL, TOTFLD
      REAL*8     REFLD(MAXRE)
      LOGICAL    FLDTRM
C
      READ(INLUN, 8000, IOSTAT=IEOF) REC
      RECDAT=REC(3:80)
      CALL UPCASE( REC, REC, TOTCOL )
C
C     Store opcode and clear field arrays.
C
      CMND= REC(1:2)
      FNAME=' '
      DO 3000 I=1,MAXINT
         INTFLD(I)= 0
3000  CONTINUE
      DO 3010 I=1,MAXRE
         REFLD(I)= 0.0
3010  CONTINUE
      IF(IEOF.LT.0)RETURN
      IF(CMND.EQ.'CM'.OR.CMND.EQ.'CE')THEN
         CMND='CM'
         RETURN
      END IF
      DO 3020 I=1,17
         BGNFLD(I)= 0
         ENDFLD(I)= 0
3020  CONTINUE
C
C     Find the beginning and ending of each field as well as the total
C     number of fields.
C
      TOTFLD= 0
      NAMFLD= 0
      FLDTRM= .FALSE.
      LAST= MAXRE + MAXINT
      DO 4000 J=3,TOTCOL
         K= ICHAR( REC(J:J) )
C
C     Check for end of line comment (`!').  This is a new modification
C     to allow VAX-like comments at the end of data records, i.e.
C       GW 1 7 0 0 0 0 0 .5 .0001 ! DIPOLE WIRE
C       GE ! END OF GEOMETRY
C
      IF (K .EQ. 33) THEN
         IF (FLDTRM) ENDFLD(TOTFLD)= J - 1
         GO TO 5000
C
C     Set the ending index when the character is a comma or space and
C     the pointer is in a field position (FLDTRM = .TRUE.).
C
      ELSE IF (K .EQ. 32  .OR.  K .EQ. 44) THEN
         IF (FLDTRM) THEN
            ENDFLD(TOTFLD)= J - 1
            FLDTRM= .FALSE.
         ENDIF
C
C     Set beginning index when the character is not a comma or space and
C     the pointer is not currently in a field position (FLDTRM= .FALSE.)
C
      ELSE IF (.NOT. FLDTRM) THEN
         TOTFLD= TOTFLD + 1
         FLDTRM= .TRUE.
         BGNFLD(TOTFLD)= J
         IF(K.GT.57)NAMFLD=TOTFLD
      ENDIF
4000  CONTINUE
      IF (FLDTRM) ENDFLD(TOTFLD)= TOTCOL
C
C     Check to see if the total number of value fields is within the
C     precribed limits.
C
5000  IF (NAMFLD .GT. 0) THEN
         TOTFLD=TOTFLD-1
         IF(NAMFLD.NE.TOTFLD+1)THEN
            WRITE(3,8005)
            GO TO 9010
         END IF
         FNAME=REC(BGNFLD(NAMFLD):ENDFLD(NAMFLD))
      END IF
      IF (TOTFLD .EQ. 0) RETURN
      IF (TOTFLD .GT. LAST) THEN
         WRITE(3, 8001 )
         GO TO 9010
      END IF
      J= MIN( TOTFLD, MAXINT )
C
C     Parse out integer values and store into integer buffer array.
C
      DO 5090 I=1,J
         LENGTH= ENDFLD(I) - BGNFLD(I) + 1
         BUFFER= REC(BGNFLD(I):ENDFLD(I))
         IND= INDEX( BUFFER(1:LENGTH), '.' )
         IF (IND .GT. 0  .AND.  IND .LT. LENGTH) GO TO 9000
         IF (IND .EQ. LENGTH) LENGTH= LENGTH - 1
         READ( BUFFER(1:LENGTH), '(I15)', ERR=9000 ) INTFLD(I)
5090  CONTINUE
C
C     Parse out real values and store into real buffer array.
C
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
                  BUFFER= BUFFER(1:INDE-1)//'.'//BUFFER(INDE:LENGTH-1)
               ENDIF
            ENDIF
            READ(BUFFER(1:LENGTH),'(E20.5)',ERR=9000)REFLD(I-MAXINT)
6000  CONTINUE
      ENDIF
      RETURN
C
C     Print out text of record line when error occurs.
C
9000  IF (I .LE. MAXINT) THEN
         WRITE(3, 8002 ) I
      ELSE
         I= I - MAXINT
         WRITE(3, 8003 ) I
      END IF
9010  WRITE(3, 8004 ) REC
      STOP 'INPUT ERROR'
C
C     Input formats and output messages.
C
8000  FORMAT (A80)
8001  FORMAT (//,' PARSIT: INPUT ERROR - TOO MANY FIELDS IN RECORD')
8002  FORMAT (//,' PARSIT: INPUT ERROR - INVALID NUMBER AT INTEGER',
     &' POSITION ',I1)
8003  FORMAT (//,' PARSIT: INPUT ERROR - INVALID NUMBER AT REAL',
     &' POSITION ',I1)
8004  FORMAT (' ***** TEXT -->  ',A80)
8005  FORMAT (' PARSIT: INVALID ENTRY OF NON-NUMERIC DATA')
      END
      SUBROUTINE UPCASE( INTEXT, OUTTXT, LENGTH )
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     UPCASE finds the length of INTEXT and converts it to upper case.
C
      IMPLICIT REAL*8 (A-H,O-Z)
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
      SUBROUTINE REBLK (B,BX,NB,NBX,N2C,IUIN,IUOT)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     REBLK reblocks array B, in the N.G.F. solution, from blocks of
C     rows on unit IUIN to blocks of columns on unit IUOT.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 B,BX
      COMMON /MATPAR/ ICASE,NBLOKS,NPBLK,NLAST,NBLSYM,NPSYM,NLSYM,IMAT,I
     &CASX,NBBX,NPBX,NLBX,NBBL,NPBL,NLBL
      DIMENSION B(NB,*), BX(NBX,*)
      CLOSE(UNIT=IUOT,STATUS='DELETE',ERR=4)
4     CALL DAOPEN(IUOT,'TAPEBB.NEC','unknown','DELETE',NPBL*NB)
      NIB=0
      NPB=NPBL
      DO 3 IB=1,NBBL
      IF (IB.EQ.NBBL) NPB=NLBL
      NIX=0
      NPX=NPBX
      DO 2 IBX=1,NBBX
      IF (IBX.EQ.NBBX) NPX=NLBX
      CALL RECIN(BX,IUIN,1,NPBX*N2C,IBX,' READ BX IN REBLK')
      DO 1 I=1,NPX
      IX=I+NIX
      DO 1 J=1,NPB
1     B(IX,J)=BX(I,J+NIB)
2     NIX=NIX+NPBX
      CALL RECOT(B,IUOT,1,NB*NPB,IB,' WRITE B IN REBLK')
3     NIB=NIB+NPBL
      CLOSE(UNIT=IUIN,STATUS='DELETE')
      RETURN
      END
      SUBROUTINE REFLC (IX,IY,IZ,ITX,NOP)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     REFLC reflects a partial structure along X,Y, or Z axes or rotates
C     the structure to complete a symmetric structure.
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      DIMENSION T1X(MAXSEG),T1Y(MAXSEG),T1Z(MAXSEG),X2(MAXSEG),
     &   Y2(MAXSEG),Z2(MAXSEG)
      EQUIVALENCE (T1X,SI),(T1Y,ALP),(T1Z,BET),(X2,SI),(Y2,ALP),(Z2,BET)
      NP=N
      MP=M
      IPSYM=0
      ITI=ITX
      IF (IX.LT.0) GO TO 19
      IF (NOP.EQ.0) RETURN
      IPSYM=1
      IF (IZ.EQ.0) GO TO 6
C
C     REFLECT ALONG Z AXIS
C
      IPSYM=2
      IF (N.LT.N2) GO TO 3
      DO 2 I=N2,N
      NX=I+N-N1
      E1=Z(I)
      E2=Z2(I)
      IF (ABS(E1)+ABS(E2).GT.1.E-5.AND.E1*E2.GE.-1.E-6) GO TO 1
      WRITE(3,24) I
      STOP
1     X(NX)=X(I)
      Y(NX)=Y(I)
      Z(NX)=-E1
      X2(NX)=X2(I)
      Y2(NX)=Y2(I)
      Z2(NX)=-E2
      ITAGI=ITAG(I)
      IF (ITAGI.EQ.0) ITAG(NX)=0
      IF (ITAGI.NE.0) ITAG(NX)=ITAGI+ITI
2     BI(NX)=BI(I)
      N=N*2-N1
      ITI=ITI*2
3     IF (M.LT.M2) GO TO 6
      NXX=LD+1-M1
      DO 5 I=M2,M
      NXX=NXX-1
      NX=NXX-M+M1
      IF (ABS(Z(NXX)).GT.1.E-10) GO TO 4
      WRITE(3,25) I
      STOP
4     X(NX)=X(NXX)
      Y(NX)=Y(NXX)
      Z(NX)=-Z(NXX)
      T1X(NX)=T1X(NXX)
      T1Y(NX)=T1Y(NXX)
      T1Z(NX)=-T1Z(NXX)
      T2X(NX)=T2X(NXX)
      T2Y(NX)=T2Y(NXX)
      T2Z(NX)=-T2Z(NXX)
      SALP(NX)=-SALP(NXX)
5     BI(NX)=BI(NXX)
      M=M*2-M1
6     IF (IY.EQ.0) GO TO 12
C
C     REFLECT ALONG Y AXIS
C
      IF (N.LT.N2) GO TO 9
      DO 8 I=N2,N
      NX=I+N-N1
      E1=Y(I)
      E2=Y2(I)
      IF (ABS(E1)+ABS(E2).GT.1.E-5.AND.E1*E2.GE.-1.E-6) GO TO 7
      WRITE(3,24) I
      STOP
7     X(NX)=X(I)
      Y(NX)=-E1
      Z(NX)=Z(I)
      X2(NX)=X2(I)
      Y2(NX)=-E2
      Z2(NX)=Z2(I)
      ITAGI=ITAG(I)
      IF (ITAGI.EQ.0) ITAG(NX)=0
      IF (ITAGI.NE.0) ITAG(NX)=ITAGI+ITI
8     BI(NX)=BI(I)
      N=N*2-N1
      ITI=ITI*2
9     IF (M.LT.M2) GO TO 12
      NXX=LD+1-M1
      DO 11 I=M2,M
      NXX=NXX-1
      NX=NXX-M+M1
      IF (ABS(Y(NXX)).GT.1.E-10) GO TO 10
      WRITE(3,25) I
      STOP
10    X(NX)=X(NXX)
      Y(NX)=-Y(NXX)
      Z(NX)=Z(NXX)
      T1X(NX)=T1X(NXX)
      T1Y(NX)=-T1Y(NXX)
      T1Z(NX)=T1Z(NXX)
      T2X(NX)=T2X(NXX)
      T2Y(NX)=-T2Y(NXX)
      T2Z(NX)=T2Z(NXX)
      SALP(NX)=-SALP(NXX)
11    BI(NX)=BI(NXX)
      M=M*2-M1
12    IF (IX.EQ.0) GO TO 18
C
C     REFLECT ALONG X AXIS
C
      IF (N.LT.N2) GO TO 15
      DO 14 I=N2,N
      NX=I+N-N1
      E1=X(I)
      E2=X2(I)
      IF (ABS(E1)+ABS(E2).GT.1.E-5.AND.E1*E2.GE.-1.E-6) GO TO 13
      WRITE(3,24) I
      STOP
13    X(NX)=-E1
      Y(NX)=Y(I)
      Z(NX)=Z(I)
      X2(NX)=-E2
      Y2(NX)=Y2(I)
      Z2(NX)=Z2(I)
      ITAGI=ITAG(I)
      IF (ITAGI.EQ.0) ITAG(NX)=0
      IF (ITAGI.NE.0) ITAG(NX)=ITAGI+ITI
14    BI(NX)=BI(I)
      N=N*2-N1
15    IF (M.LT.M2) GO TO 18
      NXX=LD+1-M1
      DO 17 I=M2,M
      NXX=NXX-1
      NX=NXX-M+M1
      IF (ABS(X(NXX)).GT.1.E-10) GO TO 16
      WRITE(3,25) I
      STOP
16    X(NX)=-X(NXX)
      Y(NX)=Y(NXX)
      Z(NX)=Z(NXX)
      T1X(NX)=-T1X(NXX)
      T1Y(NX)=T1Y(NXX)
      T1Z(NX)=T1Z(NXX)
      T2X(NX)=-T2X(NXX)
      T2Y(NX)=T2Y(NXX)
      T2Z(NX)=T2Z(NXX)
      SALP(NX)=-SALP(NXX)
17    BI(NX)=BI(NXX)
      M=M*2-M1
18    RETURN
C
C     REPRODUCE STRUCTURE WITH ROTATION TO FORM CYLINDRICAL STRUCTURE
C
19    FNOP=NOP
      IPSYM=-1
      SAM=6.2831853071796D0/FNOP
      CS=COS(SAM)
      SS=SIN(SAM)
      IF (N.LT.N2) GO TO 21
      N=N1+(N-N1)*NOP
      NX=NP+1
      DO 20 I=NX,N
      K=I-NP+N1
      XK=X(K)
      YK=Y(K)
      X(I)=XK*CS-YK*SS
      Y(I)=XK*SS+YK*CS
      Z(I)=Z(K)
      XK=X2(K)
      YK=Y2(K)
      X2(I)=XK*CS-YK*SS
      Y2(I)=XK*SS+YK*CS
      Z2(I)=Z2(K)
      ITAGI=ITAG(K)
      IF (ITAGI.EQ.0) ITAG(I)=0
      IF (ITAGI.NE.0) ITAG(I)=ITAGI+ITI
20    BI(I)=BI(K)
21    IF (M.LT.M2) GO TO 23
      M=M1+(M-M1)*NOP
      NX=MP+1
      K=LD+1-M1
      DO 22 I=NX,M
      K=K-1
      J=K-MP+M1
      XK=X(K)
      YK=Y(K)
      X(J)=XK*CS-YK*SS
      Y(J)=XK*SS+YK*CS
      Z(J)=Z(K)
      XK=T1X(K)
      YK=T1Y(K)
      T1X(J)=XK*CS-YK*SS
      T1Y(J)=XK*SS+YK*CS
      T1Z(J)=T1Z(K)
      XK=T2X(K)
      YK=T2Y(K)
      T2X(J)=XK*CS-YK*SS
      T2Y(J)=XK*SS+YK*CS
      T2Z(J)=T2Z(K)
      SALP(J)=SALP(K)
22    BI(J)=BI(K)
23    RETURN
C
24    FORMAT (' REFLEC: GEOMETRY DATA ERROR - SEGMENT',I5,' LIES IN',
     &' PLANE OF SYMMETRY')
25    FORMAT (' REFLEC: GEOMETRY DATA ERROR - PATCH',I4,' LIES IN PLANE'
     &,' OF SYMMETRY')
      END
      SUBROUTINE ROMBG (A,B,N,FSUB,SUM,DMIN,RX)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     ROMBG performs variable interval width Romberg integration for an
C     N element vector function supplied by FSUB.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 SUM,G1,G2,G3,G4,G5,T00,T01,T10,T02,T11,T20
      DIMENSION SUM(9), G1(9), G2(9), G3(9), G4(9), G5(9), T01(9), T10(9
     &), T20(9)
      DATA NM,NTS,NX/65536,4,1/
      Z=A
      ZE=B
      S=B-A
      IF (S.GE.0.) GO TO 1
      WRITE(3,20)
      STOP
1     EP=S/(1.E4*NM)
      ZEND=ZE-EP
      DO 2 I=1,N
2     SUM(I)=(0.,0.)
      NS=NX
      NT=0
      CALL FSUB (Z,G1)
3     DZ=S/NS
      IF (Z+DZ.LE.ZE) GO TO 4
      DZ=ZE-Z
      IF (DZ.LE.EP) GO TO 18
4     DZOT=DZ*.5
      CALL FSUB (Z+DZOT,G3)
      CALL FSUB (Z+DZ,G5)
5     TMAG1=0.
      TMAG2=0.
C
C     EVALUATE 3 POINT ROMBERG RESULT AND TEST CONVERGENCE.
C     CONVERGENCE TEST ON FIRST 3 FUNCTIONS ONLY
C
      DO 6 I=1,N
      T00=(G1(I)+G5(I))*DZOT
      T01(I)=(T00+DZ*G3(I))*.5
      T10(I)=(4.*T01(I)-T00)/3.
      IF (I.GT.3) GO TO 6
      TR=DREAL(T01(I))
      TI=DIMAG(T01(I))
      TMAG1=TMAG1+TR*TR+TI*TI
      TR=DREAL(T10(I))
      TI=DIMAG(T10(I))
      TMAG2=TMAG2+TR*TR+TI*TI
6     CONTINUE
      TMAG1=SQRT(TMAG1)
      TMAG2=SQRT(TMAG2)
      CALL TEST (TMAG1,TMAG2,TR,0.D0,0.D0,TI,DMIN)
      IF (TR.GT.RX) GO TO 8
      DO 7 I=1,N
7     SUM(I)=SUM(I)+T10(I)
      NT=NT+2
      GO TO 12
8     CALL FSUB (Z+DZ*.25,G2)
      CALL FSUB (Z+DZ*.75,G4)
      TMAG1=0.
      TMAG2=0.
C
C     EVALUATE 5 POINT ROMBERG RESULT AND TEST CONVERGENCE.
C
      DO 9 I=1,N
      T02=(T01(I)+DZOT*(G2(I)+G4(I)))*.5
      T11=(4.*T02-T01(I))/3.
      T20(I)=(16.*T11-T10(I))/15.
      IF (I.GT.3) GO TO 9
      TR=DREAL(T11)
      TI=DIMAG(T11)
      TMAG1=TMAG1+TR*TR+TI*TI
      TR=DREAL(T20(I))
      TI=DIMAG(T20(I))
      TMAG2=TMAG2+TR*TR+TI*TI
9     CONTINUE
      TMAG1=SQRT(TMAG1)
      TMAG2=SQRT(TMAG2)
      CALL TEST (TMAG1,TMAG2,TR,0.D0,0.D0,TI,DMIN)
      IF (TR.GT.RX) GO TO 14
10    DO 11 I=1,N
11    SUM(I)=SUM(I)+T20(I)
      NT=NT+1
12    Z=Z+DZ
      IF (Z.GT.ZEND) GO TO 18
      DO 13 I=1,N
13    G1(I)=G5(I)
      IF (NT.LT.NTS.OR.NS.LE.NX) GO TO 3
      NS=NS/2
      NT=1
      GO TO 3
14    NT=0
      IF (NS.LT.NM) GO TO 16
      WRITE(3,21) Z
      DO 15 I=1,N
15    WRITE(3,19) G1(I),G2(I),G3(I),G4(I),G5(I)
      GO TO 10
16    NS=NS*2
      DZ=S/NS
      DZOT=DZ*.5
      DO 17 I=1,N
      G5(I)=G3(I)
17    G3(I)=G2(I)
      GO TO 5
18    CONTINUE
      RETURN
C
19    FORMAT (1P10E12.5)
20    FORMAT (' ROMBG: ERROR - B LESS THAN A')
21    FORMAT (' ROMBG: STEP SIZE LIMITED AT Z =',1PE12.5)
      END
      SUBROUTINE RXFLD (RHOX,ZSX,ZOX,IZS,ERV,EZV,ERH,EPH,EZH,IREG)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     RXFLD determines whether reflected or transmitted field is needed
C     and sets ZZ and ZZP for observer above the interface and source
C     below.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 ERV,EZV,ERH,EPH,EZH,CK1,CK1SQ,CK2,CK2SQ,CKS12,CON1,
     &CON2,CON3,CON4,EPSC1,XJK
      COMMON /GNRZZ/ CK1,CK1SQ,CK2,CK2SQ,CKS12,CON1,CON2,CON3,CON4,EPSC1
     &,XJK,RHO,ZS,ZO,ZZ,ZZP,AZP,ICASE
      RHO=RHOX
      ZS=ZSX
      ZO=ZOX
      IF (IZS.EQ.0) GO TO 1
      IF (IZS.GT.0.AND.ZO.GE.0.) GO TO 4
      IF (IZS.LT.0.AND.ZO.LT.0.) GO TO 5
      GO TO 2
1     IF (ZS.GE.0..AND.ZO.GE.0.) GO TO 4
      IF (ZS.LT.0..AND.ZO.LT.0.) GO TO 5
2     IF (ZO.LT.0.) GO TO 3
      ICASE=3
      ZZ=ZO
      ZZP=ZS
      GO TO 6
3     ICASE=4
      ZZ=ZS
      ZZP=ZO
      GO TO 6
4     ICASE=1
      ZZ=ZS+ZO
      ZZP=0.
      GO TO 6
5     ICASE=2
      ZZ=0.
      ZZP=ZS+ZO
6     AZP=-ZZP
      CALL TRXFLD (ERV,EZV,ERH,EPH,EZH,IREG)
      RETURN
      END
      SUBROUTINE SADPT (RHO,ZZ,ZP,XLS)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     SADPT obtains coordinates of the saddle point between the origin
C     and GCK2 (K+) by interpolation.  STRAC is called the first time
C     that SADPT is called for new ground parameters.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 XLA,GCK1,GCK1SQ,GCK2,GCK2SQ,XZ1,XZ2,XLS
      COMMON /GPARM/ XLA(21,21),GCK1,GCK1SQ,GCK2,GCK2SQ,ZRAT,RHON
      DATA CK1R,CK1I/0.D0,0.D0/,NDIM/21/,DR,DZ/0.D0,0.D0/
      IF (DREAL(GCK1).NE.CK1R.OR.DIMAG(GCK1).NE.CK1I)THEN
         CK1R=DREAL(GCK1)
         CK1I=DIMAG(GCK1)
         CALL STRAC (NDIM,NDIM)
         DR=1./(NDIM-1.)
         DZ=DR
      END IF
      IF (ZZ.LT.0..OR.ZP.GT.0.) THEN
         WRITE(3,90) RHO,ZZ,ZP
         STOP
      END IF
      ZRAT=ZZ-ZP
      RHON=SQRT(RHO*RHO+ZRAT*ZRAT)
      IF(RHON.GT.1.E-20)THEN
         RHON=RHO/RHON
      ELSE
         RHON=0.
      END IF
      IF (ZRAT.GT.1.E-20) THEN
         ZRAT=ZZ/ZRAT
      ELSE
         ZRAT=0.
      END IF
      IR=RHON/DR+1
      IF (IR.EQ.NDIM) IR=IR-1
      RX=RHON-(IR-1)*DR
      IZ=ZRAT/DZ+1
      IF (IZ.EQ.NDIM) IZ=IZ-1
      ZX=ZRAT-(IZ-1)*DZ
      XZ1=XLA(IR,IZ)*(DR-RX)+XLA(IR+1,IZ)*RX
      XZ2=XLA(IR,IZ+1)*(DR-RX)+XLA(IR+1,IZ+1)*RX
      XLS=(XZ1*(DZ-ZX)+XZ2*ZX)/(DR*DZ)
      RETURN
C
90    FORMAT (' SADPT: ERROR - RHO,ZZ,ZP=',1P3E12.5)
      END
      SUBROUTINE SDLPT (XL,IERR)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     SDLPT iterates to find the location of the saddle point for param-
C     eters ZRAT=ZZ/(ZZ-ZP) and RHON=RHO/SQRT(RHO**2+(ZZ-ZP)**2)
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 XLA,XL,GCK1,GCK1SQ,GCK2,GCK2SQ,CJRO,COM,CGAM1,CGAM2,
     &TERM
      COMMON /GPARM/ XLA(21,21),GCK1,GCK1SQ,GCK2,GCK2SQ,ZRAT,RHON
      ZMZZ=1.-RHON*RHON
      IF (ZMZZ.LT.0.) ZMZZ=0.
      ZMZZ=SQRT(ZMZZ)
      ZOZZ=ZMZZ*ZRAT
      ZMZZ=ZMZZ*(ZRAT-1.)
      CJRO=DCMPLX(0.D0,RHON)
      DO 1 I=1,100
      COM=XL-GCK1
      CGAM1=SQRT(XL+GCK1)*SQRT(COM)
      IF (DIMAG(COM).LT.0.) CGAM1=-CGAM1
      COM=XL-GCK2
      CGAM2=SQRT(XL+GCK2)*SQRT(COM)
      IF (DIMAG(COM).LT.0.) CGAM2=-CGAM2
      COM=2.*XL*XL
      TERM=ZOZZ*CGAM2*(COM-GCK1SQ)-ZMZZ*CGAM1*(COM-GCK2SQ)
      COM=TERM+CJRO*XL*(COM-GCK1SQ-GCK2SQ)
      TERM=CGAM1*CGAM2*(XL*(ZOZZ*CGAM1-ZMZZ*CGAM2)+CJRO*CGAM1*CGAM2)
      TERM=TERM/COM
      XL=XL-TERM
      TRM=ABS(TERM)
      IF (TRM.LT.1.E-5) GO TO 3
      IF (TRM.GT.1.E3) GO TO 2
1     CONTINUE
      IERR=1
      GO TO 4
2     IERR=2
      GO TO 4
3     IERR=0
      IF (DREAL(XL).GT.DREAL(GCK2)) IERR=3
4     RETURN
      END
      SUBROUTINE SECOND (CPUSECD)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     SECOND returns cpu time in seconds.  Must be customized!!!
C
C     VAX or other (modify subroutine stopwtch):
C
      REAL*8 CPUSECD
cx      CPUSECD=TIMEF()
cx    above line replaced with the following:
      CPUSECD=DBLE(ETIME())
C      CALL STOPWTCH(CPUSECS,WALLTOT,CPUSPLT,WALLSPLT)
C      CPUSECD=60.*CPUSECS
C     MACINTOSH:
C      CPUSECD= LONG(362)/60.0
      RETURN
      END
cx        subroutine stopwtch(cputot,walltot,cpusplt,wallsplt)
cxC=======================================================================
cxC     (C) Copyright 1992
cxC     The Regents of the University of California.  All rights reserved.
cxC=======================================================================c
cxc
cxc       stopwtch operates as a stopwatch for CPU time.  When first
cxc       called, the routine initializes the clock.  On subsequent calls
cxc       the routine returns:
cxc
cxc       Outputs: cputot   -- elapsed CPU time since initialization
cxc                walltot  -- elapsed wallclock time since initialization
cxc                cpusplt  -- split (delta) CPU time since previous call
cxc                wallsplt -- split wallclock time since previous call
cxc
cxc       These outputs will all be zero (or very close to it) on the
cxc       first (initialization) call.
cxc
cxc       Internal times (cpuinit,wallinit,cpunow,wallnow) are stored in
cxc       seconds.  cpuinit  and cpunow  are stored as reals,
cxc                 wallinit and wallnow are stored as integers.
cxc       Output times are converted to real minutes.
cxc
cxc History:
cxc   Date       Author            Reason
cxc   ---------  ----------------  ------------------------------------
cxc    early-90  Scott L. Ray      initial version
cxc      mid-90  Scott L. Ray      support for additional machines
cxc   14-JAN-91                    ---- Version 2.2/release    ----
cxc   23-MAY-91  Scott L. Ray      UNICOS branch
cxc   29-JAN-92  Scott L. Ray      FPS and NLTSS support dropped
cxc   29-JAN-92  Scott L. Ray      switch to cpp conditional compilation
cxc   18-SEP-92      Conditional compilation disabled for use in NEC
cxc ----------------------------------------------------------------------
cxc
cxc parameter list
cxc
cx        real cputot,walltot,cpusplt,wallsplt
cxc
cxc locals (non sysdep)
cxc
cx        logical initiz
cx        integer wallinit,walllast,wallnow
cx        real cpuinit,cpulast,cpunow
cx        save initiz,cpuinit,cpulast,wallinit,walllast
cxc
cxc locals (sysdep)
cxc
cxC#include "machines.h"
cxC#ifdef VAX_VMS
cxC        integer istatus,iwall,icpu
cxC        real rwall
cxC        dimension iwall(2)
cxC#endif
cxC#ifdef SUN4TIMER
cxC        integer time
cxC        real tarray
cxC        dimension tarray(2)
cxC#endif
cxC#ifdef CONVEX
cxC        real time, secnds, tarray
cxC        dimension tarray(2)
cxC        external secnds
cxC#endif
cxC#ifdef IBM_RISC
cx        integer icpu
cx        integer mclock
cxC#endif
cxC#ifdef IRIS4D
cxC        external time
cxC#endif
cxC#ifdef STARDENT
cxC        integer stime
cxC        real tarray
cxC        dimension tarray(2)
cxC#endif
cxC#ifdef UNICOS
cxC        real rwall
cxC#endif
cxc
cxc data initialization
cxc
cx        data initiz/.false./
cxc
cxc ----------------------------------------------------------------------
cxc
cx        if (.not. initiz) then
cxc
cxc ...      set the flag showing that the clock has been initialized
cxc
cx           initiz = .true.
cxc
cxc ...      set the initial times to default value of zero.  These may
cxc          be changed, depending on how an individual machine handles
cxc          its timer.
cxc
cx           cpuinit  = 0.0
cx           wallinit = 0
cxc
cxc ...      initialize the timer (may not be necessary on all machines)
cxc
cxC#ifdef VAX_VMS
cxC           istatus = lib$init_timer()
cxC#endif
cxc
cxC#ifdef SUN4TIMER
cxc          CPU timer on SUN4 initializes automatically on job startup.
cxc          However, we want t=0 to be defined when this routine is first
cxc          called.  Hence, define initial CPU time here.
cxc          Wall clock timer counts in seconds from 1-Jan-70  Thus,
cxc          initial wall clock time is non-zero.  It is obtained here.
cxc
cxC           cpuinit  = etime(tarray)
cxC           wallinit = time()
cxC#endif
cxc
cxC#ifdef CONVEX
cxC           cpuinit = etime(tarray)
cxC           time = secnds(0.0)
cxC           wallinit = ifix(time)
cxC#endif
cxc
cxC#ifdef IBM_RISC
cxc          no known wall clock timer
cxc
cxC           icpu = mclock( )
cxC           cpuinit  = float(icpu)/100.0
cxC           wallinit = 0
cxC#endif
cxc
cxC#ifdef STARDENT
cxc          CPU timer on STARDENT initializes automatically on job
cxc          startup.
cxc          However, we want t=0 to be defined when this routine is first
cxc          called.  Hence, define initial CPU time here.
cxc          Wall clock timer counts in seconds from 1-Jan-70  Thus,
cxc          initial wall clock time is non-zero.  It is obtained here.
cxc
cxC           cpuinit  = etime(tarray)
cxC           wallinit = stime()
cxC#endif
cxc
cxC#ifdef UNICOS
cxc          I hope that the "second" routine is true UNICOS and not a
cxc          local (LLNL) feature that was added on to keep things
cxc          consistent with NLTSS.
cxc          The "timef" routine returns real milliseconds; first
cxc          call initializes the timer and should return zero (not
cxc          that we care -- this routine works by taking differences).
cxc
cxC           call second(cpuinit)
cxC           call timef(rwall)
cxC           wallinit = ifix(rwall*1.0e-03)
cxC#endif
cxc
cxc ...      since this is the first call to this routine,
cxc          initialize the previous call times to the initial time.
cxc
cx           cpulast  =  cpuinit
cx           walllast = wallinit
cxc
cx        end if
cxc
cxc ...   Find the current cpu and wall times
cxc
cxC#ifdef HASTIMER
cxC#ifdef VAX_VMS
cxc
cxc       function "lib$stat_timer" is called as:
cxc       error_status = lib$stat_timer(input_code,output_result,junk)
cxc       where,
cxc        input_code = 1 returns elapsed wall clock time in VAX_VMS
cxc           binary internal format.  This format takes 64 bits to store,
cxc           hence output_result should be a 32 bit integer array of
cxc           length 2.
cxc           This internal format is converted to a floating point number
cxc           by calling "lib$cvtf_from_internal_time".  This function
cxc           is poorly documented in the VAX_VMS manuals.  Here are some
cxc           details:  First argument = 28 ==> result in real hours
cxc                                    = 29 ==> result in real minutes
cxc                                    = 30 ==> result in real seconds
cxc           The input to "lib$cvtf_from_internal_time" goes in the 3rd
cxc           argument, the result is returned in the 2nd argument.
cxc           input_code = 2 returns elapsed cpu time as an integer in
cxc           units of 10msec.  This is converted to seconds here.
cxc
cxC        istatus = lib$stat_timer(1,iwall,)
cxC        istatus = lib$cvtf_from_internal_time(30,rwall,iwall)
cxC        wallnow = rwall
cxC        istatus = lib$stat_timer(2,icpu,)
cxC        cpunow = icpu*(10.0e-3)
cxC#endif
cxc
cxC#ifdef SUN4TIMER
cxc       there is some ambiguity in the manual as to how to use
cxc       etime.  Function returns:
cxc          "elapsed execution time" = tarray(1) + tarray(2)
cxc                                   = user time + system time
cxc       I am uncertain whether to let cpunow = return value or
cxc       else tarray(1).
cxc
cxC        cpunow  = etime(tarray)
cxC        wallnow = time()
cxC#endif
cxc
cxC#ifdef CONVEX
cxC           cpunow = etime(tarray)
cxC           time = secnds(0.0)
cxC           wallnow = ifix(time)
cxC#endif
cxc
cxC#ifdef IBM_RISC
cxc       no known wall clock timer
cxc
cxC        icpu = mclock( )
cxC        cpunow  = float(icpu)/100.0
cxC        wallnow = 0
cxC#endif
cxc
cxC#ifdef STARDENT
cxc       there is some ambiguity in the manual as to how to use
cxc       etime.  Function returns:
cxc          "elapsed execution time" = tarray(1) + tarray(2)
cxc                                   = user time + system time
cxc       I am uncertain whether to let cpunow = return value or
cxc       else tarray(1).
cxc
cxC        cpunow  = etime(tarray)
cxC        wallnow = stime()
cxC#endif
cxc
cxC#ifdef UNICOS
cxc       I hope that the "second" routine is true UNICOS and not a
cxc       local (LLNL) feature that was added on to keep things
cxc       consistent with NLTSS.
cxc       The "timef" routine returns real milliseconds.
cxc
cxC        call second(cpunow)
cxC        call timef(rwall)
cxC        wallnow = ifix(rwall*1.0e-03)
cxC#endif
cxC#else
cxc       for machines without timers or with unknown timers,
cxc       set things to zero now to ensure that something is returned
cxC        cpunow  = 0.0
cxC        wallnow = 0
cxC#endif
cxc
cxc ...   calculate elapsed and split cpu and wall clock times,
cxc       convert to minutes on output.
cxc
cx        cputot   = (cpunow  - cpuinit )/60.0
cx        walltot  = float(wallnow - wallinit)/60.0
cx        cpusplt  = (cpunow  - cpulast )/60.0
cx        wallsplt = float(wallnow - walllast)/60.0
cxc
cxc ...   save "now" times in "last" times
cxc
cx        cpulast  = cpunow
cx        walllast = wallnow
cxc
cx        return
cxc **********************************************************************
cx        end
      SUBROUTINE SOLGF (A,B,C,D,XY,IP,NP,N1,N,MP,M1,M,N1C,N2C,N2CZ)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     SOLGF solves for current in the N.G.F. procedure.
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 A,B,C,D,SUM,XY,Y,AX,BX,CX
      COMMON /SCRATM/ Y(2*MAXSEG)
      COMMON /SEGJ/ AX(NSJMAX),BX(NSJMAX),CX(NSJMAX),JCO(NSJMAX),JSNO,
     &ISCON(NSCNGF),NSCON,IPCON(NSPNGF),NPCON
      COMMON /MATPAR/ ICASE,NBLOKS,NPBLK,NLAST,NBLSYM,NPSYM,NLSYM,IMAT,I
     &CASX,NBBX,NPBX,NLBX,NBBL,NPBL,NLBL
      DIMENSION A(*),B(N1C,*), C(N1C,*), D(N2CZ,*), IP(*), XY(*)
      IF (N2C.EQ.0)THEN
C
C        NORMAL SOLUTION.  NOT N.G.F.
C
         CALL SOLVES (A,IP,XY,N1C,1,NP,N,MP,M,11)
         RETURN
      END IF
      IF (N1.NE.N.AND.M1.GT.0)THEN
C
C        REORDER EXCITATION ARRAY
         N2=N1+1
         JJ=N+1
         NPM=N+2*M1
         DO 2 I=N2,NPM
2        Y(I)=XY(I)
         J=N1
         DO 3 I=JJ,NPM
         J=J+1
3        XY(J)=Y(I)
         DO 4 I=N2,N
         J=J+1
4        XY(J)=Y(I)
      END IF
C
C     COMPUTE INV(A)E1
C
      NEQS=NSCON+2*NPCON
      IF (NEQS.GT.0)THEN
         NEQ=N1C+N2C
         NEQS=NEQ-NEQS+1
         DO 6 I=NEQS,NEQ
6        XY(I)=(0.,0.)
      END IF
      CALL SOLVES (A,IP,XY,N1C,1,NP,N1,MP,M1,11)
      NI=0
C
C     COMPUTE E2-C(INV(A)E1)
C
      NPB=NPBL
      DO 10 JJ=1,NBBL
      IF (JJ.EQ.NBBL) NPB=NLBL
      IF (ICASX.GT.1) CALL RECIN(C,13,1,N1C*NPB,JJ,' READ C IN SOLGF')
      II=N1C+NI
      DO 9 I=1,NPB
      SUM=(0.,0.)
      DO 8 J=1,N1C
8     SUM=SUM+C(J,I)*XY(J)
      J=II+I
9     XY(J)=XY(J)-SUM
10    NI=NI+NPBL
      JJ=N1C+1
C
C     COMPUTE INV(D)(E2-C(INV(A)E1)) = I2
C
      IF (ICASX.EQ.1)THEN
         CALL SOLVE (N2C,D,IP(JJ),XY(JJ),N2C)
      ELSE IF(ICASX.EQ.2 .OR. ICASX.EQ.3)THEN
         NI=N2C*N2C
         CALL RECIN(B,14,1,NI,1,' READ B IN SOLGF')
         CALL SOLVE (N2C,B,IP(JJ),XY(JJ),N2C)
      ELSE IF(ICASX.EQ.4)THEN
         CALL LTSOLV (B,N2C,IP(JJ),XY(JJ),N2C,1,NBBL,NPBL,NLBL,0,14)
      END IF
C
C     COMPUTE INV(A)E1-(INV(A)B)I2 = I1
C
      NI=0
      NPB=NPBL
      DO 16 JJ=1,NBBL
      IF (JJ.EQ.NBBL) NPB=NLBL
      IF (ICASX.GT.1) CALL RECIN(B,12,1,N1C*NPB,JJ,
     & ' READ B FROM UNIT 12 IN SOLGF')
      II=N1C+NI
      DO 15 I=1,N1C
      SUM=(0.,0.)
      DO 14 J=1,NPB
      JP=II+J
14    SUM=SUM+B(I,J)*XY(JP)
15    XY(I)=XY(I)-SUM
16    NI=NI+NPBL
      IF (N1.NE.N.AND.M1.GT.0)THEN
C
C        REORDER CURRENT ARRAY
         DO 17 I=N2,NPM
17       Y(I)=XY(I)
         JJ=N1C+1
         J=N1
         DO 18 I=JJ,NPM
         J=J+1
18       XY(J)=Y(I)
         DO 19 I=N2,N1C
         J=J+1
19       XY(J)=Y(I)
      END IF
      IF (NSCON.GT.0)THEN
         J=NEQS-1
         DO 21 I=1,NSCON
         J=J+1
         JJ=ISCON(I)
21       XY(JJ)=XY(J)
      END IF
      RETURN
      END
      SUBROUTINE SOLVE (N,A,IP,B,NDIM)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     SOLVE solves the matrix equation LU*X=B where L is a unit
C     lower triangular matrix and U is an upper triangular matrix both
C     of which are stored in A.  The RHS vector B is input and the
C     solution is returned through vector B.
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 A,B,Y,SUM
      INTEGER PI
      COMMON /SCRATM/ Y(2*MAXSEG)
      DIMENSION A(NDIM,NDIM), IP(NDIM), B(NDIM)
C
C     FORWARD SUBSTITUTION
C
      DO 3 I=1,N
      PI=IP(I)
      Y(I)=B(PI)
      B(PI)=B(I)
      IP1=I+1
      IF (IP1.GT.N) GO TO 2
      DO 1 J=IP1,N
      B(J)=B(J)-A(J,I)*Y(I)
1     CONTINUE
2     CONTINUE
3     CONTINUE
C
C     BACKWARD SUBSTITUTION
C
      DO 6 K=1,N
      I=N-K+1
      SUM=(0.,0.)
      IP1=I+1
      IF (IP1.GT.N) GO TO 5
      DO 4 J=IP1,N
      SUM=SUM+A(I,J)*B(J)
4     CONTINUE
5     CONTINUE
      B(I)=(Y(I)-SUM)/A(I,I)
6     CONTINUE
      RETURN
      END
      SUBROUTINE SOLVES (A,IP,B,NEQ,NRH,NP,N,MP,M,IU1)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     SOLVES performs the transformation of the right-hand side vector
C     for symmetric structures, and in any case calls routines to solve
C     the matrix equation for in-core or disk storage.
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 A,B,Y,SUM,SSX
      COMMON /SMAT/ SSX(MAXSYM,MAXSYM)
      COMMON /SCRATM/ Y(2*MAXSEG)
      COMMON /MATPAR/ ICASE,NBLOKS,NPBLK,NLAST,NBLSYM,NPSYM,NLSYM,IMAT,I
     &CASX,NBBX,NPBX,NLBX,NBBL,NPBL,NLBL
      DIMENSION A(*), IP(*), B(NEQ,NRH)
      NPEQ=NP+2*MP
      NOP=NEQ/NPEQ
      FNOP=NOP
      FNORM=1./FNOP
      NROW=NEQ
      IF (ICASE.GT.3) NROW=NPEQ
      IF (NOP.GT.1)THEN
         DO 10 IC=1,NRH
         IF (N.GT.0.AND.M.GT.0)THEN
            DO 1 I=1,NEQ
1           Y(I)=B(I,IC)
            KK=2*MP
            IA=NP
            IB=N
            J=NP
            DO 5 K=1,NOP
            IF (K.GT.1)THEN
               DO 2 I=1,NP
               IA=IA+1
               J=J+1
2              B(J,IC)=Y(IA)
            END IF
            IF (K.LT.NOP)THEN
               DO 4 I=1,KK
               IB=IB+1
               J=J+1
4              B(J,IC)=Y(IB)
            END IF
5           CONTINUE
         END IF
C
C        TRANSFORM MATRIX EQ. RHS VECTOR ACCORDING TO SYMMETRY MODES
C
         DO 10 I=1,NPEQ
         DO 7 K=1,NOP
         IA=I+(K-1)*NPEQ
7        Y(K)=B(IA,IC)
         SUM=Y(1)
         DO 8 K=2,NOP
8        SUM=SUM+Y(K)
         B(I,IC)=SUM*FNORM
         DO 10 K=2,NOP
         IA=I+(K-1)*NPEQ
         SUM=Y(1)
         DO 9 J=2,NOP
9        SUM=SUM+Y(J)*DCONJG(SSX(K,J))
10       B(IA,IC)=SUM*FNORM
      END IF
C
C     SOLVE EACH MODE EQUATION
C
      DO 16 KK=1,NOP
      KREC=(KK-1)*NBLSYM
      IA=(KK-1)*NPEQ+1
      IB=IA
      IF (ICASE.EQ.4)THEN
         I=NPEQ*NPEQ
         CALL RECIN(A,IU1,1,I,KK,'Read for ICASE=4 in SOLVES')
         IB=1
      END IF
      IF (ICASE.EQ.1.OR.ICASE.EQ.2.OR.ICASE.EQ.4)THEN
         DO 14 IC=1,NRH
14       CALL SOLVE (NPEQ,A(IB),IP(IA),B(IA,IC),NROW)
      ELSE
         CALL LTSOLV (A,NPEQ,IP(IA),B(IA,1),NEQ,NRH,NBLSYM,NPSYM,NLSYM,
     &   KREC,IU1)
      END IF
16    CONTINUE
      IF (NOP.EQ.1) RETURN
C
C     INVERSE TRANSFORM THE MODE SOLUTIONS
C
      DO 26 IC=1,NRH
      DO 20 I=1,NPEQ
      DO 17 K=1,NOP
      IA=I+(K-1)*NPEQ
17    Y(K)=B(IA,IC)
      SUM=Y(1)
      DO 18 K=2,NOP
18    SUM=SUM+Y(K)
      B(I,IC)=SUM
      DO 20 K=2,NOP
      IA=I+(K-1)*NPEQ
      SUM=Y(1)
      DO 19 J=2,NOP
19    SUM=SUM+Y(J)*SSX(K,J)
20    B(IA,IC)=SUM
      IF (N.EQ.0.OR.M.EQ.0) GO TO 26
      DO 21 I=1,NEQ
21    Y(I)=B(I,IC)
      KK=2*MP
      IA=NP
      IB=N
      J=NP
      DO 25 K=1,NOP
      IF (K.GT.1)THEN
         DO 22 I=1,NP
         IA=IA+1
         J=J+1
22       B(IA,IC)=Y(J)
      END IF
      IF (K.LT.NOP)THEN
         DO 24 I=1,KK
         IB=IB+1
         J=J+1
24       B(IB,IC)=Y(J)
      END IF
25    CONTINUE
26    CONTINUE
      RETURN
      END
      SUBROUTINE STRAC (NZ,NR)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     STRAC fills the interpolation table (XLA) for locations of the
C     saddle-point between 0. and GCK2.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 XLA,XL,XLL,GCK1,GCK1SQ,GCK2,GCK2SQ
      COMMON /GPARM/ XLA(21,21),GCK1,GCK1SQ,GCK2,GCK2SQ,ZRAT,RHON
      DZ=1./(NZ-1.)
      DR=1./(NR-1.)
      ZRAT=-DZ
      DO 9 IZ=1,NZ
      ZRAT=ZRAT+DZ
      XLA(1,IZ)=(0.,0.)
      XLA(NR,IZ)=GCK2
      ROZX=0.
      XLL=(0.,0.)
      NRM=NR-1
      DO 6 IR=2,NRM
      ROZX=ROZX+DR
      IF (IZ.EQ.1) THEN
         XL=GCK1*ROZX
         IF (DREAL(XL).GT.DREAL(GCK2)) XL=GCK2
         XLA(IR,IZ)=XL
      ELSE IF (IZ.EQ.NZ) THEN
         XLA(IR,IZ)=GCK2*ROZX
      ELSE
         DRX=DR
         NRX=1
3        XL=XLL
         RHON=ROZX-DR
         DO 4 IX=1,NRX
         RHON=RHON+DRX
         CALL SDLPT (XL,IERR)
         IF (IERR.NE.0) THEN
            NRX=2*NRX
            DRX=.5*DRX
            IF (NRX.LE.256) GO TO 3
            IF (IERR.NE.3) THEN
               WRITE(3,11) IR,IZ
               STOP
            END IF
            IRS=IR
            DO 8 IRX=IRS,NRM
8           XLA(IRX,IZ)=GCK2
            GO TO 9
         END IF
4        CONTINUE
         XLA(IR,IZ)=XL
         XLL=XL
      END IF
6     CONTINUE
9     CONTINUE
      RETURN
C
11    FORMAT (' STRAC: AN ERROR OCCURRED IN FILLING THE INTERPOLATION',
     &' TABLES,  IR,IZ=',2I7)
      END
      SUBROUTINE TEST (F1R,F2R,TR,F1I,F2I,TI,DMIN)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     TEST tests for convergence in the Romberg numerical integration.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      DEN=ABS(F2R)
      TR=ABS(F2I)
      IF (DEN.LT.TR) DEN=TR
      IF (DEN.LT.DMIN) DEN=DMIN
      IF (DEN.LT.1.E-37) GO TO 1
      TR=ABS((F1R-F2R)/DEN)
      TI=ABS((F1I-F2I)/DEN)
      RETURN
1     TR=0.
      TI=0.
      RETURN
      END
      SUBROUTINE TRXFLD (ERV,EZV,ERH,EPH,EZH,IREG)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     TRXFLD returns transmitted E field at RHO,ZO due to a source
C     at ZS on the Z axis.  Field values are obtained by interpolation
C     or L.S. approximation with the transitions smoothed.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 ERV,EZV,ERH,EPH,EZH,FRV,FZV,FRH,FPH,FZH,CK1,CK1SQ,CK2,
     &CK2SQ,CKS12,CON1,CON2,CON3,CON4,EPSC1,XJK
      COMMON /GREGON/ RHOA(3),RHOB(3),ZZA(3),ZZB(3),ZPA(3),ZPB(3),ELM,EL
     &MX,SCFAC,RHMX1,ZZMX1,ZPMX1,RHMX2,ZZMX2,ZPMX2,ZPMXX
      COMMON /GNRZZ/ CK1,CK1SQ,CK2,CK2SQ,CKS12,CON1,CON2,CON3,CON4,EPSC1
     &,XJK,RHO,ZS,ZO,ZZ,ZZP,AZP,ICASE
      IF (RHO.GT.ELM) GO TO 3
      IF (ZZ.GT.ELM) GO TO 3
      CALL INTREG (ERV,EZV,ERH,EPH,EZH)
      IF (RHO.LT.ELMX.AND.ZZ.LT.ELMX) RETURN
      IF(AZP.GT.ZPMX2)RETURN
      IF (ZZ.GT.RHO) GO TO 1
      S=(RHO-ELMX)*SCFAC
      GO TO 2
1     S=(ZZ-ELMX)*SCFAC
2     S=.5*(COS(S)+1.)
      CALL FITLS (FRV,FZV,FRH,FPH,FZH,IREG)
      ERV=(ERV-FRV)*S+FRV
      EZV=(EZV-FZV)*S+FZV
      ERH=(ERH-FRH)*S+FRH
      EPH=(EPH-FPH)*S+FPH
      EZH=(EZH-FZH)*S+FZH
      RETURN
3     CALL FITLS (ERV,EZV,ERH,EPH,EZH,IREG)
      RETURN
      END
      SUBROUTINE UNERE (XOB,YOB,ZOB)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     UNERE calculates the electric field due to unit current in the T1
C     and T2 directions on a patch.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 H1X,H1Y,H1Z,H2X,H2Y,H2Z,XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,
     &ETAL2,FRATI,XK,ETX,TT1,TT2,RKJ,ER,Q1,Q2,ZRATI,RRV,RRH,EDP
      COMMON/DATAP/H1X,H1Y,H1Z,H2X,H2Y,H2Z,SPATJ,XPATJ,YPATJ,ZPATJ,T1XJ,
     &T1YJ,T1ZJ,T2XJ,T2YJ,T2ZJ,IPGND
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      IF (ZPATJ.GE.0.)THEN
         XK=XKU
         ETX=ETAU
      ELSE
         XK=XKL
         ETX=ETAL
      END IF
      ZR=ZPATJ
      T1ZR=T1ZJ
      T2ZR=T2ZJ
      IF (IPGND.EQ.2)THEN
         ZR=-ZR
         T1ZR=-T1ZR
         T2ZR=-T2ZR
      END IF
      RX=XOB-XPATJ
      RY=YOB-YPATJ
      RZ=ZOB-ZR
      R2=RX*RX+RY*RY+RZ*RZ
      IF (R2.LT.1.E-20)THEN
         H1X=(0.,0.)
         H1Y=(0.,0.)
         H1Z=(0.,0.)
         H2X=(0.,0.)
         H2Y=(0.,0.)
         H2Z=(0.,0.)
         RETURN
      END IF
      R=SQRT(R2)
      TT1=XK*R
      TT2=TT1*TT1
      RKJ=(0.,1.)*TT1
      ER=EXP(-RKJ)*SPATJ*ETX/(RKJ*12.56637062)
      Q1=(TT2-RKJ-1.)*ER/R2
      Q2=(3.*(1.+RKJ)-TT2)*ER/(R2*R2)
      ER=Q2*(T1XJ*RX+T1YJ*RY+T1ZR*RZ)
      H1X=Q1*T1XJ+ER*RX
      H1Y=Q1*T1YJ+ER*RY
      H1Z=Q1*T1ZR+ER*RZ
      ER=Q2*(T2XJ*RX+T2YJ*RY+T2ZR*RZ)
      H2X=Q1*T2XJ+ER*RX
      H2Y=Q1*T2YJ+ER*RY
      H2Z=Q1*T2ZR+ER*RZ
      IF (IPGND.EQ.1) GO TO 8
      IF (IPERF.EQ.1) THEN
         H1X=-H1X
         H1Y=-H1Y
         H1Z=-H1Z
         H2X=-H2X
         H2Y=-H2Y
         H2Z=-H2Z
         GO TO 8
      END IF
      XYMAG=SQRT(RX*RX+RY*RY)
      ZRATI=XKU/XKL
      IF (ZPATJ.LT.0.) ZRATI=XKL/XKU
      IF (XYMAG.LT.1.E-10) THEN
         PX=0.
         PY=0.
         CTH=1.
         RRV=(1.,0.)
      ELSE
         PX=-RY/XYMAG
         PY=RX/XYMAG
         CTH=ABS(RZ)/SQRT(XYMAG*XYMAG+RZ*RZ)
         RRV=SQRT(1.-ZRATI*ZRATI*(1.-CTH*CTH))
      END IF
      RRH=ZRATI*CTH
      RRH=(RRH-RRV)/(RRH+RRV)
      RRV=ZRATI*RRV
      RRV=-(CTH-RRV)/(CTH+RRV)
      EDP=(H1X*PX+H1Y*PY)*(RRH-RRV)
      H1X=H1X*RRV+EDP*PX
      H1Y=H1Y*RRV+EDP*PY
      H1Z=H1Z*RRV
      EDP=(H2X*PX+H2Y*PY)*(RRH-RRV)
      H2X=H2X*RRV+EDP*PX
      H2Y=H2Y*RRV+EDP*PY
      H2Z=H2Z*RRV
8     RETURN
      END
      SUBROUTINE WIRE (XW1,YW1,ZW1,XW2,YW2,ZW2,RAD,RDEL,RRAD,NS,ITG)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     WIRE generates segment geometry data for a straight wire of NS
C     segments.
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      DIMENSION X2(MAXSEG), Y2(MAXSEG), Z2(MAXSEG)
      EQUIVALENCE (X2(1),SI(1)), (Y2(1),ALP(1)), (Z2(1),BET(1))
      IST=N+1
      N=N+NS
      NP=N
      MP=M
      IPSYM=0
      IF (NS.LT.1) RETURN
      XD=XW2-XW1
      YD=YW2-YW1
      ZD=ZW2-ZW1
      IF (ABS(RDEL-1.).LT.1.E-6) GO TO 1
      DELZ=SQRT(XD*XD+YD*YD+ZD*ZD)
      XD=XD/DELZ
      YD=YD/DELZ
      ZD=ZD/DELZ
      DELZ=DELZ*(1.-RDEL)/(1.-RDEL**NS)
      RD=RDEL
      GO TO 2
1     FNS=NS
      XD=XD/FNS
      YD=YD/FNS
      ZD=ZD/FNS
      DELZ=1.
      RD=1.
2     RADZ=RAD
      XS1=XW1
      YS1=YW1
      ZS1=ZW1
      DO 3 I=IST,N
      ITAG(I)=ITG
      XS2=XS1+XD*DELZ
      YS2=YS1+YD*DELZ
      ZS2=ZS1+ZD*DELZ
      X(I)=XS1
      Y(I)=YS1
      Z(I)=ZS1
      X2(I)=XS2
      Y2(I)=YS2
      Z2(I)=ZS2
      BI(I)=RADZ
      DELZ=DELZ*RD
      RADZ=RADZ*RRAD
      XS1=XS2
      YS1=YS2
3     ZS1=ZS2
      X2(N)=XW2
      Y2(N)=YW2
      Z2(N)=ZW2
      RETURN
      END
      SUBROUTINE INSET(OMEGIN)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     INSET FILLS THE ARRAYS CEINS AND BRINS IN COMMON/INSCOM/
C     WITH THE COMPLEX PERMITTIVITY AND RADIUS OF THE WIRE SHEATH
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 CEINS
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON/INSCOM/CEINS(MAXSEG),BRINS(MAXSEG),NINS,NINSF,INTAG(MAXIS),
     &INTAGF(MAXIS),INTAGT(MAXIS),EPSIN(MAXIS),SIGIN(MAXIS),RADIN(MAXIS)
      COMMON/CONSTN/PI,TP,DTORAD,CVEL,EPSRZ,RMUZ,ETAZ
      IF(NINS.EQ.0)GO TO 9
      EPCON=1./(OMEGIN*EPSRZ)
C
C     PRINT HEADING AND INITIALIZE ARRAYS
C
      WRITE(3,90)
      DO 1 I=N2,N
      BRINS(I)=0.
1     CEINS(I)=(1.,0.)
      IWARN=0
C
C     LOOP OVER INSULATION COMMANDS
C
      DO 10 IS=1,NINS
      WRITE(3,91)INTAG(IS),INTAGF(IS),INTAGT(IS),EPSIN(IS),SIGIN(IS),
     &RADIN(IS)
C
C     SEARCH FOR SEGMENTS IN THE RANGE SPECIFIED
C
      IF((INTAG(IS).NE.0).OR.(INTAGF(IS).EQ.0.AND.INTAGT(IS).EQ.0))THEN
         L1=N2
         L2=N
      ELSE
         L1=INTAGF(IS)
         L2=INTAGT(IS)
      END IF
      IF(L1.LE.N1)THEN
         WRITE(3,92)
         STOP
      END IF
      ICOUNT=0
      ICHK=0
      DO 3 I=L1,L2
      IF(INTAG(IS).NE.0)THEN
         IF(INTAG(IS).NE.ITAG(I))GO TO 3
         IF(INTAGF(IS).GT.0)THEN
            ICOUNT=ICOUNT+1
            IF(ICOUNT.LT.INTAGF(IS).OR.ICOUNT.GT.INTAGT(IS))GO TO 3
         END IF
      END IF
C
C     FILL ARRAYS CEINS AND BRINS
C
      ICHK=1
      IF(BRINS(I).GT.0.)IWARN=1
      IF(RADIN(IS).LT.BI(I))THEN
         WRITE(3,95)I
         STOP
      END IF
      CEINS(I)=DCMPLX(EPSIN(IS),SIGIN(IS))
      IF(SIGIN(IS).GT.0.)CEINS(I)=EPSIN(IS)-(0.,1.)*SIGIN(IS)*EPCON
      BRINS(I)=RADIN(IS)
3     CONTINUE
      IF(ICHK.EQ.0)THEN
         WRITE(3,93)
         STOP
      END IF
10    CONTINUE
      IF(IWARN.EQ.1)WRITE(3,94)
      NOP=N/NP
      IF(NOP.GT.1.AND.N1+2*M1.EQ.0)THEN
         DO 8 I=1,NP
         L1=I
         DO 8 L2=2,NOP
         L1=L1+NP
         CEINS(L1)=CEINS(I)
8        BRINS(L1)=BRINS(I)
      END IF
9     IF(NINSF.GT.0)WRITE(3,96)
      RETURN
90    FORMAT(//,35X,'- - - WIRE SHEATH PARAMETERS - - -',//,27X,
     &'SEGMENTS',9X,'RELATIVE',5X,'CONDUCTIVITY',3X,'SHEATH RAD.',/,
     &24X,'TAG',2X,'FROM',2X,'THRU',3X,'PERMITTIVITY',5X,'(MHOS/M)',
     &8X,'(M)',/)
91    FORMAT(21X,3I6,2X,1PE12.5,3X,E12.5,3X,E12.5)
92    FORMAT(' INSET: ERROR - SHEATH MAY NOT BE ADDED TO WIRE IN NGF',
     &' SECTION')
93    FORMAT(' INSET: ERROR -- NO SEGMENTS MATCHED THE RANGE ON THE',
     &' PREVIOUS IS COMMAND')
94    FORMAT(' INSET: WARNING - OVERLAPPING SHEATH SPECIFICATIONS.',
     &'  LAST ONE WAS USED.')
95    FORMAT(' INSET: ERROR - SHEATH RADIUS .LE. SEGMENT RADIUS FOR',
     &' SEGMENT',I5)
96    FORMAT(//,35X,'**** WIRE SHEATHS IN NGF SECTION ****',//)
      END
      SUBROUTINE XKSET
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     XKSET FILLS XKS WITH VALUES OF K FOR THE CURRENT EXPANSION
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 AIX,BIX,CIX,CUR,XKS,XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,
     &ETAL2,FRATI,CEINS,XK,XKI,H0,H0P
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON/CRNT/AIX(MAXSEG),BIX(MAXSEG),CIX(MAXSEG),CUR(3*MAXSEG),
     &XKS(MAXSEG)
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      COMMON/INSCOM/CEINS(MAXSEG),BRINS(MAXSEG),NINS,NINSF,INTAG(MAXIS),
     &INTAGF(MAXIS),INTAGT(MAXIS),EPSIN(MAXIS),SIGIN(MAXIS),RADIN(MAXIS)
      IF(N.LT.1)RETURN
      DO 10 I=1,N
      XK=XKU
      IF(Z(I).LT.0.)XK=XKL
      XKS(I)=XK
      IF(NINS.EQ.0.AND.NINSF.EQ.0)GO TO 10
      IF(BRINS(I).LT.BI(I))GO TO 10
      XKI=OMEGAG/2.998E8*SQRT(CEINS(I))
      IF(ABS(XK/XKI).LT.2.)GO TO 10
C
C     COMPUTE MODIFIED K FOR CURRENT EXPANSION ON INSULATED WIRE
C
      CALL HANK12(XK*BRINS(I),2,H0,H0P)
      XKS(I)=XKI*SQRT(1.-H0/(XK*BRINS(I)*LOG(BRINS(I)/BI(I))*H0P))
10    CONTINUE
      RETURN
      END
      SUBROUTINE PTSLEN
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     PTSLEN prints the effective electrical lengths of segments
C     relative to the wavelength 2pi/ks.  ks is the wavenumber used
C     in the current expansion, and takes into account the medium sur-
C     rounding the wire and whether the wire has an insulating sheath.
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,AIX,BIX,
     &CIX,CUR,XKS,XK
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      COMMON/CRNT/AIX(MAXSEG),BIX(MAXSEG),CIX(MAXSEG),CUR(3*MAXSEG),
     &XKS(MAXSEG)
      COMMON/CONSTN/PI,TP,DTORAD,CVEL,EPSRZ,RMUZ,ETAZ
      IF(N.LT.1)RETURN
      WRITE(3,90)
      DO 1 I=1,N
      XK=XKU
      IF(Z(I).LT.0.)XK=XKL
      TPOK=ABS(XK)/TP
      TPOKS=ABS(XKS(I))/TP
      SNOR=SI(I)*TPOK
      BNOR=BI(I)*TPOK
      SNORS=SI(I)*TPOKS
      BNORS=BI(I)*TPOKS
1     WRITE(3,91)I,SI(I),BI(I),SNOR,BNOR,SNORS,BNORS,XKS(I)
      WRITE(3,92)
      RETURN
C
90    FORMAT(///,29X,'- - - SEGMENT LENGTHS AND RADII - - -',//,31X,
     &'K  = WAVE NUMBER IN MEDIUM',/,31X,'KS = WAVE NUMBER FOR CURRENT',
     &' EXPANSION',//,33X,'ELECTRICAL LENGTHS NORMALIZED -',13X,
     &'WAVE NO. FOR CURRENT EXP.',/,2X,'SEG.',5X,'- - METERS - -',
     &8X,'BY 2.*PI/CABS(K)',7X,'BY 2.*PI/CABS(KS)',13X,'(KS)',/
     &2X,'NO.',6X,'LENGTH',5X,'RADIUS',6X,'LENGTH',5X,'RADIUS',6X,
     &'LENGTH',5X,'RADIUS',7X,'REAL',8X,'IMAG.')
91    FORMAT(I6,3(1X,1P2E11.3),1X,2E12.4)
92    FORMAT(///)
      END
      COMPLEX*16 FUNCTION ZINT(SIGL,RMU,ROLAM)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     ZINT computes the internal impedance of a circular wire.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 TH,PH,F,G,FJ,CN,BR1,BR2
      COMPLEX*16 CC1,CC2,CC3,CC4,CC5,CC6,CC7,CC8,CC9,CC10,CC11,CC12,
     &CC13,CC14
      DIMENSION CCN(28)
      EQUIVALENCE (CC1,CCN(1)), (CC2,CCN(3)), (CC3,CCN(5)),
     &(CC4,CCN(7)), (CC5,CCN(9)), (CC6,CCN(11)), (CC7,CCN(13)),
     &(CC8,CCN(15)), (CC9,CCN(17)), (CC10,CCN(19)), (CC11,CCN(21)),
     &(CC12,CCN(23)), (CC13,CCN(25)), (CC14,CCN(27))
      DATA PI,POT,TP,TPCMU/3.1415926D0,1.5707963D0,6.2831853071796D0,
     &2.368705D+3/
      DATA CMOTP/60.00D0/,FJ/(0.D0,1.D0)/,CN/(.70710678D0,.70710678D0)/
      DATA CCN/6.D-7,1.9D-6,-3.4D-6,5.1D-6,-2.52D-5,0.D0,-9.06D-5,
     &-9.01D-5,0.D0,-9.765D-4,.0110486D0,-.0110485D0,0.D0,-.3926991D0,
     &1.6D-6,-3.2D-6,1.17D-5,-2.4D-6,3.46D-5,3.38D-5,5.D-7,2.452D-4,
     &-1.3813D-3,1.3811D-3,-6.25001D-2,-1.D-7,.7071068D0,.7071068D0/
C
C     STATEMENT FUNCTIONS:
C
      TH(D)=(((((CC1*D+CC2)*D+CC3)*D+CC4)*D+CC5)*D+CC6)*D+CC7
      PH(D)=(((((CC8*D+CC9)*D+CC10)*D+CC11)*D+CC12)*D+CC13)*D+CC14
      F(D)=SQRT(POT/D)*EXP(-CN*D+TH(-8./X))
      G(D)=EXP(CN*D+TH(8./X))/SQRT(TP*D)
C
C     END OF STATEMENT FUNCTIONS; BEGIN EXECUTABLE STATEMENTS.
C
      X=SQRT(TPCMU*RMU*SIGL)*ROLAM
      IF (X.GT.110.) GO TO 2
      IF (X.GT.8.) GO TO 1
      Y=X/8.
      Y=Y*Y
      S=Y*Y
      BER=((((((-9.01E-6*S+1.22552E-3)*S-.08349609)*S+2.6419140)*S-32.36
     &3456)*S+113.77778)*S-64.)*S+1.
      BEI=((((((1.1346E-4*S-.01103667)*S+.52185615)*S-10.567658)*S+72.81
     &7777)*S-113.77778)*S+16.)*Y
      BR1=DCMPLX(BER,BEI)
      BER=(((((((-3.94E-6*S+4.5957E-4)*S-.02609253)*S+.66047849)*S-6.068
     &1481)*S+14.222222)*S-4.)*Y)*X
      BEI=((((((4.609E-5*S-3.79386E-3)*S+.14677204)*S-2.3116751)*S+11.37
     &7778)*S-10.666667)*S+.5)*X
      BR2=DCMPLX(BER,BEI)
      BR1=BR1/BR2
      GO TO 3
1     BR2=FJ*F(X)/PI
      BR1=G(X)+BR2
      BR2=G(X)*PH(8./X)-BR2*PH(-8./X)
      BR1=BR1/BR2
      GO TO 3
2     BR1=DCMPLX(.70710678D0,-.70710678D0)
3     ZINT=FJ*SQRT(CMOTP*RMU/SIGL)*BR1/ROLAM
      RETURN
      END
      COMPLEX*16 FUNCTION ZZEXP(Z)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     ZZEXP (function) evaluates the exponential of a complex number,
C     returning 0 for real arguments less than -85.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 Z
      IF(DREAL(Z).GT.-85.)GO TO 1
      ZZEXP=(0.,0.)
      RETURN
1     ZZEXP=EXP(Z)
      RETURN
      END
      SUBROUTINE CMWW (J,I1,I2,CM,NR,CW,NW,ITRP)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     CMWW computes matrix elements for wire-wire interactions.
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 CM,CW,ETK,ETS,ETC,XKSJ,EXK,EYK,EZK,EXS,EYS,EZS,EXC,EYC,
     &EZC,ZPEDS,AX,BX,CX,XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,
     &AIX,BIX,CIX,CUR,XKS,QSEGE1,QSEGE2,ZARRAY,CEINS,CFCON
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON /SEGJ/ AX(NSJMAX),BX(NSJMAX),CX(NSJMAX),JCO(NSJMAX),JSNO,
     &ISCON(NSCNGF),NSCON,IPCON(NSPNGF),NPCON
      COMMON /DATAJ/ XKSJ,EXK,EYK,EZK,EXS,EYS,EZS,EXC,EYC,EZC,ZPEDS,
     &SLENJ,ARADJ,XJ,YJ,ZJ,DXJ,DYJ,DZJ,IND1,IND2
      COMMON/ZLOAD/ ZARRAY(MAXSEG),NLOAD,NLODF,LDTYP(LOADMX),
     &LDTAG(LOADMX),LDTAGF(LOADMX),LDTAGT(LOADMX),ZLR(LOADMX),
     &ZLI(LOADMX),ZLC(LOADMX)
      COMMON/INSCOM/CEINS(MAXSEG),BRINS(MAXSEG),NINS,NINSF,INTAG(MAXIS),
     &INTAGF(MAXIS),INTAGT(MAXIS),EPSIN(MAXIS),SIGIN(MAXIS),RADIN(MAXIS)
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      COMMON/CRNT/AIX(MAXSEG),BIX(MAXSEG),CIX(MAXSEG),CUR(3*MAXSEG),
     &XKS(MAXSEG)
      COMMON/JNQCOM/QSEGE1(MAXSEG),QSEGE2(MAXSEG),IPQEND(MAXSEG)
      COMMON/CONSTN/PI,TP,DTORAD,CVEL,EPSRZ,RMUZ,ETAZ
      DIMENSION CM(NR,*), CW(NW,*), CAB(MAXSEG), SAB(MAXSEG)
      EQUIVALENCE (CAB,ALP), (SAB,BET)
C     SET SOURCE SEGMENT PARAMETERS
      SLENJ=SI(J)
      ARADJ=BI(J)
      XJ=X(J)
      YJ=Y(J)
      ZJ=Z(J)
      DXJ=CAB(J)
      DYJ=SAB(J)
      DZJ=SALP(J)
      XKSJ=XKS(J)
      IND1=ICON1(J)
      IND2=ICON2(J)
      ZPEDS=ZARRAY(J)
      IF(IPQEND(J).EQ.1.OR.IPQEND(J).EQ.3)IND1=60000
      IF(IPQEND(J).GT.1)IND2=60000
C
C     OBSERVATION LOOP
C
      IPR=0
      DO 23 I=I1,I2
      IPR=IPR+1
      XI=X(I)
      YI=Y(I)
      ZI=Z(I)
      CABI=CAB(I)
      SABI=SAB(I)
      SALPI=SALP(I)
      CALL EFLD (XI,YI,ZI)
      ETK=(EXK*CABI+EYK*SABI+EZK*SALPI)/XKU
      ETS=(EXS*CABI+EYS*SABI+EZS*SALPI)/XKU
      ETC=(EXC*CABI+EYC*SABI+EZC*SALPI)/XKU
      IF(I.EQ.J)THEN
C
C     ADD TERMS FOR IMPEDANCE LOADING AND AN INSULATING SHEATH
C
         IF(NLOAD.NE.0.OR.NLODF.NE.0)ETK=ETK-ZARRAY(J)
         IF((NINS.NE.0.OR.NINSF.NE.0).AND.BRINS(J).GT.0.)THEN
            IF(Z(J).GE.0.)THEN
               CFCON=(0.,1.)*ETAU*(CEINS(J)-CEPSU)/XKU
            ELSE
               CFCON=(0.,1.)*ETAL*(CEINS(J)-CEPSL)/XKL
            END IF
            ETC=ETC-CFCON*LOG(BRINS(J)/BI(J))/(TP*CEINS(J))*XKSJ**2/XKU
         END IF
      END IF
C
C     FILL MATRIX ELEMENTS.  ELEMENT LOCATIONS DETERMINED BY CONNECTION
C     DATA.
C
      IF (ITRP.NE.0) GO TO 18
C     NORMAL FILL
      DO 17 IJ=1,JSNO
      JX=JCO(IJ)
17    CM(IPR,JX)=CM(IPR,JX)+ETK*AX(IJ)+ETS*BX(IJ)+ETC*CX(IJ)
      GO TO 23
18    IF (ITRP.EQ.2) GO TO 20
C     TRANSPOSED FILL
      DO 19 IJ=1,JSNO
      JX=JCO(IJ)
19    CM(JX,IPR)=CM(JX,IPR)+ETK*AX(IJ)+ETS*BX(IJ)+ETC*CX(IJ)
      GO TO 23
C     TRANS. FILL FOR C(WW) - TEST FOR ELEMENTS FOR D(WW)PRIME.  (=CW)
20    DO 22 IJ=1,JSNO
      JX=JCO(IJ)
      IF (JX.GT.NR) GO TO 21
      CM(JX,IPR)=CM(JX,IPR)+ETK*AX(IJ)+ETS*BX(IJ)+ETC*CX(IJ)
      GO TO 22
21    JX=JX-NR
      CW(JX,IPR)=CW(JX,IPR)+ETK*AX(IJ)+ETS*BX(IJ)+ETC*CX(IJ)
22    CONTINUE
23    CONTINUE
      RETURN
      END
      SUBROUTINE NEFLD (XOB,YOB,ZOB,EX,EY,EZ)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     NEFLD computes the near field at specified points in space after
C     the structure currents have been computed.
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 AIX,BIX,CIX,CUR,XKS,XKSJ,EXK,EYK,EZK,EXS,EYS,EZS,EXC,
     &EYC,EZC,ZPEDS,H1X,H1Y,H1Z,H2X,H2Y,H2Z,ZARRAY,XKU,XKL,ETAU,ETAL,
     &CEPSU,CEPSL,ETAL2,FRATI,QSEGE1,QSEGE2,EX,EY,EZ,ACX,BCX,CCX
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON/CRNT/AIX(MAXSEG),BIX(MAXSEG),CIX(MAXSEG),CUR(3*MAXSEG),
     &XKS(MAXSEG)
      COMMON /DATAJ/ XKSJ,EXK,EYK,EZK,EXS,EYS,EZS,EXC,EYC,EZC,ZPEDS,
     &SLENJ,ARADJ,XJ,YJ,ZJ,DXJ,DYJ,DZJ,IND1,IND2
      COMMON/DATAP/H1X,H1Y,H1Z,H2X,H2Y,H2Z,SPATJ,XPATJ,YPATJ,ZPATJ,T1XJ,
     &T1YJ,T1ZJ,T2XJ,T2YJ,T2ZJ,IPGND
      COMMON/ZLOAD/ ZARRAY(MAXSEG),NLOAD,NLODF,LDTYP(LOADMX),
     &LDTAG(LOADMX),LDTAGF(LOADMX),LDTAGT(LOADMX),ZLR(LOADMX),
     &ZLI(LOADMX),ZLC(LOADMX)
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      COMMON/JNQCOM/QSEGE1(MAXSEG),QSEGE2(MAXSEG),IPQEND(MAXSEG)
      DIMENSION CAB(MAXSEG),SAB(MAXSEG),T1X(MAXSEG),T1Y(MAXSEG),
     &   T1Z(MAXSEG)
      EQUIVALENCE (CAB,ALP), (SAB,BET)
      EQUIVALENCE (T1X,SI), (T1Y,ALP), (T1Z,BET)
      EX=(0.,0.)
      EY=(0.,0.)
      EZ=(0.,0.)
      IF (N.EQ.0) GO TO 20
      DO 19 I=1,N
      SLENJ=SI(I)
      ARADJ=BI(I)
      XJ=X(I)
      YJ=Y(I)
      ZJ=Z(I)
      DXJ=CAB(I)
      DYJ=SAB(I)
      DZJ=SALP(I)
      XKSJ=XKS(I)
      ZPEDS=ZARRAY(I)
      IND1=ICON1(I)
      IND2=ICON2(I)
      IF(IPQEND(I).EQ.1.OR.IPQEND(I).EQ.3)IND1=60000
      IF(IPQEND(I).GT.1)IND2=60000
      CALL EFLD (XOB,YOB,ZOB)
      ACX=AIX(I)
      BCX=BIX(I)
      CCX=CIX(I)
      EX=EX+EXK*ACX+EXS*BCX+EXC*CCX
      EY=EY+EYK*ACX+EYS*BCX+EYC*CCX
19    EZ=EZ+EZK*ACX+EZS*BCX+EZC*CCX
      IF (M.EQ.0) RETURN
20    JC=N
      JL=LD+1
      DO 21 I=1,M
      JL=JL-1
      SPATJ=BI(JL)
      XPATJ=X(JL)
      YPATJ=Y(JL)
      ZPATJ=Z(JL)
      T1XJ=T1X(JL)
      T1YJ=T1Y(JL)
      T1ZJ=T1Z(JL)
      T2XJ=T2X(JL)
      T2YJ=T2Y(JL)
      T2ZJ=T2Z(JL)
      JC=JC+3
      ACX=T1XJ*CUR(JC-2)+T1YJ*CUR(JC-1)+T1ZJ*CUR(JC)
      BCX=T2XJ*CUR(JC-2)+T2YJ*CUR(JC-1)+T2ZJ*CUR(JC)
      DO 21 IP=1,KSYMP
      IPGND=IP
      CALL UNERE (XOB,YOB,ZOB)
      EX=EX+ACX*H1X+BCX*H2X
      EY=EY+ACX*H1Y+BCX*H2Y
21    EZ=EZ+ACX*H1Z+BCX*H2Z
      RETURN
      END
      SUBROUTINE EFLD (XI,YI,ZI)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     EFLD evaluates the near E field components of a wire segment with
C     constant, sin(ks) and cos(ks)-1 current distributions.  The effect
C     of a ground plane is included, with Sommerfeld or reflection
C     coefficient options for finitely conducting ground. For perfectly
C     conducting ground ZI and ZJ must be positive.  Field transmitted
C     across the interface may be computed in the Sommerfeld mode only.
C
C     INPUT:
C     XI,YI,ZI = COORDINATES OF THE EVALUATION POINT
C     OTHER INPUT FROM COMMON/DATAJ/ AND COMMON/GND/
C
C     OUTPUT THROUGH COMMON/DATAJ/:
C     EXK,EYK,EZK = X,Y,Z COMPONENTS OF E DUE TO CONSTANT CURRENT
C     EXS,EYS,EZS = X,Y,Z COMPONENTS OF E DUE TO SIN(KS) CURRENT
C     EXC,EYC,EZC = X,Y,Z COMPONENTS OF E DUE TO COS(KS)-1 CURRENT
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 XKSJ,EXK,EYK,EZK,EXS,EYS,EZS,EXC,EYC,EZC,ZPEDS,XKU,XKL,
     &ETAU,ETAL,CEPSU,CEPSL,FRATI,ETAL2,XK,ETX,FRATX,TXK,TYK,TZK,
     &TXS,TYS,TZS,TXC,TYC,TZC,ZRATI
      COMMON /DATAJ/ XKSJ,EXK,EYK,EZK,EXS,EYS,EZS,EXC,EYC,EZC,ZPEDS,
     &SLENJ,ARADJ,XJ,YJ,ZJ,DXJ,DYJ,DZJ,IND1,IND2
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      COMMON /GREGON/ RHOA(3),RHOB(3),ZZA(3),ZZB(3),ZPA(3),ZPB(3),ELM,EL
     &MX,SCFAC,RHMX1,ZZMX1,ZPMX1,RHMX2,ZZMX2,ZPMX2,ZPMXX
      XIJ=XI-XJ
      YIJ=YI-YJ
      ZIJ=ZI-ZJ
C
C     TEST IF FIELD IS TRANSMITTED ACROSS AN INTERFACE WITH GROUND
C     IF SO, GO TO SOMMERFELD SECTION.
C
      IF (KSYMP.GT.1.AND.ZI*ZJ.LT.0.) GO TO 19
C
C     SOURCE AND EVALUATION POINT ON SAME SIDE OF THE INTERFACE SO
C     EVALUATE DIRECT AND REFLECTED FIELD IF GROUND IS PRESENT.
C
      IF (ZJ.GT.0.)THEN
           XK=XKU
           ETX=ETAU
           FRATX=FRATI
           ZRATI=XKU/XKL
      ELSE
           XK=XKL
           ETX=ETAL
           FRATX=-FRATI
           ZRATI=XKL/XKU
      END IF
C
C     EVALUATE DIRECT FIELD FROM SOURCE TO EVALUATION POINT
C
      CALL EFLDSG(XIJ,YIJ,ZIJ,DXJ,DYJ,DZJ,SLENJ,ARADJ,ZPEDS,XK,ETX,XKSJ,
     &IND1,IND2,EXK,EYK,EZK,EXS,EYS,EZS,EXC,EYC,EZC)
      IF(KSYMP.EQ.1)RETURN
C
C     FOR GROUND, EVALUATE FIELD OF THE IMAGE OF THE SOURCE SEGMENT
C
      DZJR=-DZJ
      ZIJ=ZI+ZJ
      IMAGF=0
C
C     FOR SOMMERFELD GROUND EVALUATION, TEST IF DISTANCE IS GREAT ENOUGH
C     TO USE POINT SOURCE APPROXIMATION.  IF SO THE TOTAL REFLECTED
C     FIELD IS EVALUATED BY SOMMERFELD-INTERPOLATION CODE.
C
      IF(IPERF.EQ.2)THEN
         IMAGF=1
         RHO=SQRT(XIJ*XIJ+YIJ*YIJ)*GSCAL
         ZIJS=ZIJ*GSCAL
         IF((ZIJS.GT.ZZMX1).OR.(-ZIJS.GT.ZPMX1).OR.(RHO.GT.RHMX1))THEN
            IMAGF=2
            GO TO 17
         END IF
C     Include point charges on segment ends within 0.1 of the boundary
C     for switching to one-point integration.
         SLENH=.5*SLENJ
         XDST1=XI-(XJ-DXJ*SLENH)
         YDST1=YI-(YJ-DYJ*SLENH)
         ZDST1=ZI+(ZJ-DZJ*SLENH)*GSCAL
         RHOD1=SQRT(XDST1**2+YDST1**2)*GSCAL
         XDST2=XI-(XJ+DXJ*SLENH)
         YDST2=YI-(YJ+DYJ*SLENH)
         ZDST2=ZI+(ZJ+DZJ*SLENH)*GSCAL
         RHOD2=SQRT(XDST2**2+YDST2**2)*GSCAL
         IF(ZDST1.GT.ZZMX1-.1.OR.-ZDST1.GT.ZPMX1-.1.OR.
     &      RHOD1.GT.RHMX1-.1)THEN
            INDX1=60000
         ELSE
            INDX1=IND1
         END IF
         IF(ZDST2.GT.ZZMX1-.1.OR.-ZDST2.GT.ZPMX1-.1.OR.
     &      RHOD2.GT.RHMX1-.1)THEN
            INDX2=60000
         ELSE
            INDX2=IND2
         END IF
      ELSE
         INDX1=IND1
         INDX2=IND2
      END IF
C
C     EVALUATE IMAGE FIELD
C
      CALL EFLDSG(XIJ,YIJ,ZIJ,DXJ,DYJ,DZJR,SLENJ,ARADJ,ZPEDS,XK,ETX,
     &XKSJ,INDX1,INDX2,TXK,TYK,TZK,TXS,TYS,TZS,TXC,TYC,TZC)
      IF (IMAGF.EQ.0)THEN
C     RCTRAN TRANSFORMS THE IMAGE FIELD FOR REFLECTION COEF. APPROX.
C
         IF(IPERF.EQ.0)CALL RCTRAN(XI,YI,ZI,XJ,YJ,ZJ,ZRATI,ETX,TXK,TYK,
     &                 TZK,TXS,TYS,TZS,TXC,TYC,TZC)
C
C     ADD IMAGE FIELD FOR PERFECT GROUND OR REFLECTION COEF. APPROX.
C
         EXK=EXK-TXK
         EYK=EYK-TYK
         EZK=EZK-TZK
         EXS=EXS-TXS
         EYS=EYS-TYS
         EZS=EZS-TZS
         EXC=EXC-TXC
         EYC=EYC-TYC
         EZC=EZC-TZC
         RETURN
      ELSE
C
C     FOR SOMMERFELD MODE, ADD IMAGE FIELD WITH STATIC REFLECTION FACTOR
C
         EXK=EXK-TXK*FRATX
         EYK=EYK-TYK*FRATX
         EZK=EZK-TZK*FRATX
         EXS=EXS-TXS*FRATX
         EYS=EYS-TYS*FRATX
         EZS=EZS-TZS*FRATX
         EXC=EXC-TXC*FRATX
         EYC=EYC-TYC*FRATX
         EZC=EZC-TZC*FRATX
      END IF
C
C     SOMMERFELD FIELD EVALUATION FOR REFLECTED FIELD
C
17    DMIN=EXK*DCONJG(EXK)+EYK*DCONJG(EYK)+EZK*DCONJG(EZK)
      DMIN=.01*SQRT(DMIN)
      CALL SOMFLD(XI,YI,ZI,XJ,YJ,ZJ,DXJ,DYJ,DZJ,SLENJ,ARADJ,XKSJ,DMIN,
     &IMAGF,TXK,TYK,TZK,TXS,TYS,TZS,TXC,TYC,TZC)
      EXK=EXK+TXK
      EYK=EYK+TYK
      EZK=EZK+TZK
      EXS=EXS+TXS
      EYS=EYS+TYS
      EZS=EZS+TZS
      EXC=EXC+TXC
      EYC=EYC+TYC
      EZC=EZC+TZC
      RETURN
C
C     SOMMERFELD EVALUATION FOR FIELD TRANSMITTED ACROSS THE INTERFACE
C
19    IF (IPERF.NE.2)THEN
         WRITE(3,34) XJ,YJ,ZJ,XI,YI,ZI
         STOP
      END IF
      IF(ZJ.GT.0.)THEN
         ZUP=ZJ*GSCAL
         ZDN=ZI*GSCAL
      ELSE
         ZUP=ZI*GSCAL
         ZDN=ZJ*GSCAL
      END IF
C
C     TEST IF DISTANCE IS GREAT ENOUGH TO USE POINT SOURCE APPROXIMATION
C
      IMAGF=-1
      RHO=SQRT(XIJ*XIJ+YIJ*YIJ)*GSCAL
      IF((ZUP.GT.ZZMX1).OR.(-ZDN.GT.ZPMX1).OR.(RHO.GT.RHMX1))IMAGF=-2
      CALL SOMFLD(XI,YI,ZI,XJ,YJ,ZJ,DXJ,DYJ,DZJ,SLENJ,ARADJ,XKSJ,0.D0,
     &IMAGF,EXK,EYK,EZK,EXS,EYS,EZS,EXC,EYC,EZC)
      RETURN
C
34    FORMAT (' EFLD: ERROR - MUST USE SOMMERFELD FOR INTERACTION',
     &' ACROSS THE INTERFACE',/,1P6E12.5)
      END
      SUBROUTINE EFLDSG(XIJ,YIJ,ZIJ,DXJ,DYJ,DZJ,SLENJ,ARADJ,ZPEDS,XK,
     &ETX,XKS,IND1,IND2,EXK,EYK,EZK,EXS,EYS,EZS,EXC,EYC,EZC)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     EFLDSG evaluates the E field due to an arbitrarily oriented
C     segment in an infinite medium.  This routine transforms
C     coordinates and then calls subroutine EKSCSZ to evaluate the
C     field of the segment on the Z axis of a cylindrical coordinate
C     system centered at the origin.
C
C     INPUT:
C     XIJ,YIJ,ZIJ = COMPONENTS OF VECTOR FROM SOURCE TO EVALUATON POINT
C     DXJ,DYJ,DZJ = UNIT VECTOR IN DIRECTION OF THE SOURCE SEGMENT
C     SLENJ = LENGTH OF THE SOURCE SEGMENT
C     ARADJ = RADIUS OF THE SOURCE SEGMENT
C     ZPEDS = IMPEDANCE LOAD ON SEGMENT
C     XK = WAVE NUMBER IN THE MEDIUM CONTAINING THE SOURCE
C     ETX = INTRINSIC IMPEDANCE IN THE MEDIUM CONTAINING THE SOURCE
C     XKS = WAVENUMBER FOR THE CURRENT EXPANSION ON THE SEGMENT
C     IND1 = CONNECTION NUMBER (ICON1) FOR END ONE OF THE SOURCE SEG.
C          = 60000 FOR A JUNCTION THROUGH THE AIR-GROUND INTERFACE
C     IND2 = CONNECTION NUMBER (ICON2) FOR END TWO OF THE SOURCE SEG.
C          = 60000 FOR A JUNCTION THROUGH THE AIR-GROUND INTERFACE
C
C     OUTPUT:
C     EXK,EYK,EZK = X,Y,Z COMPONENTS OF E DUE TO CONSTANT CURRENT
C     EXS,EYS,EZS = X,Y,Z COMPONENTS OF E DUE TO SIN(KS) CURRENT
C     EXC,EYC,EZC = X,Y,Z COMPONENTS OF E DUE TO COS(KS)-1 CURRENT
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 ZPEDS,XK,ETX,XKS,EXK,EYK,EZK,EXS,EYS,EZS,EXC,EYC,EZC,
     &TEZK,TEZS,TEZC,TERK,TERS,TERC
      ZP=XIJ*DXJ+YIJ*DYJ+ZIJ*DZJ
      RHOX=XIJ-DXJ*ZP
      RHOY=YIJ-DYJ*ZP
      RHOZ=ZIJ-DZJ*ZP
      RH=SQRT(RHOX*RHOX+RHOY*RHOY+RHOZ*RHOZ)
      IF (RH.GT.1.E-12)THEN
         RHOX=RHOX/RH
         RHOY=RHOY/RH
         RHOZ=RHOZ/RH
      ELSE
         RHOX=0.
         RHOY=0.
         RHOZ=0.
      END IF
C
C     EKSCSZ EVALUATES THIN WIRE APPROX. OF FIELD OF SEGMENT ON Z AXIS
C
      CALL EKSCSZ(RH,ZP,SLENJ,ARADJ,ZPEDS,XK,ETX,XKS,TEZK,TEZS,TEZC,
     &TERK,TERS,TERC,IND1,IND2)
      EXK=TEZK*DXJ+TERK*RHOX
      EYK=TEZK*DYJ+TERK*RHOY
      EZK=TEZK*DZJ+TERK*RHOZ
      EXS=TEZS*DXJ+TERS*RHOX
      EYS=TEZS*DYJ+TERS*RHOY
      EZS=TEZS*DZJ+TERS*RHOZ
      EXC=TEZC*DXJ+TERC*RHOX
      EYC=TEZC*DYJ+TERC*RHOY
      EZC=TEZC*DZJ+TERC*RHOZ
      RETURN
      END
      SUBROUTINE RCTRAN(XI,YI,ZI,XJ,YJ,ZJ,ZRATI,ETX,TXK,TYK,TZK,TXS,TYS,
     &TZS,TXC,TYC,TZC)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     RCTRAN applies the plane-wave reflection formulas to the field of
C     the image of a source above or below the interface with ground.
C
C     INPUT:
C     XI,YI,ZI = COORDINATES OF THE EVALUATION POINT
C     XJ,YJ,ZJ = COORDINATES OF THE SOURCE POINT
C     ZRATI = RATIO OF INTRINSIC IMPEDANCE OF LOWER MEDIUM TO THAT OF
C             UPPER MEDIUM
C     ETX = INTRINSIC IMPEDANCE IN THE MEDIUM CONTAINING THE SOURCE
C
C     INPUT AND TRANSFORMED AS OUTPUT:
C     TXK,TYK,TZK = X,Y,Z COMPONENTS OF E DUE TO A CONSTANT CURRENT
C     TXS,TYS,TZS = X,Y,Z COMPONENTS OF E DUE TO A SIN(KS) CURRENT
C     TXC,TYC,TZC = X,Y,Z COMPONENTS OF E DUE TO A COS(KS)-1 CURRENT
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 ZRATI,ETX,TXK,TYK,TZK,TXS,TYS,TZS,TXC,TYC,TZC,XKU,XKL,
     &ETAU,ETAL,CEPSU,CEPSL,FRATI,ETAL2,ZRATX,ZSCRN,ZRSIN,REFS,
     &REFPS,EPX,EPY
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      COMMON/CONSTN/PI,TP,DTORAD,CVEL,EPSRZ,RMUZ,ETAZ
      ZRATX=ZRATI
      XIJ=XI-XJ
      YIJ=YI-YJ
      ZIJ=ZI+ZJ
C
C     SET PARAMETERS IF RADIAL WIRE GROUND SCREEN IS USED.
C
      IF (NRADL.NE.0)THEN
         XSPEC=(XI*ZJ+ZI*XJ)/(ZI+ZJ)
         YSPEC=(YI*ZJ+ZI*YJ)/(ZI+ZJ)
         RHOSPC=SQRT(XSPEC*XSPEC+YSPEC*YSPEC+(NRADL*SCNWRD)**2)
         IF (RHOSPC.LE.SCNRAD)THEN
            ZSCRN=(0.,1.)*RMUZ*OMEGAG*RHOSPC/NRADL*LOG(RHOSPC/(NRADL*
     &      SCNWRD))
            ZRATX=(ZSCRN*ZRATI)/(ETX*ZRATI+ZSCRN)
         END IF
      END IF
C
C     CALCULATION OF REFLECTION COEFFICIENTS
C
      XYMAG=SQRT(XIJ*XIJ+YIJ*YIJ)
      IF (XYMAG.LT.1.E-10)THEN
           PX=0.
           PY=0.
           CTH=1.
           ZRSIN=(1.,0.)
      ELSE
           PX=-YIJ/XYMAG
           PY=XIJ/XYMAG
           CTH=ABS(ZIJ)/SQRT(XYMAG*XYMAG+ZIJ*ZIJ)
           ZRSIN=SQRT(1.-ZRATX*ZRATX*(1.-CTH*CTH))
      END IF
      REFS=(CTH-ZRATX*ZRSIN)/(CTH+ZRATX*ZRSIN)
      REFPS=-(ZRATX*CTH-ZRSIN)/(ZRATX*CTH+ZRSIN)
      REFPS=REFPS-REFS
C
C     DECOMPOSE FIELDS INTO TE AND TM COMPONENTS, MULTIPLY BY REFLECTION
C     COEFFICIENTS AND RECOMBINE.
C
      EPY=PX*TXK+PY*TYK
      EPX=PX*EPY
      EPY=PY*EPY
      TXK=REFS*TXK+REFPS*EPX
      TYK=REFS*TYK+REFPS*EPY
      TZK=REFS*TZK
      EPY=PX*TXS+PY*TYS
      EPX=PX*EPY
      EPY=PY*EPY
      TXS=REFS*TXS+REFPS*EPX
      TYS=REFS*TYS+REFPS*EPY
      TZS=REFS*TZS
      EPY=PX*TXC+PY*TYC
      EPX=PX*EPY
      EPY=PY*EPY
      TXC=REFS*TXC+REFPS*EPX
      TYC=REFS*TYC+REFPS*EPY
      TZC=REFS*TZC
      RETURN
      END
      SUBROUTINE EKSCSZ(RH,ZP,SLEN,ARAD,ZPEDS,XK,ETA,XKS,EZK,EZS,EZCM,
     &ERK,ERS,ERC,IND1,IND2)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     EKSCSZ evaluates the E field due to a segment on the Z axis of a
C     cylindrical coordinate system using the thin wire approximation.
C     This routine calls subroutine EKSCMN to get the field due to a
C     filament of current after transforming the RHO coordinate for the
C     thin wire approximation.
C
C     INPUT:
C     RH = RHO COORDINATE OF THE EVALUATION POINT
C     ZP = Z COORDINATE OF THE EVALUATION POINT
C     SLEN = LENGTH OF THE SOURCE SEGMENT
C     ARAD = RADIUS OF THE SOURCE SEGMENT
C     ZPEDS = IMPEDANCE LOAD ON THE SEGMENT
C     XK = WAVE NUMBER IN THE MEDIUM CONTAINING THE SOURCE
C     ETA = INTRINSIC IMPEDANCE IN THE MEDIUM CONTAINING THE SOURCE
C     XKS = WAVENUMBER FOR THE CURRENT EXPANSION ON THE SEGMENT
C     IND1 = CONNECTION NUMBER (ICON1) FOR END ONE OF THE SOURCE SEG.
C          = 60000 FOR A JUNCTION THROUGH THE AIR-GROUND INTERFACE
C     IND2 = CONNECTION NUMBER (ICON2) FOR END TWO OF THE SOURCE SEG.
C          = 60000 FOR A JUNCTION THROUGH THE AIR-GROUND INTERFACE
C
C     OUTPUT:
C     EZK,ERK = Z AND RHO COMPONENTS OF E DUE TO CONSTANT CURRENT
C     EZS,ERS = Z AND RHO COMPONENTS OF E DUE TO SIN(KS) CURRENT
C     EZCM,ERC = Z AND RHO COMPONENTS OF E DUE TO COS(KS)-1 CURRENT
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 ZPEDS,XK,ETA,XKS,EZK,EZS,EZCM,ERK,ERS,ERC,ECR1,ECR2,
     &ECZ1,ECZ2
      COMMON /VLCAPC/IVCAP
      SHALF=.5*SLEN
      RHOA=SQRT(RH*RH+ARAD*ARAD)
      IF(ABS((XKS-XK)/XK).GT.1.E-5)THEN
         CALL EKSCKS (SLEN,ZP,RHOA,XK,ETA,XKS,EZK,EZS,EZCM,ERS,ERC)
      ELSE
         CALL EKSCMN (SLEN,ZP,RHOA,XK,ETA,EZK,EZS,EZCM,ERS,ERC)
      END IF
      ERK=(0.,0.)
C
C     IF A SEGMENT CONNECTS TO A MFIE PATCH OR FORMS A JUNCTION CROSSING
C     THE AIR-GROUND INTERFACE THE FIELD DUE TO THE POINT CHARGE ON THE
C     CONNECTED END IS ADDED BY SUBROUTINE EKSCPQ
C
      IF(IND1.GT.30000)CALL EKSCPQ(-SHALF,ZP,RHOA,XK,ETA,XKS,EZK,EZS,
     &EZCM,ERK,ERS,ERC)
      IF(IND2.GT.30000)CALL EKSCPQ(SHALF,ZP,RHOA,XK,ETA,XKS,EZK,EZS,
     &EZCM,ERK,ERS,ERC)
C
C     ADJUST RADIAL FIELD TO USE 1/RH FACTOR RATHER THAN 1/RHOA.
C
      IF(RH.GT.0.999*ARAD)THEN
         RHOFAC=RHOA/RH
         ERK=ERK*RHOFAC
         ERS=ERS*RHOFAC
         ERC=ERC*RHOFAC
      ELSE IF(ABS(ZP)-SHALF.GT..1*ARAD)THEN
         ERK=(0.,0.)
         ERS=(0.,0.)
         ERC=(0.,0.)
      ELSE IF(RH.LT.0.001*ARAD)THEN
         ERS=(0.,0.)
         ERC=(0.,0.)
      END IF
C
C     ADD END CAP FIELDS TO SEGMENTS ON FREE ENDS
C
      IF(IND1.EQ.0)CALL ENDCAP(-1,SLEN,ARAD,RH,ZP,XK,ETA,XKS,EZK,EZS,
     &EZCM,ERK,ERS,ERC)
      IF(IND2.EQ.0)CALL ENDCAP(1,SLEN,ARAD,RH,ZP,XK,ETA,XKS,EZK,EZS,
     &EZCM,ERK,ERS,ERC)
C
C     ADD FIELD DUE TO END CAPS ON SEGMENTS WITH IMPEDANCE LOADS.
C
      IF(IVCAP.EQ.1.AND.ABS(ZPEDS).GT.1.E-10)THEN
         CALL EFCAP(ARAD,RH,ZP+SHALF,XK,ECR1,ECZ1)
         CALL EFCAP(ARAD,RH,ZP-SHALF,XK,ECR2,ECZ2)
         EZK=EZK+(ECZ1-ECZ2)*ZPEDS*XK
         ERK=ERK+(ECR1-ECR2)*ZPEDS*XK
      END IF
      RETURN
      END
      SUBROUTINE ENDCAP(IEND,SLEN,CAPRAD,RHO,ZOB,XK,ETA,XKS,EZK,EZS,EZC,
     &ERK,ERS,ERC)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     ENDCAP evaluates the E field due to charge on an end cap of an
C     arbitrarily oriented segment in an infinite medium.  This routine
C     transforms coordinates and then calls subroutine EFCAP to evaluate
C     the field of the end cap of the segment on the Z axis of a
C     cylindrical coordinate system.
C
C     INPUT:
C     IEND = -1 IF CAP IS ON (-) END OF THE SEGMENT
C          = +1 IF CAP IS ON (+) END OF THE SEGMENT
C     SLEN = LENGTH OF THE SOURCE SEGMENT
C     CAPRAD = RADIUS OF THE SOURCE SEGMENT
C     RHO,ZOB = RHO AND Z COORDINATES OF THE EVALUATION POINT
C     XK = WAVE NUMBER IN THE MEDIUM CONTAINING THE SOURCE
C     ETA = INTRINSIC IMPEDANCE IN THE MEDIUM CONTAINING THE SOURCE
C     XKS = WAVENUMBER FOR THE CURRENT EXPANSION
C
C     INPUT AND OUTPUT:
C     EZK,ERK = Z AND RHO COMPONENTS OF E DUE TO CONSTANT CURRENT
C     EZS,ERS = Z AND RHO COMPONENTS OF E DUE TO SIN(KS) CURRENT
C     EZCM,ERC = Z AND RHO COMPONENTS OF E DUE TO COS(KS)-1 CURRENT
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 XK,ETA,XKS,EZK,EZS,EZC,ERK,ERS,ERC,RHOEND,EZ,ER,SINKS,
     &COMKS,CCOSM1
      COMMON/CONSTN/PI,TP,DTORAD,CVEL,EPSRZ,RMUZ,ETAZ
      SHALF=.5*SLEN
      IF(IEND.GT.0)THEN
         ZDIST=ZOB-SHALF
      ELSE
         ZDIST=ZOB+SHALF
      END IF
      CALL EFCAP(CAPRAD,RHO,ZDIST,XK,ER,EZ)
      RHOEND=-(0.,1.)*ETA/(PI*CAPRAD**2*XK)
      ER=ER*RHOEND
      EZ=EZ*RHOEND
      SINKS=SIN(XKS*SHALF)
      COMKS=CCOSM1(XKS*SHALF)
      EZS=EZS+EZ*SINKS
      ERS=ERS+ER*SINKS
      IF(IEND.GT.0)THEN
         EZK=EZK+EZ
         EZC=EZC+EZ*COMKS
         ERK=ERK+ER
         ERC=ERC+ER*COMKS
      ELSE
         EZK=EZK-EZ
         EZC=EZC-EZ*COMKS
         ERK=ERK-ER
         ERC=ERC-ER*COMKS
      END IF
      RETURN
      END
      SUBROUTINE EFCAP(CAPRAD,RHO,ZDIST,XK,ER,EZ)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     EFCAP evaluates the E field due to charge on a circular disk
C     representing the end cap of a wire.  Constant charge density is
C     assumed on the disk with the value determined for unit current
C     onto the disk. NOTE: A factor of 1/permittivty has been omitted
C     from the returned field since it cancels later.
C
C     INPUT:
C     CAPRAD = RADIUS OF THE WIRE AND CAP
C     RHO,ZDIST = RHO AND Z COORDINATES OF THE EVALUATION POINT
C     XK = WAVE NUMBER IN THE MEDIUM CONTAINING THE CAP
C
C     OUTPUT:
C     ER,EZ = RHO AND Z COMPONENTS OF E DUE TO THE CHARGE ON THE CAP
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 XK,ER,EZ,XJKZ,RZK,XKR,XJKR,EXKR,TERM1,TERM2
      ABSZ=ABS(ZDIST)
C
C     EXACT EVALUATION FOR POINTS ON THE AXIS OF THE DISK
C
      IF(RHO.LT..1*ABSZ.AND.ABSZ.LT.10.*CAPRAD)THEN
         RA=SQRT(ZDIST*ZDIST+CAPRAD*CAPRAD)
         XJKZ=(0.,1.)*XK*ABSZ
         RZK=XK*(RA-ABSZ)
         IF(ABS(RZK).GT.0.001)THEN
            EZ=-.5*EXP(-XJKZ)*(EXP(-(0.,1.)*RZK)*ABSZ/RA-1.)
         ELSE
            EZ=-.5*EXP(-XJKZ)/RA*(ABSZ-RA)*(1.+XJKZ)
         END IF
         IF(ZDIST.LT.0.)EZ=-EZ
         ER=(0.,0.)
      ELSE
C
C     APPROXIMATION FOR RZ MUCH GREATER THAN CAPRAD
C
         RZ=SQRT(RHO*RHO+ZDIST*ZDIST)
         XKR=XK*RZ
         XJKR=(0.,1.)*XKR
         AORS=(CAPRAD/RZ)**2
         EXKR=.25*AORS*EXP(-XJKR)/RZ
         IF(RZ.LT.10.*CAPRAD)THEN
            TERM1=1.+XJKR-.125*AORS*(RHO/RZ)**2*(((XJKR+6.)*XKR-
     &      (0.,15.))*XKR-15.)
            TERM2=.5*AORS*(3.-(XKR-(0.,3.))*XKR)
            EZ=ZDIST*EXKR*(TERM1-.5*TERM2)
            ER=RHO*EXKR*(TERM1-TERM2)
         ELSE
            TERM1=1.+XJKR
            EZ=ZDIST*EXKR*TERM1
            ER=RHO*EXKR*TERM1
         END IF
      END IF
      RETURN
      END
      SUBROUTINE EKSCMN (SLEN,ZOB,RHO,XK,ETA,EZK,EZS,EZCM,ERS,ERC)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     EKSCMN calls a routine to compute the electric field due to a
C     segment with constant, SIN(KS), and COS(KS)-1 current
C     distributions.  The routine EKSCEX uses the exact field equations
C     but is subject to numerical errors for some RHO, ZOB, and segment
C     lengths.  The other routines use series approximations for
C     particular cases that are difficult for subroutine EKSCEX.  The
C     tests here are set for single precision code.
C
C     !!!NOTE!!! THE CONTRIBUTIONS TO THE ELECTRIC FIELD DUE TO POINT
C     CHARGES (CURRENT DISCONTINUITIES) AT THE SEGMENT ENDS HAVE BEEN
C     DROPPED TO IMPROVE NUMERICAL ACCURACY.  HENCE THE FIELD IS CORRECT
C     ONLY WHEN COMBINED WITH THE FIELD OF OTHER SEGMENTS TO PRODUCE A
C     CONTINUOUS CURRENT THAT GOES TO ZERO AT FREE ENDS.
C
C     INPUT:
C     SLEN = SEGMENT LENGTH (M)
C     ZOB = Z COORDINATE OF EVALUATION POINT (M)
C     RHO = RHO COORDINATE OF EVALUATION POINT (M)
C     XK = WAVE NUMBER IN THE MEDIUM IN WHICH THE SEGMENT IS LOCATED
C     ETA = INTRINSIC IMPEDANCE OF THE MEDIUM (OHMS)
C
C     OUTPUT:
C     EZK = Z COMPONENT OF E DUE TO CONSTANT CURRENT (V/M)
C     EZS = Z COMPONENT OF E DUE TO SIN(KS) CURRENT
C     EZCM= Z COMPONENT OF E DUE TO COS(KS)-1 CURRENT
C     ERS = RHO COMPONENT OF E DUE TO SIN(KS) CURRENT
C     ERC = RHO COMPONENT OF E DUE TO COS(KS) CURRENT
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 XK,ETA,EZK,EZS,EZCM,ERS,ERC
      SHAF=.5*SLEN
      SHS=SHAF*SHAF
      ZDIST=ABS(ZOB)+SHAF
      RZSQ=ZDIST*ZDIST+RHO*RHO
      IF(RZSQ.GT.100.*SHS)THEN
C
C     SERIES FOR R MUCH LARGER THAN SEGMENT LENGTH.
C
           CALL EKSCLR(SLEN,ZOB,RHO,XK,ETA,EZK,EZS,EZCM,ERS,ERC)
      ELSE
           RWLAM=6.283185/ABS(XK)
           IF(RZSQ.GT.(.01*RWLAM)**2)THEN
C
C     GENERAL FIELD EVALUATION.
C
                CALL EKSCEX (SLEN,ZOB,RHO,XK,ETA,EZK,EZS,EZCM,ERS,ERC)
           ELSE
C
C     SERIES FOR SMALL KR.
C
                CALL EKSMR(SLEN,ZOB,RHO,XK,ETA,EZK,EZS,EZCM,ERS,ERC)
           END IF
      END IF
      RETURN
      END
      SUBROUTINE SOMFLD(XI,YI,ZI,XJ,YJ,ZJ,DXJ,DYJ,DZJ,SLENJ,ARADJ,XKSX,
     &DMIN,IMAGF,EXK,EYK,EZK,EXS,EYS,EZS,EXC,EYC,EZC)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     SOMFLD evaluates the field due to a wire segment in the presence
C     of an air-ground interface.  If the source and evaluation points
C     are on opposite sides of the interface the total field is
C     returned.  If source and evaluation points are on the same side of
C     the interface only the component of E due to the Sommerfeld
C     integrals is evaluated, and must be combined with the direct field
C     and the quasistatic image field.
C
C     INPUT:
C     XI,YI,ZI = COORDINATES OF THE EVALUATION POINT
C     XJ,YJ,ZJ = COORDINATES OF THE CENTER OF THE SOURCE SEGMENT
C     DXJ,DYJ,DZJ = UNIT VECTOR IN THE DIRECTION OF THE SOURCE SEGMENT
C     SLENJ = LENGTH OF THE SOURCE SEGMENT
C     ARADJ = RADIUS OF THE SOURCE SEGMENT
C     XKSX = WAVE NUMBER FOR THE CURRENT EXPANSION ON THE SOURCE SEGMENT
C     DMIN = LIMIT TO THE DENOMINATOR IN THE RELATIVE ERROR TEST FOR
C            NUMERICAL INTEGRATION BY SUBROUTINE ROMBG
C     IMAGF = FLAG TO CONTROL EVALUATION MODE
C             IMAGF.GT.0 FOR REFLECTED FIELD, OTHERWISE TRANSMITTED.
C             IABS(IMAGF).EQ.2 FOR POINT SOURCE APPROXIMATON OTHERWISE
C             USE NUMERICAL INTEGRATION.
C
C     OUTPUT:
C     EXK,EYK,EZK = X,Y,Z COMPONENTS OF E DUE TO CONSTANT CURRENT
C     EXS,EYS,EZS = X,Y,Z COMPONENTS OF E DUE TO SIN(KS) CURRENT
C     EXC,EYC,EZC = X,Y,Z COMPONENTS OF E DUE TO COS(KS)-1 CURRENT
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 XKSX,EXK,EYK,EZK,EXS,EYS,EZS,EXC,EYC,EZC,XKSEG,EGND
      COMMON /INCOM/ XKSEG,SEGL,XSJ,YSJ,ZSJ,DIRX,DIRY,DIRZ,SN,XSN,YSN,
     &XO,YO,ZO,ISNOR,IREG,IDIRX
      DIMENSION EGND(9)
      EXTERNAL SFLDS
      SEGL=SLENJ
      DIRX=DXJ
      DIRY=DYJ
      DIRZ=DZJ
      XO=XI
      YO=YI
      ZO=ZI
      XKSEG=XKSX
      SN=SQRT(DXJ*DXJ+DYJ*DYJ)
      IF (SN.GT.1.E-5)THEN
         XSN=DXJ/SN
         YSN=DYJ/SN
      ELSE
         SN=0.
         XSN=1.
         YSN=0.
      END IF
C
C     DISPLACE SOURCE POINT TO THE SURFACE OF THE SOURCE SEGMENT IN A
C     DIRECTION NORMAL TO THE DIRECTION TO THE EVALUATION POINT.  IF THE
C     SOURCE AND EVALUATION POINTS ARE ON THE SAME SIDE OF THE INTERFACE
C     THE IMAGE OF THE SOURCE SEGMENT IS USED IN DETERMINING THE
C     DIRECTON FOR DISPLACEMENT.
C
      IF(IMAGF.GT.0)THEN
         ZR=-ZJ
         DZR=-DZJ
      ELSE
         ZR=ZJ
         DZR=DZJ
      END IF
      XIJ=XI-XJ
      YIJ=YI-YJ
      ZIJ=ZI-ZR
      RHOX=DYJ*ZIJ-DZR*YIJ
      RHOY=DZR*XIJ-DXJ*ZIJ
      RHOZ=DXJ*YIJ-DYJ*XIJ
      RHS=RHOX*RHOX+RHOY*RHOY+RHOZ*RHOZ
      IF(RHS.GT.1.E-20)THEN
         TWSHIF=ARADJ/SQRT(RHS)
         IF(RHOZ.LT.0.)TWSHIF=-TWSHIF
         IF(ZR.LT.0.)TWSHIF=-TWSHIF
         XSJ=XJ+TWSHIF*RHOX
         YSJ=YJ+TWSHIF*RHOY
         ZSJ=ZR+TWSHIF*RHOZ
         IF(IMAGF.GT.0)ZSJ=-ZSJ
      ELSE
         XSJ=XJ-ARADJ*YSN
         YSJ=YJ+ARADJ*XSN
         ZSJ=ZJ
      END IF
      IF (IABS(IMAGF).EQ.2)THEN
C
C     POINT SOURCE APPROXIMATION
C
         ISNOR=2
         IDIRX=1
         CALL SFLDS (0.D0,EGND)
      ELSE
C
C     FIELD FROM INTERPOLATION IS INTEGRATED OVER SEGMENT
C
         ISNOR=1
         IREG=0
         SHAF=.5*SLENJ
         RIJS=XIJ**2+YIJ**2+ZIJ**2
         IF(RIJS.LT.2.*SLENJ**2)THEN
            CALL ROMBG (-SHAF,SHAF,9,SFLDS,EGND,DMIN,1.D-4)
         ELSE
            CALL GAUSI3(-SHAF,SHAF,9,SFLDS,EGND)
         END IF
      END IF
      EXK=EGND(1)
      EYK=EGND(2)
      EZK=EGND(3)
      EXS=EGND(4)
      EYS=EGND(5)
      EZS=EGND(6)
      EXC=EGND(7)-EXK
      EYC=EGND(8)-EYK
      EZC=EGND(9)-EZK
      RETURN
      END
      SUBROUTINE GAUSI3(A,B,NFUN,FSUB,ANS)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     GAUSI3 INTEGRATES FUNCTIONS USING THREE-POINT GAUSSIAN INTEGRATION
C
C     INPUT:
C     A = LOWER LIMIT OF INTEGRATION
C     B = UPPER LIMIT OF INTEGRATION
C     NFUN = NUMBER OF FUNCTIONS TO INTEGRATE
C     FSUB = SUBROUTINE SUPPLYING THE INTEGRAND VALUES
C
C     OUTPUT:
C     ANS = ARRAY OF INTEGRAL VALUES FOR THE FUNCTIONS (COMPLEX)
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 ANS(*),G1(9),G2(9),G3(9)
      DATA WCEN/.4444444D0/,WOUT/.2777778D0/
      ABCEN=.5*(A+B)
      BA=B-A
      ABOUT=.3872983*BA
      CALL FSUB(ABCEN-ABOUT,G1)
      CALL FSUB(ABCEN,G2)
      CALL FSUB(ABCEN+ABOUT,G3)
      DO 1 I=1,NFUN
      ANS(I)=(WCEN*G2(I)+WOUT*(G1(I)+G3(I)))*BA
1     CONTINUE
      RETURN
      END
      SUBROUTINE SFLDS (T,E)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     SFLDS returns the field due to a current element in the presence
C     of ground.  The current element is on a filament defined in
C     COMMON /INCOM/ at a distance T from the center of the filament.
C     The main function of SFLDS is to transform coordinates and combine
C     field components.
C
C     INPUT (ARGUMENT):
C     T = DISTANCE OF THE CURRENT ELEMENT FROM THE CENTER OF THE
C
C     INPUT (COMMON/INCOM/):
C     SEGL = LENGTH OF THE CURRENT FILAMENT
C     XJ,YJ,ZJ = COORDINATES OF THE CENTER OF THE FILAMENT
C     DIRX,DIRY,DIRZ = UNIT VECTOR ALONG THE FILAMENT
C     SN = LENGTH OF THE PROJECTION OF THE FILAMENT ONTO THE XY PLANE
C     XSN,YSN = UNIT VECTOR ALONG THE PROJECTION OF THE FILAMENT ONTO
C               THE XY PLANE
C     XO,YO,ZO = COORDINATES OF THE FIELD EVALUATION POINT
C     XKSEG = WAVENUMBER FOR THE CURRENT EXPANSION ON THE SOURCE SEGMENT
C     ISNOR = 1 TO EVALUATE SOMMERFELD INTEGRAL FIELD, GRID TRANSITIONS
C               SMOOTHED
C           = 2 TO EVALUATE SOMMERFELD INTEGRAL FIELD, NO SMOOTHING
C     IREG = GRID REGION
C     IDIRX = 1 TO SUPPRESS THE DIRECT FIELD AND COMPUTE ONLY FIELD
C             DUE TO GROUND.  OTHERWISE DIRECT FIELD IS INCLUDED.
C
C     OUTPUT:
C     E = ARRAY OF FIELD COMPONENTS
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 E,XKSEG,XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,FRATI,ETAL2,
     &ERV,EZV,ERH,EPH,EZH,SFAC,RK
      COMMON /INCOM/ XKSEG,SEGL,XSJ,YSJ,ZSJ,DIRX,DIRY,DIRZ,SN,XSN,YSN,
     &XO,YO,ZO,ISNOR,IREG,IDIRX
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      DIMENSION E(9)
      XT=XSJ+T*DIRX
      YT=YSJ+T*DIRY
      ZT=ZSJ+T*DIRZ
      IF (ZT*ZSJ.LT.0.) ZT=0.
      RHX=XO-XT
      RHY=YO-YT
      RHS=RHX*RHX+RHY*RHY
      RHO=SQRT(RHS)
      IF (RHO.EQ.0.)THEN
         RHX=1.
         RHY=0.
         PHX=0.
         PHY=1.
      ELSE
         RHX=RHX/RHO
         RHY=RHY/RHO
         PHX=-RHY
         PHY=RHX
      END IF
      CPH=RHX*XSN+RHY*YSN
      SPH=RHY*XSN-RHX*YSN
      IF (ABS(CPH).LT.1.E-10) CPH=0.
      IF (ABS(SPH).LT.1.E-10) SPH=0.
      RHOS=RHO*GSCAL
      ZTS=ZT*GSCAL
      ZOS=ZO*GSCAL
      IF (ISNOR.EQ.1) GO TO 5
C
C     ISNOR.EQ.2 - FIELD FROM INTERPOLATION/L.S. APPROX. OR ASYMPTOTIC
C     APPROXIMATION. (NOT INTENDED FOR INTEGRATING BY ROMBG)
C
      CALL GNDEF (RHOS,ZTS,ZOS,IDIRX,ERV,EZV,ERH,EPH,EZH)
      SFAX=GSCAL*GSCAL
      ERH=(ERH*SN*CPH+ERV*DIRZ)*SFAX
      EPH=EPH*SN*SPH*SFAX
      EZH=(EZH*SN*CPH+EZV*DIRZ)*SFAX
      E(1)=(ERH*RHX+EPH*PHX)*SEGL
      E(2)=(ERH*RHY+EPH*PHY)*SEGL
      E(3)=EZH*SEGL
      E(4)=(0.,0.)
      E(5)=(0.,0.)
      E(6)=(0.,0.)
      SFAC=.5*XKSEG*SEGL
      SFAC=SIN(SFAC)/SFAC
      E(7)=E(1)*SFAC
      E(8)=E(2)*SFAC
      E(9)=E(3)*SFAC
      RETURN
C
C     ISNOR.EQ.1 - FIELD FROM INTERPOLATION OR L.S. APPROX. FOR
C     INTEGRATION OVER SEGMENT.  TRANSITION REGIONS SMOOTHED.
C
5     IZS=1
      IF (ZSJ.LT.0.) IZS=-1
      CALL RXFLD (RHOS,ZTS,ZOS,IZS,ERV,EZV,ERH,EPH,EZH,IREG)
      SFAX=GSCAL*GSCAL
      ERH=(ERH*SN*CPH+ERV*DIRZ)*SFAX
      EPH=EPH*SN*SPH*SFAX
      EZH=(EZH*SN*CPH+EZV*DIRZ)*SFAX
C     X,Y,Z FIELDS FOR CONSTANT CURRENT
      E(1)=ERH*RHX+EPH*PHX
      E(2)=ERH*RHY+EPH*PHY
      E(3)=EZH
      RK=XKSEG*T
C     X,Y,Z FIELDS FOR SINE CURRENT
      SFAC=SIN(RK)
      E(4)=E(1)*SFAC
      E(5)=E(2)*SFAC
      E(6)=E(3)*SFAC
C     X,Y,Z FIELDS FOR COSINE CURRENT
      SFAC=COS(RK)
      E(7)=E(1)*SFAC
      E(8)=E(2)*SFAC
      E(9)=E(3)*SFAC
      RETURN
      END
      SUBROUTINE EKSCEX (SLEN,ZOB,RHO,XK,ETA,EZK,EZS,EZCM,ERS,ERC)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     EKSCEX computes the components of electric field for a segment
C     with constant, SIN(KS) and COS(KS)-1 current distributions. The
C     exact field equations are evaluated.
C
C     !!!NOTE!!! THE CONTRIBUTIONS TO THE ELECTRIC FIELD DUE TO POINT
C     CHARGES (CURRENT DISCONTINUITIES) AT THE SEGMENT ENDS HAVE BEEN
C     DROPPED TO IMPROVE NUMERICAL ACCURACY.  HENCE THE FIELD IS CORRECT
C     ONLY WHEN COMBINED WITH THE FIELD OF OTHER SEGMENTS TO PRODUCE A
C     CONTINUOUS CURRENT THAT GOES TO ZERO AT FREE ENDS.
C
C     INPUT:
C     SLEN = SEGMENT LENGTH (M)
C     ZOB = Z COORDINATE OF EVALUATION POINT (M)
C     RHO = RHO COORDINATE OF EVALUATION POINT (M)
C     XK = WAVE NUMBER IN THE MEDIUM IN WHICH THE SEGMENT IS LOCATED
C     ETA = INTRINSIC IMPEDANCE OF THE MEDIUM (OHMS)
C
C     OUTPUT:
C     EZK = Z COMPONENT OF E DUE TO CONSTANT CURRENT (V/M)
C     EZS = Z COMPONENT OF E DUE TO SIN(KS) CURRENT
C     EZCM= Z COMPONENT OF E DUE TO COS(KS)-1 CURRENT
C     ERS = RHO COMPONENT OF E DUE TO SIN(KS) CURRENT
C     ERC = RHO COMPONENT OF E DUE TO COS(KS) CURRENT
C     (CONSTANT CURRENT PRODUCES ZERO RHO COMPONENT OF E)
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 XK,ETA,EZK,EZS,EZCM,ERS,ERC,CON,CONK,SHK,SS,CS,EXRI,
     &GZ1,GZ2
      DATA CON/(0.D0,.07957747151D0)/
      CONK=CON*ETA
      SH=.5*SLEN
      SHK=XK*SH
      SS=SIN(SHK)
      CS=COS(SHK)
      Z2=SH-ZOB
      Z1=-(SH+ZOB)
C
C     EXRINT EVALUATES THE INTEGRAL OF EXP(-J*XK*R)/R.
C
      CALL EXRINT(RHO,ZOB,SLEN,XK,EXRI)
      EZK=-CONK*XK*EXRI
      R1=SQRT(Z1*Z1+RHO*RHO)
      R2=SQRT(Z2*Z2+RHO*RHO)
      GZ1=EXP(-(0.D0,1.D0)*XK*R1)/R1
      GZ2=EXP(-(0.D0,1.D0)*XK*R2)/R2
      EZS=CONK*(GZ2-GZ1)*CS
      EZCM=-CONK*(GZ2+GZ1)*SS-EZK
      IF(RHO.GT..01*MIN(R1,R2).OR.(Z2.GT.0..AND.Z1.LT.0.))THEN
           ERS=CONK*((GZ2*Z2-GZ1*Z1)*CS+(0.,1.)*(GZ2*R2+GZ1*R1)*SS)/RHO
           ERC=-CONK*((GZ2*Z2+GZ1*Z1)*SS-(0.,1.)*(GZ2*R2-GZ1*R1)*CS)/RHO
      ELSE
C
C     ESMLRH EVALUATES THE RHO COMPONENTS OF E FOR SMALL RHO/R.
C
           CALL ESMLRH(SLEN,ZOB,RHO,XK,ETA,ERS,ERC)
      END IF
      RETURN
      END
      SUBROUTINE EKSCKS (SLEN,ZOB,RHO,XK,ETA,XKS,EZK,EZS,EZCM,ERS,ERC)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     EKSCKS computes the components of electric field for a segment
C     with constant, SIN(KS) and COS(KS)-1 current distributions. The
C     exact field equations are evaluated in the form allowing the
C     wavenumber on in the current expansion to be different from that
C     in the medium.
C
C     !!!NOTE!!! THE CONTRIBUTIONS TO THE ELECTRIC FIELD DUE TO POINT
C     CHARGES (CURRENT DISCONTINUITIES) AT THE SEGMENT ENDS HAVE BEEN
C     DROPPED TO IMPROVE NUMERICAL ACCURACY.  HENCE THE FIELD IS CORRECT
C     ONLY WHEN COMBINED WITH THE FIELD OF OTHER SEGMENTS TO PRODUCE A
C     CONTINUOUS CURRENT THAT GOES TO ZERO AT FREE ENDS.
C
C     INPUT:
C     SLEN = SEGMENT LENGTH (M)
C     ZOB = Z COORDINATE OF EVALUATION POINT (M)
C     RHO = RHO COORDINATE OF EVALUATION POINT (M)
C     XK = WAVE NUMBER IN THE MEDIUM IN WHICH THE SEGMENT IS LOCATED
C     ETA = INTRINSIC IMPEDANCE OF THE MEDIUM (OHMS)
C     XKS = WAVENUMBER FOR THE CURRENT EXPANSION
C
C     OUTPUT:
C     EZK = Z COMPONENT OF E DUE TO CONSTANT CURRENT (V/M)
C     EZS = Z COMPONENT OF E DUE TO SIN(KS) CURRENT
C     EZCM= Z COMPONENT OF E DUE TO COS(KS)-1 CURRENT
C     ERS = RHO COMPONENT OF E DUE TO SIN(KS) CURRENT
C     ERC = RHO COMPONENT OF E DUE TO COS(KS) CURRENT
C     (CONSTANT CURRENT PRODUCES ZERO RHO COMPONENT OF E)
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 XK,ETA,XKS,EZK,EZS,EZCM,ERS,ERC,EXI,CON,CONK,XKDIF,SHK,
     &SS,CS,GZ1,GZ2
      DIMENSION EXI(5)
      DATA CON/(0.D0,.07957747151D0)/
      CONK=CON*ETA/XK
      XKDIF=XK*XK-XKS*XKS
      SH=.5*SLEN
      SHK=XKS*SH
      SS=SIN(SHK)
      CS=COS(SHK)
      Z2=SH-ZOB
      Z1=-(SH+ZOB)
C
C     EFINT EVALUATES THE INTEGRALS INVOLVING SIN/COS * EXP(-J*XK*R)/R.
C
      CALL EFINT(SLEN,RHO,ZOB,XK,XKS,EXI)
      EZK=-CONK*XK*XK*EXI(1)
      R1=SQRT(Z1*Z1+RHO*RHO)
      R2=SQRT(Z2*Z2+RHO*RHO)
      GZ1=EXP(-(0.D0,1.D0)*XK*R1)/R1
      GZ2=EXP(-(0.D0,1.D0)*XK*R2)/R2
      EZS=CONK*(XKS*(GZ2-GZ1)*CS-XKDIF*EXI(2))
      EZCM=-CONK*(XKS*(GZ2+GZ1)*SS+XKDIF*EXI(3))-EZK
      ERS=CONK*((XKS*(GZ2*Z2-GZ1*Z1)*CS+(0.,1.)*XK*(GZ2*R2+GZ1*R1)*SS)
     &+XKDIF*EXI(4))/RHO
      ERC=-CONK*((XKS*(GZ2*Z2+GZ1*Z1)*SS-(0.,1.)*XK*(GZ2*R2-GZ1*R1)*CS)
     &-XKDIF*EXI(5))/RHO
      RETURN
      END
      SUBROUTINE EFINT(S,RHO,ZZX,XK,XKS,EXI)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     EFINT RETURNS EXI(1)= INTEGRAL OF CEXP(-J*KR)/R
C     EXI(2),EXI(3)= INTEGRALS OF (SIN (KS),COS(KS))*CEXP(-J*KR)/R
C     EXI(4),EXI(5)= INT. OF (ZP-ZZ)*(SIN(KS),COS(KS))*CEXP(-J*KR)/R
C     WHERE KS=XKS*(ZP-ZZ) AND KR=XK*R
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 XK,XKS,EXI,XKJ,XKSJ,RI2,RI4,RI5,EXX
      COMMON /TMI/XKJ,XKSJ,ZZ,RH2,IJ
      DIMENSION EXI(5)
      EXTERNAL GF
      ZZ=ZZX
      RH2=RHO*RHO
      XKJ=(0.,1.)*XK
      XKSJ=(0.,1.)*XKS
      Z2=.5*S
      Z1=-Z2
      ICENT=0
      IF(ABS(ZZ)/S.LT.1.E-6)THEN
         ICENT=1
         Z1=0.
      END IF
      ZD1=Z1-ZZ
      ZD2=Z2-ZZ
      RKM=1./ABS(XK)
      IJ=0
      IF(RHO.GT.RKM)IJ=1
      IF(ZD2.LT.-RKM)IJ=1
      IF(ZD1.GT.RKM)IJ=1
      DMIN=0.
      IF(IJ.EQ.0)THEN
C
C     EVALUATE INT. OF TERMS SUBTRACTED FROM INTEGRAND TO SMOOTH PEAKS
C
         R1=SQRT(ZD1*ZD1+RH2)
         R2=SQRT(ZD2*ZD2+RH2)
         IF(ZD2.GT.0.)THEN
            RI1=LOG((R2+ZD2)/(R1+ZD1))
         ELSE
            RI1=-LOG((R2-ZD2)/(R1-ZD1))
         END IF
         RI2=RI1-XKJ*(Z2-Z1)
         RI3=R2-R1
         RI4=XKJ*.5*(ZD2*ZD2-ZD1*ZD1)-RI3
         RI5=XKSJ*(.5*(ZD2*R2-ZD1*R1-RH2*RI1))
         DMIN=.01*RI1
      END IF
C
C     NUMERICAL INTEGRATION
C
      CALL ROMBG(Z1,Z2,5,GF,EXI,DMIN,1.D-5)
C
C     ADD INTEGRALS REMOVED TO SMOOTH PEAKS.
C
      IF(IJ.EQ.0)THEN
         EXX=EXP(XKSJ*ZZ)
         EXI(1)=EXI(1)+RI1
         EXI(2)=(EXI(2)+RI2+XKSJ*RI3)*EXX
         EXI(3)=(EXI(3)+RI2-XKSJ*RI3)/EXX
         EXI(4)=(EXI(4)+RI4-RI5)*EXX
         EXI(5)=(EXI(5)+RI4+RI5)/EXX
      END IF
C
C     CONVERT FROM EXP(+-KZ) TO SIN(KZ), COS(KZ)
C
      EXX=(0.,-.5)*(EXI(2)-EXI(3))
      EXI(3)=.5*(EXI(2)+EXI(3))
      EXI(2)=EXX
      EXX=(0.,-.5)*(EXI(4)-EXI(5))
      EXI(5)=.5*(EXI(4)+EXI(5))
      EXI(4)=EXX
      IF(ICENT.EQ.1)THEN
         EXI(1)=2.*EXI(1)
         EXI(2)=0.
         EXI(3)=2.*EXI(3)
         EXI(4)=2.*EXI(4)
         EXI(5)=0.
      END IF
      RETURN
      END
      SUBROUTINE GF (Z,EX)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     GF COMPUTES THE INTEGRAND EXP(-JKR)/(KR) FOR NUMERICAL INTEGRATION
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 EX,XKJ,XKSJ,RKJ,ZA
      COMMON /TMI/XKJ,XKSJ,ZZ,RH2,IJ
      DIMENSION EX(5)
      DATA C1,C2,C3,C4,C5,C6,C7,C8/1.D0,.5D0,.166666666667D0,
     &4.1666666667D-2,8.33333333D-3,1.388888889D-3,1.98412698D-4,
     &2.48015873D-5/
      ZDM=Z-ZZ
      R=SQRT(RH2+ZDM*ZDM)
      RKJ=-XKJ*R
      IF (IJ.NE.0)THEN
C
C     COMPLETE INTEGRAND
C
         EX(1)=EXP(RKJ)/R
         EX(2)=EXP(RKJ+XKSJ*Z)/R
         EX(3)=EXP(RKJ-XKSJ*Z)/R
      ELSE
C
C     INTEGRAND WITH TERMS REMOVED TO SMOOTH PEAKS
C
         IF (ABS(RKJ).GT.0.2)THEN
            EX(1)=(EXP(RKJ)-1.)/R
            ZA=RKJ+XKSJ*ZDM
            EX(2)=(EXP(ZA)-(1.+ZA))/R
            ZA=RKJ-XKSJ*ZDM
            EX(3)=(EXP(ZA)-(1.+ZA))/R
         ELSE
C
C     INTEGRAND WITH TERMS REMOVED TO SMOOTH PEAKS (SMALL ARGUMENT)
C
            ZA=RKJ
            EX(1)=-((((((C7*ZA+C6)*ZA+C5)*ZA+C4)*ZA+C3)*ZA+C2)*ZA+C1)*
     &            XKJ
            ZA=RKJ+XKSJ*ZDM
            EX(2)=((((((C8*ZA+C7)*ZA+C6)*ZA+C5)*ZA+C4)*ZA+C3)*ZA+C2)*
     &            ZA*ZA/R
            ZA=RKJ-XKSJ*ZDM
            EX(3)=((((((C8*ZA+C7)*ZA+C6)*ZA+C5)*ZA+C4)*ZA+C3)*ZA+C2)*
     &            ZA*ZA/R
         END IF
      END IF
      EX(4)=-ZDM*EX(2)
      EX(5)=-ZDM*EX(3)
      RETURN
      END
      SUBROUTINE EKSCLR(SLEN,ZOB,RHO,XK,ETA,EZK,EZS,EZCM,ERS,ERC)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     EKSCLR computes the components of electric field for a segment
C     with constant, SIN(KS) and COS(KS)-1 current distributions.
C     Series approximations for R large relative to segment length are
C     used.
C
C     !!!NOTE!!! THE CONTRIBUTIONS TO THE ELECTRIC FIELD DUE TO POINT
C     CHARGES (CURRENT DISCONTINUITIES) AT THE SEGMENT ENDS HAVE BEEN
C     DROPPED TO IMPROVE NUMERICAL ACCURACY.  HENCE THE FIELD IS CORRECT
C     ONLY WHEN COMBINED WITH THE FIELD OF OTHER SEGMENTS TO PRODUCE A
C     CONTINUOUS CURRENT THAT GOES TO ZERO AT FREE ENDS.
C
C     INPUT:
C     SLEN = SEGMENT LENGTH (M)
C     ZOB = Z COORDINATE OF EVALUATION POINT (M)
C     RHO = RHO COORDINATE OF EVALUATION POINT (M)
C     XK = WAVE NUMBER IN THE MEDIUM IN WHICH THE SEGMENT IS LOCATED
C     ETA = INTRINSIC IMPEDANCE OF THE MEDIUM (OHMS)
C
C     OUTPUT:
C     EZK = Z COMPONENT OF E DUE TO CONSTANT CURRENT (V/M)
C     EZS = Z COMPONENT OF E DUE TO SIN(KS) CURRENT
C     EZCM= Z COMPONENT OF E DUE TO COS(KS)-1 CURRENT
C     ERS = RHO COMPONENT OF E DUE TO SIN(KS) CURRENT
C     ERC = RHO COMPONENT OF E DUE TO COS(KS) CURRENT
C     (CONSTANT CURRENT PRODUCES ZERO RHO COMPONENT OF E)
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 XK,ETA,EZK,EZS,EZCM,ERS,ERC,CON,FJ,A1,AR1,A2,CONR,D1,
     &D2,D3,AR2
      DATA CON/(0.D0,.07957747151D0)/,FJ/(0.D0,1.D0)/
C
C     SERIES FOR R LARGE RELATIVE TO SEGMENT LENGTH AND SEGMENT LENGTH
C     LESS THAN APPROXIMATELY 0.2 WAVELENGTHS.
C
      SH=.5*SLEN
      SHS=SH*SH
      RHS=RHO*RHO
      ZS=ZOB*ZOB
      RZS=RHS+ZS
      RZ=SQRT(RZS)
      RRZ=1./RZ
      A1=-FJ*XK
      AR1=A1*RZ
      IF(ABS(XK)*RZ.LT..062831)GO TO 1
      A2=A1*A1
      CONR=SLEN*CON*ETA*EXP(AR1)
      D1=ZOB*(RRZ-A1)/RZS
      D2=.5*RRZ*((2.*ZS-RHS)*(RRZ-A1)*RRZ+A2*ZS)/RZS
      D3=.5*ZOB/RZS*(((2.*ZS-3.*RHS)*(RRZ-A1)*RRZ+A2*(ZS-RHS))*RRZ-
     &.3333333*A2*ZS*A1)/RZS
      ERC=-CONR*XK*ZOB*RHO/RZS*SHS/RZS*((AR1*.33333333-1.)*AR1+1.)*RRZ
      ERS=-CONR*RHO/RZS*(AR1-1.+SHS/RZS*(.5*(RHS-4.*ZS)*(RRZ-A1)*RRZ-
     &A2*ZS+.16666667*A2*(RHS+2.*ZS)*AR1))*RRZ
      EZK=-CONR*XK*(RRZ+.3333333*D2*SHS)
      EZS=CONR*(D1+(D3+.5*A2*D1)*SHS)
      EZCM=-CONR*XK*SHS*.16666667*(4.*D2+A2*RRZ)
      RETURN
C
C     SERIES FOR R LARGE RELATIVE TO SEGMENT LENGTH AND FOR KR AND
C     K*SLEN SMALL.
C
1     AR2=AR1*AR1
      CONR=SH/RZS*CON*ETA
      EZS=-CONR*2.*((((.03333333*AR1+.125)*AR1+.33333333)*AR1+.5)*AR2-1.
     &)
      ERS=RHO*RRZ*EZS
      EZS=ZOB*RRZ*EZS
      ERC=-2./3.*CONR*XK*RHO*ZOB/RZS*SHS*RRZ*(((.066666667*AR1+.125)*AR2
     &-.5)*AR2+3.)
      TRM1=2.*(2.*ZS-RHS)
      TRM2=ZS+2.*RHS
      TRM3=1.6666667*RZS
      TRM4=.25*(4.*ZS+3.*RHS)
      TRM5=8.333333E-3*(9.*RHS-13.*ZS)
      EZCM=-CONR*XK*SHS/(3.*RZ)*((((TRM5*AR1+TRM4)*AR1+TRM3)*AR1+TRM2)*
     &AR2+TRM1)/RZS
      TRM1=6.*RZS+(2.*ZS-RHS)/RZS*SHS
      TRM2=6.*RZS
      TRM3=3.*RZS+.5*SHS/RZS*RHS
      TRM4=RZS+SHS
      EZK=-CONR*XK/(3.*RZ)*(((TRM4*AR1+TRM3)*AR1+TRM2)*AR1+TRM1)
      RETURN
      END
      SUBROUTINE ESMLRH(SEGL,ZOB,RHO,XK,ETA,ERS,ERC)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     ESMLRH computes the RHO component of the E field of SIN(K*S) and
C     COS(K*S) current filaments by an approximation for small RHO.
C     The relative error in the approximation is of order (RHO/ZMIN)**2
C     where ZMIN=ABS(ZOB)-.5*ABS(SEGL).
C
C     !!!NOTE!!! THE CONTRIBUTIONS TO THE ELECTRIC FIELD DUE TO POINT
C     CHARGES (CURRENT DISCONTINUITIES) AT THE SEGMENT ENDS HAVE BEEN
C     DROPPED TO IMPROVE NUMERICAL ACCURACY.  HENCE THE FIELD IS CORRECT
C     ONLY WHEN COMBINED WITH THE FIELD OF OTHER SEGMENTS TO PRODUCE A
C     CONTINUOUS CURRENT THAT GOES TO ZERO AT FREE ENDS.
C
C     INPUT:
C     SLEN = SEGMENT LENGTH (M)
C     ZOB = Z COORDINATE OF EVALUATION POINT (M)
C     RHO = RHO COORDINATE OF EVALUATION POINT (M)
C     XK = WAVE NUMBER IN THE MEDIUM IN WHICH THE SEGMENT IS LOCATED
C     ETA = INTRINSIC IMPEDANCE OF THE MEDIUM (OHMS)
C
C     OUTPUT:
C     ERS = RHO COMPONENT OF E DUE TO SIN(KS) CURRENT
C     ERC = RHO COMPONENT OF E DUE TO COS(KS) CURRENT
C     (CONSTANT CURRENT PRODUCES ZERO RHO COMPONENT OF E)
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 XK,ETA,ERS,ERC,CON,FJ,XKJ,EXKZ,EXMKD,EXPKD,COSKD,
     &SINKD,TERM1,TERM2,TERM3,TERM4,XK2,XK3
      DATA CON/(0.D0,.079577471D0)/,FJ/(0.D0,1.D0)/
      SH=.5*SEGL
      XKJ=FJ*XK
      ABZ=ABS(ZOB)
      EXKZ=EXP(-XKJ*ABZ)
      EXMKD=EXP(-XKJ*SH)
      EXPKD=1./EXMKD
      COSKD=.5*(EXPKD+EXMKD)
      SINKD=(0.,.5)*(EXMKD-EXPKD)
      TERM1=EXMKD/(ABZ+SH)**2
      TERM2=EXPKD/(ABZ-SH)**2
      TERM3=XK*SH/(ABZ**2-SH**2)
      IF(ABS(ZOB*XK).GT..125)THEN
           TERM4=-CON*ETA*RHO*EXKZ
           ERS=TERM4*(.5*(TERM1-TERM2)*COSKD-FJ*TERM3)
           ERC=TERM4*(.5*(TERM1+TERM2)*SINKD-TERM3)
      ELSE
           ZSQ=ZOB*ZOB
           SHSQ=SH*SH
           DEN=1./(ZSQ-SHSQ)
           XK2=XK*XK
           XK3=XK2*XK
           TERM1=XK2*(ZSQ-2.*SHSQ)
           TERM4=CON*ETA*RHO*SH
           ERS=TERM4*(ABZ*DEN*(2.+TERM1)*DEN-FJ*XK3*2./3.)
           ERC=-TERM4*XK*(SHSQ*DEN*(2.+TERM1/3.)*DEN-FJ*XK3*SHSQ*XK2*ABZ
     &     *2./45.)
      END IF
      IF(ZOB.LT.0.)ERC=-ERC
      RETURN
      END
      SUBROUTINE EXRINT(RHO,ZOB,SLEN,XK,EXRI)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     EXRINT evaluates the integral of EXP(-J*K*R)/R integrated over a
C     segment.
C
C     INPUT:
C     RHO = RHO COORDINATE OF EVALUATION POINT (M)
C     ZOB = Z COORDINATE OF EVALUATION POINT (M)
C     SLEN = SEGMENT LENGTH (M)
C     XK = WAVE NUMBER IN THE MEDIUM IN WHICH THE SEGMENT IS LOCATED
C
C     OUTPUT:
C     EXRI = INTEGRAL OF EXP(-J*K*R)/R
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 XK,EXRI,XKJ,XJS,RX,TM1,TM2,TM3,TM4,TM5
      XKJ=-(0.,1.)*XK
      RHS=RHO*RHO
      SH=.5*SLEN
      IF(RHS+ZOB*ZOB.GT.36.*SLEN*SLEN)GO TO 1
C
C     SERIES APPROXIMATION FOR INTEGRAL OF EXP(-J*K*R)/R.
C
      S1=-SH-ZOB
      SS1=S1*S1
      RS1=RHS+SS1
      R1=SQRT(RS1)
      S2=SH-ZOB
      SS2=S2*S2
      RS2=RHS+SS2
      R2=SQRT(RS2)
C
C     RIN IS THE INTEGRAL OF R**(N-2) FROM -SH TO SH
C
      IF(S1.GT.0.)THEN
           RI1=LOG((R2+S2)/(R1+S1))
      ELSE
           DIFR=R2-S2
           IF(S2.GT.0..AND.RHO.LT..05*R2)DIFR=.5*RHS/S2*(1.-.25*RHS/SS2)
           RI1=LOG((R1-S1)/DIFR)
      END IF
      RI2=S2-S1
      RI3=.5*(RHS*RI1+S2*R2-S1*R1)
      RI4=RHS*RI2+(SS2*S2-SS1*S1)/3.
      RI5=.75*RHS*RI3+.25*(S2*RS2*R2-S1*RS1*R1)
      XJS=XKJ*XKJ
      RZ=SQRT(RHS+ZOB*ZOB)
      RX=XKJ*RZ
      TM1=(((.0416666666667*RX-.166666666667)*RX+.5)*RX-1.)*RX+1.
      TM2=-XKJ*(((.166666666667*RX-.5)*RX+1.)*RX-1.)
      TM3=XJS*((.25*RX-.5)*RX+.5)
      TM4=.166666666667*XKJ*XJS*(1.-RX)
      TM5=.0416666666667*XJS*XJS
      EXRI=(TM1*RI1+TM2*RI2+TM3*RI3+TM4*RI4+TM5*RI5)*EXP(RX)
      RETURN
C
C     Approximation for distance large compared to segment length
C
1     R0S=RHS+ZOB**2
      R0=SQRT(R0S)
      RX=XKJ*R0
      TM1=2./R0
      TM2=(R0S*(RX-1.)+ZOB**2*((RX-3.)*RX+3.))/(3.*R0S*R0S*R0)
      EXRI=(TM2*SH**2+TM1)*SH*EXP(RX)
      RETURN
      END
      SUBROUTINE EKSMR(SLEN,ZOB,RHO,XK,ETA,EZK,EZS,EZCM,ERS,ERC)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     EKSSMR computes the components of electric field for a segment
C     with constant, SIN(KS) and COS(KS)-1 current distributions. Series
C     for small KR are used.
C
C     !!!NOTE!!! THE CONTRIBUTIONS TO THE ELECTRIC FIELD DUE TO POINT
C     CHARGES (CURRENT DISCONTINUITIES) AT THE SEGMENT ENDS HAVE BEEN
C     DROPPED TO IMPROVE NUMERICAL ACCURACY.  HENCE THE FIELD IS CORRECT
C     ONLY WHEN COMBINED WITH THE FIELD OF OTHER SEGMENTS TO PRODUCE A
C     CONTINUOUS CURRENT THAT GOES TO ZERO AT FREE ENDS.
C
C     INPUT:
C     SLEN = SEGMENT LENGTH (M)
C     ZOB = Z COORDINATE OF EVALUATION POINT (M)
C     RHO = RHO COORDINATE OF EVALUATION POINT (M)
C     XK = WAVE NUMBER IN THE MEDIUM IN WHICH THE SEGMENT IS LOCATED
C     ETA = INTRINSIC IMPEDANCE OF THE MEDIUM (OHMS)
C
C     OUTPUT:
C     EZK = Z COMPONENT OF E DUE TO CONSTANT CURRENT (V/M)
C     EZS = Z COMPONENT OF E DUE TO SIN(KS) CURRENT
C     EZCM= Z COMPONENT OF E DUE TO COS(KS)-1 CURRENT
C     ERS = RHO COMPONENT OF E DUE TO SIN(KS) CURRENT
C     ERC = RHO COMPONENT OF E DUE TO COS(KS) CURRENT
C     (CONSTANT CURRENT PRODUCES ZERO RHO COMPONENT OF E)
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 XK,ETA,EZK,EZS,EZCM,ERS,ERC,CON,FJ,CONK,A1,A2,A3,A4,
     &EX1,EX2,ESUM,EDIF,EORDFX,EORSMX,EORDIF,EORSUM,EINT,SHXK,SHXK3,
     &TXK3,COSKD,SINKD,XK2,XK3,TERM1
      DATA CON/(0.D0,.07957747151D0)/,FJ/(0.D0,1.D0)/
      CONK=CON*ETA
      SH=.5*SLEN
      RHS=RHO*RHO
      S1=-SH-ZOB
      SS1=S1*S1
      RS1=RHS+SS1
      R1=SQRT(RS1)
      RC1=RS1*R1
      S2=SH-ZOB
      SS2=S2*S2
      RS2=RHS+SS2
      R2=SQRT(RS2)
      RC2=RS2*R2
C
C     RIN IS THE INTEGRAL OF R**(N-2) FROM -SH TO SH
C
      IF(S1.GT.0.)THEN
           RI1=LOG((R2+S2)/(R1+S1))
      ELSE
           RSDIF=R2-S2
           IF(S2.GT.0..AND.RHO.LT..05*R2)RSDIF=.5*RHS/S2*(1.-.25*RHS/
     &     SS2)
           RI1=LOG((R1-S1)/RSDIF)
      END IF
      RI2=S2-S1
      RI3=.5*(RHS*RI1+S2*R2-S1*R1)
      RI4=RHS*RI2+(SS2*S2-SS1*S1)/3.
      RI5=.75*RHS*RI3+.25*(S2*RC2-S1*RC1)
C
C     SERIES EVALUATION FOR E FIELD COMPONENTS FOR SMALL R
C
      A1=-FJ*XK
      A2=A1*A1*.5
      A3=A1*A2/3.
      A4=A1*A3*.25
      EINT=XK*(RI1+A2*RI3+A3*RI4+A4*RI5)
      EX1=A1*R1+A3*RC1
      EX2=A1*R2+A3*RC2
      ESUM=EX2+EX1
      EDIF=EX2-EX1
      EORSMX=1./R2+1./R1+A2*(R2+R1)+A4*(RC2+RC1)
      EORDFX=1./R2-1./R1+A2*(R2-R1)+A4*(RC2-RC1)
      EORSUM=EORSMX+A3*(RS2+RS1)
      EORDIF=EORDFX+A3*(RS2-RS1)
      SHXK=SH*XK
      SHXK3=SHXK**3/3.
      TXK3=2.*FJ*XK**3*RHO/3.
      COSKD=1.-.5*SHXK*SHXK
      SINKD=SHXK-.5*SHXK3
      EZS=CONK*EORDIF*COSKD
      EZCM=-CONK*(EORSUM*SINKD-EINT-A1*SHXK3)
      EZK=-CONK*(EINT+XK*A1*RI2)
      IF(RHO.GT..04*MIN(R1,R2).OR.(S1.LT.0.AND.S2.GT.0.))THEN
           ERS=-CONK*(((ZOB*EORDFX-SH*EORSMX)*COSKD-FJ*ESUM*SINKD)/RHO+
     &     TXK3*SH)
           ERC= CONK*(((ZOB*EORSMX-SH*EORDFX)*SINKD+FJ*EDIF*COSKD)/RHO+
     &     TXK3*SHXK3*ZOB/5.)
      ELSE
C
C     SMALL RHO APPROXIMATION FOR RADIAL E FIELD
C
           ABZ=ABS(ZOB)
           ZSQ=ZOB*ZOB
           SHSQ=SH*SH
           DEN=1./(ZSQ-SHSQ)
           XK2=XK*XK
           XK3=XK2*XK
           TERM1=XK2*(ZSQ-2.*SHSQ)
           ERS=CONK*RHO*(ABZ*SH*DEN*(2.+TERM1)*DEN-FJ*XK3*SH*2./3.)
           ERC=-CONK*XK*RHO*SH*(SHSQ*DEN*(2.+TERM1/3.)*DEN-FJ*XK3*SHSQ*
     &     XK2*ABZ*2./45.)
           IF(ZOB.LT.0.)ERC=-ERC
      END IF
      RETURN
      END
      SUBROUTINE EKSCPQ(ZPTQ,ZOB,RHO,XK,ETA,XKS,EZK,EZS,EZCM,ERK,ERS,
     &ERCM)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     EKSCPQ adds the field of the delta function charge at the end of
C     a segment to the previously computed field values.
C
C     INPUT:
C     ZPTQ = Z COORDINATE OF THE POINT CHARGE AT UPPER OR LOWER END OF
C            THE SEGMENT (M)
C     ZOB = Z COORDINATE OF EVALUATION POINT (M)
C     RHO = RHO COORDINATE OF EVALUATION POINT (M)
C     XK = WAVE NUMBER IN THE MEDIUM IN WHICH THE SEGMENT IS LOCATED
C     ETA = INTRINSIC IMPEDANCE OF THE MEDIUM (OHMS)
C     XKS = WAVENUMBER FOR THE CURRENT EXPANSION
C
C     OUTPUT:
C     EZK = Z COMPONENT OF E DUE TO CONSTANT CURRENT (V/M)
C     EZS = Z COMPONENT OF E DUE TO SIN(KS) CURRENT
C     EZCM = Z COMPONENT OF E DUE TO COS(KS)-1 CURRENT
C     ERK = RHO COMPONENT OF E DUE TO CONSTANT CURRENT
C     ERS = RHO COMPONENT OF E DUE TO SIN(KS) CURRENT
C     ERCM = RHO COMPONENT OF E DUE TO COS(KS)-1 CURRENT
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 XK,ETA,XKS,EZK,EZS,EZCM,ERK,ERS,ERCM,CON,FJ,XKR,EPTQ,
     &EPTZ,EPTR,SINKS,COSKSM,CCOSM1
      DATA CON/(0.D0,.07957747151D0)/,FJ/(0.D0,1.D0)/
      ZDIF=ZOB-ZPTQ
      RSQ=RHO*RHO+ZDIF*ZDIF
      R=SQRT(RSQ)
      XKR=FJ*XK*R
      EPTQ=-CON*ETA/XK*(1.+XKR)*EXP(-XKR)/RSQ*SIGN(1.D0,ZPTQ)
      EPTZ=EPTQ*ZDIF/R
      EPTR=EPTQ*RHO/R
      SINKS=SIN(XKS*ZPTQ)
      COSKSM=CCOSM1(XKS*ZPTQ)
      EZK=EZK+EPTZ
      ERK=ERK+EPTR
      EZS=EZS+EPTZ*SINKS
      ERS=ERS+EPTR*SINKS
      EZCM=EZCM+EPTZ*COSKSM
      ERCM=ERCM+EPTR*COSKSM
      RETURN
      END
      SUBROUTINE CABC (CURX)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     CABC computes coefficients of the constant (A), SIN(K*S) (B), and
C     COS(K*S)-1 (C) terms in the current interpolation functions for
C     the current vector CUR.
C
C     THIS VERSION WAS MODIFIED ON 7/9/86 TO ACCOUNT FOR THE USE OF
C     COS(K*S)-1 TO IMPROVE ACCURACY AT LOW FREQUENCY IN THE CURRENT
C     EXPANSION.
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 CURX,AIX,BIX,CIX,CUR,XKS,AX,BX,CX,XKU,XKL,ETAU,ETAL,
     &CEPSU,CEPSL,ETAL2,FRATI,CCJ,CURD,VOLTS,CS1,CS2
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON/CRNT/AIX(MAXSEG),BIX(MAXSEG),CIX(MAXSEG),CUR(3*MAXSEG),
     &XKS(MAXSEG)
      COMMON /SEGJ/ AX(NSJMAX),BX(NSJMAX),CX(NSJMAX),JCO(NSJMAX),JSNO,
     &ISCON(NSCNGF),NSCON,IPCON(NSPNGF),NPCON
      COMMON /SORCES/ PSOR1(NSOMAX),PSOR2(NSOMAX),PSOR3(NSOMAX),
     &PSOR4(NSOMAX),PSOR5(NSOMAX),PSOR6(NSOMAX),DTHINC,DPHINC,NTHINC,
     &NPHINC,NSCINC,NSORC,ISORTP(NSOMAX)
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      DIMENSION T1X(MAXSEG),T1Y(MAXSEG),T1Z(MAXSEG),CURX(*)
      EQUIVALENCE (T1X,SI),(T1Y,ALP),(T1Z,BET)
      DATA CCJ/(0.D0,-0.01666666667D0)/
      IF (N.EQ.0) GO TO 6
      DO 1 I=1,N
      CURX(I)=CURX(I)/XKU
      AIX(I)=(0.,0.)
      BIX(I)=(0.,0.)
1     CIX(I)=(0.,0.)
      DO 2 I=1,N
      CURD=CURX(I)
      CALL TBF (I,1)
      DO 2 JX=1,JSNO
      J=JCO(JX)
      AIX(J)=AIX(J)+AX(JX)*CURD
      BIX(J)=BIX(J)+BX(JX)*CURD
2     CIX(J)=CIX(J)+CX(JX)*CURD
      IF(NSORC.GT.0)THEN
         DO 8 IS=1,NSORC
         IF(ISORTP(IS).NE.4)GO TO 8
         I=IROUND(PSOR1(IS))
         JX=ICON1(I)
         ICON1(I)=0
         CALL TBF (I,0)
         ICON1(I)=JX
         SH=SI(I)*.5
         VOLTS=DCMPLX(PSOR2(IS),PSOR3(IS))
         CURD=XKS(I)*SH
         CURD=CCJ*VOLTS/((LOG(2.*SH/BI(I))-1.)*(BX(JSNO)*COS(CURD)+
     &   CX(JSNO)*SIN(CURD)))
         DO 3 JX=1,JSNO
         J=JCO(JX)
         AIX(J)=AIX(J)+AX(JX)*CURD
         BIX(J)=BIX(J)+BX(JX)*CURD
3        CIX(J)=CIX(J)+CX(JX)*CURD
8        CONTINUE
      END IF
      DO 5 I=1,N
5     CURX(I)=AIX(I)
6     IF (M.EQ.0) RETURN
C     CONVERT SURFACE CURRENTS FROM T1,T2 COMPONENTS TO X,Y,Z COMPONENTS
      K=LD-M
      JCO1=N+2*M+1
      JCO2=JCO1+M
      DO 7 I=1,M
      K=K+1
      JCO1=JCO1-2
      JCO2=JCO2-3
      CS1=CURX(JCO1)
      CS2=CURX(JCO1+1)
      CURX(JCO2)=CS1*T1X(K)+CS2*T2X(K)
      CURX(JCO2+1)=CS1*T1Y(K)+CS2*T2Y(K)
7     CURX(JCO2+2)=CS1*T1Z(K)+CS2*T2Z(K)
      RETURN
      END
      SUBROUTINE GFLD (RHOO,PHIO,ZO,ETH,EPI,ERD)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     GFLD computes the distant field including surface wave.
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 ETH,EPI,ERD,AIX,BIX,CIX,CUR,XKS,XKU,XKL,ETAU,ETAL,
     &CEPSU,CEPSL,FRATI,ETAL2,XK,ERV,EZV,ERH,EPH,EZH,DIPM,EX,EY,EZ
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON/CRNT/AIX(MAXSEG),BIX(MAXSEG),CIX(MAXSEG),CUR(3*MAXSEG),
     &XKS(MAXSEG)
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      DIMENSION CAB(MAXSEG), SAB(MAXSEG)
      EQUIVALENCE (CAB,ALP), (SAB,BET)
      SFAC=GSCAL*GSCAL
      CPHO=COS(PHIO)
      SPHO=SIN(PHIO)
      XO=RHOO*CPHO
      YO=RHOO*SPHO
      EX=(0.,0.)
      EY=(0.,0.)
      EZ=(0.,0.)
      DO 5 I=1,N
      XK=XKU
      IF (Z(I).LT.0.) XK=XKL
      RHX=XO-X(I)
      RHY=YO-Y(I)
      RHS=RHX*RHX+RHY*RHY
      RHO=SQRT(RHS)
      IF (RHO.GT.0.) GO TO 1
      RHX=1.
      RHY=0.
      PHX=0.
      PHY=1.
      GO TO 2
1     RHX=RHX/RHO
      RHY=RHY/RHO
      PHX=-RHY
      PHY=RHX
2     SN=SQRT(CAB(I)*CAB(I)+SAB(I)*SAB(I))
      IF (SN.LT.1.E-5) GO TO 3
      XSN=CAB(I)/SN
      YSN=SAB(I)/SN
      GO TO 4
3     SN=0.
      XSN=1.
      YSN=0.
4     CPH=RHX*XSN+RHY*YSN
      SPH=RHY*XSN-RHX*YSN
      IF (ABS(CPH).LT.1.E-10) CPH=0.
      IF (ABS(SPH).LT.1.E-10) SPH=0.
      RHOS=RHO*GSCAL
      ZTS=Z(I)*GSCAL
      ZOS=ZO*GSCAL
      CALL GNDEF (RHOS,ZTS,ZOS,-1,ERV,EZV,ERH,EPH,EZH)
      ERH=(ERH*SN*CPH+ERV*SALP(I))*SFAC
      EPH=EPH*SN*SPH*SFAC
      EZH=(EZH*SN*CPH+EZV*SALP(I))*SFAC
      DIPM=AIX(I)*SI(I)+CIX(I)*(2.*SIN(XK*SI(I)*.5)/XK-SI(I))
      EX=EX+(ERH*RHX+EPH*PHX)*DIPM
      EY=EY+(ERH*RHY+EPH*PHY)*DIPM
      EZ=EZ+EZH*DIPM
5     CONTINUE
      STHO=SQRT(RHOO*RHOO+ZO*ZO)
      CTHO=ZO/STHO
      STHO=RHOO/STHO
      RNX=STHO*CPHO
      RNY=STHO*SPHO
      RNZ=CTHO
      THX=CTHO*CPHO
      THY=CTHO*SPHO
      THZ=-STHO
      PHX=-SPHO
      PHY=CPHO
      ETH=EX*THX+EY*THY+EZ*THZ
      EPI=EX*PHX+EY*PHY
      ERD=EX*RNX+EY*RNY+EZ*RNZ
      RETURN
      END
      SUBROUTINE JNQSET
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     JNQSET sets the proportionality constants for the linear charge
C     density on each end of each segment.
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,FRATI,ETAL2,QSEGE1,
     &QSEGE2,QJRATI,XK
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      COMMON/JNQCOM/QSEGE1(MAXSEG),QSEGE2(MAXSEG),IPQEND(MAXSEG)
      COMMON/SETJN/ISETJN
      DIMENSION JNCSEG(NSJMAX),JNCEND(NSJMAX),QJRATI(NSJMAX)
      ICHEK=1
      IF(KSYMP.EQ.2)ICHEK=2
      DO 1 ISEG=1,N
      IPQEND(ISEG)=0
      QSEGE1(ISEG)=(0.,0.)
1     QSEGE2(ISEG)=(0.,0.)
      DO 6 ISEG=1,N
      DO 2 IEND=1,2
      IF(IEND.EQ.1)THEN
         IF(DREAL(QSEGE1(ISEG)).NE.0.)GO TO 2
         IENDX=-1
      ELSE
         IF(DREAL(QSEGE2(ISEG)).NE.0.)GO TO 2
         IENDX=1
      END IF
C
C     FIND SEGMENTS CONNECTED TO END IENDX OF SEGMENT ISEG
C
      CALL JNFIND(ISEG,IENDX,ICHEK,JNCSEG,JNCEND,JNCNO,IRADX,IGNDX,
     &IGNDC,IPATC)
C
C     INCLUDE SEGMENT ISEG
C
      JNCNO=JNCNO+1
      JNCSEG(JNCNO)=ISEG
      JNCEND(JNCNO)=IENDX
      IF(IGNDX.NE.0)THEN
C
C     SET CHARGE RATIO FOR A JUNCTION CROSSING FROM AIR INTO GROUND
C
         DO 3 J=1,JNCNO
         JSEG=JNCSEG(J)
         IF(JNCEND(J).GT.0)THEN
            IPQEND(JSEG)=IPQEND(JSEG)+2
            IF(Z(JSEG).GE.0.)THEN
               QSEGE2(JSEG)=XKU
            ELSE
               QSEGE2(JSEG)=XKL
            END IF
         ELSE
            IPQEND(JSEG)=IPQEND(JSEG)+1
            IF(Z(JSEG).GT.0)THEN
               QSEGE1(JSEG)=XKU
            ELSE
               QSEGE1(JSEG)=XKL
            END IF
         END IF
3        CONTINUE
      ELSE IF(IRADX.NE.0.OR.JNCNO.GT.2)THEN
C
C     SET CHARGE RATIO FOR A JUNCTION WITH A CHANGE IN WIRE RADIUS OR
C     A MULTIPLE WIRE JUNCTION
C
         JSEG=JNCSEG(1)
         XK=XKU
         IF(Z(JSEG).LT.0.)XK=XKL
         CALL QSOLVE(JNCNO,JNCSEG,JNCEND,XK,QJRATI)
         DO 4 J=1,JNCNO
         JSEG=JNCSEG(J)
         IF(JNCEND(J).GT.0)THEN
            IF(ISETJN.EQ.1)THEN
               QSEGE2(JSEG)=DREAL(QJRATI(J))
            ELSE
               QSEGE2(JSEG)=1./(LOG(2./(XK*BI(JSEG)))-.577215664)
            END IF
         ELSE
            IF(ISETJN.EQ.1)THEN
               QSEGE1(JSEG)=DREAL(QJRATI(J))
            ELSE
               QSEGE1(JSEG)=1./(LOG(2./(XK*BI(JSEG)))-.577215664)
            END IF
         END IF
4        CONTINUE
      ELSE
C
C     SET CHARGE RATIO FOR A CONTINUOUS WIRE JUNCTION
C
         DO 5 J=1,JNCNO
         JSEG=JNCSEG(J)
         IF(JNCEND(J).GT.0)THEN
            QSEGE2(JSEG)=1.
         ELSE
            QSEGE1(JSEG)=1.
         END IF
5        CONTINUE
      END IF
2     CONTINUE
6     CONTINUE
      RETURN
      END
      SUBROUTINE JNFIND(JXSEG,JXEND,ICHEK,JNCSEG,JNCEND,JNCNO,IRADX,
     &IGNDX,IGNDC,IPATC)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     JNFIND locates all segments connected to a given segment and
C     determines the conditions at the junction.
C
C     INPUT:
C     JXSEG = NUMBER OF THE SEGMENT TO WHICH CONNECTIONS ARE NEEDED
C     JXEND = -1 TO FIND CONNECTIONS TO (-) END OF SEGMENT JXSEG
C             +1 TO FIND CONNECTIONS TO (+) END OF SEGMENT JXSEG
C     ICHEK = 1 TO CHECK FOR JUNCTIONS CROSSING THE AIR-GROUND INTERFACE
C
C     OUTPUT:
C     JNCSEG(I) = NUMBER OF THE I TH SEGMENT CONNECTING TO SEGMENT JXSEG
C     JNCEND(I) = -1 IF (-) END OF SEGMENT JNCSEG(I) CONNECTS TO JXSEG
C                 +1 IF (+) END OF SEGMENT JNCSEG(I) CONNECTS TO JXSEG
C     JNCNO = NUMBER OF SEGMENTS CONNECTING TO SEGMENT JXSEG
C     IRADX = 1 IF A RADIUS CHANGE OCCURS AT THE JUNCTION, = 0 OTHERWISE
C     IGNDX = 1 IF THE JUNCTION INCLUDES SEGMENTS ON BOTH SIDES OF AN
C             AIR-GROUND INTERFACE, = 0 OTHERWISE
C     IGNDC = 1 IF SEG. JXSEG CONNECTS TO A GROUND PLANE, = 0 OTHERWISE
C     IPATC = 1 IF SEGMENT JXSEG CONNECTS TO A PATCH, = 0 OTHERWISE
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      DIMENSION JNCSEG(NSJMAX),JNCEND(NSJMAX)
      JSEG=JXSEG
      JEND=JXEND
      IRADX=0
      IGNDX=0
      IGNDC=0
      IPATC=0
      JNCNO=0
      RADSEG=BI(JXSEG)
      ZSEG=Z(JXSEG)
1     IF(JEND.LT.0)THEN
         ICON=ICON1(JSEG)
      ELSE
         ICON=ICON2(JSEG)
      END IF
      JSEG=IABS(ICON)
      IF(ICON.GT.0)JEND=-JEND
      IF(JSEG.EQ.JXSEG)THEN
         IF(JNCNO.EQ.0)IGNDC=1
         GO TO 2
      ELSE IF(JSEG.EQ.0)THEN
         GO TO 2
C
C     SEGMENT CONNECTION TO A SURFACE PATCH
C
      ELSE IF(JSEG.GT.30000)THEN
         IF(JNCNO.GT.0)THEN
            WRITE(3,90)JXEND,JXSEG
            STOP
         END IF
         IPATC=1
         GO TO 2
      END IF
C
C     ENTER CONNECTED SEGMENT IN ARRAY JNCSEG
C
      JNCNO=JNCNO+1
      IF(JNCNO.GE.NSJMAX)THEN
         WRITE(3,91)JXEND,JXSEG,NSJMAX
         STOP
      END IF
      JNCSEG(JNCNO)=JSEG
      JNCEND(JNCNO)=JEND
      IF(ICHEK.NE.0)THEN
         IF(ABS(BI(JSEG)-RADSEG).GT.0.01*RADSEG)IRADX=1
      END IF
      IF(ICHEK.GT.1)THEN
         IF(Z(JSEG)*ZSEG.LT.0.)IGNDX=1
      END IF
      GO TO 1
2     RETURN
C
90    FORMAT(' JNFIND: ERROR AT',I3,' END OF SEGMENT',I5,/,
     &' MULTIPLE WIRE JUNCTION AT CONNECTION TO SURFACE PATCH IS NOT',
     &' ALLOWED')
91    FORMAT(' JNFIND: ERROR AT',I3,' END OF SEGMENT',I5,/,
     &' NUMBER OF CONNECTED SEGMENTS EXCEEDS LIMIT OF', I4)
      END
      SUBROUTINE TBF(I,ICAP)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     TBF computes the basis function associated with segment I. The
C     components of basis function I are stored in COMMON /SEGJ/.  The
C     component of basis function I that extends onto segment J is
C     AX(L)+BX(L)*SIN(K*S)+CX(L)*(COS(K*S)-1.) where JCO(L)=J and S is
C     measured from the center of segment J.  L runs from 1 through JSNO
C     where JSNO is the number of segments in the support of the basis
C     function.
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 AX,BX,CX,XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,FRATI,ETAL2,
     &AIX,BIX,CIX,CUR,XKS,XK,D,CDH,SDH,CD,SD,OMC,AJ,AP,PP,PM,QP,QM,DEN,
     &TERM,DSQ,XXI,QSEGE1,QSEGE2
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON /SEGJ/ AX(NSJMAX),BX(NSJMAX),CX(NSJMAX),JCO(NSJMAX),JSNO,
     &ISCON(NSCNGF),NSCON,IPCON(NSPNGF),NPCON
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      COMMON/CRNT/AIX(MAXSEG),BIX(MAXSEG),CIX(MAXSEG),CUR(3*MAXSEG),
     &XKS(MAXSEG)
      COMMON/JNQCOM/QSEGE1(MAXSEG),QSEGE2(MAXSEG),IPQEND(MAXSEG)
      DIMENSION JNCEND(NSJMAX)
      DATA ALIM/.08D0/
      IMAGE1=0
      IMAGE2=0
      CALL JNFIND(I,-1,0,JCO,JNCEND,NJUN1,IRX,IGX,IGC1,IPC1)
      IF(IPC1.NE.0.OR.IGC1.NE.0)THEN
         NJUN1=1
         JCO(1)=I
         JNCEND(1)=-1
         IMAGE1=1
      END IF
      NJNXT=NJUN1+1
      CALL JNFIND(I,1,0,JCO(NJNXT),JNCEND(NJNXT),NJUN2,IRX,IGX,IGC2,
     &IPC2)
      IF(IPC2.NE.0.OR.IGC2.NE.0)THEN
         NJUN2=1
         JCO(NJNXT)=I
         JNCEND(NJNXT)=1
         IMAGE2=1
      END IF
      JSNO=NJUN1+NJUN2+1
      JCO(JSNO)=I
C
C     EVALUATE A,B,C FOR SEGMENTS CONNECTED TO -1 END OF SEGMENT J
C
      PM=(0.,0.)
      IF(NJUN1.EQ.0)GO TO 2
      DO 1 JNO=1,NJUN1
      JCOX=JCO(JNO)
      XK=XKS(JCOX)
      IF(JNCEND(JNO).LT.0)THEN
         AJ=QSEGE1(JCOX)
      ELSE
         AJ=QSEGE2(JCOX)
      END IF
      D=.5*XK*SI(JCOX)
      SDH=SIN(D)
      CDH=COS(D)
      IF (ABS(D).GT.ALIM)THEN
         AX(JNO)=AJ*(.5/CDH-.5)/SDH
      ELSE
         AX(JNO)=AJ*.25*D*(1.+.58333333333*D*D)
      END IF
      BX(JNO)=AJ/(2.*CDH)
      CX(JNO)=-AJ/(2.*SDH)
      PM=PM+SDH/CDH*AJ
      IF(JNCEND(JNO).LT.0.AND.IMAGE1.EQ.0)THEN
         AX(JNO)=-AX(JNO)
         CX(JNO)=-CX(JNO)
      END IF
1     CONTINUE
      IF(IMAGE1.NE.0)BX(NJUN1)=-BX(NJUN1)
C
C     EVALUATE A,B,C FOR SEGMENTS CONNECTED TO +1 END OF SEGMENT J
C
2     PP=(0.,0.)
      IF(NJUN2.EQ.0)GO TO 4
      DO 3 JNO=1,NJUN2
      JNOP=JNO+NJUN1
      JCOX=JCO(JNOP)
      XK=XKS(JCOX)
      IF(JNCEND(JNOP).LT.0)THEN
         AJ=QSEGE1(JCOX)
      ELSE
         AJ=QSEGE2(JCOX)
      END IF
      D=.5*XK*SI(JCOX)
      SDH=SIN(D)
      CDH=COS(D)
      IF (ABS(D).GT.ALIM)THEN
         AX(JNOP)=-AJ*(.5/CDH-.5)/SDH
      ELSE
         AX(JNOP)=-AJ*.25*D*(1.+.58333333333*D*D)
      END IF
      BX(JNOP)=AJ/(2.*CDH)
      CX(JNOP)=AJ/(2.*SDH)
      PP=PP-SDH/CDH*AJ
      IF(JNCEND(JNOP).GT.0.AND.IMAGE2.EQ.0)THEN
         AX(JNOP)=-AX(JNOP)
         CX(JNOP)=-CX(JNOP)
      END IF
3     CONTINUE
      IF(IMAGE2.NE.0)BX(JNOP)=-BX(JNOP)
4     XK=XKS(I)
      D=.5*XK*SI(I)
      DSQ=D*D
      SDH=SIN(D)
      CDH=COS(D)
      SD=2.*SDH*CDH
      CD=CDH*CDH-SDH*SDH
      OMC=2.*SDH*SDH
      AJ=QSEGE1(I)
      AP=QSEGE2(I)
      IF(NJUN1.GT.0.AND.NJUN2.GT.0)THEN
         DEN=SD*(PM*PP+AJ*AP)+CD*(PM*AP-PP*AJ)
         QM=(AP*OMC-PP*SD)/DEN
         QP=-(AJ*OMC+PM*SD)/DEN
         BX(JSNO)=(AJ*QM+AP*QP)*SDH/SD
         CX(JSNO)=(AJ*QM-AP*QP)*CDH/SD
         IF(ABS(D).GT.ALIM)THEN
            AX(JSNO)=CX(JSNO)-1.
         ELSE
            TERM=-(PM/D)*(PP/D)*SD+AJ*AP*D*(1.-.25*DSQ)
            AX(JSNO)=(TERM+(PM*AP-PP*AJ)*(1.5-.625*DSQ))/DEN*DSQ
         END IF
         DO 17 IEND=1,NJUN1
         AX(IEND)=AX(IEND)*QM
         BX(IEND)=BX(IEND)*QM
17       CX(IEND)=CX(IEND)*QM
         JUNS=NJUN1+1
         JUNE=NJUN1+NJUN2
         DO 18 IEND=JUNS,JUNE
         AX(IEND)=AX(IEND)*QP
         BX(IEND)=BX(IEND)*QP
18       CX(IEND)=CX(IEND)*QP
      ELSE IF(NJUN2.GT.0)THEN
         IF(ICAP.EQ.0)THEN
            XXI=(0.,0.)
         ELSE
            XXI=.5*XK*BI(I)
         END IF
         QP=-(OMC+XXI*SD)/(SD*(AP+XXI*PP)+CD*(XXI*AP-PP))
         DEN=CD-XXI*SD
         BX(JSNO)=(SDH+AP*QP*(CDH-XXI*SDH))/DEN
         CX(JSNO)=(CDH+AP*QP*(SDH+XXI*CDH))/DEN
         IF(ABS(D).GT.ALIM)THEN
            AX(JSNO)=CX(JSNO)-1.
         ELSE
            AX(JSNO)=(DSQ*(1.5-.625*DSQ)+XXI*SD+AP*QP*(SDH+XXI*CDH))
     &      /DEN
         END IF
         DO 22 IEND=1,NJUN2
         AX(IEND)=AX(IEND)*QP
         BX(IEND)=BX(IEND)*QP
22       CX(IEND)=CX(IEND)*QP
      ELSE IF(NJUN1.GT.0)THEN
         IF(ICAP.EQ.0)THEN
            XXI=(0.,0.)
         ELSE
            XXI=.5*XK*BI(I)
         END IF
         QM=(OMC+XXI*SD)/(SD*(AJ-XXI*PM)+CD*(PM+XXI*AJ))
         DEN=CD-XXI*SD
         BX(JSNO)=(AJ*QM*(CDH-XXI*SDH)-SDH)/DEN
         CX(JSNO)=(CDH-AJ*QM*(SDH+XXI*CDH))/DEN
         IF(ABS(D).GT.ALIM)THEN
            AX(JSNO)=CX(JSNO)-1.
         ELSE
            AX(JSNO)=(DSQ*(1.5-.625*DSQ)+XXI*SD-AJ*QM*(SDH+XXI*CDH))/DEN
         END IF
         DO 26 IEND=1,NJUN1
         AX(IEND)=AX(IEND)*QM
         BX(IEND)=BX(IEND)*QM
26       CX(IEND)=CX(IEND)*QM
      ELSE
         BX(JSNO)=(0.,0.)
         IF(ICAP.EQ.0)THEN
            XXI=(0.,0.)
         ELSE
            XXI=.5*XK*BI(I)
         END IF
         CX(JSNO)=1./(CDH-XXI*SDH)
         IF(ABS(D).GT.ALIM)THEN
            AX(JSNO)=CX(JSNO)-1.
         ELSE
            AX(JSNO)=(DSQ*(.5-.04166666667*DSQ)+XXI*SDH)*CX(JSNO)
         END IF
      END IF
      RETURN
      END
      SUBROUTINE TRIO (JSEG)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     TRIO computes the components of all basis functions on segment
C     JSEG.
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 AX,BX,CX
      COMMON /SEGJ/ AX(NSJMAX),BX(NSJMAX),CX(NSJMAX),JCO(NSJMAX),JSNO,
     &ISCON(NSCNGF),NSCON,IPCON(NSPNGF),NPCON
      DIMENSION JNCEND(NSJMAX)
      CALL JNFIND(JSEG,-1,0,JCO,JNCEND,NJUN1,IRX,IGX,IGC1,IPC1)
      NJNXT=NJUN1+1
      CALL JNFIND(JSEG,1,0,JCO(NJNXT),JNCEND(NJNXT),NJUN2,IRX,IGX,IGC2,
     &IPC2)
      JSNO=NJUN1+NJUN2+1
      JCO(JSNO)=JSEG
      DO 1 JBNO=1,JSNO
      JBAS=JCO(JBNO)
1     CALL SBF(JBAS,JSEG,AX(JBNO),BX(JBNO),CX(JBNO))
      RETURN
      END
      SUBROUTINE SBF(IBAS,ISEG,AA,BB,CC)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     SBF computes the component of basis function IBAS that extends
C     onto segment ISEG.
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 AA,BB,CC,XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,
     &AIX,BIX,CIX,CUR,XKS,XK,D,CDH,SDH,CD,SD,OMC,AJ,AP,PP,PM,QP,QM,DEN,
     &TERM,DSQ,CCX,XXI,QSEGE1,QSEGE2
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      COMMON/CRNT/AIX(MAXSEG),BIX(MAXSEG),CIX(MAXSEG),CUR(3*MAXSEG),
     &XKS(MAXSEG)
      COMMON/JNQCOM/QSEGE1(MAXSEG),QSEGE2(MAXSEG),IPQEND(MAXSEG)
      DIMENSION JNCSEG(NSJMAX),JNCEND(NSJMAX)
      DATA ALIM/.08D0/
      IMAGE1=0
      IMAGE2=0
      CALL JNFIND(IBAS,-1,0,JNCSEG,JNCEND,NJUN1,IRX,IGX,IGC1,IPC1)
      IF(IPC1.NE.0.OR.IGC1.NE.0)THEN
         NJUN1=1
         JNCSEG(1)=IBAS
         JNCEND(1)=-1
         IMAGE1=1
      END IF
      NJNXT=NJUN1+1
      CALL JNFIND(IBAS,1,0,JNCSEG(NJNXT),JNCEND(NJNXT),NJUN2,IRX,IGX,
     &IGC2,IPC2)
      IF(IPC2.NE.0.OR.IGC2.NE.0)THEN
         NJUN2=1
         JNCSEG(NJNXT)=IBAS
         JNCEND(NJNXT)=1
         IMAGE2=1
      END IF
      JSNO=NJUN1+NJUN2+1
      JNCSEG(JSNO)=IBAS
C
C     EVALUATE A,B,C FOR SEGMENTS CONNECTED TO -1 END OF SEGMENT J
C
      AA=(0.,0.)
      BB=(0.,0.)
      CC=(0.,0.)
      JUNE=0
      PM=(0.,0.)
      IF(NJUN1.EQ.0)GO TO 2
      DO 1 JNO=1,NJUN1
      JCOX=JNCSEG(JNO)
      XK=XKS(JCOX)
      IF(JNCEND(JNO).LT.0)THEN
         AJ=QSEGE1(JCOX)
      ELSE
         AJ=QSEGE2(JCOX)
      END IF
      D=.5*XK*SI(JCOX)
      SDH=SIN(D)
      CDH=COS(D)
      PM=PM+SDH/CDH*AJ
      IF(JCOX.EQ.ISEG)THEN
         JUNE=-1
         IF (ABS(D).GT.ALIM)THEN
            AA=AJ*(.5/CDH-.5)/SDH
         ELSE
            AA=AJ*.25*D*(1.+.58333333333*D*D)
         END IF
         BB=AJ/(2.*CDH)
         CC=-AJ/(2.*SDH)
         IF(JNCEND(JNO).LT.0.AND.IMAGE1.EQ.0)THEN
            AA=-AA
            CC=-CC
         END IF
         IF(IMAGE1.NE.0)BB=-BB
      END IF
1     CONTINUE
C
C     EVALUATE A,B,C FOR SEGMENTS CONNECTED TO +1 END OF SEGMENT J
C
2     PP=(0.,0.)
      IF(NJUN2.EQ.0)GO TO 4
      DO 3 JNO=1,NJUN2
      JNOP=JNO+NJUN1
      JCOX=JNCSEG(JNOP)
      XK=XKS(JCOX)
      IF(JNCEND(JNOP).LT.0)THEN
         AJ=QSEGE1(JCOX)
      ELSE
         AJ=QSEGE2(JCOX)
      END IF
      D=.5*XK*SI(JCOX)
      SDH=SIN(D)
      CDH=COS(D)
      PP=PP-SDH/CDH*AJ
      IF(JCOX.EQ.ISEG)THEN
         JUNE=1
         IF (ABS(D).GT.ALIM)THEN
            AA=-AJ*(.5/CDH-.5)/SDH
         ELSE
            AA=-AJ*.25*D*(1.+.58333333333*D*D)
         END IF
         BB=AJ/(2.*CDH)
         CC=AJ/(2.*SDH)
         IF(JNCEND(JNOP).GT.0.AND.IMAGE2.EQ.0)THEN
            AA=-AA
            CC=-CC
         END IF
         IF(IMAGE2.NE.0)BB=-BB
      END IF
3     CONTINUE
4     XK=XKS(IBAS)
      D=.5*XK*SI(IBAS)
      DSQ=D*D
      SDH=SIN(D)
      CDH=COS(D)
      SD=2.*SDH*CDH
      CD=CDH*CDH-SDH*SDH
      OMC=2.*SDH*SDH
      AJ=QSEGE1(IBAS)
      AP=QSEGE2(IBAS)
      IF(NJUN1.GT.0.AND.NJUN2.GT.0)THEN
         DEN=SD*(PM*PP+AJ*AP)+CD*(PM*AP-PP*AJ)
         QM=(AP*OMC-PP*SD)/DEN
         QP=-(AJ*OMC+PM*SD)/DEN
         IF(JUNE.EQ.-1)THEN
            AA=AA*QM
            BB=BB*QM
            CC=CC*QM
         ELSE IF(JUNE.EQ.1)THEN
            AA=AA*QP
            BB=BB*QP
            CC=CC*QP
         END IF
         IF(IBAS.NE.ISEG)RETURN
         BB=BB+(AJ*QM+AP*QP)*SDH/SD
         CCX=(AJ*QM-AP*QP)*CDH/SD
         CC=CC+CCX
         IF(ABS(D).GT.ALIM)THEN
            AA=AA+CCX-1.
         ELSE
            TERM=-(PM/D)*(PP/D)*SD+AJ*AP*D*(1.-.25*DSQ)
            AA=AA+(TERM+(PM*AP-PP*AJ)*(1.5-.625*DSQ))/DEN*DSQ
         END IF
         RETURN
      ELSE IF(NJUN2.GT.0)THEN
         XXI=.5*XK*BI(IBAS)
         QP=-(OMC+XXI*SD)/(SD*(AP+XXI*PP)+CD*(XXI*AP-PP))
         IF(JUNE.EQ.1)THEN
            AA=AA*QP
            BB=BB*QP
            CC=CC*QP
         END IF
         IF(IBAS.NE.ISEG)RETURN
         DEN=CD-XXI*SD
         BB=BB+(SDH+AP*QP*(CDH-XXI*SDH))/DEN
         CCX=(CDH+AP*QP*(SDH+XXI*CDH))/DEN
         CC=CC+CCX
         IF(ABS(D).GT.ALIM)THEN
            AA=AA+CCX-1.
         ELSE
            AA=AA+(DSQ*(1.5-.625*DSQ)+XXI*SD+AP*QP*(SDH+XXI*CDH))/DEN
         END IF
         RETURN
      ELSE IF(NJUN1.GT.0)THEN
         XXI=.5*XK*BI(IBAS)
         QM=(OMC+XXI*SD)/(SD*(AJ-XXI*PM)+CD*(PM+XXI*AJ))
         IF(JUNE.EQ.-1)THEN
            AA=AA*QM
            BB=BB*QM
            CC=CC*QM
         END IF
         IF(IBAS.NE.ISEG)RETURN
         DEN=CD-XXI*SD
         BB=BB+(AJ*QM*(CDH-XXI*SDH)-SDH)/DEN
         CC=CC+(CDH-AJ*QM*(SDH+XXI*CDH))/DEN
         IF(ABS(D).GT.ALIM)THEN
            AA=CC-1.
         ELSE
            AA=(DSQ*(1.5-.625*DSQ)+XXI*SD-AJ*QM*(SDH+XXI*CDH))/DEN
         END IF
         RETURN
      ELSE
         XXI=.5*XK*BI(IBAS)
         CC=1./(CDH-XXI*SDH)
         IF(ABS(D).GT.ALIM)THEN
            AA=CC-1.
         ELSE
            AA=(DSQ*(.5-.04166666667*DSQ)+XXI*SDH)*CC
         END IF
      END IF
      RETURN
      END
      SUBROUTINE QSOLVE(NJWIRE,JNCSEG,JNCEND,XK,QJRATI)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     QSOLVE controls the solution for the charge distribution at a
C     junction to produce a continuous scalar potential.
C
C     INPUT:
C     NJWIRE = NUMBER OF WIRES AT THE JUNCTION
C     JNCSEG(I) = NEC SEGMENT NUMBER FOR THE I'TH WIRE
C     JNCEND(I) = -1 IF MINUS END OF SEGMENT IS CONNECTED TO JUNCTION
C                 +1 IF PLUS END OF SEGMENT IS CONNECTED TO JUNCTION
C
C     OUTPUT:
C     QJRATI(I) = RELATIVE CHARGE DENSITY ON WIRE I AT THE JUNCTION
C
C     NSEGPW = NUMBER OF SEGMENTS TO BE USED IN THE SOLUTION FOR EACH
C              WIRE
C
      INCLUDE 'NECPAR.INC'
      PARAMETER(NSEGPW=3,JNDIM=NSEGPW*NSJMAX)
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 XK,QJRATI(*),PMATX,RHS
      DIMENSION JNCSEG(*),JNCEND(*),PMATX(JNDIM,JNDIM),RHS(JNDIM),
     &IP(JNDIM)
      NTOT=NJWIRE*NSEGPW
      CALL QMFIL(NJWIRE,NSEGPW,JNCSEG,JNCEND,XK,PMATX,RHS,JNDIM,SLENA)
      CALL FACTR (NTOT,PMATX,IP,JNDIM)
      CALL SOLVE (NTOT,PMATX,IP,RHS,JNDIM)
      CALL QJRATV(NJWIRE,NSEGPW,JNCSEG,SLENA,RHS,QJRATI)
      RETURN
      END
      SUBROUTINE QJRATV(NJWIRE,NSEGPW,JNCSEG,SLENA,RHS,QJRATI)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     QJRATV determines the relative charge densities on each wire at
C     a junction from the solution for continuity of scalar potential.
C     The charge density at the junction end of each wire is the sum of
C     half-triangle basis function a the junction and the semi-infinite
C     basis function on that wire.
C
C     INPUT:
C     NJWIRE = NUMBER OF WIRES AT THE JUNCTION
C     NSEGPW = NUMBER OF SEGMENTS TO BE USED IN THE SOLUTION FOR EACH
C              WIRE
C     JNCSEG(I) = NEC SEGMENT NUMBER FOR THE I'TH WIRE
C     SLENA = AVERAGE LENGTH OF SEGMENTS AT THE JUNCTION
C     RHS(I) = AMPLITUDE OF CHARGE BASIS FUNCTION NUMBER I
C
C     OUTPUT:
C     QJRATI(I) = RELATIVE CHARGE DENSITY ON WIRE I AT THE JUNCTION
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 RHS,QJRATI,QVAL,QNORM
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      DIMENSION JNCSEG(*),RHS(*),QJRATI(*)
      IJNC=1
      DO 1 IW=1,NJWIRE
      IF(IW.GT.1)IJNC=IJNC+NSEGPW
      ISEG=JNCSEG(IW)
      IF(NJWIRE.GT.2)THEN
         SVAL=.5*SI(ISEG)
         IF(SVAL.LT.BI(ISEG))SVAL=BI(ISEG)
         IF(SVAL.GT.SLENA)SVAL=SLENA
         QVAL=(SLENA-SVAL)*RHS(IJNC)+RHS(IJNC-1+NSEGPW)*SLENA
         IF(NSEGPW.GT.2)QVAL=QVAL+SVAL*RHS(IJNC+1)
      ELSE
         QVAL=(RHS(IJNC)+RHS(IJNC-1+NSEGPW))*SLENA
      END IF
      IF(IW.EQ.1)THEN
         QNORM=QVAL
         QJRATI(1)=1.
      ELSE
         QJRATI(IW)=QVAL/QNORM
      END IF
1     CONTINUE
      RETURN
      END
      SUBROUTINE QMFIL(NJWIRE,NSEGPW,JNCSEG,JNCEND,XK,PMATX,RHS,JNDIM,
     &SLENI)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     QMFIL fills the scalar potential interaction matrix for triangular
C     charge basis functions.
C
C     INPUT:
C     NJWIRE = NUMBER OF WIRES AT THE JUNCTION
C     NSEGPW = NUMBER OF SEGMENTS TO BE USED IN THE SOLUTION FOR EACH
C              WIRE
C     JNCSEG(I) = NEC SEGMENT NUMBER FOR THE I'TH WIRE
C     JNCEND(I) = -1 IF MINUS END OF SEGMENT IS CONNECTED TO JUNCTION
C                 +1 IF PLUS END OF SEGMENT IS CONNECTED TO JUNCTION
C     XK = WAVE NUMBER IN THE MEDIUM CONTAINING THE WIRES
C     JNDIM = DIMENSIONED SIZE OF ARRAY PMATX
C
C     OUTPUT:
C     PMATX(J,I) = INTERACTION MATRIX; POTENTIAL AT MATCH POINT I DUE
C                  TO BASIS FUNCTION J
C     RHS(I) = RIGHT HAND SIDE VECTOR FOR THE MATRIX EQUATION
C     SLENI = AVERAGE LENGTH OF SEGMENTS AT THE JUNCTION
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 XK,PMATX,RHS,SPP,SPM,SEMINF
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      DIMENSION CAB(MAXSEG),SAB(MAXSEG),JNCSEG(*),JNCEND(*),
     &   PMATX(JNDIM,JNDIM),RHS(JNDIM)
      EQUIVALENCE (CAB,ALP),(SAB,BET)
      NTOT=NJWIRE*NSEGPW
      DO 2 IW=1,NTOT
      RHS(IW)=1.
      DO 2 JW=1,NTOT
2     PMATX(IW,JW)=(0.,0.)
C
C     Use average segment length and adjust length and radius to avoid
C     instabilities in the thin-wire solution for charge.
C
      SLENI=0.
      BIMAX=0.
      DO 1 IW=1,NJWIRE
         ISEG=JNCSEG(IW)
         SLENI=SLENI+SI(ISEG)
         IF(BI(ISEG).GT.BIMAX)BIMAX=BI(ISEG)
1     CONTINUE
      SLENI=SLENI/NJWIRE
      IF(NJWIRE.GT.2)THEN
         BIFAC=.0628318/(ABS(XK)*BIMAX*NJWIRE)
         IF(BIFAC.GT.1.)BIFAC=1.
      ELSE
         BIFAC=1.
      END IF
      IF(SLENI.LT.BIMAX*BIFAC)SLENI=BIMAX*BIFAC
      SLENJ=SLENI
      IEQ=0
C
C     Evaluation point loop
C
      DO 5 IW=1,NJWIRE
      ISEG=JNCSEG(IW)
      XIDIR=CAB(ISEG)
      YIDIR=SAB(ISEG)
      ZIDIR=SALP(ISEG)
      IF(JNCEND(IW).GT.0)THEN
         XIDIR=-XIDIR
         YIDIR=-YIDIR
         ZIDIR=-ZIDIR
      END IF
      SLEND=.5*(SLENI-SI(ISEG))
      XI=X(ISEG)+SLEND*XIDIR
      YI=Y(ISEG)+SLEND*YIDIR
      ZI=Z(ISEG)+SLEND*ZIDIR
      DO 5 IS=1,NSEGPW
      IEQ=IEQ+1
      IF(IS.EQ.2)THEN
         XI=XI+XIDIR*SLENI*.5
         YI=YI+YIDIR*SLENI*.5
         ZI=ZI+ZIDIR*SLENI*.5
      ELSE IF(IS.GT.2)THEN
         XI=XI+XIDIR*SLENI
         YI=YI+YIDIR*SLENI
         ZI=ZI+ZIDIR*SLENI
      END IF
C
C     SOURCE SEGMENT LOOP
C
      JEQ=0
      DO 4 JW=1,NJWIRE
      JSEG=JNCSEG(JW)
      XJDIR=CAB(JSEG)
      YJDIR=SAB(JSEG)
      ZJDIR=SALP(JSEG)
      IF(JNCEND(JW).GT.0)THEN
         XJDIR=-XJDIR
         YJDIR=-YJDIR
         ZJDIR=-ZJDIR
      END IF
      ARADJ=BI(JSEG)*BIFAC
      SLEND=.5*(SLENJ-SI(JSEG))
      XJ=X(JSEG)+SLEND*XJDIR
      YJ=Y(JSEG)+SLEND*YJDIR
      ZJ=Z(JSEG)+SLEND*ZJDIR
      XJEND=XJ-XJDIR*SLENJ*.5
      YJEND=YJ-YJDIR*SLENJ*.5
      ZJEND=ZJ-ZJDIR*SLENJ*.5
      NSPWM=NSEGPW-1
      DO 3 JS=1,NSEGPW
      JEQ=JEQ+1
      IF(JS.LT.NSEGPW)THEN
         IF(JS.GT.1)THEN
            XJ=XJ+XJDIR*SLENJ
            YJ=YJ+YJDIR*SLENJ
            ZJ=ZJ+ZJDIR*SLENJ
         END IF
         CALL SCAPOT(XI,YI,ZI,XJ,YJ,ZJ,SLENJ,ARADJ,XJDIR,YJDIR,ZJDIR,
     &   XK,SPP,SPM)
         PMATX(JEQ,IEQ)=PMATX(JEQ,IEQ)+SPM
         IF(JS.LT.NSPWM)PMATX(JEQ+1,IEQ)=PMATX(JEQ+1,IEQ)+SPP
      ELSE
         CALL SCAPOX(XI,YI,ZI,XJEND,YJEND,ZJEND,ARADJ,XJDIR,YJDIR,ZJDIR,
     &   XK,SEMINF)
         PMATX(JEQ,IEQ)=SEMINF*SLENJ
      END IF
3     CONTINUE
4     CONTINUE
5     CONTINUE
      RETURN
      END
      SUBROUTINE SCAPOT(XI,YI,ZI,XJ,YJ,ZJ,SLENJ,ARADJ,XJDIR,YJDIR,ZJDIR,
     &XK,SPP,SPM)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     SCAPOT evaluates the integral for scalar potential due to charge
C     on a wire segment.  The factor 1/(4*PI*EPSILON) has been omitted
C     since only relative values in a medium with constant permittivity
C     are needed.
C
C     INPUT:
C     XI,YI,ZI = COORDINATES OF THE EVALUATION POINT
C     XJ,YJ,ZJ = COORDINATES OF THE CENTER OF THE SEGMENT
C     ARADJ = RADIUS OF THE WIRE
C     XJDIR,YJDIR,ZJDIR = UNIT VECTOR IN THE OUTWARD DIRECTION ON THE
C                         WIRE
C     XK = WAVE NUMBER IN THE MEDIUM CONTAINING THE WIRE
C
C     OUTPUT:
C     SPP = SCALAR POTENTIAL DUE TO CHARGE DISTRIBUTION OF .5*SLEN+Z
C     SPM = SCALAR POTENTIAL DUE TO CHARGE DISTRIBUTION OF .5*SLEN-Z
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 XK,SPP,SPM
      XIJ=XI-XJ
      YIJ=YI-YJ
      ZIJ=ZI-ZJ
      ZZ=XIJ*XJDIR+YIJ*YJDIR+ZIJ*ZJDIR
      RHOX=XIJ-XJDIR*ZZ
      RHOY=YIJ-YJDIR*ZZ
      RHOZ=ZIJ-ZJDIR*ZZ
      RHO=SQRT(RHOX**2+RHOY**2+RHOZ**2+ARADJ**2)
      CALL SPMPOT(RHO,ZZ,SLENJ,XK,SPP,SPM)
      RETURN
      END
      SUBROUTINE SCAPOX(XI,YI,ZI,XJEND,YJEND,ZJEND,ARADJ,XJDIR,YJDIR,
     &ZJDIR,XK,SEMINF)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     SCAPOX evaluates the integral for scalar potential due to unit
C     charge on a semi-infinite section of wire.  The factor
C     1/(4*PI*EPSILON) has been omitted since only relative values in
C     a medium with constant permittivity are needed.
C
C     INPUT:
C     XI,YI,ZI = COORDINATES OF THE EVALUATION POINT
C     XJEND,YJEND,ZJEND = COORDINATES OF THE END OF THE SEMI-INFINITE
C                         WIRE
C     ARADJ = RADIUS OF THE WIRE
C     XJDIR,YJDIR,ZJDIR = UNIT VECTOR IN THE OUTWARD DIRECTION ON THE
C                         WIRE
C     XK = WAVE NUMBER IN THE MEDIUM CONTAINING THE WIRE
C
C     OUTPUT:
C     SEMINF = SCALAR POTENTIAL DUE TO UNIT CHARGE ON THE WIRE
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 XK,SEMINF,SPP,HANKKR
      XIJ=XI-XJEND
      YIJ=YI-YJEND
      ZIJ=ZI-ZJEND
      ZZ=XIJ*XJDIR+YIJ*YJDIR+ZIJ*ZJDIR
      SLEN=ABS(ZZ)
      RHOX=XIJ-XJDIR*ZZ
      RHOY=YIJ-YJDIR*ZZ
      RHOZ=ZIJ-ZJDIR*ZZ
      RHO=SQRT(RHOX**2+RHOY**2+RHOZ**2+ARADJ**2)
      CALL EXRINT(RHO,.5*ZZ,SLEN,XK,SPP)
      IF(ZZ.LT.0.)SPP=-SPP
      CALL HANK2Z(XK*RHO,HANKKR)
      SEMINF=(0.,-1.5707963)*HANKKR+SPP
      RETURN
      END
      SUBROUTINE SPMPOT(RHO,ZOB,SLEN,XK,SPP,SPM)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     SPMPOT evaluates the integrals for the scalar potential due to
C     linear charge distributions on a wire segment on the Z axis of a
C     cylindrical coordinate system.  The exponential integrals are
C     evaluated by series expansion.  The factor 1/(4*PI*EPSILON) has
C     been omitted since only relative values in a medium with constant
C     permittivity are needed.
C
C     INPUT:
C     RHO = RHO COORDINATE OF EVALUATION POINT (M)
C     ZOB = Z COORDINATE OF EVALUATION POINT (M)
C     SLEN = SEGMENT LENGTH (M)
C     XK = WAVE NUMBER IN THE MEDIUM IN WHICH THE SEGMENT IS LOCATED
C
C     OUTPUT:
C     SPP = SCALAR POTENTIAL DUE TO CHARGE DISTRIBUTION OF .5*SLEN+Z
C     SPM = SCALAR POTENTIAL DUE TO CHARGE DISTRIBUTION OF .5*SLEN-Z
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 XK,SPP,SPM,XKJ,XJS,RX,TM1,TM2,TM3,TM4,TM5,EXPR,EXR0,
     &EXR1
      XKJ=-(0.,1.)*XK
      RHS=RHO*RHO
      SH=.5*SLEN
      S1=-SH-ZOB
      SS1=S1*S1
      RS1=RHS+SS1
      RQ1=RS1*RS1
      R1=SQRT(RS1)
      S2=SH-ZOB
      SS2=S2*S2
      RS2=RHS+SS2
      RQ2=RS2*RS2
      R2=SQRT(RS2)
C
C     RIN IS THE INTEGRAL OF R**(N-2) FROM -SH TO SH
C
      IF(S1.GT.0.)THEN
           RI1=LOG((R2+S2)/(R1+S1))
      ELSE
           DIFR=R2-S2
           IF(S2.GT.0..AND.RHO.LT..05*R2)DIFR=.5*RHS/S2*(1.-.25*RHS/SS2)
           RI1=LOG((R1-S1)/DIFR)
      END IF
      RI2=S2-S1
      RI3=.5*(RHS*RI1+S2*R2-S1*R1)
      RI4=RHS*RI2+(SS2*S2-SS1*S1)/3.
      RI5=.75*RHS*RI3+.25*(S2*RS2*R2-S1*RS1*R1)
      XJS=XKJ*XKJ
      RZ=SQRT(RHS+ZOB*ZOB)
      RX=XKJ*RZ
      TM1=(((.041666667*RX-.16666667)*RX+.5)*RX-1.)*RX+1.
      TM2=-XKJ*(((.16666667*RX-.5)*RX+1.)*RX-1.)
      TM3=XJS*((.25*RX-.5)*RX+.5)
      TM4=.16666667*XKJ*XJS*(1.-RX)
      TM5=.041666667*XJS*XJS
      EXPR=EXP(RX)
C
C     EXR0 IS THE SERIES APPROX. FOR THE INTEGRAL OF EXP(-J*K*R)/R
C
      EXR0=(TM1*RI1+TM2*RI2+TM3*RI3+TM4*RI4+TM5*RI5)*EXPR
C
C     EXR1 IS THE SERIES APPROX. FOR THE INTEGRAL OF Z*EXP(-J*K*R)/R
C
      EXR1=(TM1*(R2-R1)+TM2*(RS2-RS1)*.5+TM3*(RS2*R2-RS1*R1)/3.+TM4*(RQ2
     &-RQ1)*.25+TM5*(RQ2*R2-RQ1*R1)*.2)*EXPR
      SPP=EXR1+(SH+ZOB)*EXR0
      SPM=-EXR1+(SH-ZOB)*EXR0
      RETURN
      END
      SUBROUTINE HANK2Z(Z,H0)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     HANK2Z evaluates the Hankel function of second kind, order zero
C     with complex argument Z.  Series expansion is used for small to
C     moderate argument size.  This routine should not be used for
C     arguments greater than about 10.
C
C     INPUT: Z = FUNCTION ARGUMENT
C     OUTPUT: H0 = HANKEL FUNCTION OF SECOND KIND, ORDER ZERO OF
C                  ARGUMENT Z
C
      IMPLICIT REAL*8 (A-H,O-Z)
      SAVE A1,A3,M
      COMPLEX*16 CLOGZ,H0,J0,Y0,Z,ZI,ZK
      DIMENSION M(101), A1(25), A3(25)
      DATA PI,GAMMA,C2/3.141592654D0,.5772156649D0,.3674669052D0/,
     &INIT/0/
      IF (INIT.EQ.0) GO TO 5
1     ZMS=Z*DCONJG(Z)
      IF (ZMS.EQ.0.)THEN
         PRINT 9
         STOP
      ELSE IF(ZMS.LT.0.0025)THEN
         H0=(0.,-.6366198)*(LOG(Z)+(-.11593,1.5708))
         RETURN
      END IF
      IZ=1.+ZMS
      IF(IZ.GT.101)IZ=101
      MIZ=M(IZ)
      J0=(1.,0.)
      Y0=(0.,0.)
      ZK=J0
      ZI=Z*Z
      DO 3 K=1,MIZ
      ZK=ZK*A1(K)*ZI
      J0=J0+ZK
3     Y0=Y0+A3(K)*ZK
      CLOGZ=LOG(.5*Z)
      Y0=(2.*J0*CLOGZ-Y0)/PI+C2
      H0=J0-(0.,1.)*Y0
      RETURN
C     INITIALIZATION OF CONSTANTS
5     PSI=-GAMMA
      DO 6 K=1,25
      A1(K)=-.25D0/(K*K)
      PSI=PSI+1.D0/K
6     A3(K)=PSI+PSI
      DO 8 I=1,101
      TEST=1.D0
      DO 7 K=1,24
      INIT=K
      TEST=-TEST*I*A1(K)
      IF (TEST*A3(K).LT.1.D-6) GO TO 8
7     CONTINUE
8     M(I)=INIT
      GO TO 1
C
9     FORMAT (' HANK2Z: ERROR - CANNOT EVALUATE H(Z) FOR Z=0.')
      END
      SUBROUTINE HANK12(Z,IKIND,H0,H0P)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     HANK12 evaluates the Hankel function of the first or second kind,
C     order zero, and its derivative for complex argument Z.
C
C     INPUT: Z = function argument
C            IKIND = 1 for Hankel function of first kind, 2 for 2nd kind
C     OUTPUT: H0 = Hankel function of order zero and argument Z
C             HOP = derivative of the Hankel function.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      SAVE A1,A2,A3,A4,M
      COMPLEX*16 CLOGZ,H0,H0P,J0,J0P,P0Z,P1Z,Q0Z,Q1Z,Y0,Y0P,Z,ZI,ZI2,ZK,
     &FJX
      DIMENSION M(101), A1(25), A2(25), A3(25), A4(25)
      DATA PI,GAMMA,C1,C2,C3,P10,P20/3.141592654D0,.5772156649D0,
     &-.0245785095D0,.3674669052D0,.7978845608D0,.0703125D0,
     &.1121520996D0/
      DATA Q10,Q20,P11,P21,Q11,Q21/.125D0,.0732421875D0,.1171875D0,
     &.1441955566D0,.375D0,.1025390625D0/
      DATA POF,INIT/.7853981635D0,0/
      IF (INIT.EQ.0) GO TO 5
1     FJX=(0.,1.)
      IF(IKIND.EQ.2)FJX=-FJX
      ZMS=Z*DCONJG(Z)
      IF (ZMS.NE.0.) GO TO 2
      WRITE(3,9)
      STOP
2     IB=0
      IF (ZMS.GT.16.81) GO TO 4
      IF (ZMS.GT.16.) IB=1
C     SERIES EXPANSION
      IZ=1.+ZMS
      MIZ=M(IZ)
      J0=(1.,0.)
      J0P=J0
      Y0=(0.,0.)
      Y0P=Y0
      ZK=J0
      ZI=Z*Z
      DO 3 K=1,MIZ
      ZK=ZK*A1(K)*ZI
      J0=J0+ZK
      J0P=J0P+A2(K)*ZK
      Y0=Y0+A3(K)*ZK
3     Y0P=Y0P+A4(K)*ZK
      J0P=-.5*Z*J0P
      CLOGZ=LOG(.5*Z)
      Y0=(2.*J0*CLOGZ-Y0)/PI+C2
      Y0P=(2./Z+2.*J0P*CLOGZ+.5*Y0P*Z)/PI+C1*Z
      H0=J0+FJX*Y0
      H0P=J0P+FJX*Y0P
      IF (IB.EQ.0) RETURN
      Y0=H0
      Y0P=H0P
C     ASYMPTOTIC EXPANSION
4     ZI=1./Z
      ZI2=ZI*ZI
      P0Z=1.+(P20*ZI2-P10)*ZI2
      P1Z=1.+(P11-P21*ZI2)*ZI2
      Q0Z=(Q20*ZI2-Q10)*ZI
      Q1Z=(Q11-Q21*ZI2)*ZI
      ZK=EXP(FJX*(Z-POF))*SQRT(ZI)*C3
      H0=ZK*(P0Z+FJX*Q0Z)
      H0P=FJX*ZK*(P1Z+FJX*Q1Z)
      IF (IB.EQ.0) RETURN
      ZMS=COS((SQRT(ZMS)-4.)*31.41592654)
      H0=.5*(Y0*(1.+ZMS)+H0*(1.-ZMS))
      H0P=.5*(Y0P*(1.+ZMS)+H0P*(1.-ZMS))
      RETURN
C     INITIALIZATION OF CONSTANTS
5     PSI=-GAMMA
      DO 6 K=1,25
      A1(K)=-.25D0/(K*K)
      A2(K)=1.D0/(K+1.D0)
      PSI=PSI+1.D0/K
      A3(K)=PSI+PSI
6     A4(K)=(PSI+PSI+1.D0/(K+1.D0))/(K+1.D0)
      DO 8 I=1,101
      TEST=1.D0
      DO 7 K=1,24
      INIT=K
      TEST=-TEST*I*A1(K)
      IF (TEST*A3(K).LT.1.D-6) GO TO 8
7     CONTINUE
8     M(I)=INIT
      GO TO 1
C
9     FORMAT (' HANK12: ERROR - CANNOT EVALUATE H(Z) FOR Z=0.')
      END
      SUBROUTINE CMNGF (CB,CC,CD,NB,NC,ND)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     CMNGF fills interaction matrices B, C, and D for N.G.F. solution.
C
C     INPUT:
C     NB = row dimension for CB
C     NC = row dimension for CC
C     ND = row dimension for CD
C
C     OUTPUT:
C     CB = matrix B (returned or written to disk)
C     CC = matrix C stored transposed (returned or written to disk)
C     CD = matrix D stored transposed (returned or written to disk)
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 CB,CC,CD,AX,BX,CX
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON /SEGJ/ AX(NSJMAX),BX(NSJMAX),CX(NSJMAX),JCO(NSJMAX),JSNO,
     &ISCON(NSCNGF),NSCON,IPCON(NSPNGF),NPCON
      COMMON /MATPAR/ ICASE,NBLOKS,NPBLK,NLAST,NBLSYM,NPSYM,NLSYM,IMAT,I
     &CASX,NBBX,NPBX,NLBX,NBBL,NPBL,NLBL
      DIMENSION CB(NB,*), CC(NC,*), CD(ND,*)
      IF(ICASX.GT.1)THEN
C
C        OPEN FILES FOR B, C AND D MATRICES
C
         IBFL=12
         IF(ICASX.GT.2)IBFL=15
         CLOSE(UNIT=IBFL,STATUS='DELETE',ERR=1)
1        CALL DAOPEN(IBFL,'TAPEB.NEC','unknown','DELETE',NPBX*ND)
         CLOSE(UNIT=13,STATUS='DELETE',ERR=5)
5        CALL DAOPEN(13,'TAPEC.NEC','unknown','DELETE',NPBL*NC)
         CLOSE(UNIT=14,STATUS='DELETE',ERR=7)
7        CALL DAOPEN(14,'TAPED.NEC','unknown','DELETE',NPBL*ND)
      END IF
      M1EQ=2*M1
      M2EQ=M1EQ+1
      MEQ=2*M
      NEQP=ND-NPCON*2
      NEQS=NEQP-NSCON
      NEQSP=NEQS+NC
      NEQN=NC+N-N1
      ITX=1
      IF (NSCON.GT.0) ITX=2
      IF (ICASX.LE.2)THEN
         DO 4 J=1,ND
         DO 2 I=1,ND
2        CD(I,J)=(0.,0.)
         DO 3 I=1,NB
         CB(I,J)=(0.,0.)
3        CC(I,J)=(0.,0.)
4        CONTINUE
      END IF
      IST=N-N1+1
      IT=NPBX
      ISV=-NPBX
C
C     LOOP THRU 24 FILLS B.  FOR ICASX=1 OR 2 ALSO FILLS D(WW), D(WS)
C
      DO 24 IBLK=1,NBBX
      ISV=ISV+NPBX
      IF (IBLK.EQ.NBBX) IT=NLBX
      IF (ICASX.GE.3)THEN
         DO 6 J=1,ND
         DO 6 I=1,IT
6        CB(I,J)=(0.,0.)
      END IF
      I1=ISV+1
      I2=ISV+IT
      IN2=I2
      IF (IN2.GT.N1) IN2=N1
      IM1=I1-N1
      IM2=I2-N1
      IF (IM1.LT.1) IM1=1
      IMX=1
      IF (I1.LE.N1) IMX=N1-I1+2
      IF (N2.LE.N)THEN
C
C        FILL B(WW),B(WS).  FOR ICASX=1,2 FILL D(WW),D(WS)
         DO 11 J=N2,N
         CALL TRIO (J)
         DO 9 I=1,JSNO
         JSS=JCO(I)
         IF (JSS.GE.N2)THEN
C
C           SET JCO WHEN SOURCE IS NEW BASIS FUNCTION ON NEW SEGMENT
            JCO(I)=JSS-N1
         ELSE
C
C           SOURCE IS PORTION OF MODIFIED BASIS FUNCTION ON NEW SEGMENT
            JCO(I)=NEQS+ICONX(JSS)
         END IF
9        CONTINUE
         IF (I1.LE.IN2) CALL CMWW (J,I1,IN2,CB,NB,CB,NB,0)
         IF (IM1.LE.IM2) CALL CMWS (J,IM1,IM2,CB(IMX,1),NB,CB,NB,0)
         IF (ICASX.GT.2) GO TO 11
         CALL CMWW (J,N2,N,CD,ND,CD,ND,1)
         IF (M2.LE.M) CALL CMWS (J,M2EQ,MEQ,CD(1,IST),ND,CD,ND,1)
11       CONTINUE
      END IF
      IF (NSCON.NE.0)THEN
C
C        FILL B(WW)PRIME
         DO 19 I=1,NSCON
         J=ISCON(I)
C
C        SOURCES ARE NEW OR MODIFIED BASIS FUNCTIONS ON OLD SEGMENTS
C        WHICH CONNECT TO NEW SEGMENTS
C
         CALL TRIO (J)
         JSS=0
         DO 15 IX=1,JSNO
         IR=JCO(IX)
         IF (IR.GE.N2)THEN
            IR=IR-N1
         ELSE
            IR=ICONX(IR)
            IF (IR.EQ.0) GO TO 15
            IR=NEQS+IR
         END IF
         JSS=JSS+1
         JCO(JSS)=IR
         AX(JSS)=AX(IX)
         BX(JSS)=BX(IX)
         CX(JSS)=CX(IX)
15       CONTINUE
         JSNO=JSS
         IF (I1.LE.IN2) CALL CMWW (J,I1,IN2,CB,NB,CB,NB,0)
         IF (IM1.LE.IM2) CALL CMWS (J,IM1,IM2,CB(IMX,1),NB,CB,NB,0)
C
C        SOURCE IS SINGULAR COMPONENT OF PATCH CURRENT THAT IS PART OF
C        MODIFIED BASIS FUNCTION FOR OLD SEGMENT THAT CONNECTS TO A NEW
C        SEGMENT ON END OPPOSITE PATCH.
C
         IF (I1.LE.IN2) CALL CMSW (J,I,I1,IN2,CB,CB,0,NB,-1)
C
C        SOURCES ARE PORTIONS OF MODIFIED BASIS FUNCTION J ON OLD SEGMENTS
C        EXCLUDING OLD SEGMENTS THAT DIRECTLY CONNECT TO NEW SEGMENTS.
C
         CALL TBF (J,1)
         JSX=JSNO
         JSNO=1
         IR=JCO(1)
         JCO(1)=NEQS+I
         DO 19 IX=1,JSX
         IF (IX.NE.1)THEN
            IR=JCO(IX)
            AX(1)=AX(IX)
            BX(1)=BX(IX)
            CX(1)=CX(IX)
         END IF
         IF (IR.GT.N1) GO TO 19
         IF (ICONX(IR).NE.0) GO TO 19
         IF (I1.LE.IN2) CALL CMWW (IR,I1,IN2,CB,NB,CB,NB,0)
         IF (IM1.LE.IM2) CALL CMWS (IR,IM1,IM2,CB(IMX,1),NB,CB,NB,0)
19       CONTINUE
      END IF
      IF (NPCON.NE.0)THEN
         JSS=NEQP
C
C        FILL B(SS)PRIME TO SET OLD PATCH BASIS FUNCTIONS TO ZERO FOR
C        PATCHES THAT CONNECT TO NEW SEGMENTS
C
         DO 21 I=1,NPCON
         IX=IPCON(I)*2+N1-ISV
         IR=IX-1
         JSS=JSS+1
         IF (IR.GT.0.AND.IR.LE.IT) CB(IR,JSS)=(1.,0.)
         JSS=JSS+1
         IF (IX.GT.0.AND.IX.LE.IT) CB(IX,JSS)=(1.,0.)
21       CONTINUE
      END IF
      IF (M2.LE.M)THEN
C
C        FILL B(SW) AND B(SS)
         IF (I1.LE.IN2) CALL CMSW (M2,M,I1,IN2,CB(1,IST),CB,N1,NB,0)
         IF (IM1.LE.IM2) CALL CMSS (M2,M,IM1,IM2,CB(IMX,IST),NB,0)
      END IF
      IF (ICASX.NE.1)CALL RECOT(CB,IBFL,1,NPBX*ND,IBLK,
     &' WRITE CB IN CNNGF')
24    CONTINUE
C
C     FILLING B COMPLETE.  START ON C AND D
C
      IT=NPBL
      ISV=-NPBL
      DO 43 IBLK=1,NBBL
      ISV=ISV+NPBL
      ISVV=ISV+NC
      IF (IBLK.EQ.NBBL) IT=NLBL
      IF (ICASX.GE.3)THEN
         DO 26 J=1,IT
         DO 25 I=1,NC
25       CC(I,J)=(0.,0.)
         DO 26 I=1,ND
26       CD(I,J)=(0.,0.)
      END IF
      I1=ISVV+1
      I2=ISVV+IT
      IN1=I1-M1EQ
      IN2=I2-M1EQ
      IF (IN2.GT.N) IN2=N
      IM1=I1-N
      IM2=I2-N
      IF (IM1.LT.M2EQ) IM1=M2EQ
      IF (IM2.GT.MEQ) IM2=MEQ
      IMX=1
      IF (IN1.LE.IN2) IMX=NEQN-I1+2
      IF (ICASX.GT.2.AND.N2.LE.N)THEN
C
C        SAME AS DO 24 LOOP TO FILL D(WW) FOR ICASX GREATER THAN 2
C
         DO 31 J=N2,N
         CALL TRIO (J)
         DO 29 I=1,JSNO
         JSS=JCO(I)
         IF (JSS.GE.N2)THEN
            JCO(I)=JSS-N1
         ELSE
            JCO(I)=NEQS+ICONX(JSS)
         END IF
29       CONTINUE
         IF (IN1.LE.IN2) CALL CMWW (J,IN1,IN2,CD,ND,CD,ND,1)
         IF (IM1.LE.IM2) CALL CMWS (J,IM1,IM2,CD(1,IMX),ND,CD,ND,1)
31       CONTINUE
      END IF
      IF (M2.LE.M)THEN
C
C        FILL D(SW) AND D(SS)
         IF (IN1.LE.IN2) CALL CMSW (M2,M,IN1,IN2,CD(IST,1),CD,N1,ND,1)
         IF (IM1.LE.IM2) CALL CMSS (M2,M,IM1,IM2,CD(IST,IMX),ND,1)
      END IF
      IF (N1.GT.0)THEN
C
C        FILL C(WW),C(WS), D(WW)PRIME, AND D(WS)PRIME.
         DO 37 J=1,N1
         CALL TRIO (J)
         IF (NSCON.NE.0)THEN
            DO 35 IX=1,JSNO
            JSS=JCO(IX)
            IF (JSS.GE.N2)THEN
               JCO(IX)=JSS+M1EQ
            ELSE
               IR=ICONX(JSS)
               IF (IR.NE.0) JCO(IX)=NEQSP+IR
            END IF
35          CONTINUE
         END IF
         IF (IN1.LE.IN2) CALL CMWW (J,IN1,IN2,CC,NC,CD,ND,ITX)
         IF (IM1.LE.IM2) CALL CMWS (J,IM1,IM2,CC(1,IMX),NC,CD(1,IMX),ND,
     &   ITX)
37       CONTINUE
         IF (NSCON.NE.0)THEN
C
C           FILL C(WW)PRIME
            DO 38 IX=1,NSCON
            IR=ISCON(IX)
            JSS=NEQS+IX-ISV
            IF (JSS.GT.0.AND.JSS.LE.IT) CC(IR,JSS)=(1.,0.)
38          CONTINUE
         END IF
      END IF
      IF (NPCON.NE.0)THEN
C
C        FILL C(SS)PRIME
         JSS=NEQP-ISV
         DO 40 I=1,NPCON
         IX=IPCON(I)*2+N1
         IR=IX-1
         JSS=JSS+1
         IF (JSS.GT.0.AND.JSS.LE.IT) CC(IR,JSS)=(1.,0.)
         JSS=JSS+1
         IF (JSS.GT.0.AND.JSS.LE.IT) CC(IX,JSS)=(1.,0.)
40       CONTINUE
      END IF
      IF (M1.GT.0)THEN
C
C        FILL C(SW) AND C(SS)
         IF (IN1.LE.IN2) CALL CMSW (1,M1,IN1,IN2,CC(N2,1),CC,0,NC,1)
         IF (IM1.LE.IM2) CALL CMSS (1,M1,IM1,IM2,CC(N2,IMX),NC,1)
      END IF
      IF (ICASX.NE.1)THEN
         CALL RECOT(CC,13,1,NC*IT,IBLK,' WRITE CC IN CMNGF')
         CALL RECOT(CD,14,1,ND*IT,IBLK,' WRITE CD IN CMNGF')
      END IF
43    CONTINUE
      RETURN
      END
      SUBROUTINE CMSET (NROW,CM,IU1)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     CMSET fills the complex MoM matrix in the array CM.
C
C     INPUT:
C     NROW = row dimension of transposed matrix (total no. of equations)
C     IU1 = logical unit number for writing matrix blocks to disk
C
C     OUTPUT:
C     CM = array for storing matrix or blocks of matrix
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 CM,SSX,D,DETER,AX,BX,CX
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON /MATPAR/ ICASE,NBLOKS,NPBLK,NLAST,NBLSYM,NPSYM,NLSYM,IMAT,I
     &CASX,NBBX,NPBX,NLBX,NBBL,NPBL,NLBL
      COMMON /SMAT/ SSX(MAXSYM,MAXSYM)
      COMMON /SCRATM/ D(2*MAXSEG)
      COMMON /SEGJ/ AX(NSJMAX),BX(NSJMAX),CX(NSJMAX),JCO(NSJMAX),JSNO,
     &ISCON(NSCNGF),NSCON,IPCON(NSPNGF),NPCON
      DIMENSION CM(NROW,*)
      MP2=2*MP
      NPEQ=NP+MP2
      NEQ=N+2*M
      NOP=NEQ/NPEQ
      IOUT=NPBLK*NROW
      IT=NPBLK
C
C     OPEN FILE FOR MATRIX IF NEEDED.
C
      IF(ICASE.GT.2)THEN
         CLOSE(UNIT=IU1,STATUS='DELETE',ERR=5)
5        CALL DAOPEN(IU1,'TAPE11.NEC','unknown','DELETE',IOUT)
      END IF
C
C     CYCLE OVER MATRIX BLOCKS
C
      DO 13 IXBLK1=1,NBLOKS
      ISV=(IXBLK1-1)*NPBLK
      IF (IXBLK1.EQ.NBLOKS) IT=NLAST
      DO 1 I=1,NROW
      DO 1 J=1,IT
1     CM(I,J)=(0.,0.)
      I1=ISV+1
      I2=ISV+IT
      IN2=I2
      IF (IN2.GT.NP) IN2=NP
      IM1=I1-NP
      IM2=I2-NP
      IF (IM1.LT.1) IM1=1
      IST=1
      IF (I1.LE.NP) IST=NP-I1+2
C
C     WIRE SOURCE LOOP
C
      IF (N.GT.0)THEN
         DO 4 J=1,N
         CALL TRIO (J)
         DO 2 I=1,JSNO
         IJ=JCO(I)
2        JCO(I)=((IJ-1)/NP)*MP2+IJ
         IF (I1.LE.IN2) CALL CMWW (J,I1,IN2,CM,NROW,CM,NROW,1)
         IF (IM1.LE.IM2) CALL CMWS (J,IM1,IM2,CM(1,IST),NROW,CM,NROW,1)
4        CONTINUE
      END IF
C
C     MATRIX ELEMENTS FOR PATCH CURRENT SOURCES
C
      IF (M.GT.0)THEN
         JM1=1-MP
         JM2=0
         JST=1-MP2
         DO 6 I=1,NOP
         JM1=JM1+MP
         JM2=JM2+MP
         JST=JST+NPEQ
         IF (I1.LE.IN2) CALL CMSW (JM1,JM2,I1,IN2,CM(JST,1),CM,0,NROW,1)
         IF (IM1.LE.IM2) CALL CMSS (JM1,JM2,IM1,IM2,CM(JST,IST),NROW,1)
6        CONTINUE
      END IF
      IF((ICASE.EQ.2).OR.(ICASE.GT.3))THEN
C
C        COMBINE ELEMENTS FOR SYMMETRY MODES
C
         DO 11 I=1,IT
         DO 11 J=1,NPEQ
         DO 8 K=1,NOP
         KA=J+(K-1)*NPEQ
8        D(K)=CM(KA,I)
         DETER=D(1)
         DO 9 KK=2,NOP
9        DETER=DETER+D(KK)
         CM(J,I)=DETER
         DO 11 K=2,NOP
         KA=J+(K-1)*NPEQ
         DETER=D(1)
         DO 10 KK=2,NOP
10       DETER=DETER+D(KK)*SSX(K,KK)
         CM(KA,I)=DETER
11       CONTINUE
      END IF
C
C     WRITE BLOCK FOR OUT-OF-CORE CASES.
      IF(ICASE.GT.2)CALL RECOT (CM,IU1,1,IOUT,IXBLK1,'Write from CMSET')
13    CONTINUE
      RETURN
      END
      SUBROUTINE HSFLX (S,RH,ZPX,XK,HPK,HPS,HPC)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     HSFLX calculates H field of a current filament on the Z axis with
C     sine, cosine and constant distributions.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 FJ,EKR1,EKR2,T1,T2,CONS,HPS,HPC,HPK,XK,XKJ,CDK,SDK,DK
      COMMON /TMH/ XKJ,ZP,RH2
      EXTERNAL GH
      DATA FJ/(0.D0,1.D0)/,PI4/12.56637062D0/,PI8/25.13274123D0/
      IF (RH.LT.1.E-20)THEN
         HPS=(0.,0.)
         HPC=(0.,0.)
         HPK=(0.,0.)
         RETURN
      END IF
      XKJ=FJ*XK
      RH2=RH*RH
      IF (ZPX.LT.0.)THEN
         ZP=-ZPX
         HSS=-1.
      ELSE
         ZP=ZPX
         HSS=1.
      END IF
      DH=.5*S
      Z1=ZP+DH
      Z2=ZP-DH
      IF (Z2.LT.1.E-7*S)THEN
         RHZ=1.
      ELSE
         RHZ=RH/Z2
      END IF
      DK=XK*DH
      CDK=COS(DK)
      SDK=SIN(DK)
      CALL ROMBG (-DH,DH,1,GH,HPK,0.D0,1.D-4)
      HPK=HPK*RH/PI4
      IF (RHZ.GT.1.E-3)THEN
         R1=SQRT(RH2+Z1*Z1)
         R2=SQRT(RH2+Z2*Z2)
         EKR1=EXP(-XKJ*R1)
         EKR2=EXP(-XKJ*R2)
         T1=Z1*EKR1/R1
         T2=Z2*EKR2/R2
         HPS=(CDK*(EKR2-EKR1)-FJ*SDK*(T2+T1))*HSS
         HPC=-SDK*(EKR2+EKR1)-FJ*CDK*(T2-T1)
         CONS=-FJ/(PI4*RH)
         HPS=CONS*HPS
         HPC=CONS*HPC
         HPC=HPC-HPK
      ELSE
         EKR1=(CDK+FJ*SDK)/(Z2*Z2)
         EKR2=(CDK-FJ*SDK)/(Z1*Z1)
         ZR=1./Z1-1./Z2
         T2=EXP(-XKJ*ZP)*RH/PI8
         HPS=T2*(XK*ZR+(EKR1+EKR2)*SDK)*HSS
         HPC=T2*((EKR1-EKR2)*CDK-XKJ*ZR)
         HPC=HPC-HPK
      END IF
      RETURN
      END
      SUBROUTINE CMSW (J1,J2,I1,I2,CM,CW,NCW,NROW,ITRP)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     CMSW computes matrix elements for E along wires due to patch
C     currents.
C
      INCLUDE 'NECPAR.INC'
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 CM,H1X,H1Y,H1Z,H2X,H2Y,H2Z,EXC,EYC,EZC,EMEL,CW,
     &XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,FRATI,ETAL2,AX,BX,CX,XK,CCOSM1
      COMMON /DATA/ X(MAXSEG),Y(MAXSEG),Z(MAXSEG),SI(MAXSEG),BI(MAXSEG),
     &ALP(MAXSEG),BET(MAXSEG),SALP(MAXSEG),T2X(MAXSEG),T2Y(MAXSEG),
     &T2Z(MAXSEG),ICON1(MAXSEG),ICON2(MAXSEG),ITAG(MAXSEG),
     &ICONX(MAXSEG),IPSYM,LD,N1,N2,N,NP,M1,M2,M,MP
      COMMON /GND/XKU,XKL,ETAU,ETAL,CEPSU,CEPSL,ETAL2,FRATI,OMEGAG,
     &CLIFL,CLIFH,EPSR2,SIG2,SCNRAD,SCNWRD,GSCAL,ICLIFT,NRADL,IFAR,
     &IPERF,KSYMP
      COMMON/DATAP/H1X,H1Y,H1Z,H2X,H2Y,H2Z,SPATJ,XPATJ,YPATJ,ZPATJ,T1XJ,
     &T1YJ,T1ZJ,T2XJ,T2YJ,T2ZJ,IPGND
      COMMON /SEGJ/ AX(NSJMAX),BX(NSJMAX),CX(NSJMAX),JCO(NSJMAX),JSNO,
     &ISCON(NSCNGF),NSCON,IPCON(NSPNGF),NPCON
      DIMENSION CAB(MAXSEG), SAB(MAXSEG), CM(NROW,*), CW(NROW,*)
      DIMENSION T1X(MAXSEG),T1Y(MAXSEG),T1Z(MAXSEG),EMEL(9)
      EQUIVALENCE (T1X,SI),(T1Y,ALP),(T1Z,BET),(CAB,ALP),(SAB,BET)
      LDP=LD+1
      NEQS=N-N1+2*(M-M1)
      IF (ITRP.LT.0) GO TO 15
      K=0
      ICGO=1
C     OBSERVATION LOOP
      DO 14 I=I1,I2
      K=K+1
      XI=X(I)
      YI=Y(I)
      ZI=Z(I)
      CABI=CAB(I)
      SABI=SAB(I)
      SALPI=SALP(I)
      IPCH=0
      IF (ICON1(I).GT.30000)THEN
         IPCH=ICON1(I)-30000
         FSIGN=-1.
      END IF
      IF (ICON2(I).GT.30000)THEN
         IPCH=ICON2(I)-30000
         FSIGN=1.
      END IF
      JL=0
C     SOURCE LOOP
      DO 14 J=J1,J2
      JS=LDP-J
      JL=JL+2
      T1XJ=T1X(JS)
      T1YJ=T1Y(JS)
      T1ZJ=T1Z(JS)
      T2XJ=T2X(JS)
      T2YJ=T2Y(JS)
      T2ZJ=T2Z(JS)
      XPATJ=X(JS)
      YPATJ=Y(JS)
      ZPATJ=Z(JS)
      SPATJ=BI(JS)
      IF (ZPATJ.GE.0.)THEN
         XK=XKU
      ELSE
         XK=XKL
      END IF
C     GROUND LOOP
      DO 13 IP=1,KSYMP
      IPGND=IP
      IF (IPCH.NE.J.AND.ICGO.EQ.1) GO TO 11
      IF (IP.EQ.2) GO TO 11
      IF (ICGO.GT.1) GO TO 8
      CALL PCINT (XI,YI,ZI,CABI,SABI,SALPI,EMEL)
      EZC=.5*SI(I)*FSIGN*XK
      EYC=SIN(EZC)
      EZC=CCOSM1(EZC)
      EXC=EMEL(9)*FSIGN/XKU
      CALL TRIO (I)
      IF (I.GT.N1)THEN
         IL=I-NCW
         IF (I.LE.NP) IL=((IL-1)/NP)*2*MP+IL
      ELSE
         IL=NEQS+ICONX(I)
      END IF
      IF (ITRP.EQ.0)THEN
         CW(K,IL)=CW(K,IL)+EXC*(AX(JSNO)+BX(JSNO)*EYC+CX(JSNO)*EZC)
      ELSE
         CW(IL,K)=CW(IL,K)+EXC*(AX(JSNO)+BX(JSNO)*EYC+CX(JSNO)*EZC)
      END IF
8     IF (ITRP.EQ.0)THEN
         CM(K,JL-1)=EMEL(ICGO)
         CM(K,JL)=EMEL(ICGO+4)
      ELSE
         CM(JL-1,K)=EMEL(ICGO)
         CM(JL,K)=EMEL(ICGO+4)
      END IF
      ICGO=ICGO+1
      IF (ICGO.EQ.5) ICGO=1
      GO TO 13
11    CALL UNERE (XI,YI,ZI)
      IF (ITRP.EQ.0)THEN
C     NORMAL FILL
         CM(K,JL-1)=CM(K,JL-1)+H1X*CABI+H1Y*SABI+H1Z*SALPI
         CM(K,JL)=CM(K,JL)+H2X*CABI+H2Y*SABI+H2Z*SALPI
      ELSE
C     TRANSPOSED FILL
         CM(JL-1,K)=CM(JL-1,K)+H1X*CABI+H1Y*SABI+H1Z*SALPI
         CM(JL,K)=CM(JL,K)+H2X*CABI+H2Y*SABI+H2Z*SALPI
      END IF
13    CONTINUE
14    CONTINUE
      RETURN
C     FOR OLD SEG. CONNECTING TO OLD PATCH ON ONE END AND NEW SEG. ON
C     OTHER END INTEGRATE SINGULAR COMPONENT (9) OF SURFACE CURRENT ONLY
15    IF (J1.LT.I1.OR.J1.GT.I2)RETURN
      IPCH=ICON1(J1)
      IF (IPCH.GT.30000)THEN
         IPCH=IPCH-30000
         FSIGN=-1.
      ELSE
         IPCH=ICON2(J1)
         IF (IPCH.LT.30000)RETURN
         IPCH=IPCH-30000
         FSIGN=1.
      END IF
      IF (IPCH.GT.M1)RETURN
      JS=LDP-IPCH
      IPGND=1
      T1XJ=T1X(JS)
      T1YJ=T1Y(JS)
      T1ZJ=T1Z(JS)
      T2XJ=T2X(JS)
      T2YJ=T2Y(JS)
      T2ZJ=T2Z(JS)
      XPATJ=X(JS)
      YPATJ=Y(JS)
      ZPATJ=Z(JS)
      SPATJ=BI(JS)
      XI=X(J1)
      YI=Y(J1)
      ZI=Z(J1)
      CABI=CAB(J1)
      SABI=SAB(J1)
      SALPI=SALP(J1)
      CALL PCINT (XI,YI,ZI,CABI,SABI,SALPI,EMEL)
      XK=XKU
      IF(Z(J1).LT.0.)XK=XKL
      EZC=.5*SI(J1)*FSIGN*XK
      EYC=SIN(EZC)
      EZC=CCOSM1(EZC)
      EXC=EMEL(9)*FSIGN/XKU
      IL=JCO(JSNO)
      K=J1-I1+1
      CW(K,IL)=CW(K,IL)+EXC*(AX(JSNO)+BX(JSNO)*EYC+CX(JSNO)*EZC)
      RETURN
      END
      COMPLEX*16 FUNCTION CCOSM1(Z)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     Purpose:
C     CCOSM1 computes COS(Z)-1 for complex Z.  A series is used for
C     small Z to maintain accuracy.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 Z,ZS
      IF (ABS(Z).GT..01)THEN
           CCOSM1=COS(Z)-1.
      ELSE
           ZS=Z*Z
           CCOSM1=-((1.3888889E-3*ZS-4.1666666667E-2)*ZS+.5)*ZS
      END IF
      RETURN
      END
      SUBROUTINE SOMNTX(EPSC1,ISMPRX)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     SOMNTX generates interpolation tables and least-squares approx-
C     imation parameters to approximate sommerfeld integrals for field
C     transmitted across the interface.
C
C     INPUT:
C     EPSC1 = relative permittivity of the ground
C     SIG1 = conductivity of the ground (S/m)
C     FMHZ = frequency in MHz.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      SAVE
      COMPLEX*16 CKSM,CCK1,CCK1S,CCK2,CCK2S,CON1,CON2,CON3,XLA,GCK1,
     &GCK1SQ,GCK2,GCK2SQ,EPSC1
      COMMON /EVLCOM/ CKSM,CCK1,CCK1S,CCK2,CCK2S,CON1,CON2,CON3,TKMAG,TS
     &MAG,CKAR,CKAI,CKBR,CKBI,ZZ,ZP,RHO,JH,IQAZ
      COMMON /GPARM/ XLA(21,21),GCK1,GCK1SQ,GCK2,GCK2SQ,ZRAT,RHON
      COMMON/PRNTCM/ISMPRT
C
C     SOMMERFELD INTEGRAL EVALUATION USES EXP(-JWT), NEC USES EXP(+JWT),
C     HENCE NEED CONJG(GCK1).  CONJUGATE OF FIELDS OCCURS IN SUBROUTINE
C     EVLUB.
C
      ISMPRT=ISMPRX
      GCK2=6.2831853071796D0
      GCK1=GCK2*SQRT(EPSC1)
      GCK1SQ=GCK1*GCK1
      GCK2SQ=GCK2*GCK2
      CCK1=DCONJG(GCK1)
      CCK2=DCONJG(GCK2)
      CCK1S=DCONJG(GCK1SQ)
      CCK2S=DCONJG(GCK2SQ)
      ELGND=ABS(GCK2/GCK1)
      IF (ELGND.GT..3) ELGND=.3
      CON1=(0.,188.37)
      CALL SECOND (TIM1)
      CALL SOMLSQ (EPSC1,ELGND)
      CALL SOMTRP (EPSC1,ELGND)
      CALL SECOND (TIM2)
      TIM2=TIM2-TIM1
      WRITE(3,2)TIM2
      RETURN
C
2     FORMAT (/,' Time to generate Sommerfeld ground tables =',F7.2,
     &' seconds',/)
      END
      SUBROUTINE BESSEL (Z,J0,J0P)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     BESSEL EVALUATES THE ZERO-ORDER BESSEL FUNCTION AND ITS DERIVATIVE
C     FOR COMPLEX ARGUMENT Z.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      SAVE A1,A2,M
      COMPLEX*16 J0,J0P,P0Z,P1Z,Q0Z,Q1Z,Z,ZI,ZI2,ZK,FJ,CZ,SZ,J0X,J0PX
      DIMENSION M(101), A1(25), A2(25)
      DATA C3,P10,P20,Q10,Q20/.7978845608D0,.0703125D0,.1121520996D0,
     &.125D0,.0732421875D0/
      DATA P11,P21,Q11,Q21/.1171875D0,.1441955566D0,.375D0,
     &.1025390625D0/
      DATA POF,INIT/.7853981635D0,0/,FJ/(0.D0,1.D0)/
      IF (INIT.EQ.0) GO TO 5
1     ZMS=Z*DCONJG(Z)
      IF (ZMS.GT.1.E-12) GO TO 2
      J0=(1.,0.)
      J0P=-.5*Z
      RETURN
2     IB=0
      IF (ZMS.GT.37.21) GO TO 4
      IF (ZMS.GT.36.) IB=1
C     SERIES EXPANSION
      IZ=1.+ZMS
      MIZ=M(IZ)
      J0=(1.,0.)
      J0P=J0
      ZK=J0
      ZI=Z*Z
      DO 3 K=1,MIZ
      ZK=ZK*A1(K)*ZI
      J0=J0+ZK
3     J0P=J0P+A2(K)*ZK
      J0P=-.5*Z*J0P
      IF (IB.EQ.0) RETURN
      J0X=J0
      J0PX=J0P
C     ASYMPTOTIC EXPANSION
4     ZI=1./Z
      ZI2=ZI*ZI
      P0Z=1.+(P20*ZI2-P10)*ZI2
      P1Z=1.+(P11-P21*ZI2)*ZI2
      Q0Z=(Q20*ZI2-Q10)*ZI
      Q1Z=(Q11-Q21*ZI2)*ZI
      ZK=EXP(FJ*(Z-POF))
      ZI2=1./ZK
      CZ=.5*(ZK+ZI2)
      SZ=FJ*.5*(ZI2-ZK)
      ZK=C3*SQRT(ZI)
      J0=ZK*(P0Z*CZ-Q0Z*SZ)
      J0P=-ZK*(P1Z*SZ+Q1Z*CZ)
      IF (IB.EQ.0) RETURN
      ZMS=COS((SQRT(ZMS)-6.)*31.41592654)
      J0=.5*(J0X*(1.+ZMS)+J0*(1.-ZMS))
      J0P=.5*(J0PX*(1.+ZMS)+J0P*(1.-ZMS))
      RETURN
C     INITIALIZATION OF CONSTANTS
5     DO 6 K=1,25
      A1(K)=-.25D0/(K*K)
6     A2(K)=1.D0/(K+1.D0)
      DO 8 I=1,101
      TEST=1.D0
      DO 7 K=1,24
      INIT=K
      TEST=-TEST*I*A1(K)
      IF (TEST.LT.1.D-6) GO TO 8
7     CONTINUE
8     M(I)=INIT
      GO TO 1
      END
      SUBROUTINE CAXPY (N,CA,CX,INCX,CY,INCY)
C  ***BEGIN PROLOGUE  CAXPY
C     REVISION DATE  811015   (YYMMDD)
C     CATEGORY NO.  F1A
C     KEYWORDS  BLAS,COMPLEX
C     DATE WRITTEN  OCTOBER 1979
C     AUTHOR LAWSON C. (JPL),HANSON R. (SLA),
C                            KINCAID D. (U TEXAS), KROGH F. (JPL)
C  ***PURPOSE
C     COMPLEX COMPUTATION Y = A*X + Y
C  ***DESCRIPTION
C                B L A S  SUBPROGRAM
C     DESCRIPTION OF PARAMETERS
C
C     --INPUT--
C        N  NUMBER OF ELEMENTS IN INPUT VECTOR(S)
C       CA  COMPLEX SCALAR MULTIPLIER
C       CX  COMPLEX VECTOR WITH N ELEMENTS
C     INCX  STORAGE SPACING BETWEEN ELEMENTS OF CX
C       CY  COMPLEX VECTOR WITH N ELEMENTS
C     INCY  STORAGE SPACING BETWEEN ELEMENTS OF CY
C
C     --OUTPUT--
C       CY  COMPLEX RESULT (UNCHANGED IF N.LE.0)
C
C     OVERWRITE COMPLEX CY WITH COMPLEX  CA*CX + CY.
C     FOR I = 0 TO N-1, REPLACE  CY(LY+I*INCY) WITH CA*CX(LX+I*INCX) +
C       CY(LY+I*INCY), WHERE LX = 1 IF INCX .GE. 0, ELSE LX = (-INCX)*N
C       AND LY IS DEFINED IN A SIMILAR WAY USING INCY.
C
C
C  ***REFERENCES
C     LAWSON C.L., HANSON R.J., KINCAID D.R., KROGH F.T.,
C     BASIC LINEAR ALGEBRA SUBPROGRAMS FOR FORTRAN USAGE*,
C     ALGORITHM NO. 539, TRANSACTIONS ON MATHEMATICAL SOFTWARE,
C     VOLUME 5, NUMBER 3, SEPTEMBER 1979, 308-323
C     ROUTINES CALLED    (NONE)
C  ***END PROLOGUE  CAXPY
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 CX(*),CY(*),CA
C     FIRST EXECUTABLE STATEMENT  CAXPY
      CANORM=ABS(DREAL(CA))+ABS(DIMAG(CA))
      IF (N.LE.0.OR.CANORM.EQ.0.E0) RETURN
      IF (INCX.EQ.INCY.AND.INCX.GT.0) GO TO 2
      KX=1
      KY=1
      IF (INCX.LT.0) KX=1+(1-N)*INCX
      IF (INCY.LT.0) KY=1+(1-N)*INCY
      DO 1 I=1,N
      CY(KY)=CY(KY)+CA*CX(KX)
      KX=KX+INCX
      KY=KY+INCY
1     CONTINUE
      RETURN
2     CONTINUE
      NS=N*INCX
      DO 3 I=1,NS,INCX
      CY(I)=CA*CX(I)+CY(I)
3     CONTINUE
      RETURN
      END
      SUBROUTINE CCOPY (N,CX,INCX,CY,INCY)
C  ***BEGIN PROLOGUE  CCOPY
C     REVISION DATE  811015   (YYMMDD)
C     CATEGORY NO.  F1A
C     KEYWORDS  COMPLEX,BLAS,VECTOR,COPY,VECTOR COPY
C     DATE WRITTEN  OCTOBER 1979
C     AUTHOR LAWSON C. (JPL),HANSON R. (SLA),
C                            KINCAID D. (U TEXAS), KROGH F. (JPL)
C  ***PURPOSE
C     COMPLEX VECTOR COPY Y = X
C  ***DESCRIPTION
C                B L A S  SUBPROGRAM
C     DESCRIPTION OF PARAMETERS
C
C     --INPUT--
C        N  NUMBER OF ELEMENTS IN INPUT VECTOR(S)
C       CX  COMPLEX VECTOR WITH N ELEMENTS
C     INCX  STORAGE SPACING BETWEEN ELEMENTS OF CX
C       CY  COMPLEX VECTOR WITH N ELEMENTS
C     INCY  STORAGE SPACING BETWEEN ELEMENTS OF CY
C
C     --OUTPUT--
C       CY  COPY OF VECTOR CX (UNCHANGED IF N.LE.0)
C
C     COPY COMPLEX CX TO COMPLEX CY.
C     FOR I = 0 TO N-1, COPY CX(LX+I*INCX) TO CY(LY+I*INCY),
C     WHERE LX = 1 IF INCX .GE. 0, ELSE LX = (-INCX)*N, AND LY IS
C     DEFINED IN A SIMILAR WAY USING INCY.
C
C
C  ***REFERENCES
C     LAWSON C.L., HANSON R.J., KINCAID D.R., KROGH F.T.,
C     BASIC LINEAR ALGEBRA SUBPROGRAMS FOR FORTRAN USAGE*,
C     ALGORITHM NO. 539, TRANSACTIONS ON MATHEMATICAL SOFTWARE,
C     VOLUME 5, NUMBER 3, SEPTEMBER 1979, 308-323
C     ROUTINES CALLED  (NONE)
C  ***END PROLOGUE  CCOPY
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 CX(*),CY(*)
C     FIRST EXECUTABLE STATEMENT  CCOPY
      IF (N.LE.0) RETURN
      IF (INCX.EQ.INCY.AND.INCX.GT.0) GO TO 2
      KX=1
      KY=1
      IF (INCX.LT.0) KX=1+(1-N)*INCX
      IF (INCY.LT.0) KY=1+(1-N)*INCY
      DO 1 I=1,N
      CY(KY)=CX(KX)
      KX=KX+INCX
      KY=KY+INCY
1     CONTINUE
      RETURN
2     CONTINUE
      NS=N*INCX
      DO 3 I=1,NS,INCX
      CY(I)=CX(I)
3     CONTINUE
      RETURN
      END
      COMPLEX*16 FUNCTION CDOTC(N,CX,INCX,CY,INCY)
C  ***BEGIN PROLOGUE  CDOTC
C     REVISION DATE  811015   (YYMMDD)
C     CATEGORY NO.  F1A
C     KEYWORDS  COMPLEX,BLAS,VECTOR,DOT PRODUCT,INNER PRODUCT
C     DATE WRITTEN  OCTOBER 1979
C     AUTHOR LAWSON C. (JPL),HANSON R. (SLA),
C                            KINCAID D. (U TEXAS), KROGH F. (JPL)
C  ***PURPOSE
C     DOT PRODUCT OF COMPLEX VECTORS, USES COMPLX CONJG OF FIRST VECTOR
C  ***DESCRIPTION
C                B L A S  SUBPROGRAM
C     DESCRIPTION OF PARAMETERS
C
C     --INPUT--
C        N  NUMBER OF ELEMENTS IN INPUT VECTOR(S)
C       CX  COMPLEX VECTOR WITH N ELEMENTS
C     INCX  STORAGE SPACING BETWEEN ELEMENTS OF CX
C       CY  COMPLEX VECTOR WITH N ELEMENTS
C     INCY  STORAGE SPACING BETWEEN ELEMENTS OF CY
C
C     --OUTPUT--
C     CDOTC  COMPLEX RESULT (ZERO IF N.LE.0)
C
C     RETURNS THE DOT PRODUCT FOR COMPLEX CX AND CY, USES CONJUGATE(CX)
C     CDOTC = SUM FOR I = 0 TO N-1 OF CONJ(CX(LX+I*INCX))*CY(LY+I*INCY)
C     WHERE LX = 1 IF INCX .GE. 0, ELSE LX = (-INCX)*N, AND LY IS
C     DEFINED IN A SIMILAR WAY USING INCY.
C
C
C  ***REFERENCES
C     LAWSON C.L., HANSON R.J., KINCAID D.R., KROGH F.T.,
C     BASIC LINEAR ALGEBRA SUBPROGRAMS FOR FORTRAN USAGE*,
C     ALGORITHM NO. 539, TRANSACTIONS ON MATHEMATICAL SOFTWARE,
C     VOLUME 5, NUMBER 3, SEPTEMBER 1979, 308-323
C     ROUTINES CALLED   (NONE)
C  ***END PROLOGUE  CDOTC
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 CX(*),CY(*)
C     FIRST EXECUTABLE STATEMENT  CDOTC
      CDOTC=(0.,0.)
      IF (N.LE.0) RETURN
      IF (INCX.EQ.INCY.AND.INCX.GT.0) GO TO 2
      KX=1
      KY=1
      IF (INCX.LT.0) KX=1+(1-N)*INCX
      IF (INCY.LT.0) KY=1+(1-N)*INCY
      DO 1 I=1,N
      CDOTC=CDOTC+DCONJG(CX(KX))*CY(KY)
      KX=KX+INCX
      KY=KY+INCY
1     CONTINUE
      RETURN
2     CONTINUE
      NS=N*INCX
      DO 3 I=1,NS,INCX
      CDOTC=DCONJG(CX(I))*CY(I)+CDOTC
3     CONTINUE
      RETURN
      END
      SUBROUTINE CQRDC (X,LDX,N,P,QRAUX,JPVT,WORK,JOB)
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER LDX,N,P,JOB
      INTEGER JPVT(*)
      COMPLEX*16 X(LDX,*),QRAUX(*),WORK(*)
C
C     CQRDC USES HOUSEHOLDER TRANSFORMATIONS TO COMPUTE THE QR
C     FACTORIZATION OF AN N BY P MATRIX X.  COLUMN PIVOTING
C     BASED ON THE 2-NORMS OF THE REDUCED COLUMNS MAY BE
C     PERFORMED AT THE USERS OPTION.
C
C     ON ENTRY
C
C        X       COMPLEX(LDX,P), WHERE LDX .GE. N.
C                X CONTAINS THE MATRIX WHOSE DECOMPOSITION IS TO BE
C                COMPUTED.
C
C        LDX     INTEGER.
C                LDX IS THE LEADING DIMENSION OF THE ARRAY X.
C
C        N       INTEGER.
C                N IS THE NUMBER OF ROWS OF THE MATRIX X.
C
C        P       INTEGER.
C                P IS THE NUMBER OF COLUMNS OF THE MATRIX X.
C
C        JPVT    INTEGER(P).
C                JPVT CONTAINS INTEGERS THAT CONTROL THE SELECTION
C                OF THE PIVOT COLUMNS.  THE K-TH COLUMN X(K) OF X
C                IS PLACED IN ONE OF THREE CLASSES ACCORDING TO THE
C                VALUE OF JPVT(K).
C
C                   IF JPVT(K) .GT. 0, THEN X(K) IS AN INITIAL
C                                      COLUMN.
C
C                   IF JPVT(K) .EQ. 0, THEN X(K) IS A FREE COLUMN.
C
C                   IF JPVT(K) .LT. 0, THEN X(K) IS A FINAL COLUMN.
C
C                BEFORE THE DECOMPOSITION IS COMPUTED, INITIAL COLUMNS
C                ARE MOVED TO THE BEGINNING OF THE ARRAY X AND FINAL
C                COLUMNS TO THE END.  BOTH INITIAL AND FINAL COLUMNS
C                ARE FROZEN IN PLACE DURING THE COMPUTATION AND ONLY
C                FREE COLUMNS ARE MOVED.  AT THE K-TH STAGE OF THE
C                REDUCTION, IF X(K) IS OCCUPIED BY A FREE COLUMN
C                IT IS INTERCHANGED WITH THE FREE COLUMN OF LARGEST
C                REDUCED NORM.  JPVT IS NOT REFERENCED IF
C                JOB .EQ. 0.
C
C        WORK    COMPLEX(P).
C                WORK IS A WORK ARRAY.  WORK IS NOT REFERENCED IF
C                JOB .EQ. 0.
C
C        JOB     INTEGER.
C                JOB IS AN INTEGER THAT INITIATES COLUMN PIVOTING.
C                IF JOB .EQ. 0, NO PIVOTING IS DONE.
C                IF JOB .NE. 0, PIVOTING IS DONE.
C
C     ON RETURN
C
C        X       X CONTAINS IN ITS UPPER TRIANGLE THE UPPER
C                TRIANGULAR MATRIX R OF THE QR FACTORIZATION.
C                BELOW ITS DIAGONAL X CONTAINS INFORMATION FROM
C                WHICH THE UNITARY PART OF THE DECOMPOSITION
C                CAN BE RECOVERED.  NOTE THAT IF PIVOTING HAS
C                BEEN REQUESTED, THE DECOMPOSITION IS NOT THAT
C                OF THE ORIGINAL MATRIX X BUT THAT OF X
C                WITH ITS COLUMNS PERMUTED AS DESCRIBED BY JPVT.
C
C        QRAUX   COMPLEX(P).
C                QRAUX CONTAINS FURTHER INFORMATION REQUIRED TO RECOVER
C                THE UNITARY PART OF THE DECOMPOSITION.
C
C        JPVT    JPVT(K) CONTAINS THE INDEX OF THE COLUMN OF THE
C                ORIGINAL MATRIX THAT HAS BEEN INTERCHANGED INTO
C                THE K-TH COLUMN, IF PIVOTING WAS REQUESTED.
C
C     LINPACK. THIS VERSION DATED 08/14/78 .
C     G.W. STEWART, UNIVERSITY OF MARYLAND, ARGONNE NATIONAL LAB.
C
C     CQRDC USES THE FOLLOWING FUNCTIONS AND SUBPROGRAMS.
C
C     BLAS CAXPY,CDOTC,CSCAL,CSWAP,SCNRM2
C     FORTRAN ABS,AIMAG,AMAX1,ABS,DCMPLX,CSQRT,MIN0,REAL
C
C     INTERNAL VARIABLES
C
      INTEGER J,JP,L,LP1,LUP,MAXJ,PL,PU
      REAL*8 MAXNRM,SCNRM2,TT
      COMPLEX*16 CDOTC,NRMXL,T
      LOGICAL NEGJ,SWAPJ
C
      COMPLEX*16 CSIGN,ZDUM,ZDUM1,ZDUM2
      REAL*8 CABS1
      CSIGN(ZDUM1,ZDUM2)=ABS(ZDUM1)*(ZDUM2/ABS(ZDUM2))
      CABS1(ZDUM)=ABS(DREAL(ZDUM))+ABS(DIMAG(ZDUM))
C
      PL=1
      PU=0
      IF (JOB.EQ.0) GO TO 6
C
C        PIVOTING HAS BEEN REQUESTED.  REARRANGE THE COLUMNS
C        ACCORDING TO JPVT.
C
      DO 2 J=1,P
      SWAPJ=JPVT(J).GT.0
      NEGJ=JPVT(J).LT.0
      JPVT(J)=J
      IF (NEGJ) JPVT(J)=-J
      IF (.NOT.SWAPJ) GO TO 1
      IF (J.NE.PL) CALL CSWAP (N,X(1,PL),1,X(1,J),1)
      JPVT(J)=JPVT(PL)
      JPVT(PL)=J
      PL=PL+1
1     CONTINUE
2     CONTINUE
      PU=P
      DO 5 JJ=1,P
      J=P-JJ+1
      IF (JPVT(J).GE.0) GO TO 4
      JPVT(J)=-JPVT(J)
      IF (J.EQ.PU) GO TO 3
      CALL CSWAP (N,X(1,PU),1,X(1,J),1)
      JP=JPVT(PU)
      JPVT(PU)=JPVT(J)
      JPVT(J)=JP
3     CONTINUE
      PU=PU-1
4     CONTINUE
5     CONTINUE
6     CONTINUE
C
C     COMPUTE THE NORMS OF THE FREE COLUMNS.
C
      IF (PU.LT.PL) GO TO 8
      DO 7 J=PL,PU
      QRAUX(J)=DCMPLX(SCNRM2(N,X(1,J),1),0.0D0)
      WORK(J)=QRAUX(J)
7     CONTINUE
8     CONTINUE
C
C     PERFORM THE HOUSEHOLDER REDUCTION OF X.
C
      LUP=MIN0(N,P)
      DO 20 L=1,LUP
      IF (L.LT.PL.OR.L.GE.PU) GO TO 12
C
C           LOCATE THE COLUMN OF LARGEST NORM AND BRING IT
C           INTO THE PIVOT POSITION.
C
      MAXNRM=0.0E0
      MAXJ=L
      DO 10 J=L,PU
      IF (DREAL(QRAUX(J)).LE.MAXNRM) GO TO 9
      MAXNRM=DREAL(QRAUX(J))
      MAXJ=J
9     CONTINUE
10    CONTINUE
      IF (MAXJ.EQ.L) GO TO 11
      CALL CSWAP (N,X(1,L),1,X(1,MAXJ),1)
      QRAUX(MAXJ)=QRAUX(L)
      WORK(MAXJ)=WORK(L)
      JP=JPVT(MAXJ)
      JPVT(MAXJ)=JPVT(L)
      JPVT(L)=JP
11    CONTINUE
12    CONTINUE
      QRAUX(L)=(0.0E0,0.0E0)
      IF (L.EQ.N) GO TO 19
C
C           COMPUTE THE HOUSEHOLDER TRANSFORMATION FOR COLUMN L.
C
      NRMXL=DCMPLX(SCNRM2(N-L+1,X(L,L),1),0.0D0)
      IF (CABS1(NRMXL).EQ.0.0E0) GO TO 18
      IF (CABS1(X(L,L)).NE.0.0E0) NRMXL=CSIGN(NRMXL,X(L,L))
      CALL CSCAL (N-L+1,(1.0E0,0.0E0)/NRMXL,X(L,L),1)
      X(L,L)=(1.0E0,0.0E0)+X(L,L)
C
C              APPLY THE TRANSFORMATION TO THE REMAINING COLUMNS,
C              UPDATING THE NORMS.
C
      LP1=L+1
      IF (P.LT.LP1) GO TO 17
      DO 16 J=LP1,P
      T=-CDOTC(N-L+1,X(L,L),1,X(L,J),1)/X(L,L)
      CALL CAXPY (N-L+1,T,X(L,L),1,X(L,J),1)
      IF (J.LT.PL.OR.J.GT.PU) GO TO 15
      IF (CABS1(QRAUX(J)).EQ.0.0E0) GO TO 15
      TT=1.0E0-(ABS(X(L,J))/DREAL(QRAUX(J)))**2
      TT=MAX(TT,0.0D0)
      T=DCMPLX(TT,0.0D0)
      TT=1.0E0+0.05E0*TT*(DREAL(QRAUX(J))/DREAL(WORK(J)))**2
      IF (TT.EQ.1.0E0) GO TO 13
      QRAUX(J)=QRAUX(J)*SQRT(T)
      GO TO 14
13    CONTINUE
      QRAUX(J)=DCMPLX(SCNRM2(N-L,X(L+1,J),1),0.0D0)
      WORK(J)=QRAUX(J)
14    CONTINUE
15    CONTINUE
16    CONTINUE
17    CONTINUE
C
C              SAVE THE TRANSFORMATION.
C
      QRAUX(L)=X(L,L)
      X(L,L)=-NRMXL
18    CONTINUE
19    CONTINUE
20    CONTINUE
      RETURN
      END
      SUBROUTINE CQRSL (X,LDX,N,K,QRAUX,Y,QY,QTY,B,RSD,XB,JOB,INFO)
      IMPLICIT REAL*8 (A-H,O-Z)
      INTEGER LDX,N,K,JOB,INFO
      COMPLEX*16 X(LDX,*),QRAUX(*),Y(*),QY(*),QTY(*),B(*),RSD(*),XB(*)
C
C     CQRSL APPLIES THE OUTPUT OF CQRDC TO COMPUTE COORDINATE
C     TRANSFORMATIONS, PROJECTIONS, AND LEAST SQUARES SOLUTIONS.
C     FOR K .LE. MIN(N,P), LET XK BE THE MATRIX
C
C            XK = (X(JPVT(1)),X(JPVT(2)), ... ,X(JPVT(K)))
C
C     FORMED FROM COLUMNNS JPVT(1), ... ,JPVT(K) OF THE ORIGINAL
C     N X P MATRIX X THAT WAS INPUT TO CQRDC (IF NO PIVOTING WAS
C     DONE, XK CONSISTS OF THE FIRST K COLUMNS OF X IN THEIR
C     ORIGINAL ORDER).  CQRDC PRODUCES A FACTORED UNITARY MATRIX Q
C     AND AN UPPER TRIANGULAR MATRIX R SUCH THAT
C
C              XK = Q * (R)
C                       (0)
C
C     THIS INFORMATION IS CONTAINED IN CODED FORM IN THE ARRAYS
C     X AND QRAUX.
C
C     ON ENTRY
C
C        X      COMPLEX(LDX,P).
C               X CONTAINS THE OUTPUT OF CQRDC.
C
C        LDX    INTEGER.
C               LDX IS THE LEADING DIMENSION OF THE ARRAY X.
C
C        N      INTEGER.
C               N IS THE NUMBER OF ROWS OF THE MATRIX XK.  IT MUST
C               HAVE THE SAME VALUE AS N IN CQRDC.
C
C        K      INTEGER.
C               K IS THE NUMBER OF COLUMNS OF THE MATRIX XK.  K
C               MUST NNOT BE GREATER THAN MIN(N,P), WHERE P IS THE
C               SAME AS IN THE CALLING SEQUENCE TO CQRDC.
C
C        QRAUX  COMPLEX(P).
C               QRAUX CONTAINS THE AUXILIARY OUTPUT FROM CQRDC.
C
C        Y      COMPLEX(N)
C               Y CONTAINS AN N-VECTOR THAT IS TO BE MANIPULATED
C               BY CQRSL.
C
C        JOB    INTEGER.
C               JOB SPECIFIES WHAT IS TO BE COMPUTED.  JOB HAS
C               THE DECIMAL EXPANSION ABCDE, WITH THE FOLLOWING
C               MEANING.
C
C                    IF A.NE.0, COMPUTE QY.
C                    IF B,C,D, OR E .NE. 0, COMPUTE QTY.
C                    IF C.NE.0, COMPUTE B.
C                    IF D.NE.0, COMPUTE RSD.
C                    IF E.NE.0, COMPUTE XB.
C
C               NOTE THAT A REQUEST TO COMPUTE B, RSD, OR XB
C               AUTOMATICALLY TRIGGERS THE COMPUTATION OF QTY, FOR
C               WHICH AN ARRAY MUST BE PROVIDED IN THE CALLING
C               SEQUENCE.
C
C     ON RETURN
C
C        QY     COMPLEX(N).
C               QY CONNTAINS Q*Y, IF ITS COMPUTATION HAS BEEN
C               REQUESTED.
C
C        QTY    COMPLEX(N).
C               QTY CONTAINS CTRANS(Q)*Y, IF ITS COMPUTATION HAS
C               BEEN REQUESTED.  HERE CTRANS(Q) IS THE CONJUGATE
C               TRANSPOSE OF THE MATRIX Q.
C
C        B      COMPLEX(K)
C               B CONTAINS THE SOLUTION OF THE LEAST SQUARES PROBLEM
C
C                    MINIMIZE NORM2(Y - XK*B),
C
C               IF ITS COMPUTATION HAS BEEN REQUESTED.  (NOTE THAT
C               IF PIVOTING WAS REQUESTED IN CQRDC, THE J-TH
C               COMPONENT OF B WILL BE ASSOCIATED WITH COLUMN JPVT(J)
C               OF THE ORIGINAL MATRIX X THAT WAS INPUT INTO CQRDC.)
C
C        RSD    COMPLEX(N).
C               RSD CONTAINS THE LEAST SQUARES RESIDUAL Y - XK*B,
C               IF ITS COMPUTATION HAS BEEN REQUESTED.  RSD IS
C               ALSO THE ORTHOGONAL PROJECTION OF Y ONTO THE
C               ORTHOGONAL COMPLEMENT OF THE COLUMN SPACE OF XK.
C
C        XB     COMPLEX(N).
C               XB CONTAINS THE LEAST SQUARES APPROXIMATION XK*B,
C               IF ITS COMPUTATION HAS BEEN REQUESTED.  XB IS ALSO
C               THE ORTHOGONAL PROJECTION OF Y ONTO THE COLUMN SPACE
C               OF X.
C
C        INFO   INTEGER.
C               INFO IS ZERO UNLESS THE COMPUTATION OF B HAS
C               BEEN REQUESTED AND R IS EXACTLY SINGULAR.  IN
C               THIS CASE, INFO IS THE INDEX OF THE FIRST ZERO
C               DIAGONAL ELEMENT OF R AND B IS LEFT UNALTERED.
C
C     THE PARAMETERS QY, QTY, B, RSD, AND XB ARE NOT REFERENCED
C     IF THEIR COMPUTATION IS NOT REQUESTED AND IN THIS CASE
C     CAN BE REPLACED BY DUMMY VARIABLES IN THE CALLING PROGRAM.
C     TO SAVE STORAGE, THE USER MAY IN SOME CASES USE THE SAME
C     ARRAY FOR DIFFERENT PARAMETERS IN THE CALLING SEQUENCE.  A
C     FREQUENTLY OCCURING EXAMPLE IS WHEN ONE WISHES TO COMPUTE
C     ANY OF B, RSD, OR XB AND DOES NOT NEED Y OR QTY.  IN THIS
C     CASE ONE MAY IDENTIFY Y, QTY, AND ONE OF B, RSD, OR XB, WHILE
C     PROVIDING SEPARATE ARRAYS FOR ANYTHING ELSE THAT IS TO BE
C     COMPUTED.  THUS THE CALLING SEQUENCE
C
C          CALL CQRSL(X,LDX,N,K,QRAUX,Y,DUM,Y,B,Y,DUM,110,INFO)
C
C     WILL RESULT IN THE COMPUTATION OF B AND RSD, WITH RSD
C     OVERWRITING Y.  MORE GENERALLY, EACH ITEM IN THE FOLLOWING
C     LIST CONTAINS GROUPS OF PERMISSIBLE IDENTIFICATIONS FOR
C     A SINGLE CALLINNG SEQUENCE.
C
C          1. (Y,QTY,B) (RSD) (XB) (QY)
C
C          2. (Y,QTY,RSD) (B) (XB) (QY)
C
C          3. (Y,QTY,XB) (B) (RSD) (QY)
C
C          4. (Y,QY) (QTY,B) (RSD) (XB)
C
C          5. (Y,QY) (QTY,RSD) (B) (XB)
C
C          6. (Y,QY) (QTY,XB) (B) (RSD)
C
C     IN ANY GROUP THE VALUE RETURNED IN THE ARRAY ALLOCATED TO
C     THE GROUP CORRESPONDS TO THE LAST MEMBER OF THE GROUP.
C
C     LINPACK. THIS VERSION DATED 08/14/78 .
C     G.W. STEWART, UNIVERSITY OF MARYLAND, ARGONNE NATIONAL LAB.
C
C     CQRSL USES THE FOLLOWING FUNCTIONS AND SUBPROGRAMS.
C
C     BLAS CAXPY,CCOPY,CDOTC
C     FORTRAN ABS,AIMAG,MIN0,MOD,REAL
C
C     INTERNAL VARIABLES
C
      INTEGER I,J,JJ,JU,KP1
      COMPLEX*16 CDOTC,T,TEMP
      LOGICAL CB,CQY,CQTY,CR,CXB
C
      COMPLEX*16 ZDUM
      REAL*8 CABS1
      CABS1(ZDUM)=ABS(DREAL(ZDUM))+ABS(DIMAG(ZDUM))
C
C     SET INFO FLAG.
C
      INFO=0
C
C     DETERMINE WHAT IS TO BE COMPUTED.
C
      CQY=JOB/10000.NE.0
      CQTY=MOD(JOB,10000).NE.0
      CB=MOD(JOB,1000)/100.NE.0
      CR=MOD(JOB,100)/10.NE.0
      CXB=MOD(JOB,10).NE.0
      JU=MIN0(K,N-1)
C
C     SPECIAL ACTION WHEN N=1.
C
      IF (JU.NE.0) GO TO 4
      IF (CQY) QY(1)=Y(1)
      IF (CQTY) QTY(1)=Y(1)
      IF (CXB) XB(1)=Y(1)
      IF (.NOT.CB) GO TO 3
      IF (CABS1(X(1,1)).NE.0.0E0) GO TO 1
      INFO=1
      GO TO 2
1     CONTINUE
      B(1)=Y(1)/X(1,1)
2     CONTINUE
3     CONTINUE
      IF (CR) RSD(1)=(0.0E0,0.0E0)
      GO TO 25
4     CONTINUE
C
C        SET UP TO COMPUTE QY OR QTY.
C
      IF (CQY) CALL CCOPY (N,Y,1,QY,1)
      IF (CQTY) CALL CCOPY (N,Y,1,QTY,1)
      IF (.NOT.CQY) GO TO 7
C
C           COMPUTE QY.
C
      DO 6 JJ=1,JU
      J=JU-JJ+1
      IF (CABS1(QRAUX(J)).EQ.0.0E0) GO TO 5
      TEMP=X(J,J)
      X(J,J)=QRAUX(J)
      T=-CDOTC(N-J+1,X(J,J),1,QY(J),1)/X(J,J)
      CALL CAXPY (N-J+1,T,X(J,J),1,QY(J),1)
      X(J,J)=TEMP
5     CONTINUE
6     CONTINUE
7     CONTINUE
      IF (.NOT.CQTY) GO TO 10
C
C           COMPUTE CTRANS(Q)*Y.
C
      DO 9 J=1,JU
      IF (CABS1(QRAUX(J)).EQ.0.0E0) GO TO 8
      TEMP=X(J,J)
      X(J,J)=QRAUX(J)
      T=-CDOTC(N-J+1,X(J,J),1,QTY(J),1)/X(J,J)
      CALL CAXPY (N-J+1,T,X(J,J),1,QTY(J),1)
      X(J,J)=TEMP
8     CONTINUE
9     CONTINUE
10    CONTINUE
C
C        SET UP TO COMPUTE B, RSD, OR XB.
C
      IF (CB) CALL CCOPY (K,QTY,1,B,1)
      KP1=K+1
      IF (CXB) CALL CCOPY (K,QTY,1,XB,1)
      IF (CR.AND.K.LT.N) CALL CCOPY (N-K,QTY(KP1),1,RSD(KP1),1)
      IF (.NOT.CXB.OR.KP1.GT.N) GO TO 12
      DO 11 I=KP1,N
      XB(I)=(0.0E0,0.0E0)
11    CONTINUE
12    CONTINUE
      IF (.NOT.CR) GO TO 14
      DO 13 I=1,K
      RSD(I)=(0.0E0,0.0E0)
13    CONTINUE
14    CONTINUE
      IF (.NOT.CB) GO TO 19
C
C           COMPUTE B.
C
      DO 17 JJ=1,K
      J=K-JJ+1
      IF (CABS1(X(J,J)).NE.0.0E0) GO TO 15
      INFO=J
C           ......EXIT
      GO TO 18
15    CONTINUE
      B(J)=B(J)/X(J,J)
      IF (J.EQ.1) GO TO 16
      T=-B(J)
      CALL CAXPY (J-1,T,X(1,J),1,B,1)
16    CONTINUE
17    CONTINUE
18    CONTINUE
19    CONTINUE
      IF (.NOT.CR.AND..NOT.CXB) GO TO 24
C
C           COMPUTE RSD OR XB AS REQUIRED.
C
      DO 23 JJ=1,JU
      J=JU-JJ+1
      IF (CABS1(QRAUX(J)).EQ.0.0E0) GO TO 22
      TEMP=X(J,J)
      X(J,J)=QRAUX(J)
      IF (.NOT.CR) GO TO 20
      T=-CDOTC(N-J+1,X(J,J),1,RSD(J),1)/X(J,J)
      CALL CAXPY (N-J+1,T,X(J,J),1,RSD(J),1)
20    CONTINUE
      IF (.NOT.CXB) GO TO 21
      T=-CDOTC(N-J+1,X(J,J),1,XB(J),1)/X(J,J)
      CALL CAXPY (N-J+1,T,X(J,J),1,XB(J),1)
21    CONTINUE
      X(J,J)=TEMP
22    CONTINUE
23    CONTINUE
24    CONTINUE
25    CONTINUE
      RETURN
      END
      SUBROUTINE CSCAL (N,CA,CX,INCX)
C  ***BEGIN PROLOGUE  CSCAL
C     REVISION DATE  811015   (YYMMDD)
C     CATEGORY NO.  F1A, M2
C     KEYWORDS  COMPLEX,BLAS,VECTOR,SCALE
C     DATE WRITTEN  OCTOBER 1979
C     AUTHOR LAWSON C. (JPL),HANSON R. (SLA),
C                            KINCAID D. (U TEXAS), KROGH F. (JPL)
C  ***PURPOSE
C     COMPLEX VECTOR SCALE X = A*X
C  ***DESCRIPTION
C                B L A S  SUBPROGRAM
C     DESCRIPTION OF PARAMETERS
C
C     --INPUT--
C        N  NUMBER OF ELEMENTS IN INPUT VECTOR(S)
C       CA  COMPLEX SCALE FACTOR
C       CX  COMPLEX VECTOR WITH N ELEMENTS
C     INCX  STORAGE SPACING BETWEEN ELEMENTS OF CX
C
C     --OUTPUT--
C     CSCAL  COMPLEX RESULT (UNCHANGED IF N.LE.0)
C
C     REPLACE COMPLEX CX BY COMPLEX CA*CX.
C     FOR I = 0 TO N-1, REPLACE CX(1+I*INCX) WITH  CA * CX(1+I*INCX)
C
C
C  ***REFERENCES
C     LAWSON C.L., HANSON R.J., KINCAID D.R., KROGH F.T.,
C     BASIC LINEAR ALGEBRA SUBPROGRAMS FOR FORTRAN USAGE*,
C     ALGORITHM NO. 539, TRANSACTIONS ON MATHEMATICAL SOFTWARE,
C     VOLUME 5, NUMBER 3, SEPTEMBER 1979, 308-323
C     ROUTINES CALLED  (NONE)
C  ***END PROLOGUE  CSCAL
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 CA,CX(*)
C     FIRST EXECUTABLE STATEMENT  CSCAL
      IF (N.LE.0) RETURN
      NS=N*INCX
      DO 1 I=1,NS,INCX
      CX(I)=CA*CX(I)
1     CONTINUE
      RETURN
      END
      SUBROUTINE CSWAP (N,CX,INCX,CY,INCY)
C  ***BEGIN PROLOGUE  CSWAP
C     REVISION DATE  811015   (YYMMDD)
C     CATEGORY NO.  F1A
C     KEYWORDS  COMPLEX,BLAS,VECTOR,INTERCHANGE
C     DATE WRITTEN  OCTOBER 1979
C     AUTHOR LAWSON C. (JPL),HANSON R. (SLA),
C                            KINCAID D. (U TEXAS), KROGH F. (JPL)
C  ***PURPOSE
C     INTERCHANGE COMPLEX VECTORS
C  ***DESCRIPTION
C                B L A S  SUBPROGRAM
C     DESCRIPTION OF PARAMETERS
C
C     --INPUT--
C        N  NUMBER OF ELEMENTS IN INPUT VECTOR(S)
C       CX  COMPLEX VECTOR WITH N ELEMENTS
C     INCX  STORAGE SPACING BETWEEN ELEMENTS OF CX
C       CY  COMPLEX VECTOR WITH N ELEMENTS
C     INCY  STORAGE SPACING BETWEEN ELEMENTS OF CY
C
C     --OUTPUT--
C       CX  INPUT VECTOR CY (UNCHANGED IF N.LE.0)
C       CY  INPUT VECTOR CX (UNCHANGED IF N.LE.0)
C
C     INTERCHANGE COMPLEX CX AND COMPLEX CY
C     FOR I = 0 TO N-1, INTERCHANGE  CX(LX+I*INCX) AND CY(LY+I*INCY),
C     WHERE LX = 1 IF INCX .GT. 0, ELSE LX = (-INCX)*N, AND LY IS
C     DEFINED IN A SIMILAR WAY USING INCY.
C
C
C  ***REFERENCES
C     LAWSON C.L., HANSON R.J., KINCAID D.R., KROGH F.T.,
C     BASIC LINEAR ALGEBRA SUBPROGRAMS FOR FORTRAN USAGE*,
C     ALGORITHM NO. 539, TRANSACTIONS ON MATHEMATICAL SOFTWARE,
C     VOLUME 5, NUMBER 3, SEPTEMBER 1979, 308-323
C     ROUTINES CALLED  (NONE)
C  ***END PROLOGUE  CSWAP
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 CX(*),CY(*),CTEMP
C     FIRST EXECUTABLE STATEMENT  CSWAP
      IF (N.LE.0) RETURN
      IF (INCX.EQ.INCY.AND.INCX.GT.0) GO TO 2
      KX=1
      KY=1
      IF (INCX.LT.0) KX=1+(1-N)*INCX
      IF (INCY.LT.0) KY=1+(1-N)*INCY
      DO 1 I=1,N
      CTEMP=CX(KX)
      CX(KX)=CY(KY)
      CY(KY)=CTEMP
      KX=KX+INCX
      KY=KY+INCY
1     CONTINUE
      RETURN
2     CONTINUE
      NS=N*INCX
      DO 3 I=1,NS,INCX
      CTEMP=CX(I)
      CX(I)=CY(I)
      CY(I)=CTEMP
3     CONTINUE
      RETURN
      END
      SUBROUTINE EVLUB (RHOX,ZZX,ZPX,IQAX,ERV,EZV,ERH,EPH,EZH)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     SOMMERFELD INTEGRAL EVALUATION FOR E FIELD ACROSS INTERFACE.
C     EVALUA CONTROLS THE INTEGRATION CONTOUR IN THE COMPLEX LAMBDA
C     PLANE.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      SAVE
      COMPLEX*16 ERV,EZV,ERH,EPH,EZH,A,B,CK1,CK1SQ,CK2,CK2SQ,BK,SUM,CP1,
     &CP2,CP3,CKSM,CON1,CON2,CON3,XJK,EXJK,A1,A2,A3,A4,A5,B1,B2,B3,B4,
     &B5,C1,C2,C3,C4,C5,RF1,RF2,SDIR,CKDSQ,D12,FJ
      COMMON /CNTOUR/ A,B,BAEL
      COMMON /EVLCOM/ CKSM,CK1,CK1SQ,CK2,CK2SQ,CON1,CON2,CON3,TKMAG,TSMA
     &G,CKAR,CKAI,CKBR,CKBI,ZZ,ZP,RHO,JH,IQAZ
      COMMON /SRGAM/ A1,A2,A3,A4,A5,B1,B2,B3,B4,B5,C1,C2,C3,C4,C5
      DIMENSION SUM(6)
      DATA CK1R,CK1I,CK2R,CK2I,PTP,ACC/0.D0,0.D0,0.D0,0.D0,1.5707D0,
     &1.D-5/
      IF (DREAL(CK1).NE.CK1R.OR.DIMAG(CK1).NE.CK1I) GO TO 1
      IF (DREAL(CK2).NE.CK2R.OR.DIMAG(CK2).NE.CK2I) GO TO 1
      GO TO 4
C     SET CONSTANTS THAT DEPEND ON CK1 AND CK2 ONLY.
1     CK1R=DREAL(CK1)
      CK1I=DIMAG(CK1)
      CK2R=DREAL(CK2)
      CK2I=DIMAG(CK2)
      IF (CK2R.LT.CK1R) GO TO 2
      CKAR=CK1R
      CKAI=CK1I
      CKBR=CK2R
      CKBI=CK2I
      GO TO 3
2     CKAR=CK2R
      CKAI=CK2I
      CKBR=CK1R
      CKBI=CK1I
3     DEL=1.01*CKBR
      IF (DEL.LT.1.2*CKAR) DEL=1.2*CKAR
      CP3=DCMPLX(DEL,.95*CKBI)
      CK1SQ=CK1*CK1
      CK2SQ=CK2*CK2
      TSMAG=100.*(CKBR*CKBR+CKBI*CKBI)
      TKMAG=100.*SQRT(CKBR*CKBR+CKBI*CKBI)
      CKSM=CK1SQ+CK2SQ
      CON2=(CK1SQ-CK2SQ)/CKSM
      CON3=CK2SQ*CON2/CKSM
      ALOGA=-LOG(ACC)
C     SET CONSTANTS THAT DEPEND ON RHO, ZZ, AND ZP.
4     RHO=RHOX
      ZZ=ZZX
      ZP=ZPX
      ZMP=ZZ-ZP
      R=SQRT(RHO*RHO+ZMP*ZMP)
      FJ=(0.,1.)
      BAEL=0.
      DO 5 I=1,6
5     SUM(I)=(0.,0.)
      IQAZ=IQAX
      IF (IQAX.EQ.0) GO TO 6
      IF (R*ABS(CK2).GT.6.283185) IQAZ=0
      IF (R*CKBR.LT.1.E-5) GO TO 22
      IF (IQAZ.EQ.0) GO TO 6
      ZPSQ=ZP*ZP
      C1=CK2SQ-CK1SQ
      C2=C1*C1
      C3=CK2SQ*CK2SQ-CK1SQ*CK1SQ
      C4=CK2SQ*CK2SQ*CK2SQ-CK1SQ*CK1SQ*CK1SQ
      A1=ZP*C1/2.
      A2=ZPSQ*C2/8.
      A3=(C3+ZPSQ*C2*C1/6.)*ZP/8.
      A4=(C1*C3+ZPSQ*C2*C2/24.)*ZPSQ/16.
      A5=(C4+ZPSQ*C2*C3/4.+ZPSQ*ZPSQ*C2*C2*C1/240.)*ZP/16.
      B5=-C4/16.-(A2*CK2SQ/4.+A4)*CK2SQ/2.
      B4=A5-(A1*CK2SQ/4.+A3)*CK2SQ/2.
      B3=-C3/8.-A2*CK2SQ/2.+A4
      B2=A3-A1*CK2SQ/2.
      B1=-C1/2.+A2
      C5=C4/16.-(A2*CK1SQ/4.+A4)*CK1SQ/2.
      C4=A5-(A1*CK1SQ/4.+A3)*CK1SQ/2.
      C3=C3/8.-A2*CK1SQ/2.+A4
      C2=A3-A1*CK1SQ/2.
      C1=C1/2.+A2
6     DEL=ZMP
      IF (RHO.GT.DEL) DEL=RHO
      IF (ZZ.LT.0..OR.ZP.GT.0.) THEN
         WRITE(3,23)RHOX,ZZX,ZPX,IQAX
         STOP
      END IF
      IF (ZMP.LT..5*RHO) GO TO 10
C
C     BESSEL FUNCTION FORM OF SOMMERFELD INTEGRALS
C
      JH=0
      A=(0.,0.)
      DEL=1./DEL
      IF (DEL.LE.TKMAG) GO TO 8
      B=DCMPLX(.1*TKMAG,-.1*TKMAG)
      CALL ROM1 (6,SUM,.5D0,0,ICYES)
      A=B
      B=DCMPLX(DEL,-DEL)
      CALL ROM1 (6,SUM,.5D0,0,ICYES)
      GO TO 9
8     B=DCMPLX(DEL,-DEL)
      CALL ROM1 (6,SUM,.5D0,0,ICYES)
9     A=B
      IF(ZZ.GT.1.E-10)THEN
         BMAX1=CK2R+ALOGA/ZZ
      ELSE
         BMAX1=1.E10
      END IF
      IF(ABS(ZP).GT.1.E-10)THEN
         BMAX2=CK1R+ALOGA/ABS(ZP)
      ELSE
         BMAX2=1.E10
      END IF
      IF(BMAX1.GT.BMAX2)BMAX1=BMAX2
      B=DCMPLX(BMAX1,DIMAG(A))
      DZS=PTP*DEL/ABS(B-A)
      CALL ROM1 (6,SUM,DZS,1,ICYES)
      GO TO 18
C
C     HANKEL FUNCTION FORM OF SOMMERFELD INTEGRALS
C
10    JH=1
      RMIS=.06/R+.04
      DMIS=.8/(1.+ZMP/RHO)
      IF (RMIS.GT.DMIS) RMIS=DMIS
      RMIS=RMIS*CKAR
      DMIS=CKAR+RMIS
      IF (DMIS.GT.CKBR) DMIS=.5*(CKAR+CKBR)
      CP1=DCMPLX(CKAR-RMIS,CKAI-RMIS)
      CP2=DCMPLX(DMIS,CKAI-RMIS)
      XLI=ALOGA/RHO
      SDIR=DCMPLX(ZMP,RHO)/SQRT(RHO*RHO+ZMP*ZMP)
      DEL=PTP/DEL
      IF (DEL.GT.CKAR) DEL=CKAR
      CKDSQ=SQRT(CK1SQ-CK2SQ)
      D12=CKDSQ*DCMPLX(ZZ,-ZP)-FJ*(CK1-CK2)*RHO
      XLN=XLI-DREAL(D12)/RHO
      AAD12=ABS(DIMAG(D12))
      IF (AAD12.LT.12.57) GO TO 14
      IF (RHO.LT.1.E-5) GO TO 14
      IF (ZMP.LT.1.E-10) GO TO 11
      IF (RHO*AAD12.LT.4.*ZZ*DREAL(D12)) GO TO 14
      IF (XLN.LE.0.) GO TO 11
      A=-SQRT((0.D0,2.D0)*CK1)*ZP
      B=FJ*CK1*ZZ/CKDSQ+RHO
      BK=B*XLN-A*SQRT(XLN)
      RMIS=4.*ABS(DIMAG(BK))*DREAL(D12)
      IF (DREAL(BK)*AAD12.LT.RMIS) GO TO 14
      RMIS=DREAL(A)
      IF (RMIS*RMIS.GT.4.*DREAL(B)) GO TO 14
C     INTEGRATE AROUND CKA BRANCH CUT, THEN ALONG CKB BRANCH CUT.
11    A=CP2
      B=DCMPLX(DREAL(A),XLI)
      DZS=DEL/ABS(B-A)
      CALL ROM1 (6,SUM,DZS,1,ICYES)
      DO 12 I=1,6
12    SUM(I)=-SUM(I)
      B=CP1
      CALL ROM1 (6,SUM,1.D0,0,ICYES)
C     PATH TO -INFINITY
      SDIR=-DCONJG(SDIR)
      A=CP1
      B=A+SDIR*(XLI-DIMAG(A))/DIMAG(SDIR)
      DZS=DEL/ABS(B-A)
      CALL ROM1 (6,SUM,DZS,1,ICYES)
      DO 13 I=1,6
13    SUM(I)=-SUM(I)
      IF (XLN.LE.0.) GO TO 18
C     INTEGRATE CKB BRANCH CUT
      JH=2
      A=0.
      B=SQRT(XLN)
      DZS=SQRT(DEL)/ABS(B-A)
      CALL ROM1 (6,SUM,DZS,1,ICYES)
      GO TO 18
C     INTEGRATE BELOW BRANCH POINTS, THEN TO + INFINITY
14    A=CP2
      B=CP3
      IF(ABS(DIMAG(CP3)).GT.XLI)B=CP2+XLI*(CP3-CP2)/DIMAG(CP3-CP2)
      DZS=DEL/ABS(B-A)
      CALL ROM1 (6,SUM,DZS,1,ICYES)
      IF (ICYES.EQ.1) GO TO 15
      A=CP3
      B=A+SDIR*(XLN-DIMAG(A)+CKBI)/DIMAG(SDIR)
      DZS=DEL/ABS(B-A)
      CALL ROM1 (6,SUM,DZS,1,ICYES)
15    DO 16 I=1,6
16    SUM(I)=-SUM(I)
      A=CP2
      B=CP1
      CALL ROM1 (6,SUM,1.D0,0,ICYES)
C     PATH TO -INFINITY
      SDIR=-DCONJG(SDIR)
      A=CP1
      B=A+SDIR*(XLI-DIMAG(A))/DIMAG(SDIR)
      DZS=DEL/ABS(B-A)
      CALL ROM1 (6,SUM,DZS,1,ICYES)
      DO 17 I=1,6
17    SUM(I)=-SUM(I)
18    IF (IQAX.EQ.0.OR.IQAZ.NE.0) GO TO 19
C     SUBTRACT 1./R**2 AND 1./R**3 TERMS WHEN THE SINGULARITY IS TO
C     BE REMOVED BUT WAS NOT REMOVED IN THE INTEGRAND.
      XJK=(0.,-1.)*CK2
      RSQ=R*R
      EXJK=2.*EXP(-XJK*R)/(RSQ*R*(CK1SQ+CK2SQ))
      RF1=3./RSQ+3.*XJK/R-CK2SQ
      RF2=XJK*R+1.
      SUM(1)=SUM(1)-RHO*ZMP*RF1*EXJK
      SUM(2)=SUM(2)-(ZMP*ZMP*RF1-RF2+CK2SQ*RSQ)*EXJK
      SUM(3)=SUM(3)-(RHO*RHO*RF1-RF2)*EXJK
      SUM(4)=SUM(4)+RF2*EXJK
      SUM(5)=SUM(5)+RHO*ZMP*RF1*EXJK
C     COMBINE TERMS TO OBTAIN (FIELD)*R.  CONJUGATE SINCE NEC USES
C     EXP(+JWT).
19    ERV=DCONJG(CON1*SUM(1))*R
      EZV=DCONJG(CON1*SUM(2))*R
      ERH=DCONJG(CON1*(SUM(3)+SUM(6)))*R
      EPH=-DCONJG(CON1*(SUM(4)+SUM(6)))*R
      EZH=-DCONJG(CON1*SUM(5))*R
      IF (IQAX.EQ.0) RETURN
C     SUBTRACT (1./R TERMS)*R WHEN THE SINGULARITY IS TO BE REMOVED.
      STH=ZMP/R
      CTH=RHO/R
      IF (CTH.LT.0.1) GO TO 20
      SF1=(1.-STH)/CTH
      SF2=SF1/CTH
      GO TO 21
20    SF2=RHO/ZMP
      SF2=.5*(1.-.25*SF2*SF2)/ZMP
      SF1=RHO*SF2
      SF2=R*SF2
21    SF3=STH-SF2
      SFAC=ZP/R
      EXJK=EXP(FJ*CK2*R)*CON1
      ERV=ERV-DCONJG(EXJK*(CON3*SF1-CON2*SFAC*CTH))
      EZV=EZV-DCONJG(EXJK*(CON3-CON2*SFAC*STH))
      ERH=ERH-DCONJG(EXJK*(CON3*(SF2-1.)+CON2*SFAC*SF3+1.))
      EPH=EPH-DCONJG(-EXJK*((-CON3+CON2*SFAC)*SF2+1.))
      EZH=EZH-DCONJG(-EXJK*(CON3*CK1SQ/CK2SQ*SF1+CON2*SFAC*CTH))
      RETURN
22    ERV=0.
      EZV=0.
      ERH=0.
      EPH=0.
      EZH=0.
      RETURN
C
23    FORMAT (' EVLUB: ERROR - RHO, ZZ, ZP, IQAX =',1P3E12.5,I5)
      END
      SUBROUTINE LAMBDA (T,XLAM,DXLAM)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     COMPUTE INTEGRATION PARAMETER XLAM=LAMBDA FROM PARAMETER T.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 A,B,XLAM,DXLAM
      COMMON /CNTOUR/ A,B,BAEL
      DXLAM=B-A
      XLAM=A+DXLAM*T
      RETURN
      END
      SUBROUTINE RMSRS (IEQ,Y,RA,RMR,RMRR,INF,IC)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     RMSRC COMPUTES THE RMS VALUES OF THE RESIDUALS FROM THE LEAST-
C     SQUARES SOLUTION.
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 Y,RA
      DIMENSION Y(*), RA(*)
      IF (INF.NE.0) THEN
         WRITE(3,3)IC
         STOP
      END IF
      RMR=0.
      RMRR=0.
      YMAX=0.
      DO 2 I=1,IEQ
      RMS=DREAL(RA(I)*DCONJG(RA(I)))
      RMR=RMR+RMS
      YMS=DREAL(Y(I)*DCONJG(Y(I)))
      IF (YMS.LT.1.E-20) YMS=1.E-20
      IF (YMS.GT.YMAX) YMAX=YMS
2     RMRR=RMRR+RMS/YMS
      RMR=SQRT(RMR/(IEQ*YMAX))
      RMRR=SQRT(RMRR/IEQ)
      RETURN
C
3     FORMAT (' RMSRS: ERROR IN L. S. SOLUTION FOR COMPONENT',I3)
      END
      SUBROUTINE ROM1 (N,SUM,DZS,ICONV,ICYES)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     ROM1 INTEGRATES THE 6 SOMMERFELD INTEGRALS FROM A TO B IN LAMBDA.
C     THE METHOD OF VARIABLE INTERVAL WIDTH ROMBERG INTEGRATION IS USED.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 A,B,SUM,G1,G2,G3,G4,G5,T00,T01,T10,T02,T11,T20
      COMMON /CNTOUR/ A,B,BAEL
      DIMENSION SUM(6), G1(6), G2(6), G3(6), G4(6), G5(6), T01(6), T10(6
     &), T20(6)
      DATA DZMN,DZMX,RX,RXL,RC/1.D-6,.9999D0,.5D-3,.5D-4,1.D-4/
      LSTEP=0
      ICYES=0
      Z=0.
      ZE=1.
      EPS=1.E-6
      BA=ABS(B-A)
      DZ=DZS
      CALL SAOB (Z,G1)
1     IF (Z+DZ.GT.ZE) DZ=ZE-Z
      DZOT=DZ*.5
      CALL SAOB (Z+DZOT,G3)
      CALL SAOB (Z+DZ,G5)
2     BAZ=(BAEL+BA*(Z+DZ))/(DZ*BA)
      TRM=0.
      DO 3 I=1,N
      T00=(G1(I)+G5(I))*DZOT
      T01(I)=(T00+DZ*G3(I))*.5
      T10(I)=(4.*T01(I)-T00)/3.
C     TEST CONVERGENCE OF 3 POINT ROMBERG RESULT
      CALL TESTC (T01(I),T10(I),SUM(I),TR)
      IF (TR.GT.TRM) TRM=TR
3     CONTINUE
      TRM=TRM*BAZ
      IF (TRM.GT.RX) GO TO 6
      TRM=0.
      DO 4 I=1,N
4     SUM(I)=SUM(I)+T10(I)
      IF (ICONV.EQ.0) GO TO 11
      TRX=RC/BAZ
      DO 5 I=1,N
      IF (ABS(T10(I)).GT.TRX*ABS(SUM(I))) GO TO 11
5     CONTINUE
      ICYES=1
      Z=Z+DZ
      GO TO 17
6     CALL SAOB (Z+DZ*.25,G2)
      CALL SAOB (Z+DZ*.75,G4)
      TRM=0.
      DO 7 I=1,N
      T02=(T01(I)+DZOT*(G2(I)+G4(I)))*.5
      T11=(4.*T02-T01(I))/3.
      T20(I)=(16.*T11-T10(I))/15.
C     TEST CONVERGENCE OF 5 POINT ROMBERG RESULT
      CALL TESTC (T11,T20(I),SUM(I),TR)
      IF (TR.GT.TRM) TRM=TR
7     CONTINUE
      TRM=TRM*BAZ
      IF (TRM.GT.RX) GO TO 13
8     DO 9 I=1,N
9     SUM(I)=SUM(I)+T20(I)
      IF (ICONV.EQ.0) GO TO 11
      TRX=RC/BAZ
      DO 10 I=1,N
      IF (ABS(T20(I)).GT.TRX*ABS(SUM(I))) GO TO 11
10    CONTINUE
      ICYES=1
      Z=Z+DZ
      GO TO 17
11    Z=Z+DZ
      IF (ABS(Z-ZE).LT.EPS) GO TO 17
      DO 12 I=1,N
12    G1(I)=G5(I)
      IF (TRM.LT.RXL.AND.DZ.LT.DZMX) DZ=2.*DZ
      GO TO 1
13    IF (DZ.GE.DZMN) GO TO 15
      IF (LSTEP.EQ.1) GO TO 8
      LSTEP=1
      CALL LAMBDA (Z,T00,T11)
      WRITE(3,18)T00
      WRITE(3,19)Z,DZ,A,B
      DO 14 I=1,N
14    WRITE(3,19)G1(I),G2(I),G3(I),G4(I),G5(I)
      GO TO 8
15    DZ=.5*DZ
      DZOT=DZ*.5
      DO 16 I=1,N
      G5(I)=G3(I)
16    G3(I)=G2(I)
      GO TO 2
17    CONTINUE
      BAEL=BAEL+BA*Z
      RETURN
C
18    FORMAT (' ROM1: STEP SIZE LIMITED AT LAMBDA =',1P2E12.5)
19    FORMAT (1P10E12.5)
      END
      SUBROUTINE RZZFIT (IREG,IFUNC)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     RZZFIT SETS UP THE EQUATIONS FOR LEASE-SQUARES APPROXIMATION OF
C     THE SOMMERFELD INTEGRAL VALUES MATCHED AT THE POINTS SPECIFIED IN
C     COMMON/PTFIT/.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 CLS1,CLS2,CLS3,RE1,RE2,RE3,RE4,RE5,FAC1,FAC2,FAC3,FAC4,
     &FAC5,ERV,EZV,ERH,EPH,EZH,EXX,CFF1,CFF2,CFF3,CFF4,CFF5,CFF6,CFF7,
     &CFF8,CFF,XLA,GCK1,GCK1SQ,GCK2,GCK2SQ,CQRA,RA,DUM
      DIMENSION CLS1(100,32), CLS2(100,32), CLS3(100,32), RE1(100), RE2(
     &100), RE3(100), RE4(100), RE5(100), FF(24), CFF(8), CQRA(32), RA(1
     &00)
      COMMON /FPARM/ CFF1,CFF2,CFF3,CFF4,CFF5,CFF6,CFF7,CFF8,FF1,FF2,
     &FF3,FF4,FF5,FF6,FF7,FF8,FF9,FF10,FF11,FF12,FF13,FF14,FF15,FF16,
     &FF17,FF18,FF19,FF20,FF21,FF22,FF23,FF24,NFUNF,NFUNC
      COMMON /COFIT/ FAC1(32,3),FAC2(32,3),FAC3(32,3),FAC4(32,3),
     &FAC5(32,3),RKFAC,MFUNF(3),MFUNC(3)
      COMMON /PTFIT/ RH1,DRH,ZZ1,DZZ,ZP1,DZP,SRH1,DSRH,SZZ1,DSZZ,SZP1,
     &DSZP,RES1,RES2,RES3,RES4,RES5,REX1,REX2,REX3,REX4,REX5,NRH,NZZ,
     &NZP,NSRH,NSZZ,NSZP,IQAX
      COMMON /GPARM/ XLA(21,21),GCK1,GCK1SQ,GCK2,GCK2SQ,ZRAT,RHON
      EQUIVALENCE (FF(1),FF1), (CFF(1),CFF1)
      RKFAC=ABS(GCK2/GCK1)
      NFUNC=0
      IF (IFUNC.GT.0) NFUNC=4
      IEQ=0
      RHO=RH1-DRH
C     LOOP OVER FIRST SET OF POINTS TO BE FIT.
      DO 5 IRH=1,NRH
      RHO=RHO+DRH
      ZZ=ZZ1-DZZ
      DO 5 IZZ=1,NZZ
      ZZ=ZZ+DZZ
      ZPP=ZP1-DZP
      DO 5 IZP=1,NZP
      ZPP=ZPP+DZP
      ZP=-ZPP
      IEQ=IEQ+1
C     OBTAIN FUNCTION VALUES.
      CALL FNFIT (RHO,ZZ,ZP,STH,EXX)
      IX=2
      DO 2 I=1,NFUNF
      IX=IX+1
      CLS1(IEQ,I)=FF(I)*STH
      CLS3(IEQ,I)=FF(I)
      IF (IX.EQ.3) GO TO 1
      CLS2(IEQ,I)=FF(I)
      GO TO 2
1     CLS2(IEQ,I)=FF(I)*STH
      IX=0
2     CONTINUE
      IF (NFUNC.EQ.0) GO TO 4
      DO 3 I=1,NFUNC
      IC=I+NFUNF
      CLS1(IEQ,IC)=CFF(I)*STH
      CLS2(IEQ,IC)=CFF(I)
3     CLS3(IEQ,IC)=CFF(I)
4     CALL EVLUB (RHO,ZZ,ZP,IQAX,ERV,EZV,ERH,EPH,EZH)
      R=SQRT(RHO*RHO+(ZZ-ZP)**2)
      RKF=SQRT(RHO*RHO+(ZZ-ZP*RKFAC)**2)
      EXX=RKF/(R*EXX)
      RE1(IEQ)=ERV*EXX
      RE2(IEQ)=EZV*EXX
      RE3(IEQ)=ERH*EXX
      RE4(IEQ)=EPH*EXX
      RE5(IEQ)=EZH*EXX
5     CONTINUE
      IF (NSRH.EQ.0) GO TO 11
      RHO=SRH1-DSRH
C     LOOP OVER SECOND SET OF POINTS TO BE FIT.
      DO 10 IRH=1,NSRH
      RHO=RHO+DSRH
      ZZ=SZZ1-DSZZ
      DO 10 IZZ=1,NSZZ
      ZZ=ZZ+DSZZ
      ZPP=SZP1-DSZP
      DO 10 IZP=1,NSZP
      ZPP=ZPP+DSZP
      ZP=-ZPP
      IEQ=IEQ+1
      CALL FNFIT (RHO,ZZ,ZP,STH,EXX)
      IX=2
      DO 7 I=1,NFUNF
      IX=IX+1
      CLS1(IEQ,I)=FF(I)*STH
      CLS3(IEQ,I)=FF(I)
      IF (IX.EQ.3) GO TO 6
      CLS2(IEQ,I)=FF(I)
      GO TO 7
6     CLS2(IEQ,I)=FF(I)*STH
      IX=0
7     CONTINUE
      IF (NFUNC.EQ.0) GO TO 9
      DO 8 I=1,NFUNC
      IC=I+NFUNF
      CLS1(IEQ,IC)=CFF(I)*STH
      CLS2(IEQ,IC)=CFF(I)
8     CLS3(IEQ,IC)=CFF(I)
9     CALL EVLUB (RHO,ZZ,ZP,IQAX,ERV,EZV,ERH,EPH,EZH)
      R=SQRT(RHO*RHO+(ZZ-ZP)**2)
      RKF=SQRT(RHO*RHO+(ZZ-ZP*RKFAC)**2)
      EXX=RKF/(R*EXX)
      RE1(IEQ)=ERV*EXX
      RE2(IEQ)=EZV*EXX
      RE3(IEQ)=ERH*EXX
      RE4(IEQ)=EPH*EXX
      RE5(IEQ)=EZH*EXX
10    CONTINUE
C     LEAST SQUARES SOLUTION
11    NFUN=NFUNF+NFUNC
      MFUNF(IREG)=NFUNF
      MFUNC(IREG)=NFUNC
      CALL CQRDC (CLS1,100,IEQ,NFUN,CQRA,JDUM,DUM,0)
      CALL CQRSL (CLS1,100,IEQ,NFUN,CQRA,RE1,DUM,RA,FAC1(1,IREG),RA,DUM,
     &110,INF)
      CALL RMSRS (IEQ,RE1,RA,RES1,REX1,INF,1)
      CALL CQRSL (CLS1,100,IEQ,NFUN,CQRA,RE5,DUM,RA,FAC5(1,IREG),RA,DUM,
     &110,INF)
      CALL RMSRS (IEQ,RE5,RA,RES5,REX5,INF,5)
      CALL CQRDC (CLS2,100,IEQ,NFUN,CQRA,JDUM,DUM,0)
      CALL CQRSL (CLS2,100,IEQ,NFUN,CQRA,RE2,DUM,RA,FAC2(1,IREG),RA,DUM,
     &110,INF)
      CALL RMSRS (IEQ,RE2,RA,RES2,REX2,INF,2)
      CALL CQRDC (CLS3,100,IEQ,NFUN,CQRA,JDUM,DUM,0)
      CALL CQRSL (CLS3,100,IEQ,NFUN,CQRA,RE3,DUM,RA,FAC3(1,IREG),RA,DUM,
     &110,INF)
      CALL RMSRS (IEQ,RE3,RA,RES3,REX3,INF,3)
      CALL CQRSL (CLS3,100,IEQ,NFUN,CQRA,RE4,DUM,RA,FAC4(1,IREG),RA,DUM,
     &110,INF)
      CALL RMSRS (IEQ,RE4,RA,RES4,REX4,INF,4)
      RETURN
      END
      SUBROUTINE SAOB (T,ANS)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     SAOB COMPUTES THE INTEGRAND FOR EACH OF 6 DERIVATIVES OF THE
C     SOMMERFELD INTEGRALS FOR SOURCE BELOW GROUND AND OBSERVER ABOVE.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 ANS,XL,DXL,CGAM1,CGAM2,B0,B0P,COM,CK1,CK1SQ,CK2,CK2SQ,
     &CKSM,DEN1,DEN2,DEN3,A1,A2,A3,A4,A5,B1,B2,B3,B4,B5,C1,C2,C3,C4,C5
      COMPLEX*16 TRM1,TRM2,TRM3,RXL,CON1,CON2,CON3,CEXXP,CEXXM,CEXGD,
     &CEXZD,ZPGD,ZZEXP
      COMMON /EVLCOM/ CKSM,CK1,CK1SQ,CK2,CK2SQ,CON1,CON2,CON3,TKMAG,TSMA
     &G,CKAR,CKAI,CKBR,CKBI,ZZ,ZP,RHO,JH,IQAZ
      COMMON /SRGAM/ A1,A2,A3,A4,A5,B1,B2,B3,B4,B5,C1,C2,C3,C4,C5
      DIMENSION ANS(6)
      CALL LAMBDA (T,XL,DXL)
      IF (JH.GT.0) GO TO 1
C     BESSEL FUNCTION FORM
      CALL BESSEL (XL*RHO,B0,B0P)
      B0=2.*B0
      B0P=2.*B0P*XL
      CGAM1=SQRT(XL*XL-CK1SQ)
      CGAM2=SQRT(XL*XL-CK2SQ)
      IF (DREAL(CGAM1).EQ.0.) CGAM1=DCMPLX(0.D0,-ABS(DIMAG(CGAM1)))
      IF (DREAL(CGAM2).EQ.0.) CGAM2=DCMPLX(0.D0,-ABS(DIMAG(CGAM2)))
      GO TO 3
C     HANKEL FUNCTION FORM
1     IF (JH.EQ.1) GO TO 2
      DXL=(0.,2.)*XL*DXL
      XLR=DREAL(XL)
      XL=DCMPLX(CKBR,CKBI+XLR*XLR)
2     CALL HANK12(XL*RHO,1,B0,B0P)
      B0P=B0P*XL
      COM=XL-CK2
      CGAM2=SQRT(XL+CK2)*SQRT(COM)
      IF (DREAL(COM).LT.0..AND.DIMAG(COM).GE.0.) CGAM2=-CGAM2
      COM=XL-CK1
      CGAM1=SQRT(XL+CK1)*SQRT(COM)
      IF (JH.EQ.2) GO TO 9
      IF (DREAL(COM).LT.0..AND.DIMAG(COM).GE.0.) CGAM1=-CGAM1
3     IF (IQAZ.NE.0) GO TO 4
      CEXXP=ZZEXP(CGAM1*ZP-CGAM2*ZZ)
      DEN1=CEXXP/(CGAM2+CGAM1)
      DEN2=CEXXP/(CK1SQ*CGAM2+CK2SQ*CGAM1)
      DEN3=DEN2*CGAM1
      GO TO 10
4     ZPGD=ZP*(CGAM1-CGAM2)
      CEXGD=ZZEXP(ZPGD)
      CEXZD=ZZEXP(-CGAM2*(ZZ-ZP))
      CEXXP=CEXGD*CEXZD
      XLR=XL*DCONJG(XL)
      IF (XLR.LT.TSMAG) GO TO 5
      IF (DIMAG(XL).LT.0.) GO TO 6
      XLR=DREAL(XL)
      IF (XLR.LT.CKAR) GO TO 7
      IF (XLR.GT.CKBR) GO TO 6
C
C     INTEGRAND WITH QUASISTATIC TERMS SUBTRACTED
C
5     IF(ABS(ZPGD).GT.0.01)THEN
         TRM1=CEXGD-1.
      ELSE
         TRM1=((ZPGD/6.+0.5)*ZPGD+1.)*ZPGD
      END IF
      TRM2=CGAM2*CEXGD-CGAM1
      TRM3=CGAM1*CEXGD-CGAM2
      GO TO 8
C
C     APPROXIMATION OF ABOVE FOR LARGE XL TO AVOID CANCELLATION.
C
6     RXL=1./XL
      TRM1=((((A5*RXL+A4)*RXL+A3)*RXL+A2)*RXL+A1)*RXL
      TRM2=((((B5*RXL+B4)*RXL+B3)*RXL+B2)*RXL+B1)*RXL+A1
      TRM3=((((C5*RXL+C4)*RXL+C3)*RXL+C2)*RXL+C1)*RXL+A1
      GO TO 8
7     RXL=1./XL
      TRM1=((((-A5*RXL+A4)*RXL-A3)*RXL+A2)*RXL-A1)*RXL
      TRM2=((((-B5*RXL+B4)*RXL-B3)*RXL+B2)*RXL-B1)*RXL+A1
      TRM3=((((-C5*RXL+C4)*RXL-C3)*RXL+C2)*RXL-C1)*RXL+A1
8     DEN1=CEXXP/(CGAM2+CGAM1)
      DEN3=CEXZD/(CKSM*(CK1SQ*CGAM2+CK2SQ*CGAM1))
      DEN2=(CGAM2*CK1SQ*TRM1+CK2SQ*TRM2)*DEN3/CGAM2
      DEN3=(CGAM1*CK2SQ*TRM1+CK1SQ*TRM3)*DEN3
      GO TO 10
C
C     INTEGRAND ON THE BRANCH CUT FROM K1
C
9     IF (DIMAG(COM).GE.0.) CGAM1=-CGAM1
      CEXXP=ZZEXP(CGAM1*ZP-CGAM2*ZZ)
      CEXXM=ZZEXP(-CGAM1*ZP-CGAM2*ZZ)
      DEN1=CEXXM/(CGAM2-CGAM1)-CEXXP/(CGAM2+CGAM1)
      TRM1=CEXXM/(CK1SQ*CGAM2-CK2SQ*CGAM1)
      TRM2=CEXXP/(CK1SQ*CGAM2+CK2SQ*CGAM1)
      DEN2=TRM1-TRM2
      DEN3=-CGAM1*(TRM1+TRM2)
C
C     EVALUATE INTEGRANDS FOR EACH OF THE 6 FUNCTIONS
C
10    COM=XL*DXL
      IF (RHO.LT.1.E-20.AND.JH.EQ.0) GO TO 11
      ANS(3)=-DEN2*(B0P/RHO+B0*XL*XL)*COM
      ANS(4)=DEN2*B0P*COM/RHO
      GO TO 12
11    ANS(3)=-DEN2*XL*XL*COM
      ANS(4)=ANS(3)
12    ANS(1)=-DEN2*CGAM2*B0P*COM
      ANS(2)=DEN2*B0*XL*XL*COM
      ANS(5)=DEN3*B0P*COM
      ANS(6)=DEN1*B0*COM
      RETURN
      END
      REAL*8 FUNCTION SCNRM2(N,CX,INCX)
C  ***BEGIN PROLOGUE  SCNRM2
C     REVISION DATE  811015   (YYMMDD)
C     CATEGORY NO.  F1A
C     KEYWORDS  BLAS,VECTOR,COMPLEX,UNITARY NORM,NORM
C     DATE WRITTEN  OCTOBER 1979
C     AUTHOR LAWSON C. (JPL),HANSON R. (SLA),
C                            KINCAID D. (U TEXAS), KROGH F. (JPL)
C  ***PURPOSE
C     UNITARY NORM OF COMPLEX VECTOR
C  ***DESCRIPTION
C                B L A S  SUBPROGRAM
C     DESCRIPTION OF PARAMETERS
C
C     --INPUT--
C        N  NUMBER OF ELEMENTS IN INPUT VECTOR(S)
C       CX  COMPLEX VECTOR WITH N ELEMENTS
C     INCX  STORAGE SPACING BETWEEN ELEMENTS OF CX
C
C     --OUTPUT--
C     SCNRM2  SINGLE PRECISION RESULT (ZERO IF N.LE.0)
C
C     UNITARY NORM OF THE COMPLEX N-VECTOR STORED IN CX() WITH STORAGE
C     INCREMENT INCX .
C     IF    N .LE. 0 RETURN WITH RESULT = 0.
C     IF N .GE. 1 THEN INCX MUST BE .GE. 1
C
C           C.L.LAWSON , 1978 JAN 08
C
C     FOUR PHASE METHOD     USING TWO BUILT-IN CONSTANTS THAT ARE
C     HOPEFULLY APPLICABLE TO ALL MACHINES.
C         CUTLO = MAXIMUM OF  SQRT(U/EPS)  OVER ALL KNOWN MACHINES.
C         CUTHI = MINIMUM OF  SQRT(V)      OVER ALL KNOWN MACHINES.
C     WHERE
C         EPS = SMALLEST NO. SUCH THAT EPS + 1. .GT. 1.
C         U   = SMALLEST POSITIVE NO.   (UNDERFLOW LIMIT)
C         V   = LARGEST  NO.            (OVERFLOW  LIMIT)
C
C     BRIEF OUTLINE OF ALGORITHM..
C
C     PHASE 1    SCANS ZERO COMPONENTS.
C     MOVE TO PHASE 2 WHEN A COMPONENT IS NONZERO AND .LE. CUTLO
C     MOVE TO PHASE 3 WHEN A COMPONENT IS .GT. CUTLO
C     MOVE TO PHASE 4 WHEN A COMPONENT IS .GE. CUTHI/M
C     WHERE M = N FOR X() REAL AND M = 2*N FOR COMPLEX.
C
C     VALUES FOR CUTLO AND CUTHI..
C     FROM THE ENVIRONMENTAL PARAMETERS LISTED IN THE IMSL CONVERTER
C     DOCUMENT THE LIMITING VALUES ARE AS FOLLOWS..
C     CUTLO, S.P.   U/EPS = 2**(-102) FOR  HONEYWELL.  CLOSE SECONDS ARE
C                   UNIVAC AND DEC AT 2**(-103)
C                   THUS CUTLO = 2**(-51) = 4.44089E-16
C     CUTHI, S.P.   V = 2**127 FOR UNIVAC, HONEYWELL, AND DEC.
C                   THUS CUTHI = 2**(63.5) = 1.30438E19
C     CUTLO, D.P.   U/EPS = 2**(-67) FOR HONEYWELL AND DEC.
C                   THUS CUTLO = 2**(-33.5) = 8.23181D-11
C     CUTHI, D.P.   SAME AS S.P.  CUTHI = 1.30438D19
C     DATA CUTLO, CUTHI / 8.232D-11,  1.304D19 /
C     DATA CUTLO, CUTHI / 4.441E-16,  1.304E19 /
C
C  ***REFERENCES
C     LAWSON C.L., HANSON R.J., KINCAID D.R., KROGH F.T.,
C     BASIC LINEAR ALGEBRA SUBPROGRAMS FOR FORTRAN USAGE*,
C     ALGORITHM NO. 539, TRANSACTIONS ON MATHEMATICAL SOFTWARE,
C     VOLUME 5, NUMBER 3, SEPTEMBER 1979, 308-323
C     ROUTINES CALLED  (NONE)
C  ***END PROLOGUE  SCNRM2
      IMPLICIT REAL*8 (A-H,O-Z)
      LOGICAL IMAG,SCALE
      INTEGER NEXT
      REAL*8 CUTLO,CUTHI,HITEST,SUM,XMAX,ABSX,ZERO,ONE
      COMPLEX*16 CX(*)
      DATA ZERO,ONE/0.0D0,1.0D0/
C
      DATA CUTLO,CUTHI/4.441D-16,1.304D19/
C     FIRST EXECUTABLE STATEMENT  SCNRM2
      IF (N.GT.0) GO TO 1
      SCNRM2=ZERO
      GO TO 14
C
1     ASSIGN 2 TO NEXT
      SUM=ZERO
      NN=N*INCX
C                                                 BEGIN MAIN LOOP
      DO 13 I=1,NN,INCX
      ABSX=ABS(DREAL(CX(I)))
      IMAG=.FALSE.
      GO TO NEXT, (2,3,6,11,7)
2     IF (ABSX.GT.CUTLO) GO TO 10
      ASSIGN 3 TO NEXT
      SCALE=.FALSE.
C
C                        PHASE 1.  SUM IS ZERO
C
3     IF (ABSX.EQ.ZERO) GO TO 12
      IF (ABSX.GT.CUTLO) GO TO 10
C
C                                PREPARE FOR PHASE 2.
      ASSIGN 6 TO NEXT
      GO TO 5
C
C                                PREPARE FOR PHASE 4.
C
4     ASSIGN 7 TO NEXT
      SUM=(SUM/ABSX)/ABSX
5     SCALE=.TRUE.
      XMAX=ABSX
      GO TO 8
C
C                   PHASE 2.  SUM IS SMALL.
C                             SCALE TO AVOID DESTRUCTIVE UNDERFLOW.
C
6     IF (ABSX.GT.CUTLO) GO TO 9
C
C                     COMMON CODE FOR PHASES 2 AND 4.
C                     IN PHASE 4 SUM IS LARGE.  SCALE TO AVOID OVERFLOW.
C
7     IF (ABSX.LE.XMAX) GO TO 8
      SUM=ONE+SUM*(XMAX/ABSX)**2
      XMAX=ABSX
      GO TO 12
C
8     SUM=SUM+(ABSX/XMAX)**2
      GO TO 12
C
C
C                  PREPARE FOR PHASE 3.
C
9     SUM=(SUM*XMAX)*XMAX
C
10    ASSIGN 11 TO NEXT
      SCALE=.FALSE.
C
C     FOR REAL OR D.P. SET HITEST = CUTHI/N
C     FOR COMPLEX      SET HITEST = CUTHI/(2*N)
C
      HITEST=CUTHI/FLOAT(N)
C
C                   PHASE 3.  SUM IS MID-RANGE.  NO SCALING.
C
11    IF (ABSX.GE.HITEST) GO TO 4
      SUM=SUM+ABSX**2
12    CONTINUE
C                  CONTROL SELECTION OF REAL AND IMAGINARY PARTS.
C
      IF (IMAG) GO TO 13
      ABSX=ABS(DIMAG(CX(I)))
      IMAG=.TRUE.
      GO TO NEXT, (3,6,11,7)
C
13    CONTINUE
C
C              END OF MAIN LOOP.
C              COMPUTE SQUARE ROOT AND ADJUST FOR SCALING.
C
      SCNRM2=SQRT(SUM)
      IF (SCALE) SCNRM2=SCNRM2*XMAX
14    CONTINUE
      RETURN
      END
      BLOCK DATA SOMSET
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
      IMPLICIT REAL*8 (A-H,O-Z)
      CHARACTER SOMFIL*40
      COMPLEX*16 A1,A2,A3,A4,A5,EPSCX
      COMMON /GRIDY/ A1(1200),A2(1200),A3(1200),A4(1200),A5(1200),RH1(3)
     &,ZZ1(3),ZP1(3),DRH(3),DZZ(3),DZP(3),DRZZP(3),ZPM1,ZPM2,ZPMM1,
     &ZPMM2,ZPD1,ZPD2,NRH(3),NZZ(3),NZP(3),NPT(3),INDI(3)
      COMMON /GREGON/ RHOA(3),RHOB(3),ZZA(3),ZZB(3),ZPA(3),ZPB(3),ELM,EL
     &MX,SCFAC,RHMX1,ZZMX1,ZPMX1,RHMX2,ZZMX2,ZPMX2,ZPMXX
      COMMON /GNDCOM/ EPSCX,XRH1,DXRH,XZZ1,DXZZ,XZP1,DXZP,SRH1,DSRH,
     &SZZ1,DSZZ,SZP1,DSZP,RES1,RES2,RES3,RES4,RES5,REX1,REX2,REX3,REX4,
     &REX5,NREG,NXRH,NXZZ,NXZP,NSRH,NSZZ,NSZP
      COMMON /GNDFIL/NSFILE,SOMFIL
      DATA NRH/11,11,5/,NZZ/8,5,4/,NZP/5,5,5/
      DATA RH1/0.D0,0.D0,0.D0/,ZZ1/0.D0,0.D0,0.D0/,ZP1/0.D0,0.D0,0.D0/
      DATA RHOA/0.D0,.2D0,.6D0/,RHOB/.6D0,.6D0,2.D0/,ZZA/.2D0,0.D0,
     &0.D0/,ZZB/2.D0,.2D0,2.D0/
      DATA ZPA/0.D0,0.D0,0.D0/,ZPB/.25D0,.25D0,.25D0/,
     &EPSCX/(0.D0,0.D0)/,NSFILE/0/
      END
      SUBROUTINE SOMLSQ (EPSC,ELGND)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     SOMLSQ DETERMINES PARAMETERS FOR L.S. APPROXIMATION OF SOMMERFELD
C     INTEGRALS.  APPROXIMATIONS ARE DEVELOPED FOR 3 REGIONS.  THE NUM-
C     BER OF FITTED POINTS AND THEIR SPACING IS SET IN DATA STATEMENTS.
C
      IMPLICIT REAL*8 (A-H,O-Z)
      SAVE
      COMPLEX*16 FAC1,FAC2,FAC3,FAC4,FAC5,EPSC,XLA,GCK1,GCK1SQ,GCK2,
     &GCK2SQ
      COMMON /COFIT/ FAC1(32,3),FAC2(32,3),FAC3(32,3),FAC4(32,3),
     &FAC5(32,3),RKFAC,MFUNF(3),MFUNC(3)
      COMMON /PTFIT/ RH1,DRH,ZZ1,DZZ,ZP1,DZP,SRH1,DSRH,SZZ1,DSZZ,SZP1,
     &DSZP,RES1,RES2,RES3,RES4,RES5,REX1,REX2,REX3,REX4,REX5,NRH,NZZ,
     &NZP,NSRH,NSZZ,NSZP,IQAX
      COMMON /GPARM/ XLA(21,21),GCK1,GCK1SQ,GCK2,GCK2SQ,ZRAT,RHON
      COMMON /GREGON/ RHOA(3),RHOB(3),ZZA(3),ZZB(3),ZPA(3),ZPB(3),ELM,EL
     &MX,SCFAC,RHMX1,ZZMX1,ZPMX1,RHMX2,ZZMX2,ZPMX2,ZPMXX
      COMMON/PRNTCM/ISMPRT
      DIMENSION RH1A(3),DRHA(3),NRHA(3),ZZ1A(3),DZZA(3),NZZA(3),
     &ZP1A(3),DZPA(3),NZPA(3),SRH1A(3),DSRHA(3),NSRHA(3),SZZ1A(3),
     &DSZZA(3),NSZZA(3),SZP1A(3),DSZPA(3),NSZPA(3)
      DATA RH1A/0.D0,.2D0,.6D0/,DRHA/.2D0,.1D0,.2D0/,NRHA/4,5,5/,NREG/3/
      DATA ZZ1A/.2D0,0.D0,0.D0/,DZZA/.2D0,.1D0,.2D0/,NZZA/4,4,4/
      DATA ZP1A/0.D0,0.D0,0.D0/,DZPA/.1D0,.1D0,.1D0/,NZPA/2,2,2/
      DATA SRH1A/0.D0,.2D0,.6D0/,NSRHA/5,6,8/,SZZ1A/.2D0,0.D0,0.D0/,
     &NSZZA/2,2,2/
      DATA SZP1A/0.D0,0.D0,0.D0/,NSZPA/2,3,3/
      IQAX=0
      ZZ1A(1)=ELGND
      DZPA(1)=.4*ELGND
      RH1A(2)=ELGND
      DRHA(2)=(RH1A(3)-RH1A(2))/(NRHA(2)-1)
      DZZA(2)=.5*ELGND
      DZPA(2)=.4*ELGND
      DZPA(3)=.4*ELGND
      DSRHA(1)=.025
      SZZ1A(1)=ZZ1A(1)
      DSZZA(1)=DZZA(1)
      DSZPA(1)=DZPA(1)
      SRH1A(2)=ELGND
      DSRHA(2)=ELGND*.2
      DSZZA(2)=ELGND*.4
      DSZPA(2)=.5*ELGND
      DSRHA(3)=ELGND*.2
      DSZZA(3)=ELGND*.4
      DSZPA(3)=.5*ELGND
      ZZA(1)=ZZ1A(1)
      RHOA(2)=RH1A(2)
      ZZB(2)=ZZ1A(2)+(NZZA(2)-1)*DZZA(2)
      IF(ISMPRT.NE.0)WRITE(3,3)EPSC
      TIM=0.
C     LOOP OVER REGIONS
      DO 2 IR=1,NREG
      IFUNC=1
      IF (IR.EQ.1) IFUNC=0
      RH1=RH1A(IR)
      DRH=DRHA(IR)
      NRH=NRHA(IR)
      ZZ1=ZZ1A(IR)
      DZZ=DZZA(IR)
      NZZ=NZZA(IR)
      ZP1=ZP1A(IR)
      DZP=DZPA(IR)
      NZP=NZPA(IR)
      SRH1=SRH1A(IR)
      DSRH=DSRHA(IR)
      NSRH=NSRHA(IR)
      SZZ1=SZZ1A(IR)
      DSZZ=DSZZA(IR)
      NSZZ=NSZZA(IR)
      SZP1=SZP1A(IR)
      DSZP=DSZPA(IR)
      NSZP=NSZPA(IR)
      IF (EXP(DIMAG(GCK1)*RH1).LT.1.E-8) IFUNC=0
      CALL SECOND (TIM1)
      CALL RZZFIT (IR,IFUNC)
      CALL SECOND (TIM2)
      TIM=TIM+TIM2-TIM1
      IF(ISMPRT.NE.0)THEN
         WRITE(3,4)IR,RHOA(IR),RHOB(IR),ZZA(IR),ZZB(IR),ZPA(IR),ZPB(IR)
         WRITE(3,5)RH1,DRH,NRH,ZZ1,DZZ,NZZ,ZP1,DZP,NZP
         WRITE(3,5)SRH1,DSRH,NSRH,SZZ1,DSZZ,NSZZ,SZP1,DSZP,NSZP
         WRITE(3,6)MFUNF(IR),MFUNC(IR),RES1,RES2,RES3,RES4,RES5
      END IF
2     CONTINUE
      IF(ISMPRT.NE.0)WRITE(3,7)TIM
      RETURN
C
3     FORMAT (' SOMMERFELD GROUND L.S. APPROX:',//,' EPSC=',1P2E12.5)
4     FORMAT (//,15X,'RHO:',21X,'ZZ:',22X,'ZP:',/,' REGION',I2,':',
     &3(2F10.5,5X))
5     FORMAT (' PTS. FIT:',3(2F10.5,I5))
6     FORMAT (/,' NO. FUNCTIONS:',2I4,/,' RMS RESIDUALS:',1P5E11.3)
7     FORMAT (/,' FIELD EVALUATION TIME IN SOMLSQ',F8.3,' SECONDS')
      END
      SUBROUTINE SOMTRP (EPSC,ELGND)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     SOMTRP FILLS THE INTERPOLATION TABLES FOR 3 REGIONS FOR SMALL RHO
C
C     INPUT:
C     EPSC = COMPLEX RELATIVE PERMITTIVITY OF THE GROUND
C     ELGND = DISTANCE THAT INTERPOLATION GRID EXTENDS INTO LOWER MEDIUM
C
      IMPLICIT REAL*8 (A-H,O-Z)
      SAVE
      COMPLEX*16 GCK1,GCK1SQ,GCK2,GCK2SQ,A1,A2,A3,A4,A5,ERV,EZV,ERH,EPH,
     &EZH,EXX,EPSC,XLA
      COMMON /GRIDY/ A1(1200),A2(1200),A3(1200),A4(1200),A5(1200),RH1(3)
     &,ZZ1(3),ZP1(3),DRH(3),DZZ(3),DZP(3),DRZZP(3),ZPM1,ZPM2,ZPMM1,
     &ZPMM2,ZPD1,ZPD2,NRH(3),NZZ(3),NZP(3),NPT(3),INDI(3)
      COMMON /GPARM/ XLA(21,21),GCK1,GCK1SQ,GCK2,GCK2SQ,ZRAT,RHON
      COMMON/PRNTCM/ISMPRT
      MXDIM=1200
      ELMAX=15.*ABS(GCK2/GCK1)
      IF (ELMAX.GT.1.) ELMAX=1.
      DRH(1)=ELGND/(NRH(1)-1)
      DRH(2)=ELGND/(NRH(2)-1)
      DRH(3)=ELGND/(NRH(3)-1)
      DZZ(1)=ELGND/(NZZ(1)-1)
      DZZ(2)=ELGND/(NZZ(2)-1)
      DZZ(3)=ELGND/(NZZ(3)-1)
      DZP(1)=ELGND/(NZP(1)-1)*.4
      ZP1(2)=ZP1(1)+DZP(1)*(NZP(1)-1.3)
      DZP(2)=(ELGND-ZP1(2))/(NZP(2)-1)
      ZP1(3)=ZP1(2)+DZP(2)*(NZP(2)-1.3)
      DZP(3)=(ELMAX-ZP1(3))/(NZP(3)-1)
      NPTS=0
      DO 1 K=1,3
      DRZZP(K)=DRH(K)*DZZ(K)*DZP(K)
      NPT(K)=NRH(K)*NZZ(K)*NZP(K)
1     NPTS=NPTS+NPT(K)
      IF (NPTS.GT.MXDIM) THEN
         WRITE(3,10)NPTS
         STOP
      END IF
      IQAX=1
      INDXX=0
      CALL SECOND (TIM1)
      DO 8 K=1,3
      IF (K.GT.1) IQAX=0
      IF (K.GT.1) INDXX=INDXX+NPT(K-1)
      NRHK=NRH(K)
      NZZK=NZZ(K)
      NZPK=NZP(K)
      RHOX=RH1(K)-DRH(K)
      DO 7 IRH=1,NRHK
      RHOX=RHOX+DRH(K)
      ZZX=ZZ1(K)-DZZ(K)
      DO 7 IZZ=1,NZZK
      ZZX=ZZX+DZZ(K)
      ZPPX=ZP1(K)-DZP(K)
      DO 7 IZP=1,NZPK
      ZPPX=ZPPX+DZP(K)
      ZPX=-ZPPX
      CALL EVLUB (RHOX,ZZX,ZPX,IQAX,ERV,EZV,ERH,EPH,EZH)
      INDX=NRHK*(NZZK*(IZP-1)+IZZ-1)+IRH+INDXX
      R=SQRT(RHOX*RHOX+(ZZX-ZPX)**2)
C     EXPONENTIAL FACTORS ARE DIVIDED OUT FOR EACH REGION TO REDUCE
C     OSCILLATIONS.  FOR REGIONS 2 AND 3 THE VALUES ARE MULTIPLIED BY R
C     HERE.  ANOTHER MULTIPLICATION BY R OCCURS IN EVLUB FOR ALL REGIONS
      IF(K.EQ.1)THEN
         EXX=EXP(-(0.,1.)*GCK2*R)
      ELSE IF(K.EQ.2)THEN
         RZ=SQRT(RHOX*RHOX+ZZX*ZZX)
         EXX=EXP(-(0.,1.)*(GCK2*RZ-GCK1*ZPX))/R
      ELSE
         RZ=SQRT(RHOX*RHOX+ZPX*ZPX)
         EXX=EXP(-(0.,1.)*(GCK2*ZZX+GCK1*RZ))/R
      END IF
      A1(INDX)=ERV/EXX
      A2(INDX)=EZV/EXX
      A3(INDX)=ERH/EXX
      A4(INDX)=EPH/EXX
      A5(INDX)=EZH/EXX
7     CONTINUE
8     CONTINUE
      CALL SECOND (TIM2)
      TIM2=TIM2-TIM1
      IF(ISMPRT.NE.0)THEN
         WRITE(3,11)TIM2
         WRITE(3,12)EPSC
         DO 9 I=1,3
9        WRITE(3,13)I,RH1(I),DRH(I),NRH(I),ZZ1(I),DZZ(I),NZZ(I),ZP1(I),
     &   DZP(I),NZP(I)
      END IF
      RETURN
C
10    FORMAT (' SOMTRP: ERROR - ARRAY OVERFLOW - NPTS=',I10)
11    FORMAT (' FIELD EVALUATION TIME IN SOMTRP',F8.3,' SECONDS')
12    FORMAT (//,' INTERPOLATION DATA FILE:',//,' EPSC=',1P2E12.5,//,
     &' GRID',5X,'RHO:',27X,'ZZ:',27X,'ZP:')
13    FORMAT (I4,3(1X,1P2E12.5,I4,1X))
      END
      SUBROUTINE TESTC (F1,F2,SUM,TR)
C=======================================================================
C     (C) Copyright 1992
C     The Regents of the University of California.  All rights reserved.
C=======================================================================
C
C     TEST FOR CONVERGENCE IN NUMERICAL INTEGRATION
C
      IMPLICIT REAL*8 (A-H,O-Z)
      COMPLEX*16 F1,F2,SUM,SX
      IF(ABS(F2).GT.0.)THEN
         IF(ABS((F2-F1)/F2).LT.1.E-7)GO TO 1
      END IF
      SX=SUM+F2
      DEN=ABS(DREAL(SX))+ABS(DIMAG(SX))
      IF (DEN.LT.1.E-18) GO TO 1
      TR=ABS(F2-F1)/DEN
      RETURN
1     TR=0.
      RETURN
      END
