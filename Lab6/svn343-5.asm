.ORIG x3000
;this block of ~12 lines of code stores the user inputted EID into memory
        LEA R0, PROMPT
        PUTS

        LEA R1, USEREID
BACK    GETC

        LD R2, NEGENTER
        ADD R2, R0, R2
        OUT
        BRZ ENDOFID
        STR R0, R1, #0
        ADD R1, R1, #1
        BR BACK

ENDOFID AND R2, R2, #0
        STR R2, R1, #0
            
;searching the linked list to find a match     
        LDI R0, NUM1
BACK2   BRZ SRCHDNE
        LDR R1, R0, #1
        
        JSR MATCH
        ADD R4, R4, #0
        BRP CONT
        LDR R0, R0, #0
        BR BACK2
        
SRCHDNE AND R4, R4, #0

CONT    ADD R4, R4, #0
        BRP MAINROOM
        
        
;SEARCH WAITING ROOM
        LD R0, NUM2
        LDR R5, R0, #0
        
BACK8   BRZ NOMATCH
        LDR R1, R5, #1
        
        JSR MATCH
        ADD R4, R4, #0
        BRP MOVE
        LDR R5, R5, #0
        BR BACK8
        
;DISPLAY "THE ENTERED EID DOES NOT MATCH"  
NOMATCH LEA R0, PROMPT2
        PUTS
        BR STOP
      
;DELETE FROM WAITING ROOM, ADD TO MAIN ROOM  
MOVE    ADD R1, R0, #0
        LDR R2, R1, #0
        LDR R3, R2, #0
        STR R3, R1, #0
        
        LDI R0, NUM1
        STR R0, R2, #0
        LD R4, NUM1
        STR R2, R4, #0
        
;DISPLAY "<EID> IS ADDED TO THE MAIN ROOM"        
        LEA R1, USEREID
BACK7   LDR R0, R1, #0
        OUT
        ADD R1, R1, #1
        ADD R0, R0, #0
        BRNP BACK7
        LEA R0, PROMPT4
        PUTS
        BR STOP
        
;DISPLAY "<EID> IS ALREADY IN THE MAIN ROOM"
MAINROOM LEA R1, USEREID
BACK4   LDR R0, R1, #0
        OUT
        ADD R1, R1, #1
        ADD R0, R0, #0
        BRNP BACK4
        LEA R0, PROMPT3
        PUTS

STOP    HALT

;RETURNS R4 = 1 IF MATCH, 0 IF NOT
;TAKES IN R1/EID ARRAY, R2/USEREID ARRAY
MATCH   ST R5, NUM3

        LEA R2, USEREID
        AND R4, R4, #0
BACK5   LDR R5, R1, #0
        LDR R6, R2, #0
        BRZ SETR4
        
        NOT R6, R6
        ADD R6, R6, #1
        ADD R5, R5, R6
        BRZ INCRMNT
        
RETURN  LD R5, NUM3
        RET
        
INCRMNT ADD R1, R1, #1
        ADD R2, R2, #1
        BR BACK5
        
SETR4   ADD R4, R4, #1
        BR RETURN

PROMPT .STRINGZ "Type EID and press Enter: "
USEREID .BLKW x6
NEGENTER .FILL x-0A
NUM1 .FILL x4000
NUM2 .FILL x4001
NUM3 .FILL x0
PROMPT2 .STRINGZ "The entered EID does not match."
PROMPT3 .STRINGZ " is already in the main room."
PROMPT4 .STRINGZ " is added to the main room."
.END