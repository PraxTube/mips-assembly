.data

str_address: .asciiz "address: "
str_rueckgabewert: .asciiz "\nRueckgabewert: "
buf_out: .space 256

.text

.eqv SYS_PUTSTR 4
.eqv SYS_PUTCHAR 11
.eqv SYS_PUTINT 1
.eqv SYS_EXIT 10

main:
	# Eingabe address wird ausgegeben:
	li $v0, SYS_PUTSTR
	la $a0, str_address
	syscall

	li $v0, SYS_PUTSTR
	la $a0, test_address
	syscall
	
	li $v0, SYS_PUTSTR
	la $a0, str_rueckgabewert
	syscall

	move $v0, $zero
	# Aufruf der Funktion plz:
	la $a0, test_address
	jal plz
	
	# Rueckgabewert wird ausgegeben:
	move $a0, $v0
	li $v0, SYS_PUTINT
	syscall

	# Ende der Programmausfuehrung:
	li $v0, SYS_EXIT
	syscall

	#+ BITTE VERVOLLSTAENDIGEN: Persoenliche Angaben zur Hausaufgabe 
	#+ -------------------------------------------------------------

	# Vorname:
	# Nachname:
	# Matrikelnummer:
	
	#+ Loesungsabschnitt
	#+ -----------------

.data

test_address: .asciiz "TU Berlin, 10623 Berlin"

.text

plz:
  li $t0, 0

loop:
  # Loop over each character in the string
  lb $t1, 0($a0)     # Load the next character into $t1
  beq $t1, $zero, end  # If the character is NULL (end of string), exit loop

  # Check if the character is numeric
  blt $t1, 0x30, reset_current_plz  # If the character is before '0', reset current_plz
  bgt $t1, 0x39, reset_current_plz  # If the character is after '9', reset current_plz

  # Current char is numeric
  addi $t0, $t0, 1   # Increment the length of current_plz
  li $t4, 5
  sub $t4, $t4, $t0

  li $t2, 1            # Initialize $t2 to 1
  li $t3, 10           # Load 10 into $t3

power_loop:
  beqz $t4, power_done   # If n is zero, exit the loop
  mul $t2, $t2, $t3      # Multiply $t2 by 10
  addi $t4, $t4, -1      # Decrement n
  j power_loop            # Continue looping

power_done:
  # Convert ASCII number to numerical number
  addi $t1, $t1, -0x30
  mul $t1, $t1, $t2
  add $v0, $v0, $t1

  # Check if current_plz has reached length 5
  bne $t0, 5, next_char  # If current_plz is not of length 5, continue to the next character

parse:
  # If current_plz is of length 5, parse it and return
  j end               # Jump to end of function

next_char:
  addi $a0, $a0, 1    # Move to next character in string
  j loop              # Continue looping

reset_current_plz:
  li $v0, 0
  li $t0, 0           # Reset length of current_plz to 0
  j next_char         # Continue to next character

end:
  jr $ra              # Return
