#!/bin/bash
# Build klip v6 gta6-clipper-01 — 12.5 detik, 1080x1920, dari GAMEPLAY
# ASLI GTA VI (Shirrako Part 1, no commentary). Konsep: "The World
# Underneath" — dunia bawah laut GTA 6 (permukaan -> turun -> gapura
# karang -> bangkai kapal), tesis diucapkan game sendiri ("It's like
# a whole new world down here"). 100% gameplay = NOL tumpang tindih
# dengan segmen v1-v5 (trailer). Semua batas terverifikasi FRAME
# TUNGGAL (sheet kecil terbukti bisa menyesatkan — "hiu" 5774-5776
# ternyata penyelam; dicek ulang resolusi penuh, CONCEPT-v6.md).
# Sumber: footage/gta6-dive-5660-5672.mp4 (permukaan) +
# footage/gta6-dive-5670-5805.mp4 (bawah laut), keduanya 1080p 30fps
# hasil yt-dlp --download-sections dari 42f6LTXqss0.
# Segmen (waktu LOKAL di file seksi; absolut = lokal + 5660 / + 5670):
#   S1  file0 5.0-6.5    (abs 5665-5666.5)   penyelam di dek perahu (hook)
#   S2  file1 3.0-4.5    (abs 5673-5674.5)   turun ke air, ikan, terumbu
#   S3a file1 83.0-85.0  (abs 5753-5755)     gapura karang, tesis diucapkan
#   S3b file1 85.0-87.0  (abs 5755-5757)     lanjutan gapura (potongan tak
#                                            terlihat di 5755, ritme H6;
#                                            akhir 5757 menghindari
#                                            "This is so fuckin' dope!" 5758)
#   S4  file1 125.0-127.5 (abs 5795-5797.5)  bangkai kapal, god rays
#   S5  file1 127.5-130.5 (abs 5797.5-5800.5) lanjutan bangkai (latar pitch,
#                                            audio duck 0.25)
# Total: 1.5 + 1.5 + 2.0 + 2.0 + 2.5 + 3.0 = 12.5 dtk.
# Crop: TENGAH 9:16 (menghapus watermark SHIRRAKO kanan-bawah +
# minimap kiri-bawah; dibuktikan crop-1280.jpg + crop test v6scan).
# Teks (semua y=0.16, DejaVu Bold 72, kecuali pitch 58 + box):
#   "EVERYONE'S LOOKING / AT VICE CITY." / "NO ONE'S LOOKING /
#   DOWN HERE." / "A WHOLE NEW WORLD." / "AND A SHIPWRECK." /
#   pitch 3 baris.
# Voice: pitch-voice-v6.mp3 (gTTS RAW, dibuat baru di sesi v6, raw
# 4.20 dtk), atempo 1.45 (~2.90 dtk, pas di jendela pitch 3.0 dtk).
set -euo pipefail
cd "$(dirname "$0")"
F0=../footage/gta6-dive-5660-5672.mp4
F1=../footage/gta6-dive-5670-5805.mp4
FONT=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf

# Teks per beat (textfile = tanpa masalah escaping apostrof)
printf "EVERYONE'S LOOKING\nAT VICE CITY." > s1-lines-v6.txt
printf "NO ONE'S LOOKING\nDOWN HERE." > s2-lines-v6.txt
printf 'A WHOLE NEW WORLD.' > s3-lines-v6.txt
printf 'AND A SHIPWRECK.' > s4-lines-v6.txt
printf 'MADE WITH AI\nEARN MONEY MAKING\nCLIPS ON MAKE.FUN' > pitch-lines-v6.txt

ffmpeg -hide_banner -loglevel error -y -i "$F0" -i "$F1" -i pitch-voice-v6.mp3 -filter_complex "\
[0:v]trim=start=5.0:end=6.5,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v1];\
[1:v]trim=start=3.0:end=4.5,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v2];\
[1:v]trim=start=83.0:end=85.0,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v3a];\
[1:v]trim=start=85.0:end=87.0,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v3b];\
[1:v]trim=start=125.0:end=127.5,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v4];\
[1:v]trim=start=127.5:end=130.5,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v5];\
[v1][v2][v3a][v3b][v4][v5]concat=n=6:v=1:a=0,format=yuv420p[vcat];\
[vcat]drawtext=fontfile=$FONT:textfile=s1-lines-v6.txt:fontsize=72:fontcolor=white:borderw=4:bordercolor=black:line_spacing=12:x=(w-text_w)/2:y=h*0.16:enable='between(t,0,1.5)'[t1];\
[t1]drawtext=fontfile=$FONT:textfile=s2-lines-v6.txt:fontsize=72:fontcolor=white:borderw=4:bordercolor=black:line_spacing=12:x=(w-text_w)/2:y=h*0.16:enable='between(t,1.5,3.0)'[t2];\
[t2]drawtext=fontfile=$FONT:textfile=s3-lines-v6.txt:fontsize=72:fontcolor=white:borderw=4:bordercolor=black:x=(w-text_w)/2:y=h*0.16:enable='between(t,3.0,7.0)'[t3];\
[t3]drawtext=fontfile=$FONT:textfile=s4-lines-v6.txt:fontsize=72:fontcolor=white:borderw=4:bordercolor=black:x=(w-text_w)/2:y=h*0.16:enable='between(t,7.0,9.5)'[t4];\
[t4]drawtext=fontfile=$FONT:textfile=pitch-lines-v6.txt:fontsize=58:fontcolor=white:borderw=4:bordercolor=black:box=1:boxcolor=black@0.45:boxborderw=24:line_spacing=16:x=(w-text_w)/2:y=h*0.38:enable='between(t,9.5,12.5)'[vout];\
[0:a]atrim=start=5.0:end=6.5,asetpts=PTS-STARTPTS[a1];\
[1:a]atrim=start=3.0:end=4.5,asetpts=PTS-STARTPTS[a2];\
[1:a]atrim=start=83.0:end=85.0,asetpts=PTS-STARTPTS[a3a];\
[1:a]atrim=start=85.0:end=87.0,asetpts=PTS-STARTPTS[a3b];\
[1:a]atrim=start=125.0:end=127.5,asetpts=PTS-STARTPTS[a4];\
[1:a]atrim=start=127.5:end=130.5,asetpts=PTS-STARTPTS,volume=0.25[a5];\
[a1][a2][a3a][a3b][a4][a5]concat=n=6:v=0:a=1[acat];\
[2:a]atempo=1.45,volume=1.5,adelay=9500:all=1[voice];\
[acat][voice]amix=inputs=2:duration=first:dropout_transition=0[aout]" \
-map "[vout]" -map "[aout]" -c:v libx264 -preset medium -crf 20 -pix_fmt yuv420p \
-movflags +faststart -c:a aac -b:a 192k -r 30 -t 12.5 gta6-clip-v6.mp4

ffprobe -v error -show_entries format=duration,size -show_entries stream=codec_name,width,height,r_frame_rate -of default=noprint_wrappers=1 gta6-clip-v6.mp4
echo "BUILD OK"
