all: bin_dir pcc pwin hex

hex:
	fasm hex.s ./bin/hex

bin_dir:
	mkdir -p ./bin

pwin: pwin.o
	gcc -no-pie -nostdlib -o ./bin/pwin -lX11

pwin.o: pwin.s
	fasm pwin.s pwin.o

pcc: pcc.o syscall.o
	ld /usr/lib/crt1.o -dynamic-linker /lib/ld-linux.so.2 syscall.o pcc.o -o ./bin/pcc -lc

pcc.o: pcc.c
	gcc -c pcc.c -o pcc.o

syscall.o: syscallc.s
	fasm syscallc.s syscall.o

clean:
	rm -f *.o pcc
	rm -f out.s

