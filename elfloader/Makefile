
all: loadelf hellofasm

loadelf: main.c
	gcc -g main.c -o loadelf

hellofasm: hellofasm.s my_binary.s
	fasm hellofasm.s hellofasm
	fasm my_binary.s my_binary
