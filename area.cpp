#include <cstdio>

extern "C" double area();

int main () {
    double fin = area();
    printf("\nASM returned double value: %lf\n", fin);
    return 0;
}