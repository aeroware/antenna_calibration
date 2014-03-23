/*
 *      Program          : The device dependent DIGLIB driver for X Windows
 *
 *      Author           : Steve Azevedo
 *                         Brian Cabral
 *
 *      Date             : Jan 20, 1987
 * 
 *      Dependencies     : The device driver depends on X libraries
 *                         as well as the predefined data structures.
 *
 *      Function         : This is a DigLib device driver for the X Windows
 *                         package.  Unlike most devices supported by
 *                         DigLib these devices are conceptual entities managed
 *                         by mulitple layers of windowing software.
 *                         One can think of each X window as a virtual device.
 *                         What the X window system does is to
 *                         provide a sophisticated interface to the bit mapped
 *                         physical display, allowing higher level programs
 *                         graphics libraries to act on the virtual devices.
 *
 *      Notes            : This routine is written in a much different style 
 *                         than the other DigLib device drivers.  This due to
 *                         two reasons: 
 *
 *                            1) The device is really a window manager
 *                               and requires C data structures and inter-
 *                               faces.
 * 
 *                            2) Since the driver is written in C anyway,
 *                               one can exploit C constructs to provide
 *                               more elegant and efficient driver.
 */


/*         All DigLib drivers have only one routine or function.
 *      This function parses an integer op-code(ifxn) and performs
 *      some action based on the op-code.   Since this driver is written
 *      in C (unlike the rest of DigLib) we can perfrom the parsing and
 *      call to the action routine in one step.  Instead of parsing the
 *      op-code with a case statement what is done is to have an array
 *      of pointers to functions which represent the action.  Thus an
 *      op-code becomes a mere index into a jump table; one statement in-
 *      stead of a dozen or so.
 */

#include <stdio.h>                /* Unix standard I/O definitions */
#include <X/Xlib.h>               /* Xwindows data structures */

/*
 *      Some global definitions.
 */

#define FALSE            0
#define TRUE             1

#define MAX_WINDOWS     16        /* max number of active diglib windows */
#define MAX_OPCODE      13        /* number of op-code values */
#define X_SIZE_CM       33.0      /* x size of the device (in cm.) */
#define Y_SIZE_CM       25.78125  /* y size of the device (in cm.) */
#define X_RES         1024.0      /* x resolution of the device */
#define Y_RES          800.0      /* y resolution of the device */
#define BACKGRD_COLOR    0        /* background color */
#define FOREGRD_COLOR    1        /* foreground color */
#define MAX_COLORS       8        /* size of the color table */

#define X_LENGTH         1        /* loc in char array of length in cm. */
#define Y_LENGTH         2
#define X_DOTS_PER_CM    3        /* loc in characteristics array of dots/cm */
#define Y_DOTS_PER_CM    4
#define FG_COLORS        5        /* loc in characteristics array of fg colors */

#define CURSOR_WIDTH    16        /* Cursor dimensions in pixels */
#define CURSOR_HEIGHT   16

/* Device coordinates <--> Virtual corrdinates, translation macros */

#define x_translate(x) ( ((x) - (max_x[CurrentDiglibWindow] + min_x[CurrentDiglibWindow])*0.5 )*scale_x[CurrentDiglibWindow] + DiglibFrame[CurrentDiglibWindow].width *0.5 )
#define y_translate(y) ( ((y) - (max_y[CurrentDiglibWindow] + min_y[CurrentDiglibWindow])*0.5 )*scale_y[CurrentDiglibWindow] + DiglibFrame[CurrentDiglibWindow].height*0.5 )

#define x_untranslate(x) ( ((x) - DiglibFrame[CurrentDiglibWindow].width *0.5 ) / scale_x[CurrentDiglibWindow] + (max_x[CurrentDiglibWindow] + min_x[CurrentDiglibWindow])*0.5 );
#define y_untranslate(y) ( ((y) - DiglibFrame[CurrentDiglibWindow].height*0.5 ) / scale_y[CurrentDiglibWindow] + (max_y[CurrentDiglibWindow] + min_y[CurrentDiglibWindow])*0.5 );


/* Set up device characteristic data array */

static 
float characteristics[MAX_WINDOWS][8] = 
{
   123.0,           /* device id (unused) */
   X_SIZE_CM,       /* x axis length in cm */
   Y_SIZE_CM,       /* y axis length in cm */
   X_RES/X_SIZE_CM, /* dots per cm in x */
   Y_RES/Y_SIZE_CM, /* dots per cm in y */
   1.0,             /* number of foreground colors */
   1221.0,          /* magic number (device abilities) */
   1.0              /* lines to skip during fill */
};


/* X windows data */

static
int                 DiglibPlanes;                 /* Number of planes in use */

static
int                 DiglibPixels[MAX_COLORS];     /* X color map index */

static
XButtonPressedEvent DiglibEvent;                  /* Button event variable */

static
Cursor              DiglibCursor;                 /* Cursor variable, used in x0_init */

static
WindowInfo          Winfo;                        /* Window information variable, used in x0_resize */

static
char                XServerName[MAX_WINDOWS];     /* The host/server name for a given diglib window */

static
int                 DiglibWindowCount = 1;        /* Number of active diglib windows */

static
int                 CurrentDiglibWindow = 0;      /* Current active diglib window, initial one does not exists so flag it as a minus one */

static
OpaqueFrame         DiglibFrame[MAX_WINDOWS] =
{
   0,               /* window id, filled in when the window is created */
   100, 100,        /* window origin */
   612, 612,        /* window dimensions */
   3,               /* border width */
   0,               /* border pixmap, computed by XMakeTile */
   0                /* graphics background pixmap, computed by XMakeTile */
};

/* Diglib window state */

static
float             min_x[MAX_WINDOWS],             /* Set up globals and constants used in world to device transformations */
                  max_x[MAX_WINDOWS];

static
float             min_y[MAX_WINDOWS],
                  max_y[MAX_WINDOWS];

static
float             scale_x[MAX_WINDOWS],
                  scale_y[MAX_WINDOWS];

static
int               current_x[MAX_WINDOWS],
                  current_y[MAX_WINDOWS];         /* The current (x,y) "beam" position, arghhh Textronix 401x lives */

static
int               color_bits;                     /* Number of bits of color */

static
int               current_color[MAX_WINDOWS];     /* current color for drawing */

static
Color             color_map[MAX_WINDOWS][MAX_COLORS]; /* Color table */

static
int               x0_resized = FALSE;	         /* tells if we have resized */



/* Set up the data structure for a cross hair cursor */

static
short cursor_bits[] = 
{
   0x0180, 
   0x0180, 
   0x0180, 
   0x0180,
   0x0180, 
   0x0180, 
   0x0000, 
   0xfe7f,
   0xfe7f, 
   0x0000, 
   0x0180, 
   0x0180,
   0x0180, 
   0x0180, 
   0x0180, 
   0x0180
};


/* Pointers to X window driver routines for this driver */

extern int x0_init_device();            /* initialize device */
extern int x0_clear_page();             /* screen clear */
extern int x0_move_to();                /* absolute window coordinates */
extern int x0_draw_to();                /* absolute window coordinates */
extern int x0_flush();                  /* flush all pending buffers */
extern int x0_release_device();         /* close the sun window */
extern int x0_return_device();          /* return device characteristics */
extern int x0_select_color();           /* set the current forground color */
extern int x0_get_input();              /* get input, null routine */
extern int x0_set_color_map_rgb();      /* set up a rgb color look up table */
extern int x0_set_color_map_hls();      /* set up a hls color look up table */
extern int x0_button_input();           /* a routine to handle button input */
extern int x0_draw_polygon();           /* draw a closed polygon */

/*
 * DigLib was designed with such that there would be fixed number of
 * static devices per DigLib subroutine packages.  Window systems provide
 * a variable number of dynamic virtual devices, i.g. windows.  The following
 * routines allow DigLib to use multiple dynamic windows.  Since all the
 * windows work the same way they use the same driver code and thus are placed
 * in one device driver.  These routines are called directly by the user to
 * alter the state of the driver.  They allow the user to specify windows,
 * change windows and delete windows.  DigLib will blindly use what ever the
 * currently selected window is.  It is up to the user to properly call and
 * manage these windows.  Diglib merely draws in them.
 */

/* Check to see of a Diglib window number is a valid/active diglib window */

int x0_check_window( DiglibWindowId )

int                  DiglibWindowId;
{
   /* Check id renge */
   
   if ( DiglibWindowId < 0 || DiglibWindowCount <= DiglibWindowId )
   {
      fprintf( stderr, "x0_check_window : warning : Window id = %d not in range = [%d, %d]\n", DiglibWindowId, 0, DiglibWindowCount-1 );

      /* Return unsuccessful operation, FALSE */

      return( 0 );
   }
   
   /* Check if the diglib window is active */
   
   if ( DiglibFrame[DiglibWindowId].self == 0 )
   {
      fprintf( stderr, "x0_check_window : warning : Window id = %d not an active window\n", DiglibWindowId  );

      /* Return unsuccessful operation, FALSE */

      return( 0 );
   }

   /* If it is an existing diglib window return true */

   return( 1 );
}

/* Adjust the scale of the diglib device to fit the current window */

int x0_resize_window( DiglibWindowId )

int                   DiglibWindowId;
{

   /* Check to see if diglib window is a valid window */

   if ( x0_check_window( DiglibWindowId ) )
   {
      /* Get window size information from the window system */
      
      if ( XQueryWindow( DiglibFrame[DiglibWindowId].self, &Winfo ) )
      {
	 min_x[DiglibWindowId] = 0.0;
	 max_x[DiglibWindowId] = (Winfo.width  - 1.0) / characteristics[DiglibWindowId][X_DOTS_PER_CM];
	 min_y[DiglibWindowId] = 0.0;
	 max_y[DiglibWindowId] = (Winfo.height - 1.0) / characteristics[DiglibWindowId][Y_DOTS_PER_CM];
	 
	 characteristics[DiglibWindowId][X_LENGTH] = max_x[DiglibWindowId] - min_x[DiglibWindowId];
	 characteristics[DiglibWindowId][Y_LENGTH] = max_y[DiglibWindowId] - min_y[DiglibWindowId];

	 /* ( the negative sign is there because the screen coordinates start
	  *   at  0 at top, increasing going down, which is opposite of what 
	  *   you want ).
	  */
	 
	 scale_x[DiglibWindowId] =   ( Winfo.width  - 1.0 ) / ( max_x[DiglibWindowId] - min_x[DiglibWindowId] );
	 scale_y[DiglibWindowId] = - ( Winfo.height - 1.0 ) / ( max_y[DiglibWindowId] - min_y[DiglibWindowId] );

	 /* Return successful operation, TRUE */
	 x0_resized = TRUE;
	 
	 return( 1 );
      }
      else
      {
	 return( 0 );
      }
   }
   else
   {
      return( 0 );
   }
}
   
/*
 * Add a window to the list of possible windows that diglib can draw on.
 * Returns and integer number indicating the diglib window.
 */
   
int x0_add_window( XWindowId )
      
Window             XWindowId;
{
   register
   int       i;              /* Index variable */
   
   int       DiglibWindowId; /* Returned index into diglib window list */
   
   
   /* Check to see if there are any holes in the list if there is
    * use that location.
    */
   
   DiglibWindowId = -1;
   
   for ( i = 0; i < DiglibWindowCount && DiglibWindowId == -1; i++ )
   {
      if ( DiglibFrame[i].self == 0 )
      {
	 DiglibWindowId = i;
      }
   }
   
   /* If we didn't find an empty slot add it to the end of the list if there's room */
   
   if ( DiglibWindowId == -1 )
   {
      if ( DiglibWindowCount < MAX_WINDOWS )
      {
	 DiglibWindowId = DiglibWindowCount;
	 DiglibWindowCount++;
      }
      else
      {
	 fprintf( stderr, "x0_add_window : warning : Number of active DigLib windows exceeds the maximum (%d) allowed.\n", MAX_WINDOWS );
	 
	 /* Return unsuccessful operation, FALSE */
	 
	 return( 0 );
      }
   }

   /* Copy the window characteristics */

   for ( i = 0; i < 8; i++ )
   {
      characteristics[DiglibWindowId][i] = characteristics[0][i];
   }
   
   /* Put the window in the slot */

   DiglibFrame[DiglibWindowId].self = XWindowId;

   /* resize the window */
   
   x0_resize_window( DiglibWindowId );

   /* return the Diglib window id */   
   
   return( DiglibWindowId );
}

/*
 * Remove an Diglib window from the list of active diglib windows
 */

Window x0_delete_window( DiglibWindowId )

int               DiglibWindowId;
{
   Window  TempWindowId;
   
   /* Check to see if diglib window is a valid window */

   if ( x0_check_window( DiglibWindowId ) )
   {
      TempWindowId = DiglibFrame[DiglibWindowId].self;

      DiglibFrame[DiglibWindowId].self = (Window)0;

      return( TempWindowId );
   }
   else
   {
      return( 0 );
   }
}

/*
 * Select a Diglib window from the list of active diglib windows
 */

Window x0_select_window( DiglibWindowId )

int                      DiglibWindowId;
{
   /* Check to see if diglib window is a valid window */

   if ( x0_check_window( DiglibWindowId ) )
   {
      CurrentDiglibWindow = DiglibWindowId;
      
      return( DiglibFrame[DiglibWindowId].self );
   }
   else
   {
      return( 0 );
   }
}


/*
 *  Ask about a Diglib window from the list of active diglib windows
 */

Window x0_query_window( DiglibWindowId )

int               DiglibWindowId;
{
   /* Check to see if diglib window is a valid window */

   if ( x0_check_window( DiglibWindowId ) )
   {
      return( DiglibFrame[DiglibWindowId].self );
   }
   else
   {
      return( 0 );
   }
}

/*
 * Set the server name for a given DigLib window.
 */

x0_specify_server( DiglibWindowId, server )

int                DiglibWindowId;
char                              *server;
{
   /* Make sure we have a ligitmate window */

   if ( DiglibWindowId < 0 || DiglibWindowCount <= DiglibWindowId )
   {
      fprintf( stderr, "x0_specify_server : warning : Window id = %d not in range = [%d, %d]\n", DiglibWindowId, 0, DiglibWindowCount-1 );

      /* Return unsuccessful operation, FALSE */

      return( 0 );
   }

   /* Save the server name */

   strcpy( server, &XServerName[DiglibWindowId] );

   /* Return a success */
   
   return( 1 );
}

/*
 * DigLib driver dispatch routine, called by higher level DigLib routines.
 */

gdx0_( op_code, x_data, y_data )

int    *op_code;                    /* holds the device independent op-code */
float         (* x_data)[],         /* x coordinate data */
                      (* y_data)[]; /* y coordinate data */
{
   /* An array of pointers to function */
   /*  i.e. a jump table that is global to this compilation unit */

   static 
   int (* jump_table[MAX_OPCODE])() = 
   {
      x0_init_device,
      x0_clear_page,
      x0_move_to,
      x0_draw_to,
      x0_flush,
      x0_release_device,
      x0_return_device,
      x0_select_color,
      x0_get_input,
      x0_set_color_map_rgb,
      x0_set_color_map_hls,
      x0_button_input,
      x0_draw_polygon
   };

   /* Check for correct op-code, and run */

   if (*op_code > 1024)
   {
      jump_table[MAX_OPCODE-1]( op_code, x_data, y_data );
   }

   if ( (0 <= *op_code) && (*op_code <= MAX_OPCODE-1) )
   {
      jump_table[*op_code-1]( op_code, x_data, y_data );
   }
} /* end main driver function */


/* Set up an X window for diglib */

x0_init_device( op_code, x_data, y_data )

int   *op_code;
float (* x_data)[], (* y_data)[];
{
   /* If we do not yet have a X window make connection to the X server */

   if ( DiglibFrame[CurrentDiglibWindow].self == NULL )  
   {
      if ( !XOpenDisplay( XServerName[CurrentDiglibWindow] ) )
      {
         fprintf( stderr, "x0_init : fatal : Unable to open X windows connection.\n");
         exit(0);
      }
   }

   /* Figure out if we're in color */
   
   color_bits = DisplayPlanes();
   
   /* Set up default color map */
   
   if ( XGetColorCells( 0, MAX_COLORS, 0, &DiglibPlanes, DiglibPixels ) )
   {
      color_map[CurrentDiglibWindow][0].pixel = DiglibPixels[0];        /* Background, black */
      color_map[CurrentDiglibWindow][0].red   = 0x0000;
      color_map[CurrentDiglibWindow][0].green = 0x0000;
      color_map[CurrentDiglibWindow][0].blue  = 0x0000;
      
      color_map[CurrentDiglibWindow][1].pixel = DiglibPixels[1];        /* Forground, white */
      color_map[CurrentDiglibWindow][1].red   = 0xffff;
      color_map[CurrentDiglibWindow][1].green = 0xffff;
      color_map[CurrentDiglibWindow][1].blue  = 0xffff;
      
      color_map[CurrentDiglibWindow][2].pixel = DiglibPixels[2];        /* Red */
      color_map[CurrentDiglibWindow][2].red   = 0xffff;
      color_map[CurrentDiglibWindow][2].green = 0x0000;
      color_map[CurrentDiglibWindow][2].blue  = 0x0000;
      
      color_map[CurrentDiglibWindow][3].pixel = DiglibPixels[3];        /* Green */
      color_map[CurrentDiglibWindow][3].red   = 0x0000;
      color_map[CurrentDiglibWindow][3].green = 0xffff;
      color_map[CurrentDiglibWindow][3].blue  = 0x0000;
      
      color_map[CurrentDiglibWindow][4].pixel = DiglibPixels[4];        /* Blue */
      color_map[CurrentDiglibWindow][4].red   = 0x0000;
      color_map[CurrentDiglibWindow][4].green = 0x0000;
      color_map[CurrentDiglibWindow][4].blue  = 0xffff;
      
      color_map[CurrentDiglibWindow][5].pixel = DiglibPixels[5];        /* Yellow */
      color_map[CurrentDiglibWindow][5].red   = 0xffff;
      color_map[CurrentDiglibWindow][5].green = 0xffff;
      color_map[CurrentDiglibWindow][5].blue  = 0x0000;
      
      color_map[CurrentDiglibWindow][6].pixel = DiglibPixels[6];        /* Magenta */
      color_map[CurrentDiglibWindow][6].red   = 0xffff;
      color_map[CurrentDiglibWindow][6].green = 0x0000;
      color_map[CurrentDiglibWindow][6].blue  = 0xffff;
      
      color_map[CurrentDiglibWindow][7].pixel = DiglibPixels[7];        /* Cyan */
      color_map[CurrentDiglibWindow][7].red   = 0x0000;
      color_map[CurrentDiglibWindow][7].green = 0xffff;
      color_map[CurrentDiglibWindow][7].blue  = 0xffff;
      
      characteristics[CurrentDiglibWindow][FG_COLORS] = (float)(MAX_COLORS - 1);
      
      XStoreColors( MAX_COLORS, color_map[CurrentDiglibWindow] );
   }
   else
   {
      fprintf( stderr, "x0_init : warning : This display can not support %d colors\n", MAX_COLORS );
      
      DiglibPlanes    = 1;
      DiglibPixels[0] = 0;
      DiglibPixels[1] = 1;
      
      characteristics[CurrentDiglibWindow][FG_COLORS] = 1;
   }
   
   /* If we don't have a window yet set one up */

   if ( DiglibFrame[CurrentDiglibWindow].self == NULL )
   {
      /* Build basic pixmaps for the diglib window */
      
      DiglibFrame[CurrentDiglibWindow].border     = XMakeTile( DiglibPixels[1] );
      DiglibFrame[CurrentDiglibWindow].background = XMakeTile( DiglibPixels[0] );
      
      /* Decide where the window goes */
      
      DiglibFrame[CurrentDiglibWindow].x = DisplayWidth()  - 612 - 7;
      DiglibFrame[CurrentDiglibWindow].y = DisplayHeight() - 612 - 7;
      
      /* Create an Xwindow */
      
      XCreateWindows( RootWindow, &DiglibFrame[CurrentDiglibWindow], 1 );
      
      /* Map the window onto the display */
      
      XMapWindow( DiglibFrame[CurrentDiglibWindow].self );
   }

   /* Default color */
   
   current_color[CurrentDiglibWindow] = 1;
   
   /* Create a crosshair cursor */
   
   DiglibCursor = XCreateCursor( CURSOR_WIDTH, CURSOR_HEIGHT, cursor_bits, cursor_bits, 8, 8, 1, 0, GXcopy );
   
   XDefineCursor( DiglibFrame[CurrentDiglibWindow].self, DiglibCursor );
   
   
   /* Now fix the correct screen-size */
   
   if ( !x0_resize_window( CurrentDiglibWindow ) )
   {
      fprintf( stderr, "x0_init : warning : Unable to resize Diglib device to X window size\n" );
   }
}



x0_clear_page( op_code,  x_data, y_data )

int   *op_code;
float (* x_data)[], (* y_data)[];
{
   XClear( DiglibFrame[CurrentDiglibWindow].self );
   if ( !x0_resize_window( CurrentDiglibWindow ) )
   {
      fprintf( stderr, "x0_clear : warning : Unable to resize Diglib device to X window size\n" );
   }
   if (x0_resized) {
      int zero = 0;
      int four = 4;
      int ierr;

      x0_resized = FALSE;
      /* This is a hack to make it work correctly. It releases,
	 then reinitializes the device (Steve Azevedo 10/6/87) */
      devsel_(&zero,&four,&ierr);
   }

}



x0_move_to( op_code, x_data, y_data )

int   *op_code;
float (* x_data)[], (* y_data)[];
{
   current_x[CurrentDiglibWindow] = x_translate( (*x_data)[0] );
   current_y[CurrentDiglibWindow] = y_translate( (*y_data)[0] );
}



x0_draw_to( op_code, x_data, y_data )

int   *op_code;
float (* x_data)[], (* y_data)[];
{
   register
   int      new_x, new_y;

   new_x = x_translate( (*x_data)[0] );
   new_y = y_translate( (*y_data)[0] );

   XLine( DiglibFrame[CurrentDiglibWindow].self, current_x[CurrentDiglibWindow], current_y[CurrentDiglibWindow], new_x, new_y, 1, 1, DiglibPixels[current_color[CurrentDiglibWindow]], GXcopy, AllPlanes );

   current_x[CurrentDiglibWindow] = new_x;
   current_y[CurrentDiglibWindow] = new_y;
}



x0_flush( op_code, x_data, y_data )

int   *op_code;
float (* x_data)[], (* y_data)[];
{
   XFlush(DiglibFrame[CurrentDiglibWindow].self);
}



x0_release_device( op_code, x_data, y_data )

int   *op_code;
float (* x_data)[], (* y_data)[];
{
   /*
    *  This routine should really close out the window system,
    *  but we want to be able to get back to this same device if
    *  it gets reopened.  So just leave the window around and don't
    *  clear it.
    */
}


x0_return_device( op_code, x_data, y_data )

int   *op_code;
float (* x_data)[], (* y_data)[];
{
   int i;

   for ( i = 0; i < 8; i++)
   {
      (*x_data)[i] = characteristics[CurrentDiglibWindow][i];
   }
}



x0_select_color( op_code, x_data, y_data )

int   *op_code;
float (* x_data)[], (* y_data)[];
{
   if (color_bits != 1)         /* Only if not monochrome */
   {
      if ( 0 <= (*x_data)[0]  &&  (*x_data)[0] < MAX_COLORS )
      {
	 current_color[CurrentDiglibWindow] = (*x_data)[0];
      }
   }
}



x0_check_input()
{ 
}


x0_get_input( op_code, x_data, y_data )

int   *op_code;
float (* x_data)[], (* y_data)[];
{
   int    x, y;


   /* Tell the server we only want mouse button events */

   XSelectInput( DiglibFrame[CurrentDiglibWindow].self, ButtonPressed );

   /* Poll the the mouse until a button depression is detected */

   XSync( 1 );
   XWindowEvent( DiglibFrame[CurrentDiglibWindow].self, ButtonPressed, &DiglibEvent );

   if (DiglibEvent.detail == RightButton)
   {
      (*x_data)[0] = 'r';
   }
   else if (DiglibEvent.detail == MiddleButton)
   {
      (*x_data)[0] = 'm';
   }
   else if (DiglibEvent.detail == LeftButton)
   {
      (*x_data)[0] = ' ';
   }

   /* Get the input and convert to device independent coordinates */

   (*x_data)[1] = x_untranslate( DiglibEvent.x );
   (*x_data)[2] = y_untranslate( DiglibEvent.y );
}
 


x0_set_color_map_hls( op_code, x_data, y_data )

int   *op_code;
float (* x_data)[], (* y_data)[];
{
}



x0_set_color_map_rgb( op_code, x_data, y_data )

int   *op_code;
float (* x_data)[], (* y_data)[];
{
   int color_index;

   color_index = (*x_data)[0];

   if ( 0 <= color_index  &  color_index <= MAX_COLORS )
   {
      color_map[CurrentDiglibWindow][color_index].pixel = DiglibPixels[color_index];
      color_map[CurrentDiglibWindow][color_index].red   = (*y_data)[0];
      color_map[CurrentDiglibWindow][color_index].green = (*y_data)[1];
      color_map[CurrentDiglibWindow][color_index].blue  = (*y_data)[2];

      XStoreColor( &color_map[CurrentDiglibWindow][color_index] );
   }
}



x0_button_input( op_code, x_data, y_data )

int   *op_code;
float (* x_data)[], (* y_data)[];
{
   x0_get_input( op_code, x_data, y_data );
}



x0_draw_polygon( op_code, x_data, y_data )

int   *op_code;
float (* x_data)[], (* y_data)[];
{
   Vertex *polygon;
   int    i, n;

   n = *op_code - 1024;

   polygon = (Vertex *)malloc( sizeof(Vertex)*(n+1) );

   for ( i = 0; i < n; i++ )
   {
      polygon[i].x     = x_translate( (*x_data)[i] );
      polygon[i].y     = y_translate( (*y_data)[i] );
      polygon[i].flags = 0;
   }

   polygon[n].x     = polygon[0].x;
   polygon[n].y     = polygon[0].y;
   polygon[n].flags = 0;

   XDrawFilled( DiglibFrame[CurrentDiglibWindow].self, polygon, n+1, DiglibPixels[current_color[CurrentDiglibWindow]], GXcopy, AllPlanes );

   free( polygon );

   /* Remember where we are for the next draw command */

   current_x[CurrentDiglibWindow] = polygon[n].x;
   current_y[CurrentDiglibWindow] = polygon[n].y;
}
