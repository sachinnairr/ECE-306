; OPERATING SYSTEM CODE

.ORIG x500
        
        LD R0, VEC
        LD R1, ISR
        ; (1) Initialize interrupt vector table with the starting address of ISR.
        STR R1, R0, #0

        ; (2) Set bit 14 of KBSR. [To Enable Interrupt]
        LD R3, IEBIT
	    LDI R0, KBSR
	    ADD R4, R0, R0
	    BRN STEP3
	    ADD R0, R0, R3
    	STI R0, KBSR

        ; (3) Set up system stack to enter user space. So that PC can return to the main user program at x3000.
	; R6 is the Stack Pointer. Remember to Push PC and PSR in the right order. Hint: Refer State Graph
STEP3   LD R6, SYSSTACK
        LD R0, PSR
        ADD R6, R6, #-1
        STR R0, R6, #0
        LD R0, PC
        ADD R6, R6, #-1
        STR R0, R6, #0

        ; (4) Enter user Program.
        RTI
        
VEC     .FILL x0180
ISR     .FILL x1700
KBSR    .FILL xFE00
MASK    .FILL xBFFF
PSR     .FILL x8002
PC      .FILL x3000
IEBIT   .FILL x4000
SYSSTACK .FILL x3000
NUM1    .FILL xBFFF

.END


; INTERRUPT SERVICE ROUTINE

.ORIG x1700
ST R0, SAVER0
ST R1, SAVER1
ST R2, SAVER2
ST R3, SAVER3
ST R7, SAVER7

; CHECK THE KIND OF CHARACTER TYPED AND PRINT THE APPROPRIATE PROMPT
        LDI R1, KBDR
        
        LD R3, ASCII_LCu
        ADD R3, R1, R3
        BRP ISSYMBOL
        
        LD R3, ASCII_LCl
        ADD R3, R1, R3
        BRN <61
        
        ;PRINT “Wash your Hands frequently” 
        LEA R0, STRING2
BACK1   LDR R2, R0, #0
        BRZ end
        ;OUT
POLL1   LDI R7, DSRPtr
        BRZP POLL1
        STI R2, DDRPtr
        ADD R0, R0, #1
        BR BACK1
        
        
<61     LD R3, ASCII_UCu
        ADD R3, R1, R3
        BRP ISSYMBOL
        
        LD R3, ASCII_UCl
        ADD R3, R1, R3
        BRN <41
        
        ;PRINT “Practice Social Distancing”
        LEA R0, STRING1
BACK2   LDR R2, R0, #0
        BRZ end
        ;OUT
POLL2   LDI R7, DSRPtr
        BRZP POLL2
        STI R2, DDRPtr
        ADD R0, R0, #1
        BR BACK2
        
        
<41     LD R3, ASCII_NUMu    
        ADD R3, R1, R3
        BRP ISSYMBOL
        
        LD R3, ASCII_NUMl    
        ADD R3, R1, R3
        BRN ISSYMBOL
        
        ;PRINT “Stay Home, Stay Safe”
        LEA R0, STRING3
BACK3   LDR R2, R0, #0
        BRZ end
        ;OUT
POLL3   LDI R7, DSRPtr
        BRZP POLL3
        STI R2, DDRPtr
        ADD R0, R0, #1
        BR BACK3
        
        
ISSYMBOL    ;PRINT "----------- End of EE306 Labs ^^ -----------"
        LEA R0, STRING4
BACK4   LDR R2, R0, #0
        BRZ STOP
        ;OUT
POLL4   LDI R7, DSRPtr
        BRZP POLL4
        STI R2, DDRPtr
        ADD R0, R0, #1
        BR BACK4

STOP HALT

end LD R0, SAVER0
    LD R1, SAVER1
    LD R2, SAVER2
    LD R3, SAVER3 
    LD R7, SAVER7
    RTI



ASCII_LCu  .FILL x-7A
ASCII_LCl  .FILL x-61

ASCII_UCu  .FILL x-5A
ASCII_UCl  .FILL x-41

ASCII_NUMu .FILL x-39
ASCII_NUMl .FILL x-30

KBDR .FILL xFE02
DSRPtr .FILL xFE04
DDRPtr .FILL xFE06

STRING1 .STRINGZ "\nPractice Social Distancing\n"
STRING2 .STRINGZ "\nWash your Hands frequently\n"
STRING3 .STRINGZ "\nStay Home, Stay Safe\n"
STRING4 .STRINGZ "\n ---------- END OF EE306 LABS -------------\n"
SAVER0 .BLKW x1
SAVER1 .BLKW x1
SAVER2 .BLKW x1
SAVER3 .BLKW x1
SAVER7 .BLKW x1
.END


; USER PROGRAM

.ORIG x3000


; MAIN USER PROGRAM
; PRINT THE MESSAGE "WHAT STARTS HERE CHANGES THE WORLD" WITH A DELAY LOGIC
LOOP1   LD R2, CNT
LOOP2   ADD R2, R2, #-1
        BRNP LOOP2
        
        LEA R0, MESSAGE
        PUTS
        BR LOOP1


CNT .FILL xFFFF
KBSR_Ptr .FILL xFE00
KBDR_Ptr .FILL xFE02
DSR_Ptr .FILL xFE04
DDR_Ptr .FILL xFE06
MESSAGE .STRINGZ  "WHAT STARTS HERE CHANGES THE WORLD\n"
.END