  ;;; Assemble with:
  ;;; ml /c / Zd /coff AnotherHello.asm
  ;;; link /SUBSYSTEM:WINDOWS AnotherHello.obj

  .386
  .model flat, stdcall
  option casemap :none

  include \masm32\include\windows.inc
  include \masm32\include\kernel32.inc
  include \masm32\include\masm32.inc
  include \masm32\include\user32.inc

  includelib \masm32\lib\kernel32.lib
  includelib \masm32\lib\masm32.lib
  includelib \masm32\lib\user32.lib

  .data
      ;; HelloWorld db "Hello World! Windows Version!", 0
      HelloWorld db "Hello World!", 13, 10, 0
      ;NewString db "Uryyb Jbeyq!", 13, 10, 0
      ;; NewString db "THIS IS A LONG ASS STRING THAT IS LONGER THAN THE THING AYO!@@", 13, 10, 0
      ;; NewString db "shrt", 13, 10, 0
      Leng dd 10

  .data?
      NewString byte ?

  .code
start:

  cld    ; sets direction flag to forward
  ;; movs esi, BYTE PTR [HelloWorld]
  ;; movs esi, HelloWorld
  ;; movs edi, NewString
  ;; mov ecx, 13
  ;rep movsb
	;; invoke MessageBox, NULL, addr NewString, addr NewString, MB_OK

  mov ebx, 0 ; this can also be: xor eax, eax
L1:
  ;; mov al, BYTE PTR HelloWorld[ebx] ; Turns out the BYTE PTR is unnecessary
  mov al, [HelloWorld + ebx] ; This is equivalent to the above line
  mov NewString[ebx], al     ; Which is equivalent to this
  ;; add NewString[ebx], 13  ; This is just a rot13 thingo
  ;; invoke StdOut, addr [NewString + ebx]
  inc ebx
  ;; cmp ebx, Leng
  cmp HelloWorld[ebx], 13
  jnz L1
  mov NewString[ebx], 0

	;; invoke StdOut, addr HelloWorld ; Note: StdOut is a MASM macro which simply calls other functions (WriteConsole?)
	invoke StdOut, addr HelloWorld
	invoke StdOut, addr NewString
	;; invoke MessageBox, NULL, addr HelloWorld, addr HelloWorld, MB_OK
	invoke MessageBox, NULL, addr NewString, addr NewString, MB_OK
	invoke ExitProcess, 0
  ;Also note: 'invoke' is also specific to MASM. Simply used so you don't have to push the parameters beforehand.

  end start
