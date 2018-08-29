#
# Makefile for hal/x86
#

AS = i686-elf-as
LD = i686-elf-ld
CC = i686-elf-gcc

CFLAGS = -std=gnu99 -ffreestanding -I../../include

OBJS = tty.o e820.o

arch.o: $(OBJS)
	$(LD) -r -o arch.o $(OBJS)

tty.o:
	$(CC) $(CFLAGS) -c tty.c -o tty.o

e820.o:
	$(CC) $(CFLAGS) -c e820.c -o e820.o

clean:
	rm $(OBJS)
