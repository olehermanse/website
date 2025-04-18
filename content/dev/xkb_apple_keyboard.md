---
title: "Fixing your mac keyboard in X11 (RHEL 7)"
date: 2019-03-12T21:24:30+01:00
tags:
  - "redhat"
  - "mac"
  - "unix"
  - "configuration"
aliases:
  - /unix/xkb_apple_keyboard/
---

_Alternatively: How xkb works, and how to change keys which are wrong._

On OS X, there is no alt+gr.
Combinations of shift and alt are used instead.
Both alt keys behave the same.
You can make your Apple internal or external keyboard behave like this on Linux.
This blog post shows how, but please note that it changes the behavior of your alt keys.
So keyboard shortcuts which rely on alt might not work any more.

I will focus on the norwegian mac layout, but the steps should be the same for other layouts.
I'm using RHEL 7, and this is specific to X.
Wayland and libinput will be different.

**Why doesn't it work?**

1. Shift+alt already has a function (switching layouts) which will capture the keyboard events.
2. Behavior of alt key needs to be changed to match OS X.
3. Some keys in the Macintosh keyboard layout are wrong, and need to be changed.

## Pick the correct layout

1. Click `cmd` to open the system search.
2. Search for Language.
3. Click "Region & Langauge"
4. Input sources is the important part, "Language" and "Formats" don't affect your keyboard layout.
5. If the input source isn't already correct, add the correct one with the plus symbol, and remove the incorrect one.

I recommend using just 1 input source, unless you really need 2 layouts.
My preferred layout is "Norwegian (Macintosh, no dead keys)".
"No dead keys" means that backticks don't require two clicks, they are inserted immediately.
This is generally preferred for writing code, but makes it more difficult to make accented characters.

## Disable shift+alt to switch keyboard layout

Use `dconf` to disable shift+alt toggling of layouts:

```
$ dconf read /org/gnome/desktop/input-sources/xkb-options
['grp:alt_shift_toggle', 'grp:win_space_toggle']
$ dconf write /org/gnome/desktop/input-sources/xkb-options "['grp:win_space_toggle']"
$ dconf read /org/gnome/desktop/input-sources/xkb-options
['grp:win_space_toggle']
```

## Keyboard layout and mapping

Keyboard mapping has 2 stages.
First stage (`keycodes`) depends on the keyboard model.
Second stage (`symbols`) depends on the input source picked in Settings.
The configuration files can be found in `/usr/share/X11/xkb/`.

This sounds great in theory, except when the system struggles to identify keyboard model automatically.
Since this model isn't exposed to the user in UI, a normal user doesn't really know that it exists, or how to change it.
The result is that we address problems in the `symbols` file which should have been done in `keycodes`.

### Keycodes

Keyboards send a number for each key pressed or released.
This number is typically represented as a decimal number, up to 255.
There is a per-keyboard-model mapping in `/usr/share/X11/xkb/keycodes/`.
They map the decimal keycodes to an abstract button name.

Here is an example:

```
    <LSTG> = 49;
```

This states that keycode 49 sent from the keyboard should map to LSTG (less than, greater than) button.
The `keycodes` folder has different files for different keyboard models.

#### Checking which keycodes file is used

```
$ setxkbmap -print -verbose 10 | grep keycodes
keycodes:   evdev+aliases(qwerty)
    xkb_keycodes { include "evdev+aliases(qwerty)" };
```

Note that I am not using the mac keycodes, but rather a generic one in evdev.
Thus, I either have to edit `/usr/share/X11/org/keycodes/evdev/`, or change which keycodes are used.
In most cases it's easier to leave keycodes as is and only edit `symbols` instead.

#### Examining keycodes sent by keyboard

You can see the keycodes from your keyboard using `xev`:

```
$ xev
[...]
KeyPress event, serial 37, synthetic NO, window 0x3000001,
    root 0x1e2, subw 0x0, time 6206389, (1553,682), root:(1598,792),
    state 0x0, keycode 38 (keysym 0x61, a), same_screen YES,
    XLookupString gives 1 bytes: (61) "a"
    XmbLookupString gives 1 bytes: (61) "a"
    XFilterEvent returns: False

KeyRelease event, serial 37, synthetic NO, window 0x3000001,
    root 0x1e2, subw 0x0, time 6206469, (1553,682), root:(1598,792),
    state 0x0, keycode 38 (keysym 0x61, a), same_screen YES,
    XLookupString gives 1 bytes: (61) "a"
    XFilterEvent returns: False
```

(Focus the small window and click buttons to see their information printed in terminal).

The important part is `keycode 38`.
You can open `/usr/share/X11/org/keycodes/evdev` and follow this keycode, to see what name it's assigned.
Then, in the `symbols` files, you can see which symbols are attached to this name.

It is possible to make changes to this `keycodes` file, but be aware that it might be shared with other users, other physical keyboards, other keyboard layouts.
So changing something here might break something else.
Usually it's safer to edit the `symbols` layout configurations instead, as they are tied to the input source option.

#### Changing which keycodes file is used

**DO NOT do this unless you are prepared for things to break, and to fix a lot ofthings**.
You can work around wonky keycodes in symbols file instead.

```
$ setxkbmap -keycodes "macintosh"
```

Once you are done editing keycodes and symbols, and your keyboard works as expected, add this to your `~/.bashrc` so it onlyappliesto you.
Changes you make to `/usr/share/X11` and `/etc/X11`.

### Symbols

Each input source option has a mapping from abstract button codes to symbol.
These mappings are found in `/usr/share/X11/xkb/symbols/`.

#### Checking which symbols file is used

```
$ setxkbmap -print -verbose 10 | grep symbols
symbols:    pc+no(mac_nodeadkeys)+inet(evdev)+group(win_space_toggle)
    xkb_symbols   { include "pc+no(mac_nodeadkeys)+inet(evdev)+group(win_space_toggle)"};
```

There's a lot of information there, but the most specific one is `no(mac_nodeadkeys)`.
I will edit `mac_nodeadkeys` in the `no` (norwegian) file.
This matches my chosen input source.

#### Changing the behavior of alt keys

Change the keyboard layout in `/usr/share/X11/xkb/symbols/no`

```
partial alphanumeric_keys
xkb_symbols "mac" {

    // Describes the differences between a very simple en_US
    // keyboard and a very simple Norwegian keyboard.

    include "latin(type4)"
    name[Group1]= "Norwegian (Macintosh)";

    key <TLDE>  { [       bar,    section     ] };
    key <AE03>  { [         3, numbersign,     sterling,     sterling ] };
    key <AE04>  { [         4,   currency,       dollar,       dollar ] };
    key <AE06>  { [         6,  ampersand, threequarters, fiveeighths ] };
    key <AE07>  { [         7,      slash,          bar,    backslash ] };
    key <AE08>  { [         8,  parenleft,  bracketleft,    braceleft ] };
    key <AE09>  { [         9, parenright, bracketright,   braceright ] };
    key <AC10>  { [    oslash,   Ooblique,   odiaeresis,   Odiaeresis ] };
    key <AE11>  { [      plus,   question     ] };
    key <AC11>  { [        ae,         AE     ] };
    key <AD11>  { [     aring,      Aring     ] };
    key <AE12>  { [ dead_grave, dead_acute,       acute,  dead_ogonek ] };
    key <AD12>  { [ diaeresis, asciicircum,  asciitilde,  dead_macron ] };
    key <BKSL>  { [        at,   asterisk     ] };

    include "level3(ralt_switch)" // EDIT: Make right alt work like alt gr (level 3
    include "level3(lalt_switch)" // EDIT: Make left alt work like alt gr (level 3)
};
```

Adding the last 2 `include` lines will give alt keys the desired behavior.
Log out and in for changes to take effect.

## Fixing remaining keys

In the config above, more key mappings (lines beginning with `key`) can be added to fix problematic keys.
Note that if you didn't change anything related to keycodes, some of the names might be wrong/confusing (like `TLDE`, `LSTG`).

```
    // CUSTOM EDITS: Working around bad keycodes:
    key <LSGT>  { [apostrophe,    section     ] };
    key <TLDE>  { [      less,    greater,      onehalf, threequarters] };
    key <AE04>  { [         4,     dollar,     EuroSign,     EuroSign ] }; // EDIT: shift+4=dollar, alt+4=euro

    // OS X Like alt keys:
    include "level3(ralt_switch)" // EDIT: Make right alt work like alt gr (level 3)
    include "level3(lalt_switch)" // EDIT: Make left alt work like alt gr (level 3)
```

Log out and in for changes to take effect.

# Preserving changes

## setxkbmap

Add the commands to your `~/.bashrc` to make them permanent.

## /usr/share/X11/xkb/

May be overwritten by updates.
Make sure you save backups, patches or scripts to reapply your changes.
