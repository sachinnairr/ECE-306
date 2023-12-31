.ORIG x3000
LD R0, BASE
LD R1, BASE
ADD R1, R1, #1
LD R5, MASK1


LOOP1
    
LDR R2, R0, #0
AND R6, R2, R5
BRz STOP

LOOP2
    
LDR R2, R0, #0
LDR R3, R1, #0
AND R6, R3, R5
BRnp SWAP
ADD R0, R0, #1
ADD R1, R0, #1
BR LOOP1
    
SWAP
JSR COMPARE
ADD R4, R4, #0
BRz SWAPDONE
STR R2, R1, #0 
STR R3, R0, #0
    
SWAPDONE
ADD R1, R1, #1
BR LOOP2

    
STOP  HALT
    
BASE .FILL x4004
MASK1 .FILL xFF00
MASK2 .FILL x00FF
STORE .FILL x6000
    
    
COMPARE


LD R6, STORE 
STR R0, R6, #0 
STR R1, R6, #1 
STR R2, R6, #2 
STR R3, R6, #3 
STR R5, R6, #5 
STR R6, R6, #6
LD R0, MASK2

AND R4, R4, #0
AND R5, R2, R0
AND R6, R3, R0
        
NOT R6, R6
ADD R6, R6, #1
        
ADD R5, R5, R6
        
BRnz RESTORE
        
ADD R4, R4, #1
    
RESTORE
    
LD R6, STORE
LDR R0, R6, #0
LDR R1, R6, #1
LDR R2, R6, #2
LDR R3, R6, #3
LDR R5, R6, #5
LDR R6, R6, #6
RET
.END