/*
 *	hal/x86/mem.c
 * 
 *	Author: Yujie REN
 *	Date:	2017.8
 *
 *  BIOS e820 Memory Mapping
 */

#include <types.h>

#include <arch/x86/mem.h>
#include <arch/x86/vga.h>
 
// First, let's do some basic checks to make sure we are using our x86-elf cross-compiler correctly
#if defined(__linux__)
	#error "This code must be compiled with a cross-compiler"
#elif !defined(__i386__)
	#error "This code must be compiled with an x86-elf compiler"
#endif

int* _k_pgd = (int*)K_PGD;

uint32_t _k_stack_top = STACK_TOP;

/* 
 * init paging
 * fill kernel page tables
 * flush TLB
 */
void paging_init() {
	bios_mem_map();

	while (address < end_mem) {
		tmp = *(pg_dir + 768);		/* at virtual addr 0xC0000000 */
		if (!tmp) {
			tmp = start_mem | PAGE_TABLE;
			*(pg_dir + 768) = tmp;
			start_mem += PAGE_SIZE;
		}
		*pg_dir = tmp;			/* also map it in at 0x0000000 for init */
		pg_dir++;
		pg_table = (unsigned long *) (tmp & PAGE_MASK);
		for (tmp = 0 ; tmp < PTRS_PER_PAGE ; tmp++,pg_table++) {
			if (address < end_mem)
				*pg_table = address | PAGE_SHARED;
			else
				*pg_table = 0;
			address += PAGE_SIZE;
		}
	}
}

