/*
 *	/include/kernel/core/tty.h
 * 
 *	Author: Yujie REN
 *	Date:	2017.8
 *
 *  TTY related
 */
#ifndef _TTY_H
#define _TTY_H

#include <stddef.h>
#include <stdint.h>
 
// First, let's do some basic checks to make sure we are using our x86-elf cross-compiler correctly
#if defined(__linux__)
	#error "This code must be compiled with a cross-compiler"
#elif !defined(__i386__)
	#error "This code must be compiled with an x86-elf compiler"
#endif


#define VGA_BUF 0xC00B8000

#define VGA_COLS 80
#define VGA_ROWS 25

/* cursor related */
void enable_cursor(uint8_t cursor_start, uint8_t cursor_end);

void disable_cursor();

uint16_t get_cursor();

void update_cursor();

/* tty io */
void init_tty_io();

void tty_put_c(char c);

void tty_put_s(const char* str);

#endif
