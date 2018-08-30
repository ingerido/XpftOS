/*
 *	/include/hal/phy_mem.h
 * 
 *	Author: Yujie REN
 *	Date:	2017.8
 *
 *  Physical Memory Info
 */

#ifndef _PHY_MEM_H
#define _PHY_MEM_H

/* arch specific function */
extern void bios_mem();

/* hal unified function */
void get_phy_mem_map();


#endif
