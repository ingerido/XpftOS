/*
 *	/include/arch/x86/e820.h
 * 
 *	Author: Yujie REN
 *	Date:	2017.8
 *
 *  BIOS INT 15h AX=e820
 */
#ifndef _E820_H
#define _E820_H
 
// First, let's do some basic checks to make sure we are using our x86-elf cross-compiler correctly
#if defined(__linux__)
	#error "This code must be compiled with a cross-compiler"
#elif !defined(__i386__)
	#error "This code must be compiled with an x86-elf compiler"
#endif

void bios_mem();

#endif
