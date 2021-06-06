.text
.globl main
main:
	la $s0, dimensao
	lw $s1, 0($s0)
	mul $s2, $s1, -12 # 3vetores de 4 bytes cada
	add $sp, $sp, $s2 #aloca os 3 vetores
	add $sp, $sp, -4 
	#vetor a comeca em 0
	#vetor b comeca em 40
	#vetor_soma comeca em 80
	#*ptr comeca em 120

	#prepara a chamada do preenche
	add $a0, $zero, $sp #coloca o endereco do vetor a em a0
	add $a1, $zero, $s1 #coloca a dimensao como segundo parametro
	add $a2, $zero, 3 #coloca o valor 3 como terceiro parametro

	jal preenche

	##fim da chamada do preenche

	#prepara a chamada do preenche
	addi $a0, $sp, 40
	add $a1, $zero, $s1
	addi $a2, $zero, 5

	jal preenche

	#prepara a chamada do soma
	add $a0, $zero, $sp
	addi $a1, $sp, 40
	addi $a2, $sp, 80
	add $a3, $s1, $zero

	jal soma



inicializa_for_main:
	addi $s2, $sp, 80 #salva o endereco de ptr
	sw $s2, 120($sp) #salva o endereco de ptr na stack
	
	addi $t1, $sp, 80 #pega o valor de vetor_soma
	add $t7, $zero, $s1 #pega o valor de dimensao
	mul $t7, $t7, 4 #multiplica a dimensao por 4 para somar ao ponteiro
	add $t1, $t7, $t1 #pega o endereco limite do vetor
verifica_for_main:
	slt $t2, $s2, $t1
	bgtz $t2, executa_for_main
	
	j fim_for_main
	
executa_for_main:
	add $a0, $s2, $zero
	jal apresenta_valor
	add $s2, $s2, 4
	j verifica_for_main
	


fim_for_main:
	addi $sp, $sp, 124
	addi $v0, $zero, 17 #ajusta o syscall para retorno
	addi $a0, $zero, 0 #ajusta o retorno da funcao para 0
	syscall




preenche:

	
	addi $sp, $sp, -12
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	
	addi $sp, $sp, -4
	add $s0, $zero, $zero, #inicializa o i com 0
	sw $s0, 0($sp)
	
	
	inicializa_for_preenche:
		add $s0, $s0, $zero #atribui 0 ao i
	verifica_for_preenche:
		slt $t0, $s0, $a1
		bgtz $t0, executa_for_preenche
		j fim_for_preenche
		
	executa_for_preenche:
		mul $t1, $s0, 4 #armazena em t1 o deslocamento do vetor
		add $t2, $a0, $zero #salva em t2 o endereco base do vetor
		add $t2, $t2, $t1 #obtem o endereco do vetor a ser modificado 
		sw $a2, 0($t2) #armazena o valor de a2 no endereco efetivo do vetor
		addi $a2, $a2, 1 #soma 1 ao valor de a2
		addi $s0, $s0, 1 #incrementa i
		j verifica_for_preenche
	
	fim_for_preenche:
	
	add $sp, $sp, 4 #desfaz a alocacao do i na pilha
	
	
	
	
	lw $s0, 0($sp) #restaura os registradores
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	add $sp, $sp, 12 #restaura a pilha
	jr $ra
	



soma:
	###prologo
	addi $sp, $sp, -12 #aloca espaco para salvar os registradores
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	
	#corpo da funcao
	
	

	#ptr_end sera usado em t1
	mul $t0, $a3, 4 #multiplica a constante la por 4 pra somar ao endereco do vetor
	add $t1, $a2, $t0 #obtem o endereco do ptr_end
		
	inicializa_for_soma:
		add $t2, $a2, $zero #coloca o endereco de ptr como o endereco de c
	verifica_for_soma:
		slt $t3, $t2, $t1
		bgtz $t3, executa_for_soma
		j fim_for_soma
	executa_for_soma:
		lw $t3, 0($a0) #carrega o valor de a
		lw $t4, 0($a1) #carrega o valor de b
		
		add $t5, $t3, $t4 #armazena em t5 a soma entre os valores de a e b
		sw $t5, 0($t2)
		
		
		#faz o incremento do for
		addi $t2, $t2, 4
		addi $a0, $a0, 4
		addi $a1, $a1, 4
		j verifica_for_soma
	fim_for_soma:

	
	
	
	
	
	####epilogo
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12 #restaura a pilha
	jr $ra
	
	


apresenta_valor:
	
	add $v0, $zero, 1
	lw $a1, 0($a0)
	add $a0, $a1, $zero
	syscall
	la $a0, espaco_vetor
	add $v0, $zero, 4 #coloca em v0 o print string
	syscall
	add $v0, $zero, $zero
	jr $ra

fim_programa:




	








.data
dimensao: .word 10
espaco_vetor: .asciiz " "
