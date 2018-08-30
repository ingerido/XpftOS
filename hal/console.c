/*
 *	hal/console.c
 * 
 *	Author: Yujie REN
 *	Date:	2017.8
 *
 *  console HAL
 */

#include <hal/console.h>

void console_init() {
	init_tty_io();
}

void console_write_char(char c, uint8_t color) {
	tty_put_c(c, color);
}

void console_write_string(const char* str, uint8_t color) {
	tty_put_s(str, color);
}

void console_write_int(uint32_t i, uint8_t color) {
	tty_put_i(i, color);
}
