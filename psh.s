
; r9	; 6th param
; r8	; 5th param
; r10	; 4th param
; rdx	; 3rd param
; rsi	; 2nd param
; rdi	; 1st param


format ELF64 executable 3

segment readable executable

entry $

	call fork
	cmp rax,0
	je child_process

parent_process:
	;wait for command
	jmp $

	call sys_exit

child_process:
	lea rdi,[ls_program]
	mov rsi,0
	mov rdx,0
	call execve
	call sys_exit

include "syscall.s"

segment readable writeable

buffer rb 50 ;50 characters
ls_program db '/bin/ls',0
