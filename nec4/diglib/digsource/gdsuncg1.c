/*
 *	PROGRAM		 : The device dependent DIGLIB driver for Sun Windows
 *
 *	Author		 : Brian K. Cabral
 *               Modified:  Steve Azevedo 12/22/86
 *
 *	Date		 : August , 1984
 * 
 *	Dependencies	 : The device driver depends on SunView libraries
 *			   as well as the predefined data 
 *			   structures.  These data structures and libraries 
 *			   are written in an object oriented style.  Thus to 
 *		 	   think of data and code as being a single object 
 *			   clarifies the conceptual design of this driver.
 *			   NOTE: This driver works best in a graphics sub-
 *			   window of gfxtool.
 *                         Also, this driver detects if you have a color or
 *                         monochrome display and does the right thing.
 *
 *	Function	 : This is a DigLib device driver for the Sun Work-
 *                         stations.  Unlike most devices supported by
 *			   DigLib these devices are conceptual entities managed
 *			   by mulitple layers of windowing software.
 *			   One can think of each Sun graphics (as opposed to
 *			   text) window as virtual devices.
 *			   What the Sun window system does is to
 *			   provide a sophisticated interface to the bit mapped
 *			   physical display, allowing higher level programs
 *			   graphics libraries to act on the virtual devices
 * 			   (i.e. the graphics sun windows).
 *
 *	Notes		 : This routine is written in a much different style 
 *         		   than the other DigLib device drivers.  This due to
 *			   two reasons: 
 *
 *                            1) The device is really a window manager
 *			         and requires C data structures and inter-
 *                               faces.
 * 
 *                            2) Since the driver is written in C anyway,
 *                               one can exploit C constructs to provide
 *                               more elegant and efficient driver.
 */


/*	   All DigLib drivers have only one routine or function.
 *	This function parses an integer op-code(ifxn) and performs
 *	some action based on the op-code.   Since this driver is written
 *	in C (unlike the rest of DigLib) we can perfrom the parsing and
 *	call to the action routine in one step.  Instead of parsing the
 *	op-code with a case statement what is done is to have an array
 *	of pointers to functions which represent the action.  Thus an
 *	op-code becomes a mere index into a jump table; one statement in-
 *	stead of a dozen or so.
 */

#include <stdio.h>
#include <suntool/tool_hs.h>
#include <suntool/gfx_hs.h>

/*
 *	Some global definitions.
 */
#define MAX_OPCODE 13		/* number of op-code values */
#define X_SIZE_CM       28.0	/* x size of the device (in cm.) */
#define Y_SIZE_CM       21.0	/* y size of the device (in cm.) */
#define X_RES          640.0    /* x resolution of the device */
#define Y_RES          480.0    /* y resolution of the device */
#define BACKGRD_COLOR 0		/* background color */
#define FOREGRD_COLOR 1		/* foreground color */


/* Set up device characteristic data array */
static float characteristics[] = { 640.480,	/* device id */
                            X_SIZE_CM,		/* x axis length in cm */
                            Y_SIZE_CM,	 	/* y axis length in cm */
                            X_RES/X_SIZE_CM,	/* dots per cm in x */
                            Y_RES/Y_SIZE_CM,	/* dots per cm in y */
                             8.0,       /* number of foreground colors */
                           197.0,       /* magic number (device abilities) */
                             1.0        /* lines to skip during fill */
                          };

#define X_LENGTH      1		/* loc in char array of length in cm. */
#define Y_LENGTH      2
#define X_DOTS_PER_CM 3		/* loc in characteristics array of dots/cm */
#define Y_DOTS_PER_CM 4
#define FG_COLORS     5		/* loc in characteristics array of fg colors */



/* Some static suntools data */
static char *null_argv[4] = { " ", "-d", "/dev/cgone0", 0 };
static struct gfxsubwindow *gfx = NULL;
static struct rect          screen_size;


/* Set up globals and constants used in world to device transformations */
static float  min_x,   max_x;
static float  min_y,   max_y;
static float  scale_x, scale_y;
static int current_x, current_y;     /* the current (x,y) "beam" position */
static int color_bits;		/* Number of bits of color */
static int current_color = FOREGRD_COLOR;	/* current color for drawing */

/* Global variables for returning graphics inputs */
static struct inputevent input_data;
static char   char_hit;


/* Set up the data structures for a cross hair cursor */
static short cursor_data[16] = {
         0x0000, 0x0100, 0x0100, 0x0100, 0x0100, 0x0100, 0x0100, 0x0000,
         0xFD7E, 0x0000, 0x0100, 0x0100, 0x0100, 0x0100, 0x0100, 0x0100
      };
     mpr_static(suncg1_cursor_image, 16, 16, 1, cursor_data);

     static struct cursor cross_hair_cursor = 
     {
        8, 8, PIX_SRC^PIX_DST, &suncg1_cursor_image
     };



/* Pointers to Sun window driver routines for this driver */

extern int suncg1_init_device();	/* initialize device */
extern int suncg1_clear_page();		/* screen clear */
extern int suncg1_move_to();		/* absolute window coordinates */
extern int suncg1_draw_to();		/* absolute window coordinates */
extern int suncg1_flush();		/* flush all pending buffers */
extern int suncg1_release_device();	/* close the sun window */
extern int suncg1_return_device();	/* return device characteristics */
extern int suncg1_select_color();	/* set the current forground color */
extern int suncg1_get_input();		/* get input, null routine */
extern int suncg1_set_color_map_rgb();	/* set up a rgb color look up table */
extern int suncg1_set_color_map_hls();	/* set up a hls color look up table */
extern int suncg1_button_input();	/* a routine to handle button input */
extern int suncg1_draw_polygon();	/* draw a closed polygon */



gdsuncg1_( op_code, x_data, y_data )

int    *op_code;                    /* holds the device independent op-code */
float         (* x_data)[],         /* x coordinate data */
                      (* y_data)[]; /* y coordinate data */
{
   /* An array of pointers to function */
   /*  i.e. a jump table that is global to this compilation unit */
   static int (* jump_table[MAX_OPCODE])() = {
                 suncg1_init_device,
                 suncg1_clear_page,
                 suncg1_move_to,
                 suncg1_draw_to,
                 suncg1_flush,
                 suncg1_release_device,
                 suncg1_return_device,
                 suncg1_select_color,
                 suncg1_get_input,
                 suncg1_set_color_map_rgb,
                 suncg1_set_color_map_hls,
                 suncg1_button_input,
                 suncg1_draw_polygon };

   if (*op_code > 1024)		/* Check for correct op-code, and run */
      jump_table[MAX_OPCODE-1]( op_code, x_data, y_data );

   if ( (0 <= *op_code) && (*op_code <= MAX_OPCODE-1) )
      jump_table[*op_code-1]( op_code, x_data, y_data );

}	/* end main driver function */


suncg1_set_size()
{
   win_getsize( gfx->gfx_windowfd, &screen_size );

   min_x   = 0.0;
   max_x   = (screen_size.r_width-1)  / characteristics[X_DOTS_PER_CM];
   min_y   = 0.0;
   max_y   = (screen_size.r_height-1) / characteristics[Y_DOTS_PER_CM];
   
   characteristics[X_LENGTH] = max_x;
   characteristics[Y_LENGTH] = max_y;
   
   scale_x = ( screen_size.r_width  - 1.0 ) / ( max_x - min_x );
   scale_y = - ( screen_size.r_height - 1.0 ) / ( max_y - min_y );
   /* ( the negative sign is there because the screen coordinates start */
   /*   at  0 at top, increasing going down, which is opposite of what  */
   /*   you want ).                                                     */
}


suncg1_catch_signal()
{
   int dummy, six = 6;
   gfxsw_handlesigwinch( gfx );
   suncg1_set_size();
   gsdrvr_(&six,&dummy,&dummy);
}


suncg1_init_device( op_code, x_data, y_data )

int   *op_code;
float (* x_data)[], (* y_data)[];
{
   if ( gfx == NULL )		/* if first time thru the init device */
   {
      if ( (gfx = gfxsw_init(0, null_argv)) == NULL )
      {
         printf(" Unable to open graphics window.\n");
         exit(0);
      }
      else
      {
         signal( SIGWINCH, suncg1_catch_signal );
         gfxsw_getretained( gfx );
         win_setcursor( gfx->gfx_windowfd, &cross_hair_cursor);
         color_bits = gfx->gfx_pixwin->pw_pixrect->pr_depth;
         if (color_bits == 1)	/* 1-bits per pixel */
         {
            characteristics[FG_COLORS] = 1.0;
            pw_writebackground(gfx->gfx_pixwin, 
                            0, 0, screen_size.r_width, screen_size.r_height,
                            PIX_SRC );
         }
         else			/* Assume 8-bits per pixel */
         {

            /* Fill the color map with the proper values */
            unsigned char red[8], green[8], blue[8];	/* colormap values */
            pw_setcmsname(gfx->gfx_pixwin, "DIGLIB map");
            red[0] = 0x00; green[0] = 0x00; blue[0] = 0x00;  /* background */
            red[1] = 0xFF; green[1] = 0xFF; blue[1] = 0xFF;  /* foreground */
            red[2] = 0xFF; green[2] = 0x00; blue[2] = 0x00;  /* red */
            red[3] = 0x00; green[3] = 0xFF; blue[3] = 0x00;  /* green */
            red[4] = 0x00; green[4] = 0x00; blue[4] = 0xFF;  /* blue */
            red[5] = 0xFF; green[5] = 0xFF; blue[5] = 0x00;  /* yellow */
            red[6] = 0xFF; green[6] = 0x00; blue[6] = 0xFF;  /* magenta */
            red[7] = 0x00; green[7] = 0xFF; blue[7] = 0xFF;  /* cyan */
            pw_putcolormap(gfx->gfx_pixwin,0,8,red,green,blue);

            characteristics[FG_COLORS] = 255.0;
            pw_writebackground(gfx->gfx_pixwin, 
                            0, 0, screen_size.r_width, screen_size.r_height,
                            PIX_SRC | PIX_COLOR(BACKGRD_COLOR) );
         }
      }
   }

   /* Now fix the correct screen-size */
   suncg1_set_size();
}



suncg1_clear_page( op_code,  x_data, y_data )

int   *op_code;
float (* x_data)[], (* y_data)[];
{
   if (color_bits == 1)		/* Monochrome */
   {
      pw_writebackground(gfx->gfx_pixwin, 
                         0, 0, screen_size.r_width, screen_size.r_height,
                         PIX_SRC );
   }
   else				/* Color */
   {
      pw_writebackground(gfx->gfx_pixwin, 
                         0, 0, screen_size.r_width, screen_size.r_height,
                         PIX_SRC | PIX_COLOR(BACKGRD_COLOR) );
   }
}



suncg1_move_to( op_code, x_data, y_data )

int   *op_code;
float (* x_data)[], (* y_data)[];
{
   current_x = ( (*x_data)[0] - (max_x + min_x)*0.5 )*scale_x + 
                     (screen_size.r_width + 0.0)*0.5; 
   current_y = ( (*y_data)[0] - (max_y + min_y)*0.5 )*scale_y + 
                     (screen_size.r_height + 0.0)*0.5; 
}



suncg1_draw_to( op_code, x_data, y_data )

int   *op_code;
float (* x_data)[], (* y_data)[];
{
   register int new_x, new_y;

   new_x = ( (*x_data)[0] - (max_x + min_x)*0.5 )*scale_x + 
                 (screen_size.r_width + 0.0)*0.5; 
   new_y = ( (*y_data)[0] - (max_y + min_y)*0.5 )*scale_y + 
                 (screen_size.r_height + 0.0)*0.5; 

   if (color_bits == 1)		/* Monochrome */
   {
      pw_vector( gfx->gfx_pixwin,
                 current_x, current_y, new_x, new_y, 
                 PIX_SRC, 1 );
   }
   else				/* Color */
   {
      pw_vector( gfx->gfx_pixwin,
                 current_x, current_y, new_x, new_y, 
                 PIX_SRC | PIX_COLOR(current_color), current_color );
   }

   current_x = new_x;
   current_y = new_y;
}



suncg1_flush( op_code, x_data, y_data )

int   *op_code;
float (* x_data)[], (* y_data)[];
{
}



suncg1_release_device( op_code, x_data, y_data )

int   *op_code;
float (* x_data)[], (* y_data)[];
{
   /*
    *  This routine should really close out the window system,
    *  there is an error in gfxsw_done which doesn't return
    *  malloc memory for retained windows.  Thus multiple release
    *  devices cause a virtual memory overflow.  So the kluge is not
    *  to release the retained window but to force the application to
    *  call rlsmem  (in rlsmem.c -- stands for release memory ).
    *
    */
}


suncg1_return_device( op_code, x_data, y_data )

int   *op_code;
float (* x_data)[], (* y_data)[];
{
   int i;

   for ( i = 0; i < 8; i++)
   {
      (*x_data)[i] = characteristics[i];
   }
}



suncg1_select_color( op_code, x_data, y_data )

int   *op_code;
float (* x_data)[], (* y_data)[];
{
   if (color_bits != 1)		/* Only if not monochrome */
   {
      current_color = (*x_data)[0];
   }
}



suncg1_check_input(  gfx,  ibits,  obits,  ebits,   timer )

struct gfxsubwindow *gfx;
int                      *ibits, *obits, *ebits;
struct timeval                                   **timer;
{ 
   if ( (1 << gfx->gfx_windowfd) & *ibits )
   {
      win_grabio( gfx->gfx_windowfd );
      input_readevent( gfx->gfx_windowfd, &input_data );
      win_releaseio( gfx->gfx_windowfd );
       
      switch ( input_data.ie_code )
      {
         case MS_LEFT  : {
                             char_hit = ' ';
                             gfxsw_selectdone( gfx );
                             break;
   	                  }

         case MS_MIDDLE : {                    
                             char_hit = 'm';
                             gfxsw_selectdone( gfx );
                             break;
   	                  }

         case MS_RIGHT  : {                    
                             char_hit = 'r';
                             gfxsw_selectdone( gfx );
                             break;
   	                  }

         default        : {
                             break;
	                  }
      }
      *ibits = 0;
      *obits = 0;
      *ebits = 0;
   }
}


suncg1_get_input( op_code, x_data, y_data )

int   *op_code;
float (* x_data)[], (* y_data)[];
{
   struct inputmask im;


   input_imnull( &im );
   win_setinputcodebit( &im, MS_LEFT );
   win_setinputcodebit( &im, MS_MIDDLE );
   win_setinputcodebit( &im, MS_RIGHT);


   gfxsw_setinputmask( gfx, &im, (struct inputmask *)NULL, WIN_NULLLINK, 1, 1 );
   gfxsw_select( gfx, 
                 suncg1_check_input,
                 NULL, NULL, NULL,
                 (struct timeval *)NULL );

   (*x_data)[0] = (float) char_hit;
   (*x_data)[1] = ( input_data.ie_locx - (screen_size.r_width  + 0.0)*0.5 ) /
                  scale_x + (max_x + min_x)*0.5;
   (*x_data)[2] = ( input_data.ie_locy - (screen_size.r_height + 0.0)*0.5 ) /
                  scale_y + (max_y + min_y)*0.5;
}
 


suncg1_set_color_map_rgb( op_code, x_data, y_data )

int   *op_code;
float (* x_data)[], (* y_data)[];
{
}



suncg1_set_color_map_hls( op_code, x_data, y_data )

int   *op_code;
float (* x_data)[], (* y_data)[];
{
}



suncg1_button_input( op_code, x_data, y_data )

int   *op_code;
float (* x_data)[], (* y_data)[];
{
}



suncg1_draw_polygon( op_code, x_data, y_data )

int   *op_code;
float (* x_data)[], (* y_data)[];
{
}
