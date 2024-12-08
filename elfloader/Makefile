
all: loadelf hellofasm binaryc loadbin

loadelf: main.c
	gcc -g main.c -o loadelf

loadbin: loadbin.c
	cc loadbin.c -o loadbin

binaryc: binaryc.c
	cc -pedantic -Wall -Werror -Wextra -std=c89 -fno-stack-protector -c binaryc.c
	ld binaryc.o -T binary.ld -o binaryc


hellofasm: hellofasm.s my_binary.s
	fasm hellofasm.s hellofasm
	fasm my_binary.s my_binary
