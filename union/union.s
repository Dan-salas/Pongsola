# C?digo de dibujo de p?xel con movimiento usando el D-PAD
    # Valores fijos
li a0, LED_MATRIX_0_BASE   # Direcci?n base de la matriz de LEDs
li a1, LED_MATRIX_0_WIDTH  # Ancho de la matriz
li a2, LED_MATRIX_0_HEIGHT # Alto de la matriz
#li s10, 0xFFF               # LED encendido
li a3, -1                  # Constante para invertir direccion

#dibujar marco
#------------------------------------------------------
#limites del marco en y
li a5, 2
li a6, 22

#Puntaje de marcador
li s10, 0
li s11, 0

#Posicion marcador
li a4, 0 #columna 0
li a7, 34 #columna 34

#Dibujo cancha
li t1, 0
li t2, 35
li t3, 0xFFFFFF
addi t6, a5, -1
Draw_cancha: 
    mul t4, t6, a1
    add t4, t4, t1
    slli t4, t4, 2
    add t4, t4, a0
    mul t5, a6, a1
    add t5, t5, t1
    slli t5, t5, 2
    add t5, t5, a0
    sw t3, 0(t4)
    sw t3, 140(t5)
    addi t1, t1, 1
    blt t1, t2, Draw_cancha
#------------------------------------------------------
valor_inicial:
#BOLA
#------------------------------------------------------
# Posici?n inicial bola
li s8, 16                  # X centrado bola
li s9, 11                  # Y centrado bola

# Direcci?n inicial (basado en bits de la posici?n)
li s6, 1                   # Direcci?n X
li s7, 1                   # Direcci?n Y
#-----------------------------------------------------

#Barras
#-----------------------------------------------------
# Primera posici?n del p?xel 
li s0, 10    # Fila (Y) del primer p?xel
li s1, 3    # Columna (X) del primer p?xel

# Segunda posici?n del p?xel 
li s4, 10    # Fila (Y) del segundo p?xel
li s5, 31    # Columna (X) del segundo p?xel

# Color del p?xel 
li s2, 0xFFC100   # Rojo (0xFF0000 = RGB(255,0,0))
li s3, 0x000000   # Color de apagado (negro) 0x000000 = RGB(0,0,0)


iniciarpixel:
    jal drawPixel1
    jal drawPixel2
#-------------------------------------------------------

# Bucle infinito
#Barras
#-----------------------------------------------------
loopbarra:
    # Leer estado del D-PAD
    lw t0, D_PAD_0_DOWN   # Bot?n "Abajo" (afecta s0, s1)
    lw t1, D_PAD_0_UP     # Bot?n "Arriba" (afecta s0, s1)
    lw t3, D_PAD_0_LEFT   # Bot?n "Izquierda" (afecta s4, s5)
    lw t4, D_PAD_0_RIGHT  # Bot?n "Derecha" (afecta s4, s5)

    # Movimiento en funci?n de los botones presionados
    bnez t0, moveLeft     
    bnez t1, moveUp       
    bnez t3, moveDown     
    bnez t4, moveRight 
    j loopbola   
#-----------------------------------------------------

#Bola
#----------------------------------------------------
loopbola:
    # Apagar LED en posici?n actual
    mul t1, s9, a1
    add t1, t1, s8
    slli t1, t1, 2
    add t1, a0, t1
    li t2, 0x00
    sw t2, 0(t1)

    # Actualizar posici?n
    add s8, s8, s6  # X += dir_x
    add s9, s9, s7  # Y += dir_y

       # --- Detección de colisión con las barras ---
    # Colisión con barra izquierda (s1 = columna izquierda, s0 = fila)
    li t3, 1       # Margen de colisión (ajustable)
    add t4, s1, t3 # s1 + margen
    bge s8, s1, check_left_bar  # Si bola_x >= barra_x
    j check_right_bar

    check_left_bar:
    ble s8, t4, check_left_y  # Si bola_x <= barra_x + margen
    j check_right_bar

    check_left_y:
    # Verificar si la bola está dentro del rango vertical de la barra (altura = 5)
    bge s9, s0, check_left_y_max  # Si bola_y >= barra_y
    j check_right_bar

    check_left_y_max:
    addi t5, s0, 5       # barra_y + altura_barra
    ble s9, t5, invert_x  # Si bola_y <= barra_y + altura ? rebota
    j check_right_bar

    check_right_bar:
    # Colisión con barra derecha (s5 = columna derecha, s4 = fila)
    li t3, 1       # Margen de colisión (ajustable)
    add t4, s5, t3 # s5 + margen
    bge s8, s5, check_right_bar_cont
    j check_bordes

    check_right_bar_cont:
    ble s8, t4, check_right_y
    j check_bordes

    check_right_y:
    bge s9, s4, check_right_y_max
    j check_bordes

    check_right_y_max:
    addi t5, s4, 5       # barra_y + altura_barra
    ble s9, t5, invert_x
    j check_bordes

    check_bordes:
    # --- Verificación original de bordes horizontales (puntos) ---
    blt s8, zero, punto_Pj2          # Si X < 0 ? punto jugador 2
    addi t0, a1, -1                 # t0 = columnas - 1
    bgt s8, t0, punto_Pj1            # Si X > columnas - 1 ? punto jugador 1

    # Rebotar si toca borde vertical (Y)
    blt s9, a5, invert_y          # Si Y < 1
    addi t0, a2, -1                 # t0 = filas - 1
    bgt s9, a6, invert_y            # Si Y > 22

    jal continuar
#----------------------------------------------------
    
    # Continuar en el bucle
    j loopbarra
    
#Bola
#----------------------------------------------------------
invert_x:
    mul s6, s6, a3                  # Invertir dir_x
    add s8, s8, s6                  # Retroceder un paso
    mul t1, s7, a3
    add s9, s9, t1
    j continuar
invert_y:
    mul s7, s7, a3                  # Invertir dir_y
    add s8, s8, s7
    add s9, s9, s7
    j continuar
continuar:
    # Encender LED en nueva posici?n
    mul t1, s9, a1
    add t1, t1, s8
    slli t1, t1, 2
    add t1, a0, t1
    li t6, 0xFFF
    sw t6, 0(t1)
    ret
#----------------------------------------------------------   
    
#Barra
#----------------------------------------------------------
moveDown:
    jal erasePixel1  
    addi s0, s0, 1   # Mover hacia abajo el primer píxel
    li t5, 20        # Límite inferior (ajusta este valor según necesites)
    bge s0, t5, setBottom1  # Si alcanza el límite, fijar en posición inferior
    jal drawPixel1
    j loopbarra

setBottom1:
    li s0, 20        # Fijar en posición límite inferior
    jal drawPixel1
    j loopbarra

moveUp:
    jal erasePixel1
    addi s0, s0, -1  # Mover hacia arriba el primer píxel
    li t5, 0         # Límite superior
    blt s0, t5, setTop1  # Si alcanza el límite, fijar en posición superior
    jal drawPixel1
    j loopbarra

setTop1:
    li s0, 0         # Fijar en posición límite superior
    jal drawPixel1
    j loopbarra

moveLeft:
    jal erasePixel2
    addi s4, s4, 1   # Mover hacia abajo el segundo píxel
    li t5, 20        # Límite inferior (mismo que para la primera barra)
    bge s4, t5, setBottom2
    jal drawPixel2
    j loopbarra

setBottom2:
    li s4, 20        # Fijar en posición límite inferior
    jal drawPixel2
    j loopbarra

moveRight:
    jal erasePixel2
    addi s4, s4, -1  # Mover hacia arriba el segundo píxel
    li t5, 0         # Límite superior
    blt s4, t5, setTop2
    jal drawPixel2
    j loopbarra

setTop2:
    li s4, 0         # Fijar en posición límite superior
    jal drawPixel2
    j loopbarra

erasePixel1:
    # Borrar p?xel en (s0, s1)
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
    # Dibujar p?xel en (s0, s1)
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
    # Borrar p?xel en (s4, s5)
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
    # Dibujar p?xel en (s4, s5)
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
    # Resetear la posici?n del primer p?xel
    li s0, 0
    li s1, 2
    j loopbola

resetPos2:
    # Resetear la posici?n del segundo p?xel
    li s4, 0
    li s5, 4
    j loopbola
#------------------------------------------------------------

#Contador
#------------------------------------------------------------
punto_Pj1:
    li t6, 3
    li t3, 0xFF0000 
    addi s10, s10, 1
    # Dibujar p?xel en (a4, a2-1--->t4)
    addi t4, a2, -1
    mul t2, t4, a1       
    add t2, t2, a4       
    slli t2, t2, 2       
    add t2, t2, a0       
    sw t3, 0(t2) 
    addi a4, a4, 1
    beq s10, t6, finalizar
    #Borrar todo
    jal borrar_bola
    jal erasePixel1
    jal erasePixel2       
    j valor_inicial 

punto_Pj2:
    li t6, 3
    li t3, 0xFF0000
    addi s11, s11, 1
    # Dibujar p?xel en (a7, a2-1--->t4)
    addi t4, a2, -1
    mul t2, a4, a1       
    add t2, t2, a7       
    slli t2, t2, 2       
    add t2, t2, a0       
    sw t3, 0(t2)
    addi a7, a7, -1
    beq s11, t6, finalizar
    #Borrar todo
    jal borrar_bola
    jal erasePixel1
    jal erasePixel2      
    j valor_inicial
    
borrar_bola:
    mul t1, s9, a1
    add t1, t1, s8
    slli t1, t1, 2
    add t1, a0, t1
    li t2, 0x00
    sw t2, 0(t1)
    ret
#------------------------------------------------------------
finalizar:
    j finalizar
    
