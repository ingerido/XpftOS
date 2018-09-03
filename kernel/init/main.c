/*
 *	/kernel/init/main.c
 * 
 *	Author: Yujie REN
 *	Date:	2017.8
 *
 *  The init, OS entry is here
 */

#include <kernel/tty.h>
#include <kernel/mm.h>

/*
 *	Kernel entry main()
 */
void kernel_main() {
	tty_init();
	tty_put_s("Hello, World!\n", 0x07);
	tty_put_s("Welcome to the kernel.\n", 0x07);

	paging_init();

}
