li t0, 0x80000000
li t1, 0
li t2, 1
loop:
  sw t1, 0(t0)
  jal delay
  sw t2, 0(t0)
  jal delay
  j loop
delay:
  li t3, 50000000
delay_loop:
  addi t3, t3, -1
  bne t3, zero, delay_loop
  jalr zero, ra, 0