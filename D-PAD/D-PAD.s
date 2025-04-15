# Código de dibujo de píxel con movimiento usando el D-PAD

li a0, LED_MATRIX_0_BASE   # Dirección base de la matriz de LEDs
li a1, LED_MATRIX_0_WIDTH  # Ancho de la matriz
li a2, LED_MATRIX_0_HEIGHT # Alto de la matriz

# Primera posición del píxel 
li s0, 0    # Fila (Y) del primer píxel
li s1, 0    # Columna (X) del primer píxel

# Segunda posición del píxel 
li s4, 0    # Fila (Y) del segundo píxel
li s5, 34    # Columna (X) del segundo píxel

# Color del píxel 
li s2, 0xFFC100   # Rojo (0xFF0000 = RGB(255,0,0))
li s3, 0x000000   # Color de apagado (negro) 0x000000 = RGB(0,0,0)

# Bucle infinito
loop:
    # Leer estado del D-PAD
    lw t0, D_PAD_0_DOWN   # Botón "Abajo" (afecta s0, s1)
    lw t1, D_PAD_0_UP     # Botón "Arriba" (afecta s0, s1)
    lw t3, D_PAD_0_LEFT   # Botón "Izquierda" (afecta s4, s5)
    lw t4, D_PAD_0_RIGHT  # Botón "Derecha" (afecta s4, s5)

    # Movimiento en función de los botones presionados
    bnez t0, moveLeft     
    bnez t1, moveUp       
    bnez t3, moveDown     
    bnez t4, moveRight    

    # Continuar en el bucle
    j loop

moveDown:
    jal erasePixel1  
    addi s0, s0, 1   # Mover hacia abajo el primer píxel
    bge s0, a2, resetPos1  
    jal drawPixel1
    j loop

moveUp:
    jal erasePixel1
    addi s0, s0, -1  # Mover hacia arriba el primer píxel
    blt s0, zero, resetPos1  
    jal drawPixel1
    j loop

moveLeft:
    jal erasePixel2
    addi s4, s4, 1  # Mover hacia abajo el segundo píxel
    bge s4, a2, resetPos2  
    jal drawPixel2
    j loop

moveRight:
    jal erasePixel2
    addi s4, s4, -1   # Mover a la derecha el segundo píxel
    bge s4, a2, resetPos2  
    jal drawPixel2
    j loop

erasePixel1:
    # Borrar píxel en (s0, s1)
    mul t2, s0, a1       
    add t2, t2, s1       
    slli t2, t2, 2    #Desplazamiento        
    add t2, t2, a0    
    sw s3, 0(t2)         
    sw s3, 140(t2)
    sw s3, 280(t2)
    sw s3, 420(t2)
    sw s3, 560(t2)
    ret

drawPixel1:
    # Dibujar píxel en (s0, s1)
    mul t2, s0, a1       
    add t2, t2, s1       
    slli t2, t2, 2       
    add t2, t2, a0       
    sw s2, 0(t2)         
    sw s2, 140(t2)
    sw s2, 280(t2)
    sw s2, 420(t2)
    sw s2, 560(t2)
    ret

erasePixel2:
    # Borrar píxel en (s4, s5)
    mul t2, s4, a1       
    add t2, t2, s5       
    slli t2, t2, 2       
    add t2, t2, a0       
    sw s3, 0(t2)         
    sw s3, 140(t2)
    sw s3, 280(t2)
    sw s3, 420(t2)
    sw s3, 560(t2)
    ret

drawPixel2:
    # Dibujar píxel en (s4, s5)
    mul t2, s4, a1       
    add t2, t2, s5       
    slli t2, t2, 2       
    add t2, t2, a0       
    sw s2, 0(t2)         
    sw s2, 140(t2)
    sw s2, 280(t2)
    sw s2, 420(t2)
    sw s2, 560(t2)
    ret

resetPos1:
    # Resetear la posición del primer píxel
    li s0, 0
    li s1, 2
    j loop

resetPos2:
    # Resetear la posición del segundo píxel
    li s4, 0
    li s5, 4
    j loop




