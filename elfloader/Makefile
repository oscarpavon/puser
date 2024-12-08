
all: loadelf hellofasm binaryc loadbin mixcfasm

loadelf: loadelf.c
	gcc -g loadelf.c -o loadelf

loadbin: loadbin.c
	cc loadbin.c -o loadbin

libc.o: libc.s
	fasm libc.s libc.o


BIN_CC_FLAGS := -fno-stack-protector

mixcfasm: libc.o mixcfasm.c
	cc $(BIN_CC_FLAGS) -c mixcfasm.c
	ld mixcfasm.o libc.o -T binary.ld -o mixcfasm


binaryc: binaryc.c
	cc -pedantic -Wall -Werror -Wextra -std=c89 -fno-stack-protector -c binaryc.c
	ld binaryc.o -T binary.ld -o binaryc


hellofasm: hellofasm.s my_binary.s
	fasm hellofasm.s hellofasm
	fasm my_binary.s my_binary
