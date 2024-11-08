
; r9	; 6th param
; r8	; 5th param
; r10	; 4th param
; rdx	; 3rd param
; rsi	; 2nd param
; rdi	; 1st param


format ELF64 executable 3

segment readable executable

entry $
	

	mov ax,0xef
	mov bl,16
	div bl
	mov dh,ah
	mov cx,2
	cmp ah,10
	jl decimal
	jge hex
	back:
	cmp cx,0
	jz result
	mov [msg+1],dh
	mov dh,al
	cmp al,10
	jl decimal
	jge hex

decimal:
	add dh,'0'
	dec cx
	jmp back

hex:
	sub dh,10
	add dh,'a'
	dec cx
	jmp back

result:
	mov [msg],dh
	call print_msg	

	call sys_exit
	


print_msg:
	mov edx,msg_size
	lea rsi,[msg]
	call print
	ret
	
	
	mov cx,0
	myloop:
		mov al,cl
		add al,'0'
		mov [msg],al
		push cx
		call print_msg
		pop cx
		inc cx
		cmp cx,10
		jne myloop

include "syscall.s"

segment readable writeable

msg db '00',0xA
msg_size = $-msg
