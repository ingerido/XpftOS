/*
 *	/include/hal/console.h
 * 
 *	Author: Yujie REN
 *	Date:	2017.8
 *
 *  console HAL
 */
#ifndef _CONSOLE_H
#define _CONSOLE_H

#include <stddef.h>
#include <stdint.h>

/* arch specific function */
extern void init_tty_io();

extern void tty_put_c(char c, uint8_t color);

extern void tty_put_s(const char* str, uint8_t color);

extern void tty_put_i(uint32_t i, uint8_t color);

/* hal unified function */
void console_init();

void console_write_char(char c, uint8_t color);

void console_write_string(const char* str, uint8_t color);

void console_write_int(uint32_t i, uint8_t color);

#endif
