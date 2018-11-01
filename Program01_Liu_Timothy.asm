TITLE Elementary Arithmetic     (Program01.asm)

; Author: Timothy Liu
; Last Modified: October 2, 2018
; OSU email address: liutim@oregonstate.edu
; Course number/section: CS_271_400_F2018
; Project Number: 1                Due Date: October 7, 2018
; Description: This program will introduce the program and the programmer, prompt the user for 
;	two numbers, calculate and display the sum, difference, product, and quotient and 
;	remainder of the numbers, and say good-bye.

; Implementation notes: Uses global variables. No data validation.

INCLUDE Irvine32.inc

.data
intro_1			BYTE	"     Elementary Arithmetic by Timothy Liu", 0									; Title of Program
ec_1			BYTE	"**EC #1: Program repeats until the user chooses to quit", 0					; Description of Extra Credit #1				
ec_2			BYTE	"**EC #2: Program validates the second number to be less than the first", 0		; Description of Extra Credit #2
ec_3			BYTE	"**EC #3: Program calculates and displays the quotient as a floating-point "
				BYTE	"number rounded to the nearest 0.001", 0										; Description of Extra Credit #3
intro_2			BYTE	"Enter 2 numbers, and I'll show you the sum, difference, product, "				
				BYTE	"quotient, and remainder.", 0													; Description of program's function
prompt_1		BYTE	"First number: ", 0		; Prompt user for first number
prompt_2		BYTE	"Second number: ", 0	; Prompt user for second number
userNum_1		DWORD	?						; First number to be entered by user
userNum_2		DWORD	?						; Second number to be entered by user
sum				DWORD	?						; Sum of the two numbers to be calculated
difference		DWORD	?						; Difference of the two numbers to be calculated
product			DWORD	?						; Product of the two numbers to be calculated
quotient		DWORD	?						; Quotient of the two numbers to be calculated
remainder		DWORD	?						; Remainder from dividing the two numbers
addSign			BYTE	" + ", 0				; For displaying addition sign in calculation results
minusSign		BYTE	" - ", 0				; For displaying subtraction sign in calculation results
multiplySign	BYTE	" x ", 0				; For displaying multiplication sign in calculation results
divideSign		BYTE	" / ", 0				; For displaying division sign in calculation results
equalSign		BYTE	" = ", 0				; For displaying equal sign in calculation results
remainderText	BYTE	" remainder ", 0		; For displaying remainder of division in calculation results
decimalPoint	BYTE	".", 0					; For displaying a decimal point 
noDecimals		BYTE	".000", 0				; For division with no remainder
goodBye			BYTE	"Impressed? Bye!", 0	; Exiting text at end of program
inputError		BYTE	"The second number must be less than the first!", 0		; Displays if user's second number is not less than first
againPrompt		BYTE	"Enter new numbers? 1 for yes, 0 for no: ", 0			; Asks user to enter new numbers or quit the program
againInput		BYTE	?														; User's response to againPrompt

.code
main PROC

; Introduce the program and the programmer
	mov		edx, OFFSET intro_1
	call	WriteString
	call	CrLf

; Display descriptions of included extra credit
	mov		edx, OFFSET ec_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET ec_2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET ec_3
	call	WriteString
	call	CrLf

; Describe what the program will do
loopTop:
	call	CrLf
	mov		edx, OFFSET intro_2
	call	WriteString
	call	CrLf
	call	CrLf

; Prompt user for a number and store the value
	mov		edx, OFFSET prompt_1
	call	WriteString
	call	ReadDec
	mov		userNum_1, eax

; Prompt user for a second number
	mov		edx, OFFSET prompt_2
	call	WriteString
	call	ReadDec
	
; Validate second number is less than the first number
	cmp		eax, userNum_1
	jge		notLess

; Store second number
	mov		userNum_2, eax
	call	CrLf

; Calculate the sum and store the value
	mov		eax, userNum_1
	add		eax, userNum_2
	mov		sum, eax

; Calculate the difference and store the value
	mov		eax, userNum_1
	sub		eax, userNum_2
	mov		difference, eax

; Calculate the product and store the value
	mov		eax, userNum_1
	mul		userNum_2
	mov		product, eax

; Calculate the integer quotient and remainder and store the values
	mov		eax, userNum_1
	cdq
	div		userNum_2
	mov		quotient, eax
	mov		remainder, edx

; Display the calculation for the sum of the numbers
	mov		eax, userNum_1
	call	WriteDec
	mov		edx, OFFSET addSign
	call	WriteString
	mov		eax, userNum_2
	call	WriteDec
	mov		edx, OFFSET	equalSign
	call	WriteString
	mov		eax, sum
	call	WriteDec
	call	CrLf

; Display the calculation for the difference of the numbers
	mov		eax, userNum_1
	call	WriteDec
	mov		edx, OFFSET minusSign
	call	WriteString
	mov		eax, userNum_2
	call	WriteDec
	mov		edx, OFFSET	equalSign
	call	WriteString
	mov		eax, difference
	call	WriteDec
	call	CrLf

; Display the calculation for the product of the numbers
	mov		eax, userNum_1
	call	WriteDec
	mov		edx, OFFSET multiplySign
	call	WriteString
	mov		eax, userNum_2
	call	WriteDec
	mov		edx, OFFSET	equalSign
	call	WriteString
	mov		eax, product
	call	WriteDec
	call	CrLf

; Display the calculation for the integer division of the numbers
	mov		eax, userNum_1
	call	WriteDec
	mov		edx, OFFSET divideSign
	call	WriteString
	mov		eax, userNum_2
	call	WriteDec
	mov		edx, OFFSET	equalSign
	call	WriteString
	mov		eax, quotient
	call	WriteDec
	mov		edx, OFFSET remainderText
	call	WriteString
	mov		eax, remainder
	call	WriteDec
	call	CrLf

; Display the calculation for the floating point division of the numbers
	mov		eax, userNum_1
	call	WriteDec
	mov		edx, OFFSET divideSign
	call	WriteString
	mov		eax, userNum_2
	call	WriteDec
	mov		edx, OFFSET	equalSign
	call	WriteString
	mov		eax, quotient
	call	WriteDec

; Check if division calculation had any remainder
	mov		eax, remainder
	cmp		eax, 0
	jne		showDecimals
	mov		edx, OFFSET noDecimals
	call	WriteString
	call	CrLf
	jmp		playAgain

; Print a decimal point
showDecimals:
	mov		edx, OFFSET decimalPoint
	call	WriteString

; Find 2 values after decimal point
	mov		ecx, 2
decimalLoop:
	mov		eax, remainder
	mov		ebx, 10
	mul		ebx
	div		userNum_2
	call	WriteDec
	mov		remainder, edx
	loop	decimalLoop

; Find the third value after decimal point
	mov		eax, remainder
	mov		ebx, 10
	mul		ebx
	div		userNum_2
	mov		ecx, eax
	mov		remainder, edx

; Find the fourth value after decimal point
	mov		eax, remainder
	mov		ebx, 10
	mul		ebx
	div		userNum_2

; Use fourth value after decimal to determine rounding of third value after decimal
	cmp		eax, 5
	jl		noRounding
	inc		ecx
noRounding:
	mov		eax, ecx
	call	WriteDec
	call	CrLf

; Prompt user to enter new numbers or quit the program
playAgain:
	call	CrLf
	mov		edx, OFFSET againPrompt
	call	WriteString
	call	ReadInt
	cmp		eax, 1
	je		loopTop
	jmp		theEnd

; Labels for validating second number is less than first
notLess:
	call	CrLf
	mov		edx, OFFSET inputError
	call	WriteString
	call	CrLf
	jmp		playAgain

; Say good-bye
theEnd:
	call	CrLf
	mov		edx, OFFSET goodBye
	call	WriteString
	call	CrLf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
 
