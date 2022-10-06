format PE64 Console 5.0
entry Start
include 'win64a.inc'

section '.bss' readable writeable
  readBuf db ?
 
section '.idata' import data readable
  library kernel,'KERNEL32.DLL'
  import kernel, SetConsoleTitleA, 'SetConsoleTitleA', \
  GetStdHandle, 'GetStdHandle', WriteConsoleA, 'WriteConsoleA', \
  ReadConsoleA, 'ReadConsoleA', ExitProcess, 'ExitProcess'


section '.data' data readable writeable
  memA Dd 200307.21 ;делимое
  memB Dd 157202.5 ;делитель
  
  memS Dd 0 ; переменная S, которая будет получена после вычислений
  dop DD 0.5
  

  conTitle db 'Console', 0
  mes1 db 'Number A is equal to number S', 0dh, 0ah, 0
  mes1Len = $-mes1
  mes2 db 'Number A is less then number S', 0dh, 0ah, 0
  mes2Len = $-mes2
  mes3 db 'Number A is greater then number S', 0dh, 0ah, 0
  mes3Len = $-mes3
  hStdIn dd 0
  hStdOut dd 0
  chrsRead dd 0
  chrsWritten dd 0
  STD_INP_HNDL dd -10
  STD_OUTP_HNDL dd -11


section '.text' code readable executable
Start:
  invoke SetConsoleTitleA, conTitle
  test eax, eax
  jz Exit
  invoke GetStdHandle, [STD_OUTP_HNDL]
  mov [hStdOut], eax
  invoke GetStdHandle, [STD_INP_HNDL]
  mov [hStdIn], eax
  
    fld [memB]
    fsin
    
    fld [memA] ; ST0 = A, ST1 = sin(B)
    fsub ST0, ST1 ; ST0 = ST0 - ST1 = A - sin(B)
    fadd [dop] ; ST0 = S = A + 1/2 - sin(B)
    fst [memS] ; записываем результат в переменную S
    fld [memA] ; ST0 = A, ST1 = S
    
    fcomi ST0, ST1
    jz Equal
    jc Less

    invoke WriteConsoleA, [hStdOut], mes3, mes3Len, chrsWritten, 0
    JMP Exit
    
Equal:
    invoke WriteConsoleA, [hStdOut], mes1, mes1Len, chrsWritten, 0
    JMP Exit

Less:
    invoke WriteConsoleA, [hStdOut], mes2, mes2Len, chrsWritten, 0
    JMP Exit

Exit:
  invoke ReadConsoleA, [hStdIn], readBuf, 1, chrsRead, 0
  invoke ExitProcess, 0
