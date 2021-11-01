.data
num:    .word 2, 3, 5, 7, 11, 13, 17, 19
target: .word 12
str1:   .string "numbers = "
str2:   .string "\ntarget = "
str3:   .string "sol = "
lf:     .string "\n"
ws:     .string " "
sol:    .word 0, 0

.text
main:
        addi    sp, sp, -16
        sw      ra, 12(sp)      # save ra
        sw      s1, 8(sp)       # num
        sw      s0, 4(sp)       # i

        la      s0, num

        # print "numbers = "
        la      a0, str1
        jal     printStr

        # First for loop
        li      s1, 0           # i = 0
        li      a1, 8           # size = 8
        j       L_for0C
L_for0:
        # Calculate the address of numbers[i] and print the value
        slli    t1, s1, 2
        add     t1, s0, t1
        lw      a0, 0(t1)
        jal     printNum
        addi    s1, s1, 1       # ++i
L_for0C:
        blt     s1, a1, L_for0
L_for0E:

        # Print "target = "
        la      a0, str2
        jal     printStr

        # Print the value of target
        lw      a2, target
        mv      a0, a2
        jal     printNum

        # Print "\n"
        la      a0, lf
        jal     printStr

        # Call subroutine twoSum
        mv      a0, s0          # num
        addi    a3, sp, 0       # &returnSize = 0(sp)
        jal     ra, twoSum
        mv      s0, a0          # sol

        # Print "sol = "
        la      a0, str3
        jal     printStr

        # Second for loop
        li      s1, 0           # i = 0
        lw      t1, 0(sp)
        j       L_for1
L_for1:
        # Calculate the address of sol[i] and print the value
        slli    t2, s1, 2
        add     t2, s0, t2
        lw      a0, 0(t2)       # sol[i]
        jal     printNum

        addi    s1, s1, 1       # ++i
L_for1C:
        blt     s1, t1, L_for1
L_for1E:
        # Print "\n"
        la      a0, lf
        jal     printStr
        
        lw      ra, 12(sp)      # save ra
        lw      s1, 8(sp)       # num
        lw      s0, 4(sp)       # i
        addi    sp, sp, 16

        # Exit program
        li a7, 10
        ecall

# a0: numbers
# a1: numbersSize
# a2: target
# a3: &returnSize
twoSum:
        addi    sp, sp, -12
        sw      s0, 0(sp)       # reserve for p
        sw      s1, 4(sp)       # reserve for q
        sw      ra, 8(sp)

        # p = numbers, q = &number[numbersSize - 1]
        mv      s0, a0
        addi    t0, a1, -1
        slli    t0, t0, 2
        add     s1, a0, t0
L_while:
        lw      t2, 0(s0)
        lw      t3, 0(s1)
        add     t4, t2, t3      # sum = *p + *q
        bge     t4, a2, L_else0
        addi    s0, s0, 4       # ++p
        j       L_if0E
L_else0:
        bge     a2, t4, L_else1
        addi    s1, s1, -4      # --r
        j       L_if0E
L_else1:
        sub     t0, s0, a0      # p - numbers
        srai    t0, t0, 2
        addi    t0, t0, 1       # + 1
        sub     t1, s1, a0      # q - numbers
        srai    t1, t1, 2
        addi    t1, t1, 1       # + 1
        la      a0, sol         # fake malloc
        sw      t0, 0(a0)
        sw      t1, 4(a0)
        li      t0, 2
        sw      t0, 0(a3)       # *returnSize = 2

        # Returning from twoSum
        lw      s0, 0(sp)
        lw      s1, 4(sp)
        lw      ra, 8(sp)
        addi    sp, sp, 12
        jr      ra
L_if0E:
        j       L_while

printStr:
        li      a7, 4
        ecall
        ret

printNum:
        li      a7, 1
        ecall
        la      a0, ws
        li      a7, 4
        ecall
        ret
