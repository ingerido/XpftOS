#
# Makefile for LegOS
#

AS = i686-elf-as
LD = i686-elf-ld
CC = i686-elf-gcc

all: Image

Image:
	$(AS) -o arch/i386/boot.o arch/i386/boot.s
	$(AS) -o arch/i386/setup.o arch/i386/setup.s
	$(AS) -o arch/i386/entry.o arch/i386/entry.s
	#$(AS) -o arch/i386/test.o arch/i386/test.s
	$(LD) --oformat=binary --Ttext 0x0000   -o arch/i386/boot  arch/i386/boot.o
	$(LD) --oformat=binary --Ttext 0x7e00   -o arch/i386/setup arch/i386/setup.o
	#$(LD) --oformat=binary --Ttext 0x100000 -o arch/i386/entry arch/i386/entry.o
	#$(LD) --oformat=binary --Ttext 0x0010 -o arch/i386/test arch/i386/test.o
	dd if=arch/i386/boot  of=arch/i386/boot.img seek=0 bs=512 count=1
	dd if=arch/i386/setup of=arch/i386/boot.img seek=1 bs=512 count=1
	#dd if=arch/i386/entry of=arch/i386/boot.img seek=2 bs=512 count=1
	#dd if=arch/i386/test of=arch/i386/boot.img seek=3 bs=512 count=1

	$(CC) -std=gnu99 -ffreestanding -g -c kernel/kernel.c -o kernel/kernel.o
	
	$(LD) --oformat=binary --Ttext 0x100000 --Tbss 0x101000 -o kernel/kImage arch/i386/entry.o kernel/kernel.o
	dd if=kernel/kImage of=arch/i386/boot.img seek=2 bs=512 count=9

clean:
	rm arch/i386/*.o arch/i386/*.img arch/i386/boot arch/i386/setup arch/i386/entry kernel/kernel.o kernel/kImage
