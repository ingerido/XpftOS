/*
 *	/kernel/init/main.c
 * 
 *	Author: Yujie REN
 *	Date:	2017.8
 *
 *  The init, OS entry is here
 */

#include <hal/tty.h>
#include <hal/phy_mem.h>

uint32_t _k_stack_top = 0xc8000000;

/*
 *	Kernel entry main()
 */
void kernel_main() {
	tty_init();
	tty_put_s("Hello, World!\n", 0x07);
	tty_put_s("Welcome to the kernel.\n", 0x07);

	get_phy_mem_map();

	// init_paging();

}
