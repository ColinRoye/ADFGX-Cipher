# a0, matrix
# a1, num rows
# a2, num cols
# a3, key
# 0($sp) elm size

lw $s7, 0($sp) # elm size
li $s3, 0 # j = 0
loop:
bge $s3, $a2, loop_over # if j == numCols finish

li $s0, 0 # i = 0
sub_loop:
bge $s0, $a2, sub_loop_over # if i == numCols finish subloop
#load character i
# 		#load i
# 		#load i+1

  li $s2, 0x1
  move $s1, $a3 #i
  addu $s2, $s2, $a3 #i+1

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

  addiu $sp, $sp, -16
  sw $a0, 0($sp)
  sw $a1, 4($sp)
  sw $a2, 8($sp)
  sw $a3, 12($sp)

  move $a3, $s0 # col1
  addiu $sp, $sp, -4
  addiu $t0, $s0, 1
  sw $t0, 0($sp) #col2
  #swap matrix
  jal swap_matrix_columns
  addiu $sp, $sp, 4

  move $a0, $s4 # col1
  move $a1, $s5 # col2
  move $a2, $s7 # elm size
  #swap key
  jal swap_key

  lw $a0, 0($sp)
  lw $a1, 4($sp)
  lw $a2, 8($sp)
  lw $a3, 12($sp)
  addiu $sp, $sp, 16

skip_swap:

addiu $s0, $s0, 1 # i = i + 1
b sub_loop
sub_loop_over:
# incr j

addiu $s3, $s3, 1 # j = j + 1
b loop
loop_over:

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

  sb $t1, 0($a1)
  sb $t0, 0($a0)

  b s_elm_size_over
  s_is_word:
  lw $t0, 0($a0)
  lw $t1, 0($a1)

  sw $t1, 0($a1)
  sw $t0, 0($a0)

  s_elm_size_over:


  jr $ra
