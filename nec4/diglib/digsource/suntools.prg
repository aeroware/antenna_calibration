#ifndef lint
static  char sccsid[] = "@(#)suntools.c 1.26 84/02/02 SMI";
#endif

/*
 * Sun Microsystems, Inc.
 */

/*
 * Root window: Provides the background window for a screen.
 *	Put up environment manager menu.
 */

#include <suntool/tool_hs.h>
#include <sys/ioctl.h>
#include <sys/dir.h>
#include <sys/file.h>
#include <sys/wait.h>
#include <sys/resource.h>
#include <errno.h>
#include <stdio.h>
#include <pwd.h>
#include <suntool/menu.h>
#include <suntool/wmgr.h>

extern	int errno;

static	int	rootfd, rootnumber;
static	int	root_SIGCHLD, root_SIGWINCH;
static	struct	screen screen;

static	struct  pixwin *pixwin;

#define	SHELLTOOL_NAME	"shelltool"
#define	GFXTOOL_NAME	"gfxtool"
#define SIGTOOL_NAME    "/usr2/u0/sig/master/sigtool"

#define ROOT_QUIT	 (caddr_t)1
#define ROOT_KILL	 (caddr_t)2
#define ROOT_TTY	 (caddr_t)3
#define ROOT_CRT	 (caddr_t)4
#define ROOT_SIG         (caddr_t)5
#define ROOT_REFRESH	 (caddr_t)6

struct	menuitem root_items[] = 
{
   MENU_IMAGESTRING,	"New Shell",	  ROOT_TTY,
   MENU_IMAGESTRING,	"New Graphics",	  ROOT_CRT,
   MENU_IMAGESTRING,    "New SIG",        ROOT_SIG,
   MENU_IMAGESTRING,	"Exit",		  ROOT_QUIT,
   MENU_IMAGESTRING,	"ReDisplay All",  ROOT_REFRESH
};

struct	menu wmgr_rootmenubody = 
{
   MENU_IMAGESTRING,
   "Root Mgr",
   sizeof(root_items) / sizeof(struct menuitem),
   root_items,
   0,
   0
};

struct	menu *wmgr_rootmenu = &wmgr_rootmenubody;

#define	ROOTCOLOR_PATTERN	0
#define	ROOTCOLOR_FOREGROUND	1
#define	ROOTCOLOR_BACKGROUND	2

static	      rootcolor = ROOTCOLOR_PATTERN;
static  short cursor_image[CUR_MAXIMAGEWORDS];
mpr_static(cursor_pr, 
           8*sizeof(cursor_image[0]),
	   sizeof(cursor_image)/sizeof(cursor_image[0]), 
           1,
	   cursor_image);



main(argc, argv)
int  argc;
char     **argv;
{
   char	name[WIN_NAMESIZE],
        setupfile[MAXNAMLEN];
   int	_root_sigchldcatcher(), 
        _root_sigwinchcatcher();
   int	nextissetup = 0, 
        donosetup   = 0, 
        printname   = 0;


   /*  Parse cmd line */

   setupfile[0] = NULL;
   win_initscreenfromargv(&screen, argv);
   if (argv) 
   {
      char    **args;

      for ( args = ++argv; *args; args++) 
      {
         if (nextissetup) 
         {
            (void) sscanf(*args, "%s", setupfile);
      	    nextissetup = 0;
         } 
         else if ((strcmp(*args, "-s") == 0) && *(args+1))
         {
            nextissetup = 1;
         }
         else if (strcmp(*args, "-F") == 0)
         {
            rootcolor = ROOTCOLOR_FOREGROUND;
	 }
         else if (strcmp(*args, "-B") == 0)
         {
            rootcolor = ROOTCOLOR_BACKGROUND;
	 }
         else if (strcmp(*args, "-P") == 0)
         {
            rootcolor = ROOTCOLOR_PATTERN;
	 }
         else if (strcmp(*args, "-n") == 0)
         {
            donosetup = 1;
	 }
         else if (strcmp(*args, "-p") == 0)
         {
            printname = 1;
	 }
 	 else if (argc == 2 && *args[0] != '-')
         {  
            /*
	     * If only arg and not a flag then treat as
	     * setupfile (backward compatibility with 1.0).
	     */
             (void) sscanf(*args, "%s", setupfile);
	  }
      }
   }


   /*  Set up signal catchers */

	(void) signal(SIGCHLD,  _root_sigchldcatcher );
	(void) signal(SIGWINCH, _root_sigwinchcatcher);


	/* Create root window */

	if ((rootfd = win_screennew(&screen)) == -1) 
        {
 	   perror("suntools");
	   exit(1);
	}

	if (rootcolor != ROOTCOLOR_PATTERN) 
        {
	   struct  cursor cursor;

 	   cursor.cur_shape    = &cursor_pr;
	   win_getcursor(rootfd, &cursor);

	   cursor.cur_function = PIX_SRC^PIX_DST;
	   win_setcursor(rootfd, &cursor);
	}
	win_screenget(rootfd, &screen);


	/* Open pixwin */

	if ((pixwin = pw_open(rootfd)) == 0) 
	{
           fprintf(stderr, "%s not available for window system usage\n",
		            screen.scr_fbname);
           perror("suntools");
           exit(1);
        }


	/* Set up root's name in environment */

	win_fdtoname(rootfd, name);
	rootnumber = win_nametonumber(name);
	we_setparentwindow(name);

	if (printname)
        {
		fprintf(stderr, "suntools window name is %s\n", name);
	}


	/* Set up tool slot allocator */

	wmgr_setrectalloc(rootfd, 
	                  200, 
	                  40,
	                  0, 
	                  pixwin->pw_pixrect->pr_height-TOOL_ICONHEIGHT);

	/* Setup tty parameters for all terminal emulators that will start */
	{
	   int tty_fd;

	   tty_fd = open("/dev/tty", O_RDWR, 0);

	   if (tty_fd < 0)
           {
		ttysw_saveparms(2);	/* Try stderr */
	   }
	   else 
           {
	      ttysw_saveparms(tty_fd);
	      (void) close(tty_fd);
	   }
	}

	/* Draw background */

	_root_sigwinchhandler();


	/* Do initial window setup */

	if (!donosetup)
        {
		_root_initialsetup(setupfile);
	}


	/* Do window management loop */

	_root_winmgr();


	/* Lock screen before clear so that cursor in taken down */

	pw_lock(pixwin, &screen.scr_rect);
	pr_rop(pixwin->pw_pixrect,
	       screen.scr_rect.r_left, 
               screen.scr_rect.r_top,
	       screen.scr_rect.r_width, 
               screen.scr_rect.r_height, 
               PIX_CLR,
	       0, 
               0, 
               0);

	/* Destroy screen (will return)*/

	win_screendestroy(rootfd);
	exit(0);
}

_root_winmgr()
{
	struct	inputmask im;
	struct	inputevent event;
	struct	menuitem *mi;
	extern	struct menuitem *menu_display();
	int	keyexit = 0;


	/* Set up input mask so can do menu stuff */

	input_imnull(&im);
	im.im_flags |= IM_NEGEVENT;
	im.im_flags |= IM_ASCII;
	win_setinputcodebit(&im, SELECT_BUT);
	win_setinputcodebit(&im, MENU_BUT);
	win_setinputmask(rootfd, &im, (struct inputmask *)0, WIN_NULLLINK);


	/* Read and invoke menu items */
	for (;1;) 
        {
	   int ibits, nfds;

	   /*
	    * Use select (to see if have input) so will return on
	    * SIGWINCH or SIGCHLD.
	    */

	    ibits = 0;
	    ibits |= (1<<rootfd);
	    do 
            {
	       if (root_SIGCHLD)
               {
	          _root_sigchldhandler();
	       }
	       if (root_SIGWINCH)
               {
	          _root_sigwinchhandler();
	       }
	     } 

             while (root_SIGCHLD || root_SIGWINCH);

	     nfds = select(8*sizeof(ibits), 
                           &ibits, 
                           (int *)0, 
                           (int *)0,
		           (struct timeval *)0 );
 
	     if (nfds==-1) 
             {
	        if (errno == EINTR)
                {
		   /*
		    * Go around again so that signals can be
		    * handled.  ibits may be non-zero but should
		    * be ignored in this case and they will be
		    * selected again.
		    */
		    continue;
		}
	        else 
                {
	           perror("suntools");
 	           break;

	        }
	     }

	     if (ibits & (1<<rootfd)) 
             {
	        /*
		* Read will not block.
		*/
		if (input_readevent(rootfd, &event) < 0) 
                 {
		    if (errno != EWOULDBLOCK) 
                    {
		       perror("suntools");
		       break;
		    }
		 }
		} 
                else
                {
		   continue;
		}


		/*
		 * Escape for getting out of environment when no mouse around.
		 */

		if (keyexit && event.ie_code == CTRL(q))
                {
		   break;
		}

		keyexit = 0;

		if (event.ie_code == CTRL(d))
                {
              	   keyexit = 1;
		}

		if (event.ie_code != MENU_BUT || win_inputnegevent(&event))
		{
     	           continue;
		}



		/*
		 * Do menus
		 */

		if ((mi = menu_display(&wmgr_rootmenu, &event, rootfd))) 
                {
		   if (wmgr_handlerootmenuitem(wmgr_rootmenu, mi, rootfd) == -1)
                   {
		      break; /* quit was invoked */
		   }
		}
	}
	return;
}



_root_sigchldhandler()
{
   union	wait status;

   root_SIGCHLD = 0;

   while (wait3(&status, WNOHANG, (struct rusage *)0) > 0)
   {}
}



_root_sigwinchhandler()
{
   root_SIGWINCH = 0;
   pw_damaged(pixwin);
   switch (rootcolor) 
   {
      case ROOTCOLOR_PATTERN: pw_replrop(pixwin,
                                         screen.scr_rect.r_left, 
                                         screen.scr_rect.r_top,
                                         screen.scr_rect.r_width,
                                         screen.scr_rect.r_height, 
                                         PIX_SRC,
            	 	                 tool_bkgrd, 0, 0           );
                               break;

           default:           pw_writebackground(pixwin,
 		                                 screen.scr_rect.r_left, 
                                                 screen.scr_rect.r_top,
		                                 screen.scr_rect.r_width, 
                                                 screen.scr_rect.r_height,
		                                 (rootcolor == ROOTCOLOR_BACKGROUND)? PIX_CLR: PIX_SET);
   }
   pw_donedamaged(pixwin);
   return;
}



static _root_sigchldcatcher()
{
   root_SIGCHLD = 1;
}



static _root_sigwinchcatcher()
{
   root_SIGWINCH = 1;
}



char *_get_home_dir()
{
   extern         char   *getenv(),   *getlogin();
   extern struct  passwd *getpwnam(), *getpwuid();
   struct         passwd *passwdent;
                  char	 *home_dir = getenv("HOME"), *loginname;

   if (home_dir != NULL)
   {
      return(home_dir);
   }

   loginname = getlogin();

   if (loginname == NULL) 
   {
      passwdent = getpwuid(getuid());
   } 
   else 
   {
      passwdent = getpwnam(loginname);
   }

   if (passwdent == NULL) 
   {
      fprintf(stderr,
              "suntools: couldn't find user in password file.\n");
      return(NULL);
   }

   if (passwdent->pw_dir == NULL) 
   {
      fprintf(stderr,
 	      "suntools: no home directory in password file.\n");
       return(NULL);
   }
   return(passwdent->pw_dir);
}



#define	ROOT_ARGBUFSIZE		1000
#define	ROOT_SETUPFILE		"/.suntools"
#define	ROOT_MAXTOOLDELAY	10



_root_initialsetup(requestedfilename)
char              *requestedfilename;
{
   extern char  *strcpy(), *strncat(), *strncpy();

   register     i;

          FILE *file;

          char  filename[MAXNAMLEN], 
                programname[MAXNAMLEN],
                otherargs[ROOT_ARGBUFSIZE];

  struct rect   rectnormal, recticonic;

	 int	iconic, topchild, bottomchild, seconds;


   if (requestedfilename[0] == NULL) 
   {
      char *home_dir = _get_home_dir();


      if (home_dir == NULL)
      {
         return;
      }
      (void) strcpy(filename, home_dir);
      (void) strncat(filename, 
                     ROOT_SETUPFILE, 
                     sizeof(filename) - 1 - strlen(filename) - strlen(ROOT_SETUPFILE));
   } 
   else
   {
       (void) strncpy(filename, requestedfilename, sizeof(filename)-1);
   }

   if ((file = fopen(filename, "r")) == 0) 
   {
      if (requestedfilename[0] == NULL)
      {
         /*
          * No message if was trying to open default.
	  */
	  return;
      }
      fprintf(stderr, "suntools: couldn't open %s\n", filename);
      return;
   }
   for (;;) 
   {
      otherargs[0]   = '\0';
      programname[0] = '\0';
 
      i = fscanf(file, 
                 "%s%hd%hd%hd%hd%hd%hd%hd%hd%hD%[^\n]\n",
		 programname,
		 &rectnormal.r_left,  &rectnormal.r_top,
		 &rectnormal.r_width, &rectnormal.r_height,
		 &recticonic.r_left,  &recticonic.r_top,
		 &recticonic.r_width, &recticonic.r_height,
		 &iconic, otherargs);

       if (i == EOF)
       {
          break;
       }

       if (i < 10 || i > 11) 
       {
          fprintf(stderr,
	          "suntools: in file=%s fscanf gave %D, correct format is:\n",
	          filename, 
                  i);
          fprintf(stderr, 
                  "program open-left open-top open-width open-height close-left close-top close-width close-height iconicflag [args] <newline>\n");
		  continue;
       }

       /*
        * Handle WMGR_SETPOS requests.
	*/
	
       wmgr_figuretoolrect(rootfd, &rectnormal);
       wmgr_figureiconrect(rootfd, &recticonic);

       /*
        * Remember who top and bottom children windows are for use when
        * trying to determine when tool is installed.
        */

       topchild    = win_getlink(rootfd, WL_TOPCHILD);
       bottomchild = win_getlink(rootfd, WL_BOTTOMCHILD);

       /*
        * Fork tool.
        */

       (void) wmgr_forktool(programname, otherargs, &rectnormal, &recticonic, iconic);

       /*
        * Give tool chance to intall self in tree before starting next.
        */

       for (seconds = 0;seconds < ROOT_MAXTOOLDELAY;seconds++) 
       {
          sleep(1);
	  if (topchild    != win_getlink(rootfd, WL_TOPCHILD)   || 
              bottomchild != win_getlink(rootfd, WL_BOTTOMCHILD)   )
          {
				break;
	  }
       }
   }
   (void) fclose(file);
   return;
}



wmgr_handlerootmenuitem(menu, mi, rootfd)
struct	menu           *menu;
struct	menuitem             *mi;
int	                          rootfd;
{
          int  returncode = 0;
   struct rect recticon, rectnormal;

   /*
    * Get next default tool postions
    */

   rect_construct(&recticon, 
                  WMGR_SETPOS, 
                  WMGR_SETPOS,
	          WMGR_SETPOS, 
                  WMGR_SETPOS);
   rectnormal = recticon;

   switch (mi->mi_data) 
   {
      case ROOT_QUIT: returncode = wmgr_confirm(rootfd,
		                                "Press the left mouse button to confirm Exit.  \n To cancel, press the right mouse button now.");
		      break;

      case ROOT_TTY:  wmgr_figureiconrect(rootfd, &recticon);
		      wmgr_figuretoolrect(rootfd, &rectnormal);
		      (void) wmgr_forktool(SHELLTOOL_NAME, 
                                          (char *)0,
		                          &rectnormal, 
                                          &recticon, 
                                          0/*!iconic*/);
		      break;

	case ROOT_CRT: wmgr_figureiconrect(rootfd, &recticon);
	 	       wmgr_figuretoolrect(rootfd, &rectnormal);
		       (void) wmgr_forktool(GFXTOOL_NAME, 
                                            (char *)0,
		                            &rectnormal, 
                                            &recticon, 
                                            0/*!iconic*/);
		       break;

	case ROOT_SIG: wmgr_figureiconrect(rootfd, &recticon);

                       /* Make the sigtool window a little longer */
                
                       rectnormal.r_height = 800;
                       rectnormal.r_top    = 0;
                       rectnormal.r_left   = 312;
	 	       wmgr_figuretoolrect(rootfd, &rectnormal);

		       (void) wmgr_forktool(SIGTOOL_NAME, 
                                            (char *)0,
		                            &rectnormal, 
                                            &recticon, 
                                            0/*!iconic*/);
		       break;

	case ROOT_REFRESH: wmgr_refreshwindow(rootfd);
		           break;
   } 
   return(returncode);
}

