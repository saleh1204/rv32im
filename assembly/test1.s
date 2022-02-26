.globl __start
.text
__start:
addi x1, x0, 5
addi x2, x1, 10
add x3, x1, x2
lui x4, 0x12233
auipc x5, 4
jal x1, label
slti x6, x3, 30
slt x7, x1, x2
xori x8, x0, -1
xor x9, x8, x1
ori x10, x0, 9
or x11, x10, x9
andi x12, x11, 0xf
and x13, x12, x11
sub x14, x1, x2
slli x2, x1, 1
sll x3, x1, x10
srli x4, x11, 4
srl x5, x11, x10
srai x6, x11, 4
sra x7, x11, x10
addi x1, x0, 5
addi x2, x0, 10
mul x3, x1, x2
lui x1, 0x80000
addi x2, x0, 0x0505
sw x2, 0(x1)
end:
jal x0, end

label:
jalr x0, x1, 0