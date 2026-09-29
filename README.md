# WARDOGS Fire Caller

A fan-made mortar and artillery helper for WARDOGS that **reads the firing solution out loud**, so you can keep your eyes on the game.

**Open it:** https://brawnybravo.github.io/wardogs-fire-caller/

## What it does

- Place your gun once. Then click the map to drop a **ping**, and click a ping (on the map or in the list) to fire on it. The page shows and speaks the direction and elevation, for example "Ping 2. Turn to 54. Set 700."
- The ping list shows the numbers for every ping at a glance, so you can pick the closest or the one in range.
- Supports the L81 mortar and the SPH-2 on Bakurani, Ozeti and Zestafona.
- Warns when a target is too close or out of range.
- Saves targets you use often (stored only in your browser).
- Keeps a phone screen awake while the voice is on.

## Squad rooms

Press **Start a squad room** and send the invite link to your squad. When anyone in the room drops a ping, it appears on everyone's map and the page announces it ("Ping 3 from Spotter, 420 meters"). Each gunner picks which ping to fire on and hears their own numbers, because each person places their own gun. Pings fade after five minutes, and **Clear mine** removes yours for everyone.

Rooms run over a free public message broker (HiveMQ's public broker). There is no account and nothing is stored, but anyone who knows a room code can see the map points sent in that room, so don't put anything private in your call sign.

## Playing fair

This page never connects to the game, reads its memory or screen, or presses keys. It only works with what you and your squad click. That keeps it on the same footing as the other community map calculators.

## Limits

- No correction for height difference. Fire a ranging round when the target is well above or below you.
- Accuracy depends on the community firing tables below. A game update that changes the weapons needs new tables.

## Credits

Map tiles and firing tables come from [djzet/wardogs-calc](https://github.com/djzet/wardogs-calc) (MIT licence, see `THIRD_PARTY_NOTICES.md`). Map tiles load directly from that project's site and are not copied here. WARDOGS and its maps belong to their owners; this project is unofficial and not affiliated with them.

## Licence

MIT, see `LICENSE`.
