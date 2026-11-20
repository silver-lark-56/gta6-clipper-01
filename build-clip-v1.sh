#!/bin/bash
# Build klip v1 gta6-clipper-01 — 15.5 detik, 1080x1920, dari Trailer 2 GTA VI.
# Segmen (waktu absolut di gta6-trailer2.mp4, 30fps):
#   S1 117.9-120.4  ledakan fireball + jalanan + tabrakan (hook)
#   S2 140.4-141.83 jetski jump close-up Jason & Lucia (v1.1: potong wide approach)
#   S3 141.83-144.33 motor + pesawat amfibi (+ depan truk malam)
#   S4 144.33-145.5  truk malam + percikan api (v1.2: potong 145.5-147.3
#     — ternyata adegan kamar tidur romantis, bukan aksi; merusak energi)
#   S5 147.3-149.3  perahu vs heli polisi + wheelie senja
#   S6 153.5-157.0  skyline Vice City senja (latar pitch)
# Total aksi 9.6 dtk + pitch 3.5 dtk = 13.1 dtk (mendekati formula #1: 13 dtk).
# v1.1 (verifikasi visual 18:2x WIB): S2 dipotong ke jump close-up,
# pitch fontsize 72->58 + box gelap (teks terpotong di v1.0), voice +50%.
set -euo pipefail
cd "$(dirname "$0")"
F=../footage/gta6-trailer2.mp4
FONT=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf

# Teks pitch (3 baris) + hook baris 2 (2 baris) sebagai textfile
printf 'MADE WITH AI\nEARN MONEY MAKING\nCLIPS ON MAKE.FUN' > pitch-lines.txt
printf "AND IT'S NOT\nEVEN OUT YET" > hook2-lines.txt

ffmpeg -hide_banner -loglevel error -y -i "$F" -i pitch-voice.mp3 -filter_complex "\
[0:v]trim=start=117.9:end=120.4,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v1];\
[0:v]trim=start=140.4:end=141.83,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v2];\
[0:v]trim=start=141.83:end=144.33,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v3];\
[0:v]trim=start=144.33:end=145.5,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v4];\
[0:v]trim=start=147.3:end=149.3,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v5];\
[0:v]trim=start=153.5:end=157.0,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v6];\
[v1][v2][v3][v4][v5][v6]concat=n=6:v=1:a=0,format=yuv420p[vcat];\
[vcat]drawtext=fontfile=$FONT:text='THIS IS GTA 6':fontsize=110:fontcolor=white:borderw=4:bordercolor=black:x=(w-text_w)/2:y=h*0.30:enable='between(t,0,2.5)'[t1];\
[t1]drawtext=fontfile=$FONT:textfile=hook2-lines.txt:fontsize=84:fontcolor=white:borderw=4:bordercolor=black:line_spacing=14:x=(w-text_w)/2:y=h*0.30:enable='between(t,2.5,3.93)'[t2];\
[t2]drawtext=fontfile=$FONT:text='MAY 26, 2026':fontsize=64:fontcolor=white:borderw=3:bordercolor=black:x=(w-text_w)/2:y=h*0.82:enable='between(t,3.93,6.43)'[t3];\
[t3]drawtext=fontfile=$FONT:textfile=pitch-lines.txt:fontsize=58:fontcolor=white:borderw=4:bordercolor=black:box=1:boxcolor=black@0.45:boxborderw=24:line_spacing=16:x=(w-text_w)/2:y=h*0.38:enable='between(t,9.6,13.1)'[vout];\
[0:a]atrim=start=117.9:end=120.4,asetpts=PTS-STARTPTS[a1];\
[0:a]atrim=start=140.4:end=141.83,asetpts=PTS-STARTPTS[a2];\
[0:a]atrim=start=141.83:end=144.33,asetpts=PTS-STARTPTS[a3];\
[0:a]atrim=start=144.33:end=145.5,asetpts=PTS-STARTPTS[a4];\
[0:a]atrim=start=147.3:end=149.3,asetpts=PTS-STARTPTS[a5];\
[0:a]atrim=start=153.5:end=157.0,asetpts=PTS-STARTPTS,volume=0.25[a6];\
[a1][a2][a3][a4][a5][a6]concat=n=6:v=0:a=1[acat];\
[1:a]atempo=1.3,volume=1.5,adelay=9750:all=1[voice];\
[acat][voice]amix=inputs=2:duration=first:dropout_transition=0[aout]" \
-map "[vout]" -map "[aout]" -c:v libx264 -preset medium -crf 20 -pix_fmt yuv420p \
-movflags +faststart -c:a aac -b:a 192k -r 30 -t 13.1 gta6-clip-v1.mp4

ffprobe -v error -show_entries format=duration,size -show_entries stream=codec_name,width,height,r_frame_rate -of default=noprint_wrappers=1 gta6-clip-v1.mp4
echo "BUILD OK"
