/*
 *	/include/kernel/core/tty.h
 * 
 *	Author: Yujie REN
 *	Date:	2017.8
 *
 *  TTY related
*/

#define VGA_BUF 0xC00B8000

#define VGA_COLS 80;
#define VGA_ROWS 25;

/* cursor related */
void enable_cursor(uint8_t cursor_start, uint8_t cursor_end);

void disable_cursor();

void update_cursor(uint8_t x, uint8_t y);

/* tty io */
void init_tty_io();

void tty_put_c();

void tty_put_s();

