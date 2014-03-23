      subroutine seldev(lun)
      character*1 bname(40)
c     
c     show the device numbers and their names and ask for
c     a device number. attempt to select that device. if
c     not successful, display an error message and ask for
c     a new device number.
c     
      external len
c     
c     display device numbers and names.
c     
      print 91
 91   format(/)
      idev = 1
 110  call gsdnam(idev,bname)
      l = len(bname)
      if (l .eq. 0) go to 120
      print 111, idev, (bname(i), i=1,l)
 111  format('Device ',i2,' is ',40a1)
      idev = idev + 1
      go to 110
 120  continue
      
c     ask for a device number.
      
      print 91
 5    print 121
 121  format('Graphics device number? ',$)
      read(5,122) idev
 122  format(i5)
      
c     select that device.
      
      call devsel(idev,lun,ierr)
      
      if (ierr .eq. 0) go to 200
      
      print 131
 131  format('That device is not available at this time !')
      go to 5
      
 200  continue
      
      return
      end
