	#+ BITTE NICHT MODIFIZIEREN: Vorgabeabschnitt
	#+ ------------------------------------------

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
  move $s0, $a0         # Save input string in $s0
  move $s1, $zero       # Initialize the output count $s1 to 0
  move $t0, $zero       # Initialize the current plz length to 0


loop:
  # (main loop) Loop over each character in the string
  lb $t1, 0($s0)        # Load the next character into $t1
  beq $t1, $zero, end   # If the character is NULL (end of string), exit loop

  # Check if the character is numeric
  blt $t1, 0x30, reset_current_plz  # If the character is before '0', reset current_plz
  bgt $t1, 0x39, reset_current_plz  # If the character is after '9', reset current_plz

  # Current char is numeric
  addi $t0, $t0, 1      # Increment the length of current_plz
  # Instead of storing the current plz as a string we instead
  # add each number to the output variable.
  # To do this we need to multiply each digit by 10^n, where n
  # depends on the current length of the plz.
  # This is obviously not a very performant way to handle it,
  # but it's good enough for this simple case
  li $t4, 5             # Set up exponent
  sub $t4, $t4, $t0     # Subtract length of current plz of exponent

  li $t2, 1             # Initialize the multiplier
  li $t3, 10


power_loop:
  beqz $t4, power_done  # If n (exponent) is zero, exit the loop
  mul $t2, $t2, $t3     # Multiply the multiplier by 10
  addi $t4, $t4, -1     # Decrement n
  j power_loop

power_done:
  addi $t1, $t1, -0x30  # Convert ASCII number to numerical number
  mul $t1, $t1, $t2     # Multiply the current digit with correct base 10
  add $s1, $s1, $t1     # Finally add the current number to the output

  # Check if current_plz has reached length 5
  beq $t0, 5, end       # If current_plz is of length 5, jump to end


next_char:
  addi $s0, $s0, 1      # Move to next character in string
  j loop


reset_current_plz:
  li $s1, 0             # Reset output number
  li $t0, 0             # Reset length of current_plz to 0
  j next_char


end:
  # Before finally returning, we need to make sure that
  # we didn't terminate because we reached the end of the string.
  # Because if we did, then the output may be faulty.
  beq $t0, 5, final_end
  li $s1, 0             # Reset output as the plz is not complete

final_end:
  move $v0, $s1         # Finally load output count to return register
  jr $ra
