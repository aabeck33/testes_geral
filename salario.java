import java.util.Scanner;

public class salario {
    public static void main(String[] args) {
        // Ler valores de entrada
        Scanner leitorDeEntradas = new Scanner(System.in);
        float valorSalario = leitorDeEntradas.nextFloat();
        float valorBeneficios = leitorDeEntradas.nextFloat();

        float valorImposto = 0;
        if (valorSalario >= 0 && valorSalario <= 1100) {
            // Aplicar aliquota de 5%
            valorImposto = valorSalario * 0.05F;
        } else if (valorSalario > 1100 && valorSalario <= 2500) {
            valorImposto = valorSalario * 0.1F;
        } else {
            valorImposto = valorSalario * 0.15F;
        }

        float saida = valorSalario - valorImposto + valorBeneficios;
        System.out.println(String.format("%.2f", saida));
    }
}
