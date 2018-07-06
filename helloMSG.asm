;;; Compile this with
;;; ml /Dmasm /c /Cx /coff helloMSG.asm
;;; link /subsystem:windows helloMSG.obj kernel32.lib user32.lib

  .486                                    ; create 32 bit code
  .model flat, stdcall                    ; 32 bit memory model
   option casemap :none                    ; case sensitive

  include \masm32\include\windows.inc      ;always first

  ;; IFDEF masm
  ;;   ExitProcess equ _ExitProcess@4
  ;; ENDIF

  extrn ExitProcess@4   : near
  extrn MessageBoxA@16  : near

  .data
  MessageBoxMyTitle   db  "hello there", 0
  MessageBoxMyText    db  "This is some text in the msg box", 0
  ErrorCode           dd 0

  .code

_beginning:
  push MB_ICONHAND or MB_OKCANCEL
  push offset MessageBoxMyTitle
  push offset MessageBoxMyText
  push 0
  call MessageBoxA@16

  ;mov MessageBoxMyText, DWORD PTR eax
  push MB_ICONHAND
  push offset MessageBoxMyTitle
  push offset MessageBoxMyText
  push 0
  call MessageBoxA@16

  push ErrorCode
  call ExitProcess@4

end _beginning
