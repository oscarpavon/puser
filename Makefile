pcc: pcc.o syscall.o
	ld /usr/lib/crt1.o -dynamic-linker /lib/ld-linux.so.2 syscall.o pcc.o -o pcc -lc

pcc.o: pcc.c
	gcc -c pcc.c -o pcc.o

syscall.o: syscall.s
	fasm syscall.s syscall.o

clean:
	rm -f *.o pcc
	rm -f out.s

