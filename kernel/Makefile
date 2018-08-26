#
# Makefile for the Kernel
#

AS = i686-elf-as
LD = i686-elf-ld
CC = i686-elf-gcc
CFLAGS = -std=gnu99 -ffreestanding -I../include

OBJS = init/init.o core/tty.o

kernel.o: $(OBJS)
	$(LD) -r -o kernel.o $(OBJS)

init/init.o: core/tty.o
	$(CC) $(CFLAGS) -c init/main.c -o init/init.o

core/tty.o: core/tty.c ../include/kernel/core/tty.h
	$(CC) $(CFLAGS) -c core/tty.c -o core/tty.o

clean:
	rm kernel.o kImage init/init.o core/tty.o
