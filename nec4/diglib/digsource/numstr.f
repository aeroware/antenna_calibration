	SUBROUTINE NUMSTR(JVAL,BSTRNG)
	character*1 BSTRNG(2)
C
C	THIS SUBROUTINE CONVERTS "IVAL" TO A STRING WITH NO LEADING
C	 OR TRAILING SPACES.
C
	character*10 NUMBER
C
	write(number,11) jval
11	FORMAT(I9)
	j=1
	do 100 i=1,9
	  if (number(i:i).eq.' ') goto 100
	  bstrng(j)=number(i:i)
	  j=j+1
100	continue
	bstrng(j)='\0'
	RETURN
	END
