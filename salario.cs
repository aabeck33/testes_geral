using System;

public class salario {
    public static void main()
    {
        // Ler valores de entrada
        float valorSalario = float.Parse(Console.ReadLine());
        float valorBeneficios = float.Parse(Console.ReadLine());

        float valorImposto = 0;
        if (valorSalario >= 0 && valorSalario <= 1100)
        {
            // Aplicar aliquota de 5%
            valorImposto = valorSalario * 0.05F;
        }
        else if (valorSalario > 1100 && valorSalario <= 2500)
        {
            valorImposto = valorSalario * 0.1F;
        }
        else
        {
            valorImposto = valorSalario * 0.15F;
        }

        float saida = valorSalario - valorImposto + valorBeneficios;
        Console.WriteLine(saida.ToString("0.00"));
    }
}
