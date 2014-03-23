These nec2dXS executables are based on the nec2dX executables
made available by Ramond Anderson.

They were changed so that the SomNec ground calculations are 
integrated in the nec-2 engine. 
This means that no som2d.nec file is generated any more and 
the required data is stored internally.

Because of the performance of most modern computers, the
SomNec ground calculations do not take much time any more
(typically less than 1 sec). So there is no special need
for re-using the pre-generated SomNec data.

Furthermore it is now possible to recalculate the SomNec data
for each step in the Frequency-loop/sweep. This was not
possible with earlier versions of the nec2d(x) engine.

Note however that when requesting a sweep for a large number
of steps, each step requires about 1 sec of additional ground
calculation. When using for instance a sweep from 3 to 30 Mhz
with 0.1 Mhz increment this will require 27*10*1 = 270 seconds
(4.5 minutes) of additional calculation time.

It is still possible to use the 'negative conductivity' trick.
If specified the SomNec calculation is only done once, prior
to running the frequency-loop. This will decrease the precision
back to the original nec2d precision, but will speed-up the
calculation time.

V1.0	17-may-2002	Initial exe's created.
V2.0	07-oct-2002	Not released.
V2.1	22-oct-2002	MaxLD increased to MaxSeg,
			Max_EX to 99 and Max_TL to 64
V2.2	03-feb-2003	Used DJGPP compiler port for 
			performance increase.
 		  