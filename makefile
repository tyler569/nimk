
CC := x86_64-elf-gcc
CFLAGS := -I. -ffreestanding

NIMSRC := $(shell find . -name '*.nim')
CSRC := $(shell find . -name '*.c')
ASMSRC := $(shell find . -name '*.asm')
HEADERS := $(shell find . -name '*.h')

COBJ := $(patsubst %.c,%.o,$(CSRC))
ASMOBJ := $(patsubst %.asm,%.o,$(ASMSRC))

OBJECTS := $(COBJ) $(ASMOBJ)

.PHONY: all clean

all: nimos.iso

%.o: %.asm
	nasm -felf64 -o $@ $<

%.o: %.c
	$(CC) $(CFLAGS) -o $@ -c $<

nimkernel: boot.o isrs.o io.o string.o $(NIMSRC) main.nim.cfg
	nim --nimcache:nimcache c main.nim
	ld -g -nostdlib -o $@ nimcache/*.o *.o -T link.ld

nimos.iso: nimkernel grub.cfg
	mkdir -p isodir/boot/grub
	cp grub.cfg isodir/boot/grub
	cp nimkernel isodir/boot/
	grub-mkrescue -o $@ isodir/
	rm -rf isodir

clean:
	rm -rf nimcache
	rm -f *.o
	rm -f nimkernel
	rm -f nimos.iso

