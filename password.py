'''from zxcvbn import zxcvbn

first_password = zxcvbn('cZh34Jlk@139')
print(first_password)

second_password = zxcvbn('JohnRay123', user_inputs = ['John', 'Ray'])
print(second_password)'''

import string
import time
from itertools import combinations_with_replacement
from random import random, seed, choice
import sys, gc

TAMANHO = 4
LETRASMIN = string.ascii_lowercase
LETRAS = string.ascii_letters
LETRAS_DIGITOS = string.ascii_letters + string.digits
TODOSCARACTERES = string.ascii_letters + string.digits + string.punctuation


def gerar_senhas(valores: str, tamanho: int) -> list:
    combinacao = combinations_with_replacement(valores, tamanho)

    return list(combinacao)


if __name__ == '__main__':
    init_time = time.time()
    val = TODOSCARACTERES
    lista_senhas = gerar_senhas(val, TAMANHO)
    final_time = time.time()

    print('Quantidade de senhas: '+ str(len(lista_senhas)))
    print('Tempo: '+ str(final_time - init_time) + ' seconds')

    print("Coletando lixo...")
    n = gc.collect()
    print("Número de objetos coletados pela função GC:", n)
    print("Objetos restantes:", gc.garbage)