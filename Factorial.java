import java.math.BigInteger;

/**
 * Operaciones relacionadas con el cálculo del factorial.
 */
public final class Factorial {

    private Factorial() {
    }

    /**
     * Calcula el factorial de un número entero positivo.
     *
     * @param number int positivo del que se desea calcular el factorial
     * @return factorial de {@code number} como un entero de precisión arbitraria
     * @throws IllegalArgumentException si {@code number} no es positivo
     */
    public static BigInteger factorial(int number) {
        if (number <= 0) {
            throw new IllegalArgumentException("El número debe ser positivo.");
        }

        BigInteger result = BigInteger.ONE;
        for (int factor = 2; factor <= number; factor++) {
            result = result.multiply(BigInteger.valueOf(factor));
        }
        return result;
    }

    /**
     * Muestra un ejemplo del cálculo del factorial.
     *
     * @param args argumentos de línea de comandos (no utilizados)
     */
    public static void main(String[] args) {
        System.out.println("5! = " + factorial(5));
    }
}
