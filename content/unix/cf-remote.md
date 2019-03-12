---
title: "Introducing cf-remote: Tooling to deploy CFEngine"
date: 2019-03-11T10:38:06+01:00
draft: false
tags:
  - "cfengine"
  - "unix"
  - "configuration"
  - "python"
  - "development"
---

I work at [Northern.tech](https://northern.tech), developing [CFEngine](https://github.com/cfengine/core), a configuration management system.
This is a work (CFEngine) related post.

About a year ago, I wrote a small python script to automate installing and bootstrapping CFEngine on virtual machines in AWS.
It had some hard coded IP addresses that I needed to update when I spawned new hosts, but other than that, it worked well.
During manual testing, it saved me a lot of time instead of having to do things manually.

Deploying CFEngine normally consists of these steps:

1. Determine what CFEngine package to use.
2. Download appropriate package if you haven't already - `curl`.
3. Copy the package to the host - `scp`.
4. Log into the host - `ssh`.
5. Install the package - `rpm` / `dpkg`.
6. Bootstrap CFEngine - `cf-agent -B`.

At a company hackathon I decided to make my script into something better, something that would be useful to my colleagues, and maybe even CFEngine users in general.
Enter `cf-remote`.

## Install and bootstrap

`cf-remote` can do all of this, the only thing you really need to specify is IP address(es).
In the simple case, this should be enough to install and bootstrap a host:

```
$ cf-remote install --hub 34.252.28.73 --bootstrap 172.31.30.237
```

The `cf-remote` command line tool is written in Python, and uses [Fabric](http://www.fabfile.org/) to log into the system via SSH.
It follows the same steps you would manually (listed above).
Note that there are almost no dependencies on the target system.
You only need ssh access and a shell which can perform basic UNIX commands like `ls`, `cat`, `which`.

Here is the output from the example above:

```
$ cf-remote install --hub 34.252.28.73 --bootstrap 172.31.30.237

ec2-user@34.252.28.73
OS            : rhel (fedora)
Architecture  : x86_64
CFEngine      : Not installed
Policy server : None
Binaries      : rpm, yum

Package already downloaded: '/Users/olehermanse/.cfengine/cf-remote/packages/cfengine-nova-hub-3.12.1-1.x86_64.rpm'
Copying: '/Users/olehermanse/.cfengine/cf-remote/packages/cfengine-nova-hub-3.12.1-1.x86_64.rpm' to '34.252.28.73'
Installing: 'cfengine-nova-hub-3.12.1-1.x86_64.rpm' on '34.252.28.73'
CFEngine 3.12.1 was successfully installed on '34.252.28.73'
Bootstrapping: '34.252.28.73' -> '172.31.30.237'
Bootstrap succesful: '34.252.28.73' -> '172.31.30.237'
```

We can guess the username and CFEngine version if not specified.
Many hosts can be specified in a single command:

```
$ cf-remote install --hub 34.252.28.73 --bootstrap 172.31.30.237 --clients 52.212.51.201,52.212.51.202,52.212.51.203
```

Or using a newline delimited file:

```
$ cat ./clients
52.212.51.201
52.212.51.202
52.212.51.203
$ cf-remote install --hub 34.252.28.73 --bootstrap 172.31.30.237 --clients ./clients
```

## Other useful commands

The tooling includes a few other useful utilities.
Some of these things can be done in CFEngine policy, but `cf-remote` doesn't assume that CFEngine is installed.
Thus, these commands can be useful both before and after installing CFEngine.

### Host information

The `info` command logs into the system, runs a few commands and parses `/etc/os-release` to present information about the system:

```
$ cf-remote info -H 34.252.28.73

ec2-user@34.252.28.73
OS            : rhel (fedora)
Architecture  : x86_64
CFEngine      : 3.12.1
Policy server : 172.31.30.237
Binaries      : rpm, yum
```

(Add `--log-level debug` to see all commands `cf-remote` runs).

### File copy

The `scp` command can be used to transfer files to the host.

```
$ echo "Hello, world" > txt
$ cf-remote -H 34.252.28.73 scp txt
Copying: 'txt' to '34.252.28.73'
```

The destination defaults to the home folder of the SSH user (`/home/ec2-user/txt` in this example).
The command doesn't actually use an `scp` executable, but Fabric's `Connection.put()`.

### Arbitrary command execution

We can also run commands as if we were logged in via ssh:

```
$ cf-remote -H 34.252.28.73 run "cat txt"
34.252.28.73:    'cat txt' -> 'Hello, world'
```

This is especially useful to run commands on many hosts.
`-H` accepts a comma separated list or a path to a file (beginning with `./`, `/`, `../` or `~/`).

## Config Management Camp 2019

`cf-remote` was introduced, with some live demos, in my talk at [CfgMgmtCamp](https://cfgmgmtcamp.eu/) 2019.
The video recording is available on YouTube:

https://www.youtube.com/watch?v=q50_QTd1AN4

## Getting started

The tool is completely open source, and part of the [CFEngine core repository](https://github.com/cfengine/core):

https://github.com/cfengine/core/tree/master/contrib/cf-remote

The README has installation instructions.
It should work on any system with curl, Python(3), [Fabric](http://www.fabfile.org/), and [Requests](http://docs.python-requests.org/en/master/).
We've tested it on Linux(Fedora) and OS X.

### Contributing

Anyone can contribute to `cf-remote`, we have a curated list of tickets to pick up here:

https://tracker.mender.io/issues/?filter=11704

Additional platform support (beyond dpkg and rpm) and parallellized installation are good next features.
