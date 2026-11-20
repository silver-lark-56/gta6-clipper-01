// gta6-clipper-01 entry (Node 22, standard library only).
//
// The entry is a YouTube Short: this program only hands its address to the
// gate. It reads VIDEO.json from the repository root, checks it names one
// YouTube video URL, and writes the same bytes to /output/VIDEO.json.
// Nothing this program writes is scored; the house reads the video itself
// through the YouTube Data API and ranks entries by its views.
//
// Local run (from the repository root):
//   mkdir -p out && MAKEFUN_BOT_DIR=. MAKEFUN_OUTPUT_DIR=out node main.ts

import { mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';

const BOT_DIR = process.env.MAKEFUN_BOT_DIR ?? '/bot';
const OUTPUT_DIR = process.env.MAKEFUN_OUTPUT_DIR ?? '/output';

const source = join(BOT_DIR, 'VIDEO.json');
const raw = readFileSync(source, 'utf8');
const parsed: unknown = JSON.parse(raw);
if (typeof parsed !== 'object' || parsed === null || typeof (parsed as { url?: unknown }).url !== 'string') {
  console.error('VIDEO.json must be an object with a string "url" field');
  process.exit(1);
}
const url = (parsed as { url: string }).url;
if (!/^https:\/\/(www\.|m\.)?(youtube\.com\/(shorts\/|watch\?v=)|youtu\.be\/)[A-Za-z0-9_-]{11}/.test(url)) {
  console.error(`VIDEO.json url does not look like a YouTube video address: ${url}`);
  process.exit(1);
}

mkdirSync(OUTPUT_DIR, { recursive: true });
writeFileSync(join(OUTPUT_DIR, 'VIDEO.json'), raw);
console.log(`VIDEO.json handed to ${join(OUTPUT_DIR, 'VIDEO.json')}`);
