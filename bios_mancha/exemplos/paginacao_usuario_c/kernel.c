// kernel.c -- a mesma ideia de ../paginacao_usuario.asm (2 processos
// alternados por um escalonador round-robin, cada um em modo usuário
// de verdade, isolados por PAGINAÇÃO), mas com os processos escritos
// no subconjunto de C do mcc, no mesmo espírito de
// ../multitarefa_c/kernel.c.
//
// LEIA ISTO -- a diferença mais importante em relação à versão em
// assembly puro (../paginacao_usuario.asm): lá, cada processo tinha seu
// PRÓPRIO quadro físico de código (uma entrada de tabela mapeando a
// página 0 de código diretamente para o código daquele processo, com
// "ip" inicial = 0 virtual). Isso não funciona para código compilado
// pelo mcc: o compilador só gera `jmp`/`jmpc`/`call` ABSOLUTOS, nunca
// relativos (`bra`/`brac`), então não há como fazer esse código rodar
// com um endereço de código "deslocado" -- um `jmp`/`call` absoluto
// faria a CPU somar a base da tradução duas vezes (uma de verdade,
// pela tradução; outra escondida, porque o endereço resolvido pelo
// montador já embute a posição física real), desviando para o lugar
// errado. Ver ../paginacao_usuario.asm para a explicação completa
// dessa restrição (lá ela é contornada escrevendo o código à mão só
// com desvios relativos -- aqui não dá, já que o mcc gera o código).
//
// A solução aqui só é possível por uma propriedade específica de
// paginação: a tradução é feita PÁGINA POR PÁGINA (512 bytes cada), de
// forma totalmente independente -- nada impede que uma página mapeie
// para "ela mesma" enquanto a vizinha mapeia para outro lugar. Em vez
// de desligar a paginação para o código, este exemplo mantém `P=1` o
// tempo todo, mas preenche as entradas de CÓDIGO da tabela de páginas
// de cada processo com um mapeamento por IDENTIDADE (página N -> quadro
// N, o mesmo número -- ver `preenche_identidade`, em `ponte.asm`): isso
// faz endereço virtual == endereço físico para código, exatamente como
// se a tradução nem existisse, então todo `jmp`/`jmpc`/`call` absoluto
// continua funcionando. Só a entrada de DADOS (página 0, índice 128 da
// tabela) é DIFERENTE entre os dois processos -- é ali que a isolação
// de verdade acontece.
//
// Os dados de cada processo (a página física de 512 bytes onde o
// contador realmente mora) NÃO são declarados aqui como um array C --
// um "int dados_processo_a[32]" comum não teria como garantir que essa
// área começa EXATAMENTE num múltiplo de 512 bytes, e paginação exige
// isso (a área é referenciada por NÚMERO DE QUADRO, não por um
// endereço qualquer). Por isso essas áreas (e as duas tabelas de
// página) são reservadas em assembly (`dados.asm`, com `.org`), e
// chegam aqui só como ENDEREÇOS (ponteiros comuns) recebidos por
// parâmetro.

#define N_PROCESSOS 2

// implementada em ponte.asm -- por dentro faz "trap 7" (chamada de
// sistema), não "outb" direto: os processos rodam em modo usuário de
// verdade (sem o bit I ligado), então "outb" causaria a interrupção 2
// (instrução privilegiada). "trap" funciona em qualquer modo (é o
// mecanismo pensado exatamente para isso), então uma função C comum,
// chamada por uma "call" normal sem elevar privilégio nenhum, pode
// contê-la sem problema -- é como um "write()" de biblioteca de
// verdade funciona por baixo dos panos.
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

int processos[32];     // tabela achatada de quadros salvos (2 * 16 palavras)
int processo_atual;

// monta o quadro inicial (16 palavras) do processo "indice" e preenche
// a entrada de DADOS (índice 128) da tabela de páginas dele -- as
// entradas de CÓDIGO (identidade) já foram preenchidas por
// preenche_identidade, em ponte.asm, antes desta função ser chamada.
//
//   tabela              endereço físico da tabela de páginas do
//                         processo (256 entradas de 2 bytes = 512
//                         bytes -- reservada em ponte.asm)
//   area_dados            endereço físico da página de dados do
//                           processo (também 512 bytes, também de
//                           ponte.asm -- TEM que ser múltiplo de 512)
//   entrada_processo        onde o processo deve começar a rodar
//                             (processoA/processoB)
void monta_quadro(int indice, int *tabela, int *area_dados, void (*entrada_processo)(void))
{
    int base;
    int quadro_dados;
    int *entrada_tabela;

    base = indice * 16;
    processos[base + 6] = 512;                    // sp inicial (virtual): topo da página de dados
    processos[base + 7] = (int) entrada_processo;     // ip inicial: endereço FÍSICO real
                                                          // (código em identidade -- ver topo do arquivo)
    processos[base + 8] = 0x4000;                           // sr: S=0,P=1,I=0,D=0 -- usuário, paginação
    processos[base + 12] = (int) tabela;                       // s4 = pt
    processos[base + 13] = 0;                                     // s5 (não usado sob paginação)
    processos[base + 14] = 0;                                        // s6 (não usado sob paginação)
    processos[base + 15] = 0;                                           // s7 (não usado sob paginação)

    quadro_dados = ((int) area_dados) >> 9;      // número do quadro físico = endereço / 512
    entrada_tabela = tabela + 128;                  // entrada 128 = página 0 de DADOS
    *entrada_tabela = 0xE000 | quadro_dados;           // tipo=3 (leitura/escrita), acesso=1
}

// chamada por ponte.asm/_kernel_inicio, depois de preenche_identidade
// já ter preparado as entradas de código das duas tabelas.
void inicializa_processos(int *quadro_boot, int *tabela_a, int *dados_a,
                           int *tabela_b, int *dados_b)
{
    int i;
    monta_quadro(0, tabela_a, dados_a, processoA);
    monta_quadro(1, tabela_b, dados_b, processoB);
    processo_atual = 0;
    for (i = 0; i < 16; i++) {
        quadro_boot[i] = processos[i];
    }
}

// o escalonador -- idêntico ao de ../multitarefa_c/ (só move os 16
// valores de um lugar para o outro, não precisa saber o que eles
// significam).
void escalonador(int *quadro, int *processos_tab, int *pproc)
{
    int atual;
    int i;
    int base;

    atual = *pproc;
    base = atual * 16;
    i = 0;
    while (i < 16) {
        processos_tab[base + i] = quadro[i];
        i = i + 1;
    }

    atual = atual + 1;
    if (atual >= N_PROCESSOS) {
        atual = 0;
    }
    *pproc = atual;

    base = atual * 16;
    i = 0;
    while (i < 16) {
        quadro[i] = processos_tab[base + i];
        i = i + 1;
    }
}
