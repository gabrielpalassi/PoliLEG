; GCD for PoliLEGv8 in assembly (binary content is in the rom.dat file)

; PoliLEGv8 assembly syntax/behaviour

; LDUR Rt, [Rn + address]  -   Rt = Memory[Rn + address]
; STUR Rt, [Rn + address]  -   Memory[Rn + address] = Rt
; CBZ Rt, address          -   if (Rt == 0) goto (PC + address)
; B address                -   goto (PC + address)
; ADD Rd, Rn, Rm           -   Rd = Rn + Rm
; SUB Rd, Rn, Rm           -   Rd = Rn - Rm
; AND Rd, Rn, Rm           -   Rd = Rn AND Rm (bit by bit)
; ORR Rd, Rn, Rm           -   Rd = Rn OR Rm (bit by bit)

LDUR X0, [XZR, #0]  ; X0 = 10000000 (goes to position (0 + 0) of the RAM and throws whats in there (10000000) in X0)
LDUR X1, [XZR, #8]  ; X1 = A (A is the contents of the second position of the RAM (0 + 8 because word size is 8 bits))
LDUR X2, [XZR, #16] ; X2 = B (B is the contents of the third position of the RAM)
SUB X9, X1, X2      ; X9 = A - B
CBZ X9, #7          ; If X9 == 0 goes to instruction 12 (5(current) + 7)
AND X9, X9, X0      ; X9 = X3 AND X0
CBZ X9, #3          ; If X9 == 0 goes to instruction 10 (7(current) + 3)
SUB X2, X2, X1      ; B = B - A
B #-5               ; Goes to instruction 4 (9(current) - 5)
SUB X1, X1 ,X2      ; A = A - B
B #-7               ; Goes to instruction 4 (11(current) - 7)
STUR X1, [XZR, #0]  ; throws A in the firt position of the RAM (A has the value of the GCD of A and B)

; When translating to PoliLEGv8 binary (32 bit instructions):

; D-format (LDUR, STUR) (op is always 00 for the implemented instructions)
;
; 31-21    20-12   11-10   9-5     4-0
; opcode   adress  op      Rn      Rt
; 11 bits  9 bits  2 bits  5 bits  5 bits

; R-format (ADD, SUB, AND, ORR) (shamt is always 000000 for the implemented instructions)
;
; 31-21    20-16   15-10   9-5     4-0
; opcode   Rm      shamt   Rn      Rd
; 11 bits  5 bits  6 bits  5 bits  5 bits

; CB-format (CBZ)
;
; 31-24    23-5    4-0
; opcode   adress  Rt
; 8 bits   19 bits 5 bits

; B-format (B)
;
; 31-26    25-0
; opcode   adress
; 6 bits   26 bits
