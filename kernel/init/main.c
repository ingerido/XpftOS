/*
 *	/kernel/init/main.c
 * 
 *	Author: Yujie REN
 *	Date:	2017.8
 *
 *  The init, OS entry is here
 */

#include "kernel/core/tty.h"

/*
 *	Kernel entry main()
 */
void kernel_main() {
	init_tty_io();
	tty_put_s("Hello, World!\n");
	tty_put_s("Welcome to the kernel.\n");
}
