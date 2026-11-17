// processoA.c -- o CÓDIGO do processo A deste exemplo (ver
// ../../README.md, "O mesmo exemplo, com os processos em C"), compilado
// pelo mcc e depois montado SOZINHO (nenhum outro .asm compilado na
// mesma chamada do montador, só o pequeno bridge escrito à mão -- ver
// escreve_caractere.asm e o Makefile).
//
// Como este arquivo só tem UMA função, e o mcc compila na ordem em que
// as funções aparecem no .c, "_f_processoA" acaba sendo o primeiro
// rótulo do módulo -- endereço 0, exatamente onde "ip" do processo
// começa (virtual), sob paginação. Essa é a mesma ideia de
// ../paginacao_disco/processoA.asm, só que agora a parte que o
// compilador gera (`if`/`while`/chamada de função, sempre via
// jmp/jmpc/call absolutos) continua funcionando sem nenhum truque,
// porque -- de novo -- o endereço embutido pelo montador nunca é
// físico: é só o deslocamento dentro deste módulo, que por construção
// já é o endereço virtual certo.
//
// "escreve_caractere" é só DECLARADA aqui -- a implementação (que faz
// "trap 7" por dentro) está em escreve_caractere.asm, montada junto com
// este módulo compilado (ver o Makefile). Não tem como ser diferente:
// como este processo é montado sozinho, sem ligador nenhum, qualquer
// função que ele chama precisa estar no MESMO módulo.

void escreve_caractere(int c);

void processoA(void)
{
    int *contador;
    int digito;
    int i;

    contador = (int *) 0;
    for (;;) {
        *contador = *contador + 1;
        escreve_caractere('A');
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
