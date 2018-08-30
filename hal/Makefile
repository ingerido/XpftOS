#
# Makefile for hal
#

AS = i686-elf-as
LD = i686-elf-ld
CC = i686-elf-gcc

CFLAGS = -std=gnu99 -ffreestanding -I../include

TARGET = x86

OBJS = ./$(TARGET)/arch.o console.o phy_mem.o

hal.o: $(OBJS)
	$(LD) -r -o hal.o $(OBJS)

console.o:
	$(CC) $(CFLAGS) -c console.c -o console.o

phy_mem.o:
	$(CC) $(CFLAGS) -c phy_mem.c -o phy_mem.o

clean:
	rm $(OBJS)
