#include <stdio.h>

extern long App_9_func(void);

void SpecialChar(long num);

int main() {

  if (*App_9_func >= 8) {
    long newValue = (long)*App_9_func / 8;
    printf("%ld\n", newValue);
  } else {
    SpecialChar(*App_9_func);
  }

  return 0;

}

void SpecialChar(long num) {

  char characters[2][2] = { "#f", "#t" };
  
  if (num == 0) {
    printf("%s\n", characters[0]);
  } else {
    printf("%s\n", characters[1]);
  }

}
