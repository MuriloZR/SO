// ponteiros_funcao.c -- ponteiros de função: variável de ponteiro de
// função, tabela de despacho (array de ponteiros de função, o mesmo
// padrão usado para vetor de interrupções/tabela de chamadas de sistema
// em ../../bios_mancha/), callback (ponteiro de função como parâmetro) e
// ponteiro de função como membro de struct.

#include "mancha.h"

int soma(int a, int b) { return a + b; }
int subtrai(int a, int b) { return a - b; }
int multiplica(int a, int b) { return a * b; }

// variável comum de ponteiro de função: o nome de uma função, usado sem
// "()", vale o ENDEREÇO dela (mesma ideia de um array decaindo pra
// ponteiro fora de "[]")
void ponteiro_simples(void)
{
    int (*op)(int, int);
    op = soma;
    print_int(op(3, 4));
    putchar(' ');
    op = subtrai;
    print_int(op(10, 4));
    putchar('\n');
}

// tabela de despacho: array de ponteiros de função, indexado por um
// "código de operação" -- o mesmo padrão de uma tabela de chamadas de
// sistema ou de um vetor de interrupções
int (*tabela_operacoes[3])(int, int) = { soma, subtrai, multiplica };

void tabela_despacho(void)
{
    int i;
    for (i = 0; i < 3; i++) {
        print_int(tabela_operacoes[i](6, 2));
        putchar(' ');
    }
    putchar('\n');
}

// callback: uma função recebendo outra função como parâmetro
void aplica(int (*f)(int, int), int a, int b)
{
    print_int(f(a, b));
    putchar('\n');
}

// struct com ponteiro de função: o padrão de uma "tabela de comandos"
struct Comando {
    char letra;
    int (*executa)(int, int);
};

struct Comando comandos[3] = {
    { 'S', soma },
    { 'D', subtrai },
    { 'M', multiplica },
};

void tabela_comandos(void)
{
    int i;
    for (i = 0; i < 3; i++) {
        putchar(comandos[i].letra);
        putchar('=');
        print_int(comandos[i].executa(8, 3));
        putchar(' ');
    }
    putchar('\n');
}

int main(void)
{
    ponteiro_simples();
    tabela_despacho();
    aplica(soma, 20, 5);
    aplica(multiplica, 20, 5);
    tabela_comandos();
    return 0;
}
