# Colin Roye
# croye
# 110378271

#####################################################################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
##### ANY LINES BEGINNING .data WILL BE DELETED DURING GRADING! #####
#####################################################################

.text

# Part I
get_adfgvx_coords:

li $t0, 5
bgt $a0, $t0, get_adfgvx_coords_err
bgt $a1, $t0, get_adfgvx_coords_err



addiu $sp, $sp, -6
li $t0, 'A'
sb $t0, 0($sp)
li $t0, 'D'
sb $t0, 1($sp)
li $t0, 'F'
sb $t0, 2($sp)
li $t0, 'G'
sb $t0, 3($sp)
li $t0, 'V'
sb $t0, 4($sp)
li $t0, 'X'
sb $t0, 5($sp)

addu $t0, $sp, $a0
lb $v0, 0($t0)
addu $t0, $sp, $a1
lb $v1, 0($t0)

addiu $sp, $sp, 6

b get_adfgvx_coords_over
get_adfgvx_coords_err:
li $v0, -1
li $v1, -1
get_adfgvx_coords_over:

jr $ra

# Part II
search_adfgvx_grid:
	li $t1, 0
  li $t2, 35
	loop_ind_of:
	lbu $t0, 0($a0)
	beq $a1, $t0, loop_ind_of_over



	addiu $a0, $a0, 1
  addiu $t1, $t1, 1
  bgt $t1, $t2, search_adfgvx_grid_err
	b loop_ind_of
	loop_ind_of_over:

  li $t0, 6
  div $t1, $t0

  mfhi $v1
  mflo $v0
  b search_adfgvx_grid_over
  search_adfgvx_grid_err:
  li $v0, -1
  li $v1, -1
  search_adfgvx_grid_over:

	jr $ra




# Part III
map_plaintext:

map_plaintext_loop:
lb $t0, 0($a1)
beqz $t0, map_plaintext_over

addiu $sp, $sp, -20
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $a2, 8($sp)
sw $ra, 16($sp)
lb $a1, 0($a1)
jal search_adfgvx_grid



move $a0, $v0
move $a1, $v1
#translate x
jal get_adfgvx_coords


lw $t0, 8($sp)
sb $v0, 0($t0)
sb $v1, 1($t0)





lw $a0, 0($sp)
lw $a1, 4($sp)
lw $a2, 8($sp)
lw $ra, 16($sp)
addiu $sp, $sp, 20



addiu $a1, $a1, 1
addiu $a2, $a2, 2

b map_plaintext_loop
map_plaintext_over:

jr $ra

# Part IV
swap_matrix_columns:

li $t0, 0
addiu $sp, $sp, -4
sw $a0, 4($sp)
li $t0, 0
smc_loop:
lw $a0, 4($sp)

beq $t0 , $a1, smc_loop_over

mul $t1, $t0, $a2
addu $t1, $t1, $a0
# t1 i row

#a3 is j_1
addu $t9, $a3, $t1
#sp is j_2
lw $t3, 0($sp)
addu $t2, $t3, $t1

lb $t4, 0($t2)
lb $t5, 0($t9)


sb $t4, 0($t9)
sb $t5, 0($t2)

addiu $t0, $t0, 1

b smc_loop
smc_loop_over:

jr $ra

# Part V
key_sort_matrix:
  

jr $ra

memcpy:
	addiu $sp, $sp, -4
	sw $s0, 0($sp)
	blez $a2, memcpy_err
	li $s0, 0
	loop_memcpy:
	beq $s0, $a2 loop_memcpy_over

	lbu $t1, 0($a0)
	sb $t1, 0($a1)

	addiu $s0, $s0, 1
	addiu $a0, $a0, 1
	addiu $a1, $a1, 1
	b loop_memcpy
	loop_memcpy_over:
	li $v0, 0
	b memcpy_over
	memcpy_err:
	li $v0, -1
	memcpy_over:
	lw $s0, 0($sp)
	addiu $sp, $sp, 4
	jr $ra


  sort:
  ################save s registers
  addiu $sp, $sp, -24
  sw $s0, 0($sp)
  sw $s1, 4($sp)
  sw $s2, 8($sp)
  sw $s5, 12($sp)
  sw $a0, 16($sp)
  sw $a1, 20($sp)

  	li $s5, 0 #bool


  	loop_sort:
  	bnez $s5, loop_sort_over
  	li $s5, 1 #bool

  	li $s0, 1 #iterator

  		loop_sort:
  		addiu $t0, $s0, 1
  		bge $t0, $a1, loop_sort_over
  		#load i
  		#load i+1
  		li $s1, 0x10
  		mul $s1, $s1, $s0
  		addu $s1, $s1, $a0
  		addiu $s2, $s1, 0x10

  		#years
  		lh $t1, 12($s1)##S
  		lh $t2, 12($s2)##S

  		#check condition
  		ble $t1, $t2,	check_gt_over
  		## if true swap


  		addiu $sp, $sp, -40
  		sw $s0, 16($sp)
  		sw $s1, 20($sp)
  		sw $s2, 24($sp)
  		sw $a0, 28($sp)
  		sw $a1, 32($sp)
  		sw $ra, 36($sp)

  		move $a0, $s1
  		move $a1, $sp
  		li $a2, 0x10

  		jal memcpy
  		lw $s0, 16($sp)
  		lw $s1, 20($sp)
  		lw $s2, 24($sp)
  		lw $a0, 28($sp)
  		lw $a1, 32($sp)
  		lw $ra, 36($sp)

  		move $a0, $s2
  		move $a1, $s1
  		li $a2, 0x1

  		jal memcpy
  		lw $s0, 16($sp)
  		lw $s1, 20($sp)
  		lw $s2, 24($sp)
  		lw $a0, 28($sp)
  		lw $a1, 32($sp)
  		lw $ra, 36($sp)


  		move $a0, $sp
  		move $a1, $s2
  		li $a2, 0x1

  		jal memcpy
  		lw $s0, 16($sp)
  		lw $s1, 20($sp)
  		lw $s2, 24($sp)
  		lw $a0, 28($sp)
  		lw $a1, 32($sp)
  		lw $ra, 36($sp)
  		addiu $sp, $sp, 40

  		li $s5, 0
  		check_gt_odd_over:
  		#add 2
  		addiu $s0, $s0, 1
  		b loop_sort
  		loop_sort_over:


     jr $ra

# Part IV
transpose:
li $v0, -200
li $v1, -200

jr $ra

# Part VII
encrypt:
li $v0, -200
li $v1, -200

jr $ra

# Part VIII
lookup_char:
li $v0, -200
li $v1, -200

jr $ra

# Part IX


string_sort:




jr $ra

# Part X
decrypt:
li $v0, -200
li $v1, -200

jr $ra

#####################################################################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
##### ANY LINES BEGINNING .data WILL BE DELETED DURING GRADING! #####
#####################################################################
