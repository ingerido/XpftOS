#
# Makefile for hal/x86
#

AS = i686-elf-as
LD = i686-elf-ld
CC = i686-elf-gcc

CFLAGS = -std=gnu99 -ffreestanding -I../../include

OBJS = vga.o mem.o e820.o

arch.o: $(OBJS)
	$(LD) -r -o arch.o $(OBJS)

vga.o:
	$(CC) $(CFLAGS) -c vga.c -o vga.o

mem.o:
	$(CC) $(CFLAGS) -c mem.c -o mem.o

e820.o:
	$(CC) $(CFLAGS) -c e820.c -o e820.o

clean:
	rm $(OBJS)
