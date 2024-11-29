
; r9	; 6th param
; r8	; 5th param
; r10	; 4th param
; rdx	; 3rd param
; rsi	; 2nd param
; rdi	; 1st param

SYS_REBOOT = 169
LINUX_REBOOT_MAGIC1 = 0xfee1dead
LINUX_REBOOT_MAGIC2 = 0x28121969
LINUX_REBOOT_CMD_RESTART = 0x1234567

format ELF64 executable 3

segment readable executable

entry $

      mov rax,SYS_REBOOT
			mov rdi,LINUX_REBOOT_MAGIC1
			mov rsi,LINUX_REBOOT_MAGIC2
			mov rdx,LINUX_REBOOT_CMD_RESTART
      syscall



