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
	$(LD) --oformat=binary --Ttext 0x100000 --Tdata 0x110000 --Tbss 0x120000 -o kImage -nostdlib entry.o ../../kernel/kernel.o
	#$(LD) --oformat=binary -T linker.ld -o kImage -nostdlib entry.o ../../kernel/kernel.o

	dd if=boot   of=xpftOS.img seek=0 bs=512 count=1
	dd if=setup  of=xpftOS.img seek=1 bs=512 count=1
	dd if=kImage of=xpftOS.img seek=2 bs=512 count=137

boot.o:
	$(AS) -o boot.o boot.s

setup.o:
	$(AS) -o setup.o setup.s

entry.o:
	$(AS) -o entry.o entry.s

clean:
	rm -rf *.o boot setup kImage xpftOS.img
