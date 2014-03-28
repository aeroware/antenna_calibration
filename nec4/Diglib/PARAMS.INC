* This file defines a file parameter block.  It can be used to make calls
* to the low level file routines as described in the File Manager chapter
* of "Inside Macintosh".

	integer*1 params(108)		! Enough for all variants.
	integer iolink
	integer*2 iotype
	integer*2 iotrap
	integer iocmdaddr
	integer iocompletion
	integer*2 ioresult
	integer ionameptr
	integer*2 iovrefnum
	
* Added to above to make up WDPBRec.  HFS only.
	integer*2 filler5
	integer*2 iowdindex
	integer*4 iowdprocid
	integer*2 iowdvrefnum
	integer*2 filler6(7)
	integer*4 iowddirid

* ioParam
	integer*2 iorefnum
	integer*1 ioversnum			! MFS only.
	integer*1 filler1			! HFS only.
	integer*1 iopermssn
	integer iomisc
	integer iobuffer
	integer ioreqcount
	integer ioactcount
	integer*2 ioposmode
	integer ioposoffset
	
* volumeParam
	integer*2 iovolindex
	
* fileParam
	integer*2 iofrefnum
	integer*1 iofversnum			! MFS only.
	integer*1 filler2			! MFS only.
	integer*2 filler3			! HFS only.
	integer*2 iofdirindex
	integer*1 ioflattrib
	integer*1 ioflversnum			! MFS only.
	integer*1 filler4			! HFS only.
	character*4 fdtype
	character*4 fdcreator
	integer*2 fdflags
	integer*2 fdlocation(2)
	integer*2 fdfldr
	integer*4 ioflnum			! MFS only.
	integer*4 iodirid			! HFS only.
	integer*2 ioflstblk
	integer*4 iofllglen
	integer*4 ioflpylen
	integer*2 ioflrstblk
	integer*4 ioflrlglen
	integer*4 ioflrpylen
	integer*4 ioflcrdat
	integer*4 ioflmddat

* Added to fileParam for hFileInfo record of CInfoPBRec
	integer*4 ioflbkdat			! HFS only

* Extra finder info record.
	integer*1 ioflxfndrinfo(14)		! HFS only
	character*4 fdxtype			! HFS only
	character*4 fdxcreator			! HFS only
	integer*2 fdxflags			! HFS only
	integer*2 fdxlocation(2)		! HFS only
	integer*2 fdxfldr			! HFS only

	integer*4 ioflparid			! HFS only
	integer*4 ioflclpsiz			! HFS only
	

* cntrlParam
	integer*2 cscode
	integer*1 csparam(52)

	equivalence (params(1), iolink)
	equivalence (params(5), iotype)
	equivalence (params(7), iotrap)
	equivalence (params(9), iocmdaddr)
	equivalence (params(13), iocompletion)
	equivalence (params(17), ioresult)
	equivalence (params(19), ionameptr)
	equivalence (params(23), iovrefnum)

* Added to above to make up WDPBRec.  HFS only.
	equivalence (params(25), filler5)
	equivalence (params(27), iowdindex)
	equivalence (params(29), iowdprocid)
	equivalence (params(33), iowdvrefnum)
	equivalence (params(35), filler6)
	equivalence (params(49), iowddirid)

	equivalence (params(25), iorefnum)
	equivalence (params(27), ioversnum)
	equivalence (params(27), filler1)
	equivalence (params(28), iopermssn)
	equivalence (params(29), iomisc)
	equivalence (params(33), iobuffer)
	equivalence (params(37), ioreqcount)
	equivalence (params(41), ioactcount)
	equivalence (params(45), ioposmode)
	equivalence (params(47), ioposoffset)
	
	equivalence (params(29), iovolindex)

	equivalence (params(25),iofrefnum)
	equivalence (params(27),iofversnum)
	equivalence (params(28),filler2)
	equivalence (params(27),filler3)
	equivalence (params(29),iofdirindex)
	equivalence (params(31),ioflattrib)
	equivalence (params(32),ioflversnum)
	equivalence (params(32),filler4)
	equivalence (params(33),fdtype)
	equivalence (params(37),fdcreator)
	equivalence (params(41),fdflags)
	equivalence (params(45),fdlocation(1))
	equivalence (params(47),fdfldr)
	equivalence (params(49),ioflnum)
	equivalence (params(49),iodirid)
	equivalence (params(53),ioflstblk)
	equivalence (params(55),iofllglen)
	equivalence (params(59),ioflpylen)
	equivalence (params(63),ioflrstblk)
	equivalence (params(65),ioflrlglen)
	equivalence (params(69),ioflrpylen)
	equivalence (params(73),ioflcrdat)
	equivalence (params(77),ioflmddat)

* Added to fileParam for hFileInfo record of CInfoPBRec
	equivalence (params(81), ioflbkdat)	! HFS only
	equivalence (params(85), ioflxfndrinfo)	! HFS only.
	equivalence (params(85), fdxtype)	! HFS only.
	equivalence (params(89), fdxcreator)	! HFS only.
	equivalence (params(93), fdxflags)	! HFS only.
	equivalence (params(95),fdxlocation)	! HFS only.
	equivalence (params(99), fdxfldr)	! HFS only.
	equivalence (params(101), ioflparid)	! HFS only.
	equivalence (params(105), ioflclpsiz)	! HFS only.
	
	equivalence (params(27),cscode)
	equivalence (params(29),csparam(1))
