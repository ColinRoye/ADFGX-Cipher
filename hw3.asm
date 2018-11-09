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
addiu $t0, $s0, 1
bge $t0, $a2, sub_loop_over # if i == numCols finish subloop
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
  beq $s0, $a2 sub_loop_over

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
	addiu $sp, $sp, -8
	sw $s0, 0($sp)
	sw $s3, 4($sp)
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
	#return vals s regs
	lw $s0, 0($sp)
	lw $s3, 4($sp)
	addiu $sp, $sp, 8

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
addiu $sp, $sp, -8
sw $s0, 0($sp)
sw $s1, 4($sp)

li $s0, 0
li $t0, 'A'
beq $a1, $t0, row_over
li $s0, 1
li $t0, 'D'
beq $a1, $t0, row_over
li $s0, 2
li $t0, 'F'
beq $a1, $t0, row_over
li $s0, 3
li $t0, 'G'
beq $a1, $t0, row_over
li $s0, 4
li $t0, 'V'
beq $a1, $t0, row_over
li $s0, 5
li $t0, 'X'
beq $a1, $t0, row_over
b char_err
row_over:


li $s1, 0
li $t0, 'A'
beq $a2, $t0, col_over
li $s1, 1
li $t0, 'D'
beq $a2, $t0, col_over
li $s1, 2
li $t0, 'F'
beq $a2, $t0, col_over
li $s1, 3
li $t0, 'G'
beq $a2, $t0, col_over
li $s1, 4
li $t0, 'V'
beq $a2, $t0, col_over
li $s1, 5
li $t0, 'X'
beq $a2, $t0, col_over
b char_err
col_over:
li $t0, 6
mul $t0, $t0, $s0
addu $t0, $t0, $s1
addu $t0, $t0, $a0

lb $v1, 0($t0)

b char_err_over
char_err:
li $v0, -1
li $v1, -1
char_err_over:

lw $s0, 0($sp)
lw $s1, 4($sp)
addiu $sp, $sp, 8


jr $ra



# Part IX


string_sort:

addiu $sp, $sp, -32
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)
sw $s5, 20($sp)
sw $s7, 24($sp)
sw $ra, 28($sp)



li $s3, 0 # j =a2
loop_str:
li $s0, 0 # i = 0

addu $t0, $s3, $a0
lb $t0 0($t0)
beqz $t0, loop_over_str
sub_loop_str:


	#might need to multiply by 4

	addu $s1, $a0, $s0 # get address for char[i]
	li $t0, 1
	addu $s2, $s1, $t0 # get address for char[i+1]


  lb $t0, 0($s1)
  lb $t1, 0($s2)

  #if char[i+1] = 0 sub loop over
  beqz $t1, sub_loop_over_str

  #swap character if needed to
  ble $t0, $t1, skip_swap_str

  addiu $sp, $sp, -20
  sw $a0, 0($sp)
  sw $a1, 4($sp)
  sw $a2, 8($sp)
  sw $a3, 12($sp)
	sw $ra, 16($sp)
	#ra??
  move $a0, $s1 # col1
  move $a1, $s2 # col2
	li $t0, 1
  move $a2, $t0 # elm size
  #swap key
  jal swap_key
  lw $a0, 0($sp)
  lw $a1, 4($sp)
  lw $a2, 8($sp)
  lw $a3, 12($sp)
	lw $ra, 16($sp)
  addiu $sp, $sp, 20

skip_swap_str:
addiu $s0, $s0, 1 # i = i + 1
b sub_loop_str
sub_loop_over_str:
# incr j
addiu $s3, $s3, 1 # j = j + 1
b loop_str
loop_over_str:



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



# Part X
decrypt:

move $t1, $a2
li $t0, 0
len_k_dc:
addu $t2, $t1, $t0
lb $t2, 0($t2)
beqz $t2, len_k_dc_over
addiu $t0, $t0, 1
b len_k_dc
len_k_dc_over:

move $a0, $t0
addiu $a0, $a0, 1
move $t5, $a0
li $v0, 9
syscall
move $a0, $t5

# move $t5, $a0
# li $v0, 9
# syscall
# move $s1, $v0 #arr 0-n


move $s3, $t0 #len
cpy_key:
addu $t1, $t0, $a2
addu $t2, $v0, $t0
lb $t3, 0($t1)
sb $t3, 0($t2)
blez $t0, cpy_key_over
addiu $t0, $t0, -1
b cpy_key
cpy_key_over:
move $s0, $v0 #unsrted

move $t5, $a0
li $t5, 4
mul $a0, $a0, $t5
li $v0, 9
syscall
move $s1, $v0 #arr 0-n

addiu $sp, $sp, -20
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $a2, 8($sp)
sw $a3, 12($sp)
sw $ra, 16($sp)
move $a0, $a2
jal string_sort




li $s5, 0
mk_arr:
lw $a0, 8($sp)
beq $s3, $s5, mk_arr_over
addu $a1, $s5, $a0
lb $a1, 0($a1) #a0
beqz $a1, mk_arr_over
move $a0, $s0
#addu $a0, $s0, $s5

# addiu $s5, $s5, 1
jal index_of
li $t1, 4
mul $t1, $t1, $s5
addu $t0, $s1, $t1
sw $v0, 0($t0)
addiu $s5, $s5, 1

b mk_arr
mk_arr_over:

lw $a0, 0($sp)
lw $a1, 4($sp)
lw $a2, 8($sp)
lw $a3, 12($sp)
addiu $sp, $sp, 20

#move  $a0, $a1

#a1 = arr of shit
#s0 = arr of int

move $t1, $a1
li $t0, 0
len_arr_dc:
addu $t2, $t1, $t0
lb $t2, 0($t2)
beqz $t2, len_arr_dc_over
addiu $t0, $t0, 1
b len_arr_dc
len_arr_dc_over:


li $v0, 9
move $a0, $t0
addiu $a0, $a0, 1
syscall
move $a0, $a1

move $s2, $v0
move $a1, $v0

move $a2, $s3

div $t0, $s3
mflo $a3


addiu $sp, $sp, -8
sw $ra, 0($sp)
sw $a3, 4($sp)
jal transpose
lw $ra, 0($sp)
lw $a3, 4($sp)
addiu $sp, $sp, 8

move $a0, $s2
move $a2, $s3
move $a1, $a3
# div $t0, $s3
# mflo $a2

move $a3, $s1

addiu $sp, $sp, -4
li $t0, 4 #fix
sw $t0, 0($sp)
jal key_sort_matrix
addiu $sp, $sp, 4

move $a0, $s2
li $v0, 4
syscall
li $v0, 10
syscall



#allocate memory for keyword
#sort heap keyword
#allocate memory for

#allocate memory arr the length of the key




jr $ra


index_of:
################save s registers
	li $t1, 0
	loop_ind_of_2:
	lbu $t0, 0($a0)
	beq $t0, $a1, loop_ind_of_over_2


	addiu $t1, $t1, 1
	addiu $a0, $a0, 1
	b loop_ind_of_2
	loop_ind_of_over_2:
	move $v0, $t1

	################save s registers

	jr $ra

#####################################################################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
##### ANY LINES BEGINNING .data WILL BE DELETED DURING GRADING! #####
#####################################################################
