
#	Begin Data Segment
	.data
	
array: 	.space	8000												#int[] array = new int[20];	
size:	.word 	0												#int size = 0;
comsp:	.asciiz ", "											#comma-space segment for array print out
		.align	2												#align data segment after each String
msg1:	.asciiz	"The elements sorted in ascending order are: "	#Message Output 1
		.align	2												#align data segment after each String

#	Begin Text Segment
	.text
	
MAIN:	la $s0, array											#Load address of array into memory
		la $s1, size											#Load address of size to memory
		lw $s1, 0($s1)											#size = 0
		addi $v0, $zero, 5										#Set syscall to read an int from the user
		syscall													#Get int "n"
		add $s1, $v0, $zero										#size = n;
		beq $s1, $zero, QUIT									#quit program if array size is 0.
		add $s2, $zero, $zero									#i = 0; 
		jal INIAR												#Initialize Array()
		add $a0, $s0, $zero										#Pass array[] address to argument 0 for SS
		add $a1, $s1, $zero										#Pass initialized size to argument 1 for SS
		add $s2, $zero $zero									#i = 0;
		jal SS													#SelectionSort(array, array.size)
		add $s2, $zero, $zero									#i = 0;
		addi $v0, $zero, 4										#Set syscall to print
		la $a0, msg1											#Pass message to print
		syscall													#Print
		jal PRINT												#PrintArray()
		j QUIT													#Exit Program
	
QUIT:	addi $v0, $zero, 10										# system call for exit
		syscall													# clean termination of program

#----------------------Void Initialize Array()-------------------------------------------------------------------------

INIAR:	slt $t0, $s2, $s1										#i < size
		beq $t0, $zero, INIEX									#exit when !(i < size)
		addi $v0, $zero, 5										#Set syscall to read an int from the user
		syscall													#Get new int "n"
		add $t1, $s2, $zero										#Set i to a temp variable
		sll $t1, $t1, 2											#i * 4 
		add $t1, $t1, $s0										#Address of array[i];
		sw $v0, ($t1)											#ar[i] = n;
		addi $s2, $s2, 1										#i++;
		j INIAR													#Loop
INIEX:
		jr $ra													#return
#--------------------End Initialize Array------------------------------------------------------------------------------

#-------------------Void Insertion Sort (int[] array, int len)---------------------------------------------------------	

SS:	addi $sp, $sp, -8											#Set stack pointer for 2 s registers
	sw $s0, 4($sp)												#Save array base pointer to stack
	sw $s1, 0($sp)												#Save array.size to stack
L1:		addi $t1, $a1, -1										#len - 1
		slt $t0, $s2, $t1										#(i < len-1)
		beq $t0, $zero, SSEND									#Return when !(i < len-1)
		add $s0, $s2, $zero										#minIndex = i;
		addi $s3, $s2, 1										#j = i+1
L2:			slt $t0, $s3, $a1 									#(j < len)
			beq $t0, $zero L1CON								#Finish Inner Loop when !(j < len)
			add $t1, $s0, $zero									#Set minIndex to a temp variable
			sll $t1, $t1, 2										#minIndex * 4
			add $t1, $t1, $a0									#Address of array[minIndex]
			lw $t1, 0($t1)										#array[minIndex]
			add $t2, $s3, $zero									#Set j to a temp variable
			sll $t2, $t2, 2										#j * 4
			add $t2, $t2, $a0									#Address of array[j]
			lw $t2, 0($t2)										#array[j]
			slt $t3, $t2, $t1									#(arr[j] < arr[minIndex])
			beq $t3, $zero, L2INC								#Jump to j++ when !(arr[j] < arr[minIndex])
			add $s0, $s3, $zero									#MinIndex = j when arr[j] < arr[minIndex])
L2INC:		addi $s3, $s3, 1									#j++;
				j L2											#Jump to inner Loop "L2"
L1CON:		beq $s0, $s2, L1INC									#Jump to increment step if minIndex == i
			add $t1, $s0, $zero									#Set minIndex to a temp variable
			sll $t1, $t1, 2										#minIndex * 4
			add $t1, $t1, $a0									#Address of array[minIndex]
			lw  $s1, 0($t1)										#tmp = arr[minIndex]
			add $t2, $s2, $zero									#Set i to a temp variable
			sll $t2, $t2, 2										#i * 4
			add $t2, $t2, $a0									#Address of array[i]
			lw $t3, 0($t2)										#tmp = arr[i];
			sw $t3, 0($t1)										#arr[minIndex] = arr[i];
			sw $s1, 0($t2)										#arr[i] = tmp;
L1INC:		addi $s2, $s2, 1									#i++;
			j L1												#Jump to outer Loop
SSEND:	lw $s0, 4($sp)											#Restore array[]
		lw $s1, 0($sp)											#Restore size
		addi $sp, $sp, 8										#Pop the Stack
		jr $ra													#Return;

#----------------------End SelectionSort-------------------------------------------------------------------------------

#-----------------------void PrintArray()------------------------------------------------------------------------------

PRINT:	add $t1, $s2, $zero 									#Set i to a temp variable
		sll $t1, $t1, 2											#i * 4 
		add $t1, $t1, $s0										#Address of array[i];
		lw $t2, 0($t1)											#Load int into t2
		addi $v0, $zero, 1										#Set syscall to print an int.
		la $a0, ($t2)											#Set int to be printed
		syscall													#Print int
		addi $v0, $zero, 4										#Set syscall to print
		la $a0, comsp											#Pass comma/space to print
		addi $t3, $s1, -1										#t3 = size - 1
		beq $t3, $s2 PEXIT										#if i == size - 1, exit.
		syscall													#Print ", "
		addi $s2, $s2, 1										#i++
		j PRINT													#Loop
PEXIT:	jr $ra													#return

#----------------------End PrintArray------------------------------------------------------------------------------------
#End Text Segment
