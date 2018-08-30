#
# Makefile for the Kernel
#

AS = i686-elf-as
LD = i686-elf-ld
CC = i686-elf-gcc

CFLAGS = -std=gnu99 -ffreestanding -I../include

TARGET = x86

OBJS = ../hal/hal.o init/init.o

kernel.o: $(OBJS)
	$(LD) -r -o kernel.o $(OBJS)

init/init.o: 
	$(CC) $(CFLAGS) -c init/main.c -o init/init.o

clean:
	rm kernel.o $(OBJS)
