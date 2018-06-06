---
title: "The DayKnight 30-day project - Week 4 / Final update"
date: 2018-06-06T22:06:08+02:00
draft: false
categories:
  - "Development"
  - "Game Development"
tags:
  - "gamedev"
  - "mrpg"
  - "dk30"
  - "rpg"
draft: false
---

[DK30](../dayknight30) has been over for quite some time.
I wanted to post a final update about my progress, for my "fake week 4".
Work and other things have kept me busy, so I'm not done with everything I wanted to do, but still enjoy working on the game.

## Enemies

I've added a few enemies, with skills and the basics needed for AI.
Currently the AI is completely random.

* **Ogre** - Only knows how to attack
* **Slime** - Uses a few basic physical moves, like *Attack* and *Slash*
* **Wizard** - Can use both healing and damaging magic skills.
* **Cultist** - Uses *evil* magic, like *Blood pact* and *Life drain*

### Sprites

Enemies and players will have 16x16 sprites in combat.
Some basic sprites are done, here is a sneak peak:

![Player](/mrpg/warrior.png)
![Ogre](/mrpg/ogre.png)
![Cultist](/mrpg/cultist.png)

## The future

I still want to finish a prototype / demo to share and let others try.
Realistically, this will still take a few weeks, need to finish up a few things:

* Unlocking skills after leveling
* Health and mana bars in GUI
* Rendering enemy and player sprites during combat

I will keep posting updates about the game, although not under the DK30 label.

## Changelog

* [Whitespace](https://github.com/olehermanse/mrpg/commit/09facd307b31afe17af9b11f4dfa46e1209df836)
* [Dexterity is now correctly reset after Shock fades](https://github.com/olehermanse/mrpg/commit/74fcd95d81390d3956ed29e08705ca085f39d654)
* [Added basic random enemy AI](https://github.com/olehermanse/mrpg/commit/4282c02d8291037f492751a09973396cc83d5b42)
* [Added 3 new enemies: Cultist, Wizard, and Slime](https://github.com/olehermanse/mrpg/commit/e7994a576a96476848131e3004b87e93e7e65093)
* [Small style change for mana costs](https://github.com/olehermanse/mrpg/commit/187780fee8a2facf76140b1a900a734b951a166f)
* [Added some basic (unfinished) sprites](https://github.com/olehermanse/mrpg/commit/54b76bd84221bbba127b70808e64311b80aa745d)
* [Renamed platform subpackage to system](https://github.com/olehermanse/mrpg/commit/2f138ba8c770ca22e5107abffb168feec134ca9f)
* [Added binary git attribute to png files](https://github.com/olehermanse/mrpg/commit/bc7c4a9b7f0bfbda14fc7d97396849004421c617)
* [Restructured battle/skill systems to use Event objects](https://github.com/olehermanse/mrpg/commit/a67d914eb3d18c45ce515900fa3397f47a825e96)
* [Made combat log scroll](https://github.com/olehermanse/mrpg/commit/d2967be69b680eeeb455b09b85078930437dfe75)
* [True strike damage is now correctly printed](https://github.com/olehermanse/mrpg/commit/524682aacefdfa3ff0aa5714dd800569fc58a294)
* [New skill: Slash](https://github.com/olehermanse/mrpg/commit/6c47d9fb08bda50e2c5bf18aaa73bfe60883c9d5)
* [Bleed damage is now based on base health](https://github.com/olehermanse/mrpg/commit/7e3ed53e886143dad2c08ef5ed2b16ba6dee236a)
* [Increased burn duration and reduced damage per tick](https://github.com/olehermanse/mrpg/commit/38dd05a5d2462f5fcb8e1085e85bd1341c0bd495)
* [New skill: True strike](https://github.com/olehermanse/mrpg/commit/2822514ec6f45a205c3bc738be4610d2ee370f7e)
* [New skill: Lightning](https://github.com/olehermanse/mrpg/commit/f9bb1b8b7c4eb79f48cf2fbb4138c436a3b83f6b)
* [Mana and stats are now correctly reset after adventure](https://github.com/olehermanse/mrpg/commit/febb9d88bd6c2fdf462e34951ff61ec39b9340ec)
* [Blood pact now kills if already bleeding](https://github.com/olehermanse/mrpg/commit/0d055530473eb02a81d9e0e0a2cc4bb6fe8c8612)
