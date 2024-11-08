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
SYS_EXIT = 60
;end syscall



STDOUT = 1

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

;edi = bytes to allocate
;out eax = memory position allocated
brk:
      mov rax,SYS_BRK
      syscall
      ret

close:
      mov rax,SYS_CLOSE
      syscall
      ret

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

