
; r9	; 6th param
; r8	; 5th param
; r10	; 4th param
; rdx	; 3rd param
; rsi	; 2nd param
; rdi	; 1st param


format ELF64 executable 3

segment readable executable

entry $


parent_process:
	
	lea rsi, [shell]
	mov rdx, shell_size
	call print
		
	
	;wait for command
	mov rdi,STDIN
	lea rsi,[buffer]
	mov rdx,40
	call read
	
	call fork
	cmp rax,0
	je child_process

	mov rdi,rax;child pid
	mov rsi, 0
	mov rdx, 0
	mov r10, 0
	call wait4;stop until child finish


	jmp parent_process

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
shell db '$'
shell_size = $ - shell
