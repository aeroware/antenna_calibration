1



                                ***********************************************
                                *                                             *
                                *  NUMERICAL ELECTROMAGNETICS CODE (NEC-4.1)  *
                                *                                             *
                                ***********************************************




                      **********************************************************

                         EXAMPLE 1.  CENTER FED LINEAR ANTENNA                                         

                      **********************************************************





                                 - - - STRUCTURE SPECIFICATION - - -

                                     COORDINATES MUST BE INPUT IN
                                     METERS OR BE SCALED TO METERS
                                     BEFORE STRUCTURE INPUT IS ENDED


  WIRE                                                                               NO. OF    FIRST  LAST     TAG
  NO.        X1         Y1         Z1          X2         Y2         Z2      RADIUS   SEG.     SEG.   SEG.     NO.
     1     .00000     .00000    -.25000      .00000     .00000     .25000     .00100      7        1     7       0

   TOTAL SEGMENTS USED=    7     NO. SEG. IN A SYMMETRIC CELL=    7     SYMMETRY FLAG=  0


         - MULTIPLE WIRE JUNCTIONS -
 JUNCTION    SEGMENTS  (- FOR END 1, + FOR END 2)
  NONE




                                 - - - - SEGMENTATION DATA - - - -

                                        COORDINATES IN METERS

                         I+ AND I- INDICATE THE SEGMENTS BEFORE AND AFTER I


  SEG.   COORDINATES OF SEG. CENTER     SEG.     ORIENTATION ANGLES    WIRE    CONNECTION DATA   TAG
  NO.       X         Y         Z       LENGTH     ALPHA     BETA      RADIUS    I-   I    I+    NO.
     1    .00000    .00000   -.21429    .07143   90.00000    .00000    .00100     0    1    2      0
     2    .00000    .00000   -.14286    .07143   90.00000    .00000    .00100     1    2    3      0
     3    .00000    .00000   -.07143    .07143   90.00000    .00000    .00100     2    3    4      0
     4    .00000    .00000    .00000    .07143   90.00000    .00000    .00100     3    4    5      0
     5    .00000    .00000    .07143    .07143   90.00000    .00000    .00100     4    5    6      0
     6    .00000    .00000    .14286    .07143   90.00000    .00000    .00100     5    6    7      0
     7    .00000    .00000    .21429    .07143   90.00000    .00000    .00100     6    7    0      0




 ***** INPUT LINE  1  EX   0    0    4    0  1.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  2  XQ   0    0    0    0  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00




                                 - - - - - - FREQUENCY - - - - - -

                                    FREQUENCY= 2.9980E+02 MHZ
                                    WAVELENGTH= 1.0000E+00 METERS



                                  - - - ANTENNA ENVIRONMENT - - -

                                            FREE SPACE



                               - - - STRUCTURE IMPEDANCE LOADING - - -

                                   THIS STRUCTURE IS NOT LOADED



                                - - - MATRIX TIMING - - -

                        FILL=     .030 SEC.,  FACTOR=     .000 SEC.



                                          - - - ANTENNA INPUT PARAMETERS - - -

   TAG   SEG.    VOLTAGE (VOLTS)         CURRENT (AMPS)         IMPEDANCE (OHMS)        ADMITTANCE (MHOS)      POWER
   NO.   NO.    REAL        IMAG.       REAL        IMAG.       REAL        IMAG.       REAL        IMAG.     (WATTS)
     0     4 1.00000E+00 0.00000E+00 9.20578E-03-5.15456E-03 8.26996E+01 4.63057E+01 9.20578E-03-5.15456E-03 4.60289E-03



                             - - - CURRENTS AND LOCATION - - -

                     LENGTHS NORMALIZED BY WAVELENGTH (OR 2.*PI/CABS(K))

  SEG.  TAG    COORD. OF SEG. CENTER     SEG.            - - - CURRENT (AMPS) - - -
  NO.   NO.     X        Y        Z      LENGTH     REAL        IMAG.       MAG.        PHASE
     1    0    .0000    .0000   -.2143   .07143   2.3592E-03 -1.6880E-03  2.9009E-03  -35.584
     2    0    .0000    .0000   -.1429   .07143   5.9998E-03 -4.0462E-03  7.2366E-03  -33.995
     3    0    .0000    .0000   -.0714   .07143   8.3710E-03 -5.1856E-03  9.8471E-03  -31.777
     4    0    .0000    .0000    .0000   .07143   9.2058E-03 -5.1546E-03  1.0551E-02  -29.246
     5    0    .0000    .0000    .0714   .07143   8.3710E-03 -5.1856E-03  9.8471E-03  -31.777
     6    0    .0000    .0000    .1429   .07143   5.9998E-03 -4.0462E-03  7.2366E-03  -33.995
     7    0    .0000    .0000    .2143   .07143   2.3592E-03 -1.6880E-03  2.9009E-03  -35.584



                                        - - - POWER BUDGET - - -

                                           INPUT POWER   = 4.6029E-03 WATTS
                                           RADIATED POWER= 4.6029E-03 WATTS
                                           WIRE LOSS     = 0.0000E+00 WATTS
                                           EFFICIENCY    = 100.00 PERCENT




 ***** INPUT LINE  3  LD   0    0    4    4  1.00000E+01  3.00000E-09  5.30000E-11  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  4  PQ   0    0    0    0  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  5  NE   0    1    1   15  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  1.78600E-02




                                 - - - - - - FREQUENCY - - - - - -

                                    FREQUENCY= 2.9980E+02 MHZ
                                    WAVELENGTH= 1.0000E+00 METERS



                                  - - - ANTENNA ENVIRONMENT - - -

                                            FREE SPACE



                               - - - STRUCTURE IMPEDANCE LOADING - - -


       LOCATION          RESISTANCE   INDUCTANCE  CAPACITANCE       IMPEDANCE (OHMS)     CONDUCTIVITY    TYPE
    ITAG FROM THRU          OHMS        HENRYS       FARADS        REAL      IMAGINARY    MHOS/METER

            4    4      1.0000E+01   3.0000E-09   5.3000E-11                                           SERIES 



                                - - - MATRIX TIMING - - -

                        FILL=     .020 SEC.,  FACTOR=     .000 SEC.



                                          - - - ANTENNA INPUT PARAMETERS - - -

   TAG   SEG.    VOLTAGE (VOLTS)         CURRENT (AMPS)         IMPEDANCE (OHMS)        ADMITTANCE (MHOS)      POWER
   NO.   NO.    REAL        IMAG.       REAL        IMAG.       REAL        IMAG.       REAL        IMAG.     (WATTS)
     0     4 1.00000E+00 0.00000E+00 8.95457E-03-4.05135E-03 9.26996E+01 4.19404E+01 8.95457E-03-4.05135E-03 4.47728E-03



                             - - - CURRENTS AND LOCATION - - -

                     LENGTHS NORMALIZED BY WAVELENGTH (OR 2.*PI/CABS(K))

  SEG.  TAG    COORD. OF SEG. CENTER     SEG.            - - - CURRENT (AMPS) - - -
  NO.   NO.     X        Y        Z      LENGTH     REAL        IMAG.       MAG.        PHASE
     1    0    .0000    .0000   -.2143   .07143   2.3240E-03 -1.3789E-03  2.7023E-03  -30.682
     2    0    .0000    .0000   -.1429   .07143   5.8907E-03 -3.2778E-03  6.7413E-03  -29.093
     3    0    .0000    .0000   -.0714   .07143   8.1823E-03 -4.1466E-03  9.1730E-03  -26.875
     4    0    .0000    .0000    .0000   .07143   8.9546E-03 -4.0514E-03  9.8284E-03  -24.344
     5    0    .0000    .0000    .0714   .07143   8.1823E-03 -4.1466E-03  9.1730E-03  -26.875
     6    0    .0000    .0000    .1429   .07143   5.8907E-03 -3.2778E-03  6.7412E-03  -29.093
     7    0    .0000    .0000    .2143   .07143   2.3240E-03 -1.3789E-03  2.7023E-03  -30.682



                                  - - - CHARGE DENSITIES - - -

                       LENGTHS NORMALIZED TO WAVELENGTH (OR 2.*PI/CABS(K))


  SEG.  TAG    COORD. OF SEG. CENTER     SEG.          CHARGE DENSITY (COULOMBS/METER)
  NO.   NO.     X        Y        Z      LENGTH     REAL        IMAG.       MAG.        PHASE
     1E   0    .0000    .0000   -.2500   .07143   2.1919E-11  3.6035E-11  4.2178E-11   58.689
     1    0    .0000    .0000   -.2143   .07143   1.8291E-11  3.1761E-11  3.6651E-11   60.062
     2    0    .0000    .0000   -.1429   .07143   1.0429E-11  2.2040E-11  2.4383E-11   64.677
     3    0    .0000    .0000   -.0714   .07143   2.1139E-12  1.1638E-11  1.1829E-11   79.706
     4    0    .0000    .0000    .0000   .07143  -1.6381E-18 -8.7431E-18  8.8952E-18 -100.612
     5    0    .0000    .0000    .0714   .07143  -2.1139E-12 -1.1638E-11  1.1829E-11 -100.294
     6    0    .0000    .0000    .1429   .07143  -1.0429E-11 -2.2040E-11  2.4383E-11 -115.323
     7    0    .0000    .0000    .2143   .07143  -1.8291E-11 -3.1761E-11  3.6651E-11 -119.938
     7E   0    .0000    .0000    .2500   .07143  -2.1919E-11 -3.6035E-11  4.2178E-11 -121.311



                                        - - - POWER BUDGET - - -

                                           INPUT POWER   = 4.4773E-03 WATTS
                                           RADIATED POWER= 3.9943E-03 WATTS
                                           WIRE LOSS     = 4.8299E-04 WATTS
                                           EFFICIENCY    =  89.21 PERCENT



                                      - - - NEAR ELECTRIC FIELDS - - -

              -  LOCATION  -                     -  EX  -               -  EY  -               -  EZ  -
        X           Y           Z           MAGNITUDE   PHASE      MAGNITUDE   PHASE      MAGNITUDE   PHASE
      METERS      METERS      METERS         VOLTS/M   DEGREES      VOLTS/M   DEGREES      VOLTS/M   DEGREES
         .0000       .0000       .0000     0.0000E+00      .00    0.0000E+00      .00    1.3042E+01  -175.10
         .0000       .0000       .0179     0.0000E+00      .00    0.0000E+00      .00    1.2536E+01  -175.08
         .0000       .0000       .0357     0.0000E+00      .00    0.0000E+00      .00    6.7270E+00  -175.46
         .0000       .0000       .0536     0.0000E+00      .00    0.0000E+00      .00    8.4348E-01  -179.75
         .0000       .0000       .0714     0.0000E+00      .00    0.0000E+00      .00    3.2851E-04    -6.75
         .0000       .0000       .0893     0.0000E+00      .00    0.0000E+00      .00    3.4487E-01    -8.87
         .0000       .0000       .1072     0.0000E+00      .00    0.0000E+00      .00    2.7983E-01    22.83
         .0000       .0000       .1250     0.0000E+00      .00    0.0000E+00      .00    2.2073E-01    74.43
         .0000       .0000       .1429     0.0000E+00      .00    0.0000E+00      .00    3.2703E-04  -107.03
         .0000       .0000       .1607     0.0000E+00      .00    0.0000E+00      .00    2.1940E-01  -106.43
         .0000       .0000       .1786     0.0000E+00      .00    0.0000E+00      .00    1.9746E+00    57.57
         .0000       .0000       .1965     0.0000E+00      .00    0.0000E+00      .00    3.3108E+00    58.63
         .0000       .0000       .2143     0.0000E+00      .00    0.0000E+00      .00    1.0225E-02  -121.54
         .0000       .0000       .2322     0.0000E+00      .00    0.0000E+00      .00    1.0677E+01  -121.66
         .0000       .0000       .2500     0.0000E+00      .00    0.0000E+00      .00    7.3670E+02  -121.37




 ***** INPUT LINE  6  NE   0    1    1   15  1.00000E-03  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  1.78600E-02



                                      - - - NEAR ELECTRIC FIELDS - - -

              -  LOCATION  -                     -  EX  -               -  EY  -               -  EZ  -
        X           Y           Z           MAGNITUDE   PHASE      MAGNITUDE   PHASE      MAGNITUDE   PHASE
      METERS      METERS      METERS         VOLTS/M   DEGREES      VOLTS/M   DEGREES      VOLTS/M   DEGREES
         .0010       .0000       .0000     1.4265E-04  -116.09    0.0000E+00      .00    1.2068E+01  -175.57
         .0010       .0000       .0179     5.5432E+01   -66.34    0.0000E+00      .00    1.1563E+01  -175.56
         .0010       .0000       .0357     1.0947E+02   -67.51    0.0000E+00      .00    6.3683E+00  -176.30
         .0010       .0000       .0536     1.5608E+02   -88.87    0.0000E+00      .00    1.0985E+00   177.07
         .0010       .0000       .0714     2.1267E+02  -100.31    0.0000E+00      .00    2.6119E-01   166.81
         .0010       .0000       .0893     2.7146E+02  -106.86    0.0000E+00      .00    8.6227E-02     4.25
         .0010       .0000       .1072     3.2922E+02  -111.07    0.0000E+00      .00    1.3827E-01    77.44
         .0010       .0000       .1250     3.8591E+02  -113.51    0.0000E+00      .00    2.5106E-01   124.56
         .0010       .0000       .1429     4.3834E+02  -115.33    0.0000E+00      .00    2.0187E-01  -178.22
         .0010       .0000       .1607     4.8562E+02  -116.77    0.0000E+00      .00    3.4159E-01  -140.60
         .0010       .0000       .1786     5.2835E+02  -117.97    0.0000E+00      .00    1.5253E+00    63.32
         .0010       .0000       .1965     5.9658E+02  -119.06    0.0000E+00      .00    2.5345E+00    62.10
         .0010       .0000       .2143     6.5864E+02  -119.94    0.0000E+00      .00    8.0359E-01  -132.39
         .0010       .0000       .2322     7.1183E+02  -120.67    0.0000E+00      .00    1.1430E+01  -122.41
         .0010       .0000       .2500     6.2616E+02  -121.28    0.0000E+00      .00    2.7831E+02  -121.49




 ***** INPUT LINE  7  NX   0    0    0    0  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
1



                                ***********************************************
                                *                                             *
                                *  NUMERICAL ELECTROMAGNETICS CODE (NEC-4.1)  *
                                *                                             *
                                ***********************************************




                      **********************************************************

                         EXAMPLE 2.  CENTER FED LINEAR ANTENNA.                                        
                                     CURRENT SLOPE DISCONTINUITY SOURCE.                               
                                     1. THIN PERFECTLY CONDUCTING WIRE                                 
                                     2. THIN ALUMINUM WIRE                                             

                      **********************************************************





                                 - - - STRUCTURE SPECIFICATION - - -

                                     COORDINATES MUST BE INPUT IN
                                     METERS OR BE SCALED TO METERS
                                     BEFORE STRUCTURE INPUT IS ENDED


  WIRE                                                                               NO. OF    FIRST  LAST     TAG
  NO.        X1         Y1         Z1          X2         Y2         Z2      RADIUS   SEG.     SEG.   SEG.     NO.
     1     .00000     .00000    -.25000      .00000     .00000     .25000     .00001      8        1     8       0

   TOTAL SEGMENTS USED=    8     NO. SEG. IN A SYMMETRIC CELL=    8     SYMMETRY FLAG=  0


         - MULTIPLE WIRE JUNCTIONS -
 JUNCTION    SEGMENTS  (- FOR END 1, + FOR END 2)
  NONE




                                 - - - - SEGMENTATION DATA - - - -

                                        COORDINATES IN METERS

                         I+ AND I- INDICATE THE SEGMENTS BEFORE AND AFTER I


  SEG.   COORDINATES OF SEG. CENTER     SEG.     ORIENTATION ANGLES    WIRE    CONNECTION DATA   TAG
  NO.       X         Y         Z       LENGTH     ALPHA     BETA      RADIUS    I-   I    I+    NO.
     1    .00000    .00000   -.21875    .06250   90.00000    .00000    .00001     0    1    2      0
     2    .00000    .00000   -.15625    .06250   90.00000    .00000    .00001     1    2    3      0
     3    .00000    .00000   -.09375    .06250   90.00000    .00000    .00001     2    3    4      0
     4    .00000    .00000   -.03125    .06250   90.00000    .00000    .00001     3    4    5      0
     5    .00000    .00000    .03125    .06250   90.00000    .00000    .00001     4    5    6      0
     6    .00000    .00000    .09375    .06250   90.00000    .00000    .00001     5    6    7      0
     7    .00000    .00000    .15625    .06250   90.00000    .00000    .00001     6    7    8      0
     8    .00000    .00000    .21875    .06250   90.00000    .00000    .00001     7    8    0      0




 ***** INPUT LINE  1  FR   0    3    0    0  2.00000E+02  5.00000E+01  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  2  EX   5    0    5    1  1.00000E+00  0.00000E+00  5.00000E+01  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  3  XQ   0    0    0    0  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00




                                 - - - - - - FREQUENCY - - - - - -

                                    FREQUENCY= 2.0000E+02 MHZ
                                    WAVELENGTH= 1.4990E+00 METERS



                                  - - - ANTENNA ENVIRONMENT - - -

                                            FREE SPACE



                               - - - STRUCTURE IMPEDANCE LOADING - - -

                                   THIS STRUCTURE IS NOT LOADED



                                - - - MATRIX TIMING - - -

                        FILL=     .030 SEC.,  FACTOR=     .000 SEC.



                                          - - - ANTENNA INPUT PARAMETERS - - -

   TAG   SEG.    VOLTAGE (VOLTS)         CURRENT (AMPS)         IMPEDANCE (OHMS)        ADMITTANCE (MHOS)      POWER
   NO.   NO.    REAL        IMAG.       REAL        IMAG.       REAL        IMAG.       REAL        IMAG.     (WATTS)
     0 *   5 1.00000E+00 0.00000E+00 6.64054E-05 1.57933E-03 2.65762E+01-6.32064E+02 6.64054E-05 1.57933E-03 3.32027E-05



                             - - - CURRENTS AND LOCATION - - -

                     LENGTHS NORMALIZED BY WAVELENGTH (OR 2.*PI/CABS(K))

  SEG.  TAG    COORD. OF SEG. CENTER     SEG.            - - - CURRENT (AMPS) - - -
  NO.   NO.     X        Y        Z      LENGTH     REAL        IMAG.       MAG.        PHASE
     1    0    .0000    .0000   -.1459   .04169   1.5369E-05  2.5220E-04  2.5267E-04   86.513
     2    0    .0000    .0000   -.1042   .04169   3.9856E-05  7.0589E-04  7.0701E-04   86.768
     3    0    .0000    .0000   -.0625   .04169   5.6673E-05  1.1008E-03  1.1023E-03   87.053
     4    0    .0000    .0000   -.0208   .04169   6.5313E-05  1.4319E-03  1.4334E-03   87.388
     5    0    .0000    .0000    .0208   .04169   6.5313E-05  1.4319E-03  1.4334E-03   87.388
     6    0    .0000    .0000    .0625   .04169   5.6673E-05  1.1008E-03  1.1023E-03   87.053
     7    0    .0000    .0000    .1042   .04169   3.9856E-05  7.0589E-04  7.0701E-04   86.768
     8    0    .0000    .0000    .1459   .04169   1.5369E-05  2.5220E-04  2.5267E-04   86.513



                                        - - - POWER BUDGET - - -

                                           INPUT POWER   = 3.3203E-05 WATTS
                                           RADIATED POWER= 3.3203E-05 WATTS
                                           WIRE LOSS     = 0.0000E+00 WATTS
                                           EFFICIENCY    = 100.00 PERCENT




                                 - - - - - - FREQUENCY - - - - - -

                                    FREQUENCY= 2.5000E+02 MHZ
                                    WAVELENGTH= 1.1992E+00 METERS



                                  - - - ANTENNA ENVIRONMENT - - -

                                            FREE SPACE



                               - - - STRUCTURE IMPEDANCE LOADING - - -

                                   THIS STRUCTURE IS NOT LOADED



                                - - - MATRIX TIMING - - -

                        FILL=     .020 SEC.,  FACTOR=     .000 SEC.



                                          - - - ANTENNA INPUT PARAMETERS - - -

   TAG   SEG.    VOLTAGE (VOLTS)         CURRENT (AMPS)         IMPEDANCE (OHMS)        ADMITTANCE (MHOS)      POWER
   NO.   NO.    REAL        IMAG.       REAL        IMAG.       REAL        IMAG.       REAL        IMAG.     (WATTS)
     0 *   5 1.00000E+00 0.00000E+00 6.16988E-04 3.56466E-03 4.71435E+01-2.72372E+02 6.16988E-04 3.56466E-03 3.08494E-04



                             - - - CURRENTS AND LOCATION - - -

                     LENGTHS NORMALIZED BY WAVELENGTH (OR 2.*PI/CABS(K))

  SEG.  TAG    COORD. OF SEG. CENTER     SEG.            - - - CURRENT (AMPS) - - -
  NO.   NO.     X        Y        Z      LENGTH     REAL        IMAG.       MAG.        PHASE
     1    0    .0000    .0000   -.1824   .05212   1.3629E-04  6.4701E-04  6.6120E-04   78.105
     2    0    .0000    .0000   -.1303   .05212   3.6169E-04  1.7863E-03  1.8225E-03   78.553
     3    0    .0000    .0000   -.0782   .05212   5.2216E-04  2.7057E-03  2.7557E-03   79.077
     4    0    .0000    .0000   -.0261   .05212   6.0628E-04  3.3503E-03  3.4047E-03   79.743
     5    0    .0000    .0000    .0261   .05212   6.0628E-04  3.3503E-03  3.4047E-03   79.743
     6    0    .0000    .0000    .0782   .05212   5.2216E-04  2.7057E-03  2.7557E-03   79.077
     7    0    .0000    .0000    .1303   .05212   3.6169E-04  1.7863E-03  1.8225E-03   78.553
     8    0    .0000    .0000    .1824   .05212   1.3629E-04  6.4701E-04  6.6120E-04   78.105



                                        - - - POWER BUDGET - - -

                                           INPUT POWER   = 3.0849E-04 WATTS
                                           RADIATED POWER= 3.0849E-04 WATTS
                                           WIRE LOSS     = 0.0000E+00 WATTS
                                           EFFICIENCY    = 100.00 PERCENT




                                 - - - - - - FREQUENCY - - - - - -

                                    FREQUENCY= 3.0000E+02 MHZ
                                    WAVELENGTH= 9.9933E-01 METERS



                                  - - - ANTENNA ENVIRONMENT - - -

                                            FREE SPACE



                               - - - STRUCTURE IMPEDANCE LOADING - - -

                                   THIS STRUCTURE IS NOT LOADED



                                - - - MATRIX TIMING - - -

                        FILL=     .020 SEC.,  FACTOR=     .010 SEC.



                                          - - - ANTENNA INPUT PARAMETERS - - -

   TAG   SEG.    VOLTAGE (VOLTS)         CURRENT (AMPS)         IMPEDANCE (OHMS)        ADMITTANCE (MHOS)      POWER
   NO.   NO.    REAL        IMAG.       REAL        IMAG.       REAL        IMAG.       REAL        IMAG.     (WATTS)
     0 *   5 1.00000E+00 0.00000E+00 9.39002E-03-5.32895E-03 8.05525E+01 4.57145E+01 9.39002E-03-5.32895E-03 4.69501E-03



                             - - - CURRENTS AND LOCATION - - -

                     LENGTHS NORMALIZED BY WAVELENGTH (OR 2.*PI/CABS(K))

  SEG.  TAG    COORD. OF SEG. CENTER     SEG.            - - - CURRENT (AMPS) - - -
  NO.   NO.     X        Y        Z      LENGTH     REAL        IMAG.       MAG.        PHASE
     1    0    .0000    .0000   -.2189   .06254   1.9607E-03 -1.2798E-03  2.3414E-03  -33.134
     2    0    .0000    .0000   -.1564   .06254   5.3516E-03 -3.4033E-03  6.3421E-03  -32.454
     3    0    .0000    .0000   -.0938   .06254   7.8677E-03 -4.8420E-03  9.2383E-03  -31.609
     4    0    .0000    .0000   -.0313   .06254   9.2168E-03 -5.4146E-03  1.0690E-02  -30.433
     5    0    .0000    .0000    .0313   .06254   9.2168E-03 -5.4146E-03  1.0690E-02  -30.433
     6    0    .0000    .0000    .0938   .06254   7.8677E-03 -4.8420E-03  9.2383E-03  -31.609
     7    0    .0000    .0000    .1564   .06254   5.3516E-03 -3.4033E-03  6.3421E-03  -32.454
     8    0    .0000    .0000    .2189   .06254   1.9607E-03 -1.2798E-03  2.3414E-03  -33.135



                                        - - - POWER BUDGET - - -

                                           INPUT POWER   = 4.6950E-03 WATTS
                                           RADIATED POWER= 4.6950E-03 WATTS
                                           WIRE LOSS     = 0.0000E+00 WATTS
                                           EFFICIENCY    = 100.00 PERCENT



                                    - - - INPUT IMPEDANCE DATA - - -
                                             SOURCE SEGMENT NO.   5
                                             NORMALIZATION FACTOR= 5.00000E+01

       FREQ.             -  -  UNNORMALIZED IMPEDANCE  -  -                     -  -  NORMALIZED IMPEDANCE  -  -
                   RESISTANCE    REACTANCE      MAGNITUDE    PHASE       RESISTANCE    REACTANCE      MAGNITUDE    PHASE
        MHZ           OHMS          OHMS           OHMS     DEGREES                                               DEGREES

     200.000     2.65762E+01  -6.32064E+02    6.32623E+02   -87.59     5.31524E-01  -1.26413E+01    1.26525E+01   -87.59
     250.000     4.71435E+01  -2.72372E+02    2.76422E+02   -80.18     9.42869E-01  -5.44744E+00    5.52844E+00   -80.18
     300.000     8.05525E+01   4.57145E+01    9.26203E+01    29.58     1.61105E+00   9.14290E-01    1.85241E+00    29.58







 ***** INPUT LINE  4  LD   5    0    0    0  3.72000E+07  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  5  FR   0    1    0    0  3.00000E+02  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  6  EX   5    0    5    0  1.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  7  XQ   0    0    0    0  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00




                                 - - - - - - FREQUENCY - - - - - -

                                    FREQUENCY= 3.0000E+02 MHZ
                                    WAVELENGTH= 9.9933E-01 METERS



                                  - - - ANTENNA ENVIRONMENT - - -

                                            FREE SPACE



                               - - - STRUCTURE IMPEDANCE LOADING - - -


       LOCATION          RESISTANCE   INDUCTANCE  CAPACITANCE       IMPEDANCE (OHMS)     CONDUCTIVITY    TYPE
    ITAG FROM THRU          OHMS        HENRYS       FARADS        REAL      IMAGINARY    MHOS/METER

     ALL                                                                                 3.7200E+07     WIRE  



                                - - - MATRIX TIMING - - -

                        FILL=     .030 SEC.,  FACTOR=     .000 SEC.



                                          - - - ANTENNA INPUT PARAMETERS - - -

   TAG   SEG.    VOLTAGE (VOLTS)         CURRENT (AMPS)         IMPEDANCE (OHMS)        ADMITTANCE (MHOS)      POWER
   NO.   NO.    REAL        IMAG.       REAL        IMAG.       REAL        IMAG.       REAL        IMAG.     (WATTS)
     0 *   5 1.00000E+00 0.00000E+00 6.64423E-03-3.86654E-03 1.12431E+02 6.54282E+01 6.64423E-03-3.86654E-03 3.32212E-03



                             - - - CURRENTS AND LOCATION - - -

                     LENGTHS NORMALIZED BY WAVELENGTH (OR 2.*PI/CABS(K))

  SEG.  TAG    COORD. OF SEG. CENTER     SEG.            - - - CURRENT (AMPS) - - -
  NO.   NO.     X        Y        Z      LENGTH     REAL        IMAG.       MAG.        PHASE
     1    0    .0000    .0000   -.2189   .06254   1.3862E-03 -9.6304E-04  1.6879E-03  -34.790
     2    0    .0000    .0000   -.1564   .06254   3.7847E-03 -2.5546E-03  4.5662E-03  -34.018
     3    0    .0000    .0000   -.0938   .06254   5.5658E-03 -3.6090E-03  6.6335E-03  -32.961
     4    0    .0000    .0000   -.0313   .06254   6.5215E-03 -3.9782E-03  7.6391E-03  -31.384
     5    0    .0000    .0000    .0313   .06254   6.5215E-03 -3.9782E-03  7.6391E-03  -31.384
     6    0    .0000    .0000    .0938   .06254   5.5658E-03 -3.6090E-03  6.6335E-03  -32.961
     7    0    .0000    .0000    .1564   .06254   3.7847E-03 -2.5546E-03  4.5662E-03  -34.018
     8    0    .0000    .0000    .2189   .06254   1.3862E-03 -9.6304E-04  1.6879E-03  -34.790



                                        - - - POWER BUDGET - - -

                                           INPUT POWER   = 3.3221E-03 WATTS
                                           RADIATED POWER= 2.4401E-03 WATTS
                                           WIRE LOSS     = 8.8197E-04 WATTS
                                           EFFICIENCY    =  73.45 PERCENT




 ***** INPUT LINE  8  NX   0    0    0    0  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
1



                                ***********************************************
                                *                                             *
                                *  NUMERICAL ELECTROMAGNETICS CODE (NEC-4.1)  *
                                *                                             *
                                ***********************************************




                      **********************************************************

                         EXAMPLE 3.  VERTICAL HALF WAVELENGTH ANTENNA OVER GROUND                      
                                     1. PERFECT GROUND                                                 
                                     2. IMPERFECT GROUND INCLUDING GROUND WAVE AND RECEIVING           
                                        PATTERN CALCULATIONS                                           

                      **********************************************************





                                 - - - STRUCTURE SPECIFICATION - - -

                                     COORDINATES MUST BE INPUT IN
                                     METERS OR BE SCALED TO METERS
                                     BEFORE STRUCTURE INPUT IS ENDED


  WIRE                                                                               NO. OF    FIRST  LAST     TAG
  NO.        X1         Y1         Z1          X2         Y2         Z2      RADIUS   SEG.     SEG.   SEG.     NO.
     1     .00000     .00000    2.00000      .00000     .00000    7.00000     .30000      9        1     9       0

   GROUND PLANE SPECIFIED.

   WHERE WIRE ENDS TOUCH GROUND, CURRENT WILL BE INTERPOLATED TO IMAGE IN GROUND PLANE.


   TOTAL SEGMENTS USED=    9     NO. SEG. IN A SYMMETRIC CELL=    9     SYMMETRY FLAG=  0


         - MULTIPLE WIRE JUNCTIONS -
 JUNCTION    SEGMENTS  (- FOR END 1, + FOR END 2)
  NONE




                                 - - - - SEGMENTATION DATA - - - -

                                        COORDINATES IN METERS

                         I+ AND I- INDICATE THE SEGMENTS BEFORE AND AFTER I


  SEG.   COORDINATES OF SEG. CENTER     SEG.     ORIENTATION ANGLES    WIRE    CONNECTION DATA   TAG
  NO.       X         Y         Z       LENGTH     ALPHA     BETA      RADIUS    I-   I    I+    NO.
     1    .00000    .00000   2.27778    .55556   90.00000    .00000    .30000     0    1    2      0
     2    .00000    .00000   2.83333    .55556   90.00000    .00000    .30000     1    2    3      0
     3    .00000    .00000   3.38889    .55556   90.00000    .00000    .30000     2    3    4      0
     4    .00000    .00000   3.94444    .55556   90.00000    .00000    .30000     3    4    5      0
     5    .00000    .00000   4.50000    .55556   90.00000    .00000    .30000     4    5    6      0
     6    .00000    .00000   5.05556    .55556   90.00000    .00000    .30000     5    6    7      0
     7    .00000    .00000   5.61111    .55556   90.00000    .00000    .30000     6    7    8      0
     8    .00000    .00000   6.16667    .55556   90.00000    .00000    .30000     7    8    9      0
     9    .00000    .00000   6.72222    .55556   90.00000    .00000    .30000     8    9    0      0




 ***** INPUT LINE  1  FR   0    1    0    0  3.00000E+01  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  2  EX   0    0    5    0  1.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  3  GN   1    0    0    0  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  4  RP   0   10    2 1301  0.00000E+00  0.00000E+00  1.00000E+01  9.00000E+01  0.00000E+00  0.00000E+00




                                 - - - - - - FREQUENCY - - - - - -

                                    FREQUENCY= 3.0000E+01 MHZ
                                    WAVELENGTH= 9.9933E+00 METERS



                                  - - - ANTENNA ENVIRONMENT - - -

                                          PERFECT GROUND



                               - - - STRUCTURE IMPEDANCE LOADING - - -

                                   THIS STRUCTURE IS NOT LOADED



                                - - - MATRIX TIMING - - -

                        FILL=     .050 SEC.,  FACTOR=     .000 SEC.



                                          - - - ANTENNA INPUT PARAMETERS - - -

   TAG   SEG.    VOLTAGE (VOLTS)         CURRENT (AMPS)         IMPEDANCE (OHMS)        ADMITTANCE (MHOS)      POWER
   NO.   NO.    REAL        IMAG.       REAL        IMAG.       REAL        IMAG.       REAL        IMAG.     (WATTS)
     0     5 1.00000E+00 0.00000E+00 9.45359E-03-2.45171E-05 1.05779E+02 2.74330E-01 9.45359E-03-2.45171E-05 4.72680E-03



                             - - - CURRENTS AND LOCATION - - -

                     LENGTHS NORMALIZED BY WAVELENGTH (OR 2.*PI/CABS(K))

  SEG.  TAG    COORD. OF SEG. CENTER     SEG.            - - - CURRENT (AMPS) - - -
  NO.   NO.     X        Y        Z      LENGTH     REAL        IMAG.       MAG.        PHASE
     1    0    .0000    .0000    .2279   .05559   2.8919E-03 -2.5813E-03  3.8763E-03  -41.752
     2    0    .0000    .0000    .2835   .05559   5.5642E-03 -4.1603E-03  6.9475E-03  -36.785
     3    0    .0000    .0000    .3391   .05559   7.5810E-03 -4.6063E-03  8.8707E-03  -31.283
     4    0    .0000    .0000    .3947   .05559   8.9151E-03 -4.0180E-03  9.7787E-03  -24.261
     5    0    .0000    .0000    .4503   .05559   9.4536E-03 -2.4517E-05  9.4536E-03    -.149
     6    0    .0000    .0000    .5059   .05559   9.1337E-03 -4.0356E-03  9.9855E-03  -23.838
     7    0    .0000    .0000    .5615   .05559   7.9642E-03 -4.6311E-03  9.2128E-03  -30.178
     8    0    .0000    .0000    .6171   .05559   6.0055E-03 -4.1764E-03  7.3149E-03  -34.816
     9    0    .0000    .0000    .6727   .05559   3.2249E-03 -2.5767E-03  4.1278E-03  -38.625



                                        - - - POWER BUDGET - - -

                                           INPUT POWER   = 4.7268E-03 WATTS
                                           RADIATED POWER= 4.7268E-03 WATTS
                                           WIRE LOSS     = 0.0000E+00 WATTS
                                           EFFICIENCY    = 100.00 PERCENT



                                                - - - RADIATION PATTERNS - - -

  - - ANGLES - -          - POWER GAINS -        - - - POLARIZATION - - -    - - - E(THETA) - - -    - - - E(PHI) - - -
  THETA     PHI        VERT.   HOR.    TOTAL      AXIAL     TILT   SENSE     MAGNITUDE    PHASE      MAGNITUDE    PHASE 
 DEGREES  DEGREES       DB      DB      DB        RATIO     DEG.               VOLTS     DEGREES       VOLTS     DEGREES
     .00      .00    -999.99 -999.99 -999.99     .00000      .00            0.00000E+00      .00    0.00000E+00      .00
   10.00      .00      -9.88 -999.99   -9.88     .00000      .00  LINEAR    1.70726E-01  -113.54    0.00000E+00      .00
   20.00      .00      -4.21 -999.99   -4.21     .00000      .00  LINEAR    3.27688E-01  -113.81    0.00000E+00      .00
   30.00      .00      -1.71 -999.99   -1.71     .00000      .00  LINEAR    4.37005E-01  -114.19    0.00000E+00      .00
   40.00      .00      -1.76 -999.99   -1.76     .00000      .00  LINEAR    4.34908E-01  -114.57    0.00000E+00      .00
   50.00      .00      -6.75 -999.99   -6.75     .00000      .00  LINEAR    2.44874E-01  -114.53    0.00000E+00      .00
   60.00      .00     -10.06 -999.99  -10.06     .00000      .00  LINEAR    1.67177E-01    62.40    0.00000E+00      .00
   70.00      .00       2.65 -999.99    2.65     .00000      .00  LINEAR    7.22664E-01    63.29    0.00000E+00      .00
   80.00      .00       7.18 -999.99    7.18     .00000      .00  LINEAR    1.21714E+00    63.24    0.00000E+00      .00
   90.00      .00       8.50 -999.99    8.50     .00000      .00  LINEAR    1.41677E+00    63.20    0.00000E+00      .00
     .00    90.00    -999.99 -999.99 -999.99     .00000      .00            0.00000E+00      .00    0.00000E+00      .00
   10.00    90.00      -9.88 -999.99   -9.88     .00000      .00  LINEAR    1.70726E-01  -113.54    0.00000E+00      .00
   20.00    90.00      -4.21 -999.99   -4.21     .00000      .00  LINEAR    3.27688E-01  -113.81    0.00000E+00      .00
   30.00    90.00      -1.71 -999.99   -1.71     .00000      .00  LINEAR    4.37005E-01  -114.19    0.00000E+00      .00
   40.00    90.00      -1.76 -999.99   -1.76     .00000      .00  LINEAR    4.34908E-01  -114.57    0.00000E+00      .00
   50.00    90.00      -6.75 -999.99   -6.75     .00000      .00  LINEAR    2.44874E-01  -114.53    0.00000E+00      .00
   60.00    90.00     -10.06 -999.99  -10.06     .00000      .00  LINEAR    1.67177E-01    62.40    0.00000E+00      .00
   70.00    90.00       2.65 -999.99    2.65     .00000      .00  LINEAR    7.22664E-01    63.29    0.00000E+00      .00
   80.00    90.00       7.18 -999.99    7.18     .00000      .00  LINEAR    1.21714E+00    63.24    0.00000E+00      .00
   90.00    90.00       8.50 -999.99    8.50     .00000      .00  LINEAR    1.41677E+00    63.20    0.00000E+00      .00


   AVERAGE POWER GAIN= 2.01877E+00       SOLID ANGLE USED IN AVERAGING=(  .5000)*PI STERADIANS.

   POWER RADIATED ASSUMING RADIATION INTO 4*PI STERADIANS = 9.54230E-03 WATTS




                                     - - - - NORMALIZED GAIN - - - -

                                        VERTICAL GAIN
                                      NORMALIZATION FACTOR =     8.50 DB

    - - ANGLES - -      GAIN           - - ANGLES - -      GAIN           - - ANGLES - -      GAIN
    THETA     PHI        DB            THETA     PHI        DB            THETA     PHI        DB
   DEGREES  DEGREES                   DEGREES  DEGREES                   DEGREES  DEGREES
       .00      .00  -1008.49           70.00      .00     -5.85           40.00    90.00    -10.26
     10.00      .00    -18.38           80.00      .00     -1.32           50.00    90.00    -15.25
     20.00      .00    -12.72           90.00      .00       .00           60.00    90.00    -18.56
     30.00      .00    -10.22             .00    90.00  -1008.49           70.00    90.00     -5.85
     40.00      .00    -10.26           10.00    90.00    -18.38           80.00    90.00     -1.32
     50.00      .00    -15.25           20.00    90.00    -12.72           90.00    90.00       .00
     60.00      .00    -18.56           30.00    90.00    -10.22      




 ***** INPUT LINE  5  GN   0    0    0    0  6.00000E+00  1.00000E-03  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  6  RP   0   10    2 1301  0.00000E+00  0.00000E+00  1.00000E+01  9.00000E+01  0.00000E+00  0.00000E+00




                                 - - - - - - FREQUENCY - - - - - -

                                    FREQUENCY= 3.0000E+01 MHZ
                                    WAVELENGTH= 9.9933E+00 METERS



                                  - - - ANTENNA ENVIRONMENT - - -

                                        FINITE GROUND.  REFLECTION COEFFICIENT APPROXIMATION
                                        RELATIVE DIELECTRIC CONST.=  6.000
                                        CONDUCTIVITY= 1.000E-03 MHOS/METER
                                        COMPLEX DIELECTRIC CONSTANT= 6.00000E+00-5.99183E-01



                               - - - STRUCTURE IMPEDANCE LOADING - - -

                                   THIS STRUCTURE IS NOT LOADED



                                - - - MATRIX TIMING - - -

                        FILL=     .050 SEC.,  FACTOR=     .000 SEC.



                                          - - - ANTENNA INPUT PARAMETERS - - -

   TAG   SEG.    VOLTAGE (VOLTS)         CURRENT (AMPS)         IMPEDANCE (OHMS)        ADMITTANCE (MHOS)      POWER
   NO.   NO.    REAL        IMAG.       REAL        IMAG.       REAL        IMAG.       REAL        IMAG.     (WATTS)
     0     5 1.00000E+00 0.00000E+00 9.04515E-03-5.38014E-05 1.10553E+02 6.57577E-01 9.04515E-03-5.38014E-05 4.52258E-03



                             - - - CURRENTS AND LOCATION - - -

                     LENGTHS NORMALIZED BY WAVELENGTH (OR 2.*PI/CABS(K))

  SEG.  TAG    COORD. OF SEG. CENTER     SEG.            - - - CURRENT (AMPS) - - -
  NO.   NO.     X        Y        Z      LENGTH     REAL        IMAG.       MAG.        PHASE
     1    0    .0000    .0000    .2279   .05559   2.8751E-03 -2.5567E-03  3.8475E-03  -41.646
     2    0    .0000    .0000    .2835   .05559   5.4615E-03 -4.1520E-03  6.8605E-03  -37.243
     3    0    .0000    .0000    .3391   .05559   7.3684E-03 -4.6190E-03  8.6965E-03  -32.082
     4    0    .0000    .0000    .3947   .05559   8.5928E-03 -4.0447E-03  9.4972E-03  -25.207
     5    0    .0000    .0000    .4503   .05559   9.0452E-03 -5.3801E-05  9.0453E-03    -.341
     6    0    .0000    .0000    .5059   .05559   8.6815E-03 -4.0567E-03  9.5826E-03  -25.046
     7    0    .0000    .0000    .5615   .05559   7.5241E-03 -4.6375E-03  8.8384E-03  -31.648
     8    0    .0000    .0000    .6171   .05559   5.6410E-03 -4.1681E-03  7.0139E-03  -36.461
     9    0    .0000    .0000    .6727   .05559   3.0109E-03 -2.5621E-03  3.9535E-03  -40.396



                                        - - - POWER BUDGET - - -

                                           INPUT POWER   = 4.5226E-03 WATTS
                                           RADIATED POWER= 4.5226E-03 WATTS
                                           WIRE LOSS     = 0.0000E+00 WATTS
                                           EFFICIENCY    = 100.00 PERCENT



                                                - - - RADIATION PATTERNS - - -

  - - ANGLES - -          - POWER GAINS -        - - - POLARIZATION - - -    - - - E(THETA) - - -    - - - E(PHI) - - -
  THETA     PHI        VERT.   HOR.    TOTAL      AXIAL     TILT   SENSE     MAGNITUDE    PHASE      MAGNITUDE    PHASE 
 DEGREES  DEGREES       DB      DB      DB        RATIO     DEG.               VOLTS     DEGREES       VOLTS     DEGREES
     .00      .00    -999.99 -999.99 -999.99     .00000      .00            0.00000E+00      .00    0.00000E+00      .00
   10.00      .00     -12.88 -999.99  -12.88     .00000      .00  LINEAR    1.18226E-01  -123.90    0.00000E+00      .00
   20.00      .00      -7.19 -999.99   -7.19     .00000      .00  LINEAR    2.27567E-01  -128.12    0.00000E+00      .00
   30.00      .00      -4.48 -999.99   -4.48     .00000      .00  LINEAR    3.10746E-01  -136.54    0.00000E+00      .00
   40.00      .00      -3.47 -999.99   -3.47     .00000      .00  LINEAR    3.49292E-01  -152.66    0.00000E+00      .00
   50.00      .00      -2.96 -999.99   -2.96     .00000      .00  LINEAR    3.70490E-01   177.80    0.00000E+00      .00
   60.00      .00       -.81 -999.99    -.81     .00000      .00  LINEAR    4.74476E-01   142.78    0.00000E+00      .00
   70.00      .00       1.52 -999.99    1.52     .00000      .00  LINEAR    6.20232E-01   121.07    0.00000E+00      .00
   80.00      .00        .62 -999.99     .62     .00000      .00  LINEAR    5.59348E-01   111.10    0.00000E+00      .00
   90.00      .00    -125.10 -999.99 -125.10     .00000      .00  LINEAR    2.89517E-07   -75.96    0.00000E+00      .00
     .00    90.00    -999.99 -999.99 -999.99     .00000      .00            0.00000E+00      .00    0.00000E+00      .00
   10.00    90.00     -12.88 -999.99  -12.88     .00000      .00  LINEAR    1.18226E-01  -123.90    0.00000E+00      .00
   20.00    90.00      -7.19 -999.99   -7.19     .00000      .00  LINEAR    2.27567E-01  -128.12    0.00000E+00      .00
   30.00    90.00      -4.48 -999.99   -4.48     .00000      .00  LINEAR    3.10746E-01  -136.54    0.00000E+00      .00
   40.00    90.00      -3.47 -999.99   -3.47     .00000      .00  LINEAR    3.49292E-01  -152.66    0.00000E+00      .00
   50.00    90.00      -2.96 -999.99   -2.96     .00000      .00  LINEAR    3.70490E-01   177.80    0.00000E+00      .00
   60.00    90.00       -.81 -999.99    -.81     .00000      .00  LINEAR    4.74476E-01   142.78    0.00000E+00      .00
   70.00    90.00       1.52 -999.99    1.52     .00000      .00  LINEAR    6.20232E-01   121.07    0.00000E+00      .00
   80.00    90.00        .62 -999.99     .62     .00000      .00  LINEAR    5.59348E-01   111.10    0.00000E+00      .00
   90.00    90.00    -125.10 -999.99 -125.10     .00000      .00  LINEAR    2.89517E-07   -75.96    0.00000E+00      .00


   AVERAGE POWER GAIN= 7.17751E-01       SOLID ANGLE USED IN AVERAGING=(  .5000)*PI STERADIANS.

   POWER RADIATED ASSUMING RADIATION INTO 4*PI STERADIANS = 3.24608E-03 WATTS




                                     - - - - NORMALIZED GAIN - - - -

                                        VERTICAL GAIN
                                      NORMALIZATION FACTOR =     1.52 DB

    - - ANGLES - -      GAIN           - - ANGLES - -      GAIN           - - ANGLES - -      GAIN
    THETA     PHI        DB            THETA     PHI        DB            THETA     PHI        DB
   DEGREES  DEGREES                   DEGREES  DEGREES                   DEGREES  DEGREES
       .00      .00  -1001.51           70.00      .00       .00           40.00    90.00     -4.99
     10.00      .00    -14.40           80.00      .00      -.90           50.00    90.00     -4.48
     20.00      .00     -8.71           90.00      .00   -126.62           60.00    90.00     -2.33
     30.00      .00     -6.00             .00    90.00  -1001.51           70.00    90.00       .00
     40.00      .00     -4.99           10.00    90.00    -14.40           80.00    90.00      -.90
     50.00      .00     -4.48           20.00    90.00     -8.71           90.00    90.00   -126.62
     60.00      .00     -2.33           30.00    90.00     -6.00      




 ***** INPUT LINE  7  RP   1   10    1    0  1.00000E+00  0.00000E+00  2.00000E+00  0.00000E+00  1.00000E+05  0.00000E+00



                             - - - RADIATED FIELDS NEAR GROUND - - -

        - - - LOCATION - - -          - - E(THETA) - -        - - E(PHI) - -        - - E(RADIAL) - -
       RHO      PHI         Z            MAG      PHASE         MAG      PHASE         MAG      PHASE
     METERS   DEGREES    METERS        VOLTS/M   DEGREES      VOLTS/M   DEGREES      VOLTS/M   DEGREES

   100000.00      .00       1.00     2.5165E-09   138.98    0.0000E+00      .00    8.3425E-10   -44.65
   100000.00      .00       3.00     3.1256E-09   147.43    0.0000E+00      .00    8.3494E-10   -44.70
   100000.00      .00       5.00     3.7802E-09   153.05    0.0000E+00      .00    8.3562E-10   -44.75
   100000.00      .00       7.00     4.4602E-09   156.98    0.0000E+00      .00    8.3631E-10   -44.80
   100000.00      .00       9.00     5.1555E-09   159.86    0.0000E+00      .00    8.3700E-10   -44.85
   100000.00      .00      11.00     5.8606E-09   162.05    0.0000E+00      .00    8.3769E-10   -44.90
   100000.00      .00      13.00     6.5725E-09   163.77    0.0000E+00      .00    8.3838E-10   -44.95
   100000.00      .00      15.00     7.2890E-09   165.15    0.0000E+00      .00    8.3907E-10   -45.00
   100000.00      .00      17.00     8.0081E-09   166.18    0.0000E+00      .00    8.4253E-10   -45.37
   100000.00      .00      19.00     8.7317E-09   167.02    0.0000E+00      .00    8.4748E-10   -45.77






 ***** INPUT LINE  8  EX   1   10    1    0  0.00000E+00  0.00000E+00  0.00000E+00  1.00000E+01  0.00000E+00  0.00000E+00
 ***** INPUT LINE  9  PT   2    0    5    5  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE 10  XQ   0    0    0    0  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00



                                 - - - RECEIVING PATTERN PARAMETERS - - -
                                           ETA=    .00 DEGREES
                                           TYPE -LINEAR
                                           AXIAL RATIO=  .000

           THETA      PHI          -  CURRENT  -         SEG
           (DEG)     (DEG)       MAGNITUDE    PHASE      NO.

              .00       .00     0.0000E+00       .00        5
            10.00       .00     6.2726E-03    -33.91        5
            20.00       .00     1.2071E-02    -38.13        5
            30.00       .00     1.6476E-02    -46.55        5
            40.00       .00     1.8511E-02    -62.66        5
            50.00       .00     1.9625E-02    -92.20        5
            60.00       .00     2.5121E-02   -127.22        5
            70.00       .00     3.2827E-02   -148.93        5
            80.00       .00     2.9598E-02   -158.89        5
            90.00       .00     1.2238E-08     17.31        5



                                - - - NORMALIZED RECEIVING PATTERN - - -
                                         NORMALIZATION FACTOR= 3.2827E-02
                                         ETA=    .00 DEGREES
                                         TYPE -LINEAR
                                         AXIAL RATIO=  .000
                                         SEGMENT NO.=    5

                     THETA      PHI         -  PATTERN  -
                     (DEG)     (DEG)        DB        MAGNITUDE

                        .00       .00    -999.99     0.0000E+00
                      10.00       .00     -14.38     1.9108E-01
                      20.00       .00      -8.69     3.6771E-01
                      30.00       .00      -5.99     5.0191E-01
                      40.00       .00      -4.98     5.6390E-01
                      50.00       .00      -4.47     5.9783E-01
                      60.00       .00      -2.32     7.6527E-01
                      70.00       .00        .00     1.0000E+00
                      80.00       .00       -.90     9.0163E-01
                      90.00       .00    -128.57     3.7282E-07




 ***** INPUT LINE 11  NX   0    0    0    0  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
1



                                ***********************************************
                                *                                             *
                                *  NUMERICAL ELECTROMAGNETICS CODE (NEC-4.1)  *
                                *                                             *
                                ***********************************************




                      **********************************************************

                         EXAMPLE 4.  T ANTENNA ON A BOX OVER PERFECT GROUND                            

                      **********************************************************





                                 - - - STRUCTURE SPECIFICATION - - -

                                     COORDINATES MUST BE INPUT IN
                                     METERS OR BE SCALED TO METERS
                                     BEFORE STRUCTURE INPUT IS ENDED


  WIRE                                                                               NO. OF    FIRST  LAST     TAG
  NO.        X1         Y1         Z1          X2         Y2         Z2      RADIUS   SEG.     SEG.   SEG.     NO.
     1P    .10000     .05000     .05000      .00000     .00000     .01000
     2P    .05000     .10000     .05000      .00000   90.00000     .01000
      STRUCTURE REFLECTED ALONG THE AXES X Y  .  TAGS INCREMENTED BY    0
     9P    .00000     .00000     .10000    90.00000     .00000     .04000
     1     .00000     .00000     .10000      .00000     .00000     .30000     .00100      4        1     4       1
     2     .00000     .00000     .30000      .15000     .00000     .30000     .00100      2        5     6       2
     3     .00000     .00000     .30000     -.15000     .00000     .30000     .00100      2        7     8       3

   GROUND PLANE SPECIFIED.

   WHERE WIRE ENDS TOUCH GROUND, CURRENT WILL BE INTERPOLATED TO IMAGE IN GROUND PLANE.


   TOTAL SEGMENTS USED=    8     NO. SEG. IN A SYMMETRIC CELL=    8     SYMMETRY FLAG=  0
   TOTAL PATCHES USED=   12      NO. PATCHES IN A SYMMETRIC CELL=   12


         - MULTIPLE WIRE JUNCTIONS -
 JUNCTION    SEGMENTS  (- FOR END 1, + FOR END 2)
     1         4   -5   -7




                                 - - - - SEGMENTATION DATA - - - -

                                        COORDINATES IN METERS

                         I+ AND I- INDICATE THE SEGMENTS BEFORE AND AFTER I


  SEG.   COORDINATES OF SEG. CENTER     SEG.     ORIENTATION ANGLES    WIRE    CONNECTION DATA   TAG
  NO.       X         Y         Z       LENGTH     ALPHA     BETA      RADIUS    I-   I    I+    NO.
     1    .00000    .00000    .12500    .05000   90.00000    .00000    .00100 10009    1    2      1
     2    .00000    .00000    .17500    .05000   90.00000    .00000    .00100     1    2    3      1
     3    .00000    .00000    .22500    .05000   90.00000    .00000    .00100     2    3    4      1
     4    .00000    .00000    .27500    .05000   90.00000    .00000    .00100     3    4    5      1
     5    .03750    .00000    .30000    .07500     .00000    .00000    .00100    -7    5    6      2
     6    .11250    .00000    .30000    .07500     .00000    .00000    .00100     5    6    0      2
     7   -.03750    .00000    .30000    .07500     .00000 180.00000    .00100     4    7    8      3
     8   -.11250    .00000    .30000    .07500     .00000 180.00000    .00100     7    8    0      3




                                            - - - SURFACE PATCH DATA - - -

                                                 COORDINATES IN METERS

 PATCH     COORD. OF PATCH CENTER       UNIT NORMAL VECTOR      PATCH            COMPONENTS OF UNIT TANGENT VECTORS
  NO.      X         Y         Z         X       Y       Z       AREA       X1      Y1      Z1       X2      Y2      Z2
    1    .10000    .05000    .05000   1.0000   .0000   .0000    .01000    .0000  1.0000   .0000    .0000   .0000  1.0000
    2    .05000    .10000    .05000    .0000  1.0000   .0000    .01000  -1.0000   .0000   .0000    .0000   .0000  1.0000
    3    .10000   -.05000    .05000   1.0000   .0000   .0000    .01000    .0000 -1.0000   .0000    .0000   .0000  1.0000
    4    .05000   -.10000    .05000    .0000 -1.0000   .0000    .01000  -1.0000   .0000   .0000    .0000   .0000  1.0000
    5   -.10000    .05000    .05000  -1.0000   .0000   .0000    .01000    .0000  1.0000   .0000    .0000   .0000  1.0000
    6   -.05000    .10000    .05000    .0000  1.0000   .0000    .01000   1.0000   .0000   .0000    .0000   .0000  1.0000
    7   -.10000   -.05000    .05000  -1.0000   .0000   .0000    .01000    .0000 -1.0000   .0000    .0000   .0000  1.0000
    8   -.05000   -.10000    .05000    .0000 -1.0000   .0000    .01000   1.0000   .0000   .0000    .0000   .0000  1.0000
    9    .05000    .05000    .10000    .0000   .0000  1.0000    .01000   1.0000   .0000   .0000    .0000  1.0000   .0000
   10   -.05000    .05000    .10000    .0000   .0000  1.0000    .01000   1.0000   .0000   .0000    .0000  1.0000   .0000
   11   -.05000   -.05000    .10000    .0000   .0000  1.0000    .01000   1.0000   .0000   .0000    .0000  1.0000   .0000
   12    .05000   -.05000    .10000    .0000   .0000  1.0000    .01000   1.0000   .0000   .0000    .0000  1.0000   .0000




 ***** INPUT LINE  1  GN   1    0    0    0  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  2  EX   0    1    1    0  1.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  3  RP   0   10    4 1001  0.00000E+00  0.00000E+00  1.00000E+01  3.00000E+01  0.00000E+00  0.00000E+00




                                 - - - - - - FREQUENCY - - - - - -

                                    FREQUENCY= 2.9980E+02 MHZ
                                    WAVELENGTH= 1.0000E+00 METERS



                                  - - - ANTENNA ENVIRONMENT - - -

                                          PERFECT GROUND



                               - - - STRUCTURE IMPEDANCE LOADING - - -

                                   THIS STRUCTURE IS NOT LOADED



                                - - - MATRIX TIMING - - -

                        FILL=     .150 SEC.,  FACTOR=     .040 SEC.



                                          - - - ANTENNA INPUT PARAMETERS - - -

   TAG   SEG.    VOLTAGE (VOLTS)         CURRENT (AMPS)         IMPEDANCE (OHMS)        ADMITTANCE (MHOS)      POWER
   NO.   NO.    REAL        IMAG.       REAL        IMAG.       REAL        IMAG.       REAL        IMAG.     (WATTS)
     1     1 1.00000E+00 0.00000E+00 2.17993E-03-2.66254E-03 1.84097E+02 2.24854E+02 2.17993E-03-2.66254E-03 1.08996E-03



                             - - - CURRENTS AND LOCATION - - -

                     LENGTHS NORMALIZED BY WAVELENGTH (OR 2.*PI/CABS(K))

  SEG.  TAG    COORD. OF SEG. CENTER     SEG.            - - - CURRENT (AMPS) - - -
  NO.   NO.     X        Y        Z      LENGTH     REAL        IMAG.       MAG.        PHASE
     1    1    .0000    .0000    .1250   .05000   2.1799E-03 -2.6625E-03  3.4411E-03  -50.691
     2    1    .0000    .0000    .1750   .05000   2.1579E-03 -3.4413E-03  4.0619E-03  -57.911
     3    1    .0000    .0000    .2250   .05000   2.0988E-03 -3.8734E-03  4.4055E-03  -61.549
     4    1    .0000    .0000    .2750   .05000   1.9793E-03 -3.8860E-03  4.3611E-03  -63.008
     5    2    .0375    .0000    .3000   .07500   7.9588E-04 -1.5851E-03  1.7737E-03  -63.340
     6    2    .1125    .0000    .3000   .07500   3.1430E-04 -6.4731E-04  7.1957E-04  -64.101
     7    3   -.0375    .0000    .3000   .07500   7.9588E-04 -1.5851E-03  1.7737E-03  -63.339
     8    3   -.1125    .0000    .3000   .07500   3.1430E-04 -6.4730E-04  7.1957E-04  -64.101




                                         - - - - SURFACE PATCH CURRENTS - - - -

                                                  DISTANCES IN WAVELENGTHS (2.*PI/CABS(K))
                                                  CURRENT IN AMPS/METER

                            - - SURFACE COMPONENTS - -                   - - - RECTANGULAR COMPONENTS - - -
      PATCH CENTER      TANGENT VECTOR 1   TANGENT VECTOR 2           X                   Y                   Z
     X      Y      Z     MAG.       PHASE   MAG.       PHASE    REAL      IMAG.     REAL      IMAG.     REAL      IMAG. 
    1
    .100   .050   .050 1.1832E-03  111.34 8.2597E-03 -116.30  0.00E+00  0.00E+00 -4.30E-04  1.10E-03 -3.66E-03 -7.40E-03
    2
    .050   .100   .050 1.1755E-03  -68.82 8.0984E-03 -117.13 -4.25E-04  1.10E-03 -1.86E-11  4.79E-11 -3.69E-03 -7.21E-03
    3
    .100  -.050   .050 1.1832E-03  111.34 8.2597E-03 -116.30  0.00E+00  0.00E+00  4.30E-04 -1.10E-03 -3.66E-03 -7.40E-03
    4
    .050  -.100   .050 1.1755E-03  -68.82 8.0984E-03 -117.13 -4.25E-04  1.10E-03  1.86E-11 -4.79E-11 -3.69E-03 -7.21E-03
    5
   -.100   .050   .050 1.1832E-03  111.34 8.2597E-03 -116.30  0.00E+00  0.00E+00 -4.30E-04  1.10E-03 -3.66E-03 -7.40E-03
    6
   -.050   .100   .050 1.1755E-03  -68.82 8.0984E-03 -117.13  4.25E-04 -1.10E-03 -1.86E-11  4.79E-11 -3.69E-03 -7.21E-03
    7
   -.100  -.050   .050 1.1832E-03  111.34 8.2597E-03 -116.30  0.00E+00  0.00E+00  4.30E-04 -1.10E-03 -3.66E-03 -7.40E-03
    8
   -.050  -.100   .050 1.1755E-03  -68.82 8.0984E-03 -117.13  4.25E-04 -1.10E-03  1.86E-11 -4.79E-11 -3.69E-03 -7.21E-03
    9
    .050   .050   .100 6.8284E-03  111.24 6.6278E-03  111.27 -2.47E-03  6.36E-03 -2.40E-03  6.18E-03  0.00E+00  0.00E+00
   10
   -.050   .050   .100 6.8284E-03  -68.76 6.6278E-03  111.27  2.47E-03 -6.36E-03 -2.40E-03  6.18E-03  0.00E+00  0.00E+00
   11
   -.050  -.050   .100 6.8284E-03  -68.76 6.6278E-03  -68.73  2.47E-03 -6.36E-03  2.40E-03 -6.18E-03  0.00E+00  0.00E+00
   12
    .050  -.050   .100 6.8284E-03  111.24 6.6278E-03  -68.73 -2.47E-03  6.36E-03  2.40E-03 -6.18E-03  0.00E+00  0.00E+00



                                        - - - POWER BUDGET - - -

                                           INPUT POWER   = 1.0900E-03 WATTS
                                           RADIATED POWER= 1.0900E-03 WATTS
                                           WIRE LOSS     = 0.0000E+00 WATTS
                                           EFFICIENCY    = 100.00 PERCENT



                                                - - - RADIATION PATTERNS - - -

  - - ANGLES - -          - POWER GAINS -        - - - POLARIZATION - - -    - - - E(THETA) - - -    - - - E(PHI) - - -
  THETA     PHI        VERT.   HOR.    TOTAL      AXIAL     TILT   SENSE     MAGNITUDE    PHASE      MAGNITUDE    PHASE 
 DEGREES  DEGREES       DB      DB      DB        RATIO     DEG.               VOLTS     DEGREES       VOLTS     DEGREES
     .00      .00    -134.22 -142.13 -133.57     .11379    21.13  LEFT      4.97118E-08   -94.62    2.00102E-08   -75.69
   10.00      .00     -13.76 -142.34  -13.76     .00000      .00  LINEAR    5.24152E-02    -8.09    1.95206E-08   -76.83
   20.00      .00      -7.53 -142.31   -7.53     .00000      .00  LINEAR    1.07389E-01    -6.16    1.95866E-08   -69.84
   30.00      .00      -3.71 -143.52   -3.71     .00000      .00  LINEAR    1.66732E-01    -3.44    1.70369E-08   -67.37
   40.00      .00       -.90 -144.25    -.90     .00000      .00  LINEAR    2.30546E-01     -.47    1.56671E-08   -66.58
   50.00      .00       1.28 -146.50    1.28     .00000      .00  LINEAR    2.96354E-01     2.31    1.20910E-08   -70.90
   60.00      .00       2.95 -148.74    2.95     .00000      .00  LINEAR    3.58947E-01     4.60    9.34847E-09   -64.46
   70.00      .00       4.13 -152.29    4.13     .00000      .00  LINEAR    4.11285E-01     6.28    6.21332E-09   -76.94
   80.00      .00       4.84 -156.86    4.84     .00000      .00  LINEAR    4.46239E-01     7.29    3.66976E-09   -52.49
   90.00      .00       5.07 -170.41    5.07     .00000      .00  LINEAR    4.58537E-01     7.63    7.70776E-10     8.95
     .00    30.00    -133.73 -148.02 -133.57     .11379    -8.87  LEFT      5.26162E-08   -91.08    1.01589E-08    51.80
   10.00    30.00     -14.02  -37.74  -14.00     .03788    -3.04  RIGHT     5.08749E-02    -9.29    3.31671E-03  -153.65
   20.00    30.00      -7.78  -31.70   -7.76     .03512    -3.04  RIGHT     1.04393E-01    -7.22    6.65068E-03  -153.65
   30.00    30.00      -3.93  -28.28   -3.92     .03081    -2.99  RIGHT     1.62562E-01    -4.29    9.85483E-03  -153.65
   40.00    30.00      -1.08  -26.20   -1.07     .02548    -2.82  RIGHT     2.25791E-01    -1.09    1.25178E-02  -153.65
   50.00    30.00       1.15  -25.23    1.16     .01980    -2.50  RIGHT     2.91871E-01     1.90    1.39927E-02  -153.65
   60.00    30.00       2.87  -25.49    2.87     .01428    -2.03  RIGHT     3.55596E-01     4.37    1.35918E-02  -153.65
   70.00    30.00       4.09  -27.40    4.10     .00918    -1.43  RIGHT     4.09539E-01     6.17    1.09041E-02  -153.65
   80.00    30.00       4.83  -32.45    4.83     .00447     -.74  RIGHT     4.45896E-01     7.26    6.09517E-03  -153.65
   90.00    30.00       5.08 -157.30    5.08     .00000      .00  LINEAR    4.58750E-01     7.62    3.48711E-09     7.16
     .00    60.00    -135.76 -137.59 -133.57     .11379   -38.87  LEFT      4.16298E-08   -86.86    3.37436E-08    79.87
   10.00    60.00     -14.55  -37.73  -14.53     .04285    -3.12  RIGHT     4.78614E-02   -11.92    3.32117E-03  -153.66
   20.00    60.00      -8.29  -31.65   -8.27     .03966    -3.15  RIGHT     9.84705E-02    -9.54    6.68450E-03  -153.66
   30.00    60.00      -4.39  -28.19   -4.37     .03457    -3.12  RIGHT     1.54197E-01    -6.15    9.95788E-03  -153.68
   40.00    60.00      -1.46  -26.06   -1.44     .02825    -2.96  RIGHT     2.16095E-01    -2.44    1.27252E-02  -153.69
   50.00    60.00        .87  -25.04     .88     .02157    -2.62  RIGHT     2.82571E-01     1.04    1.43094E-02  -153.70
   60.00    60.00       2.69  -25.25    2.70     .01526    -2.12  RIGHT     3.48500E-01     3.90    1.39723E-02  -153.71
   70.00    60.00       4.01  -27.13    4.01     .00963    -1.49  RIGHT     4.05698E-01     5.97    1.12550E-02  -153.71
   80.00    60.00       4.81  -32.16    4.81     .00463     -.77  RIGHT     4.44953E-01     7.21    6.30753E-03  -153.71
   90.00    60.00       5.08 -163.71    5.08     .00000      .00  LINEAR    4.58964E-01     7.62    1.66760E-09   172.94
     .00    90.00    -142.13 -134.22 -133.57     .11379   -68.87  LEFT      2.00102E-08   -75.69    4.97118E-08    85.38
   10.00    90.00     -14.82 -134.46  -14.82     .00000      .00  LINEAR    4.63931E-02   -13.37    4.83716E-08    87.24
   20.00    90.00      -8.55 -134.20   -8.55     .00000      .00  LINEAR    9.55519E-02   -10.81    4.98180E-08    85.06
   30.00    90.00      -4.63 -133.81   -4.63     .00000      .00  LINEAR    1.50010E-01    -7.17    5.21315E-08    86.21
   40.00    90.00      -1.66 -133.45   -1.66     .00000      .00  LINEAR    2.11160E-01    -3.17    5.43397E-08    87.08
   50.00    90.00        .72 -134.11     .72     .00000      .00  LINEAR    2.77755E-01      .57    5.03796E-08    80.74
   60.00    90.00       2.60 -135.46    2.60     .00000      .00  LINEAR    3.44753E-01     3.64    4.31289E-08    80.39
   70.00    90.00       3.97 -137.37    3.97     .00000      .00  LINEAR    4.03602E-01     5.87    3.46152E-08    76.72
   80.00    90.00       4.80 -143.90    4.80     .00000      .00  LINEAR    4.44352E-01     7.19    1.63203E-08    78.70
   90.00    90.00       5.08 -162.46    5.08     .00000      .00  LINEAR    4.58965E-01     7.63    1.92597E-09   162.97


   AVERAGE POWER GAIN= 1.80189E+00       SOLID ANGLE USED IN AVERAGING=(  .5000)*PI STERADIANS.

   POWER RADIATED ASSUMING RADIATION INTO 4*PI STERADIANS = 1.96399E-03 WATTS






 ***** INPUT LINE  4  NX   0    0    0    0  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
1



                                ***********************************************
                                *                                             *
                                *  NUMERICAL ELECTROMAGNETICS CODE (NEC-4.1)  *
                                *                                             *
                                ***********************************************




                      **********************************************************

                          12 ELEMENT LOG PERIODIC ANTENNA IN FREE SPACE.                               
                            78 SEGMENTS.     SIGMA=D/L       RECEIVING AND TRANS. PATTERNS.            
                          DIPOLE LENGTH TO DIAMETER RATIO=150.                                         
                          TAU=0.93,    SIGMA=0.70,     BOOM IMPEDANCE=50. OHMS.                        

                      **********************************************************





                                 - - - STRUCTURE SPECIFICATION - - -

                                     COORDINATES MUST BE INPUT IN
                                     METERS OR BE SCALED TO METERS
                                     BEFORE STRUCTURE INPUT IS ENDED


  WIRE                                                                               NO. OF    FIRST  LAST     TAG
  NO.        X1         Y1         Z1          X2         Y2         Z2      RADIUS   SEG.     SEG.   SEG.     NO.
     1     .00000   -1.00000     .00000      .00000    1.00000     .00000     .00667      5        1     5       1
     2    -.75270   -1.07530     .00000     -.75270    1.07530     .00000     .00717      5        6    10       2
     3   -1.56200   -1.15620     .00000    -1.56200    1.15620     .00000     .00771      5       11    15       3
     4   -2.43230   -1.24320     .00000    -2.43230    1.24320     .00000     .00829      5       16    20       4
     5   -3.36800   -1.33680     .00000    -3.36800    1.33680     .00000     .00891      5       21    25       5
     6   -4.37420   -1.43740     .00000    -4.37420    1.43740     .00000     .00958      7       26    32       6
     7   -5.45620   -1.54560     .00000    -5.45620    1.54560     .00000     .01030      7       33    39       7
     8   -6.61950   -1.66190     .00000    -6.61950    1.66190     .00000     .01108      7       40    46       8
     9   -7.87050   -1.78700     .00000    -7.87050    1.78700     .00000     .01191      7       47    53       9
    10   -9.21560   -1.92150     .00000    -9.21560    1.92150     .00000     .01281      7       54    60      10
    11  -10.66190   -2.06620     .00000   -10.66190    2.06620     .00000     .01377      9       61    69      11
    12  -12.21710   -2.22170     .00000   -12.21710    2.22170     .00000     .01481      9       70    78      12

   TOTAL SEGMENTS USED=   78     NO. SEG. IN A SYMMETRIC CELL=   78     SYMMETRY FLAG=  0


         - MULTIPLE WIRE JUNCTIONS -
 JUNCTION    SEGMENTS  (- FOR END 1, + FOR END 2)
  NONE




                                 - - - - SEGMENTATION DATA - - - -

                                        COORDINATES IN METERS

                         I+ AND I- INDICATE THE SEGMENTS BEFORE AND AFTER I


  SEG.   COORDINATES OF SEG. CENTER     SEG.     ORIENTATION ANGLES    WIRE    CONNECTION DATA   TAG
  NO.       X         Y         Z       LENGTH     ALPHA     BETA      RADIUS    I-   I    I+    NO.
     1    .00000   -.80000    .00000    .40000     .00000  90.00000    .00667     0    1    2      1
     2    .00000   -.40000    .00000    .40000     .00000  90.00000    .00667     1    2    3      1
     3    .00000    .00000    .00000    .40000     .00000  90.00000    .00667     2    3    4      1
     4    .00000    .40000    .00000    .40000     .00000  90.00000    .00667     3    4    5      1
     5    .00000    .80000    .00000    .40000     .00000  90.00000    .00667     4    5    0      1
     6   -.75270   -.86024    .00000    .43012     .00000  90.00000    .00717     0    6    7      2
     7   -.75270   -.43012    .00000    .43012     .00000  90.00000    .00717     6    7    8      2
     8   -.75270    .00000    .00000    .43012     .00000  90.00000    .00717     7    8    9      2
     9   -.75270    .43012    .00000    .43012     .00000  90.00000    .00717     8    9   10      2
    10   -.75270    .86024    .00000    .43012     .00000  90.00000    .00717     9   10    0      2
    11  -1.56200   -.92496    .00000    .46248     .00000  90.00000    .00771     0   11   12      3
    12  -1.56200   -.46248    .00000    .46248     .00000  90.00000    .00771    11   12   13      3
    13  -1.56200    .00000    .00000    .46248     .00000  90.00000    .00771    12   13   14      3
    14  -1.56200    .46248    .00000    .46248     .00000  90.00000    .00771    13   14   15      3
    15  -1.56200    .92496    .00000    .46248     .00000  90.00000    .00771    14   15    0      3
    16  -2.43230   -.99456    .00000    .49728     .00000  90.00000    .00829     0   16   17      4
    17  -2.43230   -.49728    .00000    .49728     .00000  90.00000    .00829    16   17   18      4
    18  -2.43230    .00000    .00000    .49728     .00000  90.00000    .00829    17   18   19      4
    19  -2.43230    .49728    .00000    .49728     .00000  90.00000    .00829    18   19   20      4
    20  -2.43230    .99456    .00000    .49728     .00000  90.00000    .00829    19   20    0      4
    21  -3.36800  -1.06944    .00000    .53472     .00000  90.00000    .00891     0   21   22      5
    22  -3.36800   -.53472    .00000    .53472     .00000  90.00000    .00891    21   22   23      5
    23  -3.36800    .00000    .00000    .53472     .00000  90.00000    .00891    22   23   24      5
    24  -3.36800    .53472    .00000    .53472     .00000  90.00000    .00891    23   24   25      5
    25  -3.36800   1.06944    .00000    .53472     .00000  90.00000    .00891    24   25    0      5
    26  -4.37420  -1.23206    .00000    .41069     .00000  90.00000    .00958     0   26   27      6
    27  -4.37420   -.82137    .00000    .41069     .00000  90.00000    .00958    26   27   28      6
    28  -4.37420   -.41069    .00000    .41069     .00000  90.00000    .00958    27   28   29      6
    29  -4.37420    .00000    .00000    .41069     .00000  90.00000    .00958    28   29   30      6
    30  -4.37420    .41069    .00000    .41069     .00000  90.00000    .00958    29   30   31      6
    31  -4.37420    .82137    .00000    .41069     .00000  90.00000    .00958    30   31   32      6
    32  -4.37420   1.23206    .00000    .41069     .00000  90.00000    .00958    31   32    0      6
    33  -5.45620  -1.32480    .00000    .44160     .00000  90.00000    .01030     0   33   34      7
    34  -5.45620   -.88320    .00000    .44160     .00000  90.00000    .01030    33   34   35      7
    35  -5.45620   -.44160    .00000    .44160     .00000  90.00000    .01030    34   35   36      7
    36  -5.45620    .00000    .00000    .44160     .00000  90.00000    .01030    35   36   37      7
    37  -5.45620    .44160    .00000    .44160     .00000  90.00000    .01030    36   37   38      7
    38  -5.45620    .88320    .00000    .44160     .00000  90.00000    .01030    37   38   39      7
    39  -5.45620   1.32480    .00000    .44160     .00000  90.00000    .01030    38   39    0      7
    40  -6.61950  -1.42449    .00000    .47483     .00000  90.00000    .01108     0   40   41      8
    41  -6.61950   -.94966    .00000    .47483     .00000  90.00000    .01108    40   41   42      8
    42  -6.61950   -.47483    .00000    .47483     .00000  90.00000    .01108    41   42   43      8
    43  -6.61950    .00000    .00000    .47483     .00000  90.00000    .01108    42   43   44      8
    44  -6.61950    .47483    .00000    .47483     .00000  90.00000    .01108    43   44   45      8
    45  -6.61950    .94966    .00000    .47483     .00000  90.00000    .01108    44   45   46      8
    46  -6.61950   1.42449    .00000    .47483     .00000  90.00000    .01108    45   46    0      8
    47  -7.87050  -1.53171    .00000    .51057     .00000  90.00000    .01191     0   47   48      9
    48  -7.87050  -1.02114    .00000    .51057     .00000  90.00000    .01191    47   48   49      9
    49  -7.87050   -.51057    .00000    .51057     .00000  90.00000    .01191    48   49   50      9
    50  -7.87050    .00000    .00000    .51057     .00000  90.00000    .01191    49   50   51      9
    51  -7.87050    .51057    .00000    .51057     .00000  90.00000    .01191    50   51   52      9
    52  -7.87050   1.02114    .00000    .51057     .00000  90.00000    .01191    51   52   53      9
    53  -7.87050   1.53171    .00000    .51057     .00000  90.00000    .01191    52   53    0      9
    54  -9.21560  -1.64700    .00000    .54900     .00000  90.00000    .01281     0   54   55     10
    55  -9.21560  -1.09800    .00000    .54900     .00000  90.00000    .01281    54   55   56     10
    56  -9.21560   -.54900    .00000    .54900     .00000  90.00000    .01281    55   56   57     10
    57  -9.21560    .00000    .00000    .54900     .00000  90.00000    .01281    56   57   58     10
    58  -9.21560    .54900    .00000    .54900     .00000  90.00000    .01281    57   58   59     10
    59  -9.21560   1.09800    .00000    .54900     .00000  90.00000    .01281    58   59   60     10
    60  -9.21560   1.64700    .00000    .54900     .00000  90.00000    .01281    59   60    0     10
    61 -10.66190  -1.83662    .00000    .45916     .00000  90.00000    .01377     0   61   62     11
    62 -10.66190  -1.37747    .00000    .45916     .00000  90.00000    .01377    61   62   63     11
    63 -10.66190   -.91831    .00000    .45916     .00000  90.00000    .01377    62   63   64     11
    64 -10.66190   -.45916    .00000    .45916     .00000  90.00000    .01377    63   64   65     11
    65 -10.66190    .00000    .00000    .45916     .00000  90.00000    .01377    64   65   66     11
    66 -10.66190    .45916    .00000    .45916     .00000  90.00000    .01377    65   66   67     11
    67 -10.66190    .91831    .00000    .45916     .00000  90.00000    .01377    66   67   68     11
    68 -10.66190   1.37747    .00000    .45916     .00000  90.00000    .01377    67   68   69     11
    69 -10.66190   1.83662    .00000    .45916     .00000  90.00000    .01377    68   69    0     11
    70 -12.21710  -1.97484    .00000    .49371     .00000  90.00000    .01481     0   70   71     12
    71 -12.21710  -1.48113    .00000    .49371     .00000  90.00000    .01481    70   71   72     12
    72 -12.21710   -.98742    .00000    .49371     .00000  90.00000    .01481    71   72   73     12
    73 -12.21710   -.49371    .00000    .49371     .00000  90.00000    .01481    72   73   74     12
    74 -12.21710    .00000    .00000    .49371     .00000  90.00000    .01481    73   74   75     12
    75 -12.21710    .49371    .00000    .49371     .00000  90.00000    .01481    74   75   76     12
    76 -12.21710    .98742    .00000    .49371     .00000  90.00000    .01481    75   76   77     12
    77 -12.21710   1.48113    .00000    .49371     .00000  90.00000    .01481    76   77   78     12
    78 -12.21710   1.97484    .00000    .49371     .00000  90.00000    .01481    77   78    0     12




 ***** INPUT LINE  1  FR   0    0    0    0  4.62900E+01  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  2  TL   1    3    2    3 -5.00000E+01  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  3  TL   2    3    3    3 -5.00000E+01  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  4  TL   3    3    4    3 -5.00000E+01  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  5  TL   4    3    5    3 -5.00000E+01  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  6  TL   5    3    6    4 -5.00000E+01  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  7  TL   6    4    7    4 -5.00000E+01  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  8  TL   7    4    8    4 -5.00000E+01  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  9  TL   8    4    9    4 -5.00000E+01  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE 10  TL   9    4   10    4 -5.00000E+01  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE 11  TL  10    4   11    5 -5.00000E+01  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE 12  TL  11    5   12    5 -5.00000E+01  0.00000E+00  0.00000E+00  0.00000E+00  2.00000E-02  0.00000E+00
 ***** INPUT LINE 13  EX   0    1    3   10  1.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE 14  RP   0   37    1 1110  9.00000E+01  0.00000E+00 -5.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00




                                 - - - - - - FREQUENCY - - - - - -

                                    FREQUENCY= 4.6290E+01 MHZ
                                    WAVELENGTH= 6.4766E+00 METERS



                                  - - - ANTENNA ENVIRONMENT - - -

                                            FREE SPACE



                               - - - STRUCTURE IMPEDANCE LOADING - - -

                                   THIS STRUCTURE IS NOT LOADED



                                - - - MATRIX TIMING - - -

                        FILL=    1.670 SEC.,  FACTOR=     .410 SEC.



                                            - - - NETWORK DATA - - -

      - FROM -    - TO -           TRANSMISSION LINE               -  -  SHUNT ADMITTANCES (MHOS)  -  -              LINE
      TAG  SEG.   TAG  SEG.      IMPEDANCE      LENGTH            - END ONE -                 - END TWO -            TYPE
      NO.   NO.   NO.   NO.         OHMS        METERS         REAL          IMAG.         REAL          IMAG.
        1     3     2     8     5.0000E+01    7.5270E-01    0.0000E+00    0.0000E+00    0.0000E+00    0.0000E+00   CROSSED
        2     8     3    13     5.0000E+01    8.0930E-01    0.0000E+00    0.0000E+00    0.0000E+00    0.0000E+00   CROSSED
        3    13     4    18     5.0000E+01    8.7030E-01    0.0000E+00    0.0000E+00    0.0000E+00    0.0000E+00   CROSSED
        4    18     5    23     5.0000E+01    9.3570E-01    0.0000E+00    0.0000E+00    0.0000E+00    0.0000E+00   CROSSED
        5    23     6    29     5.0000E+01    1.0062E+00    0.0000E+00    0.0000E+00    0.0000E+00    0.0000E+00   CROSSED
        6    29     7    36     5.0000E+01    1.0820E+00    0.0000E+00    0.0000E+00    0.0000E+00    0.0000E+00   CROSSED
        7    36     8    43     5.0000E+01    1.1633E+00    0.0000E+00    0.0000E+00    0.0000E+00    0.0000E+00   CROSSED
        8    43     9    50     5.0000E+01    1.2510E+00    0.0000E+00    0.0000E+00    0.0000E+00    0.0000E+00   CROSSED
        9    50    10    57     5.0000E+01    1.3451E+00    0.0000E+00    0.0000E+00    0.0000E+00    0.0000E+00   CROSSED
       10    57    11    65     5.0000E+01    1.4463E+00    0.0000E+00    0.0000E+00    0.0000E+00    0.0000E+00   CROSSED
       11    65    12    74     5.0000E+01    1.5552E+00    0.0000E+00    0.0000E+00    2.0000E-02    0.0000E+00   CROSSED



                           - - - STRUCTURE EXCITATION DATA AT NETWORK CONNECTION POINTS - - -

   TAG   SEG.    VOLTAGE (VOLTS)         CURRENT (AMPS)         IMPEDANCE (OHMS)        ADMITTANCE (MHOS)      POWER
   NO.   NO.    REAL        IMAG.       REAL        IMAG.       REAL        IMAG.       REAL        IMAG.     (WATTS)
     2     8-6.76627E-01 7.27115E-01-1.88010E-04-1.90062E-03-3.43985E+02-3.90030E+02-1.27190E-03 1.44216E-03-6.27380E-04
     3    13-1.14154E-01-1.08175E+00 6.83753E-03 2.28692E-03-6.26065E+01-1.37267E+02-2.75050E-03 6.03058E-03-1.62720E-03
     4    18 9.62160E-01 5.03161E-01-4.58110E-03 1.06822E-02 7.15877E+00-9.31412E+01 8.20345E-04 1.06733E-02 4.83562E-04
     5    23-7.24748E-01 6.58961E-01-1.37147E-02-3.48165E-03 3.81861E+01-5.77418E+01 7.96823E-03 1.20489E-02 3.82271E-03
     6    29-2.80599E-01-7.56265E-01 1.69322E-03-1.27472E-02 5.54259E+01-2.93747E+01 1.40857E-02 7.46518E-03 4.58259E-03
     7    36 5.10308E-01 5.67232E-02 9.62980E-03-1.19915E-03 5.14611E+01 1.22986E+01 1.83823E-02-4.39314E-03 2.42307E-03
     8    43-2.44911E-01 2.99244E-01 1.37850E-03 5.04823E-03 4.28356E+01 6.02111E+01 7.84496E-03-1.10271E-02 5.86523E-04
     9    50-9.82410E-02-3.60746E-01-2.30737E-03 5.52674E-04 4.85021E+00 1.57507E+02 1.95322E-04-6.34292E-03 1.36519E-05
    10    57 3.40068E-01 2.78021E-02 3.64279E-04-9.09733E-04 1.02661E+02 3.32702E+02 8.46831E-04-2.74439E-03 4.92936E-05
    11    65-9.25171E-02 3.38575E-01 5.72594E-04 5.66597E-04 2.13995E+02 3.79546E+02 1.12719E-03-1.99920E-03 6.94304E-05
    12    74-2.94601E-01-1.34907E-01-7.24943E-04 4.78269E-04 1.97601E+02 3.16457E+02 1.41964E-03-2.27354E-03 7.45236E-05
     1     3 1.00000E+00 0.00000E+00 1.82267E-03 2.30202E-03 2.11411E+02-2.67012E+02 1.82267E-03 2.30202E-03 9.11335E-04



                                          - - - ANTENNA INPUT PARAMETERS - - -

   TAG   SEG.    VOLTAGE (VOLTS)         CURRENT (AMPS)         IMPEDANCE (OHMS)        ADMITTANCE (MHOS)      POWER
   NO.   NO.    REAL        IMAG.       REAL        IMAG.       REAL        IMAG.       REAL        IMAG.     (WATTS)
     1     3 1.00000E+00 0.00000E+00 2.36240E-02 2.51273E-04 4.23251E+01-4.50185E-01 2.36240E-02 2.51273E-04 1.18120E-02



                             - - - CURRENTS AND LOCATION - - -

                     LENGTHS NORMALIZED BY WAVELENGTH (OR 2.*PI/CABS(K))

  SEG.  TAG    COORD. OF SEG. CENTER     SEG.            - - - CURRENT (AMPS) - - -
  NO.   NO.     X        Y        Z      LENGTH     REAL        IMAG.       MAG.        PHASE
     1    1    .0000   -.1235    .0000   .06176   6.9687E-04  5.6853E-04  8.9937E-04   39.209
     2    1    .0000   -.0618    .0000   .06176   1.5437E-03  1.5720E-03  2.2033E-03   45.520
     3    1    .0000    .0000    .0000   .06176   1.8227E-03  2.3020E-03  2.9362E-03   51.629
     4    1    .0000    .0618    .0000   .06176   1.5437E-03  1.5720E-03  2.2033E-03   45.520
     5    1    .0000    .1235    .0000   .06176   6.9687E-04  5.6853E-04  8.9937E-04   39.209
     6    2   -.1162   -.1328    .0000   .06641   1.9906E-04 -4.7358E-04  5.1372E-04  -67.202
     7    2   -.1162   -.0664    .0000   .06641   1.5344E-04 -1.3185E-03  1.3274E-03  -83.362
     8    2   -.1162    .0000    .0000   .06641  -1.8801E-04 -1.9006E-03  1.9099E-03  -95.649
     9    2   -.1162    .0664    .0000   .06641   1.5344E-04 -1.3185E-03  1.3274E-03  -83.362
    10    2   -.1162    .1328    .0000   .06641   1.9906E-04 -4.7358E-04  5.1372E-04  -67.202
    11    3   -.2412   -.1428    .0000   .07141   2.1561E-03  9.2255E-04  2.3452E-03   23.165
    12    3   -.2412   -.0714    .0000   .07141   5.2780E-03  1.9920E-03  5.6414E-03   20.677
    13    3   -.2412    .0000    .0000   .07141   6.8375E-03  2.2869E-03  7.2098E-03   18.493
    14    3   -.2412    .0714    .0000   .07141   5.2780E-03  1.9920E-03  5.6414E-03   20.677
    15    3   -.2412    .1428    .0000   .07141   2.1561E-03  9.2255E-04  2.3452E-03   23.165
    16    4   -.3756   -.1536    .0000   .07678  -1.5102E-03  3.5732E-03  3.8792E-03  112.911
    17    4   -.3756   -.0768    .0000   .07678  -3.6158E-03  8.5158E-03  9.2516E-03  113.006
    18    4   -.3756    .0000    .0000   .07678  -4.5811E-03  1.0682E-02  1.1623E-02  113.212
    19    4   -.3756    .0768    .0000   .07678  -3.6158E-03  8.5158E-03  9.2516E-03  113.006
    20    4   -.3756    .1536    .0000   .07678  -1.5102E-03  3.5732E-03  3.8792E-03  112.911
    21    5   -.5200   -.1651    .0000   .08256  -4.7271E-03 -9.5696E-04  4.8230E-03 -168.556
    22    5   -.5200   -.0826    .0000   .08256  -1.1146E-02 -2.5364E-03  1.1431E-02 -167.180
    23    5   -.5200    .0000    .0000   .08256  -1.3715E-02 -3.4817E-03  1.4150E-02 -165.756
    24    5   -.5200    .0826    .0000   .08256  -1.1146E-02 -2.5364E-03  1.1431E-02 -167.180
    25    5   -.5200    .1651    .0000   .08256  -4.7271E-03 -9.5696E-04  4.8230E-03 -168.556
    26    6   -.6754   -.1902    .0000   .06341   1.3784E-04 -3.3821E-03  3.3850E-03  -87.666
    27    6   -.6754   -.1268    .0000   .06341   5.5930E-04 -8.3198E-03  8.3386E-03  -86.154
    28    6   -.6754   -.0634    .0000   .06341   1.1491E-03 -1.1516E-02  1.1573E-02  -84.302
    29    6   -.6754    .0000    .0000   .06341   1.6932E-03 -1.2747E-02  1.2859E-02  -82.434
    30    6   -.6754    .0634    .0000   .06341   1.1491E-03 -1.1516E-02  1.1573E-02  -84.302
    31    6   -.6754    .1268    .0000   .06341   5.5930E-04 -8.3198E-03  8.3386E-03  -86.154
    32    6   -.6754    .1902    .0000   .06341   1.3784E-04 -3.3821E-03  3.3850E-03  -87.666
    33    7   -.8425   -.2046    .0000   .06818   2.5956E-03 -5.7065E-04  2.6576E-03  -12.399
    34    7   -.8425   -.1364    .0000   .06818   6.4073E-03 -1.2256E-03  6.5235E-03  -10.829
    35    7   -.8425   -.0682    .0000   .06818   8.8152E-03 -1.3908E-03  8.9242E-03   -8.966
    36    7   -.8425    .0000    .0000   .06818   9.6298E-03 -1.1991E-03  9.7042E-03   -7.098
    37    7   -.8425    .0682    .0000   .06818   8.8152E-03 -1.3908E-03  8.9242E-03   -8.966
    38    7   -.8425    .1364    .0000   .06818   6.4073E-03 -1.2256E-03  6.5235E-03  -10.829
    39    7   -.8425    .2046    .0000   .06818   2.5956E-03 -5.7065E-04  2.6576E-03  -12.399
    40    8  -1.0221   -.2199    .0000   .07331   5.2459E-04  1.4102E-03  1.5046E-03   69.595
    41    8  -1.0221   -.1466    .0000   .07331   1.1846E-03  3.4851E-03  3.6809E-03   71.227
    42    8  -1.0221   -.0733    .0000   .07331   1.4455E-03  4.7327E-03  4.9485E-03   73.015
    43    8  -1.0221    .0000    .0000   .07331   1.3785E-03  5.0482E-03  5.2331E-03   74.727
    44    8  -1.0221    .0733    .0000   .07331   1.4455E-03  4.7327E-03  4.9485E-03   73.015
    45    8  -1.0221    .1466    .0000   .07331   1.1846E-03  3.4851E-03  3.6809E-03   71.227
    46    8  -1.0221    .2199    .0000   .07331   5.2459E-04  1.4102E-03  1.5046E-03   69.595
    47    9  -1.2152   -.2365    .0000   .07883  -7.4268E-04  2.0205E-04  7.6967E-04  164.781
    48    9  -1.2152   -.1577    .0000   .07883  -1.7937E-03  4.6194E-04  1.8522E-03  165.558
    49    9  -1.2152   -.0788    .0000   .07883  -2.3194E-03  5.7087E-04  2.3886E-03  166.173
    50    9  -1.2152    .0000    .0000   .07883  -2.3074E-03  5.5267E-04  2.3726E-03  166.530
    51    9  -1.2152    .0788    .0000   .07883  -2.3194E-03  5.7087E-04  2.3886E-03  166.173
    52    9  -1.2152    .1577    .0000   .07883  -1.7936E-03  4.6194E-04  1.8522E-03  165.558
    53    9  -1.2152    .2365    .0000   .07883  -7.4268E-04  2.0205E-04  7.6967E-04  164.781
    54   10  -1.4229   -.2543    .0000   .08477   9.5834E-05 -3.9100E-04  4.0257E-04  -76.228
    55   10  -1.4229   -.1695    .0000   .08477   2.4963E-04 -8.9811E-04  9.3215E-04  -74.467
    56   10  -1.4229   -.0848    .0000   .08477   3.4553E-04 -1.0569E-03  1.1120E-03  -71.896
    57   10  -1.4229    .0000    .0000   .08477   3.6428E-04 -9.0973E-04  9.7996E-04  -68.178
    58   10  -1.4229    .0848    .0000   .08477   3.4553E-04 -1.0569E-03  1.1120E-03  -71.896
    59   10  -1.4229    .1695    .0000   .08477   2.4963E-04 -8.9811E-04  9.3215E-04  -74.467
    60   10  -1.4229    .2543    .0000   .08477   9.5834E-05 -3.9100E-04  4.0257E-04  -76.228
    61   11  -1.6462   -.2836    .0000   .07089   2.7083E-04  1.5013E-04  3.0966E-04   29.002
    62   11  -1.6462   -.2127    .0000   .07089   6.3258E-04  3.7777E-04  7.3679E-04   30.846
    63   11  -1.6462   -.1418    .0000   .07089   8.0840E-04  5.3307E-04  9.6834E-04   33.402
    64   11  -1.6462   -.0709    .0000   .07089   7.6869E-04  5.9462E-04  9.7183E-04   37.724
    65   11  -1.6462    .0000    .0000   .07089   5.7259E-04  5.6660E-04  8.0554E-04   44.698
    66   11  -1.6462    .0709    .0000   .07089   7.6869E-04  5.9462E-04  9.7183E-04   37.724
    67   11  -1.6462    .1418    .0000   .07089   8.0840E-04  5.3307E-04  9.6834E-04   33.402
    68   11  -1.6462    .2127    .0000   .07089   6.3258E-04  3.7777E-04  7.3679E-04   30.846
    69   11  -1.6462    .2836    .0000   .07089   2.7083E-04  1.5013E-04  3.0966E-04   29.002
    70   12  -1.8864   -.3049    .0000   .07623  -1.9982E-04  2.4060E-04  3.1276E-04  129.711
    71   12  -1.8864   -.2287    .0000   .07623  -5.0500E-04  5.6275E-04  7.5612E-04  131.904
    72   12  -1.8864   -.1525    .0000   .07623  -7.0918E-04  7.1451E-04  1.0067E-03  134.786
    73   12  -1.8864   -.0762    .0000   .07623  -7.7887E-04  6.6669E-04  1.0252E-03  139.438
    74   12  -1.8864    .0000    .0000   .07623  -7.2494E-04  4.7827E-04  8.6850E-04  146.586
    75   12  -1.8864    .0762    .0000   .07623  -7.7887E-04  6.6669E-04  1.0252E-03  139.438
    76   12  -1.8864    .1525    .0000   .07623  -7.0918E-04  7.1451E-04  1.0067E-03  134.786
    77   12  -1.8864    .2287    .0000   .07623  -5.0500E-04  5.6276E-04  7.5612E-04  131.904
    78   12  -1.8864    .3049    .0000   .07623  -1.9982E-04  2.4060E-04  3.1276E-04  129.711



                                        - - - POWER BUDGET - - -

                                           INPUT POWER   = 1.1812E-02 WATTS
                                           RADIATED POWER= 1.0762E-02 WATTS
                                           WIRE LOSS     = 0.0000E+00 WATTS
                                           NETWORK LOSS  = 1.0499E-03 WATTS
                                           EFFICIENCY    =  91.11 PERCENT



                                                - - - RADIATION PATTERNS - - -

  - - ANGLES - -       - DIRECTIVE GAINS -       - - - POLARIZATION - - -    - - - E(THETA) - - -    - - - E(PHI) - - -
  THETA     PHI        VERT.   HOR.    TOTAL      AXIAL     TILT   SENSE     MAGNITUDE    PHASE      MAGNITUDE    PHASE 
 DEGREES  DEGREES       DB      DB      DB        RATIO     DEG.               VOLTS     DEGREES       VOLTS     DEGREES
   90.00      .00    -999.99    9.75    9.75     .00000    90.00  LINEAR    0.00000E+00      .00    2.46920E+00   -65.98
   85.00      .00    -999.99    9.70    9.70     .00000    90.00  LINEAR    0.00000E+00      .00    2.45350E+00   -65.18
   80.00      .00    -999.99    9.53    9.53     .00000    90.00  LINEAR    0.00000E+00      .00    2.40688E+00   -62.81
   75.00      .00    -999.99    9.25    9.25     .00000    90.00  LINEAR    0.00000E+00      .00    2.33092E+00   -58.95
   70.00      .00    -999.99    8.86    8.86     .00000    90.00  LINEAR    0.00000E+00      .00    2.22887E+00   -53.73
   65.00      .00    -999.99    8.37    8.37     .00000    90.00  LINEAR    0.00000E+00      .00    2.10615E+00   -47.29
   60.00      .00    -999.99    7.79    7.79     .00000    90.00  LINEAR    0.00000E+00      .00    1.97021E+00   -39.76
   55.00      .00    -999.99    7.15    7.15     .00000    90.00  LINEAR    0.00000E+00      .00    1.82914E+00   -31.16
   50.00      .00    -999.99    6.45    6.45     .00000    90.00  LINEAR    0.00000E+00      .00    1.68846E+00   -21.32
   45.00      .00    -999.99    5.69    5.69     .00000    90.00  LINEAR    0.00000E+00      .00    1.54743E+00    -9.89
   40.00      .00    -999.99    4.81    4.81     .00000    90.00  LINEAR    0.00000E+00      .00    1.39754E+00     3.58
   35.00      .00    -999.99    3.67    3.67     .00000    90.00  LINEAR    0.00000E+00      .00    1.22596E+00    19.49
   30.00      .00    -999.99    2.10    2.10     .00000    90.00  LINEAR    0.00000E+00      .00    1.02309E+00    38.03
   25.00      .00    -999.99    -.14    -.14     .00000    90.00  LINEAR    0.00000E+00      .00    7.90293E-01    59.28
   20.00      .00    -999.99   -3.40   -3.40     .00000    90.00  LINEAR    0.00000E+00      .00    5.43335E-01    83.44
   15.00      .00    -999.99   -8.27   -8.27     .00000   -90.00  LINEAR    0.00000E+00      .00    3.10049E-01   111.79
   10.00      .00    -999.99  -16.14  -16.14     .00000   -90.00  LINEAR    0.00000E+00      .00    1.25250E-01   152.61
    5.00      .00    -999.99  -23.14  -23.14     .00000   -90.00  LINEAR    0.00000E+00      .00    5.59453E-02  -103.86
     .00      .00    -999.99  -19.63  -19.63     .00000    90.00  LINEAR    0.00000E+00      .00    8.38484E-02   -41.94
   -5.00      .00    -999.99  -20.65  -20.65     .00000    90.00  LINEAR    0.00000E+00      .00    7.45420E-02   -24.91
  -10.00      .00    -999.99  -22.13  -22.13     .00000    90.00  LINEAR    0.00000E+00      .00    6.28661E-02   -47.75
  -15.00      .00    -999.99  -17.70  -17.70     .00000    90.00  LINEAR    0.00000E+00      .00    1.04659E-01   -62.54
  -20.00      .00    -999.99  -14.43  -14.43     .00000    90.00  LINEAR    0.00000E+00      .00    1.52462E-01   -50.17
  -25.00      .00    -999.99  -13.31  -13.31     .00000    90.00  LINEAR    0.00000E+00      .00    1.73493E-01   -30.85
  -30.00      .00    -999.99  -13.96  -13.96     .00000    90.00  LINEAR    0.00000E+00      .00    1.60994E-01   -10.65
  -35.00      .00    -999.99  -16.41  -16.41     .00000    90.00  LINEAR    0.00000E+00      .00    1.21404E-01     7.53
  -40.00      .00    -999.99  -21.42  -21.42     .00000    90.00  LINEAR    0.00000E+00      .00    6.82465E-02    18.35
  -45.00      .00    -999.99  -29.96  -29.96     .00000    90.00  LINEAR    0.00000E+00      .00    2.55093E-02   -16.59
  -50.00      .00    -999.99  -24.33  -24.33     .00000    90.00  LINEAR    0.00000E+00      .00    4.87955E-02   -74.37
  -55.00      .00    -999.99  -19.91  -19.91     .00000    90.00  LINEAR    0.00000E+00      .00    8.11638E-02   -72.26
  -60.00      .00    -999.99  -17.99  -17.99     .00000    90.00  LINEAR    0.00000E+00      .00    1.01248E-01   -63.60
  -65.00      .00    -999.99  -17.28  -17.28     .00000    90.00  LINEAR    0.00000E+00      .00    1.09830E-01   -55.16
  -70.00      .00    -999.99  -17.24  -17.24     .00000    90.00  LINEAR    0.00000E+00      .00    1.10383E-01   -48.42
  -75.00      .00    -999.99  -17.53  -17.53     .00000    90.00  LINEAR    0.00000E+00      .00    1.06732E-01   -43.74
  -80.00      .00    -999.99  -17.92  -17.92     .00000    90.00  LINEAR    0.00000E+00      .00    1.02055E-01   -40.95
  -85.00      .00    -999.99  -18.23  -18.23     .00000    90.00  LINEAR    0.00000E+00      .00    9.84975E-02   -39.61
  -90.00      .00    -999.99  -18.34  -18.34     .00000    90.00  LINEAR    0.00000E+00      .00    9.71979E-02   -39.23




                                     - - - - NORMALIZED GAIN - - - -

                                      MAJOR AXIS GAIN
                                      NORMALIZATION FACTOR =     9.75 DB

    - - ANGLES - -      GAIN           - - ANGLES - -      GAIN           - - ANGLES - -      GAIN
    THETA     PHI        DB            THETA     PHI        DB            THETA     PHI        DB
   DEGREES  DEGREES                   DEGREES  DEGREES                   DEGREES  DEGREES
     90.00      .00       .00           25.00      .00     -9.90          -35.00      .00    -26.17
     85.00      .00      -.06           20.00      .00    -13.15          -40.00      .00    -31.17
     80.00      .00      -.22           15.00      .00    -18.02          -45.00      .00    -39.72
     75.00      .00      -.50           10.00      .00    -25.90          -50.00      .00    -34.08
     70.00      .00      -.89            5.00      .00    -32.90          -55.00      .00    -29.66
     65.00      .00     -1.38             .00      .00    -29.38          -60.00      .00    -27.74
     60.00      .00     -1.96           -5.00      .00    -30.40          -65.00      .00    -27.04
     55.00      .00     -2.61          -10.00      .00    -31.88          -70.00      .00    -26.99
     50.00      .00     -3.30          -15.00      .00    -27.46          -75.00      .00    -27.29
     45.00      .00     -4.06          -20.00      .00    -24.19          -80.00      .00    -27.67
     40.00      .00     -4.94          -25.00      .00    -23.07          -85.00      .00    -27.98
     35.00      .00     -6.08          -30.00      .00    -23.71          -90.00      .00    -28.10
     30.00      .00     -7.65      




 ***** INPUT LINE 15  NX   0    0    0    0  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
1



                                ***********************************************
                                *                                             *
                                *  NUMERICAL ELECTROMAGNETICS CODE (NEC-4.1)  *
                                *                                             *
                                ***********************************************




                      **********************************************************

                         CYLINDER WITH ATTACHED WIRES.                                                 

                      **********************************************************





                                 - - - STRUCTURE SPECIFICATION - - -

                                     COORDINATES MUST BE INPUT IN
                                     METERS OR BE SCALED TO METERS
                                     BEFORE STRUCTURE INPUT IS ENDED


  WIRE                                                                               NO. OF    FIRST  LAST     TAG
  NO.        X1         Y1         Z1          X2         Y2         Z2      RADIUS   SEG.     SEG.   SEG.     NO.
     1P  10.00000     .00000    7.33330      .00000     .00000   38.40000
     2P  10.00000     .00000     .00000      .00000     .00000   38.40000
     3P  10.00000     .00000   -7.33330      .00000     .00000   38.40000
      THE STRUCTURE HAS BEEN MOVED, GM COMMAND DATA IS -
        0    1    .00000    .00000  30.00000    .00000    .00000    .00000    0    1    0    1
     7P   6.89000     .00000   11.00000    90.00000     .00000   44.88000
     8P   6.89000     .00000  -11.00000   -90.00000     .00000   44.88000
      STRUCTURE ROTATED ABOUT Z-AXIS  6 TIMES.  LABELS INCREMENTED BY    0
    49P    .00000     .00000   11.00000    90.00000     .00000   44.89000
    50P    .00000     .00000  -11.00000   -90.00000     .00000   44.89000
     1     .00000     .00000   11.00000      .00000     .00000   23.00000     .10000      4        1     4       1
     2   10.00000     .00000     .00000    27.60000     .00000     .00000     .20000      5        5     9       2
      STRUCTURE SCALED BY FACTOR    .01000

   TOTAL SEGMENTS USED=    9     NO. SEG. IN A SYMMETRIC CELL=    9     SYMMETRY FLAG=  0
   TOTAL PATCHES USED=   56      NO. PATCHES IN A SYMMETRIC CELL=   56


         - MULTIPLE WIRE JUNCTIONS -
 JUNCTION    SEGMENTS  (- FOR END 1, + FOR END 2)
  NONE




                                 - - - - SEGMENTATION DATA - - - -

                                        COORDINATES IN METERS

                         I+ AND I- INDICATE THE SEGMENTS BEFORE AND AFTER I


  SEG.   COORDINATES OF SEG. CENTER     SEG.     ORIENTATION ANGLES    WIRE    CONNECTION DATA   TAG
  NO.       X         Y         Z       LENGTH     ALPHA     BETA      RADIUS    I-   I    I+    NO.
     1    .00000    .00000    .12500    .03000   90.00000    .00000    .00100 10052    1    2      1
     2    .00000    .00000    .15500    .03000   90.00000    .00000    .00100     1    2    3      1
     3    .00000    .00000    .18500    .03000   90.00000    .00000    .00100     2    3    4      1
     4    .00000    .00000    .21500    .03000   90.00000    .00000    .00100     3    4    0      1
     5    .11760    .00000    .00000    .03520     .00000    .00000    .00200 10002    5    6      2
     6    .15280    .00000    .00000    .03520     .00000    .00000    .00200     5    6    7      2
     7    .18800    .00000    .00000    .03520     .00000    .00000    .00200     6    7    8      2
     8    .22320    .00000    .00000    .03520     .00000    .00000    .00200     7    8    9      2
     9    .25840    .00000    .00000    .03520     .00000    .00000    .00200     8    9    0      2




                                            - - - SURFACE PATCH DATA - - -

                                                 COORDINATES IN METERS

 PATCH     COORD. OF PATCH CENTER       UNIT NORMAL VECTOR      PATCH            COMPONENTS OF UNIT TANGENT VECTORS
  NO.      X         Y         Z         X       Y       Z       AREA       X1      Y1      Z1       X2      Y2      Z2
    1    .10000    .00000    .07333   1.0000   .0000   .0000    .00384    .0000  1.0000   .0000    .0000   .0000  1.0000
    2    .10000    .01549    .01549   1.0000   .0000   .0000    .00096    .0000  1.0000   .0000    .0000   .0000  1.0000
    3    .10000   -.01549    .01549   1.0000   .0000   .0000    .00096    .0000  1.0000   .0000    .0000   .0000  1.0000
    4    .10000   -.01549   -.01549   1.0000   .0000   .0000    .00096    .0000  1.0000   .0000    .0000   .0000  1.0000
    5    .10000    .01549   -.01549   1.0000   .0000   .0000    .00096    .0000  1.0000   .0000    .0000   .0000  1.0000
    6    .10000    .00000   -.07333   1.0000   .0000   .0000    .00384    .0000  1.0000   .0000    .0000   .0000  1.0000
    7    .08660    .05000    .07333    .8660   .5000   .0000    .00384   -.5000   .8660   .0000    .0000   .0000  1.0000
    8    .08660    .05000    .00000    .8660   .5000   .0000    .00384   -.5000   .8660   .0000    .0000   .0000  1.0000
    9    .08660    .05000   -.07333    .8660   .5000   .0000    .00384   -.5000   .8660   .0000    .0000   .0000  1.0000
   10    .06890    .00000    .11000    .0000   .0000  1.0000    .00449   1.0000   .0000   .0000    .0000  1.0000   .0000
   11    .06890    .00000   -.11000    .0000   .0000 -1.0000    .00449   1.0000   .0000   .0000    .0000 -1.0000   .0000
   12    .05000    .08660    .07333    .5000   .8660   .0000    .00384   -.8660   .5000   .0000    .0000   .0000  1.0000
   13    .05000    .08660    .00000    .5000   .8660   .0000    .00384   -.8660   .5000   .0000    .0000   .0000  1.0000
   14    .05000    .08660   -.07333    .5000   .8660   .0000    .00384   -.8660   .5000   .0000    .0000   .0000  1.0000
   15    .00000    .10000    .07333    .0000  1.0000   .0000    .00384  -1.0000   .0000   .0000    .0000   .0000  1.0000
   16    .00000    .10000    .00000    .0000  1.0000   .0000    .00384  -1.0000   .0000   .0000    .0000   .0000  1.0000
   17    .00000    .10000   -.07333    .0000  1.0000   .0000    .00384  -1.0000   .0000   .0000    .0000   .0000  1.0000
   18    .03445    .05967    .11000    .0000   .0000  1.0000    .00449    .5000   .8660   .0000   -.8660   .5000   .0000
   19    .03445    .05967   -.11000    .0000   .0000 -1.0000    .00449    .5000   .8660   .0000    .8660  -.5000   .0000
   20   -.05000    .08660    .07333   -.5000   .8660   .0000    .00384   -.8660  -.5000   .0000    .0000   .0000  1.0000
   21   -.05000    .08660    .00000   -.5000   .8660   .0000    .00384   -.8660  -.5000   .0000    .0000   .0000  1.0000
   22   -.05000    .08660   -.07333   -.5000   .8660   .0000    .00384   -.8660  -.5000   .0000    .0000   .0000  1.0000
   23   -.08660    .05000    .07333   -.8660   .5000   .0000    .00384   -.5000  -.8660   .0000    .0000   .0000  1.0000
   24   -.08660    .05000    .00000   -.8660   .5000   .0000    .00384   -.5000  -.8660   .0000    .0000   .0000  1.0000
   25   -.08660    .05000   -.07333   -.8660   .5000   .0000    .00384   -.5000  -.8660   .0000    .0000   .0000  1.0000
   26   -.03445    .05967    .11000    .0000   .0000  1.0000    .00449   -.5000   .8660   .0000   -.8660  -.5000   .0000
   27   -.03445    .05967   -.11000    .0000   .0000 -1.0000    .00449   -.5000   .8660   .0000    .8660   .5000   .0000
   28   -.10000    .00000    .07333  -1.0000   .0000   .0000    .00384    .0000 -1.0000   .0000    .0000   .0000  1.0000
   29   -.10000    .00000    .00000  -1.0000   .0000   .0000    .00384    .0000 -1.0000   .0000    .0000   .0000  1.0000
   30   -.10000    .00000   -.07333  -1.0000   .0000   .0000    .00384    .0000 -1.0000   .0000    .0000   .0000  1.0000
   31   -.08660   -.05000    .07333   -.8660  -.5000   .0000    .00384    .5000  -.8660   .0000    .0000   .0000  1.0000
   32   -.08660   -.05000    .00000   -.8660  -.5000   .0000    .00384    .5000  -.8660   .0000    .0000   .0000  1.0000
   33   -.08660   -.05000   -.07333   -.8660  -.5000   .0000    .00384    .5000  -.8660   .0000    .0000   .0000  1.0000
   34   -.06890    .00000    .11000    .0000   .0000  1.0000    .00449  -1.0000   .0000   .0000    .0000 -1.0000   .0000
   35   -.06890    .00000   -.11000    .0000   .0000 -1.0000    .00449  -1.0000   .0000   .0000    .0000  1.0000   .0000
   36   -.05000   -.08660    .07333   -.5000  -.8660   .0000    .00384    .8660  -.5000   .0000    .0000   .0000  1.0000
   37   -.05000   -.08660    .00000   -.5000  -.8660   .0000    .00384    .8660  -.5000   .0000    .0000   .0000  1.0000
   38   -.05000   -.08660   -.07333   -.5000  -.8660   .0000    .00384    .8660  -.5000   .0000    .0000   .0000  1.0000
   39    .00000   -.10000    .07333    .0000 -1.0000   .0000    .00384   1.0000   .0000   .0000    .0000   .0000  1.0000
   40    .00000   -.10000    .00000    .0000 -1.0000   .0000    .00384   1.0000   .0000   .0000    .0000   .0000  1.0000
   41    .00000   -.10000   -.07333    .0000 -1.0000   .0000    .00384   1.0000   .0000   .0000    .0000   .0000  1.0000
   42   -.03445   -.05967    .11000    .0000   .0000  1.0000    .00449   -.5000  -.8660   .0000    .8660  -.5000   .0000
   43   -.03445   -.05967   -.11000    .0000   .0000 -1.0000    .00449   -.5000  -.8660   .0000   -.8660   .5000   .0000
   44    .05000   -.08660    .07333    .5000  -.8660   .0000    .00384    .8660   .5000   .0000    .0000   .0000  1.0000
   45    .05000   -.08660    .00000    .5000  -.8660   .0000    .00384    .8660   .5000   .0000    .0000   .0000  1.0000
   46    .05000   -.08660   -.07333    .5000  -.8660   .0000    .00384    .8660   .5000   .0000    .0000   .0000  1.0000
   47    .08660   -.05000    .07333    .8660  -.5000   .0000    .00384    .5000   .8660   .0000    .0000   .0000  1.0000
   48    .08660   -.05000    .00000    .8660  -.5000   .0000    .00384    .5000   .8660   .0000    .0000   .0000  1.0000
   49    .08660   -.05000   -.07333    .8660  -.5000   .0000    .00384    .5000   .8660   .0000    .0000   .0000  1.0000
   50    .03445   -.05967    .11000    .0000   .0000  1.0000    .00449    .5000  -.8660   .0000    .8660   .5000   .0000
   51    .03445   -.05967   -.11000    .0000   .0000 -1.0000    .00449    .5000  -.8660   .0000   -.8660  -.5000   .0000
   52    .01675    .01675    .11000    .0000   .0000  1.0000    .00112   1.0000   .0000   .0000    .0000  1.0000   .0000
   53   -.01675    .01675    .11000    .0000   .0000  1.0000    .00112   1.0000   .0000   .0000    .0000  1.0000   .0000
   54   -.01675   -.01675    .11000    .0000   .0000  1.0000    .00112   1.0000   .0000   .0000    .0000  1.0000   .0000
   55    .01675   -.01675    .11000    .0000   .0000  1.0000    .00112   1.0000   .0000   .0000    .0000  1.0000   .0000
   56    .00000    .00000   -.11000    .0000   .0000 -1.0000    .00449   1.0000   .0000   .0000    .0000 -1.0000   .0000




 ***** INPUT LINE  1  FR   0    1    0    0  4.65840E+02  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  2  CP   1    1    2    1  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00




                                 - - - - - - FREQUENCY - - - - - -

                                    FREQUENCY= 4.6584E+02 MHZ
                                    WAVELENGTH= 6.4357E-01 METERS



                                  - - - ANTENNA ENVIRONMENT - - -

                                            FREE SPACE



                               - - - STRUCTURE IMPEDANCE LOADING - - -

                                   THIS STRUCTURE IS NOT LOADED



                                - - - MATRIX TIMING - - -

                        FILL=     .500 SEC.,  FACTOR=    1.540 SEC.



                                    - - - ISOLATION DATA - - -

      - - COUPLING BETWEEN - -        MAXIMUM               - - - FOR MAXIMUM COUPLING - - -
            SEG.              SEG.   COUPLING    LOAD IMPEDANCE (2ND SEG.)       INPUT IMPEDANCE
  TAG/SEG.   NO.    TAG/SEG.   NO.      (DB)        REAL         IMAG.         REAL         IMAG.
    1    1     1      2    1     5    -13.722     5.58110E+01 -2.06399E+01   1.82306E+01 -1.16448E+02



 ***** INPUT LINE  3  EX   0    1    1    0  1.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  4  RP   0   73    1 1000  0.00000E+00  0.00000E+00  5.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00



                                          - - - ANTENNA INPUT PARAMETERS - - -

   TAG   SEG.    VOLTAGE (VOLTS)         CURRENT (AMPS)         IMPEDANCE (OHMS)        ADMITTANCE (MHOS)      POWER
   NO.   NO.    REAL        IMAG.       REAL        IMAG.       REAL        IMAG.       REAL        IMAG.     (WATTS)
     1     1 1.00000E+00 0.00000E+00 1.25123E-03 8.29191E-03 1.77930E+01-1.17915E+02 1.25123E-03 8.29191E-03 6.25614E-04



                             - - - CURRENTS AND LOCATION - - -

                     LENGTHS NORMALIZED BY WAVELENGTH (OR 2.*PI/CABS(K))

  SEG.  TAG    COORD. OF SEG. CENTER     SEG.            - - - CURRENT (AMPS) - - -
  NO.   NO.     X        Y        Z      LENGTH     REAL        IMAG.       MAG.        PHASE
     1    1    .0000    .0000    .1942   .04662   1.2512E-03  8.2919E-03  8.3858E-03   81.419
     2    1    .0000    .0000    .2408   .04662   1.0974E-03  6.5797E-03  6.6706E-03   80.531
     3    1    .0000    .0000    .2875   .04662   7.9159E-04  4.3755E-03  4.4465E-03   79.745
     4    1    .0000    .0000    .3341   .04662   3.3072E-04  1.7249E-03  1.7563E-03   79.146
     5    2    .1827    .0000    .0000   .05470  -7.5951E-04  1.5535E-03  1.7292E-03  116.054
     6    2    .2374    .0000    .0000   .05470  -7.0187E-04  1.4308E-03  1.5937E-03  116.130
     7    2    .2921    .0000    .0000   .05470  -5.8469E-04  1.1901E-03  1.3260E-03  116.164
     8    2    .3468    .0000    .0000   .05470  -4.0822E-04  8.3176E-04  9.2653E-04  116.141
     9    2    .4015    .0000    .0000   .05469  -1.7005E-04  3.4744E-04  3.8682E-04  116.079




                                         - - - - SURFACE PATCH CURRENTS - - - -

                                                  DISTANCES IN WAVELENGTHS (2.*PI/CABS(K))
                                                  CURRENT IN AMPS/METER

                            - - SURFACE COMPONENTS - -                   - - - RECTANGULAR COMPONENTS - - -
      PATCH CENTER      TANGENT VECTOR 1   TANGENT VECTOR 2           X                   Y                   Z
     X      Y      Z     MAG.       PHASE   MAG.       PHASE    REAL      IMAG.     REAL      IMAG.     REAL      IMAG. 
    1
    .155   .000   .114 5.3064E-10  139.91 7.1971E-03  -35.22  0.00E+00  0.00E+00 -4.06E-10  3.42E-10  5.88E-03 -4.15E-03
    2
    .155   .024   .024 9.0028E-03  -65.45 1.4222E-02  -51.34  0.00E+00  0.00E+00  3.74E-03 -8.19E-03  8.88E-03 -1.11E-02
    3
    .155  -.024   .024 9.0028E-03  114.55 1.4222E-02  -51.34  0.00E+00  0.00E+00 -3.74E-03  8.19E-03  8.88E-03 -1.11E-02
    4
    .155  -.024  -.024 9.0097E-03  114.50 5.0969E-03   84.34  0.00E+00  0.00E+00 -3.74E-03  8.20E-03  5.03E-04  5.07E-03
    5
    .155   .024  -.024 9.0097E-03  -65.50 5.0969E-03   84.34  0.00E+00  0.00E+00  3.74E-03 -8.20E-03  5.03E-04  5.07E-03
    6
    .155   .000  -.114 3.4452E-10  -86.20 1.5963E-03   12.56  0.00E+00  0.00E+00  2.29E-11 -3.44E-10  1.56E-03  3.47E-04
    7
    .135   .078   .114 1.8796E-03  -94.86 5.5431E-03  -11.30  7.96E-05  9.36E-04 -1.38E-04 -1.62E-03  5.44E-03 -1.09E-03
    8
    .135   .078   .000 3.9155E-03  -75.48 5.3136E-03  -33.00 -4.91E-04  1.90E-03  8.50E-04 -3.28E-03  4.46E-03 -2.89E-03
    9
    .135   .078  -.114 1.8136E-03  -94.59 2.9175E-03  -33.42  7.26E-05  9.04E-04 -1.26E-04 -1.57E-03  2.44E-03 -1.61E-03
   10
    .107   .000   .171 1.3690E-02 -104.81 8.5133E-10  169.08 -3.50E-03 -1.32E-02 -8.36E-10  1.61E-10  0.00E+00  0.00E+00
   11
    .107   .000  -.171 1.5185E-03  -10.60 2.5369E-10  120.73  1.49E-03 -2.79E-04  1.30E-10 -2.18E-10  0.00E+00  0.00E+00
   12
    .078   .135   .114 1.6708E-03 -129.80 4.7412E-03   -8.86  9.26E-04  1.11E-03 -5.35E-04 -6.42E-04  4.68E-03 -7.30E-04
   13
    .078   .135   .000 1.6297E-03 -112.83 5.3696E-03  -33.12  5.48E-04  1.30E-03 -3.16E-04 -7.51E-04  4.50E-03 -2.93E-03
   14
    .078   .135  -.114 1.7229E-03 -128.57 4.1502E-03  -48.62  9.30E-04  1.17E-03 -5.37E-04 -6.74E-04  2.74E-03 -3.11E-03
   15
    .000   .155   .114 1.4453E-03 -160.33 5.3230E-03   11.87  1.36E-03  4.86E-04  7.57E-11  2.71E-11  5.21E-03  1.09E-03
   16
    .000   .155   .000 1.2076E-03 -155.47 5.3687E-03  -32.95  1.10E-03  5.01E-04  6.11E-11  2.79E-11  4.51E-03 -2.92E-03
   17
    .000   .155  -.114 1.4418E-03 -160.25 4.6029E-03  -54.61  1.36E-03  4.87E-04  7.55E-11  2.71E-11  2.67E-03 -3.75E-03
   18
    .054   .093   .171 1.4844E-02 -105.23 1.6079E-03 -145.63 -8.01E-04 -6.38E-03 -4.04E-03 -1.29E-02  0.00E+00  0.00E+00
   19
    .054   .093  -.171 1.7546E-03  -50.90 1.6066E-03   35.03  1.69E-03  1.18E-04  3.00E-04 -1.64E-03  0.00E+00  0.00E+00
   20
   -.078   .135   .114 1.3171E-03 -178.67 5.0407E-03   -2.54  1.14E-03  2.65E-05  6.58E-04  1.53E-05  5.04E-03 -2.24E-04
   21
   -.078   .135   .000 9.9512E-04  178.65 5.3741E-03  -33.13  8.62E-04 -2.04E-05  4.97E-04 -1.17E-05  4.50E-03 -2.94E-03
   22
   -.078   .135  -.114 1.3021E-03  178.63 4.3368E-03  -56.63  1.13E-03 -2.69E-05  6.51E-04 -1.56E-05  2.39E-03 -3.62E-03
   23
   -.135   .078   .114 7.0547E-04  161.21 5.7471E-03    9.56  3.34E-04 -1.14E-04  5.78E-04 -1.97E-04  5.67E-03  9.55E-04
   24
   -.135   .078   .000 5.8010E-04  165.31 5.3713E-03  -33.03  2.81E-04 -7.36E-05  4.86E-04 -1.27E-04  4.50E-03 -2.93E-03
   25
   -.135   .078  -.114 6.9553E-04  166.61 4.2600E-03  -58.97  3.38E-04 -8.05E-05  5.86E-04 -1.39E-04  2.20E-03 -3.65E-03
   26
   -.054   .093   .171 1.5569E-02 -109.02 1.4146E-03 -176.68  3.76E-03  7.43E-03 -3.69E-03 -1.27E-02  0.00E+00  0.00E+00
   27
   -.054   .093  -.171 1.7610E-03  -92.01 1.4057E-03    3.01  1.25E-03  9.44E-04  6.49E-04 -1.49E-03  0.00E+00  0.00E+00
   28
   -.155   .000   .114 6.5597E-10  -80.27 5.2707E-03   -3.82  1.76E-17 -1.03E-16 -1.11E-10  6.47E-10  5.26E-03 -3.51E-04
   29
   -.155   .000   .000 4.2642E-10 -106.63 5.3698E-03  -33.05 -1.94E-17 -6.49E-17  1.22E-10  4.09E-10  4.50E-03 -2.93E-03
   30
   -.155   .000  -.114 5.6326E-10 -141.92 4.0751E-03  -57.88 -7.04E-17 -5.52E-17  4.43E-10  3.47E-10  2.17E-03 -3.45E-03
   31
   -.135  -.078   .114 7.0547E-04  -18.79 5.7471E-03    9.56  3.34E-04 -1.14E-04 -5.78E-04  1.97E-04  5.67E-03  9.55E-04
   32
   -.135  -.078   .000 5.8010E-04  -14.69 5.3713E-03  -33.03  2.81E-04 -7.36E-05 -4.86E-04  1.27E-04  4.50E-03 -2.93E-03
   33
   -.135  -.078  -.114 6.9553E-04  -13.39 4.2600E-03  -58.97  3.38E-04 -8.05E-05 -5.86E-04  1.39E-04  2.20E-03 -3.65E-03
   34
   -.107   .000   .171 1.5556E-02 -111.31 5.9994E-10   82.27  5.65E-03  1.45E-02  8.17E-10  1.71E-09  0.00E+00  0.00E+00
   35
   -.107   .000  -.171 1.6722E-03 -112.54 5.6144E-10  -28.46  6.41E-04  1.54E-03  5.95E-10 -2.22E-11  0.00E+00  0.00E+00
   36
   -.078  -.135   .114 1.3171E-03    1.33 5.0407E-03   -2.54  1.14E-03  2.65E-05 -6.58E-04 -1.53E-05  5.04E-03 -2.24E-04
   37
   -.078  -.135   .000 9.9512E-04   -1.35 5.3741E-03  -33.13  8.62E-04 -2.03E-05 -4.97E-04  1.17E-05  4.50E-03 -2.94E-03
   38
   -.078  -.135  -.114 1.3021E-03   -1.37 4.3368E-03  -56.63  1.13E-03 -2.69E-05 -6.51E-04  1.56E-05  2.39E-03 -3.62E-03
   39
    .000  -.155   .114 1.4453E-03   19.67 5.3230E-03   11.87  1.36E-03  4.86E-04  2.57E-10  9.18E-11  5.21E-03  1.09E-03
   40
    .000  -.155   .000 1.2076E-03   24.53 5.3687E-03  -32.95  1.10E-03  5.01E-04  2.07E-10  9.46E-11  4.51E-03 -2.92E-03
   41
    .000  -.155  -.114 1.4418E-03   19.75 4.6029E-03  -54.61  1.36E-03  4.87E-04  2.56E-10  9.19E-11  2.67E-03 -3.75E-03
   42
   -.054  -.093   .171 1.5569E-02 -109.02 1.4146E-03    3.32  3.76E-03  7.43E-03  3.69E-03  1.27E-02  0.00E+00  0.00E+00
   43
   -.054  -.093  -.171 1.7610E-03  -92.01 1.4057E-03 -176.99  1.25E-03  9.44E-04 -6.48E-04  1.49E-03  0.00E+00  0.00E+00
   44
    .078  -.135   .114 1.6708E-03   50.20 4.7412E-03   -8.86  9.26E-04  1.11E-03  5.35E-04  6.42E-04  4.68E-03 -7.30E-04
   45
    .078  -.135   .000 1.6297E-03   67.17 5.3696E-03  -33.12  5.48E-04  1.30E-03  3.16E-04  7.51E-04  4.50E-03 -2.93E-03
   46
    .078  -.135  -.114 1.7229E-03   51.43 4.1502E-03  -48.62  9.30E-04  1.17E-03  5.37E-04  6.74E-04  2.74E-03 -3.11E-03
   47
    .135  -.078   .114 1.8796E-03   85.14 5.5431E-03  -11.30  7.96E-05  9.36E-04  1.38E-04  1.62E-03  5.44E-03 -1.09E-03
   48
    .135  -.078   .000 3.9155E-03  104.52 5.3136E-03  -33.00 -4.91E-04  1.90E-03 -8.50E-04  3.28E-03  4.46E-03 -2.89E-03
   49
    .135  -.078  -.114 1.8136E-03   85.41 2.9175E-03  -33.42  7.26E-05  9.04E-04  1.26E-04  1.57E-03  2.44E-03 -1.61E-03
   50
    .054  -.093   .171 1.4844E-02 -105.23 1.6079E-03   34.37 -8.01E-04 -6.38E-03  4.04E-03  1.29E-02  0.00E+00  0.00E+00
   51
    .054  -.093  -.171 1.7546E-03  -50.90 1.6066E-03 -144.97  1.69E-03  1.18E-04 -3.00E-04  1.64E-03  0.00E+00  0.00E+00
   52
    .026   .026   .171 3.7705E-02  -97.61 3.8521E-02  -99.40 -4.99E-03 -3.74E-02 -6.29E-03 -3.80E-02  0.00E+00  0.00E+00
   53
   -.026   .026   .171 3.8969E-02   78.78 3.8495E-02  -99.34  7.58E-03  3.82E-02 -6.25E-03 -3.80E-02  0.00E+00  0.00E+00
   54
   -.026  -.026   .171 3.8969E-02   78.78 3.8495E-02   80.66  7.58E-03  3.82E-02  6.25E-03  3.80E-02  0.00E+00  0.00E+00
   55
    .026  -.026   .171 3.7705E-02  -97.61 3.8521E-02   80.60 -4.99E-03 -3.74E-02  6.29E-03  3.80E-02  0.00E+00  0.00E+00
   56
    .000   .000  -.171 1.3525E-03   18.01 9.5383E-10  166.94  1.29E-03  4.18E-04  9.29E-10 -2.15E-10  0.00E+00  0.00E+00



                                        - - - POWER BUDGET - - -

                                           INPUT POWER   = 6.2561E-04 WATTS
                                           RADIATED POWER= 6.2561E-04 WATTS
                                           WIRE LOSS     = 0.0000E+00 WATTS
                                           EFFICIENCY    = 100.00 PERCENT



                                                - - - RADIATION PATTERNS - - -

  - - ANGLES - -          - POWER GAINS -        - - - POLARIZATION - - -    - - - E(THETA) - - -    - - - E(PHI) - - -
  THETA     PHI        VERT.   HOR.    TOTAL      AXIAL     TILT   SENSE     MAGNITUDE    PHASE      MAGNITUDE    PHASE 
 DEGREES  DEGREES       DB      DB      DB        RATIO     DEG.               VOLTS     DEGREES       VOLTS     DEGREES
     .00      .00      -8.10 -145.12   -8.10     .00000      .00  LINEAR    7.61800E-02    -2.25    1.07467E-08  -151.92
    5.00      .00      -8.34 -140.79   -8.34     .00000      .00  LINEAR    7.41701E-02    -2.07    1.76879E-08  -154.97
   10.00      .00      -8.85 -141.75   -8.85     .00000      .00  LINEAR    6.99564E-02    -2.75    1.58285E-08  -168.33
   15.00      .00      -9.70 -148.33   -9.70     .00000      .00  LINEAR    6.33790E-02    -4.61    7.42641E-09  -150.37
   20.00      .00     -11.01 -144.64  -11.01     .00000      .00  LINEAR    5.44951E-02    -8.23    1.13565E-08  -159.55
   25.00      .00     -12.94 -146.85  -12.94     .00000      .00  LINEAR    4.36374E-02   -14.76    8.79917E-09  -172.12
   30.00      .00     -15.74 -140.78  -15.74     .00000      .00  LINEAR    3.16385E-02   -27.31    1.77051E-08  -167.67
   35.00      .00     -19.30 -139.71  -19.30     .00000      .00  LINEAR    2.09860E-02   -55.32    2.00208E-08   179.41
   40.00      .00     -19.98 -140.85  -19.98     .00000      .00  LINEAR    1.94196E-02  -107.80    1.75671E-08   168.69
   45.00      .00     -16.08 -149.37  -16.08     .00000      .00  LINEAR    3.04181E-02  -145.30    6.58772E-09   122.17
   50.00      .00     -12.40 -141.89  -12.40     .00000      .00  LINEAR    4.64494E-02  -163.88    1.55750E-08   177.96
   55.00      .00      -9.60 -141.28   -9.60     .00000      .00  LINEAR    6.41571E-02  -175.94    1.67139E-08   162.88
   60.00      .00      -7.40 -144.20   -7.40     .00000      .00  LINEAR    8.26338E-02   174.32    1.19425E-08   155.96
   65.00      .00      -5.61 -141.41   -5.61     .00000      .00  LINEAR    1.01577E-01   165.51    1.64646E-08   162.71
   70.00      .00      -4.10 -140.13   -4.10     .00000      .00  LINEAR    1.20848E-01   157.18    1.90813E-08   160.32
   75.00      .00      -2.80 -141.28   -2.80     .00000      .00  LINEAR    1.40308E-01   149.15    1.67145E-08   150.97
   80.00      .00      -1.67 -143.60   -1.67     .00000      .00  LINEAR    1.59730E-01   141.42    1.28028E-08   145.04
   85.00      .00       -.70 -146.31    -.70     .00000      .00  LINEAR    1.78749E-01   133.99    9.36677E-09   135.18
   90.00      .00        .14 -141.03     .14     .00000      .00  LINEAR    1.96860E-01   126.92    1.71966E-08   147.62
   95.00      .00        .84 -142.84     .84     .00000      .00  LINEAR    2.13435E-01   120.23    1.39603E-08   140.17
  100.00      .00       1.41 -144.46    1.41     .00000      .00  LINEAR    2.27774E-01   113.95    1.15851E-08   123.48
  105.00      .00       1.83 -144.86    1.83     .00000      .00  LINEAR    2.39165E-01   108.08    1.10684E-08   118.46
  110.00      .00       2.11 -144.93    2.11     .00000      .00  LINEAR    2.46942E-01   102.64    1.09825E-08   107.06
  115.00      .00       2.24 -142.93    2.24     .00000      .00  LINEAR    2.50544E-01    97.66    1.38210E-08   103.48
  120.00      .00       2.20 -145.18    2.20     .00000      .00  LINEAR    2.49562E-01    93.15    1.06654E-08    97.49
  125.00      .00       2.00 -146.16    2.00     .00000      .00  LINEAR    2.43770E-01    89.16    9.52879E-09    80.51
  130.00      .00       1.61 -143.32    1.61     .00000      .00  LINEAR    2.33152E-01    85.74    1.32146E-08   104.93
  135.00      .00       1.02 -143.21    1.02     .00000      .00  LINEAR    2.17913E-01    82.99    1.33911E-08    51.10
  140.00      .00        .21 -140.98     .21     .00000      .00  LINEAR    1.98484E-01    81.07    1.73026E-08    53.09
  145.00      .00       -.85 -142.77    -.85     .00000      .00  LINEAR    1.75531E-01    80.23    1.40758E-08    66.34
  150.00      .00      -2.22 -142.15   -2.22     .00000      .00  LINEAR    1.49982E-01    80.93    1.51219E-08    61.78
  155.00      .00      -3.94 -140.70   -3.94     .00000      .00  LINEAR    1.23112E-01    83.98    1.78665E-08    57.40
  160.00      .00      -6.02 -143.19   -6.02     .00000      .00  LINEAR    9.68053E-02    90.96    1.34147E-08    53.21
  165.00      .00      -8.33 -142.06   -8.33     .00000      .00  LINEAR    7.42430E-02   104.78    1.52711E-08    50.95
  170.00      .00     -10.04 -138.91  -10.04     .00000      .00  LINEAR    6.09829E-02   128.43    2.19658E-08    42.67
  175.00      .00      -9.83 -140.73   -9.83     .00000      .00  LINEAR    6.24554E-02   156.55    1.78061E-08    34.21
  180.00      .00      -8.13 -141.64   -8.13     .00000      .00  LINEAR    7.59666E-02   177.78    1.60321E-08    28.00
  185.00      .00      -6.24 -141.96   -6.24     .00000      .00  LINEAR    9.44016E-02  -168.89    1.54626E-08    27.11
  190.00      .00      -4.65 -141.85   -4.65     .00000      .00  LINEAR    1.13367E-01  -159.93    1.56538E-08    29.81
  195.00      .00      -3.40 -141.03   -3.40     .00000      .00  LINEAR    1.30945E-01  -152.98    1.72060E-08    19.07
  200.00      .00      -2.43 -145.21   -2.43     .00000      .00  LINEAR    1.46423E-01  -146.81    1.06282E-08    25.49
  205.00      .00      -1.68 -144.15   -1.68     .00000      .00  LINEAR    1.59690E-01  -140.78    1.20112E-08    27.15
  210.00      .00      -1.08 -144.38   -1.08     .00000      .00  LINEAR    1.70963E-01  -134.57    1.16927E-08     6.44
  215.00      .00       -.61 -145.38    -.61     .00000      .00  LINEAR    1.80618E-01  -128.06    1.04201E-08    23.91
  220.00      .00       -.21 -142.12    -.21     .00000      .00  LINEAR    1.89045E-01  -121.23    1.51745E-08      .04
  225.00      .00        .13 -144.07     .13     .00000      .00  LINEAR    1.96534E-01  -114.15    1.21284E-08    -2.07
  230.00      .00        .42 -148.86     .42     .00000      .00  LINEAR    2.03196E-01  -106.93    6.98459E-09    17.08
  235.00      .00        .66 -145.74     .66     .00000      .00  LINEAR    2.08937E-01   -99.67    9.99963E-09     4.73
  240.00      .00        .85 -150.03     .85     .00000      .00  LINEAR    2.13486E-01   -92.48    6.10211E-09     5.59
  245.00      .00        .97 -150.92     .97     .00000      .00  LINEAR    2.16461E-01   -85.43    5.50831E-09     9.08
  250.00      .00       1.01 -154.48    1.01     .00000      .00  LINEAR    2.17459E-01   -78.55    3.65491E-09   -20.10
  255.00      .00        .95 -148.44     .95     .00000      .00  LINEAR    2.16129E-01   -71.88    7.32922E-09   -11.02
  260.00      .00        .79 -143.69     .79     .00000      .00  LINEAR    2.12240E-01   -65.42    1.26687E-08   -36.68
  265.00      .00        .52 -145.43     .52     .00000      .00  LINEAR    2.05722E-01   -59.16    1.03629E-08   -89.73
  270.00      .00        .13 -149.09     .13     .00000      .00  LINEAR    1.96679E-01   -53.13    6.80052E-09   -69.37
  275.00      .00       -.38 -149.09    -.38     .00000      .00  LINEAR    1.85388E-01   -47.32    6.80453E-09  -108.77
  280.00      .00      -1.02 -147.56   -1.02     .00000      .00  LINEAR    1.72282E-01   -41.75    8.10847E-09  -132.45
  285.00      .00      -1.77 -151.56   -1.77     .00000      .00  LINEAR    1.57917E-01   -36.46    5.11764E-09  -108.77
  290.00      .00      -2.64 -149.63   -2.64     .00000      .00  LINEAR    1.42931E-01   -31.49    6.39012E-09  -119.36
  295.00      .00      -3.60 -145.21   -3.60     .00000      .00  LINEAR    1.28004E-01   -26.90    1.06291E-08  -117.43
  300.00      .00      -4.62 -140.88   -4.62     .00000      .00  LINEAR    1.13805E-01   -22.79    1.75040E-08  -143.50
  305.00      .00      -5.66 -144.13   -5.66     .00000      .00  LINEAR    1.00951E-01   -19.22    1.20342E-08  -113.03
  310.00      .00      -6.66 -145.07   -6.66     .00000      .00  LINEAR    8.99608E-02   -16.30    1.07996E-08  -114.55
  315.00      .00      -7.55 -146.82   -7.55     .00000      .00  LINEAR    8.12157E-02   -14.02    8.83660E-09  -113.82
  320.00      .00      -8.25 -144.29   -8.25     .00000      .00  LINEAR    7.49201E-02   -12.32    1.18203E-08  -127.16
  325.00      .00      -8.71 -144.03   -8.71     .00000      .00  LINEAR    7.10727E-02   -11.01    1.21713E-08  -144.40
  330.00      .00      -8.91 -142.76   -8.91     .00000      .00  LINEAR    6.94550E-02    -9.84    1.40976E-08  -133.58
  335.00      .00      -8.88 -140.53   -8.88     .00000      .00  LINEAR    6.96526E-02    -8.59    1.82110E-08  -145.92
  340.00      .00      -8.70 -145.35   -8.70     .00000      .00  LINEAR    7.11031E-02    -7.20    1.04648E-08  -138.91
  345.00      .00      -8.46 -146.88   -8.46     .00000      .00  LINEAR    7.31547E-02    -5.71    8.76687E-09  -160.82
  350.00      .00      -8.23 -145.92   -8.23     .00000      .00  LINEAR    7.51209E-02    -4.26    9.79415E-09  -153.74
  355.00      .00      -8.09 -142.83   -8.09     .00000      .00  LINEAR    7.63314E-02    -3.05    1.39766E-08  -174.87
  360.00      .00      -8.10 -145.60   -8.10     .00000      .00  LINEAR    7.61800E-02    -2.25    1.01668E-08  -146.04






 ***** INPUT LINE  5  EX   0    2    1    0  1.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  6  XQ   0    0    0    0  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00



                                          - - - ANTENNA INPUT PARAMETERS - - -

   TAG   SEG.    VOLTAGE (VOLTS)         CURRENT (AMPS)         IMPEDANCE (OHMS)        ADMITTANCE (MHOS)      POWER
   NO.   NO.    REAL        IMAG.       REAL        IMAG.       REAL        IMAG.       REAL        IMAG.     (WATTS)
     2     5 1.00000E+00 0.00000E+00 1.50288E-02-6.91199E-03 5.49216E+01 2.52593E+01 1.50288E-02-6.91199E-03 7.51441E-03



                             - - - CURRENTS AND LOCATION - - -

                     LENGTHS NORMALIZED BY WAVELENGTH (OR 2.*PI/CABS(K))

  SEG.  TAG    COORD. OF SEG. CENTER     SEG.            - - - CURRENT (AMPS) - - -
  NO.   NO.     X        Y        Z      LENGTH     REAL        IMAG.       MAG.        PHASE
     1    1    .0000    .0000    .1942   .04662  -9.0581E-04  1.7154E-03  1.9399E-03  117.836
     2    1    .0000    .0000    .2408   .04662  -7.8794E-04  1.5064E-03  1.7000E-03  117.613
     3    1    .0000    .0000    .2875   .04662  -5.5915E-04  1.0891E-03  1.2242E-03  117.177
     4    1    .0000    .0000    .3341   .04662  -2.2834E-04  4.5624E-04  5.1019E-04  116.587
     5    2    .1827    .0000    .0000   .05470   1.5029E-02 -6.9120E-03  1.6542E-02  -24.698
     6    2    .2374    .0000    .0000   .05470   1.3802E-02 -7.4031E-03  1.5662E-02  -28.208
     7    2    .2921    .0000    .0000   .05470   1.1403E-02 -6.7791E-03  1.3266E-02  -30.731
     8    2    .3468    .0000    .0000   .05470   7.8898E-03 -5.0202E-03  9.3516E-03  -32.468
     9    2    .4015    .0000    .0000   .05469   3.2561E-03 -2.1808E-03  3.9190E-03  -33.813




                                         - - - - SURFACE PATCH CURRENTS - - - -

                                                  DISTANCES IN WAVELENGTHS (2.*PI/CABS(K))
                                                  CURRENT IN AMPS/METER

                            - - SURFACE COMPONENTS - -                   - - - RECTANGULAR COMPONENTS - - -
      PATCH CENTER      TANGENT VECTOR 1   TANGENT VECTOR 2           X                   Y                   Z
     X      Y      Z     MAG.       PHASE   MAG.       PHASE    REAL      IMAG.     REAL      IMAG.     REAL      IMAG. 
    1
    .155   .000   .114 4.2524E-09  113.80 4.0395E-02  140.23  0.00E+00  0.00E+00 -1.72E-09  3.89E-09 -3.10E-02  2.58E-02
    2
    .155   .024   .024 8.6326E-02  153.30 8.8861E-02  153.00  0.00E+00  0.00E+00 -7.71E-02  3.88E-02 -7.92E-02  4.03E-02
    3
    .155  -.024   .024 8.6326E-02  -26.70 8.8861E-02  153.00  0.00E+00  0.00E+00  7.71E-02 -3.88E-02 -7.92E-02  4.03E-02
    4
    .155  -.024  -.024 8.6323E-02  -26.70 9.1298E-02  -26.15  0.00E+00  0.00E+00  7.71E-02 -3.88E-02  8.20E-02 -4.02E-02
    5
    .155   .024  -.024 8.6323E-02  153.30 9.1298E-02  -26.15  0.00E+00  0.00E+00 -7.71E-02  3.88E-02  8.20E-02 -4.02E-02
    6
    .155   .000  -.114 3.5554E-09  110.16 4.1819E-02  -37.69  0.00E+00  0.00E+00 -1.23E-09  3.34E-09  3.31E-02 -2.56E-02
    7
    .135   .078   .114 1.7535E-02  121.84 2.2203E-02  129.66  4.63E-03 -7.45E-03 -8.01E-03  1.29E-02 -1.42E-02  1.71E-02
    8
    .135   .078   .000 3.7645E-02  141.93 1.3238E-03    2.36  1.48E-02 -1.16E-02 -2.57E-02  2.01E-02  1.32E-03  5.45E-05
    9
    .135   .078  -.114 1.7518E-02  121.84 2.3099E-02  -45.70  4.62E-03 -7.44E-03 -8.00E-03  1.29E-02  1.61E-02 -1.65E-02
   10
    .107   .000   .171 2.0215E-02  -85.03 3.5771E-09  -56.73  1.75E-03 -2.01E-02  1.96E-09 -2.99E-09  0.00E+00  0.00E+00
   11
    .107   .000  -.171 1.6876E-02  -87.10 9.9131E-10  179.47  8.55E-04 -1.69E-02  9.91E-10 -9.17E-12  0.00E+00  0.00E+00
   12
    .078   .135   .114 1.6712E-02   87.53 6.2231E-03  106.05 -6.25E-04 -1.45E-02  3.61E-04  8.35E-03 -1.72E-03  5.98E-03
   13
    .078   .135   .000 1.5769E-02  103.51 1.3329E-03    2.81  3.19E-03 -1.33E-02 -1.84E-03  7.67E-03  1.33E-03  6.54E-05
   14
    .078   .135  -.114 1.6655E-02   87.45 6.8125E-03  -56.49 -6.41E-04 -1.44E-02  3.70E-04  8.32E-03  3.76E-03 -5.68E-03
   15
    .000   .155   .114 1.3966E-02   55.65 1.7992E-03   89.82 -7.88E-03 -1.15E-02 -4.38E-10 -6.41E-10  5.58E-06  1.80E-03
   16
    .000   .155   .000 1.1671E-02   60.49 1.3311E-03    3.42 -5.75E-03 -1.02E-02 -3.20E-10 -5.65E-10  1.33E-03  7.94E-05
   17
    .000   .155  -.114 1.3952E-02   55.63 2.2809E-03  -30.99 -7.88E-03 -1.15E-02 -4.38E-10 -6.40E-10  1.96E-03 -1.17E-03
   18
    .054   .093   .171 9.5486E-03  -98.10 1.5575E-02   70.79 -5.11E-03 -1.75E-02  1.40E-03 -8.33E-04  0.00E+00  0.00E+00
   19
    .054   .093  -.171 6.5737E-03 -109.89 1.5544E-02 -109.23 -5.55E-03 -1.58E-02  6.23E-04  1.98E-03  0.00E+00  0.00E+00
   20
   -.078   .135   .114 1.2624E-02   34.29 1.5700E-03  179.33 -9.03E-03 -6.16E-03 -5.22E-03 -3.56E-03 -1.57E-03  1.83E-05
   21
   -.078   .135   .000 9.6173E-03   34.26 1.3373E-03    3.29 -6.88E-03 -4.69E-03 -3.97E-03 -2.71E-03  1.34E-03  7.67E-05
   22
   -.078   .135  -.114 1.2603E-02   34.43 3.6445E-03    5.06 -9.00E-03 -6.17E-03 -5.20E-03 -3.56E-03  3.63E-03  3.21E-04
   23
   -.135   .078   .114 6.7440E-03   22.43 4.2070E-03 -179.28 -3.12E-03 -1.29E-03 -5.40E-03 -2.23E-03 -4.21E-03 -5.26E-05
   24
   -.135   .078   .000 5.6066E-03   21.57 1.3442E-03    3.21 -2.61E-03 -1.03E-03 -4.52E-03 -1.78E-03  1.34E-03  7.53E-05
   25
   -.135   .078  -.114 6.7311E-03   22.45 6.2421E-03    6.28 -3.11E-03 -1.29E-03 -5.39E-03 -2.23E-03  6.20E-03  6.82E-04
   26
   -.054   .093   .171 5.5928E-03    3.16 1.3636E-02   38.75 -1.20E-02 -7.54E-03 -4.81E-04 -4.00E-03  0.00E+00  0.00E+00
   27
   -.054   .093  -.171 5.8828E-03   37.28 1.3611E-02 -141.23 -1.15E-02 -9.16E-03 -1.25E-03 -1.18E-03  0.00E+00  0.00E+00
   28
   -.155   .000   .114 1.2638E-09  157.62 4.2246E-03  178.49 -1.86E-16  7.64E-17  1.17E-09 -4.81E-10 -4.22E-03  1.11E-04
   29
   -.155   .000   .000 1.5934E-09  143.29 1.3472E-03    3.06 -2.03E-16  1.51E-16  1.28E-09 -9.52E-10  1.35E-03  7.20E-05
   30
   -.155   .000  -.114 1.6915E-09 -124.27 6.3070E-03    2.14 -1.51E-16 -2.22E-16  9.53E-10  1.40E-09  6.30E-03  2.35E-04
   31
   -.135  -.078   .114 6.7440E-03 -157.57 4.2070E-03 -179.28 -3.12E-03 -1.29E-03  5.40E-03  2.23E-03 -4.21E-03 -5.26E-05
   32
   -.135  -.078   .000 5.6066E-03 -158.43 1.3442E-03    3.21 -2.61E-03 -1.03E-03  4.52E-03  1.78E-03  1.34E-03  7.53E-05
   33
   -.135  -.078  -.114 6.7311E-03 -157.55 6.2421E-03    6.28 -3.11E-03 -1.29E-03  5.39E-03  2.23E-03  6.20E-03  6.82E-04
   34
   -.107   .000   .171 1.1521E-02    9.49 2.0097E-09   88.28 -1.14E-02 -1.90E-03 -1.87E-09 -2.31E-09  0.00E+00  0.00E+00
   35
   -.107   .000  -.171 1.1649E-02   26.25 7.0934E-10 -136.76 -1.04E-02 -5.15E-03 -2.18E-09 -1.30E-09  0.00E+00  0.00E+00
   36
   -.078  -.135   .114 1.2624E-02 -145.71 1.5700E-03  179.33 -9.03E-03 -6.16E-03  5.22E-03  3.56E-03 -1.57E-03  1.83E-05
   37
   -.078  -.135   .000 9.6173E-03 -145.74 1.3373E-03    3.29 -6.88E-03 -4.69E-03  3.97E-03  2.71E-03  1.34E-03  7.67E-05
   38
   -.078  -.135  -.114 1.2603E-02 -145.57 3.6445E-03    5.06 -9.00E-03 -6.17E-03  5.20E-03  3.56E-03  3.63E-03  3.21E-04
   39
    .000  -.155   .114 1.3966E-02 -124.35 1.7992E-03   89.82 -7.88E-03 -1.15E-02 -1.49E-09 -2.18E-09  5.57E-06  1.80E-03
   40
    .000  -.155   .000 1.1671E-02 -119.51 1.3311E-03    3.42 -5.75E-03 -1.02E-02 -1.08E-09 -1.92E-09  1.33E-03  7.94E-05
   41
    .000  -.155  -.114 1.3952E-02 -124.37 2.2809E-03  -30.99 -7.88E-03 -1.15E-02 -1.49E-09 -2.17E-09  1.96E-03 -1.17E-03
   42
   -.054  -.093   .171 5.5928E-03    3.16 1.3636E-02 -141.25 -1.20E-02 -7.54E-03  4.81E-04  4.00E-03  0.00E+00  0.00E+00
   43
   -.054  -.093  -.171 5.8828E-03   37.28 1.3611E-02   38.77 -1.15E-02 -9.16E-03  1.25E-03  1.18E-03  0.00E+00  0.00E+00
   44
    .078  -.135   .114 1.6712E-02  -92.47 6.2232E-03  106.05 -6.25E-04 -1.45E-02 -3.61E-04 -8.35E-03 -1.72E-03  5.98E-03
   45
    .078  -.135   .000 1.5769E-02  -76.49 1.3329E-03    2.81  3.19E-03 -1.33E-02  1.84E-03 -7.67E-03  1.33E-03  6.54E-05
   46
    .078  -.135  -.114 1.6655E-02  -92.55 6.8125E-03  -56.49 -6.41E-04 -1.44E-02 -3.70E-04 -8.32E-03  3.76E-03 -5.68E-03
   47
    .135  -.078   .114 1.7535E-02  -58.16 2.2203E-02  129.66  4.63E-03 -7.45E-03  8.01E-03 -1.29E-02 -1.42E-02  1.71E-02
   48
    .135  -.078   .000 3.7645E-02  -38.07 1.3238E-03    2.36  1.48E-02 -1.16E-02  2.57E-02 -2.01E-02  1.32E-03  5.45E-05
   49
    .135  -.078  -.114 1.7518E-02  -58.16 2.3099E-02  -45.70  4.62E-03 -7.44E-03  8.00E-03 -1.29E-02  1.61E-02 -1.65E-02
   50
    .054  -.093   .171 9.5487E-03  -98.10 1.5575E-02 -109.21 -5.11E-03 -1.75E-02 -1.40E-03  8.33E-04  0.00E+00  0.00E+00
   51
    .054  -.093  -.171 6.5737E-03 -109.89 1.5544E-02   70.77 -5.55E-03 -1.58E-02 -6.23E-04 -1.98E-03  0.00E+00  0.00E+00
   52
    .026   .026   .171 2.0113E-02  -97.13 8.6908E-03  -62.32 -2.50E-03 -2.00E-02  4.04E-03 -7.70E-03  0.00E+00  0.00E+00
   53
   -.026   .026   .171 1.2975E-02 -174.04 8.9451E-03  -64.50 -1.29E-02 -1.35E-03  3.85E-03 -8.07E-03  0.00E+00  0.00E+00
   54
   -.026  -.026   .171 1.2975E-02 -174.04 8.9451E-03  115.50 -1.29E-02 -1.35E-03 -3.85E-03  8.07E-03  0.00E+00  0.00E+00
   55
    .026  -.026   .171 2.0113E-02  -97.13 8.6908E-03  117.68 -2.50E-03 -2.00E-02 -4.04E-03  7.70E-03  0.00E+00  0.00E+00
   56
    .000   .000  -.171 1.3089E-02 -126.30 1.7116E-09   65.72 -7.75E-03 -1.05E-02 -7.04E-10 -1.56E-09  0.00E+00  0.00E+00



                                        - - - POWER BUDGET - - -

                                           INPUT POWER   = 7.5144E-03 WATTS
                                           RADIATED POWER= 7.5144E-03 WATTS
                                           WIRE LOSS     = 0.0000E+00 WATTS
                                           EFFICIENCY    = 100.00 PERCENT




 ***** INPUT LINE  7  NX   0    0    0    0  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
1



                                ***********************************************
                                *                                             *
                                *  NUMERICAL ELECTROMAGNETICS CODE (NEC-4.1)  *
                                *                                             *
                                ***********************************************




                      **********************************************************

                         SAMPLE PROBLEMS FOR NEC -  SCATTERING BY A WIRE.                              
                             1. STRAIGHT WIRE - FREE SPACE                                             
                             2. STRAIGHT WIRE - PERFECT GROUND                                         
                             3. STRAIGHT WIRE - FINITELY CONDUCTING GROUND                             
                                                (SIG.=1.E-4 MHOS/M., EPS.=6.)                          

                      **********************************************************





                                 - - - STRUCTURE SPECIFICATION - - -

                                     COORDINATES MUST BE INPUT IN
                                     METERS OR BE SCALED TO METERS
                                     BEFORE STRUCTURE INPUT IS ENDED


  WIRE                                                                               NO. OF    FIRST  LAST     TAG
  NO.        X1         Y1         Z1          X2         Y2         Z2      RADIUS   SEG.     SEG.   SEG.     NO.
     1  -55.00000     .00000   10.00000    55.00000     .00000   10.00000     .01000     15        1    15       0

   GROUND PLANE SPECIFIED.

   WHERE WIRE ENDS TOUCH GROUND, CURRENT WILL BE INTERPOLATED TO IMAGE IN GROUND PLANE.


   TOTAL SEGMENTS USED=   15     NO. SEG. IN A SYMMETRIC CELL=   15     SYMMETRY FLAG=  0


         - MULTIPLE WIRE JUNCTIONS -
 JUNCTION    SEGMENTS  (- FOR END 1, + FOR END 2)
  NONE




                                 - - - - SEGMENTATION DATA - - - -

                                        COORDINATES IN METERS

                         I+ AND I- INDICATE THE SEGMENTS BEFORE AND AFTER I


  SEG.   COORDINATES OF SEG. CENTER     SEG.     ORIENTATION ANGLES    WIRE    CONNECTION DATA   TAG
  NO.       X         Y         Z       LENGTH     ALPHA     BETA      RADIUS    I-   I    I+    NO.
     1 -51.33334    .00000  10.00000   7.33333     .00000    .00000    .01000     0    1    2      0
     2 -44.00000    .00000  10.00000   7.33333     .00000    .00000    .01000     1    2    3      0
     3 -36.66667    .00000  10.00000   7.33333     .00000    .00000    .01000     2    3    4      0
     4 -29.33334    .00000  10.00000   7.33333     .00000    .00000    .01000     3    4    5      0
     5 -22.00000    .00000  10.00000   7.33333     .00000    .00000    .01000     4    5    6      0
     6 -14.66667    .00000  10.00000   7.33333     .00000    .00000    .01000     5    6    7      0
     7  -7.33333    .00000  10.00000   7.33333     .00000    .00000    .01000     6    7    8      0
     8    .00000    .00000  10.00000   7.33333     .00000    .00000    .01000     7    8    9      0
     9   7.33333    .00000  10.00000   7.33333     .00000    .00000    .01000     8    9   10      0
    10  14.66667    .00000  10.00000   7.33333     .00000    .00000    .01000     9   10   11      0
    11  22.00000    .00000  10.00000   7.33333     .00000    .00000    .01000    10   11   12      0
    12  29.33333    .00000  10.00000   7.33333     .00000    .00000    .01000    11   12   13      0
    13  36.66666    .00000  10.00000   7.33333     .00000    .00000    .01000    12   13   14      0
    14  44.00000    .00000  10.00000   7.33333     .00000    .00000    .01000    13   14   15      0
    15  51.33333    .00000  10.00000   7.33334     .00000    .00000    .01000    14   15    0      0




 ***** INPUT LINE  1  FR   0    1    0    0  3.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  2  EX   1    2    1    0  0.00000E+00  0.00000E+00  0.00000E+00  4.50000E+01  0.00000E+00  0.00000E+00
 ***** INPUT LINE  3  RP   0    2    1 1000  0.00000E+00  0.00000E+00  4.50000E+01  0.00000E+00  0.00000E+00  0.00000E+00




                                 - - - - - - FREQUENCY - - - - - -

                                    FREQUENCY= 3.0000E+00 MHZ
                                    WAVELENGTH= 9.9933E+01 METERS



                                  - - - ANTENNA ENVIRONMENT - - -

                                            FREE SPACE



                               - - - STRUCTURE IMPEDANCE LOADING - - -

                                   THIS STRUCTURE IS NOT LOADED



                                - - - MATRIX TIMING - - -

                        FILL=     .070 SEC.,  FACTOR=     .000 SEC.



                                        - - - EXCITATION - - -

    PLANE WAVE    THETA=    .00 DEG,  PHI=    .00 DEG,  ETA=    .00 DEG,  TYPE -LINEAR=  AXIAL RATIO=  .000



                             - - - CURRENTS AND LOCATION - - -

                     LENGTHS NORMALIZED BY WAVELENGTH (OR 2.*PI/CABS(K))

  SEG.  TAG    COORD. OF SEG. CENTER     SEG.            - - - CURRENT (AMPS) - - -
  NO.   NO.     X        Y        Z      LENGTH     REAL        IMAG.       MAG.        PHASE
     1    0   -.5137    .0000    .1001   .07338  -8.8816E-04  2.5670E-03  2.7163E-03  109.085
     2    0   -.4403    .0000    .1001   .07338   1.5985E-03  2.1975E-03  2.7175E-03   53.967
     3    0   -.3669    .0000    .1001   .07338   8.8158E-03 -4.2494E-03  9.7865E-03  -25.735
     4    0   -.2935    .0000    .1001   .07338   1.9216E-02 -1.4937E-02  2.4339E-02  -37.860
     5    0   -.2201    .0000    .1001   .07338   3.0735E-02 -2.7408E-02  4.1180E-02  -41.726
     6    0   -.1468    .0000    .1001   .07338   4.1101E-02 -3.8922E-02  5.6606E-02  -43.440
     7    0   -.0734    .0000    .1001   .07338   4.8271E-02 -4.6991E-02  6.7367E-02  -44.230
     8    0    .0000    .0000    .1001   .07338   5.0830E-02 -4.9887E-02  7.1221E-02  -44.464
     9    0    .0734    .0000    .1001   .07338   4.8271E-02 -4.6991E-02  6.7367E-02  -44.230
    10    0    .1468    .0000    .1001   .07338   4.1101E-02 -3.8922E-02  5.6606E-02  -43.440
    11    0    .2201    .0000    .1001   .07338   3.0735E-02 -2.7408E-02  4.1181E-02  -41.726
    12    0    .2935    .0000    .1001   .07338   1.9216E-02 -1.4937E-02  2.4339E-02  -37.860
    13    0    .3669    .0000    .1001   .07338   8.8159E-03 -4.2495E-03  9.7866E-03  -25.735
    14    0    .4403    .0000    .1001   .07338   1.5986E-03  2.1975E-03  2.7174E-03   53.966
    15    0    .5137    .0000    .1001   .07338  -8.8815E-04  2.5670E-03  2.7163E-03  109.085



                                                - - - RADIATION PATTERNS - - -

  - - ANGLES - -         - CROSS SECTION -       - - - POLARIZATION - - -    - - - E(THETA) - - -    - - - E(PHI) - - -
  THETA     PHI        VERT.   HOR.    TOTAL      AXIAL     TILT   SENSE     MAGNITUDE    PHASE      MAGNITUDE    PHASE 
 DEGREES  DEGREES       DB      DB      DB        RATIO     DEG.               VOLTS     DEGREES       VOLTS     DEGREES
     .00      .00     -12.86 -999.99  -12.86     .00000      .00  LINEAR    6.41328E+00   -95.23    0.00000E+00      .00
   45.00      .00     -18.33 -999.99  -18.33     .00000      .00  LINEAR    3.41557E+00  -108.66    0.00000E+00      .00





                                        - - - EXCITATION - - -

    PLANE WAVE    THETA=  45.00 DEG,  PHI=    .00 DEG,  ETA=    .00 DEG,  TYPE -LINEAR=  AXIAL RATIO=  .000



                             - - - CURRENTS AND LOCATION - - -

                     LENGTHS NORMALIZED BY WAVELENGTH (OR 2.*PI/CABS(K))

  SEG.  TAG    COORD. OF SEG. CENTER     SEG.            - - - CURRENT (AMPS) - - -
  NO.   NO.     X        Y        Z      LENGTH     REAL        IMAG.       MAG.        PHASE
     1    0   -.5137    .0000    .1001   .07338  -1.4018E-02 -2.6706E-02  3.0162E-02 -117.696
     2    0   -.4403    .0000    .1001   .07338  -3.9114E-02 -6.9420E-02  7.9681E-02 -119.399
     3    0   -.3669    .0000    .1001   .07338  -5.8271E-02 -9.6999E-02  1.1316E-01 -120.995
     4    0   -.2935    .0000    .1001   .07338  -6.7872E-02 -1.0687E-01  1.2660E-01 -122.420
     5    0   -.2201    .0000    .1001   .07338  -6.5358E-02 -9.8634E-02  1.1832E-01 -123.530
     6    0   -.1468    .0000    .1001   .07338  -5.0272E-02 -7.4959E-02  9.0256E-02 -123.848
     7    0   -.0734    .0000    .1001   .07338  -2.4527E-02 -4.1065E-02  4.7833E-02 -120.849
     8    0    .0000    .0000    .1001   .07338   7.8287E-03 -3.6794E-03  8.6502E-03  -25.173
     9    0    .0734    .0000    .1001   .07338   4.1295E-02  3.0302E-02  5.1220E-02   36.271
    10    0    .1468    .0000    .1001   .07338   6.9910E-02  5.5139E-02  8.9038E-02   38.264
    11    0    .2201    .0000    .1001   .07338   8.8355E-02  6.7302E-02  1.1107E-01   37.297
    12    0    .2935    .0000    .1001   .07338   9.2959E-02  6.6030E-02  1.1402E-01   35.387
    13    0    .3669    .0000    .1001   .07338   8.2371E-02  5.3310E-02  9.8117E-02   32.911
    14    0    .4403    .0000    .1001   .07338   5.7747E-02  3.3262E-02  6.6641E-02   29.942
    15    0    .5137    .0000    .1001   .07338   2.1820E-02  1.0871E-02  2.4378E-02   26.483



                                                - - - RADIATION PATTERNS - - -

  - - ANGLES - -         - CROSS SECTION -       - - - POLARIZATION - - -    - - - E(THETA) - - -    - - - E(PHI) - - -
  THETA     PHI        VERT.   HOR.    TOTAL      AXIAL     TILT   SENSE     MAGNITUDE    PHASE      MAGNITUDE    PHASE 
 DEGREES  DEGREES       DB      DB      DB        RATIO     DEG.               VOLTS     DEGREES       VOLTS     DEGREES
     .00      .00     -18.38 -999.99  -18.38     .00000      .00  LINEAR    3.39890E+00  -108.66    0.00000E+00      .00
   45.00      .00     -10.40 -999.99  -10.40     .00000      .00  LINEAR    8.51381E+00    71.99    0.00000E+00      .00






 ***** INPUT LINE  4  GN   1    0    0    0  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  5  EX   1    1    1    0  4.50000E+01  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  6  RP   0   19    1 1000  9.00000E+01  0.00000E+00 -1.00000E+01  0.00000E+00  0.00000E+00  0.00000E+00




                                 - - - - - - FREQUENCY - - - - - -

                                    FREQUENCY= 3.0000E+00 MHZ
                                    WAVELENGTH= 9.9933E+01 METERS



                                  - - - ANTENNA ENVIRONMENT - - -

                                          PERFECT GROUND



                               - - - STRUCTURE IMPEDANCE LOADING - - -

                                   THIS STRUCTURE IS NOT LOADED



                                - - - MATRIX TIMING - - -

                        FILL=     .120 SEC.,  FACTOR=     .010 SEC.



                                        - - - EXCITATION - - -

    PLANE WAVE    THETA=  45.00 DEG,  PHI=    .00 DEG,  ETA=    .00 DEG,  TYPE -LINEAR=  AXIAL RATIO=  .000



                             - - - CURRENTS AND LOCATION - - -

                     LENGTHS NORMALIZED BY WAVELENGTH (OR 2.*PI/CABS(K))

  SEG.  TAG    COORD. OF SEG. CENTER     SEG.            - - - CURRENT (AMPS) - - -
  NO.   NO.     X        Y        Z      LENGTH     REAL        IMAG.       MAG.        PHASE
     1    0   -.5137    .0000    .1001   .07338   9.6561E-03 -2.2202E-02  2.4211E-02  -66.495
     2    0   -.4403    .0000    .1001   .07338   2.3188E-02 -6.0451E-02  6.4746E-02  -69.014
     3    0   -.3669    .0000    .1001   .07338   2.9765E-02 -8.8240E-02  9.3125E-02  -71.360
     4    0   -.2935    .0000    .1001   .07338   2.9987E-02 -1.0121E-01  1.0556E-01  -73.496
     5    0   -.2201    .0000    .1001   .07338   2.5315E-02 -9.6765E-02  1.0002E-01  -75.339
     6    0   -.1468    .0000    .1001   .07338   1.7997E-02 -7.5366E-02  7.7485E-02  -76.570
     7    0   -.0734    .0000    .1001   .07338   1.0529E-02 -4.0582E-02  4.1926E-02  -75.455
     8    0    .0000    .0000    .1001   .07338   5.0481E-03  1.5152E-03  5.2707E-03   16.708
     9    0    .0734    .0000    .1001   .07338   2.8281E-03  4.3478E-02  4.3569E-02   86.278
    10    0    .1468    .0000    .1001   .07338   4.0022E-03  7.7882E-02  7.7985E-02   87.058
    11    0    .2201    .0000    .1001   .07338   7.5625E-03  9.8727E-02  9.9016E-02   85.620
    12    0    .2935    .0000    .1001   .07338   1.1641E-02  1.0254E-01  1.0320E-01   83.523
    13    0    .3669    .0000    .1001   .07338   1.3997E-02  8.8980E-02  9.0075E-02   81.060
    14    0    .4403    .0000    .1001   .07338   1.2583E-02  6.0736E-02  6.2025E-02   78.296
    15    0    .5137    .0000    .1001   .07338   5.8545E-03  2.2237E-02  2.2995E-02   75.250



                                                - - - RADIATION PATTERNS - - -

  - - ANGLES - -         - CROSS SECTION -       - - - POLARIZATION - - -    - - - E(THETA) - - -    - - - E(PHI) - - -
  THETA     PHI        VERT.   HOR.    TOTAL      AXIAL     TILT   SENSE     MAGNITUDE    PHASE      MAGNITUDE    PHASE 
 DEGREES  DEGREES       DB      DB      DB        RATIO     DEG.               VOLTS     DEGREES       VOLTS     DEGREES
   90.00      .00    -999.99 -999.99 -999.99     .00000      .00            4.91094E-15   180.00    0.00000E+00      .00
   80.00      .00     -36.78 -999.99  -36.78     .00000      .00  LINEAR    4.08382E-01  -175.53    0.00000E+00      .00
   70.00      .00     -24.91 -999.99  -24.91     .00000      .00  LINEAR    1.60225E+00  -175.47    0.00000E+00      .00
   60.00      .00     -18.29 -999.99  -18.29     .00000      .00  LINEAR    3.43166E+00  -175.38    0.00000E+00      .00
   50.00      .00     -14.20 -999.99  -14.20     .00000      .00  LINEAR    5.49971E+00  -175.26    0.00000E+00      .00
   40.00      .00     -12.00 -999.99  -12.00     .00000      .00  LINEAR    7.08357E+00  -175.08    0.00000E+00      .00
   30.00      .00     -11.77 -999.99  -11.77     .00000      .00  LINEAR    7.27029E+00  -174.82    0.00000E+00      .00
   20.00      .00     -14.39 -999.99  -14.39     .00000      .00  LINEAR    5.37932E+00  -174.28    0.00000E+00      .00
   10.00      .00     -25.57 -999.99  -25.57     .00000      .00  LINEAR    1.48517E+00  -171.00    0.00000E+00      .00
     .00      .00     -18.38 -999.99  -18.38     .00000      .00  LINEAR    3.39531E+00     3.10    0.00000E+00      .00
  -10.00      .00     -11.31 -999.99  -11.31     .00000      .00  LINEAR    7.66722E+00     4.34    0.00000E+00      .00
  -20.00      .00      -8.98 -999.99   -8.98     .00000      .00  LINEAR    1.00251E+01     4.77    0.00000E+00      .00
  -30.00      .00      -8.95 -999.99   -8.95     .00000      .00  LINEAR    1.00633E+01     5.05    0.00000E+00      .00
  -40.00      .00     -10.60 -999.99  -10.60     .00000      .00  LINEAR    8.31612E+00     5.29    0.00000E+00      .00
  -50.00      .00     -13.78 -999.99  -13.78     .00000      .00  LINEAR    5.77200E+00     5.49    0.00000E+00      .00
  -60.00      .00     -18.58 -999.99  -18.58     .00000      .00  LINEAR    3.31796E+00     5.68    0.00000E+00      .00
  -70.00      .00     -25.71 -999.99  -25.71     .00000      .00  LINEAR    1.46092E+00     5.82    0.00000E+00      .00
  -80.00      .00     -37.90 -999.99  -37.90     .00000      .00  LINEAR    3.59184E-01     5.92    0.00000E+00      .00
  -90.00      .00    -999.99 -999.99 -999.99     .00000      .00            0.00000E+00      .00    0.00000E+00      .00






 ***** INPUT LINE  7  GN   0    0    0    0  6.00000E+00  1.00000E-04  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  8  RP   0   19    1 1000  9.00000E+01  0.00000E+00 -1.00000E+01  0.00000E+00  0.00000E+00  0.00000E+00




                                 - - - - - - FREQUENCY - - - - - -

                                    FREQUENCY= 3.0000E+00 MHZ
                                    WAVELENGTH= 9.9933E+01 METERS



                                  - - - ANTENNA ENVIRONMENT - - -

                                        FINITE GROUND.  REFLECTION COEFFICIENT APPROXIMATION
                                        RELATIVE DIELECTRIC CONST.=  6.000
                                        CONDUCTIVITY= 1.000E-04 MHOS/METER
                                        COMPLEX DIELECTRIC CONSTANT= 6.00000E+00-5.99183E-01



                               - - - STRUCTURE IMPEDANCE LOADING - - -

                                   THIS STRUCTURE IS NOT LOADED



                                - - - MATRIX TIMING - - -

                        FILL=     .140 SEC.,  FACTOR=     .000 SEC.



                                        - - - EXCITATION - - -

    PLANE WAVE    THETA=  45.00 DEG,  PHI=    .00 DEG,  ETA=    .00 DEG,  TYPE -LINEAR=  AXIAL RATIO=  .000



                             - - - CURRENTS AND LOCATION - - -

                     LENGTHS NORMALIZED BY WAVELENGTH (OR 2.*PI/CABS(K))

  SEG.  TAG    COORD. OF SEG. CENTER     SEG.            - - - CURRENT (AMPS) - - -
  NO.   NO.     X        Y        Z      LENGTH     REAL        IMAG.       MAG.        PHASE
     1    0   -.5137    .0000    .1001   .07338  -7.7095E-03 -2.4421E-02  2.5609E-02 -107.521
     2    0   -.4403    .0000    .1001   .07338  -2.2707E-02 -6.4147E-02  6.8047E-02 -109.494
     3    0   -.3669    .0000    .1001   .07338  -3.5359E-02 -9.0527E-02  9.7188E-02 -111.335
     4    0   -.2935    .0000    .1001   .07338  -4.2711E-02 -1.0066E-01  1.0934E-01 -112.993
     5    0   -.2201    .0000    .1001   .07338  -4.2368E-02 -9.3636E-02  1.0277E-01 -114.345
     6    0   -.1468    .0000    .1001   .07338  -3.3299E-02 -7.1510E-02  7.8883E-02 -114.969
     7    0   -.0734    .0000    .1001   .07338  -1.6198E-02 -3.8905E-02  4.2142E-02 -112.605
     8    0    .0000    .0000    .1001   .07338   6.5211E-03 -2.1112E-03  6.8543E-03  -17.939
     9    0    .0734    .0000    .1001   .07338   3.1092E-02  3.2145E-02  4.4722E-02   45.953
    10    0    .1468    .0000    .1001   .07338   5.3059E-02  5.7997E-02  7.8606E-02   47.546
    11    0    .2201    .0000    .1001   .07338   6.8107E-02  7.1520E-02  9.8761E-02   46.400
    12    0    .2935    .0000    .1001   .07338   7.2903E-02  7.1391E-02  1.0204E-01   44.400
    13    0    .3669    .0000    .1001   .07338   6.5756E-02  5.8999E-02  8.8344E-02   41.900
    14    0    .4403    .0000    .1001   .07338   4.6930E-02  3.7971E-02  6.0368E-02   38.976
    15    0    .5137    .0000    .1001   .07338   1.8053E-02  1.2945E-02  2.2215E-02   35.642



                                                - - - RADIATION PATTERNS - - -

  - - ANGLES - -         - CROSS SECTION -       - - - POLARIZATION - - -    - - - E(THETA) - - -    - - - E(PHI) - - -
  THETA     PHI        VERT.   HOR.    TOTAL      AXIAL     TILT   SENSE     MAGNITUDE    PHASE      MAGNITUDE    PHASE 
 DEGREES  DEGREES       DB      DB      DB        RATIO     DEG.               VOLTS     DEGREES       VOLTS     DEGREES
   90.00      .00    -149.54 -999.99 -149.54     .00000      .00  LINEAR    9.39767E-07  -125.54    0.00000E+00      .00
   80.00      .00     -20.83 -999.99  -20.83     .00000      .00  LINEAR    2.56117E+00    58.15    0.00000E+00      .00
   70.00      .00     -17.03 -999.99  -17.03     .00000      .00  LINEAR    3.96648E+00    66.92    0.00000E+00      .00
   60.00      .00     -14.91 -999.99  -14.91     .00000      .00  LINEAR    5.06490E+00    79.04    0.00000E+00      .00
   50.00      .00     -13.32 -999.99  -13.32     .00000      .00  LINEAR    6.08615E+00    91.45    0.00000E+00      .00
   40.00      .00     -12.41 -999.99  -12.41     .00000      .00  LINEAR    6.75445E+00   101.83    0.00000E+00      .00
   30.00      .00     -12.82 -999.99  -12.82     .00000      .00  LINEAR    6.44305E+00   109.70    0.00000E+00      .00
   20.00      .00     -15.74 -999.99  -15.74     .00000      .00  LINEAR    4.60351E+00   116.07    0.00000E+00      .00
   10.00      .00     -26.88 -999.99  -26.88     .00000      .00  LINEAR    1.27626E+00   130.68    0.00000E+00      .00
     .00      .00     -19.74 -999.99  -19.74     .00000      .00  LINEAR    2.90333E+00   -70.75    0.00000E+00      .00
  -10.00      .00     -12.71 -999.99  -12.71     .00000      .00  LINEAR    6.52624E+00   -67.06    0.00000E+00      .00
  -20.00      .00     -10.25 -999.99  -10.25     .00000      .00  LINEAR    8.66638E+00   -68.08    0.00000E+00      .00
  -30.00      .00      -9.90 -999.99   -9.90     .00000      .00  LINEAR    9.02113E+00   -71.67    0.00000E+00      .00
  -40.00      .00     -10.90 -999.99  -10.90     .00000      .00  LINEAR    8.03584E+00   -77.94    0.00000E+00      .00
  -50.00      .00     -12.76 -999.99  -12.76     .00000      .00  LINEAR    6.48624E+00   -87.17    0.00000E+00      .00
  -60.00      .00     -15.05 -999.99  -15.05     .00000      .00  LINEAR    4.98290E+00   -98.67    0.00000E+00      .00
  -70.00      .00     -17.67 -999.99  -17.67     .00000      .00  LINEAR    3.68643E+00  -110.10    0.00000E+00      .00
  -80.00      .00     -21.77 -999.99  -21.77     .00000      .00  LINEAR    2.29888E+00  -118.44    0.00000E+00      .00
  -90.00      .00    -150.58 -999.99 -150.58     .00000      .00  LINEAR    8.33621E-07    58.01    0.00000E+00      .00






 ***** INPUT LINE  9  NX   0    0    0    0  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
1



                                ***********************************************
                                *                                             *
                                *  NUMERICAL ELECTROMAGNETICS CODE (NEC-4.1)  *
                                *                                             *
                                ***********************************************




                      **********************************************************

                         SAMPLE PROBLEM FOR NEC                                                        
                         STICK MODEL OF AIRCRAFT - FREE SPACE                                          

                      **********************************************************





                                 - - - STRUCTURE SPECIFICATION - - -

                                     COORDINATES MUST BE INPUT IN
                                     METERS OR BE SCALED TO METERS
                                     BEFORE STRUCTURE INPUT IS ENDED


  WIRE                                                                               NO. OF    FIRST  LAST     TAG
  NO.        X1         Y1         Z1          X2         Y2         Z2      RADIUS   SEG.     SEG.   SEG.     NO.
     1     .00000     .00000     .00000     6.00000     .00000     .00000    1.00000      1        1     1       1
     2    6.00000     .00000     .00000    44.00000     .00000     .00000    1.00000      6        2     7       2
     3   44.00000     .00000     .00000    68.00000     .00000     .00000    1.00000      4        8    11       3
     4   44.00000     .00000     .00000    24.00000   29.90000     .00000    1.00000      6       12    17       4
     5   44.00000     .00000     .00000    24.00000  -29.90000     .00000    1.00000      6       18    23       5
     6    6.00000     .00000     .00000     2.00000   11.30000     .00000    1.00000      2       24    25       6
     7    6.00000     .00000     .00000     2.00000  -11.30000     .00000    1.00000      2       26    27       7
     8    6.00000     .00000     .00000     2.00000     .00000   10.00000    1.00000      2       28    29       8

   TOTAL SEGMENTS USED=   29     NO. SEG. IN A SYMMETRIC CELL=   29     SYMMETRY FLAG=  0


         - MULTIPLE WIRE JUNCTIONS -
 JUNCTION    SEGMENTS  (- FOR END 1, + FOR END 2)
     1         1   -2  -24  -26  -28
     2         7   -8  -12  -18




                                 - - - - SEGMENTATION DATA - - - -

                                        COORDINATES IN METERS

                         I+ AND I- INDICATE THE SEGMENTS BEFORE AND AFTER I


  SEG.   COORDINATES OF SEG. CENTER     SEG.     ORIENTATION ANGLES    WIRE    CONNECTION DATA   TAG
  NO.       X         Y         Z       LENGTH     ALPHA     BETA      RADIUS    I-   I    I+    NO.
     1   3.00000    .00000    .00000   6.00000     .00000    .00000   1.00000     0    1    2      1
     2   9.16667    .00000    .00000   6.33333     .00000    .00000   1.00000   -24    2    3      2
     3  15.50000    .00000    .00000   6.33333     .00000    .00000   1.00000     2    3    4      2
     4  21.83334    .00000    .00000   6.33333     .00000    .00000   1.00000     3    4    5      2
     5  28.16667    .00000    .00000   6.33333     .00000    .00000   1.00000     4    5    6      2
     6  34.50000    .00000    .00000   6.33333     .00000    .00000   1.00000     5    6    7      2
     7  40.83334    .00000    .00000   6.33333     .00000    .00000   1.00000     6    7    8      2
     8  47.00000    .00000    .00000   6.00000     .00000    .00000   1.00000   -12    8    9      3
     9  53.00000    .00000    .00000   6.00000     .00000    .00000   1.00000     8    9   10      3
    10  59.00000    .00000    .00000   6.00000     .00000    .00000   1.00000     9   10   11      3
    11  65.00000    .00000    .00000   6.00000     .00000    .00000   1.00000    10   11    0      3
    12  42.33334   2.49167    .00000   5.99539     .00000 123.77841   1.00000   -18   12   13      4
    13  39.00000   7.47500    .00000   5.99539     .00000 123.77841   1.00000    12   13   14      4
    14  35.66667  12.45833    .00000   5.99539     .00000 123.77841   1.00000    13   14   15      4
    15  32.33334  17.44167    .00000   5.99539     .00000 123.77843   1.00000    14   15   16      4
    16  29.00000  22.42500    .00000   5.99539     .00000 123.77843   1.00000    15   16   17      4
    17  25.66667  27.40833    .00000   5.99539     .00000 123.77843   1.00000    16   17    0      4
    18  42.33334  -2.49167    .00000   5.99539     .00000-123.77841   1.00000     7   18   19      5
    19  39.00000  -7.47500    .00000   5.99539     .00000-123.77841   1.00000    18   19   20      5
    20  35.66667 -12.45833    .00000   5.99539     .00000-123.77841   1.00000    19   20   21      5
    21  32.33334 -17.44167    .00000   5.99539     .00000-123.77843   1.00000    20   21   22      5
    22  29.00000 -22.42500    .00000   5.99539     .00000-123.77843   1.00000    21   22   23      5
    23  25.66667 -27.40833    .00000   5.99539     .00000-123.77843   1.00000    22   23    0      5
    24   5.00000   2.82500    .00000   5.99354     .00000 109.49306   1.00000   -26   24   25      6
    25   3.00000   8.47500    .00000   5.99354     .00000 109.49306   1.00000    24   25    0      6
    26   5.00000  -2.82500    .00000   5.99354     .00000-109.49306   1.00000   -28   26   27      7
    27   3.00000  -8.47500    .00000   5.99354     .00000-109.49306   1.00000    26   27    0      7
    28   5.00000    .00000   2.50000   5.38516   68.19859 180.00000   1.00000     1   28   29      8
    29   3.00000    .00000   7.50000   5.38516   68.19859 180.00000   1.00000    28   29    0      8




 ***** INPUT LINE  1  FR   0    1    0    0  3.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  2  EX   1    1    1    0  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  3  RP   0    1    1 1000  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00




                                 - - - - - - FREQUENCY - - - - - -

                                    FREQUENCY= 3.0000E+00 MHZ
                                    WAVELENGTH= 9.9933E+01 METERS



                                  - - - ANTENNA ENVIRONMENT - - -

                                            FREE SPACE



                               - - - STRUCTURE IMPEDANCE LOADING - - -

                                   THIS STRUCTURE IS NOT LOADED



                                - - - MATRIX TIMING - - -

                        FILL=     .270 SEC.,  FACTOR=     .030 SEC.



                                        - - - EXCITATION - - -

    PLANE WAVE    THETA=    .00 DEG,  PHI=    .00 DEG,  ETA=    .00 DEG,  TYPE -LINEAR=  AXIAL RATIO=  .000



                             - - - CURRENTS AND LOCATION - - -

                     LENGTHS NORMALIZED BY WAVELENGTH (OR 2.*PI/CABS(K))

  SEG.  TAG    COORD. OF SEG. CENTER     SEG.            - - - CURRENT (AMPS) - - -
  NO.   NO.     X        Y        Z      LENGTH     REAL        IMAG.       MAG.        PHASE
     1    1    .0300    .0000    .0000   .06004   1.4842E-03  4.6709E-03  4.9011E-03   72.372
     2    2    .0917    .0000    .0000   .06338   3.1084E-02 -1.5877E-02  3.4904E-02  -27.057
     3    2    .1551    .0000    .0000   .06338   3.6971E-02 -3.0161E-02  4.7713E-02  -39.208
     4    2    .2185    .0000    .0000   .06338   4.3426E-02 -4.8837E-02  6.5352E-02  -48.356
     5    2    .2819    .0000    .0000   .06338   4.8697E-02 -6.6808E-02  8.2672E-02  -53.911
     6    2    .3452    .0000    .0000   .06338   5.1695E-02 -7.9951E-02  9.5208E-02  -57.114
     7    2    .4086    .0000    .0000   .06338   5.1698E-02 -8.5362E-02  9.9797E-02  -58.799
     8    3    .4703    .0000    .0000   .06004   2.1042E-01 -2.0935E-01  2.9682E-01  -44.854
     9    3    .5304    .0000    .0000   .06004   1.7974E-01 -1.7871E-01  2.5346E-01  -44.834
    10    3    .5904    .0000    .0000   .06004   1.2893E-01 -1.2752E-01  1.8134E-01  -44.686
    11    3    .6504    .0000    .0000   .06004   5.9333E-02 -5.8036E-02  8.2998E-02  -44.367
    12    4    .4236    .0249    .0000   .05999  -8.3842E-02  6.5998E-02  1.0670E-01  141.791
    13    4    .3903    .0748    .0000   .05999  -8.3937E-02  6.5582E-02  1.0652E-01  141.999
    14    4    .3569    .1247    .0000   .05999  -7.7074E-02  5.8799E-02  9.6942E-02  142.660
    15    4    .3235    .1745    .0000   .05999  -6.3325E-02  4.6370E-02  7.8487E-02  143.787
    16    4    .2902    .2244    .0000   .05999  -4.4052E-02  3.0291E-02  5.3461E-02  145.487
    17    4    .2568    .2743    .0000   .05999  -1.9735E-02  1.2375E-02  2.3294E-02  147.909
    18    5    .4236   -.0249    .0000   .05999  -8.3842E-02  6.5998E-02  1.0670E-01  141.791
    19    5    .3903   -.0748    .0000   .05999  -8.3937E-02  6.5582E-02  1.0652E-01  141.999
    20    5    .3569   -.1247    .0000   .05999  -7.7074E-02  5.8799E-02  9.6942E-02  142.660
    21    5    .3235   -.1745    .0000   .05999  -6.3325E-02  4.6370E-02  7.8487E-02  143.787
    22    5    .2902   -.2244    .0000   .05999  -4.4052E-02  3.0291E-02  5.3461E-02  145.487
    23    5    .2568   -.2743    .0000   .05999  -1.9735E-02  1.2375E-02  2.3294E-02  147.909
    24    6    .0500    .0283    .0000   .05998  -9.8533E-03  4.9660E-03  1.1034E-02  153.252
    25    6    .0300    .0848    .0000   .05998  -4.4638E-03  1.6451E-03  4.7573E-03  159.770
    26    7    .0500   -.0283    .0000   .05998  -9.8533E-03  4.9661E-03  1.1034E-02  153.252
    27    7    .0300   -.0848    .0000   .05998  -4.4639E-03  1.6451E-03  4.7573E-03  159.770
    28    8    .0500    .0000    .0250   .05389  -5.3733E-03  5.1496E-03  7.4425E-03  136.218
    29    8    .0300    .0000    .0751   .05389  -1.6005E-03  1.9454E-03  2.5192E-03  129.445



                                                - - - RADIATION PATTERNS - - -

  - - ANGLES - -         - CROSS SECTION -       - - - POLARIZATION - - -    - - - E(THETA) - - -    - - - E(PHI) - - -
  THETA     PHI        VERT.   HOR.    TOTAL      AXIAL     TILT   SENSE     MAGNITUDE    PHASE      MAGNITUDE    PHASE 
 DEGREES  DEGREES       DB      DB      DB        RATIO     DEG.               VOLTS     DEGREES       VOLTS     DEGREES
     .00      .00      -2.97 -149.62   -2.97     .00000      .00  LINEAR    2.00162E+01  -133.82    9.30926E-07    57.24






 ***** INPUT LINE  4  EX   1    1    1    0  9.00000E+01  3.00000E+01 -9.00000E+01  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  5  RP   0    1    1 1000  9.00000E+01  3.00000E+01  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00



                                        - - - EXCITATION - - -

    PLANE WAVE    THETA=  90.00 DEG,  PHI=  30.00 DEG,  ETA= -90.00 DEG,  TYPE -LINEAR=  AXIAL RATIO=  .000



                             - - - CURRENTS AND LOCATION - - -

                     LENGTHS NORMALIZED BY WAVELENGTH (OR 2.*PI/CABS(K))

  SEG.  TAG    COORD. OF SEG. CENTER     SEG.            - - - CURRENT (AMPS) - - -
  NO.   NO.     X        Y        Z      LENGTH     REAL        IMAG.       MAG.        PHASE
     1    1    .0300    .0000    .0000   .06004   2.1991E-03  3.3846E-03  4.0363E-03   56.986
     2    2    .0917    .0000    .0000   .06338   6.9361E-03  1.5006E-03  7.0966E-03   12.208
     3    2    .1551    .0000    .0000   .06338   7.7595E-03 -7.7728E-03  1.0983E-02  -45.049
     4    2    .2185    .0000    .0000   .06338   1.0122E-02 -2.1514E-02  2.3776E-02  -64.803
     5    2    .2819    .0000    .0000   .06338   1.4426E-02 -3.6488E-02  3.9236E-02  -68.428
     6    2    .3452    .0000    .0000   .06338   2.0122E-02 -4.9398E-02  5.3340E-02  -67.837
     7    2    .4086    .0000    .0000   .06338   2.5454E-02 -5.7453E-02  6.2839E-02  -66.105
     8    3    .4703    .0000    .0000   .06004  -4.0440E-02  1.5696E-01  1.6208E-01  104.448
     9    3    .5304    .0000    .0000   .06004  -2.9110E-02  1.3339E-01  1.3653E-01  102.311
    10    3    .5904    .0000    .0000   .06004  -1.5427E-02  9.5148E-02  9.6390E-02   99.209
    11    3    .6504    .0000    .0000   .06004  -4.0129E-03  4.3653E-02  4.3837E-02   95.252
    12    4    .4236    .0249    .0000   .05999  -2.3196E-02 -2.1276E-01  2.1402E-01  -96.222
    13    4    .3903    .0748    .0000   .05999  -1.5897E-02 -2.0631E-01  2.0692E-01  -94.406
    14    4    .3569    .1247    .0000   .05999  -7.4583E-03 -1.8477E-01  1.8492E-01  -92.311
    15    4    .3235    .1745    .0000   .05999   1.8008E-05 -1.4867E-01  1.4867E-01  -89.993
    16    4    .2902    .2244    .0000   .05999   4.7940E-03 -1.0131E-01  1.0143E-01  -87.291
    17    4    .2568    .2743    .0000   .05999   4.6214E-03 -4.4365E-02  4.4605E-02  -84.053
    18    5    .4236   -.0249    .0000   .05999   9.5435E-02 -9.1216E-03  9.5870E-02   -5.460
    19    5    .3903   -.0748    .0000   .05999   9.4091E-02 -1.0588E-02  9.4685E-02   -6.421
    20    5    .3569   -.1247    .0000   .05999   8.6039E-02 -8.6666E-03  8.6475E-02   -5.752
    21    5    .3235   -.1745    .0000   .05999   7.1345E-02 -4.5574E-03  7.1490E-02   -3.655
    22    5    .2902   -.2244    .0000   .05999   5.0881E-02 -3.6871E-04  5.0883E-02    -.415
    23    5    .2568   -.2743    .0000   .05999   2.3781E-02  1.4851E-03  2.3827E-02    3.573
    24    6    .0500    .0283    .0000   .05998   1.1446E-02 -3.6207E-02  3.7973E-02  -72.457
    25    6    .0300    .0848    .0000   .05998   7.1412E-03 -2.1764E-02  2.2906E-02  -71.835
    26    7    .0500   -.0283    .0000   .05998  -1.0536E-02  3.6642E-02  3.8127E-02  106.042
    27    7    .0300   -.0848    .0000   .05998  -4.9814E-03  2.0858E-02  2.1444E-02  103.432
    28    8    .0500    .0000    .0250   .05389  -4.7038E-03 -1.1080E-03  4.8325E-03 -166.745
    29    8    .0300    .0000    .0751   .05389  -2.6531E-03 -1.3391E-03  2.9719E-03 -153.218



                                                - - - RADIATION PATTERNS - - -

  - - ANGLES - -         - CROSS SECTION -       - - - POLARIZATION - - -    - - - E(THETA) - - -    - - - E(PHI) - - -
  THETA     PHI        VERT.   HOR.    TOTAL      AXIAL     TILT   SENSE     MAGNITUDE    PHASE      MAGNITUDE    PHASE 
 DEGREES  DEGREES       DB      DB      DB        RATIO     DEG.               VOLTS     DEGREES       VOLTS     DEGREES
   90.00    30.00     -51.98   -9.75   -9.75     .00083    89.56  LEFT      7.09685E-02   -58.62    9.17549E+00   -52.15






 ***** INPUT LINE  6  NX   0    0    0    0  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
1



                                ***********************************************
                                *                                             *
                                *  NUMERICAL ELECTROMAGNETICS CODE (NEC-4.1)  *
                                *                                             *
                                ***********************************************




                      **********************************************************

                         BISTATIC SCATTERING BY A SPHERE.                                              
                         PATCH DATA ARE INPUT FOR A SPHERE OF 1. M. RADIUS                             
                         THE SPHERE IS THEN SCALED SO THAT KA=FREQUENCY IN MHZ.                        
                         THE PATCH MODEL MAY BE USED FOR KA LESS THAN ABOUT 3.                         
                         FOR THIS RUN  *** KA=2.9 ***                                                  

                      **********************************************************





                                 - - - STRUCTURE SPECIFICATION - - -

                                     COORDINATES MUST BE INPUT IN
                                     METERS OR BE SCALED TO METERS
                                     BEFORE STRUCTURE INPUT IS ENDED


  WIRE                                                                               NO. OF    FIRST  LAST     TAG
  NO.        X1         Y1         Z1          X2         Y2         Z2      RADIUS   SEG.     SEG.   SEG.     NO.
     1P    .13795     .13795     .98079    78.75000   45.00000     .11957
     2P    .51328     .21261     .83147    56.25000   22.50000     .17025
     3P    .21261     .51328     .83147    56.25000   67.50000     .17025
     4P    .80314     .21520     .55557    33.75000   15.00000     .16987
     5P    .58794     .58794     .55557    33.75000   45.00000     .16987
     6P    .21520     .80314     .55557    33.75000   75.00000     .16987
     7P    .96194     .19134     .19509    11.25000   11.25000     .15028
     8P    .81549     .54490     .19509    11.25000   33.75000     .15028
     9P    .54490     .81549     .19509    11.25000   56.25000     .15028
    10P    .19134     .96194     .19509    11.25000   78.75000     .15028
      STRUCTURE REFLECTED ALONG THE AXES X Y Z.  TAGS INCREMENTED BY    0
      STRUCTURE SCALED BY FACTOR  47.71465

   TOTAL SEGMENTS USED=    0     NO. SEG. IN A SYMMETRIC CELL=    0     SYMMETRY FLAG=  2
   TOTAL PATCHES USED=   80      NO. PATCHES IN A SYMMETRIC CELL=   10
 STRUCTURE HAS 3 PLANES OF SYMMETRY





                                            - - - SURFACE PATCH DATA - - -

                                                 COORDINATES IN METERS

 PATCH     COORD. OF PATCH CENTER       UNIT NORMAL VECTOR      PATCH            COMPONENTS OF UNIT TANGENT VECTORS
  NO.      X         Y         Z         X       Y       Z       AREA       X1      Y1      Z1       X2      Y2      Z2
    1   6.58224   6.58224  46.79805    .1379   .1379   .9808 272.22357   -.7071   .7071   .0000   -.6935  -.6935   .1951
    2  24.49097  10.14461  39.67330    .5133   .2126   .8315 387.60608   -.3827   .9239   .0000   -.7682  -.3182   .5556
    3  10.14461  24.49097  39.67330    .2126   .5133   .8315 387.60608   -.9239   .3827   .0000   -.3182  -.7682   .5556
    4  38.32154  10.26819  26.50883    .8031   .2152   .5556 386.74097   -.2588   .9659   .0000   -.5366  -.1438   .8315
    5  28.05335  28.05335  26.50883    .5879   .5879   .5556 386.74097   -.7071   .7071   .0000   -.3928  -.3928   .8315
    6  10.26819  38.32154  26.50883    .2152   .8031   .5556 386.74097   -.9659   .2588   .0000   -.1438  -.5366   .8315
    7  45.89863   9.12972   9.30865    .9619   .1913   .1951 342.14062   -.1951   .9808   .0000   -.1913  -.0381   .9808
    8  38.91082  25.99971   9.30865    .8155   .5449   .1951 342.14062   -.5556   .8315   .0000   -.1622  -.1084   .9808
    9  25.99971  38.91082   9.30865    .5449   .8155   .1951 342.14062   -.8315   .5556   .0000   -.1084  -.1622   .9808
   10   9.12972  45.89863   9.30865    .1913   .9619   .1951 342.14062   -.9808   .1951   .0000   -.0381  -.1913   .9808
   11   6.58224   6.58224 -46.79805    .1379   .1379  -.9808 272.22357   -.7071   .7071   .0000   -.6935  -.6935  -.1951
   12  24.49097  10.14461 -39.67330    .5133   .2126  -.8315 387.60608   -.3827   .9239   .0000   -.7682  -.3182  -.5556
   13  10.14461  24.49097 -39.67330    .2126   .5133  -.8315 387.60608   -.9239   .3827   .0000   -.3182  -.7682  -.5556
   14  38.32154  10.26819 -26.50883    .8031   .2152  -.5556 386.74097   -.2588   .9659   .0000   -.5366  -.1438  -.8315
   15  28.05335  28.05335 -26.50883    .5879   .5879  -.5556 386.74097   -.7071   .7071   .0000   -.3928  -.3928  -.8315
   16  10.26819  38.32154 -26.50883    .2152   .8031  -.5556 386.74097   -.9659   .2588   .0000   -.1438  -.5366  -.8315
   17  45.89863   9.12972  -9.30865    .9619   .1913  -.1951 342.14062   -.1951   .9808   .0000   -.1913  -.0381  -.9808
   18  38.91082  25.99971  -9.30865    .8155   .5449  -.1951 342.14062   -.5556   .8315   .0000   -.1622  -.1084  -.9808
   19  25.99971  38.91082  -9.30865    .5449   .8155  -.1951 342.14062   -.8315   .5556   .0000   -.1084  -.1622  -.9808
   20   9.12972  45.89863  -9.30865    .1913   .9619  -.1951 342.14062   -.9808   .1951   .0000   -.0381  -.1913  -.9808
   21   6.58224  -6.58224  46.79805    .1379  -.1379   .9808 272.22357   -.7071  -.7071   .0000   -.6935   .6935   .1951
   22  24.49097 -10.14461  39.67330    .5133  -.2126   .8315 387.60608   -.3827  -.9239   .0000   -.7682   .3182   .5556
   23  10.14461 -24.49097  39.67330    .2126  -.5133   .8315 387.60608   -.9239  -.3827   .0000   -.3182   .7682   .5556
   24  38.32154 -10.26819  26.50883    .8031  -.2152   .5556 386.74097   -.2588  -.9659   .0000   -.5366   .1438   .8315
   25  28.05335 -28.05335  26.50883    .5879  -.5879   .5556 386.74097   -.7071  -.7071   .0000   -.3928   .3928   .8315
   26  10.26819 -38.32154  26.50883    .2152  -.8031   .5556 386.74097   -.9659  -.2588   .0000   -.1438   .5366   .8315
   27  45.89863  -9.12972   9.30865    .9619  -.1913   .1951 342.14062   -.1951  -.9808   .0000   -.1913   .0381   .9808
   28  38.91082 -25.99971   9.30865    .8155  -.5449   .1951 342.14062   -.5556  -.8315   .0000   -.1622   .1084   .9808
   29  25.99971 -38.91082   9.30865    .5449  -.8155   .1951 342.14062   -.8315  -.5556   .0000   -.1084   .1622   .9808
   30   9.12972 -45.89863   9.30865    .1913  -.9619   .1951 342.14062   -.9808  -.1951   .0000   -.0381   .1913   .9808
   31   6.58224  -6.58224 -46.79805    .1379  -.1379  -.9808 272.22357   -.7071  -.7071   .0000   -.6935   .6935  -.1951
   32  24.49097 -10.14461 -39.67330    .5133  -.2126  -.8315 387.60608   -.3827  -.9239   .0000   -.7682   .3182  -.5556
   33  10.14461 -24.49097 -39.67330    .2126  -.5133  -.8315 387.60608   -.9239  -.3827   .0000   -.3182   .7682  -.5556
   34  38.32154 -10.26819 -26.50883    .8031  -.2152  -.5556 386.74097   -.2588  -.9659   .0000   -.5366   .1438  -.8315
   35  28.05335 -28.05335 -26.50883    .5879  -.5879  -.5556 386.74097   -.7071  -.7071   .0000   -.3928   .3928  -.8315
   36  10.26819 -38.32154 -26.50883    .2152  -.8031  -.5556 386.74097   -.9659  -.2588   .0000   -.1438   .5366  -.8315
   37  45.89863  -9.12972  -9.30865    .9619  -.1913  -.1951 342.14062   -.1951  -.9808   .0000   -.1913   .0381  -.9808
   38  38.91082 -25.99971  -9.30865    .8155  -.5449  -.1951 342.14062   -.5556  -.8315   .0000   -.1622   .1084  -.9808
   39  25.99971 -38.91082  -9.30865    .5449  -.8155  -.1951 342.14062   -.8315  -.5556   .0000   -.1084   .1622  -.9808
   40   9.12972 -45.89863  -9.30865    .1913  -.9619  -.1951 342.14062   -.9808  -.1951   .0000   -.0381   .1913  -.9808
   41  -6.58224   6.58224  46.79805   -.1379   .1379   .9808 272.22357    .7071   .7071   .0000    .6935  -.6935   .1951
   42 -24.49097  10.14461  39.67330   -.5133   .2126   .8315 387.60608    .3827   .9239   .0000    .7682  -.3182   .5556
   43 -10.14461  24.49097  39.67330   -.2126   .5133   .8315 387.60608    .9239   .3827   .0000    .3182  -.7682   .5556
   44 -38.32154  10.26819  26.50883   -.8031   .2152   .5556 386.74097    .2588   .9659   .0000    .5366  -.1438   .8315
   45 -28.05335  28.05335  26.50883   -.5879   .5879   .5556 386.74097    .7071   .7071   .0000    .3928  -.3928   .8315
   46 -10.26819  38.32154  26.50883   -.2152   .8031   .5556 386.74097    .9659   .2588   .0000    .1438  -.5366   .8315
   47 -45.89863   9.12972   9.30865   -.9619   .1913   .1951 342.14062    .1951   .9808   .0000    .1913  -.0381   .9808
   48 -38.91082  25.99971   9.30865   -.8155   .5449   .1951 342.14062    .5556   .8315   .0000    .1622  -.1084   .9808
   49 -25.99971  38.91082   9.30865   -.5449   .8155   .1951 342.14062    .8315   .5556   .0000    .1084  -.1622   .9808
   50  -9.12972  45.89863   9.30865   -.1913   .9619   .1951 342.14062    .9808   .1951   .0000    .0381  -.1913   .9808
   51  -6.58224   6.58224 -46.79805   -.1379   .1379  -.9808 272.22357    .7071   .7071   .0000    .6935  -.6935  -.1951
   52 -24.49097  10.14461 -39.67330   -.5133   .2126  -.8315 387.60608    .3827   .9239   .0000    .7682  -.3182  -.5556
   53 -10.14461  24.49097 -39.67330   -.2126   .5133  -.8315 387.60608    .9239   .3827   .0000    .3182  -.7682  -.5556
   54 -38.32154  10.26819 -26.50883   -.8031   .2152  -.5556 386.74097    .2588   .9659   .0000    .5366  -.1438  -.8315
   55 -28.05335  28.05335 -26.50883   -.5879   .5879  -.5556 386.74097    .7071   .7071   .0000    .3928  -.3928  -.8315
   56 -10.26819  38.32154 -26.50883   -.2152   .8031  -.5556 386.74097    .9659   .2588   .0000    .1438  -.5366  -.8315
   57 -45.89863   9.12972  -9.30865   -.9619   .1913  -.1951 342.14062    .1951   .9808   .0000    .1913  -.0381  -.9808
   58 -38.91082  25.99971  -9.30865   -.8155   .5449  -.1951 342.14062    .5556   .8315   .0000    .1622  -.1084  -.9808
   59 -25.99971  38.91082  -9.30865   -.5449   .8155  -.1951 342.14062    .8315   .5556   .0000    .1084  -.1622  -.9808
   60  -9.12972  45.89863  -9.30865   -.1913   .9619  -.1951 342.14062    .9808   .1951   .0000    .0381  -.1913  -.9808
   61  -6.58224  -6.58224  46.79805   -.1379  -.1379   .9808 272.22357    .7071  -.7071   .0000    .6935   .6935   .1951
   62 -24.49097 -10.14461  39.67330   -.5133  -.2126   .8315 387.60608    .3827  -.9239   .0000    .7682   .3182   .5556
   63 -10.14461 -24.49097  39.67330   -.2126  -.5133   .8315 387.60608    .9239  -.3827   .0000    .3182   .7682   .5556
   64 -38.32154 -10.26819  26.50883   -.8031  -.2152   .5556 386.74097    .2588  -.9659   .0000    .5366   .1438   .8315
   65 -28.05335 -28.05335  26.50883   -.5879  -.5879   .5556 386.74097    .7071  -.7071   .0000    .3928   .3928   .8315
   66 -10.26819 -38.32154  26.50883   -.2152  -.8031   .5556 386.74097    .9659  -.2588   .0000    .1438   .5366   .8315
   67 -45.89863  -9.12972   9.30865   -.9619  -.1913   .1951 342.14062    .1951  -.9808   .0000    .1913   .0381   .9808
   68 -38.91082 -25.99971   9.30865   -.8155  -.5449   .1951 342.14062    .5556  -.8315   .0000    .1622   .1084   .9808
   69 -25.99971 -38.91082   9.30865   -.5449  -.8155   .1951 342.14062    .8315  -.5556   .0000    .1084   .1622   .9808
   70  -9.12972 -45.89863   9.30865   -.1913  -.9619   .1951 342.14062    .9808  -.1951   .0000    .0381   .1913   .9808
   71  -6.58224  -6.58224 -46.79805   -.1379  -.1379  -.9808 272.22357    .7071  -.7071   .0000    .6935   .6935  -.1951
   72 -24.49097 -10.14461 -39.67330   -.5133  -.2126  -.8315 387.60608    .3827  -.9239   .0000    .7682   .3182  -.5556
   73 -10.14461 -24.49097 -39.67330   -.2126  -.5133  -.8315 387.60608    .9239  -.3827   .0000    .3182   .7682  -.5556
   74 -38.32154 -10.26819 -26.50883   -.8031  -.2152  -.5556 386.74097    .2588  -.9659   .0000    .5366   .1438  -.8315
   75 -28.05335 -28.05335 -26.50883   -.5879  -.5879  -.5556 386.74097    .7071  -.7071   .0000    .3928   .3928  -.8315
   76 -10.26819 -38.32154 -26.50883   -.2152  -.8031  -.5556 386.74097    .9659  -.2588   .0000    .1438   .5366  -.8315
   77 -45.89863  -9.12972  -9.30865   -.9619  -.1913  -.1951 342.14062    .1951  -.9808   .0000    .1913   .0381  -.9808
   78 -38.91082 -25.99971  -9.30865   -.8155  -.5449  -.1951 342.14062    .5556  -.8315   .0000    .1622   .1084  -.9808
   79 -25.99971 -38.91082  -9.30865   -.5449  -.8155  -.1951 342.14062    .8315  -.5556   .0000    .1084   .1622  -.9808
   80  -9.12972 -45.89863  -9.30865   -.1913  -.9619  -.1951 342.14062    .9808  -.1951   .0000    .0381   .1913  -.9808




 ***** INPUT LINE  1  FR   0    1    0    0  2.90000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  2  EX   1    1    1    0  9.00000E+01  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  3  RP   0   19    1 1000  9.00000E+01  0.00000E+00 -1.00000E+01  0.00000E+00  0.00000E+00  0.00000E+00




                                 - - - - - - FREQUENCY - - - - - -

                                    FREQUENCY= 2.9000E+00 MHZ
                                    WAVELENGTH= 1.0338E+02 METERS



                                  - - - ANTENNA ENVIRONMENT - - -

                                            FREE SPACE



                               - - - STRUCTURE IMPEDANCE LOADING - - -

                                   THIS STRUCTURE IS NOT LOADED



                                - - - MATRIX TIMING - - -

                        FILL=     .110 SEC.,  FACTOR=     .070 SEC.



                                        - - - EXCITATION - - -

    PLANE WAVE    THETA=  90.00 DEG,  PHI=    .00 DEG,  ETA=    .00 DEG,  TYPE -LINEAR=  AXIAL RATIO=  .000




                                         - - - - SURFACE PATCH CURRENTS - - - -

                                                  DISTANCES IN WAVELENGTHS (2.*PI/CABS(K))
                                                  CURRENT IN AMPS/METER

                            - - SURFACE COMPONENTS - -                   - - - RECTANGULAR COMPONENTS - - -
      PATCH CENTER      TANGENT VECTOR 1   TANGENT VECTOR 2           X                   Y                   Z
     X      Y      Z     MAG.       PHASE   MAG.       PHASE    REAL      IMAG.     REAL      IMAG.     REAL      IMAG. 
    1
    .064   .064   .453 2.8794E-03 -156.32 3.1198E-03 -157.39  3.86E-03  1.65E-03  1.33E-04  1.42E-05 -5.62E-04 -2.34E-04
    2
    .237   .098   .384 1.4256E-03  -91.29 4.7156E-03  -94.79  3.15E-04  4.16E-03  9.57E-05  1.79E-04 -2.19E-04 -2.61E-03
    3
    .098   .237   .384 3.2575E-03 -142.94 2.3664E-03 -147.56  3.04E-03  2.22E-03  5.39E-04  2.24E-04 -1.11E-03 -7.05E-04
    4
    .371   .099   .256 6.0841E-04  -43.12 4.9604E-03  -45.55 -1.98E-03  2.01E-03 -7.05E-05  1.07E-04  2.89E-03 -2.94E-03
    5
    .271   .271   .256 1.7787E-03  -79.48 3.9145E-03  -84.57 -3.75E-04  2.77E-03  8.40E-05  2.94E-04  3.08E-04 -3.24E-03
    6
    .099   .371   .256 2.2829E-03 -142.59 2.2575E-03 -151.48  2.04E-03  1.49E-03  5.95E-04  2.19E-04 -1.65E-03 -8.96E-04
    7
    .444   .088   .090 1.4688E-04  -14.13 5.2457E-03  -16.94 -9.88E-04  3.00E-04 -5.13E-05  2.30E-05  4.92E-03 -1.50E-03
    8
    .376   .251   .090 4.6333E-04  -40.19 4.4776E-03  -43.42 -7.24E-04  6.65E-04 -5.82E-05  8.50E-05  3.19E-03 -3.02E-03
    9
    .251   .376   .090 7.4095E-04  -85.74 3.3811E-03  -94.45 -1.74E-05  9.80E-04  7.32E-05  1.36E-04 -2.57E-04 -3.31E-03
   10
    .088   .444   .090 8.0344E-04 -147.10 2.2400E-03 -157.22  7.40E-04  4.61E-04  2.64E-04  8.08E-05 -2.03E-03 -8.51E-04
   11
    .064   .064  -.453 2.8794E-03   23.68 3.1198E-03   22.61 -3.86E-03 -1.65E-03 -1.33E-04 -1.42E-05 -5.62E-04 -2.34E-04
   12
    .237   .098  -.384 1.4256E-03   88.71 4.7156E-03   85.21 -3.15E-04 -4.16E-03 -9.57E-05 -1.79E-04 -2.19E-04 -2.61E-03
   13
    .098   .237  -.384 3.2575E-03   37.06 2.3664E-03   32.44 -3.04E-03 -2.22E-03 -5.39E-04 -2.24E-04 -1.11E-03 -7.05E-04
   14
    .371   .099  -.256 6.0841E-04  136.88 4.9604E-03  134.45  1.98E-03 -2.01E-03  7.05E-05 -1.07E-04  2.89E-03 -2.94E-03
   15
    .271   .271  -.256 1.7787E-03  100.52 3.9145E-03   95.43  3.75E-04 -2.77E-03 -8.40E-05 -2.94E-04  3.08E-04 -3.24E-03
   16
    .099   .371  -.256 2.2829E-03   37.41 2.2575E-03   28.52 -2.04E-03 -1.49E-03 -5.95E-04 -2.19E-04 -1.65E-03 -8.96E-04
   17
    .444   .088  -.090 1.4688E-04  165.87 5.2457E-03  163.06  9.88E-04 -3.00E-04  5.13E-05 -2.30E-05  4.92E-03 -1.50E-03
   18
    .376   .251  -.090 4.6333E-04  139.81 4.4776E-03  136.58  7.24E-04 -6.65E-04  5.82E-05 -8.50E-05  3.19E-03 -3.02E-03
   19
    .251   .376  -.090 7.4095E-04   94.26 3.3811E-03   85.55  1.74E-05 -9.80E-04 -7.32E-05 -1.36E-04 -2.57E-04 -3.31E-03
   20
    .088   .444  -.090 8.0344E-04   32.90 2.2400E-03   22.78 -7.40E-04 -4.61E-04 -2.64E-04 -8.08E-05 -2.03E-03 -8.51E-04
   21
    .064  -.064   .453 2.8794E-03 -156.32 3.1198E-03 -157.39  3.86E-03  1.65E-03 -1.33E-04 -1.42E-05 -5.62E-04 -2.34E-04
   22
    .237  -.098   .384 1.4256E-03  -91.29 4.7156E-03  -94.79  3.15E-04  4.16E-03 -9.57E-05 -1.79E-04 -2.19E-04 -2.61E-03
   23
    .098  -.237   .384 3.2575E-03 -142.94 2.3664E-03 -147.56  3.04E-03  2.22E-03 -5.39E-04 -2.24E-04 -1.11E-03 -7.05E-04
   24
    .371  -.099   .256 6.0841E-04  -43.12 4.9604E-03  -45.55 -1.98E-03  2.01E-03  7.05E-05 -1.07E-04  2.89E-03 -2.94E-03
   25
    .271  -.271   .256 1.7787E-03  -79.48 3.9145E-03  -84.57 -3.75E-04  2.77E-03 -8.40E-05 -2.94E-04  3.08E-04 -3.24E-03
   26
    .099  -.371   .256 2.2829E-03 -142.59 2.2575E-03 -151.48  2.04E-03  1.49E-03 -5.95E-04 -2.19E-04 -1.65E-03 -8.96E-04
   27
    .444  -.088   .090 1.4688E-04  -14.13 5.2457E-03  -16.94 -9.88E-04  3.00E-04  5.13E-05 -2.30E-05  4.92E-03 -1.50E-03
   28
    .376  -.251   .090 4.6333E-04  -40.19 4.4776E-03  -43.42 -7.24E-04  6.65E-04  5.82E-05 -8.50E-05  3.19E-03 -3.02E-03
   29
    .251  -.376   .090 7.4095E-04  -85.74 3.3811E-03  -94.45 -1.74E-05  9.80E-04 -7.32E-05 -1.36E-04 -2.57E-04 -3.31E-03
   30
    .088  -.444   .090 8.0344E-04 -147.10 2.2400E-03 -157.22  7.40E-04  4.61E-04 -2.64E-04 -8.08E-05 -2.03E-03 -8.51E-04
   31
    .064  -.064  -.453 2.8794E-03   23.68 3.1198E-03   22.61 -3.86E-03 -1.65E-03  1.33E-04  1.42E-05 -5.62E-04 -2.34E-04
   32
    .237  -.098  -.384 1.4256E-03   88.71 4.7156E-03   85.21 -3.15E-04 -4.16E-03  9.57E-05  1.79E-04 -2.19E-04 -2.61E-03
   33
    .098  -.237  -.384 3.2575E-03   37.06 2.3664E-03   32.44 -3.04E-03 -2.22E-03  5.39E-04  2.24E-04 -1.11E-03 -7.05E-04
   34
    .371  -.099  -.256 6.0841E-04  136.88 4.9604E-03  134.45  1.98E-03 -2.01E-03 -7.05E-05  1.07E-04  2.89E-03 -2.94E-03
   35
    .271  -.271  -.256 1.7787E-03  100.52 3.9145E-03   95.43  3.75E-04 -2.77E-03  8.40E-05  2.94E-04  3.08E-04 -3.24E-03
   36
    .099  -.371  -.256 2.2829E-03   37.41 2.2575E-03   28.52 -2.04E-03 -1.49E-03  5.95E-04  2.19E-04 -1.65E-03 -8.96E-04
   37
    .444  -.088  -.090 1.4688E-04  165.87 5.2457E-03  163.06  9.88E-04 -3.00E-04 -5.13E-05  2.30E-05  4.92E-03 -1.50E-03
   38
    .376  -.251  -.090 4.6333E-04  139.81 4.4776E-03  136.58  7.24E-04 -6.65E-04 -5.82E-05  8.50E-05  3.19E-03 -3.02E-03
   39
    .251  -.376  -.090 7.4095E-04   94.26 3.3811E-03   85.55  1.74E-05 -9.80E-04  7.32E-05  1.36E-04 -2.57E-04 -3.31E-03
   40
    .088  -.444  -.090 8.0344E-04   32.90 2.2400E-03   22.78 -7.40E-04 -4.61E-04  2.64E-04  8.08E-05 -2.03E-03 -8.51E-04
   41
   -.064   .064   .453 2.9135E-03  -36.76 2.5234E-03  -37.39  3.04E-03 -2.30E-03  2.60E-04 -1.70E-04  3.91E-04 -2.99E-04
   42
   -.237   .098   .384 1.9524E-03 -104.63 3.6573E-03 -105.39 -9.35E-04 -3.43E-03 -1.47E-04 -6.23E-04 -5.39E-04 -1.96E-03
   43
   -.098   .237   .384 3.3932E-03  -51.87 6.3674E-04  -60.16  2.04E-03 -2.64E-03  5.58E-04 -5.97E-04  1.76E-04 -3.07E-04
   44
   -.371   .099   .256 1.1507E-03 -138.16 1.8444E-03 -164.01 -1.17E-03 -4.71E-04 -5.73E-04 -6.68E-04 -1.47E-03 -4.23E-04
   45
   -.271   .271   .256 2.6220E-03 -114.23 1.0836E-03 -121.84 -9.85E-04 -2.05E-03 -5.36E-04 -1.33E-03 -4.75E-04 -7.65E-04
   46
   -.099   .371   .256 2.3854E-03  -52.80 4.0244E-04  137.80  1.35E-03 -1.80E-03  5.33E-04 -6.37E-04 -2.48E-04  2.25E-04
   47
   -.444   .088   .090 3.3208E-04 -151.23 2.5093E-03   82.36  7.06E-06  4.45E-04 -2.98E-04 -2.51E-04  3.27E-04  2.44E-03
   48
   -.376   .251   .090 8.6498E-04 -139.37 1.2097E-03   94.55 -3.80E-04 -1.17E-04 -5.35E-04 -5.99E-04 -9.42E-05  1.18E-03
   49
   -.251   .376   .090 1.0285E-03 -108.70 3.1884E-04   82.46 -2.70E-04 -7.76E-04 -1.90E-04 -5.93E-04  4.10E-05  3.10E-04
   50
   -.088   .444   .090 8.2755E-04  -48.33 9.1957E-04  137.33  5.14E-04 -5.83E-04  2.37E-04 -2.40E-04 -6.63E-04  6.11E-04
   51
   -.064   .064  -.453 2.9135E-03  143.24 2.5234E-03  142.61 -3.04E-03  2.30E-03 -2.60E-04  1.70E-04  3.91E-04 -2.99E-04
   52
   -.237   .098  -.384 1.9524E-03   75.37 3.6573E-03   74.61  9.35E-04  3.43E-03  1.47E-04  6.23E-04 -5.39E-04 -1.96E-03
   53
   -.098   .237  -.384 3.3932E-03  128.13 6.3674E-04  119.84 -2.04E-03  2.64E-03 -5.58E-04  5.97E-04  1.76E-04 -3.07E-04
   54
   -.371   .099  -.256 1.1507E-03   41.84 1.8444E-03   15.99  1.17E-03  4.71E-04  5.73E-04  6.68E-04 -1.47E-03 -4.23E-04
   55
   -.271   .271  -.256 2.6220E-03   65.77 1.0836E-03   58.16  9.85E-04  2.05E-03  5.36E-04  1.33E-03 -4.75E-04 -7.65E-04
   56
   -.099   .371  -.256 2.3854E-03  127.20 4.0244E-04  -42.20 -1.35E-03  1.80E-03 -5.33E-04  6.37E-04 -2.48E-04  2.25E-04
   57
   -.444   .088  -.090 3.3208E-04   28.77 2.5093E-03  -97.64 -7.06E-06 -4.45E-04  2.98E-04  2.51E-04  3.27E-04  2.44E-03
   58
   -.376   .251  -.090 8.6498E-04   40.63 1.2097E-03  -85.45  3.80E-04  1.17E-04  5.35E-04  5.99E-04 -9.42E-05  1.18E-03
   59
   -.251   .376  -.090 1.0285E-03   71.30 3.1884E-04  -97.54  2.70E-04  7.76E-04  1.90E-04  5.93E-04  4.10E-05  3.10E-04
   60
   -.088   .444  -.090 8.2755E-04  131.67 9.1957E-04  -42.67 -5.14E-04  5.83E-04 -2.37E-04  2.40E-04 -6.63E-04  6.11E-04
   61
   -.064  -.064   .453 2.9135E-03  -36.76 2.5234E-03  -37.39  3.04E-03 -2.30E-03 -2.60E-04  1.70E-04  3.91E-04 -2.99E-04
   62
   -.237  -.098   .384 1.9524E-03 -104.63 3.6573E-03 -105.39 -9.35E-04 -3.43E-03  1.47E-04  6.23E-04 -5.39E-04 -1.96E-03
   63
   -.098  -.237   .384 3.3932E-03  -51.87 6.3674E-04  -60.16  2.04E-03 -2.64E-03 -5.58E-04  5.97E-04  1.76E-04 -3.07E-04
   64
   -.371  -.099   .256 1.1507E-03 -138.16 1.8444E-03 -164.01 -1.17E-03 -4.71E-04  5.73E-04  6.68E-04 -1.47E-03 -4.23E-04
   65
   -.271  -.271   .256 2.6220E-03 -114.23 1.0836E-03 -121.84 -9.85E-04 -2.05E-03  5.36E-04  1.33E-03 -4.75E-04 -7.65E-04
   66
   -.099  -.371   .256 2.3854E-03  -52.80 4.0244E-04  137.80  1.35E-03 -1.80E-03 -5.33E-04  6.37E-04 -2.48E-04  2.25E-04
   67
   -.444  -.088   .090 3.3208E-04 -151.23 2.5093E-03   82.36  7.06E-06  4.45E-04  2.98E-04  2.51E-04  3.27E-04  2.44E-03
   68
   -.376  -.251   .090 8.6498E-04 -139.37 1.2097E-03   94.55 -3.80E-04 -1.17E-04  5.35E-04  5.99E-04 -9.42E-05  1.18E-03
   69
   -.251  -.376   .090 1.0285E-03 -108.70 3.1884E-04   82.46 -2.70E-04 -7.76E-04  1.90E-04  5.93E-04  4.10E-05  3.10E-04
   70
   -.088  -.444   .090 8.2755E-04  -48.33 9.1957E-04  137.33  5.14E-04 -5.83E-04 -2.37E-04  2.40E-04 -6.63E-04  6.11E-04
   71
   -.064  -.064  -.453 2.9135E-03  143.24 2.5234E-03  142.61 -3.04E-03  2.30E-03  2.60E-04 -1.70E-04  3.91E-04 -2.99E-04
   72
   -.237  -.098  -.384 1.9524E-03   75.37 3.6573E-03   74.61  9.35E-04  3.43E-03 -1.47E-04 -6.23E-04 -5.39E-04 -1.96E-03
   73
   -.098  -.237  -.384 3.3932E-03  128.13 6.3674E-04  119.84 -2.04E-03  2.64E-03  5.58E-04 -5.97E-04  1.76E-04 -3.07E-04
   74
   -.371  -.099  -.256 1.1507E-03   41.84 1.8444E-03   15.99  1.17E-03  4.71E-04 -5.73E-04 -6.68E-04 -1.47E-03 -4.23E-04
   75
   -.271  -.271  -.256 2.6220E-03   65.77 1.0836E-03   58.16  9.85E-04  2.05E-03 -5.36E-04 -1.33E-03 -4.75E-04 -7.65E-04
   76
   -.099  -.371  -.256 2.3854E-03  127.20 4.0244E-04  -42.20 -1.35E-03  1.80E-03  5.33E-04 -6.37E-04 -2.48E-04  2.25E-04
   77
   -.444  -.088  -.090 3.3208E-04   28.77 2.5093E-03  -97.64 -7.06E-06 -4.45E-04 -2.98E-04 -2.51E-04  3.27E-04  2.44E-03
   78
   -.376  -.251  -.090 8.6498E-04   40.63 1.2097E-03  -85.45  3.80E-04  1.17E-04 -5.35E-04 -5.99E-04 -9.42E-05  1.18E-03
   79
   -.251  -.376  -.090 1.0285E-03   71.30 3.1884E-04  -97.54  2.70E-04  7.76E-04 -1.90E-04 -5.93E-04  4.10E-05  3.10E-04
   80
   -.088  -.444  -.090 8.2755E-04  131.67 9.1957E-04  -42.67 -5.14E-04  5.83E-04  2.37E-04 -2.40E-04 -6.63E-04  6.11E-04



                                                - - - RADIATION PATTERNS - - -

  - - ANGLES - -         - CROSS SECTION -       - - - POLARIZATION - - -    - - - E(THETA) - - -    - - - E(PHI) - - -
  THETA     PHI        VERT.   HOR.    TOTAL      AXIAL     TILT   SENSE     MAGNITUDE    PHASE      MAGNITUDE    PHASE 
 DEGREES  DEGREES       DB      DB      DB        RATIO     DEG.               VOLTS     DEGREES       VOLTS     DEGREES
   90.00      .00      -4.44 -164.42   -4.44     .00000      .00  LINEAR    1.74852E+01   163.80    1.75233E-07  -128.04
   80.00      .00      -4.04 -161.28   -4.04     .00000      .00  LINEAR    1.83237E+01   161.67    2.51716E-07   -46.67
   70.00      .00      -2.96 -158.18   -2.96     .00000      .00  LINEAR    2.07471E+01   156.86    3.59742E-07   117.44
   60.00      .00      -1.61 -152.13   -1.61     .00000      .00  LINEAR    2.42167E+01   152.14    7.21283E-07  -175.05
   50.00      .00       -.50 -161.69    -.50     .00000      .00  LINEAR    2.75240E+01   148.81    2.40046E-07  -164.66
   40.00      .00       -.03 -155.06    -.03     .00000      .00  LINEAR    2.90492E+01   146.61    5.14922E-07  -104.09
   30.00      .00       -.59 -171.52    -.59     .00000      .00  LINEAR    2.72599E+01   144.38    7.74140E-08    -4.85
   20.00      .00      -2.73 -156.04   -2.73     .00000      .00  LINEAR    2.13035E+01   139.32    4.59884E-07  -151.97
   10.00      .00      -7.57 -151.81   -7.57     .00000      .00  LINEAR    1.22053E+01   118.96    7.48818E-07   -93.48
     .00      .00      -8.64 -155.43   -8.64     .00000      .00  LINEAR    1.07892E+01    44.17    4.93353E-07    76.49
  -10.00      .00      -1.91 -158.02   -1.91     .00000      .00  LINEAR    2.34179E+01    14.76    3.66260E-07    98.43
  -20.00      .00       1.94 -164.06    1.94     .00000      .00  LINEAR    3.64467E+01    11.84    1.82810E-07   -66.18
  -30.00      .00       3.84 -148.04    3.84     .00000      .00  LINEAR    4.53563E+01    16.56    1.15550E-06    13.77
  -40.00      .00       4.51 -146.82    4.51     .00000      .00  LINEAR    4.89894E+01    27.10    1.33013E-06   -18.43
  -50.00      .00       4.62 -147.42    4.62     .00000      .00  LINEAR    4.96673E+01    44.18    1.24185E-06     -.34
  -60.00      .00       5.12 -147.65    5.12     .00000      .00  LINEAR    5.25643E+01    65.77    1.20836E-06    62.20
  -70.00      .00       6.29 -157.78    6.29     .00000      .00  LINEAR    6.01727E+01    84.51    3.76596E-07  -154.60
  -80.00      .00       7.42 -170.52    7.42     .00000      .00  LINEAR    6.85140E+01    95.53    8.69089E-08    69.75
  -90.00      .00       7.86 -159.82    7.86     .00000      .00  LINEAR    7.20509E+01    99.00    2.97665E-07    95.43






 ***** INPUT LINE  4  RP   0    1   19 1000  9.00000E+01  0.00000E+00  0.00000E+00  1.00000E+01  0.00000E+00  0.00000E+00



                                                - - - RADIATION PATTERNS - - -

  - - ANGLES - -         - CROSS SECTION -       - - - POLARIZATION - - -    - - - E(THETA) - - -    - - - E(PHI) - - -
  THETA     PHI        VERT.   HOR.    TOTAL      AXIAL     TILT   SENSE     MAGNITUDE    PHASE      MAGNITUDE    PHASE 
 DEGREES  DEGREES       DB      DB      DB        RATIO     DEG.               VOLTS     DEGREES       VOLTS     DEGREES
   90.00      .00      -4.44 -164.42   -4.44     .00000      .00  LINEAR    1.74852E+01   163.80    1.75233E-07  -128.04
   90.00    10.00      -4.28 -148.00   -4.28     .00000      .00  LINEAR    1.78240E+01   161.73    1.16050E-06   -71.79
   90.00    20.00      -3.79 -147.60   -3.79     .00000      .00  LINEAR    1.88459E+01   156.08    1.21541E-06   -69.60
   90.00    30.00      -3.06 -146.93   -3.06     .00000      .00  LINEAR    2.04929E+01   148.15    1.31351E-06   -62.22
   90.00    40.00      -2.25 -143.30   -2.25     .00000      .00  LINEAR    2.25127E+01   139.17    1.99353E-06   -62.76
   90.00    50.00      -1.54 -150.25   -1.54     .00000      .00  LINEAR    2.44308E+01   129.63    8.96418E-07   -51.25
   90.00    60.00      -1.11 -151.56   -1.11     .00000      .00  LINEAR    2.56763E+01   119.17    7.70193E-07    66.05
   90.00    70.00      -1.05 -148.49   -1.05     .00000      .00  LINEAR    2.58334E+01   106.70    1.09793E-06  -179.55
   90.00    80.00      -1.34 -153.99   -1.34     .00000      .00  LINEAR    2.49858E+01    90.48    5.82753E-07    32.71
   90.00    90.00      -1.67 -141.21   -1.67     .00000      .00  LINEAR    2.40598E+01    68.79    2.53596E-06    14.62
   90.00   100.00      -1.45 -139.78   -1.45     .00000      .00  LINEAR    2.46845E+01    42.25    2.99004E-06    30.13
   90.00   110.00       -.38 -135.16    -.38     .00000      .00  LINEAR    2.79070E+01    15.31    5.09337E-06   -18.52
   90.00   120.00       1.14 -132.27    1.14     .00000      .00  LINEAR    3.32413E+01    -8.45    7.10100E-06    14.80
   90.00   130.00       2.70 -128.71    2.70     .00000      .00  LINEAR    3.97937E+01   -28.99    1.06970E-05    -4.05
   90.00   140.00       4.20 -129.39    4.20     .00000      .00  LINEAR    4.72787E+01   -46.85    9.89101E-06    -5.70
   90.00   150.00       5.60 -129.75    5.60     .00000      .00  LINEAR    5.55509E+01   -61.58    9.48639E-06     1.36
   90.00   160.00       6.78 -132.35    6.78     .00000      .00  LINEAR    6.36601E+01   -72.39    7.03998E-06     6.03
   90.00   170.00       7.58 -136.73    7.58     .00000      .00  LINEAR    6.97659E+01   -78.86    4.25009E-06    -1.58
   90.00   180.00       7.86 -160.24    7.86     .00000      .00  LINEAR    7.20509E+01   -81.00    2.83605E-07   -84.73






 ***** INPUT LINE  5  NE   0    1    1   11  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  5.00000E+00



                                      - - - NEAR ELECTRIC FIELDS - - -

              -  LOCATION  -                     -  EX  -               -  EY  -               -  EZ  -
        X           Y           Z           MAGNITUDE   PHASE      MAGNITUDE   PHASE      MAGNITUDE   PHASE
      METERS      METERS      METERS         VOLTS/M   DEGREES      VOLTS/M   DEGREES      VOLTS/M   DEGREES
         .0000       .0000       .0000     4.2897E-08   -27.02    8.1716E-09  -168.75    9.9619E-01      .03
         .0000       .0000      5.0000     2.4040E-02    79.71    6.5470E-09  -178.29    9.9612E-01      .04
         .0000       .0000     10.0000     4.6950E-02    79.76    6.7465E-09    50.90    9.9585E-01      .04
         .0000       .0000     15.0000     6.7923E-02    79.85    5.7676E-09  -162.40    9.9523E-01      .06
         .0000       .0000     20.0000     8.7167E-02    80.01    1.3235E-08   -34.07    9.9357E-01      .10
         .0000       .0000     25.0000     1.0747E-01    80.30    7.4691E-09  -108.14    9.8943E-01      .20
         .0000       .0000     30.0000     1.3472E-01    80.92    3.4696E-08    91.72    9.8671E-01      .29
         .0000       .0000     35.0000     1.5167E-01    81.47    2.7707E-08    46.79    1.0307E+00     -.45
         .0000       .0000     40.0000     1.0076E-01   -87.91    6.5494E-08    95.26    1.2282E+00    -3.24
         .0000       .0000     45.0000     1.2887E+00   -93.79    5.4447E-08   105.01    9.2209E-01     1.86
         .0000       .0000     50.0000     1.2772E+00   -95.81    1.0082E-08  -121.21    7.4353E-01   137.47




 ***** INPUT LINE  6  NE   0    1   11    1  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  5.00000E+00  0.00000E+00



                                      - - - NEAR ELECTRIC FIELDS - - -

              -  LOCATION  -                     -  EX  -               -  EY  -               -  EZ  -
        X           Y           Z           MAGNITUDE   PHASE      MAGNITUDE   PHASE      MAGNITUDE   PHASE
      METERS      METERS      METERS         VOLTS/M   DEGREES      VOLTS/M   DEGREES      VOLTS/M   DEGREES
         .0000       .0000       .0000     4.2897E-08   -27.02    8.1716E-09  -168.75    9.9619E-01      .03
         .0000      5.0000       .0000     6.0943E-08   -17.72    9.1474E-09    -6.98    9.9611E-01      .03
         .0000     10.0000       .0000     1.0566E-07    -7.01    5.9305E-09   -76.65    9.9588E-01      .02
         .0000     15.0000       .0000     4.3300E-08    18.76    3.9681E-09   -62.74    9.9556E-01      .00
         .0000     20.0000       .0000     7.8480E-09   -26.24    1.0693E-08  -165.18    9.9530E-01     -.02
         .0000     25.0000       .0000     5.6689E-08    -9.92    7.2733E-09    26.44    9.9550E-01     -.05
         .0000     30.0000       .0000     9.6798E-08   -18.05    8.8174E-09   -93.44    9.9795E-01      .05
         .0000     35.0000       .0000     6.9174E-08   -27.59    1.8923E-08   -14.14    1.0106E+00     1.19
         .0000     40.0000       .0000     3.6084E-08   -58.06    1.0351E-08   -31.91    1.0547E+00     6.03
         .0000     45.0000       .0000     4.9021E-08   -61.26    5.7310E-09   -69.21    1.1040E+00    12.69
         .0000     50.0000       .0000     2.5275E-08    -6.27    4.6016E-09    14.28    9.8244E-01     9.30




 ***** INPUT LINE  7  NE   0   11    1    1  0.00000E+00  0.00000E+00  0.00000E+00  5.00000E+00  0.00000E+00  0.00000E+00



                                      - - - NEAR ELECTRIC FIELDS - - -

              -  LOCATION  -                     -  EX  -               -  EY  -               -  EZ  -
        X           Y           Z           MAGNITUDE   PHASE      MAGNITUDE   PHASE      MAGNITUDE   PHASE
      METERS      METERS      METERS         VOLTS/M   DEGREES      VOLTS/M   DEGREES      VOLTS/M   DEGREES
         .0000       .0000       .0000     4.2897E-08   -27.02    8.1716E-09  -168.75    9.9619E-01      .03
        5.0000       .0000       .0000     4.1361E-08    -2.62    4.3675E-09  -107.37    9.8692E-01    16.52
       10.0000       .0000       .0000     4.0215E-08    28.84    6.0728E-09     6.04    9.6987E-01    33.41
       15.0000       .0000       .0000     6.1043E-08    37.29    1.4793E-09  -108.55    9.4938E-01    50.89
       20.0000       .0000       .0000     3.3373E-08    88.99    2.5648E-09   152.02    9.3104E-01    69.02
       25.0000       .0000       .0000     5.2652E-08   108.33    8.3089E-09  -146.02    9.1939E-01    87.66
       30.0000       .0000       .0000     9.9166E-08   130.65    3.1535E-09   168.55    9.0782E-01   106.78
       35.0000       .0000       .0000     1.2326E-07   135.32    1.3783E-08   -55.19    8.5662E-01   130.00
       40.0000       .0000       .0000     1.8910E-07   165.66    4.1255E-09   -72.55    8.5966E-01   174.27
       45.0000       .0000       .0000     9.5646E-08   161.81    9.7338E-09    29.87    1.3188E+00  -148.03
       50.0000       .0000       .0000     1.2006E-07   -67.85    3.4089E-08   106.34    1.2074E+00  -148.66




 ***** INPUT LINE  8  NH   0    1    1   11  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  5.00000E+00



                                      - - - NEAR MAGNETIC FIELDS - - -

              -  LOCATION  -                     -  HX  -               -  HY  -               -  HZ  -
        X           Y           Z           MAGNITUDE   PHASE      MAGNITUDE   PHASE      MAGNITUDE   PHASE
      METERS      METERS      METERS          AMPS/M   DEGREES       AMPS/M   DEGREES       AMPS/M   DEGREES
         .0000       .0000       .0000     3.2159E-11  -126.58    2.2789E-03     1.96    1.1914E-11   -87.74
         .0000       .0000      5.0000     2.2310E-11   -25.41    2.2876E-03     1.91    2.5972E-11   164.34
         .0000       .0000     10.0000     8.4380E-11   167.20    2.3137E-03     1.77    3.5585E-11    45.12
         .0000       .0000     15.0000     1.4544E-10     8.80    2.3568E-03     1.55    6.6238E-11    11.83
         .0000       .0000     20.0000     3.2183E-11    -9.22    2.4177E-03     1.26    6.9556E-11     1.92
         .0000       .0000     25.0000     6.9161E-11    -8.98    2.5014E-03      .91    1.7734E-10  -174.05
         .0000       .0000     30.0000     5.3614E-11    18.89    2.6239E-03      .48    7.5468E-11    40.41
         .0000       .0000     35.0000     4.7674E-11    31.57    2.8061E-03     -.04    3.6545E-11   -88.55
         .0000       .0000     40.0000     5.1084E-11   -58.23    2.9018E-03     -.28    2.7443E-11    78.60
         .0000       .0000     45.0000     3.0839E-11   -38.89    1.9299E-03     2.40    1.4433E-10   166.77
         .0000       .0000     50.0000     4.9085E-11   -10.39    3.5955E-04   125.57    1.6976E-10  -165.25




 ***** INPUT LINE  9  NH   0    1   11    1  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  5.00000E+00  0.00000E+00



                                      - - - NEAR MAGNETIC FIELDS - - -

              -  LOCATION  -                     -  HX  -               -  HY  -               -  HZ  -
        X           Y           Z           MAGNITUDE   PHASE      MAGNITUDE   PHASE      MAGNITUDE   PHASE
      METERS      METERS      METERS          AMPS/M   DEGREES       AMPS/M   DEGREES       AMPS/M   DEGREES
         .0000       .0000       .0000     3.2159E-11  -126.58    2.2789E-03     1.96    1.1914E-11   -87.74
         .0000      5.0000       .0000     2.4436E-06   -33.79    2.2814E-03     1.94    5.7903E-11    -6.39
         .0000     10.0000       .0000     4.6772E-06   -31.84    2.2888E-03     1.89    4.2509E-11    44.97
         .0000     15.0000       .0000     6.5546E-06   -28.51    2.3015E-03     1.81    3.9539E-11   150.51
         .0000     20.0000       .0000     8.0913E-06   -24.05    2.3196E-03     1.71    7.3694E-11   174.93
         .0000     25.0000       .0000     9.8607E-06   -20.06    2.3435E-03     1.58    2.1723E-11  -118.47
         .0000     30.0000       .0000     1.5590E-05   -18.84    2.3757E-03     1.46    2.5174E-11   172.58
         .0000     35.0000       .0000     4.6067E-05   -15.18    2.4241E-03     1.45    3.7337E-11   142.11
         .0000     40.0000       .0000     1.8253E-04    -9.27    2.4817E-03     1.51    6.6449E-11   142.09
         .0000     45.0000       .0000     5.5127E-04    -7.05    2.4295E-03      .45    9.7078E-11   166.31
         .0000     50.0000       .0000     1.0005E-03    -9.09    2.1016E-03    -4.19    8.1565E-11   146.46




 ***** INPUT LINE 10  NH   0   11    1    1  0.00000E+00  0.00000E+00  0.00000E+00  5.00000E+00  0.00000E+00  0.00000E+00



                                      - - - NEAR MAGNETIC FIELDS - - -

              -  LOCATION  -                     -  HX  -               -  HY  -               -  HZ  -
        X           Y           Z           MAGNITUDE   PHASE      MAGNITUDE   PHASE      MAGNITUDE   PHASE
      METERS      METERS      METERS          AMPS/M   DEGREES       AMPS/M   DEGREES       AMPS/M   DEGREES
         .0000       .0000       .0000     3.2159E-11  -126.58    2.2789E-03     1.96    1.1914E-11   -87.74
        5.0000       .0000       .0000     5.0610E-11   172.73    2.3306E-03    21.82    8.9218E-12   -46.03
       10.0000       .0000       .0000     4.0816E-11  -118.78    2.4170E-03    40.81    6.4700E-12    38.75
       15.0000       .0000       .0000     3.5055E-11   141.67    2.5179E-03    58.74    6.0730E-12   -91.39
       20.0000       .0000       .0000     8.6868E-11   -41.18    2.6126E-03    75.71    2.6145E-11  -166.58
       25.0000       .0000       .0000     1.7379E-11    69.66    2.6847E-03    91.98    7.3204E-12    26.79
       30.0000       .0000       .0000     1.7592E-11   129.09    2.7211E-03   107.70    2.2805E-11   163.67
       35.0000       .0000       .0000     3.9828E-11    36.83    2.6696E-03   122.20    2.9184E-11  -133.28
       40.0000       .0000       .0000     9.8566E-11    74.81    2.2557E-03   132.88    1.0978E-11   106.59
       45.0000       .0000       .0000     1.4798E-10    49.94    9.8588E-04   132.94    8.8598E-12  -114.91
       50.0000       .0000       .0000     1.2374E-10   -69.08    6.7883E-04   -24.20    7.1621E-12   -80.20




 ***** INPUT LINE 11  NX   0    0    0    0  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
1



                                ***********************************************
                                *                                             *
                                *  NUMERICAL ELECTROMAGNETICS CODE (NEC-4.1)  *
                                *                                             *
                                ***********************************************




                      **********************************************************

                          Horizontal 16 m dipole                                                       
                          1. Dipole in free space                                                      
                          2. Dipole above ground - Ground: E = 10.,  SIG = 0.01 S/M,  5 MHz            
                             Sommerfeld gound option                                                   

                      **********************************************************





                                 - - - STRUCTURE SPECIFICATION - - -

                                     COORDINATES MUST BE INPUT IN
                                     METERS OR BE SCALED TO METERS
                                     BEFORE STRUCTURE INPUT IS ENDED


  WIRE                                                                               NO. OF    FIRST  LAST     TAG
  NO.        X1         Y1         Z1          X2         Y2         Z2      RADIUS   SEG.     SEG.   SEG.     NO.
     1   -8.00000     .00000     .01000     8.00000     .00000     .01000     .00100     11        1    11       1

   GROUND PLANE SPECIFIED.

   TOTAL SEGMENTS USED=   11     NO. SEG. IN A SYMMETRIC CELL=   11     SYMMETRY FLAG=  0


         - MULTIPLE WIRE JUNCTIONS -
 JUNCTION    SEGMENTS  (- FOR END 1, + FOR END 2)
  NONE




                                 - - - - SEGMENTATION DATA - - - -

                                        COORDINATES IN METERS

                         I+ AND I- INDICATE THE SEGMENTS BEFORE AND AFTER I


  SEG.   COORDINATES OF SEG. CENTER     SEG.     ORIENTATION ANGLES    WIRE    CONNECTION DATA   TAG
  NO.       X         Y         Z       LENGTH     ALPHA     BETA      RADIUS    I-   I    I+    NO.
     1  -7.27273    .00000    .01000   1.45455     .00000    .00000    .00100     0    1    2      1
     2  -5.81818    .00000    .01000   1.45455     .00000    .00000    .00100     1    2    3      1
     3  -4.36364    .00000    .01000   1.45455     .00000    .00000    .00100     2    3    4      1
     4  -2.90909    .00000    .01000   1.45455     .00000    .00000    .00100     3    4    5      1
     5  -1.45455    .00000    .01000   1.45455     .00000    .00000    .00100     4    5    6      1
     6    .00000    .00000    .01000   1.45455     .00000    .00000    .00100     5    6    7      1
     7   1.45455    .00000    .01000   1.45455     .00000    .00000    .00100     6    7    8      1
     8   2.90909    .00000    .01000   1.45455     .00000    .00000    .00100     7    8    9      1
     9   4.36364    .00000    .01000   1.45455     .00000    .00000    .00100     8    9   10      1
    10   5.81818    .00000    .01000   1.45455     .00000    .00000    .00100     9   10   11      1
    11   7.27273    .00000    .01000   1.45455     .00000    .00000    .00100    10   11    0      1




 ***** INPUT LINE  1  FR   0    1    0    0  5.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  2  EX   0    1    6    0  1.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  3  RP   0   10    2 1000  0.00000E+00  0.00000E+00  1.00000E+01  9.00000E+01  0.00000E+00  0.00000E+00




                                 - - - - - - FREQUENCY - - - - - -

                                    FREQUENCY= 5.0000E+00 MHZ
                                    WAVELENGTH= 5.9960E+01 METERS



                                  - - - ANTENNA ENVIRONMENT - - -

                                            FREE SPACE



                               - - - STRUCTURE IMPEDANCE LOADING - - -

                                   THIS STRUCTURE IS NOT LOADED



                                - - - MATRIX TIMING - - -

                        FILL=     .050 SEC.,  FACTOR=     .000 SEC.



                                          - - - ANTENNA INPUT PARAMETERS - - -

   TAG   SEG.    VOLTAGE (VOLTS)         CURRENT (AMPS)         IMPEDANCE (OHMS)        ADMITTANCE (MHOS)      POWER
   NO.   NO.    REAL        IMAG.       REAL        IMAG.       REAL        IMAG.       REAL        IMAG.     (WATTS)
     1     6 1.00000E+00 0.00000E+00 2.12384E-05 1.13068E-03 1.66070E+01-8.84113E+02 2.12384E-05 1.13068E-03 1.06192E-05



                             - - - CURRENTS AND LOCATION - - -

                     LENGTHS NORMALIZED BY WAVELENGTH (OR 2.*PI/CABS(K))

  SEG.  TAG    COORD. OF SEG. CENTER     SEG.            - - - CURRENT (AMPS) - - -
  NO.   NO.     X        Y        Z      LENGTH     REAL        IMAG.       MAG.        PHASE
     1    1   -.1213    .0000    .0002   .02426   3.8669E-06  1.3055E-04  1.3061E-04   88.303
     2    1   -.0970    .0000    .0002   .02426   1.0130E-05  3.6692E-04  3.6706E-04   88.419
     3    1   -.0728    .0000    .0002   .02426   1.4951E-05  5.8650E-04  5.8670E-04   88.540
     4    1   -.0485    .0000    .0002   .02426   1.8428E-05  7.9257E-04  7.9278E-04   88.668
     5    1   -.0243    .0000    .0002   .02426   2.0533E-05  9.8694E-04  9.8716E-04   88.808
     6    1    .0000    .0000    .0002   .02426   2.1238E-05  1.1307E-03  1.1309E-03   88.924
     7    1    .0243    .0000    .0002   .02426   2.0533E-05  9.8694E-04  9.8716E-04   88.808
     8    1    .0485    .0000    .0002   .02426   1.8428E-05  7.9257E-04  7.9278E-04   88.668
     9    1    .0728    .0000    .0002   .02426   1.4951E-05  5.8651E-04  5.8670E-04   88.540
    10    1    .0970    .0000    .0002   .02426   1.0130E-05  3.6692E-04  3.6706E-04   88.419
    11    1    .1213    .0000    .0002   .02426   3.8669E-06  1.3055E-04  1.3061E-04   88.303



                                        - - - POWER BUDGET - - -

                                           INPUT POWER   = 1.0619E-05 WATTS
                                           RADIATED POWER= 1.0619E-05 WATTS
                                           WIRE LOSS     = 0.0000E+00 WATTS
                                           EFFICIENCY    = 100.00 PERCENT



                                                - - - RADIATION PATTERNS - - -

  - - ANGLES - -          - POWER GAINS -        - - - POLARIZATION - - -    - - - E(THETA) - - -    - - - E(PHI) - - -
  THETA     PHI        VERT.   HOR.    TOTAL      AXIAL     TILT   SENSE     MAGNITUDE    PHASE      MAGNITUDE    PHASE 
 DEGREES  DEGREES       DB      DB      DB        RATIO     DEG.               VOLTS     DEGREES       VOLTS     DEGREES
     .00      .00       1.86 -999.99    1.86     .00000      .00  LINEAR    3.12413E-02    -1.25    0.00000E+00      .00
   10.00      .00       1.71 -999.99    1.71     .00000      .00  LINEAR    3.07092E-02    -1.25    0.00000E+00      .00
   20.00      .00       1.25 -999.99    1.25     .00000      .00  LINEAR    2.91450E-02    -1.25    0.00000E+00      .00
   30.00      .00        .47 -999.99     .47     .00000      .00  LINEAR    2.66391E-02    -1.26    0.00000E+00      .00
   40.00      .00       -.68 -999.99    -.68     .00000      .00  LINEAR    2.33254E-02    -1.26    0.00000E+00      .00
   50.00      .00      -2.30 -999.99   -2.30     .00000      .00  LINEAR    1.93614E-02    -1.26    0.00000E+00      .00
   60.00      .00      -4.57 -999.99   -4.57     .00000      .00  LINEAR    1.49075E-02    -1.27    0.00000E+00      .00
   70.00      .00      -7.94 -999.99   -7.94     .00000      .00  LINEAR    1.01127E-02    -1.28    0.00000E+00      .00
   80.00      .00     -13.88 -999.99  -13.88     .00000      .00  LINEAR    5.10642E-03    -1.29    0.00000E+00      .00
   90.00      .00    -145.88 -999.99 -145.88     .00000      .00  LINEAR    1.28297E-09   178.70    0.00000E+00      .00
     .00    90.00    -145.33    1.86    1.86     .00000    90.00  LINEAR    1.36560E-09   178.75    3.12413E-02   178.75
   10.00    90.00    -145.47    1.86    1.86     .00000    90.00  LINEAR    1.34485E-09   178.75    3.12413E-02   178.75
   20.00    90.00    -145.87    1.86    1.86     .00000    90.00  LINEAR    1.28325E-09   178.75    3.12413E-02   178.75
   30.00    90.00    -146.58    1.86    1.86     .00000    90.00  LINEAR    1.18265E-09   178.74    3.12413E-02   178.74
   40.00    90.00    -147.65    1.86    1.86     .00000    90.00  LINEAR    1.04611E-09   178.74    3.12413E-02   178.74
   50.00    90.00    -149.17    1.86    1.86     .00000    90.00  LINEAR    8.77791E-10   178.73    3.12413E-02   178.73
   60.00    90.00    -151.35    1.86    1.86     .00000    90.00  LINEAR    6.82800E-10   178.72    3.12413E-02   178.72
   70.00    90.00    -154.65    1.86    1.86     .00000    90.00  LINEAR    4.67063E-10   178.71    3.12413E-02   178.71
   80.00    90.00    -160.54    1.86    1.86     .00000    90.00  LINEAR    2.37134E-10   178.70    3.12413E-02   178.70
   90.00    90.00    -999.99    1.86    1.86     .00000   -90.00  LINEAR    5.96923E-17    -1.31    3.12413E-02   178.69






 ***** INPUT LINE  4  RP   0   10   10 1002  0.00000E+00  0.00000E+00  1.00000E+01  1.00000E+01  0.00000E+00  0.00000E+00



                                                - - - RADIATION PATTERNS - - -

  - - ANGLES - -          - POWER GAINS -        - - - POLARIZATION - - -    - - - E(THETA) - - -    - - - E(PHI) - - -
  THETA     PHI        VERT.   HOR.    TOTAL      AXIAL     TILT   SENSE     MAGNITUDE    PHASE      MAGNITUDE    PHASE 
 DEGREES  DEGREES       DB      DB      DB        RATIO     DEG.               VOLTS     DEGREES       VOLTS     DEGREES


   AVERAGE POWER GAIN= 9.97862E-01       SOLID ANGLE USED IN AVERAGING=(  .5000)*PI STERADIANS.

   POWER RADIATED ASSUMING RADIATION INTO 4*PI STERADIANS = 1.05965E-05 WATTS






 ***** INPUT LINE  5  GN   2    0    0    0  1.00000E+01  1.00000E-02  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
                                             0.00000E+00  SOMEX10.NEC                             
 ***** INPUT LINE  6  RP   0   10    2 1000  0.00000E+00  0.00000E+00  1.00000E+01  9.00000E+01  0.00000E+00  0.00000E+00




                                 - - - - - - FREQUENCY - - - - - -

                                    FREQUENCY= 5.0000E+00 MHZ
                                    WAVELENGTH= 5.9960E+01 METERS



                                  - - - ANTENNA ENVIRONMENT - - -


 GNDINO: UNABLE TO OPEN FILE SOMEX10.NEC                             
 WILL COMPUTE SOMMERFELD-GROUND TABLES

 Time to generate Sommerfeld ground tables =  20.12 seconds

                                        FINITE GROUND.  SOMMERFELD SOLUTION
                                        RELATIVE DIELECTRIC CONST.= 10.000
                                        CONDUCTIVITY= 1.000E-02 MHOS/METER
                                        COMPLEX DIELECTRIC CONSTANT= 1.00000E+01-3.59510E+01



                               - - - STRUCTURE IMPEDANCE LOADING - - -

                                   THIS STRUCTURE IS NOT LOADED



                                - - - MATRIX TIMING - - -

                        FILL=     .610 SEC.,  FACTOR=     .000 SEC.



                                          - - - ANTENNA INPUT PARAMETERS - - -

   TAG   SEG.    VOLTAGE (VOLTS)         CURRENT (AMPS)         IMPEDANCE (OHMS)        ADMITTANCE (MHOS)      POWER
   NO.   NO.    REAL        IMAG.       REAL        IMAG.       REAL        IMAG.       REAL        IMAG.     (WATTS)
     1     6 1.00000E+00 0.00000E+00 3.01426E-03 5.37698E-03 7.93275E+01-1.41508E+02 3.01426E-03 5.37698E-03 1.50713E-03



                             - - - CURRENTS AND LOCATION - - -

                     LENGTHS NORMALIZED BY WAVELENGTH (OR 2.*PI/CABS(K))

  SEG.  TAG    COORD. OF SEG. CENTER     SEG.            - - - CURRENT (AMPS) - - -
  NO.   NO.     X        Y        Z      LENGTH     REAL        IMAG.       MAG.        PHASE
     1    1   -.1213    .0000    .0002   .02426   4.1725E-04  6.6178E-04  7.8233E-04   57.768
     2    1   -.0970    .0000    .0002   .02426   1.2241E-03  1.9396E-03  2.2936E-03   57.745
     3    1   -.0728    .0000    .0002   .02426   1.9386E-03  3.1141E-03  3.6682E-03   58.096
     4    1   -.0485    .0000    .0002   .02426   2.5044E-03  4.1281E-03  4.8284E-03   58.756
     5    1   -.0243    .0000    .0002   .02426   2.8759E-03  4.9303E-03  5.7078E-03   59.745
     6    1    .0000    .0000    .0002   .02426   3.0143E-03  5.3770E-03  6.1642E-03   60.726
     7    1    .0243    .0000    .0002   .02426   2.8759E-03  4.9303E-03  5.7078E-03   59.745
     8    1    .0485    .0000    .0002   .02426   2.5044E-03  4.1281E-03  4.8284E-03   58.756
     9    1    .0728    .0000    .0002   .02426   1.9386E-03  3.1140E-03  3.6682E-03   58.096
    10    1    .0970    .0000    .0002   .02426   1.2241E-03  1.9396E-03  2.2936E-03   57.745
    11    1    .1213    .0000    .0002   .02426   4.1725E-04  6.6177E-04  7.8233E-04   57.768



                                        - - - POWER BUDGET - - -

                                           INPUT POWER   = 1.5071E-03 WATTS
                                           RADIATED POWER= 1.5071E-03 WATTS
                                           WIRE LOSS     = 0.0000E+00 WATTS
                                           EFFICIENCY    = 100.00 PERCENT



                                                - - - RADIATION PATTERNS - - -

  - - ANGLES - -          - POWER GAINS -        - - - POLARIZATION - - -    - - - E(THETA) - - -    - - - E(PHI) - - -
  THETA     PHI        VERT.   HOR.    TOTAL      AXIAL     TILT   SENSE     MAGNITUDE    PHASE      MAGNITUDE    PHASE 
 DEGREES  DEGREES       DB      DB      DB        RATIO     DEG.               VOLTS     DEGREES       VOLTS     DEGREES
     .00      .00     -14.96 -999.99  -14.96     .00000      .00  LINEAR    5.37220E-02     1.58    0.00000E+00      .00
   10.00      .00     -14.99 -999.99  -14.99     .00000      .00  LINEAR    5.35041E-02     1.48    0.00000E+00      .00
   20.00      .00     -15.10 -999.99  -15.10     .00000      .00  LINEAR    5.28542E-02     1.20    0.00000E+00      .00
   30.00      .00     -15.28 -999.99  -15.28     .00000      .00  LINEAR    5.17760E-02      .70    0.00000E+00      .00
   40.00      .00     -15.54 -999.99  -15.54     .00000      .00  LINEAR    5.02483E-02     -.07    0.00000E+00      .00
   50.00      .00     -15.90 -999.99  -15.90     .00000      .00  LINEAR    4.81698E-02    -1.19    0.00000E+00      .00
   60.00      .00     -16.45 -999.99  -16.45     .00000      .00  LINEAR    4.52273E-02    -2.93    0.00000E+00      .00
   70.00      .00     -17.41 -999.99  -17.41     .00000      .00  LINEAR    4.05043E-02    -5.89    0.00000E+00      .00
   80.00      .00     -19.77 -999.99  -19.77     .00000      .00  LINEAR    3.08561E-02   -12.02    0.00000E+00      .00
   90.00      .00    -145.93 -999.99 -145.93     .00000      .00  LINEAR    1.51962E-08   149.13    0.00000E+00      .00
     .00    90.00    -162.15  -14.96  -14.96     .00000    90.00  LINEAR    2.34827E-09  -178.42    5.37220E-02  -178.42
   10.00    90.00    -162.16  -15.07  -15.07     .00000    90.00  LINEAR    2.34328E-09  -178.52    5.30108E-02  -178.34
   20.00    90.00    -162.22  -15.43  -15.43     .00000    90.00  LINEAR    2.32778E-09  -178.81    5.08807E-02  -178.08
   30.00    90.00    -162.33  -16.05  -16.05     .00000    90.00  LINEAR    2.29994E-09  -179.32    4.73442E-02  -177.66
   40.00    90.00    -162.49  -17.01  -17.01     .00000    90.00  LINEAR    2.25574E-09   179.91    4.24269E-02  -177.09
   50.00    90.00    -162.76  -18.39  -18.39     .00000    90.00  LINEAR    2.18691E-09   178.77    3.61754E-02  -176.39
   60.00    90.00    -163.22  -20.41  -20.41     .00000    90.00  LINEAR    2.07521E-09   177.02    2.86661E-02  -175.57
   70.00    90.00    -164.10  -23.53  -23.53     .00000    90.00  LINEAR    1.87467E-09   174.06    2.00146E-02  -174.65
   80.00    90.00    -166.42  -29.23  -29.23     .00000    90.00  LINEAR    1.43624E-09   167.91    1.03858E-02  -173.68
   90.00    90.00    -999.99 -999.99 -999.99     .00000      .00            7.08722E-16   -30.94    7.08722E-16   -30.94






 ***** INPUT LINE  7  RP   0   10   10 1002  0.00000E+00  0.00000E+00  1.00000E+01  1.00000E+01  0.00000E+00  0.00000E+00



                                                - - - RADIATION PATTERNS - - -

  - - ANGLES - -          - POWER GAINS -        - - - POLARIZATION - - -    - - - E(THETA) - - -    - - - E(PHI) - - -
  THETA     PHI        VERT.   HOR.    TOTAL      AXIAL     TILT   SENSE     MAGNITUDE    PHASE      MAGNITUDE    PHASE 
 DEGREES  DEGREES       DB      DB      DB        RATIO     DEG.               VOLTS     DEGREES       VOLTS     DEGREES


   AVERAGE POWER GAIN= 1.59455E-02       SOLID ANGLE USED IN AVERAGING=(  .5000)*PI STERADIANS.

   POWER RADIATED ASSUMING RADIATION INTO 4*PI STERADIANS = 2.40320E-05 WATTS






 ***** INPUT LINE  8  NX   0    0    0    0  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
1



                                ***********************************************
                                *                                             *
                                *  NUMERICAL ELECTROMAGNETICS CODE (NEC-4.1)  *
                                *                                             *
                                ***********************************************




                      **********************************************************

                          Horizontal 16 m dipole                                                       
                          1. Dipole in an infinite lossy medium                                        
                          2. Dipole below the ground surface                                           
                             Sommerfeld gound option -  E = 10.,  SIG = 0.01 S/M,  5 MHz               

                      **********************************************************





                                 - - - STRUCTURE SPECIFICATION - - -

                                     COORDINATES MUST BE INPUT IN
                                     METERS OR BE SCALED TO METERS
                                     BEFORE STRUCTURE INPUT IS ENDED


  WIRE                                                                               NO. OF    FIRST  LAST     TAG
  NO.        X1         Y1         Z1          X2         Y2         Z2      RADIUS   SEG.     SEG.   SEG.     NO.
     1   -8.00000     .00000    -.01000     8.00000     .00000    -.01000     .00100     11        1    11       1

   GROUND PLANE SPECIFIED.

   TOTAL SEGMENTS USED=   11     NO. SEG. IN A SYMMETRIC CELL=   11     SYMMETRY FLAG=  0


         - MULTIPLE WIRE JUNCTIONS -
 JUNCTION    SEGMENTS  (- FOR END 1, + FOR END 2)
  NONE




                                 - - - - SEGMENTATION DATA - - - -

                                        COORDINATES IN METERS

                         I+ AND I- INDICATE THE SEGMENTS BEFORE AND AFTER I


  SEG.   COORDINATES OF SEG. CENTER     SEG.     ORIENTATION ANGLES    WIRE    CONNECTION DATA   TAG
  NO.       X         Y         Z       LENGTH     ALPHA     BETA      RADIUS    I-   I    I+    NO.
     1  -7.27273    .00000   -.01000   1.45455     .00000    .00000    .00100     0    1    2      1
     2  -5.81818    .00000   -.01000   1.45455     .00000    .00000    .00100     1    2    3      1
     3  -4.36364    .00000   -.01000   1.45455     .00000    .00000    .00100     2    3    4      1
     4  -2.90909    .00000   -.01000   1.45455     .00000    .00000    .00100     3    4    5      1
     5  -1.45455    .00000   -.01000   1.45455     .00000    .00000    .00100     4    5    6      1
     6    .00000    .00000   -.01000   1.45455     .00000    .00000    .00100     5    6    7      1
     7   1.45455    .00000   -.01000   1.45455     .00000    .00000    .00100     6    7    8      1
     8   2.90909    .00000   -.01000   1.45455     .00000    .00000    .00100     7    8    9      1
     9   4.36364    .00000   -.01000   1.45455     .00000    .00000    .00100     8    9   10      1
    10   5.81818    .00000   -.01000   1.45455     .00000    .00000    .00100     9   10   11      1
    11   7.27273    .00000   -.01000   1.45455     .00000    .00000    .00100    10   11    0      1




 ***** INPUT LINE  1  FR   0    1    0    0  5.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  2  EX   0    1    6    0  1.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  3  UM   0    0    0    0  1.00000E+01  1.00000E-02  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  4  RP   0   10    2 1000  0.00000E+00  0.00000E+00  1.00000E+01  9.00000E+01  0.00000E+00  0.00000E+00




                                 - - - - - - FREQUENCY - - - - - -

                                    FREQUENCY= 5.0000E+00 MHZ
                                    WAVELENGTH= 1.2327E+01 METERS
                                    SKIN DEPTH= 2.5822E+00 METERS



                                  - - - ANTENNA ENVIRONMENT - - -

                                        INFINITE MEDIUM
                                        RELATIVE DIELECTRIC CONST.= 10.000
                                        CONDUCTIVITY= 1.000E-02 MHOS/METER
                                        COMPLEX DIELECTRIC CONSTANT= 1.00000E+01-3.59510E+01



                               - - - STRUCTURE IMPEDANCE LOADING - - -

                                   THIS STRUCTURE IS NOT LOADED



                                - - - MATRIX TIMING - - -

                        FILL=     .050 SEC.,  FACTOR=     .000 SEC.



                                          - - - ANTENNA INPUT PARAMETERS - - -

   TAG   SEG.    VOLTAGE (VOLTS)         CURRENT (AMPS)         IMPEDANCE (OHMS)        ADMITTANCE (MHOS)      POWER
   NO.   NO.    REAL        IMAG.       REAL        IMAG.       REAL        IMAG.       REAL        IMAG.     (WATTS)
     1     6 1.00000E+00 0.00000E+00 4.64606E-03-4.10914E-03 1.20768E+02 1.06812E+02 4.64606E-03-4.10914E-03 2.32303E-03



                             - - - CURRENTS AND LOCATION - - -

                     LENGTHS NORMALIZED BY WAVELENGTH (OR 2.*PI/CABS(K))

  SEG.  TAG    COORD. OF SEG. CENTER     SEG.            - - - CURRENT (AMPS) - - -
  NO.   NO.     X        Y        Z      LENGTH     REAL        IMAG.       MAG.        PHASE
     1    1   -.7409    .0000   -.0010   .14819  -2.1873E-04  1.4690E-04  2.6348E-04  146.114
     2    1   -.5928    .0000   -.0010   .14819  -6.9515E-04  1.9455E-04  7.2186E-04  164.365
     3    1   -.4446    .0000   -.0010   .14819  -1.1394E-03 -3.9681E-04  1.2065E-03 -160.799
     4    1   -.2964    .0000   -.0010   .14819  -9.4195E-04 -1.8406E-03  2.0676E-03 -117.102
     5    1   -.1482    .0000   -.0010   .14819   1.1277E-03 -3.6214E-03  3.7930E-03  -72.703
     6    1    .0000    .0000   -.0010   .14819   4.6461E-03 -4.1091E-03  6.2025E-03  -41.491
     7    1    .1482    .0000   -.0010   .14819   1.1277E-03 -3.6214E-03  3.7930E-03  -72.703
     8    1    .2964    .0000   -.0010   .14819  -9.4195E-04 -1.8406E-03  2.0676E-03 -117.102
     9    1    .4446    .0000   -.0010   .14819  -1.1394E-03 -3.9680E-04  1.2065E-03 -160.799
    10    1    .5928    .0000   -.0010   .14819  -6.9515E-04  1.9455E-04  7.2186E-04  164.365
    11    1    .7409    .0000   -.0010   .14819  -2.1873E-04  1.4690E-04  2.6348E-04  146.114



                                        - - - POWER BUDGET - - -

                                           INPUT POWER   = 2.3230E-03 WATTS
                                           RADIATED POWER= 2.3230E-03 WATTS
                                           WIRE LOSS     = 0.0000E+00 WATTS
                                           EFFICIENCY    = 100.00 PERCENT



                                                - - - RADIATION PATTERNS - - -

  - - ANGLES - -          - POWER GAINS -        - - - POLARIZATION - - -    - - - E(THETA) - - -    - - - E(PHI) - - -
  THETA     PHI        VERT.   HOR.    TOTAL      AXIAL     TILT   SENSE     MAGNITUDE    PHASE      MAGNITUDE    PHASE 
 DEGREES  DEGREES       DB      DB      DB        RATIO     DEG.               VOLTS     DEGREES       VOLTS     DEGREES
     .00      .00      -5.79 -999.99   -5.79     .00000      .00  LINEAR    6.91939E-02  -176.72    0.00000E+00      .00
   10.00      .00      -5.53 -999.99   -5.53     .00000      .00  LINEAR    7.12477E-02  -175.32    0.00000E+00      .00
   20.00      .00      -4.93 -999.99   -4.93     .00000      .00  LINEAR    7.63759E-02  -171.10    0.00000E+00      .00
   30.00      .00      -4.33 -999.99   -4.33     .00000      .00  LINEAR    8.18868E-02  -164.27    0.00000E+00      .00
   40.00      .00      -4.06 -999.99   -4.06     .00000      .00  LINEAR    8.44404E-02  -155.53    0.00000E+00      .00
   50.00      .00      -4.40 -999.99   -4.40     .00000      .00  LINEAR    8.11554E-02  -145.98    0.00000E+00      .00
   60.00      .00      -5.64 -999.99   -5.64     .00000      .00  LINEAR    7.03939E-02  -136.84    0.00000E+00      .00
   70.00      .00      -8.25 -999.99   -8.25     .00000      .00  LINEAR    5.20974E-02  -129.30    0.00000E+00      .00
   80.00      .00     -13.73 -999.99  -13.73     .00000      .00  LINEAR    2.77403E-02  -124.33    0.00000E+00      .00
   90.00      .00    -145.57 -999.99 -145.57     .00000      .00  LINEAR    7.09781E-09    57.43    0.00000E+00      .00
     .00    90.00    -152.98   -5.79   -5.79     .00000    90.00  LINEAR    3.02456E-09     3.28    6.91939E-02     3.28
   10.00    90.00    -153.11   -5.79   -5.79     .00000    90.00  LINEAR    2.97879E-09     3.28    6.91980E-02     3.28
   20.00    90.00    -153.51   -5.79   -5.79     .00000    90.00  LINEAR    2.84282E-09     3.30    6.92101E-02     3.30
   30.00    90.00    -154.22   -5.78   -5.78     .00000    90.00  LINEAR    2.62071E-09     3.32    6.92298E-02     3.32
   40.00    90.00    -155.28   -5.78   -5.78     .00000    90.00  LINEAR    2.31905E-09     3.35    6.92566E-02     3.35
   50.00    90.00    -156.80   -5.78   -5.78     .00000    90.00  LINEAR    1.94684E-09     3.38    6.92897E-02     3.38
   60.00    90.00    -158.98   -5.77   -5.77     .00000    90.00  LINEAR    1.51521E-09     3.43    6.93280E-02     3.43
   70.00    90.00    -162.27   -5.77   -5.77     .00000    90.00  LINEAR    1.03710E-09     3.47    6.93704E-02     3.47
   80.00    90.00    -168.16   -5.76   -5.76     .00000    90.00  LINEAR    5.26893E-10     3.52    6.94157E-02     3.52
   90.00    90.00    -999.99   -5.76   -5.76     .00000   -90.00  LINEAR    1.32721E-16  -176.43    6.94624E-02     3.57






 ***** INPUT LINE  5  RP   0   10   10 1002  0.00000E+00  0.00000E+00  1.00000E+01  1.00000E+01  0.00000E+00  0.00000E+00



                                                - - - RADIATION PATTERNS - - -

  - - ANGLES - -          - POWER GAINS -        - - - POLARIZATION - - -    - - - E(THETA) - - -    - - - E(PHI) - - -
  THETA     PHI        VERT.   HOR.    TOTAL      AXIAL     TILT   SENSE     MAGNITUDE    PHASE      MAGNITUDE    PHASE 
 DEGREES  DEGREES       DB      DB      DB        RATIO     DEG.               VOLTS     DEGREES       VOLTS     DEGREES


   AVERAGE POWER GAIN= 3.07473E-01       SOLID ANGLE USED IN AVERAGING=(  .5000)*PI STERADIANS.

   POWER RADIATED ASSUMING RADIATION INTO 4*PI STERADIANS = 7.14269E-04 WATTS








                      **********************************************************

                          NOTE: The above calculation of average gain in a lossy medium cannot         
                                be interpreted in the usual sense.  A factor of EXP(-jkR)/R            
                                has been omitted from the field so that a non-zero value can           
                                be obtained for R --> infinity with complex k.  However, by the        
                                usual definition, the far-field gain is zero in a lossy medium.        

                      **********************************************************


 ***** INPUT LINE  6  UM   0    0    0    0  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  7  GN   2    0    0    0  1.00000E+01  1.00000E-02  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
                                             0.00000E+00  SOMEX10.NEC                             
 ***** INPUT LINE  8  RP   0   10    2 1000  0.00000E+00  0.00000E+00  1.00000E+01  9.00000E+01  0.00000E+00  0.00000E+00




                                 - - - - - - FREQUENCY - - - - - -

                                    FREQUENCY= 5.0000E+00 MHZ
                                    WAVELENGTH= 5.9960E+01 METERS



                                  - - - ANTENNA ENVIRONMENT - - -

                                        FINITE GROUND.  SOMMERFELD SOLUTION
                                        RELATIVE DIELECTRIC CONST.= 10.000
                                        CONDUCTIVITY= 1.000E-02 MHOS/METER
                                        COMPLEX DIELECTRIC CONSTANT= 1.00000E+01-3.59510E+01



                               - - - STRUCTURE IMPEDANCE LOADING - - -

                                   THIS STRUCTURE IS NOT LOADED



                                - - - MATRIX TIMING - - -

                        FILL=     .540 SEC.,  FACTOR=     .000 SEC.



                                          - - - ANTENNA INPUT PARAMETERS - - -

   TAG   SEG.    VOLTAGE (VOLTS)         CURRENT (AMPS)         IMPEDANCE (OHMS)        ADMITTANCE (MHOS)      POWER
   NO.   NO.    REAL        IMAG.       REAL        IMAG.       REAL        IMAG.       REAL        IMAG.     (WATTS)
     1     6 1.00000E+00 0.00000E+00 3.73947E-03-3.02523E-03 1.61632E+02 1.30761E+02 3.73947E-03-3.02523E-03 1.86973E-03



                             - - - CURRENTS AND LOCATION - - -

                     LENGTHS NORMALIZED BY WAVELENGTH (OR 2.*PI/CABS(K))

  SEG.  TAG    COORD. OF SEG. CENTER     SEG.            - - - CURRENT (AMPS) - - -
  NO.   NO.     X        Y        Z      LENGTH     REAL        IMAG.       MAG.        PHASE
     1    1   -.7409    .0000   -.0010   .14819  -2.8478E-04 -5.5907E-05  2.9022E-04 -168.893
     2    1   -.5928    .0000   -.0010   .14819  -7.4081E-04 -3.1102E-04  8.0345E-04 -157.225
     3    1   -.4446    .0000   -.0010   .14819  -9.0938E-04 -9.3623E-04  1.3052E-03 -134.167
     4    1   -.2964    .0000   -.0010   .14819  -4.1824E-04 -1.9434E-03  1.9879E-03 -102.145
     5    1   -.1482    .0000   -.0010   .14819   1.3088E-03 -2.9169E-03  3.1971E-03  -65.833
     6    1    .0000    .0000   -.0010   .14819   3.7395E-03 -3.0252E-03  4.8100E-03  -38.973
     7    1    .1482    .0000   -.0010   .14819   1.3089E-03 -2.9169E-03  3.1971E-03  -65.833
     8    1    .2964    .0000   -.0010   .14819  -4.1823E-04 -1.9434E-03  1.9879E-03 -102.145
     9    1    .4446    .0000   -.0010   .14819  -9.0936E-04 -9.3622E-04  1.3052E-03 -134.166
    10    1    .5928    .0000   -.0010   .14819  -7.4079E-04 -3.1102E-04  8.0344E-04 -157.225
    11    1    .7409    .0000   -.0010   .14819  -2.8477E-04 -5.5909E-05  2.9021E-04 -168.893



                                        - - - POWER BUDGET - - -

                                           INPUT POWER   = 1.8697E-03 WATTS
                                           RADIATED POWER= 1.8697E-03 WATTS
                                           WIRE LOSS     = 0.0000E+00 WATTS
                                           EFFICIENCY    = 100.00 PERCENT



                                                - - - RADIATION PATTERNS - - -

  - - ANGLES - -          - POWER GAINS -        - - - POLARIZATION - - -    - - - E(THETA) - - -    - - - E(PHI) - - -
  THETA     PHI        VERT.   HOR.    TOTAL      AXIAL     TILT   SENSE     MAGNITUDE    PHASE      MAGNITUDE    PHASE 
 DEGREES  DEGREES       DB      DB      DB        RATIO     DEG.               VOLTS     DEGREES       VOLTS     DEGREES
     .00      .00     -24.36 -999.99  -24.36     .00000      .00  LINEAR    2.02759E-02  -141.75    0.00000E+00      .00
   10.00      .00     -24.38 -999.99  -24.38     .00000      .00  LINEAR    2.02148E-02  -141.76    0.00000E+00      .00
   20.00      .00     -24.46 -999.99  -24.46     .00000      .00  LINEAR    2.00298E-02  -141.81    0.00000E+00      .00
   30.00      .00     -24.60 -999.99  -24.60     .00000      .00  LINEAR    1.97132E-02  -141.94    0.00000E+00      .00
   40.00      .00     -24.81 -999.99  -24.81     .00000      .00  LINEAR    1.92430E-02  -142.25    0.00000E+00      .00
   50.00      .00     -25.12 -999.99  -25.12     .00000      .00  LINEAR    1.85630E-02  -142.89    0.00000E+00      .00
   60.00      .00     -25.62 -999.99  -25.62     .00000      .00  LINEAR    1.75333E-02  -144.18    0.00000E+00      .00
   70.00      .00     -26.53 -999.99  -26.53     .00000      .00  LINEAR    1.57797E-02  -146.77    0.00000E+00      .00
   80.00      .00     -28.87 -999.99  -28.87     .00000      .00  LINEAR    1.20599E-02  -152.66    0.00000E+00      .00
   90.00      .00    -154.94 -999.99 -154.94     .00000      .00  LINEAR    5.99291E-09     9.15    0.00000E+00      .00
     .00    90.00    -171.54  -24.36  -24.36     .00000    90.00  LINEAR    8.86288E-10    38.25    2.02759E-02    38.25
   10.00    90.00    -171.56  -24.47  -24.47     .00000    90.00  LINEAR    8.84509E-10    38.16    2.00074E-02    38.34
   20.00    90.00    -171.62  -24.83  -24.83     .00000    90.00  LINEAR    8.78956E-10    37.90    1.92033E-02    38.59
   30.00    90.00    -171.72  -25.45  -25.45     .00000    90.00  LINEAR    8.68888E-10    37.43    1.78683E-02    39.01
   40.00    90.00    -171.88  -26.41  -26.41     .00000    90.00  LINEAR    8.52726E-10    36.70    1.60122E-02    39.59
   50.00    90.00    -172.14  -27.79  -27.79     .00000    90.00  LINEAR    8.27254E-10    35.62    1.36526E-02    40.29
   60.00    90.00    -172.59  -29.81  -29.81     .00000    90.00  LINEAR    7.85489E-10    33.92    1.08184E-02    41.12
   70.00    90.00    -173.47  -32.93  -32.93     .00000    90.00  LINEAR    7.09942E-10    30.99    7.55328E-03    42.03
   80.00    90.00    -175.78  -38.63  -38.63     .00000    90.00  LINEAR    5.44084E-10    24.88    3.91945E-03    43.00
   90.00    90.00    -999.99 -170.35 -170.35     .00000   -90.00  LINEAR    2.70629E-16  -173.39    1.01701E-09    44.58






 ***** INPUT LINE  9  RP   0   10   10 1002  0.00000E+00  0.00000E+00  1.00000E+01  1.00000E+01  0.00000E+00  0.00000E+00



                                                - - - RADIATION PATTERNS - - -

  - - ANGLES - -          - POWER GAINS -        - - - POLARIZATION - - -    - - - E(THETA) - - -    - - - E(PHI) - - -
  THETA     PHI        VERT.   HOR.    TOTAL      AXIAL     TILT   SENSE     MAGNITUDE    PHASE      MAGNITUDE    PHASE 
 DEGREES  DEGREES       DB      DB      DB        RATIO     DEG.               VOLTS     DEGREES       VOLTS     DEGREES


   AVERAGE POWER GAIN= 1.87156E-03       SOLID ANGLE USED IN AVERAGING=(  .5000)*PI STERADIANS.

   POWER RADIATED ASSUMING RADIATION INTO 4*PI STERADIANS = 3.49932E-06 WATTS






 ***** INPUT LINE 10  NX   0    0    0    0  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
1



                                ***********************************************
                                *                                             *
                                *  NUMERICAL ELECTROMAGNETICS CODE (NEC-4.1)  *
                                *                                             *
                                ***********************************************




                      **********************************************************

                          TWO HORIZONTAL 16 M DIPOLE ANTENNAS ABOVE AND BELOW GROUND                   
                          SOMMERFELD GOUND OPTION -  E = 10.,  SIG = 0.01 S/M,  5 MHz                  

                      **********************************************************





                                 - - - STRUCTURE SPECIFICATION - - -

                                     COORDINATES MUST BE INPUT IN
                                     METERS OR BE SCALED TO METERS
                                     BEFORE STRUCTURE INPUT IS ENDED


  WIRE                                                                               NO. OF    FIRST  LAST     TAG
  NO.        X1         Y1         Z1          X2         Y2         Z2      RADIUS   SEG.     SEG.   SEG.     NO.
     1   -8.00000     .00000     .01000     8.00000     .00000     .01000     .00100     11        1    11       1
     2   -8.00000     .00000    -.01000     8.00000     .00000    -.01000     .00100     11       12    22       2

   GROUND PLANE SPECIFIED.

   TOTAL SEGMENTS USED=   22     NO. SEG. IN A SYMMETRIC CELL=   22     SYMMETRY FLAG=  0


         - MULTIPLE WIRE JUNCTIONS -
 JUNCTION    SEGMENTS  (- FOR END 1, + FOR END 2)
  NONE




                                 - - - - SEGMENTATION DATA - - - -

                                        COORDINATES IN METERS

                         I+ AND I- INDICATE THE SEGMENTS BEFORE AND AFTER I


  SEG.   COORDINATES OF SEG. CENTER     SEG.     ORIENTATION ANGLES    WIRE    CONNECTION DATA   TAG
  NO.       X         Y         Z       LENGTH     ALPHA     BETA      RADIUS    I-   I    I+    NO.
     1  -7.27273    .00000    .01000   1.45455     .00000    .00000    .00100     0    1    2      1
     2  -5.81818    .00000    .01000   1.45455     .00000    .00000    .00100     1    2    3      1
     3  -4.36364    .00000    .01000   1.45455     .00000    .00000    .00100     2    3    4      1
     4  -2.90909    .00000    .01000   1.45455     .00000    .00000    .00100     3    4    5      1
     5  -1.45455    .00000    .01000   1.45455     .00000    .00000    .00100     4    5    6      1
     6    .00000    .00000    .01000   1.45455     .00000    .00000    .00100     5    6    7      1
     7   1.45455    .00000    .01000   1.45455     .00000    .00000    .00100     6    7    8      1
     8   2.90909    .00000    .01000   1.45455     .00000    .00000    .00100     7    8    9      1
     9   4.36364    .00000    .01000   1.45455     .00000    .00000    .00100     8    9   10      1
    10   5.81818    .00000    .01000   1.45455     .00000    .00000    .00100     9   10   11      1
    11   7.27273    .00000    .01000   1.45455     .00000    .00000    .00100    10   11    0      1
    12  -7.27273    .00000   -.01000   1.45455     .00000    .00000    .00100     0   12   13      2
    13  -5.81818    .00000   -.01000   1.45455     .00000    .00000    .00100    12   13   14      2
    14  -4.36364    .00000   -.01000   1.45455     .00000    .00000    .00100    13   14   15      2
    15  -2.90909    .00000   -.01000   1.45455     .00000    .00000    .00100    14   15   16      2
    16  -1.45455    .00000   -.01000   1.45455     .00000    .00000    .00100    15   16   17      2
    17    .00000    .00000   -.01000   1.45455     .00000    .00000    .00100    16   17   18      2
    18   1.45455    .00000   -.01000   1.45455     .00000    .00000    .00100    17   18   19      2
    19   2.90909    .00000   -.01000   1.45455     .00000    .00000    .00100    18   19   20      2
    20   4.36364    .00000   -.01000   1.45455     .00000    .00000    .00100    19   20   21      2
    21   5.81818    .00000   -.01000   1.45455     .00000    .00000    .00100    20   21   22      2
    22   7.27273    .00000   -.01000   1.45455     .00000    .00000    .00100    21   22    0      2




 ***** INPUT LINE  1  FR   0    1    0    0  5.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  2  EX   0    1    6    0  1.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  3  EX   0    2    6    0  1.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  4  GN   2    0    0    0  1.00000E+01  1.00000E-02  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
                                             0.00000E+00  SOMEX10.NEC                             
 ***** INPUT LINE  5  RP   0   10    2 1000  0.00000E+00  0.00000E+00  1.00000E+01  9.00000E+01  0.00000E+00  0.00000E+00




                                 - - - - - - FREQUENCY - - - - - -

                                    FREQUENCY= 5.0000E+00 MHZ
                                    WAVELENGTH= 5.9960E+01 METERS



                                  - - - ANTENNA ENVIRONMENT - - -

                                        FINITE GROUND.  SOMMERFELD SOLUTION
                                        RELATIVE DIELECTRIC CONST.= 10.000
                                        CONDUCTIVITY= 1.000E-02 MHOS/METER
                                        COMPLEX DIELECTRIC CONSTANT= 1.00000E+01-3.59510E+01



                               - - - STRUCTURE IMPEDANCE LOADING - - -

                                   THIS STRUCTURE IS NOT LOADED



                                - - - MATRIX TIMING - - -

                        FILL=    3.050 SEC.,  FACTOR=     .010 SEC.



                                          - - - ANTENNA INPUT PARAMETERS - - -

   TAG   SEG.    VOLTAGE (VOLTS)         CURRENT (AMPS)         IMPEDANCE (OHMS)        ADMITTANCE (MHOS)      POWER
   NO.   NO.    REAL        IMAG.       REAL        IMAG.       REAL        IMAG.       REAL        IMAG.     (WATTS)
     1     6 1.00000E+00 0.00000E+00-1.72394E-04 1.40381E-03-8.61804E+01-7.01766E+02-1.72394E-04 1.40381E-03-8.61972E-05
     2    17 1.00000E+00 0.00000E+00 3.75486E-03-3.92407E-03 1.27295E+02 1.33031E+02 3.75486E-03-3.92407E-03 1.87743E-03



                             - - - CURRENTS AND LOCATION - - -

                     LENGTHS NORMALIZED BY WAVELENGTH (OR 2.*PI/CABS(K))

  SEG.  TAG    COORD. OF SEG. CENTER     SEG.            - - - CURRENT (AMPS) - - -
  NO.   NO.     X        Y        Z      LENGTH     REAL        IMAG.       MAG.        PHASE
     1    1   -.1213    .0000    .0002   .02426  -1.4621E-05  1.6669E-04  1.6733E-04   95.013
     2    1   -.0970    .0000    .0002   .02426  -4.5201E-05  4.9385E-04  4.9592E-04   95.230
     3    1   -.0728    .0000    .0002   .02426  -8.0166E-05  7.9938E-04  8.0339E-04   95.727
     4    1   -.0485    .0000    .0002   .02426  -1.1921E-04  1.0666E-03  1.0733E-03   96.377
     5    1   -.0243    .0000    .0002   .02426  -1.5532E-04  1.2803E-03  1.2897E-03   96.917
     6    1    .0000    .0000    .0002   .02426  -1.7239E-04  1.4038E-03  1.4144E-03   97.001
     7    1    .0243    .0000    .0002   .02426  -1.5532E-04  1.2803E-03  1.2897E-03   96.917
     8    1    .0485    .0000    .0002   .02426  -1.1922E-04  1.0666E-03  1.0733E-03   96.377
     9    1    .0728    .0000    .0002   .02426  -8.0168E-05  7.9938E-04  8.0339E-04   95.727
    10    1    .0970    .0000    .0002   .02426  -4.5203E-05  4.9385E-04  4.9592E-04   95.230
    11    1    .1213    .0000    .0002   .02426  -1.4621E-05  1.6669E-04  1.6733E-04   95.013
    12    2   -.7409    .0000   -.0010   .14819  -2.8339E-04 -1.5423E-04  3.2264E-04 -151.444
    13    2   -.5928    .0000   -.0010   .14819  -7.3857E-04 -6.1383E-04  9.6035E-04 -140.270
    14    2   -.4446    .0000   -.0010   .14819  -9.0640E-04 -1.4343E-03  1.6967E-03 -122.291
    15    2   -.2964    .0000   -.0010   .14819  -4.1164E-04 -2.6152E-03  2.6474E-03  -98.945
    16    2   -.1482    .0000   -.0010   .14819   1.3209E-03 -3.7311E-03  3.9581E-03  -70.504
    17    2    .0000    .0000   -.0010   .14819   3.7549E-03 -3.9241E-03  5.4311E-03  -46.262
    18    2    .1482    .0000   -.0010   .14819   1.3209E-03 -3.7311E-03  3.9581E-03  -70.504
    19    2    .2964    .0000   -.0010   .14819  -4.1163E-04 -2.6152E-03  2.6474E-03  -98.945
    20    2    .4446    .0000   -.0010   .14819  -9.0638E-04 -1.4343E-03  1.6966E-03 -122.291
    21    2    .5928    .0000   -.0010   .14819  -7.3855E-04 -6.1383E-04  9.6034E-04 -140.269
    22    2    .7409    .0000   -.0010   .14819  -2.8338E-04 -1.5423E-04  3.2264E-04 -151.443



                                        - - - POWER BUDGET - - -

                                           INPUT POWER   = 1.7912E-03 WATTS
                                           RADIATED POWER= 1.7912E-03 WATTS
                                           WIRE LOSS     = 0.0000E+00 WATTS
                                           EFFICIENCY    = 100.00 PERCENT



                                                - - - RADIATION PATTERNS - - -

  - - ANGLES - -          - POWER GAINS -        - - - POLARIZATION - - -    - - - E(THETA) - - -    - - - E(PHI) - - -
  THETA     PHI        VERT.   HOR.    TOTAL      AXIAL     TILT   SENSE     MAGNITUDE    PHASE      MAGNITUDE    PHASE 
 DEGREES  DEGREES       DB      DB      DB        RATIO     DEG.               VOLTS     DEGREES       VOLTS     DEGREES
     .00      .00     -26.38 -999.99  -26.38     .00000      .00  LINEAR    1.57173E-02  -144.88    0.00000E+00      .00
   10.00      .00     -26.41 -999.99  -26.41     .00000      .00  LINEAR    1.56740E-02  -144.86    0.00000E+00      .00
   20.00      .00     -26.48 -999.99  -26.48     .00000      .00  LINEAR    1.55424E-02  -144.82    0.00000E+00      .00
   30.00      .00     -26.61 -999.99  -26.61     .00000      .00  LINEAR    1.53150E-02  -144.81    0.00000E+00      .00
   40.00      .00     -26.80 -999.99  -26.80     .00000      .00  LINEAR    1.49720E-02  -144.95    0.00000E+00      .00
   50.00      .00     -27.10 -999.99  -27.10     .00000      .00  LINEAR    1.44665E-02  -145.42    0.00000E+00      .00
   60.00      .00     -27.58 -999.99  -27.58     .00000      .00  LINEAR    1.36857E-02  -146.54    0.00000E+00      .00
   70.00      .00     -28.49 -999.99  -28.49     .00000      .00  LINEAR    1.23331E-02  -149.00    0.00000E+00      .00
   80.00      .00     -30.82 -999.99  -30.82     .00000      .00  LINEAR    9.43401E-03  -154.81    0.00000E+00      .00
   90.00      .00    -156.84 -999.99 -156.84     .00000      .00  LINEAR    4.71652E-09     7.45    0.00000E+00      .00
     .00    90.00    -173.57  -26.38  -26.38     .00000    90.00  LINEAR    6.87024E-10    35.12    1.57173E-02    35.12
   10.00    90.00    -173.59  -26.50  -26.50     .00000    90.00  LINEAR    6.85701E-10    35.04    1.55091E-02    35.21
   20.00    90.00    -173.64  -26.85  -26.85     .00000    90.00  LINEAR    6.81556E-10    34.79    1.48857E-02    35.46
   30.00    90.00    -173.74  -27.48  -27.48     .00000    90.00  LINEAR    6.73990E-10    34.35    1.38507E-02    35.88
   40.00    90.00    -173.90  -28.43  -28.43     .00000    90.00  LINEAR    6.61742E-10    33.67    1.24117E-02    36.46
   50.00    90.00    -174.16  -29.82  -29.82     .00000    90.00  LINEAR    6.42271E-10    32.62    1.05825E-02    37.16
   60.00    90.00    -174.60  -31.84  -31.84     .00000    90.00  LINEAR    6.10109E-10    30.96    8.38554E-03    37.99
   70.00    90.00    -175.48  -34.96  -34.96     .00000    90.00  LINEAR    5.51623E-10    28.06    5.85463E-03    38.90
   80.00    90.00    -177.79  -40.66  -40.66     .00000    90.00  LINEAR    4.22849E-10    21.97    3.03799E-03    39.87
   90.00    90.00    -999.99 -157.94 -157.94     .00000   -90.00  LINEAR    2.11511E-16  -175.84    4.15311E-09    18.44






 ***** INPUT LINE  6  RP   0   10   10 1002  0.00000E+00  0.00000E+00  1.00000E+01  1.00000E+01  0.00000E+00  0.00000E+00



                                                - - - RADIATION PATTERNS - - -

  - - ANGLES - -          - POWER GAINS -        - - - POLARIZATION - - -    - - - E(THETA) - - -    - - - E(PHI) - - -
  THETA     PHI        VERT.   HOR.    TOTAL      AXIAL     TILT   SENSE     MAGNITUDE    PHASE      MAGNITUDE    PHASE 
 DEGREES  DEGREES       DB      DB      DB        RATIO     DEG.               VOLTS     DEGREES       VOLTS     DEGREES


   AVERAGE POWER GAIN= 1.18079E-03       SOLID ANGLE USED IN AVERAGING=(  .5000)*PI STERADIANS.

   POWER RADIATED ASSUMING RADIATION INTO 4*PI STERADIANS = 2.11508E-06 WATTS






 ***** INPUT LINE  7  NX   0    0    0    0  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
1



                                ***********************************************
                                *                                             *
                                *  NUMERICAL ELECTROMAGNETICS CODE (NEC-4.1)  *
                                *                                             *
                                ***********************************************




                      **********************************************************

                          15 m monopole antenna on a ground stake 2 m deep.                            
                          Ground: E = 10.,  SIG = 0.01 S/m,   5 MHz.                                   

                      **********************************************************





                                 - - - STRUCTURE SPECIFICATION - - -

                                     COORDINATES MUST BE INPUT IN
                                     METERS OR BE SCALED TO METERS
                                     BEFORE STRUCTURE INPUT IS ENDED


  WIRE                                                                               NO. OF    FIRST  LAST     TAG
  NO.        X1         Y1         Z1          X2         Y2         Z2      RADIUS   SEG.     SEG.   SEG.     NO.
     1     .00000     .00000   -2.00000      .00000     .00000     .00000     .01000      8        1     8       1
     2     .00000     .00000     .00000      .00000     .00000   15.00000     .01000     10        9    18       2

   GROUND PLANE SPECIFIED.

   TOTAL SEGMENTS USED=   18     NO. SEG. IN A SYMMETRIC CELL=   18     SYMMETRY FLAG=  0


         - MULTIPLE WIRE JUNCTIONS -
 JUNCTION    SEGMENTS  (- FOR END 1, + FOR END 2)
  NONE




                                 - - - - SEGMENTATION DATA - - - -

                                        COORDINATES IN METERS

                         I+ AND I- INDICATE THE SEGMENTS BEFORE AND AFTER I


  SEG.   COORDINATES OF SEG. CENTER     SEG.     ORIENTATION ANGLES    WIRE    CONNECTION DATA   TAG
  NO.       X         Y         Z       LENGTH     ALPHA     BETA      RADIUS    I-   I    I+    NO.
     1    .00000    .00000  -1.87500    .25000   90.00000    .00000    .01000     0    1    2      1
     2    .00000    .00000  -1.62500    .25000   90.00000    .00000    .01000     1    2    3      1
     3    .00000    .00000  -1.37500    .25000   90.00000    .00000    .01000     2    3    4      1
     4    .00000    .00000  -1.12500    .25000   90.00000    .00000    .01000     3    4    5      1
     5    .00000    .00000   -.87500    .25000   90.00000    .00000    .01000     4    5    6      1
     6    .00000    .00000   -.62500    .25000   90.00000    .00000    .01000     5    6    7      1
     7    .00000    .00000   -.37500    .25000   90.00000    .00000    .01000     6    7    8      1
     8    .00000    .00000   -.12500    .25000   90.00000    .00000    .01000     7    8    9      1
     9    .00000    .00000    .75000   1.50000   90.00000    .00000    .01000     8    9   10      2
    10    .00000    .00000   2.25000   1.50000   90.00000    .00000    .01000     9   10   11      2
    11    .00000    .00000   3.75000   1.50000   90.00000    .00000    .01000    10   11   12      2
    12    .00000    .00000   5.25000   1.50000   90.00000    .00000    .01000    11   12   13      2
    13    .00000    .00000   6.75000   1.50000   90.00000    .00000    .01000    12   13   14      2
    14    .00000    .00000   8.25000   1.50000   90.00000    .00000    .01000    13   14   15      2
    15    .00000    .00000   9.75000   1.50000   90.00000    .00000    .01000    14   15   16      2
    16    .00000    .00000  11.25000   1.50000   90.00000    .00000    .01000    15   16   17      2
    17    .00000    .00000  12.75000   1.50000   90.00000    .00000    .01000    16   17   18      2
    18    .00000    .00000  14.25000   1.50000   90.00000    .00000    .01000    17   18    0      2




 ***** INPUT LINE  1  FR   0    1    0    0  5.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  2  GN   2    0    0    0  1.00000E+01  1.00000E-02  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
                                             0.00000E+00  SOMEX10.NEC                             
 ***** INPUT LINE  3  EX   0    2    1    0  1.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  4  RP   0   19    2 1002  0.00000E+00  0.00000E+00  5.00000E+00  9.00000E+01  0.00000E+00  0.00000E+00




                                 - - - - - - FREQUENCY - - - - - -

                                    FREQUENCY= 5.0000E+00 MHZ
                                    WAVELENGTH= 5.9960E+01 METERS



                                  - - - ANTENNA ENVIRONMENT - - -

                                        FINITE GROUND.  SOMMERFELD SOLUTION
                                        RELATIVE DIELECTRIC CONST.= 10.000
                                        CONDUCTIVITY= 1.000E-02 MHOS/METER
                                        COMPLEX DIELECTRIC CONSTANT= 1.00000E+01-3.59510E+01



                               - - - STRUCTURE IMPEDANCE LOADING - - -

                                   THIS STRUCTURE IS NOT LOADED



                                - - - MATRIX TIMING - - -

                        FILL=     .560 SEC.,  FACTOR=     .000 SEC.



                                          - - - ANTENNA INPUT PARAMETERS - - -

   TAG   SEG.    VOLTAGE (VOLTS)         CURRENT (AMPS)         IMPEDANCE (OHMS)        ADMITTANCE (MHOS)      POWER
   NO.   NO.    REAL        IMAG.       REAL        IMAG.       REAL        IMAG.       REAL        IMAG.     (WATTS)
     2     9 1.00000E+00 0.00000E+00 8.92869E-03-3.54504E-03 9.67472E+01 3.84125E+01 8.92869E-03-3.54504E-03 4.46435E-03



                             - - - CURRENTS AND LOCATION - - -

                     LENGTHS NORMALIZED BY WAVELENGTH (OR 2.*PI/CABS(K))

  SEG.  TAG    COORD. OF SEG. CENTER     SEG.            - - - CURRENT (AMPS) - - -
  NO.   NO.     X        Y        Z      LENGTH     REAL        IMAG.       MAG.        PHASE
     1    1    .0000    .0000   -.1910   .02547   6.8675E-04 -5.9398E-04  9.0798E-04  -40.857
     2    1    .0000    .0000   -.1656   .02547   1.7691E-03 -1.4821E-03  2.3079E-03  -39.954
     3    1    .0000    .0000   -.1401   .02547   2.7892E-03 -2.2227E-03  3.5665E-03  -38.551
     4    1    .0000    .0000   -.1146   .02547   3.8210E-03 -2.8438E-03  4.7631E-03  -36.658
     5    1    .0000    .0000   -.0891   .02547   4.8850E-03 -3.3285E-03  5.9112E-03  -34.270
     6    1    .0000    .0000   -.0637   .02547   5.9915E-03 -3.6542E-03  7.0179E-03  -31.379
     7    1    .0000    .0000   -.0382   .02547   7.1441E-03 -3.7955E-03  8.0898E-03  -27.981
     8    1    .0000    .0000   -.0127   .02547   8.3406E-03 -3.7249E-03  9.1346E-03  -24.065
     9    2    .0000    .0000    .0125   .02502   8.9287E-03 -3.5450E-03  9.6067E-03  -21.655
    10    2    .0000    .0000    .0375   .02502   8.7241E-03 -3.6490E-03  9.4565E-03  -22.698
    11    2    .0000    .0000    .0625   .02502   8.3168E-03 -3.6494E-03  9.0822E-03  -23.692
    12    2    .0000    .0000    .0876   .02502   7.7163E-03 -3.5106E-03  8.4773E-03  -24.464
    13    2    .0000    .0000    .1126   .02502   6.9354E-03 -3.2496E-03  7.6590E-03  -25.106
    14    2    .0000    .0000    .1376   .02502   5.9898E-03 -2.8775E-03  6.6452E-03  -25.659
    15    2    .0000    .0000    .1626   .02502   4.8976E-03 -2.4044E-03  5.4559E-03  -26.148
    16    2    .0000    .0000    .1876   .02502   3.6768E-03 -1.8403E-03  4.1117E-03  -26.589
    17    2    .0000    .0000    .2126   .02502   2.3412E-03 -1.1926E-03  2.6275E-03  -26.993
    18    2    .0000    .0000    .2377   .02502   8.6184E-04 -4.4608E-04  9.7044E-04  -27.366



                                        - - - POWER BUDGET - - -

                                           INPUT POWER   = 4.4643E-03 WATTS
                                           RADIATED POWER= 4.4643E-03 WATTS
                                           WIRE LOSS     = 0.0000E+00 WATTS
                                           EFFICIENCY    = 100.00 PERCENT



                                                - - - RADIATION PATTERNS - - -

  - - ANGLES - -          - POWER GAINS -        - - - POLARIZATION - - -    - - - E(THETA) - - -    - - - E(PHI) - - -
  THETA     PHI        VERT.   HOR.    TOTAL      AXIAL     TILT   SENSE     MAGNITUDE    PHASE      MAGNITUDE    PHASE 
 DEGREES  DEGREES       DB      DB      DB        RATIO     DEG.               VOLTS     DEGREES       VOLTS     DEGREES


   AVERAGE POWER GAIN= 3.21443E-01       SOLID ANGLE USED IN AVERAGING=(  .5000)*PI STERADIANS.

   POWER RADIATED ASSUMING RADIATION INTO 4*PI STERADIANS = 1.43504E-03 WATTS






 ***** INPUT LINE  5  NE   0    1    1   21  5.00000E+03  0.00000E+00  1.00000E-01  0.00000E+00  0.00000E+00  1.00000E+01



                                      - - - NEAR ELECTRIC FIELDS - - -

              -  LOCATION  -                     -  EX  -               -  EY  -               -  EZ  -
        X           Y           Z           MAGNITUDE   PHASE      MAGNITUDE   PHASE      MAGNITUDE   PHASE
      METERS      METERS      METERS         VOLTS/M   DEGREES      VOLTS/M   DEGREES      VOLTS/M   DEGREES
     5000.0000       .0000       .1000     1.7187E-06    -8.44    3.4802E-12   169.37    1.0534E-05   -44.98
     5000.0000       .0000     10.1000     1.6534E-06    -7.35    3.2555E-12   174.13    9.5769E-06   -36.49
     5000.0000       .0000     20.1000     1.5922E-06    -6.75    3.0578E-12   179.11    8.8683E-06   -26.86
     5000.0000       .0000     30.1000     1.5328E-06    -6.52    2.8875E-12  -175.70    8.4460E-06   -16.37
     5000.0000       .0000     40.1000     1.4739E-06    -6.56    2.7447E-12  -170.35    8.3241E-06    -5.62
     5000.0000       .0000     50.1000     1.4172E-06    -7.04    2.6294E-12  -164.88    8.4941E-06     4.66
     5000.0000       .0000     60.1000     1.3620E-06    -7.93    2.5407E-12  -159.37    8.9146E-06    13.85
     5000.0000       .0000     70.1000     1.3076E-06    -9.15    2.4778E-12  -153.93    9.5379E-06    21.64
     5000.0000       .0000     80.1000     1.2563E-06   -10.96    2.4389E-12  -148.63    1.0311E-05    28.00
     5000.0000       .0000     90.1000     1.2071E-06   -13.25    2.4219E-12  -143.59    1.1189E-05    33.05
     5000.0000       .0000    100.1000     1.1616E-06   -16.11    2.4242E-12  -138.87    1.2135E-05    37.00
     5000.0000       .0000    110.1000     1.1190E-06   -19.47    2.4431E-12  -134.55    1.3129E-05    40.00
     5000.0000       .0000    120.1000     1.0799E-06   -23.31    2.4763E-12  -130.67    1.4152E-05    42.23
     5000.0000       .0000    130.1000     1.0481E-06   -27.53    2.5274E-12  -127.34    1.5198E-05    43.73
     5000.0000       .0000    140.1000     1.0212E-06   -32.51    2.5824E-12  -124.39    1.6243E-05    44.76
     5000.0000       .0000    150.1000     9.9916E-07   -38.03    2.6413E-12  -121.83    1.7282E-05    45.36
     5000.0000       .0000    160.1000     9.8406E-07   -43.99    2.7053E-12  -119.69    1.8315E-05    45.56
     5000.0000       .0000    170.1000     9.8050E-07   -50.46    2.7730E-12  -117.96    1.9338E-05    45.41
     5000.0000       .0000    180.1000     9.8656E-07   -57.21    2.8430E-12  -116.61    2.0350E-05    44.94
     5000.0000       .0000    190.1000     1.0008E-06   -64.05    2.9144E-12  -115.61    2.1349E-05    44.18
     5000.0000       .0000    200.1000     1.0285E-06   -71.04    2.9861E-12  -114.94    2.2333E-05    43.18




 ***** INPUT LINE  6  NH   0    1    1   21  5.00000E+03  0.00000E+00  1.00000E-01  0.00000E+00  0.00000E+00  1.00000E+01



                                      - - - NEAR MAGNETIC FIELDS - - -

              -  LOCATION  -                     -  HX  -               -  HY  -               -  HZ  -
        X           Y           Z           MAGNITUDE   PHASE      MAGNITUDE   PHASE      MAGNITUDE   PHASE
      METERS      METERS      METERS          AMPS/M   DEGREES       AMPS/M   DEGREES       AMPS/M   DEGREES
     5000.0000       .0000       .1000     9.3146E-16  -150.32    2.8468E-08   134.73    9.2705E-15   169.03
     5000.0000       .0000     10.1000     8.8256E-16  -148.54    2.5875E-08   143.11    8.6591E-15   173.79
     5000.0000       .0000     20.1000     8.3568E-16  -146.89    2.4213E-08   153.20    8.1402E-15   178.76
     5000.0000       .0000     30.1000     7.8008E-16  -145.33    2.2729E-08   163.54    7.6929E-15  -176.02
     5000.0000       .0000     40.1000     7.2995E-16  -143.97    2.2828E-08   174.75    7.3080E-15  -170.70
     5000.0000       .0000     50.1000     7.0029E-16  -142.78    2.2693E-08  -175.98    7.0068E-15  -165.20
     5000.0000       .0000     60.1000     6.4484E-16  -142.29    2.4361E-08  -167.24    6.7664E-15  -159.75
     5000.0000       .0000     70.1000     6.1277E-16  -141.33    2.5323E-08  -159.62    6.6074E-15  -154.24
     5000.0000       .0000     80.1000     5.5647E-16  -141.67    2.7750E-08  -152.30    6.4979E-15  -148.94
     5000.0000       .0000     90.1000     5.2949E-16  -141.27    2.9523E-08  -147.96    6.4502E-15  -143.96
     5000.0000       .0000    100.1000     4.7084E-16  -143.41    3.2485E-08  -143.10    6.4573E-15  -139.12
     5000.0000       .0000    110.1000     4.6854E-16  -141.39    3.4257E-08  -140.67    6.4967E-15  -134.99
     5000.0000       .0000    120.1000     4.1031E-16  -145.49    3.8167E-08  -138.25    6.6078E-15  -130.93
     5000.0000       .0000    130.1000     4.7884E-16   153.85    3.9999E-08  -137.50    6.7222E-15  -127.74
     5000.0000       .0000    140.1000     3.4115E-16  -148.42    4.3483E-08  -136.09    6.8926E-15  -124.62
     5000.0000       .0000    150.1000     3.1434E-16  -151.55    4.6169E-08  -134.98    7.0675E-15  -122.03
     5000.0000       .0000    160.1000     2.6164E-16  -164.79    4.8007E-08  -134.76    7.1978E-15  -120.04
     5000.0000       .0000    170.1000     2.6638E-16  -156.74    5.1892E-08  -135.75    7.3915E-15  -118.26
     5000.0000       .0000    180.1000     2.3289E-16  -167.19    5.3902E-08  -135.61    7.5539E-15  -116.94
     5000.0000       .0000    190.1000     2.0603E-16   179.50    5.6054E-08  -136.02    7.7675E-15  -115.92
     5000.0000       .0000    200.1000     1.9307E-16   164.56    5.8815E-08  -136.66    7.9555E-15  -115.23




 ***** INPUT LINE  7  NX   0    0    0    0  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
1



                                ***********************************************
                                *                                             *
                                *  NUMERICAL ELECTROMAGNETICS CODE (NEC-4.1)  *
                                *                                             *
                                ***********************************************




                      **********************************************************

                          6-Wire Radial-Wire Ground Screen.                                            
                          An NGF file is written to take advantage of symmetry of the screen.          

                      **********************************************************





                                 - - - STRUCTURE SPECIFICATION - - -

                                     COORDINATES MUST BE INPUT IN
                                     METERS OR BE SCALED TO METERS
                                     BEFORE STRUCTURE INPUT IS ENDED


  WIRE                                                                               NO. OF    FIRST  LAST     TAG
  NO.        X1         Y1         Z1          X2         Y2         Z2      RADIUS   SEG.     SEG.   SEG.     NO.
     1   12.00000     .00000    -.05000      .80000     .00000    -.05000     .01000     14        1    14       1
     2     .80000     .00000    -.05000      .00000     .00000     .00000     .01000      1       15    15       1
      STRUCTURE ROTATED ABOUT Z-AXIS  6 TIMES.  LABELS INCREMENTED BY    0

   TOTAL SEGMENTS USED=   90     NO. SEG. IN A SYMMETRIC CELL=   15     SYMMETRY FLAG= -1
 STRUCTURE HAS   6 FOLD ROTATIONAL SYMMETRY



         - MULTIPLE WIRE JUNCTIONS -
 JUNCTION    SEGMENTS  (- FOR END 1, + FOR END 2)
     1        15   30   45   60   75   90




                                 - - - - SEGMENTATION DATA - - - -

                                        COORDINATES IN METERS

                         I+ AND I- INDICATE THE SEGMENTS BEFORE AND AFTER I


  SEG.   COORDINATES OF SEG. CENTER     SEG.     ORIENTATION ANGLES    WIRE    CONNECTION DATA   TAG
  NO.       X         Y         Z       LENGTH     ALPHA     BETA      RADIUS    I-   I    I+    NO.
     1  11.60000    .00000   -.05000    .80000     .00000 180.00000    .01000     0    1    2      1
     2  10.80000    .00000   -.05000    .80000     .00000 180.00000    .01000     1    2    3      1
     3  10.00000    .00000   -.05000    .80000     .00000 180.00000    .01000     2    3    4      1
     4   9.20000    .00000   -.05000    .80000     .00000 180.00000    .01000     3    4    5      1
     5   8.40000    .00000   -.05000    .80000     .00000 180.00000    .01000     4    5    6      1
     6   7.60000    .00000   -.05000    .80000     .00000 180.00000    .01000     5    6    7      1
     7   6.80000    .00000   -.05000    .80000     .00000 180.00000    .01000     6    7    8      1
     8   6.00000    .00000   -.05000    .80000     .00000 180.00000    .01000     7    8    9      1
     9   5.20000    .00000   -.05000    .80000     .00000 180.00000    .01000     8    9   10      1
    10   4.40000    .00000   -.05000    .80000     .00000 180.00000    .01000     9   10   11      1
    11   3.60000    .00000   -.05000    .80000     .00000 180.00000    .01000    10   11   12      1
    12   2.80000    .00000   -.05000    .80000     .00000 180.00000    .01000    11   12   13      1
    13   2.00000    .00000   -.05000    .80000     .00000 180.00000    .01000    12   13   14      1
    14   1.20000    .00000   -.05000    .80000     .00000 180.00000    .01000    13   14   15      1
    15    .40000    .00000   -.02500    .80156    3.57633 180.00000    .01000    14   15  -30      1
    16   5.80000  10.04589   -.05000    .80000     .00000-120.00001    .01000     0   16   17      1
    17   5.40000   9.35308   -.05000    .80000     .00000-120.00001    .01000    16   17   18      1
    18   5.00000   8.66025   -.05000    .80000     .00000-120.00001    .01000    17   18   19      1
    19   4.60000   7.96743   -.05000    .80000     .00000-120.00001    .01000    18   19   20      1
    20   4.20000   7.27461   -.05000    .80000     .00000-119.99999    .01000    19   20   21      1
    21   3.80000   6.58179   -.05000    .80000     .00000-120.00001    .01000    20   21   22      1
    22   3.40000   5.88897   -.05000    .80000     .00000-120.00001    .01000    21   22   23      1
    23   3.00000   5.19615   -.05000    .80000     .00000-120.00001    .01000    22   23   24      1
    24   2.60000   4.50333   -.05000    .80000     .00000-120.00001    .01000    23   24   25      1
    25   2.20000   3.81051   -.05000    .80000     .00000-120.00001    .01000    24   25   26      1
    26   1.80000   3.11769   -.05000    .80000     .00000-120.00001    .01000    25   26   27      1
    27   1.40000   2.42487   -.05000    .80000     .00000-120.00001    .01000    26   27   28      1
    28   1.00000   1.73205   -.05000    .80000     .00000-119.99999    .01000    27   28   29      1
    29    .60000   1.03923   -.05000    .80000     .00000-119.99999    .01000    28   29   30      1
    30    .20000    .34641   -.02500    .80156    3.57633-120.00001    .01000    29   30  -45      1
    31  -5.80000  10.04589   -.05000    .80000     .00000 -60.00000    .01000     0   31   32      1
    32  -5.40000   9.35307   -.05000    .80000     .00000 -59.99997    .01000    31   32   33      1
    33  -5.00000   8.66025   -.05000    .80000     .00000 -60.00000    .01000    32   33   34      1
    34  -4.60000   7.96743   -.05000    .80000     .00000 -59.99999    .01000    33   34   35      1
    35  -4.20000   7.27461   -.05000    .80000     .00000 -60.00000    .01000    34   35   36      1
    36  -3.80000   6.58179   -.05000    .80000     .00000 -59.99999    .01000    35   36   37      1
    37  -3.40000   5.88897   -.05000    .80000     .00000 -59.99999    .01000    36   37   38      1
    38  -3.00000   5.19615   -.05000    .80000     .00000 -60.00000    .01000    37   38   39      1
    39  -2.60000   4.50333   -.05000    .80000     .00000 -59.99999    .01000    38   39   40      1
    40  -2.20000   3.81051   -.05000    .80000     .00000 -60.00000    .01000    39   40   41      1
    41  -1.80000   3.11769   -.05000    .80000     .00000 -60.00000    .01000    40   41   42      1
    42  -1.40000   2.42487   -.05000    .80000     .00000 -60.00000    .01000    41   42   43      1
    43  -1.00000   1.73205   -.05000    .80000     .00000 -59.99999    .01000    42   43   44      1
    44   -.60000   1.03923   -.05000    .80000     .00000 -60.00000    .01000    43   44   45      1
    45   -.20000    .34641   -.02500    .80156    3.57633 -60.00000    .01000    44   45  -60      1
    46 -11.60000    .00000   -.05000    .80000     .00000    .00000    .01000     0   46   47      1
    47 -10.80000    .00000   -.05000    .80000     .00000    .00003    .01000    46   47   48      1
    48 -10.00000    .00000   -.05000    .80000     .00000    .00000    .01000    47   48   49      1
    49  -9.20000    .00000   -.05000    .80000     .00000    .00002    .01000    48   49   50      1
    50  -8.40000    .00000   -.05000    .80000     .00000    .00000    .01000    49   50   51      1
    51  -7.60000    .00000   -.05000    .80000     .00000    .00002    .01000    50   51   52      1
    52  -6.80000    .00000   -.05000    .80000     .00000    .00002    .01000    51   52   53      1
    53  -6.00000    .00000   -.05000    .80000     .00000    .00000    .01000    52   53   54      1
    54  -5.20000    .00000   -.05000    .80000     .00000    .00002    .01000    53   54   55      1
    55  -4.40000    .00000   -.05000    .80000     .00000    .00000    .01000    54   55   56      1
    56  -3.60000    .00000   -.05000    .80000     .00000    .00001    .01000    55   56   57      1
    57  -2.80000    .00000   -.05000    .80000     .00000    .00000    .01000    56   57   58      1
    58  -2.00000    .00000   -.05000    .80000     .00000    .00002    .01000    57   58   59      1
    59  -1.20000    .00000   -.05000    .80000     .00000    .00001    .01000    58   59   60      1
    60   -.40000    .00000   -.02500    .80156    3.57633    .00001    .01000    59   60  -75      1
    61  -5.80000 -10.04590   -.05000    .80000     .00000  60.00000    .01000     0   61   62      1
    62  -5.40000  -9.35308   -.05000    .80000     .00000  60.00001    .01000    61   62   63      1
    63  -5.00000  -8.66026   -.05000    .80000     .00000  60.00003    .01000    62   63   64      1
    64  -4.60000  -7.96743   -.05000    .80000     .00000  60.00002    .01000    63   64   65      1
    65  -4.20000  -7.27461   -.05000    .80000     .00000  59.99999    .01000    64   65   66      1
    66  -3.80000  -6.58179   -.05000    .80000     .00000  60.00004    .01000    65   66   67      1
    67  -3.40000  -5.88897   -.05000    .80000     .00000  60.00002    .01000    66   67   68      1
    68  -3.00000  -5.19615   -.05000    .80000     .00000  60.00000    .01000    67   68   69      1
    69  -2.60000  -4.50333   -.05000    .80000     .00000  60.00002    .01000    68   69   70      1
    70  -2.20000  -3.81051   -.05000    .80000     .00000  60.00000    .01000    69   70   71      1
    71  -1.80000  -3.11769   -.05000    .80000     .00000  60.00002    .01000    70   71   72      1
    72  -1.40000  -2.42487   -.05000    .80000     .00000  60.00000    .01000    71   72   73      1
    73  -1.00000  -1.73205   -.05000    .80000     .00000  60.00002    .01000    72   73   74      1
    74   -.60000  -1.03923   -.05000    .80000     .00000  60.00002    .01000    73   74   75      1
    75   -.20000   -.34641   -.02500    .80156    3.57633  60.00001    .01000    74   75  -90      1
    76   5.80000 -10.04589   -.05000    .80000     .00000 120.00001    .01000     0   76   77      1
    77   5.40000  -9.35307   -.05000    .80000     .00000 120.00003    .01000    76   77   78      1
    78   5.00000  -8.66025   -.05000    .80000     .00000 120.00003    .01000    77   78   79      1
    79   4.60000  -7.96743   -.05000    .80000     .00000 120.00002    .01000    78   79   80      1
    80   4.20000  -7.27461   -.05000    .80000     .00000 120.00001    .01000    79   80   81      1
    81   3.80000  -6.58179   -.05000    .80000     .00000 120.00003    .01000    80   81   82      1
    82   3.40000  -5.88897   -.05000    .80000     .00000 120.00003    .01000    81   82   83      1
    83   3.00000  -5.19615   -.05000    .80000     .00000 120.00002    .01000    82   83   84      1
    84   2.60000  -4.50333   -.05000    .80000     .00000 120.00002    .01000    83   84   85      1
    85   2.20000  -3.81051   -.05000    .80000     .00000 120.00001    .01000    84   85   86      1
    86   1.80000  -3.11769   -.05000    .80000     .00000 120.00002    .01000    85   86   87      1
    87   1.40000  -2.42487   -.05000    .80000     .00000 120.00001    .01000    86   87   88      1
    88   1.00000  -1.73205   -.05000    .80000     .00000 120.00003    .01000    87   88   89      1
    89    .60000  -1.03923   -.05000    .80000     .00000 120.00002    .01000    88   89   90      1
    90    .20000   -.34641   -.02500    .80156    3.57633 120.00002    .01000    89   90  -15      1




 ***** INPUT LINE  1  FR   0    1    0    0  5.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  2  GN   2    0    0    0  1.00000E+01  1.00000E-02  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
                                             0.00000E+00  SOMEX10.NEC                             
 ***** INPUT LINE  3  WG   0    0    0    0  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00




                                 - - - - - - FREQUENCY - - - - - -

                                    FREQUENCY= 5.0000E+00 MHZ
                                    WAVELENGTH= 5.9960E+01 METERS



                                  - - - ANTENNA ENVIRONMENT - - -

                                        FINITE GROUND.  SOMMERFELD SOLUTION
                                        RELATIVE DIELECTRIC CONST.= 10.000
                                        CONDUCTIVITY= 1.000E-02 MHOS/METER
                                        COMPLEX DIELECTRIC CONSTANT= 1.00000E+01-3.59510E+01



                               - - - STRUCTURE IMPEDANCE LOADING - - -

                                   THIS STRUCTURE IS NOT LOADED



                                - - - MATRIX TIMING - - -

                        FILL=    2.920 SEC.,  FACTOR=     .020 SEC.



 ****NUMERICAL GREEN'S FUNCTION WRITTEN ON FILE NGFS.NEC                                                              
     MATRIX STORAGE -   1350 COMPLEX NUMBERS



 ***** INPUT LINE  4  NX   0    0    0    0  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
1



                                ***********************************************
                                *                                             *
                                *  NUMERICAL ELECTROMAGNETICS CODE (NEC-4.1)  *
                                *                                             *
                                ***********************************************




                      **********************************************************

                          15 m Monopole added to the ground screen from the NGF file.                  

                      **********************************************************







     ************************************************************************************
     ************************************************************************************
     **                                                                                **
     ** NUMERICAL GREEN'S FUNCTION FILE                                                **
     ** NO. SEGMENTS =  90          NO. PATCHES =   0                                  **
     ** NO. SYMMETRIC SECTIONS =   6                                                   **
     ** N.G.F. MATRIX -  CORE STORAGE =   1350 COMPLEX NUMBERS,  CASE 2                **
     ** FREQUENCY = 5.00000E+00 MHZ.                                                   **
     ** FINITE GROUND.  SOMMERFELD SOLUTION                                            **
     ** GROUND PARAMETERS - DIELECTRIC CONSTANT = 1.00000E+01                          **
     **                     CONDUCTIVITY = 1.00000E-02 MHOS/M.                         **
     **                                                                                **
     **  6-Wire Radial-Wire Ground Screen.                                             **
     **  An NGF file is written to take advantage of symmetry of the screen.           **
     **                                                                                **
     ************************************************************************************
     ************************************************************************************








                                 - - - STRUCTURE SPECIFICATION - - -

                                     COORDINATES MUST BE INPUT IN
                                     METERS OR BE SCALED TO METERS
                                     BEFORE STRUCTURE INPUT IS ENDED


  WIRE                                                                               NO. OF    FIRST  LAST     TAG
  NO.        X1         Y1         Z1          X2         Y2         Z2      RADIUS   SEG.     SEG.   SEG.     NO.
     1     .00000     .00000     .00000      .00000     .00000   15.00000     .01000     10       91   100       2

   TOTAL SEGMENTS USED=  100     NO. SEG. IN A SYMMETRIC CELL=  100     SYMMETRY FLAG=  0


         - MULTIPLE WIRE JUNCTIONS -
 JUNCTION    SEGMENTS  (- FOR END 1, + FOR END 2)
     1        15   30   45   60   75   90  -91




                                 - - - - SEGMENTATION DATA - - - -

                                        COORDINATES IN METERS

                         I+ AND I- INDICATE THE SEGMENTS BEFORE AND AFTER I


  SEG.   COORDINATES OF SEG. CENTER     SEG.     ORIENTATION ANGLES    WIRE    CONNECTION DATA   TAG
  NO.       X         Y         Z       LENGTH     ALPHA     BETA      RADIUS    I-   I    I+    NO.
     1  11.60000    .00000   -.05000    .80000     .00000 180.00000    .01000     0    1    2      1
     2  10.80000    .00000   -.05000    .80000     .00000 180.00000    .01000     1    2    3      1
     3  10.00000    .00000   -.05000    .80000     .00000 180.00000    .01000     2    3    4      1
     4   9.20000    .00000   -.05000    .80000     .00000 180.00000    .01000     3    4    5      1
     5   8.40000    .00000   -.05000    .80000     .00000 180.00000    .01000     4    5    6      1
     6   7.60000    .00000   -.05000    .80000     .00000 180.00000    .01000     5    6    7      1
     7   6.80000    .00000   -.05000    .80000     .00000 180.00000    .01000     6    7    8      1
     8   6.00000    .00000   -.05000    .80000     .00000 180.00000    .01000     7    8    9      1
     9   5.20000    .00000   -.05000    .80000     .00000 180.00000    .01000     8    9   10      1
    10   4.40000    .00000   -.05000    .80000     .00000 180.00000    .01000     9   10   11      1
    11   3.60000    .00000   -.05000    .80000     .00000 180.00000    .01000    10   11   12      1
    12   2.80000    .00000   -.05000    .80000     .00000 180.00000    .01000    11   12   13      1
    13   2.00000    .00000   -.05000    .80000     .00000 180.00000    .01000    12   13   14      1
    14   1.20000    .00000   -.05000    .80000     .00000 180.00000    .01000    13   14   15      1
    15    .40000    .00000   -.02500    .80156    3.57633-180.00000    .01000    14   15  -30      1
    16   5.80000  10.04589   -.05000    .80000     .00000-120.00003    .01000     0   16   17      1
    17   5.40000   9.35308   -.05000    .80000     .00000-120.00001    .01000    16   17   18      1
    18   5.00000   8.66025   -.05000    .80000     .00000-120.00001    .01000    17   18   19      1
    19   4.60000   7.96743   -.05000    .80000     .00000-120.00001    .01000    18   19   20      1
    20   4.20000   7.27461   -.05000    .80000     .00000-119.99996    .01000    19   20   21      1
    21   3.80000   6.58179   -.05000    .80000     .00000-120.00002    .01000    20   21   22      1
    22   3.40000   5.88897   -.05000    .80000     .00000-120.00001    .01000    21   22   23      1
    23   3.00000   5.19615   -.05000    .80000     .00000-120.00001    .01000    22   23   24      1
    24   2.60000   4.50333   -.05000    .80000     .00000-120.00002    .01000    23   24   25      1
    25   2.20000   3.81051   -.05000    .80000     .00000-119.99999    .01000    24   25   26      1
    26   1.80000   3.11769   -.05000    .80000     .00000-120.00001    .01000    25   26   27      1
    27   1.40000   2.42487   -.05000    .80000     .00000-120.00001    .01000    26   27   28      1
    28   1.00000   1.73205   -.05000    .80000     .00000-119.99999    .01000    27   28   29      1
    29    .60000   1.03923   -.05000    .80000     .00000-119.99999    .01000    28   29   30      1
    30    .20000    .34641   -.02500    .80156    3.57633-120.00001    .01000    29   30  -45      1
    31  -5.80000  10.04589   -.05000    .80000     .00000 -60.00000    .01000     0   31   32      1
    32  -5.40000   9.35307   -.05000    .80000     .00000 -59.99997    .01000    31   32   33      1
    33  -5.00000   8.66025   -.05000    .80000     .00000 -60.00000    .01000    32   33   34      1
    34  -4.60000   7.96743   -.05000    .80000     .00000 -59.99997    .01000    33   34   35      1
    35  -4.20000   7.27461   -.05000    .80000     .00000 -60.00002    .01000    34   35   36      1
    36  -3.80000   6.58179   -.05000    .80000     .00000 -59.99999    .01000    35   36   37      1
    37  -3.40000   5.88897   -.05000    .80000     .00000 -59.99999    .01000    36   37   38      1
    38  -3.00000   5.19615   -.05000    .80000     .00000 -60.00002    .01000    37   38   39      1
    39  -2.60000   4.50333   -.05000    .80000     .00000 -59.99997    .01000    38   39   40      1
    40  -2.20000   3.81051   -.05000    .80000     .00000 -60.00000    .01000    39   40   41      1
    41  -1.80000   3.11769   -.05000    .80000     .00000 -60.00001    .01000    40   41   42      1
    42  -1.40000   2.42487   -.05000    .80000     .00000 -60.00000    .01000    41   42   43      1
    43  -1.00000   1.73205   -.05000    .80000     .00000 -59.99997    .01000    42   43   44      1
    44   -.60000   1.03923   -.05000    .80000     .00000 -60.00000    .01000    43   44   45      1
    45   -.20000    .34641   -.02500    .80156    3.57633 -60.00000    .01000    44   45  -60      1
    46 -11.60000    .00000   -.05000    .80000     .00000    .00000    .01000     0   46   47      1
    47 -10.80000    .00000   -.05000    .80000     .00000    .00003    .01000    46   47   48      1
    48 -10.00000    .00000   -.05000    .80000     .00000    .00000    .01000    47   48   49      1
    49  -9.20000    .00000   -.05000    .80000     .00000    .00002    .01000    48   49   50      1
    50  -8.40000    .00000   -.05000    .80000     .00000    .00000    .01000    49   50   51      1
    51  -7.60000    .00000   -.05000    .80000     .00000    .00002    .01000    50   51   52      1
    52  -6.80000    .00000   -.05000    .80000     .00000    .00002    .01000    51   52   53      1
    53  -6.00000    .00000   -.05000    .80000     .00000    .00000    .01000    52   53   54      1
    54  -5.20000    .00000   -.05000    .80000     .00000    .00002    .01000    53   54   55      1
    55  -4.40000    .00000   -.05000    .80000     .00000    .00000    .01000    54   55   56      1
    56  -3.60000    .00000   -.05000    .80000     .00000    .00001    .01000    55   56   57      1
    57  -2.80000    .00000   -.05000    .80000     .00000    .00000    .01000    56   57   58      1
    58  -2.00000    .00000   -.05000    .80000     .00000    .00002    .01000    57   58   59      1
    59  -1.20000    .00000   -.05000    .80000     .00000    .00001    .01000    58   59   60      1
    60   -.40000    .00000   -.02500    .80156    3.57633    .00001    .01000    59   60  -75      1
    61  -5.80000 -10.04590   -.05000    .80000     .00000  59.99997    .01000     0   61   62      1
    62  -5.40000  -9.35308   -.05000    .80000     .00000  59.99997    .01000    61   62   63      1
    63  -5.00000  -8.66026   -.05000    .80000     .00000  60.00006    .01000    62   63   64      1
    64  -4.60000  -7.96743   -.05000    .80000     .00000  60.00000    .01000    63   64   65      1
    65  -4.20000  -7.27461   -.05000    .80000     .00000  60.00000    .01000    64   65   66      1
    66  -3.80000  -6.58179   -.05000    .80000     .00000  60.00004    .01000    65   66   67      1
    67  -3.40000  -5.88897   -.05000    .80000     .00000  60.00004    .01000    66   67   68      1
    68  -3.00000  -5.19615   -.05000    .80000     .00000  60.00000    .01000    67   68   69      1
    69  -2.60000  -4.50333   -.05000    .80000     .00000  60.00000    .01000    68   69   70      1
    70  -2.20000  -3.81051   -.05000    .80000     .00000  60.00000    .01000    69   70   71      1
    71  -1.80000  -3.11769   -.05000    .80000     .00000  60.00002    .01000    70   71   72      1
    72  -1.40000  -2.42487   -.05000    .80000     .00000  60.00000    .01000    71   72   73      1
    73  -1.00000  -1.73205   -.05000    .80000     .00000  60.00002    .01000    72   73   74      1
    74   -.60000  -1.03923   -.05000    .80000     .00000  60.00002    .01000    73   74   75      1
    75   -.20000   -.34641   -.02500    .80156    3.57633  60.00002    .01000    74   75  -90      1
    76   5.80000 -10.04589   -.05000    .80000     .00000 120.00001    .01000     0   76   77      1
    77   5.40000  -9.35307   -.05000    .80000     .00000 120.00003    .01000    76   77   78      1
    78   5.00000  -8.66025   -.05000    .80000     .00000 120.00003    .01000    77   78   79      1
    79   4.60000  -7.96743   -.05000    .80000     .00000 120.00003    .01000    78   79   80      1
    80   4.20000  -7.27461   -.05000    .80000     .00000 119.99998    .01000    79   80   81      1
    81   3.80000  -6.58179   -.05000    .80000     .00000 120.00003    .01000    80   81   82      1
    82   3.40000  -5.88897   -.05000    .80000     .00000 120.00003    .01000    81   82   83      1
    83   3.00000  -5.19615   -.05000    .80000     .00000 119.99999    .01000    82   83   84      1
    84   2.60000  -4.50333   -.05000    .80000     .00000 120.00003    .01000    83   84   85      1
    85   2.20000  -3.81051   -.05000    .80000     .00000 120.00001    .01000    84   85   86      1
    86   1.80000  -3.11769   -.05000    .80000     .00000 120.00002    .01000    85   86   87      1
    87   1.40000  -2.42487   -.05000    .80000     .00000 120.00001    .01000    86   87   88      1
    88   1.00000  -1.73205   -.05000    .80000     .00000 120.00005    .01000    87   88   89      1
    89    .60000  -1.03923   -.05000    .80000     .00000 120.00002    .01000    88   89   90      1
    90    .20000   -.34641   -.02500    .80156    3.57633 120.00002    .01000    89   90   91      1
    91    .00000    .00000    .75000   1.50000   90.00000 100.17654    .01000    15   91   92      2
    92    .00000    .00000   2.25000   1.50000   90.00000    .00000    .01000    91   92   93      2
    93    .00000    .00000   3.75000   1.50000   90.00000    .00000    .01000    92   93   94      2
    94    .00000    .00000   5.25000   1.50000   90.00000    .00000    .01000    93   94   95      2
    95    .00000    .00000   6.75000   1.50000   90.00000    .00000    .01000    94   95   96      2
    96    .00000    .00000   8.25000   1.50000   90.00000    .00000    .01000    95   96   97      2
    97    .00000    .00000   9.75000   1.50000   90.00000    .00000    .01000    96   97   98      2
    98    .00000    .00000  11.25000   1.50000   90.00000    .00000    .01000    97   98   99      2
    99    .00000    .00000  12.75000   1.50000   90.00000    .00000    .01000    98   99  100      2
   100    .00000    .00000  14.25000   1.50000   90.00000    .00000    .01000    99  100    0      2


 N.G.F. - NUMBER OF NEW UNKNOWNS IS  16




 ***** INPUT LINE  1  EX   0    2    1    0  1.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00
 ***** INPUT LINE  2  RP   0   19    2 1001  0.00000E+00  0.00000E+00  5.00000E+00  9.00000E+01  0.00000E+00  0.00000E+00




                                 - - - - - - FREQUENCY - - - - - -

                                    FREQUENCY= 5.0000E+00 MHZ
                                    WAVELENGTH= 5.9960E+01 METERS



                                  - - - ANTENNA ENVIRONMENT - - -

                                        FINITE GROUND.  SOMMERFELD SOLUTION
                                        RELATIVE DIELECTRIC CONST.= 10.000
                                        CONDUCTIVITY= 1.000E-02 MHOS/METER
                                        COMPLEX DIELECTRIC CONSTANT= 1.00000E+01-3.59510E+01



                               - - - STRUCTURE IMPEDANCE LOADING - - -

                                   THIS STRUCTURE IS NOT LOADED



                                - - - MATRIX TIMING - - -

                        FILL=    5.260 SEC.,  FACTOR=     .180 SEC.



                                          - - - ANTENNA INPUT PARAMETERS - - -

   TAG   SEG.    VOLTAGE (VOLTS)         CURRENT (AMPS)         IMPEDANCE (OHMS)        ADMITTANCE (MHOS)      POWER
   NO.   NO.    REAL        IMAG.       REAL        IMAG.       REAL        IMAG.       REAL        IMAG.     (WATTS)
     2    91 1.00000E+00 0.00000E+00 1.42846E-02-7.78769E-03 5.39656E+01 2.94209E+01 1.42846E-02-7.78769E-03 7.14232E-03



                             - - - CURRENTS AND LOCATION - - -

                     LENGTHS NORMALIZED BY WAVELENGTH (OR 2.*PI/CABS(K))

  SEG.  TAG    COORD. OF SEG. CENTER     SEG.            - - - CURRENT (AMPS) - - -
  NO.   NO.     X        Y        Z      LENGTH     REAL        IMAG.       MAG.        PHASE
     1    1   1.1818    .0000   -.0051   .08150   3.6076E-05 -1.1057E-04  1.1631E-04  -71.930
     2    1   1.1003    .0000   -.0051   .08150   5.0396E-05 -2.7345E-04  2.7806E-04  -79.558
     3    1   1.0188    .0000   -.0051   .08150   2.8497E-05 -4.0279E-04  4.0379E-04  -85.953
     4    1    .9373    .0000   -.0051   .08150  -6.5444E-06 -5.1470E-04  5.1474E-04  -90.728
     5    1    .8558    .0000   -.0051   .08150  -3.9153E-05 -6.2064E-04  6.2188E-04  -93.610
     6    1    .7743    .0000   -.0051   .08150  -5.6324E-05 -7.3121E-04  7.3338E-04  -94.405
     7    1    .6928    .0000   -.0051   .08150  -4.5531E-05 -8.5499E-04  8.5620E-04  -93.048
     8    1    .6113    .0000   -.0051   .08150   6.4908E-06 -9.9672E-04  9.9674E-04  -89.627
     9    1    .5298    .0000   -.0051   .08150   1.1413E-04 -1.1554E-03  1.1610E-03  -84.359
    10    1    .4483    .0000   -.0051   .08150   2.9220E-04 -1.3222E-03  1.3541E-03  -77.539
    11    1    .3668    .0000   -.0051   .08150   5.5377E-04 -1.4790E-03  1.5793E-03  -69.473
    12    1    .2853    .0000   -.0051   .08150   9.0588E-04 -1.5969E-03  1.8360E-03  -60.436
    13    1    .2038    .0000   -.0051   .08150   1.3424E-03 -1.6385E-03  2.1182E-03  -50.674
    14    1    .1223    .0000   -.0051   .08150   1.8333E-03 -1.5642E-03  2.4099E-03  -40.470
    15    1    .0408    .0000   -.0025   .08166   2.2800E-03 -1.3732E-03  2.6616E-03  -31.059
    16    1    .5909   1.0235   -.0051   .08150   3.6076E-05 -1.1057E-04  1.1631E-04  -71.930
    17    1    .5501    .9529   -.0051   .08150   5.0396E-05 -2.7345E-04  2.7806E-04  -79.558
    18    1    .5094    .8823   -.0051   .08150   2.8497E-05 -4.0279E-04  4.0379E-04  -85.953
    19    1    .4686    .8117   -.0051   .08150  -6.5447E-06 -5.1470E-04  5.1474E-04  -90.729
    20    1    .4279    .7411   -.0051   .08150  -3.9153E-05 -6.2065E-04  6.2188E-04  -93.610
    21    1    .3871    .6705   -.0051   .08150  -5.6325E-05 -7.3121E-04  7.3338E-04  -94.405
    22    1    .3464    .6000   -.0051   .08150  -4.5531E-05 -8.5499E-04  8.5620E-04  -93.048
    23    1    .3056    .5294   -.0051   .08150   6.4904E-06 -9.9672E-04  9.9674E-04  -89.627
    24    1    .2649    .4588   -.0051   .08150   1.1413E-04 -1.1554E-03  1.1610E-03  -84.359
    25    1    .2241    .3882   -.0051   .08150   2.9220E-04 -1.3222E-03  1.3541E-03  -77.539
    26    1    .1834    .3176   -.0051   .08150   5.5377E-04 -1.4790E-03  1.5793E-03  -69.473
    27    1    .1426    .2470   -.0051   .08150   9.0588E-04 -1.5969E-03  1.8360E-03  -60.436
    28    1    .1019    .1765   -.0051   .08150   1.3424E-03 -1.6385E-03  2.1182E-03  -50.674
    29    1    .0611    .1059   -.0051   .08150   1.8334E-03 -1.5642E-03  2.4099E-03  -40.470
    30    1    .0204    .0353   -.0025   .08166   2.2800E-03 -1.3732E-03  2.6616E-03  -31.059
    31    1   -.5909   1.0235   -.0051   .08150   3.6076E-05 -1.1057E-04  1.1631E-04  -71.930
    32    1   -.5501    .9529   -.0051   .08150   5.0396E-05 -2.7345E-04  2.7806E-04  -79.558
    33    1   -.5094    .8823   -.0051   .08150   2.8497E-05 -4.0279E-04  4.0379E-04  -85.953
    34    1   -.4686    .8117   -.0051   .08150  -6.5445E-06 -5.1470E-04  5.1474E-04  -90.728
    35    1   -.4279    .7411   -.0051   .08150  -3.9153E-05 -6.2064E-04  6.2188E-04  -93.610
    36    1   -.3871    .6705   -.0051   .08150  -5.6325E-05 -7.3121E-04  7.3338E-04  -94.405
    37    1   -.3464    .6000   -.0051   .08150  -4.5532E-05 -8.5499E-04  8.5620E-04  -93.048
    38    1   -.3056    .5294   -.0051   .08150   6.4895E-06 -9.9672E-04  9.9674E-04  -89.627
    39    1   -.2649    .4588   -.0051   .08150   1.1412E-04 -1.1554E-03  1.1610E-03  -84.359
    40    1   -.2241    .3882   -.0051   .08150   2.9220E-04 -1.3222E-03  1.3541E-03  -77.539
    41    1   -.1834    .3176   -.0051   .08150   5.5376E-04 -1.4790E-03  1.5793E-03  -69.473
    42    1   -.1426    .2470   -.0051   .08150   9.0588E-04 -1.5969E-03  1.8360E-03  -60.436
    43    1   -.1019    .1765   -.0051   .08150   1.3424E-03 -1.6385E-03  2.1182E-03  -50.674
    44    1   -.0611    .1059   -.0051   .08150   1.8334E-03 -1.5642E-03  2.4100E-03  -40.470
    45    1   -.0204    .0353   -.0025   .08166   2.2800E-03 -1.3732E-03  2.6616E-03  -31.059
    46    1  -1.1818    .0000   -.0051   .08150   3.6076E-05 -1.1057E-04  1.1631E-04  -71.930
    47    1  -1.1003    .0000   -.0051   .08150   5.0396E-05 -2.7345E-04  2.7806E-04  -79.558
    48    1  -1.0188    .0000   -.0051   .08150   2.8497E-05 -4.0279E-04  4.0379E-04  -85.953
    49    1   -.9373    .0000   -.0051   .08150  -6.5445E-06 -5.1470E-04  5.1474E-04  -90.728
    50    1   -.8558    .0000   -.0051   .08150  -3.9153E-05 -6.2065E-04  6.2188E-04  -93.610
    51    1   -.7743    .0000   -.0051   .08150  -5.6324E-05 -7.3121E-04  7.3338E-04  -94.405
    52    1   -.6928    .0000   -.0051   .08150  -4.5531E-05 -8.5499E-04  8.5620E-04  -93.048
    53    1   -.6113    .0000   -.0051   .08150   6.4907E-06 -9.9672E-04  9.9674E-04  -89.627
    54    1   -.5298    .0000   -.0051   .08150   1.1413E-04 -1.1554E-03  1.1610E-03  -84.359
    55    1   -.4483    .0000   -.0051   .08150   2.9220E-04 -1.3222E-03  1.3541E-03  -77.539
    56    1   -.3668    .0000   -.0051   .08150   5.5377E-04 -1.4790E-03  1.5793E-03  -69.473
    57    1   -.2853    .0000   -.0051   .08150   9.0588E-04 -1.5969E-03  1.8360E-03  -60.436
    58    1   -.2038    .0000   -.0051   .08150   1.3424E-03 -1.6385E-03  2.1182E-03  -50.674
    59    1   -.1223    .0000   -.0051   .08150   1.8333E-03 -1.5642E-03  2.4099E-03  -40.470
    60    1   -.0408    .0000   -.0025   .08166   2.2800E-03 -1.3732E-03  2.6616E-03  -31.059
    61    1   -.5909  -1.0235   -.0051   .08150   3.6076E-05 -1.1057E-04  1.1631E-04  -71.930
    62    1   -.5501   -.9529   -.0051   .08150   5.0396E-05 -2.7345E-04  2.7806E-04  -79.558
    63    1   -.5094   -.8823   -.0051   .08150   2.8497E-05 -4.0279E-04  4.0379E-04  -85.953
    64    1   -.4686   -.8117   -.0051   .08150  -6.5444E-06 -5.1470E-04  5.1474E-04  -90.728
    65    1   -.4279   -.7411   -.0051   .08150  -3.9153E-05 -6.2064E-04  6.2188E-04  -93.610
    66    1   -.3871   -.6705   -.0051   .08150  -5.6326E-05 -7.3121E-04  7.3338E-04  -94.405
    67    1   -.3464   -.6000   -.0051   .08150  -4.5532E-05 -8.5499E-04  8.5620E-04  -93.048
    68    1   -.3056   -.5294   -.0051   .08150   6.4898E-06 -9.9672E-04  9.9674E-04  -89.627
    69    1   -.2649   -.4588   -.0051   .08150   1.1413E-04 -1.1554E-03  1.1610E-03  -84.359
    70    1   -.2241   -.3882   -.0051   .08150   2.9220E-04 -1.3222E-03  1.3541E-03  -77.539
    71    1   -.1834   -.3176   -.0051   .08150   5.5376E-04 -1.4790E-03  1.5793E-03  -69.473
    72    1   -.1426   -.2470   -.0051   .08150   9.0588E-04 -1.5969E-03  1.8360E-03  -60.436
    73    1   -.1019   -.1765   -.0051   .08150   1.3424E-03 -1.6385E-03  2.1182E-03  -50.674
    74    1   -.0611   -.1059   -.0051   .08150   1.8333E-03 -1.5642E-03  2.4100E-03  -40.470
    75    1   -.0204   -.0353   -.0025   .08166   2.2800E-03 -1.3732E-03  2.6616E-03  -31.059
    76    1    .5909  -1.0235   -.0051   .08150   3.6076E-05 -1.1057E-04  1.1631E-04  -71.930
    77    1    .5501   -.9529   -.0051   .08150   5.0396E-05 -2.7345E-04  2.7806E-04  -79.558
    78    1    .5094   -.8823   -.0051   .08150   2.8497E-05 -4.0279E-04  4.0379E-04  -85.953
    79    1    .4686   -.8117   -.0051   .08150  -6.5445E-06 -5.1470E-04  5.1474E-04  -90.728
    80    1    .4279   -.7411   -.0051   .08150  -3.9153E-05 -6.2064E-04  6.2188E-04  -93.610
    81    1    .3871   -.6705   -.0051   .08150  -5.6325E-05 -7.3121E-04  7.3338E-04  -94.405
    82    1    .3464   -.6000   -.0051   .08150  -4.5532E-05 -8.5499E-04  8.5620E-04  -93.048
    83    1    .3056   -.5294   -.0051   .08150   6.4896E-06 -9.9672E-04  9.9674E-04  -89.627
    84    1    .2649   -.4588   -.0051   .08150   1.1412E-04 -1.1554E-03  1.1610E-03  -84.359
    85    1    .2241   -.3882   -.0051   .08150   2.9220E-04 -1.3222E-03  1.3541E-03  -77.539
    86    1    .1834   -.3176   -.0051   .08150   5.5376E-04 -1.4790E-03  1.5793E-03  -69.473
    87    1    .1426   -.2470   -.0051   .08150   9.0588E-04 -1.5969E-03  1.8360E-03  -60.436
    88    1    .1019   -.1765   -.0051   .08150   1.3424E-03 -1.6385E-03  2.1182E-03  -50.674
    89    1    .0611   -.1059   -.0051   .08150   1.8334E-03 -1.5642E-03  2.4100E-03  -40.470
    90    1    .0204   -.0353   -.0025   .08166   2.2800E-03 -1.3732E-03  2.6616E-03  -31.059
    91    2    .0000    .0000    .0125   .02502   1.4285E-02 -7.7877E-03  1.6270E-02  -28.598
    92    2    .0000    .0000    .0375   .02502   1.3937E-02 -7.9289E-03  1.6034E-02  -29.637
    93    2    .0000    .0000    .0625   .02502   1.3266E-02 -7.8306E-03  1.5405E-02  -30.552
    94    2    .0000    .0000    .0876   .02502   1.2292E-02 -7.4686E-03  1.4383E-02  -31.284
    95    2    .0000    .0000    .1126   .02502   1.1034E-02 -6.8682E-03  1.2997E-02  -31.901
    96    2    .0000    .0000    .1376   .02502   9.5187E-03 -6.0495E-03  1.1278E-02  -32.437
    97    2    .0000    .0000    .1626   .02502   7.7748E-03 -5.0324E-03  9.2613E-03  -32.914
    98    2    .0000    .0000    .1876   .02502   5.8311E-03 -3.8370E-03  6.9803E-03  -33.346
    99    2    .0000    .0000    .2126   .02502   3.7095E-03 -2.4780E-03  4.4611E-03  -33.744
   100    2    .0000    .0000    .2377   .02502   1.3643E-03 -9.2409E-04  1.6478E-03  -34.111



                                        - - - POWER BUDGET - - -

                                           INPUT POWER   = 7.1423E-03 WATTS
                                           RADIATED POWER= 7.1423E-03 WATTS
                                           WIRE LOSS     = 0.0000E+00 WATTS
                                           EFFICIENCY    = 100.00 PERCENT



                                                - - - RADIATION PATTERNS - - -

  - - ANGLES - -          - POWER GAINS -        - - - POLARIZATION - - -    - - - E(THETA) - - -    - - - E(PHI) - - -
  THETA     PHI        VERT.   HOR.    TOTAL      AXIAL     TILT   SENSE     MAGNITUDE    PHASE      MAGNITUDE    PHASE 
 DEGREES  DEGREES       DB      DB      DB        RATIO     DEG.               VOLTS     DEGREES       VOLTS     DEGREES
     .00      .00    -154.93 -153.40 -151.09     .03880    50.02  RIGHT     1.17336E-08   147.29    1.39877E-08   142.77
    5.00      .00     -21.08 -153.32  -21.08     .00000      .00  LINEAR    5.77876E-02    60.79    1.41134E-08   144.85
   10.00      .00     -15.05 -153.42  -15.05     .00000      .00  LINEAR    1.15672E-01    60.70    1.39590E-08   134.92
   15.00      .00     -11.52 -155.97  -11.52     .00000      .00  LINEAR    1.73698E-01    60.56    1.04097E-08   158.35
   20.00      .00      -9.01 -155.40   -9.01     .00000      .00  LINEAR    2.31808E-01    60.36    1.11182E-08   130.42
   25.00      .00      -7.08 -155.66   -7.08     .00000      .00  LINEAR    2.89789E-01    60.11    1.07832E-08   147.48
   30.00      .00      -5.50 -155.33   -5.50     .00000      .00  LINEAR    3.47229E-01    59.79    1.12095E-08   132.26
   35.00      .00      -4.20 -155.32   -4.20     .00000      .00  LINEAR    4.03467E-01    59.41    1.12141E-08   133.62
   40.00      .00      -3.11 -157.79   -3.11     .00000      .00  LINEAR    4.57553E-01    58.95    8.44353E-09   155.84
   45.00      .00      -2.20 -157.66   -2.20     .00000      .00  LINEAR    5.08199E-01    58.41    8.56284E-09   140.95
   50.00      .00      -1.45 -157.12   -1.45     .00000      .00  LINEAR    5.53725E-01    57.76    9.11611E-09   152.72
   55.00      .00       -.87 -158.64    -.87     .00000      .00  LINEAR    5.91968E-01    56.96    7.65399E-09   153.62
   60.00      .00       -.47 -161.31    -.47     .00000      .00  LINEAR    6.20125E-01    55.97    5.62733E-09   149.46
   65.00      .00       -.27 -161.17    -.27     .00000      .00  LINEAR    6.34409E-01    54.69    5.72143E-09   147.74
   70.00      .00       -.34 -165.59    -.34     .00000      .00  LINEAR    6.29306E-01    52.97    3.43861E-09   153.84
   75.00      .00       -.81 -165.58    -.81     .00000      .00  LINEAR    5.95800E-01    50.54    3.44093E-09   157.86
   80.00      .00      -2.05 -169.35   -2.05     .00000      .00  LINEAR    5.16753E-01    46.82    2.23053E-09   146.53
   85.00      .00      -5.35 -174.07   -5.35     .00000      .00  LINEAR    3.53274E-01    40.50    1.29457E-09   173.49
   90.00      .00    -128.26 -999.99 -128.26     .00000      .00  LINEAR    2.52768E-07  -157.26    4.76642E-16   144.35
     .00    90.00    -153.40 -154.93 -151.09     .03880   -39.98  RIGHT     1.39877E-08   142.77    1.17336E-08   -32.71
    5.00    90.00     -21.08 -155.30  -21.08     .00000      .00  LINEAR    5.77876E-02    60.79    1.12466E-08   -32.91
   10.00    90.00     -15.05 -155.00  -15.05     .00000      .00  LINEAR    1.15672E-01    60.70    1.16385E-08   -20.72
   15.00    90.00     -11.52 -155.90  -11.52     .00000      .00  LINEAR    1.73698E-01    60.56    1.04946E-08   -30.53
   20.00    90.00      -9.01 -157.16   -9.01     .00000      .00  LINEAR    2.31808E-01    60.36    9.07230E-09   -43.84
   25.00    90.00      -7.08 -157.50   -7.08     .00000      .00  LINEAR    2.89789E-01    60.11    8.72773E-09   -10.61
   30.00    90.00      -5.50 -156.29   -5.50     .00000      .00  LINEAR    3.47229E-01    59.79    1.00338E-08   -22.64
   35.00    90.00      -4.20 -156.92   -4.20     .00000      .00  LINEAR    4.03467E-01    59.41    9.32455E-09   -30.44
   40.00    90.00      -3.11 -159.83   -3.11     .00000      .00  LINEAR    4.57552E-01    58.95    6.67625E-09   -46.30
   45.00    90.00      -2.20 -158.38   -2.20     .00000      .00  LINEAR    5.08198E-01    58.41    7.88195E-09   -17.16
   50.00    90.00      -1.45 -161.50   -1.45     .00000      .00  LINEAR    5.53724E-01    57.76    5.50450E-09   -17.56
   55.00    90.00       -.87 -160.85    -.87     .00000      .00  LINEAR    5.91968E-01    56.96    5.93233E-09   -13.54
   60.00    90.00       -.47 -162.74    -.47     .00000      .00  LINEAR    6.20124E-01    55.97    4.77348E-09    -5.88
   65.00    90.00       -.27 -161.11    -.27     .00000      .00  LINEAR    6.34408E-01    54.69    5.75874E-09   -13.63
   70.00    90.00       -.34 -163.02    -.34     .00000      .00  LINEAR    6.29304E-01    52.97    4.62301E-09   -10.03
   75.00    90.00       -.81 -167.45    -.81     .00000      .00  LINEAR    5.95798E-01    50.54    2.77417E-09    -5.72
   80.00    90.00      -2.05 -173.22   -2.05     .00000      .00  LINEAR    5.16752E-01    46.82    1.42839E-09   -21.30
   85.00    90.00      -5.35 -177.28   -5.35     .00000      .00  LINEAR    3.53273E-01    40.50    8.94632E-10   -11.65
   90.00    90.00    -128.26 -999.99 -128.26     .00000      .00  LINEAR    2.52768E-07  -157.26    4.43123E-16   -11.59


   AVERAGE POWER GAIN= 5.82049E-01       SOLID ANGLE USED IN AVERAGING=(  .5000)*PI STERADIANS.

   POWER RADIATED ASSUMING RADIATION INTO 4*PI STERADIANS = 4.15718E-03 WATTS






 ***** INPUT LINE  3  EN   0    0    0    0  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00  0.00000E+00

 RUN TIME =    49.140
