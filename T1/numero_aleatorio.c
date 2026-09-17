#include "mancha.h"

void puts_sem_n(char *s) {
    while (*s != 0) {
        putchar(*s);
        s = s + 1;
    }
}

void set_clock_max_main(int valor) {
    mancha_out(0x0022, valor >> 8);
    mancha_out(0x0023, valor);
}

int retorna_clock_atual_main() {
    return (mancha_in(0x0020) << 8) | mancha_in(0x0021);
}

int retorna_time() {
    return (mancha_in(0x0024) << 8) | mancha_in(0x0025);
}

int next = 0x001;

void srand(int seed) {
    next = seed;
}

int rand() {
    next = (next * 0x6255 + 0x3619) & 0x7FFF;
    return next;
}

int main() {
    set_clock_max_main(0x7FFF);
    srand(retorna_time());
    for (int i = 0; i < 1; i++) {
        puts_sem_n("rand: ");
        print_int((rand()));
        putchar('\n');
    }
    return 0;
}
