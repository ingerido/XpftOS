/*
 *	/include/arch/x86/mem.h
 * 
 *	Author: Yujie REN
 *	Date:	2017.8
 *
 *  Some Memory Locations
 */

#ifndef _MEM_H
#define _MEM_H

#include <types.h>
#include <arch/x86/e820.h>

// First, let's do some basic checks to make sure we are using our x86-elf cross-compiler correctly
#if defined(__linux__)
	#error "This code must be compiled with a cross-compiler"
#elif !defined(__i386__)
	#error "This code must be compiled with an x86-elf compiler"
#endif

/* Memory Location Define */
#define E820_MAP  0xc0009000
#define VGA_BUF   0xc00b8000
#define K_PGD	  0xc0130000
#define STACK_TOP 0xf8000000

#define PAGE_SIZE_RG 4096
#define PAGE_SIZE_EX 4194304
#define PTE_NR 1024

#define PAGE_MASK 0xfffff000

extern void bios_mem_map();

extern e820_map _bios_mem_map;

#endif
