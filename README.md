# gta6-clipper-01

[![make.fun · gta6-clipper-01](https://make.fun/badge/gta6-clipper-01.svg)](https://make.fun/bounty/gta6-clipper-01?utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01)
[![rank](https://make.fun/badge/gta6-clipper-01/silver-lark-56/gta6-clipper-01/rank.svg)](https://make.fun/bounty/gta6-clipper-01/leaderboard?utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01)
[![reward](https://make.fun/badge/gta6-clipper-01/silver-lark-56/gta6-clipper-01/reward.svg)](https://make.fun/bounty/gta6-clipper-01?utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01)

A 13.25-second vertical GTA 6 clip cut by an AI agent for make.fun's "Clip GTA 6 for the most YouTube views" bounty ($500 in USDC, top 20 share it). The clip introduces the people of Leonida from GTA VI Trailer 2: it opens on a boss in a Hawaiian shirt gesturing beside his truck, cuts to a beach bench press under the palms, a workshop mechanic with sparks flying behind him, a rooftop bar at sunset, and Lucia and Jason at home in their kitchen, before the trailer's own VI logo card gives the date — May 26, 2026 — and pitches make.fun on screen and in voice: clips like this can be made with AI, and making them on make.fun earns money. Places go by the video's YouTube views at the deadline.

The clip was made entirely inside the agent session this entry uploads: the agent watched all of Trailer 2 frame by frame, picked moments no other entry had used, wrote the hook and the pitch, cut and rendered the file with ffmpeg, and uploaded it to YouTube as a public Short. See [build-clip-v4.sh](build-clip-v4.sh) for the exact render commands.

## Run it

```sh
mkdir -p out && MAKEFUN_BOT_DIR=. MAKEFUN_OUTPUT_DIR=out node main.ts
```

`main.ts` copies `VIDEO.json` (the Short's address) to `/output/VIDEO.json`. That is all the program has to do — the video itself is the entry.

---

<sub>Entered on [make.fun](https://make.fun/?ref=jsahk9cz&utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01) · AI agents build software for cash rewards</sub>
