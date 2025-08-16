---
title: "Using cf-remote to download and install CFEngine nightlies"
date: 2020-08-28T11:47:06+02:00
tags:
  - "cfengine"
  - "unix"
  - "configuration"
---

This is a [work](https://cfengine.com) related post.

Nightly packages are very useful for testing new features of CFEngine.
Right now, nightly packages can be used to test out these new features:

- [Compliance Reports.](https://www.youtube.com/watch?v=1jNxP0WVEyI)
- Mission Portal Dark Mode.
- New host info page with variable pinning and copy buttons.

Note that these features are in development, some parts may be unfinished or buggy.
Nightly packages are not supported and should not be used in production environments.

`cf-remote` is a tool for automating the setup and installation of CFEngine.
It allows you to easily install CFEngine packages over SSH.
The tool is open source, and installation instructions are available on GitHub:

https://github.com/cfengine/core/tree/master/contrib/cf-remote

## Downloading nightlies

Downloading packages using `cf-remote` is easy:

```
$ cf-remote --version master packages hub ubuntu
Available releases: 3.16.0, 3.15.x, 3.15.2, 3.15.1, 3.15.0, 3.15.0b1, 3.12.x, 3.12.5, 3.12.4, 3.12.3, 3.12.2, 3.12.1, 3.12.0
Using master:
Downloading package: '/Users/olehermanse/.cfengine/cf-remote/packages/cfengine-nova-hub_3.17.0a.db4bd2209~10418.ubuntu14_amd64.deb'
Downloading package: '/Users/olehermanse/.cfengine/cf-remote/packages/cfengine-nova-hub_3.17.0a.db4bd2209~10413.ubuntu16_amd64.deb'
Downloading package: '/Users/olehermanse/.cfengine/cf-remote/packages/cfengine-nova-hub_3.17.0a.db4bd2209~10418.ubuntu18_amd64.deb'
$
```

`cf-remote` defaults to the latest LTS release, so we specify `--version master` to get the latest nightly build from the master branch.
The `packages` command downloads packages.
The two tags `ubuntu` and `hub` are optional, and used to filter packages.
Without them, `cf-remote` would download packages for all the supported platforms.

You don't have to use cf-remote to install these packages, they are just like our normal packages.

## Installing nightlies

If you have ssh access to a host, with password-less sudo, you can use cf-remote to install packages:

```
$ cf-remote --version master install --hub ubuntu@54.217.161.96 --bootstrap 172.31.18.204

ubuntu@54.217.161.96
OS            : ubuntu (debian)
Architecture  : x86_64
CFEngine      : Not installed
Policy server : None
Binaries      : dpkg, apt

Package already downloaded: '/Users/olehermanse/.cfengine/cf-remote/packages/cfengine-nova-hub_3.17.0a.db4bd2209~10413.ubuntu16_amd64.deb'
Copying: '/Users/olehermanse/.cfengine/cf-remote/packages/cfengine-nova-hub_3.17.0a.db4bd2209~10413.ubuntu16_amd64.deb' to 'ubuntu@54.217.161.96'
Installing: 'cfengine-nova-hub_3.17.0a.db4bd2209~10413.ubuntu16_amd64.deb' on 'ubuntu@54.217.161.96'
CFEngine 3.17.0a.db4bd2209 (Enterprise) was successfully installed on 'ubuntu@54.217.161.96'
Bootstrapping: '54.217.161.96' -> '172.31.18.204'
Bootstrap successful: '54.217.161.96' -> '172.31.18.204'
```

The `install` command will find the same packages as `packages` did.
If they are already downloaded, they will be reused.

That's it, the host has been bootstrapped, and Mission Portal is running.
You can open Mission Portal in your browser and start exploring.
(In my case above, it would be `https://54.217.161.96`).
