---
title: "Generating markdown changelogs using git"
date: 2019-07-15T14:41:34+02:00
tags:
  - "git"
  - "markdown"
  - "foss"
  - "development"
---

[Sometimes](/gamedev/mrpg_1/) I want to create changelogs for my personal projects and add them to blog posts.
It's extra neat to have all changelog entries link to individual commits on GitHub.
`git log` allows you to specify a custom format, and is perfect for the task:

```bash
$ git log --pretty=format:"* [%s](https://github.com/olehermanse/mrpg/commit/%H)" 09facd30..HEAD
```

Update the GitHub URL with your project, and the commit SHA with the last commit from the previous changelog.
The log will have newest changes first, and won't include the commit which the SHA references, only commits since then.
This fits well if you want to maintain a changelog file with the most recent version first.
(Use the `--reverse` option if you prefer older changes first).
You can also use a tag:

```bash
$ git log --pretty=format:"* [%s](https://github.com/olehermanse/mrpg/commit/%H)" v.1.4..HEAD
```
