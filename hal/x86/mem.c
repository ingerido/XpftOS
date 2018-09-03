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
#include <kernel/mm.h>
 
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
	int addr = 0, pt_addr = K_PGD + PAGE_SIZE_RG, mem_end = 896*1024*1024, tmp = 0;

	int *pg_dir = _k_pgd, *pg_table;

	/* Get Physical Memory Map */
	bios_mem_map();
	
	/* Fill Kernel Page Table for Directed Mapped Memory Area */
	while (addr < mem_end) {
		tmp = *(pg_dir + 0x300);
		if (!tmp) {
			tmp = pt_addr | 0x07;
			*(pg_dir + 0x300) = tmp;
		} else {
			vga_put_c('\n', 0x07);
			vga_put_i((uint32_t) pt_addr, 0x07);
			vga_put_c('\n', 0x07);
		}
		pt_addr += PAGE_SIZE_RG;
		//*pg_dir = tmp;
		pg_dir++;
		pg_table = (int *) (tmp & PAGE_MASK);
		for (tmp = 0; tmp < PTE_NR; tmp++, pg_table++) {
			if (addr < mem_end)
				*pg_table = addr | 0x07;
			else
				*pg_table = 0;
			addr += PAGE_SIZE_RG;
		}
	}
}

