.text



.globl main
main:
	addi $sp $sp, -12 #aloca 4 inteiros na pilha
	addi $a0, $zero, 5 #atribui o valor de n
	addi $a1, $zero, 3 #atribui o valor de m
	sw $a0, 0($sp) #salva n na pilha
	sw $a1, 4($sp) #salva m na pilha
	sw $ra, 8($sp) #salva o endereco de retorno na pilha
	jal procedimento1 #chama o procedimento com m e n de argumentos
	lw $ra, 8($sp) #restaura o endereco de retorno da main
	add $s2, $v0, $zero #armazena o retorno da funcao no registrador s2
	add $sp, $sp, 12 #restaura a pilha
	sw $s2, 0($sp) #salva resultado na pilha
	addi $v0, $zero, 17 #ajusta o syscall para retorno
	addi $a0, $zero, 0 #ajusta o retorno da funcao para 0
	syscall
	



procedimento3:


	
	#t0 usado como variavel temporaria
	
	slt $t1, $a0, $a1
	bgtz $t1, if_verdadeiro
	j if_falso
	if_verdadeiro:
		add $t0, $a0, $zero 
		add $a0, $a1, $zero #a0 recebe a1
		add $a1, $zero, $t0 #a1 recebe tmp
	if_falso:
	
	verifica_while:

		slt  $t1, $a1, $a0
		bgtz $t1 executa_while
		j fim_while
	executa_while:
		addi $a0, $a0, -1
		addi $a1, $a1, 1
		j verifica_while
	fim_while:
	
	add $v0, $zero, $a0
	jr $ra


procedimento2:	
	
	addi $sp, $sp, -28 #aloca espaco para 2 variaveis, $ra e registradores s na stack
	sw $s0, 12($sp) #salva o valor dos registradores na stack
	sw $s1, 16($sp)
	sw $s2, 20 ($sp)
	sw $s4, 24($sp)
	
	sw $a0, 0($sp) #aloca a0 na posicao 0 da pilha
	la $t3, valor1 #le o endereco de valor 1
	lw $a1, 0($t3) #armazena o valor de valor1
	sw $a1, 4($sp) #aloca valor1 na pilha de execucao
	sw $ra, 8($sp) #salva o endereco de retorno na stack
	jal procedimento3 #p1
	
	add $s0, $v0, $zero #carrega o valor retornado em s0
	
	
	lw $a0, 0($sp) #restaura o valor do a0
	
	la $t3, valor2 #le o endereco de valor2
	lw $a1, 0($t3) #carrega o endereco de valor2
	sw $a1, 4($sp) #carrega v2 na pilha
	jal procedimento3 #p2
	add $s1, $v0, $zero #salva o valor de retorno em s1

	sub $v0, $s0, $s1 #subtrai s1 de s0 e armazena em s0
	
	#restaurar s0 e s1
	lw $s0, 12($sp)
	lw $s1, 16($sp)
	lw $s2, 20($sp)
	lw $s4, 24($sp)
	
	lw $ra, 8($sp) #restaura o endereco de retorno
	
	addi $sp, $sp, 28 #restaura a pilha
	

	jr $ra #volta para o procedimento chamador
	

procedimento1:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	#ate aqui a pilha esta alocada ate a posicao 12
	#A PARTIR DAQUI HA REALOCACAO DA PILHA.
	addi $sp, $sp, -48 #aloca espaço para as 10 posicoes do vetor e as 2 variaveis
	sw $ra, 44($sp)
	add $s4, $zero, $zero #seta i para 0
	sw $s4, 36($sp) #aloca i na stack como zero
	sw $s4, 40($sp) #aloca acumulador na stack como 0
	verifica_for:
		slti $t3, $s4, 10 #COMECAFOR
		bgtz $t3, executa_for #COMECAFOR
		j fim_for
	executa_for:
		mul $s2, $s4, 4 #armazena o deslocamento da pilha em s2
		add $s2, $s2, $sp #soma o endereco da pilha a s2

		mul $t4, $s4, $s0 #multiplica i por x 
		add $t4, $t4, $s1 #adiciona y ao resultado anterior
		sw $t4, 0($s2) #arnazena o conteudo de t4 no endereco contido em s2
		
		
		lw $a0, 0($s2) #armazena em a0 o valor que s2 guarda para chamar a funcao
		addi $sp, $sp, -4 #aloca espaco para 2 inteiros na pilha
		##
		jal procedimento2
		sw $v0, 0($s2) #salva o valor retornado 
		addi $sp, $sp, 4 #libera os valores salvos na stack
		lw $t4, 0($s2) #pega o valor de v[i]
		lw $t5, 40($sp) #armazena o valor da variavel de aumento de valor
		add $t5, $t4, $t5 #soma os dois valores
		sw $t5, 40($sp) #armazena o valor da variavel de aumento de valor na pilha
		add $s4, $s4, 1
		j verifica_for
	fim_for:
	
	lw $ra, 44($sp)
	lw $t1, 40($sp) #carrega em t1 o valor do acumulador
	addi $sp, $sp, 48
	add $v0, $zero, $t1 #ajusta o valor do retorno
	jr $ra  #retorna ao procedimento chamador
		
.globl fim
fim:
	
	
	

.data
valor1: .word 10
valor2: .word 20
