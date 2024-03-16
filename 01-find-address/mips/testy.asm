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
    # Initialize variables
    li $v0, 0          # $v0 stores the current_plz value
    li $t0, 0          # $t0 stores the length of current_plz
    la $t1, buf_out    # Load the address of buf_out into $t1

    # Loop over each character in the string
loop:
    lb $t2, 0($a0)     # Load the next character into $t2
    beq $t2, $zero, end  # If the character is NULL (end of string), exit loop

    # Check if the character is numeric
    li $t3, '0'        # ASCII value of '0'
    li $t4, '9'        # ASCII value of '9'

# Print the characters corresponding to the ASCII values
    li $v0, 11          # Load the syscall number for printing a character (11)
    move $a0, $t3       # Move the ASCII value of '0' into $a0
    syscall             # Perform the syscall to print the character

    li $v0, 11          # Load the syscall number for printing a character (11)
    move $a0, $t4       # Move the ASCII value of '9' into $a0
    syscall             # Perform the syscall to print the character

    blt $t2, $t3, reset_current_plz  # If the character is before '0', reset current_plz
    bgt $t2, $t4, reset_current_plz  # If the character is after '9', reset current_plz

    # If the character is numeric, add it to current_plz
    sb $t2, 0($t1)     # Store the character in buf_out
    addi $t1, $t1, 1   # Move to the next character in buf_out
    addi $t0, $t0, 1   # Increment the length of current_plz

    # Check if current_plz has reached length 5
    li $t5, 5
    bne $t0, $t5, next_char  # If current_plz is not of length 5, continue to the next character

    # If current_plz is of length 5, parse it and return
    li $t6, 0           # Initialize result
    li $t7, 10          # Base for parsing decimal number

parse_loop:
    lb $t2, 0($t1)      # Load a character from buf_out
    beq $t2, $zero, parse_done  # If end of string, parsing is done

    sub $t2, $t2, '0'   # Convert character to numeric value
    mul $t6, $t6, $t7   # Multiply result by base
    add $t6, $t6, $t2   # Add current digit to result

    addi $t1, $t1, 1    # Move to next character in buf_out
    j parse_loop        # Continue parsing

parse_done:
    add $v0, $zero, $t6 # Move result to $v0
    j end               # Jump to end of function

next_char:
    addi $a0, $a0, 1    # Move to next character in string
    j loop              # Continue looping

reset_current_plz:
    li $v0, 0           # Reset current_plz to 0
    li $t0, 0           # Reset length of current_plz to 0
    la $t1, buf_out     # Reset pointer to buf_out
    j next_char         # Continue to next character

end:
    jr $ra              # Return
