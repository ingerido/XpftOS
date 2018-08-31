/*
 *	/include/hal/tty.h
 * 
 *	Author: Yujie REN
 *	Date:	2017.8
 *
 *  tty HAL
 */
#ifndef _TTY_H
#define _TTY_H

#include <stddef.h>
#include <stdint.h>

/* arch specific function */
extern void init_vga();

extern void vga_put_c(char c, uint8_t color);

extern void vga_put_s(const char* str, uint8_t color);

extern void vga_put_i(uint32_t i, uint8_t color);

/* hal unified function */
void tty_init();

void tty_put_c(char c, uint8_t color);

void tty_put_s(const char* str, uint8_t color);

void tty_put_i(uint32_t i, uint8_t color);

#endif
