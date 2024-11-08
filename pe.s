
; r9	; 6th param
; r8	; 5th param
; r10	; 4th param
; rdx	; 3rd param
; rsi	; 2nd param
; rdi	; 1st param


format ELF64 executable 3

segment readable executable

entry $

	lea rdi,[file_to_open]
	mov rsi, O_RDONLY
	call open
	;cmp rax, EACCES
	;je erro_open

	mov r10,rax;save file descriptor


	mov rdi,r10
	mov rsi,0
	mov rdx,SEEK_END
	call lseek

	mov r11,rax ;save file size	

	mov rdi,r11
	call brk
	mov [allocated_memory],rax

	
	mov rdi, r10
	call close
	
	mov rdi,r10
	mov rsi,0
	mov rdx,SEEK_SET
	;call lseek

	lea rdi,[file_to_open]
	mov rsi, O_RDONLY
	call open
	;cmp rax, EACCES
	;je erro_open

	mov r10,rax;save file descriptor

	mov rax,'a'
	mov rbx,'c'
	mov [allocated_memory],rax
	mov [allocated_memory+1],rbx

	mov rdi,r10
	lea rsi,[allocated_memory]
	mov rdx,r11
	call read

	
	
	mov rdi, r10
	call close

	mov rdx,r11
	lea rsi,[allocated_memory]
	call print

	
	mov rdx,error_open_file_msg_size
	lea rsi,[error_open_file_msg]
	call print


	


	call print_msg

	call sys_exit
	

erro_open:
	mov edx,error_open_file_msg_size
	lea rsi,[error_open_file_msg]
	call print
	call sys_exit


print_msg:
	mov edx,msg_size
	lea rsi,[msg]
	call print
	ret
	
	

include "syscall.s"

segment readable writeable

msg db 'Message',0xA
msg_size = $-msg

error_open_file_msg db 'Cant open file',0xA
error_open_file_msg_size = $-error_open_file_msg

file_to_open db 'test.txt',0

allocated_memory dq ?

