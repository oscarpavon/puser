; r9	; 6th param
; r8	; 5th param
; r10	; 4th param
; rdx	; 3rd param
; rsi	; 2nd param
; rdi	; 1st param
format ELF64
section '.text' executable

      public print_hello
      
print_hello:
      mov rdx,hello_text_size  
      lea rsi,[hello_text]
      call print
      call sys_exit



include "syscall.s"

section '.data'
hello_text db 'Hello gcc! by: fasm',10
hello_text_size = $ - hello_text
