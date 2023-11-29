
.ORIG x3000 
    
    
LD R0, BASE ;skip to 4500
LDR, R1, R0, #1  ;load num2
LDR R0, R0, #0  ;load num1


    
LD, R2, MASK ; create mask 
AND R0, R0, R2 ; mask num1
AND R1, R1, R2 ; mask num2
    
    
ADD R3, R0, R1 ;add num1 and num2 in R3
    
    
NOT R4, R1 ;-num2
ADD R4, R4, #1
    
ADD R4, R0, R4  ;add  -num2 to numb1, store in R4
    
LD R0, BASE ;reset R0
STR R3, R0, #2  ;store into x4502
STR R4, R0, #3  ;store into x4503
    
HALT    
    
BASE .FILL x4500  
MASK .FILL x00FF    

.END

;TEST CODE BELOW I USED 

;.ORIG x4500
;.fill #5
;.fill #2
;.END