// Header for MPCLIB.C
// 2025 remeny

#ifndef PATCHRESS_UTILS_H
#define PATCHRESS_UTILS_H

#ifdef __cplusplus
extern "C" {
#endif

// ---[ Boolean type ]--- //
#if !defined(__cplusplus)
    #if __STDC_VERSION__ >= 199901L
        #include <stdbool.h>
    #else
        typedef int bool;
        #define true  1
        #define false 0
    #endif
#endif

// ---[ Special key codes [getch()] ]--- //
#define EXT_KEY       0
#define BACKSPACE_KEY 8
#define ENTER_KEY     13
#define ESC_KEY       27
#define F3_KEY        61
#define UP_KEY        72
#define LEFT_KEY      75
#define RIGHT_KEY     77
#define DOWN_KEY      80
#define TILDE_KEY     96

// ---[ Arrows & UI symbols ]--- //
#define UP_ARROW      24    // ↑
#define DOWN_ARROW    25    // ↓
#define RIGHT_ARROW   26    // →
#define LEFT_ARROW    27    // ←

#define BLOCK_FULL    219   // █
#define BLOCK_DARK    178   // ▓
#define BLOCK_MED     177   // ▒
#define BLOCK_LIGHT   176   // ░

#define BULLET        7     // •
#define SMILE         1     // ☺
#define HEART         3     // ♥

// ---[ IBM PC / CP437 box-drawing characters ]--- //
// Single-line box
#define H_LINE        196   // ─
#define V_LINE        179   // │
#define TOP_LEFT      218   // ┌
#define TOP_RIGHT     191   // ┐
#define BOTTOM_LEFT   192   // └
#define BOTTOM_RIGHT  217   // ┘

// Double-line box
#define DH_LINE       205   // ═
#define DV_LINE       186   // ║
#define DTOP_LEFT     201   // ╔
#define DTOP_RIGHT    187   // ╗
#define DBOTTOM_LEFT  200   // ╚
#define DBOTTOM_RIGHT 188   // ╝

// Mixed connectors
#define T_DOWN        194   // ┬
#define T_UP          193   // ┴
#define T_RIGHT       195   // ├
#define T_LEFT        180   // ┤
#define CROSS         197   // ┼

// Double-line connectors
#define DT_DOWN       203   // ╦
#define DT_UP         202   // ╩
#define DT_RIGHT      204   // ╠
#define DT_LEFT       185   // ╣
#define DCROSS        206   // ╬

// ---[ Mixed single/double connectors (CP437) ]--- //
#define DV_T_LEFT     182   // ╢
#define DV_T_RIGHT    199   // ╟

// ---[ Save and restore screen items ]--- //
//
// 'var' must be declared in your code as:
//    struct text_info var;
//
// Save position and color (text attributes):
#define save_pos_and_color(var) gettextinfo(&var);
// Save position:
#define save_pos(var) save_pos_and_color(var);
// Save color:
#define save_color(var) save_pos_and_color(var);
// Restore position:
#define restore_pos(var) gotoxy(var.curx, var.cury);
// Restore color:
#define restore_color(var) textattr(var.attribute);
// Restore position and color:
#define restore_pos_and_color(var) { restore_pos(var); restore_color(var); }

// ---[ Other Defines ]--- //
#define MIN_SCREEN_COLS 80
#define MIN_SCREEN_ROWS 25
#define MAX_SCREEN_COLS 132 // Apparently 60*132 is the max possible vid out for dos
#define MAX_SCREEN_ROWS 60

// ---[ Structures ]--- //
typedef struct {
    bool animate;
    bool show_cursor;
    bool fat_cursor;
    bool verbose;
    bool v_pause;
    bool v_log;
    bool v_word_by_word;
    bool v_status_as_debug;
} Flags;

// ---[ Box drawing presets ]--- //
#define BOX_SINGLE 0
#define BOX_DOUBLE 1
#define BOX_PRESET_COUNT 2

// Box character set definition
struct box_chars {
    unsigned char tl;  // top-left corner
    unsigned char tr;  // top-right corner
    unsigned char bl;  // bottom-left corner
    unsigned char br;  // bottom-right corner
    unsigned char h;   // horizontal line
    unsigned char v;   // vertical line
};

// Preset table (IBM PC CP437)
static const struct box_chars BOX_PRESETS[BOX_PRESET_COUNT] = {
    // BOX_SINGLE
    {
        TOP_LEFT,      // tl ┌ 218
        TOP_RIGHT,     // tr ┐ 191
        BOTTOM_LEFT,   // bl └ 192
        BOTTOM_RIGHT,  // br ┘ 217
        H_LINE,        // h  ─ 196
        V_LINE         // v  │ 179
    },

    // BOX_DOUBLE
    {
        DTOP_LEFT,     // tl ╔ 201
        DTOP_RIGHT,    // tr ╗ 187
        DBOTTOM_LEFT,  // bl ╚ 200
        DBOTTOM_RIGHT, // br ╝ 188
        DH_LINE,       // h  ═ 205
        DV_LINE        // v  ║ 186
    }
};

// ---[ Libraries ]--- //
#include <dir.h> // For MAXPATH

// ---[ Global Variables ]--- //
extern Flags flags;
extern int screen_rows, screen_cols;
extern char logfile[MAXPATH]; // <--- File to be used if logging is enabled

// ---[ Function declarations ]--- //
void get_screen_size(void);
void save_screen(unsigned char *screen_buffer);
void restore_screen(unsigned char *screen_buffer);
void log(const char* fmt, ...);
void crash(const char* fmt, ...);
void dbg(const char* fmt, ...);
int count_arrays(char *arr[]);
bool presence_in_array(char* arr[], char* item);
bool arg_check(char* arr[], char* item);
void status(const char *fmt, ...);
void intro(void);
void intro_reverse(void);
void title(const char* fmt, ...);
void print_page(const char* fmt, ...);
void wipe(void);
void window(const int x, const int y, const int width, const int height);
void window_off(const int x, const int y, const int width, const int height);
int selector(bool enable_esc, bool enable_f3, char *items[]);
int selector_noscroll(bool enable_esc, bool enable_f3, char *items[]);
bool file_exists(const char *fmt, ...);
int dir_exists(const char *fmt, ...);
int copy_file(const char *src, const char *dst);
int remove_file(const char *fmt, ...);
int remove_folder(const char *fmt, ...);
int move_file(const char *src, const char *dst);
char **build_argv(const char *prog_name, const char *arg_str);
void join(char *o, char *a[]);
void input(char str_buffer[], const int length, const char *default_str);
void input_num(long *buf, int maxlen, const long def);
bool yesno(const bool enable_F3, const char *fmt, ...);
int file_append(const char *fname, const char *fmt, ...);
int file_prepend(const char *fname, const char *fmt, ...);
char *fmt_str(const char *fmt, ...);
int save_attrs(int *out_attr, const char *fmt, ...);
int clear_RHS(const char *fmt, ...);
int restore_attrs(int original, const char *fmt, ...);
void validate_mpc_args(char *argv[]);
void box(int x, int y, int width, int height, int preset);

// End of extern "C" block
#ifdef __cplusplus
}
#endif

#endif // PATCHRESS_UTILS_H