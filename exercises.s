# Práctica 1

# Ejercicio 1

.text

Binomial_coef:
    # guardamos registros en pila
    addi sp, sp, -24
    sw ra, 20(sp)
    sw s0, 16(sp)
    sw s1, 12(sp)
    sw s2, 8(sp)
    sw s3, 4(sp)
    sw s4, 0(sp)
    
    mv s0, a0
    mv s1, a1
    # calculo n!
    li t0, 1 # resultado = 1
    li t1, 1 # contador = 1
    ble s0, zero, factorial_n_final # si n <= 0, factorial = 1
factorial_n:
    bgt t1, s0, factorial_n_final #si contador > n, termina el factorial
    mul t0, t0, t1
    addi t1, t1, 1
    j factorial_n
factorial_n_final:
    mv s2, t0
    # calculo de k! 
    li t0, 1
    li t1, 1
    ble s1, zero, factorial_k_final # si k <= 0, factorial = 1
factorial_k:
    bgt t1, s1, factorial_k_final #si contador > k, termina el factorial
    mul t0, t0, t1
    addi t1, t1, 1
    j factorial_k
factorial_k_final:
    mv s3, t0
    # calculo (n-k)! 
    sub t2, s0, s1 # t2 = n - k
    li t0, 1
    li t1, 1
    ble t2, zero, factorial_nk_final # si (n-k) <= 0, factorial = 1
factorial_nk:
    bgt t1, t2, factorial_nk_final #si contador > (n-k) , termina el factorial
    mul t0, t0, t1
    addi t1, t1, 1
    j factorial_nk
factorial_nk_final:
    mv s4, t0
    # calculo del binomio n! / (k! * (n-k)!)
    mul t0, s3, s4 # k! * (n-k)!
    div a0, s2, t0 # n! / (k! * (n-k)!)
    
    # restauramos registros 
    lw ra, 20(sp)
    lw s0, 16(sp)
    lw s1, 12(sp)
    lw s2, 8(sp)
    lw s3, 4(sp)
    lw s4, 0(sp)
    addi sp, sp, 24
    jr ra

Newton_int:
    # guardamos registros en pila
    addi sp, sp, -36
    sw ra, 32(sp)
    sw s0, 28(sp) 
    sw s1, 24(sp)
    sw s2, 20(sp) 
    fsw fs0, 16(sp)
    fsw fs1, 12(sp) 
    fsw fs2, 8(sp) 
    fsw fs3, 4(sp)
    fsw fs4, 0(sp) 
    
    mv s0, a0
    fmv.s fs0, fa0
    fmv.s fs1, fa1
    
    fcvt.s.w fs2, zero # resultado = 0
    
    li s1, 0 # k = 0
    
bucle_newton:
    # si k > n, terminamos
    bgt s1, s0, newton_final
    
    # calculamos C(n,k) usando Binomial_coef
    mv a0, s0 # n
    mv a1, s1 # k
    jal ra, Binomial_coef
    mv s2, a0 # C(n,k)
    
    # calculo a^(n-k)
    fmv.s fa0, fs0 # a
    sub a0, s0, s1 # n - k
    jal ra, pow # usamos la libreria pow
    fmv.s fs3, fa0
    
    # calculo b^k
    fmv.s fa0, fs1 # b
    mv a0, s1 # k
    jal ra, pow
    fmv.s fs4, fa0
    
    # calculamos C(n,k) * a^(n-k) * b^k
    fcvt.s.w ft0, s2
    fmul.s ft1, ft0, fs3   
    fmul.s ft1, ft1, fs4
    fadd.s fs2, fs2, ft1 # resultado += término
    
    addi s1, s1, 1 # k += 1
    j bucle_newton
    
newton_final:
    fmv.s fa0, fs2
    
    # restauramos registros
    lw ra, 32(sp)
    lw s0, 28(sp)
    lw s1, 24(sp)
    lw s2, 20(sp)
    flw fs0, 16(sp)
    flw fs1, 12(sp)
    flw fs2, 8(sp)
    flw fs3, 4(sp)
    flw fs4, 0(sp)
    addi sp, sp, 36
    
    jr ra
    
   
   
# Ejercicio 2

E:
    addi sp, sp, -20
    sw   ra, 16(sp)
    fsw  fs0, 12(sp)	# guardamos registros
    fsw  fs1, 8(sp)
    fsw  fs2, 4(sp)

    # primer término
    fmv.s fs0, fa0      

    li t0, 1            # para comenzar la serie en 1
    fcvt.s.w fs1, t0    # sum = 1
    fcvt.s.w fs2, t0    # term = 1
    li t1, 1            # contador k = 1

E_bucle:
    li t2, 20           # límite de la serie
    bge t1, t2, E_fin   # si k >= 20 salir

    # term = term * x / k
    fcvt.s.w ft0, t1    
    fmul.s fs2, fs2, fs0 # term *= x
    fdiv.s fs2, fs2, ft0 # term = term / k
    fadd.s fs1, fs1, fs2 # sum += term
    addi t1, t1, 1       # k++
    j E_bucle

E_fin:
    fmv.s fa0, fs1      # retornar sum en fa0

    # restaurar los registros
    lw   ra, 16(sp)
    flw  fs0, 12(sp)
    flw  fs1, 8(sp)
    flw  fs2, 4(sp)
    addi sp, sp, 20
    jr   ra


Arctanh:
    addi sp, sp, -20
    sw   ra, 16(sp)
    fsw  fs0, 12(sp)   
    fsw  fs1, 8(sp)    
    fsw  fs2, 4(sp)    

    fmv.s fs0, fa0     
    fmv.s fs1, fa0    
    fmv.s fs2, fa0     
    li t1, 1           

Arctanh_bucle:

    li t2, 20
    bge t1, t2, Arctanh_final

    # term = term * y * y
    fmul.s fs1, fs1, fs0
    fmul.s fs1, fs1, fs0
    # divisor = 2*k + 1
    add  t3, t1, t1   # t3 = t1 + t1 = 2*k
    addi t3, t3, 1    # t3 = 2*k + 1
    fcvt.s.w ft0, t3

    # sum += term / divisor
    fdiv.s ft1, fs1, ft0
    fadd.s fs2, fs2, ft1

    addi t1, t1, 1
    j Arctanh_bucle

Arctanh_final:
    fmv.s fa0, fs2
    					# restaurar los registros
    lw   ra, 16(sp)
    flw  fs0, 12(sp)
    flw  fs1, 8(sp)
    flw  fs2, 4(sp)
    addi sp, sp, 20
    jr   ra


Ln:
    addi sp, sp, -16
    sw   ra, 12(sp)			# guardamos registros
    fsw  fs0, 8(sp)
    fsw  fs1, 4(sp)

    fmv.s fs0, fa0          # x

							# comprobacion de NAN (si x es negativo)
    fmv.s ft0, fs0
    fsub.s ft0, ft0, ft0    
    fle.s t0, fs0, ft0      # t0 = 1 si x <= 0
    bne t0, zero, Ln_nan    # saltar si x <= 0


    li t0, 1
    fcvt.s.w ft0, t0
    fsub.s ft1, fs0, ft0  # x - 1
    fadd.s ft2, fs0, ft0  # x + 1
    fdiv.s fs1, ft1, ft2  # y = (x-1)/(x+1)

    fmv.s fa0, fs1
    jal ra, Arctanh       # llama Arctanh
    li t1, 2
    fcvt.s.w ft0, t1
    fmul.s fa0, fa0, ft0  # ln(x) = 2 * artanh(y)
    j Ln_fin              # salto para evitar ejecutar Ln_nan cuando x > 0

Ln_nan:
    li   t1, 0x7FC00000     # patrón IEEE-754 de NaN
    fmv.w.x fa0, t1         # moverlo a fa0 (resultado NaN)

Ln_fin:
    lw   ra, 12(sp)
    flw  fs0, 8(sp)
    flw  fs1, 4(sp)			#restaurar registros
    addi sp, sp, 16
    jr ra


powf:
    addi sp, sp, -24
    sw   ra, 20(sp)			# guardamos registros
    fsw  fs0, 16(sp)
    fsw  fs1, 12(sp)
							# e^(b * ln(a))
    fmv.s fs0, fa0			
    fmv.s fs1, fa1
    fmv.s fa0, fs0
    jal  ra, Ln				# fa0 = ln(a)
    fmul.s fa0, fa0, fs1	# fa0 = b * ln(a)
    jal  ra, E				# fa0 = e^(b*ln(a)) = a^b

    flw  fs1, 12(sp)
    flw  fs0, 16(sp)
    lw   ra, 20(sp)			#restaurar registros
    addi sp, sp, 24
    jr ra


Newton_real:
    addi sp, sp, -24
    sw   ra, 20(sp)
    fsw  fs0, 16(sp)
    fsw  fs1, 12(sp)		# guardamos registros
    fsw  fs2, 8(sp)
    fsw  fs3, 4(sp)
    fsw  fs4, 0(sp)

    fmv.s fs0, fa0        # fs0 = a
    fmv.s fs1, fa1        # fs1 = b
    fmv.s fs2, fa2        # fs2 = n

    # comprobación de dominio: n < 0 , devuelve NaN
    fmv.s ft0, fs2
    fsub.s ft0, ft0, ft0    
    flt.s t0, fs2, ft0      # t0 = 1 si n < 0
    bne  t0, zero, Newton_NAN   # saltar si n < 0

    # term0 = a^n
    fmv.s fa0, fs0
    fmv.s fa1, fs2
    jal   ra, powf
    fmv.s fs3, fa0
    fmv.s fs4, fs3
    li   t1, 1

Newton_bucle:
    li   t2, 20
    bge  t1, t2, Newton_fin   # salir cuando t1 >= 20

    fcvt.s.w ft0, t1
    addi t3, t1, -1
    fcvt.s.w ft1, t3		# float(k - 1)
    fsub.s ft2, fs2, ft1
    fdiv.s ft3, ft2, ft0	# n - (k - 1)
    fdiv.s ft4, fs1, fs0	# (n - (k - 1)) / k
    fmul.s fs3, fs3, ft3	# b / a
    fmul.s fs3, fs3, ft4
    fadd.s fs4, fs4, fs3
    addi t1, t1, 1
    j Newton_bucle

Newton_NAN:
    li   t1, 0x7FC00000		#Nan en igual que IEEE-754 en Ln(x)
    fmv.w.x fa0, t1

    # restaurar registros (misma secuencia que en Newton_fin)
    flw  fs4, 0(sp)
    flw  fs3, 4(sp)
    flw  fs2, 8(sp)
    flw  fs1, 12(sp)
    flw  fs0, 16(sp)
    lw   ra, 20(sp)
    addi sp, sp, 24
    jr ra
    
Newton_fin:
    fmv.s fa0, fs4

    flw  fs4, 0(sp)
    flw  fs3, 4(sp)
    flw  fs2, 8(sp)
    flw  fs1, 12(sp)	#restaurar registros
    flw  fs0, 16(sp)
    lw   ra, 20(sp)
    addi sp, sp, 24
    jr ra
  
# Ejercicio 3

Compute_pows:
    addi sp, sp, -40
    sw   ra, 36(sp)
    sw   s0, 32(sp)     
    sw   s1, 28(sp)     # guardar registros
    sw   s2, 24(sp)     
    sw   s3, 20(sp)
    fsw  fs0, 16(sp)
    fsw  fs1, 12(sp)
    fsw  fs2, 8(sp)
    
    # Guardar parámetros
    mv   s0, a0         # s0 = dirección de la matriz
    mv   s1, a1         # s1 = N
    fmv.s fs0, fa0      # fs0 = a
    fmv.s fs1, fa1      # fs1 = b
    fmv.s fs2, fa2      # fs2 = c
    
    li   s2, 0 # i = 0
    
bucle_i:
    bge  s2, s1, final  # si i >= N, terminar
    
    li   s3, 0 # j = 0
    
bucle_j:
    bge  s3, s1, cambio_fila # si j >= N, siguiente fila
    
    fcvt.s.w ft0, s2        # convertir i a float
    fadd.s fa0, fs0, ft0    # fa0 = a + i
    
    fcvt.s.w ft0, s3        # convertir j a float
    fadd.s fa1, fs1, ft0    # fa1 = b + j
    
    fmv.s fa2, fs2 # c
    
    jal  ra, Newton_real
    
    # Guardar resultado en matriz
    mul  t0, s2, s1         # t0 = i * N
    add  t0, t0, s3         # t0 = i * N + j
    li   t1, 4
    mul  t0, t0, t1         # t0 = (i * N + j) * 4
    add  t0, s0, t0         # ubicar el elemento en matriz
    
    fsw  fa0, 0(t0)
    
    addi s3, s3, 1          # j++
    j    bucle_j
    
cambio_fila:
    addi s2, s2, 1          # i++
    j    bucle_i
    
final:
    # Restaurar registros
    flw  fs2, 8(sp)
    flw  fs1, 12(sp)
    flw  fs0, 16(sp)
    lw   s3, 20(sp)
    lw   s2, 24(sp)
    lw   s1, 28(sp)
    lw   s0, 32(sp)
    lw   ra, 36(sp)
    addi sp, sp, 40
    jr   ra