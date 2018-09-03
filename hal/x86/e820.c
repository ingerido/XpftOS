/*
 *	hal/x86/e820.c
 * 
 *	Author: Yujie REN
 *	Date:	2017.8
 *
 *  BIOS e820 Memory Mapping
 */

#include <types.h>

#include <arch/x86/mem.h>
#include <arch/x86/vga.h>
#include <arch/x86/e820.h>
 
// First, let's do some basic checks to make sure we are using our x86-elf cross-compiler correctly
#if defined(__linux__)
	#error "This code must be compiled with a cross-compiler"
#elif !defined(__i386__)
	#error "This code must be compiled with an x86-elf compiler"
#endif

e820_entry* phy_mm_map = (e820_entry*)E820_MAP;

/* BIOS INT 15h AX=e820 Get Memory Map */
void bios_mem_map() {
	vga_put_s("e820: BIOS-Provided physical memory map:\n", 0x0e);
	e820_entry* entry = phy_mm_map;
	int cnt = 0;

	while (entry->valid) {
		vga_put_s("BIOS-e820: [mem ", 0x07);

		vga_put_s("0x", 0x07);
		vga_put_i(entry->addr_h, 0x07);
		vga_put_i(entry->addr_l, 0x07);
		vga_put_c('-', 0x07);
		vga_put_s("0x", 0x07);
		vga_put_i(entry->addr_h, 0x07);
		vga_put_i(entry->addr_l + entry->size_l - 1, 0x07);
		vga_put_s("] ", 0x07);
		switch(entry->type) {
			case E820_AVAL: {
				vga_put_s("usable", 0x07);
				break;
			}
			case E820_RESV: {
				vga_put_s("reserved", 0x07);
				break;				
			}
			case E820_ACPI: {
				vga_put_s("ACPI", 0x07);
				break;				
			}
			case E820_NVS: {
				vga_put_s("NVS", 0x07);
				break;				
			}
			default: {
				vga_put_s("unknown", 0x07);
				break;
			}
		}
		vga_put_c('\n', 0x07);

		_bios_mem_map.map[cnt++] = *entry;
		++entry;
	}
	_bios_mem_map.nr_map = cnt;
}
