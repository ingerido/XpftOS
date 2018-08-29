/*
 *	/kernel/init/main.c
 * 
 *	Author: Yujie REN
 *	Date:	2017.8
 *
 *  The init, OS entry is here
 */

#include "arch/x86/tty.h"
#include "arch/x86/e820.h"

/*
 *	Kernel entry main()
 */
void kernel_main() {
	init_tty_io();
	tty_put_s("Hello, World!\n", 0x07);
	tty_put_s("Welcome to the kernel.\n", 0x07);

	show_mem();

	// init_paging();

}
