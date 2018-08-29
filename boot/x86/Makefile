#
# boot/x86 Makefile
#

AS = i686-elf-as
LD = i686-elf-ld
CC = i686-elf-gcc

all: Image

Image: boot.o setup.o entry.o ../../kernel/kernel.o
	$(LD) --oformat=binary --Ttext 0x0000 -o boot boot.o
	$(LD) --oformat=binary --Ttext 0x7e00 -o setup setup.o
	$(LD) --oformat=binary --Ttext 0x100000 --Tdata 0x101000 --Tbss 0x106000 -o kImage -nostdlib entry.o ../../kernel/kernel.o
	#$(LD) --oformat=binary -T arch/x86/linker.ld -o kernel/kImage -nostdlib arch/x86/entry.o kernel/kernel.o

	dd if=boot   of=xfptOS.img seek=0 bs=512 count=1
	dd if=setup  of=xfptOS.img seek=1 bs=512 count=1
	dd if=kImage of=xfptOS.img seek=2 bs=512 count=41

boot.o:
	$(AS) -o boot.o boot.s

setup.o:
	$(AS) -o setup.o setup.s

entry.o:
	$(AS) -o entry.o entry.s

clean:
	rm -rf *.o boot setup kImage xfptOS.img
