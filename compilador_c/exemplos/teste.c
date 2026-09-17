#include "mancha.h"

int main() {
    puts("Clock antes do set:");
    print_int(retorna_clock_max());
    putchar('\n');
    set_clock_max(12345);
    puts("Clock depois do set:");
    print_int(retorna_clock_max());
    putchar('\n');
    puts("Clock atual: ");
    print_int(retorna_clock_atual());
    putchar('\n');
}