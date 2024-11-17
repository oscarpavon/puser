
; r9	; 6th param
; r8	; 5th param
; r10	; 4th param
; rdx	; 3rd param
; rsi	; 2nd param
; rdi	; 1st param


format ELF64 executable 3

segment readable executable

entry $
	mov rcx,16	;max 64bit hex number digits
	mov rax,0xFFFFFFFFFFFFFFF; max number - FF
divide:
	xor rdx,rdx
	cmp rax,16
	jl back
	mov rbx,16
	div rbx
	mov r15b,dl
	cmp rdx,10
	jl decimal
	jge hex
	back:
	cmp rax, 15
	jg divide
	cmp rax,10
	mov r14,1;last number
	mov r15b,al
	jl decimal
	jge hex
	finish:
	cmp rcx,0
	je not_fill
	fill_zero:
		mov al,'0'
		mov byte [msg+rcx],al
		dec rcx
		cmp rcx,0
		jne fill_zero
		mov al,'0'
		mov byte [msg+rcx],al
	
	not_fill:

	mov rdx,17
	lea rsi,[msg]
	call print

	call sys_exit
	

decimal:
	add r15b,'0'
	jmp put_char

hex:
	sub r15b,10
	add r15b,'a'
	jmp put_char

put_char:
	mov byte [msg+rcx],r15b
	dec rcx
	cmp r14,1
	je finish
	jne back

include "syscall.s"

segment readable writeable

msg db 'FFFFFFFFFFFFFFFF',0xA
msg_size = $-msg
