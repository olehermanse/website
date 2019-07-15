---
title: "Cv2"
date: 2019-04-01T14:25:20+01:00
draft: true
---

## Guidelines for Cv2

* Make it easy for C projects to convert their code
* Make the software produced safer
* No performance hits
    * All the additional checking is done in compiler / asserts
* It should be possible to create a Cv2->C compiler
    * All features and changes should be expressable in C
* Cv2 source code should be more readable than C equivalent

## Smaller changes

* A keyword to express a `non-null` pointer
    * Enforced by compiler and asserts
    * Cast between non-null and normal pointer must be explicit
* A keyword to express an array of at least n elements
    * Enforced by compiler and asserts (w ASAN)
* Pointers and arrays are considered part of the type
    * An array is not NULL and has at least size 1
    * Array can be cast to pointer implicitly
    * Pointer to array cast has to be explicit, since array has a size
* Stricter enums
    * Type cast required when converting to an enum (from integer or other enum)
    * Functions which take an enum should assert that it has a valid value
    * Intuitive way to test that an int is within an enum range
* Sticky `const`
    * Pointers within a `const` struct are automatically `const`
    * Need to cast using `mut` keyword to get rid of `const`
        * Cannot "accidentally" get rid of a const

## Bigger features

* Keyword to automatically free on return
* Return more than 1 value ("tuples")
    * Parameters are inputs, returns are outputs

## Examples

```C
int strlen(const char *non_null str)
{

}
```
