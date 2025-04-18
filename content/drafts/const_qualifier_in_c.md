---
title: "Const_qualifier_in_c"
date: 2019-09-26T01:46:26+02:00
draft: true
---

The rule of thumb is that:

```
const keyword applies to the left, unless it is the first word, then it applies to the right.
```

(This is not mentioned explicitly in the C standard(s), AFAICT it's just a consequence of how the grammar is defined, see grammar for type-names and type-qualifiers, in any of the standards, if you're interested.)

So in:

```
const char const * pointer_to_char;
```

Both `const` keywords apply to the `char`, as Vratislav said it's the same as dropping one of them. The compiler gives a warning because, what the programmer likely intended was that the pointer and the data it points to should be considered `const`:

```
const char *const pointer_to_char;
```

(I use whitespace in this way to make it less ambiguous).

What do you mean by "following the language specifications"? [The ISO C11 standard](http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf) calls these qualifiers, and does not specify whether you should put them before or after the first _type-specifier_ in a _type-name_, both are allowed by the syntax definition.

However, they do consistently use my preferred style, placing the const before the first _type-specifier_, in all the examples:

```C
const char *c_cp;
const void *c_vp;
extern int atoi(const char *);
```

```C
typedef int A[2][3];
const A a = {{4, 5, 6}, {7, 8, 9}}; // array of array of const int
int *pi;
const int *pci;
```

I would argue that `const char *const *` is the most readable way. The first `const` is unambiguous, intuitively, since there is nothing to the left it must apply to the right. You don't have to know the "const rule of thumb" to understand this. The second `const` is put together with the pointer asterisk (no space between) to indicate that it applies to this pointer. Most examples in the C standard follow this:

```C
const int *ptr_to_constant;
int *const constant_ptr;
```

(But there are also a couple of examples that use `* const`).

[glibc also seems to mostly follow the same convention.](https://github.com/bminor/glibc/blob/master/posix/execv.c#L23)

What I wrote above applies for both [ANSI C](https://www.pdf-archive.com/2014/10/02/ansi-iso-9899-1990-1/ansi-iso-9899-1990-1.pdf), as well as the K&R book. They don't say whether to put it before or after, the syntax definitions allow both, and they put it first in examples. Maybe you read it somewhere else (course material, blog post, etc.), but it doesn't seem to be part of any of the standards.

```C
#include <stdio.h>

int main(void)
{
  printf("STEP 0: Creating hello and world strings\n");
  const char *const hello = "hello";
  const char *const world = "world";
  printf("hello   = \"%s\"\n", hello);
  printf("world   = \"%s\"\n", world);

  printf("STEP 1: Setting pp to point to hello\n");
  const char *const *pp = NULL;
  pp = &hello;
  printf("(*pp)   = \"%s\"\n", (*pp));

  printf("STEP 2: Setting ppp to point to pp\n");
  const char *const **ppp = NULL;
  ppp = &pp;
  printf("(**ppp) = \"%s\"\n", (**ppp));

  printf("STEP 3: Modifying pp through ppp\n");
  *ppp = &world;
  printf("(*pp)   = \"%s\"\n", (*pp));
  printf("(**ppp) = \"%s\"\n", (**ppp));

  return 0;
}
```

```C
#include <stdio.h>

int main(void)
{
  printf("STEP 0: Creating hello and world strings\n");
  char hello_arr[] = {'h', 'e', 'l', 'l', 'o', '\0', '\0'};
  char world_arr[] = {'w', 'o', 'r', 'l', 'd', '\0', '\0'};
  char *const hello = hello_arr;
  char *const world = world_arr;
  printf("hello   = \"%s\"\n", hello);
  printf("world   = \"%s\"\n", world);

  printf("STEP 1: Setting pp to point to hello\n");
  char *const *pp = &hello;
  printf("(*pp)   = \"%s\"\n", (*pp));

  printf("STEP 2: Setting ppp to point to pp\n");
  char *const **ppp = &pp;
  printf("(**ppp) = \"%s\"\n", (**ppp));

  printf("STEP 3: Modifying pp through ppp\n");
  *ppp = &world;
  printf("(*pp)   = \"%s\"\n", (*pp));
  printf("(**ppp) = \"%s\"\n", (**ppp));

  printf("STEP 4: Modifying world through ppp\n");
  (**ppp)[5] = 's';
  printf("hello   = \"%s\"\n", hello);
  printf("world   = \"%s\"\n", world);
  printf("(*pp)   = \"%s\"\n", (*pp));
  printf("(**ppp) = \"%s\"\n", (**ppp));

  return 0;
}
```

```C
#include <stdio.h>

int print_arg_0(const char *const *argv)
{
  printf("%s\n", argv[0]);
  // Should be safe to pass char **, everything is const:
  // argv[0][0] = 'A'; // No can do
  // *argv = NULL;     // Nope
  return 0;
}

int main(__unused int argc, char **argv)
{
  // This typecast should not be necessary:
  return print_arg_0((const char *const *)argv);

  // incompatible-pointer-types in both gcc and clang is wrong here
  // The warning is part of -Wall and useful in other cases, like:

  // const char ** = argv; // No can do

}
```
