#include <stdio.h>
#include <string.h>

int compute_width (FILE* f) {
    char bin[100];
    fscanf(f, "%s", &bin);
    return strlen(bin);
}

int compute_size (FILE* f) {
    int size = 0;
    while (1) {
        char c = fgetc(f);
        if (feof(f)) break;

        if (c == '\n') ++size;
    }
    return size;
}

void get_frequencies (int width, FILE* f, int bit_frequency[][2]) {
    for (int i = 0; i < width; ++i) {
        bit_frequency[i][0] = 0;
        bit_frequency[i][1] = 0;
    }

    fseek(f, 0, 0);
    while (1) {
        char bin[width];
        fscanf(f, "%s", &bin);
        if (feof(f)) break;

        for (int i = 0; i < width; ++i)
            bit_frequency[i][ bin[i] - '0' ]++;
    }
    return;
}

void get_gamma_epsilon (int width, int bit_frequency[][2],
                        int *gamma, int *epsilon) {
    *gamma = *epsilon = 0;
    int pow = 1;
    for (int i = width - 1; i >= 0; --i) {
        int cmp = bit_frequency[i][0] < bit_frequency[i][1];
        *gamma   += cmp ? pow : 0;
        *epsilon += cmp ? 0   : pow;
        pow *= 2;
    }
    return;
}

int main(int argc, char* argv[]) {
    FILE* f = fopen(argv[1], "r");
    int width = compute_width(f);
    int size = compute_size(f);

    int bit_frequency[width][2];
    get_frequencies(width, f, &bit_frequency[0]);

    int gamma, epsilon;
    get_gamma_epsilon(width, &bit_frequency[0], &gamma, &epsilon);

    printf("%d\n", gamma * epsilon);
    return 0;
}
