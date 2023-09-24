
objs/kernel.o : kernel.c
	gcc -c kernel.c -o objs/kernel.o -m32 --freestanding 

bins/boot.bin : boot.asm
	nasm boot.asm -o bins/boot.bin

objs/loader.o : loader.asm
	nasm loader.asm -f elf32 -o objs/loader.o

bins/kernel.elf : objs/kernel.o objs/loader.o
	ld -m elf_i386 -Ttext 0x7e00 -Tbss 0x7e00 -Tdata 0x7e00 objs/kernel.o objs/loader.o -o bins/kernel.elf
bins/kernel.bin : bins/kernel.elf
	objcopy -O binary bins/kernel.elf bins/kernel.bin

OS.bin : bins/kernel.bin bins/boot.bin
	cat bins/boot.bin bins/kernel.bin > OS.bin

run : OS.bin
	qemu-system-x86_64 OS.bin

