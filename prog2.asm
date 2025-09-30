; Group: Joseph Hanger (jhang5), Austin Wang (alw9)
; date : 02/01/2024
; description: this program implements a calculator using postfix 
; expressions using a stack. The program first gets and echos input
; ASCII characters to the screen. Then detects if the inputed character
; is an equals ('='), space, number, or operator ('+', '-', '*', '/', '^').
; If the input is a number it gets push onto the stack. If the input is a 
; operator the first two values of the stack are popped and inputed into
; an operation (ADD, SUBTRACT, MULTIPLY, DIVIDE, EXPONENT) then the result
; is pushed to the stack. If the input is an equals ('=') the program prints
; the last value in stack as a hexidecimal number.
; R0 holds current ASCII char
; R1 holds operator value
; R3 holds stack operand 1
; R4 holds stack operand 2
; R5 holds final solution
; R6 holds temp

		.ORIG x3000
MAIN_LOOP
	GETC			; get char input
	OUT			; echo to screen
	LD R6,EQUALS_ASCII	; is input equal to '='
	NOT R6,R6		; then goto EQUALS
	ADD R6,R6,#1		; |
	ADD R6,R6,R0		; |
	BRz EQUALS		; v
	LD R6,SPACE_ASCII	; is input equalt to ' '
	NOT R6,R6		; then goto MAIN_LOOP
	ADD R6,R6,#1		; |
	ADD R6,R6,R0		; |
	BRz MAIN_LOOP		; v
	LD R6,ZERO_ASCII	; is input >= '0' and <= '9'
	NOT R6,R6		; then goto IS_OPERATOR		
	ADD R6,R6,#1		; |
	ADD R6,R6,R0		; |
	BRn IS_OPERATOR		; |
	LD R6,NINE_ASCII	; |
	NOT R6,R6		; |
	ADD R6,R6,#1		; |
	ADD R6,R6,R0		; |
	BRp IS_OPERATOR		; |
	BRnzp NUMBER		; v
IS_OPERATOR
	LD R6,ADD_ASCII		; is input equal to '+'
	NOT R6,R6		; then goto OPERATOR
	ADD R6,R6,#1		; |
	ADD R6,R6,R0		; |
	BRz OPERATOR		; v
	LD R6,SUBTRACT_ASCII	; is input equal to '-'
	NOT R6,R6		; then goto OPERATOR
	ADD R6,R6,#1		; |
	ADD R6,R6,R0		; |
	BRz OPERATOR		; v
	LD R6,MULTIPLY_ASCII	; is input equal to '*'
	NOT R6,R6		; then goto OPERATOR
	ADD R6,R6,#1		; |
	ADD R6,R6,R0		; |
	BRz OPERATOR		; v
	LD R6,DIVIDE_ASCII      ; is input equal to '/'
        NOT R6,R6               ; then goto OPERATOR
        ADD R6,R6,#1            ; |
        ADD R6,R6,R0            ; |
        BRz OPERATOR            ; v
	LD R6,EXPONENT_ASCII    ; is input equal to '^'
        NOT R6,R6               ; then goto OPERATOR
        ADD R6,R6,#1            ; |
        ADD R6,R6,R0            ; |
        BRz OPERATOR            ; v
	LEA R0,INVALID_STRING	; if not equal to anything
	PUTS			; |
	BRnzp STOP		; v
NUMBER
	LD R6,ZERO_ASCII	; load '0' into R6
	NOT R6,R6
	ADD R6,R6,#1		;
	ADD R0,R0,R6		; R0 = R0 - R6
	JSR PUSH		; push result to stack
	BRnzp MAIN_LOOP
OPERATOR
	ADD R1,R0,#0		; R1 holds operator ASCII value
	LD R6,STACK_TOP		; is at least two items in stack?
	LD R0,STACK_START	; |
	NOT R6,R6		; |
	ADD R6,R6,#1		; |
	ADD R6,R6,#-2		; |
	ADD R6,R6,R0		; |
	BRzp #3			; v
	LEA R0,INVALID_STRING	; print error
	PUTS			; |
	BRnzp STOP		; v
	JSR POP			; POP into R3 and R4
	ADD R4,R0,#0		; |
	JSR POP			; |
	ADD R3,R0,#0		; v
	LD R6,ADD_ASCII         ; is input equal to '+'
        NOT R6,R6               ; then add
        ADD R6,R6,#1            ; |
        ADD R6,R6,R1            ; |
        BRnp #1 	        ; |
	JSR ADD_		; v
	LD R6,SUBTRACT_ASCII    ; is input equal to '-'
        NOT R6,R6               ; then subtract
        ADD R6,R6,#1            ; |
        ADD R6,R6,R1            ; |
        BRnp #1                 ; |
	JSR SUBTRACT		; v
	LD R6,MULTIPLY_ASCII    ; is input equal to '*'
        NOT R6,R6               ; then multiply
        ADD R6,R6,#1            ; |
        ADD R6,R6,R1            ; |
        BRnp #1                 ; |
        JSR MULTIPLY            ; v
	LD R6,DIVIDE_ASCII      ; is input equal to '/'
        NOT R6,R6               ; then divide
        ADD R6,R6,#1            ; |
        ADD R6,R6,R1            ; |
        BRnp #1                 ; |
        JSR DIVIDE		; v
	LD R6,EXPONENT_ASCII    ; is input equal to '^'
        NOT R6,R6               ; then exponent
        ADD R6,R6,#1            ; |
        ADD R6,R6,R1            ; |
        BRnp #1                 ; |
        JSR EXPONENT            ; v
	JSR PUSH
	BRnzp MAIN_LOOP
EQUALS
	LD R6,STACK_TOP		; if (STACK_START - STACK_STOP) equals 1
	LD R0,STACK_START	; then PC = PC + 1 + 4
	NOT R6,R6		; |
	ADD R6,R6,#1		; |
	ADD R6,R6,#-1		; |
	ADD R6,R6,R0		; |
	BRz #3			; v
	LEA R0,INVALID_STRING	; print invalid
	PUTS
	BRnzp STOP
	JSR POP			; pop result into R0
	ADD R3,R0,#0		; store into R3
	ADD R5,R0,#0		; store into R5
	JSR PRINT_HEX		; print R3 to hex
	BRnzp STOP
STOP 	HALT

EQUALS_ASCII	.FILL x003D
SPACE_ASCII	.FILL x0020
ZER0_ASCII	.FILL x0030
NINE_ASCII	.FILL x0039
ADD_ASCII	.FILL x002B
SUBTRACT_ASCII  .FILL x002D
MULTIPLY_ASCII	.FILL x002A
DIVIDE_ASCII	.FILL x002F
EXPONENT_ASCII  .FILL x005E
INVALID_STRING  .STRINGZ "INVALID EXPRESSION"

; DESCRIPTION: print number to hexidecimal
; INPUT: R3 value to print to hexidecimal
; OUTPUT: VOID to screen
; R0 holds ASCII character to print
; R1 holds digit counter
; R2 hold bit counter
; R3 holds number
; R4 holds digit
; R5 temp

PRINT_HEX
  	ST R0,PRINT_HEX_SAVE_R0	; save registers
  	ST R1,PRINT_HEX_SAVE_R1	; |
  	ST R2,PRINT_HEX_SAVE_R2	; |
  	ST R4,PRINT_HEX_SAVE_R4	; |
  	ST R5,PRINT_HEX_SAVE_R5	; v
  	AND R1,R1,#0		; set R1 to 0
DIGIT_LOOP
    	ADD R5,R1,#-4		; if R1 >= 4
    	BRzp PRINT_HEX_DONE	; then goto DONE
    	AND R4,R4,#0
    	AND R2,R2,#0
BIT_LOOP
    	ADD R5,R2,#-4		; if R2 >= 4
    	BRzp PRINT_CHAR 	; then goto PRINT_CHAR
    	ADD R4,R4,R4		; left shift digit
    	ADD R3,R3,#0		; if MSB of R3 > 0
    	BRzp #1			; then add #0 else add #1
    	ADD R4,R4,#1
    	ADD R3,R3,R3		; left shift R3
    	ADD R2,R2,#1  		; increment bit counter
    	BRnzp BIT_LOOP
PRINT_CHAR
    	ADD R5,R4,#-9 		; if digit <= 9 
    	BRp #2			; then PC = PC + 1 + 2
    	LD R0,ZERO_ASCII 	; set R0 to '0'
    	BRnzp #2			
    	LD R0,A_ASCII		; set R0 to 'A'
    	ADD R0,R0,#-10   	; subtract 10
    	ADD R0,R0,R4		; add digit to R0
    	ST R7,PRINT_HEX_SAVE_R7 ; make sure to save this shit
    	OUT
    	LD R7,PRINT_HEX_SAVE_R7
    	ADD R1,R1,#1		; increment digit counter
    	BRnzp DIGIT_LOOP
 PRINT_HEX_DONE
    	LD R0,PRINT_HEX_SAVE_R0	; load register values
    	LD R1,PRINT_HEX_SAVE_R1	; |
    	LD R2,PRINT_HEX_SAVE_R2	; |
    	LD R4,PRINT_HEX_SAVE_R4	; |
    	LD R5,PRINT_HEX_SAVE_R5	; v
    	RET			; go back to reality

ZERO_ASCII 	.FILL x0030
A_ASCII 	.FILL x0041

PRINT_HEX_SAVE_R0 .BLKW #1
PRINT_HEX_SAVE_R1 .BLKW #1
PRINT_HEX_SAVE_R2 .BLKW #1
PRINT_HEX_SAVE_R4 .BLKW #1
PRINT_HEX_SAVE_R5 .BLKW #1
PRINT_HEX_SAVE_R7 .BLKW #1

; DESCRIPTION: adds two numbers together
; INPUT: R3, R4
; OUTPUT: R0 (sum)

ADD_
  	AND R0,R0,#0		; set R0 to 0
  	ADD R0,R3,R4		; add R3 and R4 to R0
  	RET
	
; DESCRIPTION: subtracts two numbers
; INPUT: R3, R4
; OUTPUT: R0 (difference)

SUBTRACT
  	AND R0,R0,#0		; set R0 to 0
  	ADD R0,R4,#0		; set R0 to 2's comp of R4
  	NOT R0,R0		; |
  	ADD R0,R0,#1		; v
  	ADD R0,R0,R3		; add R3 to R0 (-R4)
  	RET
	
; DESCRIPTION: multiply two numbers
; INPUT: R3, R4
; OUTPUT: R0 (product)
; R1 holds sign value

MULTIPLY
  	ST R1,MULTIPLY_SAVE_R1
  	AND R0,R0,#0		; set R0 to 0
  	ADD R1,R0,#1		; set sign to 1
  	ADD R3,R3,#0		; if R3 >= 0
  	BRzp #4			; goto PC = PC + 1 + 4
  	NOT R3,R3		; R3 = -R3
  	ADD R3,R3,#1
  	NOT R1,R1		; sign = -sign
  	ADD R1,R1,#1
  	ADD R4,R4,#0		; if R4 >= 0
  	BRzp #4			; goto PC = PC + 1 + 4
  	NOT R4,R4		; R4 = -R4
  	ADD R4,R4,#1
  	NOT R1,R1		; sign = -sign
  	ADD R1,R1,#1
MULTIPLY_LOOP
    	ADD R4,R4,#0		; while R4 > 0
    	BRnz MULTIPLY_DONE
    	ADD R0,R0,R3		; then R0 = R0 + R3
    	ADD R4,R4,#-1		; decrement R4
    	BRnzp MULTIPLY_LOOP
MULTIPLY_DONE
    	ADD R1,R1,#0
    	BRzp #2			; if sign < 0
    	NOT R0,R0		; then R0 = -R0
    	ADD R0,R0,#1
    	LD R1,MULTIPLY_SAVE_R1
    	RET

MULTIPLY_SAVE_R1 .BLKW #1
	
; DESCRIPTION: divide two numbers
; INPUT: R3 (dividend), R4 (divisor)
; OUTPUT: R0 (quotient)
; R1 holds temp value

DIVIDE
  	ST R1,DIVIDE_SAVE_R1	; save registers
  	AND R0,R0,#0		; set R0 (quotient) to 0
  	ADD R3,R3,#0		; if R3 (divident) < 0
  	BRz DIVIDE_DONE		; then goto DIVIDE_DONE
  	ADD R4,R4,#0		; if R4 (divisor) <= 0
  	BRnz DIVIDE_DONE	; then goto DIVIDE_DONE
  	NOT R4,R4		; 2's comp R4
  	ADD R4,R4,#1		; v
DIVIDE_LOOP
    	ADD R1,R3,R4		; if R3 < R4
    	BRn DIVIDE_DONE		; then goto DIVIDE_DONE
    	ADD R3,R3,R4		; R3 = R3 - R4
    	ADD R0,R0,#1		; increment R0 (quotient)
    	BRnzp DIVIDE_LOOP
DIVIDE_DONE
    	LD R1,DIVIDE_SAVE_R1
    	RET

DIVIDE_SAVE_R1  .BLKW #1
  
; DESCRIPTION: EXPONENT
; INPUT: R3 (base), R4 (degree)
; OUTPUT: R0 (power)
; R1 holds exponent number

EXPONENT
  	ST R1,EXPONENT_SAVE_R1	; save R1
  	ST R3,EXPONENT_SAVE_R3	; save R3 so can load back into R4
  	ADD R0,R3,#0		; set R0 to R3
  	ADD R1,R4,#0		; set R1 to exponent degree
EXPONENT_LOOP
    	ADD R1,R1,#-1		; if R1 <= 0
    	BRnz EXPONENT_DONE	; then goto EXPONENT_DONE
    	ADD R3,R0,#0		; R3 is equal to last MULTIPLY output
    	LD R4,EXPONENT_SAVE_R3	; set R4 to initial base value
    	ST R7,EXPONENT_SAVE_R7	; save R7 so can get back
    	JSR MULTIPLY		; INPUT: R3, R4 OUTPUT: R0
    	LD R7,EXPONENT_SAVE_R7	; load R7 back
    	BRnzp EXPONENT_LOOP	; goto EXPONENT_LOOP
EXPONENT_DONE
    	LD R1,EXPONENT_SAVE_R1	; load R1 previous value back
    	RET

EXPONENT_SAVE_R1 .BLKW #1
EXPONENT_SAVE_R3 .BLKW #1
EXPONENT_SAVE_R7 .BLKW #1
	
;IN:R0, OUT:R5 (0-success, 1-fail/overflow)
;R3: STACK_END R4: STACK_TOP
;
PUSH	
	ST R3, PUSH_SaveR3	;save R3
	ST R4, PUSH_SaveR4	;save R4
	AND R5, R5, #0		;
	LD R3, STACK_END	;
	LD R4, STACk_TOP	;
	ADD R3, R3, #-1		;
	NOT R3, R3		;
	ADD R3, R3, #1		;
	ADD R3, R3, R4		;
	BRz OVERFLOW		;stack is full
	STR R0, R4, #0		;no overflow, store value in the stack
	ADD R4, R4, #-1		;move top of the stack
	ST R4, STACK_TOP	;store top of stack pointer
	BRnzp DONE_PUSH		;
OVERFLOW
	ADD R5, R5, #1		;
DONE_PUSH
	LD R3, PUSH_SaveR3	;
	LD R4, PUSH_SaveR4	;
	RET


PUSH_SaveR3	.BLKW #1	;
PUSH_SaveR4	.BLKW #1	;


;OUT: R0, OUT R5 (0-success, 1-fail/underflow)
;R3 STACK_START R4 STACK_TOP
;
POP	
	ST R3, POP_SaveR3	;save R3
	ST R4, POP_SaveR4	;save R3
	AND R5, R5, #0		;clear R5
	LD R3, STACK_START	;
	LD R4, STACK_TOP	;
	NOT R3, R3		;
	ADD R3, R3, #1		;
	ADD R3, R3, R4		;
	BRz UNDERFLOW		;
	ADD R4, R4, #1		;
	LDR R0, R4, #0		;
	ST R4, STACK_TOP	;
	BRnzp DONE_POP		;
UNDERFLOW
	ADD R5, R5, #1		;
DONE_POP
	LD R3, POP_SaveR3	;
	LD R4, POP_SaveR4	;
	RET


POP_SaveR3	.BLKW #1	;
POP_SaveR4	.BLKW #1	;
STACK_END	.FILL x3FF0	;
STACK_START	.FILL x4000	;
STACK_TOP	.FILL x4000	;


.END
