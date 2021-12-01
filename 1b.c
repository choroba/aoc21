#include <stdio.h>

int main (int argc, char* argv[]) {
    int tally = -1;
    FILE* f;
    f = fopen(argv[1], "r");
    int window[3];
    int sum;
    for (int i = 0; i < 3; ++i) {
        fscanf(f, "%d", &window[i]);
        sum += window[i];
    }
    while (! feof(f)) {
        int line;
        fscanf(f, "%d", &line);
        int newsum = line + sum - window[0];
        if (newsum > sum) ++tally;
        window[0] = window[1];
        window[1] = window[2];
        window[2] = line;
        sum = newsum;
    }
    printf("%d\n", tally);
    return 0;
}
