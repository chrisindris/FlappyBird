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
	
	current: .space 8
	#pipeArray: .word  1, 2, 3	# pipeArray = [1, 2, 3]	(python)
	#pipeArray: .space 4		# Array pipeArray[1] (Java)
	#Sky: #33ccff (blue)
	#Bird: #771b80 (purple)
	#Pipe: #ff9933 (orange)
	#Grass/Ground: #339933 (green)
.text

main: # main method

	jal initialize # jump to initialize
	
	jal pipeCreator
SQUARES:
	li $v0, 32 # for now, we only want sleep (syscall, $v0 = 32)
	li $a0, 1000 # $a0 = 1000- sysall will sleep for 1000 milliseconds = 1 sec each time.
	
	move $t1, $0	# starts our game counter at 0.
	addi $sp, $sp, -4
	sw $0, 0($sp)
	
	addi $s1, $t0, 124
	addi $s2, $t0, 0
	
	addi $s3, $0, 0 # 0
	addi $s4, $0, 3712 # 3840
	
	
	
	li $v0, 42
	li $a1, 8
	syscall
	sll $a0, $a0, 2
	lw $s5, function2array($a0)
	andi $t9, $s5, 255              	 # start
	andi $s5, $s5, 65280       
	sra $s5, $s5, 8				# gap
	add $s5, $s5, $t9 			# end
	sll $t9, $t9, 7				# multiplies by 128, to match with the $s3 value
	sll $s5, $s5, 7
	
	li $v0, 42
	li $a1, 8
	syscall
	sll $a0, $a0, 2
	lw $a2, function2array($a0)
	andi $a3, $a2, 255              	 # start
	andi $a2, $a2, 65280       
	sra $a2, $a2, 8				# gap
	add $a2, $a2, $a3			# end
	sll $a3, $a3, 7				# multiplies by 128, to match with the $s3 value
	sll $a2, $a2, 7

			
STARTSQUARE:

	jal trash
	
	# $t1 as game counter
	# push $t1 = gc onto the stack
	addi $sp, $sp, -4
	sw $t1, 0($sp)
	# load it with the bird colour 
	li $t1, 0x771b80	# $t1 stores the purple colour code (bird)
	
	lw $s7, 0xffff0000($0)  # Load $s7 with value found in memory location 0xffff0000 = 0xffff0000 + 0. 
	beq $s7, $0, birdDown	# if $s7 is 0, no button was pressed at all and we go down.
	lw $s7, 0xffff0004($0)	# Load $s7 with value found in memory location 0xffff0004 = 0xffff0004 + 0
	subi $s7, $s7, 102	# If $s7 = 102 (the ascii code for 'f'), then $s7 -= 102 = 0.
	bne $s7, $0, birdDown	# If $s7 - 102 != 0, then $s7 != 102 (some non-'f' key is pressed). No flap up here!
	jal keyboardbirdUP	
	birdDown:
	jal birdpaintDOWN
	FlapDone:
	# pop gc off of stack and into $t1 again.
	lw $t1, 0($sp)
	addi $sp, $sp, 4
	
	
	# new loop cycle
	bne $s1, $s2, continue
	
	addi $t1, $t1, 1
	
	li $s1, 4
	l_two:
	bne $t1, $s1, l_three
		jal pipeCreator
		j l_done
	l_three:
	li $s1, 8
	bne $t1, $s1, l_done
		jal pipeCreator
		j l_done
	l_done:
	
	
	addi $s1, $t0, 124
	
	
	# day/night
	jal sky
	
	li $v0, 42
	li $a1, 8
	syscall
	sll $a0, $a0, 2
	lw $s5, function2array($a0)
	andi $t9, $s5, 255              	 # start
	andi $s5, $s5, 65280       
	sra $s5, $s5, 8				# gap
	add $s5, $s5, $t9 			# end
	sll $t9, $t9, 7				# multiplies by 128, to match with the $s3 value
	sll $s5, $s5, 7
	
	li $v0, 42
	li $a1, 8
	syscall
	sll $a0, $a0, 2
	lw $a2, function2array($a0)
	andi $a3, $a2, 255              	 # start
	andi $a2, $a2, 65280       
	sra $a2, $a2, 8				# gap
	add $a2, $a2, $a3			# end
	sll $a3, $a3, 7				# multiplies by 128, to match with the $s3 value
	sll $a2, $a2, 7
	
	continue: 
	
	
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
	
	# build a single square given a colour.
	blt $s3, $t9, orang1
	bgt $s3, $s5, orang1
		sw $t3, 0($s6)	# $s6 + 0 = $s6
		sw $t3, 4($s6)
		j odone1
	orang1:
		sw $t4, 0($s6)
		sw $t3, 4($s6)
	odone1:
	
	blt $s3, $a3, orang2
	bgt $s3, $a2, orang2
		subi $s1, $s1, 36
		ble $s1, $t0, past1
		sw $t3, -40($s6)
		sw $t3, -36($s6)
		past1:
		addi $s1, $s1, 36
		j odone2
	orang2:
		subi $s1, $s1, 36
		ble $s1, $t0, past2
		sw $t4, -40($s6)
		sw $t3, -36($s6)
		past2:
		addi $s1, $s1, 36
	odone2:
	
	li $s4, 3712
	addi $s3, $s3, 128
	j ORG
ENDORG:
	# pause
	li $v0, 32
	beq $t1, 4, p2
	beq $t1, 8, p3
		li $a0, 300	# pause for 0.3 seconds
		j pdone
	p2:
		li $a0, 150	# pause for 0.15 seconds
		j pdone
	p3:
		li $a0, 50	# pause for 0.05 seconds
		j pdone
	pdone:
	syscall 
	j STARTSQUARE
ENDSQUARE:

initialize:	
	lw $t0, displayAddress	# $t0 stores the base address for display
	li $t1, 0x771b80	# $t1 stores the purple colour code (bird)
	li $t2, 0x339933	# $t2 stores the green colour code (grass)
	li $t3, 0x33ccff	# $t3 stores the blue colour code (sky)
	li $t4, 0xff9933	# $t4 stores the orange colour code (pipe)
	
	li $t6, 6
	li $t7, 7
	
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
	
	jr $ra	
ENDinitialize:

# bird up
keyboardbirdUP:	
	# colour current locations blue
	# $t8 += 128 
	# colour new locations purple
	add $t0, $t0, $t8 # brings us to the old location of the bird ($t0 + $t8)
	
	# check for grass collision
	lw $v0, 256($t0)
	beq $v0, $t2, death
	# check for pipe collision in front
	lw $v0, 8($t0)
	beq $v0, $t4, death
	# check for pipe collision above
	lw $v0, -256($t0)
	beq $v0, $t4, death
	lw $v0, -124($t0)
	beq $v0, $t4, death
	# check for pipe collision below
	lw $v0, 256($t0)
	beq $v0, $t4, death
	lw $v0, 132($t0)
	beq $v0, $t4, death
		
	sw $t3, -128($t0)
	sw $t3, 0($t0)
	sw $t3, 4($t0)
	sw $t3, 128($t0)
	
	sub $t0, $t0, $t8	# restore $t0
	
	addi $t8, $t8, -256
	
	add $t0, $t0, $t8 # brings us to the old location of the bird ($t0 + $t8)
	
	
	sw $t1, -128($t0)
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 128($t0)
	
	sub $t0, $t0, $t8	# restore $t0
	
	#sw $t3, 0($s1)	
ENDkeyboardbirdUP: jr $ra

# DEATH Function: This function can be called when the bird crashes into something.
# Repaint the entire screen black, sad face, syscall to exit ($v0 = 10), do not return to game loop.
death:
	
	sub $t0, $t0, $t8	# back to the proper start
	
	addi $t9, $t0, 4096	# $t9 = $t0 + 4096
	deathscreenloop: 
		addi $t9, $t9, -4
		sw $0, 0($t9)
		bne $t9, $t0, deathscreenloop
	deathscreenloopdone:
	
	# head
	li $t1, 0x9c1006
	
	addi $s1, $t0, 352
	addi $s0, $t0, 288
	dloop1:
		addi $s1, $s1, -4
		sw $t1, 0($s1)
		sw $t1, 1920($s1)
		bne $s1, $s0, dloop1
		
	addi $s1, $t0, 2208
	addi $s0, $t0, 288
	dloop2:
		addi $s1, $s1, -128
		sw $t1, 0($s1)
		sw $t1, 60($s1)
		bne $s1, $s0, dloop2
		
	# face
	addi $s1, $t0, 816
	sw $t1, 0($s1)
	sw $t1, -128($s1)
	sw $t1, 128($s1)
	sw $t1, -4($s1)
	sw $t1, 4($s1)
	
	addi $s1, $t0, 844
	sw $t1, 0($s1)
	sw $t1, -128($s1)
	sw $t1, 128($s1)
	sw $t1, -4($s1)
	sw $t1, 4($s1)
	
	sw $t1, 1468($t0)
	sw $t1, 1472($t0)
	
	sw $t1, 1588($t0)
	sw $t1, 1592($t0)
	sw $t1, 1596($t0)
	sw $t1, 1600($t0)
	sw $t1, 1604($t0)
	sw $t1, 1608($t0)
	
	sw $t1, 1712($t0)
	sw $t1, 1716($t0)
	sw $t1, 1836($t0)
	sw $t1, 1840($t0)
	
	sw $t1, 1736($t0)
	sw $t1, 1740($t0)
	sw $t1, 1868($t0)
	sw $t1, 1872($t0)
	
	
	# ded
	addi $s1, $t0, 2988
	sw $t1, -132($s1)
	sw $t1, -128($s1)
	sw $t1, -124($s1)
	sw $t1, -4($s1)
	sw $t1, 4($s1)
	sw $t1, 124($s1)
	sw $t1, 128($s1)
	sw $t1, 132($s1)
	sw $t1, -252($s1)
	sw $t1, -380($s1)
	
	addi $s1, $t0, 3020
	sw $t1, -132($s1)
	sw $t1, -128($s1)
	sw $t1, -124($s1)
	sw $t1, -4($s1)
	sw $t1, 4($s1)
	sw $t1, 124($s1)
	sw $t1, 128($s1)
	sw $t1, 132($s1)
	sw $t1, -252($s1)
	sw $t1, -380($s1)
	
	sw $t1, 2616($t0)
	sw $t1, 2620($t0)
	sw $t1, 2624($t0)
	sw $t1, 2744($t0)
	sw $t1, 2872($t0)
	sw $t1, 2876($t0)
	sw $t1, 2880($t0)
	sw $t1, 3000($t0)
	sw $t1, 3128($t0)
	sw $t1, 3132($t0)
	sw $t1, 3136($t0)
	
	# goodbye
	li $v0, 10
	syscall
	
ENDdeath:

# TRASH Function: This function will check 
# May use: $t9 (because $t9 is the last storing function)
trash:
	addi $v0, $t0, 3712
	tloop:
	subi $v0, $v0, 128
	sw $t3, 0($v0)
	bne $v0, $t0, tloop 
ENDtrash: jr $ra

# SKY function: change the sky colour, and paint everything.
sky:
	# cycle from day, to dusk, to black, to morning
	li $v0, 0x33ccff	# branch if it's day
	beq $t3, $v0, day
	
	li $v0, 0x276276	# branch if it's dusk
	beq $t3, $v0, dusk
	
	beq $t3, $zero, night	# branch if it's night
	
	li $v0, 0x276275	# branch if it's morning
	beq $t3, $v0, morn
	
	day:
		li $t3, 0x276276	# day -> dusk
		j skydone
	dusk:
		move $t3, $zero		# dusk -> night
		j skydone
	night:
		li $t3, 0x276275	# night -> morn
		j skydone
	morn:			
		li $t3, 0x33ccff	# morn -> day
		j skydone	
	skydone:
	
	addi $v0, $t0, 3712
	skyloop: 
		addi $v0, $v0, -4
		lw $v1, 0($v0)
		beq $v1, $t1, nonsky
		beq $v1, $t2, nonsky
		beq $v1, $t4, nonsky
		sw $t3, 0($v0)
		nonsky:
		bne $v0, $t0, skyloop
	skyloopdone:

ENDsky: jr $ra

# BIRDPAINT Function:
birdpaintDOWN:
	# colour current locations blue
	# $t8 += 128 
	# colour new locations purple
	add $t0, $t0, $t8 # brings us to the old location of the bird ($t0 + $t8)
	
	# check for grass collision
	lw $v0, 256($t0)
	beq $v0, $t2, death
	# check for pipe collision in front
	lw $v0, 8($t0)
	beq $v0, $t4, death
	# check for pipe collision above
	lw $v0, -256($t0)
	beq $v0, $t4, death
	lw $v0, -124($t0)
	beq $v0, $t4, death
	# check for pipe collision below
	lw $v0, 256($t0)
	beq $v0, $t4, death
	lw $v0, 132($t0)
	beq $v0, $t4, death
	
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
	
	#sw $t3, 0($s1)
ENDbirdpaintDOWN: jr $ra

# check around the bird for collisions.
birddeathcheck:

	# check for grass collision
	lw $v0, 256($t0)
	beq $v0, $t2, death
	
	# check for pipe collision in front
	lw $v0, 8($t0)
	beq $v0, $t4, death
	# check for pipe collision above
	lw $v0, -256($t0)
	beq $v0, $t4, death
	
	lw $v0, -124($t0)
	beq $v0, $t4, death
	
	# check for pipe collision below
	lw $v0, 256($t0)
	beq $v0, $t4, death
	
	lw $v0, 132($t0)
	beq $v0, $t4, death
	
ENDbirddeathcheck:

# TODO: Paint a new pipe on the rightmost column of the screen (for now, we will make pipes one unit wide)
# Add "128" to the array (starting location; the conveyer belt will make this smaller as the pipes move)
pipeCreator:
# Function1 (default pipe thickness, min gap size, max gap size) (Each of the 3 levels sets these values)
	
	# if $t4 = orange 
	# 	make $t4 yellow #e3d61b
	# elif $t4 = yellow
	# 	make $t4 pink #fa07de
	
	colourchange:
	beq $t4, 0xff9933, makeyellow
	beq $t4, 0xe3d61b, makepink
	makeyellow:
		li $t4, 0xe3d61b
		j colourdone
	makepink:
		li $t4, 0xfa07de
		j colourdone
	colourdone:
		
		
	li $v1, 32
	
	subi $t7, $t7, 1	# precondition: $t7 = maxGap was defined in Initialize function to at least 6		
	subi $t6, $t6, 1	# precondition: $t6 = minGap was defined in Intialize function to at least 6
	
	pcloop:
	subi $v1, $v1, 4
	
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
	
	thickness_loop:
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
	
	bne $v1, $0, thickness_loop
	thickness_loop_end:
	
	
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

ENDpipeCreator: jr $ra

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
