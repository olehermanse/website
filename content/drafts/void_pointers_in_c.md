---
title: "Void pointers in C"
date: 2019-09-26T01:45:03+02:00
draft: true
---

```
#include <stdio.h>

typedef struct _Nums {
  char a;
  char b;
  char c;
  char d;
} Nums;

int main(void)
{
  Nums a = { 'a', 'b', 'c', 'd'};
  Nums b = { 'e', 'f', 'g', 'h'};
  Nums arr[2] = {a, b};
  void *vp = arr;
  vp += 1;
  Nums *p = vp;
  printf("%c %c %c %c\n", p[0].a, p[0].b, p[0].c, p[0].d);
  return 0;
}
```
