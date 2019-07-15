---
title: "Running cf-runagent as non-root"
date: 2019-04-10T11:38:06+02:00
draft: false
tags:
  - "cfengine"
  - "unix"
  - "configuration"
---

I work at [Northern.tech](https://northern.tech), developing [CFEngine](https://github.com/cfengine/core), a configuration management system.
This is a work (CFEngine) related post.

`cf-runagent` is a component for triggering remote agent runs using the CFEngine network protocol.
It does not allow for arbitrary commands to be executed, but rather asks the remote host to run the policy it already has.
To trigger `cf-runagent` from other systems or web interfaces, you want to be able to run it as non-root.

## Install and bootstrap

I will use [cf-remote](https://oleherman.com/unix/cf-remote/) to set up a demo hub running CFEngine Enterprise 3.12.1:

```
olehermanse@OHMBP-2869 ~ $ cf-remote install --version 3.12.1 --hub 34.251.155.150 --bootstrap 172.31.2.67 --demo

ubuntu@34.251.155.150
OS            : ubuntu (debian)
Architecture  : x86_64
CFEngine      : Not installed
Policy server : None
Binaries      : dpkg, apt

Package already downloaded: '/Users/olehermanse/.cfengine/cf-remote/packages/cfengine-nova-hub_3.12.1-1_amd64.deb'
Copying: '/Users/olehermanse/.cfengine/cf-remote/packages/cfengine-nova-hub_3.12.1-1_amd64.deb' to '34.251.155.150'
Installing: 'cfengine-nova-hub_3.12.1-1_amd64.deb' on '34.251.155.150'
CFEngine 3.12.1 was successfully installed on '34.251.155.150'
Bootstrapping: '34.251.155.150' -> '172.31.2.67'
Bootstrap successful: '34.251.155.150' -> '172.31.2.67'
Transferring def.json to hub: '34.251.155.150'
Copying: '/Users/olehermanse/.cfengine/cf-remote/json/def.json' to '34.251.155.150'
Triggering an agent run on: '34.251.155.150'
Disabling password change on hub: '34.251.155.150'
Triggering an agent run on: '34.251.155.150'
Your demo hub is ready: https://34.251.155.150/ (Username: admin, Password: password)
```

## SSH

`cf-remote` output shows the username and IP we can ssh to:

```
olehermanse@OHMBP-2869 ~ $ ssh ubuntu@34.251.155.150
The authenticity of host '34.251.155.150 (34.251.155.150)' can't be established.
ECDSA key fingerprint is SHA256:J2rxvibDSb8KCoz3xdfixHLdkt+znmwt/qaVHXFVRns.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '34.251.155.150' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 18.04.2 LTS (GNU/Linux 4.15.0-1032-aws x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Wed Apr 10 08:01:30 UTC 2019

  System load:  0.16              Processes:           214
  Usage of /:   18.2% of 7.69GB   Users logged in:     0
  Memory usage: 1%                IP address for eth0: 172.31.2.67
  Swap usage:   0%


  Get cloud support with Ubuntu Advantage Cloud Guest:
    http://www.ubuntu.com/business/services/cloud

0 packages can be updated.
0 updates are security updates.


ubuntu@ip-172-31-2-67:~$ sudo bash
root@ip-172-31-2-67:~#
```

(You will need a text editor, so feel free to install `emacs` if you want).

## Create user

```
root@ip-172-31-2-67:~# adduser cf-runner --disabled-password
Adding user `cf-runner' ...
Adding new group `cf-runner' (1001) ...
Adding new user `cf-runner' (1001) with group `cf-runner' ...
The home directory `/home/cf-runner' already exists.  Not copying from `/etc/skel'.
Changing the user information for cf-runner
Enter the new value, or press ENTER for the default
	Full Name []:
	Room Number []:
	Work Phone []:
	Home Phone []:
	Other []:
Is the information correct? [Y/n] Y
root@ip-172-31-2-67:~# sudo -u cf-runner bash
cf-runner@ip-172-31-2-67:~$
```

## Add policy file

The CFEngine components expect a `promises.cf` policy entry point in the `inputs` directory.
For a non-root user, this is `~/.cfagent/inputs/promises.cf`.
For the purposes of using `cf-runagent` it can be an empty file:

```
cf-runner@ip-172-31-2-67:~$ cf-runagent -H 172.31.2.67
   error: Can't stat file '/home/cf-runner/.cfagent/inputs/promises.cf' for parsing. (stat: No such file or directory)
cf-runner@ip-172-31-2-67:~$ touch /home/cf-runner/.cfagent/inputs/promises.cf && chmod ugo-w /home/cf-runner/.cfagent/inputs/promises.cf
```

## Generate a key pair

CFengine stores public and private keys in `/var/cfengine/ppkeys/`(root) and `~/.cfagent/ppkeys/`(non-root).
We can generate a new key specific to this user:

```
cf-runner@ip-172-31-2-67:~$ cf-runagent -H 172.31.2.67
   error: No public/private key pair is loaded, please create one using cf-key
   error: Failed to connect to host: 172.31.2.67
cf-runner@ip-172-31-2-67:~$ cf-key
cf-runner@ip-172-31-2-67:~$
```

## Trust the server key

`cf-runagent` will now trust public keys in `~/.cfagent/ppkeys/`, so we will have to add the server's public key:

```
cf-runner@ip-172-31-2-67:~$ cf-runagent -H 172.31.2.67
   error: TRUST FAILED, server presented untrusted key: SHA=af4c5dce82c29d18142cb3308f2086bfd0e1123fef948f73209c3053c2d6d7a6
   error: Failed to connect to host: 172.31.2.67
```

### Interactively trusting keys

The easiest way to trust the key is to run with the `--interactive` option:

```
cf-runner@ip-172-31-2-67:~$ cf-runagent -H 172.31.2.67 --interactive
WARNING - You do not have a public key from host 172.31.2.67 = 172.31.2.67
          Do you want to accept one on trust? (yes/no)

--> yes
Will trust the key...
  notice: Trusting new key: SHA=af4c5dce82c29d18142cb3308f2086bfd0e1123fef948f73209c3053c2d6d7a6
172.31.2.67> !!  Unspecified server refusal (see verbose server output)

cf-runner@ip-172-31-2-67:~$
```

### Manually trusting keys

Interactive dialogs can be awkward to script/automate, but we can achieve trust by copying the public key.
We need to switch back to root for a second:

```
cf-runner@ip-172-31-2-67:~$ exit
root@ip-172-31-2-67:~# cp /var/cfengine/ppkeys/localhost.pub /home/cf-runner/.cfagent/ppkeys/cf-runner-SHA=af4c5dce82c29d18142cb3308f2086bfd0e1123fef948f73209c3053c2d6d7a6.pub
root@ip-172-31-2-67:~# ls -al /home/cf-runner/.cfagent/ppkeys/cf-runner-SHA=af4c5dce82c29d18142cb3308f2086bfd0e1123fef948f73209c3053c2d6d7a6.pub
-rw------- 1 root root 426 Apr 10 08:21 '/home/cf-runner/.cfagent/ppkeys/cf-runner-SHA=af4c5dce82c29d18142cb3308f2086bfd0e1123fef948f73209c3053c2d6d7a6.pub'
root@ip-172-31-2-67:~# chown cf-runner:cf-runner /home/cf-runner/.cfagent/ppkeys/cf-runner-SHA=af4c5dce82c29d18142cb3308f2086bfd0e1123fef948f73209c3053c2d6d7a6.pub
root@ip-172-31-2-67:~# sudo -u cf-runner bash
cf-runner@ip-172-31-2-67:~$
```

Note the filename of the public key:

```
/home/cf-runner/.cfagent/ppkeys/<user>-<hostkey>.pub
```

Where `<user>` is the **local** user running `cf-runagent`, and `<hostkey>` is the key digest of the (remote) `cf-serverd` (most likely running as root).
If you forget the `.pub` extension, or get the file name wrong in any way, it will not work.

## Trusting the client key

In a new installation, `cf-serverd` automatically trusts new keys, placing them into `/var/cfengine/ppkeys`.
This behavior is controlled by `trustkeysfrom` in the `cf-serverd` policy.
It is recommended to disable or tighten this feature, so the server doesn't automatically trust new keys.
If you have already disabled it, and need to manually trust the new client key we generated, you can do so by copying the public key file:

```
cf-runner@ip-172-31-2-67:~$ cf-runagent -H 172.31.2.67
   error: Connection unexpectedly closed (SSL_read): socket closed
   error: Connection was hung up while receiving line:
   error: Connection was hung up during identification! (3)
   error: Failed to connect to host: 172.31.2.67
cf-runner@ip-172-31-2-67:~$ exit
root@ip-172-31-2-67:~# cf-key -p /home/cf-runner/.cfagent/ppkeys/localhost.pub
SHA=c57b3c10ff9dd6b051b02157561de26cf11e357523cf39da6fdeb1dc4cfe790a
root@ip-172-31-2-67:~# cp /home/cf-runner/.cfagent/ppkeys/localhost.pub /var/cfengine/ppkeys/cf-runner-SHA=c57b3c10ff9dd6b051b02157561de26cf11e357523cf39da6fdeb1dc4cfe790a.pub
root@ip-172-31-2-67:~# cf-agent -Kf update.cf && cf-agent -K
root@ip-172-31-2-67:~# systemctl restart cfengine3
root@ip-172-31-2-67:~# cf-agent -Kf update.cf && cf-agent -K
root@ip-172-31-2-67:~# sudo -u cf-runner bash
cf-runner@ip-172-31-2-67:~$
```

(If you are using the default policy, without altering `trustkeysfrom`, this step is not necessary).

## Verbose server output

```
cf-runner@ip-172-31-2-67:~$ cf-runagent -H 172.31.2.67
172.31.2.67> !!  Unspecified server refusal (see verbose server output)

cf-runner@ip-172-31-2-67:~$
```

The server is still rejecting cf-runagent.
Let's start it in verbose mode to find out why.

```
cf-runner@ip-172-31-2-67:~$ exit
root@ip-172-31-2-67:~# systemctl stop cf-serverd
root@ip-172-31-2-67:~# /var/cfengine/bin/cf-serverd --no-fork --verbose 2>&1 > /server.log &
[1] 7804
root@ip-172-31-2-67:~# tail /server.log
 verbose: Object delta
 verbose: Object rebase
 verbose: Object full
 verbose:  === END summary of access promises ===
 verbose: Setting minimum acceptable TLS version: 1.0
 verbose: Setting cipher list for incoming TLS connections to: AES256-GCM-SHA384:AES256-SHA
 verbose: Listening for connections on socket descriptor 6 ...
  notice: Server is starting...
 verbose: CollectCallWorker: no interval specified. Not starting
 verbose: CollectCallHasPending: false
root@ip-172-31-2-67:~# sudo -u cf-runner bash
cf-runner@ip-172-31-2-67:~$ cf-runagent -H 172.31.2.67
172.31.2.67> !!  Unspecified server refusal (see verbose server output)

cf-runner@ip-172-31-2-67:~$ exit
root@ip-172-31-2-67:~# tail /server.log
 verbose: 172.31.2.67>     Peeked nothing important in TCP stream, considering the protocol as TLS
 verbose: 172.31.2.67>     TLS version negotiated:  TLSv1.2; Cipher: AES256-GCM-SHA384,TLSv1.2
 verbose: 172.31.2.67>     TLS session established, checking trust...
 verbose: 172.31.2.67>     Setting IDENTITY: USERNAME=cf-runner
 verbose: 172.31.2.67>     Received public key compares equal to the one we have stored
 verbose: 172.31.2.67>     SHA=c57b3c10ff9dd6b051b02157561de26cf11e357523cf39da6fdeb1dc4cfe790a: Client is TRUSTED, public key MATCHES stored one.
 verbose: 172.31.2.67>          Received:    EXEC
    info: 172.31.2.67>     EXEC denied due to not allowed user: cf-runner
 verbose: 172.31.2.67>     REFUSAL to user='cf-runner' of request: EXEC
    info: 172.31.2.67>     Closing connection, terminating thread
root@ip-172-31-2-67:~#
```

The output indicates that `cf-runner` is not an allowed user for `EXEC` requests (cf-runagent).
(In CFEngine 3.7 there is no `cf-serverd` unit, stop the entire `cfengine3` unit instead).

## Allow the user to make EXEC requests

### Via augments

If you are running masterfiles 3.12.1 or newer, allowed users can easily be controlled via augments.
Use your favorite editor to alter `def.json`:

```
root@ip-172-31-2-67:~# cat > /var/cfengine/masterfiles/def.json
{
  "vars":
  {
    "control_server_allowusers_non_policy_server": [ "cf-runner" ],
    "control_server_allowusers_policy_server": [ "cf-runner" ]
  }
}
root@ip-172-31-2-67:~#
```

`cat` will overwrite `def.json`, so you might want to use a more advanced editor.
Note that the usernames in `allowusers` are self reported, and could be spoofed.
Use other ACL's and `allowconnects` as security measures, not `allowusers`.

### Via policy

For older versions of the policy framework, you will have to edit the policy manually.
`cf-serverd` policy is at `/var/cfengine/masterfiles/controls/cf_serverd.cf`.
(In 3.7: `/var/cfengine/masterfiles/controls/3.7/cf_serverd.cf`).
You need to add a list of allowed users to `body server control`:

```
body server control
{
  [...]
  any::
    allowusers => { "cf-runner" };
}
```

Replace the `any::` class guard with one describing the hosts where you want to allow `cf-serverd` to accept remote `cf-runagent` requests.

## Update policy and restart server

```
root@ip-172-31-2-67:~# pkill -f cf-serverd
root@ip-172-31-2-67:~# cf-agent -Kf update.cf && cf-agent -K
root@ip-172-31-2-67:~# systemctl start cf-serverd
root@ip-172-31-2-67:~# systemctl restart cfengine3
root@ip-172-31-2-67:~# cf-agent -Kf update.cf && cf-agent -K
```

## Voilà

```
root@ip-172-31-2-67:~# sudo -u cf-runner bash
cf-runner@ip-172-31-2-67:~$ cf-runagent -H 172.31.2.67
172.31.2.67> cf-serverd executing cfruncommand: /bin/sh -c '
                           "/var/cfengine/bin/cf-agent" -I -D cf_runagent_initiated -f /var/cfengine/inputs/update.cf  ;
                           "/var/cfengine/bin/cf-agent" -I -D cf_runagent_initiated
172.31.2.67> ->     info: Executing 'no timeout' ... '/var/cfengine/httpd/php/bin/php /var/cfengine/httpd/htdocs/index.php cli_tasks clearLastSeenHostsLogs'
172.31.2.67> ->     info: Completed execution of '/var/cfengine/httpd/php/bin/php /var/cfengine/httpd/htdocs/index.php cli_tasks clearLastSeenHostsLogs'
172.31.2.67> ->     info: Executing 'no timeout' ... '/var/cfengine/httpd/php/bin/php /var/cfengine/httpd/htdocs/index.php cli_tasks process_api_events'
172.31.2.67> ->     info: Command related to promiser '/var/cfengine/httpd/php/bin/php' returned code defined as promise kept 0
172.31.2.67> ->     info: Completed execution of '/var/cfengine/httpd/php/bin/php /var/cfengine/httpd/htdocs/index.php cli_tasks process_api_events'
172.31.2.67> ->     info: Executing 'no timeout' ... '/var/cfengine/httpd/php/bin/php /var/cfengine/httpd/htdocs/index.php cli_tasks materialized_hosts_view_refresh'
172.31.2.67> ->     info: Completed execution of '/var/cfengine/httpd/php/bin/php /var/cfengine/httpd/htdocs/index.php cli_tasks materialized_hosts_view_refresh'
172.31.2.67> ->     info: Executing 'no timeout' ... '/var/cfengine/httpd/php/bin/php /var/cfengine/httpd/htdocs/index.php cli_tasks inventory_refresh'
172.31.2.67> ->     info: Command related to promiser '/var/cfengine/httpd/php/bin/php' returned code defined as promise kept 0
172.31.2.67> ->     info: Completed execution of '/var/cfengine/httpd/php/bin/php /var/cfengine/httpd/htdocs/index.php cli_tasks inventory_refresh'
cf-runner@ip-172-31-2-67:~$ cf-runagent -H 172.31.2.67
172.31.2.67> cf-serverd executing cfruncommand: /bin/sh -c '
                           "/var/cfengine/bin/cf-agent" -I -D cf_runagent_initiated -f /var/cfengine/inputs/update.cf  ;
                           "/var/cfengine/bin/cf-agent" -I -D cf_runagent_initiated
cf-runner@ip-172-31-2-67:~$
```

Locks are respected, so some runs have more output than others.

## Summary

In short these things are needed:

* Bootstrapped CFEngine installation working and running `cf-serverd` (Preferably 3.12.1+).
* A new user to run `cf-runagent` - Created using `adduser`.
* A new key pair for the `cf-runagent` user - Created by running `cf-key` as that user.
* There must be a policy entry point with correct permissions at `~/.cfagent/inputs/promises.cf`. (It can be an empty file).
* The server must trust the `cf-runagent` client key - must be present in `/var/cfengine/ppkeys/` with correct name.
* The `cf-runagent` client must trust the server key - must be present in `~/.cfagent/ppkeys/` with correct name.
* The `cf-runagent` user must be added to `allowusers` in the server policy - either directly or through `def.json` (3.12.1+).

In some cases/versions, you will have to run update policy and/or restart the `cfengine3` service for changes to take effect.
Tested on CFEngine Enterprise Hub, version 3.12.1, 3.10.5, and 3.7.8.
