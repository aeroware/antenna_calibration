	subroutine scopy(str1,str2)
	character*1 str1(1),str2(2)
	i=0
10	continue
	i=i+1
	str2(i)=str1(i)
	if (str2(i).ne.char(0)) goto 10
	return
	end
