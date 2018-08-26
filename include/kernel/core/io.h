/*
 *	/include/kernel/core/io.h
 * 
 *	Author: Yujie REN
 *	Date:	2017.8
 *
 *  I/O operation Wrapper
 */
#ifndef _IO_H
#define _IO_H


#define outb(port, value) \
__asm__ ("outb %%al,%%dx"::"a" (value),"d" (port))

/*static inline void outb(uint16_t value, uint16_t port)
{
	__asm__ ("outb %%al,%%dx"::"a" (value),"d" (port));
}*/


#define inb(port) ({ \
unsigned char _v; \
__asm__ volatile ("inb %%dx,%%al":"=a" (_v):"d" (port)); \
_v; \
})

/*static inline uint8_t intb(uint16_t port)
{
	uint8_t ret;
	__asm__ __volatile__ ("inb %%dx,%%al":"=a" (ret):"d" (port));
	return ret;
}*/


#endif
