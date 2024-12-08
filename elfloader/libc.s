format ELF64

SYS_WRITE = 1
SYS_EXIT = 60
STDOUT = 1

section '.text' executable
  public print_and_exit

print_and_exit:
  mov rax,1
  mov rdi,STDOUT
  lea rsi,[hello]
  mov rdx,hello_size
  syscall

  mov rax, SYS_EXIT
  xor rdi,rdi
  xor rsi,rsi
  xor rdx,rdx
  syscall

section '.data' writable
hello db 'this is a message from fasm',10
hello_size = $ - hello

