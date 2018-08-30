/*
 *	hal/phy_mem.c
 * 
 *	Author: Yujie REN
 *	Date:	2017.8
 *
 *  Get physical memory map
 */


#include <arch/x86/tty.h>

void get_phy_mem_map() {
	bios_mem();
}
