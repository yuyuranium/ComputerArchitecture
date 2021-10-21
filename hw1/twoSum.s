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
        li      a7, 4
        ecall

        # First for loop
        li      s1, 0           # i = 0
        li      a1, 8           # size = 8
        j       L_for0C
L_for0:
        # Calculate the address of numbers[i] and print the value
        slli    t1, s1, 2
        add     t1, s0, t1
        lw      a0, 0(t1)
        li      a7, 1
        ecall

        # Print " "
        la      a0, ws
        li      a7, 4
        ecall

        addi    s1, s1, 1       # ++i
L_for0C:
        blt     s1, a1, L_for0
L_for0E:

        # Print "target = "
        la      a0, str2
        li      a7, 4
        ecall

        # Print the value of target
        lw      a2, target
        mv      a0, a2
        li      a7, 1
        ecall

        # Print "\n"
        la      a0, lf
        li      a7, 4
        ecall

        # Call subroutine twoSum
        mv      a0, s0          # num
        addi    a3, sp, 0       # &returnSize = 0(sp)
        jal     ra, twoSum
        mv      s0, a0          # sol

        # Print "sol = "
        la      a0, str3
        li      a7, 4
        ecall

        # Second for loop
        li      s1, 0           # i = 0
        lw      t1, 0(sp)
        j       L_for1
L_for1:
        # Calculate the address of sol[i] and print the value
        slli    t2, s1, 2
        add     t2, s0, t2
        lw      a0, 0(t2)       # sol[i]
        li      a7, 1
        ecall

        # Print " "
        la      a0, ws
        li      a7, 4
        ecall

        addi    s1, s1, 1       # ++i
L_for1C:
        blt     s1, t1, L_for1
L_for1E:
        # Print "\n"
        la      a0, lf
        li      a7, 4
        ecall
        
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
        sw      s0, 0(sp)
        sw      s1, 4(sp)
        sw      ra, 8(sp)

        # p = 0, r = numbersSize - 1
        addi    s0, zero, 0
        addi    s1, a1, -1
L_while:
        slli    t0, s0, 2
        slli    t1, s1, 2
        add     t0, a0, t0
        add     t1, a0, t1
        lw      t2, 0(t0)
        lw      t3, 0(t1)
        add     t4, t2, t3      # sum = numbers[p] + numbers[r]
        bge     t4, a2, L_else0
        addi    s0, s0, 1       # ++p
        j       L_if0E
L_else0:
        bge     a2, t4, L_else1
        addi    s1, s1, -1      # --r
        j       L_if0E
L_else1:
        la      a0, sol         # fake malloc
        addi    t0, s0, 1       # p + 1
        addi    t1, s1, 1       # r + 1
        sw      t0, 0(a0)       # sol[0] = p + 1
        sw      t1, 4(a0)       # sol[1] = r + 1
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
