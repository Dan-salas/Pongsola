    # Dirección base de la matriz
    li a0, LED_MATRIX_0_BASE   

    # Valores fijos
    li s0, 0xFFF               # LED encendido
    li s1, LED_MATRIX_0_HEIGHT # Altura
    li s2, LED_MATRIX_0_WIDTH  # Ancho
    li s7, -1                  # Constante para invertir dirección

    # Posición inicial
    li s3, 17                  # X centrado
    li s4, 12                  # Y centrado

    # Dirección inicial aleatoria (basado en bits de la posición)
    li t0, 0x12345678          # prueba para poner algo "aleatorio"
    andi t1, t0, 1             # bit 0: dirección X
    andi t2, t0, 2             # bit 1: dirección Y
    li s5, 1                   # Dirección X
    li s6, 1                   # Dirección Y
    beqz t1, neg_x
    beqz t2, neg_y
    j start_loop

neg_x:
    li s5, -1
neg_y:
    li s6, -1

start_loop:

loop_movimiento:
    # Apagar LED en posición actual
    mul t1, s4, s2
    add t1, t1, s3
    slli t1, t1, 2
    add t1, a0, t1
    li t2, 0x00
    sw t2, 0(t1)

    # Actualizar posición
    add s3, s3, s5  # X += dir_x
    add s4, s4, s6  # Y += dir_y

    # Rebotar si toca borde horizontal (X)
    blt s3, zero, invert_x          # Si X < 0
    addi t0, s2, -1                 # t0 = columnas - 1
    bgt s3, t0, invert_x            # Si X > columnas - 1

    # Rebotar si toca borde vertical (Y)
    blt s4, zero, invert_y          # Si Y < 0
    addi t0, s1, -1                 # t0 = filas - 1
    bgt s4, t0, invert_y            # Si Y > filas - 1

    j continuar

invert_x:
    mul s5, s5, s7                  # Invertir dir_x
    add s3, s3, s5                  # Retroceder un paso
invert_y:
    mul s6, s6, s7                  # Invertir dir_y
    add s4, s4, s6

continuar:
    # Encender LED en nueva posición
    mul t1, s4, s2
    add t1, t1, s3
    slli t1, t1, 2
    add t1, a0, t1
    sw s0, 0(t1)

    j loop_movimiento
