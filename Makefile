#
# Makefile for XpftOS
#

TARGET = x86

all: Image

Image: kernel/kernel.o
	(cd boot/$(TARGET); make)

kernel/kernel.o: hal/$(TARGET)/arch.o
	(cd kernel; make)

#hal/hal.o: arch/$(TARGET)/arch.o
#	(cd hal; make $(TARGET))

hal/$(TARGET)/arch.o:
	(cd hal/$(TARGET); make)

clean:
	(cd hal/$(TARGET); make clean)
	(cd kernel; make clean)
	(cd boot/$(TARGET); make clean)

