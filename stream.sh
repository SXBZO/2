name: YouTube Video to Restream 24/7 Loop

on:
  workflow_dispatch:
  schedule:
    - cron: '0 */6 * * *'

permissions:
  actions: write
  contents: read

jobs:
  relay:
    runs-on: ubuntu-latest
    timeout-minutes: 355

    env:
      RESTREAM_KEY: "re_12552561_event81737fba9ada4713ab13ad7e04a36880"
      RAW_COOKIES: "__Secure-YNID=CtoBCAUSjAEB8QZuZjWcTXG9JU0sYr8QklViTrtUnYqFMLV9yU629lRWJDINQyeozV6-VyvAarKMG0ED8Wt0SDrH8If6uqeRWHS00Fi9VtKnh9E7aHUUSCeYHN3J2fJ1Qn7R-EdOMLb1gSPhQGid3sKH4CG84qyVXYdi6VqNxYcnNlKsbsw7FffqqIaZK4gudMLvvSgFMkUB3qmdT8tAKNapXLK-V47vnqSb2QTP0M5m9yE9iYxvPPqAocRA-G4D_vQtYaBJ496Hv7zVWGpVbvTSknV2qZOL_SU9Tgo; GPS=1; YSC=lmfdjAh_2bQ; VISITOR_INFO1_LIVE=KOhY259gc18; VISITOR_PRIVACY_METADATA=CgJJURIEGgAgPA%3D%3D; PREF=f6=40000000&tz=Asia.Baghdad; __Secure-1PSIDTS=sidts-CjUBkldj_x9GX33Z7u8RT2KjbHkPh50m3ggyGssI1mk6HLKntqTgW-YbuOoiUBd9kiGX4LxaOxAA; __Secure-3PSIDTS=sidts-CjUBkldj_x9GX33Z7u8RT2KjbHkPh50m3ggyGssI1mk6HLKntqTgW-YbuOoiUBd9kiGX4LxaOxAA; HSID=AdV8f3a6EAup9EfGp; SSID=AV2omS8jEiLInIRc_; APISID=cu6IlZQ6VxPidlQN/AGMaGwzVRrnype0Pd; SAPISID=OGKvzqgF20NZZRZj/AR739Ij0F45yUqvFP; __Secure-1PAPISID=OGKvzqgF20NZZRZj/AR739Ij0F45yUqvFP; __Secure-3PAPISID=OGKvzqgF20NZZRZj/AR739Ij0F45yUqvFP; SID=g.a000EAntDetJD0McOuQCxohUWZpSKlR9RldynZMTCNL3kLH7LOxCiQcWx_zsZVtwHcmo5xBgNwACgYKAVESARUSFQHGX2MiifxOqWPtF-mPZgDIM4MEwBoVAUF8yKoNETlOy1gA616K4N1mZhqQ0076; __Secure-1PSID=g.a000EAntDetJD0McOuQCxohUWZpSKlR9RldynZMTCNL3kLH7LOxCKfiU3n0XfnJzQZARNb3sNQACgYKAS8SARUSFQHGX2Mi8aPqZ4tRvp7TyrqhtujUEhoVAUF8yKpCLcdEP5OU4D5kyZBE5efV0076; __Secure-3PSID=g.a000EAntDetJD0McOuQCxohUWZpSKlR9RldynZMTCNL3kLH7LOxCr8xKlEzgYKM3bZ_IMUM5MgACgYKAWwSARUSFQHGX2Mibt76Vo6ejXS-X-ljZh0OaBoVAUF8yKqai9C_czYDfocsLjEHvB-20076; LOGIN_INFO=AFmmF2swRAIgFeuN9qwW5ooyO-6322_dqnpQ8P6c9V707sEJNYL9CsQCIEno-xX1YTrmsCcf4wbADq-GfpCoVTdQ1T6w_CfMbKrW:QUQ3MjNmeXNrMThZREgwVC1Pb0VpM1BDdHI3LVNhQ0FmalNfajR2b19kSEg1MEo2aHJvVnN6WUVxZFlFeGVRdlN0NjVxLVZCQjdfZ0xFalh2eDN6bjl6N013Q21mOTNBS3pUUXJrcXJOWkVJT0F5a0x5cWwxZGFqUnpMNnlsZWx3Z0F5S1VkSkxMSDhnRFc1Y1M1M09HOGxOTWs5MmkxelNn; __Secure-ROLLOUT_TOKEN=CNTZ-7rI-IXK4gEQ7pKMnI_RlwMY5Y74rI_RlwM%3D; SIDCC=APD_SKH4LSAsKHHY_fRpcNPbD_InnWDxUQux9Xj5LGBLbp6LK3bHH-Qqb9LYjCXpfq0No8SW; __Secure-1PSIDCC=APD_SKH5UQjWA57-0hkrqayKCA3LA3VYRXk86CUustYueN0FPQO3903DeJ_OvzBThYhWIcLh9Q; __Secure-3PSIDCC=APD_SKGmDbup0y3RSrK_mJXcStmYTuWqU5HNLhlsvydZSjFy9drmlnaDKfQTc7tpPcBGee-Yzw"

    steps:
      - name: جلب الملفات
        uses: actions/checkout@v3

      - name: تثبيت الأدوات (ffmpeg, yt-dlp)
        run: |
          set -e
          echo "═══ التثبيت ═══"
          sudo apt-get update -qq
          sudo apt-get install -y --no-install-recommends ffmpeg
          
          sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
          sudo chmod a+rx /usr/local/bin/yt-dlp
          
          echo "✅ ffmpeg: $(ffmpeg -version | head -n 1)"
          echo "✅ yt-dlp: $(yt-dlp --version)"

      - name: تشغيل البث
        run: |
          chmod +x stream.sh
          ./stream.sh
