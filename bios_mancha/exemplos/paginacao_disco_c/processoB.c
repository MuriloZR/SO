// processoB.c -- o mesmo que processoA.c, trocando só a letra impressa.
// Ver os comentários lá (e ../../README.md) para o motivo de isto
// funcionar montado sozinho, sem nenhum truque de posição.

void escreve_caractere(int c);

void processoB(void)
{
    int *contador;
    int digito;
    int i;

    contador = (int *) 0;
    for (;;) {
        *contador = *contador + 1;
        escreve_caractere('B');
        escreve_caractere(':');
        digito = *contador % 10;
        escreve_caractere(digito + '0');
        escreve_caractere(' ');
        i = 0;
        while (i < 3000) {
            i = i + 1;
        }
    }
}
