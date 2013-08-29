#include <stdio.h>

extern long App_9_func(void);

void SpecialChar(long num);

int main() {

  long n = App_9_func();
  
  if (n >= 8) {
    long newValue = (long) n / 8;
    printf("%ld\n", newValue);
  } else {
    SpecialChar(n);
  }
  

  return 0;

}

void SpecialChar(long num) {

  char *characters[] = {"#f", "#t"};
  
  if (num == 0) {
    printf("%s\n", characters[0]);
  } else {
    printf("%s\n", characters[1]);
  }

}
