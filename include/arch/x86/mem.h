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

// First, let's do some basic checks to make sure we are using our x86-elf cross-compiler correctly
#if defined(__linux__)
	#error "This code must be compiled with a cross-compiler"
#elif !defined(__i386__)
	#error "This code must be compiled with an x86-elf compiler"
#endif

/* Memory Location Define */
#define E820_MAP  0xc0009000
#define VGA_BUF   0xc00b8000
#define KERN_PGD  0xc0130000
#define STACK_TOP 0xc8000000


extern void bios_mem_map();

extern e820_map _bios_mem_map;

#endif
