#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_WIDTH 50

int compute_width (FILE* f) {
    char* bin = (char*)malloc(MAX_WIDTH * sizeof(char));
    fscanf(f, "%s", bin);
    int l = strlen(bin);
    if (l > MAX_WIDTH) {
        fprintf(stderr, "Line too wide: %d over %d\n", l, MAX_WIDTH);
        exit (1);
    }
    free(bin);
    return l;
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

void populate (FILE* f, int width, int size, char** oxygens, char** co2s) {
    int line = 0;
    char* bin = (char*)malloc((1 + width * sizeof(char)));
    while (1) {
        fscanf(f, "%s", bin);
        if (feof(f)) break;

        oxygens[line] = (char*)malloc(width * sizeof(char));
        co2s[line]    = (char*)malloc(width * sizeof(char));
        for (int i = 0; i < width; ++i) {
            oxygens[line][i] = bin[i];
            co2s[line][i] = bin[i] == '0' ? '1' : '0';
        }
        ++line;
    }
    free(bin);
    return;
}

int process (int size, int width, char** bins, int gt) {
    int pos = 0;
    while (size > 1) {
        int count1 = 0;
        for (int l = 0; l < size; ++l)
            if (bins[l][pos] == '1')
                ++count1;

        int cmp = gt ? (count1 * 2 < size ? '0' : '1')
                     : (count1 * 2 > size ? '0' : '1');
        char** filtered;
        filtered = (char**)malloc(size * sizeof(char*));
        int newsize = 0;

        for (int l = 0; l < size; ++l) {
            if (bins[l][pos] == cmp) {
                filtered[newsize] = (char*)malloc(width * sizeof(char));
                for (int i = 0; i < width; ++i) {
                    filtered[newsize][i] = bins[l][i];
                }
                ++newsize;
            }
        }

        for (int l = 0; l < size; ++l)
            free(bins[l]);

        size = newsize;
        bins = filtered;
        ++pos;
    }
    if (!gt) 
        for (int i = 0; i < width; ++i)
            bins[0][i] = bins[0][i] == '0' ? '1' : '0';

    int r = 0;
    int pow = 1;
    for (int i = width - 1; i >= 0; --i, pow *= 2)
        r += pow * (bins[0][i] - '0');

    free(bins[0]);

    return r;
}

int main(int argc, char* argv[]) {
    FILE* f = fopen(argv[1], "r");
    int width = compute_width(f);
    int size = compute_size(f);
    fseek(f, 0, 0);

    char **oxygens = (char**)malloc(size * sizeof(char*));
    char **co2s    = (char**)malloc(size * sizeof(char*));
    populate(f, width, size, oxygens, co2s);
    fclose(f);

    long oxygen = process(size, width, oxygens, 1);
    long co2    = process(size, width, co2s, 0);

    free(oxygens);
    free(co2s);

    printf("%ld\n", oxygen * co2);

    return 0;
}
