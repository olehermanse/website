---
title: "Sane error handling in C"
date: 2018-12-17T14:25:20+01:00
draft: true
---

```C
bool connect_and_write(char *ip, char *data)
{
    Connection *connection = connect(ip);
    if (connection == NULL)
    {
        return false; // Error
    }
    int r = write(connection, data);
    if (r < 0)
    {
        return false; // Error
    }
    return true;
}

int main(void)
{
    bool success = connect_and_write("1.2.3.4", "[0]");
    if (!success)
    {
        printf("There was an error, and I'm handling it by retrying\n");
        success = connect_and_write("1.2.3.4", "[0]");
    }
    return (success ? 0 : -1);
}
```
