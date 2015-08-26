CC=riscv64-unknown-elf-gcc
CFLAGS=-MD -std=c99 -m32  -march=RV32I -O3 -nostdlib -ffreestanding -DTIME -DRISCV
#CFLAGS=-std=c99 -m32  -march=RV32IM -O -DM_EXTENSION=1

hello:
	riscv64-unknown-elf-gcc $(CFLAGS) crt0.s -c
	riscv64-unknown-elf-gcc $(CFLAGS) riscvsoc.c -c
	riscv64-unknown-elf-gcc $(CFLAGS) hello.c -c
#	riscv64-unknown-elf-ld -melf32lriscv -o hello crt0.o riscvsoc.o hello.o -Triscv.ld
	riscv64-unknown-elf-gcc $(CFLAGS) -Wl,-Bstatic,-Triscv.ld,-Map,hello.map,--strip-debug -o hello crt0.o riscvsoc.o hello.o -lgcc 
	riscv64-unknown-elf-size hello	
	riscv64-unknown-elf-objdump -D -x -S hello > hello.dis
	riscv64-unknown-elf-objcopy -O ihex hello hello.hex
#	srec_cat hello.hex -intel -byte-swap 4 -o out.hex -intel
	srec_cat hello.hex -intel -byte-swap 4 --fill 0x00 0x00 0x54 -o out.a.txt -vmem --line-length=16 --data-only
	cut -c 11-19 out.a.txt > out.txt
#	./hex2coe out.hex out.coe

dhry:
	riscv64-unknown-elf-gcc $(CFLAGS) crt0.s -c
	riscv64-unknown-elf-gcc $(CFLAGS) riscvsoc.c -c
	riscv64-unknown-elf-gcc $(CFLAGS) dhry_1.c -c
	riscv64-unknown-elf-gcc $(CFLAGS) dhry_2.c -c

	riscv64-unknown-elf-gcc $(CFLAGS) -Wl,-Bstatic,-Triscv.ld,-Map,dhry.map,--strip-debug -o dhry crt0.o riscvsoc.o dhry_1.o dhry_2.o -lgcc 
	riscv64-unknown-elf-size dhry
	riscv64-unknown-elf-objdump -D -x -S dhry > dhry.dis
	riscv64-unknown-elf-objcopy -O ihex dhry dhry.hex
#	srec_cat dhry.hex -intel -byte-swap 4 -o dhry.hex -intel
	srec_cat dhry.hex -intel -byte-swap 4 --fill 0x00 0x00 0x54 -o dhry.a.txt -vmem --line-length=16 --data-only
	cut -c 11-19 dhry.a.txt > dhry.txt

clean:
	rm -f *.o
	rm -f hello
	rm -f dhry
	rm -f *.hex
	rm -f *.dis
	rm -f *.txt