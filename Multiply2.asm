# this project takes two inputs, a multiplicand and multiplier
# then it multiplies the two numbers by adding the multiplicand to the result.
# if the least significant bit of the multiplicand is 1
# then it shifts the multiplicand left and the multiplier right
# and the process is repeated until the multiplier is 0.

# the dilemma is it can only multiply up to 2 16-bit numbers
# it doesn't check for overflow, and if the number multiplies to have
# a one in the most significant bit it's funky becuase it prints as a two's complement negative.
# I couldn't figure out the syscall to print unsigned.
# this was really just to create a virtual version of the multiplication hardware for my own understanding .

.data
    input1: .asciiz "enter multiplicand:"
    input2: .asciiz "enter multiplier:"
    output1: .asciiz "equals: "

.text
main:
    li $v0, 4
    la $a0, input1	# print prompt
    syscall
    
    li $v0, 5
    syscall		# read first int
    move $s0, $v0	# s0 holds the multiplicand
    
    li $v0, 4
    la $a0, input2	# print prompt
    syscall
    
    li $v0, 5
    syscall		# read second int
    move $s1, $v0	# s1 holds multiplier
    
    #put parameters in $a registers
    move $a0, $s0	# a0 holds multiplicand
    move $a1, $s1	# a1 holds miltiplier
    add $v0,$zero, $zero	#initialize $v0 to 0
    jal multiply	# call multiply
    move $s2, $v0 	# retrieve the return value and store in $s2
    
    li $v0, 4			# print prompt
    la $a0, output1		
    syscall
    
    move $a0, $s2		# print result
    li $v0, 1			
    syscall
    
    li $v0, 10			#exit cleanly
    syscall
    
  #recursively adds and shifts bits to multiply two numbers
  #param -- $a0 = multiplicand -- $a1 = multiplier --
  multiply:
    maskBit:
    andi $t0, $a1, 1		# t0 holds the least significant bit of the multiplier
    
    shiftAndAdd:
    beq $t0, $zero, next	# if it doesn't need to be added skip adding
    add $v0, $v0, $a0		# v0 holds the result as it's built
    
    next:
    srl $a1, $a1, 1		# shift $a1(multiplier) right one bit
    sll $a0, $a0, 1		# a0 holds the multiplicand shifted left 1
    bne $a1, $zero, multiply	# if theres more non zero bits in the multiplier do the next multiply step again 
    jr $ra			#return control to the caller
    
    
    
    