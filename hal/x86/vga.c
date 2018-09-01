/*
 *	hal/x86/vga.c
 * 
 *	Author: Yujie REN
 *	Date:	2017.8
 *
 *  VGA related
 */

#include <stddef.h>
#include <stdint.h>

#include <arch/x86/io.h>
#include <arch/x86/mem.h>
#include <arch/x86/vga.h>

// First, let's do some basic checks to make sure we are using our x86-elf cross-compiler correctly
#if defined(__linux__)
	#error "This code must be compiled with a cross-compiler"
#elif !defined(__i386__)
	#error "This code must be compiled with an x86-elf compiler"
#endif

volatile uint16_t* vga_buffer = (uint16_t*)VGA_BUF;

// We start displaying text in the top-left of the screen (column = 0, row = 0)
uint8_t term_col = 0;
uint8_t term_row = 0;
uint8_t term_color = 0x0F; // Black background, White foreground


/* cursor related */
void enable_cursor(uint8_t cursor_start, uint8_t cursor_end) {
	outb(0x3D4, 0x0A);
	outb(0x3D5, (inb(0x3D5) & 0xC0) | cursor_start);
 
	outb(0x3D4, 0x0B);
	outb(0x3D5, (inb(0x3E0) & 0xE0) | cursor_end);
}

void disable_cursor() {
	outb(0x3D4, 0x0A);
	outb(0x3D5, 0x20);
}

uint16_t get_cursor() {
	uint16_t pos = 0;

	outb(0x3D4, 0x0E);
	pos = inb(0x3D5) << 8;
	outb(0x3D4, 0x0F);
	pos = pos | inb(0x3D5);
	return pos;
}

void update_cursor() {
	uint16_t pos = term_row * VGA_COLS + term_col;
 
	outb(0x3D4, 0x0F);
	outb(0x3D5, (uint8_t) (pos & 0xFF));
	outb(0x3D4, 0x0E);
	outb(0x3D5, (uint8_t) ((pos >> 8) & 0xFF));
}

/* vga io */
void init_vga() {
	uint16_t pos = get_cursor();
	term_col = pos % VGA_COLS;
	term_row = pos / VGA_COLS + 1;
}	

void vga_put_c(char c, uint8_t color) {
	// Remember - we don't want to display ALL characters!
	switch (c) {
		case '\n': // Newline characters should return the column to 0, and increment the row
		{
			term_col = 0;
			term_row ++;
			break;
		}
		default: // Normal characters just get displayed and then increment the column
		{
			const size_t index = (VGA_COLS * term_row) + term_col; // Like before, calculate the buffer index
			vga_buffer[index] = ((uint16_t)color << 8) | c;
			term_col ++;
			break;
		}
	}
 
	// What happens if we get past the last column? We need to reset the column to 0, and increment the row to get to a new line
	if (term_col >= VGA_COLS) {
		term_col = 0;
		term_row ++;
	}
 
	// What happens if we get past the last row? We need to reset both column and row to 0 in order to loop back to the top of the screen
	if (term_row >= VGA_ROWS) {
		term_col = 0;
		term_row = 0;
	}

	update_cursor();
}

void vga_put_s(const char* str, uint8_t color) {
	for (size_t i = 0; str[i] != '\0'; i ++) // Keep placing characters until we hit the null-terminating character ('\0')
		vga_put_c(str[i], color);
}

void vga_put_i(uint32_t i, uint8_t color) {
	char c[8] = {0};
	int8_t cnt = -1;
	size_t index = 0;
	while (i) {
		uint8_t tmp = i % 0x10;

		cnt ++;

		if (tmp <= 9) {
			c[cnt] = tmp + 0x30;
		} else {
			c[cnt] = tmp % 0x0a + 0x61;
		}
		i /= 0x10;
	}

	for (int j = 7; j > cnt; --j) {
		index = (VGA_COLS * term_row) + term_col;
		vga_buffer[index] = ((uint16_t)color << 8) | 0x30;
		term_col ++;
		update_cursor();
	}

	while (cnt >= 0) {
		index = (VGA_COLS * term_row) + term_col;
		vga_buffer[index] = ((uint16_t)color << 8) | c[cnt];
		term_col ++;
		cnt --;
		update_cursor();
	}
}

