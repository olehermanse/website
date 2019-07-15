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
  - "rpg"
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

* [Burn now lasts for 3 turns](https://github.com/olehermanse/mrpg/commit/dc006827027582458c1ecfa656e1fd04f129a4dc)
* [Cleaned up skill and effect code to be more clear](https://github.com/olehermanse/mrpg/commit/aaae4a66d81d6596491c575d627089babf6977a3)
* [Effects are now removed after combat](https://github.com/olehermanse/mrpg/commit/349c2a6a858265c2dafc06d3eccb902ebd5047e1)
* [Adding effects are now appropriately delayed during speed ties](https://github.com/olehermanse/mrpg/commit/18385a06f4c904ba4928d570ccb653db4191fcca)
* [Newline after same time message in combat](https://github.com/olehermanse/mrpg/commit/26b02b5ef75c4c1f1897947e732ff53a89603f90)
* [Remove duplicate effects](https://github.com/olehermanse/mrpg/commit/7be45467ac37eb4f78ac367555be2a3cb3f70e0b)
* [GUI: Added animation (typing) to combat text](https://github.com/olehermanse/mrpg/commit/83e28f1af10d36bd1e09418d2cf41eab2e3de421)
* [Renamed AnimatedLabel to MenuLabel for clarity](https://github.com/olehermanse/mrpg/commit/48fe98321924194d5b9246dc3d035470c02b8944)
* [Added requirements.txt and better instructions](https://github.com/olehermanse/mrpg/commit/667ee594bd539cdcedb8f60a8971f8b2939bd224)
* [GUI: Always capitalize first letters in menus](https://github.com/olehermanse/mrpg/commit/66e20be9051c33aae0370e29d49a0ece6600e8ce)
* [GUI: Mapped WASD to arrow keys](https://github.com/olehermanse/mrpg/commit/febcc9739e9176916cbd0a1ca2b87bb7a76c5275)
* [New skill: Blood pact](https://github.com/olehermanse/mrpg/commit/676eb420e14e625d817a92c642d706d933914ff5)
* [Added damage mitigation](https://github.com/olehermanse/mrpg/commit/8d62e53cb8366ca2f311299268d4c656f0d9ac36)
* [Reduce font sizes slightly](https://github.com/olehermanse/mrpg/commit/61490925b37a2e26980e3b72ac9e2f3491000f2f)
* [GUI: Clean up Label code](https://github.com/olehermanse/mrpg/commit/b00212c705fbd3f4ea07d0cdf7196c12684ed079)
* [Skill/Effect code cleanup](https://github.com/olehermanse/mrpg/commit/a8706add9ff5847c000c7e6689d13c8417d71709)
* [Added effects - Fireball now applies burn](https://github.com/olehermanse/mrpg/commit/d2b30f8584710dff2dda1da9a5597cdbf10f14f5)
* [Cleaned up some skill/battle logging](https://github.com/olehermanse/mrpg/commit/cc88ebfcbc38d1f8e2b7bbf5f00af55c55d656bb)
* [Whitespace](https://github.com/olehermanse/mrpg/commit/7d014d235e519604a6387d8a374ba41958be5039)
* [Added module for effects](https://github.com/olehermanse/mrpg/commit/e3e9f5fc4587a23d96a0f2550e144f32e731847a)
* [Restructured skills to be more clear and flexible](https://github.com/olehermanse/mrpg/commit/11a7ac29946f72ad46e4142c04f0013bc708b5b1)
* [Added functions for printable and internal versions of names](https://github.com/olehermanse/mrpg/commit/af6ee867d752f1cce59e8fdc9a2d61d42f033a1e)
* [Made Skill objects determine hint internally](https://github.com/olehermanse/mrpg/commit/6d41a95ad6987d78da1e0bde5814100ba3b59fef)
* [Moved skill collections code to separate module](https://github.com/olehermanse/mrpg/commit/ff10af8e953ad7ab26beb8f69b220d79b8fd1a3f)
* [GUI: Fixed a bug causing negative menu index](https://github.com/olehermanse/mrpg/commit/511143b536a0769f2be7d16a0a505b6786a632a2)
* [Added installer.cfg for generating windows installer](https://github.com/olehermanse/mrpg/commit/8484bcfba8577890602ae0521dedf20742f887f4)
* [Added build folder to .gitignore](https://github.com/olehermanse/mrpg/commit/7ef8cf382e51efa45c9cdae10f0c5868139d0cf2)
* [GUI is now the default version(--terminal for shell only)](https://github.com/olehermanse/mrpg/commit/79a1196c22ea3969a9f72786843d633a4aff334e)

See [github.com/olehermanse/mrpg](https://github.com/olehermanse/mrpg) for more details.

#### Generating markdown changelogs using git

The changelog was generated using:
```bash
$ git log --pretty=format:"* [%s](https://github.com/olehermanse/mrpg/commit/%H)" 733bf2f..HEAD
```
(This prints all commits after `733bf2f` - which was the end of the previous changelog)

I thought this might be useful to leave here for future reference.
