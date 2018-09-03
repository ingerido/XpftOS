#
# Makefile for hal
#

AS = i686-elf-as
LD = i686-elf-ld
CC = i686-elf-gcc

CFLAGS = -std=gnu99 -ffreestanding -I../include

TARGET = x86

OBJS = ./$(TARGET)/arch.o

hal.o: $(OBJS)
	$(LD) -r -o hal.o $(OBJS)

clean:
	rm $(OBJS)
