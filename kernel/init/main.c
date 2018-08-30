/*
 *	/kernel/init/main.c
 * 
 *	Author: Yujie REN
 *	Date:	2017.8
 *
 *  The init, OS entry is here
 */

#include <hal/console.h>
#include <hal/phy_mem.h>

/*
 *	Kernel entry main()
 */
void kernel_main() {
	console_init();
	console_write_string("Hello, World!\n", 0x07);
	console_write_string("Welcome to the kernel.\n", 0x07);

	get_phy_mem_map();

	// init_paging();

}
