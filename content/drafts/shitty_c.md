---
title: "Mistakes found in C code"
date: 2019-04-10T11:38:06+02:00
draft: true
tags:
  - "unix"
  - "c"
  - "posix"
  - "programming"
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
