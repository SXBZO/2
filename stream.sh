#!/bin/bash

# ═══════════════════════════════════════════════════
#  YouTube Video to Restream 24/7 (Loop)
# ═══════════════════════════════════════════════════

YOUTUBE_URL="https://youtu.be/P0uaLRO6V1U"
VIDEO_FILE="/tmp/looped_video.mp4"
COOKIE_FILE="/tmp/cookies.txt"

# 1. إنشاء ملف الكوكيز
if [ -n "$RAW_COOKIES" ]; then
    echo "🍪 تجهيز ملف الكوكيز..."
    python3 -c "
import os
raw = os.environ.get('RAW_COOKIES', '')
with open('/tmp/cookies.txt', 'w') as f:
    f.write('# Netscape HTTP Cookie File\n')
    for pair in raw.split(';'):
        pair = pair.strip()
        if not pair or '=' not in pair: continue
        name, value = pair.split('=', 1)
        f.write(f'.youtube.com\tTRUE\t/\tTRUE\t0\t{name}\t{value}\n')
"
fi

# 2. تحميل الفيديو (إذا لم يكن موجوداً)
if [ ! -f "$VIDEO_FILE" ]; then
    echo "⬇️  جاري تحميل الفيديو لأول مرة..."
    # استخدام yt-dlp مع الكوكيز وأفضل جودة MP4
    yt-dlp --cookies "$COOKIE_FILE" \
           -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" \
           --merge-output-format mp4 \
           -o "$VIDEO_FILE" \
           "$YOUTUBE_URL"
    
    if [ ! -f "$VIDEO_FILE" ]; then
        echo "❌ فشل تحميل الفيديو. تأكد من صحة الكوكيز أو الرابط."
        exit 1
    fi
    echo "✅ تم تحميل الفيديو بنجاح."
fi

# 3. حلقة البث اللانهائية
while true; do
    echo "🔁 [$(date -u +%H:%M:%S)] بدء بث الفيديو..."
    
    # استخدام ffmpeg لقراءة الملف وبثه بشكل متكرر (-stream_loop -1)
    ffmpeg -hide_banner -loglevel warning -nostdin \
        -stream_loop -1 \
        -re \
        -i "$VIDEO_FILE" \
        -c:v libx264 -preset ultrafast -tune zerolatency \
        -pix_fmt yuv420p -g 120 -r 60 \
        -b:v 6500k -maxrate 7000k -bufsize 14000k \
        -c:a aac -b:a 160k -ar 44100 -ac 2 \
        -max_muxing_queue_size 4096 \
        -flvflags no_duration_filesize \
        -f flv "rtmp://live.restream.io/live/$RESTREAM_KEY"

    echo "⚠️ انقطع البث. إعادة المحاولة خلال 5 ثوانٍ..."
    sleep 5
done 
