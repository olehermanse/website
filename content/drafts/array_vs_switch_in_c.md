---
title: "Array vs switch statement in C"
date: 2019-09-26T01:49:55+02:00
draft: true
---

Array:

```
#include <stdio.h>
#include <stdlib.h>

const char *get_string(unsigned int index)
{
    if (index > 4)
    {
        return "";
    }
    static const char *const messages[] = {
        [0] = "blah",
        [1] = "bleep",
        [2] = "bloop",
        [3] = "zip",
        [4] = "zap",
    };
    return messages[index];
}

int main(int argc, char **argv)
{
    if (argc != 2)
    {
        return 1;
    }
    printf("Message: '%s'\n", get_string(atoi(argv[1])));
    return 0;
}
```


Switch:

```
#include <stdio.h>
#include <stdlib.h>

const char *get_string(unsigned int index)
{
    switch (index)
    {
    case 0:
        return "blah";
    case 1:
        return "bleep";
    case 2:
        return "bloop";
    case 3:
        return "zip";
    case 4:
        return "zap";
    default:
        return "";
    }
}

int main(int argc, char **argv)
{
    if (argc != 2)
    {
        return 1;
    }
    printf("Message: '%s'\n", get_string(atoi(argv[1])));
    return 0;
}
```
