---
title: "How to Install and Use CFEngine Community Edition on Ubuntu 20.04"
date: 2021-07-01T12:00:00+00:00
tags:
  - "cfengine"
  - "unix"
  - "configuration"
---

If you are looking for a fast and highly scalable configuration management tool for your IT infrastructure, you should give CFEngine a try.
The agent you install on each machine is small and fast (written in C), supporting a wide range of platforms, and ideal for resource constrained environments such as large infrastructures or small IoT devices.
It allows you to use the same tool and policy language to manage everything in your infrastructure; Linux, Mac, Windows, BSD, Solaris, IBM AIX, HP-UX, etc.

In this tutorial, you will learn how to install and use CFEngine Community Edition 3.18.0 on Ubuntu 20.04.
We will use `apt` and the package repos to install CFEngine.
The main advantage of using `apt` to install CFEngine is that you can use `apt` to update CFEngine later, same as everything else you've installed with `apt`.

Other ways of installing have other benefits:

* [`cf-remote`](https://pypi.org/project/cf-remote/) is the most flexible - it easily handles installing on multiple machines, different versions of CFEngine, nightly builds, etc.
* [The `quick-install` shell script](https://cfengine.com/downloads/quick-install/) is the easiest / fastest for 1 machine, just copy a single command into a terminal.
* [Downloading packages directly from the website is also straight forward](https://cfengine.com/downloads/cfengine-community/).

If you use one of these alternate ways, to install CFEngine community, or Enterprise, skip to step 5 after installing (or step 7 after bootstrapping).

## Step 1 - Log in as root

If you are not already logged in as `root`, open a root shell:

```
sudo bash
```

Installing software normally requires root level access.
Additionally, CFEngine is typically run as `root` since you use it to manage many things on the system, such as installed software, configuration files, running processes and user accounts.

## Step 2 - Adding CFEngine's Public Key

The CFEngine public GPG key is needed for `apt` to trust packages from the repository:

```
wget -qO- https://cfengine-package-repos.s3.amazonaws.com/pub/gpg.key | apt-key add -
```

## Step 3 - Adding CFEngine's Package Repositories

The reposotiry itself must also be added as a source to `apt`:

```
echo "deb https://cfengine-package-repos.s3.amazonaws.com/pub/apt/packages stable main" > /etc/apt/sources.list.d/cfengine-community.list
```

And the `update` command is necessary for `apt` to see the new packages that came with that repo (source):

```
apt update
```

## Step 4 - Installing CFEngine

`apt` now knows where the CFEngine packages are, and you can install:

```
apt install cfengine-community
```

## Step 5 - Verifying the installation

Now, the `cf-agent` component should be installed (in `/var/cfengine/bin`).
Check that it works:

```
cf-agent --version
```

You should see the version number:

```
CFEngine Core 3.18.0
```

(If you read this in the future, the version number might be higher.)

If the `cf-agent` command doesn't work, check that `/var/cfengine/bin/` is in your `PATH` variable, and that `cf-agent` exists in that directory.

## Step 6 - Starting CFEngine

```
cf-agent --bootstrap <your_server_ip>
```

Replace `<your_server_ip>` with the appropriate IP address.

If you only want to use CFEngine on 1 server, you can put the localhost address there, `127.0.0.1`. (Other hosts won't be able to connect).
At a later point, if you want to connect other servers with CFEngine, you will have to re-run the bootstrap command on this machine, with the correct IP.

If you want to manage multiple servers with 1 hub, install and run the bootstrap command on the hub machine first (with its own IP in the command).
Repeat the process for each additional machine, but run the bootstrap command with the same IP as before (the IP of the hub).
You must use the correct IP for this to work; an IP address the other servers can use to connect to that machine.
Networking must work between those machine (on that IP) and if there are firewalls involved, they must accept traffic on port 5308.

## Step 7 - Creating your first policy

To automate a system administration task using CFEngine, you should create a policy file for it.
A policy file is written in CFEngine's own DSL (Domain Specific Language).

Let's start by creating a simple "Hello World" policy.
Use `nano` or your favorite text editor to create a new file called `hello_world.cf`:

```cf3
bundle agent main
{
  reports:
    "Hello!";
}
```

In CFEngine policy language, each statement you make about what you are managing is called a _promise_, and they are organized into bundles.
Bundles are useful as they allow you to choose which parts of the policy is run (and which parts aren't), and what order they are run in.
CFEngine policy is declarative, and not evaluated from top to bottom.

In this policy, `reports` is a _promise type_, responsible for printing the message to the terminal.
The `agent` keyword, after `bundle`, signifies that this bundle is for the `cf-agent` component.
`main` is the name of the bundle.
The _bundle sequence_ specifies the bundles to evaluate, and by default it includes the `main` bundle, so we don't need to change it.

To run the policy, simply:

```
cf-agent hello_world.cf
```

By default, CFEngine keeps track of what has been done, and skips promises evaluated recently.
If you try to run the policy again, it won't print anything.
You can disable this locking with a command line option:

```
cf-agent --no-lock hello_world.cf
```

## Step 8 - Managing a text file with some content

Printing messages to the terminal is not that useful.
A more realistic example is that you want to make sure a file exists with some content, on all the hosts in your infrastructure.

Let's create another policy file, `file_management.cf`:

```cf3
bundle agent manage_my_file
{
  files:
    "/tmp/my_file.txt"
      content => "Hello, CFEngine!";
}
```

I renamed the bundle to `manage_my_file`.
As we write more policy we want to give each bundle a unique and descriptive name, there can only be one `main` bundle.
Since we are managing files now, the promise type is `files`.
`content` is an attribute for `files` promises, stating what the content of that file should be.

Let's run this policy, we will add some new command line options:

```
cf-agent --no-lock --info file_management.cf --bundle manage_my_file
```

Specifying the bundle with `--bundle manage_my_file` is necessary since there is no longer a `main` bundle.
The `--info` option is nice, as it makes CFEngine print informational messages about the changes it's making to the system:

```
    info: Using command line specified bundlesequence
    info: Updated content of '/tmp/my_file.txt' with content 'Hello, CFEngine!'
```

If you run the same command again, the second message will disappear.
This is because CFEngine recognizes that the contents of the file are already correct, and doesn't perform any changes.

**Tip:** `--no-lock` and `--info` are commonly used together when writing and testing policy.
To save some typing, there are short options available; `-KI` is equivalent to `--no-lock --info`.

## Step 9 - Automation

We don't want to run our policy from the command line, manually, all the time, on all our servers.
After all, the point of this is _automation_.
Luckily, making CFEngine copy this policy to all your servers and run it everywhere, regularly, is quite simple.

Copy the policy file into the correct directory on the hub (the first machine you set up):

```
cp file_management.cf /var/cfengine/masterfiles/services/
```

Specify where the file is and what bundle should be run using a JSON file, `/var/cfengine/masterfiles/def.json`:

```json
{
  "inputs": [ "services/file_management.cf" ],
  "vars": {
    "control_common_bundlesequence_end": [ "manage_my_file" ]
  }
}
```

That's it.

At this point, you are editing policy on your hub, inside `/var/cfengine/masterfiles/`, and the rest is taken care of by automation.
All servers bootstrapped to this hub will fetch this policy file, and evaluate that bundle.
The file will be created, with the content we specified, on every machine in your infrastructure.
By default, policy is fetched and enforced by `cf-agent` every 5 minutes, but this [can be customized](https://docs.cfengine.com/docs/3.18/reference-masterfiles-policy-framework.html#configure-agent-execution-schedule).

If you want to test that it's working correctly, without waiting for the next time `cf-agent` runs, you can do it manually:

```
cf-agent -KIf update.cf
cf-agent -KI
```

Depending on how long you waited before running these commands, CFEngine might have ran in the meantime.
In that case, our agent runs will not copy any files, make any changes, or print any log messages.

## What's next

Where you go from here, what you want to use CFEngine for, is up to you.
Here are some useful links to get you started:

* [GitHub Discussions Q&A - The CFEngine team and community will answer any questions you might have](https://github.com/cfengine/core/discussions/categories/q-a)
* [The CFEngine blog - Read about the latest features and changes](https://cfengine.com/blog/)
* [Official documentation - Learn how everything in CFEngine works](https://docs.cfengine.com)
