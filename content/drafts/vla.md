---
title: "VLA"
date: 2020-03-02T11:38:06+02:00
draft: true
tags:
  - "unix"
  - "c"
  - "posix"
  - "programming"
---

```
$ cat test.c
#include <stdio.h>
#include <string.h>

int main(int argc, char **argv)
{
  char cmd[10 + strlen(argv[1])];
  printf("%d\n", (int) sizeof(cmd));
  return 0;
}
$ gcc test.c -o test
$ ./test abc
13
$ ./test abcde
15
```
