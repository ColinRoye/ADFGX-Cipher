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


#jr ra?????
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
lw $t7, 0($sp) #a4
li $t0, 0
addiu $sp, $sp, -8
sw $a0, 0($sp)
sw $t7, 4($sp)
li $t0, 0
smc_loop:
lw $a0, 0($sp)

beq $t0 , $a1, smc_loop_over
mul $t1, $t0, $a2
addu $t1, $t1, $a0
# t1 i row

#a3 is j_1
addu $t9, $a3, $t1
#sp is j_2
lw $t3, 4($sp)
addu $t2, $t3, $t1

lb $t4, 0($t2)
lb $t5, 0($t9)


sb $t4, 0($t9)
sb $t5, 0($t2)

addiu $t0, $t0, 1

b smc_loop
smc_loop_over:
addiu $sp, $sp, 8

jr $ra

# Part V










key_sort_matrix:

# a0, matrix
# a1, num rows
# a2, num cols
# a3, key
# 0($sp) elm size
addiu $sp, $sp, -32
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)
sw $s5, 20($sp)
sw $s7, 24($sp)
sw $ra, 28($sp)


lw $s7, 32($sp) # elm size
li $s3, 0 # j = 0
loop:
bge $s3, $a2, loop_over # if j == numCols finish

li $s0, 0 # i = 0
sub_loop:
bge $s0, $a2, sub_loop_over # if i == numCols finish subloop
#load character i
# 		#load i
# 		#load i+1
	move $s1, $a3 #i
	#might need to multiply by 4
	mul $t0, $s7, $s0 # multiply for elm size
	addu $s1, $s1, $t0 # get address for char[i]
	addu $s2, $s1, $s7 # get address for char[i+1]

  move $s4, $s1 # address of char[i]
  move $s5, $s2 # address of char[i+1]

  li $t0, 1
  bne $s7, $t0, is_word
is_byte:


  lb $s1, 0($s1)
  lb $s2, 0($s2)
  b elm_size_over
is_word:
  lw $s1, 0($s1)
  lw $s2, 0($s2)

elm_size_over:
  #if char[i+1] = 0 sub loop over
  beqz $s2, sub_loop_over

  #swap character if needed to
  ble $s1, $s2, skip_swap

  addiu $sp, $sp, -20
  sw $a0, 0($sp)
  sw $a1, 4($sp)
  sw $a2, 8($sp)
  sw $a3, 12($sp)
	sw $ra, 16($sp)

  move $a3, $s0 # col1
  addiu $sp, $sp, -4
  addiu $t0, $s0, 1
  sw $t0, 0($sp) #col2
  #swap matrix
  jal swap_matrix_columns
  addiu $sp, $sp, 4
	#ra??
  move $a0, $s4 # col1
  move $a1, $s5 # col2
  move $a2, $s7 # elm size
  #swap key
  jal swap_key

  lw $a0, 0($sp)
  lw $a1, 4($sp)
  lw $a2, 8($sp)
  lw $a3, 12($sp)
	lw $ra, 16($sp)
  addiu $sp, $sp, 20

skip_swap:

addiu $s0, $s0, 1 # i = i + 1
b sub_loop
sub_loop_over:
# incr j

addiu $s3, $s3, 1 # j = j + 1
b loop
loop_over:



lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
lw $s5, 20($sp)
lw $s7, 24($sp)
lw $ra, 28($sp)
addiu $sp, $sp, 32

jr $ra


swap_key:
  #a0 adr1
  #a1 adr2
  #a2 elm size

  li $t0, 4
  beq $t0, $a2, s_is_word
  s_is_byte:
  lb $t0, 0($a0)
  lb $t1, 0($a1)

  sb $t1, 0($a0)
  sb $t0, 0($a1)

  b s_elm_size_over
  s_is_word:
  lw $t0, 0($a0)
  lw $t1, 0($a1)

  sw $t1, 0($a0)
  sw $t0, 0($a1)

  s_elm_size_over:


  jr $ra



# Part IV
transpose:
	#s0 = iterator
	#if iterator = num row
	li $s3, 0
	loop_tr:
	li $s0, 0
	beq $s3, $a3, loop_tr_over #num col
	sub_loop_tr:
	beq $s0, $a2, sub_loop_tr_over #num row
	mul $t0, $a3, $s0
	addu $t0, $t0, $a0
	addu $t0, $t0, $s3
	lb $t0, 0($t0)
	sb $t0, 0($a1)
	addiu $s0, $s0, 1

	addiu $a1, $a1, 1
	b sub_loop_tr
	sub_loop_tr_over:
	addiu $s3, $s3, 1

	b loop_tr
	loop_tr_over:



jr $ra

# Part VII
encrypt:
#allocate memory for map plain text

#map plain text for every elm in adfgvx_grid
addiu $sp, $sp, -32
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $a2, 8($sp)
sw $a3, 12($sp)
sw $ra, 16($sp)

li $a0, 56
li $v0, 9
syscall

li $t0, 0
li $t1, '*'
li $t3, 55
move $t4, $v0
loop_star:
addiu $t0, $t0, 1
beq $t0, $t3, loop_star_over
sb $t1, 0($t4)
addiu $t4, $t4, 1

b loop_star
loop_star_over:


sw $v0, 20($sp)

lw $a0, 0($sp)
move $a2, $v0
jal map_plaintext



# lw $a0, 20($sp)
# li $v0, 4
# syscall
# li $v0, 10
# syscall



lw $a0, 20($sp)
jal len
move $s1, $v0


lw $a0, 8($sp)
jal len
move $s2, $v0

lw $a0, 20($sp)
lw $a1, 12($sp)
div $s1, $s2
mflo $a2
mfhi $t0
beqz $t0, skip_add
addiu $a2, $a2, 1
skip_add:



move $a3, $s2

sw $a2, 24($sp)
sw $a3, 28($sp)

# jal transpose




# jal transpose
lw $a0, 20($sp)
lw $a1, 24($sp)
lw $a2, 28($sp)
lw $a3, 8($sp)
addiu $sp, $sp, -4
li $t0, 1
sw $t0, 0($sp)
jal key_sort_matrix
addiu $sp, $sp, 4

lw $a0, 20($sp)
lw $a1, 12($sp)
lw $a2, 24($sp)
lw $a3, 28($sp)


jal transpose


# lw $a0, 12($sp)
#
# lw $a2, 24($sp)
# lw $a3, 28($sp)
# #mul $t0, $a2, $a3
# #addu $a0, $a0, $t0
# li $t0, 0
# sb $t0, 0($a2)
lw $a1, 12($sp)
 lw $a2, 24($sp)
 lw $a3, 28($sp)
 mul $t0, $a2, $a3
 addu $a1, $a1, $t0
 li $t0, 0
 sb $t0, 0($a1)

lw $ra, 16($sp)
addiu $sp, $sp, 28



jr $ra

len:
li $v0, 0
li $t1, '*'
len_loop:
lb $t0, 0($a0)
beqz $t0, len_loop_over
beq $t0, $t1, len_loop_over
addiu $v0, $v0, 1
addiu $a0, $a0, 1
b len_loop
len_loop_over:
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
