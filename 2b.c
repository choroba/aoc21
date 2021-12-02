#include <stdio.h>
#include <string.h>

int main (int argc, char* argv[]) {
    int aim = 0, depth = 0, horiz = 0;

    FILE* f = fopen(argv[1], "r");
    while (1) {
        char direction[strlen("forward")];
        int amount;
        fscanf(f, "%s %d", &direction, &amount);
        if (feof(f)) break;

        switch (direction[0]) {
            case 'f':
                horiz += amount;
                depth += amount * aim;
                break;
            case 'u':
                aim -= amount;
                break;
            case 'd':
                aim += amount;
                break;
        }
    }
    printf("%d\n", depth * horiz);
    return 0;
}
