; ��� ��������� ���������� ������� � ����� ��������, ������
; �������� ���� �������� ��������� �� ��������� �(i, j)=�(i-1, j+1)-�(i+1, j-1). 
; ������� ��������� � ������ ����� ��������� � �������
; �������������� (� ������ �������) ������������ �������� � ����������
; ���������������� ��� �� �� ����������.

format PE64 Console 5.0
entry Start
include 'win64a.inc'
 
section '.idata' import data readable
  library kernel,'KERNEL32.DLL', msvcrt, 'msvcrt.dll'
  import kernel, SetConsoleTitleA, 'SetConsoleTitleA',\
      GetStdHandle, 'GetStdHandle', WriteConsoleA, 'WriteConsoleA',\
      ReadConsoleA, 'ReadConsoleA', ExitProcess, 'ExitProcess'
  import msvcrt, printf, 'printf',\
      setlocale, 'setlocale',\
      getch, '_getch' 


section '.data' data readable writeable
  A dd 1, 1, 10, 7, 4,\
       1, 4, 3, 4, 10,\
       6, 4, 8, 9, 10,\
       66, 1, 1, 55, 13 
       
 
  k_str dd 4
  k_colum dd 5
  k dd 0
  adds dd 0
  true_coinc dd 0
  
  dop dd 4
  ru db 'Russian', 0 
  mes1 db '����� ���������, ��������������� �������: k = %d', 0dh, 0ah, 0
  mes2 db '����� �������������� ��������: %0x%016x', 0dh, 0ah, 0
  mes_error db '������� ����� � �������� ������� ������ ���� ������ 2!!', 0dh, 0ah, 0
  mes_true db '������������� ����� �������� �� �������', 0dh, 0ah, 0
  mes_false db '������������� ����� �� �������� �� �������', 0dh, 0ah, 0

section '.text' code readable executable
Proc:
    pop rbp
    ; ��������� � �������� ������� ����� [A + �(������)*������ + �(��������)*������]
    pop r8            ; r8d = A
    mov ecx, [k_str]
    sub ecx, 2        ; cx = k_str - 2
    cmp ecx, 0
    jle incorrect_input
    
    mov edx, [k_colum]
    cmp edx, 2
    jle incorrect_input
    
    mov ebx, 4        ; ��� ����, ����� �������� ���� �� ������ ������ �������
    
    for_str:
        mov eax, ebx
        mul [k_colum]
        
        mov edx, [k_colum]
        sub edx, 2
        add eax, r8d  ; ������ eax - ������ N ������ �������
        
        mov esi, 0
        for_colum:
            inc esi
            jmp calculations    
            continue:
            dec edx
            cmp edx, 0
            jg for_colum     
        add ebx, 4  
    loop for_str
        
    mov r12d, eax
    xchg eax, esi
    mul [dop]
    add r12d, eax
    mov [adds], r12d
    invoke printf, mes2, [adds]
    JMP exit_proc
        
    calculations:
        mov r9, [eax+esi*4]
        mov r10d, eax
        sub r10d, 20
        mov r10d, [r10d+(esi+1)*4] ; A[i-1, j+1]
        
        mov r11d, eax
        add r11d, 20 
        mov r11d, [r11d+(esi-1)*4] ; A[i+1, j-1]
        
        sub r10d, r11d
        cmp r9d, r10d
        jz coincidence
        jmp continue
        coincidence:
            inc [k]
            cmp edx, 1
            jz last_but_one
            jmp continue
        last_but_one:
            inc [true_coinc]
            jmp continue
    
  incorrect_input:
      invoke printf, mes_error 
              
  exit_proc: 
      push rbp
      RET

Start:
  invoke setlocale, 0, ru
  push A
  call Proc
  cmp [true_coinc], 0
  jg true_mes
  invoke printf, mes_false
  jmp Exit
  true_mes:
      invoke printf, mes_true

Exit:
  invoke printf, mes1, [k]
  invoke getch
  invoke ExitProcess, 0
