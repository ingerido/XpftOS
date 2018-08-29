/*
 *	/kernel/init/main.c
 * 
 *	Author: Yujie REN
 *	Date:	2017.8
 *
 *  The init, OS entry is here
 */

#include "kernel/core/tty.h"

const size_t e820_size = 24;
int* phy_mm_map = (int*)0xc0009000;

void show_mem() {
	tty_put_s("e820: BIOS-Provided physical memory map:\n", 0x0e);

	int* phy_mm_st = phy_mm_map;
	uint32_t base_addr_low, base_addr_high, length_low, length_high, type;

	while (*(phy_mm_st + 5)) {
		base_addr_low  = *phy_mm_st;
		base_addr_high = *(phy_mm_st + 1);
		length_low  = *(phy_mm_st + 2);
		length_high = *(phy_mm_st + 3);
		type = *(phy_mm_st + 4);

		tty_put_s("BIOS-e820: [mem ", 0x07);

		tty_put_s("0x", 0x07);
		tty_put_i(base_addr_high, 0x07);
		tty_put_i(base_addr_low, 0x07);
		tty_put_c('-', 0x07);
		tty_put_s("0x", 0x07);
		tty_put_i(base_addr_high, 0x07);
		tty_put_i(base_addr_low + length_low - 1, 0x07);
		tty_put_s("] ", 0x07);
		switch(type) {
			case 1: {
				tty_put_s("usable", 0x07);
				break;
			}
			case 2: {
				tty_put_s("reserved", 0x07);
				break;				
			}
			default: {
				tty_put_s("unknown", 0x07);
				break;
			}
		}
		tty_put_c('\n', 0x07);

		phy_mm_st += 6;
	}

}

/*
 *	Kernel entry main()
 */
void kernel_main() {
	init_tty_io();
	tty_put_s("Hello, World!\n", 0x07);
	tty_put_s("Welcome to the kernel.\n", 0x07);

	show_mem();
	//tty_put_i(0xffffffff, 0x07);

	// init_paging();

}
