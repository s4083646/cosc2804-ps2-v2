        .ORIG x3000

        ; === Get player position ===
        TRAP x29                ; R0 = X, R1 = Y, R2 = Z
        ST R0, PLAYER_X
        ST R1, PLAYER_Y
        ST R2, PLAYER_Z

        ; === Apply offset to get base corner position ===
        LD R0, PLAYER_X
        LD R1, OFFSET_X
        ADD R0, R0, R1
        ST R0, BASE_X

        LD R0, PLAYER_Y
        LD R1, OFFSET_Y
        ADD R0, R0, R1
        ST R0, BASE_Y

        LD R0, PLAYER_Z
        LD R1, OFFSET_Z
        ADD R0, R0, R1
        ST R0, BASE_Z

        AND R7, R7, #0          ; layer = 0

LOOP_LAYER
        ; if layer >= HEIGHT → DONE
        LD R3, STAIRS_HEIGHT
        NOT R3, R3
        ADD R3, R3, #1
        ADD R3, R7, R3
        BRzp DONE

        ; Y = BASE_Y + layer
        LD R0, BASE_Y
        ADD R0, R0, R7
        ST R0, Y_CURR

        ; Z_START = BASE_Z + layer
        LD R0, BASE_Z
        ADD R0, R0, R7
        ST R0, Z_START

        ; X_START = BASE_X + 1
        LD R0, BASE_X
        ADD R0, R0, #1
        ST R0, X_START

        ; Z_COUNT = LENGTH - layer
        LD R1, STAIRS_LENGTH
        NOT R2, R7
        ADD R2, R2, #1
        ADD R1, R1, R2
        ST R1, Z_COUNT_ORIG

        ; WIDTH → X_COUNT
        LD R1, STAIRS_WIDTH
        ST R1, X_COUNT

        AND R6, R6, #0          ; X index = 0

LOOP_X
        LD R0, X_START
        ADD R0, R0, R6
        ST R0, X_CURR

        ; Reset Z_COUNT and Z_CURR
        LD R1, Z_COUNT_ORIG
        ST R1, Z_COUNT
        LD R2, Z_START
        ST R2, Z_CURR

LOOP_Z
        LD R0, X_CURR
        LD R1, Y_CURR
        LD R2, Z_CURR
        LD R3, STONE_ID
        TRAP x2C                ; setBlock(x, y, z, blockID)

        ; Z++
        LD R2, Z_CURR
        ADD R2, R2, #1
        ST R2, Z_CURR

        ; Z_COUNT--
        LD R3, Z_COUNT
        ADD R3, R3, #-1
        ST R3, Z_COUNT
        BRp LOOP_Z

        ; X++
        ADD R6, R6, #1
        LD R3, X_COUNT
        ADD R3, R3, #-1
        ST R3, X_COUNT
        BRp LOOP_X

        ; layer++
        ADD R7, R7, #1
        BRnzp LOOP_LAYER

DONE
        HALT

; === Data Section ===
PLAYER_X  .BLKW 1
PLAYER_Y  .BLKW 1
PLAYER_Z  .BLKW 1

BASE_X    .BLKW 1
BASE_Y    .BLKW 1
BASE_Z    .BLKW 1

X_START   .BLKW 1
Y_CURR    .BLKW 1
Z_START   .BLKW 1

X_CURR    .BLKW 1
Z_CURR    .BLKW 1

X_COUNT   .BLKW 1
Z_COUNT   .BLKW 1
Z_COUNT_ORIG .BLKW 1

STAIRS_WIDTH     .FILL #2
STAIRS_LENGTH    .FILL #4
STAIRS_HEIGHT    .FILL #3

OFFSET_X  .FILL #0     ; move structure 2 blocks east
OFFSET_Y  .FILL #0
OFFSET_Z  .FILL #1      ; move structure 1 block south

STONE_ID  .FILL #1

        .END
