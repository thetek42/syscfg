#include "config.h"

/* appearance */
const bool sloppyfocus = true;
const bool bypass_surface_visibility = false;
const int cursor_timeout = 10;
const unsigned int borderpx = 1;
const bool showbar = true;
const bool topbar = true;
const char *barfont = "Roboto Mono:size=10";
const Color rootcolor = 0x000000ff;
const Color fullscreen_bg = 0x000000ff;
const Color colors[_SchemeCount][3] = { /* {fg, bg, border} */
	[SchemeNorm] = { 0xbbbbbbff, 0x151515ff, 0x151515ff },
	[SchemeSel]  = { 0xe1e1e1ff, 0x304f50ff, 0x304f50ff },
	[SchemeUrg]  = { 0,          0,          0xac4142ff },
};

/* logging */
enum wlr_log_importance log_level = WLR_ERROR;

/* rules */
const Rule rules[] = {
	{0},
};

/* layouts */
const Layout layouts[] = {
	{ "[]=", tile },
	{ "><>", NULL }, /* float */
	{ "[M]", monocle },
	{0},
};

/* monitors */
const MonitorRule monrules[] = {
	{ NULL, 0.5f, 1, 1, &layouts[0], WL_OUTPUT_TRANSFORM_NORMAL, -1, -1 },
};

/* keyboard */
const struct xkb_rule_names xkb_rules = {
	.layout = "demod",
	.options = "ctrl:nocaps",
};
const bool numlock = true;
const bool capslock = false;
const int repeat_rate = 25;
const int repeat_delay = 600;

/* trackpad */
const bool tap_to_click = true;
const bool tap_and_drag = true;
const bool drag_lock = true;
const bool natural_scrolling = false;
const bool disable_while_typing = true;
const bool left_handed = false;
const bool middle_button_emulation = false;
const double accel_speed = 1.0;
const enum libinput_config_scroll_method scroll_method = LIBINPUT_CONFIG_SCROLL_2FG;
const enum libinput_config_click_method click_method = LIBINPUT_CONFIG_CLICK_METHOD_BUTTON_AREAS;
const enum libinput_config_send_events_mode send_events_mode = LIBINPUT_CONFIG_SEND_EVENTS_ENABLED;
const enum libinput_config_accel_profile accel_profile = LIBINPUT_CONFIG_ACCEL_PROFILE_ADAPTIVE;
const enum libinput_config_tap_button_map button_map = LIBINPUT_CONFIG_TAP_MAP_LRM;

/* keyboard mappings **********************************************************/

#define MODKEY WLR_MODIFIER_LOGO

#define TAGKEYS(KEY,SKEY,TAG) \
	{ MODKEY,                    KEY,            view,            {.ui = 1 << TAG} }, \
	{ MODKEY|WLR_MODIFIER_CTRL,  KEY,            toggleview,      {.ui = 1 << TAG} }, \
	{ MODKEY|WLR_MODIFIER_SHIFT, SKEY,           tag,             {.ui = 1 << TAG} }, \
	{ MODKEY|WLR_MODIFIER_CTRL|WLR_MODIFIER_SHIFT,SKEY,toggletag, {.ui = 1 << TAG} }

/* commands */
static const char *termcmd[]         = { "foot", NULL };
static const char *pdfcmd[]          = { "zathura", NULL };
static const char *browsercmd[]      = { "firefox", "--no-remote", "--profile", ".mozilla/firefox/myprofile", NULL };
static const char *menucmd[]         = { "wmenu-run", "-f", "Roboto Mono 10", "-N", "151515", "-n", "bbbbbb", "-S", "304f50", "-s", "e1e1e1", NULL };
static const char *vol_up[]          = { "pactl", "set-sink-volume", "@DEFAULT_SINK@", "+2%",    NULL };
static const char *vol_down[]        = { "pactl", "set-sink-volume", "@DEFAULT_SINK@", "-2%",    NULL };
static const char *vol_mute[]        = { "pactl", "set-sink-mute",   "@DEFAULT_SINK@", "toggle", NULL };
static const char *screenshot_area[] = { "screenshot-area.sh", NULL };
static const char *screenshot_full[] = { "screenshot-full.sh", NULL };
static const char *wlockcmd[]        = { "wlock", NULL };

const Key keys[] = {
	/* Note that Shift changes certain key codes: c -> C, 2 -> at, etc. */
	/* modifier                  key                 function        argument */
	{ MODKEY,                    XKB_KEY_space,      spawn,          {.v = menucmd} },
	{ MODKEY,                    XKB_KEY_Return,     spawn,          {.v = termcmd} },
	{ MODKEY,                    XKB_KEY_w,          spawn,          {.v = browsercmd} },
	{ MODKEY,                    XKB_KEY_z,          spawn,          {.v = pdfcmd} },

	{ MODKEY,                    XKB_KEY_b,          togglebar,      {0} },
	{ MODKEY,                    XKB_KEY_j,          focusstack,     {.i = +1} },
	{ MODKEY,                    XKB_KEY_k,          focusstack,     {.i = -1} },
	{ MODKEY,                    XKB_KEY_i,          incnmaster,     {.i = +1} },
	{ MODKEY,                    XKB_KEY_d,          incnmaster,     {.i = -1} },
	{ MODKEY,                    XKB_KEY_h,          setmfact,       {.f = -0.05f} },
	{ MODKEY,                    XKB_KEY_l,          setmfact,       {.f = +0.05f} },
	{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_Return,     zoom,           {0} },
	{ MODKEY,                    XKB_KEY_Tab,        view,           {0} },
	{ MODKEY,                    XKB_KEY_q,          killclient,     {0} },
	{ MODKEY,                    XKB_KEY_t,          setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                    XKB_KEY_f,          setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                    XKB_KEY_m,          setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                    XKB_KEY_p,          setlayout,      {0} },
	{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_space,      togglefloating, {0} },
	{ MODKEY,                    XKB_KEY_e,         togglefullscreen, {0} },
	{ MODKEY,                    XKB_KEY_0,          view,           {.ui = ~0} },
	{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_parenright, tag,            {.ui = ~0} },
	{ MODKEY,                    XKB_KEY_comma,      focusmon,       {.i = WLR_DIRECTION_LEFT} },
	{ MODKEY,                    XKB_KEY_period,     focusmon,       {.i = WLR_DIRECTION_RIGHT} },
	{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_less,       tagmon,         {.i = WLR_DIRECTION_LEFT} },
	{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_greater,    tagmon,         {.i = WLR_DIRECTION_RIGHT} },
	TAGKEYS(          XKB_KEY_1, XKB_KEY_exclam,                     0),
	TAGKEYS(          XKB_KEY_2, XKB_KEY_quotedbl,                   1),
	TAGKEYS(          XKB_KEY_3, XKB_KEY_section,                    2),
	TAGKEYS(          XKB_KEY_4, XKB_KEY_dollar,                     3),
	TAGKEYS(          XKB_KEY_5, XKB_KEY_percent,                    4),
	TAGKEYS(          XKB_KEY_6, XKB_KEY_ampersand,                  5),
	TAGKEYS(          XKB_KEY_7, XKB_KEY_slash,                      6),
	TAGKEYS(          XKB_KEY_8, XKB_KEY_parenleft,                  7),
	TAGKEYS(          XKB_KEY_9, XKB_KEY_parenright,                 8),
	{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_X,          spawn,          {.v = wlockcmd} },
	{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_Q,          quit,           {0} },

	{ 0,                      XKB_KEY_XF86AudioMute, spawn,          {.v = vol_mute} },
	{ 0,               XKB_KEY_XF86AudioRaiseVolume, spawn,          {.v = vol_up} },
	{ 0,               XKB_KEY_XF86AudioLowerVolume, spawn,          {.v = vol_down} },
	{ 0,                              XKB_KEY_Print, spawn,          {.v = screenshot_area} },
	{ WLR_MODIFIER_SHIFT,             XKB_KEY_Print, spawn,          {.v = screenshot_full} },

	/* Ctrl-Alt-Backspace and Ctrl-Alt-Fx used to be handled by X server */
	{ WLR_MODIFIER_CTRL|WLR_MODIFIER_ALT,XKB_KEY_Terminate_Server, quit, {0} },
	/* Ctrl-Alt-Fx is used to switch to another VT, if you don't know what a VT is
	 * do not remove them.
	 */
#define CHVT(n) { WLR_MODIFIER_CTRL|WLR_MODIFIER_ALT,XKB_KEY_XF86Switch_VT_##n, chvt, {.ui = (n)} }
	CHVT(1), CHVT(2), CHVT(3), CHVT(4), CHVT(5), CHVT(6),
	CHVT(7), CHVT(8), CHVT(9), CHVT(10), CHVT(11), CHVT(12),

	{0},
};

/* button mappings ************************************************************/

const Button buttons[] = {
	{ ClkLtSymbol, 0,      BTN_LEFT,   setlayout,      {.v = &layouts[0]} },
	{ ClkLtSymbol, 0,      BTN_RIGHT,  setlayout,      {.v = &layouts[2]} },
	{ ClkTitle,    0,      BTN_MIDDLE, zoom,           {0} },
	{ ClkStatus,   0,      BTN_MIDDLE, spawn,          {.v = termcmd} },
	{ ClkClient,   MODKEY, BTN_LEFT,   moveresize,     {.ui = CurMove} },
	{ ClkClient,   MODKEY, BTN_MIDDLE, togglefloating, {0} },
	{ ClkClient,   MODKEY, BTN_RIGHT,  moveresize,     {.ui = CurResize} },
	{ ClkTagBar,   0,      BTN_LEFT,   view,           {0} },
	{ ClkTagBar,   0,      BTN_RIGHT,  toggleview,     {0} },
	{ ClkTagBar,   MODKEY, BTN_LEFT,   tag,            {0} },
	{ ClkTagBar,   MODKEY, BTN_RIGHT,  toggletag,      {0} },
	{0},
};
