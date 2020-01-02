---
title: "I tried using Fedora for the first time"
date: 2020-01-02T23:20:03+01:00
draft: true
---

## Live USB

## GRUB

## NVidia drivers

## Music

### Tidal

### Spotify

## Containerization

## Virtualization

### Password checks - PolicyKit

```
root@ohfedora rules.d $ cat /etc/polkit-1/rules.d/80-libvirt-manage.rules
polkit.addRule(function(action, subject) {
if (action.id == "org.libvirt.unix.manage" &amp;&amp; subject.local &amp;&amp; subject.active &amp;&amp; subject.isInGroup("wheel")) {
return polkit.Result.YES;
}
});
root@ohfedora rules.d $
```

### sudoless vagrant package

```
+ vagrant package basebox --output base.box
==> basebox: Halting domain...
==> basebox: Packaging domain...
==> basebox: Require set read access to /var/lib/libvirt/images/starter_pack_basebox.img. sudo chmod a+r /var/lib/libvirt/images/starter_pack_basebox.img
Traceback (most recent call last):
	90: from /usr/share/vagrant/gems/bin/vagrant:23:in `<main>'
	89: from /usr/share/vagrant/gems/bin/vagrant:23:in `load'
	88: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/bin/vagrant:182:in `<top (required)>'
	87: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/environment.rb:290:in `cli'
	86: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/cli.rb:66:in `execute'
	85: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/plugins/commands/package/command.rb:45:in `execute'
	84: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/plugins/commands/package/command.rb:77:in `package_target'
	83: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/plugin/v2/command.rb:232:in `with_target_vms'
	82: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/plugin/v2/command.rb:232:in `each'
	81: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/plugin/v2/command.rb:238:in `block in with_target_vms'
	80: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/plugins/commands/package/command.rb:79:in `block in package_target'
	79: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/plugins/commands/package/command.rb:90:in `package_vm'
	78: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/machine.rb:195:in `action'
	77: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/machine.rb:195:in `call'
	76: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/environment.rb:613:in `lock'
	75: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/machine.rb:209:in `block in action'
	74: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/machine.rb:238:in `action_raw'
	73: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/runner.rb:102:in `run'
	72: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/util/busy.rb:19:in `busy'
	71: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/runner.rb:102:in `block in run'
	70: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/builder.rb:116:in `call'
	69: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/warden.rb:50:in `call'
	68: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/builtin/before_trigger.rb:23:in `call'
	67: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/warden.rb:50:in `call'
	66: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/builtin/config_validate.rb:25:in `call'
	65: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/warden.rb:50:in `call'
	64: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/builtin/after_trigger.rb:26:in `call'
	63: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/warden.rb:50:in `call'
	62: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/builtin/before_trigger.rb:23:in `call'
	61: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/warden.rb:50:in `call'
	60: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/builtin/config_validate.rb:25:in `call'
	59: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/warden.rb:50:in `call'
	58: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/builtin/after_trigger.rb:26:in `call'
	57: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/warden.rb:50:in `call'
	56: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/builtin/before_trigger.rb:23:in `call'
	55: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/warden.rb:50:in `call'
	54: from /usr/share/vagrant/gems/gems/vagrant-libvirt-0.0.45/lib/vagrant-libvirt/action/forward_ports.rb:197:in `call'
	53: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/warden.rb:50:in `call'
	52: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/builtin/after_trigger.rb:26:in `call'
	51: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/warden.rb:50:in `call'
	50: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/builtin/before_trigger.rb:23:in `call'
	49: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/warden.rb:50:in `call'
	48: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/builtin/call.rb:53:in `call'
	47: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/runner.rb:102:in `run'
	46: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/util/busy.rb:19:in `busy'
	45: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/runner.rb:102:in `block in run'
	44: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/builder.rb:116:in `call'
	43: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/warden.rb:50:in `call'
	42: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/warden.rb:121:in `block in finalize_action'
	41: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/warden.rb:50:in `call'
	40: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/builtin/before_trigger.rb:23:in `call'
	39: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/warden.rb:50:in `call'
	38: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/builtin/call.rb:53:in `call'
	37: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/runner.rb:102:in `run'
	36: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/util/busy.rb:19:in `busy'
	35: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/runner.rb:102:in `block in run'
	34: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/builder.rb:116:in `call'
	33: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/warden.rb:50:in `call'
	32: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/warden.rb:121:in `block in finalize_action'
	31: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/warden.rb:50:in `call'
	30: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/warden.rb:121:in `block in finalize_action'
	29: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/warden.rb:50:in `call'
	28: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/builtin/after_trigger.rb:26:in `call'
	27: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/warden.rb:50:in `call'
	26: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/builtin/before_trigger.rb:23:in `call'
	25: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/warden.rb:50:in `call'
	24: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/builtin/call.rb:53:in `call'
	23: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/runner.rb:102:in `run'
	22: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/util/busy.rb:19:in `busy'
	21: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/runner.rb:102:in `block in run'
	20: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/builder.rb:116:in `call'
	19: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/warden.rb:50:in `call'
	18: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/warden.rb:121:in `block in finalize_action'
	17: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/warden.rb:50:in `call'
	16: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/builtin/before_trigger.rb:23:in `call'
	15: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/warden.rb:50:in `call'
	14: from /usr/share/vagrant/gems/gems/vagrant-libvirt-0.0.45/lib/vagrant-libvirt/action/halt_domain.rb:36:in `call'
	13: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/warden.rb:50:in `call'
	12: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/builtin/after_trigger.rb:26:in `call'
	11: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/warden.rb:50:in `call'
	10: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/warden.rb:121:in `block in finalize_action'
	 9: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/warden.rb:50:in `call'
	 8: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/builtin/after_trigger.rb:26:in `call'
	 7: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/warden.rb:50:in `call'
	 6: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/warden.rb:121:in `block in finalize_action'
	 5: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/warden.rb:50:in `call'
	 4: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/builtin/after_trigger.rb:26:in `call'
	 3: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/warden.rb:50:in `call'
	 2: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/builtin/before_trigger.rb:23:in `call'
	 1: from /usr/share/vagrant/gems/gems/vagrant-2.2.6/lib/vagrant/action/warden.rb:50:in `call'
/usr/share/vagrant/gems/gems/vagrant-libvirt-0.0.45/lib/vagrant-libvirt/action/package_domain.rb:34:in `call': Have no access (RuntimeError)
olehermanse@ohfedora starter_pack $
```
