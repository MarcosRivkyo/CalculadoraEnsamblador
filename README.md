# CalculadoraEnsamblador
Operaciones con polinomios en ensamblador


En este proyecto se realizarán las operaciones básicas definidas para
polinomios, para ello, el usuario entrará dos polinomios para los cuales se
mostrará un menú con las opciones a realizar sobre ellos. Los polinomios
estarán ordenados y tendrán la siguiente estructura: 

𝑎𝑎𝑛𝑛𝑥𝑥𝑛𝑛 + 𝑎𝑎𝑛𝑛−1𝑥𝑥𝑛𝑛−1 + ⋯ + 𝑎𝑎2𝑥𝑥2 + 𝑎𝑎1𝑥𝑥 + 𝑎𝑎0.

Además de estar ordenado, el polinomio estará en su forma reducida y
tendrá todos sus coeficientes diferente de cero, esto es, no faltará ningún
término, ejemplo: 2𝑥𝑥3 + 5𝑥𝑥2 − 3𝑥𝑥 + 1. 

Para reducir la complejidad del problema, los coeficientes, exponentes y el valor de la x en el polinomio
estarán limitados a enteros con signos en el intervalo [-128, +127]. En el
caso del grado de los polinomios, éste no será mayor que 9.

Para cada polinomio entrado por el usuario, se le debe pedir primero, el
grado del polinomio y luego pedir cada coeficiente del polinomio. Al
finalizar la entrada de ambos polinomios, éstos se imprimirán de la
siguiente forma: anx^n+an-1x^(n-1)+…+a2x^2+a1x+a0. Además, se
imprimirá a continuación el menú de las posibles opciones de operaciones
aritméticas para los polinomios, que serán:

        1. Suma de dos polinomios.
        2. Resta de dos polinomios.
        3. Multiplicación del primer polinomio por un escalar (entero).
        4. Multiplicación del primer polinomio por un monomio (esto es, 𝑎𝑎𝑖𝑖𝑥𝑥𝑖𝑖).
        5. Multiplicación de los dos polinomios.
        6. División entera de los polinomios. En este caso, se debe cumplir que el grado del polinomio dividendo sea mayor o igual al del divisor.


El usuario introducirá el número de la opción/operación que desea
realizar. El resultado de cada operación será impreso por pantalla al
usuario y en los casos de que no se cumpla la condición de la división de
polinomios, se imprimirá un mensaje por pantalla alertando tal hecho.
Finalmente, el usuario podrá realizar diferentes operaciones hasta que
introduzca el número correspondiente a la opción de terminar el
programa. Después de realizar cada operación, el programa debe reiniciar
