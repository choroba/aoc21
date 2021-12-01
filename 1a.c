#include <stdio.h>

int main (int argc, char* argv[]) {
    int previous = -1;
    int tally = -1;

    FILE* f = fopen(argv[1], "r");
    while (! feof(f)) {
        int line;
        fscanf(f, "%d", &line);
        if (line > previous) ++tally;
        previous = line;
    }
    printf("%d\n", tally);
    return 0;
}
