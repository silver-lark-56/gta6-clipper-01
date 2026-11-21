#!/bin/bash
# Build klip v2 gta6-clipper-01 — 10.85 detik, 1080x1920, dari Trailer 2 GTA VI.
# Konsep: kisah Lucia (penjara -> perampokan -> Vice City). NOL tumpang tindih
# dengan segmen v1 (1:58-2:37). Semua momen terverifikasi di frame (CONCEPT-v2.md).
# Segmen (waktu absolut di gta6-trailer2.mp4, 30fps):
#   S1 75.3-77.1    perampokan lampu merah: Lucia bertopeng tengkorak + senapan (hook)
#   S2 114.7-115.7  tendangan terbang Lucia di kandang
#   S3 63.3-65.9    Lucia keluar penjara, senyum, tangan terbuka
#   S4 125.75-128.2 Ocean Drive siang -> klub neon malam
#   S5 82.0-85.0    dermaga golden hour (latar pitch)
# Total: 1.8 + 1.0 + 2.6 + 2.45 + 3.0 = 10.85 dtk.
# Teks: "MEET LUCIA." (hook) + "SHE JUST GOT OUT OF PRISON." (S3) +
# "MAY 26, 2026" (S4, bawah) + pitch 3 baris (S5, box gelap, pelajaran v1.1).
# Voice: pitch-voice-v2.mp3 (gTTS, dibuat baru di sesi v2), atempo 1.45 (~2.9 dtk).
# v2.1 (verifikasi visual): teks hook + penjara y 0.30->0.16 (teks menutupi
# wajah Lucia di v2.0), voice atempo 1.4->1.45 (ekor voice terpotong di 10.85).
set -euo pipefail
cd "$(dirname "$0")"
F=../footage/gta6-trailer2.mp4
FONT=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf

# Teks pitch (3 baris) + teks penjara (2 baris) sebagai textfile
printf 'MADE WITH AI\nEARN MONEY MAKING\nCLIPS ON MAKE.FUN' > pitch-lines-v2.txt
printf 'SHE JUST GOT OUT\nOF PRISON.' > prison-lines.txt

ffmpeg -hide_banner -loglevel error -y -i "$F" -i pitch-voice-v2.mp3 -filter_complex "\
[0:v]trim=start=75.3:end=77.1,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v1];\
[0:v]trim=start=114.7:end=115.7,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v2];\
[0:v]trim=start=63.3:end=65.9,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v3];\
[0:v]trim=start=125.75:end=128.2,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v4];\
[0:v]trim=start=82.0:end=85.0,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v5];\
[v1][v2][v3][v4][v5]concat=n=5:v=1:a=0,format=yuv420p[vcat];\
[vcat]drawtext=fontfile=$FONT:text='MEET LUCIA.':fontsize=110:fontcolor=white:borderw=4:bordercolor=black:x=(w-text_w)/2:y=h*0.16:enable='between(t,0,1.8)'[t1];\
[t1]drawtext=fontfile=$FONT:textfile=prison-lines.txt:fontsize=84:fontcolor=white:borderw=4:bordercolor=black:line_spacing=14:x=(w-text_w)/2:y=h*0.16:enable='between(t,2.8,5.4)'[t2];\
[t2]drawtext=fontfile=$FONT:text='MAY 26, 2026':fontsize=64:fontcolor=white:borderw=3:bordercolor=black:x=(w-text_w)/2:y=h*0.82:enable='between(t,5.4,7.85)'[t3];\
[t3]drawtext=fontfile=$FONT:textfile=pitch-lines-v2.txt:fontsize=58:fontcolor=white:borderw=4:bordercolor=black:box=1:boxcolor=black@0.45:boxborderw=24:line_spacing=16:x=(w-text_w)/2:y=h*0.38:enable='between(t,7.85,10.85)'[vout];\
[0:a]atrim=start=75.3:end=77.1,asetpts=PTS-STARTPTS[a1];\
[0:a]atrim=start=114.7:end=115.7,asetpts=PTS-STARTPTS[a2];\
[0:a]atrim=start=63.3:end=65.9,asetpts=PTS-STARTPTS[a3];\
[0:a]atrim=start=125.75:end=128.2,asetpts=PTS-STARTPTS[a4];\
[0:a]atrim=start=82.0:end=85.0,asetpts=PTS-STARTPTS,volume=0.25[a5];\
[a1][a2][a3][a4][a5]concat=n=5:v=0:a=1[acat];\
[1:a]atempo=1.45,volume=1.5,adelay=7850:all=1[voice];\
[acat][voice]amix=inputs=2:duration=first:dropout_transition=0[aout]" \
-map "[vout]" -map "[aout]" -c:v libx264 -preset medium -crf 20 -pix_fmt yuv420p \
-movflags +faststart -c:a aac -b:a 192k -r 30 -t 10.85 gta6-clip-v2.mp4

ffprobe -v error -show_entries format=duration,size -show_entries stream=codec_name,width,height,r_frame_rate -of default=noprint_wrappers=1 gta6-clip-v2.mp4
echo "BUILD OK"
