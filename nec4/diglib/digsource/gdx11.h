/***************************/
/* DIGLIB Window Structure */
/***************************/

/* Note: User's should treat all DIGWin structures as READ-ONLY */
/*  However, in general, user's should even read these fields!  */

#define DIGWIN_TYPE DIGWin

typedef struct DIGWin
{
  Window xwin;
  Display *xdisplay;
  XWindowAttributes xwa;
  GC xgc;
  int num_fg_colors;
  int pixel_value_for_color[8];
  int current_x;
  int current_y;
  int current_pixel_value;
  int min_x;
  int max_x;
  int min_y;
  int max_y;
  int abs_min_max;
  int x_border;
  int y_border;
  int x_offset;
  int x_len;
  float x_scale;
  int y_offset;
  int y_len;
  float y_scale;
  int next_point;
  int npolylines;
  int *npoints;
  int *polyline_pixel_value;
  XPoint *points;
} DIGWin;
