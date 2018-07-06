; This program was written following the tutorial at:
; https://www-s.acm.illinois.edu/sigwin/old/workshops/winasmtut.pdf

  .386
  .model flat, stdcall
  option casemap :none

	;include \masm32\include\masm32.inc
	;includelib \masm32\lib\masm32.lib
	include \masm32\include\windows.inc
	include \masm32\include\kernel32.inc
  include \masm32\include\user32.inc
	includelib \masm32\lib\kernel32.lib
  includelib \masm32\lib\user32.lib

  WinMain proto :DWORD, :DWORD, :DWORD, :DWORD

.data
  ClassName db "WinClass", 0
  AppName   db "Simple Window", 0

.data?
  hInstance HINSTANCE ?

.code
start:
  invoke GetModuleHandle, NULL
  mov hInstance, eax
  invoke WinMain, hInstance, NULL, NULL, 0
  invoke ExitProcess, eax

WinMain proc hInst:HINSTANCE, hPrevInst:HINSTANCE, CmdLine:LPSTR, CmdShow:DWORD
  local wc:WNDCLASSEX
  local msg:MSG
  local hwnd:HWND

  mov wc.cbSize, SIZEOF WNDCLASSEX
  mov wc.style, CS_HREDRAW or CS_VREDRAW
  mov wc.lpfnWndProc, offset WndProc
  mov wc.cbClsExtra, NULL
  mov wc.cbWndExtra, NULL
  push hInstance
  pop wc.hInstance
  mov wc.hbrBackground, COLOR_WINDOW+1
  mov wc.lpszMenuName, NULL
  mov wc.lpszClassName, offset ClassName
  invoke LoadIcon, NULL, IDI_APPLICATION
  mov wc.hIcon, eax
  mov wc.hIconSm, eax
  invoke LoadCursor, NULL, IDC_ARROW
  mov wc.hCursor, eax
  invoke RegisterClassEx, addr wc

  invoke CreateWindowEx, 0, addr ClassName, addr AppName, WS_OVERLAPPEDWINDOW or WS_VISIBLE, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, NULL, NULL, hInst, NULL

  mov hwnd, eax

.while TRUE
  invoke GetMessage, addr msg, NULL, 0, 0
  .break .if (!eax)
  invoke TranslateMessage, addr msg
  invoke DispatchMessage, addr msg
.endw
  mov eax, msg.wParam
  ret
WinMain endp

WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
  .if uMsg == WM_DESTROY
      invoke PostQuitMessage, 0
  .else
      invoke DefWindowProc, hWnd, uMsg, wParam, lParam
      ret
  .endif
  xor eax, eax
  ret
WndProc endp

end start
