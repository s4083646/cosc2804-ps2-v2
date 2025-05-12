        .ORIG   x3000

        TRAP    x29
        ADD     R4, R0, #0      

        AND     R5, R5, #0     
        LD      R7, COUNT       

READ1
        BRz     DONE1
        ADD     R0, R4, R7     
        TRAP    x2B             
        ADD     R5, R5, R5     
        AND     R3, R3, #1     
        BRz     SKIP1
        ADD     R5, R5, #1    
SKIP1
        ADD     R7, R7, #-1    
        BRnzp   READ1
DONE1


        ADD     R2, R2, #1      
        AND     R6, R6, #0      
        LD      R7, COUNT       

READ2
        BRz     DONE2
        ADD     R0, R4, R7
        TRAP    x2B            
        ADD     R6, R6, R6     
        AND     R3, R3, #1
        BRz     SKIP2
        ADD     R6, R6, #1
SKIP2
        ADD     R7, R7, #-1
        BRnzp   READ2
DONE2


        ADD     R7, R5, R6      
        TRAP    x27            


        ADD     R6, R7, #0     


        TRAP    x29            
        ADD     R0, R0, #1     
        ADD     R2, R2, #2     

        LD      R7, COUNT       
        AND     R4, R4, #0
        ADD     R4, R4, #1     

WRITE
        BRz     DONE_WRITE
        AND     R3, R6, R4      
        BRz     WRITE_AIR

        AND     R3, R3, #0
        ADD     R3, R3, #1
        TRAP    x2C            
        BRnzp   NEXT

WRITE_AIR
        
        AND     R3, R3, #0
        TRAP    x2C             

NEXT
        ADD     R0, R0, #1    
        ADD     R4, R4, R4    
        ADD     R7, R7, #-1  
        BRnzp   WRITE
DONE_WRITE

        HALT

COUNT   .FILL   x0010
        .END
