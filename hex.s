
; r9	; 6th param
; r8	; 5th param
; r10	; 4th param
; rdx	; 3rd param
; rsi	; 2nd param
; rdi	; 1st param


format ELF64 executable 3

segment readable executable

entry $


	mov rdi,0xFFFF
	call print_hex
	mov rdi,0xCCDD
	call print_hex

	call sys_exit

;rdi value
;rsi amount of bits 
;rdx destination buffer
;rax amount of bytes written to output buffer
print_hex:
	mov rsi,64
	lea rdx,[buffer]
	xor rax,rax
	shr rsi,2 ;divide by 4
	add rdx,rsi
	nibble:
		lea r9,[hex_table]
		mov bl,dil
		and bl,0x0f
		add r9b,bl
		mov bl,[r9]
		sub rdx,1
		mov byte [rdx],bl
		shr rdi,4
		add rax,1
		cmp rax,rsi
		jl nibble

	mov rdx,17
	lea rsi,[buffer]
	call print

	ret

include "syscall.s"

segment readable writeable

hex_table db '0123456789abcdef'
buffer db '                ',10
