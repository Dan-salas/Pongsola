    # Definir direcciones base de la matriz (ajustar seg?n sea necesario)
    li a0, LED_MATRIX_0_BASE   # Direccion base de la matriz
    li s0, 0xFFF               # Mascara para encender un LED
    li s1, 25                 # Altura de la matriz (n?mero de filas)
    li s2, 35                 # Ancho de la matriz (n?mero de columnas)
    li s3, 17                  # Posici0n X (columna)
    li s4, 12                  # Posici?n Y (fila)
    li s5, 1
    li s6, 1
    li s7, -1
    

loop_movimiento:
    # Calcular direcci?n de la posici?n anterior y apagar LED
    mul t1, s4, s2            # Fila * ancho
    add t1, t1, s3            # Sumar columna
    slli t1, t1, 2            # Multiplicar por 4 (acceso por palabras)
    add t1, a0, t1            # Direcci?n en memoria
    li t2, 0x00               # Valor para apagar LED anterior
    sw t2, 0(t1)              # Escribir 0x00 en la posici?n anterior

    # Actualizar posici?n 
    add s3, s3, s5            # Mover en X (derecha)
    add s4, s4, s6            # Mover en Y (abajo)

    # Mantener dentro de l?mites de la matriz
    #rem s3, s3, s2            # X = X % columnas
    #rem s4, s4, s1            # Y = Y % filas\
    
    
    # Calcular nueva direccion y encender LED
    mul t1, s4, s2
    add t1, t1, s3
    slli t1, t1, 2
    add t1, a0, t1
    sw s0, 0(t1)              # Encender LED en la nueva posici?n
    # Comprobar su est? en un borde
    
    blt s4, s1, changeDirY


    # Cambiar direccionx
    changeDirY:
    #mul s5, s5 ,s7
    #j loop_movimiento    
    
    # Repetir el ciclo
    j loop_movimiento
