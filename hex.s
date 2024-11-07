
; r9	; 6th param
; r8	; 5th param
; r10	; 4th param
; rdx	; 3rd param
; rsi	; 2nd param
; rdi	; 1st param


format ELF64 executable 3

segment readable executable

entry $
	
	mov edx,msg_size
	lea rsi,[msg]
	call print
	
	call sys_exit
	ret

include "syscall.s"

segment readable writeable

msg db 'Hello from fasm elf',0xA
msg_size = $-msg
