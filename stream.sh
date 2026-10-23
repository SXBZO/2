#!/bin/bash

# ═══════════════════════════════════════════════════
#  YouTube Video to Restream 24/7 (Loop with Cookies)
# ═══════════════════════════════════════════════════

YOUTUBE_URL="https://youtu.be/P0uaLRO6V1U"
VIDEO_FILE="/tmp/looped_video.mp4"
COOKIE_FILE="/tmp/cookies.txt"

# 1. كتابة ملف الكوكيز بالصيغة التي أرسلتها (Netscape)
cat << 'EOF' > "$COOKIE_FILE"
# Netscape HTTP Cookie File
.youtube.com	TRUE	/	TRUE	0	__Secure-YNID	CtoBCAUSjAEB8QZuZjWcTXG9JU0sYr8QklViTrtUnYqFMLV9yU629lRWJDINQyeozV6-VyvAarKMG0ED8Wt0SDrH8If6uqeRWHS00Fi9VtKnh9E7aHUUSCeYHN3J2fJ1Qn7R-EdOMLb1gSPhQGid3sKH4CG84qyVXYdi6VqNxYcnNlKsbsw7FffqqIaZK4gudMLvvSgFMkUB3qmdT8tAKNapXLK-V47vnqSb2QTP0M5m9yE9iYxvPPqAocRA-G4D_vQtYaBJ496Hv7zVWGpVbvTSknV2qZOL_SU9Tgo
.youtube.com	TRUE	/	FALSE	0	GPS	1
.youtube.com	TRUE	/	FALSE	0	YSC	lmfdjAh_2bQ
.youtube.com	TRUE	/	FALSE	0	VISITOR_INFO1_LIVE	KOhY259gc18
.youtube.com	TRUE	/	FALSE	0	VISITOR_PRIVACY_METADATA	CgJJURIEGgAgPA%3D%3D
.youtube.com	TRUE	/	TRUE	0	__Secure-1PSIDTS	sidts-CjUBkldj_x9GX33Z7u8RT2KjbHkPh50m3ggyGssI1mk6HLKntqTgW-YbuOoiUBd9kiGX4LxaOxAA
.youtube.com	TRUE	/	TRUE	0	__Secure-3PSIDTS	sidts-CjUBkldj_x9GX33Z7u8RT2KjbHkPh50m3ggyGssI1mk6HLKntqTgW-YbuOoiUBd9kiGX4LxaOxAA
.youtube.com	TRUE	/	FALSE	0	HSID	AdV8f3a6EAup9EfGp
.youtube.com	TRUE	/	TRUE	0	SSID	AV2omS8jEiLInIRc_
.youtube.com	TRUE	/	FALSE	0	APISID	cu6IlZQ6VxPidlQN/AGMaGwzVRrnype0Pd
.youtube.com	TRUE	/	TRUE	0	SAPISID	OGKvzqgF20NZZRZj/AR739Ij0F45yUqvFP
.youtube.com	TRUE	/	TRUE	0	__Secure-1PAPISID	OGKvzqgF20NZZRZj/AR739Ij0F45yUqvFP
.youtube.com	TRUE	/	TRUE	0	__Secure-3PAPISID	OGKvzqgF20NZZRZj/AR739Ij0F45yUqvFP
.youtube.com	TRUE	/	FALSE	0	SID	g.a000EAntDetJD0McOuQCxohUWZpSKlR9RldynZMTCNL3kLH7LOxCiQcWx_zsZVtwHcmo5xBgNwACgYKAVESARUSFQHGX2MiifxOqWPtF-mPZgDIM4MEwBoVAUF8yKoNETlOy1gA616K4N1mZhqQ0076
.youtube.com	TRUE	/	TRUE	0	__Secure-1PSID	g.a000EAntDetJD0McOuQCxohUWZpSKlR9RldynZMTCNL3kLH7LOxCKfiU3n0XfnJzQZARNb3sNQACgYKAS8SARUSFQHGX2Mi8aPqZ4tRvp7TyrqhtujUEhoVAUF8yKpCLcdEP5OU4D5kyZBE5efV0076
.youtube.com	TRUE	/	TRUE	0	__Secure-3PSID	g.a000EAntDetJD0McOuQCxohUWZpSKlR9RldynZMTCNL3kLH7LOxCr8xKlEzgYKM3bZ_IMUM5MgACgYKAWwSARUSFQHGX2Mibt76Vo6ejXS-X-ljZh0OaBoVAUF8yKqai9C_czYDfocsLjEHvB-20076
.youtube.com	TRUE	/	TRUE	0	LOGIN_INFO	AFmmF2swRAIgFeuN9qwW5ooyO-6322_dqnpQ8P6c9V707sEJNYL9CsQCIEno-xX1YTrmsCcf4wbADq-GfpCoVTdQ1T6w_CfMbKrW:QUQ3MjNmeXNrMThZREgwVC1Pb0VpM1BDdHI3LVNhQ0FmalNfajR2b19kSEg1MEo2aHJvVnN6WUVxZFlFeGVRdlN0NjVxLVZCQjdfZ0xFalh2eDN6bjl6N013Q21mOTNBS3pUUXJrcXJOWkVJT0F5a0x5cWwxZGFqUnpMNnlsZWx3Z0F5S1VkSkxMSDhnRFc1Y1M1M09HOGxOTWs5MmkxelNn
.youtube.com	TRUE	/	TRUE	0	__Secure-ROLLOUT_TOKEN	CNTZ-7rI-IXK4gEQ7pKMnI_RlwMY5Y74rI_RlwM%3D
.youtube.com	TRUE	/	FALSE	0	PREF	f6=40000000&tz=Asia.Baghdad&f7=100
.youtube.com	TRUE	/	FALSE	0	SIDCC	APD_SKH7g76JIHD1tI9f-JsL2hQFAPs_oCUBcLhjE8SsbaD368gycjZgjiWg4RulGxH39oYC
.youtube.com	TRUE	/	TRUE	0	__Secure-1PSIDCC	APD_SKHhW77B2IVhAkEZ7HDCl60zfpI03WG1SgMl8TDBHyvNXkrPrZ44BPzXczCtdKiX6UN-2A
.youtube.com	TRUE	/	TRUE	0	__Secure-3PSIDCC	APD_SKH-I8gaI1f2dW4jpmKtuvU3_AIcVVbrkbro8knpY4YDGta_ceY4TMUBL2G16-uUdeXY1w
EOF

echo "🍪 تم تجهيز ملف الكوكيز."

# 2. تحميل الفيديو (إذا لم يكن موجوداً)
if [ ! -f "$VIDEO_FILE" ]; then
    echo "⬇️  جاري تحميل الفيديو لأول مرة... (قد يستغرق دقائق)"
    
    # محاولة التحميل باستخدام الكوكيز
    yt-dlp --cookies "$COOKIE_FILE" \
           -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" \
           --merge-output-format mp4 \
           --no-warnings \
           -o "$VIDEO_FILE" \
           "$YOUTUBE_URL"
    
    if [ ! -f "$VIDEO_FILE" ]; then
        echo "❌ فشل تحميل الفيديو. يوتيوب رفض الطلب (حظر IP)."
        echo "⏳ سيعيد السكربت المحاولة بعد 60 ثانية..."
        sleep 60
        # إعادة المحاولة بشكل لا نهائي حتى ينجح التحميل
        while [ ! -f "$VIDEO_FILE" ]; do
            yt-dlp --cookies "$COOKIE_FILE" \
                   -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" \
                   --merge-output-format mp4 \
                   --no-warnings \
                   -o "$VIDEO_FILE" \
                   "$YOUTUBE_URL"
            [ ! -f "$VIDEO_FILE" ] && sleep 60
        done
    fi
    echo "✅ تم تحميل الفيديو بنجاح."
fi

# 3. حلقة البث اللانهائية (24/7)
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
