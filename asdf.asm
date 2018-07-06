;;; Assemble with:
;;; ml /c / Zd /coff rot13.asm
;;; link /SUBSYSTEM:WINDOWS rot13.obj

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
  prompt db "Enter a string to rot13: ", 13, 10, 0
  another db "Hi this is a test string", 13, 10, 0
  rotated     db 128 dup(" ")
  newString db 128 dup(" ")
  asdf dd OFFSET another
  .data?
  inputString db 128 dup(?)
  ;; rotated     db 128 dup(?)

  .code
start:
  ;; invoke StdOut, addr prompt
  ;; invoke StdIn, addr inputString, 128
    cld

    ;; invoke  StdOut, asdf
    mov esi, asdf
    mov edi, offset newString
    xor ecx, ecx
cpy_nxt:
    mov al, [esi]
    mov [edi], al
    ;; invoke  StdOut, esi
    inc esi
    inc edi
    ;; test al, al
    cmp al, 0
jnz cpy_nxt

    ;; invoke  StdOut, addr prompt
    invoke  StdOut, addr newString
    ;; invoke  StdOut, asdf

;;   cld
;;   mov ebx, 0
;; L1:
;;   mov al, [inputString + ebx]
;;   cmp al, 65                  ; if char is < capitals
;;   jb NoRot
;;   cmp al, 122
;;   ja NoRot
;;   cmp al, 90
;;   ja MaybeLower

;;   ; if you're here, then its an uppercase letter (>=65, <=90)
;;   ;; mov rotated[ebx], al
;;   cmp al, 77
;;   ja Sub13
;;   add al, 13
;;   mov rotated[ebx], al
;;   jmp NextLetter
;; Sub13:
;;   sub al, 13
;;   mov rotated[ebx], al
;;   jmp NextLetter
;; MaybeLower:
;;   cmp al, 97
;;   jb NoRot
;;   cmp al, 109
;;   ja Sub13
;;   add al, 13
;;   mov rotated[ebx], al
;;   jmp NextLetter
;; NoRot:
;;   mov rotated[ebx], al
;; NextLetter:

;;   inc ebx
;;   cmp inputString[ebx], 0                   ; if string terminator found
;;   jnz L1                                    ; end of rot13 loop

;;   mov rotated[ebx], 0

  ;; invoke StdOut, addr rotated
  invoke ExitProcess, 0

  end start
