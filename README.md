# WARDOGS Fire Caller

A fan-made mortar and artillery helper for WARDOGS that **reads the firing solution out loud**, so you can keep your eyes on the game.

**Open it:** https://brawnybravo.github.io/wardogs-fire-caller/

## What it does

- Pick your **role**: Spotter, Mortar (L81), SPH-2 or Sniper.
- Place your gun (or yourself) once. Then click the map to drop a **ping**, and click a ping (on the map or in the list) to get its numbers. The page shows and speaks them:
  - Mortar and SPH-2: direction and elevation, for example "Ping 2. Turn to 54. Set 700."
  - Sniper: direction, range and the scope zero to dial (zero moves in 100 m steps), with a hold high or low when the target sits between steps, for example "Turn to 41. 570 meters. Zero 600, hold a touch low." Choose your scope's longest zero so targets past it tell you to hold high.
  - Spotter: bearing and range from you, to call out to the squad.
- The ping list shows the numbers for every ping at a glance, so you can pick the closest or the one in range.
- Works on Bakurani, Ozeti and Zestafona.
- Warns when a target is too close or out of range.
- Shows how far the direction could be off. At mortar distances a few meters of misplaced click turns into several degrees, so when the page says the direction could be off, zoom in and place your gun and the ping again.
- When you reopen the page it shows your gun from last time and asks you to confirm it, so a position from an earlier match is not used by mistake.
- Saves targets you use often (stored only in your browser).
- Keeps a phone screen awake while the voice is on.

## Squad rooms

Press **Start a squad room** and send the invite link to your squad. When anyone in the room drops a ping, it appears on everyone's map and the page announces it ("Ping 3 from Spotter, 420 meters"). Each gunner picks which ping to fire on and hears their own numbers, because each person places their own gun. Pings fade after five minutes, and **Clear mine** removes yours for everyone.

Rooms run over a free public message broker (HiveMQ's public broker). There is no account and nothing is stored, but anyone who knows a room code can see the map points sent in that room, so don't put anything private in your call sign.

## Playing fair

This page never connects to the game, reads its memory or screen, or presses keys. It only works with what you and your squad click. That keeps it on the same footing as the other community map calculators.

## Limits

- No correction for height difference. Fire a ranging round when the target is well above or below you.
- Direction is only as good as where you click. The page cannot know exactly where your gun stands; zoom in when placing it.
- Sniper holds are a rough guide, not a ballistic table.
- Accuracy depends on the community firing tables below. A game update that changes the weapons needs new tables.

## Credits

Map tiles and firing tables come from [djzet/wardogs-calc](https://github.com/djzet/wardogs-calc) (MIT licence, see `THIRD_PARTY_NOTICES.md`). Map tiles load directly from that project's site and are not copied here. WARDOGS and its maps belong to their owners; this project is unofficial and not affiliated with them.

## Licence

MIT, see `LICENSE`.
