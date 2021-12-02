#include <stdio.h>

int main (int argc, char* argv[]) {
    int previous = -1;
    int tally = -1;

    FILE* f = fopen(argv[1], "r");
    while (1) {
        int line;
        fscanf(f, "%d", &line);
        if (line > previous) ++tally;
        previous = line;

        if (feof(f)) break;
    }
    printf("%d\n", tally);
    return 0;
}
