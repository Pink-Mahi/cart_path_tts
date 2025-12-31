FROM node:20-slim

# Install Piper TTS dependencies
RUN apt-get update && apt-get install -y \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Piper TTS
WORKDIR /tmp
RUN wget https://github.com/rhasspy/piper/releases/download/v1.2.0/piper_amd64.tar.gz && \
    tar -xzf piper_amd64.tar.gz && \
    cp -r piper/* /usr/local/bin/ && \
    chmod +x /usr/local/bin/piper && \
    rm -rf piper piper_amd64.tar.gz

# Download voice models
# English voices
# AI Bot voice: en_US-lessac-medium (natural female voice)
# Admin voice: en_US-danny-low (deep male voice)
# Spanish voices
# AI Bot voice: es_ES-mls_10246-low (female voice)
# Admin voice: es_ES-mls_9972-low (male voice)
RUN mkdir -p /models && \
    cd /models && \
    wget https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US/lessac/medium/en_US-lessac-medium.onnx && \
    wget https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US/lessac/medium/en_US-lessac-medium.onnx.json && \
    wget https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US/danny/low/en_US-danny-low.onnx && \
    wget https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US/danny/low/en_US-danny-low.onnx.json && \
    wget https://github.com/rhasspy/piper/releases/download/v1.2.0/es_ES-mls_10246-low.onnx && \
    wget https://github.com/rhasspy/piper/releases/download/v1.2.0/es_ES-mls_10246-low.onnx.json && \
    wget https://github.com/rhasspy/piper/releases/download/v1.2.0/es_ES-mls_9972-low.onnx && \
    wget https://github.com/rhasspy/piper/releases/download/v1.2.0/es_ES-mls_9972-low.onnx.json

# Set up application
WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .

# Create audio directory
RUN mkdir -p /app/audio

# Set environment variables
ENV PORT=3002
ENV PIPER_MODEL_PATH=/models/en_US-lessac-medium.onnx

EXPOSE 3002

CMD ["node", "src/server.js"]
