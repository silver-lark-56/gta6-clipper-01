#!/bin/bash
# Build klip v4 gta6-clipper-01 — 13.25 detik, 1080x1920, dari Trailer 2 GTA VI.
# Konsep: pemeran pendukung Leonida (bos -> gym pantai -> montir ->
# bar rooftop -> dapur Lucia+Jason -> logo VI -> pitch).
# NOL tumpang tindih dengan segmen v1, v2, maupun v3. Semua momen
# terverifikasi di frame (CONCEPT-v4.md + footage/v4scan/).
# Segmen (waktu absolut di gta6-trailer2.mp4, 30fps):
#   S1 14.5-16.0    bos memberi isyarat di samping truk (hook wajah)
#   S2 38.5-40.5    bench press pantai (jendela bersih 38.25-41.25)
#   S3 150.75-152.5 montir bengkel, bunga api (jendela bersih 150.75-152.5)
#   S4 95.5-97.5    bar rooftop senja, gaun emas (jendela bersih 95.25-98.0)
#   S5 88.25-89.25  dapur: Lucia + Jason (jendela bersih 88.25-89.25)
#   S6 162.0-164.0  kartu logo VI + MAY 26, 2026 (asli trailer)
#   S7 90.25-92.0   interior bar (latar pitch, audio duck 0.25)
#   S8 92.25-93.5   bar berdansa (latar pitch, audio duck 0.25)
# Total: 1.5 + 2.0 + 1.75 + 2.0 + 1.0 + 2.0 + 1.75 + 1.25 = 13.25 dtk.
# Teks: "EVERYONE KNOWS / JASON & LUCIA." (hook, bawah y=0.74 —
# wajah di atas) + "BUT HAVE YOU MET / EVERYONE ELSE?" (S2, atas
# y=0.16) + pitch 3 baris (S7+S8, box gelap).
# Voice: pitch-voice-v4.mp3 (gTTS, dibuat baru di sesi v4, raw
# 4.20 dtk), atempo 1.45 (~2.90 dtk, pas di jendela pitch 3.0 dtk).
set -euo pipefail
cd "$(dirname "$0")"
F=../footage/gta6-trailer2.mp4
FONT=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf

# Teks hook (2 baris) + teks S2 (2 baris) + teks pitch (3 baris)
printf 'EVERYONE KNOWS\nJASON & LUCIA.' > hook-lines-v4.txt
printf 'BUT HAVE YOU MET\nEVERYONE ELSE?' > meet-lines-v4.txt
printf 'MADE WITH AI\nEARN MONEY MAKING\nCLIPS ON MAKE.FUN' > pitch-lines-v4.txt

ffmpeg -hide_banner -loglevel error -y -i "$F" -i pitch-voice-v4.mp3 -filter_complex "\
[0:v]trim=start=14.5:end=16.0,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v1];\
[0:v]trim=start=38.5:end=40.5,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v2];\
[0:v]trim=start=150.75:end=152.5,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v3];\
[0:v]trim=start=95.5:end=97.5,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v4];\
[0:v]trim=start=88.25:end=89.25,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v5];\
[0:v]trim=start=162.0:end=164.0,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v6];\
[0:v]trim=start=90.25:end=92.0,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v7];\
[0:v]trim=start=92.25:end=93.5,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v8];\
[v1][v2][v3][v4][v5][v6][v7][v8]concat=n=8:v=1:a=0,format=yuv420p[vcat];\
[vcat]drawtext=fontfile=$FONT:textfile=hook-lines-v4.txt:fontsize=72:fontcolor=white:borderw=4:bordercolor=black:line_spacing=12:x=(w-text_w)/2:y=h*0.74:enable='between(t,0,1.5)'[t1];\
[t1]drawtext=fontfile=$FONT:textfile=meet-lines-v4.txt:fontsize=72:fontcolor=white:borderw=4:bordercolor=black:line_spacing=12:x=(w-text_w)/2:y=h*0.16:enable='between(t,1.5,3.5)'[t2];\
[t2]drawtext=fontfile=$FONT:textfile=pitch-lines-v4.txt:fontsize=58:fontcolor=white:borderw=4:bordercolor=black:box=1:boxcolor=black@0.45:boxborderw=24:line_spacing=16:x=(w-text_w)/2:y=h*0.38:enable='between(t,10.25,13.25)'[vout];\
[0:a]atrim=start=14.5:end=16.0,asetpts=PTS-STARTPTS[a1];\
[0:a]atrim=start=38.5:end=40.5,asetpts=PTS-STARTPTS[a2];\
[0:a]atrim=start=150.75:end=152.5,asetpts=PTS-STARTPTS[a3];\
[0:a]atrim=start=95.5:end=97.5,asetpts=PTS-STARTPTS[a4];\
[0:a]atrim=start=88.25:end=89.25,asetpts=PTS-STARTPTS[a5];\
[0:a]atrim=start=162.0:end=164.0,asetpts=PTS-STARTPTS[a6];\
[0:a]atrim=start=90.25:end=92.0,asetpts=PTS-STARTPTS,volume=0.25[a7];\
[0:a]atrim=start=92.25:end=93.5,asetpts=PTS-STARTPTS,volume=0.25[a8];\
[a1][a2][a3][a4][a5][a6][a7][a8]concat=n=8:v=0:a=1[acat];\
[1:a]atempo=1.45,volume=1.5,adelay=10250:all=1[voice];\
[acat][voice]amix=inputs=2:duration=first:dropout_transition=0[aout]" \
-map "[vout]" -map "[aout]" -c:v libx264 -preset medium -crf 20 -pix_fmt yuv420p \
-movflags +faststart -c:a aac -b:a 192k -r 30 -t 13.25 gta6-clip-v4.mp4

ffprobe -v error -show_entries format=duration,size -show_entries stream=codec_name,width,height,r_frame_rate -of default=noprint_wrappers=1 gta6-clip-v4.mp4
echo "BUILD OK"
