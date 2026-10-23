#!/bin/bash

# ═══════════════════════════════════════════════════
#  Direct Link Video to Restream 24/7 (Loop)
# ═══════════════════════════════════════════════════

DIRECT_URL="https://rr2---sn-4g5lznlr.googlevideo.com/videoplayback?expire=1792816277&ei=NeDbaszQBuzGsfIP0JTJ2Ao&ip=89.249.193.85&id=o-AHnxIfQKcERzNaVO7GvgJxcOUcYzgQODnUg3Iv1sFJa3&itag=18&source=youtube&requiressl=yes&xpc=EgVo2aDSNQ%3D%3D&rms=au%2Cau&bui=AWzQHwrHLpAzldfXzSOly-lBl5OpGJWy30KzPSasYYuJbnLj0fjARmf4iLnit8Om1khROopqP2roGpfR&spc=mpRQ_z4qnZtltfyK3OutcmVORFVkbkW3DXZRfPxclW9Z7jMoDHJblMfA4658jyxlFMo&vprv=1&svpuc=1&mime=video%2Fmp4&rqh=1&cnr=14&ratebypass=yes&dur=8325.120&lmt=1785460026765468&epbp=1&fexp=51565116&c=ANDROID&txp=4538534&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cxpc%2Cbui%2Cspc%2Cvprv%2Csvpuc%2Cmime%2Crqh%2Ccnr%2Cratebypass%2Cdur%2Clmt&sig=AE0s2JYwRAIgErQak9xGZujFkIjD0AIiA_pEmS6_s7RdPbOU9uOPT68CIE-k7BuaVFYWK-3PNuNoJ1SZiUynTxBzJti8Y2tEmzBi&rm=sn-nx5zr7z&rrc=104,191&req_id=f9f9f0cccbeca3ee&cps=0&ipbypass=yes&redirect_counter=2&cm2rm=sn-p5qeey7s&cms_redirect=yes&cmsv=e&met=1792794686,&mh=1j&mip=37.238.36.147&mm=34&mn=sn-4g5lznlr&ms=ltu&mt=1792794295&mv=m&mvi=2&pl=24&lsparams=cps,ipbypass,met,mh,mip,mm,mn,ms,mv,mvi,pl,rms&lsig=APaTxxMwRgIhAKFQjd-b_Uf4AN3fkd2Kg9e0zbFASHDc-iu0d9QfVXNuAiEA9p4XXgcmHVAcH3XtPXmdeexKlc3wU3TpyXlCH7jN8SI%3D"

VIDEO_FILE="/tmp/video_loop.mp4"

# 1. تحميل الفيديو (إذا لم يكن موجوداً)
if [ ! -f "$VIDEO_FILE" ]; then
    echo "⬇️  جاري تحميل الفيديو من الرابط المباشر..."
    
    # استخدام curl لتحميل الفيديو
    curl -L -o "$VIDEO_FILE" "$DIRECT_URL"
    
    # التحقق من نجاح التحميل (حجم الملف أكبر من 1 ميجابايت)
    FILE_SIZE=$(stat -c%s "$VIDEO_FILE" 2>/dev/null || echo 0)
    if [ "$FILE_SIZE" -lt 1048576 ]; then
        echo "❌ فشل تحميل الفيديو. قد يكون الرابط منتهي الصلاحية أو محظوراً."
        echo "⏳ سيعيد السكربت المحاولة بعد 60 ثانية..."
        sleep 60
        # إعادة المحاولة بشكل لا نهائي حتى ينجح التحميل
        while [ ! -s "$VIDEO_FILE" ] || [ "$(stat -c%s "$VIDEO_FILE" 2>/dev/null || echo 0)" -lt 1048576 ]; do
            curl -L -o "$VIDEO_FILE" "$DIRECT_URL"
            [ -s "$VIDEO_FILE" ] && [ "$(stat -c%s "$VIDEO_FILE")" -gt 1048576 ] && break
            sleep 60
        done
    fi
    echo "✅ تم تحميل الفيديو بنجاح (الحجم: $(du -h "$VIDEO_FILE" | cut -f1))."
fi

# 2. حلقة البث اللانهائية (24/7)
echo "🚀 بدء البث المتكرر إلى Restream..."
while true; do
    # استخدام -stream_loop -1 للتكرار اللامتناهي
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
