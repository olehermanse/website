---
title: "Bashcat"
date: 2018-12-17T14:25:20+01:00
draft: true
---

```
$ cat > 1
print("hello")
$ cat > 2
print("world")
$ cat *
print("hello")
print("world")
$ cat * | python3
hello
world
$ grep '.*' *
1:print("hello")
2:print("world")
$ ls | xargs -I % bash -c  " echo -n %:  ; cat % ;"
1:print("hello")
2:print("world")
```
