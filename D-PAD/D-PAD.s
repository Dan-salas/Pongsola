# C�digo de dibujo de p�xel con movimiento usando el D-PAD

li a0, LED_MATRIX_0_BASE   # Direcci�n base de la matriz de LEDs
li a1, LED_MATRIX_0_WIDTH  # Ancho de la matriz
li a2, LED_MATRIX_0_HEIGHT # Alto de la matriz

# Posici�n inicial del primer p�xel (comienza en la fila 0, columna 2)
li s0, 0    # Fila (Y) del primer p�xel
li s1, 2    # Columna (X) del primer p�xel

# Color del p�xel (Formato RGB 24 bits: 0xRRGGBB)
li s2, 0xFF0000   # Rojo 
li s3, 0x000000   # Color de apagado (negro) 

# Bucle infinito
loop:
    # Leer estado del D-PAD
    lw t0, D_PAD_0_DOWN   # Bot�n Abajo
    lw t1, D_PAD_0_UP     # Bot�n Arriba
    lw t3, D_PAD_0_LEFT   # Bot�n Izquierda
    lw t4, D_PAD_0_RIGHT  # Bot�n Derecha

    # Movimiento en funci�n de los botones presionados
    bnez t0, moveDown     
    bnez t1, moveUp       
    bnez t3, moveLeft     
    bnez t4, moveRight    

    # Continuar en el bucle
    j loop

moveDown:
    # Borrar la posici�n anterior 
    jal erasePixel  
    addi s0, s0, 1   # Mover hacia abajo
    bge s0, a2, resetPos  # Verificar l�mites
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
    # Calcular la direcci�n del p�xel actual y apagarlo
    mul t2, s0, a1       
    add t2, t2, s1       
    slli t2, t2, 2       
    add t2, t2, a0       
    sw s3, 0(t2)         
    sw s3, 4(t2)
    ret

drawPixel:
    # Calcular la nueva direcci�n y dibujar el p�xel
    mul t2, s0, a1       
    add t2, t2, s1       
    slli t2, t2, 2       
    add t2, t2, a0       
    sw s2, 0(t2)         
    sw s2, 4(t2)
    ret

resetPos:
    # Resetear la posici�n a un estado v�lido
    li s0, 0
    li s1, 2
    j loop


