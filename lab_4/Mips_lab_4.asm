# ��� ��������� ���������� ������� � ����� ��������, ������ �������
# ���� �������� ��������� �� ��������� �(i, j)=�(i-1, j+1)-�(i+1, j-1).
# ������� ��������� � ������ ����� ��������� � ������� ������ ���
# ���������� (� ������ �������) ������������ �������� � ����������
# ���������������� ��� �� �� ����������.

.data
A: .word 1 1 10 7 4 
	 1 4 3 4 10 
	 6 4 8 9 10 
	 66 1 1 55 13 
k_str: .word 4
k_colum: .word 5

k: .word 0
adds: .word 0
true_coinc: .word 0

mes_k: .asciiz "The number of elements that satisfy the condition: k = "
mes_adds: .asciiz "\nThe address of penultimate element: "

.text
	addi $sp, $sp, -12
	la $a0, A
	sw $a0, 8($sp)
	la $a0, k_str
	sw $a0, 4($sp)
	la $a0, k_colum
	sw $a0, 0($sp)
	jal proc
	
	#xor $t1, $t1, $t1
	#lw $t1, 0($sp)
	#sw $t1, k
	#xor $t2, $t2, $t2
	#lw $t2, 4($sp)
	#sw $t2, true_coinc
	
	#xor $t3, $t3, $t3
	#lw $t3, 8($sp)
	#sw $t3, adds
	
	addi $sp, $sp, 8 
	j exit

#---------------- ������ ��������� -----------------#
proc:	 
	lw $t0, 8($sp) 
	lw $t1, 4($sp)
	lw $t2, 0($sp)
	addi $sp, $sp, 12
	addi $sp, $sp, -8
	
	lw $t1, 0($t1)  	# ���-�� ����� 
	lw $t2, 0($t2)   	# ���-�� �������� 
	la $t9, 0
	sub $t1, $t1, 2  	# �������� � t1 ����� �����, �� ������� ����� ��������
	la $t3, 1 		# ������� ��� ������� �� ������� � �����
	
loop_str:
	bltz $t1, exit_proc
	la $t4, 1 		# ������� ��� ������� �� ��������, �������� �� ������� ��������
	sub $t5, $t2, 2 	# �������� � t5 ����� ��������, �� ������� ����� ��������
	loop_colum:
		sub $t5, $t5, 1
		bltz $t5, continue_str
		j calculations
		continue_colum:
		sub $t7, $t7, $t8
		bne $t6, $t7, not_equal
		
		add $t9, $t9, 1
		# ������ ���������, ������������� ��� ������� � ������ ��� ���
		la $t7, 0
		la $t7,  k_str
		lw $t7, 0($t7)
		add $t7, $t7, $t2
		sub $t7, $t7, 4 # ������ � t7 �������� k_str + k_colum - 4
		
		la $t8, 0
		add $t8, $t3, $t4 # ������ � t8 ����� �������� ����� �� ������� � ��������
		
		bne $t7, $t8, not_equal # ���� ��� �� �����, �� ������� �� ������������
		la $t7, 1
		sw $t7, true_coinc
		#sw $t7, 4($sp)
		
		not_equal:
		add $t4, $t4, 1
		j loop_colum	
	continue_str:
	sub $t1, $t1, 1	
	add $t3, $t3, 1
	j loop_str

calculations:
	la $t6, 0
	mul $t6, $t3, $t2 
	add  $t6, $t6, $t4 
	mul $t6, $t6, 4
	add  $t6, $t6, $t0
	xor $t7, $t7, $t7
	move $t7, $t6 
	lw $t6, ($t6)
	
	sub $t7, $t7, 4
	sw $t7, adds # �������� � ���������� adds ����� 
	# (�� ��������� �������� � ���������� ��������� ����� �������������� ��������)
	#sw $t7, 8($sp)
			
	la $t7, 0
	sub $t7, $t3, 1
	mul $t7, $t7, $t2 
	add  $t7, $t7, $t4 
	add $t7, $t7, 1
	mul $t7, $t7, 4
	add  $t7, $t7, $t0	# �������� ����� A[i-1, j+1]
	lw $t7, ($t7) 		# �������� A[i-1, j+1]
		
	la $t8, 0
	add $t8, $t3, 1
	mul $t8, $t8, $t2 
	add  $t8, $t8, $t4 
	sub $t8, $t8, 1
	mul $t8, $t8, 4
	add  $t8, $t8, $t0	# �������� ����� A[i+1, j-1]
	lw $t8, ($t8) 		# �������� A[i+1, j-1]

	j continue_colum

exit_proc:
	#sw $t9, 0($sp)
	jr $ra
			
#----------- ����� ��������� � ������ ������ ����������� ------------#			
exit:
	la $a0, mes_k
	li $v0, 4
	syscall
	move $a0, $t9
	li $v0, 1
	syscall
	
	la $a0, mes_adds
	li $v0, 4
	syscall
	lw $a0, adds
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall


