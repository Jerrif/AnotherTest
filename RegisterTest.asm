  .386
  .model flat, stdcall
  option casemap :none

	include \masm32\include\windows.inc
	include \masm32\include\kernel32.inc
	include \masm32\include\masm32.inc
	includelib \masm32\lib\kernel32.lib
	includelib \masm32\lib\masm32.lib

.data
      ProgramText db "Hello World!", 13, 10, 0                 ; 13, 10 is CRLF, 0 is terminating byte
      BadText db "Error: Sum is incorrect value", 13, 10, 0    ; db = Define Byte
      GoodText db "Excellent! Sum is 6", 13, 10, 0
      Sum sdword 0 ; SDWORD = Signed DWORD. Allocates and (optionally) initializes.

.code
start:
  mov ecx, 6
  xor eax, eax
_label:
  add eax, ecx
	dec ecx
  jnz _label
  mov edx, 7
  mul edx
  push eax
  pop Sum
  cmp Sum, 148
  jz _good
_bad:
  invoke StdOut, addr BadText
  jmp _quit
_good:
  invoke StdOut, addr GoodText
_quit:
  invoke ExitProcess, 0

  end start
