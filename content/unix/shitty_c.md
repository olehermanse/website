---
title: "Mistakes found in real C code"
date: 2019-04-10T11:38:06+02:00
draft: false
tags:
  - "cfengine"
  - "unix"
  - "configuration"
---

```C
void FilterResults(Filter *filter)
{
    Sequence *include = NULL;
    Sequence *exclude = NULL;

    if (filter->include)
    {
        include = filter->include;
    }

    if (filter->exclude)
    {
        exclude = filter->exclude;
    }
}
```

### Recipe for a memory leak

* Long function (80+ lines)
* Multiple (early) returns
* Multiple pointers which have to be freed
* Booleans / conditions for when to free said pointers

```C
const char *StatusString(enum Status status)
{
    static const char *const strings[] =
    {
        [STATUS_HEALTHY] = "healthy",
        [STATUS_SICK] = "sick",
        [STATUS_SUPER] = "super"
    };
    return strings[status];
}
```
