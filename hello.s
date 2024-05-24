/*
RETISTRO

.global _start

.section .text  //SE USA PARA ESPECIFICAR QUE EN ESTA SERA PARA CODIGO NO ESTA DIRIGIDO A GUARDAR EN MEMORIA
_start:
    mov r0, #1
    ldr r1, =message
    mov r2, #13 //CON MOV MOVEMOS UN VALOR A UN REGISTRO, TAMBIEN PODEMOS HACER POR EJEMPLO MOV R2, R1 Y MOVEMOS LO QUE TIENE R1 A R2
    mov r7, #4
    svc 0

    mov r7, #1
    svc 0

.section .data //SE USA PARA ESPECIFICAR QUE EN ESTA PARTE SE GUARDARAN DATOS EN MEMORIA
message:
    .ascii "Hello, ARM!\n"
*/

/*
//INTERRUMPIR PROGRAMA

 .global _start
 _start:
;  ASIGNAMOS EL DECIMAL 30 AL REGISTRO R0, GUARDAMOS EN REGISTRO PORQUE ESTE VALOR CAMBIARA CONSTANTEMENTE,
;  TAMBIEN PODEMOS GUARDAR EXADECIMALES EMPEZANDO CON 0x...(es decir seguido el hexadeximal) 
    MOV R0, #30   

 //NECESITAMOS LLAMAR A UN REGISTRO ANTES DE INTERRUMPIR EL PROGRAMA CON SWI, POR CONVENCIO SE USA R7 CON 1 COMO VALOR*
    MOV R7, #1
    SWI 0
*/


//STACK
/*
.global _start

.section .text
_start:
    // Inicialización
    mov r0, #10        // r0 = 10
    push {r0}          // Guardar 10 en la pila
    mov r0, #13        // r0 = 13
    push {r0}          // Guardar 13 en la pila

    // Recuperar valores desde la pila
    pop {r0}           // r0 = 13, se recupera el valor más reciente Y se elimina de la pila. 
    pop {r0}           // r0 = 10, se recupera el valor siguiente más reciente y se elimina de la pila


    // Preparar para salir del programa
    mov r7, #1         // Número de syscall para salir
    svc 0              // Llamada al sistema (salir)
*/

/*
.global _start

.section .text
_start:
    // Inicialización
    mov r0, #10        // r0 = 10
    push {r0}          // Guardar 10 en la pila
    mov r0, #13        // r0 = 13
    push {r0}          // Guardar 13 en la pila

    // Recuperar valores desde la pila
    pop {r4}           // r4 = 13, se recupera el valor más reciente Y se elimina de la pila. 
    pop {r5}           // r5 = 10, se recupera el valor siguiente más reciente y se elimina de la pila

    //TAMBIEN PODEMOS HACER ALGO ASI PUSH {R1-R3} GUARDAMOS TODOS LOS REGISTROS DESDE R1 AL R3, 
    //CON POP {R1-R3} LOS RECUPERAMOS EN ESAS DIRECCIONES, AUNQUE SI HACEMOS POP {R4-R6} RECUPERAMOS LOS VALORES PERO EN R4,R5,R6
    //CUIDADO SOLO GUARDAMOS LOS VALORES DE LOS REGISTROS NO EL NOMBRE DEL REGISTRO EN SI POR LO QUE SON VALORES SUELTOS EN LA CAJA QUE ES EL STACK
 
    // Preparar para salir del programa
    mov r7, #1         // Número de syscall para salir
    svc 0              // Llamada al sistema (salir)
*/



/*

MEMORIA Y REGISTRO

.global _start
_start:
   LDR R0, =list //asignamos a el registro r0 la direccion de memoria que contiene list(donde empezo el guardado de datos no todas las direcciones cuidado)
   //ldr r1, [r0]        @ accedemos a el primer valor (los primeros 4 bytes a partir de la direccion de memoria de list) en r1 (cargar 4)
   //ldr r2, [r0, #4]    @ si ponemos #4 estamos diciendo carga los 4 bytes posteriores a los primeros 4 (cargara 5) en r2
   //ldr r2, [r0, #4]!    Si agregamos el signo !, lo que ocurre es que primero le dara la direccion de memoria a r2 y luego r0 actualizara su 

    //ldr r2, [r0], #4 esto lo que hara es asignarle a r2 el valor de r0 y luego incrementar en 4 bytes la direccion de memoria de r0
    //es decir r2 quedara por ejemplo 0x1000 y r0 cambiara a 0x1004

   //direccion de memoria para empezar de ahi, es decir si r0 empezaba 0x1000 ahora empezara en 0x1004, dejando lo que ahi 0x1000 sin una forma de acceder clara
   //si es que no lo asignamos en r1.
   //ldr r3, [r0, #8]    @ si ponemos # estamos diciendo Cargara los 4 bytes posteriores a los primeros 8, cargara el tercer valor (6) en r3
   //cuidado si nos pasamos ya empezara a cargar datos fuera de list, no importa si no pertenece a list.

//data se usa para guardar datos constantes o variables
.data
list: //list solo es el nombre que se le da a esta seccion del codigo,una simil variable
      //es el nombre que se le dio al lugar donde empieza el guardado de datos. list o lista es lo mismo.
   //con word(32) bits podes reservar 32 bits de memoria en cada valor.
   //es decir para 4 se reservaran 32 bits memoria, para 5 32 bits, etc.
   .word 4,5,-9,1,0,2,-3
*/


//CALCULOS
/*
.global _start
_start:
    //suma = ADD, resta = SUB, multiplicacion = MUL, 
    //resta con flags = SUBS, suma con flags = ADDS, suma + carry(0 o 1) = ADC
    MOV R0, #5
    MOV R1, #7
    ADD R2,R0,R1 //R2 = R0 + R1
    SUB R3,R0,R1 //R3 = R0 - R1 Usa SUB cuando solo necesitas el resultado de la resta y no te importan los flags(no se actualizan los flags)
    MUL R4,R0,R1 //R4 = R0 * R1

    //Usa SUBS cuando quieres que la operación afecte los flags para decisiones condicionales.
    ; Los flags se actualizan según el resultado, es decir cambia el cpsr:
    ; - N (Negative): 0 (el resultado no es negativo)
    ; - Z (Zero): 0 (el resultado no es cero)
    ; - C (Carry/Borrow): 1 (no se produjo un préstamo)
    ; - V (Overflow): 0 (no hubo desbordamiento)
    SUBS R5,R0,R1 //R5 = R0 - R1

    ; COMPARACION
    ; CMP R1, R2   ; Internamente usa SUBS y actualiza los flags
    ; BEQ equal    ; Salta a "equal" si R1 es igual a R2 (Z=1)

    ; BUCLE O CONDICIONAL
    ; SUBS R0, R0, #1  ; Decrementa R0 y actualiza los flags
    ; BNE loop         ; Si R0 no es cero (Z=0), sigue en el bucle


*/
/*
//CALCULOS
//ADDS Y ADC
.section .data
    num1: .word 0xFFFFFFFF  ; Valor máximo de un entero de 32 bits sin signo
    num2: .word 1

.section .text
.global _start

_start:
    LDR R0, =num1          ; Cargar la dirección de num1 en R0
    LDR R1, [R0]           ; Cargar el valor de num1 en R1 (R1 = 0xFFFFFFFF)

    LDR R0, =num2          ; Cargar la dirección de num2 en R0
    LDR R2, [R0]           ; Cargar el valor de num2 en R2 (R2 = 1)

    ADDS R3, R1, R2        ; Sumar R1 y R2, almacenar en R3 y actualizar los flags (R3 = 0xFFFFFFFF + 1)
                           ; Esto causa un carry porque el resultado es mayor que el máximo valor que un registro puede contener (R3 = 0)
                           ; El carry flag (C) se setea a 1

    ADC R4, R3, #0         ; Sumar R3 y el carry flag, almacenar en R4 (R4 = R3 + carry)
                           ; Aquí, R4 será 1 porque R3 es 0 y carry es 1

    B end                  ; Saltar al final

end:
    ; Salida
    MOV R7, #1             ; Número de llamada del sistema para salida
    SWI 0                  ; Llamada del sistema
*/


//RECORRER ARRAY CON BUCLE Y USO DE CONDICIONAL CMP
/*
.data //aqui definiremos nuestras constantes
tam: .word 8 //este sera el tamaño del array que usaremos
datos: .word 2, 4, 6, 8, -2, -4, -6, -7 //datos es mi array, estos son los valores del array

res: .word 0

.text
.global main
main: 
    ldr ro, -tam //cargamos el principio de la direccion tam
        ldr r1, [r0] //asignamos el valor de los primeros 4 bytes a r1 (8)
        ldr r2, -datos  //asignamos el principio de la direccion datos a r2


loop: 
    cmp r1, #0 //creamos una funcion llamada loop, y dentro un condicional de comparacion(cmp) que pregunta si r1 es igual a 0
        beq salir //usamos la palabra reservada branch equal(beq) que dice que si es igual entonces use la funcion salir(si r1 es igual a 0 usa salir)
        ldr r4, [r2], #4 //cargamos el valor de los primeros 4 bytes de r2 (2) y 
                        //luego actualizamos la direccion de memoria de r2 a 4 bytes posteriores(obtenemos el valor 4 luego 6, etc.)
        add r3, r3, r4, //vamos sumando los distintos valores de r4 a r3 (r3 + 4, luego r3 + 6, etc)
        sub r1, #1 //vamos restando de a 1 a r1 para que el bucle no pegue mas vueltas que el tamaño del array y genere un gran error, 
                   //es decir r1 es nuestro contador, ira desde el tamaño de nuestro array (8) hasta 0
        b loop //esto dice vuelve a ejecutar loop

salir:
    ldr r0, -res //cargamos la direccion de memoria de res en r0
        str r3, [r0] //str lo que hace es que en lugar de aplicar el valor de la direccion de memoria de r0 (0) a r3 como lo hace ldr, 
                    //aplica el valor de r3 a la direccion de memoria de r0. es decir va a reemplazar 0 por el valor actual de r3
                    //por ejemplo si teniamos res: .word 0 ahora seria res: .word valor de r3(14 por ejemplo)
                    //si res por ejemplo seria .word 0, 1 reemplaza el 0 por el valor de r3, el 1 no lo toca por el momento a menos que se lo indiquemos despues
        bx lr   //Salto de linea que vuelve a donde fue llamado

        //BX: Esta instrucción es una instrucción de salto de registro. Toma la dirección almacenada en un registro y realiza un salto a esa dirección.
        //LR: Este es el registro de enlace (Link Register) en ARM, que generalmente contiene la dirección de retorno de una subrutina o función.
*/

//CONDICIONALES
/*
.text

.global main
main:
    add r0, #1

    //cmp A, B --> X = A - B Lo que hace cmp es restar estos numeros y verificar que si da 0 entonces son iguales
    cmp r1, r0 //CMP COMPARA PERO SIN GUARDAR EL DATO es decir activa una bandera de cpsr(nzcv) segun el resultado que da pero el resultado no se almacena

    subs r2, r0, r1 //SUBS COMPARA y activa una bandera de cpsr segun el resultado hasta ahi lo mismo que cmp, pero ademas guarda el resultado de la resta de r0 y r1 en r2.
                    //en este caso r0(1) - r1(0) = 1, activara la bandera correspondiente y guardara el resultado de la resta en r2 que seria 1
    
    //cmn A, B --> X = A + B CMN LO QUE HACE ES SUMAR (EN REALIDAD ES RESTAR N DE NEGATIVE PERO NEGATIVO DE NEGATIVO +. NO ENTENDI BIEN ESTO PERO NO ES IMPORTANTE AHORA)
    //ES DECIR SUMA A + B Y SI DA 0 ENTONCES SON IGUALES 
    cmn r1, r0 //CMN COMPARA PERO SIN GUARDAR EL DATO es decir activa una bandera de cpsr(nzcv) segun el resultado que da pero el resultado no se almacena

    adds r3, r0, r1 //ADDS COMPARA y activa una bandera segun corresponda pero ademas guarda el dato de la suma, lo mismo que subs pero en suma
                    //en este caso guardara el resultado de r0 + r1 = 1 + 0 = 1


    //teq A,B --> X = A eor B, eor seria un xor, si A y B tienen el mismo valor entonces devuelve 0 y si son distinto devuelve 1. No guarda valor.
    //se activa la bandera Z de es cero cuando son iguales.
    teq r1, r1 //devolvera 0 ya que son iguales si usamos beq ejecutara codigo
    teq r1, r0 //r1 y r0 no contienen los mismos valores por lo que devolvera 1 beq no ejecutara el codigo del condicional


    eors r4, r1, r1 //son iguales por lo que se activara la bandera Z de es cero cuando son iguales, y ademas guarda el 0 en r4
    eors r5, r1, r0 //r1 y r0 no contienen el mismo valor devuelve 1 y lo almacena en r5
*/

/*AND Y ANDS
//LO QUE HACE AND ES EJECUTAR LA OPERACION LOGICA AND ENTRE 2 NUMEROS, ES DECIR A * B
//LO QUE HACE ES IR COMPARANDO BINARIO POR BINARIO Y ACTIVA LA BANDERA SEGUN CORRESPONDA(NVM)
//EJEMPLO 1 * 1 = 1, 1 * 0 = 0, 0 * 1 = 0, 0 * 0 = 0. LO HACE BIT POR BIT
//EJEMLO TENGO 12 EN BINARIO (1100) Y 10 (1010), HACEMOS LA MULTIPLICACION BIT * BIT.
//  1 * 1 = 1, 1 * 0 = 0, 0 * 1 = 0, 0 * 0 = 0, ME DA 1000 QUE SERIA 8 (EN REALIDAD 00001000) YA QUE ESTA USAMOS 8 BITS PARA REPRESENTAR LOS VALORES
//EN ESTE CASO NI LA BANDERA DE NEGATIVO NI LA DE ZERO SE ACTIVAN YA QUE EL RESULTADO FINAOL NO CUMPLE NINGUNA DE ESTAS CONDICIONES
//ANDS LO UNICO QUE CAMBIA ES QUE GUARDA EL VALOR POR LO QUE GUARDARIA 8

MOV r0, #0b1100    // r0 = 12 (en binario: 1100)
MOV r1, #0b1010    // r1 = 10 (en binario: 1010)

AND r2, r0, r1     // r2 = r0 AND r1 = 1100 AND 1010 = 1000 (en binario: 1000)
                   // No se actualizan las banderas de estado

ANDS r3, r0, r1    // r3 = r0 AND r1 = 1100 AND 1010 = 1000 (en binario: 1000)
                   // Se actualizan las banderas N y Z
                   // N = 0 (el resultado no es negativo)
                   // Z = 0 (el resultado no es cero)


*/


/*
//BANDERAS O FLAGS

.text
.global main
main:
    add r0, #1

    //N: Negativo (0 = > | 1 = <) 
    cmp r0, #2 //1 < 2 --> N:1, (R0(1) - 2 = -1) ENTONCES SE ACTIVA N 
    cmp r0, #0 //1 > 0 --> N:0, (r0(1) - 0 = 1) ENTONCES No SE ACTIVA N 

    //Z : Cero (1 = '0' | 0 != '0')
    cmp r0, #1 //r0(1) - #1 = 0 --> Z:1, el resultado dio Z por eso se activa Z
    cmp r0, #-1 //r0(1) - #-1 != 0 --> Z: 0, EL RESULTADO ES DISINTO DE 0, Z NO SE ACTIVA
    cmp r0, #0 //r0(1) - #0 = 1 esto es != 0 --> z: 0. EL RESULTADO ES DISINTO DE 0, Z NO SE ACTIVA
    cmp r1, #0 //r1 - #0 = 0 --> Z:1. EL RESULTADO ES 0 SE ACTIVA Z

    //C: Carry 
    //SUB (1 = no te llevas | 0 = te llevas)
    subs r2, r1, r1 // la comparacion  0 - 0 da 0 por lo que se activa el carry C: 1
    subs r3, r1, #1 //la comparacion 0 - 1 da -1 o distinto de cero por lo que el carry no se activa

    //ADD (1 = te llevas | 0 = no te llevas)
    adds r4, r1, #0  //la comparacion 0 + 0 da 0 por lo que el carry no se activa
    adds r5, r0, #1 //la comparacion 1 + 1 da 10(2) o distinto de 0 por lo que se activa el carry

    //V : OVERFLOW
    mov r0, #0x4000000
    mov r1, #0x4000000
    adds r3, r1, r0...
    //sume 31 bits + 31 bits hubo perdida de datos ya que supere el tamaño que podia guardar el registro 32 bits que 
    //por lo que se produce un overflow hubo perdida de datos en el guardado eran muchos valores
    */

/*
//BRANCH Y FUNCIONES
.txt 
.global main
main:
    bl f3 //esto se llama branch link, te lleva directamente a una funcion. La funcion f3 en este caso. y deja guardado desde donde fue llamada para que luego
            //con bx lr nos traiga de nuevo aqui y continuemos desde aqui
    b f4 //b lo que hace es ejecutar una funcion pero ya no vuelve

f2:
    add r0, #1
    cmp r0, r1
    beq exit  //beq (branch) esto te lleva a la funcio pero si previamente se cumplio una condicion en este caso la condicion de cmp, es decir si 
                //los numeros comparados en cmp son iguales es decir devuelven 0

f3:
    add r1, #1
    bx lr //te retorna al lugar de donde fue llamado, es decir no retornara a bl f3 y continuara desde alli

f4:
    cmp r1, r0
    bne f2 //bne (branch not equal) si la comparacion de cmp no da 0 es decir no son iguales ejecutara f2, es bne llama a la funcion pero si ocurre
            //lo contrario a lo que haria beq

exit:
    .end...
    */