#####################################################################
#
# CSC258H5S Winter 2020 Assembly Programming Project
# University of Toronto Mississauga
#
# Group members:
# - Student 1: Christopher Indris, 1004880159
# - Student 2 : Sukhman Vig, 1005256599
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8					     
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestone is reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 1/2/3/4/5 (choose the one the applies)
#
# Which approved additional features have been implemented?
# (See the assignment handout for the list of additional features)
# 1. (fill in the feature, if any)
# 2. (fill in the feature, if any)
# 3. (fill in the feature, if any)
# ... (add more if necessary)
#
# Any additional information that the TA needs to know:
# - (write here, if any)
#



#####################################################################


# Demo for painting
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8					     
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
.data
	displayAddress:	.word	0x10008000
	#Sky: #33ccff (blue)
	#Bird: #ff3300 (red)
	#Pipe: #ff9933 (orange)
	#Grass/Ground: #339933 (green)
.text
main:
	lw $t0, displayAddress	# $t0 stores the base address for display
	li $t1, 0xff3300	# $t1 stores the red colour code
	li $t2, 0x339933	# $t2 stores the green colour code
	li $t3, 0x33ccff	# $t3 stores the blue colour code
	li $t4, 0xff9933	# $t4 stores the orange colour code
	
  	
	
	# for(i = 3712; i < 4096; i += 4):
	# 	colour i green 
	
	# sky
	add $s1, $t0, $zero
	addi $s2, $t0, 3712
STARTSKY:
	beq $s1, $s2, ENDSKY # if $s1 has reached $s2, leave the loop.
	sw $t3, 0($s1) # store $t2 (green) at $s1 ($s1 + 0 = $s1)
	addi $s1, $s1, 4 # $s1 = $s1 + 4  
	j STARTSKY
ENDSKY:

	# grass
	addi $s1, $t0, 3712
	addi $s2, $t0, 4096
STARTGRASS: 	
	beq $s1, $s2, ENDGRASS # if $s1 has reached $s2, leave the loop.
	sw $t2, 0($s1) # store $t2 (green) at $s1 ($s1 + 0 = $s1)
	addi $s1, $s1, 4 # $s1 = $s1 + 4  
	j STARTGRASS
ENDGRASS:

	# orange square
	li $v0, 32 # for now, we only want sleep (syscall, $v0 = 32)
	li $a0, 1000 # $a0 = 1000- sysall will sleep for 1000 milliseconds = 1 sec each time.
	li $s7, 128 # constant value of 128
	
	addi $s1, $t0, 124
	addi $s2, $t0, 0
	
	addi $s3, $0, 0 # 0
	addi $s4, $0, 3712 # 3840
STARTSQUARE:
	beq $s1, $s2, ENDSQUARE
	#pipe
	addi $s1, $s1, -4
	addi $s3, $zero, 0
	addi $s6, $zero, 0
ORG:
	beq $s3, $s4, ENDORG
	add $s6, $s1, $s3
	sw $t4, -4($s6)
	sw $t4, 0($s6) # 0 + $s6 = 0 + $s3 + $s1
	sw $t3, 4($s6) # 4 + $s6
	addi $s3, $s3, 128
	j ORG
ENDORG:
	syscall # after the pipe is painted, we pause for 1 second.
	j STARTSQUARE
ENDSQUARE:

Exit:
	li $v0, 10 # terminate the program gracefully
	syscall