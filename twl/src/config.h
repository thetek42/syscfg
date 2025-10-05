#ifndef CONFIG_H_
#define CONFIG_H_

#include <libinput.h>
#include <linux/input-event-codes.h>
#include <stdbool.h>
#include <stdint.h>
#include <wayland-server-protocol.h>
#include <wlr/types/wlr_keyboard.h>
#include <wlr/types/wlr_output_layout.h>
#include <wlr/util/log.h>
#include <xkbcommon/xkbcommon.h>
#include <X11/XF86keysym.h>

/******************************************************************************/

typedef enum {
	SchemeNorm,
	SchemeSel,
	SchemeUrg,
	_SchemeCount,
} Scheme;

typedef enum {
	ResizeCornerTopLeft = 0,
	ResizeCornerTopRight = 1,
	ResizeCornerBottomLeft = 2,
	ResizeCornerBottomRight = 3,
	ResizeCornerClosestToCursor = 4,
} ResizeCorner;

typedef struct {
	const char *id;
	const char *title;
	uint32_t tags;
	int isfloating;
	int monitor;
} Rule;

typedef struct {
	const char *symbol;
	void (*arrange)(void *);
} Layout;

typedef struct {
	const char *name;
	float mfact;
	int nmaster;
	float scale;
	const Layout *lt; /* must point to something in `layouts` */
	enum wl_output_transform rr; /* rotate/reflect */
	int x, y;
} MonitorRule;

typedef union {
	int i;
	uint32_t ui;
	float f;
	const void *v;
} Arg;

typedef struct {
	uint32_t mod;
	xkb_keysym_t keysym;
	void (*func)(const Arg *);
	const Arg arg;
} Key;

typedef enum {
	ClkTagBar,
	ClkLtSymbol,
	ClkStatus,
	ClkTitle,
	ClkClient,
	ClkRoot,
} Click;

typedef struct {
	Click click;
	unsigned int mod;
	unsigned int button;
	void (*func)(const Arg *);
	const Arg arg;
} Button;

typedef enum {
	CurNormal,
	CurPressed,
	CurMove,
	CurResize,
} CursorMode;

typedef uint32_t Color;

/* declarations for various functions located in twl.c */
/* TODO: move this to a more sensible place */
extern void chvt(const Arg *arg);
extern void focusmon(const Arg *arg);
extern void focusstack(const Arg *arg);
extern void incnmaster(const Arg *arg);
extern void killclient(const Arg *arg);
extern void monocle(void *);
extern void moveresize(const Arg *arg);
extern void quit(const Arg *arg);
extern void setlayout(const Arg *arg);
extern void setmfact(const Arg *arg);
extern void spawn(const Arg *arg);
extern void tag(const Arg *arg);
extern void tagmon(const Arg *arg);
extern void tile(void *);
extern void togglebar(const Arg *arg);
extern void togglefloating(const Arg *arg);
extern void togglefullscreen(const Arg *arg);
extern void toggletag(const Arg *arg);
extern void toggleview(const Arg *arg);
extern void view(const Arg *arg);
extern void zoom(const Arg *arg);

/******************************************************************************/

/* appearance */
extern const bool sloppyfocus; /* focus follows mouse */
extern const bool bypass_surface_visibility; /* true means idle inhibitors will disable idle tracking even if it's surface isn't visible  */
extern const int cursor_timeout; /* seconds to wait before hiding mouse cursor */
extern const unsigned int borderpx; /* border pixel or windows */
extern const bool showbar; /* false means no bar */
extern const bool topbar; /* false means bottom bar */
extern const char *barfont; /* the font to use for the bar */
extern const Color rootcolor; /* desktop wallpaper colour */
extern const Color fullscreen_bg; /* background color for fullscreen apps */
extern const Color colors[_SchemeCount][3]; /* window frame and bar colors, use Scheme for indices and {fg, bg, border} for values */

/* logging */
extern enum wlr_log_importance log_level;

/* rules */
/* array must be terminated with {0} */
extern const Rule rules[];

/* layouts */
/* array must be terminated with {0} */
/* when specifying .arrange = NULL, it means floating behaviour */
extern const Layout layouts[];

/* monitors */
/* array must be terminated with a rule that has .name = NULL */
/* .name = NULL means that this is the default/fallback rule */
/* only one default/fallback rule is possible (obviously) */
/* (x=-1, y=-1) is reserved as an "autoconfigure" monitor position indicator */
/* negative values other than (x=-1, y=-1) cause problems with xwayland */
extern const MonitorRule monrules[];

/* keyboard */
extern const struct xkb_rule_names xkb_rules; /* keyboard layout and options */
extern const bool numlock;
extern const bool capslock;
extern const int repeat_rate;
extern const int repeat_delay;

/* trackpad */
extern const bool tap_to_click;
extern const bool tap_and_drag;
extern const bool drag_lock;
extern const bool natural_scrolling;
extern const bool disable_while_typing;
extern const bool left_handed;
extern const bool middle_button_emulation;
extern const double accel_speed;
extern const enum libinput_config_scroll_method scroll_method;
extern const enum libinput_config_click_method click_method;
extern const enum libinput_config_send_events_mode send_events_mode;
extern const enum libinput_config_accel_profile accel_profile;
extern const enum libinput_config_tap_button_map button_map;

/* keyboard mappings */
/* array must be terminated with {0} */
extern const Key keys[];

/* mouse button mappings */
/* array must be terminated with {0} */
extern const Button buttons[];

#endif /* CONFIG_H_ */
