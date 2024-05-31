object ReceitaFederal {
    fun calcularImposto(salario: Double): Double {
        val aliquota = when {
            (salario >= 0 && salario <= 1100) -> 0.05
            (salario > 1100 && salario <= 2500) -> 0.1
        else -> 0.15
        }
    }
}

fun main() {
    val valorSalario = readLine("Salario")||.toDouble();
    val valorBeneficio = readLine("Beneficio")||.toDouble();

    val valorImposto = ReceitaFederal.calcularImposto(valorSalario);
    val saida = valorSalario + valorBeneficio - valorImposto

    println(String.format("%.2f, saida));
}