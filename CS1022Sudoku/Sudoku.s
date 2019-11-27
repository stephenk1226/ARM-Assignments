	AREA	Sudoku, CODE, READONLY
	IMPORT	main
	IMPORT	getkey
	IMPORT	sendchar
	EXPORT	start
	PRESERVE8	
                                                                                           
start

	LDR	R0, =gridOne;load in the array
	MOV	R1, #0 	; Row
	MOV	R2, #0 	; Column
	;MOV R3, #6	;test Value for setSquare
	;BL getSquare	;call the getSquare subroutine
	;BL setSquare	;call the setSqaure subroutine
	;BL isValid	;call the isValid subroutine
	BL sudoku	;call the sudoku subroutine
	BL print	;call the print subroutine (extra mile)
	
stop	B	stop

getSquare
	STMFD sp!, {R0-R2, lr}
	LDR R5, = 9  				; Row and column size.
	MUL R6, R1, R5				; Index = Size*Row.
	ADD R6, R6, R2				; Index = index + column.
	LDRB R7, [R0, R6]			; Load number into R7
	LDMFD sp!, {R0-R2, pc}		
	BX lr
	
setSquare
	STMFD sp!, {R0-R3, lr}
	MOV R4, R0
	LDR R5, = 9 				; Row and column size.
	MUL R6, R1, R5				; Index = Column*Size.
	ADD R6, R6, R2				; Index = index + column.
	STRB R3, [R4, R6]			; Store value of R3 in the array index.
	LDMFD sp!, {R0-R3, pc}
	BX lr
	
isValid				
	STMFD sp!, {R0-R2, lr}  	
	BL getSquare				;call the getSquare subroutine
	MOV R6, #1					;boolean valid = true
	CMP R7, #0					;if(getSqaure( array, col, row) == ))
	BEQ finishedChecking		;{
	BL rowCheck					;call the rowCheck subroutine
	CMP R6, #1					;if(valid)
	BEQ validCheck				;{	
	B finishedChecking			;call the finishedChecking subroutine
validCheck			
	BL columnCheck				;call the checkColumn subroutine
	CMP R6, #1					;if(valid)	
	BEQ gridCheck				;{	
	B finishedChecking			;finish the isValid subroutine
	
gridCheck
	BL checkThreeByThree		;call the checkThreeByThree subroutine
	
finishedChecking
	LDMFD sp!, {R0-R2, pc}		;finish the isValid subroutine
	BX lr	
	
rowCheck
	STMFD sp!, {R0-R2, lr}  	
	MOV R6, #1					;boolean valid = true
	MOV R8, #0					;counter
	MOV R9, #0					;columnChecker = 0
	B rowFor					;call the for , in order to loop through the row elements
rowFor
	CMP R9, #9					;for(columnChecker < 9 )
	BLT columnGreaterThanNine	;{
	MOV R6, #1					;reset boolean
	B finishRowFor				
columnGreaterThanNine
	BL getSquare				;getSquare(Array, row, col)
	MOV R12, R7					;move the element into local varibale
	MOV R11, R2					;int column 
	MOV R2, R9					;pass in the paramters
	BL getSquare				;getSquare(Array, row, columnChecker	
	MOV R2, R11					;reset parameter			
	CMP R12, R7					;if(old element == new element)
	BEQ sameElement				;{
	ADD R9, R9, #1				;columnChecker++
	MOV R6, #1					;boolean = true
	B rowFor					;continue to loop until done 9 times
sameElement
	ADD R8, R8, #1				;counter++
	CMP R8, #1					;if(conter>1)
	BGT inValid					;{
	ADD R9, R9, #1				;columnChecker++		
	B rowFor		
inValid
	MOV R6, #0					;valid
	B finishRowFor
finishRowFor
	LDMFD sp!, {R0-R2, pc}
	BX lr;	
	
	
columnCheck
	STMFD sp!, {R0-R2, lr}  	; Row and column parameters
	MOV R6, #1					; boolean valid = true
	MOV R8, #0					; int count = 0
	MOV R9, #0					; int rowChecker = 0
	B columnFor					
columnFor
	CMP R9, #9					;if(rowChecker < 0)
	BLT rowGreaterThanNine		;{
	MOV R6, #1					;valid = true
	B finishColumnFor			;
rowGreaterThanNine
	BL getSquare				;getSquare(Array, row, column)
	MOV R12, R7					;move initial getSquare value into a local variable	
	MOV R11, R1					;move parameter back in
	MOV R1, R9					;pass in paramters
	BL getSquare				;getSquare(Array, rowChecker, column)
	MOV R1, R11					;move back in the original parameter
	CMP R12, R7					;if(original getSquare() == new getSquare())	
	BEQ sameElement1			;{
	ADD R9, R9, #1				;rowChecker++
	MOV R6, #1					;vallid = true 
	B columnFor					;
sameElement1
	ADD R8, R8, #1				;count++
	CMP R8, #1					;if(cunt>1)
	BGT inValid1				;{	
	ADD R9, R9, #1				;rowChecker++
	B columnFor					;
inValid1
	MOV R6, #0					;valid = false
	B finishColumnFor
finishColumnFor
	LDMFD sp!, {R0-R2, pc}
	BX lr;
finish	
	LDMFD sp!, {R0-R3, pc}	
	
checkThreeByThree
	STMFD sp!, {R0-R2, lr}  
	BL getSquare		; call the getSquare subroutine
	MOV R8, R7			; initial getSquare value
	MOV R11, R2			; initial column
	MOV R12, R1			; initial row
		
	CMP R1, #0			;if(row == 0    
	BEQ firstRow		;||
	CMP R1, #3			;row == 3
	BEQ firstRow		;||
	CMP R1, #6			;row == 6)
	BEQ firstRow		;{
	CMP R1, #1			;if(row == 1   
	BEQ secondRow		;||
	CMP R1, #4			;row == 4
	BEQ secondRow		;||	
	CMP R1, #7			;row == 7)
	BEQ secondRow		;{
	CMP R1, #2			;if(row == 2    
	BEQ thirdRow		;||
	CMP R1, #5			;row == 5
	BEQ thirdRow		;||	
	CMP R1, #8			;row == 8)	
	BEQ thirdRow		;{	
	
firstRow
	CMP R2, #0					;if(column == 0
	BEQ firstRowFirstColumn		;||
	CMP R2, #3					;column == 3
	BEQ firstRowFirstColumn		;||
	CMP R2, #6					;column == 6)
	BEQ firstRowFirstColumn		;{	
	CMP R2, #1					;if(column == 1
	BEQ firstRowSecondColumn	;|| 
	CMP R2, #4					;column == 4	
	BEQ firstRowSecondColumn	;||
	CMP R2, #7					;column == 7)	
	BEQ firstRowSecondColumn	;{
	CMP R2, #2					;if(column == 2
	BEQ firstRowThirdColumn		;|| 
	CMP R2, #5					;column == 5
	BEQ firstRowThirdColumn		;||
	CMP R2, #8					;column == 8)
	BEQ firstRowThirdColumn		;{
	
firstRowFirstColumn
	ADD R1, R1, #1		; row = row + 1
	ADD R2, R2, #1		; col = col +1
	BL getSquare		; call the getSquare subroutine
	CMP R8, R7			;if(initial == current) 
	BEQ false			;return false
	ADD R2, R2, #1 		;col = col +2
	BL getSquare		;call the getSquare subroutine
	CMP R8, R7			;if(initial == current) 
	BEQ false			;return false
	ADD R1, R1, #1		;row = row+2 
	BL getSquare		;call the getSquare subroutine
	CMP R8,R7			;if(initial == current) 
	BEQ false			;return false
	SUB R2, R2, #1		;row 1, col 2
	BL getSquare		;call the getSquare subroutine
	CMP R8, R7			;if(initial == current) 
	BEQ false			;return false
	B true				;return true
	
firstRowSecondColumn
	ADD R1, R1, #1		;row = row + 1
	ADD R2, R2, #1		;col = col +1
	BL getSquare		;call the getSquare subroutine
	CMP R8, R7			;if(initial == current) 
	BEQ false			;return false
	SUB R2, R2, #2 		;row+1, col-1
	BL getSquare		;call the getSquare subroutine
	CMP R8, R7			;if(initial == current) 
	BEQ false			;return false
	ADD R1, R1, #1		;row+2,col-1
	BL getSquare		;call the getSquare subroutine	
	CMP R8,R7			;if(initial == current) 
	BEQ false			;return false
	ADD R2, R2, #2		;row 2, col 1
	BL getSquare		;call the getSquare subroutine
	CMP R8, R7			;if(initial == current) 
	BEQ false			;return false
	B true				;return true
	
firstRowThirdColumn
	ADD R1, R1, #1		;row = row+1, 
	SUB R2, R2, #1		;col = col-1
	BL getSquare		;call the getSquare subroutine
	CMP R8, R7			;if(initial == current) 
	BEQ false			;return false
	SUB R2, R2, #1 		;col = col-2
	BL getSquare		;call the getSquare subroutine
	CMP R8, R7			;if(initial == current) {	
	BEQ false			;return false
	ADD R1, R1, #1		;row = row+2
	BL getSquare		;call the getSquare subroutine	
	CMP R8,R7			;if(initial == current) 
	BEQ false			;return false
	ADD R2, R2, #1		;col = col - 1
	BL getSquare		;call the getSquare subroutine	
	CMP R8, R7			;if(initial == current) 
	BEQ false			;return false
	B true				;return true
	
secondRow				
	CMP R2, #0					;if(column == 0
	BEQ secondRowFirstColumn	;||
	CMP R2, #3					;column == 3
	BEQ secondRowFirstColumn	;||
	CMP R2, #6					;column == 6)	
	BEQ secondRowFirstColumn	;{
	CMP R2, #1					;if(column == 1
	BEQ secondRowSecondColumn	;||
	CMP R2, #4					;column == 4
	BEQ secondRowSecondColumn	;||
	CMP R2, #7					;column == 7)
	BEQ secondRowSecondColumn	;{
	CMP R2, #2					;if(column == 2
	BEQ secondRowThirdColumn	;||
	CMP R2, #5					;column == 5
	BEQ secondRowThirdColumn	;||
	CMP R2, #8					;column == 8)	
	BEQ secondRowThirdColumn	;{
	
secondRowFirstColumn
	ADD R1, R1, #1		;row = row+1
	ADD R2, R2, #1		;col = col +1
	BL getSquare		;call the getSquare subroutine
	CMP R8, R7			;if(initial == current) 
	BEQ false			;return false
	ADD R2, R2, #1 		;col = col + 2
	BL getSquare		;call the getSquare subroutine
	CMP R8, R7			;if(initial == current) 
	BEQ false			;return false
	SUB R1, R1, #2		;row = row - 1
	BL getSquare		;call the getSquare subroutine
	CMP R8,R7			;if(initial == current) 	
	BEQ false			;return false
	SUB R2, R2, #1		;col = col + 1 
	BL getSquare		;call the getSquare subroutine
	CMP R8, R7			;if(initial == current) 
	BEQ false			;return false
	B true				;return true
	
secondRowSecondColumn
	ADD R1, R1, #1		;row = row+1
	ADD R2, R2, #1		;col = col + 1	
	BL getSquare		;call the getSquare subroutine
	CMP R8, R7			;if(initial == current) 	
	BEQ false			;return false
	SUB R2, R2, #2 		;col = col -1
	BL getSquare		;call the getSquare subroutine
	CMP R8, R7			;if(initial == current) 
	BEQ false			;return false
	SUB R1, R1, #2		;row = row - 1
	BL getSquare		;call the getSquare subroutine
	CMP R8,R7			;if(initial == current) 
	BEQ false			;return false
	ADD R2, R2, #2		;col = col + 1
	BL getSquare		;call the getSquare subroutine
	CMP R8, R7			;if(initial == current) 		
	BEQ false			;return false
	B true				;return true	
	
secondRowThirdColumn	
	ADD R1, R1, #1		;row = row+1
	SUB R2, R2, #1		;col = col-1	
	BL getSquare		;call the getSquare subroutine
	CMP R8, R7			;if(initial == current) 	
	BEQ false			;return false
	SUB R2, R2, #1 		;col = col -2
	BL getSquare		;call the getSquare subroutine
	CMP R8, R7			;if(initial == current) 
	BEQ false			;return false
	SUB R1, R1, #2		;row = row -1
	BL getSquare		;call the getSquare subroutine		
	CMP R8,R7			;if(initial == current) 
	BEQ false			;return false
	ADD R2, R2, #1		;col = col -1
	BL getSquare		;call the getSquare subroutine
	CMP R8, R7			;if(initial == current) 
	BEQ false			;return false
	B true				;return true

thirdRow
	CMP R2, #0					;if(column == 0
	BEQ thirdRowFirstColumn		;|| 
	CMP R2, #3					;column == 3	
	BEQ thirdRowFirstColumn		;|| 	
	CMP R2, #6					;column == 6)
	BEQ thirdRowFirstColumn		;{	
	CMP R2, #1					;if(column == 1	
	BEQ thirdRowSecondColumn	;||	
	CMP R2, #4					;column == 4		
	BEQ thirdRowSecondColumn	;||
	CMP R2, #7					;column == 7)	
	BEQ thirdRowSecondColumn	;{
	CMP R2, #2					;if(column == 2
	BEQ thirdRowThirdColumn		;||
	CMP R2, #5					;column == 5
	BEQ thirdRowThirdColumn		;||
	CMP R2, #8					;column == 8)
	BEQ thirdRowThirdColumn		;{
	
thirdRowFirstColumn
	SUB R1, R1, #1		;row = row-1 
	ADD R2, R2, #1		;col = col +1	
	BL getSquare		;call the getSquare subroutine
	CMP R8, R7			;if(initial == current) 	
	BEQ false			;return false
	ADD R2, R2, #1 		;col = col +2
	BL getSquare		;call the getSquare subroutine
	CMP R8, R7			;if(initial == current) 
	BEQ false			;return false
	SUB R1, R1, #1		;row = row -2 
	BL getSquare		;call the getSquare subroutine
	CMP R8,R7			;if(initial == current) 
	BEQ false			;return false
	SUB R2, R2, #1		;col = col +1
	BL getSquare		;call the getSquare subroutine
	CMP R8, R7			;if(initial == current) 
	BEQ false			;return false
	B true				;return true
	
thirdRowSecondColumn
	SUB R1, R1, #1		;row = row-1
	SUB R2, R2, #1		;col = col-1 	
	BL getSquare		;call the getSquare subroutine
	CMP R8, R7			;if(initial == current) 	
	BEQ false			;return false
	SUB R1, R1, #1 		;row = row-2
	BL getSquare		;call the getSquare subroutine
	CMP R8, R7			;if(initial == current) 
	BEQ false			;return false
	ADD R2, R2, #3		;col = col +2
	BL getSquare		;call the getSquare subroutine
	CMP R8,R7			;if(initial == current) 
	BEQ false			;return false
	ADD R1, R1, #1		;row = row -1
	BL getSquare		;call the getSquare subroutine
	CMP R8, R7			;if(initial == current) 
	BEQ false			;return false
	B true				;return true
	
thirdRowThirdColumn
	SUB R1, R1, #1		;row = row-1
	SUB R2, R2, #1		;col = col - 1		
	BL getSquare		;call the getSquare subroutine
	CMP R8, R7			;if(initial == current) 	
	BEQ false			;return false
	SUB R2, R2, #1 		;col = col -2
	BL getSquare		;call the getSquare subroutine
	CMP R8, R7			;if(initial == current) 	
	BEQ false			;return false
	SUB R1, R1, #1		;row = row -2
	BL getSquare		;call the getSquare subroutine
	CMP R8,R7			;if(initial == current) 
	BEQ false			;return false
	ADD R2, R2, #1		;col = col +1
	BL getSquare		;call the getSquare subroutine
	CMP R8, R7			;if(initial == current) 
	BEQ false			;return false
	B true				;return true
	
false
	MOV R6, #0			;boolean valid = false
	MOV R1, R12			;pass back in the Parameters
	MOV R2, R11			;pass back in the Parameters
	LDMFD sp!, {R0-R2, pc}
true
	MOV R6, #1			;boolean valid = true
	MOV R1, R12			;pass back in the Parameters
	MOV R2, R11			;pass back in the Parameters
	LDMFD sp!, {R0-R2, pc}
	
sudoku	
	STMFD sp!, {R4-R10, lr}
	
	MOV R4, R0		;move parameter into a local variable (array)
	MOV R5, R1		;move parameter into a local variable (current row)
	MOV R6, R2		;move parameter into a local variable (current column)
	
	MOV R7, #0		;boolean result = false
	MOV R8, R5		;nxtRow = row
	ADD R9, R6, #1	;nxtCol = col +1
	
	CMP R9, #8		;if (nxtcol > 8)
	BLE lessThanEight;{
	MOV R9, #0		;nxtcol = 0
	ADD R8, R8, #1	;nxtrow++
	
lessThanEight
	MOV R0, R4		;pass in the parameters
	MOV R1, R5		;pass in the parameters
	MOV R2, R6		;pass in the parameters
	BL getSquare	;call the subroutine getSquare
	CMP R7, #0		; R7 is where I store the getSquare result
	BEQ squareNotZero
	MOV R0, R4	;pass in the parameters
	MOV R1, R5	;pass in the parameters
	MOV R2, R5	;pass in the parameters
	BL isValid	; isValid( int[] Array, nxtrow, nxtcol)
	CMP R6, #1	; is the result boolean of isValid
	BNE squareNotZero
	CMP R5, #8		;if (row == 8
	BNE notEight	;&&
	CMP R6, #8		;col==8)
	BNE notEight	;{
	LDR R7, = 1	; return true( 1 = true)
	LDMFD sp!, {R0-R3, pc}

notEight
	MOV R0, R4	;pass in the parameters
	MOV R1, R8	;pass in the parameters
	MOV R2, R9	;pass in the parameters
	BL sudoku	;esult = sudoku(array, nxtRow, nxtCol);

squareNotZero
	LDR R10, =1 	;int num =1
	LDR R7, =0

for		
	CMP R10, #9	;if(num<=9
	BHI endFor	;&&
	CMP R7, #1	;!result)
	BNE endFor	;{
	MOV R0, R4	;pass in parameters
	MOV R1, R5	;pass in parameters
	MOV R2, R6	;pass in parameters
	MOV R3, R10	;pass in parameters
	BL setSquare	;setSquare(numL, row, col, num);
	MOV R0, R4	;pass in parameters
	MOV R1, R5	;pass in parameters
	MOV R2, R6	;pass in parameters
	BL isValid	;isValid(array, row, col)
	CMP R6, #1	;R6 is boolean for isValid
	BNE notValid2
	CMP R5, #8	;R11 = nxtRow
	BNE else3
	CMP R6, #8	;R12 = nxtCol
	BNE else3
	LDR R5, =1	;return true
	LDMFD sp!, {R0-R3, pc}

else3
	MOV R0, R4	;pass in parameters
	MOV R1, R8	;pass in parameters
	MOV R2, R9	;pass in parameters
	BL sudoku	;result = sudoku(numL, nxtrow, nxtcol);

notValid2
	ADD R10, R10, #1	;num++
	B for

resetTry
	MOV R10, #1
	B for
	
endFor
	CMP R7, #0		;if(!result)
	BNE done 		;{
	MOV R0, R4		;pass in the parameters
	MOV R1, R5		;pass in the parameters
	MOV R2, R6		;pass in the parameters#
	MOV R3, #0		;num = 0
	MOV R3, R10		;pass in the parameters
	BL setSquare	;setSquare(numL, row, col, 0)
done
	LDMFD sp!, {R4-R10, pc}
	
print	
	STMFD sp!, {R4-R10, lr}
	MOV R4, R0	;move array into local variable
	LDR R8, =0	;row 
	LDR R9, =0	;column
	LDR R10, =0	; rowCounter
	LDR R11, = 0 ;finalCounter

forPrint
	CMP R10, #9			;for( row counter < 9	
	BEQ changeColumn	;&&
	CMP R11, #81		;final counter < 81)	
	BEQ finishProgram	;else endProgram
	MOV R1, R8			;pass in the parameters for getSquare
	MOV R2, R9			;pass in the parameters for getSquare
	MOV R0, R4			;pass in the parameters for getSquare
	BL getSquare		;(getSquare(array, row, col)
	ADD R0, R7, #0x30	;convert to ascii
	BL sendchar			;send value in R0 to console
	MOV R0, #0x20		;add a space to R0 to have a gap betweeen the elements
	BL sendchar			;send value  in R0 to console
	ADD R10, R10, #1	;rowCounter++
	ADD R11, R11, #1	;finalCounter++
	ADD R9, R9, #1		;column++
	B forPrint
	
changeColumn
	MOV R0, #0x0A		;assign R0 to a line break	
	BL sendchar			;send value in R0 to console
	LDR R9, =0			;reset column to 0
	ADD R8, R8, #1		;row++
	MOV R10, #0			;reset rowCounter to 0
	B forPrint
	

finishProgram
	LDMFD sp!, {R4-R10, pc}	


	AREA	Grids, DATA, READWRITE

gridOne
		DCB	0,7,0,0,0,0,0,0,0
    	DCB	0,0,0,0,0,6,9,0,0
    	DCB	0,0,0,8,3,0,0,7,6
    	DCB	0,0,0,0,0,5,0,0,2
    	DCB	0,7,5,4,1,8,7,0,0
    	DCB	0,0,0,7,0,0,0,0,0
    	DCB	6,1,0,0,9,0,0,0,8
    	DCB	0,0,2,3,0,0,0,0,0
    	DCB	0,0,9,0,0,0,0,5,4

gridTwo
		DCB	1,7,0,0,3,3,0,3,3
    	DCB	7,0,0,0,0,6,9,0,0
    	DCB	0,0,0,8,3,0,0,7,6
    	DCB	0,3,3,0,3,3,0,2,2
    	DCB	0,0,5,4,1,8,7,0,0
    	DCB	0,0,0,7,0,0,0,0,0
    	DCB	6,1,1,9,9,0,0,8,8
    	DCB	0,0,2,3,0,0,0,5,0
    	DCB	0,0,9,0,0,0,0,5,4

gridThree
		DCB	3,3,3,3,3,3,3,3,3
    	DCB	3,3,3,3,3,6,9,3,3
    	DCB	3,3,3,8,3,3,3,7,6
    	DCB	3,3,3,3,3,3,3,2,2
    	DCB	3,3,5,4,1,8,7,3,3
    	DCB	3,3,3,7,3,3,3,3,3
    	DCB	6,1,1,9,9,3,3,8,8
    	DCB	3,3,2,3,3,3,3,5,3
    	DCB	3,3,9,3,3,3,3,5,4
		
	END