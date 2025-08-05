# syntax=docker/dockerfile:1

FROM python:3.9-slim

EXPOSE 7865

WORKDIR /app

COPY . .

# نصب وابستگی‌های سیستمی
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ffmpeg aria2 build-essential python3-dev curl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# نصب pip جدید و وابستگی‌های پایتون
RUN python3 -m pip install --upgrade pip==24.0
RUN python3 -m pip install --no-cache-dir -r requirements.txt

# دریافت مدل‌ها
RUN aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained_v2/D40k.pth -d assets/pretrained_v2/ -o D40k.pth
RUN aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained_v2/G40k.pth -d assets/pretrained_v2/ -o G40k.pth
RUN aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained_v2/f0D40k.pth -d assets/pretrained_v2/ -o f0D40k.pth
RUN aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained_v2/f0G40k.pth -d assets/pretrained_v2/ -o f0G40k.pth

RUN aria2c --console-log-level=error -c -x 16 -s 16 -k 1M "https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/uvr5_weights/HP2-人声vocals+非人声instrumentals.pth" -d assets/uvr5_weights/ -o "HP2-人声vocals+非人声instrumentals.pth"
RUN aria2c --console-log-level=error -c -x 16 -s 16 -k 1M "https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/uvr5_weights/HP5-主旋律人声vocals+其他instrumentals.pth" -d assets/uvr5_weights/ -o "HP5-主旋律人声vocals+其他instrumentals.pth"

RUN aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/hubert_base.pt -d assets/hubert -o hubert_base.pt
RUN aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/rmvpe.pt -d assets/rmvpe -o rmvpe.pt

VOLUME [ "/app/weights", "/app/opt" ]

CMD ["python3", "infer-web.py"]
