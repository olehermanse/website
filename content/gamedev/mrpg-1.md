---
title: "MRPG #1 - Turn based RPG combat and GUI improvements"
description: "Sprites, GUI and combat events"
date: 2019-06-19T22:24:44+02:00
categories:
  - "Development"
  - "Game Development"
tags:
  - "gamedev"
  - "mrpg"
  - "python"
  - "rpg"
---

Recently, I've done a lot of work on my unnamed game project, [MRPG](https://github.com/olehermanse/mrpg/), so I thought I'd share some of it.
The game is turn based, open source, written in python, with a focus on the combat system, and inspired by famous JRPGs such as Final Fantasy and Pokémon.
It's been a while since [I posted about it](https://oleherman.com/gamedev/dayknight30_week4/).

## GUI

A lot of improvements were made to the GUI version of the game.
Following what is happening in battle is a lot more intuitive, as you have to click through the battle events one by one.
Sprites and animated health and mana bars were also added.

### Old Combat GUI

![Old GUI animated gif - Text only](/mrpg/gui_1.gif)

### New Combat GUI

![New GUI animated gif - Sprites, health bars, etc.](/mrpg/gui_2.gif)

## Combat system

I rewrote a lot of the combat system to use game events to a much larger extent.
These game events can be things like damage dealt, effect applied, creature killed, etc.
A key aspect of the event system is that they can be generated and then resolved (applied) in 2 separate steps.
This gives a lot of flexibility in ordering, as well as how to present them in the GUI.
The main advantages are:

- GUI user experience is a lot better now, since events wait for the user to click (enter)
- General code quality and maintainability is better
  - Some edge case bugs in combat were fixed
  - It's significantly easier to write automated tests for the new combat system
  - Adding new features is easier

Internally, these events are generated using python generators.
To enforce correct ordering in combat, the code assumes that events are resolved before the next one is requested.
This means that the generators hold some internal state, instead of having to keep variables for what has happened and what will happen in normal variables.
Adding features or [making changes to the combat system is intuitive](https://github.com/olehermanse/mrpg/commit/a026647f86862b3596ec6a6793ce2a1b422822e9), as [the generators look like sequential code](https://github.com/olehermanse/mrpg/blob/0c981f00c52cbadd6b15a2aaadc3ae14cae547f1/mrpg/core/battle.py#L92-#L99).

## Changelog

- [Added basic creature sprites](https://github.com/olehermanse/mrpg/commit/0c981f00c52cbadd6b15a2aaadc3ae14cae547f1)
- [Added skill hints in GUI version](https://github.com/olehermanse/mrpg/commit/3d0a5e381c539a116f311401d143d705c123873f)
- [Cleaned up GUI refresh code](https://github.com/olehermanse/mrpg/commit/0120b0205691adca007f6bdd8170ec15baa1d76a)
- [True strike now has priority, and is used before other moves](https://github.com/olehermanse/mrpg/commit/a026647f86862b3596ec6a6793ce2a1b422822e9)
- [Animated health and mana bars](https://github.com/olehermanse/mrpg/commit/7187e0ff267c9b77c3d56089acc9dbf1f620e2c0)
- [Removed CRLF line endings](https://github.com/olehermanse/mrpg/commit/d158dc7f1e0a692aa1576d2e727603d4abced0f1)
- [Removed old battle GUI and scaled new one](https://github.com/olehermanse/mrpg/commit/a2dd2382602da5bcebcd7b62994cba71b77f7126)
- [Whitespace](https://github.com/olehermanse/mrpg/commit/55bc1f7522b2f20b176dee3a27fcfc89ba827789)
- [Added new battle GUI](https://github.com/olehermanse/mrpg/commit/e26e4fb2be3de222bf16962b668679e581030182)
- [Fireball now has a custom burn message](https://github.com/olehermanse/mrpg/commit/444d6d3734260586b34608b552bb30940eade574)
- [Added variable in resolve() for convenience](https://github.com/olehermanse/mrpg/commit/e9ac4e1bbcc27bf658a4ceeb13520ab2348a94b1)
- [Added punctuation to all in-game messages](https://github.com/olehermanse/mrpg/commit/cca67d7236a1815799187d87a94bc5f192cdc926)
- [Stat modifiers are now applied immediately](https://github.com/olehermanse/mrpg/commit/a8538c9c752335f277b5692a76879c3f1417ad1f)
- [Moved some menu code to gui module](https://github.com/olehermanse/mrpg/commit/d4da63805e34457543d84c4f74e2e5acefffea83)
- [Renamed outputter to printer for clarity](https://github.com/olehermanse/mrpg/commit/4644804f889485fa824d4d435715285b47cec34c)
- [Renamed function update_text to refresh_gui](https://github.com/olehermanse/mrpg/commit/ed426c42d4ea5c4c5c92112aba2e408264cb1dad)
- [Made terminal version work again with new events](https://github.com/olehermanse/mrpg/commit/758083f3fa8c5eee12300e10f51501beacc26563)
- [The next enemy in an adventure now spawns after reading](https://github.com/olehermanse/mrpg/commit/329f355ac8cd10a310829c87c8beb339d7ee6018)
- [Refactored progress battle and adventure code](https://github.com/olehermanse/mrpg/commit/a1c0e62763def9179127c3fa9acb3e9c9a324d9e)
- [In-game events are now resolved as you click enter through messages](https://github.com/olehermanse/mrpg/commit/19bf2e9807fbd31571bef28d9555fc88561cf3c3)
- [Ensure that creatures pick a skill once per turn](https://github.com/olehermanse/mrpg/commit/ec143deb3dd780cbce456d86612c3a5114c61892)
- [Renamed Event apply() to resolve()](https://github.com/olehermanse/mrpg/commit/0cc7e683759cdc25a23051fa7f624f1ca86eb579)
- [Removed applier code, which is no longer used](https://github.com/olehermanse/mrpg/commit/394c28557ac57930408dc5f09b8b3e15efba0d9d)
- [Made the header and stats hidden when printing output](https://github.com/olehermanse/mrpg/commit/9c376302edb89000e0cf5decc8e0fae3f65dfdc2)
- [Replaced magic constants with named variables/functions](https://github.com/olehermanse/mrpg/commit/c77e97577d2bbd4e3e708995d9123722bb7439a0)
- [Made outputter index a local variable](https://github.com/olehermanse/mrpg/commit/959ac1fb696f11d2a6a9f758c777f51ede0a2acd)
- [Added --parallel option to yapf commands](https://github.com/olehermanse/mrpg/commit/f348e606453e3e151695204b7b265e372f4a613e)
- [Reduced size of scrolling text in GUI to 3 lines](https://github.com/olehermanse/mrpg/commit/02272ed71dec864fc3d0d6050c658146c073d4fa)
- [Moved GUI text outputter to bottom of screen](https://github.com/olehermanse/mrpg/commit/01848abeda955aa8ded7ee33ed3b328102ac54bc)
- [Menu is now hidden while printing output in GUI](https://github.com/olehermanse/mrpg/commit/c4ecea35411b5d392a011e582e862d5f83b092fd)
- [Added pre-commit hook to run yapf and tests](https://github.com/olehermanse/mrpg/commit/ec3259b70bdd2594e15a5009936ff3e084209d38)
- [Added make check/test command](https://github.com/olehermanse/mrpg/commit/3815fa5baf38b3f16ee90ff85490e648b0eaefc7)
- [Added tests for speed and effects](https://github.com/olehermanse/mrpg/commit/4dc273b7076f0f1cd58e66f16afcc45e59a45a5c)
- [Ran yapf to format python source code](https://github.com/olehermanse/mrpg/commit/8bd5d53be0a9f6d84c2e860c2e98611f778b8bbf)
- [Added terminal command to Makefile](https://github.com/olehermanse/mrpg/commit/2ef033456a441f1bca287414523c4a668bfa479a)
- [Removed extra newlines in battle output](https://github.com/olehermanse/mrpg/commit/21abd4008c2bc554e91e10646caac81154c7effb)
- [Added yapf commands to Makefile](https://github.com/olehermanse/mrpg/commit/14a41e29f1cdf30614bf6a6f840f2074991dc8f0)
- [Ran yapf to format all python source code](https://github.com/olehermanse/mrpg/commit/f12c8710ce82a5d56afb7aebfe4bcdaa576e259a)
- [Added battle test](https://github.com/olehermanse/mrpg/commit/3bd7e6ea7a02c91b15bc2d494e8bd762c42abb00)
- [Cleaned up battle turns and event generators, fixing effects](https://github.com/olehermanse/mrpg/commit/77fb0abc58d50ab312c1d3f208e8808dc7a72a78)
- [Added combined events](https://github.com/olehermanse/mrpg/commit/f7bbdcccb92750672767302a698a7c7d7ce4188a)
- [Removed internal output pause events](https://github.com/olehermanse/mrpg/commit/40c04cdfbc4527c1d5dec7d61e14bd50d819cbd7)
- [Simplified window resizing](https://github.com/olehermanse/mrpg/commit/0cb78f6247cd10bb95770a948a896abbae5a276d)
- [Made default resolution smaller](https://github.com/olehermanse/mrpg/commit/bfdbfa2a7a50921a839a4c51c2ecf43d84b16ea6)
- [Made fullscreen work on OS X](https://github.com/olehermanse/mrpg/commit/7d0e363dea3b98c9ded379389ea0016ebd654fac)
- [Stopped using fixed aspect ratio](https://github.com/olehermanse/mrpg/commit/b68d4cce22b9c96ca22aea7ba6f9f6e0a9fea011)
- [Stopped using default window resize](https://github.com/olehermanse/mrpg/commit/551ef5f9aee5220acc5658e48698975e5507ae6d)
- [Fixed window resizing](https://github.com/olehermanse/mrpg/commit/6459f729853b51ca75e6d79671fdde74b92fddb0)
- [Cleaned up State and text display](https://github.com/olehermanse/mrpg/commit/fe64cb36a32dff7724f681953b792a019d5c759f)
- [Removed Unneccessary Output class](https://github.com/olehermanse/mrpg/commit/4322ea3278000b1583a2f0ad5944430245fc7402)
- [Fixed window resizing](https://github.com/olehermanse/mrpg/commit/ce32ce09f797759d3ace475fb4b2de4d899383ba)
- [Fixed resolution problems on mac](https://github.com/olehermanse/mrpg/commit/7060b304daab41a3c525f4856fce16d3eab7937a)

[Generated using `git log`](/dev/markdown_git_changelogs).
