SYS_WRITE = 1
SYS_EXIT = 60
STDOUT = 1

format ELF64 executable 3

segment readable executable

entry $

  mov rax,SYS_WRITE
  mov rdi,STDOUT
  lea rsi,[hello]
  mov rdx,hello_size
  syscall

  mov rax, SYS_EXIT
  xor rdi,rdi
  xor rsi,rsi
  xor rdx,rdx
  syscall


segment readable writeable
hello db 'Hello from fasm',10
hello_size = $ - hello
