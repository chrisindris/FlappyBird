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
	pipeLocationArray: .space 8		# 2 pipes on screen
	pipeGapSizeThinknessArray: .space 32	# 8 pipes to choose from
	
	function1array: .space 32
	function2array: .space 32
	#pipeArray: .word  1, 2, 3	# pipeArray = [1, 2, 3]	(python)
	#pipeArray: .space 4		# Array pipeArray[1] (Java)
	#Sky: #33ccff (blue)
	#Bird: #771b80 (purple)
	#Pipe: #ff9933 (orange)
	#Grass/Ground: #339933 (green)
.text

main: # main method

	j initialize # jump to initialize
	
SQUARES:
	li $v0, 32 # for now, we only want sleep (syscall, $v0 = 32)
	li $a0, 1000 # $a0 = 1000- sysall will sleep for 1000 milliseconds = 1 sec each time.
	
	addi $s1, $t0, 124
	addi $s2, $t0, -4
	
	addi $s3, $0, 0 # 0
	addi $s4, $0, 3712 # 3840
		
STARTSQUARE:

	j trash
	PAUSE:
	
	lw $s7, 0xffff0000($0)  # Load $s7 with value found in memory location 0xffff0000 = 0xffff0000 + 0. 
	beq $s7, $0, birdDown	# if $s7 is 0, no button was pressed at all and we go down.
	lw $s7, 0xffff0004($0)	# Load $s7 with value found in memory location 0xffff0004 = 0xffff0004 + 0
	subi $s7, $s7, 102	# If $s7 = 102 (the ascii code for 'f'), then $s7 -= 102 = 0.
	bne $s7, $0, birdDown	# If $s7 - 102 != 0, then $s7 != 102 (some non-'f' key is pressed). No flap up here!
	j keyboardbirdUP	
	birdDown:
	j birdpaintDOWN
	FlapDone:
	
	beq $s1, $s2, Exit
	#pipe
	addi $s1, $s1, -4
	addi $s3, $zero, 0
	addi $s6, $zero, 0
ORG:
	#go through function2array that has 8 pipes in it and randomly print them to the screen for one 
	#iteration making sure that all the 8 pipes come on the screen in one iteration
	# for the second iteration have the 8 pipes randomly print to the screen but in a different random ordering then iteration 1,
	# again all 8 pipes get printed to the screen
	#depending on how many iterations we want for level 1 of the 8 pipes the above process continues
	#to be done in the form of a form loop because we will have a set number of iterations
	
	
	
	
	
	beq $s3, $s4, ENDORG
	add $s6, $s1, $s3
	# sw $t4, -4($s6)
	beq $s1, $s2, skip
	sw $t4, 0($s6) # 0 + $s6 = 0 + $s3 + $s1
	skip:
	sw $t3, 4($s6) # 4 + $s6
	addi $s3, $s3, 128
	j ORG
ENDORG:
	
	syscall # after the pipe is painted, we pause for 1 second.
	j STARTSQUARE
ENDSQUARE:

initialize:	
	lw $t0, displayAddress	# $t0 stores the base address for display
	li $t1, 0x771b80	# $t1 stores the purple colour code (bird)
	li $t2, 0x339933	# $t2 stores the green colour code (grass)
	li $t3, 0x33ccff	# $t3 stores the blue colour code (sky)
	li $t4, 0xff9933	# $t4 stores the orange colour code (pipe)
	
  		# Board Setup: Paint Sky and Grass
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
	
	# Bird
	sw $t1, 1032($t0)
	sw $t1, 1160($t0)
	sw $t1, 1288($t0)
	sw $t1, 1164($t0)
	li $t8, 1160 
	
	j SQUARES	
ENDinitialize:

# bird up
keyboardbirdUP:	
	# colour current locations blue
	# $t8 += 128 
	# colour new locations purple
	add $t0, $t0, $t8 # brings us to the old location of the bird ($t0 + $t8)
	
	sw $t3, -128($t0)
	sw $t3, 0($t0)
	sw $t3, 4($t0)
	sw $t3, 128($t0)
	
	sub $t0, $t0, $t8	# restore $t0
	
	addi $t8, $t8, -128
	
	add $t0, $t0, $t8 # brings us to the old location of the bird ($t0 + $t8)
	
	sw $t1, -128($t0)
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 128($t0)
	
	sub $t0, $t0, $t8	# restore $t0
	j FlapDone
	#sw $t3, 0($s1)	
ENDkeyboardbirdUP:

# TRASH Function: This function will check 
# May use: $t9 (because $t9 is the last storing function)
trash:
	lw $t9, 0($t0) 					# $t9 stores the colour at the upper left hand corner of the screen.
	
	trash_IF: 					# check if upper left hand corner is sky blue.
		beq $t9, $t3, trash_DONE			# if the upper left corner is sky-blue, no pipe (no work needed)
		
	trash_ELSE: 					# else, the upper left hand corner is not blue (a pipe is here)
		addi $s3, $0, 0 			# 0 - this will count up to 3840, 128 at a time.
		addi $s4, $0, 3712			# 3712
		
		trash_WHILE:				# While loop: change all sqares here to blue (erase the pipe)
			beq $s3, $s4, trash_DONE	# if $s3 has reached $s4, work is done.
			add $t9, $t0, $s3		# otherwise, $t9 = $0 + $s3 (this is $s3($t0), the memory location.
			sw $t3, 0($t9)			# we make this square blue. (we progress down the column like this)
			addi $s3, $s3, 128		# $s3 += 128, to find the next pipe below.
			j trash_WHILE			# jump up again (we may continue the loop; so, we check at the top.)
							
	trash_DONE:
		addi $s3, $0, 0				# set $s3 back to 0.
		j PAUSE				# exit function, return to next task.
ENDtrash:

# BIRDPAINT Function:
birdpaintDOWN:
	# colour current locations blue
	# $t8 += 128 
	# colour new locations purple
	add $t0, $t0, $t8 # brings us to the old location of the bird ($t0 + $t8)
	
	sw $t3, -128($t0)
	sw $t3, 0($t0)
	sw $t3, 4($t0)
	sw $t3, 128($t0)
	
	sub $t0, $t0, $t8	# restore $t0
	
	addi $t8, $t8, 128
	
	add $t0, $t0, $t8 # brings us to the old location of the bird ($t0 + $t8)
	
	sw $t1, -128($t0)
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 128($t0)
	
	sub $t0, $t0, $t8	# restore $t0
	j FlapDone
	#sw $t3, 0($s1)
ENDbirdpaintDOWN:

# TODO: Paint a new pipe on the rightmost column of the screen (for now, we will make pipes one unit wide)
# Add "128" to the array (starting location; the conveyer belt will make this smaller as the pipes move)
pipeCreator:
# Function1 (default pipe thickness, min gap size, max gap size) (Each of the 3 levels sets these values)
	li $v1, 32
	
	pcloop:
	subi $v1, $v1, 4
	subi $t7, $t7, 1	# precondition: $t7 = maxGap was defined in Initialize function to at least 6		
	subi $t6, $t6, 1	# precondition: $t6 = minGap was defined in Intialize function to at least 6
	
	# syscall
	# We want a number in this range: [minGap, maxGap] (inclusive)
	# However, random number generation gives us a result in range [0, $a1).
	# At the beginning, $t6 = minGap and $t7 = maxGap
	# We can say that [minGap, maxGap] is the same as [minGap - minGap, maxGap - minGap] + minGap = [0, max - min] + min
	# = [0, max - min + 1) + min 
	# so we want $a1 = max - min + 1
	# our random in range [0, max - min + 1) is stored in $a0
	# We do $t7 += $t6 to cancel out the original subtraction
	# add $t9, $a0, $t6
	li $v0, 42		# trapcode for random integer in range 0 <= output < $a1
	sub $t7, $t7, $t6	
	move $a1, $t7
	addi $a1, $a1, 1
	syscall
	add $t7, $t7, $t6
	add $t9, $a0, $t6
	
	li $v0, 42
	li $a1, 29		# accounts for the +1 (exclusion)
	sub $a1, $a1, $t9	# $a1 = 29 - gap
	syscall
	addi $a0, $a0, 1	# the answer + 1 = $a0 + 1 gives us the range we want
	
	# now, we store our pipe
	# thickness = 1
	li $s5, 1 # $s5 = 1
	sll $s5, $s5, 16	# $s5 = 00000000 00000001 00000000 00000000 
	
	sll $t9, $t9, 8
	add $s5, $s5, $t9	# $s5 = 00000000 00000001 [  $t9  ] 00000000 
	
	add $s5, $s5, $a0	# $s5 = 00000000 00000001 [  $t9  ] [  $a0  ] 
	
	sw $s5, function1array($v1)
	
	bne $v1, $0, pcloop
	pcloop_end:
	
	
	#Fucntion2 (pick a number from 1-8, thinkness from 1-4)
	li $v1, 32
	thinkness:
	subi $v1, $v1, 4
	
	li $v0, 42
	li $a1, 4
	syscall			# gives you randint in [0, 3] = [0, 4)
	move $t9, $a0		# gives you randint in [0, 3] 
	
	li $v0, 42
	li $a1, 8
	syscall			# gives you randint in [0, 8) = [0, 7]
	
	# now, we store our pipe
	# thickness = $t9
	# $a0 gives us which pipe in the first array we want to take from
	
	sll $t9, $t9, 16		
	
	add $a0, $a0, $a0
	add $a0, $a0, $a0 		# now, we have 4 * $a0
	
	lw $s5, function1array($a0)	#   $s5 = [0][1][gap][start]
	add $s5, $s5, $t9		# + $t9 = [0][thickness - 1][0][0]
	sw $s5, function2array($v1)     #       = [0][thickness][gap][start]
	
	
	
	#for(i = 8, i != 0, i--){ # loop 8 times
		#gap = randomNumInRange(minGap, maxGap)
		#startOfHole = randomNumInRange(1, 29 - gap)
		#pipeList[i - 1] = new Pipe(thickness = 1, gap, startOfHole) # store in the array
	#}
	#return Fucntion1Array
#Fucntion2 (pick a number from 1-8, thinkness from 1-4)
	#for(i = 8, i != 0, i--){
		#thickness = randomNumInRange(1, 4)
		#baseArray = randomNumInRange(1, 8)
		#function2array[i-1] = new Pipe(THICKNESS = thickness, baseArray = function1Array[baseArray - 1])
	#}
# Final pipe array  ( thick pipes from fucntion2, orginal pipes from function1)
#pick randomly from Final pipe array and put on screen
	#choice = randomNumInRange(0, 7) # 8 choices
	#paint function2array[choice] on screen by painting the appropriate base array "thickness" times.
	
	#00000000 00000000 00000000 00000000  	5-bit binary: biggest number is 11111 = 31. 
	#00000000 TTTTTTTT GGGGGGGG SSSSSSSS
	

ENDpipeCreator:

FinalPipePainter:
	

End_FinalPipePainter:

# TODO: Conveyer Belt function (move the pipes from right to left)
# Algorithm:
conveyerBelt:
	

ENDconveyerBelt:

# TODO: Level Creator Function
# Generate 8 pipes (hole starting position, hole width), and set a pipe width for the level.
#



level:

ENDlevel:	
# EXIT Function: used to terminate.
Exit:
	li $v0, 10 # terminate the program gracefully
	syscall
