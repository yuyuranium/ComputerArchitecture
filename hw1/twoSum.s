.data
size:   .word 8
num:    .word 2, 3, 5, 7, 11, 13, 17, 19
target: .word 18
str1:   .string "numbers = "
str2:   .string "\ntarget = "
str3:   .string "sol = "
lf:     .string "\n"
ws:     .string " "
sol:    .dword 0

.text
main:
        addi    sp, sp, -12
        sw      ra, 8(sp)       # save sp
        la      t0, num
        sw      t0, 4(sp)

        # print "numbers = "
        la      a0, str1
        li      a7, 4
        ecall

        # First for loop
        li      t1, 0           # i = 0
        li      t4, 8
L_for0:
        bge     t1, t4, L_for0E

        # Calculate the address of numbers[i] and print the value
        slli    t5, t1, 2
        add     t2, t0, t5
        lw      a0, 0(t2)
        li      a7, 1
        ecall

        # Print " "
        la      a0, ws
        li      a7, 4
        ecall

        # ++i
        addi    t1, t1, 1
        j       L_for0
L_for0E:
        addi    x0, x0, 0

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

        lw      a0, 4(sp)
        li      a1, 8
        addi    a3, sp, 0
        jal     ra, twoSum
        mv      s0, a0          # sol

        # Print "sol = "
        la      a0, str3
        li      a7, 4
        ecall

        # Second for loop
        li      t0, 0
        lw      t1, 0(sp)
L_for1:
        bge     t0, t1, L_for1E

        # Calculate the address of sol[i] and print the value
        slli    t2, t0, 2
        add     t2, s0, t2
        lw      a0, 0(t2)  # sol[i]
        li      a7, 1
        ecall

        # Print " "
        la      a0, ws
        li      a7, 4
        ecall

        # ++i
        addi    t0, t0, 1
        j       L_for1
L_for1E:
        # Print "\n"
        la      a0, lf
        li      a7, 4
        ecall
        
        lw      ra, 8(sp)
        addi    sp, sp, 12

        # Exit program
        li a7, 10
        ecall

# a0: numbers
# a1: numbersSize
# a2: target
# a3: &returnSize
twoSum:
        addi    sp, sp, -4
        sw      ra, 0(sp)

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
        add     t4, t2, t3
        bge     t4, a2, L_else0
        addi    s0, s0, 1
        j       L_if0E
L_else0:
        bge     a2, t4, L_else1
        addi    s1, s1, -1
        j       L_if0E
L_else1:
        la      a0, sol
        addi    t0, s0, 1
        addi    t1, s1, 1
        sw      t0, 0(a0)
        sw      t1, 4(a0)
        li      t0, 2
        sw      t0, 0(a3)
        lw      ra, 0(sp)
        addi    sp, sp, 4
        jr      ra
L_if0E:
        j       L_while
