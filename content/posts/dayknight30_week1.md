---
title: "30-day project - Week 1"
description: "\"Graphical\" User Interface"
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
draft: false
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

* Print messages character by character to better guide attention
* Frames around different text boxes
* Replace the textual stats and battle screens with prettier graphical representation
  * Green and blue health and mana bars instead of text
  * Bars / numbers can be animated for damage / healing / exp gain etc.
* Simple sprites for player and enemy
* More interesting backgrounds

### Next week

[The plan for next week](../dayknight30) is to work on _effects_, i.e. buffs and debuffs caused by skills which last multiple turns.
I'll try to stick to this plan, but I might get back to doing a little more GUI if I finish early.

### Changelog

For the extra interested I've generated a changelog based on my commit history:

* [GUI: Better default option when going from one menu to another](https://github.com/olehermanse/mrpg/commit/81f3adc979acc099965e592aad6b2dc95ba1e533)
* [Experience gain is now printed after adventure success message](https://github.com/olehermanse/mrpg/commit/132fa999c792a1b8e34dc766cc9a5eb689a8b657)
* [Added a message when meeting a new enemy in adventures](https://github.com/olehermanse/mrpg/commit/54873d4df3a663c3116aba845cf8cc28034927db)
* [Added hello message when creating new character](https://github.com/olehermanse/mrpg/commit/eba82046a9bc3d0502813b8cf98c00ea259ad27f)
* [Skills are no longer printed in battle](https://github.com/olehermanse/mrpg/commit/560323ecfe4ee35a702604b47452404be4993d70)
* [Player now starts with 4 skills](https://github.com/olehermanse/mrpg/commit/141aeceec53c7e48224b4e890c7ec234b408b3e7)
* [GUI: Separate labels for battle stats](https://github.com/olehermanse/mrpg/commit/6501b82b9f1b401bb0f543f571206da30f259cea)
* [GUI: Moved GUI class to separate file](https://github.com/olehermanse/mrpg/commit/15b3c8f8c6c3d0fc68ba0a7c02d7c4abae5addf0)
* [GUI: Enter and navigation in menus](https://github.com/olehermanse/mrpg/commit/f14514efbf0b80131060ae8015339adcc6ec5c0e)
* [Animation based on character width](https://github.com/olehermanse/mrpg/commit/e8b2d210d20644fb9fd61809ca36c63b795a9a24)
* [Font options for Mac OS X](https://github.com/olehermanse/mrpg/commit/0d61faf43a211f9bde6d2bb2bdb1ab07dc370fd8)
* [Up and down working in GUI menu](https://github.com/olehermanse/mrpg/commit/874414ab6e74ba0b7bdfd777e815e28823b1ae06)
* [GUI: Menus (rendering only)](https://github.com/olehermanse/mrpg/commit/60564a439baeaf18b7ff0ec6f8f49ffca2477ba6)
* [GUI: Better fonts and spacing](https://github.com/olehermanse/mrpg/commit/03424ff4dbdd8db9d1b2a64723dd0dc31bc48901)
* [GUI: Backgreound and title text](https://github.com/olehermanse/mrpg/commit/6bf471e0451783e792f4044f47c8ea7a56be1992)
* [Big refactorings to enable GUI](https://github.com/olehermanse/mrpg/commit/9b3940523d46c47b3afca40373a3b8e386c3c9e6)
* [Removed unused arguments](https://github.com/olehermanse/mrpg/commit/fde4a22b53ee7339d99e0ce4c87059f3a3ab6785)
* [Added small banner to main menu](https://github.com/olehermanse/mrpg/commit/d5697e265356d04ede7574d9ba7e97d987e5cb48)
* [Removed game over exception](https://github.com/olehermanse/mrpg/commit/1e30f9b2ac4c5ec5b7032dbd23b425cfd96a1b4d)
* [Removed level and skills from character creator](https://github.com/olehermanse/mrpg/commit/10d9b544b6b194f500de4452cb8b241771fb1401)
* [Balanced out starter stats](https://github.com/olehermanse/mrpg/commit/47f4cd207ab60c8cab6be186b431f2c5d3f923ff)
* [Case insensitive skills](https://github.com/olehermanse/mrpg/commit/7ad5c44bf7a9c01fe9529d021398acdd5c7e41f9)
* [Balanced the 4 basic starter skills](https://github.com/olehermanse/mrpg/commit/5c48054f8239c00b8a0cceec84f49266f109614f)
* [Windows compatible clear](https://github.com/olehermanse/mrpg/commit/22982feaa0a42179795f7f949869eb1783f86922)
* [Clean up imports](https://github.com/olehermanse/mrpg/commit/74325a9f0ba8a5c2f01b982d62353c6b2d9a6d5a)
* [README](https://github.com/olehermanse/mrpg/commit/c97c6aa7196d75ce3ed87754f34c3b76cd980cf3)
* [Skill collection system](https://github.com/olehermanse/mrpg/commit/abcdef2a64ee1bad3d29af8ae910e8b8f2d230cd)
* [YAPF for formatting](https://github.com/olehermanse/mrpg/commit/68bbc2faa3d0b2304c7bc1f7c9a14d03ea5ccc0e)
* [Sane importing/module behavior](https://github.com/olehermanse/mrpg/commit/529becfa2a340cfff1f7d75f0bcdc9f5fecaa661)

See [github.com/olehermanse/mrpg](https://github.com/olehermanse/mrpg) for more details.
