sum:
     mov rax,rdi 
      ret 0

say_hello:
      mov rax,1;;sys write
      mov rdi,1;;stdout file descriptor
      ;;lea rsi,[hello]
      mov rdx,6;;byte lenght
      syscall
      ret 0

;;linux function argument RDI, RSI, RDX, RCX
;;linux syscall sys_read = 0 sys_write = 1 sys_close = 3 sys_open = 2 sys_lseek = 8

;this need to be in rax before "syscall" asm
SYS_READ = 0
SYS_WRITE = 1
SYS_OPEN = 2
SYS_CLOSE = 3
SYS_LSEEK = 8
SYS_BRK = 12
SYS_IOCTL = 16
SYS_EXIT = 60

;end syscall


SEEK_SET = 0	;Seek from beginning of file
SEEK_CUR = 1	;Seek from current position
SEEK_END = 2	;Seek from end of file

EACCES = 13

O_RDONLY = 0000o

;Standard Linux file descriptors
STDIN = 0
STDOUT = 1
STDERR = 2

TCGETS = 0x5401
TCSETS = 0x5402

;rdi file descriptor
;rsi command IOCTL number
;rdx argument data structure
;out rax 0 success - negative error
ioctl:
      mov rax, SYS_IOCTL
      syscall
      ret


;rdi file descriptors
;rsi memory
;rdx bytes to read
read:
      mov rax,SYS_READ
      syscall
      ret

write:
      mov rax,SYS_WRITE
      syscall
      ret

;rdi = file path or file descriptor
;rsi = open mode
;out rax = file descriptor
open:
      mov rax,SYS_OPEN
      syscall
      ret

;rdi = bytes to allocate
;out eax = memory position allocate
brk:
      mov rax,SYS_BRK
      syscall
      ret

;rdi file descriptor to close
close:
      mov rax,SYS_CLOSE
      syscall
      ret

;rdi file descriptor
;rsi offset
;rdx seek option
;out eax position in bytes
lseek:
      mov rax,SYS_LSEEK
      syscall
      ret

;;end linux syscall

print:
      mov edi,STDOUT
      mov eax,SYS_WRITE
      syscall
      ret

sys_exit:
      mov rax, SYS_EXIT
      xor rdi,rdi
      syscall
      ret

