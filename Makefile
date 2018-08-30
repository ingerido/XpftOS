#
# Makefile for XpftOS
#

TARGET = x86

all: Image

Image: kernel/kernel.o
	(cd boot/$(TARGET); make)

kernel/kernel.o: hal/hal.o
	(cd kernel; make)

hal/hal.o: hal/$(TARGET)/arch.o
	(cd hal; make)

hal/$(TARGET)/arch.o:
	(cd hal/$(TARGET); make)

clean:
	(cd hal/$(TARGET); make clean)
	(cd hal; make clean)
	(cd kernel; make clean)
	(cd boot/$(TARGET); make clean)

