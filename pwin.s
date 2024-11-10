; r9	; 6th param
; r8	; 5th param
; r10	; 4th param
; rdx	; 3rd param
; rsi	; 2nd param
; rdi	; 1st param
format ELF64
section '.text' executable
      extrn XOpenDisplay ;out eax display pointer ;rdi 0
     
      extrn XDefaultRootWindow;rdi display out root window
                               
      ;example ;display, rootwindow, 0, 0, 800, 600, 0, 0, 0xffffffff
      extrn XCreateSimpleWindow ;display, parent, x, y, width, height, border_width, 
                                ;border, background -out window
                                ;window = unsigned long

      extrn XMapWindow;rdi display rsi window);

      ;extrn XCloseDisplay;rdi display
      extrn XInternAtom; rdi 0 rsi "WM_DELETE_WINDOW" rdx bool out rax Atom

      extrn XFlush; rdi MainDisplay

      public _start
      
_start:
      

      mov rdi,0
      call XOpenDisplay
      mov r15,rax;save display

      ;maybe we can save in memory
      ;mov [xdisplay],rax
      ;mov r15,[xdisplay]
     

      mov rdi, r15
      call XDefaultRootWindow
      mov r14, rax;save default root window

      
      mov rdi,r15;display
      mov rsi,r14;parent root window
      mov rdx,0;x
      mov r10,0;y 
      mov r8,800;width
      mov r9,600;height
     
      
      ;passing arguments by stack not work
      ;7 8 9 argument in reverse order 
      mov rax,0xffffffff;white backgorund 
      ;push rax
      
      mov rax,0;border
      ;push rax
      
      mov rax,0;border_width
      ;push rax


      call XCreateSimpleWindow
      mov r13,rax;save window

      mov rdi,r15
      mov rsi,r13
      call XMapWindow
      
      mov rdi,r15
      call XFlush

      ;set window not close
      ;mov rdi,r15
      ;lea rsi, [delete_win_atom]
      ;mov rdx,0
      ;call XInternAtom

      jmp $

      call sys_exit

include "syscall.s"

section '.data'
delete_win_atom db 'WM_DELETE_WINDOW',0
xdisplay dq ?
