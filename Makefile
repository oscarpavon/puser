all: bin_dir pcc pwin hex pe

hex:
	fasm hex.s ./bin/hex

bin_dir:
	mkdir -p ./bin

pe: pe.s
	fasm pe.s ./bin/pe

pwin: pwin.o
	ld -znoexecstack -znocombreloc -dynamic-linker /lib/ld-linux-x86-64.so.2 pwin.o -o ./bin/pwin -lX11

pwin.o: pwin.s
	fasm pwin.s pwin.o

pcc: pcc.o syscall.o
	ld -z noexecstack /usr/lib/crt1.o -dynamic-linker /lib/ld-linux.so.2 syscall.o pcc.o -o ./bin/pcc -lc

pcc.o: pcc.c
	gcc -c pcc.c -o pcc.o

syscall.o: syscallc.s
	fasm syscallc.s syscall.o

clean:
	rm -f *.o pcc
	rm -f out.s

