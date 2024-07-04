			.area PROG (ABS)

teclado .equ 0xFF02
pantalla .equ 0xFF00
fin     .equ 0xFF01

	.org 0x100
	.globl programa

;;variables cadenas    
cadena_menu:    .ascii "\nMenu de opciones:\n"
		.ascii "\n 1) SUMA de polinomios. 2) RESTA de polinomios. 3) MULTIPLICAR por un ESCALAR."
		.ascii "\n 4) MULTIPLICAR por un monomio.  5) MULTIPLICACION de polinomios. 6) DIVISION de polinomios." 
		.ascii "\n 7) para SALIR."
		.ascii "\n Elija la opcion que quiera para estos polinomios: \n\n\0"

continue:	.ascii "PULSE INTRO PARA CONTINUAR.\n\0"
intro_opc:	.ascii "\n---------------------------------Introduzca la opcion: \0"

cadena_grado: 		.ascii "\nElija el grado de su polinomio: \0"

cadena_coeficiente: 	.ascii "\nCoeficiente de grado \0"

intro: 			.ascii ". Introduzcalo: \0"

cadena_grado_monomio: .ascii "\nElija el grado de su monomio\0"

cadena_coeficiente_monomio: .ascii "\nIntroduzca el coeficiente de su monomio\0"

cadena_resto:  .ascii "\n El resto es: \0"

cadena_cociente:  .ascii "\n El cociente es: \0"

cadena_error_rango:	.ascii "\n<error>  rango permitido entre -127 y 128\n\0"

desbordamiento: .ascii "\n<error>  ¡¡desbordamiento detectado!!!\0"

error_division: .ascii "\n El grado del segundo polinomio tiene que ser menor que el del primero.\0"



;;variables polinomios
polinom1: .rmb 129
polinom2: .rmb 129

pol_res1: .rmb 129
pol_res2: .rmb 129

	;;comienzo del programa
programa:

	ldu #0xF000	;cargamos el registro U con esa dirección

	 
	ldy #polinom1		;cargamos el registro Y con el polinomio 1
	jsr leer_polinomio	;llamamos a la subrutina para lea el polinomio

	ldy #polinom2		;cargamos el registro Y con el polinomio 2
	jsr leer_polinomio	;llamamos a la subrutina para lea el polinomio
	


bucle_menu:

	ldx #cadena_menu	;cargamos el registro X con la cadena
	jsr most_cadena	;llamamos a la subrutina para que muestre la cadena
	jsr most_polS	;llamamos a la subrutina para que muestre los polinomios
	ldx #intro_opc		;cargamos el registro X con la cadena
	jsr most_cadena	;llamamos a la subrutina para que muestre la cadena
	
	lda teclado  		;cargamos A con la dirección de teclado  
	suba #48		;restamos 48 a lo que haya en A, en este caso la dirección de teclado, 
				;sirve para meter la opcion que queramos

	cmpa #1 ;;SUMA		;comparamos con 1, si no es 1...
	bne resta		;saltamos a resta
	  ldx #polinom1	;cargamos X con el polinom1	
	  ldy #pol_res1		;cargamos Y con el pol_res1
	  jsr copiar_polinomio	;llamamos a la subrutina de copiar polinomio
	  ldx #polinom2	;cargamos X con el polinom2
	  jsr suma_pol		;llamamos y hacemos la suma

	  ldx #pol_res1		;cargamos con el polinomio resultado
	  jsr most_pol	; y lo mostramos

;;INTRO
	  ldx #continue
	  jsr most_cadena
	  lda teclado		
	  jmp bucle_menu

resta:
	cmpa #2				;comparamos con 2, si no es...
	bne mult_escalar   	;saltamos a mult por escalar
	  ldx #polinom2		;cargamos x con polinomio 2	
	  ldy #pol_res1			;cargamos y con pol_res1
	  jsr negar_polinomio		;llamamos a negar polinomio, para hacer la resta, negando polinom2
	  ldx #polinom1		;cargamos polinomio 1
	  jsr suma_pol			; y sumamos el 1 y el 2

	  ldx #pol_res1			;cargamos el resultado
	  jsr most_pol		; y lo enseñamos

;;INTRO
	  ldx #continue
	  jsr most_cadena
	  lda teclado		
	  jmp bucle_menu

	
mult_escalar:
	cmpa #3			;comparamos con 3, si no es...
	bne mult_monomio	;saltamos a mult monomio
	  jsr pedir_rango	;pedimos un numero que este dentro del rango
	  tfr b,a		;transferimos el contenido de B a A
	  ldx #polinom1	;cargamos el primer polinomio
	  ldy #pol_res1		;y el resultado
	  jsr multiplicar_escalar	;llamamos a la subrutina de multiplicar escalar
	  exg y,x		; transferimos el contenido de Y a X
	  jsr most_pol	;mostramos polinomio
	  ldx #polinom2	;cargamos como antes pero ahora con el segundo
	  ldy #pol_res1
	  jsr multiplicar_escalar	; y llamamos otra vez
	  exg y,x		;intercabiamos
	  jsr most_pol	; y mostramos

;;INTRO
	  ldx #continue
	  jsr most_cadena
	  lda teclado		
	  jmp bucle_menu

mult_monomio:
	cmpa #4					;comparamos con 4, si no es...
	bne mult_pol				;saltamos a multiplicar polinomios
	  ldx #cadena_coeficiente_monomio	;cargamos la cadena
	  jsr most_cadena			;la mostramos
	  jsr pedir_rango			;pedimos un numero que este en el rango para el grado del monomio
	  tfr b,a				;transferimos valores
	  ldx #cadena_grado_monomio		;cargamos cadena
	  jsr most_cadena			;la mostramos
	  jsr pedir_rango  			;pedimos rango para coef del monomio
	  
	  ldx #polinom1			;cargamos los polinomios 1 y resultado
	  ldy #pol_res1	
	  jsr mult_mon			;llamamos a mult monomio
	  ldx #pol_res1				;cargamos
	  jsr most_pol			;y enseñamos el resultado

	  ldx #polinom2			;y asi con el segundo
	  ldy #pol_res1
	  jsr mult_mon
	  ldx #pol_res1
	  jsr most_pol

;;INTRO

	  ldx #continue
	  jsr most_cadena
	  lda teclado		
	  jmp bucle_menu

mult_pol:

	cmpa #5			;comparamos con 5, si no es...
	bne div_pol		;saltamos a dividir polinomios
	  ldx #polinom1	;cargamos pol1, pol2 y pol_res1
	  ldy #polinom2
	  ldd #pol_res1
	  jsr mult_polinomios	;llamamos a la subrutina de multiplicar polinomios
	  ldx #pol_res1		;cargamos
	  jsr most_pol	;y enseñamos el resultado	

;;INTRO

	  ldx #continue
	  jsr most_cadena
	  lda teclado
	  jmp bucle_menu

div_pol:
	cmpa #6			;comparamos con 6, si no es...
	bne salir		;saltamos a salir
	  ldx #polinom1	;cargamos los polinomios 1 y resultado
	  ldy #pol_res1
	  jsr copiar_polinomio	;llamamos a copiar polinomio
	
	  ldx #pol_res1		;cargamos los polinomios siguientes
	  ldy #polinom2
	  ldd #pol_res2
	  jsr div_polinomios	;llamamos a la subrutina de dividir los polinomios cargados

	  ldx #cadena_cociente	;mostramos el cociente de la divison
	  jsr most_cadena
	  ldx #pol_res2
	  jsr most_pol

	  ldx #cadena_resto	;mostramos el resto de la division
	  jsr most_cadena
	  ldx #pol_res1
	  jsr most_pol

;;INTRO
	  ldx #continue
	  jsr most_cadena
	  lda teclado		
	  jmp bucle_menu

salir:
	cmpa #7		;comparamos con 7, si no es...
	bne otra_vez	;vamos a otra vez
	jmp acabar	;si es, vamos a acabar y se acaba el programa

otra_vez:
	jmp bucle_menu	;salta al principio del bucle del menu





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; most_polS   						       ;
;     saca por la pantalla los dos polinomios introducidos por teclado ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
most_polS:
	ldx #polinom1 	;cargamos x con el primer polinomio
	jsr most_pol	;llamamos y lo mostramos en pantalla
	ldx #polinom2		;lo mismo para el segundo
	jsr most_pol
	rts			;terminamos subrutina

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; most_cadena                                                   ;
;     saca por la pantalla la cadena acabada en '\0 apuntada por X ;
;                                                                  ;
;   Entrada: X-direccion de comienzo de la cadena                  ;
;   Salida:  ninguna                                               ;hecho
;   Registros afectados: X, CC.                                    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
most_cadena:
        pshs a

nuevo_char:
	lda ,x+
        beq fin_most_cadena
        sta pantalla
        bra nuevo_char

fin_most_cadena:
        puls a
        rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;      leer - pide un polinomio y lo inserta en donde apunte Y                 ;
;------------------------------------------------------------------------------;
;   Entrada: Y - dirección donde escribir el polinomio			  ;
;   Salida: (en memoria) el polinomio introducido por el usuario, comenzando   ;
;           por su grado.                                                      ;
;   Registros afectados: CC.                                                   ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
leer_polinomio:
	pshs d,x,y              ; reservamos D X e Y.

	ldd #0			; ponemos D a cero
	pshu d			; reservamos D

pedir_grado_pol:
        ldx #cadena_grado       ; mostramos la cadena
	jsr most_cadena    

	jsr pedir_rango   	; llamamos a pedir el num y que este en el rango correcto
	cmpb #0			; vemos si es mayor o igual que cero
bp0:
	blt error_grado
	tfr b,a			; tranferimos de B a A
	sta 1,u			; guardamos en U
	sta ,y			; guardamos en y lo que haya en A
bp3:
	exg x,y			;transferimos
	jsr puntero_coeficientes;llamamos a la subrutina, y apuntamos al polinomio
	exg y,x			;transferimos

bucle_introducir_coeficientes:
	ldx #cadena_coeficiente		;mostramos cadena	
	jsr most_cadena
	ldb #'\0			;cargamos B con final de cadena
	jsr mostrar_int			;mostramos el numero

	jsr pedir_rango		;pedimos num que este en e rango correcto
	stb ,y+			;guardamos en y lo que haya en b e incrementamos
bp5:	
	deca			;decrementamos A
	cmpa #0			;miestras que A 
	bge bucle_introducir_coeficientes  ;sea mayor o igual que cero repetimos esto

	
	bra acabar_pedir_polinomio	   ;saltamos al final

error_grado:
	ldx #cadena_error_rango ;mostramos cadena
	jsr most_cadena
	bra pedir_grado_pol	;saltamos a pedir grado otra vez porque es incorrecto	

acabar_pedir_polinomio:
	tst ,u++
	puls x,d,y             	;finalizamos subrutina
	rts	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       most_pol - Imprime un polinomio guardado en memoria.	                  ;
;   		Ejemplo formato salida:   -3x^4 +2x^2 +5		          ;
;------------------------------------------------------------------------------;
;  Entrada: X dirección del polinomio (debe apuntar al 1º byte, el del grado)  ;
;  Registros afectados: CC.						          ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
most_pol:
	pshs d,x,y		;reservamos memoria para los registros
	
	ldd #0		;ponemos D a 0
	pshu d		;reservamos D en la pila
	ldb ,x		;lo cargamos
	stb 1,u		;y lo guardo

	jsr puntero_coeficientes ;;llamamos a la subrutina y apuntamos al polinomio
	
	lda #'\n	;cargamos A con salto de linea
	sta pantalla	;y lo ponemos en pantalla

bucle_intro_coef:
	cmpb #0				;compruebo que B sea positivo
	ble fin_bucle_intro_coef 	;si no saltamos 
	lda ,x+				;guardamos en memoria A e incrementamos
	cmpa #0				;vemos si es positivo
	beq controlar_bucle_intro_coef	;si no saltamos 

	lda #' 				;cargamos A con espacio en blanco
	sta pantalla			;lo mostramos en pantalla
	lda -1,x			;cargamos A en memoria 
	ldb #'+   			;mostramos el signo positivo
	jsr mostrar_int			;llamamos y mostramos el entero
	ldb 1,u				;cargamos b en memoria
;;mostramos la parte de las X elevadas
	lda #'x				;cargamos A
	sta pantalla			;lo mostramos
	lda #'^				;cargamos A
	sta pantalla			;lo mostramos
	tfr b,a				;tranferimos B a A
	ldb #'\0   			;y cargamos con fin de cadena
	jsr mostrar_int			;mostramos numero
	tfr a,b				;y volvemos a tranferir

controlar_bucle_intro_coef:
	decb				;decrementamos B
	stb 1,u				;y lo guardo en memoria
	bra bucle_intro_coef		;saltamos al principio del bucle

fin_bucle_intro_coef:
	
	lda ,x				;guardamos el ultimo coeficiente
	cmpa #0				;comparamos para que no sea cero
	beq no_mostrar_si_0		;si lo fuera, saltamos

	lda #' 				;cargamos A con espacio en blanco
	sta pantalla			;lo mostramos
	lda ,x				;y guardamos en memoria
	ldb #'+   			;sacamos el signo positivo
	jsr mostrar_int			;mostramos el numero
	ldb 1,u				;y lo guardamos en memoria		
		
no_mostrar_si_0:	
	lda #'\n			;ponemos un salto de linea
	sta pantalla



	tst ,u++
	puls y,x,d			;y finalizamos la subrutina
	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; copiar_polinomio - copia un polinomio en X en una dirección Y		  ;
;------------------------------------------------------------------------------;
;  Entradas: X - Puntero al principio del polinomio (byte de grado)	          ;  
;            Y - Dirección destino (donde se insertará el byte de grado)       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
copiar_polinomio:
	pshs d,x,y
	
	lda ,x 			    ;cargamos a con el grado del polinomio
	sta ,y			    ;guardamos en y lo que cargamos antes
	jsr puntero_coeficientes    ;apuntamos al polinomio
	exg x,y			    ;cambiamos x por y
	jsr puntero_coeficientes    ;y con y apuntamos ahora al polinomio

bucle_copiar_pol:
	cmpa #0			;vamos comparando a con cero
	blt fin_copiar_pol      ;si el grado fuera menor entonces salta
	
	ldb ,y+	  		;cargamos b e incrementamos 
	stb ,x+			;y lo guardamos
	
	deca			;decrementamos a	
	bra bucle_copiar_pol	;y saltamos al comienzo


fin_copiar_pol:
	puls y,x,d		;terminamos subrutina
	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; limpiar_polinomio - establece los términos de un polinomio a 0	          ;
;------------------------------------------------------------------------------;
;  Entradas: X - Direccion del polinomio (byte de grado)		          ;
;  Salida - términos del polinomio a 0. Grado a 0			          ;
;  Registros alterados: CC						          ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
limpiar_polinomio:
	pshs d,x
	
	ldb ,x		;cargamos b en memoria
	lda #0		;ponemos a a cero
	sta ,x		;lo ponemos a cero

	jsr puntero_coeficientes	;apuntamos al polinomio	
	

bucle_limpiar: 			
	cmpb #0			;vamos comparando si es negativo
	blt fin_bucle_limpiar	;si lo fuese saltamos al final
	
	sta ,x+			;guardamos a en memoria e incrementamos
	decb			;decrementamos b
	bra bucle_limpiar	;saltamos al principio

fin_bucle_limpiar:
	puls d,x
	rts			;terminamos subrutina

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; suma_pol - suma un polinomio a otro     				          ;
;------------------------------------------------------------------------------;
;  Entradas: X - Polinomio a sumar 					          ;
;            Y - Polinomio al que se sumará (se reemplaza) 		          ;
;  Salida - mem[Y] - nuevo polinomio suma de los anteriores		          ;
;  Registros alterados: CC						          ;
;------------------------------------------------------------------------------;
; Si se pretende sumar 2 polinomios en otra dirección, sin alterar los	  ;
; originales, copiese primero uno en ella.				          ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
suma_pol:
	pshs y,x,d	;reservamos y, x y d
			
	lda #0		;ponemos a a cero
	ldb ,y		;cargamos b con y
	pshu d		;reservamos d otra vez en un sitio distinto
	ldb ,x		;cargamos d con x
	pshu d		;volvemos a reservar

	lda ,y		;cargamos los grados en a
	ldb ,x		;cargamos b 
	sta 3,u		;y los guardamos en la pila
	stb 1,u

	jsr puntero_coeficientes    ;apuntamos al polinomio
	exg y,d			    ;cambiamos valores
	addd #128		    ;sumamos 128
	subd ,u			    ;restamos el grado
	exg d,y			    ;y x e y están ajustados

;si los grados de x son mayores que los de y copiar los de x
	subb 3,u	
	pshu b		;nos quedamos con la resta anterior

bucle_sumar1: 
	cmpb #0			;vamos comparando b con 0, para ver si es negativo
	ble acabar_bucle_sumar1	;si lo fuera saltamos
	
	lda ,x+		;cargamos a e incrementamos
	sta ,y+		;y lo guardamos en y e incrementamos
	decb		;decrementamos b
	bra bucle_sumar1	;saltamos

acabar_bucle_sumar1:
;restando a la resta anterior el grado de x obtenemos las vueltas del bucle
	
	ldb 2,u		
	subb ,u+		
	
bucle_sumar2:
	cmpb #0	
	blt acabar_sumar_polinomios
	
	lda ,x+		
	adda ,y		
	sta ,y+		
	decb
	bra bucle_sumar2


acabar_sumar_polinomios:
	
	lda 1,u		
	cmpa 3,u	
	blt reducir	;ponemos en la solucion el grado del mayor

	ldx 4,s		
	sta ,x		
	
reducir:
	jsr ajustar_polinomio 	;llamamos y reducimos si se puede el polinomio

	tst ,u++	
	tst ,u++

	puls d,y,x
	rts			;terminamos la subrutina

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; negar_polinomio - obtiene el polinomio con los coef cambiados de signo       ;			  ;
;------------------------------------------------------------------------------;
;  Entradas: X - Puntero al principio del polinomio (byte de grado)	          ;
;            Y - Puntero a la dirección de destino			          ;
;  Salida: mem[Y] - Puntero negado					          ;
;  Registros alterados: CC						          ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
negar_polinomio:
	pshs d,x,y		;reservamos memoria para los registros
	
	lda ,x 				;guardamos el grado en A
	sta ,y				;cargamos en memoria A
	jsr puntero_coeficientes	;llamamos y apuntamos al primer coeficiente del polinomio
	exg x,y				;transferimos
	jsr puntero_coeficientes	;y ahora apuntamos al otro polinomio

bucle_negar:
	cmpa #0
	blt acabar_negar_polinomio	;repetimos hasta que se acabe el polinomio que estemos negando
	
	ldb ,y+		;vemos el elemento
	negb		;lo negamos
	stb ,x+		;lo escribimos cambiado de signo
	
	deca		;decrementamos A	
	bra bucle_negar	;y saltamos al comienzo hasta que se acabe el polinomio

acabar_negar_polinomio:
	puls y,x,d	;finalizamos subrutina
	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; multiplicar_escalar - multiplica un polinomio por un escalar	          ;
;------------------------------------------------------------------------------;
;  Entradas: X - puntero al inicio del polinomio (byte de grado).	          ;
;	     A - escalar 						          ;
;            Y - puntero a dirección de salida. 			          ;
;  Salida - mem[Y] - nuevo polinomio igual al anterior pero negado	          ;
;  Registros afectados - CC						          ;
;------------------------------------------------------------------------------;
; AVISO: máximo representable por un coeficiente = 127.                        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
multiplicar_escalar:
	pshs d,x,y

	lda #0
	ldb ,x		;cargamos el grado
	pshs d		

	lda 2,s		;cargamos el escalar

	stb ,y		;guardamos el polinomio resultado
	
	jsr puntero_coeficientes  	;apuntamos al polinomio
	exg x,y				;cambiamos valores
	jsr puntero_coeficientes  	;volvemos a apuntar al otro
				   

	pshs u			    ;contador
	ldu 2,s			    ;cargamos el grado

bucle_multiplicacion:
	cmpu #0			;vamos comparando con cero
	blt fin_mul_escalar	;saltamos si se cumple
	
	ldb ,y+		;cargamos en b el coeficiente 
	mul		;vamos multiplicando
	stb ,x+		;y guardamos el nuevo coeficiente

	lda 4,s		;cargamos a con el escalar

	tst ,-u
	
	bra bucle_multiplicacion	;saltamos

fin_mul_escalar:
	puls u			;liberamos u
	tst ,s++
	puls y,x,d
	jsr ajustar_polinomio	;ajustamos por si acaso
				
	rts			;terminamos subrutina

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; mult_mon - multiplica un polinomio por un monomio	                         ;
;------------------------------------------------------------------------------;
;  Entradas: X - Puntero al principio del polinomio (byte de grado)	          ;
;	     Y - Dirección donde guardar el nuevo polinomio		          ;
;            A - Coeficiente del monomio				          ;
;            B - Grado del monomio					          ;
;------------------------------------------------------------------------------;
; NOTA: la suma de los grados del polinomio + monomio no debe exceder 127      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mult_mon:
        pshs x,y,d		;guardamos en memoria los datos del monomio
	
	;calculamos grado
	ldb ,x		;guardamos en memoria el grado
	lda #0		;ponemos A a cero
	addb 1,s	;ponemos en b la suma de los grados
	stb ,y		;guardamos el nuevo grado 
	pshu b		;y lo ponemos en la pila
	ldb ,x		;volvemos a tener el grado del polinomio anterior

	exg x,y				;transferimos
	jsr puntero_coeficientes	;apuntamos al polinomio con y
	exg y,x				;y volvemos a transferir
	jsr puntero_coeficientes 	;ahora en x apunta al polinomio

	
bucle_producto_monomio:
	cmpb #0		   			;vamos comparando b con cero
	blt acabar_bucle_producto_monomio	;cuando lo sea saltamos

	pshu b		   ;guardamos b.
	lda ,x+		   ;cargamos a con el coeficiente del monomio
	ldb ,s		   ;y con b hacemos lo mismo
	mul		   ;multiplicamos a y b	
	stb ,y+		   ;y guardamos b en y e incrementamos
	pulu b		   ;devolvemos b
	decb		   ;y lo decrementamos
	bra bucle_producto_monomio 	;volvemos al principio

acabar_bucle_producto_monomio:	;por si nos quedan terminos basura hay que ponerlos a 0

	pulu b		   ;volvemos a tener b
	ldx 2,s		   ;x apunta al grado
	subb ,x		   ;y restamos a b lo que haya en x
	
	lda #0		   ;ponemos A a cero

bucle_poner_0:
	cmpb #0					;comprobamos que b sea positivo
	ble fin_multiplicar_por_monomio		;si es menor o igual saltamos al final
	sta ,y+					;guardamos en memoria e incrementamos a
	decb					;decrementamos b
	bra bucle_poner_0			;volvemos al principio
	
fin_multiplicar_por_monomio:
	ldx 4,s			;aqui ajustamos el polinomio
	jsr ajustar_polinomio


	
	puls x,y,d		;terminamos subrutina
	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; mult_polinomios - multiplica 2 polinomios		               	  ;
;------------------------------------------------------------------------------;
;  Entradas: X - Polinomio 1					       	  ;
;            Y - Polinomio con el que se multiplicara		 	  ;
;	     D - Dirección de destino de la multiplicación		          ;
;  Salida - mem[D] - nuevo polinomio multiplicación de los anteriores	  ;
;  Registros alterados: CC						          ;
;------------------------------------------------------------------------------;
; NOTA: la suma del grado de los polinomios no debe ser mayor que 127	  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mult_polinomios:
	pshs x,y,d

	lda ,y		;a es igual al grado del pol y
	adda ,x		;a es igual a la suma de los grados

	cmpa #0
	bge sigue_multiplicando_polinomios		;si grado es menor que cero esta mal y no se salta			
	  ldx #desbordamiento				;se muestra la cadena
	  jsr most_cadena				
	  jmp acabar_multiplicar_polinomios		;y vamos a la etiqueta acabar_...

			
sigue_multiplicando_polinomios:	
			
	pshs u
	ldu 2,s
	sta ,u		;guardamos el grado nuevo
			
	puls u		

	pshs d
	ldd 2,s
	exg d,x
	jsr limpiar_polinomio 
	tfr d,x
	puls d
	
	lda ,x		;cargamos en a el grado
	cmpa ,y		;comparamos
	bge reduce	;si era mas grande continuamos
	  exg x,y	;si no cambiamos valores
			
reduce:	
	tfr u,d
	subd #129	
	tfr d,u		

	ldb ,y			     
	exg x,y
	jsr puntero_coeficientes   
	exg y,x
	
bucle_multiplicar_polinomios:
	cmpb #0
	blt fin_bucle_multiplicar_polinomios
	
	lda ,y+		;cargamos en a el coeficiente del primer monomio
	pshs x,y	;y en b su grado
	tfr u,y		;en y su dirireccion y en x el polinomio q multiplica
			
bpsuma4:
	jsr mult_mon
bpsuma2:
	tfr u,x	  
	ldy 4,s    
	jsr suma_pol
bpsuma3:	
	puls x,y   
bp1:
	decb
	bra bucle_multiplicar_polinomios

fin_bucle_multiplicar_polinomios:
	tfr u,d		
	addd #129	
	tfr d,u		


acabar_multiplicar_polinomios:
	puls x,y,d
	rts				;terminamos subrutina

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                div_polinomios - divide 2 polinomios		 	  ;
;------------------------------------------------------------------------------;
;  Entradas: X - Dividendo					       	  ;
;            Y - Divisor					 	          ;
;	     D - Direccion cociente					          ;
;  Salida - mem[D] - cociente						          ;
;	    X - Resto (altera el dividendo original)			          ;
;  Registros alterados: CC,U,D						  ;
;------------------------------------------------------------------------------;
; NOTA: Grado dividendo > grado divisor	                                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
div_polinomios:
	pshs y,x,d
	
	lda ,y		;grado del divisor
	ldb ,x		;grado del dividendo

	cmpa ,x
	blt si_dividendo_mayor

	ldx #error_division
	jsr most_cadena
	jmp fin_division_polinomios

si_dividendo_mayor:
	pshu a				;guardamos
	exg x,y				;cambiamos
	jsr puntero_coeficientes	;apuntamos al polinomio
	lda ,x				;y a es ahora el primer coeficiente

	pulu a

	exg u,d		;cambiamos u por d
	subd #129	;restamos ad 129
	exg d,u		;luego cambiamos otra vez
	pshs u		;y guardamos en la pila

	pshu d		

	exg x,y				;apuntamos a polinomio
	jsr puntero_coeficientes	
	exg x,y
	subb ,u		

	pshu x		;cogemos x
bpdm:
	ldx 2,s				;le damos la direcciond el cociente
	stb ,x				;ponemos el grado
	jsr limpiar_polinomio	     	;limpiamos el polinomio
	stb ,x				;lo guardamos
	jsr puntero_coeficientes   	;y apuntamos donde ira el primer elemento
	stx 2,s				
 	pulu x				
	
bucle_dividir:
	cmpb #0				;comparamos
	blt acabar_bucle_dividir	;saltamos si es menor
	lda ,y+				
	ldx 2,s				;le damos la direccion del proximo elemento del cociente
	sta ,x+				;lo guardamos
	stx 2,s				;y guardamos el puntero
	nega				;negamos el monomio apuntado
	pshu y				;reservamos y
	ldy ,s				
	ldx 6,s				;a x le damos la direccion del divisor
	jsr mult_mon			;y llamamos a la subrutina

	ldx 4,s				;le damos la direccion del dividendo a x
	exg x,y				;cambiamos valores
	jsr suma_pol			;y llamamos

bpbdf2:
	pulu y
	decb
	bra bucle_dividir

acabar_bucle_dividir:
	tfr u,d		
	addd #131	
	tfr d,u		
	tst ,s++

fin_division_polinomios:
	puls d,x,y
	rts				;terminamos subrutina
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;      mostrar_int - imprime el entero almacenado en A	      ;
;                                                                  ;
;   Entrada: A entero a mostrar en base 10  	                     ;
;            B signo pos por defecto (\0 si no se quiere)	     ;
;              no impedirá los negativos, sólo positivo.           ;
;   Registros afectados: CC.                                       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mostrar_int:
	pshs d, x

	cmpa #0			;comparamos a con cero
	bge cuando_es_positivo	;saltamos
	ldb #'-			;si no cambiamos el signo
	nega			;y lo negamos 
	
cuando_es_positivo:
	stb pantalla    ;sacamos el signo

	tfr a,b		;cambiamos valores
	lda #0		;cargamos cero

	tst ,--u	
	tfr u,x		
	jsr dividir_D_diez	;llamamos 
	
	lda 1,u
	tst ,u++

	cmpa #10		;comparamos con 10
	blt vemos_si_cero	;
	suba #10		;restamos
	pshu b			;guardamos el resto
	ldb #'1			;cargamos b
	stb pantalla		;enseñamos en pantalla
	pulu b			;guardamos resto
	bra sacar_numeros	;saltamos

vemos_si_cero:				 
	cmpa #0				;comparamos con cero		 
	beq no_sacar_cero_al_principio 	;saltamos
				         
sacar_numeros:					 
	adda #48			;sumamos  
	sta pantalla			;y enseñamos el numero
					 
no_sacar_cero_al_principio:		 
	addb #48			 
	stb pantalla			;hacemos lo mismo

acabar_mostrar_int:
	puls x,d
	rts				;terminamos subrutina


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; puntero_coeficientes- hace que X apunte al primer coficiente de un pol.      ;
;------------------------------------------------------------------------------;
;   Entradas: X - apuntando al primer byte del polinomio (su byte de grado)    ;
;   Salidas: X - apuntado al byte del primer coeficiente (el de mayor grado).  ;
;   Registros afectaods: CC, X						       ;hecho
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
puntero_coeficientes:
	pshs d
	
	ldd #0		;cargamos en d cero
	pshu d		

	ldb ,x		;cargamos el grado en la pila
	stb 1,u		

	tfr x,d		;para hacer las cuentas cambiamos a d
	addd #128 	;sumamos 128
	subd ,u++ 	;le restamos el grado
	tfr d,x	

	
	puls d
	rts		;terminamos subrutina

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   ajustar_polinomio - ajusta el grado de un polinomio que ha sido recortado  ;
;------------------------------------------------------------------------------;
; Esta operación es necesaria cuando se acorta un polinomio (no cuando crece)  ;
; por operaciones de suma o resta y el grado del polinomio no coincide con su  ;
; realidad, provocando accesos a bytes no seguros. 			       ;
;------------------------------------------------------------------------------;
;   Entrada X - cabeza del polinomio (byte de grado)			       ;
;   Salida: En memoria, el polinomio tendría el grado que debería. 	       ;hecho
;   Registros afectados: CC.	                                               ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ajustar_polinomio:
	pshs d
	pshu x
	
	lda ,x 				;cargamos a con el grado que sea
	jsr puntero_coeficientes  	;apuntamos al polinomio

bucle_ajustar:
	cmpa #0
	ble fin_ajuste	;si el grado es cero terminamos
	
	ldb ,x+	  	;cargamos elementos
	cmpb #0		;vamos comparando
	bne fin_ajuste	;terminar si fuese cero
	
	deca			;decrementamos
	bra bucle_ajustar	;saltamos

fin_ajuste:
	pulu x		
	sta ,x		

	puls d
	rts		;terminamos subrutina


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;      - pide un valor entero en rango de -127 a 127                           ;
;------------------------------------------------------------------------------;
;   Salida: B - Valor insertado por el usuario (entre -127 y 127)              ;
;   Registros afectados: B,CC.                                                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pedir_rango:
	pshs a,x,y
	pshs u

bucle_pedir_rango_bien:	
	ldu ,s			                 
				
	ldy #0			;cargamos el valor cero
	ldx #intro
	jsr most_cadena	;mostramos cadena

	ldb #0			;cargamos cero en b
	lda #'+			;cargamos el caracter
	pshs a			

	lda teclado		;vemos si es negativo
	cmpa #'-		
	bne comprobar_si_positivo ;si no vemos si es positivo	
				
	sta ,s			
	bra bucle_chars   
 
comprobar_si_positivo:
	cmpa #'+		
	beq bucle_chars 	
	pshu a			
	tst ,y+			
	tfr a,b			

bucle_chars:
	cmpb #'\n		;acabar si se encuentra salto de linea
	beq transformar_chars
	cmpy #3			
	beq poner_salto_al_final   ;insertamos salto de linea
	
	ldb teclado
	pshu b		 
	tst ,y+		
	bra bucle_chars

poner_salto_al_final:	
	lda #'\n	
	pshu a
	tst ,y+

transformar_chars:
	ldb #0  
	stb ,u		;cambiamos el salto por cero, ahí ponemos la suma total.
	tst ,-y
	tfr u,d 	

	pshu y  	
	addd ,u++
	tfr d,x 	
	 
bucle_transformar_chars:
	cmpy #0
	beq fin_pedir_rango_bien
	
	lda ,x
	cmpa #'0		;si es menor que cero mostramos error
	blt error_num
	cmpa #'9		;y tambien si es mayor que nueve
	bgt error_num

	suba #48	;convertimos a numero
	sta ,x		

	lda ,u		
	ldb #10			
	mul	

	addb ,x			;le sumamos el nuevo numero
	tst ,-x			;decrementamos
	stb ,u  		;guardamos en memoria

	tst ,-y		
	bra bucle_transformar_chars	;saltamos

fin_pedir_rango_bien:
	ldb ,u			;ponemos el valor que metimos en b
	cmpb #0			;comparamos si es negativo
	blt error_num 		
	
	lda ,s		
	cmpa #'+
	beq positivo    	;si es positivo no hacemos nada
	negb			;si no lo es lo negamos

positivo:
	tst ,s+				
	puls u
	puls y,x,a
	rts

error_num:
	tst ,s+				
	ldx #cadena_error_rango
	jsr most_cadena		

	jmp bucle_pedir_rango_bien	;vamos repitiendo hasta que lo introduzcamos bien
	


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   dividir_D_diez - Divide D entre 10.      	  		  	         ;
;   Algoritmo: http://avellano.usal.es/~compii/sesion5.htm   		  ;
;------------------------------------------------------------------------------;
;   Entrada: D - Dividendo						         ;
;	     X - Dirección donde guardar el cociente			         ;
;   Salida: mem[X] - Cociente					                 ;
;           B - Resto							         ;
;   Registros afectados: D, X, CC                      	                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dividir_D_diez:
	pshs x,y	

			
	tst ,--u	;u tendrá el dividendo
	tst ,--u	;u+2 guardará la máscara 
	tst ,--u	;u+4 guardará el divisor 
	tst ,--u	;u+6 guardará el cociente

	std ,u		;guardamos el dividendo en memoria
	ldx #0		;cargamos cero
	stx 6,u		;y lo asignamos al cociente

	ldy #0b00000001	
	sty 2,u		;máscara

	ldx #10
	stx 4,u		
	
	exg x,d		;cambiamos x por d

bucle_multiplicar_por_2:
	cmpd ,u
	bgt fin_bucle_multiplicar_por_2      

	jsr desplaza_izquierda		    

	exg y,d			    
	jsr desplaza_izquierda		   
	exg y,d

	stx ,u					;guardamos el dividendo
	bra bucle_multiplicar_por_2		;saltamos al principio

fin_bucle_multiplicar_por_2:
	exg x,d					;deshacemos el intercambio anterior

bucle_compara:
	cmpy #0			
	beq acabar_division
	
	
	cmpx ,u
	bgt nos_quedamos_igual	;si el dividendo es menor que el divisor no hacemos nada
				;si el dividendo mayor o igual que el divisor restamos
	  ;; resta
	  stx 4,u		;guardamos el divisor
	  subd 4,u		;ponemos en d la resta de dividendo y divisor
	  std ,u		;y guardamos el resultado

	  sty 2,u		
	  ldd 6,u		
	  addd 2,u		
	  std 6,u		
	  ldd ,u		;actualizamos el cociente usando la mascara

nos_quedamos_igual:
	exg y,d
	jsr desplaza_derecha			
	exg y,d
	exg x,d
	jsr desplaza_derecha			
	exg x,d
	bra bucle_compara

acabar_division:
	puls y,x
	
	ldd 6,u		;guardamos en d el cociente
	std ,x		;y lo ponemos en

	ldd ,u		;ponemos en d el resto
	
	tst ,u++		
	tst ,u++
	tst ,u++
	tst ,u++
	rts		;terminamos subrutina

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  desplaza_izquierda - Desplaza a la izquierda el registro D     (<<D)        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
desplaza_izquierda:  
	 	aslb
	  	rola
		rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  desplaza_derecha - Desplaza a la derecha el registro D  (D>>) 	       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
desplaza_derecha:   
		asra
		rorb
		rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
acabar: 
        clra
	sta fin

	.org 0xFFFE	; vector de RESET
	.word programa

;
