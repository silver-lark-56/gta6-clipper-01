#!/bin/bash
# Build klip v3 gta6-clipper-01 — 13.35 detik, 1080x1920, dari Trailer 2 GTA VI.
# Konsep: kehidupan tenang Jason (kerja -> perjalanan -> penjara -> pulang).
# NOL tumpang tindih dengan segmen v1 maupun v2. Semua momen terverifikasi
# di frame (CONCEPT-v3.md + footage/v3scan/).
# Segmen (waktu absolut di gta6-trailer2.mp4, 30fps):
#   S1 18.8-19.9   Jason di tangga, senyum, kacamata hijau (hook wajah)
#   S2 11.5-13.5   Jason memperbaiki atap (bukti teks hook)
#   S3 34.5-36.5   POV mengemudi ke skyline Vice City
#   S4 51.0-51.75  menara penjara (tanda baca visual)
#   S5 53.0-55.5   meja check-in penjara (Jason + petugas di balik sekat)
#   S6 134.5-136.5 Lucia & Jason di ruang TV (beat domestik, payoff)
#   S7 6.25-8.0    kota pesisir dari udara (latar pitch, audio duck 0.25)
#   S8 8.25-9.5    rumah panggung (latar pitch, audio duck 0.25)
# Total: 1.1 + 2.0 + 2.0 + 0.75 + 2.5 + 2.0 + 1.75 + 1.25 = 13.35 dtk.
# Teks: "HE FIXES ROOFS." (hook, bawah y=0.78 — wajah di atas) +
# "THEN HE DRIVES / TO PRISON." (S3) + "TO PICK UP LUCIA." (S5) +
# "MAY 26, 2026" (S6, bawah) + pitch 3 baris (S7+S8, box gelap).
# Voice: pitch-voice-v3.mp3 (gTTS, dibuat baru di sesi v3), atempo 1.45
# (~2.9 dtk, pas di jendela pitch 3.0 dtk).
set -euo pipefail
cd "$(dirname "$0")"
F=../footage/gta6-trailer2.mp4
FONT=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf

# Teks pitch (3 baris) + teks mengemudi (2 baris) sebagai textfile
printf 'MADE WITH AI\nEARN MONEY MAKING\nCLIPS ON MAKE.FUN' > pitch-lines-v3.txt
printf 'THEN HE DRIVES\nTO PRISON.' > drive-lines-v3.txt

ffmpeg -hide_banner -loglevel error -y -i "$F" -i pitch-voice-v3.mp3 -filter_complex "\
[0:v]trim=start=18.8:end=19.9,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v1];\
[0:v]trim=start=11.5:end=13.5,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v2];\
[0:v]trim=start=34.5:end=36.5,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v3];\
[0:v]trim=start=51.0:end=51.75,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v4];\
[0:v]trim=start=53.0:end=55.5,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v5];\
[0:v]trim=start=134.5:end=136.5,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v6];\
[0:v]trim=start=6.25:end=8.0,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v7];\
[0:v]trim=start=8.25:end=9.5,setpts=PTS-STARTPTS,crop=ih*9/16:ih,scale=1080:1920,fps=30,setsar=1[v8];\
[v1][v2][v3][v4][v5][v6][v7][v8]concat=n=8:v=1:a=0,format=yuv420p[vcat];\
[vcat]drawtext=fontfile=$FONT:text='HE FIXES ROOFS.':fontsize=100:fontcolor=white:borderw=4:bordercolor=black:x=(w-text_w)/2:y=h*0.78:enable='between(t,0,1.1)'[t1];\
[t1]drawtext=fontfile=$FONT:textfile=drive-lines-v3.txt:fontsize=72:fontcolor=white:borderw=4:bordercolor=black:line_spacing=12:x=(w-text_w)/2:y=h*0.16:enable='between(t,3.1,5.1)'[t2];\
[t2]drawtext=fontfile=$FONT:text='TO PICK UP LUCIA.':fontsize=84:fontcolor=white:borderw=4:bordercolor=black:x=(w-text_w)/2:y=h*0.16:enable='between(t,5.85,8.35)'[t3];\
[t3]drawtext=fontfile=$FONT:text='MAY 26, 2026':fontsize=64:fontcolor=white:borderw=3:bordercolor=black:x=(w-text_w)/2:y=h*0.82:enable='between(t,8.35,10.35)'[t4];\
[t4]drawtext=fontfile=$FONT:textfile=pitch-lines-v3.txt:fontsize=58:fontcolor=white:borderw=4:bordercolor=black:box=1:boxcolor=black@0.45:boxborderw=24:line_spacing=16:x=(w-text_w)/2:y=h*0.38:enable='between(t,10.35,13.35)'[vout];\
[0:a]atrim=start=18.8:end=19.9,asetpts=PTS-STARTPTS[a1];\
[0:a]atrim=start=11.5:end=13.5,asetpts=PTS-STARTPTS[a2];\
[0:a]atrim=start=34.5:end=36.5,asetpts=PTS-STARTPTS[a3];\
[0:a]atrim=start=51.0:end=51.75,asetpts=PTS-STARTPTS[a4];\
[0:a]atrim=start=53.0:end=55.5,asetpts=PTS-STARTPTS[a5];\
[0:a]atrim=start=134.5:end=136.5,asetpts=PTS-STARTPTS[a6];\
[0:a]atrim=start=6.25:end=8.0,asetpts=PTS-STARTPTS,volume=0.25[a7];\
[0:a]atrim=start=8.25:end=9.5,asetpts=PTS-STARTPTS,volume=0.25[a8];\
[a1][a2][a3][a4][a5][a6][a7][a8]concat=n=8:v=0:a=1[acat];\
[1:a]atempo=1.45,volume=1.5,adelay=10350:all=1[voice];\
[acat][voice]amix=inputs=2:duration=first:dropout_transition=0[aout]" \
-map "[vout]" -map "[aout]" -c:v libx264 -preset medium -crf 20 -pix_fmt yuv420p \
-movflags +faststart -c:a aac -b:a 192k -r 30 -t 13.35 gta6-clip-v3.mp4

ffprobe -v error -show_entries format=duration,size -show_entries stream=codec_name,width,height,r_frame_rate -of default=noprint_wrappers=1 gta6-clip-v3.mp4
echo "BUILD OK"
