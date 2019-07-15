---
title: "Using Systemd to ensure unit(s) run on one CPU core"
date: 2018-07-27T13:59:03+02:00
categories:
  - "Development"
  - "System Management"
tags:
  - "systemd"
  - "cfengine"
  - "configuration"
  - "unix"
---

This post is based on an excellent article from Red Hat:

https://access.redhat.com/solutions/1445073

I'm a CFEngine developer, so this is a more work related post.

## CFEngine and Systemd

In some performance critical situations, it makes sense to limit management software to a single CPU (core).
We can do this using systemd and cgroups.
CFEngine already provides systemd units on relevant platforms, we just need to tweak them.
Tested using CFEngine 3.12 on CentOS 7.

## Using ps to check what CPU core is utilized

### Listing all processes and their core

We can use ps to check CPU core for desired processes:
```
$ ps x -o pid,psr,comm
  PID PSR COMMAND
    1   1 systemd
    2   0 kthreadd
    3   0 ksoftirqd/0
    5   0 kworker/0:0H
    6   1 kworker/u4:0
    7   0 migration/0
    8   0 rcu_bh
    9   1 rcu_sched
   10   0 lru-add-drain
[...]
```

(first column is PID, second is core, third is the process command)

### Filtering using grep

```
$ ps x -o pid,psr,comm | grep [c]f-
10716   1 cf-serverd
10719   3 cf-execd
10723   3 cf-monitord
10791   0 cf-hub
```

(The brackets in the grep command means it won't match its own process).

## Systemd services

### Location and editing

CFEngine provides an umbrella service:

```
$ systemctl status cfengine3
● cfengine3.service - CFEngine 3 umbrella service
   Loaded: loaded (/usr/lib/systemd/system/cfengine3.service; enabled; vendor preset: disabled)
   Active: active (exited) since Fri 2018-07-27 13:23:43 UTC; 1min 21s ago
     Docs: https://docs.cfengine.com/
[...]
```

The other services, like `cf-serverd` and `cf-execd` etc. are in the same folder:
```
$ ls -al /usr/lib/systemd/system/ | grep [c]f
-rw-r--r--.  1 root root   433 Jun 28 10:03 cf-apache.service
-rw-r--r--.  1 root root   851 Jun 28 10:03 cfengine3.service
-rw-r--r--.  1 root root   385 Jun 28 10:03 cf-execd.service
-rw-r--r--.  1 root root   387 Jun 28 10:03 cf-hub.service
-rw-r--r--.  1 root root   358 Jun 28 10:03 cf-monitord.service
-rw-r--r--.  1 root root  1150 Jun 28 10:03 cf-postgres.service
-rw-r--r--.  1 root root   638 Jun 28 10:03 cf-runalerts.service
-rw-r--r--.  1 root root   437 Jun 28 10:03 cf-serverd.service
```

To edit them, we should make copies in `/etc/systemd/system`:
```
$ cp /usr/lib/systemd/system/cf* /etc/systemd/system/
$ ls -al /etc/systemd/system/ | grep [c]f
-rw-r--r--.  1 root root  433 Jul 27 13:26 cf-apache.service
-rw-r--r--.  1 root root  851 Jul 27 13:26 cfengine3.service
drwxr-xr-x.  2 root root  185 Jul 27 13:22 cfengine3.service.wants
-rw-r--r--.  1 root root  385 Jul 27 13:26 cf-execd.service
-rw-r--r--.  1 root root  387 Jul 27 13:26 cf-hub.service
-rw-r--r--.  1 root root  358 Jul 27 13:26 cf-monitord.service
-rw-r--r--.  1 root root 1150 Jul 27 13:26 cf-postgres.service
drwxr-xr-x.  2 root root   34 Jul 27 13:22 cf-postgres.service.wants
-rw-r--r--.  1 root root  638 Jul 27 13:26 cf-runalerts.service
-rw-r--r--.  1 root root  437 Jul 27 13:26 cf-serverd.service
```

If we reload and restart, we should see that systemd is now using our new copies:
```
$ systemctl daemon-reload
$ systemctl restart cfengine3
$ systemctl status cfengine3
● cfengine3.service - CFEngine 3 umbrella service
   Loaded: loaded (/etc/systemd/system/cfengine3.service; enabled; vendor preset: disabled)
   Active: active (exited) since Fri 2018-07-27 13:28:54 UTC; 4s ago
     Docs: https://docs.cfengine.com/
[...]
```

### Making a cgroup for the umbrella service

`/etc/systemd/system/cfengine3.service` is the umbrella service which starts and stops all the other services.
We will create one shared cgroup, called `cfe_group` for the different services.
We want to add 4 lines to set up and tear down the cgroup:
```
ExecStartPre=/usr/bin/mkdir -p /sys/fs/cgroup/cpuset/cfe_group
ExecStartPre=/bin/bash -c '/usr/bin/echo "1" > /sys/fs/cgroup/cpuset/cfe_group/cpuset.cpus'
ExecStartPre=/bin/bash -c '/usr/bin/echo "0" > /sys/fs/cgroup/cpuset/cfe_group/cpuset.mems'

ExecStopPost=/usr/bin/rmdir /sys/fs/cgroup/cpuset/cfe_group
```
The _pre_ steps create a cgroup and says that all processes within it should run on cpu `1`.
The _post_ step deletes the cgroup using `rmdir`.

The final version should look like this:
```
$ cat /etc/systemd/system/cfengine3.service
[Unit]
Description=CFEngine 3 umbrella service
Documentation=https://docs.cfengine.com/
After=syslog.target

[Install]
WantedBy=multi-user.target

[Service]
Type=oneshot
RemainAfterExit=yes

# Creat cgroup to assign processes to CPU 1
ExecStartPre=/usr/bin/mkdir -p /sys/fs/cgroup/cpuset/cfe_group
ExecStartPre=/bin/bash -c '/usr/bin/echo "1" > /sys/fs/cgroup/cpuset/cfe_group/cpuset.cpus'
ExecStartPre=/bin/bash -c '/usr/bin/echo "0" > /sys/fs/cgroup/cpuset/cfe_group/cpuset.mems'

# ENT-2841: Ensure synchronous start behavior
ExecStart=/bin/systemctl start cf-serverd
ExecStart=/bin/systemctl start cf-execd
ExecStart=/bin/systemctl start cf-monitord
ExecStart=/bin/systemctl start cf-postgres
ExecStart=/bin/systemctl start cf-apache
ExecStart=/bin/systemctl start cf-runalerts
ExecStart=/bin/systemctl start cf-hub

# ENT-2841: Ensure synchronous stop behavior
ExecStop=/bin/systemctl stop cf-serverd
ExecStop=/bin/systemctl stop cf-execd
ExecStop=/bin/systemctl stop cf-monitord
ExecStop=/bin/systemctl stop cf-hub
ExecStop=/bin/systemctl stop cf-runalerts
ExecStop=/bin/systemctl stop cf-apache
ExecStop=/bin/systemctl stop cf-postgres

# Tear down cgroup
ExecStopPost=/usr/bin/rmdir /sys/fs/cgroup/cpuset/cfe_group
```

There is no relevant PID in this service, so we will have to add the individual PID in the different services.

For each of the services you want in the cgroup (running on CPU 1), you need to add this line to the service file:
```
ExecStartPost=/bin/bash -c '/usr/bin/echo $MAINPID >> /sys/fs/cgroup/cpuset/cfe_group/tasks'
```

I added it to the 4 processes we saw earlier, `cf-hub`, `cf-serverd`, `cf-execd`, `cf-monitord`.
`cf-execd` spawns (forks) `cf-agent`, so the agent will also be in the same cgroup.

As an example, my cf-execd service looks like this:
```
$ cat /etc/systemd/system/cf-execd.service
[Unit]
Description=CFEngine Enterprise Execution Scheduler
After=syslog.target
ConditionPathExists=/var/cfengine/bin/cf-execd
ConditionPathExists=/var/cfengine/inputs/promises.cf
PartOf=cfengine3.service

[Service]
Type=simple
ExecStart=/var/cfengine/bin/cf-execd --no-fork
Restart=always
RestartSec=10
KillMode=process

# Add PID to cgroup:
ExecStartPost=/bin/bash -c '/usr/bin/echo $MAINPID >> /sys/fs/cgroup/cpuset/cfe_group/tasks'

[Install]
WantedBy=multi-user.target
WantedBy=cfengine3.service
```

### Reloading and checking results:

Again, we need to reload and restart to see results:
```
$ systemctl daemon-reload
$ systemctl restart cfengine3
$ ps ax -o pid,psr,comm | grep [c]f
11934   1 cf-serverd
11941   1 cf-execd
11947   1 cf-monitord
12002   1 cf-hub
```

That's it!
Change the `1` in `cfengine3.service` to whatever cpu core you want to use, then reload and restart to check that it worked.
A good next step is to automate this, make CFEngine set up these services with our new modifications.

If you want to use multiple cores for CFEngine (but not all), there are two options:

 * Create more cgroups and assign the services how you want them manually
 * Instead of writing `"1"` to `cpuset.cpus` use a comma-separated list:

```
ExecStartPre=/bin/bash -c '/usr/bin/echo "1,2,3" > /sys/fs/cgroup/cpuset/cfe_group/cpuset.cpus'
```
