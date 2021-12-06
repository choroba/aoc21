#include <stdio.h>
#include <string.h>

const int DAYS = 256;

int main (int argc, char** argv) {
    FILE* f = fopen(argv[1], "r");
    char* line = NULL;
    long unsigned int length;
    getline(&line, &length, f);

    char sep[] = ",";
    long  int fish[9] = {0,0,0,0,0,0,0,0,0};
    char* token = strtok(line, sep);
    int age;
    while (token != NULL) {
        sscanf(token, "%d", &age);
        ++fish[age];
        token = strtok(NULL, sep);
    }

    for (int day = 1; day <= DAYS; ++day) {
        long int next[9] = {0,0,0,0,0,0,0,0,0};
        next[8] += fish[0];
        next[6] += fish[0];
        for (int d = 1; d <= 8; ++d) {
            next[d-1] += fish[d];
        }
        memcpy(fish, next, 9 * sizeof(long int));
    }
    long int sum = 0;
    for (int i = 0; i <= 8; ++i)
        sum += fish[i];
    printf("%ld\n", sum);
    return 0;
}
