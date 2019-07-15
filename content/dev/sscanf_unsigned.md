---
title: "Scanning unsigned types in C"
date: 2018-11-11T14:26:22+01:00
categories:
  - "Development"
tags:
  - "C"
  - "development"
  - "unix"
---

`printf` and `scanf` are the C standard library functions for printing out and reading in data.
They have string counterparts, prefixed with `s`, which work on strings (`sprintf` and `sscanf`).
All these functions use a format string to match parts of the string with C variables.
As an example, `%lu` in the format string corresponds to an `unsigned long`, a positive integer type in C.

## Scanning unsigned types

What happens if you try to `sscanf` a negative number using `%lu`?
`printf` will never print a negative number for `%lu` so `sscanf` should not scan one, right?
Unfortunately, `sscanf` does match negative numbers for `unsigned` format strings.
As an example, we can scan `"-10"` with format `"%lu"`:

```
$ cat test.c
#include <stdio.h>

int main(void)
{
    unsigned long num = 0;
    int ret = sscanf("-10", "%lu", &num);
    printf("num=%lu\n", num);
    return ret;
}
```

The output shows that it matches, and converts the `signed long` to `unsigned`, like a type cast:

```
$ clang -o test test.c && ./test
num=18446744073709551606
$ echo $?
1
```

(The result is the same using gcc).

## Introducing error checking

So, this can be annoying.
You scan a small input string of 3 symbols, and get a 20 digit number as a result.
In many cases, negative numbers should be invalid input.

One option is to check for the `-` sign before scanning, but this can be quite complicated for longer strings.
The other option is to scan into a signed type, check the value, and then error if it's incorrect.
This means you lose 1 bit for the signed type, you cannot read as large numbers, but for most situations `signed long` is big enough.

A simple example:

```
$ cat test.c
#include <stdio.h>

int main(int argc, char **argv)
{
    if (argc != 2)
    {
        printf("Error: Please provide exactly 1 string argument.\n");
        return 1;
    }
    const char *const str = argv[1];
    long signed_num;

    int ret = sscanf(str, "%ld", &signed_num);
    if (ret <= 0)
    {
        printf("Error: Could not find a number in '%s'.\n", str);
        return 1;
    }
    if (signed_num < 0)
    {
        printf("Error: Negative numbers not allowed.\n");
        return 1;
    }

    unsigned long unsigned_num = signed_num;
    printf("Scanned num: %lu\n", unsigned_num);
    return 0;
}
```

This works as expected and has the necessary error checking:

```
$ gcc test.c -o test
$ ./test 1234
Scanned num: 1234
$ ./test -1
Error: Negative numbers not allowed.
$ ./test blah
Error: Could not find a number in 'blah'.
$ ./test
Error: Please provide exactly 1 string argument.
$
```
