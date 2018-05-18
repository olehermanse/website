---
title: "The DayKnight 30-day project - Week 3"
description: "Skills"
date: 2018-05-18T23:31:36+02:00
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

[DK30](../dayknight30) has officially ended.
As I've been busy with work, progress has been slow.
I've done some changes to pave the way for better GUI, but nothing to show there.
This post is mainly about the new skills.

## Skills

I've added 8 active skills, I think this is enough for the demo, and shows the potential of the combat system.
For simplicity, all the explanations below assume that you have equal stats as your opponent.
Skill damage scales with your stats (Strength, Dexterity or Intelligence) and mitigation reduces damage based on enemy stats.

### Attack

Attack is the most basic skill, it deals damage based on `str` (Strength) stat, and doesn't cost mana.
All other skills are balanced by comparing them to Attack (this doesn't mean that the game is well balanced, yet).
For example, this means that any skill dealing more damage than Attack should have some drawback.

### Heal

Heal restores health and has a mana cost.
Restores roughly twice as many hit points as Attack deals (after mitigation).

### Fireball

This skill has a mana cost, deals damage and applies a DoT (damage over time) effect.
The initial damage is roughly the same as Attack, but the Burn effect makes it worthwhile to spend the mana.

### Lightning

Similar to Fireball, but applies Shock instead of Burn.
Shock reduses enemy dexterity, which makes them slower, among other things.

### Life Drain

Costs mana, deals damage and restores health.
Deals less damage than Attack, but might need some adjustment as it seems weak currently.

### Blood Pact

Fully restores user health without a mana cost.
Adds a significant bleed effect.
If the user is already bleeding, the user dies instead.

### Slash

Deals less damage than Attack, but also applies a Bleed.
Bleed deals damage over time and is especially effective against Blood Pact users.

### True Strike

Similar to Attack, but scales with user's dexterity, and ignores mitigation.
Stronger against enemies which have better stats/mitigation.

## Next week

Even though the event is over, I will keep working on the game, and post a final (fake) "week 4" update in about a week.
The goal is still to finish a playable and fun demo to let others try out.
Most important features to focus on are progression (unlocking and equipping skills), UI, and content(enemies).

## Changelog

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
* [Added mana costs](https://github.com/olehermanse/mrpg/commit/574a5560864b3fecb5f2514d104442f27319246f)
