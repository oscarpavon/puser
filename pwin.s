format ELF64
section '.text' executable writable
      public _start
      extrn XOpenDisplay
_start:
      
      mov rdi,0
      call XOpenDisplay
      call sys_exit

include "syscall.s"

