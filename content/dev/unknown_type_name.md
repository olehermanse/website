---
title: "Unknown type name 'u_int'"
date: 2018-10-20T15:49:10+02:00
categories:
  - "Development"
tags:
  - "C"
  - "development"
  - "unix"
aliases:
  - /unix/unknown_type_name/
---

I ran across the error message (`Unknown type name 'u_int', 'u_long', 'u_char' etc.`) when trying to incorporate some old C code into a more modern project.
It shows up in system headers, like `sys/attr.h`, and I was confused.
After quite some time I figured out what the problem was, so I thought I'd share.

## Simplified example

The source code, when simplified, looked something like this:

```
$ cat test.c
#define _XOPEN_SOURCE 500
#include <sys/attr.h>
#include <stdio.h>

int main(void)
{
    printf("Hello, world!");
}
$
```

## Compiler output

When compiled in [GCC](https://gcc.gnu.org/), on OS X, you get errors from the included file `sys/attr.h`:

```
$ gcc-8 test.c -o test.o
In file included from /usr/include/sys/attr.h:42,
                 from test.c:2:
/usr/include/sys/ucred.h:91:2: error: unknown type name 'u_long'
  u_long cr_ref;   /* reference count */
  ^~~~~~
/usr/include/sys/ucred.h:133:9: error: unknown type name 'u_int'
         u_int   cr_version;             /* structure layout version */
         ^~~~~
In file included from test.c:2:
/usr/include/sys/attr.h:77:2: error: unknown type name 'u_short'
  u_short bitmapcount;   /* number of attr. bit sets in list (should be 5) */
  ^~~~~~~
/usr/include/sys/attr.h:541:2: error: unknown type name 'u_long'
  u_long    maxmatches;
  ^~~~~~
/usr/include/sys/attr.h:554:2: error: unknown type name 'u_char'
  u_char    ss_fsstate[548]; // fs private
  ^~~~~~
```

And the same in [clang](https://clang.llvm.org/):

```
$ clang test.c -o test.o
In file included from test.c:2:
In file included from /usr/include/sys/attr.h:42:
/usr/include/sys/ucred.h:91:2: error: unknown type name 'u_long'; did you mean 'long'?
        u_long  cr_ref;                 /* reference count */
        ^
/usr/include/sys/ucred.h:133:9: error: unknown type name 'u_int'
        u_int   cr_version;             /* structure layout version */
        ^
In file included from test.c:2:
/usr/include/sys/attr.h:77:2: error: unknown type name 'u_short'; did you mean 'short'?
        u_short bitmapcount;                    /* number of attr. bit sets in list (should be 5) */
        ^
/usr/include/sys/attr.h:541:2: error: unknown type name 'u_long'; did you mean 'long'?
        u_long                          maxmatches;
        ^
/usr/include/sys/attr.h:554:2: error: unknown type name 'u_char'; did you mean 'char'?
        u_char                          ss_fsstate[548];        // fs private
        ^
5 errors generated.
```

## Explanation and solution

I had never seen the macro `_XOPEN_SOURCE` before.
[It turns out](https://stackoverflow.com/questions/5378778/what-does-d-xopen-source-do-mean), this specifies the X/OPEN or POSIX standard you are writing for.

```
#define _XOPEN_SOURCE 500
```

The above value (`500`) corresponds to POSIX 1995.
Many headers, (at least on OS X), expect types which are not available in this mode.
_The fix was to remove the line._
