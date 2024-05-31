def calcula_imposto(salario: float) -> float:
    aliquota = 0.00
    if (salario >= 0.0) and (salario <= 1100):
        aliquota = 0.05
    elif (salario > 1100) and (salario <= 2500):
        aliquota = 0.1
    else:
        aliquota = 0.15
    return aliquota*salario

valor_salario = float(input('Salario:'))
valor_beneficio = float(input('Beneficio:'))

valor_imposto = calcula_imposto(valor_salario)
saida = valor_salario + valor_beneficio - valor_imposto
print(f'{saida:2f}')