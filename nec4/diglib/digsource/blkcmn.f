      block data blkcmn
      character FNAME*80
      logical LNOPLT
      include 'gcfont.cmn'
      common /GD4010/ IOHIY, IOLOY, IOHIX
      data IOHIY,IOLOY,IOHIX/3*-1/
      include 'gcsidx.dat'
      include 'gccstd.dat'
      data icfontslot/1/, maxslot/1/
      data islotfont/1,numz*0/, iheight(1)/8/
c
c     Initialization for delayed dump of PostScript files.
c     Not part of standard DIGLIB
c
      COMMON/POSTDCM/LUNPOS,INITPOST,LNOPLT,FNAME
      DATA INITPOST/0/
      end
