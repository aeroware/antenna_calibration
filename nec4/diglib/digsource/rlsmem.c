#include <suntool/gfx_hs.h>
extern struct gfxsubwindow *gfx;

rlsmem_()
{
   pw_pfsysclose();
   gfxsw_done(gfx);
}
