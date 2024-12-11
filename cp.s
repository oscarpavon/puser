;abi = rdi , rsi , rdx, r10, r8, r9
format ELF64 executable 3

segment readable executable

entry $

	lea rdi,[file_from]
	mov rsi,O_RDONLY
	call open

	mov rdi,rax;file descriptor file_from
	lea rsi,[stat]
	call fstat

	mov [file_descriptor_in_file],eax;save file descriptor file_from

	lea rdi,[file_out]
	mov rsi,O_WRONLY
	or rsi,O_CREAT
	call open

	mov [file_descriptor_out_file],eax

retry:

	mov dword edi,[file_descriptor_out_file]
	mov dword esi,[file_descriptor_in_file]
	mov rdx,0 ;offset 0
	;lea r10,[stat_struct+STAT_SIZE]
	mov r10,10
	call sendfile
	cmp rax,10
	jl not_copy_all
	

	mov rdi,rax;close out_file
	call close

	mov rdi,r15;close in_file
	call close


	call sys_exit


not_copy_all:
	mov [copy_count],eax
	lea rsi,[error_msg]
	mov rdx,msg_size
	call print

	call sys_exit

include "syscall.s"

segment readable writeable
file_from db 'test.txt',0
file_out db 'copied.txt',0
stat_struct rb STAT_STRUCT_SIZE
error_msg db 'not copy all',10,0
msg_size = $ - error_msg
file_descriptor_in_file rd 1
file_descriptor_out_file rd 1
copy_count dd 0

