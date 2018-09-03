/*
 *	hal/tty.c
 * 
 *	Author: Yujie REN
 *	Date:	2017.8
 *
 *  tty console HAL
 */

#include <kernel/tty.h>

void tty_init() {
	init_vga();
}

void tty_put_c(char c, uint8_t color) {
	vga_put_c(c, color);
}

void tty_put_s(const char* str, uint8_t color) {
	vga_put_s(str, color);
}

void tty_put_i(uint32_t i, uint8_t color) {
	vga_put_i(i, color);
}
