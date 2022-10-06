.data
memA: .float 200307.21
memB: .float 157202.5
memS: .float 0 # ���������� ��� ������ �������� ����� S

esp: .float 1.0e-15 # �������� ���������� SIN
pi2: .float 6.283185307 # pi*2

border: .float 10.0 # ������� �������� ��� memB, ������������ ��� ������� ��������� �������������� memB
dop: .float 0.5 # ����������� ��� ���������� ����� S

h1: .asciiz "\n"
mes_sin: .asciiz "sin(B) = "
mes_A: .asciiz "A = "
mes_B: .asciiz "B = "
mes_S: .asciiz "S = "

mes_res: .asciiz "\nResult: "
mes_equal: .asciiz "number A is equal to number S\n"
mes_less: .asciiz "number A is less then number S\n"
mes_greater: .asciiz "number A is greater then number S\n"

.text

#------------------------------------------ ���������� SIN(memB) --------------------------------------------#
SIN:
	# ��� ����������� ���������� ������, ��� ������������� 
	# ����������� ������� ����� memB � ������� ��� ������������� 
	# ���������� ������� sin(B) = sin(B - 2*pi*k), ��� k - ����� �����
	
	lwc1 $f0, memB # �������� memB � ������� f0
	lwc1 $f1, border 
	c.lt.s $f1, $f0 # ���������� ���������
	bc1t FindEqual # ��� ������� memB ��������� � ����������� �������������� ��� �����
	
Continue: # ������� � ������ ���������� sin(memB)	
	li $t0, 1 # ������� n = 1
	lwc1 $f1, esp
	mov.s $f2, $f0 # ����� ������ ���������� ���� ���� r, r_0 = x = memB
	
	la $a0, mes_sin # �������� � ������� ��������� mes_sin
	li $v0, 4
	syscall # ������� �� ��������� �����
	
Loop:
	abs.s $f3, $f2 # ���� ������ �� ����� ���� � ���������� ��� � f3
	c.lt.s $f3, $f1 # ������� ���� ���� � ����������� ���������
	bc1t LabTask # ���� ���� ���� ��-�������� ������ ������ ��������, ���� �����������
	
	add.s $f12, $f12, $f2 # ��������� � ����� ����� ���� ����
	add $t0, $t0, 2 # ����������� ������� n �� 2
	
	sub $t1, $t0, 1 # �������� �� ������� 1 � ��������� ��������� � $t1
	mul $t1, $t1, $t0 # ������������ ������������ n*(n-1)
	mtc1 $t1, $f4 # �������� ���������� �� $t1 � $f4
	cvt.s.w $f4, $f4 # ��������� ����� ����� n*(n-1) � ���
	
	div.s $f4, $f0, $f4 # ����� x/(n*(n-1))
	mul.s $f4, $f4, $f0 # �������� ��������� �� x
	neg.s $f4, $f4 # ��������� ��������� �� (-1)
	mul.s $f2, $f2, $f4 # �������� ���������� �� ���������� ���� ����
	
	# � ���������� ��������, ��� f2 = -r*x*x/(n*(n-1))
	
	j Loop # ������������ � ������ �����

FindEqual:
	lwc1 $f1, pi2 # ���������� � ������� ��������� pi*2
	div.s $f2, $f0, $f1 # ����� memB/(pi*2) � ���������� ��������� � f2
	
	# ������ ����� ��������� ���������� ����� ����
	# ��� ����� ����� �������������� float � int, �������� ������� �����
	
	cvt.w.s $f2, $f2 # ����������� f2 � ����� ����� � �������������� ��� � f2
	mfc1 $t0, $f2 # ��������� ���������� ����� ����� � ������� t0
	mtc1 $t0, $f2 # �������������� ����� ����� t0 ������� � ������� f2
	cvt.s.w $f2, $f2 # ��������� ����� ����� ������� � ���
	
	mul.s $f1, $f1, $f2 # �������������� � f1 ������������ �� (2*pi) �� �� ������������ ����� ���-��
	sub.s $f0, $f0, $f1 # �������� �� memB ���������� ����� � ���������� ���������. ��� � ���� ���������� ������������� �����
	
	j Continue

#--------------------------------------- ������ ���������� ������ ��3 -----------------------------------------#
LabTask:	
	li, $v0, 2
	syscall # ������� �� ����� ���������� �������� f12 = sin(B)
	
	la $a0, h1
	li, $v0, 4
	syscall # ���������� ������� ������ (������� ��������� "\n")
	
	# ������ ������������ S = A + 0.5 - sin(B)
	# memA ����� ������� � �������� f0
	# dop = 0.5 ����� ������� � f1
	# �������� sin(B) ����� ��-�������� ������������ �� �������� f12
	
	lwc1 $f0, memA
	lwc1 $f1, dop
	add.s $f2, $f0, $f1
	sub.s $f2, $f2, $f12
	swc1 $f2, memS # ���������� ��������� � ���������� memS

#------------------------------------- ������� �������� ����� A, B � S -----------------------------------------#	
	la $a0, mes_A
	li, $v0, 4
	syscall # ������� �� ����� ��������� mes_A
	mov.s $f12, $f0 # ���������� � f12 �������� ����� A
	li, $v0, 2
	syscall # ������� �� ����� ���������� �������� f12 = sin(B)
	la $a0, h1
	li, $v0, 4
	syscall # ���������� ������� ������ (������� ��������� "\n")
	
	la $a0, mes_B
	li, $v0, 4
	syscall # ������� �� ����� ��������� mes_B
	lwc1 $f12, memB # ���������� � f12 �������� ����� B
	li, $v0, 2
	syscall # ������� �� ����� ���������� �������� f12 = B
	la $a0, h1
	li, $v0, 4
	syscall # ���������� ������� ������ (������� ��������� "\n")	
	
	la $a0, mes_S
	li, $v0, 4
	syscall # ������� �� ����� ��������� mes_S
	lwc1 $f12, memS # ���������� � f12 �������� ����� S
	li, $v0, 2
	syscall # ������� �� ����� ���������� �������� f12 = S
	la $a0, h1
	li, $v0, 4
	syscall # ���������� ������� ������ (������� ��������� "\n")
	
#---------------------------------- ����� ���������� ��������� ����� A � S -------------------------------------#	
	la $a0, mes_res
	li, $v0, 4
	syscall
	
	# memA �������� � $f0
	# memS ��-�������� ��������� � $f12 � � $f2
	c.eq.s $f0, $f12
	bc1t Equal
	c.lt.s $f0, $f12
	bc1t Less
	
Greater:
	la $a0, mes_greater
	li, $v0, 4
	syscall
	j Exit

Equal:
	la $a0, mes_equal
	li, $v0, 4
	syscall
	j Exit
	
Less:
	la $a0, mes_less
	li, $v0, 4
	syscall
	
Exit:	
	li, $v0, 10
	syscall # ��������� ���������