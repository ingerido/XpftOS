/*
 *	/include/arch/x86/e820.h
 * 
 *	Author: Yujie REN
 *	Date:	2017.8
 *
 *  TTY related
 */
#ifndef _E820_H
#define _E820_H

#include <stddef.h>
#include <stdint.h>
 
// First, let's do some basic checks to make sure we are using our x86-elf cross-compiler correctly
#if defined(__linux__)
	#error "This code must be compiled with a cross-compiler"
#elif !defined(__i386__)
	#error "This code must be compiled with an x86-elf compiler"
#endif

void bios_mem();

#endif
