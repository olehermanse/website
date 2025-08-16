---
title: "The DayKnight 30-day project - Week 1"
description: '"Graphical" User Interface'
date: 2018-04-15T16:57:09+02:00
categories:
  - "Development"
  - "Game Development"
tags:
  - "gamedev"
  - "mrpg"
  - "dk30"
  - "rpg"
  - "gui"
  - "ux"
---

[This weeks task](../dayknight30) was to experiment and implement a better User Interface.
I used pyglet to make a simple GUI, which currently has the same functionality as the terminal version.
It's still just text so far, creating GUI from scratch takes time, but adding more graphics and animation is now possible.
Had to spend a decent amount of time refactoring, making sure the [core package](https://github.com/olehermanse/mrpg/tree/132fa999c792a1b8e34dc766cc9a5eb689a8b657/mrpg/core), which contains game logic, was completely separate from any terminal specific code.
I also spent a little time balancing stats and the 4 skills currently available, so that the game is playable and all 4 skills have purpose.

### Terminal version

The old interface in terminal looked like this:

![GIF of terminal version](/mrpg/terminal_0.gif)

### GUI version

The new GUI version (WIP!) looks like this:

![GIF of GUI version](/mrpg/gui_0.gif)

It is a little rough around the edges, but has mostly the same functionality as the terminal version.
Some obvious next steps are:

- Print messages character by character to better guide attention
- Frames around different text boxes
- Replace the textual stats and battle screens with prettier graphical representation
  - Green and blue health and mana bars instead of text
  - Bars / numbers can be animated for damage / healing / exp gain etc.
- Simple sprites for player and enemy
- More interesting backgrounds

### Next week

[The plan for next week](../dayknight30) is to work on _effects_, i.e. buffs and debuffs caused by skills which last multiple turns.
I'll try to stick to this plan, but I might get back to doing a little more GUI if I finish early.

### Changelog

For the extra interested I've generated a changelog based on my commit history:

- [GUI: Better default option when going from one menu to another](https://github.com/olehermanse/mrpg/commit/733bf2fc45f77c0f5fcede417b11693d8b1aca17)
- [Experience gain is now printed after adventure success message](https://github.com/olehermanse/mrpg/commit/448c1ac35479a4bee4c0256e37cd81debf1ec185)
- [Added a message when meeting a new enemy in adventures](https://github.com/olehermanse/mrpg/commit/64807218b7c6a4bb8bacdbc1376596e689df308d)
- [Added hello message when creating new character](https://github.com/olehermanse/mrpg/commit/d9f2d4848819db1747ff304fadf87b98f9e5cd5d)
- [Skills are no longer printed in battle](https://github.com/olehermanse/mrpg/commit/ab95c269bb69ea20f2ab07791fa9f28af68050db)
- [Player now starts with 4 skills](https://github.com/olehermanse/mrpg/commit/e38872841e783a2a88269d79f4ec886c23d436bb)
- [GUI: Separate labels for battle stats](https://github.com/olehermanse/mrpg/commit/2d65f12b50898f83d762d32b237ab7d7589e265d)
- [GUI: Moved GUI class to separate file](https://github.com/olehermanse/mrpg/commit/d6b56d2b2f49f88338ac9a7eec9b80d09b6dadb1)
- [GUI: Enter and navigation in menus](https://github.com/olehermanse/mrpg/commit/e8766d1180bae4451a3291de0f3d4384b617b263)
- [Animation based on character width](https://github.com/olehermanse/mrpg/commit/11fc7be111bbf407d9271b560763bce28dc45077)
- [Font options for Mac OS X](https://github.com/olehermanse/mrpg/commit/8fe60aaef22f2ca174bfb3cbb9510577f31e65a0)
- [Up and down working in GUI menu](https://github.com/olehermanse/mrpg/commit/097ab39c8a6f4c8825fa90f12de6ad008057018b)
- [GUI: Menus (rendering only)](https://github.com/olehermanse/mrpg/commit/953b4914d3cc115864e1de82c1acf5c66e658fbb)
- [GUI: Better fonts and spacing](https://github.com/olehermanse/mrpg/commit/29b4cc2cedf2c99f5e83bda7cfa4937b2ede18aa)
- [GUI: Backgreound and title text](https://github.com/olehermanse/mrpg/commit/a5b13c2e810ace73fe87df35a41857fdcf5e1981)
- [Big refactorings to enable GUI](https://github.com/olehermanse/mrpg/commit/c699b6ebc68694f6ddaefe63fea788c5e73f08f1)
- [Removed unused arguments](https://github.com/olehermanse/mrpg/commit/7e87fb4cbb6353da9821ee400323dd42f1d3fd0c)
- [Added small banner to main menu](https://github.com/olehermanse/mrpg/commit/ca51b4ab708bd540cbbd22e4847bbb7e46f016d6)
- [Removed game over exception](https://github.com/olehermanse/mrpg/commit/cd3cd7455112a76a3ef08196b9f8c56424ede72b)
- [Removed level and skills from character creator](https://github.com/olehermanse/mrpg/commit/3419c2a4afba393dd57d27dc27b8c90b196ad8fe)
- [Balanced out starter stats](https://github.com/olehermanse/mrpg/commit/7c2140467e53c2bf5e62e1dc8c1cea689559a353)
- [Case insensitive skills](https://github.com/olehermanse/mrpg/commit/7a3d75f2f5dc956c83f0278d3fb33e4e0caa17bc)
- [Balanced the 4 basic starter skills](https://github.com/olehermanse/mrpg/commit/8d162a98f24317d65d60330ca9fafbf0f05a1d19)
- [Windows compatible clear](https://github.com/olehermanse/mrpg/commit/243b2c3abaf62bccfa42c3fc113a6885faa5d479)
- [Clean up imports](https://github.com/olehermanse/mrpg/commit/535e02da7e6f2030fd8b706b367aaa2c7f35b854)
- [README](https://github.com/olehermanse/mrpg/commit/574ba1bcda7a8579df7fe0b9c4e2dfb488fbcfbb)
- [Skill collection system](https://github.com/olehermanse/mrpg/commit/7fe94030d990b7a4e8178b4639cac673e78515ed)
- [YAPF for formatting](https://github.com/olehermanse/mrpg/commit/424d43b84ec98f90a933273ad879407b48756a62)
- [Sane importing/module behavior](https://github.com/olehermanse/mrpg/commit/9a81003632b5415f17426a3ad3e940c4e1c2d293)

See [github.com/olehermanse/mrpg](https://github.com/olehermanse/mrpg) for more details.
