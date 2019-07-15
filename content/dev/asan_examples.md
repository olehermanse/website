---
title: "AddressSanitizer (ASAN) examples"
date: 2018-10-06T03:29:14+02:00
categories:
  - "Development"
tags:
  - "C"
  - "security"
  - "development"
  - "unix"
---

[AddressSanitizer](https://github.com/google/sanitizers/wiki/AddressSanitizer) is a great tool for finding bugs in C or C++ projects.
It consists of some instrumentation added to code at compile time, as well as a dynamically linked runtime.
Good test coverage is required, as it detects problems at runtime, while running your test-suite.
To use it, supply `-fsanitize=address` to both the compiler and linker when building for tests (works in newer versions of clang and gcc).
There are [great resources](https://www.youtube.com/watch?v=V2_80g0eOMc) for [understanding how it works](https://www.youtube.com/watch?v=Q2C2lP8_tNE), but when I started, I was missing a few simple examples.

## A minimal C code example - the buffer overflow

```
$ cat test.c
#include <stdio.h>

int main(void)
{
    int a[8] = {0};
    int b[8] = {0};
    b[1] = 1;
    for (int i = 0, x = 0, y = 0; i <= 8; ++i) // uh oh
    {
        // This loop looks like it only reads / writes inside b
        b[i] += x + y;
        y = x;
        x = b[i];
    }
    // a has been altered, b[8] is actually a[0]
    return a[0];
}
```

(**Note:** In my case `b[8] == a[0]`, order and padding of the stack variables may be different on other compilers/platforms).

This is a very common mistake in C/++, the for loop's condition is wrong, so it will read/write outside the buffer.

It compiles and runs:

```
$ gcc -o test test.c && ./test
$ echo $?
21
```

## ASAN output

When run with ASAN, we see that this is detected as a _stack-buffer-overflow_ :

```
$ gcc -fsanitize=address -o test test.c && ./test
=================================================================
==45808==ERROR: AddressSanitizer: stack-buffer-overflow on address 0x7ffee419d4c0 at pc 0x00010ba62d3b bp 0x7ffee419d430 sp 0x7ffee419d428
READ of size 4 at 0x7ffee419d4c0 thread T0
    #0 0x10ba62d3a in main (test:x86_64+0x100000d3a)
    #1 0x7fff6b0f0014 in start (libdyld.dylib:x86_64+0x1014)
[...]
  This frame has 2 object(s):
    [32, 64) 'a'
    [96, 128) 'b' <== Memory access at offset 128 overflows this variable
[...]
$
```
I stripped away some of the output to highlight important information.
The stacktrace and variable name is usually sufficient to find the error.

## Smaller example without arrays

Here is an even shorter example, which is very similar, and detected in exactly the same way:

```
$ cat test.c
#include <stdio.h>

int main(void)
{
    int a = 1, b = 2, c = 3;
    // ASAN should detect that we are accessing memory outside b:
    return *((&b) + 1) + *((&b) - 1); // Return 1 + 3 without ASAN
}
```

## Adding ASAN to bigger projects

Bigger C projects typically use autotools or CMake to build.
You need to make sure both the compiler (gcc/clang) and the linker (ld) gets the correct flags.
In [CFEngine](https://github.com/cfengine/core), which I work on, I had to use `CFLAGS` and `LDFLAGS`:

```
$ ./autogen.sh --enable-debug
$ make CFLAGS="-fsanitize=address" LDFLAGS="-fsanitize=address -pthread"
```

The same flags worked for unit tests:
```
$ cd tests/unit
$ make CFLAGS="-fsanitize=address" LDFLAGS="-fsanitize=address -pthread" check
```
