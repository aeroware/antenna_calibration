/*******************************/
/*******************************/
/*** X11R3 Driver for DIGLIB ***/
/*******************************/
/*******************************/


/************************************************************************/
/* History:                                                             */
/*                                                                      */
/* Jan-1991 Hal R. Brand, Fixed ICCCM compliance problem with input     */
/*                        events where WM hint for input was not set    */
/*                        The Open Windows work around was to define    */
/*                        the "FocusLenience" resource to True.         */
/* Apr-1990 Hal R. Brand, Programmable configurability enhancements     */
/* Apr-1990 Hal R. Brand, Conditionalization for VMS and UN*X           */
/* Dec-1989 Hal R. Brand, General cleanup and enhancements              */
/* ???-1989 Tom Spelce, X11 attempt                                     */
/* ???-???? Brian Cabral and Steve Azevedo, Original X10 driver         */
/************************************************************************/


/**************************/
/**************************/
/** Driver configuration **/
/**************************/
/**************************/

/*****************/
/* OS selection! */
/*****************/

/* Attempt to "autoconfigure" */

#ifdef vms
#define OS_VMS
#endif
#ifdef unix
#define OS_UNIX
#endif

/* Manual configuration if autoconfigure failed */

#ifndef OS_VMS
#ifndef OS_UNIX
#define OS_UNIX
/* #define OS_VMS */
#endif
#endif


/**************************************/
/* FORTRAN to C calling configuration */
/**************************************/

/* This works automatically for most UN*X systems */
/*  Override if necessary */

/*#ifdef OS_UNIX					*/
/*#define NEED_TRAILING_UNDERSCORE	*/
/*#endif							*/



/************************************************/
/* Default mapping of Mouse Buttons to GIN keys */
/************************************************/

/* This driver supports the traditional GIN mode, i.e. point the cursor   */
/*  and strike a key! It also supports the use of the mouse buttons       */
/*  during GIN input. Below is the mouse button to "key" relationships.   */
/*  The first character is returned in response to button 1, 2nd char is  */
/*  button 2, 3rd is button 3, and 4th is any other button event.         */

#define DEFAULT_BUTTON_MAP " mr\n"



/*******************************************************/
/* Driver Memory Utilization to Support Window Refresh */
/*******************************************************/

/* This driver has the capability to store all the lines drawn into the */
/*  X Window and to use these saved lines to refresh the window.        */
/*  Using this feature and the routine "gdx11_refresh_window" should    */
/*  make using DIGLIB under X11 easier than before!                     */
/* If you don't want/need this feature or if you can't afford the       */
/*  memory usage, set MAX_SEG to 1, MAX_POINTS to something around 100  */
/*  and COMPLAIN_ON_OVERFLOW to 0!                                      */

#define COMPLAIN_ON_OVERFLOW 1   /* Complain if can't store all polylines */
#define MAX_POINTS 15000         /* Maximum points in all polylines stored */
#define MAX_SEG     6000         /* Maximum polylines stored */

#define DEBUG          2         /* 0 == No debugging. */
                                 /* 1 == Soft X11 errors */
                                 /* 2 == Above plus caller bugs */
                                 /* 3 == Above plus Driver tracing messages */
                                 /* 4 == Above plus all tracing messages */




/***********************************/
/***********************************/
/** Definitions and Include Files **/
/***********************************/
/***********************************/

/* Check out configuration */
#ifndef OS_VMS
#ifndef OS_UNIX
#include "give-it-up-no-os-defined" /* Abort compilation */
#endif
#endif

/****************************/
/* Non-DIGLIB include files */
/****************************/

#include <stdio.h>                /* Unix standard I/O definitions */

#ifdef OS_UNIX
#include <malloc.h>               /* We use "malloc" and "free" */
#include <X11/Xlib.h>             /* Xwindows data structures */
#include <X11/Xutil.h>            /* Needed for XSizeHints and XWMHints defn */
#include <X11/cursorfont.h>       /* Needed for GIN cursor switching */
#endif
#ifdef OS_VMS
#include <stdlib.h>               /* We use "malloc" and "free" */
#include <decw$include:Xlib.h>    /* Xwindows data structures */
#include <decw$include:Xutil.h>   /* Needed for XSizeHints defn */
#include <decw$include:cursorfont.h> /* Needed for GIN cursor switching */
#endif

/* Note: if you don't have the file "malloc.h", then use the following: */
/* extern char *malloc(); */
/* extern void free();    */


/************************/
/* Driver include files */
/************************/

#include "gdx11.h"
#include "gd_dev_char_bits.h"

/*****************/
/* Local Storage */
/*****************/

#define MAX_OPCODE      13        /* number of op-code values */

static XButtonPressedEvent DiglibEvent;/* Button event variable */
static DIGWin *current_dw = NULL;
static DIGWin *default_dw = NULL;
static int default_width = 600;
static int default_height = 500;
static char button_map[6] = DEFAULT_BUTTON_MAP;


/*******************************************************************/
/* Device coordinates <--> Virtual corrdinates, translation macros */
/*******************************************************************/

#define x_translate(dw,x)    (int)((x)*dw->x_scale+0.5)+dw->x_offset
#define y_translate(dw,y)    (int)(dw->y_len-(y)*dw->y_scale+0.5)+dw->y_offset
#define x_untranslate(dw,x)  ((x)-dw->x_offset)/dw->x_scale
#define y_untranslate(dw,y)  (dw->y_len+dw->y_offset-(y))/dw->y_scale


/*********************************/
/*********************************/
/*** Window Management Support ***/
/*********************************/
/*********************************/


/*******************************************************************/
/* Adjust the scale of the diglib device to fit the current window */
/*  given the user's guidelines for what part of the window to use.*/
/*******************************************************************/

void gdx11_adjust_digwin(dw)
     DIGWin *dw;
{
  if (dw->abs_min_max)
    {
      dw->x_offset = dw->min_x + dw->x_border;
      dw->y_offset = dw->min_y + dw->y_border;
      dw->x_len = (dw->max_x-dw->x_border) - dw->x_offset;
      dw->y_len = (dw->max_y-dw->y_border) - dw->y_offset;
    }
  else
    {
      XGetWindowAttributes(dw->xdisplay,dw->xwin,&(dw->xwa));
      dw->x_offset = (dw->min_x*dw->xwa.width)/100+dw->x_border;
      dw->y_offset = (dw->min_y*dw->xwa.height)/100+dw->y_border;
      dw->x_len = ((dw->max_x-dw->min_x)*dw->xwa.width)/100-dw->x_border;
      dw->y_len = ((dw->max_y-dw->min_y)*dw->xwa.height)/100-dw->y_border;
    }
}




/*****************************/
/* Refresh the DIGLIB window */
/*****************************/

void gdx11_refresh_digwin(dw)
     DIGWin *dw;
{
  int i;
  int start = 0;
  Display *disp = dw->xdisplay;
  unsigned long fg_pv;
  int pv;
  int np;

  fg_pv = dw->polyline_pixel_value[0];
  XSetForeground(disp,dw->xgc,fg_pv);
  for (i=0;i<dw->npolylines;++i)
    {
      if ((pv=dw->polyline_pixel_value[i])!=fg_pv)
	{
	  fg_pv = pv;
	  XSetForeground(disp,dw->xgc,fg_pv);
	}
      np = dw->npoints[i];
      if (np<0)
	{
	  np = -np;
	  XFillPolygon(disp,dw->xwin,dw->xgc,&(dw->points[start]),np,
		       Complex,CoordModeOrigin);
	}
      XDrawLines(disp,dw->xwin,dw->xgc,&(dw->points[start]),
		 np,CoordModeOrigin);
      start = start+np;
    }
  return;
}



/****************************************/
/* Make a XWindow into a DIGLIB XWindow */
/****************************************/

static char colors[6][10] = { "RED", "GREEN", "BLUE",
				"YELLOW", "MAGENTA", "CYAN"};

DIGWin *gdx11_make_digwin_from_xwin(display,xwindow,
				    back_pixel,fore_pixel,
				    x_border,y_border,
				    min_x,max_x,min_y,max_y,
				    abs_min_max)
     Display *display;
     Window xwindow;
     unsigned long back_pixel, fore_pixel;
     int x_border, y_border;
     int min_x, max_x, min_y, max_y;
     int abs_min_max;
{
  DIGWin *dw;
  Screen *screen;
  Colormap cmap;
  XColor screen_def, exact_def;
  XGCValues setgc;
  int color;
  int colors_allocated;

  if ((dw = (DIGWin *)malloc(sizeof(DIGWin)))==0)
    {
      fprintf(stderr,"DIGLIB X11 Driver unable to get window memory!\n");
      exit(0);
    }
  dw->npoints = (int *)malloc(MAX_SEG*sizeof(int));
  dw->polyline_pixel_value = (int *)malloc(MAX_SEG*sizeof(int));
  dw->points = (XPoint *)malloc(MAX_POINTS*sizeof(XPoint));

  dw->xdisplay = display;
  dw->xwin = xwindow;

  XGetWindowAttributes(display,xwindow,&(dw->xwa));
  screen = dw->xwa.screen;
  cmap = dw->xwa.colormap;

  /* Get default colors */
  dw->pixel_value_for_color[0] = back_pixel;
  dw->pixel_value_for_color[1] = fore_pixel;
  colors_allocated = 2;
  if (CellsOfScreen(screen)>=3)
    {
      for (color=2;color<8;++color)
	{
	  if (XAllocNamedColor(display,cmap,colors[color-2],
			       &screen_def,&exact_def))
	    {
	      dw->pixel_value_for_color[colors_allocated++] = screen_def.pixel;
	      if (DEBUG>=3)
		fprintf(stderr,"Color %s is pixel %d\n",
			colors[color-2],dw->pixel_value_for_color[color]);
	    }
	  else
	    if (DEBUG>=2)
	      fprintf(stderr,"DIGLIB-GDX11: Unable to allocate color %s\n",
		      colors[color-2]);
	}
    }
  else
    if (DEBUG>=3)
      fprintf(stderr,"DIGLIB-GDX11: Monochrome window - no colors!\n");
  dw->num_fg_colors = colors_allocated - 1;
  dw->current_pixel_value = dw->pixel_value_for_color[1];

  /* Get scale factors for the screen (and therefore for the window) */
  dw->x_scale = ((double)WidthOfScreen(screen))/
    (((double)WidthMMOfScreen(screen))/10.0);
  dw->y_scale = ((double)HeightOfScreen(screen))/
    (((double)HeightMMOfScreen(screen))/10.0);

  /* Use portion of window user wants */
  dw->x_border = x_border;
  dw->y_border = y_border;
  dw->abs_min_max = abs_min_max;
  dw->min_x = min_x;
  dw->max_x = max_x;
  dw->min_y = min_y;
  dw->max_y = max_y;

  /* Create a GC for this window */
  setgc.foreground = dw->pixel_value_for_color[1];
  setgc.function = GXcopy;
  setgc.line_width = 0;
  setgc.line_style = LineSolid;
  setgc.fill_style = FillSolid;
  dw->xgc = XCreateGC(display,xwindow,
		      (GCForeground|GCFunction|GCLineWidth|
		       GCLineStyle|GCFillStyle),
		      &setgc);

  gdx11_adjust_digwin(dw);
  return(dw);
}



/****************************************/
/* Create a DIGLIB XWindow from scratch */
/****************************************/

DIGWin *gdx11_create_digwin(xservername,window_width,window_height)
     char *xservername;
     int window_width, window_height;
{
  Display *disp;
  Window xwin;
  Screen *def_screen;
  Colormap cmap;
  XColor screen_def, exact_def;
  XSetWindowAttributes setwin;
  XGCValues setgc;
  XSizeHints size_hints;
  XWMHints wmhints;
  XEvent event;
  DIGWin *dw;
  unsigned long background_pixel, foreground_pixel;

  if (!(disp = XOpenDisplay(xservername)))
    {
      fprintf(stderr,
	      "DIGLIB X11 Driver unable to open X windows connection.\n");
      exit(0);
    }
  if (DEBUG>=4)
    fprintf(stderr,"gdx11_init_device: Inform : X Display opened\n");

  /* Get screen for window */
  def_screen = DefaultScreenOfDisplay(disp);

  /* Get colors straight */
  cmap = DefaultColormapOfScreen(def_screen);
  if (XAllocNamedColor(disp,cmap,"BLACK",&screen_def,&exact_def))
    foreground_pixel = screen_def.pixel;
  else
    foreground_pixel = BlackPixelOfScreen(def_screen);
  if (XAllocNamedColor(disp,cmap,"WHITE",&screen_def,&exact_def))
    background_pixel = screen_def.pixel;
  else
    background_pixel = WhitePixelOfScreen(def_screen);

  /* Create an Xwindow */
  setwin.event_mask = (ButtonPressMask|ExposureMask|StructureNotifyMask|
		       KeyPressMask);
  setwin.background_pixel = background_pixel;
  xwin = XCreateWindow(disp,
		       RootWindowOfScreen(def_screen),
		       0,0,
		       window_width,window_height,
		       4,
		       DefaultDepthOfScreen(def_screen),
		       InputOutput,
		       DefaultVisualOfScreen(def_screen),
		       (CWBackPixel|CWEventMask),
		       &setwin);

  /* Set up stuff for Window Managers */
  size_hints.width = window_width;
  size_hints.height = window_height;
  size_hints.min_width = 20;
  size_hints.min_height = 20;
  size_hints.flags = PSize|PMinSize;
  XSetStandardProperties(disp,xwin,"DIGLIB Window","DIGLIB Win",
			 None,0,0,&size_hints);
  wmhints.input = True;
  wmhints.initial_state = NormalState;
  wmhints.flags = InputHint|StateHint;
  XSetWMHints(disp,xwin,&wmhints);

  /* Map the window onto the display */
  XMapWindow(disp,xwin);

  /* Wait for exposure event before proceeding - otherwise, some */
  /*  drawing command might get tossed                           */
  XWindowEvent(disp,xwin,ExposureMask,&event);

  /* Now turn the XWindow into a DIGLIB XWindow */
  dw = gdx11_make_digwin_from_xwin(disp,xwin,
				   background_pixel,foreground_pixel,
				   2,2,0,100,0,100,0);
  return(dw);
}

/* FORTRAN Interface */
DIGWin *
#ifdef NEED_TRAILING_UNDERSCORE
        gdx11cdw_
#else
        gdx11cdw
#endif
                 (xservername,widthptr,heightptr)
     char *xservername;
     int *widthptr, *heightptr;
{
  return(gdx11_create_digwin(xservername,*widthptr,*heightptr));
}



/*****************************/
/* Set DIGLIB Drawing Window */
/*****************************/

extern void
#ifdef NEED_TRAILING_UNDERSCORE
            gsgdev_
#else
            gsgdev
#endif
                   ();

DIGWin *gdx11_set_current_digwin(dw)
     DIGWin *dw;
{
  DIGWin *old_dw = current_dw;

  current_dw = dw;

  /* Force DIGLIB to do equivalent of a DEVSEL! This is necessary to get */
  /*  DIGLIB to notice the change in the window. Unfortunately, it also  */
  /*  has the side effect of resetting all those things DEVSEL resets,   */
  /*  e.g. line type, clipping limits, etc.                              */
#ifdef NEED_TRAILING_UNDERSCORE
  gsgdev_
#else
  gsgdev
#endif
         ();

  /* Finally, return the old DIGLIB window */
  return(old_dw);
}

/* FORTRAN Interace */
DIGWin *
#ifdef NEED_TRAILING_UNDERSCORE
        gdx11setdw_
#else
        gdx11setdw
#endif
                   (dw)
     DIGWin **dw;
{
  return(gdx11_set_current_digwin(*dw));
}


DIGWin *gdx11_get_current_digwin()
{
  return(current_dw);
}

/* FORTRAN Interace */
DIGWin *
#ifdef NEED_TRAILING_UNDERSCORE
        gdx11getdw_
#else
        gdx11getdw
#endif
                   ()
{
  return(gdx11_get_current_digwin());
}



/****************************/
/* Set Default Xwindow Size */
/****************************/

void gdx11_set_def_window_size(width,height)
     int width, height;
{
  default_width = width;
  default_height = height;
}

/* FORTRAN Interface */
void
#ifdef NEED_TRAILING_UNDERSCORE
     gdx11setwindow_
#else
     gdx11setwindow
#endif
                    (widthptr,heightptr)
     int *widthptr, *heightptr;
{
  gdx11_set_def_window_size(*widthptr,*heightptr);
}



/************************/
/* Free a DIGLIB Window */
/************************/

void gdx11_free_digwin(dw)
     DIGWin *dw;
{
  if (current_dw == dw) current_dw = NULL;
  if (default_dw == dw) default_dw = NULL;
  free(dw->npoints);
  free(dw->polyline_pixel_value);
  free(dw->points);
  free(dw);
}



/******************************************************************/
/* A Simple Funtion to Handle a Single X Event in a DIGLIB Window */
/******************************************************************/

static XComposeStatus lookup_status;

int gdx11_handle_digwin_event(dw,eventptr,term_char,term_button)
     DIGWin *dw;
     XEvent *eventptr;
     char term_char;
     unsigned int term_button;
{
  int terminator = 0;

  switch (eventptr->type)
    {
    case MappingNotify:
      XRefreshKeyboardMapping(eventptr);
      break;
    case Expose:
      gdx11_refresh_digwin(dw);
      break;
    case ConfigureNotify:
      gdx11_adjust_digwin(dw);
      gdx11_refresh_digwin(dw);
      break;
    case KeyPress:
      {
	XKeyEvent *key_event = (XKeyEvent *)eventptr;
	int length;
	char buf[8];
	KeySym ks;

	length = XLookupString(key_event,buf,8,&ks,&lookup_status);
	if (length > 0 && term_char != 0 && term_char == buf[0])
	  terminator = 1;
	break;
      }
    case ButtonPress:
      {
	XButtonEvent *button_event = (XButtonEvent *)eventptr;

	if (term_button != 0 &&
	    term_button == button_event->button) terminator = 1;
      }
    default:
      break;
    }
  return(terminator);
}


/*******************************/
/* Keep DIGLIB windows "alive" */
/*******************************/

void gdx11_maintain_digwins(dws,ndigwin,term_char,term_button)
     DIGWin *dws[];
     int ndigwin;
     char term_char;
     unsigned int term_button;
{
  int i;
  DIGWin *dw;
  XEvent event;
  int terminated = 0;
  do
    {
      for (i=0;i<ndigwin;++i)
	{
	  dw = dws[i];
	  if (XCheckWindowEvent(dw->xdisplay,dw->xwin,
				dw->xwa.your_event_mask,&event))
	    terminated = gdx11_handle_digwin_event(dw,&event,term_char,
						   term_button);
	}
    } while (!terminated);
}

/* FORTRAN Interface */
void
#ifdef NEED_TRAILING_UNDERSCORE
     gdx11maintain_
#else
     gdx11maintain
#endif
                   (dws,ndigwinptr,term_char_ptr,term_button_ptr)
     DIGWin *dws[];
     int *ndigwinptr;
     char *term_char_ptr;
     int *term_button_ptr;
{
  gdx11_maintain_digwins(dws,*ndigwinptr,*term_char_ptr,term_button_ptr);
}



/******************************************/
/******************************************/
/** Programmable Configuration Functions **/
/******************************************/
/******************************************/

void gdx11_set_button_map(bmap)
     char *bmap;
{
  int i;

  for (i=0;i<4;++i)
    button_map[i] = bmap[i];
}

/* FORTRAN Interface */
void
#ifdef NEED_TRAILING_UNDERSCORE
     gdx11setbmap_
#else
     gdx11setbmap
#endif
                   (bmap)
     char *bmap;
{
  gdx11_set_button_map(bmap);
}



/***************************************************************/
/***************************************************************/
/****** DIGLIB DRIVER FOR X WINDOWS VERSION 11, RELEASE 3 ******/
/***************************************************************/
/***************************************************************/

/********************/
/* Polyline support */
/********************/

static void gdx11_init_polylines(dw)
     DIGWin *dw;
{
  dw->npolylines = 0;
  dw->npoints[0] = 0;
  dw->next_point = 0;
}

static void gdx11_term_polyline(dw)
     DIGWin *dw;
{
  /* Terminate previous polyline if necessary */
  if (dw->npoints[dw->npolylines]>=2)
    ++dw->npolylines;
  else
    dw->next_point -= dw->npoints[dw->npolylines];
  dw->npoints[dw->npolylines] = 0;
}

static gdx11_end_polygon(dw)
     DIGWin *dw;
{
  int npoly = dw->npolylines;

  if (dw->npoints[npoly]>=2)
    {
      dw->npoints[npoly] = -dw->npoints[npoly];
      ++dw->npolylines;
    }
  else
    dw->next_point -= dw->npoints[dw->npolylines];
  dw->npoints[dw->npolylines] = 0;
}

static void gdx11_check_polyline_overflow(dw,n)
     DIGWin *dw;
     int n;
{
  if (dw->next_point+n > MAX_POINTS ||
      dw->npolylines>=MAX_SEG)
    {
      gdx11_term_polyline(dw);
      gdx11_refresh_digwin(dw);
      gdx11_init_polylines(dw);
      if (COMPLAIN_ON_OVERFLOW)
	fprintf(stderr,"DIGLIB-GDX11: Too many %s to save!\n",
		(dw->npolylines>=MAX_SEG ? "polylines" : "points"));
      if (n>MAX_POINTS)
	fprintf(stderr,"DIGLIB-GDX11: Point buffer too small!\n");
    }
}

static void gdx11_start_polyline(dw,x,y)
     DIGWin *dw;
     int x, y;
{
  gdx11_term_polyline(dw);
  gdx11_check_polyline_overflow(dw,2);

  /* Initialize current polyline */
  dw->points[dw->next_point].x = x;
  dw->points[dw->next_point++].y = y;
  dw->npoints[dw->npolylines] = 1;
  dw->polyline_pixel_value[dw->npolylines] = dw->current_pixel_value;
  return;
}

static void gdx11_start_polygon(dw,n,x,y)
     DIGWin *dw;
     int n;
     int x, y;
{
  gdx11_term_polyline(dw);
  gdx11_check_polyline_overflow(dw,n);
  gdx11_start_polyline(dw,x,y);
  return;
}

static void gdx11_add_point_to_polyline(dw,x,y)
     DIGWin *dw;
     int x,y;
{
  if (dw->npoints[dw->npolylines]==0)
    gdx11_start_polyline(dw,dw->current_x,dw->current_y);
  gdx11_check_polyline_overflow(dw,1);
  dw->points[dw->next_point].x = x;
  dw->points[dw->next_point++].y = y;
  ++dw->npoints[dw->npolylines];
}



/*********************/
/* INITIALIZE DEVICE */
/*********************/

static void gdx11_init_device(dw,x_data,y_data)
     DIGWin *dw;
     float *x_data, *y_data;
{
  /* If we do not yet have a diglib Xwindow get one */
  if (dw == NULL)
    {
      if (default_dw == NULL)
	dw = default_dw =
	  gdx11_create_digwin("",default_width,default_height);
      else
	dw = default_dw;
    }
  current_dw = dw;

  /* Now fix the correct screen-size */
  gdx11_adjust_digwin(dw);
}



/*************************************************/
/* GET FRESH PLOTTING SURFACE, i.e. ERASE WINDOW */
/*************************************************/

static void gdx11_clear_page(dw,x_data,y_data)
     DIGWin *dw;
     float *x_data, *y_data;
{
  dw->current_pixel_value = dw->pixel_value_for_color[1];
  gdx11_init_polylines(dw);
  if (DEBUG>=4) fprintf(stderr,"Clearing Window ... ");
  XClearWindow(dw->xdisplay,dw->xwin);
  if (DEBUG>=4) fprintf(stderr,"done!\n");
  gdx11_adjust_digwin(dw);

  /* Force DIGLIB to do equivalent of a DEVSEL! This is necessary to get */
  /*  DIGLIB to notice any change in the window. Unfortunately, it also  */
  /*  has the side effect of resetting all those things DEVSEL resets,   */
  /*  e.g. line type, clipping limits, etc. Here it should be too bad!   */
#ifdef NEED_TRAILING_UNDERSCORE
  gsgdev_
#else
  gsgdev
#endif
         ();
}



/*****************/
/* MOVE TO (X,Y) */
/*****************/

static void gdx11_move_to(dw,x_data,y_data)
     DIGWin *dw;
     float *x_data, *y_data;
{
  int x = x_translate(dw,x_data[0]);
  int y = y_translate(dw,y_data[0]);

  if (x==dw->current_x && y==dw->current_y) return;

  /* Start polyline */
  gdx11_start_polyline(dw,x,y);
  
  dw->current_x = x;
  dw->current_y = y;
}



/*****************/
/* DRAW TO (X,Y) */
/*****************/

static void gdx11_draw_to(dw,x_data,y_data)
     DIGWin *dw;
     float *x_data, *y_data;
{
  register int new_x, new_y;
  
  new_x = x_translate(dw,x_data[0]);
  new_y = y_translate(dw,y_data[0]);
  gdx11_add_point_to_polyline(dw,new_x,new_y);
  dw->current_x = new_x;
  dw->current_y = new_y;
}



/*************************/
/* FLUSH GRAPHICS BUFFER */
/*************************/

static void gdx11_flush(dw,x_data,y_data)
     DIGWin *dw;
     float *x_data, *y_data;
{
  gdx11_term_polyline(dw);
  gdx11_refresh_digwin(dw);
  XFlush(dw->xdisplay);
}



/******************/
/* RELEASE DEVICE */
/******************/

static void gdx11_release_device(dw,x_data,y_data)
     DIGWin *dw;
     float *x_data, *y_data;
{
  /*
   *  This routine should really close out the window system,
   *  but we want to be able to get back to this same device if
   *  it gets reopened.  So just leave the window around and don't
   *  clear it.
   */
  return;
}



/*********************************/
/* RETURN DEVICE CHARACTERISTICS */
/*********************************/

static void gdx11_return_device(dw,x_data,y_data)
     DIGWin *dw;
     float *x_data, *y_data;
{
  x_data[0] = 11.0;                      /* Nonzero device ID */
  if (dw!=NULL && dw->xwin!=NULL)
    {
      x_data[1] = dw->x_len/dw->x_scale; /* X Length in cm. */
      x_data[2] = dw->y_len/dw->y_scale; /* Y Length in cm. */
      x_data[3] = dw->x_scale;           /* X pixels per cm */
      x_data[4] = dw->y_scale;           /* Y pixels per cm */
      x_data[5] = dw->num_fg_colors;     /* Number of foreground colors */
    }
  else
    {
      x_data[1] = 0.001;                 /* X Length in cm. */
      x_data[2] = 0.001;                 /* Y Length in cm. */
      x_data[3] = 1.0;                   /* X pixels per cm */
      x_data[4] = 1.0;                   /* Y pixels per cm */
      x_data[5] = 1.0;                   /* Number of foreground colors */
    }
  x_data[6] = RASTER_DEVICE+CAN_DRAW_IN_BACKGROUND+
    CAN_DO_GIN+CAN_DRAW_FILLED_POLYGONS+
      CAN_DO_LOCATOR_INPUT;                 /* DIGLIB device capabilities */
  x_data[7] = 1.0;                       /* Fill every line */
  return;
}



/*************************/
/* SELECT PLOTTING COLOR */
/*************************/

static void gdx11_select_color(dw,x_data,y_data)
     DIGWin *dw;
     float *x_data, *y_data;
{
  int new_pv = (int) x_data[0];

  if (new_pv>=0 && new_pv<=dw->num_fg_colors &&
      (new_pv = dw->pixel_value_for_color[new_pv])
      !=dw->current_pixel_value)
    {
      gdx11_term_polyline(dw);
      dw->current_pixel_value = new_pv;
    }
}




static void gdx11_get_input(dw,cursor,allow_keys,bmap,press,x,y)
     DIGWin *dw;
     Cursor cursor;
     int allow_keys;
     char *bmap;
     int *press, *x, *y;
{
  Display *disp = dw->xdisplay;
  Window w = dw->xwin;
  XEvent event;
  long int event_mask = (ButtonPressMask|ExposureMask|StructureNotifyMask|
			 KeyPressMask);
  int no_button = 1;

  /* First, toss all events on this window already in the queue */
  while (XCheckWindowEvent(disp,w,event_mask,&event))
    gdx11_handle_digwin_event(dw,&event,0,0);


  /* Put up cursor to signal we want input */
  XDefineCursor(disp,w,cursor);

  /* Now look for GIN event */
  while(no_button)
    {
      XWindowEvent(disp,w,event_mask,&event);
      switch((int)event.type)
	{
	case KeyPress:
	  if (allow_keys)
	    {
	      XKeyEvent *key_event = (XKeyEvent *)(&event);
	      int length;
	      char buf[8];
	      KeySym ks;
	      
	      /* Get the key pressed! */
	      length = XLookupString(key_event,buf,8,&ks,&lookup_status);
	      if (length>0)
		{
		  *press = buf[0];
		  *x = key_event->x;
		  *y = key_event->y;
		  no_button = 0;
		}
	    }
	  break;
	case ButtonPress:
	  {
	    XButtonEvent *DiglibEvent = (XButtonEvent *)(&event);

	    if (DiglibEvent->button == Button3)
	      *press = bmap[2];
	    else if (DiglibEvent->button == Button2)
	      *press = bmap[1];
	    else if (DiglibEvent->button == Button1)
	      *press = bmap[0];
	    else
	      *press = bmap[3];
	    *x = DiglibEvent->x;
	    *y = DiglibEvent->y;
	    no_button = 0;
	  }
	  break;
	default:
	  gdx11_handle_digwin_event(dw,&event,0,0);
	  break;
	}
    }
  /* Remove cross_hair_cursor */
  XUndefineCursor(disp,w);
}


/*****************/
/* GET GIN INPUT */
/*****************/

static Cursor gin_cursor;
static int have_gin_cursor = 0;

static void gdx11_gin(dw,x_data,y_data) 
     DIGWin *dw;
     float *x_data, *y_data;
{
  int key;
  int x,y;

  /* Make sure we have a cross hair cursor */
  if (!have_gin_cursor)
    {
      gin_cursor = XCreateFontCursor(dw->xdisplay,XC_crosshair);
      have_gin_cursor = 1;
    }

  gdx11_get_input(dw,gin_cursor,1,button_map,&key,&x,&y);
  x_data[0] = key;
  x_data[1] = x_untranslate(dw,x);
  x_data[2] = y_untranslate(dw,y);
}


/**************************/
/* DEFINE COLOR USING HLS */
/**************************/

/* Not yet implemented, probably never will be */
static void gdx11_set_color_map_hls( op_code, x_data, y_data )
     int   *op_code;
     float *x_data, *y_data;
{
}



/**************************/
/* DEFINE COLOR USING RGB */
/**************************/

/* Not yet implemented */
/* Because colors are allocated READ-ONLY, this will take some work! */
static void gdx11_set_color_map_rgb(dw,x_data,y_data)
     DIGWin *dw;
     float *x_data, *y_data;
{
  int color_index = x_data[0];
}



/*********************/
/* GET LOCATOR INPUT */
/*********************/

static Cursor locator_cursor;
static int have_locator_cursor = 0;

static void gdx11_button_input(dw,x_data,y_data)
     DIGWin *dw;
     float *x_data, *y_data;
{
  int button;
  int x,y;
  char bmap[4];
  int i, j;

  for (i=0,j=1;i<4;++i)
    {
      bmap[i] = j;
      j*= 2;
    }

  /* Make sure we have a cross hair cursor */
  if (!have_locator_cursor)
    {
      gin_cursor = XCreateFontCursor(dw->xdisplay,XC_diamond_cross);
      have_locator_cursor = 1;
    }

  gdx11_get_input(dw,locator_cursor,0,bmap,&button,&x,&y);
  x_data[0] = button;
  x_data[1] = x_untranslate(dw,x);
  x_data[2] = y_untranslate(dw,y);
}



/***********************/
/* DRAW FILLED POLYGON */
/***********************/

static void gdx11_draw_polygon(dw,n,x_data,y_data)
     DIGWin *dw;
     int n;
     float *x_data, *y_data;
{
  int    i;
  Display *disp = dw->xdisplay;

  dw->current_x = x_translate(dw,x_data[n-1]);
  dw->current_y = y_translate(dw,y_data[n-1]);
  gdx11_start_polygon(dw,n+1,dw->current_x,dw->current_y);
  for ( i = 0; i < n; ++i)
    gdx11_add_point_to_polyline(dw,x_translate(dw,x_data[i]),
				y_translate(dw,y_data[i]));
  gdx11_end_polygon(dw);
}


/***********************/
/* GDX11 DEVICE DRIVER */
/***********************/

void
#ifdef NEED_TRAILING_UNDERSCORE
     gdx11_
#else
     gdx11
#endif
           ( op_code, x_data, y_data )
     int    *op_code;        /* holds the device independent op-code */
     float  *x_data;         /* x coordinate data */
     float  *y_data;         /* y coordinate data */
{
  /* An array of pointers to function */
  /*  i.e. a jump table that is global to this compilation unit */
  
  static void (* jump_table[MAX_OPCODE])() = 
    {
      gdx11_init_device,
      gdx11_clear_page,
      gdx11_move_to,
      gdx11_draw_to,
      gdx11_flush,
      gdx11_release_device,
      gdx11_return_device,
      gdx11_select_color,
      gdx11_gin,
      gdx11_set_color_map_rgb,
      gdx11_set_color_map_hls,
      gdx11_button_input,
      gdx11_draw_polygon
      };
  
  if (DEBUG>=3) fprintf(stderr,"GDX11 called, op_code = %d\n",*op_code);
  /* Check for correct op-code, and run */
  if (*op_code > 1024)
    jump_table[MAX_OPCODE-1](current_dw,*op_code-1024,x_data,y_data);
  else if ((0 <= *op_code) && (*op_code <= MAX_OPCODE-1))
    jump_table[*op_code-1](current_dw,x_data,y_data);
  if (DEBUG>=3) fprintf(stderr,"GDX11 done with op_code = %d\n",*op_code);
}
