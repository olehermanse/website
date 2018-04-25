---
title: "The DayKnight 30-day project - Week 2"
description: "Buffs and debuffs"
date: 2018-04-24T16:49:18+02:00
categories:
  - "Development"
  - "Game Development"
tags:
  - "gamedev"
  - "mrpg"
  - "dk30"
draft: false
---

Following [the initial plan](../dayknight30), I worked on effects this week.
_Effects_ (buffs/debuffs) can have positive or negative consequences, like stat boosts, damage over time and so on.
Skills can apply effects, and effects can also apply other effects.

I made a few improvements in other places as well.
A gif should say [way more than a thousand words](https://www.reddit.com/r/shittyaskscience/comments/2h86xo/);

![GIF of new features](/mrpg/gui_1.gif)

Notice that text is more animated now?
I've also made changes to existing skills and started adding new ones, I'll talk more about this next week.

### Ordering of combat steps

One of my goals for this game is to have deterministic, turn based, combat.
This means that there is no random number generator involved.
There are no critical hits, random misses, or random ordering.

Who goes first is determined by the dexterity stat, however if they are equal, both players act at the same time.
This is especially challenging to implement, combat (skills and effects) has to be broken down into multiple steps.
The outcome should be completely deterministic regardless of what functions are technically called first.
Current steps for case when both players act at the same time:

1. Calculate outcome of skills for both players - amount of damage, healing etc. to apply
2. Apply outcomes of skills - Use data from step 1 to deal damage, heal, etc.
3. Add any queued effects to players (Skills can queue effects to be added)
4. Remove any expired/duplicate effects
5. Outcomes of effects are calculated
6. Stats are reset to base before reapplying effects
7. Effects are applied (damage, healing, etc.)
8. Add any queued effects to players (effects can add other effects)
9. Remove any expired/duplicate effects

Luckily, the logic for calculating and applying effects and skills is very similar.
They are even [using the same base class internally](https://github.com/olehermanse/mrpg/blob/a8706add9ff5847c000c7e6689d13c8417d71709/mrpg/core/applier.py).

The important takeaway here is that outcomes of skills and effects are calculated for both players, before being applied.
This way, skills can be based on remaining health, mana, etc. and outcomes will still be consistent.
An interesting consequence of this system is that no skills or effects can _set_ a stat to a value, when applying they can only add or subtract as these are commutative operations.

### Next week

As stated in the [intro post](../dayknight30) I will be working on progression next week.
The most important features would be to implement skill unlocks, and more interesting content after that.

### Changelog

Just like [last week](../dayknight30_week1) here is a changelog generated from my git history:

* [Burn now lasts for 3 turns](https://github.com/olehermanse/mrpg/commit/2f9cf7bd563662f60ccca82c687fbb3f585278dc)
* [Cleaned up skill and effect code to be more clear](https://github.com/olehermanse/mrpg/commit/f20e9334d804d36bf08ee170ffcb27bafd302e77)
* [Effects are now removed after combat](https://github.com/olehermanse/mrpg/commit/9ce6e79d196b1a303098fd379f044c1ebea5ebca)
* [Adding effects are now appropriately delayed during speed ties](https://github.com/olehermanse/mrpg/commit/e16c2d0a402751c2129628accff8f98d2211562e)
* [Newline after same time message in combat](https://github.com/olehermanse/mrpg/commit/f173578575ec9a8b3c25ce09daada1aece8069ae)
* [Remove duplicate effects](https://github.com/olehermanse/mrpg/commit/6cc7308fdac594d6421a511ca13c2938bb5a3181)
* [GUI: Added animation (typing) to combat text](https://github.com/olehermanse/mrpg/commit/1ccdabc49ec0cddce6b9a8cd43f738bc4cc26d6c)
* [Renamed AnimatedLabel to MenuLabel for clarity](https://github.com/olehermanse/mrpg/commit/b112b1c9cbf47567f6410be543286e283b01cdb8)
* [Added requirements.txt and better instructions](https://github.com/olehermanse/mrpg/commit/73d4d44aec5725e6627a3f582b2e2334c7c7fc33)
* [GUI: Always capitalize first letters in menus](https://github.com/olehermanse/mrpg/commit/f33705b517848ff7d407189c99752eb8925babd2)
* [GUI: Mapped WASD to arrow keys](https://github.com/olehermanse/mrpg/commit/db9d14dc288d07e7a488527348c061dbcd60789e)
* [New skill: Blood pact](https://github.com/olehermanse/mrpg/commit/5ef1c74d3f1cc74296166b87c64b6f640f7c4fea)
* [Added damage mitigation](https://github.com/olehermanse/mrpg/commit/a8a7827fab251481d7cd802f217bd64b1cf0a777)
* [Reduce font sizes slightly](https://github.com/olehermanse/mrpg/commit/92174b197aed21b392f7cf94c78ece20028e6863)
* [GUI: Clean up Label code](https://github.com/olehermanse/mrpg/commit/8d2b9a7b5d059d1ed78a5ebb787ef9288379bb18)
* [Skill/Effect code cleanup](https://github.com/olehermanse/mrpg/commit/f763338dd0ab0a40e74384b03ad6bd2490b96a07)
* [Added effects - Fireball now applies burn](https://github.com/olehermanse/mrpg/commit/c005cde66da49d84270d4b7de45d2ae6f7aa2b9c)
* [Cleaned up some skill/battle logging](https://github.com/olehermanse/mrpg/commit/272de4c7fb0939ea5ed378dac3f66904236aaf64)
* [Whitespace](https://github.com/olehermanse/mrpg/commit/e0388400435c94b99b464c8ddcdcc7b6271fa5c6)
* [Added module for effects](https://github.com/olehermanse/mrpg/commit/a3d1975a132c45da4029228581d11c9bb4e2460f)
* [Restructured skills to be more clear and flexible](https://github.com/olehermanse/mrpg/commit/53eb69a6fd4bc741b1115aefa2c8fcf6b3d0ddec)
* [Added functions for printable and internal versions of names](https://github.com/olehermanse/mrpg/commit/ed42b1f40f98ece0b93731808201886f509c96e8)
* [Made Skill objects determine hint internally](https://github.com/olehermanse/mrpg/commit/5b4d213d8c0f27819830ddafa66fd7bb38f0cbf8)
* [Moved skill collections code to separate module](https://github.com/olehermanse/mrpg/commit/546f5bf61611c33d86295becff6a382504cfbad9)
* [GUI: Fixed a bug causing negative menu index](https://github.com/olehermanse/mrpg/commit/d41277e65a86aebb1141fec36f65973ab408493d)
* [Added installer.cfg for generating windows installer](https://github.com/olehermanse/mrpg/commit/f3b4db2bb63e8a015a9c85fe1676962389e39d62)
* [Added build folder to .gitignore](https://github.com/olehermanse/mrpg/commit/d6b6c3c3b3e5f4bbdbb3307c1148b5588e75e6b5)
* [GUI is now the default version(--terminal for shell only)](https://github.com/olehermanse/mrpg/commit/57a2cb7d1c731fe0212c9dbcb1532ee3ca7b81dd)

See [github.com/olehermanse/mrpg](https://github.com/olehermanse/mrpg) for more details.

#### Generating markdown changelogs using git

The changelog was generated using:
```bash
$ git log --pretty=format:"* [%s](https://github.com/olehermanse/mrpg/commit/%T)" 733bf2f..HEAD
```
(This prints all commits after `733bf2f` - which was the end of the previous changelog)

I thought this might be useful to leave here for future reference.
