
; r9	; 6th param
; r8	; 5th param
; r10	; 4th param
; rdx	; 3rd param
; rsi	; 2nd param
; rdi	; 1st param


format ELF64 executable 3

segment readable executable

entry $
	
	mov eax,0xFFFFFFFF
	call print_decimal
	mov eax,0xFFFF
	call print_decimal
	mov eax,2060
	call print_decimal
	
	call sys_exit


;eax number
print_decimal:
	mov rcx,9;max digits count
	sub rsp,32;reserve stack with alignment
divide:
	xor edx,edx
	mov ebx,10
	div ebx
	add edx,'0'
	mov byte [rsp+16+rcx],dl
	dec rcx
	cmp eax,9
	jg divide
	add eax,'0'
	mov byte [rsp+16+rcx],al

	mov r15,0
mov_digits:
	mov byte al, [rsp+16+rcx]
	mov byte [rsp+r15],al
	inc r15
	inc rcx
	cmp rcx,10
	jl mov_digits

	mov byte [rsp+r15],0
	inc r15
	mov byte [rsp+r15],10
	inc r15
	mov byte [rsp+r15],10

	mov rdx,r15;size of buffer
	lea rsi,[rsp]
	call print
	add rsp,32
	ret

	


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

msg db '000000000',0xA
msg_size = $-msg
