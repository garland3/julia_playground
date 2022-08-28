// https://renenyffenegger.ch/notes/development/languages/C-C-plus-plus/GCC/create-libraries/index

#include <stdio.h>
#include "mylib/add.h"
#include "mylib/answer.h"

int main(int argc, char* argv[]) {

  setSummand(5);

  printf("5 + 7 = %d\n", add(7));

  printf("And the answer is: %d\n", answer());

  return 0;
}

// gcc -c       src/main.c        -o bin/main.o