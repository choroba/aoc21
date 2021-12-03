#include <stdio.h>
#include <string.h>

int main(int argc, char* argv[]) {
    FILE* f = fopen(argv[1], "r");
    char bin[100];
    fscanf(f, "%s", &bin);
    int max_length = strlen(bin);
    int size = 0;
    while (1) {
        char c = fgetc(f);
        if (feof(f)) break;

        if (c == '\n') ++size;
    }

    int bit_frequency[max_length][2];
    for (int i = 0; i < max_length; ++i) {
        bit_frequency[i][0] = 0;
        bit_frequency[i][1] = 0;
    }
    fseek(f, 0, 0);
    while (1) {
        char bin[max_length];
        fscanf(f, "%s", &bin);
        if (feof(f)) break;

        for (int i = 0; i < max_length; ++i)
            bit_frequency[i][ bin[i] - '0' ]++;
    }

    int gamma = 0, epsilon = 0, pow = 1;
    for (int i = max_length - 1; i >= 0; --i) {
        int cmp = bit_frequency[i][0] < bit_frequency[i][1];
        gamma   += cmp ? pow : 0;
        epsilon += cmp ? 0   : pow;
        pow *= 2;
    }
    printf("%d\n", gamma * epsilon);
    return 0;
}
