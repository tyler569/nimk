
CC := x86_64-elf-gcc
CFLAGS := -I. -ffreestanding

NIMSRC := $(shell find . -name '*.nim')

.PHONY: all clean

all: nimos.iso

boot.o: boot.asm
	nasm -felf64 -o $@ $<

io.o: io.asm
	nasm -felf64 -o $@ $<

string.o: string.c string.h
	$(CC) $(CFLAGS) -o $@ -c $<

nimkernel: boot.o io.o string.o $(NIMSRC) main.nim.cfg
	nim --nimcache:nimcache c main.nim
	ld -g -nostdlib -o $@ nimcache/*.o boot.o io.o string.o -T link.ld

nimos.iso: nimkernel grub.cfg
	mkdir -p isodir/boot/grub
	cp grub.cfg isodir/boot/grub
	cp nimkernel isodir/boot/
	grub-mkrescue -o $@ isodir/
	rm -rf isodir

clean:
	rm -rf nimcache
	rm -f boot.o
	rm -f string.o
	rm -f nimkernel
	rm -f nimos.iso

