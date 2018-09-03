/*
 *	/include/arch/x86/vga.h
 * 
 *	Author: Yujie REN
 *	Date:	2017.8
 *
 *  VGA related
 */
#ifndef _VGA_H
#define _VGA_H

#include <types.h>
 
// First, let's do some basic checks to make sure we are using our x86-elf cross-compiler correctly
#if defined(__linux__)
	#error "This code must be compiled with a cross-compiler"
#elif !defined(__i386__)
	#error "This code must be compiled with an x86-elf compiler"
#endif

#define VGA_COLS 80
#define VGA_ROWS 25

/* cursor related */
void enable_cursor(uint8_t cursor_start, uint8_t cursor_end);

void disable_cursor();

uint16_t get_cursor();

void update_cursor();

/* vga */
void init_vga();

void vga_put_c(char c, uint8_t color);

void vga_put_s(const char* str, uint8_t color);

void vga_put_i(uint32_t i, uint8_t color);

#endif
