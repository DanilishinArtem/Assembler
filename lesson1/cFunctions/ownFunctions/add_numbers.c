#include <stdio.h>

extern int add_numbers(int, int);

int add_numbers(int a, int b){
    printf("Adding %d and %d\n", a, b);
    return a + b;
}