#!/bin/bash
# Build klip v5 gta6-clipper-01 — 10.5 detik, 1080x1920, dari Trailer 1 GTA VI.
# Konsep: komedi trend-core "Welcome to Florida" (crotch-grab apology ->
# truck yeller -> spa lumpur -> nenek -> beat rilis -> pitch).
# 100% Trailer 1 = NOL tumpang tindih dengan segmen v1-v4 (Trailer 2).
# Semua batas segmen terverifikasi FRAME TUNGGAL (bukan hanya sheet —
# grid sheet fps terbukti bergeser +0.375 s/d +2.0 dtk; CONCEPT-v5.md).
# Segmen (waktu absolut di gta6-trailer1.mp4, 30fps):
#   S1 51.125-52.125 crotch-grab apology, taksi kuning (hook)
#   S2 52.25-53.75   pria bertelanjang dada berteriak dari truk hijau
#   S3 56.0-57.75    pesta lumpur, wanita berlumpur menyeringai
#   S4 58.0-59.25    nenek berdaster pink, neighborhood watch (punchline + zoom punch)
#   S5 25.0-27.0     convertible menari, skyline malam (beat rilis)
#   S6 11.0-13.0     aerial pantai (latar pitch, audio duck 0.25)
#   S7 36.0-37.0     aerial jembatan (latar pitch, audio duck 0.25)
# Total: 1.0 + 1.5 + 1.75 + 1.25 + 2.0 + 2.0 + 1.0 = 10.5 dtk.
# Teks (semua y=0.16, DejaVu Bold 72, kecuali pitch 58 + box):
#   "WELCOME TO FLORIDA." / "JUST ANOTHER TUESDAY." /
#   "THIS IS A SPA DAY." / "DON'T MESS WITH / GRANDMA." (2 baris) /
#   "AND IT'S OUT NOW." / pitch 3 baris.
# Voice: pitch-voice-v5.mp3 (gTTS, dibuat baru di sesi v5, raw
# 4.20 dtk), atempo 1.45 (~2.90 dtk, pas di jendela pitch 3.0 dtk).
set -euo pipefail
cd "$(dirname "$0")"
F=../footage/gta6-trailer1.mp4
FONT=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf

# Teks per beat (textfile = tanpa masalah escaping apostrof)
printf 'WELCOME TO FLORIDA.' > s1-lines-v5.txt
printf 'JUST ANOTHER TUESDAY.' > s2-lines-v5.txt
printf 'THIS IS A SPA DAY.' > s3-lines-v5.txt
printf "DON'T MESS WITH\nGRANDMA." > s4-lines-v5.txt
printf "AND IT'S OUT NOW." > s5-lines-v5.txt
printf 'MADE WITH AI\nEARN MONEY MAKING\nCLIPS ON MAKE.FUN' > pitch-lines-v5.txt

ffmpeg -hide_banner -loglevel error -y -i "$F" -i pitch-voice-v5.mp3 -filter_complex "\
[0:v]trim=start=51.125:end=52.125,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v1];\
[0:v]trim=start=52.25:end=53.75,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v2];\
[0:v]trim=start=56.0:end=57.75,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v3];\
[0:v]trim=start=58.0:end=59.25,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1,zoompan=z='1+0.08*on/36':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=1:s=1080x1920:fps=30,setsar=1[v4];\
[0:v]trim=start=25.0:end=27.0,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v5];\
[0:v]trim=start=11.0:end=13.0,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v6];\
[0:v]trim=start=36.0:end=37.0,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v7];\
[v1][v2][v3][v4][v5][v6][v7]concat=n=7:v=1:a=0,format=yuv420p[vcat];\
[vcat]drawtext=fontfile=$FONT:textfile=s1-lines-v5.txt:fontsize=72:fontcolor=white:borderw=4:bordercolor=black:x=(w-text_w)/2:y=h*0.16:enable='between(t,0,1.0)'[t1];\
[t1]drawtext=fontfile=$FONT:textfile=s2-lines-v5.txt:fontsize=72:fontcolor=white:borderw=4:bordercolor=black:x=(w-text_w)/2:y=h*0.16:enable='between(t,1.0,2.5)'[t2];\
[t2]drawtext=fontfile=$FONT:textfile=s3-lines-v5.txt:fontsize=72:fontcolor=white:borderw=4:bordercolor=black:x=(w-text_w)/2:y=h*0.16:enable='between(t,2.5,4.25)'[t3];\
[t3]drawtext=fontfile=$FONT:textfile=s4-lines-v5.txt:fontsize=72:fontcolor=white:borderw=4:bordercolor=black:line_spacing=12:x=(w-text_w)/2:y=h*0.16:enable='between(t,4.25,5.5)'[t4];\
[t4]drawtext=fontfile=$FONT:textfile=s5-lines-v5.txt:fontsize=72:fontcolor=white:borderw=4:bordercolor=black:x=(w-text_w)/2:y=h*0.16:enable='between(t,5.5,7.5)'[t5];\
[t5]drawtext=fontfile=$FONT:textfile=pitch-lines-v5.txt:fontsize=58:fontcolor=white:borderw=4:bordercolor=black:box=1:boxcolor=black@0.45:boxborderw=24:line_spacing=16:x=(w-text_w)/2:y=h*0.38:enable='between(t,7.5,10.5)'[vout];\
[0:a]atrim=start=51.125:end=52.125,asetpts=PTS-STARTPTS[a1];\
[0:a]atrim=start=52.25:end=53.75,asetpts=PTS-STARTPTS[a2];\
[0:a]atrim=start=56.0:end=57.75,asetpts=PTS-STARTPTS[a3];\
[0:a]atrim=start=58.0:end=59.25,asetpts=PTS-STARTPTS[a4];\
[0:a]atrim=start=25.0:end=27.0,asetpts=PTS-STARTPTS[a5];\
[0:a]atrim=start=11.0:end=13.0,asetpts=PTS-STARTPTS,volume=0.25[a6];\
[0:a]atrim=start=36.0:end=37.0,asetpts=PTS-STARTPTS,volume=0.25[a7];\
[a1][a2][a3][a4][a5][a6][a7]concat=n=7:v=0:a=1[acat];\
[1:a]atempo=1.45,volume=1.5,adelay=7500:all=1[voice];\
[acat][voice]amix=inputs=2:duration=first:dropout_transition=0[aout]" \
-map "[vout]" -map "[aout]" -c:v libx264 -preset medium -crf 20 -pix_fmt yuv420p \
-movflags +faststart -c:a aac -b:a 192k -r 30 -t 10.5 gta6-clip-v5.mp4

ffprobe -v error -show_entries format=duration,size -show_entries stream=codec_name,width,height,r_frame_rate -of default=noprint_wrappers=1 gta6-clip-v5.mp4
echo "BUILD OK"
