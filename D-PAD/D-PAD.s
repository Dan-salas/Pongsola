# Código de dibujo de píxel con movimiento usando el D-PAD

li a0, LED_MATRIX_0_BASE   # Dirección base de la matriz de LEDs
li a1, LED_MATRIX_0_WIDTH  # Ancho de la matriz
li a2, LED_MATRIX_0_HEIGHT # Alto de la matriz

# Posición inicial del primer píxel (comienza en la fila 0, columna 2)
li s0, 0    # Fila (Y) del primer píxel
li s1, 2    # Columna (X) del primer píxel

# Color del píxel (Formato RGB 24 bits: 0xRRGGBB)
li s2, 0xFF0000   # Rojo 
li s3, 0x000000   # Color de apagado (negro) 

# Bucle infinito
loop:
    # Leer estado del D-PAD
    lw t0, D_PAD_0_DOWN   # Botón Abajo
    lw t1, D_PAD_0_UP     # Botón Arriba
    lw t3, D_PAD_0_LEFT   # Botón Izquierda
    lw t4, D_PAD_0_RIGHT  # Botón Derecha

    # Movimiento en función de los botones presionados
    bnez t0, moveDown     
    bnez t1, moveUp       
    bnez t3, moveLeft     
    bnez t4, moveRight    

    # Continuar en el bucle
    j loop

moveDown:
    # Borrar la posición anterior 
    jal erasePixel  
    addi s0, s0, 1   # Mover hacia abajo
    bge s0, a2, resetPos  # Verificar límites
    jal drawPixel
    j loop

moveUp:
    jal erasePixel
    addi s0, s0, -1  # Mover hacia arriba
    blt s0, zero, resetPos  
    jal drawPixel
    j loop

moveLeft:
    jal erasePixel
    addi s1, s1, -1  # Mover a la izquierda
    blt s1, zero, resetPos  
    jal drawPixel
    j loop

moveRight:
    jal erasePixel
    addi s1, s1, 1   # Mover a la derecha
    bge s1, a1, resetPos  
    jal drawPixel
    j loop

erasePixel:
    # Calcular la dirección del píxel actual y apagarlo
    mul t2, s0, a1       
    add t2, t2, s1       
    slli t2, t2, 2       
    add t2, t2, a0       
    sw s3, 0(t2)         
    sw s3, 4(t2)
    ret

drawPixel:
    # Calcular la nueva dirección y dibujar el píxel
    mul t2, s0, a1       
    add t2, t2, s1       
    slli t2, t2, 2       
    add t2, t2, a0       
    sw s2, 0(t2)         
    sw s2, 4(t2)
    ret

resetPos:
    # Resetear la posición a un estado válido
    li s0, 0
    li s1, 2
    j loop


