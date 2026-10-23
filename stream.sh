#!/bin/bash

# ═══════════════════════════════════════════════════
#  Google Drive Video to Restream 24/7
# ═══════════════════════════════════════════════════

# 🔴 رابط جوجل درايف الخاص بك (تم وضعه هنا)
VIDEO_URL="https://drive.google.com/file/d/1AdYW7St0tRS34gCf5F8Ym57suCXiW5Qs/view?usp=drivesdk"
VIDEO_FILE="video1.mp4"

# 1. تنزيل الفيديو من Google Drive
if [ ! -f "$VIDEO_FILE" ]; then
    echo "⬇️  جاري تنزيل الفيديو من Google Drive..."
    
    # تثبيت gdown (أداة تنزيل من جوجل درايف)
    pip3 install --user --break-system-packages --quiet gdown
    
    # استخدام gdown لتنزيل الرابط
    python3 -m gdown "$VIDEO_URL" -O "$VIDEO_FILE"
    
    # التحقق من نجاح التنزيل
    if [ ! -s "$VIDEO_FILE" ]; then
        echo "❌ فشل تنزيل الفيديو. تأكد من أن صلاحية الملف في Google Drive هي 'Anyone with the link'."
        exit 1
    fi
    echo "✅ تم تنزيل الفيديو بنجاح (الحجم: $(du -h "$VIDEO_FILE" | cut -f1))."
fi

# 2. حلقة البث اللانهائية
echo "🚀 بدء البث المتكرر إلى Restream..."
while true; do
    ffmpeg -hide_banner -loglevel warning -nostdin \
        -stream_loop -1 \
        -re \
        -i "$VIDEO_FILE" \
        -c:v libx264 -preset ultrafast -tune zerolatency \
        -pix_fmt yuv420p -g 120 \
        -b:v 6000k -maxrate 6500k -bufsize 12000k \
        -c:a aac -b:a 160k -ar 44100 -ac 2 \
        -max_muxing_queue_size 4096 \
        -flvflags no_duration_filesize \
        -f flv "rtmp://live.restream.io/live/$RESTREAM_KEY"

    echo "⚠️ انقطع الاتصال. إعادة المحاولة خلال 5 ثوانٍ..."
    sleep 5
done
