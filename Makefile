#
# Makefile for XpftOS
#

AS = i686-elf-as
LD = i686-elf-ld
CC = i686-elf-gcc

all: Image

Image: arch/i386/boot.o arch/i386/setup.o arch/i386/entry.o kernel/kernel.o
	$(LD) --oformat=binary --Ttext 0x0000 -o arch/i386/boot  arch/i386/boot.o
	$(LD) --oformat=binary --Ttext 0x7e00 -o arch/i386/setup arch/i386/setup.o
	$(LD) --oformat=binary --Ttext 0x100000 --Tdata 0x101000 --Tbss 0x106000 -o kernel/kImage -nostdlib arch/i386/entry.o kernel/kernel.o
	#$(LD) --oformat=binary -T arch/i386/linker.ld -o kernel/kImage -nostdlib arch/i386/entry.o kernel/kernel.o

	dd if=arch/i386/boot  of=arch/i386/boot.img seek=0 bs=512 count=1
	dd if=arch/i386/setup of=arch/i386/boot.img seek=1 bs=512 count=1
	dd if=kernel/kImage of=arch/i386/boot.img seek=2 bs=512 count=41

arch/i386/boot.o:
	$(AS) -o arch/i386/boot.o arch/i386/boot.s

arch/i386/setup.o:
	$(AS) -o arch/i386/setup.o arch/i386/setup.s

arch/i386/entry.o:
	$(AS) -o arch/i386/entry.o arch/i386/entry.s

kernel/kernel.o:
	#$(CC) -std=gnu99 -ffreestanding -c kernel/kernel.c -o kernel/kernel.o
	(cd kernel; make)

clean:
	rm arch/i386/*.o arch/i386/*.img arch/i386/boot arch/i386/setup
	(cd kernel;make clean)
