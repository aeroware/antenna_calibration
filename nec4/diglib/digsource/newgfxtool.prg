#ifndef lint
static	char sccsid[] = "@(#)gfxtool.c 1.1 86/01/09 Copyr 1984 Sun Micro";
#endif

/*
 * Copyright (c) 1984 by Sun Microsystems, Inc.
 */

/*
 *  gfxtool - run a process in a tty subwindow with a separate graphic area
 *	** MODIFIED **  by Steve Azevedo LLNL	86/05/04
 *		This version accepts a "-Tnnn" argument on the execute line
 *		to change the text subwindow height (nnn is the number of
 *		pixels in height).  Default is 200 as before.
 */

#include <stdio.h>
#include <suntool/tool_hs.h>
#include <suntool/ttysw.h>
#include <suntool/ttytlsw.h>
#include <suntool/emptysw.h>

extern	char *getenv();
extern	caddr_t ttytlsw_create();

static	sigtermcatcher();

static	Tool *tool;
static	caddr_t ttysw;

static short ic_image[258] = {
#include <images/gfxtool.icon>
};
mpr_static(gfxic_mpr, 64, 64, 1, ic_image);

static	struct icon icon = {64, 64, (struct pixrect *)NULL, 0, 0, 64, 64,
	    &gfxic_mpr, 0, 0, 0, 0, NULL, (struct pixfont *)NULL,
	    ICON_BKGRDCLR};

main(argc, argv)
	int argc;
	char **argv;
{
	char	**tool_attrs = NULL;
	int	become_console = 0;
	char	*tool_name = argv[0], *tmp_str;
	static	char *label_default = "Graphics Tool 3.0";
	static	char *label_console = " (CONSOLE): ";
	static	char label[150];
	static	char icon_label[30];
	static	char *sh_argv[2]; /* Let default to {NULL, NULL} */
	Emptysw	*emptysw;
	char    name[WIN_NAMESIZE];
	int	child_pid;
	Notify_value wait_child();
	extern	tool_sigchld();
	int	text_size = 200;	/* Y-size of the text segment */
	
	argv++;
	argc--;
	/*
	 * Pick up command line arguments to modify tool behavior
	 */
	if (tool_parse_all(&argc, argv, &tool_attrs, tool_name) == -1) {
		tool_usage(tool_name);
		exit(1);
	}
	/*
	 * Get ttysw related args
	 */
	while (argc > 0 && **argv == '-') {
		switch (argv[0][1]) {
		case 'T':
			text_size = atoi(&argv[0][2]);
			break;
		case 'C':
			become_console = 1;
			break;
		case '?':
			tool_usage(tool_name);
			fprintf(stderr, "To make the console use -C\n");
			exit(1);
		default:
			;
		}
		argv++;
		argc--;
	}
	if (argc == 0) {
		argv = sh_argv;
		if ((argv[0] = getenv("SHELL")) == NULL)
			argv[0] = "/bin/sh";
	}
	/*
	 * Set default icon label
	 */
	if (tool_find_attribute(tool_attrs, WIN_LABEL, &tmp_str)) {
		/* Using tool label supplied on command line */
		strncat(icon_label, tmp_str, sizeof(icon_label));
		tool_free_attribute(WIN_LABEL, tmp_str);
	} else if (become_console)
		strncat(icon_label, "CONSOLE", sizeof(icon_label));
	else
		/* Use program name that is run under ttysw */
		strncat(icon_label, argv[0], sizeof(icon_label));
	/*
	 * Buildup tool label
	 */
	strcat(label, label_default);
	if (become_console)
		strcat(label, label_console);
	else
		strcat(label, ": ");
	strncat(label, *argv, sizeof(label)-
	    strlen(label_default)-strlen(label_console)-1);
	/*
	 * Create tool window
	 */
	tool = tool_begin(
	    WIN_LABEL,		label,
	    WIN_NAME_STRIPE,	1,
	    WIN_BOUNDARY_MGR,	1,
	    WIN_ICON,		&icon,
	    WIN_ICON_LABEL,	icon_label,
	    WIN_ATTR_LIST,	tool_attrs,
	    0);
	if (tool == (struct tool *)NULL)
		exit(1);
	tool_free_attribute_list(tool_attrs);
	/*
	 * Create tty tool subwindow
	 */
	ttysw = ttytlsw_create(tool, "ttysw", TOOL_SWEXTENDTOEDGE,
	    text_size);
	if (ttysw == (caddr_t)NULL)
		exit(1);
        /* Create empty subwindow for graphics */
        emptysw = esw_begin(tool, "emptysw",
            TOOL_SWEXTENDTOEDGE, TOOL_SWEXTENDTOEDGE);
        if (emptysw == (Emptysw *)NULL)
                exit(1);
	/* Install tool in tree of windows */
	(void) notify_set_signal_func(tool, tool_sigchld, SIGCHLD,
	                              NOTIFY_ASYNC);
	(void) notify_set_signal_func(tool, sigtermcatcher, SIGTERM,
	                              NOTIFY_ASYNC);
	tool_install(tool);
	/* Start tty process */
        win_fdtoname(win_get_fd(emptysw), name);
        we_setgfxwindow(name);
	if (become_console)
		ttysw_becomeconsole(ttysw);
	if ((child_pid = ttysw_start(ttysw, argv)) == -1) {
		perror(tool_name);
		exit(1);
	}
	/* Wait for child process to die */
	(void) notify_set_wait3_func(tool, wait_child, child_pid);
	/* Handle notifications */
	(void) notify_start();
	exit(0);
}

static
sigtermcatcher()
{
	/* Special case: Do ttysw related cleanup (e.g., /etc/utmp) */
	ttysw_done(ttysw);
	exit(0);
}

static
Notify_value
wait_child(tool, pid, status, rusage)
	Tool *tool;
	int pid;
	union wait *status;
	struct rusage *rusage;
{
	/* Note: Could handle child stopping differently from child death */
	/* Break out of notification loop */
	(void) notify_stop();
	return(NOTIFY_DONE);
}
