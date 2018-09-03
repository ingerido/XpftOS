/*
 *	/include/arch/x86/e820.h
 * 
 *	Author: Yujie REN
 *	Date:	2017.8
 *
 *  BIOS INT 15h AX=0xe820 Read Physical Memory Map
 */

#ifndef _E820_H
#define _E820_H

#include <types.h>

// First, let's do some basic checks to make sure we are using our x86-elf cross-compiler correctly
#if defined(__linux__)
	#error "This code must be compiled with a cross-compiler"
#elif !defined(__i386__)
	#error "This code must be compiled with an x86-elf compiler"
#endif

#define E820MAP	0x2d0		/* our map */
#define E820MAX	128			/* number of entries in E820MAP */
#define E820NR	0x1e8		/* # entries in E820MAP */

#define E820_AVAL	1
#define E820_RESV	2
#define E820_ACPI	3
#define E820_NVS	4

typedef struct e820_entry {
	uint32_t addr_l;	/* start of memory segment (low 4 byte)*/
	uint32_t addr_h;	/* start of memory segment (high 4 byte)*/
	uint32_t size_l;	/* size of memory segment (low 4 byte)*/
	uint32_t size_h;	/* size of memory segment (high 4 byte)*/
	uint32_t type;		/* type of memory segment */
	uint32_t valid;		/* 1 for valid entry, 0 for invalid */
} e820_entry;

typedef struct e820_map {
	uint32_t nr_map;
	e820_entry map[E820MAX];
} e820_map;


#endif
