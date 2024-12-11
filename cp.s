;abi = rdi , rsi , rdx, r10, r8, r9
format ELF64 executable 3

segment readable executable

entry $

	lea rdi,[file_from]
	mov rsi,O_RDONLY
	call open
	push rax

	lea rdi,[file_out]
	mov rsi,O_WRONLY
	or rsi,O_CREAT
	call open

	mov rdi,rax
	call close

	pop rax
	mov rdi,rax
	call close


	call sys_exit

include "syscall.s"

segment readable
file_from db 'test.txt',0
file_out db 'copied.txt',0
