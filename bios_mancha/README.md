# Uma BIOS mínima para o Mancha completo

`bios_mancha` é uma base de firmware para quem for implementar um
sistema operacional sobre o
[simulador do Mancha completo](../simulador_completo/): vetor de
interrupções pronto, handlers padrão de exceção, drivers de console/
disco/relógio, e um mecanismo de chamada de sistema (`trap 7`).

```
seukernel.asm + src/bios.asm --[montador]--> seukernel.mob --[simulador]--> executa
```

## Sumário

1. [Uso](#uso)
2. [O vetor de interrupções](#o-vetor-de-interrupções)
3. [O quadro de 16 palavras](#o-quadro-de-16-palavras)
4. [Interface da BIOS](#interface-da-bios)
5. [pilha_sistema vs. pilha_nucleo](#pilha_sistema-vs-pilha_nucleo)
6. [Chamadas de sistema](#chamadas-de-sistema)
7. [Escalonador (multitarefa preemptiva)](#escalonador-multitarefa-preemptiva)
8. [Escalonador implementado em C](#escalonador-implementado-em-c)
9. [Processos de usuário com paginação real](#processos-de-usuário-com-paginação-real)
10. [O mesmo exemplo, com os processos em C](#o-mesmo-exemplo-com-os-processos-em-c)
11. [Carregando o código de um processo do disco, em tempo de execução](#carregando-o-código-de-um-processo-do-disco-em-tempo-de-execução)
12. [O mesmo exemplo de disco, com os processos em C](#o-mesmo-exemplo-de-disco-com-os-processos-em-c)
13. [Exemplos](#exemplos)
14. [Validação](#validação)

## Uso

```sh
make                # monta src/bios.asm com cada exemplos/*.asm
```

Para um kernel próprio:

```sh
montador src/bios.asm meukernel.asm -o meukernel.mob
```

O único requisito é que `meukernel.asm` defina um rótulo
`_kernel_inicio`: é para lá que a BIOS salta depois de inicializar,
**com as interrupções externas ainda desligadas** (`SR.D=1`) -- para que
a inicialização do kernel (montar tabela de processos, tabela de
`syscalls`, programar o relógio, etc.) não seja interrompida no meio.
Ligue com a instrução `ei` quando o kernel estiver pronto para receber
interrupções.

## Vetor de interrupções

Os primeiros 128 bytes da memória real (endereço 0) são 16 quadros de 4
palavras (`ip, sp, cs, ds`) cada -- 8 bytes por quadro, um por número de
interrupção (mancha.pdf, secção 7). `ip=0` num quadro significa
"interrupção ignorada" (é assim que memória zerada se comporta por
padrão). `src/bios.asm` já define os 16:

| nº | uso | quem trata |
|---|---|---|
| 0 | início de operação (boot) | `_start` |
| 1 | violação de segmento | pânico (mensagem + para) |
| 2 | instrução privilegiada | pânico |
| 3 | divisão por zero | pânico |
| 4 | instrução ilegal | pânico |
| 5 | ausência de quadro (paginação) | pânico |
| 6 | *livre* | -- |
| 7 | chamada de sistema | despachante de `syscalls` (ver abaixo) |
| 8 | console | driver de console (buffer circular) |
| 9 | disco | (E/S síncrona nesta BIOS -- ver comentário em `bios.asm`) |
| 10 | relógio | conta tiques + chama o escalonador, se instalado |
| 11-15 | *livres* | -- |

Os vetores 6 e 11-15 ficam livres de propósito, para o kernel usar como
quiser (mais chamadas de sistema em vetores diferentes, por exemplo --
embora usar só o 7 com um número de chamada em `r0`, como esta BIOS já
faz, normalmente seja mais prático que ocupar vários vetores).

Cada quadro tem seu próprio `cs`/`ds`: dá para, por exemplo, rodar todo
handler de interrupção em segmentação plana mesmo com processos de
usuário já paginados -- evita o handler ter que lidar com a MMU do outro
processo antes de conseguir tratar a falta dele.

## O quadro de 16 palavras

Toda interrupção/`trap` empilha os 16 registradores do contexto
interrompido, na pilha indicada pelo quadro do vetor (não importa qual
fosse o `sp` de quem foi interrompido -- ver a próxima seção). A ordem,
do endereço **mais baixo** para o mais alto (é a ordem que `rete` espera
para desempilhar, e a mesma usada por `bios_copia_quadro`):

```
sp+0   r0          sp+16  s0 (sr)
sp+2   r1          sp+18  s1
sp+4   r2          sp+20  s2
sp+6   r3          sp+22  s3
sp+8   r4          sp+24  s4 (cs/pt)
sp+10  bp          sp+26  s5 (cl)
sp+12  sp (antigo)  sp+28  s6 (ds)
sp+14  ip (antigo)   sp+30  s7 (dl)
```

Isso é útil, por exemplo, para os handlers de pânico lerem "em que
endereço a exceção aconteceu" (`(sp+14)`) sem precisar de mais nada.

## Interface da BIOS

Convenção de chamada: **diferente** do compilador C do Mancha completo
(que empilha argumentos), as rotinas da BIOS recebem argumentos em `r0`,
`r1`, `r2`, `r3` (nessa ordem) e devolvem o resultado (se houver) em
`r0` -- mais direto para escrever/ler em assembly de mão. `r0`-`r4` são
sempre considerados "sujos" depois de um `call` (nenhum é preservado).

| rotina | argumentos | efeito |
|---|---|---|
| `bios_putc` | r0=caractere | escreve 1 caractere na console |
| `bios_imprime` | r0=endereço de string terminada em 0 | escreve a string |
| `bios_imprime_dec` | r0=valor com sinal | escreve um inteiro decimal |
| `bios_imprime_hex` | r0=valor | escreve 4 dígitos hexadecimais |
| `bios_console_disponivel` | -- | r0 = diferente de 0 se há caractere esperando |
| `bios_console_le` | -- | r0 = próximo caractere (não verifica disponibilidade) |
| `bios_disco_le_setor` | r0=face,r1=trilha,r2=setor,r3=endereço destino | lê 1 setor (512 bytes) do disco 0, bloqueante |
| `bios_disco_escreve_setor` | r0=face,r1=trilha,r2=setor,r3=endereço fonte | escreve 1 setor no disco 0, bloqueante |
| `bios_disco_erro` | -- | r0 = diferente de 0 se a última operação deu erro |
| `bios_copia_quadro` | r0=origem,r1=destino | copia um quadro de 16 palavras (32 bytes) -- ver [Escalonador](#escalonador-multitarefa-preemptiva) |

E três variáveis de dados:

- **`tabela_syscalls`** (16 palavras): endereços dos handlers de
  chamada de sistema, por número (0-15). Uma entrada em 0 (o padrão,
  `_start` já zera tudo) significa "não implementada" -- devolve -1.
- **`retomada_escalonador`** (1 palavra): endereço do escalonador do
  kernel, para ligar multitarefa preemptiva. 0 (o padrão) = sem
  escalonador, o relógio só conta tiques.
- **`contador_tiques`** (1 palavra): incrementado a cada estouro do
  relógio, antes de olhar `retomada_escalonador`.

Só a unidade 0 de disco é endereçável (as portas de face/trilha/setor/
endereço do simulador são fixas na unidade 0, independente do campo de
unidade do byte de operação -- ver
`../simulador_completo/src/dispositivos.c`). E/S de disco aqui é sempre
síncrona (a BIOS espera terminar antes de devolver o controle);
implementar E/S assíncrona de verdade (suspendendo o processo chamador
em vez de girar num laço) é um bom exercício de continuação.

## pilha_sistema vs. pilha_nucleo

**Todo quadro do vetor de interrupções tem um endereço de pilha FIXO.**
A cada interrupção/`trap`, a CPU reescreve `sp` para o valor daquele
campo e empilha o quadro de 16 palavras a partir dali -- não importa
onde `sp` estivesse antes. `src/bios.asm` usa `pilha_sistema` (0xF000)
para *todos* os vetores. Isso significa que `pilha_sistema` só é segura
para o que empilha e desempilha inteiramente **dentro de um único
atendimento de interrupção** -- nada que precise sobreviver a um `rete`
pode morar lá, porque a próxima interrupção (mesmo uma causada pelo
próprio handler, ou uma chamada de sistema feita pelo próprio kernel)
reescreve por cima.

Por isso o kernel roda numa pilha **separada**, `pilha_nucleo` (0xE000):
`_start` troca `sp` para lá antes de fazer qualquer `call` ou chamar
`_kernel_inicio`. Se o seu kernel precisar de mais do que os 4KB entre
`pilha_nucleo` e `pilha_sistema`, ajuste as constantes no topo de
`bios.asm` (só não deixe elas se sobrepor, nem sobrepor a área de
código/dados da BIOS e do kernel).

## Chamadas de sistema

```asm
        ld      r0, NUMERO_DA_CHAMADA
        ld      r1, primeiro_argumento
        ld      r2, segundo_argumento
        trap    7
        ; resultado em r0
```

O kernel instala um handler escrevendo seu endereço em
`tabela_syscalls[numero]`:

```asm
        ld      r0, NUMERO_DA_CHAMADA
        add     r0, r0                  ; índice * 2 (2 bytes por entrada)
        add     r0, tabela_syscalls
        ld      r1, meu_handler
        st      r1, (r0)
```

O handler recebe o número em `r0` (pode ignorar) e os argumentos em
`r1`..`r4`, devolve o resultado em `r0` e termina com `ret` -- **não**
`rete`; quem faz o `rete` de verdade é o despachante da BIOS.

Um detalhe sutil que vale entender (está comentado em `_bios_chamada_sistema`,
em `bios.asm`): `rete` restaura `r0` a partir do **quadro empilhado na
pilha**, não do registrador `r0` ao vivo no momento do `rete`. Então,
para o valor que o handler deixou em `r0` realmente "voltar" para quem
chamou, o despachante da BIOS grava esse valor de volta no lugar certo
da pilha (`st r0, (sp)`) antes do `rete`. Isso já é feito --
só é importante saber *por que* isso é necessário, caso decida escrever
seu próprio mecanismo de retorno de valores em outro contexto (por
exemplo, se seu escalonador precisar "injetar" um valor de retorno
diferente ao acordar um processo bloqueado).

## Escalonador (multitarefa preemptiva)

Ligar multitarefa preemptiva é só:

```asm
        ld      r0, meu_escalonador
        st      r0, (retomada_escalonador)
```

A cada estouro do relógio, se `retomada_escalonador` não for 0, a BIOS
salta (por `jmp`, não `call`) para lá, com `sp` apontando para o quadro
de 16 palavras recém-empilhado do processo interrompido. O escalonador
termina escolhendo um processo (possivelmente outro) e executando
`rete`.

**Por causa do que a seção anterior explica** (todo vetor usa um
endereço de pilha fixo), o quadro do processo interrompido **não fica
guardado "na pilha dele"** -- ele aparece sempre no mesmo lugar
(`pilha_sistema-32`) e seria sobrescrito na próxima interrupção. Um
escalonador de verdade, portanto, não pode só trocar `sp`: ele precisa

1. **copiar** esse quadro para uma área reservada só daquele processo
   (com `bios_copia_quadro`);
2. escolher o próximo processo;
3. **copiar de volta** a área salva do processo escolhido para
   `pilha_sistema-32`;
4. `rete`.

Isso é exatamente o que `exemplos/multitarefa.asm` faz -- leia os
comentários lá, especialmente o de `escalonador:`. A vantagem de tudo
isso (o que faz a troca de contexto sair "de graça" no Mancha, apesar
dessa complicação) é que os 16 registradores -- inclusive `sr` e `sp` --
são sempre salvos/restaurados automaticamente pelo hardware a cada
interrupção; o escalonador só move bytes de um lugar para o outro, não
precisa entender o significado de nenhum deles.

Para "iniciar" o primeiro processo (não há uma interrupção anterior de
onde partir), o kernel monta manualmente um quadro "de mentira" com os
valores iniciais desejados (`ip`=ponto de entrada, `sp`=topo da pilha de
trabalho do processo, `sr`=modo desejado, resto zerado) e faz a mesma
cópia + `rete` que o escalonador faria -- ver `_kernel_inicio` em
`multitarefa.asm`.

**Cuidado com o período do relógio**: `disp_tick` (que conta os tiques)
roda a cada instrução executada de verdade, *inclusive* quando essa
"instrução" foi na verdade o atendimento de uma interrupção -- então o
tempo que o **próprio escalonador** leva para rodar também consome 
tempo do relógio. Se o período configurado for menor que o custo do
escalonador (duas cópias de 16 palavras custam uns 200+ instruções
juntas), o relógio estoura de novo *ainda dentro* do escalonador; como
`D=1` durante todo atendimento de interrupção, essa segunda interrupção
fica pendente e dispara imediatamente assim que `rete` restaura `D=0` --
o processo escolhido nunca chega a executar nem uma instrução antes de
ser trocado de novo, e a "multitarefa" trava sempre no mesmo processo.


Este exemplo roda todo processo em **modo supervisor**, de propósito,
para isolar o conceito de escalonamento do de proteção de memória (que
já está demonstrado em `../simulador_completo/exemplos/protecao.asm` e
`paginacao.asm`). Combinar os dois -- processos de usuário de verdade,
com `S=0` e limites de segmento/paginação configurados por processo -- é
o passo natural seguinte.

## Escalonador implementado em C

`exemplos/multitarefa.asm` (seção anterior) escreve o escalonador todo em
assembly. `exemplos/multitarefa_c/` faz o mesmo exemplo (3 processos,
round-robin, disparado pelo relógio), mas com o **escalonador -- e os
próprios processos -- escritos no subconjunto de C do
[mcc](../../compilador_c/)**. A ideia é mostrar que, uma vez estabelecida
uma pequena "ponte" entre a convenção de chamada da BIOS e a convenção do
mcc, o resto de um kernel de brinquedo pode ser C de verdade -- laços,
ponteiros, structs -- sem precisar reescrever a lógica em assembly.

### Duas convenções de chamada, uma ponte

A BIOS (esta, `bios.asm`) usa uma convenção: argumentos em `r0..r3`,
resultado em `r0`, nada empilhado. O mcc usa outra, documentada em
`../../compilador_c/README.md` ("convenção de chamada"): argumentos
empilhados da direita para a esquerda antes do `call`, resultado em
`r0`, e toda função gerada tem um rótulo `_f_<nome>` com seu próprio
prólogo/epílogo (`push bp` / `ld bp,sp` / ... / `ld sp,bp` / `pop bp` /
`ret`). As duas convenções não são intercambiáveis: chamar uma função
gerada pelo mcc como se fosse uma rotina da BIOS (ou vice-versa) deixa a
pilha desbalanceada.

`exemplos/multitarefa_c/ponte.asm` é a única coisa deste exemplo escrita
à mão em assembly, e ela existe só para:

1. **Traduzir a chamada do escalonador**: `escalonador_trampolim` (é
   isso que fica instalado em `retomada_escalonador`, chamado pela BIOS
   por `jmp`) empilha os 3 argumentos do jeito que o mcc espera e faz um
   `call _f_escalonador` de verdade -- daí em diante, `escalonador()` é
   uma função C comum, compilada pelo mcc a partir de `kernel.c`.
2. **Programar portas de E/S e ligar interrupções** (`outb`, `ei`) --
   coisas que a linguagem C deste compilador não expõe (sem inline
   assembly, sem acesso a porta).
3. **Iniciar o primeiro processo** com um `rete` manual (mesma técnica
   de `_kernel_inicio` em `multitarefa.asm`).

O truque que faz o escalonador em C funcionar sem nenhuma cópia extra:
`escalonador(int *quadro, ...)` recebe o endereço **fixo** onde a CPU
acabou de empilhar o contexto do processo interrompido (o mesmo endereço
de onde `rete` vai ler de volta, ver
[pilha_sistema vs. pilha_nucleo](#pilha_sistema-vs-pilha_nucleo)) como um
ponteiro comum. A função C escreve o resultado **direto nesse endereço**
via `quadro[i] = ...` -- não existe um "valor de retorno" separado para
copiar de volta; quando `escalonador()` retorna, o quadro já está
pronto para o `rete` que vem logo depois, em `ponte.asm`.

### Ponteiro de função

O mcc suporta ponteiro de função (ver `../../compilador_c/README.md`,
"Ponteiros de função") -- a tabela de pontos de entrada dos processos também é
montada em C, direto em `kernel.c`:

```c
void (*pontos_entrada[N_PROCESSOS])(void) = { processoA, processoB, processoC };
```

A montagem do quadro inicial de cada processo (`monta_quadro_inicial`,
usando `pontos_entrada[i]` como `ip`) também é C. O que sobra em
`ponte.asm` é só o que a linguagem realmente não expõe: programar portas
de E/S, ligar interrupções, e o `rete` manual -- referenciando as
variáveis/funções de `kernel.c` só pelos rótulos que o mcc gera
(`_g_processos`, `_g_processo_atual`, `_f_inicializa_processos`,
`_f_escalonador`), sem precisar saber o que tem dentro delas.

Isso mostra bem o que ponteiro de função destrava num kernel escrito
neste subconjunto de C: sem ele, qualquer tabela de despacho (a de
pontos de entrada de processos aqui, mas o mesmo vale para um vetor de
interrupções ou uma tabela de chamadas de sistema escritos em C) tinha
que ser montada em assembly à parte -- com ele, a tabela é só um array
comum, inicializado com os nomes das funções, do jeito mais direto
possível.

### Arquivos

```
exemplos/multitarefa_c/
  kernel.c     escalonador(), os três processos, a tabela de pontos de
                entrada (pontos_entrada[], um array de ponteiros de
                função) e a montagem dos quadros iniciais -- tudo C de
                verdade, compilado pelo mcc
  ponte.asm    a ponte: _kernel_inicio, escalonador_trampolim, e a
                função escreve_caractere (bridge pra outb) -- sem
                nenhum dado estático próprio
  Makefile     mcc kernel.c -o kernel.asm; depois monta
                bios.asm + ponte.asm + kernel.asm juntos
```

## Processos de usuário com paginação real

Todos os exemplos anteriores (`multitarefa.asm`/`multitarefa_c/`) rodam
seus processos em **modo supervisor**, com paginação desligada
(`P=0`) -- então endereço virtual e endereço físico coincidem e nada é
verificado. Isso foi uma escolha deliberada naqueles exemplos, para
isolar o conceito de escalonamento do de proteção de memória.

`exemplos/paginacao_usuario.asm` junta os dois: **2 processos
alternados por um escalonador round-robin** (a mesma mecânica de
`multitarefa.asm`, reaproveitada sem nenhuma mudança), mas agora cada
processo roda em **modo usuário de verdade** (`S=0`, `I=0` no `sr` de
cada um), isolado por **paginação** (mancha.pdf, secção 8) -- o bit `P`
de `sr` liga esse modo, com cada processo tendo sua **própria tabela de
páginas**, mapeando páginas de código e de dados para quadros físicos
diferentes, com a proteção realmente aplicada pela CPU -- o mesmo tipo
de mecanismo de `../simulador_completo/exemplos/protecao.asm`, agora
por página em vez de por um único segmento com base e limite.

### Por que o código de cada processo só pode usar desvios relativos

Esta é a parte genuinamente nova (e fácil de errar): quando a tradução
de endereço soma uma base física diferente da identidade ao endereço
virtual, um `jmp etiqueta` comum deixa de funcionar dentro do código
traduzido. O motivo: o montador resolve `etiqueta` para um endereço
**absoluto**, calculado a partir de onde o código realmente foi
colocado na memória física -- e com a página de código mapeada para um
quadro físico diferente do seu próprio número, esse endereço absoluto
já embutido no `jmp` **já é** o endereço físico final. Na próxima busca
de instrução, a CPU aplicaria a tradução de novo (`quadro_físico × 512
+ deslocamento`) por cima de um valor que já é físico, somando a base
**duas vezes** (uma de verdade, pela tradução; outra escondida, porque
o endereço resolvido pelo montador já embute a posição física real) --
desviando para o lugar errado.

A saída são as instruções de desvio **relativas** -- `bra`/`brac`/
`braq` (mancha.pdf, secção 10): o montador resolve o alvo delas como
`valor_do_símbolo - endereço_da_próxima_instrução`, um deslocamento em
bytes, somado ao `ip` **em tempo de execução** -- por isso funciona
certo seja qual for a base da tradução. Por essa razão, `codigo_a`/
`codigo_b`, em `paginacao_usuario.asm`, usam só `bra` (desvio
incondicional) e `brac` (condicional, alcance curto) para controle de
fluxo -- nunca `jmp`/`jmpc`/`call` para dentro do próprio código. O
código do **kernel** (`_kernel_inicio`/`escalonador`/
`sys_escreve_impl`) não tem essa restrição -- ele sempre roda com
paginação desligada (`P=0`, o valor fixo de todo quadro do vetor de
interrupções, nunca alterado), então `jmp`/`jmpc` comuns funcionam nele
sem problema, exatamente como em `multitarefa.asm`.

Pela mesma razão, o quadro salvo de cada processo guarda `ip=0` (não o
endereço absoluto de `codigo_a`/`codigo_b`) -- é o mapeamento da página
0 de código, na tabela de páginas daquele processo, que já aponta para
o quadro físico certo; o processo sempre começa a rodar no endereço
**virtual** 0. Acesso a **dados** segue a mesma lógica: o contador de
cada processo é lido/escrito como `(r3)` com `r3` carregado do literal
numérico `0` (o endereço virtual 0 da página de dados do processo),
nunca por um rótulo absoluto como `dados_a` (que resolveria para o
endereço físico, errado pelo mesmo motivo).

### A mecânica de paginação, em poucas palavras

Com `P=1`, o registrador de supervisor `s4` -- chamado **`pt`** nesse
modo, em vez de `cs` -- aponta para uma **tabela de páginas** de até
256 entradas de 2 bytes. O endereço virtual de 16 bits é dividido em
**página** (7 bits mais altos) e **deslocamento** dentro da página (9
bits mais baixos -- páginas de 512 bytes). Acessos de **código** usam
as entradas 0-127 da tabela (uma por página de código); acessos de
**dados** usam as entradas 128-255 (a mesma tabela, a segunda metade)
-- por isso `pt` é o **único** registrador de supervisor realmente
usado sob paginação (`s5`/`s6`/`s7` do quadro de cada processo, neste
exemplo, ficam em `0`, sem efeito nenhum).

Cada entrada da tabela tem 3 bits de controle (**tipo**: `0`=ausente,
`1`=só leitura, `2`=leitura/escrita "limpa", `3`=leitura/escrita "já
modificada"; e 1 bit de **acesso**) nos bits mais altos, e o **número
do quadro físico** (0 a 8191) nos 13 bits mais baixos -- o endereço
físico final é `quadro_físico × 512 + deslocamento`. Uma entrada com
tipo `0` (o padrão, já que a memória começa zerada) causa a
interrupção 5 (**ausência de quadro**) se o processo tentar alcançar
essa página -- uma proteção de verdade, não só a tradução de endereço
(ver a subseção seguinte).

Por causa do tamanho fixo do quadro físico (512 bytes), toda estrutura
que precisa ser referenciada por número de quadro -- o **código** e os
**dados** de cada processo, não a tabela de páginas em si, que é só um
endereço físico comum -- precisa estar alinhada a um múltiplo de 512
bytes. `paginacao_usuario.asm` usa `.org` para isso: `0x1000`/`0x1200`
para as duas tabelas, `0x1400`/`0x1600` para o código dos dois
processos (quadros 10 e 11), `0x1800`/`0x1A00` para os dados (quadros
12 e 13) -- `0x1000` foi só escolhido confortavelmente maior que
`bios.asm` + o código do kernel, para não precisar calcular o fim exato
de nenhum dos dois.

### Um bug real do simulador, encontrado e corrigido para este exemplo existir

Diferente dos dois exemplos anteriores, este aqui não funcionou de
primeira -- expôs um bug genuíno em
`../simulador_completo/src/cpu.c`, na função `cpu_interrompe` (o código
comum a toda interrupção/`trap`, usado por **todo** exemplo deste
projeto, não só os de paginação).

Toda interrupção zera `cs`/`ds` para os valores fixos do quadro do
vetor correspondente (sempre `0` em `bios.asm`) e liga `S`, `I` e `D`
em `sr` -- mas, antes da correção, **não desligava o bit `P`**. Se o
que foi interrompido estivesse com paginação ativa (`P=1`), o próprio
atendimento da interrupção continuaria traduzindo endereços com `P=1`
e `pt` (o mesmo `s4` que o campo "cs" do quadro zera) já resetado para
`0` -- ou seja, toda tradução subsequente (a partir do **próprio**
empilhamento do contexto interrompido, que já acontece dentro de
`cpu_interrompe`, antes de qualquer código do kernel rodar) passaria a
ler "entradas de tabela de páginas" de dentro do vetor de interrupções
(endereço físico `0`) -- um resultado sem sentido, essencialmente
garantido de travar ou corromper memória assim que a primeira
interrupção chegasse a um processo paginado.

Nenhum exemplo anterior -- nem mesmo
`../simulador_completo/exemplos/paginacao.asm`, o demo original de
paginação -- jamais expôs isso, porque nenhum disparava uma
interrupção estando com `P=1`: aquele exemplo liga a paginação, faz
alguns acessos a dado, e termina com um `halt` direto (que não passa
pelo mecanismo de interrupção -- só marca a CPU como parada). Combinar
paginação com multitarefa preemptiva de verdade (o relógio interrompe
o processo, e o processo também usa `trap` para chamadas de sistema)
é o que a este exemplo precisava, e isso nunca tinha sido exercitado.

A correção é de uma linha, no mesmo lugar onde `S`/`I`/`D` já eram
ligados:

```c
// antes:
cpu->s[0] |= (SR_S | SR_I | SR_D);
// depois:
cpu->s[0] = (uint16_t)((cpu->s[0] & ~(uint16_t)SR_P) | (SR_S | SR_I | SR_D));
```

A correção foi validada com a suíte de regressão completa do projeto
(todo `.mob` de `compilador_c/`, `bios_mancha/` e seus subexemplos) --
nenhum resultado mudou, porque nenhum outro exemplo jamais passava por
esse caminho com `P=1` (confirma que o bug realmente nunca tinha sido
exercitado, e que a correção não quebra nada que já funcionava).

### A proteção funciona de verdade

Não é só a tradução de endereço que muda -- a ausência de uma entrada
válida na tabela de páginas é realmente verificada pela CPU (`cpu.c`,
função `traduz`: uma entrada com tipo `0` causa a interrupção 5). Um
teste rápido (não incluído no exemplo principal, para não interromper
a demonstração contínua) confirma isso: um processo tentando ler uma
página de dados cuja entrada na tabela nunca foi preenchida (tipo
"ausente", o valor padrão de memória zerada) recebe imediatamente a
interrupção 5, tratada pelo handler de pânico já existente na BIOS --
`"EXCECAO: ausencia de quadro (pagina) em ip=0006"` -- e a máquina
pára, exatamente como aconteceria com um bug real de um processo
tentando alcançar uma página que nunca lhe foi atribuída.

## O mesmo exemplo, com os processos em C

`exemplos/paginacao_usuario_c/` repete a ideia de
`paginacao_usuario.asm` (2 processos em modo usuário, alternados por um
escalonador round-robin, cada um com seu próprio contador isolado em
memória, isolados por paginação), mas com os **processos escritos em
C**, compilados pelo mcc -- no mesmo espírito de
[Escalonador implementado em C](#escalonador-implementado-em-c).

### Por que o código dos processos não pode simplesmente usar páginas "deslocadas", como o de `paginacao_usuario.asm`

Tentar repetir a ideia da versão em assembly (página de código do
processo mapeada para um quadro físico qualquer, diferente do seu
próprio número) com código compilado pelo mcc não funciona -- e vale a
pena entender exatamente por quê, porque é uma limitação genuína,
descoberta ao escrever este exemplo, não uma limitação do processador
Mancha.

Todo `if`/`while`/`for`/chamada de função que o mcc compila gera
`jmp`/`jmpc`/`call` -- **sempre**, o compilador não tem (e hoje não
pode ter, sem mudanças nele) um modo de gerar desvios relativos como
`bra`/`brac`. Esses três resolvem para um endereço **absoluto** (ver
[Por que o código de cada processo só pode usar desvios relativos](#por-que-o-código-de-cada-processo-só-pode-usar-desvios-relativos)
acima). Rodar uma função compilada pelo mcc numa página de código
mapeada para um quadro físico diferente do seu próprio número faria a
CPU somar a base da tradução **duas vezes** em todo desvio ou chamada
interno -- inclusive o primeiro `jmp` de um `while` tão simples quanto
o laço de atraso deste próprio exemplo. Não há como contornar isso sem
o compilador aprender a gerar desvios relativos (um projeto de
compilador em si, fora do escopo deste exemplo).

A solução adotada explora uma propriedade específica de paginação: a
tradução é feita **página por página** (512 bytes cada), de forma
totalmente independente -- nada impede que uma página mapeie para "ela
mesma" enquanto a página vizinha mapeia para outro lugar completamente
diferente. Em vez de desligar a paginação para o código, este exemplo
mantém `P=1` o tempo todo, mas preenche as entradas de **código** da
tabela de páginas de
cada processo com um **mapeamento por identidade** -- página `N` mapeia
para o quadro físico `N`, o mesmo número. Isso faz endereço virtual ==
endereço físico para código, exatamente como se a tradução nem
existisse -- então todo `jmp`/`jmpc`/`call` absoluto que o mcc gera
continua funcionando. Só a entrada de **dados** (página 0, índice 128
da tabela) é de fato diferente entre os dois processos -- é ali que a
isolação acontece.

`preenche_identidade`, em `ponte.asm`, é a rotina que monta esse
mapeamento (um laço simples: entrada `N` = quadro `N`, somente leitura,
bit de acesso já ligado), chamada para as duas tabelas antes de
`inicializa_processos` (em `kernel.c`) preencher a entrada de dados de
cada uma.

Como consequência direta, de dentro do processo não existe nenhuma
diferença visível entre código rodando em identidade e código rodando
sem tradução nenhuma: `processoA`/`processoB`, em `kernel.c`, acessam o
próprio contador sempre do mesmo jeito, `(int *) 0`. Só a montagem do
quadro (`sr`/`s4`, em `monta_quadro`) muda de um processo para o outro.

### Por que os dados de cada processo não são um array C comum

O compilador só resolve nomes de variável global para endereços
**absolutos** -- então os processos não podem escrever algo como
`dados_processo_a[0]` diretamente: isso resolveria para o endereço
absoluto de `dados_processo_a`, e se essa área fosse alcançada por
tradução de página, a CPU somaria a base de novo por cima de um
endereço que já é físico (o mesmo problema de código, agora para
dados). Além disso, a área de dados de cada processo precisa estar
alinhada a um múltiplo de 512 bytes, porque é alcançada por **número
de quadro** (não por um endereço qualquer) -- e o mcc não tem nenhuma
forma de forçar esse alinhamento num `int array[32];` comum. Por isso
as áreas de dados (e as duas tabelas de páginas) são reservadas em
assembly (`dados.asm`, com `.org`), e `kernel.c` só recebe seus
endereços como parâmetros simples -- construindo, em cada processo, um
ponteiro a partir de um literal numérico puro (`int *contador = (int *)
0;`, o endereço **virtual** 0 da própria página de dados), nunca um
símbolo.

### Um bug de verdade encontrado ao escrever este exemplo (não do simulador, desta vez)

Diferente da versão em assembly puro, este exemplo não funcionou de
primeira -- mas o problema, desta vez, estava no **arquivo deste
exemplo**, não no simulador (esse já tinha sido corrigido para
`paginacao_usuario.asm`).

A primeira versão declarava as duas tabelas de páginas e as duas áreas
de dados dentro de `ponte.asm`, usando `.org` para alinhá-las. O
problema: o montador trata vários `.asm` passados numa só chamada como
um módulo só, com um único contador de endereço que **continua** de um
arquivo para o próximo, na ordem dada na linha de comando -- e
`kernel.asm` (gerado a partir de `kernel.c`, com bem mais código do que
se imaginaria à primeira vista, já que o mcc não otimiza) é montado
**depois** de `ponte.asm`. Resultado: `processoA`/`processoB`
(compilados a partir de `kernel.c`) acabavam colocados em endereços
**depois** das áreas de dados que `ponte.asm` tinha reservado --
bem fora do alcance de `preenche_identidade` -- e a primeira instrução
de cada processo já causava a interrupção 5 (ausência de quadro), antes
de executar qualquer coisa.

A correção: mover as tabelas/áreas de dados para um arquivo **próprio**
(`dados.asm`), montado **por último** (depois de `kernel.asm`) -- só
assim o `.org` tem garantia de estar depois do fim de tudo que vem
antes. O Makefile deste diretório já reflete a ordem certa.

### Uma observação da validação: atomicidade de uma chamada não é atomicidade de uma sequência

Rodando por tempo suficiente, de vez em quando a saída intercala os
dois processos de um jeito mais fino do que nos exemplos anteriores --
por exemplo, `B:` de um processo seguido de `A:2 ` completo do outro,
e só então o `2 ` que faltava do primeiro. Isso **não é um bug**: cada
`trap 7` individual é atômico (o contexto inteiro é salvo/restaurado),
mas a sequência de quatro chamadas que imprime "letra:dígito " não é
protegida como um bloco -- o relógio pode (e eventualmente vai)
interromper um processo **entre** duas chamadas dessa sequência. O
processo interrompido retoma exatamente de onde parou, então nenhum
dado é perdido ou corrompido -- só a ordem de exibição na tela fica
mais "entrelaçada" do que se cada ciclo de impressão fosse uma unidade
só. É uma boa demonstração de por que sistemas reais precisam de
seções críticas quando querem que uma sequência de operações pareça
atômica para quem está observando de fora.

## Carregando o código de um processo do disco, em tempo de execução

`exemplos/paginacao_disco/` é uma terceira variação dos dois exemplos
anteriores: ainda 2 processos em modo usuário, alternados por um
escalonador round-robin, isolados por paginação -- mas agora o
**código** de cada processo nunca é montado junto com o kernel. Ele é
montado **sozinho** (`processoA.asm`/`processoB.asm`), convertido para
um binário puro, gravado num setor de um disco simulado, e **carregado
de verdade em tempo de execução** pelo próprio kernel (via
`bios_disco_le_setor`) -- direto para o quadro físico que a tabela de
páginas daquele processo aponta. Nem `bra`/`brac` (como em
`paginacao_usuario.asm`) nem mapeamento de código por identidade (como
em `paginacao_usuario_c/`) são necessários aqui.

### Por que isso elimina a restrição de desvios relativos

Quando um módulo é montado **junto** com outro -- `codigo_a`/`codigo_b`
em `paginacao_usuario.asm`, por exemplo, que compartilham o contador de
endereço com `bios.asm` e o kernel -- o montador embute em todo
`jmp`/`call` absoluto o endereço **físico** real de onde aquele código
vai acabar colocado. É exatamente isso que quebra sob tradução de
endereço (ver
[Por que o código de cada processo só pode usar desvios relativos](#por-que-o-código-de-cada-processo-só-pode-usar-desvios-relativos)).
Mas se o módulo é montado **por si só**, sem mais nada na mesma
chamada, o contador de endereço começa em 0, e todo `jmp`/`call`
resolve para um deslocamento pequeno dentro do próprio módulo -- que,
sem coincidência nenhuma, é também o endereço **virtual** que esse
código vai ter quando rodar sob paginação (todo processo começa com
`ip=0` virtual). A tradução de página garante que esse endereço
virtual pequeno sempre aponta pro quadro físico certo, seja ele qual
for -- não importa fisicamente **onde** o kernel decida copiar os
bytes depois, nem quando. Por isso `processoA.asm`/`processoB.asm`
(ver os comentários neles) usam `jmp`/`jmpc` comuns, sem nenhuma
instrução relativa.

### O `.mob` convertido para binário puro: a ferramenta `mob2bin`

O arquivo `.mob` (ver `../../simulador_completo/README.md`) já é só uma
lista de pares (endereço absoluto, byte) -- então transformar um módulo
standalone num binário "achatado" de 512 bytes (pronto para ser um
setor de disco) é trivial. A nova ferramenta `mob2bin`
(`../../simulador_completo/src/mob2bin.c`) faz isso reaproveitando
`obj_carrega`, o mesmo carregador usado pelo simulador: carrega o
`.mob` num espaço de memória limpo e despeja os primeiros N bytes
resultantes num arquivo. O Makefile deste diretório usa `mob2bin` para
converter `processoA.mob`/`processoB.mob` depois de montados, e
concatena os dois binários (512 bytes cada) num `disco.img` de 1024
bytes -- setor 0 = `processoA`, setor 1 = `processoB` (face 0, trilha
0). Um arquivo de disco menor que o tamanho real de uma unidade é
aceito pelo simulador (`disp_monta_disco`, em
`../../simulador_completo/src/dispositivos.c`) -- o resto fica zerado.

### O carregamento em si, em `_kernel_inicio`

Antes de montar os quadros iniciais dos processos, `_kernel_inicio`
chama `bios_disco_le_setor` duas vezes, lendo os setores 0 e 1 direto
para `quadro_codigo_a`/`quadro_codigo_b` -- os mesmos quadros físicos
que `tabela_pt_a`/`tabela_pt_b` apontam para a página 0 de código de
cada processo. Não há buffer intermediário: o destino passado para
`bios_disco_le_setor` já é o quadro físico final. Em `kernel.asm`, esses
quadros são só **reservados** com `.ds` (nenhum byte é montado ali) --
o conteúdo real só passa a existir depois que o kernel roda, o que é o
ponto central do exemplo: o código que vai executar ali nunca passou
pela montagem de `kernel.asm`, então o montador nunca teve chance de
embutir o endereço físico desses quadros em nada.

### Arquivos

```
exemplos/paginacao_disco/
  processoA.asm   código do processo A, montado SOZINHO -- jmp/jmpc
                    comuns, sem bra/brac
  processoB.asm   o mesmo, para o processo B
  kernel.asm      bios+kernel: escalonador, tabelas de página, e o
                    carregamento dos processos do disco em
                    _kernel_inicio
  Makefile        monta processoA.asm/processoB.asm sozinhos, converte
                    cada um com mob2bin, concatena os dois num
                    disco.img, e monta bios.asm+kernel.asm à parte
```

## O mesmo exemplo de disco, com os processos em C

`exemplos/paginacao_disco_c/` repete a ideia de `paginacao_disco/` (2
processos em modo usuário, isolados por paginação, código carregado de
um disco simulado em tempo de execução), mas com os **processos
escritos em C**, compilados pelo mcc -- no mesmo espírito de
[Escalonador implementado em C](#escalonador-implementado-em-c).

### Cada processo também é compilado e montado sozinho

A mesma ideia de
[Por que isso elimina a restrição de desvios relativos](#por-que-isso-elimina-a-restrição-de-desvios-relativos)
vale aqui, só que agora é o **mcc** quem gera os `jmp`/`jmpc`/`call`
(sempre absolutos -- o compilador não tem outro modo). `processoA.c`
tem uma única função (`processoA`), e o mcc compila as funções de um
arquivo na ordem em que elas aparecem -- então `_f_processoA` acaba
sendo o primeiro rótulo do módulo compilado, endereço `0`, exatamente
onde `ip` do processo começa (virtual). Montado **sozinho** (sem
`bios.asm`/`kernel.asm` na mesma chamada do montador), esse `0` nunca
vira um endereço físico diferente de `0` -- então todo `if`/`while`/
chamada de função que o mcc gerou continua funcionando sem identidade
de página nenhuma, exatamente como `processoA.asm`/`processoB.asm` no
exemplo em assembly puro.

### Por que `escreve_caractere` não pode morar em `ponte.asm` aqui

Nos outros exemplos em C (`multitarefa_c/`, `paginacao_usuario_c/`), a
implementação de `escreve_caractere` (o `trap 7` que os processos usam
para escrever na console) vive em `ponte.asm`, montada **junto** com o
kernel e com o código dos processos, todos no mesmo módulo. Aqui isso
não é possível: `processoA.c`/`processoB.c` são montados **sozinhos**,
sem o kernel por perto -- então qualquer função que o processo chama
precisa estar nesse MESMO módulo, ou o montador erraria com símbolo
indefinido. A saída é `escreve_caractere.asm`, um arquivo pequeno
contendo só `_f_escreve_caractere` (a mesma implementação de sempre),
montado junto com `processoA.asm`/`processoB.asm` individualmente (ver
o Makefile) -- cada processo acaba com sua **própria cópia** dessa
rotina, dentro da própria página de código. Pouco custo (são só 7
instruções) pela simplicidade de manter cada processo totalmente
autocontido.

### `kernel.c` fica mais simples que nas versões anteriores

Diferente de `paginacao_usuario_c/kernel.c`, não há nada para
`monta_quadro` preencher nas tabelas de página em tempo de execução:
tanto a entrada de **código** quanto a de **dados** de cada processo
são estáticas, escritas direto em `dados.asm` (como no exemplo em
assembly puro) -- não existe mapeamento por identidade (que dependeria
de saber, em tempo de execução, onde o código acabou) nem área de
dados "genérica" passada por parâmetro. `monta_quadro` só precisa
escrever `sr`/`pt` no quadro de 16 palavras; `ip` inicial é sempre `0`
(virtual) para qualquer processo, já que o código de cada um sempre
começa na página 0 dele -- não há "ponto de entrada" para passar como
parâmetro, porque uma função compilada num módulo separado nem tem um
endereço que faça sentido fora do próprio módulo.

### Arquivos

```
exemplos/paginacao_disco_c/
  processoA.c             o processo A -- compilado e montado SOZINHO
                             (junto só com escreve_caractere.asm)
  processoB.c             idem, processo B
  escreve_caractere.asm   _f_escreve_caractere (trap 7) -- montada
                             junto com cada processo, não com o kernel
  kernel.c                monta_quadro/inicializa_processos/
                             escalonador -- tudo em C
  ponte.asm               a ponte: _kernel_inicio (carrega o código dos
                             processos do disco), escalonador_trampolim
  dados.asm               tabelas de página JÁ preenchidas, e os
                             quadros de código (reservados)/dados --
                             MONTADO POR ÚLTIMO
  Makefile                compila cada processo e o kernel, monta cada
                             peça, converte com mob2bin, monta disco.img
```

## Exemplos

- **`ola_syscall.asm`**: duas chamadas de sistema simples (escrever um
  caractere, somar dois inteiros), sem multitarefa -- para entender o
  mecanismo de despacho isoladamente. Mostra também que um número de
  chamada não implementado devolve -1 em vez de travar o sistema.
- **`multitarefa.asm`**: 3 processos alternando por um escalonador
  round-robin preemptivo disparado pelo relógio, cada um escrevendo sua
  letra através de uma chamada de sistema -- saída
  `ABCABCABCABCABC...` (roda para sempre, de propósito: é uma demo de
  SO, não um programa que "termina").
- **`multitarefa_c/`**: o mesmo exemplo (3 processos, escalonador
  round-robin pelo relógio, saída `ABCABCABC...`), mas com o escalonador
  e os processos escritos em C (compilados pelo mcc) -- ver
  [Escalonador implementado em C](#escalonador-implementado-em-c).
- **`paginacao_usuario.asm`**: 2 processos alternados por um
  escalonador round-robin, cada um em **modo usuário** de verdade, com
  sua própria tabela de páginas, isolados por **paginação** (base
  física e proteção realmente aplicadas pela CPU) -- saída
  `A:1 B:1 A:2 B:2 ...` (o dígito é o contador de cada processo,
  guardado isoladamente na página de dados que só ele alcança) -- ver
  [Processos de usuário com paginação real](#processos-de-usuário-com-paginação-real).
- **`paginacao_usuario_c/`**: o mesmo exemplo (2 processos em modo
  usuário, saída `A:1 B:1 A:2 B:2 ...`), isolado por paginação, mas com
  os processos escritos em C -- as páginas de CÓDIGO mapeiam por
  identidade (página N → quadro N), só as de DADOS são realmente
  diferentes entre os dois processos -- ver
  [O mesmo exemplo, com os processos em C](#o-mesmo-exemplo-com-os-processos-em-c).
- **`paginacao_disco/`**: o mesmo exemplo (2 processos em modo usuário,
  isolados por paginação, saída `A:1 B:1 A:2 B:2 ...`), mas o código de
  cada processo é montado **sozinho**, convertido para binário puro, e
  carregado de um disco simulado **em tempo de execução** -- sem
  `bra`/`brac` nem mapeamento por identidade -- ver
  [Carregando o código de um processo do disco, em tempo de execução](#carregando-o-código-de-um-processo-do-disco-em-tempo-de-execução).
- **`paginacao_disco_c/`**: o mesmo exemplo de disco (saída
  `A:1 B:1 A:2 B:2 ...`), mas com os processos escritos em C,
  compilados e montados **sozinhos** (cada um junto só com uma pequena
  rotina de ponte própria) -- ver
  [O mesmo exemplo de disco, com os processos em C](#o-mesmo-exemplo-de-disco-com-os-processos-em-c).

## Validação

`bios.asm` sozinho monta sem erros (só falta `_kernel_inicio`, como
esperado, quando montado sem nenhum kernel). 

- `ola_syscall.mob`: console = `"oi!\n42\n-1\n"` (a syscall de escrita
  chamada três vezes monta "oi!", a de soma devolve 40+2=42, e o número
  9 -- não implementado -- devolve -1), pára após 367 instruções. ✓
- `multitarefa.mob`: console = `"ABCABCABCABC..."` intercalado de forma
  perfeita, estável por 2 milhões de instruções sem travar; confirmado
  também interativamente no simulador real (comandos `D0`/`C`), mostrando
  `RODANDO` e a mesma saída após 916 mil instruções. ✓ (nunca "pára" --
  é uma demo de SO de propósito, não um programa que termina)
- Handler de pânico (`div r0,r1` com `r1=0`, num kernel de teste avulso):
  imprime `"EXCECAO: divisao por zero em ip=<endereço>"` e pára de
  verdade (`halt`). ✓
- `multitarefa_c.mob`: console = `"ABCABCABCABC..."` intercalado de
  forma perfeita, estável por 2 milhões de instruções sem travar;
  confirmado também interativamente no simulador real, mostrando
  `RODANDO` e a mesma saída após 240 mil instruções. ✓ (revalidado depois
  da tabela de processos passar a ser montada em C com
  `pontos_entrada[]`, um array de ponteiros de função -- mesmo resultado,
  ver [Ponteiro de função](#ponteiro-de-função))
- `paginacao_usuario.mob`: console = `"A:1 B:1 A:2 B:2 ..."`
  intercalado de forma perfeita, estável por 2 milhões de instruções
  sem travar; confirmado também interativamente no simulador real,
  mostrando `modo=USR`, `paginacao` e `pt=1200` corretamente
  identificado na tela de registradores (com `sr=4001`: `S=0 P=1 I=0
  D=0`). ✓ Teste adicional (fora do exemplo principal, num kernel
  avulso): um processo tentando ler uma página de dados cuja entrada na
  tabela nunca foi preenchida (tipo "ausente") recebe a interrupção 5 --
  `"EXCECAO: ausencia de quadro (pagina) em ip=0006"` -- confirmando que
  a proteção por página também funciona de verdade, não só a tradução
  de endereço (ver
  [A proteção funciona de verdade](#a-proteção-funciona-de-verdade)).
  Este exemplo só passou a funcionar depois da correção em `cpu.c`
  descrita em
  [Processos de usuário com paginação real](#processos-de-usuário-com-paginação-real)
  -- sem ela, a primeira interrupção do relógio travava o kernel.
- `paginacao_usuario_c.mob`: console = `"A:1 B:1 A:2 B:2 ..."`
  intercalado (em geral por ciclo completo, mas eventualmente também no
  meio de um ciclo -- ver
  [Uma observação da validação](#uma-observação-da-validação-atomicidade-de-uma-chamada-não-é-atomicidade-de-uma-sequência)
  acima; sem perda nem corrupção de dado em nenhum dos dois casos),
  estável por 2 milhões de instruções sem travar; confirmado também
  interativamente no simulador real, mostrando `modo=USR`, `paginacao`
  e `pt` corretamente identificado (`sr=4000`: `S=0 P=1 I=0 D=0`). ✓
  Um bug real foi encontrado e corrigido durante a escrita deste
  exemplo (não do simulador, desta vez -- ver
  [Um bug de verdade encontrado ao escrever este exemplo](#um-bug-de-verdade-encontrado-ao-escrever-este-exemplo-não-do-simulador-desta-vez)):
  as áreas de dados, inicialmente declaradas em `ponte.asm`, acabavam
  fisicamente **antes** do código compilado de `kernel.c` (montado
  depois), o que empurrava `processoA`/`processoB` para fora do
  alcance do mapeamento por identidade -- corrigido movendo essas
  áreas para um arquivo próprio (`dados.asm`), montado por último.
- `paginacao_disco.mob` (com `disco.img` montado na unidade 0): console
  = `"A:1 B:1 A:2 B:2 ..."` intercalado (quase sempre por ciclo
  completo, mas com a mesma entrelaçada ocasional de
  `paginacao_usuario_c.mob`, pela mesma razão -- ver
  [Uma observação da validação](#uma-observação-da-validação-atomicidade-de-uma-chamada-não-é-atomicidade-de-uma-sequência)
  acima), estável por 2 milhões de instruções sem travar; confirmado
  também interativamente no simulador real, mostrando `modo=USR`,
  `paginacao` e `pt=1200` corretamente identificado (`sr=4000`:
  `S=0 P=1 I=0 D=0`) -- a janela de memória em volta do `ip` mostra as
  instruções de `processoB.asm` exatamente como montadas, carregadas do
  disco pelo próprio kernel. ✓ Funcionou de primeira (sem nenhum bug
  novo encontrado): `processoA.asm`/`processoB.asm` usam só `jmp`/`jmpc`
  comuns -- nem `bra`/`brac` nem mapeamento de código por identidade
  foram necessários, exatamente como previsto em
  [Por que isso elimina a restrição de desvios relativos](#por-que-isso-elimina-a-restrição-de-desvios-relativos).
- `paginacao_disco_c.mob` (com `disco.img` montado na unidade 0):
  console = `"A:1 B:1 A:2 B:2 ..."` intercalado, estável por 2 milhões
  de instruções sem travar; confirmado também interativamente no
  simulador real, mostrando `modo=USR`, `paginacao` e `pt=1200`
  corretamente identificado (`sr=4009`: `S=0 P=1 I=0 D=0`). ✓ Funcionou
  de primeira (sem nenhum bug novo encontrado): `_f_processoA` saiu do
  mcc exatamente no endereço `0` do módulo compilado sozinho, como
  previsto em
  [Cada processo também é compilado e montado sozinho](#cada-processo-também-é-compilado-e-montado-sozinho).

## Organização do código

```
src/
  bios.asm          vetor de interrupções, handlers de exceção,
                      drivers de console/disco/relógio, despachante de
                      chamadas de sistema, rotinas de impressão
exemplos/
  ola_syscall.asm    chamadas de sistema isoladas, sem multitarefa
  multitarefa.asm     3 processos + escalonador round-robin preemptivo,
                        tudo em assembly
  multitarefa_c/       mesmo exemplo, escalonador e processos em C
    kernel.c            escalonador() e os processos (compilado pelo mcc)
    ponte.asm             a ponte entre a convenção da BIOS e a do mcc
    Makefile
  paginacao_usuario.asm  2 processos em MODO USUÁRIO, cada um com sua
                           própria tabela de páginas (código e dados
                           isolados de verdade) -- mesmo escalonador de
                           multitarefa.asm, processos escritos só com
                           desvios relativos (bra/brac)
  paginacao_usuario_c/     mesmo exemplo, processos em C -- páginas de
                             código em identidade (N -> N), só as de
                             DADOS isoladas de verdade entre os dois
                             processos
    kernel.c                 processoA/processoB, escalonador() e a
                               montagem dos quadros/tabelas -- tudo em C
    ponte.asm                  a ponte -- inclui preenche_identidade,
                                 que monta o mapeamento de código
    dados.asm                    as duas tabelas de página e as duas
                                   páginas de dados -- MONTADO POR
                                   ÚLTIMO, de propósito (ver o bug real
                                   encontrado, na seção acima)
    Makefile
  paginacao_disco/           mesmo exemplo, mas o código de cada
                                processo é montado sozinho e carregado
                                de um disco simulado em tempo de
                                execução -- sem bra/brac nem
                                mapeamento por identidade
    processoA.asm               código do processo A, montado SOZINHO
    processoB.asm               idem, processo B
    kernel.asm                   escalonador, tabelas de página, e o
                                   carregamento dos processos do disco
    Makefile                      monta cada processo, converte com
                                    mob2bin, monta disco.img
  paginacao_disco_c/         mesmo exemplo de disco, processos em C --
                                cada um compilado e montado SOZINHO
    processoA.c                 processo A (compilado pelo mcc,
                                  montado sozinho)
    processoB.c                 idem, processo B
    escreve_caractere.asm        _f_escreve_caractere -- montada junto
                                   com cada processo, não com o kernel
    kernel.c                      monta_quadro/inicializa_processos/
                                    escalonador -- tudo em C
    ponte.asm                       a ponte -- carrega o código dos
                                      processos do disco
    dados.asm                         tabelas de página JÁ preenchidas,
                                        e os quadros de código/dados --
                                        MONTADO POR ÚLTIMO
    Makefile
```
