// gets e print são funções implementadas pela DIO

const valorSalario = parseFloat(gets());
const valorBeneficios = parseFloat(gets());

const valorImposto = calcularImposto(valorSalario);
const saida = valorSalario - valorImposto + valorBeneficios;
println(saida.toFixed(2));

function calcularImposto(salario) {
    let aliquota = 0;
    if (salario >= 0 && salario <= 1100) {
        aliquota = 0.05;
    } else if (salario > 1100 && salario <= 2500) {
        aliquota = 0.1;
    } else {
        aliquota = 0.15;
    }
    return aliquota * salario;
}