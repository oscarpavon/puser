
; r9	; 6th param
; r8	; 5th param
; r10	; 4th param
; rdx	; 3rd param
; rsi	; 2nd param
; rdi	; 1st param

ESC = 0x1b
local_mode_offset = 12

FILE_SIZE = 2200

format ELF64 executable 3

segment readable executable

entry $

	;mov rdx,clear_screen_size
	;lea rsi,[clear_screen]
	;call print

	call open_file_and_print

	jmp $
	
	;get terminal size
	mov rdi, STDOUT
	mov rsi, TIOCGWINSZ
	lea rdx, [winsize];row [winsize] col [winsize+2]
	call ioctl


	mov rdi, STDIN
	mov rsi, TCGETS
	lea rdx, [termios]
	call ioctl
	cmp rax, 0
	jne ioctl_error


	mov eax, [termios+local_mode_offset]
	mov edx, ICANON
	not edx
	and eax,edx
	mov [termios+local_mode_offset], eax

	mov rdi, STDIN
	mov rsi, TCSETS
	lea rdx, [termios]
	call ioctl
	cmp rax, 0
	jne ioctl_error


	mov rdx, msg_size
	lea rsi, [msg]
	call print

main_loop:

	mov rdi, STDIN
	lea rsi,[r10]
	mov rdx,1
	call read

	jmp main_loop

	call sys_exit

ioctl_error:
	lea rsi, [error_ioctl]	
	mov rdx, error_ioctl_size
	jmp main_loop

open_file_and_print:
	lea rdi,[file_to_open]
	mov rsi, O_RDONLY
	call open
	;cmp rax, EACCES
	;je erro_open

	mov r10,rax;save file descriptor


	mov rdi,r10
	mov rsi,0
	mov rdx,SEEK_END
	;call lseek

	;mov r11,rax ;save file size	
	mov r11,FILE_SIZE ;save file size	

	mov rdi,0
	call brk
	mov [allocated_memory],rax
	mov rdi,r11
	add rdi,rax
	call brk

	
	;mov rdi, r10
	;call close
	
	mov rdi,r10
	mov rsi,0
	mov rdx,SEEK_SET
	;call lseek

	;lea rdi,[file_to_open]
	;mov rsi, O_RDONLY
	;call open
	;cmp rax, EACCES
	;je erro_open

	;mov r10,rax;save file descriptor

	;mov rax,'a'
	;mov rbx,'c'
	;mov [allocated_memory],rax
	;mov [allocated_memory+1],rbx

	mov rdi,r10
	lea rsi,[allocated_memory]
	mov rdx,FILE_SIZE
	call read

	
	mov rdi, r10
	call close

	mov rdx,FILE_SIZE
	lea rsi,[allocated_memory]
	call print


	mov rdi,0
	call brk
	mov rdi,r11
	sub rdi,rax
	call brk
	
	;mov rdx,error_open_file_msg_size
	;lea rsi,[error_open_file_msg]
	;call print

	;call print_msg

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

error_ioctl db 'ioctl error', 0xA
error_ioctl_size = $-error_ioctl

error_open_file_msg db 'Cant open file',0xA
error_open_file_msg_size = $-error_open_file_msg

file_to_open db 'syscall.s',0

allocated_memory dq ?

clear_screen: db ESC, "[2J"
clear_screen_size = $ - clear_screen

termios rd 4;c_iflag input mode flags 4 bytes each
						;c_oflag output mode flags
						;c_cflag control mode flags
						;c_lflag local mode flags
				rb 1;c_line line discipline
				rb 19	; c_cc control characters 19 bytes

winsize rw 4;store terminal size
