use64

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


hello db 'Hello from pavon binary',10
hello_size = $ - hello

SYS_WRITE = 1
SYS_EXIT = 60
STDOUT = 1
