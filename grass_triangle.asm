        .ORIG x3000

; === Get player position ===
        getp              ; getp
        reg            ; debug reg dump

        ST R0, PX             ; Save player X
        ST R1, PY             ; Save player Y
        ST R2, PZ             ; Save player Z

        LD R4, Z_DIST         ; Number of rows 3
        LD R3, BLOCK_ID_GRASS ; Block ID

        AND R5, R5, #0         
        ADD R5, R5, R4        ; R5 = starting row index

; === Row Loop ===
ROW_LOOP
        LD R1, PY
        ADD R1, R1, #-1       ; Y = PY - 1

        LD R0, PX
        ADD R0, R0, R5        ; X = PX + R5 (structure grows toward +X)

        ; offset = Z_DIST - R5
        LD R7, Z_DIST           ; get the total layes from z dist
        NOT R6, R5              
        ADD R6, R6, #1          ; R6 = -R5
        ADD R6, R6, R7        ; R6 = total - current = how far it needs to spread from the center

        ; Z = PZ - offset (start at left)
        LD R2, PZ
        NOT R7, R6
        ADD R7, R7, #1
        ADD R2, R2, R7        ; ; R2 = PZ - spread → start placing blocks at the leftmost position

        ; block_count = 2 * offset + 1
        ADD R7, R6, R6         ; R7 = spread × 2
        ADD R7, R7, #1         ; R7 = 2 * spread + 1 = total number of blocks in this row
        ST R7, BLOCK_COUNT     ; store that in memory for use in the block placement loop

CLEAR_COUNTER
        AND R6, R6, #0        ; counter = 0

; === Block Loop ===
BLOCK_LOOP
        LD R3, BLOCK_ID_GRASS
        setb             ; setb at (R0, R1, R2)

        ADD R2, R2, #1        ; Z++
        ADD R6, R6, #1        ; counter++

        LD R7, BLOCK_COUNT
        NOT R7, R7
        ADD R7, R7, #1
        ADD R7, R7, R6

        BRn BLOCK_LOOP

        ADD R5, R5, #-1
        BRzp ROW_LOOP

        HALT

; === Data ===
PX              .BLKW 1
PY              .BLKW 1
PZ              .BLKW 1
BLOCK_COUNT     .BLKW 1
Z_DIST          .FILL #3
BLOCK_ID_GRASS  .FILL #2

        .END
