li t0, 0x00000004
li t1, 12
sw t1, 0(t0)
li t2, 18
sw t2, 4(t0)
lw t3, 0(t0)
lw t4, 4(t0)
blt, t1, t2, dallanma_1
add t5, t3, t4
sw t5, 8(t0)
jal zero, 12
dallanma_1:
mul t5, t3, t4
sw t5, 8(t0)
sub t3, t5, t2
sw t3, 12(t0)
bne t3, t2, dallanma_2
xor, t1, t2, t3
sw t1, 16(t0)
jal zero, 12
dallanma_2:
add t4, t3, t2
sw t4, 16(t0)
mul t4, t4, t2
sw t4, 20(t0)
