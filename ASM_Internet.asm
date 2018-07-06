; NOTE: I didn't make this, I got it from here: https://gist.github.com/thosakwe/ec7a5fc628173a353088

; We access the MangaEden API and request a list of the first 25 available manga. I used a buffer size of 5000, but feel free to modify it.
; I basically learned ASM today, just felt like posting this somewhere.


.386
.model flat, stdcall
option casemap:none

; Includes
include C:\masm32\include\windows.inc
include C:\masm32\include\kernel32.inc
includelib C:\masm32\lib\kernel32.lib
include C:\masm32\include\wininet.inc
includelib C:\masm32\lib\wininet.lib

; Initialized data
.data
szAgent db "OK ASM is really tedious", 0
szUrl db "https://www.mangaeden.com/api/list/0/?p=0&l=25", 0
szFailInternetOpen db "Failed to InternetOpen.", 13, 10, 0
szFailInternetOpenUrl db "Failed to InternetOpenUrl.", 13, 10, 0
szFailInternetReadFile db "Failed to InternetReadFile.", 13, 10, 0
szData db 5000 DUP(0)

; Uninitialized data
.data?
hConsoleOutput dd ?
hInternet dd ?
hFile dd ?
bytesWritten dd ?
dwContext dw ?
bytesRead dd ?

.code

failInternetOpen proc
	invoke WriteConsole, hConsoleOutput, offset szFailInternetOpen, sizeof szFailInternetOpen, offset bytesWritten, 0
	jmp complete
failInternetOpen endp

failInternetOpenUrl proc
	invoke WriteConsole, hConsoleOutput, offset szFailInternetOpenUrl, sizeof szFailInternetOpenUrl, offset bytesWritten, 0
	jmp complete
failInternetOpenUrl endp

failInternetReadFile proc
	invoke WriteConsole, hConsoleOutput, offset szFailInternetReadFile, sizeof szFailInternetReadFile, offset bytesWritten, 0
	jmp complete
failInternetReadFile endp


complete proc
	invoke CloseHandle, hConsoleOutput
	invoke ExitProcess, 0
	ret
complete endp

start:
	; Get write handle
	invoke GetStdHandle, -11
	mov [hConsoleOutput], eax
	
	;InternetOpen
	invoke InternetOpen, addr szAgent, INTERNET_OPEN_TYPE_DIRECT, 0, 0, 0
	mov [hInternet], eax
	cmp hInternet, 0
	je failInternetOpen
	
	;InternetOpenUrl
	invoke InternetOpenUrl, hInternet, offset szUrl, 0, 0, INTERNET_FLAG_RELOAD, 0
	mov [hFile], eax
	cmp hFile, 0
	je failInternetOpenUrl
	
	;InternetReadFile
	invoke InternetReadFile, hFile, offset szData, 5000, offset bytesRead
	cmp eax, 0
	je failInternetReadFile
	
	;Success
	invoke WriteConsole, hConsoleOutput, offset szData, bytesRead, offset bytesWritten, 0
	
	invoke InternetCloseHandle, hInternet
	jmp complete
end start
