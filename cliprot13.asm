;;; Assemble with:
;;; ml /c / Zd /coff cliprot13.asm
;;; link /SUBSYSTEM:WINDOWS cliprot13.obj

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
errorText db "Cliprot13.exe Error", 0
clipFailText db "Could not open clipboard", 13, 10, 0
clipDataFailText db "Could not get data from clipboard", 13, 10, 0
clipSetFailText db "Could not set clipboard", 13, 10, 0
hClipHandle DWORD ?


.data?
inputString db 16384 dup(?)
rotated     db 16384 dup(?)

.code

ClipFail proc
    ;; invoke StdOut, addr clipFailText
    invoke  MessageBoxA, 0, clipFailText, errorText, MB_ICONWARNING
    jmp     Complete
ClipFail endp

ClipDataFail proc
    ;; invoke StdOut, addr clipDataFailText
    invoke  MessageBoxA, 0, clipDataFailText, errorText, MB_ICONWARNING
    jmp     Complete
ClipDataFail endp

ClipSetFail proc
    ;; invoke  StdOut, addr clipSetFailText
    invoke  MessageBoxA, 0, clipSetFailText, errorText, MB_ICONWARNING
    jmp     Complete
ClipSetFail endp

Complete proc
    invoke  CloseClipboard
    invoke  ExitProcess, 0
Complete endp

start:

    invoke  OpenClipboard, 0
    cmp     eax, 0
    je      ClipFail

    xor     eax, eax

    invoke  GetClipboardData, CF_TEXT ; The WinAPI version
    mov     [hClipHandle], eax        ;
    cmp     hClipHandle, 0            ; hi
    je      ClipDataFail              ; hi

    mov     esi, hClipHandle
    mov     edi, offset inputString
    xor     ecx, ecx

cpy_nxt:
    mov     al, [esi]
    mov     [edi], al
    inc     esi
    inc     edi
    cmp     al, 0
jnz cpy_nxt

    invoke  EmptyClipboard

    mov     ebx, 0
L1:
    mov     al, inputString[ebx]
    cmp     al, 65                  ; if char is < capitals
    jb      NoRot
    cmp     al, 122
    ja      NoRot
    cmp     al, 90
    ja      MaybeLower
    ; if you're here, then its an uppercase letter (>=65, <=90)
    cmp     al, 77
    ja      Sub13
    add     al, 13
    mov     rotated[ebx], al
    jmp     NextLetter
Sub13:
    sub     al, 13
    mov     rotated[ebx], al
    jmp     NextLetter
MaybeLower:
    cmp     al, 97
    jb      NoRot
    cmp     al, 109
    ja      Sub13
    add     al, 13
    mov     rotated[ebx], al
    jmp     NextLetter
NoRot:
    mov     rotated[ebx], al

NextLetter:
    inc     ebx
    cmp     inputString[ebx], 0                   ; if string terminator found
    jnz     L1                                    ; end of rot13 loop

    mov     rotated[ebx], 0

    ;; invoke    SetClipboardData, CF_TEXT, addr rotated      ; This is the WinAPI version, doesn't work. Requires some weird GlobalAlloc memory ???
    invoke  SetClipboardText, addr rotated                    ; WAOW this is just a MASM procedure, the WinAPI one is ????????

    invoke  CloseClipboard
    jmp     Complete

end start
