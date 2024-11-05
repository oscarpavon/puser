format ELF64
section '.text' executable
      public say_hello
      public write
      public close
      public sum
      public open
      public read
      public lseek


sum:
     mov rax,rdi 
      ret 0

say_hello:
      mov rax,1;;sys write
      mov rdi,1;;stdout file descriptor
      lea rsi,[hello]
      mov rdx,6;;byte lenght
      syscall
      ret 0

;;linux function argument RDI, RSI, RDX, RCX
;;linux syscall sys_read = 0 sys_write = 1 sys_close = 3 sys_open = 2 sys_lseek = 8

read:
      mov rax,0
      syscall
      ret 0

write:
      mov rax,1
      syscall
      ret 0

open:
      mov rax,2
      syscall
      ret 0

close:
      mov rax,3
      syscall
      ret 0

lseek:
      mov rax,8
      syscall
      ret 0

;;end linux syscall


      ;;exit
      mov rax, 60
      xor rdi,rdi
      syscall

section ".data"
      hello db 'hello',10
      mytest db 'test',10

