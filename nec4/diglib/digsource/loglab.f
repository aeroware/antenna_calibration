	SUBROUTINE LOGLAB(NUM,STRNG)
	CHARACTER*1 STRNG(*), LLABS(6,8)
	DATA LLABS / '.','0','0','1',2*'\0',
     1   '.','0','1',3*'\0',
     2   '.','1',4*'\0',
     3   '1',5*'\0',
     4   '1','0',4*'\0',
     5   '1','0','0',3*'\0',
     6   '1','0','0','0',2*'\0',
     7   '1','0','0','0','0','\0'/
	IF (NUM .GT. -4 .AND. NUM .LT. 5) GO TO 100
	CALL SCOPY('1E'//char(0),STRNG)
	CALL NUMSTR(NUM,STRNG(3))
	GO TO 200
100	CALL SCOPY(LLABS(1,4+NUM),STRNG)
200	RETURN
	END
