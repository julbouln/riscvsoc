CC=riscv64-unknown-elf-gcc
CFLAGS=-std=c99 -m32  -march=RV32I -Os
#CFLAGS=-std=c99 -m32  -march=RV32IM -O -DM_EXTENSION=1

hello:
	riscv64-unknown-elf-gcc $(CFLAGS) crt0.s -c
	riscv64-unknown-elf-gcc $(CFLAGS) riscvsoc.c -c
	riscv64-unknown-elf-gcc $(CFLAGS) hello.c -c
	riscv64-unknown-elf-ld -melf32lriscv -o hello crt0.o riscvsoc.o hello.o -Triscv.ld
	riscv64-unknown-elf-objdump -D -x -S hello > hello.dis
	riscv64-unknown-elf-objcopy -O ihex hello hello.hex
	srec_cat hello.hex -intel -byte-swap 4 -o out.hex -intel
	srec_cat hello.hex -intel --offset=-0x800000 -byte-swap 4  --fill 0x00 0x00 0x54 -o out.a.txt -vmem --line-length=16 --data-only
	cut -c 11-19 out.a.txt > out.txt
#	./hex2coe out.hex out.coe

clean:
	rm *.o
	rm hello
	rm *.hex
	rm *.dis
	rm *.txt